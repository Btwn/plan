SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spOportunidadPlanPreliminarAgregar
@ID			int,
@Usuario	varchar(10),
@Sucursal	int,
@Plantilla	varchar(20),
@Empresa    varchar(20),
@Ok			int			 = NULL OUTPUT,
@OkRef		varchar(255) = NULL OUTPUT

AS
BEGIN
DECLARE @Mov					varchar(20),
@FechaEmision			datetime,
@IDProy				int,
@OkDesc				varchar(255),
@OkTipo				varchar(50)
SELECT @FechaEmision = GETDATE()
EXEC spExtraerFecha @FechaEmision OUTPUT
SELECT @Mov = PlanPreliminar FROM EmpresaCfgMov WHERE Empresa=@Empresa
IF @Mov IS NULL OR @Mov = ''
BEGIN
SELECT @OK=10061
END
IF @Mov IS NOT NULL
BEGIN
INSERT Proyecto (Empresa, Mov,  ContactoTipo, Moneda, TipoCambio, Estatus,      FechaEmision,   Usuario, Proyecto, Sucursal, OrigenTipo, Origen, OrigenID)
SELECT Empresa, @Mov, ContactoTipo, Moneda, TipoCambio, 'SINAFECTAR', @FechaEmision,  Usuario, Proyecto, Sucursal, 'OPORT',    Mov,    MovID
FROM Oportunidad
WHERE ID=@ID
SELECT @IDProy = SCOPE_IDENTITY()
INSERT INTO ProyectoInteresadoEn (ID,      Renglon, RenglonSub, RenglonTipo, RenglonID, Articulo, Cantidad, CantidadInventario, SubCuenta, Precio, PrecioSugerido, Sucursal, SucursalOrigen, UEN, DescuentoLinea, DescuentoImporte, FechaRequerida, HoraRequerida, Espacio, Almacen, PoliticaPrecios, PrecioMoneda, PrecioTipoCambio, DescuentoTipo, Unidad, Factor, CompraRequerida)
SELECT                            @IDProy, Renglon, RenglonSub, RenglonTipo, RenglonID, Articulo, Cantidad, CantidadInventario, SubCuenta, Precio, PrecioSugerido, Sucursal, SucursalOrigen, UEN, DescuentoLinea, DescuentoImporte, FechaRequerida, HoraRequerida, Espacio, Almacen, PoliticaPrecios, PrecioMoneda, PrecioTipoCambio, DescuentoTipo, Unidad, Factor, CompraRequerida
FROM OportunidadInteresadoEn
WHERE ID=@ID
EXEC xpOportunidadPlanPreliminarAgregar  @ID, @Usuario, @Sucursal, @Plantilla, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
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
SELECT @Ok, @OkDesc, @OkTipo, @OkRef, @IDProy
RETURN
END

