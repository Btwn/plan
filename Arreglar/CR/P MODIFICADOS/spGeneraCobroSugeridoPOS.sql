SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGeneraCobroSugeridoPOS
@Modulo			char(5),
@ID				int,
@Usuario		varchar(10),
@Estacion		int,
@Ok				int OUTPUT,
@OkRef			varchar(255)OUTPUT

AS
BEGIN
DECLARE
@Empresa					char(5),
@Sucursal					int,
@Hoy						datetime,
@Moneda						char(10),
@TipoCambio					float,
@Renglon					float,
@Aplica						varchar(20),
@AplicaID					varchar(20),
@AplicaMovTipo				varchar(20),
@Importe					money,
@SumaImporte				money,
@Impuestos					money,
@DesglosarImpuestos			bit,
@IDDetalle					int,
@IDCxc						int,
@ImporteReal				money,
@ImporteAPagar				money,
@ImporteMoratorio			money,
@ImporteACondonar			money,
@MovGenerar					varchar(20),
@UEN						int,
@ImporteTotal				money,
@Mov						varchar(20),
@MovID						varchar(20),
@MovPadre					varchar(20),
@Cliente					varchar(10),
@CteMoneda					varchar(10),
@CteTipoCambio				float,
@FechaAplicacion			datetime,
@ClienteEnviarA				int,
@TotalMov					money,
@CampoExtra					varchar(50),
@Consecutivo				varchar(20),
@ValorCampoExtra			varchar(255),
@Concepto					varchar(50),
@MoratorioAPagar			money,
@MovIDGen					varchar(20),
@MovCobro					varchar(20),
@GeneraNC					char(1),
@Origen						varchar(20),
@OrigenID					varchar(20),
@Impuesto					money,
@DefImpuesto				float,
@ImporteDoc					money,
@Bonificacion				money,
@MovIDGenerado				varchar(20),
@TotalAPagar				money,
@IDCargoMor					int,
@InteresPorPolitica			money,
@MovIDCgo					varchar(20),
@IDPadre					int,
@SaldoIniDia				money,
@PorcAbonoCapital			float,
@PorcMoratorioBonificar		float,
@TotalMoratorio				money,
@MoratorioBonificado		money,
@MoratorioXPagar			money,
@TotalCobrosDia				money,
@PorcIntaBonificar			float,
@PorcPAgoCapital			float,
@Nota						varchar(100),
@CobroxPolitica				int,
@MoratoriosaBonificar		money,
@VencimientoMasAntiguo		datetime,
@IDCargoMorEst				int,
@IdCargoMoratorio			int,
@IdCargoMoratorioEst		int,
@SaldoNCPend				money,
@SaldoEstPend				money,
@EstatusNCEst				varchar(15),
@EstatusNC					varchar(15),
@IDUltCobro					int,
@TotalMoratUltCob			money,
@EstatusCargoMor			varchar(15),
@EstatusCargoMorEst			varchar(15),
@TotalBonificacion			money
SET @CobroxPolitica = 0
SELECT @CteMoneda = ClienteMoneda, @CteTipoCambio = ClienteTipoCambio, @Cliente = Cliente, @FechaAplicacion = dbo.fnFechaSinHora(FechaEmision)
FROM CXC
WITH(NOLOCK) WHERE ID = @ID
SELECT @CobroxPolitica = ISNULL(TipoCobro,0)
FROM TipoCobroMAVI
WITH(NOLOCK) WHERE IdCobro = @ID
SELECT @DesglosarImpuestos = 0 , @Renglon = 0.0, @SumaImporte = 0.0, @ImporteTotal = NULLIF(@ImporteTotal, 0.0)
SELECT @Renglon = 1024.0
SELECT @GeneraNC = '1'
IF not exists(SELECT * FROM NegociaMoratoriosMAVI WITH(NOLOCK) WHERE IDCobro = @ID)
BEGIN
SELECT 'No hay sugerencia a cobrar..'
RETURN
END
IF @Modulo = 'CXC'
BEGIN
UPDATE CXC  WITH(ROWLOCK) SET AplicaManual = 1 WHERE id = @ID
SELECT @Empresa = Empresa, @Sucursal = Sucursal, @Hoy = FechaEmision, @Moneda = Moneda, @TipoCambio = TipoCambio,
@ClienteEnviarA = ClienteEnviarA, @MovCobro = Mov
FROM Cxc
WITH(NOLOCK) WHERE ID = @ID
DELETE CxcD WHERE ID = @ID
DELETE DetalleAfectacionMAVI WHERE IDCobro = @ID
EXEC spGeneraNCredPPMAVI @ID, @Usuario, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spGeneraNCredNAMAVI @ID, @Usuario, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spGeneraNCredAPMAVI @ID, @Usuario, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spGeneraNCredBonifMAVI @ID, @Usuario, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
DECLARE crDetalle CURSOR FAST_FORWARD FOR
SELECT SUM(ISNULL(MoratorioAPagar,0) - ISNULL(ImporteACondonar,0)), Origen, OrigenID
FROM NegociaMoratoriosMAVI
WITH(NOLOCK) WHERE IDCobro = @ID
AND Estacion = @Estacion AND MoratorioAPagar > 0
GROUP BY Origen, OrigenID
OPEN crDetalle
FETCH NEXT FROM crDetalle  INTO  @ImporteMoratorio, @Origen, @OrigenID
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2 AND @OK IS NULL
BEGIN
SELECT @UEN = UEN, @ClienteEnviarA = ClienteEnviarA FROM CXC WITH(NOLOCK) WHERE Mov = @Origen AND MovId = @OrigenID
IF @ImporteMoratorio > 0
BEGIN
SELECT @MovGenerar = dbo.fnMaviObtieneMovSaldoMoratorios(@Origen,'Moratorios', @UEN)
IF @MovGenerar Is NULL
SELECT @MovGenerar = 'Nota Cargo'
IF @MovGenerar = 'Endoso'
SELECT @MovGenerar = 'Nota Cargo'
SELECT @DefImpuesto = 1 + ISNULL(DefImpuesto,15.0)/100
FROM EmpresaGral
WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @Importe = @ImporteMoratorio/@DefImpuesto
SELECT @Impuesto = @ImporteMoratorio - @Importe
IF @MovGenerar in ( 'Nota Cargo', 'Nota Cargo VIU')
SELECT @Concepto = 'MORATORIOS MENUDEO'
IF @MovGenerar = 'Nota Cargo Mayoreo'
SELECT @Concepto = 'MORATORIOS MAYOREO'
IF @GeneraNC = '1'
BEGIN
INSERT INTO Cxc(
Empresa, Mov, MovID, FechaEmision, Concepto, UltimoCambio, Moneda, TipoCambio,
Usuario, Referencia, Estatus, Cliente, ClienteEnviarA, ClienteMoneda, ClienteTipoCambio, Vencimiento,
Importe, Impuestos, AplicaManual, ConDesglose, Saldo, ConTramites, VIN, Sucursal, SucursalOrigen, UEN,
PersonalCobrador, FechaOriginal, Nota, Comentarios, LineaCredito, TipoAmortizacion, TipoTasa, Amortizaciones,
Comisiones, ComisionesIVA, FechaRevision, ContUso, TieneTasaEsp, TasaEsp, Codigo)
VALUES(
@Empresa, @MovGenerar, NULL, dbo.fnFechaSinHora(@FechaAplicacion), @Concepto, @FechaAplicacion, @Moneda, @TipoCambio,
@Usuario, null, 'SINAFECTAR',  @Cliente, @ClienteEnviarA, @Moneda, @TipoCambio, @FechaAplicacion,
@Importe, @Impuesto, 0, 0, ISNULL(@Importe,0) + ISNULL(@Impuesto,0), 0, NULL, @Sucursal, @Sucursal, @UEN,
NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL,
NULL, NULL, NULL, 0, NULL, NULL)
SELECT @IDCxc = SCOPE_IDENTITY()
EXEC spAfectar 'CXC', @IDCxc, 'AFECTAR', 'Todo', NULL, @Usuario,  NULL, 1, @Ok OUTPUT, @OkRef OUTPUT,NULL, @Conexion =  1
INSERT INTO DetalleAfectacionMAVI(
IDCobro, ID, Mov, MovID, ValorOK, ValorOKRef)
VALUES(
@ID, @IDCxc, @MovGenerar, @MovIDGen, @Ok, @OkRef)
UPDATE NegociaMoratoriosMAVI
 WITH(ROWLOCK) SET NotaCargoMorId = @IDCxc
WHERE IDCobro = @ID AND Estacion = @Estacion AND MoratorioAPagar > 0
AND Origen = @Origen AND OrigenID = @OrigenId
SELECT @MovIDGen = MovId
FROM CXC
WITH(NOLOCK) WHERE ID = @IDCxc
INSERT CxcD (
ID, Sucursal, Renglon, Aplica, AplicaID, Importe, InteresesOrdinarios, InteresesMoratorios, ImpuestoAdicional)
VALUES (
@ID, @Sucursal, @Renglon, @MovGenerar, @MovIDGen, NULLIF(@ImporteMoratorio, 0.0), 0.0, 0.0, 0.0)
SELECT @Renglon = @Renglon + 1024.0
IF @Ok = 80030
SELECT @Ok = NULL
IF @Ok IS NULL
BEGIN
IF NOT EXISTS(SELECT * FROM MovCampoExtra WITH(NOLOCK) WHERE Modulo = @Modulo AND Mov = @MovGenerar AND ID = @IDCxc)
BEGIN
SELECT @AplicaId  = MovId
FROM CXC
WITH(NOLOCK) WHERE ID = @IDCxc
IF @MovGenerar = 'Nota Cargo'
SELECT @CampoExtra = 'NC_FACTURA'
IF @MovGenerar = 'Nota Cargo VIU'
SELECT @CampoExtra = 'NCV_FACTURA'
IF @MovGenerar = 'Nota Cargo Mayoreo'
SELECT @CampoExtra = 'NCM_FACTURA'
SELECT @ValorCampoExtra =  RTRIM(@Origen)+'_'+RTRIM(@OrigenId)
IF  @MovGenerar in ('Nota Cargo', 'Nota Cargo VIU', 'Nota Cargo Mayoreo')
INSERT INTO MovCampoExtra (
Modulo, Mov, ID, CampoExtra, Valor)
VALUES(
'CXC', @MovGenerar, @IDCxc, @CampoExtra, @ValorCampoExtra)
END
END
END
END
END
FETCH NEXT FROM crDetalle  INTO  @ImporteMoratorio, @Origen, @OrigenID
END
CLOSE crDetalle
DEALLOCATE crDetalle
DECLARE crDoc CURSOR FAST_FORWARD FOR
SELECT Mov, MovID, ImporteReal, ImporteAPagar, ImporteMoratorio, ImporteACondonar, Bonificacion, TotalAPagar
FROM NegociaMoratoriosMAVI WITH(NOLOCK)
WHERE  IDCobro = @ID AND Estacion = @Estacion AND ImporteAPagar > 0
OPEN crDoc
FETCH NEXT FROM crDoc  INTO @Mov, @MovID, @ImporteReal, @ImporteAPagar, @ImporteMoratorio, @ImporteACondonar, @Bonificacion, @TotalAPagar
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2 AND @OK IS NULL
BEGIN
SELECT  @ImporteDoc =  ISNULL(@ImporteAPagar,0) - ISNULL(@Bonificacion,0)
IF @ImporteDoc > 0
BEGIN
INSERT CxcD (
ID, Sucursal, Renglon, Aplica, AplicaID, Importe, InteresesOrdinarios, InteresesMoratorios, ImpuestoAdicional)
VALUES (
@ID, @Sucursal, @Renglon, @Mov, @MovID, NULLIF(@ImporteDoc, 0.0), 0.0, 0.0, 0.0)
SELECT @Renglon = @Renglon + 1024.0
END
END
FETCH NEXT FROM crDoc  INTO @Mov, @MovID, @ImporteReal, @ImporteAPagar, @ImporteMoratorio, @ImporteACondonar, @Bonificacion, @TotalAPagar
END
CLOSE crDoc
DEALLOCATE crDoc
IF @CobroxPolitica = 1
BEGIN
UPDATE CXC  WITH(ROWLOCK) SET Concepto = 'POLITICA QUITA MORATORIOS'
WHERE ID = @ID
SELECT @InteresPorPolitica = MIN(InteresPorPolitica)
FROM NegociaMoratoriosMAVI
WITH(NOLOCK) WHERE IDCobro = @ID AND InteresPorPolitica > 0
SELECT @Origen = Origen, @OrigenID = OrigenID
FROM NegociaMoratoriosMAVI
WITH(NOLOCK) WHERE IDCobro = @ID
GROUP BY Origen, OrigenID
SELECT @IDPadre = ID, @UEN = UEN, @ClienteEnviarA = ClienteEnviarA
FROM CXC
WITH(NOLOCK) WHERE  Mov = @Origen AND MovID = @OrigenID
SELECT @ImporteTotal = SUM(ISNULL(ImporteAPagar,0))
FROM NegociaMoratoriosMAVI
WITH(NOLOCK) WHERE IDCobro = @ID
IF NOT EXISTS(SELECT * FROM  CobroXPoliticaHistMAVI WITH(NOLOCK) WHERE Mov = @Origen AND MovID = @OrigenID
AND CONVERT(varchar(8),FechaEmision,112) =  CONVERT(varchar(8),@FechaAplicacion,112) AND EstatusCobro = 'CONCLUIDO')
BEGIN
SET @TotalBonificacion = 0
SELECT @TotalBonificacion = SUM(ISNULL(Bonificacion,0))
FROM NegociaMoratoriosMAVI
WITH(NOLOCK) WHERE IDCobro = @ID
SELECT @SaldoIniDia = dbo.fnSaldoPMMAVI(@IDPadre) + ISNULL(@TotalBonificacion,0)
SELECT @TotalCobrosDia = @ImporteTotal
END
ELSE
BEGIN
SELECT TOP 1 @SaldoIniDia = SaldoInicioDelDia
FROM CobroXPoliticaHistMAVI
WITH(NOLOCK) WHERE Mov = @Origen AND MovID = @OrigenID
AND CONVERT(varchar(8),FechaEmision,112) = CONVERT(varchar(8),@FechaAplicacion,112) AND EstatusCobro = 'CONCLUIDO'
ORDER BY IDCobro ASC
SELECT @TotalCobrosDia = SUM(ImporteCobro) + ISNULL(@ImporteTotal,0)
FROM CobroXPoliticaHistMAVI
WITH(NOLOCK) WHERE Mov = @Origen AND MovID = @OrigenID
AND CONVERT(varchar(8),FechaEmision,112) =  CONVERT(varchar(8),@FechaAplicacion,112)
AND EstatusCobro = 'CONCLUIDO'
SELECT @IdCargoMoratorioEst = 0
SELECT TOP 1 @IDUltCobro = idCobro, @PorcMoratorioBonificar = PorcMoratorioBonificar,
@IdCargoMoratorioEst = IdCargoMoratorioEst, @TotalMoratUltCob = TotalMoratorio
FROM CobroXPoliticaHistMAVI
WITH(NOLOCK) WHERE Mov = @Origen AND MovID = @OrigenID
AND CONVERT(varchar(8),FechaEmision,112) = CONVERT(varchar(8),@FechaAplicacion,112) AND EstatusCobro = 'CONCLUIDO'
ORDER BY IDCobro DESC
SELECT @InteresPorPolitica = @TotalMoratUltCob
IF @PorcMoratorioBonificar <= 100
BEGIN
SELECT @SaldoEstPend = ISNULL(Importe,0) + ISNULL(Impuestos,0), @EstatusNCEst = Estatus
FROM CXC
WITH(NOLOCK) WHERE ID = @IdCargoMoratorioEst
IF @IdCargoMoratorioEst > 0
BEGIN
EXEC spAfectar 'CXC', @IdCargoMoratorioEst, 'CANCELAR', 'Todo', NULL, @Usuario,  NULL, 1,
@Ok OUTPUT, @OkRef OUTPUT,NULL, @Conexion =  1
UPDATE CobroxPoliticaHistMAVI
 WITH(ROWLOCK) SET EstatusCargoMorEst = 'CANCELADO'
WHERE IdCargoMoratorioEst = @IdCargoMoratorioEst
END
END
END
IF @SaldoIniDia > 0
SELECT @PorcAbonoCapital = (@TotalCobrosDia / @SaldoIniDia)*100.0
SELECT @PorcIntaBonificar = 0
SELECT TOP 1 @PorcIntaBonificar = ISNULL(Valor,0)
FROM TablaNumD
WITH(NOLOCK) WHERE TablaNum = 'CFG QUITA MORATORIOS' AND @PorcAbonoCapital >= Numero
ORDER BY Valor DESC
SELECT @Nota = NULL
IF @PorcIntaBonificar > 0.0
BEGIN
SELECT @PorcMoratorioBonificar = ISNULL(@InteresPorPolitica,0) - (ISNULL(@InteresPorPolitica,0) * (ISNULL(@PorcIntaBonificar,0)/100.0))
SELECT @MoratorioXPagar = @PorcMoratorioBonificar
SELECT @MoratoriosaBonificar =  ISNULL(@InteresPorPolitica,0) - ISNULL(@PorcMoratorioBonificar,0)
SELECT @Nota = 'IM Bonificado:' + CONVERT(Varchar(20), @MoratoriosaBonificar)
END
ELSE
BEGIN
UPDATE NegociaMoratoriosMAVI  WITH(ROWLOCK) SET InteresAPAgarConPolitica = 0 WHERE IDCobro = @ID
SELECT @Nota = 'IM Bonificado: 0'
SELECT @MoratoriosaBonificar = 0
SELECT @MoratorioXPagar =  ISNULL(@InteresPorPolitica,0) - ISNULL(@PorcMoratorioBonificar,0)
END
SELECT @EstatusCargoMorEst = NULL
IF @InteresPorPolitica > 0 AND @PorcIntaBonificar > 0 AND @PorcIntaBonificar <= 100
BEGIN
SELECT @EstatusCargoMorEst = 'CONCLUIDO'
INSERT INTO Cxc(
Empresa, Mov, MovID, FechaEmision, Concepto, UltimoCambio, Moneda, TipoCambio,
Usuario, Referencia, Estatus, Cliente, ClienteEnviarA, ClienteMoneda, ClienteTipoCambio,
Condicion, Vencimiento, Importe, Impuestos, AplicaManual, ConDesglose, Saldo,
ConTramites, VIN, Sucursal, SucursalOrigen, UEN, PersonalCobrador, FechaOriginal, Nota, Comentarios,
LineaCredito, TipoAmortizacion, TipoTasa, Amortizaciones, Comisiones, ComisionesIVA,
FechaRevision, ContUso, TieneTasaEsp, TasaEsp, Codigo, PadreMAVI, PadreIDMAVI, IDPadreMAVI)
VALUES(
@Empresa, 'Cargo Moratorio Est', NULL, @FechaAplicacion, @Concepto, @FechaAplicacion, @Moneda, @TipoCambio,
@Usuario, null, 'SINAFECTAR',  @Cliente, @ClienteEnviarA, @Moneda, @TipoCambio,
'(Fecha)', @FechaAplicacion, @MoratoriosaBonificar, @Impuesto, 0, 0, ISNULL(@MoratoriosaBonificar,0) + ISNULL(@Impuesto,0),
0, NULL, @Sucursal, @Sucursal, @UEN, NULL, NULL, @Nota, '',
NULL, NULL, NULL, NULL, NULL, NULL,
NULL, NULL, 0, NULL, NULL, 'Cargo Moratorio Est', NULL, @IDPadre)
SELECT @IDCargoMorEst = @@IDENTITY
EXEC spAfectar 'CXC', @IDCargoMorEst, 'AFECTAR', 'Todo', NULL, @Usuario,  NULL, 1, @Ok OUTPUT, @OkRef OUTPUT,NULL, @Conexion =  1
SELECT @MovIDCgo = MovId
FROM CXC
WITH(NOLOCK) WHERE ID = @IDCargoMorEst
UPDATE Cxc  WITH(ROWLOCK) SET PadreIDMAVI = @MovIDCgo WHERE ID = @IDCargoMorEst
INSERT INTO DetalleAfectacionMAVI(
IDCobro, ID, Mov, MovID, ValorOK, ValorOKRef)
VALUES(
@ID, @IDCargoMorEst, 'Cargo Moratorio Est', @MovIDGen, @Ok, @OkRef)
IF NOT EXISTS(SELECT * FROM MovCampoExtra WITH(NOLOCK) WHERE Modulo = @Modulo AND Mov = 'Cargo Moratorio Est' AND ID = @IDCargoMorEst)
BEGIN
SELECT @CampoExtra = 'CM_FACTURA'
SELECT @ValorCampoExtra =  RTRIM(@Origen)+'_'+RTRIM(@OrigenId)
INSERT INTO MovCampoExtra (
Modulo, Mov, ID, CampoExtra, Valor)
VALUES(
'CXC', 'Cargo Moratorio Est', @IDCargoMorEst, @CampoExtra, @ValorCampoExtra)
END
SELECT @VencimientoMasAntiguo = MIN(Vencimiento)
FROM Cxc
WITH(NOLOCK) WHERE PadreMAVI = @Origen AND PadreIDMAVI = @OrigenID
AND Estatus = 'PENDIENTE'
IF @VencimientoMasAntiguo IS NULL
SELECT @VencimientoMasAntiguo = @FechaAplicacion
END
INSERT INTO CobroXPoliticaHistMAVI (
IdCobro, FechaEmision, EstatusCobro, ImporteCobro, Cliente, Mov, MovID,
SaldoIniciodelDia, TotalCobrosdelDia, PorcAbonoCapital, PorcMoratorioBonificar, TotalMoratorio,
MoratorioBonificado, MoratorioXPagar, IdCargoMoratorioEst, EstatusCargoMorEst)
VALUES(
@ID, @FechaAplicacion, 'SINAFECTAR', @ImporteTotal, @Cliente, @Origen, @OrigenID,
@SaldoIniDia, @TotalCobrosDia, @PorcAbonoCapital, @PorcIntaBonificar, @InteresPorPolitica,
ISNULL(@MoratoriosaBonificar,0), ISNULL(@MoratorioXPagar,0), ISNULL(@IDCargoMorEst,0), @EstatusCargoMorEst)
END
SELECT @Impuestos = SUM(d.importe*isnull(ca.IVAFiscal,0))
FROM CXCD d
 WITH(NOLOCK) JOIN CxcAplica ca  WITH(NOLOCK) ON d.Aplica = ca.Mov AND d.AplicaID = ca.MovID AND ca.Empresa = @Empresa
WHERE d.ID = @ID
SELECT @TotalMov = SUM(d.Importe-isnull(d.Importe*ca.IVAFiscal,0))
FROM CXCD d
 WITH(NOLOCK) JOIN CxcAplica ca  WITH(NOLOCK) ON d.Aplica = ca.Mov AND d.AplicaID = ca.MovID AND ca.Empresa = @Empresa
WHERE d.ID = @ID
UPDATE CXC  WITH(ROWLOCK) SET Importe = isnull(ROUND(@TotalMov,2),0.00),
Impuestos = isnull(ROUND(@Impuestos,2),0.00),
Saldo = isnull(ROUND(@TotalMov,2),0.00) + isnull(ROUND(@impuestos,2),0.00)
WHERE ID = @ID
EXEC spAfectar 'CXC', @ID, 'AFECTAR', 'Todo', NULL, @Usuario,  NULL, 1, @Ok OUTPUT, @OkRef OUTPUT,NULL, @Conexion = 1
SELECT @MovIDGenerado = MovID FROM CXC WITH(NOLOCK) WHERE ID = @ID
UPDATE CXC  WITH(ROWLOCK) SET Referencia = RTRIM(@MovCobro)+'_'+RTRIM(@MovIDGenerado)
WHERE IDCobroBonifMAVI = @ID
IF @IDCargoMorEst > 0
UPDATE CXC  WITH(ROWLOCK) SET Referencia = RTRIM(@MovCobro)+'_'+RTRIM(@MovIDGenerado)
WHERE ID = @IDCargoMorEst
END
IF @Ok IS NOT NULL AND @Ok NOT IN (80030)
BEGIN
SELECT  @OkRef = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
END
RETURN
END
END

