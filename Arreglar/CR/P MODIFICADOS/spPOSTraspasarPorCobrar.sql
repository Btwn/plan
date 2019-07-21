SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSTraspasarPorCobrar
@Empresa		varchar(5),
@Modulo			varchar(5),
@Sucursal		int,
@Usuario		varchar(10),
@Saldo			float,
@Estacion       int,
@ID				varchar(50)		OUTPUT,
@Mensaje		varchar(255)	OUTPUT,
@Imagen			varchar(255)	OUTPUT,
@Expresion		varchar(255)	OUTPUT,
@IDImprimir		varchar(36)     OUTPUT,
@Ok				int				OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS
BEGIN
DECLARE
@IDM					varchar(50),
@ToleranciaRedondeo		float,
@Mov					varchar(20),
@MovID					varchar(20),
@MovClave				varchar(20),
@Caja					varchar(10),
@ImporteMov				float,
@CobradoMov				float,
@ReporteImpresora		varchar(50),
@Prefijo				varchar(5),
@Consecutivo			int,
@noAprobacion			int,
@fechaAprobacion		datetime,
@Host					varchar(20),
@Cluster				varchar(20),
@RedondeoMonetarios		int,
@Checksum               bigint
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
EXEC spPOSHost @Host OUTPUT, @Cluster OUTPUT
SELECT
@Mov = p.Mov,
@MovID = p.MovID,
@MovClave = mt.Clave,
@Caja = p.CtaDinero
FROM POSL p WITH (NOLOCK)
INNER JOIN Sucursal s WITH (NOLOCK) ON p.Sucursal = s.Sucursal
INNER JOIN MovTipo mt WITH (NOLOCK) ON p.Mov = mt.Mov
AND mt.Modulo = 'POS'
WHERE p.ID = @ID
SELECT @IDImprimir = @ID
SELECT @ImporteMov = SUM(dbo.fnPOSImporteMov(((plv.Cantidad  - ISNULL(plv.CantidadObsequio,0.0)) * ((plv.Precio -
(plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) - ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) * (
CASE WHEN ISNULL(plv.AplicaDescGlobal, 1) = 1
THEN ISNULL(p.DescuentoGlobal,0.0)
ELSE 0
END)/100))),plv.Impuesto1,plv.Impuesto2,plv.Impuesto3,plv.Cantidad))
FROM POSLVenta plv WITH (NOLOCK)
INNER JOIN POSL p WITH (NOLOCK) ON p.ID = plv.ID
WHERE plv.ID = @ID
SELECT @CobradoMov = SUM(ISNULL(Importe,0))
FROM POSLCobro plc WITH (NOLOCK)
WHERE plc.ID = @ID
SELECT @ImporteMov = ROUND(@ImporteMov,@RedondeoMonetarios)
SELECT @CobradoMov = ROUND(@ImporteMov,@RedondeoMonetarios)
IF @MovClave NOT IN ('POS.NPC') OR ISNULL(@ImporteMov,0) <= 0
SELECT @Ok = 30100
IF @Ok IS NULL
BEGIN
IF @MovID IS NULL
BEGIN
EXEC spPOSConsecutivoAuto @Empresa, @Sucursal, @Mov,
@MovID OUTPUT, @Prefijo OUTPUT, @Consecutivo OUTPUT, @noAprobacion OUTPUT, @FechaAprobacion OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
UPDATE POSL WITH (ROWLOCK) SET
MovID = ISNULL(MovID, @MovID),
Prefijo = ISNULL(Prefijo, @Prefijo),
Consecutivo = ISNULL(Consecutivo, @Consecutivo),
noAprobacion = ISNULL(noAprobacion, @noAprobacion),
fechaAprobacion = ISNULL(fechaAprobacion, @fechaAprobacion),
Estatus = 'PORCOBRAR'
WHERE ID = @ID
IF @@ERROR <> 0
SET @Ok = 1
DELETE POSLValidarDevolucion WHERE ID = @ID
END
IF @Ok IS NULL
BEGIN
INSERT POSLPorCobrar(
ID, Empresa, Modulo, Mov, MovID, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda, TipoCambio, Referencia,
Observaciones, Estatus, Cliente, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Delegacion, Colonia, Poblacion,
Estado, Pais, Zona, CodigoPostal, RFC, CURP, EnviarA, Almacen, Agente, FormaEnvio, Condicion, Vencimiento, CajaOrigen, CtaDinero, Descuento,
DescuentoGlobal, Importe, Impuestos, Causa, Atencion, AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, Sucursal, OrigenTipo, Origen, OrigenID,
Tasa, Prefijo, Consecutivo, IDR, Monedero, BeneficiarioNombre, IDCB, Directo)
SELECT
ID, Empresa, Modulo, Mov, MovID, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda, TipoCambio, Referencia,
Observaciones, Estatus, Cliente, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Delegacion, Colonia, Poblacion,
Estado, Pais, Zona, CodigoPostal, RFC, CURP, EnviarA, Almacen, Agente, FormaEnvio, Condicion, Vencimiento, CtaDinero, CtaDinero, Descuento,
DescuentoGlobal, Importe, Impuestos, Causa, Atencion, AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, Sucursal, OrigenTipo, Origen, OrigenID,
Tasa, Prefijo, Consecutivo,  IDR, Monedero, BeneficiarioNombre,dbo.fnPOSCBGenerar(ID), ISNULL(Directo,1)
FROM POSL WITH (NOLOCK)
WHERE ID = @ID
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL
INSERT POSLPorCobrarD(
ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Aplica, AplicaID, Cantidad, Articulo, SubCuenta, Precio, PrecioSugerido,
DescuentoLinea, DescuentoImporte, Impuesto1, Impuesto2, Impuesto3, Unidad, Factor, CantidadInventario, Puntos, Comision, CantidadObsequio,
OfertaID, SerieLote, LDIServicio, Juego, Aplicado, PrecioImpuestoInc, AplicaDescGlobal, Codigo, Almacen)
SELECT
ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Aplica, AplicaID, Cantidad, Articulo, SubCuenta, Precio, PrecioSugerido,
DescuentoLinea, DescuentoImporte, Impuesto1, Impuesto2, Impuesto3, Unidad, Factor, CantidadInventario, Puntos, Comision, CantidadObsequio,
OfertaID, SerieLote, LDIServicio, Juego, Aplicado, PrecioImpuestoInc, AplicaDescGlobal, Codigo, Almacen
FROM POSLVenta WITH (NOLOCK)
WHERE ID = @ID
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL AND EXISTS(SELECT * FROM POSLSerieLote WITH (NOLOCK) WHERE ID = @ID)
INSERT POSLPorCobrarSerieLote(
ID, RenglonID, Articulo, SubCuenta, SerieLote)
SELECT
ID, RenglonID, Articulo, ISNULL(SubCuenta,''), SerieLote
FROM POSLSerieLote WITH (NOLOCK)
WHERE ID = @ID
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL
UPDATE POSLPorCobrarD WITH (ROWLOCK) SET DCheckSum = dbo.fnPOSCheckSumDetalle(@ID, Renglon)
WHERE ID = @ID
IF @@ERROR <> 0
SET @Ok = 1
SELECT @Checksum = ISNULL(SUM(CONVERT(bigint,DCheckSum)),0)
FROM POSLPorCobrarD WITH (NOLOCK)
WHERE ID = @ID
IF @Ok IS NULL
UPDATE POSLPorCobrar WITH (ROWLOCK) SET ECheckSum = dbo.fnPOSCheckSumEncabezado(@ID), DCheckSum = @Checksum
WHERE ID = @ID
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL AND EXISTS(SELECT * FROM POSLPorCobrarSerieLote WITH (NOLOCK) WHERE ID = @ID)
UPDATE POSLPorCobrarSerieLote WITH (ROWLOCK) SET SCheckSum = dbo.fnPOSCheckSumSerie(@ID,IDL)
WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
EXEC spPOSMovNuevo @Empresa, @Modulo, @Sucursal, @Usuario, @Estacion, @ID OUTPUT, @Imagen OUTPUT
DELETE FROM POSLAccion
WHERE Host = @Host AND Caja = @Caja
SELECT @Mensaje = 'EL MOVIMIENTO SE TRASPASO CORRECTAMENTE'
END
END

