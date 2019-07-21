SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSMovCopiar
@ID	varchar(50),
@Codigo	varchar(50),
@Modulo	varchar(5),
@Ok	int	OUTPUT,
@OkRef	int	OUTPUT

AS
BEGIN
DECLARE
@IDMov		int,
@Mov			varchar(20),
@MovID		varchar(20),
@Concepto		varchar(50),
@Proyecto		varchar(50),
@UEN			int,
@Moneda		varchar(10),
@TipoCambio		float,
@Referencia		varchar(50),
@Observaciones	varchar(100),
@Cliente		varchar(10),
@CteEnviarA		int,
@Agente		varchar(10),
@Almacen		varchar(10),
@FormaEnvio		varchar(50),
@OrdenCompra		varchar(50),
@Condicion		varchar(50),
@Vencimiento		datetime,
@Descuento		varchar(50),
@DescuentoGlobal	float,
@Causa		varchar(50),
@Atencion		varchar(50),
@AtencionTelefono	varchar(50),
@ListaPreciosEsp	varchar(20),
@ZonaImpuesto		varchar(50),
@Estatus		varchar(15),
@Host			varchar(20),
@Cluster		varchar(20),
@Empresa		varchar(5)
EXEC spPOSHost @Host OUTPUT, @Cluster OUTPUT
IF @Modulo = 'VTAS'
BEGIN
SELECT @IDMov = v.ID
FROM Venta v
WHERE CONVERT(varchar, v.ID) = @Codigo
OR UPPER(LTRIM(RTRIM(v.Mov))+ ' ' + LTRIM(RTRIM(v.MovID))) = @Codigo
SELECT
@Mov = v.Mov,
@MovID = v.MovID,
@Concepto = v.Concepto,
@Proyecto = v.Proyecto,
@UEN = v.UEN,
@Moneda = v.Moneda,
@TipoCambio = v.TipoCambio,
@Referencia = v.Referencia,
@Observaciones = v.Observaciones,
@Cliente = v.Cliente,
@CteEnviarA = v.EnviarA,
@Agente = v.Agente,
@Almacen = v.Almacen,
@FormaEnvio = v.FormaEnvio,
@OrdenCompra = v.OrdenCompra,
@Condicion = v.Condicion,
@Vencimiento = v.Vencimiento,
@Descuento = v.Descuento,
@DescuentoGlobal = v.DescuentoGlobal,
@Causa = v.Causa,
@Atencion = v.Atencion,
@AtencionTelefono = v.AtencionTelefono,
@ListaPreciosEsp = v.ListaPreciosEsp,
@ZonaImpuesto = v.ZonaImpuesto,
@Estatus = @Estatus,
@Empresa = Empresa
FROM Venta v
WHERE v.ID = @IDMov
UPDATE POSL
SET Concepto = @Concepto, Proyecto = @Proyecto, UEN = @UEN, Moneda = @Moneda, TipoCambio = @TipoCambio, Referencia = @Referencia,
Observaciones = @Observaciones, Cliente = @Cliente, EnviarA = @CteEnviarA, Almacen = @Almacen, Agente = @Agente, FormaEnvio = @FormaEnvio,
Condicion = @Condicion,Vencimiento = @Vencimiento, Descuento = @Descuento, DescuentoGlobal = @DescuentoGlobal, Causa = @Causa,
Atencion = @Atencion, AtencionTelefono = @AtencionTelefono, ListaPreciosEsp = @ListaPreciosEsp, ZonaImpuesto = @ZonaImpuesto,
Host = @Host
WHERE ID = @ID
INSERT POSLVenta (
ID,  Renglon,    RenglonID,    RenglonTipo,    Cantidad,    Articulo,    SubCuenta,    Precio,    DescuentoLinea,
Impuesto1,    Impuesto2,    Impuesto3,    Unidad,    Factor,    CantidadInventario, PrecioImpuestoInc, Codigo, Almacen)
SELECT
@ID, vd.Renglon, vd.RenglonID, vd.RenglonTipo, vd.Cantidad, vd.Articulo, vd.SubCuenta, vd.Precio, vd.DescuentoLinea,
vd.Impuesto1, vd.Impuesto2, vd.Impuesto3, vd.Unidad, vd.Factor, vd.CantidadInventario,
dbo.fnPOSPrecioConImpuestos(vd.precio,vd.Impuesto1, vd.Impuesto2, vd.Impuesto3, @Empresa), vd.Codigo, vd.Almacen
FROM VentaD vd
WHERE vd.ID = @IDMov
IF @Estatus = 'PENDIENTE'
BEGIN
UPDATE POSL SET OrigenTipo = @Modulo, Origen = @Mov, OrigenID = @MovID
WHERE ID = @ID
UPDATE POSLVenta SET Aplica = @Mov, AplicaID = @MovID
WHERE ID = @ID
END
END
END

