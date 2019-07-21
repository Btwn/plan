SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSConcluir
@Empresa			varchar(5),
@Modulo				varchar(5),
@Sucursal			int,
@Usuario			varchar(10),
@Saldo				float,
@Estacion			int,
@ID					varchar(50)	OUTPUT,
@Mensaje			varchar(255)	OUTPUT,
@Imagen				varchar(255)	OUTPUT,
@Expresion			varchar(255)	OUTPUT,
@Expresion2			varchar(255)	OUTPUT,
@Ok					int		OUTPUT,
@OkRef				varchar(255)	OUTPUT,
@IDImpresion		varchar(36)     OUTPUT,
@GenerarCFD			bit             OUTPUT,
@AfectadoEnLinea	bit             OUTPUT

AS
BEGIN
DECLARE
@IDM							varchar(50),
@IDR							varchar(50),
@ToleranciaRedondeo				float,
@Mov							  varchar(20),
@MovID							varchar(20),
@MovClave						varchar(20),
@MovSubClave					varchar(20),
@CtaDinero						varchar(10),
@CtaDineroDestino				varchar(10),
@Caja							varchar(10),
@Cajero							varchar(10),
@ImporteMov						float,
@ImpuestosMov					float,
@Estatus						varchar(20),
@ValidarDevolucion				bit,
@ImporteCobro					float,
@ReporteImpresora				varchar(50),
@Host							varchar(20),
@Cluster						varchar(20),
@Prefijo						varchar(5),
@Consecutivo					int,
@noAprobacion					int,
@fechaAprobacion				datetime,
@ImporteLDI						float,
@MonederoLDI					varchar(20),
@UsuarioAutoriza				varchar(10),
@PuedeAutorizar					bit,
@TotalImporte					float,
@TotalImpuesto1					float,
@TotalImpuesto2					float,
@Fecha							datetime,
@FechaRegistro					datetime,
@RedondeoMonetarios				int,
@EsConcentradora				bit,
@MovCFD							varchar(20),
@IDNuevo						int,
@CodigoRedondeo					varchar(50),
@VentaPreciosImpuestoIncluido	bit,
@ArticuloTarjeta				varchar(20),
@AlmacenTarjeta					varchar(20),
@ArticuloRedondeo				varchar(20),
@CadenaOriginal					varchar(max),
@Sello							varchar(255),
@Certificado					varchar(20),
@DocumentoXML					varchar(max),
@FechaSello						datetime,
@ImporteEnCaja					float,
@MensajeLimiteCaja				bit,
@Alerta							bit,
@LimiteCaja						float,
@Superior						float,
@LDI							bit,
@UsuarioPerfil					varchar(10),
@UsuarioAutorizaPerfil			varchar(10),
@CantidadD						float,
@ArticuloD						varchar(20),
@SubCuentaD						varchar(50),
@RenglonIDD						int,
@CantidadSerie					float,
@MovIDCFD						varchar(20),
@UUID							varchar(50),
@FechaTimbrado					datetime,
@SelloSat						varchar(255),
@TFDVersion						varchar(10),
@NoCertificadoSAT				varchar(20),
@TFDCadenaOriginal				varchar(max),
@CxcLocal						bit,
@Condicion						varchar(50),
@Aplica							varchar(20),
@AplicaID						varchar(20),
@ContMoneda						varchar(10),
@ContMonedaTC					float,
@SugerirFechaCierre				bit,
@FechaCierre					datetime,
@IDDevolucion					varchar(36),
@IDDevolucionP					varchar(36),
@Articulo						varchar (20),
@Cantidad						float,
@iSyncNivel						varchar(20),
@SubCuenta						varchar(50),
@ImporteVerificar				float,
@MensajeLimiteCajaT				varchar(100),
@GenerarEmbarques  				bit,
@POSDefMovEmbarque 				varchar(20),
@IDEst             				varchar(36),
@MonederoIntelisis				bit,
@CfgVentaMonederoA				bit
SET @IDEst = @ID
SET @GenerarCFD = 0
SET @AfectadoEnLinea = 0
SELECT @VentaPreciosImpuestoIncluido = ISNULL(VentaPreciosImpuestoIncluido,0), @ArticuloTarjeta= CxcArticuloTarjetasDef ,@AlmacenTarjeta= CxcAlmacenTarjetasDef
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
EXEC spPOSHost @Host OUTPUT, @Cluster OUTPUT
SELECT @FechaRegistro = GETDATE()
SELECT  @iSyncNivel = ISNULL(NULLIF(CierreiSyncNivel,''),'Sucursal') , @MensajeLimiteCajaT = ISNULL(NULLIF(MensajeLimiteCajaT,''), '   ***  HA EXCEDIDO EL LIMITE PERMITIDO POR FAVOR HAGA UNA RECOLECCI±N'),
@ValidarDevolucion = pc.ValidarDevolucion, @LDI = ISNULL(MonederoLDI,0), @CxcLocal = ISNULL(CxcLocal,0), @SugerirFechaCierre = SugerirFechaCierre, @ToleranciaRedondeo = ISNULL(POSToleranciaVta,0.99),
@GenerarEmbarques = GenerarEmbarques, @POSDefMovEmbarque = POSDefMovEmbarque
FROM POSCfg pc
WHERE pc.Empresa = @Empresa
SELECT @MonederoIntelisis = ISNULL(VentaMonedero,0),
@CfgVentaMonederoA	= isnull(VentaMonederoA,0)
FROM EmpresaCfg2
WHERE Empresa = @Empresa
IF @CfgVentaMonederoA = 1
SET @LDI = 0
SELECT @MensajeLimiteCaja = ISNULL(POSMensajeLimiteCaja,0), @LimiteCaja = ISNULL(POSLimiteCaja,0.0)
FROM Sucursal
WHERE Sucursal = @Sucursal
SELECT @UsuarioPerfil = NULLIF(POSPerfil,'') FROM Usuario WHERE Usuario = @Usuario
SELECT @IDImpresion = @ID
SELECT @Saldo = ROUND(@Saldo,@RedondeoMonetarios)
SELECT
@Mov = p.Mov,
@MovID = p.MovID,
@MovClave = mt.Clave,
@MovSubClave = mt.SubClave,
@CtaDinero = p.CtaDinero,
@CtaDineroDestino = p.CtaDineroDestino,
@Caja = p.Caja,
@Cajero = p.Cajero,
@Estatus = p.Estatus,
@UsuarioAutoriza = p.UsuarioAutoriza,
@IDR = p.IDR
FROM POSL p
INNER JOIN Sucursal s ON p.Sucursal = s.Sucursal
INNER JOIN MovTipo mt ON mt.Mov = p.Mov AND mt.Modulo = 'POS'
WHERE p.ID = @ID
SELECT @FechaCierre = Fecha
FROM POSFechaCierre
WHERE Sucursal = @Sucursal
SELECT @FechaCierre = dbo.fnPOSFechaCierre(@Empresa,@Sucursal,ISNULL(@FechaCierre,GETDATE()),@Caja)
SELECT @Fecha = CASE WHEN @SugerirFechaCierre = 1 THEN @FechaCierre ELSE dbo.fnFechaSinHora(GETDATE())END
SELECT @UsuarioAutorizaPerfil = NULLIF(POSPerfil,'')
FROM Usuario
WHERE Usuario = @UsuarioAutoriza
IF @Cajero IS NULL
SELECT @Ok = 30490
SELECT @Alerta = Alerta, @Superior = ISNULL(AlertaLimiteSuperior,0.0)
FROM CtaDinero
WHERE CtaDinero = @CtaDinero AND Tipo = 'Caja'
IF ISNULL(@Alerta,0) = 1 AND @Superior > 0.0
SELECT @LimiteCaja = @Superior
SELECT @ImporteCobro = ROUND(SUM(Importe),@RedondeoMonetarios)
FROM POSLCobro pc
WHERE pc.ID = @ID
SELECT /*@ToleranciaRedondeo = ec.CxcAutoAjusteMov, */@ContMoneda = ec.ContMoneda
FROM EmpresaCfg ec
WHERE ec.Empresa = @Empresa
SELECT @ContMonedaTC = TipoCambio FROM POSLTipoCambioRef WHERE Sucursal = @Sucursal AND Moneda = @ContMoneda
IF @MovClave IN ('POS.CPC', 'POS.CPCM', 'POS.CC', 'POS.CCM')
BEGIN
SELECT @ImporteVerificar = SUM(ISNULL(Importe,0)) FROM POSLCobro WHERE ID = @ID 
IF ISNULL(@ImporteVerificar,0) = 0
BEGIN
SELECT @Ok = 30100, @OkRef = 'NO SE PUEDE REALIZAR ESTA OPERACI±N EN CEROS, DEBE AGREGAR CUANDO MENOS UN CENTAVO EN UNA FORMA PAGO'
RETURN
END
END
IF @MovClave IN ('POS.N', 'POS.A', 'POS.F','POS.P','POS.NPC','POS.INVD', 'POS.INVA')
BEGIN
SELECT @ImporteMov = SUM((plv.Cantidad - ISNULL(plv.CantidadObsequio,0)) * ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0)/100))) - ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0)/100))) * (CASE WHEN ISNULL(plv.AplicaDescGlobal, 1) = 1 THEN ISNULL(p.DescuentoGlobal,0.0) ELSE 0 END)/100))),
@ImpuestosMov = (SUM(dbo.fnPOSImporteMov(((plv.Cantidad  - ISNULL(plv.CantidadObsequio,0.0)) * ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) - ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) * (CASE WHEN ISNULL(plv.AplicaDescGlobal, 1) = 1 THEN ISNULL(p.DescuentoGlobal,0.0) ELSE 0 END)/100))),plv.Impuesto1,plv.Impuesto2,plv.Impuesto3,plv.Cantidad)) - @ImporteMov)
FROM POSLVenta plv
INNER JOIN POSL p ON p.ID = plv.ID
WHERE plv.ID = @ID
SELECT @ImporteMov = ROUND(@ImporteMov,@RedondeoMonetarios)
SELECT @ImpuestosMov = ROUND(@ImpuestosMov,@RedondeoMonetarios)
IF (@MovClave IN('POS.N','POS.F','POS.NPC')OR(@MovClave = 'POS.P'  AND @MovSubClave IN('POS.FACCRED','POS.DEVCRED')))AND @MovSubClave NOT IN('POS.PEDCONT')
BEGIN
IF EXISTS(SELECT * FROM POSLVenta p JOIN Art a ON p.Articulo = a.Articulo
WHERE a.Tipo IN('SERIE','LOTE') AND p.ID = @ID AND a.Articulo <> @ArticuloTarjeta)
BEGIN
DECLARE crVentaD CURSOR FOR
SELECT  ISNULL(p.Cantidad,0.0), p.Articulo, ISNULL(p.SubCuenta,''),p.RenglonID
FROM POSLVenta p JOIN Art a ON a.Articulo = p.Articulo
WHERE p.ID = @ID
AND a.Tipo IN('SERIE','LOTE')
AND p.Cantidad >0.0
OPEN crVentaD
FETCH NEXT FROM crVentaD INTO @CantidadD, @ArticuloD, @SubCuentaD, @RenglonIDD
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @CantidadSerie = COUNT(*)
FROM POSLSerieLote
WHERE Articulo = @ArticuloD AND ISNULL(SubCuenta,'') = ISNULL(@SubCuentaD,'')
AND RenglonID = @RenglonIDD AND ID = @ID
IF ISNULL(@CantidadSerie,0.0) <> ISNULL(@CantidadD,0.0)
SELECT @Ok = 20320, @OkRef = @ArticuloD
FETCH NEXT FROM crVentaD INTO @CantidadD, @ArticuloD, @SubCuentaD, @RenglonIDD
END
CLOSE crVentaD
DEALLOCATE crVentaD
END
END
IF(SELECT NULLIF(Monedero,'') FROM POSL WHERE ID = @ID) IS NULL
UPDATE POSLVenta SET Puntos = NULL  WHERE ID = @ID
IF @ValidarDevolucion = 1 AND @ImporteMov < 0 AND @MovClave IN ('POS.N','POS.NPC')
BEGIN
IF NOT EXISTS(SELECT * FROM POSLValidarDevolucion plv WHERE plv.ID = @ID)
BEGIN
INSERT POSLAccion (Host, Caja, Accion)
VALUES (@Host, @Caja, 'ORIGEN DEVOLUCION')
SELECT @Ok = 46020, @OkRef = 'Favor de Ingresar el Folio de la Venta Original'
END
END
IF @ValidarDevolucion = 1 AND @MovClave IN ('POS.P')AND @MovSubClave = 'POS.DEVCRED'
BEGIN
IF NOT EXISTS(SELECT * FROM POSLValidarDevolucion plv WHERE plv.ID = @ID)
BEGIN
INSERT POSLAccion (Host, Caja, Accion)
VALUES (@Host, @Caja, 'ORIGEN DEVOLUCION')
SELECT @Ok = 46020, @OkRef = 'Favor de Ingresar el Folio de la Venta Original'
END
END
IF @MovClave IN ('POS.A') /*OR (@ImporteMov < 0 AND @MovClave IN ('POS.N'))*/ AND @Ok IS NULL
BEGIN
SELECT @MonederoLDI = Monedero
FROM POSLDIMonederoSaldoFavor
WHERE ID = @ID
IF @MonederoLDI IS NULL
SELECT @Ok = 53020, @OkRef = 'Es necesario indicar con una acción el Monedero donde se abonará el Saldo a Favor'
SELECT @ImporteLDI = (@ImporteMov + ISNULL(@ImpuestosMov,0)) * (-1)
IF @Ok IS NULL AND @LDI = 1
EXEC spPOSLDI 'MON ABONO', @ID, @MonederoLDI, @Empresa, @Usuario, @Sucursal, NULL, @ImporteLDI, 1, null, @Ok OUTPUT, @OkRef OUTPUT, 'POS'
END
IF @Ok IS NULL AND @LDI = 1 AND (SELECT SUM(ISNULL(PUNTOS,0)) FROM POSLVenta WHERE ID = @ID) > 0
BEGIN
SELECT @MonederoLDI = Monedero  FROM POSL WHERE ID = @ID
SELECT @ImporteLDI = SUM(ISNULL(PUNTOS,0)) FROM POSLVenta WHERE ID = @ID
EXEC spPOSLDI 'MON ABONO', @ID, @MonederoLDI, @Empresa, @Usuario, @Sucursal, NULL, @ImporteLDI, 1, null, @Ok OUTPUT, @OkRef OUTPUT, 'POS'
END
IF @Saldo < 0 AND @Ok IS NULL
BEGIN
SELECT @Saldo = 0
END
IF ISNULL(@Saldo,0) NOT BETWEEN (@ToleranciaRedondeo * (-1)) AND (@ToleranciaRedondeo) AND @MovClave NOT IN ('POS.P','POS.INVD', 'POS.INVA')
SELECT @Ok = 20370
IF NOT EXISTS(SELECT * FROM POSLVenta WHERE ID = @ID) AND @MovClave IN ('POS.N', 'POS.F', 'POS.A','POS.P','POS.NPC','POS.INVD', 'POS.INVA')
SELECT @Ok = 60010
END
IF @MovClave IN ('POS.AC', 'POS.ACM', 'POS.AP', 'POS.CAC', 'POS.CACM', 'POS.CC', 'POS.CCC', 'POS.CCCM', 'POS.CCM', 'POS.CPC', 'POS.CPCM',
'POS.CTCAC', 'POS.CTCM', 'POS.CTCRC', 'POS.CTRM', 'POS.EC', 'POS.FTE', 'POS.IC', 'POS.STE', 'POS.TCAC', 'POS.TCM', 'POS.TCM', 'POS.TCRC',
'POS.TRM','POS.FA' ) AND @OK IS NULL
BEGIN
SELECT @PuedeAutorizar = 1
FROM POSUsuarioMov pum
WHERE Usuario = ISNULL(NULLIF(@UsuarioPerfil,''),@Usuario)
AND Mov = @Mov
IF ISNULL(@PuedeAutorizar,0) = 0
SELECT @PuedeAutorizar = 1
FROM POSUsuarioMov pum
WHERE Usuario = ISNULL(NULLIF(@UsuarioAutorizaPerfil,''),@UsuarioAutoriza)
AND Mov = @Mov
IF ISNULL(@PuedeAutorizar,0) = 0
SELECT @Ok = 3
IF @CtaDinero IS NULL AND @Ok IS NULL
SELECT @Ok = 40120
IF @CtaDineroDestino IS NULL AND @Ok IS NULL AND @MovClave NOT IN ('POS.FA','POS.CXCC','POS.CXCD' )
SELECT @Ok = 40040
IF ISNULL(@ImporteCobro,0) < 0 AND @Ok IS NULL
SELECT @OK = 30100
IF @MovClave IN('POS.CXCC','POS.CXCD') AND @Ok IS NULL
BEGIN
SELECT TOP 1 @Aplica = Aplica, @AplicaID = AplicaID
FROM POSLVenta
WHERE ID = @ID
IF NULLIF(@Aplica,'') IS NULL OR NULLIF(@AplicaID,'')IS NULL
SELECT @Ok = 30210
END
IF NOT EXISTS(SELECT * FROM POSLCobro WHERE ID = @ID) AND @Ok IS NULL
SELECT @OK = 30100 , @OkRef = @OkRef +'Es Necesario Capturar Un Importe'
IF @MovClave IN ('POS.AC','POS.ACM','POS.CCC','POS.CCCM')
BEGIN
EXEC spPOSEstatusCaja @CtaDineroDestino, @Host, @Cajero, @Usuario,  1, NULL, @ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spPOSCambiarFechaEmision  @ID, @Empresa, @Sucursal, @Host, @Caja, @ok OUTPUT, @OkRef OUTPUT
END
IF @MovClave IN ('POS.CC','POS.CCM','POS.CAC','POS.CACM')
BEGIN
EXEC spPOSEstatusCaja @CtaDinero, @Host, @Cajero, @Usuario, 0, NULL,  @ok OUTPUT, @OkRef OUTPUT
IF EXISTS(SELECT * FROM POSCFDFlexPendiente)
SELECT @Ok = 35250, @OkRef = ' DE GENERAR CFD'
IF @Ok IS NULL
EXEC spPOSValidarCierresCaja @ID, @Empresa, @Sucursal, @Host, @Caja, @ok OUTPUT, @OkRef OUTPUT
END
IF @MovClave IN ('POS.CPC','POS.CPM','POS.FA','POS.AP','POS.CXCC','POS.CXCD' )
BEGIN
IF NOT EXISTS(SELECT * FROM POSEstatusCaja WHERE Caja = @Caja)
SELECT @Ok = 30440, @OkRef = @Caja
IF (SELECT Abierto FROM POSEstatusCaja WHERE Caja = @Caja) = 0
SELECT @Ok =30440, @OkRef = @Caja
END
IF @MovClave IN ('POS.TRM','POS.TCM' )
BEGIN
IF NOT EXISTS(SELECT * FROM POSEstatusCaja WHERE Caja = @CtaDineroDestino)
SELECT @Ok = 30440, @OkRef = @CtaDineroDestino
IF (SELECT Abierto FROM POSEstatusCaja WHERE Caja = @Caja) = 0 AND @iSyncNivel = 'Sucursal'
SELECT @Ok =30440, @OkRef = @Caja
END
IF @MovClave IN ('POS.CC','POS.CCM','POS.CAC','POS.CACM') AND @Ok IS NULL
BEGIN
SELECT @EsConcentradora = ISNULL(EsConcentradora,0) FROM CtaDinero WHERE CtaDinero = @CtaDinero
IF @MovClave IN ('POS.CC','POS.CCM') AND @Ok IS NULL
EXEC spPOSGeneraFaltante @Empresa, @Sucursal, @Usuario, @ID, @MovClave, @Caja, @Ok OUTPUT, @OkRef OUTPUT
END
END
IF @MovClave IN('POS.AC','POS.ACM','POS.AP')
SELECT @Caja = Caja FROM POSL WHERE ID = @ID
IF EXISTS (SELECT * FROM POSLDIRecargaTemp WHERE ID = @ID) AND @Ok IS NULL
BEGIN
EXEC spPOSLDIRecargaTelefonica @ID, @Ok OUTPUT, @OkRef OUTPUT
IF @OK IS NULL
SELECT @Mensaje = 'RECARGA EXITOSA  <BR>'
END
IF EXISTS (SELECT * FROM POSLDIPagoServicioTemp WHERE ID = @ID) AND @Ok IS NULL
BEGIN
EXEC spPOSLDIPagoServicio @ID, @Ok OUTPUT, @OkRef OUTPUT
IF @OK IS NULL
SELECT @Mensaje = 'PAGO EXITOSO  <BR>'
END
IF @MovClave IN ('POS.N', 'POS.A', 'POS.F', 'POS.AC','POS.AP', 'POS.CC', 'POS.CPC','POS.P','POS.ACM','POS.CCM','POS.CPCM',
'POS.TCM','POS.TCAC','POS.CTCAC', 'POS.CAC','POS.CACM','POS.CCC','POS.CCCM','POS.CTCM','POS.IC','POS.EC','POS.TRM',
'POS.CTRM','POS.CTCRC','POS.NPC','POS.FA','POS.INVD', 'POS.INVA','POS.CXCC','POS.CXCD' ) AND @OK IS NULL
BEGIN
IF @MovID IS NULL OR @Estatus IN ('PORCOBRAR', 'SINAFECTAR','PENDIENTE')
BEGIN
IF @MovID IS NULL
BEGIN
EXEC spPOSConsecutivoAuto @Empresa, @Sucursal, @Mov,
@MovID OUTPUT, @Prefijo OUTPUT, @Consecutivo OUTPUT, @noAprobacion OUTPUT, @FechaAprobacion OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
UPDATE POSL SET
MovID = ISNULL(MovID, @MovID),
Prefijo = ISNULL(Prefijo, @Prefijo),
Consecutivo = ISNULL(Consecutivo, @Consecutivo),
noAprobacion = ISNULL(noAprobacion, @NoAprobacion),
fechaAprobacion = ISNULL(fechaAprobacion, @fechaAprobacion),
Estatus = 'CONCLUIDO',
FechaEmision = @Fecha,
FechaRegistro = @FechaRegistro
WHERE ID = @ID
SELECT @IDDevolucion = NULLIF(IDDevolucion,''), @IDDevolucionP = NULLIF(IDDevolucionP,'') FROM POSL WHERE ID = @ID
UPDATE POSLCobro SET Importe = ImporteRef WHERE ID = @ID AND ImporteRef <> 0 AND Importe = 0
IF @IDDevolucion IS NOT NULL
BEGIN
UPDATE POSL SET Devolucion = 1 WHERE ID = @IDDevolucion
UPDATE POSLVenta SET CantidadSaldo = 0 WHERE ID = @IDDevolucion
END
IF @IDDevolucionP IS NOT NULL
BEGIN
DECLARE @Contador INT, @CantidadSaldoSum float
UPDATE POSL SET DevolucionP = 1 WHERE ID = @IDDevolucionP
DECLARE crSE1 CURSOR LOCAL FOR
SELECT Articulo, SUM(Cantidad), NULLIF(SubCuenta,'')
FROM POSLVenta
WHERE ID = @ID
GROUP BY  Articulo, NULLIF(SubCuenta,'')
OPEN crSE1
FETCH NEXT FROM crSE1 INTO @Articulo, @Cantidad, @SubCuenta
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Contador = COUNT (1), @CantidadSaldoSum = sum(isnull(CantidadSaldo,0))
FROM POSLVenta
WHERE ID = @IDDevolucionP AND Articulo = @Articulo AND NULLIF(SubCuenta,'') = @SubCuenta
SELECT @CantidadSaldoSum = (@CantidadSaldoSum + @Cantidad) / @Contador
UPDATE POSLVenta SET CantidadSaldo = @CantidadSaldoSum
WHERE ID = @IDDevolucionP AND Articulo = @Articulo AND NULLIF(SubCuenta,'') = @SubCuenta
END
FETCH NEXT FROM crSE1 INTO @Articulo, @Cantidad, @SubCuenta
END
CLOSE crSE1
DEALLOCATE crSE1
END
UPDATE POSLVenta SET CantidadSaldo = Cantidad WHERE ID = @ID
END
IF @MovClave IN('POS.INVD', 'POS.INVA')
BEGIN
INSERT POSLInv(
ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Aplica, AplicaID, Cantidad, Articulo, SubCuenta,
Unidad, Factor, CantidadInventario, Almacen, Codigo, Precio)
SELECT
ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Aplica, AplicaID, Cantidad, Articulo, SubCuenta,
Unidad, Factor, CantidadInventario, NULL, Codigo, Precio
FROM POSLVenta
WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
DELETE POSLVenta WHERE ID = @ID
END
DELETE POSLValidarDevolucion WHERE ID = @ID
END
IF @Ok IS NULL AND @MovClave IN ('POS.N', 'POS.A', 'POS.F','POS.P','POS.NPC','POS.INVD', 'POS.INVA') AND @OK IS NULL
BEGIN
SELECT @TotalImporte = SUM(dbo.fnPOSImporte(plv.Cantidad, plv.CantidadObsequio, plv.Precio, plv.DescuentoLinea,
CASE WHEN ISNULL(plv.AplicaDescGlobal, 1) = 1
THEN ISNULL(p.DescuentoGlobal,0.0)
ELSE 0
END, plv.Articulo, p.Empresa)),
@TotalImpuesto2 = SUM(dbo.fnPOSImporteMov(((plv.Cantidad  - ISNULL(plv.CantidadObsequio,0.0)) * ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) - ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) * (
CASE WHEN ISNULL(plv.AplicaDescGlobal, 1) = 1
THEN ISNULL(p.DescuentoGlobal,0.0)
ELSE 0
END)/100))),plv.Impuesto1,plv.Impuesto2,plv.Impuesto3,plv.Cantidad)),
@TotalImpuesto1 = CONVERT(money,CONVERT(varchar, CONVERT(money, ISNULL(@TotalImpuesto2,0.0)), 104))-@TotalImporte
FROM POSL p
INNER JOIN POSLVenta plv ON p.ID = plv.ID
WHERE plv.ID = @ID
SELECT @Condicion = NULLIF(Condicion,'')
FROM POSL
WHERE ID = @ID
UPDATE POSL Set Importe = ROUND(@TotalImporte,@RedondeoMonetarios), Impuestos = ROUND(@TotalImpuesto1,@RedondeoMonetarios)
WHERE ID = @ID
END
IF @Ok IS NULL AND @MovClave = 'POS.N' AND @MovSubClave = 'POS.PEDCONT'
IF NULLIF(@Condicion,'') IS NULL OR @Condicion NOT IN (SELECT Condicion FROM Condicion WHERE ControlAnticipos = 'Cobrar Pedido')
SELECT @Ok = 20880
IF @Ok IS NULL AND @MovClave = 'POS.P' AND @MovSubClave = 'POS.DEVCRED'
IF NULLIF(@Condicion,'') IS NULL OR @Condicion NOT IN (SELECT Condicion FROM Condicion WHERE TipoCondicion = 'Credito')
SELECT @Ok = 20700
IF @Ok IS NULL AND (@MovClave IN ('POS.F','POS.N')
AND (SELECT ISNULL(AnticipoFacturadoTipoServicio,0) FROM POSL WHERE ID = @ID)= 1)
OR (@MovClave  = 'POS.P' AND @MovSubClave = 'POS.FACCRED')OR (@MovClave  = 'POS.P' AND @MovSubClave = 'POS.DEVCRED')
BEGIN
IF @Ok IS NULL AND  @CxcLocal = 0
UPDATE POSL Set Estatus = 'CONFIRMAR'  WHERE ID = @ID
IF @MovClave IN ('POS.F','POS.N', 'POS.P') AND EXISTS(SELECT * FROM POSLCobro WHERE ID = @ID)
IF NOT EXISTS(SELECT * FROM POSVentaCobro WHERE ID = @ID)
EXEC spPOSInsertarPOSVentaCobro @ID, @Empresa,@Sucursal, @Ok OUTPUT, @OkRef OUTPUT
IF @MovClave IN ('POS.P') AND @MovSubClave = 'POS.FACCRED'
AND NOT EXISTS(SELECT * FROM POSVentaCobro WHERE ID = @ID) AND EXISTS (SELECT * FROM POSLCobro WHERE ID = @ID)
EXEC spPOSInsertarPOSVentaCobro @ID, @Empresa,@Sucursal, @Ok OUTPUT, @OkRef OUTPUT
IF @MovClave  = 'POS.P' AND @MovSubClave = 'POS.FACCRED'
DELETE POSCxcAnticipoTemp  WHERE Estacion = @Estacion
IF @OK IS NULL AND @CxcLocal = 0
EXEC spPOSWSSolicitudAfectarVenta  @ID, @Empresa, @Estacion, @Sucursal, @Usuario, @Ok OUTPUT, @OkRef OUTPUT
IF @OK IS NULL AND @CxcLocal = 1
EXEC spPOSSolicitudAfectarVentaLocal  @ID, @Empresa, @Estacion, @Sucursal, @Usuario, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND  @CxcLocal = 0 AND (@MovClave IN('POS.N')OR (@MovClave  = 'POS.P' AND @MovSubClave = 'POS.DEVCRED'))
UPDATE POSL Set Estatus = 'CONCLUIDO'  WHERE ID = @ID
IF @MovClave = 'POS.N' AND (SELECT ISNULL(AnticipoFacturadoTipoServicio,0) FROM POSL WHERE ID = @ID)= 1
UPDATE POSL Set Estatus = 'TRASPASADO' WHERE ID = @ID
IF @Ok IS NULL AND  @CxcLocal = 1 AND @MovClave IN('POS.N')
UPDATE POSL Set AfectadoLocal = 1  WHERE ID = @ID
IF @Ok IS NULL AND @MovClave IN('POS.F','POS.P')
SET  @AfectadoEnLinea  = 1
END
IF (@MovClave = 'POS.F' OR (@MovClave  = 'POS.P' AND @MovSubClave = 'POS.FACCRED')) AND @OK IS NULL
BEGIN
SELECT @GenerarCFD = 1
END
IF @Ok IS NULL AND @MovClave IN ('POS.AC', 'POS.ACM', 'POS.AP', 'POS.CAC', 'POS.CACM', 'POS.CC', 'POS.CCC', 'POS.CCCM', 'POS.CCM',
'POS.CPC', 'POS.CPCM', 'POS.CTCAC', 'POS.CTCM', 'POS.CTCRC', 'POS.CTRM', 'POS.EC', 'POS.FTE', 'POS.IC', 'POS.STE', 'POS.TCAC',
'POS.TCM', 'POS.TCM', 'POS.TCRC', 'POS.TRM') AND @OK IS NULL
BEGIN
SELECT @TotalImporte = SUM(c.Importe)
FROM POSL p
INNER JOIN POSLCobro c ON p.ID = c.ID
WHERE c.ID = @ID
IF @MovSubClave = 'POS.FACCRED' AND @CxcLocal = 0
UPDATE POSL Set Estatus = 'TRASPASADO' WHERE ID = @ID
UPDATE POSL Set Importe = ROUND(@TotalImporte,@RedondeoMonetarios) WHERE ID = @ID
END
IF @MovClave IN ('POS.TCM','POS.CTCM') AND @Ok IS NULL
EXEC spPOSGeneraAbonoCaja @Empresa, @Sucursal, @Usuario, @ID, @MovClave, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @MovClave IN ('POS.TRM','POS.CTRM' )
EXEC spPOSGeneraRetiroCaja @Empresa, @Sucursal, @Usuario, @ID, @MovClave, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
INSERT POSLAuxiliar (
IDL, ID, Rama, FormaPago, Importe, Referencia, EsCancelacion)
SELECT
NEWID(), ID, 'CAJA', FormaPago, Importe, Referencia, 0
FROM POSLCobro
WHERE ID = @ID
IF EXISTS(SELECT * FROM POSLPorCobrar WHERE ID = @IDR AND Estatus = 'PORCOBRAR')
UPDATE 	POSLPorCobrar SET Estatus = 'TRASPASADO' WHERE ID = @IDR
IF @Ok IS NULL
BEGIN
IF EXISTS(SELECT * FROM POSL p JOIN MovTipo m ON m.Mov = p.Mov AND m.Modulo = 'POS'
WHERE m.Clave = 'POS.NPC' AND p.Estatus = 'PORCOBRAR' AND p.ID IN (SELECT ID FROM POSLPorCobrar WHERE Estatus = 'TRASPASADO'))
UPDATE POSL SET Estatus = 'TRASPASADO'
FROM POSL p JOIN MovTipo m ON m.Mov = p.Mov AND m.Modulo = 'POS'
WHERE m.Clave = 'POS.NPC' AND p.Estatus = 'PORCOBRAR' AND p.ID IN (SELECT ID FROM POSLPorCobrar WHERE Estatus = 'TRASPASADO')
END
DELETE FROM POSLArtSeleccionado WHERE ID = @ID
EXEC spPOSMovNuevo @Empresa, @Modulo, @Sucursal, @Usuario, @Estacion, @ID OUTPUT, @Imagen OUTPUT, @IDImpresion
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
SELECT @Mensaje = ISNULL(@Mensaje,'')+'MOVIMIENTO CONCLUIDO CON EXITO'
IF @MovClave IN('POS.N','POS.F','POS.NPC')
BEGIN
SELECT @ImporteEnCaja = SUM((plc.Importe*plc.TipoCambio) * mt.Factor)
FROM POSLCobro plc
INNER JOIN POSL p ON plc.ID = p.ID
INNER JOIN MovTipo mt ON p.Mov = mt.Mov  AND mt.Modulo = 'POS'
JOIN FormaPago f ON plc.FormaPago = f.FormaPago
WHERE f.Recoleccion = 1
AND (CASE WHEN mt.Clave IN('POS.AC','POS.AP','POS.ACM','POS.IC','POS.EC')
THEN p.CtaDineroDestino
ELSE plc.Caja
END) = @Caja
IF ISNULL(@ImporteEnCaja,0.0) >= @LimiteCaja AND @MensajeLimiteCaja = 1
SELECT @Mensaje = @Mensaje +' , '+ UPPER(@MensajeLimiteCajaT)
END
END
IF @MovClave IN ('POS.CXCC') AND @Ok IS NULL
EXEC xpPOSConcluirCobroCredito @IDImpresion, @Empresa
IF @MovClave IN ('POS.CC', 'POS.CCM')
EXEC spPOSMovEliminarNoc @Usuario
IF @Ok IS NULL
BEGIN
DELETE FROM POSLArtSeleccionado WHERE ID = @ID
IF @MovClave IN ('POS.N') AND @GenerarEmbarques = 1 AND NULLIF(@POSDefMovEmbarque,'') IS NOT NULL AND @Ok IS NULL
BEGIN
EXEC spPOSGeneraEstadisticoEmbarque @Empresa, @Modulo, @Sucursal, @Usuario, @Estacion, @IDEst, @IDEst, @POSDefMovEmbarque, @ContMoneda, @ContMonedaTC, @ArticuloTarjeta, @AlmacenTarjeta, @VentaPreciosImpuestoIncluido, @Ok OUTPUT, @OkRef OUTPUT
END
SELECT TOP 1 @ReporteImpresora = ecmi.ReporteImpresora
FROM EmpresaCfgMovImp ecmi
WHERE Modulo = 'POS'
AND Mov = @Mov
AND Empresa = @Empresa
/***** SE ENVIA DOS VECES LA IMPRESION DE LOS CORTES Y APERTURAS DE CAJA*****/
IF @MovClave IN ('POS.AC', 'POS.ACM', 'POS.AP', 'POS.CAC', 'POS.CACM', 'POS.CC', 'POS.CCC', 'POS.CCCM', 'POS.CCM', 'POS.CPC', 'POS.CPCM',
'POS.CTCAC', 'POS.CTCM', 'POS.CTCRC', 'POS.CTRM', 'POS.EC', 'POS.FTE', 'POS.IC', 'POS.STE', 'POS.TCAC', 'POS.TCM', 'POS.TCM', 'POS.TCRC',
'POS.TRM','POS.P') AND NULLIF(@ReporteImpresora,'') IS NOT NULL
SELECT @Expresion = 'ReporteImpresora(''' +@ReporteImpresora +''', ''' + @IDImpresion + ''')'+'ReporteImpresora(''' +
@ReporteImpresora +''', ''' + @IDImpresion + ''')'
IF @MovClave NOT IN ('POS.AC', 'POS.ACM', 'POS.AP', 'POS.CAC', 'POS.CACM', 'POS.CC', 'POS.CCC', 'POS.CCCM', 'POS.CCM', 'POS.CPC', 'POS.CPCM',
'POS.CTCAC', 'POS.CTCM', 'POS.CTCRC', 'POS.CTRM', 'POS.EC', 'POS.FTE', 'POS.IC', 'POS.STE', 'POS.TCAC', 'POS.TCM', 'POS.TCM', 'POS.TCRC',
'POS.TRM', 'POS.P') AND NULLIF(@ReporteImpresora,'') IS NOT NULL
SELECT @Expresion = 'ReporteImpresora(''' +@ReporteImpresora +''', ''' + @IDImpresion + ''')'
END
END

