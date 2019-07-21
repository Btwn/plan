SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSAfectarCFD
@ID                     varchar(50),
@Empresa				varchar(5),
@Sucursal               int,
@Usuario                varchar(10),
@AfectadoEnLinea        bit,
@Mensaje                varchar(255)  OUTPUT,
@Ok                     int  OUTPUT,
@OkRef                  varchar(255)  OUTPUT

AS
BEGIN
DECLARE
@MovCFD								varchar(20),
@ContMoneda							varchar(10),
@ToleranciaRedondeo					float,
@ContMonedaTC						float,
@IDNuevo							int,
@CodigoRedondeo						varchar(30),
@ArticuloRedondeo					varchar(20),
@CxcLocal							bit,
@ArticuloTarjeta					varchar(20),
@AlmacenTarjeta						varchar(10),
@MovIDCFD							varchar(20),
@UUID								varchar(50),
@FechaTimbrado						datetime,
@SelloSat							varchar(255),
@TFDVersion							varchar(10),
@NoCertificadoSAT					varchar(20),
@TFDCadenaOriginal					varchar(max),
@CadenaOriginal						varchar(max),
@Sello								varchar(255),
@Certificado						varchar(20),
@DocumentoXML						varchar(max),
@FechaSello							datetime,
@MovClave							varchar(20),
@Modulo								varchar(10),
@VentaPreciosImpuestoIncluido       bit
SELECT @MovCFD = MovFactura,  @CxcLocal = ISNULL(CxcLocal,0), @ToleranciaRedondeo = ISNULL(POSToleranciaVta,0.99)
FROM POSCfg
WHERE Empresa = @Empresa
SELECT @VentaPreciosImpuestoIncluido = ISNULL(VentaPreciosImpuestoIncluido,0), @ArticuloTarjeta= CxcArticuloTarjetasDef ,@AlmacenTarjeta= CxcAlmacenTarjetasDef
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT /*@ToleranciaRedondeo = ec.CxcAutoAjusteMov,*/ @ContMoneda = ec.ContMoneda
FROM EmpresaCfg ec
WHERE ec.Empresa = @Empresa
SELECT @ContMonedaTC = TipoCambio FROM POSLTipoCambioRef WHERE Sucursal = @Sucursal AND Moneda = @ContMoneda
SELECT @ArticuloRedondeo = cb.Cuenta
FROM CB
WHERE CB.Cuenta = @CodigoRedondeo
AND CB.TipoCuenta = 'Articulos'
SELECT @MovClave = mt.Clave , @Modulo = mt.ConsecutivoModulo
FROM MovTipo mt JOIN POSL p ON p.Mov = mt.Mov AND mt.Modulo = 'POS'
WHERE p.ID = @ID
IF NULLIF(@MovCFD,'') IS NOT NULL AND @Ok IS NULL
BEGIN
INSERT Venta (
Empresa, Mov, MovID, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda, TipoCambio, Usuario, Referencia,
Estatus, Observaciones, Cliente, EnviarA, Almacen, Agente, FormaEnvio, Condicion, Vencimiento, CtaDinero, Descuento,
DescuentoGlobal, Causa, Atencion, AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, Sucursal, OrigenTipo,
Origen, OrigenID, ReferenciaOrdenCompra, GenerarDinero, SucursalOrigen)
SELECT
p.Empresa, @MovCFD, NULL, p.FechaEmision, p.FechaRegistro, p.Concepto, p.Proyecto, p.UEN, p.Moneda,
CASE WHEN p.Moneda <> @ContMoneda
THEN  (p.TipoCambio/@ContMonedaTC)
ELSE p.TipoCambio
END, p.Usuario, p.Referencia,
'SINAFECTAR', p.Observaciones, p.Cliente, p.EnviarA, p.Almacen, p.Agente, p.FormaEnvio, p.Condicion, p.Vencimiento, p.CtaDinero, p.Descuento,
0.0, p.Causa, p.Atencion, p.AtencionTelefono, p.ListaPreciosEsp, p.ZonaImpuesto, p.Sucursal, 'POS',
p.Mov, p.MovID, @ID, 0, p.Sucursal
FROM POSL p
WHERE p.ID = @ID
IF @@ERROR <> 0
SET @Ok = 1
SELECT @IDNuevo = SCOPE_IDENTITY()
SELECT @CodigoRedondeo = pc.RedondeoVentaCodigo
FROM POSCfg pc
WHERE pc.Empresa = @Empresa
SELECT @ArticuloRedondeo = Cuenta
FROM CB
WHERE Codigo = @CodigoRedondeo
AND TipoCuenta = 'Articulos'
INSERT VentaD (
ID, Renglon, RenglonID, Aplica, AplicaID, RenglonTipo, Cantidad, CantidadObsequio, Almacen, EnviarA, Articulo, SubCuenta, Precio,
DescuentoLinea, Impuesto1, Impuesto2, Impuesto3, Unidad, Factor, Sucursal, Puntos, POSDesGlobal, POSDesLinea, Codigo)
SELECT
@IDNuevo, pmv.Renglon, pmv.RenglonID, pmv.Aplica, pmv.AplicaID, pmv.RenglonTipo, pmv.Cantidad, pmv.CantidadObsequio,
CASE WHEN pmv.Articulo= @ArticuloTarjeta
THEN ISNULL(pmv.Almacen,@AlmacenTarjeta)
ELSE p.Almacen
END, p.EnviarA, pmv.Articulo, pmv.SubCuenta,
CASE WHEN @VentaPreciosImpuestoIncluido = 1
THEN pmv.PrecioImpuestoInc
ELSE pmv.Precio
END,
dbo.fnPOSCalcDescuentosVenta(CASE WHEN ISNULL(pmv.AplicaDescGlobal, 1) = 1
THEN ISNULL(p.DescuentoGlobal,0.0)
ELSE 0
END,pmv.DescuentoLinea), pmv.Impuesto1, pmv.Impuesto2, pmv.Impuesto3, pmv.Unidad, 1, @Sucursal, pmv.Puntos,
CASE WHEN ISNULL(pmv.AplicaDescGlobal, 1) = 1
THEN ISNULL(p.DescuentoGlobal,0.0)
ELSE 0
END, ISNULL(pmv.DescuentoLinea,0.0), pmv.Codigo
FROM POSLVenta pmv JOIN POSL p ON pmv.ID = p.ID
WHERE pmv.ID = @ID
IF @@ERROR <> 0
SET @Ok = 1
EXEC spPOSInsertarPOSVentaCobro @ID, @Empresa,@Sucursal, @Ok OUTPUT, @OkRef OUTPUT
IF EXISTS(SELECT 1 FROM POSLSerieLote pls WHERE pls.ID = @ID)
INSERT SerieLoteMov (
Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Sucursal)
SELECT
@Empresa, 'VTAS', @IDNuevo, pls.RenglonID, pls.Articulo, ISNULL(pls.SubCuenta, ''), pls.SerieLote, COUNT(*),  @Sucursal
FROM POSLSerieLote pls
WHERE pls.ID = @ID
GROUP BY Articulo, ISNULL(SubCuenta,''), SerieLote, RenglonID
IF @Ok IS NULL AND @IDNuevo IS NOT NULL
EXEC spAfectar @Modulo, @IDNuevo, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 0, @Ok = @ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL AND EXISTS(SELECT * FROM CFD WHERE Modulo = 'VTAS' AND ModuloID = @IDNuevo)
BEGIN
SELECT
@CadenaOriginal = cfd.CadenaOriginal,
@Certificado = cfd.noCertificado,
@Sello = cfd.Sello,
@DocumentoXML = cfd.Documento,
@MovIDCFD = cfd.MovID,
@UUID = cfd.UUID,
@FechaTimbrado = cfd.FechaTimbrado,
@SelloSat = cfd.SelloSat,
@TFDVersion = cfd.TFDVersion,
@NoCertificadoSAT = cfd.NoCertificadoSAT,
@TFDCadenaOriginal = cfd.TFDCadenaOriginal
FROM CFD cfd
WHERE cfd.Modulo = 'VTAS' AND cfd.ModuloID = @IDNuevo
END
IF @Ok IS NULL
UPDATE POSL SET
CadenaOriginal = @CadenaOriginal,
Sello = @Sello,
Certificado = @Certificado,
DocumentoXML = @DocumentoXML,
FechaSello = @FechaSello,
Origen = @MovCFD,
OrigenID = @MovIDCFD,
UUID = @UUID,
FechaTimbrado = @FechaTimbrado,
SelloSat = @SelloSat,
TFDVersion = @TFDVersion,
NoCertificadoSAT = @NoCertificadoSAT,
TFDCadenaOriginal = @TFDCadenaOriginal
WHERE ID = @ID
IF @Ok IS NULL AND  @CxcLocal = 0 AND @MovClave IN('POS.F','POS.P')   AND @AfectadoEnLinea = 1
UPDATE POSL Set Estatus = 'TRASPASADO' , AfectadoEnLinea = @AfectadoEnLinea WHERE ID = @ID
IF @Ok IS NULL AND  @CxcLocal = 1 AND @MovClave IN('POS.F')
UPDATE POSL Set AfectadoLocal = 1  WHERE ID = @ID
END
IF @Ok IS NOT NULL
BEGIN
SELECT  @MovIDCFD = MovID
FROM Venta
WHERE ID = @IDNuevo
SELECT @Mensaje = @Mensaje+'<BR> ERROR AL GENERAR EL CFD '+ISNULL(@OkRef,'')+'<BR> '
UPDATE POSL Set Estatus = 'FACTURADO' , AfectadoEnLinea = @AfectadoEnLinea,Origen = @MovCFD, OrigenID = @MovIDCFD WHERE ID = @ID
END
SELECT  @Ok = null,@OkRef = null
END

