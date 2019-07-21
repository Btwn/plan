SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spPOSFacturarNotasLote
@Estacion       int,
@Empresa        varchar(20),
@Sucursal       int,
@Usuario        varchar(10),
@MovFact        varchar(20),
@Cliente        varchar(10),
@Ok             int   = NULL         OUTPUT,
@OkRef          varchar(255)  = NULL OUTPUT

AS
BEGIN
DECLARE
@IDPOS							varchar(50),
@IDDev							varchar(50),
@IDFact							varchar(50),
@MovCFD							varchar(20),
@MovDev							varchar(20),
@IDNuevo						int,
@CodigoRedondeo					varchar(20),
@ArticuloRedondeo				varchar(20),
@UUID							varchar(50),
@FechaTimbrado					datetime,
@MovIDCFD						varchar(20),
@SelloSat						varchar(255),
@TFDVersion						varchar(10),
@NoCertificadoSAT				varchar(20),
@TFDCadenaOriginal				varchar(max),
@CadenaOriginal					varchar(max),
@Sello							varchar(255),
@Certificado					varchar(20),
@DocumentoXML					varchar(max),
@FechaSello						datetime,
@Fecha 							datetime,
@ArticuloTarjeta				varchar(20),
@AlmacenTarjeta					varchar(20),
@Prefijo						varchar(5),
@Consecutivo					int,
@noAprobacion					int,
@fechaAprobacion				datetime,
@MovIDFact						varchar(20),
@MovIDDev						varchar(20),
@VentaPreciosImpuestoIncluido	bit,
@Host							varchar(20),
@Cluster						varchar(20),
@ContMoneda						varchar(10),
@ContMonedaTC					float,
@Expresion						varchar(255),
@Renglon						float,
@RenglonID						int,
@RenglonD						float,
@RenglonIDD						int,
@RenglonTipo					varchar(1),
@Cantidad						float,
@CantidadObsequio				float,
@Articulo						varchar(20),
@SubCuenta						varchar(50),
@Precio							float,
@PrecioSugerido					float,
@DescuentoLinea					float,
@Impuesto1						float,
@Impuesto2						float,
@Impuesto3						float,
@Unidad							varchar(20),
@Factor							float,
@Puntos							float,
@PrecioImpuestoInc				float,
@Almacen						varchar(20),
@AlmacenE						varchar(20),
@Moneda							varchar(10),
@Importe						float,
@Impuestos						float,
@TipoCambio						float,
@CtaDinero						varchar(10),
@CtaDineroDestino				varchar(10),
@Caja							varchar(10),
@Cajero							varchar(10),
@Agente							varchar(10),
@Codigo							varchar(30),
@EsMonedero						bit,
@ArtTarjetaServicio				varchar(20),
@RenglonIDMonederoDev			bit,
@SugerirFechaCierre				bit,
@FechaCierre					datetime,
@EsError						bit,
@Imagen							varchar(255)
DECLARE @VentaDetalle table(
Renglon				float,
RenglonID			int,
RenglonTipo			varchar(1),
Cantidad			float,
CantidadObsequio    float,
Articulo			varchar(20),
SubCuenta			varchar(50),
Precio				float,
PrecioSugerido		float,
DescuentoLinea		float,
Impuesto1			float,
Impuesto2			float,
Impuesto3			float,
Unidad				varchar(20),
Factor				float,
Puntos				float,
PrecioImpuestoInc	float,
Almacen				varchar(20),
Codigo				varchar(30),
EsMonedero			bit)
DECLARE @Cobro table(
FormaPago			varchar(50),
Importe				float,
Referencia			varchar(50),
Monedero			varchar(50),
CtaDinero			varchar(10),
Fecha				datetime,
Caja				varchar(10),
Cajero				varchar(10),
Host				varchar(20),
ImporteRef			float,
TipoCambio			float,
Voucher				varchar(max),
Banco				varchar(255),
MonedaRef			varchar(10),
CtaDineroDestino	varchar(10),
MonederoMoneda		varchar(10),
MonederoTipoCambio	float,
MonederoImporte		float)
DECLARE @SerieLote table(
RenglonID		int,
Articulo		varchar(20),
SubCuenta		varchar(50),
SerieLote		varchar(50))
SELECT @MovCFD = MovFactura, @CodigoRedondeo = RedondeoVentaCodigo
FROM POSCfg
WHERE Empresa = @Empresa
SELECT @ArticuloRedondeo = Cuenta
FROM CB
WHERE Codigo = @CodigoRedondeo AND TipoCuenta = 'Articulos'
SELECT @VentaPreciosImpuestoIncluido = ISNULL(VentaPreciosImpuestoIncluido,0),
@ArticuloTarjeta= CxcArticuloTarjetasDef,
@AlmacenTarjeta= CxcAlmacenTarjetasDef,
@ArtTarjetaServicio = ArtTarjetaServicio
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @SugerirFechaCierre = SugerirFechaCierre
FROM POSCfg
WHERE Empresa = @Empresa
SELECT @IDFact = NEWID(), @IDNuevo = NULL, @EsError = 0
EXEC spPOSHost @Host OUTPUT, @Cluster OUTPUT
IF NOT EXISTS(SELECT * FROM ListaSt l JOIN POSL p ON p.Mov+' '+p.MovID = l.Clave AND p.Empresa = @Empresa AND p.Facturado = 0 WHERE l.Estacion = @Estacion )
SELECT @Ok = -1 , @OkRef = 'No Hay Nada Que Afectar'
SELECT @Agente = Agente
FROM Cte
WHERE Cliente = @Cliente
SELECT TOP 1 @Moneda = Moneda, @AlmacenE = Almacen  ,@TipoCambio = TipoCambio
FROM POSL
WHERE Empresa = @Empresa AND Mov+' '+MovID IN(SELECT Clave FROM ListaSt WHERE Estacion = @Estacion) ORDER BY FechaRegistro
SELECT @Importe = SUM(Importe), @Impuestos = SUM(Impuestos)
FROM POSL
WHERE Empresa = @Empresa AND Mov+' '+MovID IN(SELECT Clave FROM ListaSt WHERE Estacion = @Estacion)
SELECT @CtaDinero = DefCtaDinero,
@Caja = DefCtaDinero,
@Cajero = DefCajero,
@CtaDineroDestino = DefCtaDineroTrans 
FROM Usuario
WHERE Usuario = @Usuario
SELECT @FechaCierre = dbo.fnPOSFechaCierre(@Empresa,@Sucursal,@FechaCierre,@Caja)
SELECT @ContMoneda = ec.ContMoneda
FROM EmpresaCfg ec
WHERE ec.Empresa = @Empresa
SELECT @ContMonedaTC = TipoCambio
FROM POSLTipoCambioRef
WHERE Sucursal = @Sucursal AND Moneda = @ContMoneda
SELECT @Fecha = CASE WHEN @SugerirFechaCierre = 1 THEN ISNULL(@FechaCierre,GETDATE()) ELSE dbo.fnFechaSinHora(GETDATE()) END
BEGIN TRANSACTION
SELECT @Renglon = 2048.0, @RenglonID = 1
DECLARE crPOS CURSOR local FOR
SELECT p.ID
FROM ListaSt l JOIN POSL p ON p.Mov+' '+p.MovID = l.Clave AND p.Empresa = @Empresa
WHERE l.Estacion = @Estacion
AND p.Facturado = 0
OPEN crPOS
FETCH NEXT FROM crPOS INTO @IDPOS
WHILE @@FETCH_STATUS = 0  AND @Ok IS NULL
BEGIN
SELECT @IDDev = NEWID()
IF @Ok IS  NULL
BEGIn
INSERT POSL (
ID, Empresa, Mov, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda, TipoCambio, Importe, Impuestos, Usuario, Referencia,
Estatus, Observaciones, Cliente, EnviarA, Almacen, Agente, FormaEnvio, Condicion, Vencimiento, CtaDinero, Descuento, DescuentoGlobal,
Causa, Atencion, AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, Sucursal, OrigenTipo, Origen, OrigenID, Host, Cluster, Nombre,
Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Delegacion, Colonia, Poblacion, Estado, Pais, Zona, CodigoPostal,
RFC, CURP, Modulo, Cajero, CtaDineroDestino, Directo, Caja, PedidoReferencia, PedidoReferenciaID, IDR, FechaNacimiento, EstadoCivil,
Conyuge, Sexo, Fuma, Profesion, Puesto, NumeroHijos, Religion)
SELECT
@IDDev, Empresa, Mov, @Fecha, GETDATE(), Concepto, Proyecto, UEN, Moneda, TipoCambio, (Importe*-1), (Impuestos*-1), @Usuario, Referencia,
Estatus, Observaciones, Cliente, EnviarA, Almacen, @Agente, FormaEnvio, Condicion, Vencimiento, @CtaDinero, Descuento, DescuentoGlobal,
Causa, Atencion, AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, @Sucursal, OrigenTipo, Origen, OrigenID, @Host, @Cluster, Nombre,
Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Delegacion, Colonia, Poblacion, Estado, Pais, Zona, CodigoPostal,
RFC, CURP, Modulo, @Cajero, @CtaDineroDestino, Directo, @Caja, PedidoReferencia, PedidoReferenciaID, @IDPOS, FechaNacimiento, EstadoCivil,
Conyuge, Sexo, Fuma, Profesion, Puesto, NumeroHijos, Religion
FROM POSL
WHERE ID = @IDPOS
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
INSERT POSLVenta(
ID, Renglon, RenglonID, Aplica, AplicaID, RenglonTipo, Cantidad, CantidadObsequio, Articulo, SubCuenta, Precio,
PrecioSugerido, DescuentoLinea, Impuesto1, Impuesto2, Impuesto3, Unidad, Factor, Puntos,PrecioImpuestoInc, Almacen,
Aplicado, Codigo, EsMonedero)
SELECT
@IDDev, Renglon, RenglonID, Aplica, AplicaID, RenglonTipo, (Cantidad*-1), (CantidadObsequio*-1), Articulo, SubCuenta, Precio,
PrecioSugerido, DescuentoLinea, Impuesto1, Impuesto2, Impuesto3, Unidad, Factor,  Puntos,PrecioImpuestoInc, Almacen,
1, Codigo, EsMonedero
FROM POSLVenta
WHERE ID = @IDPOS
IF @@ERROR <> 0 SET @Ok = 1
IF EXISTS(SELECT * FROM POSLSerieLote WHERE ID = @IDPOS)
BEGIN
INSERT POSLSerieLote(ID, RenglonID, Articulo, SubCuenta, SerieLote)
SELECT @IDDev, RenglonID, Articulo, ISNULL(SubCuenta,''), SerieLote
FROM POSLSerieLote
WHERE ID = @IDPOS
ORDER BY Orden
END
IF EXISTS(SELECT * FROM POSLCobro WHERE ID = @IDPOS)
BEGIN
INSERT POSLCobro(ID, FormaPago, Importe, Referencia, Monedero, CtaDinero, Fecha, Caja, Cajero, Host, ImporteRef, TipoCambio,
Voucher, Banco, MonedaRef, CtaDineroDestino, MonederoMoneda, MonederoTipoCambio, MonederoImporte)
SELECT @IDDev, FormaPago, (Importe*-1), Referencia, Monedero, @CtaDinero, Fecha,  @Caja,  @Cajero, Host, (ImporteRef*-1), TipoCambio,
Voucher, Banco, MonedaRef, @CtaDineroDestino, MonederoMoneda, MonederoTipoCambio, (MonederoImporte*-1)
FROM POSLCobro
WHERE ID = @IDPOS
END
IF EXISTS(SELECT * FROM POSLVenta WHERE ID = @IDPOS AND ISNULL(EsMonedero,0) = 1)
BEGIN
SELECT @RenglonIDMonederoDev = RenglonID
FROM POSLVenta
WHERE  ID = @IDPOS AND ISNULL(EsMonedero,0) = 1
UPDATE POSLVenta SET Articulo = @ArtTarjetaServicio, RenglonTipo = 'N'
WHERE  ID = @IDDev AND ISNULL(EsMonedero,0) = 1
DELETE POSLSerieLote WHERE ID = @IDDev AND RenglonID = @RenglonIDMonederoDev
END
SELECT @MovDev = Mov
FROM POSL
WHERE ID = @IDDev
SELECT @MovDev = ISNULL(NULLIF(POSDefMovDev,''),@MovDev)
FROM POSCfg
WHERE Empresa = @Empresa
IF @Ok IS NULL
BEGIN
EXEC spPOSConsecutivoAuto @Empresa, @Sucursal, @MovDev, @MovIDDev OUTPUT, @Prefijo OUTPUT,
@Consecutivo OUTPUT, @noAprobacion OUTPUT, @FechaAprobacion OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
UPDATE POSL SET Mov =  @MovDev,
MovID =  @MovIDDev,
Prefijo = ISNULL(Prefijo, @Prefijo),
Consecutivo = ISNULL(Consecutivo, @Consecutivo),
noAprobacion = ISNULL(noAprobacion, @NoAprobacion),
fechaAprobacion = ISNULL(fechaAprobacion, @fechaAprobacion),
Estatus = 'CONCLUIDO',
FechaEmision = dbo.fnFechaSinHora(@Fecha),
FechaRegistro = GETDATE()
WHERE ID = @IDDev
END
END
IF @Ok IS NULL
BEGIN
DECLARE crDetalle CURSOR LOCAL FOR
SELECT pv.Renglon,
pv.RenglonID,
pv.RenglonTipo,
pv.Cantidad,
pv.CantidadObsequio,
CASE WHEN ISNULL(pv.EsMonedero,0) = 1  THEN @ArtTarjetaServicio ELSE pv.Articulo END,
pv.SubCuenta,
pv.Precio,
pv.PrecioSugerido,
CASE WHEN ISNULL(p.DescuentoGlobal,0) <> 0 THEN 1 - ((1-ISNULL(pv.DescuentoLinea,0)) *(1-ISNULL(p.DescuentoGlobal,0))) ELSE  pv.DescuentoLinea END,
pv.Impuesto1,
pv.Impuesto2,
pv.Impuesto3,
pv.Unidad,
pv.Factor,
pv.Puntos,
pv.PrecioImpuestoInc,
pv.Almacen,
pv.Codigo,
ISNULL(pv.EsMonedero,0)
FROM POSLVenta pv
JOIN POSL p ON pv.ID = p.ID
WHERE p.ID = @IDPOS
OPEN crDetalle
FETCH NEXT FROM crDetalle INTO @RenglonD, @RenglonIDD, @RenglonTipo, @Cantidad, @CantidadObsequio, @Articulo, @SubCuenta, @Precio,
@PrecioSugerido, @DescuentoLinea, @Impuesto1, @Impuesto2, @Impuesto3, @Unidad, @Factor,  @Puntos,
@PrecioImpuestoInc, @Almacen, @Codigo, @EsMonedero
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
INSERT @VentaDetalle(Renglon, RenglonID, RenglonTipo, Cantidad, CantidadObsequio, Articulo, SubCuenta, Precio, PrecioSugerido,
DescuentoLinea, Impuesto1, Impuesto2, Impuesto3, Unidad, Factor, Puntos, PrecioImpuestoInc, Almacen, Codigo,
EsMonedero)
SELECT				@Renglon, @RenglonID, @RenglonTipo, @Cantidad, @CantidadObsequio, @Articulo, @SubCuenta, @Precio, @PrecioSugerido, @DescuentoLinea,
@Impuesto1, @Impuesto2, @Impuesto3, @Unidad, @Factor,  @Puntos, @PrecioImpuestoInc, @Almacen,@Codigo,
@EsMonedero
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL AND EXISTS(SELECT * FROM POSLSerieLote WHERE ID = @IDPOS AND RenglonID = @RenglonIDD)
BEGIN
INSERT @SerieLote(RenglonID,  Articulo, SubCuenta, SerieLote)
SELECT			  @RenglonID, Articulo, SubCuenta, SerieLote
FROM POSLSerieLote
WHERE ID = @IDPOS AND RenglonID = @RenglonIDD
IF @@ERROR <> 0 SET @Ok = 1
END
IF ISNULL(@EsMonedero,0)=1
DELETE @SerieLote WHERE RenglonID = @RenglonID
SELECT  @Renglon = @Renglon +2048.0, @RenglonID = @RenglonID +1
FETCH NEXT FROM crDetalle INTO  @RenglonD, @RenglonIDD, @RenglonTipo, @Cantidad, @CantidadObsequio, @Articulo, @SubCuenta, @Precio,
@PrecioSugerido, @DescuentoLinea, @Impuesto1, @Impuesto2, @Impuesto3, @Unidad, @Factor,  @Puntos,
@PrecioImpuestoInc, @Almacen, @Codigo, @EsMonedero
END
CLOSE crDetalle
DEALLOCATE crDetalle
END
IF @Ok IS NULL
BEGIN
INSERT @Cobro (FormaPago, Importe, Referencia, Monedero, CtaDinero, Fecha, Caja, Cajero, Host, ImporteRef, TipoCambio, Voucher, Banco,
MonedaRef, CtaDineroDestino, MonederoMoneda, MonederoTipoCambio, MonederoImporte)
SELECT		   FormaPago, Importe, Referencia, Monedero, @CtaDinero, Fecha, @Caja, @Cajero, Host, ImporteRef, TipoCambio, Voucher, Banco,
MonedaRef, @CtaDineroDestino, MonederoMoneda, MonederoTipoCambio, MonederoImporte
FROM  POSLCobro
WHERE ID = @IDPOS
END
FETCH NEXT FROM crPOS INTO @IDPOS
END
CLOSE crPOS
DEALLOCATE crPOS
IF @MovFact IS NOT NULL AND @Ok IS NULL
BEGIN
INSERT POSL (
ID, Empresa, Mov, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda, Importe, Impuestos, TipoCambio, Usuario, Referencia, Estatus,
Observaciones, Cliente, EnviarA, Almacen, Agente, FormaEnvio, Condicion, Vencimiento, CtaDinero, Descuento, DescuentoGlobal, Causa, Atencion,
AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, Sucursal, OrigenTipo, Origen, OrigenID, Host, Cluster, Modulo, Cajero, CtaDineroDestino,
Directo, Caja, PedidoReferencia, PedidoReferenciaID, IDR)
SELECT
@IDFact, @Empresa, @MovFact, @Fecha, GETDATE(), NULL, NULL, NULL, @Moneda, @Importe, @Impuestos, @TipoCambio, @Usuario, NULL, 'CONCLUIDO',
NULL, @Cliente, NULL, @AlmacenE, @Agente, NULL, NULL, NULL, @CtaDinero, NULL, NULL, NULL, NULL,
NULL, NULL, NULL, @Sucursal, NULL, NULL, NULL, @Host, @Cluster, 'VTAS', @Cajero, NULL,
1, @Caja, NULL, NULL, NULL
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
INSERT POSLVenta(ID, Renglon, RenglonID, RenglonTipo, Cantidad, CantidadObsequio, Articulo, SubCuenta, Precio, PrecioSugerido, DescuentoLinea,
Impuesto1, Impuesto2, Impuesto3, Unidad, Factor,  Puntos,PrecioImpuestoInc, Almacen, Aplicado, Codigo)
SELECT			@IDFact, Renglon, RenglonID, RenglonTipo, Cantidad, CantidadObsequio, Articulo, SubCuenta, Precio, PrecioSugerido, DescuentoLinea,
Impuesto1, Impuesto2, Impuesto3, Unidad, Factor,  Puntos,PrecioImpuestoInc, Almacen, 1, Codigo
FROM @VentaDetalle
IF @@ERROR <> 0 SET @Ok = 1
IF EXISTS(SELECT * FROM POSLSerieLote WHERE ID = @IDPOS)
INSERT POSLSerieLote(ID, RenglonID, Articulo, SubCuenta, SerieLote)
SELECT				 @IDFact, RenglonID, Articulo, ISNULL(SubCuenta,''), SerieLote
FROM @SerieLote
IF EXISTS(SELECT * FROM POSLCobro WHERE ID = @IDPOS)
INSERT POSLCobro( ID, FormaPago, Importe, Referencia, Monedero, CtaDinero, Fecha, Caja, Cajero, Host, ImporteRef, TipoCambio,
Voucher, Banco, MonedaRef, CtaDineroDestino, MonederoMoneda, MonederoTipoCambio, MonederoImporte)
SELECT			@IDFact, FormaPago, SUM(Importe), Referencia, Monedero, @CtaDinero, Fecha,  @Caja,  @Cajero, @Host, SUM(ImporteRef), TipoCambio,
NULL, Banco, MonedaRef, CtaDineroDestino, MonederoMoneda, MonederoTipoCambio, sum(isnull(MonederoImporte,0))
FROM @Cobro
GROUP BY FormaPago, Referencia, Monedero, CtaDinero, Fecha, TipoCambio, Banco, MonedaRef, CtaDineroDestino, MonederoMoneda, MonederoTipoCambio
IF @Ok IS NULL
EXEC spPOSInsertaCliente2 @Empresa, @IDFact, NULL, @CtaDinero, @Cliente, @Estacion, @Imagen OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @EsFactura = 1
IF @Ok IS NULL
EXEC spPOS @Estacion, NULL, @Empresa, 'VTAS', @Sucursal, @Usuario,  NULL, @IDFact, NULL, NULL, NULL, 0, NULL, NULL, @EnSilencio = 1
IF @Ok IS NULL
BEGIN
EXEC spPOSConsecutivoAuto @Empresa, @Sucursal, @MovFact, @MovIDFact OUTPUT, @Prefijo OUTPUT, @Consecutivo OUTPUT,
@noAprobacion OUTPUT, @FechaAprobacion OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
UPDATE POSL SET MovID =  @MovIDFact,
Prefijo = ISNULL(Prefijo, @Prefijo),
Consecutivo = ISNULL(Consecutivo, @Consecutivo),
noAprobacion = ISNULL(noAprobacion, @NoAprobacion),
fechaAprobacion = ISNULL(fechaAprobacion, @fechaAprobacion),
Estatus = 'CONCLUIDO',
FechaEmision = dbo.fnFechaSinHora(@Fecha),
FechaRegistro = GETDATE()
WHERE ID = @IDFact
END
END
IF NULLIF(@MovCFD,'') IS NOT NULL AND @Ok IS NULL AND @IDFact IS NOT NULL
BEGIN
INSERT Venta (
Empresa, Mov, MovID, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda, TipoCambio,
Usuario, Referencia, Estatus, Observaciones, Cliente, EnviarA, Almacen, Agente, FormaEnvio, Condicion,
Vencimiento, CtaDinero, Descuento, DescuentoGlobal, Causa, Atencion, AtencionTelefono, ListaPreciosEsp, ZonaImpuesto,
Sucursal, OrigenTipo, Origen, OrigenID, ReferenciaOrdenCompra, GenerarDinero, SucursalOrigen, Directo, Ejercicio, Periodo)
SELECT
p.Empresa, @MovCFD, NULL, @Fecha, GETDATE(), p.Concepto, p.Proyecto, p.UEN, p.Moneda, CASE WHEN p.Moneda <> @ContMoneda THEN  (p.TipoCambio/@ContMonedaTC) ELSE p.TipoCambio END,
p.Usuario, p.Referencia, 'SINAFECTAR', p.Observaciones, p.Cliente, p.EnviarA, p.Almacen, p.Agente, p.FormaEnvio, p.Condicion,
p.Vencimiento, p.CtaDinero, p.Descuento, 0.0, p.Causa, p.Atencion, p.AtencionTelefono, p.ListaPreciosEsp, p.ZonaImpuesto,
p.Sucursal, 'POS', p.Mov, p.MovID, @IDFact, 0, p.Sucursal, 1, DATEPART(YEAR,p.FechaEmision), DATEPART(MONTH,p.FechaEmision)
FROM POSL p
WHERE p.ID = @IDFact
IF @@ERROR <> 0 SET @Ok = 1
SELECT @IDNuevo = SCOPE_IDENTITY()
INSERT VentaD ( ID,		  Renglon,		RenglonID,		Aplica,		AplicaID,	RenglonTipo,	 Cantidad,		CantidadObsequio,
Almacen,
EnviarA,	Articulo,		SubCuenta,		Precio,
DescuentoLinea,
Impuesto1,		Impuesto2,		Impuesto3,		Unidad,		Factor,		Sucursal,	Puntos,
POSDesGlobal,																					POSDesLinea, Codigo)
SELECT			@IDNuevo, pmv.Renglon,	pmv.RenglonID,	NULL,		NULL,		pmv.RenglonTipo, pmv.Cantidad,	pmv.CantidadObsequio,
CASE WHEN pmv.Articulo= @ArticuloTarjeta THEN ISNULL(p.Almacen,@AlmacenTarjeta) ELSE ISNULL(pmv.Almacen,p.Almacen) END,
p.EnviarA,	pmv.Articulo,	pmv.SubCuenta,	CASE WHEN @VentaPreciosImpuestoIncluido = 1 THEN pmv.PrecioImpuestoInc ELSE pmv.Precio END,
dbo.fnPOSCalcDescuentosVenta(CASE WHEN ISNULL(pmv.AplicaDescGlobal, 1) = 1 THEN ISNULL(p.DescuentoGlobal,0.0) ELSE 0 END, pmv.DescuentoLinea),
pmv.Impuesto1,	pmv.Impuesto2,	pmv.Impuesto3,	pmv.Unidad, pmv.Factor,	@Sucursal,	pmv.Puntos,
CASE WHEN ISNULL(pmv.AplicaDescGlobal, 1) = 1 THEN ISNULL(p.DescuentoGlobal,0.0) ELSE 0 END,	ISNULL(pmv.DescuentoLinea,0.0), pmv.Codigo
FROM POSLVenta pmv
JOIN POSL p ON pmv.ID = p.ID
WHERE pmv.ID = @IDFact
AND ISNULL(pmv.precio,0.0) <> 0.0
IF @@ERROR <> 0 SET @Ok = 1
EXEC spPOSInsertarPOSVentaCobro @IDFact, @Empresa,@Sucursal, @Ok OUTPUT, @OkRef OUTPUT
IF EXISTS(SELECT 1 FROM POSLSerieLote pls WHERE pls.ID = @IDFact)
INSERT SerieLoteMov (Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Sucursal)
SELECT @Empresa, 'VTAS', @IDNuevo, pls.RenglonID, pls.Articulo, ISNULL(pls.SubCuenta, ''), pls.SerieLote, COUNT(*),  @Sucursal
FROM POSLSerieLote pls
WHERE pls.ID = @IDFact
GROUP BY Articulo, ISNULL(SubCuenta,''), SerieLote, RenglonID
IF @Ok IS NULL AND @IDNuevo IS NOT NULL
EXEC spAfectar 'VTAS', @IDNuevo, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL AND EXISTS(SELECT * FROM CFD WHERE Modulo = 'VTAS' AND ModuloID = @IDNuevo)
BEGIN
SELECT @CadenaOriginal = cfd.CadenaOriginal,
@Certificado = cfd.noCertificado,
@Sello = cfd.Sello,
@DocumentoXML = cfd.Documento,
@MovIDCFD = cfd.MovID,
@UUID = cfd.UUID,
@FechaTimbrado = cfd.FechaTimbrado,
@SelloSat = cfd.SelloSat,
@TFDVersion = cfd.TFDVersion  ,
@NoCertificadoSAT = cfd.NoCertificadoSAT,
@TFDCadenaOriginal = cfd.TFDCadenaOriginal
FROM CFD cfd
WHERE cfd.Modulo = 'VTAS'
AND cfd.ModuloID = @IDNuevo
IF @Ok IS NULL
UPDATE POSL SET CadenaOriginal = @CadenaOriginal,
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
WHERE ID = @IDFact
END
END
IF @Ok IS NULL
UPDATE POSL SET Facturado = 1 WHERE Empresa = @Empresa AND Mov+' '+MovID IN(SELECT Clave FROM ListaSt WHERE Estacion = @Estacion)
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
SELECT @Expresion = 'FormaModal('+CHAR(39)+'POSFacturarNotas'+CHAR(39)+')'
SELECT @OkRef = ' Se Genero '+@MovFact+' '+@MovIDFact
END
ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT @OkRef = Descripcion+' '+RTRIM(ISNULL(@OkRef,''))
FROM MensajeLista
WHERE Mensaje = @Ok
SELECT @Expresion = @OkRef
SET @EsError = 1
END
SELECT @OkRef, @Expresion, @IDFact, @IDNuevo, @MovCFD, @MovIDCFD, @EsError
RETURN
END

