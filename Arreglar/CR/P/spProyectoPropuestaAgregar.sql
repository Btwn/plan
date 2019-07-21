SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spProyectoPropuestaAgregar
@ID			int,
@Usuario	varchar(10),
@Empresa    varchar(10),
@Sucursal	int,
@Ok			int			 = NULL OUTPUT,
@OkRef		varchar(255) = NULL OUTPUT

AS
BEGIN
DECLARE @Mov					varchar(20),
@FechaEmision			datetime,
@Almacen				varchar(10),
@IDVTAS				int,
@OkDesc				varchar(255),
@OkTipo				varchar(50),
@TipoImpuesto			bit
SELECT @FechaEmision = GETDATE()
EXEC spExtraerFecha @FechaEmision OUTPUT
SELECT @Mov = PropuestaEconomica FROM EmpresaCfgMov WHERE Empresa=@Empresa
IF @Mov IS NULL OR @Mov = ''
BEGIN
SELECT @OK=10061
END
IF @Mov IS NOT NULL
BEGIN
SELECT @Almacen = DefAlmacen FROM Usuario WHERE Usuario = @Usuario
SELECT @TipoImpuesto = ISNULL(TipoImpuesto, 0) FROM EmpresaGral JOIN Oportunidad ON EmpresaGral.Empresa = Oportunidad.Empresa WHERE ID = @ID
IF NULLIF(RTRIM(@Almacen), '') IS NULL
SELECT @Ok = 10576
IF @Ok IS NULL
BEGIN
INSERT INTO Venta(
Empresa,  Mov,  FechaEmision, Proyecto, UEN, Moneda, TipoCambio, Usuario, Referencia, Observaciones, Estatus,      Cliente,  Almacen, Agente, OrigenTipo, Origen, OrigenID,  Sucursal,  SucursalOrigen,  SucursalDestino, IDProyecto)
SELECT Empresa, @Mov, @FechaEmision, Proyecto, UEN, Moneda, TipoCambio, Usuario, Referencia, Observaciones, 'SINAFECTAR', Cliente,  @Almacen, Agente, 'PROY',    Mov,    MovID,     @Sucursal, @Sucursal,       @Sucursal,       ID
FROM Proyecto
WHERE ID = @ID
SELECT @IDVTAS = SCOPE_IDENTITY()
IF @TipoImpuesto = 0
INSERT INTO VentaD(
ID,      Renglon,   RenglonSub,   RenglonID,   RenglonTipo,   Almacen,   Articulo,   Precio,   PrecioSugerido,   Agente,  Sucursal,  SucursalOrigen,   Impuesto1,   Impuesto2,   Impuesto3,   Retencion1,   Retencion2,   Retencion3,   ContUso,   ContUso2,   ContUso3,   Unidad,   Cantidad,   SubCuenta,   UEN,   DescuentoLinea,   DescuentoImporte,   FechaRequerida,   HoraRequerida,   Espacio,   PrecioMoneda,   PrecioTipoCambio,   PoliticaPrecios,   DescuentoTipo,   Factor,   CantidadInventario)
SELECT @IDVTAS, i.Renglon, i.RenglonSub, i.RenglonID, i.RenglonTipo, i.Almacen, i.Articulo, i.Precio, i.PrecioSugerido, c.Agente, @Sucursal, @Sucursal,       a.Impuesto1, a.Impuesto2, a.Impuesto3, a.Retencion1, a.Retencion2, a.Retencion3, a.ContUso, a.ContUso2, a.ContUso3, a.Unidad, i.Cantidad, i.SubCuenta, i.UEN, i.DescuentoLinea, i.DescuentoImporte, i.FechaRequerida, i.HoraRequerida, i.Espacio, i.PrecioMoneda, i.PrecioTipoCambio, i.PoliticaPrecios, i.DescuentoTipo, i.Factor, i.CantidadInventario
FROM ProyectoInteresadoEn i
JOIN Proyecto c ON i.ID = c.ID
JOIN Art a ON i.Articulo = a.Articulo
WHERE i.ID = @ID
ELSE
INSERT INTO VentaD(
ID,       Renglon,   RenglonSub,   RenglonID,   RenglonTipo,   Almacen,   Articulo,   Precio,   PrecioSugerido,   Agente,  Sucursal,  SucursalOrigen,   TipoImpuesto1,   TipoImpuesto2,   TipoImpuesto3,   TipoRetencion1,   TipoRetencion2,   TipoRetencion3,     Impuesto1,                               Impuesto2,                               Impuesto3,                               Retencion1,                               Retencion2,                               Retencion3,                              ContUso,   ContUso2,   ContUso3,   Unidad,   Cantidad,   SubCuenta,    UEN,   DescuentoLinea,   DescuentoImporte,   FechaRequerida,   HoraRequerida,   Espacio,   PrecioMoneda,   PrecioTipoCambio,   PoliticaPrecios,   DescuentoTipo,   Factor,   CantidadInventario)
SELECT @IDVTAS, i.Renglon, i.RenglonSub, i.RenglonID, i.RenglonTipo, i.Almacen, i.Articulo, i.Precio, i.PrecioSugerido, c.Agente, @Sucursal, @Sucursal,       a.TipoImpuesto1, a.TipoImpuesto2, a.TipoImpuesto3, a.TipoRetencion1, a.TipoRetencion2, a.TipoRetencion3, dbo.fnTipoImpuestoTasa(a.TipoImpuesto1), dbo.fnTipoImpuestoTasa(a.TipoImpuesto2), dbo.fnTipoImpuestoTasa(a.TipoImpuesto3), dbo.fnTipoImpuestoTasa(a.TipoRetencion1), dbo.fnTipoImpuestoTasa(a.TipoRetencion2), dbo.fnTipoImpuestoTasa(a.TipoRetencion3),  a.ContUso, a.ContUso2, a.ContUso3, a.Unidad, i.Cantidad, i.SubCuenta, i.UEN, i.DescuentoLinea, i.DescuentoImporte, i.FechaRequerida, i.HoraRequerida, i.Espacio, i.PrecioMoneda, i.PrecioTipoCambio, i.PoliticaPrecios, i.DescuentoTipo, i.Factor, i.CantidadInventario
FROM ProyectoInteresadoEn i
JOIN Proyecto c ON i.ID = c.ID
JOIN Art a ON i.Articulo = a.Articulo
WHERE i.ID = @ID
END
EXEC xpProyectoPropuestaAgregar  @ID, @Usuario, @Sucursal, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
IF @Ok IS NULL
BEGIN
SELECT @OkRef = NULL
END
ELSE
SELECT @OkDesc = Descripcion,
@OkTipo = Tipo
FROM MensajeLista
WHERE Mensaje = @Ok
SELECT @Ok, @OkDesc, @OkTipo, @OkRef, @IDVTAS
RETURN
END

