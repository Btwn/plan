SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDineroAfectar
@ID                		int,
@Accion			char(20),
@Empresa	      		char(5),
@Modulo	      		char(5),
@Mov	  	      		char(20),
@MovID             		varchar(20)  OUTPUT,
@MovTipo     		char(20),
@MovMoneda	      		char(10),
@MovTipoCambio	      	float,
@FechaEmision      		datetime,
@FechaAfectacion		datetime,
@FechaConclusion	 	datetime,
@Concepto	      		varchar(50),
@Proyecto	      		varchar(50),
@Usuario	      		char(10),
@Autorizacion      		char(10),
@Referencia	      		varchar(50),
@DocFuente	      		int,
@Observaciones     		varchar(255),
@Estatus           		char(15),
@EstatusNuevo	      	char(15),
@FechaRegistro     		datetime,
@Ejercicio	      		int,
@Periodo	      		int,
@CtaDinero			char(10),
@CtaDineroTipo		char(20),
@CtaDineroDestino		char(10),
@CtaDineroFactor		float,
@CtaDineroTipoCambio		float,
@CtaDineroMoneda		char(10),
@CtaDineroDestinoMoneda	char(10),
@TipoCambioDestino		float,
@Cajero		 	char(10),
@FormaPago			varchar(50),
@IVAFiscal			float,
@IEPSFiscal			float,
@Importe   			money,
@Impuestos	        	money,
@Saldo			money,
@Dias			int,
@TasaDiaria			float,
@Retencion			money,
@CfgInversionIntereses	varchar(20),
@InteresTipo			varchar(20),
@Titulo			varchar(10),
@TituloValor			float,
@ValorOrigen			float,
@Contacto			char(10),
@ContactoTipo		varchar(20),
@ContactoEnviarA		int,
@Directo			bit,
@ConDesglose                 bit,
@AutoConciliar		bit,
@OrigenTipo			varchar(20),
@OrigenMov			varchar(20),
@OrigenMovID			varchar(20),
@OrigenMovTipo		varchar(20),
@Conexion			bit,
@SincroFinal			bit,
/*@Verificar			bit,*/
@Sucursal			int,
@SucursalDestino		int,
@SucursalOrigen		int,
@GenerarGasto		bit,
@CfgCajeros			bit,
@CfgAutoFaltanteSobrante	bit,
@CfgSobregiros		bit,
@CfgAfectarComision		bit,
@CfgAfectarComisionIVA	bit,
@CfgContX			bit,
@CfgContXGenerar		char(20),
@CfgEmbarcar			bit,
@GenerarPoliza		bit,
@Utilizar			bit,
@UtilizarID			int,
@UtilizarMov			char(20),
@UtilizarMovTipo		char(20),
@UtilizarMovID		varchar(20),
@Generar                     bit,
@GenerarMov                  char(20),
@GenerarAfectado		bit,
@GenerarAfectando		bit,
@GenerarCopia		bit,
@IDGenerar			int	     OUTPUT,
@GenerarMovID	  	varchar(20)  OUTPUT,
@Ok                		int          OUTPUT,
@OkRef             		varchar(255) OUTPUT,
@EstacionTrabajo int = NULL 

AS BEGIN
DECLARE
@Comision		 money,
@ComisionIVA	 money,
@ComisionImpuestos	 money,
@Comision2		 money,
@Comision2IVA	 money,
@Comision2Impuestos	 money,
@ImporteTotal	 money,
@Intereses		 money,
@NuevoPendiente      float,
@CtaDineroImporte    money,
@CtaDineroIntereses  money,
@CtaDineroSaldo	 money,
@SaldoNuevo	         money,
@FechaCancelacion	 datetime,
@EsCargo		 bit,
@GenerarEstatus	 char(15),
@Serie		 char(20),
@GenerarPolizaTemp	 bit,
@DineroMov		 char(20),
@DineroMovID	 varchar(20),
@ComisionMov	 char(20),
@ComisionMovIVA	 char(20),
@ComisionMovID	 varchar(20),
@Comision2Mov	 char(20),
@Comision2MovIVA	 char(20),
@UltimoID		 int,
@CajeroActual	 char(10),
@CxID		 int,
@CxModulo		 char(5),
@CxMov		 char(20),
@CxMovID		 varchar(20),
@GenerarCxSolicitud  bit,
@DepositoFactor	 float,
@DepositoTipoCambio  float,
@DepositoImporte	 money,
@AbonoImporte	 money,
@CtaSaldo		 money,
@TieneSaldoOtrasMonedas bit,
@CajeroSaldo	 money,
@FormaPagoD		 varchar(50),
@ReferenciaD	 varchar(50),
@ImporteD		 money,
@CtaDineroD		 char(10),
@FaltanteCajaModulo	 char(5),
@RedondeoMonetarios	 int,
@CargoImporte	 money,
@OrigenID		 int,
@OrigenTotal	 money,
@OrigenFactor	 float,
@sOk		 int,
@sOkRef		 varchar(255),
@ReferenciaID	 int,
@PPTO		 bit,
@ImporteTotalCorte	 money,
@AplicaCorteFactor	 float,
@Retencion2BaseImpuesto1		bit  ,
@SubClave   	 varchar(20),
@CfgProrrateoMovImpuesto    bit	,
@TotalMovCargoCorte         float,
@TotalMovAbonoCorte         float,
@CorteImporteDiferir	money,
@CDID					int,
@CDMov					varchar(20),
@CDMovId				varchar(20),
@CDImporte				money,
@CDImpuestos			money,
@CDTipoCambio			float,
@CorteImporteD			money,
@CorteDisminuciones     money,
@DMovTipo				varchar(20),
@CorteFaltante			money,
@CorteImporteDAnterior	money
SELECT @SubClave = SubClave FROM MovTipo WHERE Mov = @Mov AND Modulo = @Modulo
SELECT @Retencion2BaseImpuesto1 = ISNULL(Retencion2BaseImpuesto1,0) FROM Version
SELECT @CfgProrrateoMovImpuesto = DineroProrrateoMovImpuesto FROM EmpresaCfg WHE
SELECT @PPTO = PPTO FROM EmpresaGral WHERE Empresa = @Empresa
SELECT @RedondeoMonetarios = dbo.fnRedondeoMonetarios()
SELECT @CtaDineroImporte   = 0.0,
@SaldoNuevo         = 0.0,
@EsCargo            = 0,
@Intereses	     = 0.0,
@CtaDineroIntereses = 0.0,
@Serie		     = NULL
IF @MovTipo IN ('DIN.CH', 'DIN.CHE') SELECT @Serie = @CtaDinero
IF @MovID IS NULL 
EXEC spMovConsecutivo @Sucursal, @SucursalOrigen, @SucursalDestino, @Empresa, @Usuario, @Modulo, @Ejercicio, @Periodo, @ID, @Mov, @Serie, @Estatus, @Concepto, @Accion, @Conexion, @SincroFinal, @MovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @Accion <> 'CANCELAR' AND @Ok IS NULL
EXEC spMovChecarConsecutivo	@Empresa, @Modulo, @Mov, @MovID, @Serie, @Ejercicio, @Periodo, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion IN ('CONSECUTIVO', 'SINCRO') AND @Ok IS NULL
BEGIN
IF @Accion = 'SINCRO' EXEC spAsignarSucursalEstatus @ID, @Modulo, @SucursalDestino, @Accion
SELECT @Ok = 80060, @OkRef = @MovID
RETURN
END
IF @OK IS NOT NULL RETURN
IF @Conexion = 0
BEGIN TRANSACTION
EXEC spMovEstatus @Modulo, 'AFECTANDO', @ID, @Generar, @IDGenerar, @GenerarAfectado, @Ok OUTPUT
IF @Accion <> 'CANCELAR'
EXEC spRegistrarMovimiento @Sucursal, @Empresa, @Modulo, @Mov, @MovID, @ID, @Ejercicio, @Periodo, @FechaRegistro, @FechaEmision,
@Concepto, @Proyecto, @MovMoneda, @MovTipoCambio,
@Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones,
@Generar, @GenerarMov, @GenerarMovID, @IDGenerar,
@Ok OUTPUT
IF @MovTipo NOT IN ('DIN.CB','DIN.AB') SELECT @Impuestos = 0.0
SELECT @ImporteTotal = @Importe + @Impuestos
IF @MovTipo = 'DIN.RET' 
BEGIN
IF @InteresTipo = 'TASA FIJA'
SELECT @Intereses = (ISNULL(@ImporteTotal * @Dias * (@TasaDiaria/100.0) , 0)) - @Retencion
ELSE
IF @InteresTipo = 'TITULO'
SELECT @Intereses = (@ImporteTotal * ((@TituloValor/@ValorOrigen)-1.0)) - @Retencion
END
IF @MovTipo = 'DIN.REI' AND @Accion <> 'CANCELAR'
BEGIN
IF @Titulo IS NULL OR NULLIF(@TituloValor, 0.0) IS NULL OR NULLIF(@ValorOrigen, 0.0) IS NULL SELECT @Ok = 10610 ELSE
BEGIN
SELECT @ReferenciaID = MIN(d.ID)
FROM Dinero d
JOIN MovTipo mt ON mt.Modulo = @Modulo AND mt.Mov = d.Mov AND mt.Clave = 'DIN.INV'
WHERE d.Empresa = @Empresa AND d.Estatus = 'PENDIENTE' AND @Referencia = RTRIM(d.Mov)+' '+RTRIM(d.MovID) AND CtaDinero = @CtaDinero
IF @ReferenciaID IS NULL
SELECT @Ok = 20915, @OkRef = @Referencia
ELSE
UPDATE Dinero SET TituloValor = @TituloValor WHERE ID = @ReferenciaID
END
END
IF @MovTipo IN ('DIN.D', 'DIN.DE', 'DIN.DA', 'DIN.I', 'DIN.SD', 'DIN.E', 'DIN.F', 'DIN.SCH', 'DIN.C', 'DIN.CNI')
BEGIN
IF (@MovTipo IN ('DIN.DA', 'DIN.CNI') OR (@ConDesglose = 0 AND @Directo = 1)) AND @Accion <> 'CANCELAR'
DELETE DineroD WHERE ID = @ID
END
IF @Accion = 'AFECTAR' AND @Estatus IN ('SINAFECTAR', 'CONFIRMAR')
IF (SELECT Sincro FROM Version) = 1
EXEC sp_executesql N'UPDATE DineroD SET Sucursal = @Sucursal, SincroC = 1 WHERE ID = @ID AND (Sucursal <> @Sucursal OR SincroC <> 1)', N'@Sucursal int, @ID int', @Sucursal, @ID
IF NULLIF(@IVAFiscal, 0) IS NULL
SELECT @IVAFiscal = SUM(d.Importe*a.IVAFiscal)/SUM(d.Importe) FROM DineroD d, Dinero a WHERE d.Aplica = a.Mov AND d.AplicaID = a.MovID AND a.Empresa = @Empresa AND a.Estatus NOT IN ('SINAFECTAR', 'CANCELADO') AND d.id = @ID
IF NULLIF(@IEPSFiscal, 0) IS NULL
SELECT @IEPSFiscal = SUM(d.Importe*a.IEPSFiscal)/SUM(d.Importe) FROM DineroD d, Dinero a WHERE d.Aplica = a.Mov AND d.AplicaID = a.MovID AND a.Empresa = @Empresa AND a.Estatus NOT IN ('SINAFECTAR', 'CANCELADO') AND d.id = @ID
IF NULLIF(@IVAFiscal, 0) IS NULL
SELECT @IVAFiscal = CONVERT(float, NULLIF(@Impuestos, 0)) / NULLIF(@Importe + @Impuestos, 0)
IF @MovTipo = 'DIN.C' AND @Accion = 'AFECTAR' AND @SubClave NOT IN ('DIN.CMULTIMONEDA')
BEGIN
SELECT @CtaSaldo = 0.0, @TieneSaldoOtrasMonedas = 0
SELECT @CtaSaldo = ISNULL(SUM(Saldo), 0.0)
FROM Saldo
WHERE Empresa = @Empresa
AND Rama = @Modulo
AND Moneda = @CtaDineroMoneda
AND Cuenta = @CtaDinero
IF EXISTS(SELECT Moneda, ISNULL(SUM(Saldo), 0.0)
FROM Saldo
WHERE Empresa = @Empresa
AND Rama = @Modulo
AND Moneda <> @CtaDineroMoneda
AND Cuenta = @CtaDinero
GROUP BY Moneda)
SELECT @TieneSaldoOtrasMonedas = 1
SELECT @CajeroSaldo = ROUND(@CtaSaldo, @RedondeoMonetarios) - ROUND(@ImporteTotal, @RedondeoMonetarios)
IF (@CajeroSaldo <> 0.0 OR @TieneSaldoOtrasMonedas = 1) AND @CfgCajeros = 1 AND @CfgAutoFaltanteSobrante = 1 AND @Accion = 'AFECTAR'
BEGIN
IF @CajeroSaldo > 0 SELECT @CorteFaltante = @CajeroSaldo
EXEC spDineroFaltanteSobrante @Accion, @Empresa, @Sucursal, @Usuario, @ID, @Mov, @MovID, @CajeroSaldo, @CtaDinero, @CtaDineroMoneda, @TieneSaldoOtrasMonedas, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL SELECT @CajeroSaldo = 0.0
END
IF @Ok IS NULL
BEGIN
IF @CajeroSaldo > 0 AND @CfgCajeros = 1
SELECT @Ok = 30450, @OkRef = 'Importe Faltante: '+LTRIM(CONVERT(char, @CajeroSaldo))+' '+@CtaDineroMoneda
IF @CajeroSaldo < 0
SELECT @Ok = 30455, @OkRef = 'Importe Sobrante: '+LTRIM(CONVERT(char, -@CajeroSaldo))+' '+@CtaDineroMoneda
IF @Ok IS NULL
BEGIN
IF (SELECT ISNULL(ROUND(SUM(s.Saldo), @RedondeoMonetarios), 0) FROM Saldo s WHERE s.Empresa = @Empresa AND s.Rama = @Modulo AND s.Moneda <> @CtaDineroMoneda AND s.Cuenta = @CtaDinero) <> 0.0
SELECT @Ok = 30540
END
END
END
IF @CfgCajeros = 1
BEGIN
IF @MovTipo = 'DIN.A' AND @SubClave   NOT IN( 'DIN.AMULTIMONEDA')
BEGIN
IF @Accion = 'CANCELAR' SELECT @CajeroActual = NULL ELSE SELECT @CajeroActual = @Cajero
UPDATE CtaDineroCajero
SET Cajero = @CajeroActual
WHERE Moneda = ''/*@MovMoneda*/ AND CtaDinero = @CtaDineroDestino
IF @@ROWCOUNT = 0
INSERT CtaDineroCajero (CtaDinero, Moneda, Cajero) VALUES (@CtaDineroDestino, ''/*@MovMoneda*/, @CajeroActual)
END
IF @MovTipo = 'DIN.C' AND @SubClave   NOT IN( 'DIN.CMULTIMONEDA')
BEGIN
IF @Accion <> 'CANCELAR'
SELECT @CajeroActual = NULL
ELSE
SELECT @CajeroActual = @Cajero
UPDATE CtaDineroCajero
SET Cajero = @CajeroActual
WHERE Moneda = ''/*@MovMoneda*/ AND CtaDinero = @CtaDinero
IF @@ROWCOUNT = 0
INSERT CtaDineroCajero (CtaDinero, Moneda, Cajero) VALUES (@CtaDinero, ''/*@MovMoneda*/, @CajeroActual)
END
END
IF (@Accion IN('AFECTAR','CANCELAR')  AND @MovTipo = 'DIN.A'   AND @SubClave ='DIN.AMULTIMONEDA' AND @EstatusNuevo IN('CONCLUIDO','CANCELADO'))OR
(@Accion IN('CANCELAR')  AND @MovTipo = 'DIN.C'   AND @SubClave ='DIN.CMULTIMONEDA' AND @EstatusNuevo IN('CANCELADO'))OR
(@Accion IN('AFECTAR','CANCELAR')  AND @MovTipo = 'DIN.CP'   AND @SubClave ='DIN.CPMULTIMONEDA' AND @EstatusNuevo IN('CONCLUIDO','CANCELADO'))
EXEC spDineroGenerarMultimoneda @Accion,@Empresa,@Sucursal,@Usuario,@ID,@Mov,@MovID,@MovTipo,@SubClave,@Estatus,@EstatusNuevo,@Ok  OUTPUT,@OkRef OUTPUT
IF @Accion IN('AFECTAR','CANCELAR')  AND @MovTipo = 'DIN.TC'   AND @SubClave ='DIN.TCMULTIMONEDA' AND @EstatusNuevo IN('CONCLUIDO','CANCELADO')
EXEC spDineroGenerarTCMultimoneda @Accion,@Empresa,@Sucursal,@Usuario,@ID,@Mov,@MovID,@MovTipo,@SubClave,@Estatus,@EstatusNuevo,@Ok  OUTPUT,@OkRef OUTPUT
IF @Accion IN('AFECTAR')  AND @MovTipo = 'DIN.C'   AND @SubClave ='DIN.CMULTIMONEDA' AND @EstatusNuevo IN('CONCLUIDO')
EXEC spDineroGenerarCorteMultimoneda @Accion,@Empresa,@Sucursal,@Usuario,@ID,@Mov,@MovID,@MovTipo,@SubClave,@Estatus,@EstatusNuevo,@Ok  OUTPUT,@OkRef OUTPUT
IF @MovTipo IN ('DIN.C', 'DIN.CP') AND @Ok IS NULL AND @SubClave   NOT IN( 'DIN.CMULTIMONEDA','DIN.CPMULTIMONEDA')
BEGIN
IF @CfgProrrateoMovImpuesto = 1 AND @CfgCajeros = 1
BEGIN
IF @Accion = 'CANCELAR'
BEGIN
SELECT @CorteImporteD = NULL
DECLARE crCancelarCorte CURSOR FOR
SELECT ID, CorteImporte FROM MovCorteDetalle WHERE IDCorte = @ID AND Cancelado = 0
OPEN crCancelarCorte
FETCH NEXT FROM crCancelarCorte INTO @CDID,  @CorteImporteD
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
UPDATE Dinero SET CorteImporte = ISNULL(CorteImporte,0) - ISNULL(@CorteImporteD,0) WHERE ID = @CDID
UPDATE MovCorteDetalle SET Cancelado = 1 WHERE IDCorte = @ID AND ID = @CDID
SELECT @CorteImporteD = NULL
END
FETCH NEXT FROM crCancelarCorte INTO @CDID,  @CorteImporteD
END 
CLOSE crCancelarCorte
DEALLOCATE crCancelarCorte
END ELSE
BEGIN
SELECT @UltimoID = ISNULL(MAX(ID), 0)
FROM Dinero d, MovTipo mt
WHERE d.ID < @ID AND d.Mov = mt.Mov AND mt.Modulo = 'DIN' AND mt.Clave = 'DIN.C' AND d.Estatus = 'CONCLUIDO' AND d.Empresa = @Empresa AND d.CtaDinero = @CtaDinero
UPDATE Dinero
SET Corte = @ID FROM Dinero d join MovTipo mt ON d.Mov = mt.Mov AND mt.Modulo = 'DIN' WHERE D.ID > @UltimoID AND (D.Estatus = 'CONCLUIDO' OR D.ID = @ID) AND D.Moneda = @MovMoneda AND D.Empresa = @Empresa AND D.CtaDinero = @CtaDinero AND D.CtaDineroDestino IS NULL
AND MT.Clave IN ('DIN.I', 'DIN.E')
SELECT @IVAFiscal = NULL, @IEPSFiscal = NULL
SELECT @IVAFiscal = SUM((ISNULL(Importe, 0)+ISNULL(Impuestos, 0))*IVAFiscal)/SUM(ISNULL(Importe, 0)+ISNULL(Impuestos, 0)),
@IEPSFiscal = SUM((ISNULL(Importe, 0)+ISNULL(Impuestos, 0))*IEPSFiscal)/SUM(ISNULL(Importe, 0)+ISNULL(Impuestos, 0)),
@ImporteTotalCorte = SUM(ISNULL(Importe, 0)+ISNULL(Impuestos, 0))
FROM Dinero
WHERE Estatus='CONCLUIDO' AND (Corte = @ID OR CorteDestino = @ID) AND ID <> @ID
SELECT @CorteImporteDiferir = 0.0
SELECT @CorteDisminuciones = SUM(ISNULL(d.Importe, 0.0))+ SUM(ISNULL(d.Impuestos,0.0))
FROM Dinero d JOIN MovTipo mt ON d.Mov = mt.Mov AND mt.Modulo = 'DIN'
WHERE (d.Corte = @ID OR d.CorteDestino = @ID) AND d.ID <> @ID AND ISNULL(d.Importe, 0.0) + ISNULL(d.Impuestos,0.0) > ISNULL(d.CorteImporte,0)
AND mt.Clave = 'DIN.E'
SELECT @CorteImporteDiferir = @ImporteTotal + ISNULL(@CorteFaltante,0.0)
DECLARE crDiferirCorte CURSOR FOR
SELECT d.ID, d.Mov, d.MovId, ISNULL(d.Importe, 0.0), ISNULL(d.Impuestos,0.0), d.TipoCambio, mt.Clave, ISNULL(CorteImporte,0.0)
FROM Dinero d JOIN MovTipo mt ON d.Mov = mt.Mov AND mt.Modulo = 'DIN'
WHERE (d.Corte = @ID OR d.CorteDestino = @ID) AND d.ID <> @ID AND ISNULL(d.Importe, 0.0) + ISNULL(d.Impuestos,0.0) > ISNULL(d.CorteImporte,0)
AND d.Estatus = 'CONCLUIDO'
ORDER BY mt.Clave asc, d.ID asc
OPEN crDiferirCorte
FETCH NEXT FROM crDiferirCorte INTO @CDID, @CDMov, @CDMovId, @CDImporte, @CDImpuestos, @CDTipoCambio, @DMovTipo, @CorteImporteDAnterior
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2 AND @CorteImporteDiferir+ISNULL(@CorteDisminuciones,0.0) > 0
BEGIN
SELECT @CorteImporteD = 0
IF @DMovTipo = 'DIN.E'
SELECT @CorteImporteD =  @CDImporte + @CDImpuestos
ELSE
BEGIN
IF (@CDImporte + @CDImpuestos) - @CorteImporteDAnterior <= @CorteImporteDiferir + ISNULL(@CorteDisminuciones,0.0) SELECT @CorteImporteD =  (@CDImporte + @CDImpuestos) - @CorteImporteDAnterior
ELSE SELECT @CorteImporteD = @CorteImporteDiferir
END
INSERT MovCorteDetalle (IDcorte, ID, Mov, MovID, CorteImporte) VALUES (@ID, @CDID, @CDMov, @CDMovID, @CorteImporteD)
UPDATE Dinero SET CorteImporte = ISNULL(CorteImporte,0.0)+@CorteImporteD WHERE ID =  @CDID
IF @DMovTipo = 'DIN.E'
BEGIN
SELECT @CorteDisminuciones = @CorteDisminuciones - @CorteImporteD
SELECT @CorteImporteDiferir = @CorteImporteDiferir + @CorteImporteD
END
ELSE
SELECT @CorteImporteDiferir = @CorteImporteDiferir-@CorteImporteD
END
FETCH NEXT FROM crDiferirCorte INTO @CDID, @CDMov, @CDMovId, @CDImporte, @CDImpuestos, @CDTipoCambio, @DMovTipo, @CorteImporteDAnterior
END 
CLOSE crDiferirCorte
DEALLOCATE crDiferirCorte
INSERT MovImpuesto (
Modulo,  ModuloID, OrigenModulo,    OrigenModuloID,    OrigenConcepto,    OrigenDeducible,		  OrigenFecha,    LoteFijo,    Retencion1,    Retencion2,    Retencion3,    Excento1,    Excento2,    Excento3,    Impuesto1,    Impuesto2,    Impuesto3,    TipoImpuesto1,    TipoImpuesto2,    TipoImpuesto3,    TipoRetencion1,    TipoRetencion2,    TipoRetencion3,    Importe1,                            Importe2,                            Importe3,                            SubTotal,                            ContUso,    ContUso2,    ContUso3,    ClavePresupuestal,    ClavePresupuestalImpuesto1,    DescuentoGlobal)
SELECT @Modulo, @ID,      mi.OrigenModulo, mi.OrigenModuloID, mi.OrigenConcepto, ISNULL(mi.OrigenDeducible, 100), mi.OrigenFecha, mi.LoteFijo, mi.Retencion1, mi.Retencion2, mi.Retencion3, mi.Excento1, mi.Excento2, mi.Excento3, mi.Impuesto1, mi.Impuesto2, mi.Impuesto3, mi.TipoImpuesto1, mi.TipoImpuesto2, mi.TipoImpuesto3, mi.TipoRetencion1, mi.TipoRetencion2, mi.TipoRetencion3,
ROUND(SUM(mi.Importe1*ISNULL(mcd.CorteImporte,0.0)/(ISNULL(Importe,0.0)+ISNULL(Impuestos,0.0))*CASE WHEN mt.Clave IN ('DIN.E', 'DIN.F', 'DIN.CP', 'DIN.TC') THEN -1 ELSE 1 END),@RedondeoMonetarios),
ROUND(SUM(mi.Importe2*ISNULL(mcd.CorteImporte,0.0)/(ISNULL(Importe,0.0)+ISNULL(Impuestos,0.0))*CASE WHEN mt.Clave IN ('DIN.E', 'DIN.F', 'DIN.CP', 'DIN.TC') THEN -1 ELSE 1 END),@RedondeoMonetarios),
ROUND(SUM(mi.Importe3*ISNULL(mcd.CorteImporte,0.0)/(ISNULL(Importe,0.0)+ISNULL(Impuestos,0.0))*CASE WHEN mt.Clave IN ('DIN.E', 'DIN.F', 'DIN.CP', 'DIN.TC') THEN -1 ELSE 1 END),@RedondeoMonetarios),
ROUND(SUM(mi.SubTotal*ISNULL(mcd.CorteImporte,0.0)/(ISNULL(Importe,0.0)+ISNULL(Impuestos,0.0))*CASE WHEN mt.Clave IN ('DIN.E', 'DIN.F', 'DIN.CP', 'DIN.TC') THEN -1 ELSE 1 END),@RedondeoMonetarios),
mi.ContUso, mi.ContUso2, mi.ContUso3, mi.ClavePresupuestal, mi.ClavePresupuestalImpuesto1, mi.DescuentoGlobal
FROM MovImpuesto mi
JOIN Dinero d ON d.Estatus = 'CONCLUIDO' AND d.ID <> @ID
JOIN MovTipo mt ON Mt.Modulo = 'DIN' AND mt.Mov = d.Mov
JOIN MovCorteDetalle mcd ON mcd.IDCorte = @ID AND mcd.ID = D.ID AND mcd.Cancelado = 0
WHERE mi.Modulo = @Modulo AND mi.ModuloID = d.ID
GROUP BY mi.OrigenModulo, mi.OrigenModuloID, mi.OrigenConcepto, ISNULL(mi.OrigenDeducible, 100), mi.OrigenFecha, mi.LoteFijo, mi.Retencion1, mi.Retencion2, mi.Retencion3, mi.Excento1, mi.Excento2, mi.Excento3, mi.Impuesto1, mi.Impuesto2, mi.Impuesto3, mi.TipoImpuesto1, mi.TipoImpuesto2, mi.TipoImpuesto3, mi.TipoRetencion1, mi.TipoRetencion2, mi.TipoRetencion3, mi.ContUso, mi.ContUso2, mi.ContUso3, mi.ClavePresupuestal, mi.ClavePresupuestalImpuesto1, mi.DescuentoGlobal
ORDER BY mi.OrigenModulo, mi.OrigenModuloID, mi.OrigenConcepto, ISNULL(mi.OrigenDeducible, 100), mi.OrigenFecha, mi.LoteFijo, mi.Retencion1, mi.Retencion2, mi.Retencion3, mi.Excento1, mi.Excento2, mi.Excento3, mi.Impuesto1, mi.Impuesto2, mi.Impuesto3, mi.TipoImpuesto1, mi.TipoImpuesto2, mi.TipoImpuesto3, mi.TipoRetencion1, mi.TipoRetencion2, mi.TipoRetencion3, mi.ContUso, mi.ContUso2, mi.ContUso3, mi.ClavePresupuestal, mi.ClavePresupuestalImpuesto1, mi.DescuentoGlobal
IF @PPTO = 1
INSERT MovPresupuesto (
Modulo,  ModuloID, CuentaPresupuesto,    Importe)
SELECT @Modulo, @ID,      mp.CuentaPresupuesto, SUM(mp.Importe)
FROM MovPresupuesto mp
JOIN Dinero d ON d.Estatus = 'CONCLUIDO' AND (d.Corte = @ID OR d.CorteDestino = @ID) AND d.ID <> @ID
WHERE mp.Modulo = @Modulo AND mp.ModuloID = d.ID
GROUP BY mp.CuentaPresupuesto
ORDER BY mp.CuentaPresupuesto
IF @IVAFiscal IS NULL AND @IEPSFiscal IS NULL
SELECT @IVAFiscal = IVAFiscal, @IEPSFiscal = IEPSFiscal FROM Dinero WHERE ID = @UltimoID
END
END ELSE
BEGIN
IF @Accion = 'CANCELAR'
BEGIN
UPDATE Dinero SET Corte = NULL WHERE Corte = @ID
UPDATE Dinero SET CorteDestino = NULL WHERE CorteDestino = @ID
END ELSE
BEGIN
IF @MovTipo = 'DIN.C'
UPDATE CtaDinero SET UltimoCorte = @FechaRegistro WHERE CtaDinero = @CtaDinero
SELECT @UltimoID = ISNULL(MAX(ID), 0)
FROM Dinero d, MovTipo mt
WHERE d.ID < @ID AND d.Mov = mt.Mov AND mt.Modulo = 'DIN' AND mt.Clave = 'DIN.C' AND d.Estatus = 'CONCLUIDO' AND d.Empresa = @Empresa AND d.CtaDinero = @CtaDinero
UPDATE Dinero
SET Corte = @ID
WHERE ID > @UltimoID AND (Estatus = 'CONCLUIDO' OR ID = @ID) AND Moneda = @MovMoneda AND Empresa = @Empresa AND CtaDinero = @CtaDinero AND Corte IS NULL
UPDATE Dinero
SET CorteDestino = @ID
WHERE ID > @UltimoID AND (Estatus = 'CONCLUIDO' OR ID = @ID) AND Moneda = @MovMoneda AND Empresa = @Empresa AND CtaDineroDestino = @CtaDinero AND CorteDestino IS NULL
SELECT @IVAFiscal = NULL, @IEPSFiscal = NULL
SELECT @IVAFiscal = SUM((ISNULL(Importe, 0)+ISNULL(Impuestos, 0))*IVAFiscal)/SUM(ISNULL(Importe, 0)+ISNULL(Impuestos, 0)),
@IEPSFiscal = SUM((ISNULL(Importe, 0)+ISNULL(Impuestos, 0))*IEPSFiscal)/SUM(ISNULL(Importe, 0)+ISNULL(Impuestos, 0)),
@ImporteTotalCorte = SUM(ISNULL(Importe, 0)+ISNULL(Impuestos, 0))
FROM Dinero
WHERE Estatus='CONCLUIDO' AND (Corte = @ID OR CorteDestino = @ID) AND ID <> @ID
SELECT @AplicaCorteFactor = @ImporteTotal / @ImporteTotalCorte
INSERT MovImpuesto (
Modulo,  ModuloID, OrigenModulo,    OrigenModuloID,    OrigenConcepto,    OrigenDeducible,		  OrigenFecha,    LoteFijo,    Retencion1,    Retencion2,    Retencion3,    Excento1,    Excento2,    Excento3,    Impuesto1,    Impuesto2,    Impuesto3,    TipoImpuesto1,    TipoImpuesto2,    TipoImpuesto3,    TipoRetencion1,    TipoRetencion2,    TipoRetencion3,    Importe1,                            Importe2,                            Importe3,                            SubTotal,                            ContUso,    ContUso2,    ContUso3,    ClavePresupuestal,    ClavePresupuestalImpuesto1,    DescuentoGlobal)
SELECT @Modulo, @ID,      mi.OrigenModulo, mi.OrigenModuloID, mi.OrigenConcepto, ISNULL(mi.OrigenDeducible, 100), mi.OrigenFecha, mi.LoteFijo, mi.Retencion1, mi.Retencion2, mi.Retencion3, mi.Excento1, mi.Excento2, mi.Excento3, mi.Impuesto1, mi.Impuesto2, mi.Impuesto3, mi.TipoImpuesto1, mi.TipoImpuesto2, mi.TipoImpuesto3, mi.TipoRetencion1, mi.TipoRetencion2, mi.TipoRetencion3, SUM(mi.Importe1*@AplicaCorteFactor), SUM(mi.Importe2*@AplicaCorteFactor), SUM(mi.Importe3*@AplicaCorteFactor), SUM(mi.SubTotal*@AplicaCorteFactor), mi.ContUso, mi.ContUso2, mi.ContUso3, mi.ClavePresupuestal, mi.ClavePresupuestalImpuesto1, mi.DescuentoGlobal
FROM MovImpuesto mi
JOIN Dinero d ON d.Estatus = 'CONCLUIDO' AND (d.Corte = @ID OR d.CorteDestino = @ID) AND d.ID <> @ID
WHERE mi.Modulo = @Modulo AND mi.ModuloID = d.ID
GROUP BY mi.OrigenModulo, mi.OrigenModuloID, mi.OrigenConcepto, ISNULL(mi.OrigenDeducible, 100), mi.OrigenFecha, mi.LoteFijo, mi.Retencion1, mi.Retencion2, mi.Retencion3, mi.Excento1, mi.Excento2, mi.Excento3, mi.Impuesto1, mi.Impuesto2, mi.Impuesto3, mi.TipoImpuesto1, mi.TipoImpuesto2, mi.TipoImpuesto3, mi.TipoRetencion1, mi.TipoRetencion2, mi.TipoRetencion3, mi.ContUso, mi.ContUso2, mi.ContUso3, mi.ClavePresupuestal, mi.ClavePresupuestalImpuesto1, mi.DescuentoGlobal
ORDER BY mi.OrigenModulo, mi.OrigenModuloID, mi.OrigenConcepto, ISNULL(mi.OrigenDeducible, 100), mi.OrigenFecha, mi.LoteFijo, mi.Retencion1, mi.Retencion2, mi.Retencion3, mi.Excento1, mi.Excento2, mi.Excento3, mi.Impuesto1, mi.Impuesto2, mi.Impuesto3, mi.TipoImpuesto1, mi.TipoImpuesto2, mi.TipoImpuesto3, mi.TipoRetencion1, mi.TipoRetencion2, mi.TipoRetencion3, mi.ContUso, mi.ContUso2, mi.ContUso3, mi.ClavePresupuestal, mi.ClavePresupuestalImpuesto1, mi.DescuentoGlobal
IF @PPTO = 1
INSERT MovPresupuesto (
Modulo,  ModuloID, CuentaPresupuesto,    Importe)
SELECT @Modulo, @ID,      mp.CuentaPresupuesto, SUM(mp.Importe)
FROM MovPresupuesto mp
JOIN Dinero d ON d.Estatus = 'CONCLUIDO' AND (d.Corte = @ID OR d.CorteDestino = @ID) AND d.ID <> @ID
WHERE mp.Modulo = @Modulo AND mp.ModuloID = d.ID
GROUP BY mp.CuentaPresupuesto
ORDER BY mp.CuentaPresupuesto
IF @IVAFiscal IS NULL AND @IEPSFiscal IS NULL
SELECT @IVAFiscal = IVAFiscal, @IEPSFiscal = IEPSFiscal FROM Dinero WHERE ID = @UltimoID
END
END
END
IF @Directo = 0 AND @MovTipo IN ('DIN.CH', 'DIN.CHE', 'DIN.D', 'DIN.DE', 'DIN.I', 'DIN.E', 'DIN.F', 'DIN.INV', 'DIN.RET') AND (@Estatus <> 'PENDIENTE' OR @Accion = 'CANCELAR')
EXEC spDineroAplicar @Sucursal, @ID, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaEmision, @FechaRegistro, @FechaAfectacion, @Ejercicio, @Periodo,
@CtaDinero, @CtaDineroFactor, @CtaDineroTipoCambio, @ImporteTotal, @CfgContX, @CfgContXGenerar, 0,
@Ok OUTPUT, @OkRef OUTPUT, @EstacionTrabajo = @EstacionTrabajo 
SELECT @CtaDineroImporte   = @ImporteTotal / @CtaDineroFactor,
@CtaDineroIntereses = @Intereses / @CtaDineroFactor
IF (@MovTipo IN ('DIN.I', 'DIN.SD', 'DIN.E', 'DIN.F', 'DIN.SCH') AND @CtaDineroTipo <> 'CAJA') OR (@MovTipo IN ('DIN.CH', 'DIN.CHE') AND @Accion = 'AFECTAR' AND @Estatus = 'PENDIENTE')
SELECT @Ok = @Ok
ELSE
IF @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR','POSFECHADO','PENDIENTE') OR @Accion <> 'AFECTAR'
BEGIN
IF @MovTipo IN ('DIN.CH', 'DIN.CHE', 'DIN.E', 'DIN.F', 'DIN.CB', 'DIN.DF', 'DIN.CP', 'DIN.C', 'DIN.T', 'DIN.INV', 'DIN.RET', 'DIN.TC', 'DIN.A', 'DIN.AP', 'DIN.CNI') AND @SubClave  NOT IN( 'DIN.AMULTIMONEDA','DIN.CMULTIMONEDA','DIN.CPMULTIMONEDA','DIN.TCMULTIMONEDA')
BEGIN
IF @Accion <> 'CANCELAR' SELECT @EsCargo = 0 ELSE SELECT @EsCargo = 1
SELECT @AbonoImporte = @CtaDineroImporte
IF @MovTipo = 'DIN.RET' AND @CfgInversionIntereses = 'CIERRE DIARIO' SELECT @AbonoImporte = @AbonoImporte + @CtaDineroIntereses
EXEC spSaldo @Sucursal, @Accion, @Empresa, @Usuario, @Modulo, @MovMoneda, @CtaDineroTipoCambio, @CtaDinero, NULL, NULL, NULL,
@Modulo, @ID, @Mov, @MovID, @EsCargo, @AbonoImporte, NULL, NULL,
@FechaAfectacion, @Ejercicio, @Periodo, @Mov, @MovID, 0, 0, 0,
@Ok OUTPUT, @OkRef OUTPUT
IF @MovTipo IN ('DIN.CP', 'DIN.C') AND @Ok IS NULL AND ISNULL(@CtaDineroImporte, 0.0) <> 0.0 AND @SubClave  NOT IN('DIN.CMULTIMONEDA','DIN.CPMULTIMONEDA') 
BEGIN
IF (SELECT DineroCorteSDPorFormaPago FROM EmpresaCfg WHERE Empresa = @Empresa) = 0
BEGIN
EXEC spGenerarDinero @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @Empresa,@Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, 1, 1,
@FechaRegistro, @Ejercicio, @Periodo, @FormaPago, NULL, NULL, NULL, @CtaDineroDestino, NULL, @CtaDineroImporte, NULL, NULL, NULL, NULL,
@DineroMov OUTPUT, @DineroMovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @IVAFiscal = @IVAFiscal, @IEPSFiscal = @IEPSFiscal, @OrigenTipo = @OrigenTipo, @IgnorarFormaPago = 1
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
END ELSE
BEGIN
SELECT @CtaDineroSaldo = @CtaDineroImporte
DECLARE crCorteFormaPago CURSOR FOR
SELECT RTRIM(d.FormaPago), RTRIM(d.Referencia), ISNULL(d.Importe, 0), NULLIF(RTRIM(fp.DefCtaDinero), '')
FROM DineroD d, FormaPago fp
WHERE d.ID = @ID AND d.FormaPago = fp.FormaPago
OPEN crCorteFormaPago
FETCH NEXT FROM crCorteFormaPago INTO @FormaPagoD, @ReferenciaD, @ImporteD, @CtaDineroD
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2 AND @CtaDineroD IS NOT NULL
BEGIN
EXEC spGenerarDinero @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @Empresa,@Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @ReferenciaD, @DocFuente, @Observaciones, 0, 1,
@FechaRegistro, @Ejercicio, @Periodo, @FormaPagoD, NULL, NULL, NULL, @CtaDineroD, NULL, @ImporteD, NULL, NULL, NULL, NULL,
@DineroMov OUTPUT, @DineroMovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @IVAFiscal = @IVAFiscal, @IEPSFiscal = @IEPSFiscal, @OrigenTipo = @OrigenTipo, @IgnorarFormaPago = 1
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
SELECT @CtaDineroSaldo = @CtaDineroSaldo - @ImporteD
END
FETCH NEXT FROM crCorteFormaPago INTO @FormaPagoD, @ReferenciaD, @ImporteD, @CtaDineroD
END 
CLOSE crCorteFormaPago
DEALLOCATE crCorteFormaPago
IF @CtaDineroSaldo <> 0.0
BEGIN
EXEC spGenerarDinero @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @Empresa,@Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, 0, 1,
@FechaRegistro, @Ejercicio, @Periodo, @FormaPago, NULL, NULL, NULL, @CtaDineroDestino, NULL, @CtaDineroSaldo, NULL, NULL, NULL, NULL,
@DineroMov OUTPUT, @DineroMovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @IVAFiscal = @IVAFiscal, @IEPSFiscal = @IEPSFiscal, @OrigenTipo = @OrigenTipo, @IgnorarFormaPago = 1
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
END
END
END
END
SELECT @SubClave = ISNULL(@SubClave,'Sin')
IF @MovTipo IN ('DIN.D', 'DIN.DE', 'DIN.I', 'DIN.DA', 'DIN.AB', 'DIN.CD', 'DIN.T', 'DIN.INV', 'DIN.RET', 'DIN.REI', 'DIN.TC', 'DIN.A', 'DIN.AP') AND @SubClave  NOT IN( 'DIN.AMULTIMONEDA','DIN.TCMULTIMONEDA')
BEGIN
IF @Accion <> 'CANCELAR' SELECT @EsCargo = 1 ELSE SELECT @EsCargo = 0
IF @MovTipo NOT IN ('DIN.T', 'DIN.INV', 'DIN.RET', 'DIN.TC', 'DIN.A', 'DIN.AP') SELECT @CtaDineroDestino = @CtaDinero
IF @MovTipo IN ('DIN.T', 'DIN.INV', 'DIN.RET') AND @CtaDineroDestinoMoneda <> @MovMoneda
BEGIN
SELECT @DepositoImporte = ((@ImporteTotal + ISNULL(@Intereses, 0)) * @MovTipoCambio) / @TipoCambioDestino
EXEC spSaldo @Sucursal, @Accion, @Empresa, @Usuario, @Modulo, @CtaDineroDestinoMoneda, @TipoCambioDestino, @CtaDineroDestino, NULL, NULL, NULL,
@Modulo, @ID, @Mov, @MovID, @EsCargo, @DepositoImporte, NULL, NULL,
@FechaAfectacion, @Ejercicio, @Periodo, @Mov, @MovID, 0, 0, 0,
@Ok OUTPUT, @OkRef OUTPUT
END ELSE
IF @MovTipo = 'DIN.D' AND @CtaDineroMoneda <> @MovMoneda
BEGIN
/** JH 22.08.2006 **/
/*IF @TipoCambioDestino IS NULL*/
IF @Accion ='CANCELAR'
SELECT @DepositoTipoCambio=Tipocambio,@DepositoFactor=TipoCambio  from Auxiliar where ModuloID =@ID
ELSE
EXEC spMoneda NULL, @MovMoneda, @MovTipoCambio, @CtaDineroMoneda, @DepositoFactor OUTPUT, @DepositoTipoCambio OUTPUT, @Ok OUTPUT, @ModuloID = @ID
/*ELSE
SELECT @DepositoFactor = @TipoCambioDestino */
/** Inicia cambio Bug 24360 **/
IF @Accion = 'CANCELAR' AND @MovTipo = 'DIN.D' AND @OrigenMovTipo = 'DIN.TI' AND @CtaDineroDestinoMoneda <> @MovMoneda
SELECT @DepositoImporte = ((@ImporteTotal + ISNULL(@Intereses, 0)) * @MovTipoCambio) / @TipoCambioDestino
ELSE
/** Termina cambio Bug 24360 **/
SELECT @DepositoImporte = (@ImporteTotal + ISNULL(@Intereses, 0)) / @DepositoFactor
EXEC spSaldo @Sucursal, @Accion, @Empresa, @Usuario, @Modulo, @CtaDineroMoneda, @DepositoTipoCambio, @CtaDineroDestino, NULL, NULL, NULL,
@Modulo, @ID, @Mov, @MovID, @EsCargo, @DepositoImporte, NULL, NULL,
@FechaAfectacion, @Ejercicio, @Periodo, @Mov, @MovID, 0, 0, 0,
@Ok OUTPUT, @OkRef OUTPUT
END ELSE
BEGIN
SELECT @CargoImporte = @CtaDineroImporte + ISNULL(@CtaDineroIntereses, 0)
EXEC spSaldo @Sucursal, @Accion, @Empresa, @Usuario, @Modulo, @MovMoneda, @CtaDineroTipoCambio, @CtaDineroDestino, NULL, NULL, NULL,
@Modulo, @ID, @Mov, @MovID, @EsCargo, @CargoImporte, NULL, NULL,
@FechaAfectacion, @Ejercicio, @Periodo, @Mov, @MovID, 0, 0, 0,
@Ok OUTPUT, @OkRef OUTPUT
END
END
END
IF @CfgAfectarComision = 1 AND @MovTipo IN ('DIN.D', 'DIN.DE', 'DIN.CH', 'DIN.CHE') AND @EstatusNuevo <> 'PENDIENTE'
BEGIN
SELECT @Comision = NULL, @Comision2 = NULL, @ComisionIVA = NULL
IF @ConDesglose = 0 OR @MovTipo IN ('DIN.CHE', 'DIN.CH')
BEGIN
IF @MovTipo IN ('DIN.CHE', 'DIN.CH')
SELECT @Comision = CargoBancario, @ComisionIVA = CargoBancarioIVA FROM Dinero WHERE ID = @ID
ELSE
SELECT @Comision    = @ImporteTotal*(Comision/100.0),
@ComisionIVA = (@ImporteTotal*(Comision/100.0))*(Impuestos/100.0),
@Comision2   = @ImporteTotal*(Comision2/100.0),
@Comision2IVA= (@ImporteTotal*(Comision2/100.0))*(Impuestos/100.0)
FROM FormaPago
WHERE FormaPago = @FormaPago
SELECT @ComisionMov     = CASE WHEN @Comision     < 0.0 THEN BancoAbonoBancario    ELSE BancoCargoBancario    END,
@Comision2Mov    = CASE WHEN @Comision2    < 0.0 THEN BancoAbonoBancario    ELSE BancoCargoBancario    END,
@ComisionMovIVA  = CASE WHEN @ComisionIVA  < 0.0 THEN BancoAbonoBancarioIVA ELSE BancoCargoBancarioIVA END,
@Comision2MovIVA = CASE WHEN @Comision2IVA < 0.0 THEN BancoAbonoBancarioIVA ELSE BancoCargoBancarioIVA END
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
SELECT @Comision = ABS(@Comision), @ComisionIVA = ABS(@ComisionIVA), @Comision2 = ABS(@Comision2), @Comision2IVA = ABS(@Comision2IVA)
IF @CfgAfectarComisionIVA = 0
SELECT @ComisionImpuestos = @ComisionIVA, @Comision2Impuestos = @Comision2IVA
ELSE SELECT @ComisionImpuestos = NULL, @Comision2Impuestos = NULL
IF ISNULL(@Comision, 0.0) <> 0.0
EXEC spGenerarDinero @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, 1, 1,
@FechaRegistro, @Ejercicio, @Periodo, @FormaPago, NULL, NULL, NULL, @CtaDinero, NULL, @Comision, @ComisionImpuestos, @ComisionMov, NULL, NULL,
@ComisionMov, @DineroMovID, @Ok OUTPUT, @OkRef OUTPUT, @IVAFiscal = NULL, @IEPSFiscal = NULL, @DesgloseManual = 1, @OrigenTipo = @OrigenTipo
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
IF ISNULL(@Comision2, 0.0) <> 0.0
EXEC spGenerarDinero @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, 1, 1,
@FechaRegistro, @Ejercicio, @Periodo, @FormaPago, NULL, NULL, NULL, @CtaDinero, NULL, @Comision2, @Comision2Impuestos, @Comision2Mov, NULL, NULL,
@Comision2Mov, @DineroMovID, @Ok OUTPUT, @OkRef OUTPUT, @IVAFiscal = NULL, @IEPSFiscal = NULL, @DesgloseManual = 1, @OrigenTipo = @OrigenTipo
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
IF @CfgAfectarComisionIVA = 1
BEGIN
IF ISNULL(@ComisionIVA, 0.0) <> 0.0
EXEC spGenerarDinero @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, 1, 1,
@FechaRegistro, @Ejercicio, @Periodo, @FormaPago, NULL, NULL, NULL, @CtaDinero, NULL, @ComisionIVA, NULL, @ComisionMovIVA, NULL, NULL,
@ComisionMovIVA, @DineroMovID, @Ok OUTPUT, @OkRef OUTPUT, @IVAFiscal = NULL, @IEPSFiscal = NULL, @DesgloseManual = 1, @OrigenTipo = @OrigenTipo
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
IF @Ok = 60060 AND @Accion = 'CANCELAR' SELECT @Ok = NULL, @OkRef = NULL
IF ISNULL(@Comision2IVA, 0.0) <> 0.0
EXEC spGenerarDinero @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, 1, 1,
@FechaRegistro, @Ejercicio, @Periodo, @FormaPago, NULL, NULL, NULL, @CtaDinero, NULL, @Comision2IVA, NULL, @Comision2MovIVA, NULL, NULL,
@Comision2MovIVA, @DineroMovID, @Ok OUTPUT, @OkRef OUTPUT, @IVAFiscal = NULL, @IEPSFiscal = NULL, @DesgloseManual = 1, @OrigenTipo = @OrigenTipo
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
IF @Ok = 60060 AND @Accion = 'CANCELAR' SELECT @Ok = NULL, @OkRef = NULL
END
END ELSE
BEGIN
DECLARE crComisionFormaPago CURSOR FOR
SELECT d.FormaPago, d.Referencia,
ISNULL(d.Importe, 0)*ISNULL(fp.Comision/100.0, 0),
(ISNULL(d.Importe, 0)*ISNULL(fp.Comision/100.0, 0))*ISNULL(fp.Impuestos/100.0, 0),
ISNULL(d.Importe, 0)*ISNULL(fp.Comision2/100.0, 0),
(ISNULL(d.Importe, 0)*ISNULL(fp.Comision2/100.0, 0))*ISNULL(fp.Impuestos/100.0, 0)
FROM DineroD d, FormaPago fp
WHERE d.ID = @ID AND d.FormaPago = fp.FormaPago
OPEN crComisionFormaPago
FETCH NEXT FROM crComisionFormaPago INTO @FormaPagoD, @ReferenciaD, @Comision, @ComisionIVA, @Comision2, @Comision2IVA
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @ComisionMov     = CASE WHEN @Comision     < 0.0 THEN BancoAbonoBancario    ELSE BancoCargoBancario    END,
@Comision2Mov    = CASE WHEN @Comision2    < 0.0 THEN BancoAbonoBancario    ELSE BancoCargoBancario    END,
@ComisionMovIVA  = CASE WHEN @ComisionIVA  < 0.0 THEN BancoAbonoBancarioIVA ELSE BancoCargoBancarioIVA END,
@Comision2MovIVA = CASE WHEN @Comision2IVA < 0.0 THEN BancoAbonoBancarioIVA ELSE BancoCargoBancarioIVA END
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
SELECT @Comision = ABS(@Comision), @ComisionIVA = ABS(@ComisionIVA), @Comision2 = ABS(@Comision2), @Comision2IVA = ABS(@Comision2IVA)
IF @CfgAfectarComisionIVA = 0
SELECT @ComisionImpuestos = @ComisionIVA, @Comision2Impuestos = @Comision2IVA
ELSE SELECT @ComisionImpuestos = NULL, @Comision2Impuestos = NULL
IF ISNULL(@Comision, 0.0) <> 0.0
EXEC spGenerarDinero @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @ReferenciaD, @DocFuente, @Observaciones, 1, 1,
@FechaRegistro, @Ejercicio, @Periodo, @FormaPagoD, NULL, NULL, NULL, @CtaDinero, NULL, @Comision, @ComisionImpuestos, @ComisionMov, NULL, NULL,
@ComisionMov, @DineroMovID, @Ok OUTPUT, @OkRef OUTPUT, @IVAFiscal = NULL, @IEPSFiscal = NULL, @DesgloseManual = 1, @OrigenTipo = @OrigenTipo
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
IF ISNULL(@Comision2, 0.0) <> 0.0
EXEC spGenerarDinero @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @ReferenciaD, @DocFuente, @Observaciones, 1, 1,
@FechaRegistro, @Ejercicio, @Periodo, @FormaPagoD, NULL, NULL, NULL, @CtaDinero, NULL, @Comision2, NULL, @Comision2Mov, NULL, NULL,
@Comision2Mov, @DineroMovID, @Ok OUTPUT, @OkRef OUTPUT, @IVAFiscal = NULL, @IEPSFiscal = NULL, @DesgloseManual = 1, @OrigenTipo = @OrigenTipo
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
IF @CfgAfectarComisionIVA = 1
BEGIN
IF ISNULL(@ComisionIVA, 0.0) <> 0.0
EXEC spGenerarDinero @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @ReferenciaD, @DocFuente, @Observaciones, 1, 1,
@FechaRegistro, @Ejercicio, @Periodo, @FormaPagoD, NULL, NULL, NULL, @CtaDinero, NULL, @ComisionIVA, NULL, @ComisionMovIVA, NULL, NULL,
@ComisionMovIVA, @DineroMovID, @Ok OUTPUT, @OkRef OUTPUT, @IVAFiscal = NULL, @IEPSFiscal = NULL, @DesgloseManual = 1, @OrigenTipo = @OrigenTipo
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
IF @Ok = 60060 AND @Accion = 'CANCELAR' SELECT @Ok = NULL, @OkRef = NULL
IF ISNULL(@Comision2IVA, 0.0) <> 0.0
EXEC spGenerarDinero @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @ReferenciaD, @DocFuente, @Observaciones, 1, 1,
@FechaRegistro, @Ejercicio, @Periodo, @FormaPagoD, NULL, NULL, NULL, @CtaDinero, NULL, @Comision2IVA, NULL, @Comision2MovIVA, NULL, NULL,
@Comision2MovIVA, @DineroMovID, @Ok OUTPUT, @OkRef OUTPUT, @IVAFiscal = NULL, @IEPSFiscal = NULL, @DesgloseManual = 1, @OrigenTipo = @OrigenTipo
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
IF @Ok = 60060 AND @Accion = 'CANCELAR' SELECT @Ok = NULL, @OkRef = NULL
END
END
FETCH NEXT FROM crComisionFormaPago INTO @FormaPagoD, @ReferenciaD, @Comision, @ComisionIVA, @Comision2, @Comision2IVA
END 
CLOSE crComisionFormaPago
DEALLOCATE crComisionFormaPago
END
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
END
IF @Ok IS NULL
BEGIN
IF @Accion = 'CANCELAR' SELECT @SaldoNuevo = 0.0
IF @EstatusNuevo = 'PENDIENTE'  AND @MovTipo IN ('DIN.I', 'DIN.SD','DIN.E', 'DIN.F', 'DIN.SCH', 'DIN.INV', 'DIN.TI', 'DIN.DA', 'DIN.CNI') SELECT @SaldoNuevo = @CtaDineroImporte
IF @EstatusNuevo <> 'PENDIENTE' AND @SaldoNuevo > 0.0 SELECT @EstatusNuevo = 'PENDIENTE'
IF @EstatusNuevo = 'CANCELADO' SELECT @FechaCancelacion = @FechaRegistro ELSE SELECT @FechaCancelacion = NULL
IF @EstatusNuevo = 'CONCLUIDO' SELECT @FechaConclusion  = @FechaEmision ELSE IF @EstatusNuevo <> 'CANCELADO' SELECT @FechaConclusion  = NULL
IF @CfgContX = 1 AND @CfgContXGenerar <> 'NO'
BEGIN
IF @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR','POSFECHADO') AND @EstatusNuevo <> 'CANCELADO' SELECT @GenerarPoliza = 1 ELSE
IF @Estatus NOT IN ('SINAFECTAR','CONFIRMAR','POSFECHADO') AND @EstatusNuevo =  'CANCELADO' IF @GenerarPoliza = 1 SELECT @GenerarPoliza = 0 ELSE SELECT @GenerarPoliza = 1
END
IF @SaldoNuevo = 0.0 SELECT @SaldoNuevo = NULL
EXEC spValidarTareas @Empresa, @Modulo, @ID, @EstatusNuevo, @Ok OUTPUT, @OkRef OUTPUT
UPDATE Dinero
SET FechaConclusion 	= @FechaConclusion,
FechaCancelacion 	= @FechaCancelacion,
UltimoCambio       = /*CASE WHEN UltimoCambio IS NULL THEN */@FechaRegistro /*ELSE UltimoCambio END*/,
Estatus 		= @EstatusNuevo,
Situacion 	      	= CASE WHEN @Estatus<>@EstatusNuevo THEN NULL ELSE Situacion END,
Concepto 		= @Concepto,
GenerarPoliza 	= @GenerarPoliza,
IVAFiscal		= @IVAFiscal,
IEPSFiscal		= @IEPSFiscal,
Impuestos 		= @Impuestos,
Saldo 		= @SaldoNuevo,
Mensaje            = NULL
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Conexion = 0 AND @MovTipo IN ('DIN.CH', 'DIN.CHE', 'DIN.D', 'DIN.DE', 'DIN.I','DIN.E') AND (@Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') OR @Accion = 'CANCELAR') AND @Ok IS NULL
EXEC spDineroRelacionar @Empresa, @Accion, @Modulo, @ID, @Mov, @MovID, @CtaDinero
IF @AutoConciliar = 1
UPDATE Auxiliar SET Conciliado = 1 WHERE Empresa = @Empresa AND Modulo = 'DIN' AND ModuloID = @ID AND Conciliado = 0
EXEC spEmbarqueMov @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @Estatus, @EstatusNuevo, @CfgEmbarcar, @Ok OUTPUT
IF @Utilizar = 1
BEGIN
SELECT @FechaConclusion = @FechaEmision
EXEC spValidarTareas @Empresa, @Modulo, @UtilizarID, 'CONCLUIDO', @Ok OUTPUT, @OkRef OUTPUT
UPDATE Dinero SET FechaConclusion = @FechaConclusion, Estatus = 'CONCLUIDO', Saldo = NULL WHERE ID = @UtilizarID
IF @@ERROR <> 0 SELECT @Ok = 1
END
IF @Generar = 1
BEGIN
IF @GenerarAfectado = 1 SELECT @GenerarEstatus = 'CONCLUIDO' ELSE SELECT @GenerarEstatus = 'SINAFECTAR'
IF @GenerarEstatus = 'CONCLUIDO' SELECT @FechaConclusion = @FechaEmision ELSE IF @GenerarEstatus <> 'CANCELADO' SELECT @FechaConclusion = NULL
IF @GenerarEstatus = 'CONCLUIDO' AND @CfgContX = 1 AND @CfgContXGenerar <> 'NO' SELECT @GenerarPolizaTemp = 1 ELSE SELECT @GenerarPolizaTemp = 0
EXEC spValidarTareas @Empresa, @Modulo, @IDGenerar, @GenerarEstatus, @Ok OUTPUT, @OkRef OUTPUT
UPDATE Dinero SET FechaConclusion = @FechaConclusion, Estatus = @GenerarEstatus, GenerarPoliza = @GenerarPolizaTemp WHERE ID = @IDGenerar
IF @@ERROR <> 0 SELECT @Ok = 1
END
END
IF @MovTipo = 'DIN.F' AND @Ok IS NULL
BEGIN
SELECT @FaltanteCajaModulo = DineroFaltanteModulo FROM EmpresaCfg WHERE Empresa = @Empresa
EXEC spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @FaltanteCajaModulo, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario,  @Autorizacion, @Referencia, @DocFuente, @Observaciones,
@FechaRegistro, @Ejercicio, @Periodo,
NULL, NULL, @Cajero, NULL, @Cajero, NULL, NULL, NULL,
@ImporteTotal, NULL, NULL, @ImporteTotal,
NULL, NULL, NULL, NULL, NULL, NULL,
@CxModulo, @CxMov, @CxMovID, @Ok OUTPUT, @OkRef  OUTPUT
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
END
IF @MovTipo IN ('DIN.SD', 'DIN.SCH') AND @OrigenTipo IN ('CXC', 'CXP'/*, 'VTAS', 'AGENT', 'NOM', 'GAS', 'COMS'*/) AND (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
SELECT @sOk = @Ok, @sOkRef = @OkRef
SELECT @Ok = NULL, @OkRef = NULL, @GenerarCxSolicitud = 1
IF @OrigenTipo IN ('VTAS', 'CXC') SELECT @CxModulo = 'CXC' ELSE SELECT @CxModulo = 'CXP'
IF @Accion = 'CANCELAR'
BEGIN
IF @CxModulo = 'CXC' AND NOT EXISTS(SELECT * FROM Cxc WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID) SELECT @GenerarCxSolicitud = 0 ELSE
IF @CxModulo = 'CXP' AND NOT EXISTS(SELECT * FROM Cxp WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID) SELECT @GenerarCxSolicitud = 0
END ELSE
BEGIN
IF @ContactoTipo = 'Cliente'
BEGIN
IF NOT EXISTS(SELECT * FROM Cte  WHERE Cliente   = @Contacto) SELECT @Ok = 26060, @OkRef = @Contacto
END ELSE
IF NOT EXISTS(SELECT * FROM Prov WHERE Proveedor = @Contacto) SELECT @Ok = 26050, @OkRef = @Contacto
END
IF @GenerarCxSolicitud = 1
BEGIN
EXEC @CxID = spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @CxModulo, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario,  @Autorizacion, @Referencia, @DocFuente, @Observaciones,
@FechaRegistro, @Ejercicio, @Periodo,
NULL, NULL, @Contacto, @ContactoEnviarA, NULL, NULL, @CtaDinero, NULL,
@ImporteTotal, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, NULL,
@CxModulo, @CxMov OUTPUT, @CxMovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @CxModulo, @CxID, @CxMov, @CxMovID, @Ok OUTPUT
END
IF @Ok IS NULL
SELECT @Ok = @sOk, @OkRef = @sOkRef
END
IF @MovTipo IN ('DIN.ACXC', 'DIN.ACXP') AND (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
SELECT @sOk = @Ok, @sOkRef = @OkRef
SELECT @Ok = NULL, @OkRef = NULL
UPDATE Dinero SET ContactoTipo = @ContactoTipo, Contacto = @Contacto, ContactoEnviarA = @ContactoEnviarA WHERE ID = @ID
IF @MovTipo = 'DIN.ACXC' SELECT @CxModulo = 'CXC' ELSE SELECT @CxModulo = 'CXP'
EXEC @CxID = spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @CxModulo, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario,  @Autorizacion, @Referencia, @DocFuente, @Observaciones,
@FechaRegistro, @Ejercicio, @Periodo,
NULL, NULL, @Contacto, @ContactoEnviarA, NULL, NULL, NULL, NULL,
@ImporteTotal, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, NULL,
@CxModulo, @CxMov OUTPUT, @CxMovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @CxModulo, @CxID, @CxMov, @CxMovID, @Ok OUTPUT
IF @Ok IS NULL
SELECT @Ok = @sOk, @OkRef = @sOkRef
END
IF @MovTipo = 'DIN.TI'
EXEC spGenerarDinero @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @Empresa,@Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, @ConDesglose, 1,
@FechaRegistro, @Ejercicio, @Periodo, @FormaPago, NULL, NULL, NULL, @CtaDinero, NULL, @CtaDineroImporte, NULL, NULL, NULL, NULL,
@DineroMov OUTPUT, @DineroMovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @IVAFiscal = @IVAFiscal, @IEPSFiscal = @IEPSFiscal, @OrigenTipo = @OrigenTipo, @IgnorarFormaPago = 1
IF (SELECT TieneMovimientos FROM CtaDinero WHERE CtaDinero = @CtaDinero) = 0
UPDATE CtaDinero SET TieneMovimientos = 1 WHERE CtaDinero = @CtaDinero
IF @CtaDineroDestino IS NOT NULL
BEGIN
IF (SELECT TieneMovimientos FROM CtaDinero WHERE CtaDinero = @CtaDineroDestino) = 0
UPDATE CtaDinero SET TieneMovimientos = 1 WHERE CtaDinero = @CtaDineroDestino
END
/* MovImpuesto */
IF @OrigenTipo IS NOT NULL AND NOT EXISTS(SELECT * FROM MovImpuesto WHERE Modulo = @Modulo AND ModuloID = @ID)
BEGIN
EXEC spMovInfo @OrigenID OUTPUT, @OrigenTipo, @OrigenMov, @OrigenMovID, @Empresa = @Empresa, @Total = @OrigenTotal OUTPUT
SELECT @OrigenFactor = @Importe / NULLIF(@OrigenTotal, 0.0)
DECLARE @OrigenImporte money
SELECT @OrigenImporte = Importe FROM Dinero WHERE ID = @OrigenID
EXEC xpDineroOrigenFactorMovImpuesto @Sucursal, @ID, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio, @OrigenID, @OrigenMov, @OrigenMovID, @OrigenTipo, @OrigenImporte, NULL, @OrigenFactor OUTPUT, @Ok OUTPUT,  @OkRef OUTPUT
INSERT MovImpuesto (
Modulo,  ModuloID, OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenDeducible,              OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, Importe1,               Importe2,               Importe3,               SubTotal,               ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal)
SELECT @Modulo, @ID,      OrigenModulo, OrigenModuloID, OrigenConcepto, ISNULL(OrigenDeducible, 100), OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, Importe1*@OrigenFactor, Importe2*@OrigenFactor, Importe3*@OrigenFactor, SubTotal*@OrigenFactor, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal
FROM MovImpuesto
WHERE Modulo = @OrigenTipo AND ModuloID = @OrigenID
END
/* MovPresupuesto */
IF @PPTO = 1 AND @OrigenTipo IS NOT NULL AND NOT EXISTS(SELECT * FROM MovPresupuesto WHERE Modulo = @Modulo AND ModuloID = @ID)
BEGIN
EXEC spMovInfo @OrigenID OUTPUT, @OrigenTipo, @OrigenMov, @OrigenMovID, @Empresa = @Empresa, @Total = @OrigenTotal OUTPUT
SELECT @OrigenFactor = @Importe / NULLIF(@OrigenTotal, 0.0)
INSERT MovPresupuesto (
Modulo,  ModuloID, CuentaPresupuesto, Importe)
SELECT @Modulo, @ID,      CuentaPresupuesto, Importe*@OrigenFactor
FROM MovPresupuesto
WHERE Modulo = @OrigenTipo AND ModuloID = @OrigenID
END
IF @Accion <> 'CANCELAR' AND (SELECT DineroValidarMovImpuesto FROM EmpresaCfg WHERE Empresa = @Empresa) = 1
IF ROUND(@Importe, 2) <> (SELECT ROUND(SUM(ISNULL(Importe1, 0.0)+ISNULL(Importe2, 0.0)+ISNULL(Importe3, 0.0)+ISNULL(SubTotal, 0.0)-ISNULL(SubTotal*(Retencion1/100),0.0) - ISNULL(CASE WHEN @Retencion2BaseImpuesto1 = 0 THEN SubTotal ELSE Importe1 END*(Retencion2/100),0.0)- ISNULL(SubTotal*(Retencion3/100),0.0) ), 2) FROM MovImpuesto WHERE Modulo = @Modulo AND ModuloID = @ID)
SELECT @Ok = 35330
IF @MovTipo = 'DIN.C' AND @CfgCajeros = 1 AND @CfgAutoFaltanteSobrante = 1 AND @Accion = 'CANCELAR' AND @SubClave  NOT IN('DIN.CMULTIMONEDA')
EXEC spDineroFaltanteSobrante @Accion, @Empresa, @Sucursal, @Usuario, @ID, @Mov, @MovID, NULL, NULL, NULL, NULL, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
IF @GenerarGasto = 1
EXEC spGenerarGasto @Accion, @Empresa, @Sucursal, @Usuario, @Modulo, @ID, @Mov, @MovID, @FechaEmision, @FechaRegistro, @Ok OUTPUT, @OkRef OUTPUT, @MovTipoGenerarGasto = 1
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC xpDineroAfectar @ID, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio, @Estatus, @EstatusNuevo,
@CtaDinero, @CtaDineroTipo, @CtaDineroDestino, @CtaDineroFactor, @CtaDineroTipoCambio, @CtaDineroMoneda, @Cajero,
@Importe, @Impuestos, @Saldo,
@Directo, @CfgContX, @CfgContXGenerar, @Conexion, @SincroFinal, @Sucursal, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spMovFinal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT, @EstacionTrabajo 
IF @Accion = 'CANCELAR' AND @EstatusNuevo = 'CANCELADO' AND @Ok IS NULL
EXEC spCancelarFlujo @Empresa, @Modulo, @ID, @Ok OUTPUT
IF @Conexion = 0
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
COMMIT TRANSACTION
ELSE
BEGIN
DECLARE @PolizaDescuadrada TABLE (Cuenta varchar(20) NULL, SubCuenta varchar(50) NULL, Concepto varchar(50) NULL, Debe money NULL, Haber money NULL, SucursalContable int NULL)
IF EXISTS(SELECT * FROM PolizaDescuadrada WHERE Modulo = @Modulo AND ID = @ID)
INSERT @PolizaDescuadrada (Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable) SELECT Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable FROM PolizaDescuadrada WHERE Modulo = @Modulo AND ID = @ID
ROLLBACK TRANSACTION
DELETE PolizaDescuadrada WHERE Modulo = @Modulo AND ID = @ID
INSERT PolizaDescuadrada (Modulo, ID, Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable) SELECT @Modulo, @ID, Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable FROM @PolizaDescuadrada
END
RETURN
END

