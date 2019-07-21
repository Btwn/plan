SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCxAfectar2
@ID                		int OUTPUT,
@Accion					char(20) OUTPUT,
@Empresa	      			char(5) OUTPUT,
@Modulo	      			char(5) OUTPUT,
@Mov	  	      			char(20)OUTPUT,
@MovID             		varchar(20)  OUTPUT,
@MovTipo     			char(20) OUTPUT,
@MovMoneda	      		char(10) OUTPUT,
@MovTipoCambio	      	float OUTPUT,
@FechaEmision      		datetime OUTPUT,
@FechaAfectacion    		datetime OUTPUT,
@Concepto	      		varchar(50) OUTPUT,
@Usuario			  		char(10) OUTPUT,
@Estatus           		char(15) OUTPUT,
@FechaRegistro     		datetime OUTPUT,
@Ejercicio	      		int OUTPUT,
@Periodo		    		int OUTPUT,
@Contacto			char(10) OUTPUT,
@ContactoEnviarA		int OUTPUT,
@Importe   			money OUTPUT,
@Impuestos	        	money OUTPUT,
@Retencion			money OUTPUT,
@Retencion2			money OUTPUT,
@Retencion3			money OUTPUT,
@Comisiones			money OUTPUT,
@ComisionesIVA		money OUTPUT,
@Saldo			money OUTPUT,
@SaldoInteresesOrdinarios	money OUTPUT,
@SaldoInteresesMoratorios	money OUTPUT,
@CtaDinero			char(10) OUTPUT,
@Cajero			char(10) OUTPUT,
@Conexion			bit OUTPUT,
@SincroFinal			bit OUTPUT,
@Sucursal			int OUTPUT,
@SucursalDestino		int OUTPUT,
@SucursalOrigen		int OUTPUT,
@CfgCobroImpuestos	 	bit OUTPUT,
@CfgVentaLimiteNivelSucursal bit OUTPUT,
@CfgSugerirProntoPago	bit OUTPUT,
@CfgAC			bit OUTPUT,
@TipoAmortizacion		varchar(20) OUTPUT,
@Generar                     bit OUTPUT,
@GenerarMov                  char(20) OUTPUT,
@GenerarSerie		char(20) OUTPUT,
@RedondeoMonetarios		int OUTPUT,
@IDGenerar			int	     OUTPUT,
@GenerarMovID	  	varchar(20)  OUTPUT,
@Ok                		int          OUTPUT,
@OkRef             		varchar(255) OUTPUT,
@Base			varchar(20)	= NULL OUTPUT,
@ComisionesFinanciadas		bit = NULL OUTPUT,
@ImporteTotal				float = NULL OUTPUT,
@Limite						float = NULL OUTPUT,
@VentaNeta					float = NULL OUTPUT,
@LimiteDesde					datetime = NULL OUTPUT,
@LimiteHasta					datetime = NULL OUTPUT,
@Excedente					float = NULL OUTPUT,
@GenerarEstatus				varchar(15) = NULL OUTPUT,
@GenerarMovTipo 	 			char(20) = NULL OUTPUT,
@GenerarSubMovTipo 	 		varchar(20) = NULL OUTPUT,
@GenerarPolizaTemp	 		bit = NULL OUTPUT,
@GenerarPeriodo 	 			int = NULL OUTPUT,
@GenerarEjercicio 	 		int = NULL OUTPUT,
@DescuentoRecargos			money = NULL OUTPUT,
@ImpuestoAdicional			float = NULL OUTPUT,
@Metodo						int = NULL OUTPUT,
@ImporteD					money = NULL OUTPUT,
@SaldoSinImpuestos			money = NULL OUTPUT,
@TasaDiaria					float = NULL OUTPUT,
@Dias						int = NULL OUTPUT,
@SubMovTipo					varchar(20) = NULL OUTPUT,
@ConsignacionFechaCorte		datetime = NULL OUTPUT,
@SaldoTotal					money = NULL OUTPUT,
@Porcentaje					float = NULL OUTPUT,
@ImporteSinImpuestos			money = NULL OUTPUT,
@GenerarAplicaManual			bit = NULL OUTPUT,
@SaldoInteresesOrdinariosIVA		float = NULL OUTPUT, 
@SaldoInteresesMoratoriosIVA		float = NULL OUTPUT  

AS BEGIN
DECLARE
@FactorImpuestos			float,
@ImpuestosProporcional	float,
@RetencionProporcional	float,
@Retencion2Proporcional	float,
@Retencion3Proporcional	float,
@ArrastrarTipoCambioGenerarMov	bit
IF @CfgAC = 1
BEGIN
SELECT @ComisionesFinanciadas = ISNULL(ComisionesFinanciadas, 0) FROM TipoAmortizacion WHERE TipoAmortizacion = @TipoAmortizacion
END
SELECT @ImporteTotal = @Importe + @Impuestos - @Retencion - @Retencion2 - @Retencion3
IF @ComisionesFinanciadas = 1
SELECT @ImporteTotal = @ImporteTotal + ISNULL(@Comisiones, 0.0) + ISNULL(@ComisionesIVA, 0.0)
EXEC spMovConsecutivo @Sucursal, @SucursalOrigen, @SucursalDestino, @Empresa, @Usuario, @Modulo, @Ejercicio, @Periodo, @ID, @Mov, NULL, @Estatus, @Concepto, @Accion, @Conexion, @SincroFinal, @MovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'CONFIRMAR') AND @Accion <> 'CANCELAR' AND @Ok IS NULL
EXEC spMovChecarConsecutivo	@Empresa, @Modulo, @Mov, @MovID, NULL, @Ejercicio, @Periodo, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion IN ('CONSECUTIVO', 'SINCRO') AND @Ok IS NULL
BEGIN
IF @Accion = 'SINCRO' EXEC spAsignarSucursalEstatus @ID, @Modulo, @SucursalDestino, 'SINCRO'
SELECT @Ok = 80060, @OkRef = @MovID
RETURN
END
IF @CfgVentaLimiteNivelSucursal = 1 AND @MovTipo = 'CXC.F' AND @Accion = 'AFECTAR' AND @Ok IS NULL
BEGIN
SELECT @Limite = NULL
SELECT @Limite = NULLIF(SUM(s.Limite*m.TipoCambio), 0), @LimiteDesde = MIN(s.Desde), @LimiteHasta = MAX(s.Hasta)
FROM CteEnviarALimite s, Mon m
WHERE s.Cliente = @Contacto AND s.EnviarA = @ContactoEnviarA AND @FechaEmision BETWEEN s.Desde AND s.Hasta
AND s.Moneda = m.Moneda
IF @Limite IS NOT NULL
BEGIN
SELECT @VentaNeta = ISNULL(SUM(ISNULL(v.Importe, 0)+ISNULL(v.Impuestos, 0)*m.TipoCambio) , 0)
FROM CxcVentaNeta v, Mon m
WHERE Empresa = @Empresa AND FechaEmision BETWEEN @LimiteDesde AND @LimiteHasta
AND Cliente = @Contacto AND EnviarA = @ContactoEnviarA
AND v.Moneda = m.Moneda
SELECT @Excedente = @VentaNeta+@Importe+@Impuestos - @Retencion - @Retencion2 - @Retencion3 - @Limite
IF ISNULL(@Excedente, 0) > 0
SELECT @Ok = 65060, @OkRef = 'Excedente '+CONVERT(varchar, @Excedente)+ ' MN'
END
END
IF @OK IS NOT NULL RETURN
IF @Generar = 1 AND @Ok IS NULL
BEGIN
IF @Accion = 'GENERAR' SELECT @GenerarEstatus = 'SINAFECTAR' ELSE SELECT @GenerarEstatus = 'CANCELADO'
EXEC spMovGenerar @Sucursal, @Empresa, @Modulo, @Ejercicio, @Periodo, @Usuario, @FechaRegistro, @GenerarEstatus,
NULL, NULL,
@Mov, @MovID, 0,
@GenerarMov, @GenerarSerie, @GenerarMovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spMovTipo @Modulo, @GenerarMov, @FechaAfectacion, @Empresa, NULL, NULL, @GenerarMovTipo OUTPUT, @GenerarPeriodo OUTPUT, @GenerarEjercicio OUTPUT, @Ok OUTPUT, @SubClave = @GenerarSubMovTipo OUTPUT 
IF @GenerarMovTipo IN ('CXC.EST','CXC.C','CXC.NET','CXC.D', 'CXC.DM','CXC.DA','CXC.DP','CXC.NC','CXC.NCD','CXC.NCF','CXC.CA','CXC.CAD','CXC.CAP','CXC.DV','CXC.NCP','CXC.DC',
'CXP.EST','CXP.P','CXP.NET','CXP.DP','CXP.NC','CXP.NCD','CXP.NCP','CXP.NCF','CXP.DC','CXP.D','CXP.CA','CXP.CAD','CXP.CAP','CXP.DM','CXP.PAG','CXP.DA',
'AGENT.P','AGENT.CO','CXC.FAC','CXP.FAC')
BEGIN
IF @Modulo = 'CXC'
BEGIN
SELECT @DescuentoRecargos = NULL, @ImpuestoAdicional = NULL
IF @GenerarMovTipo = 'CXC.C' AND @CfgSugerirProntoPago = 1
SELECT @DescuentoRecargos = -NULLIF(ProntoPago, 0) FROM CxcAplica WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID
SELECT @Metodo = ta.Metodo FROM Cxc c JOIN Cxc r ON r.ID = c.RamaID JOIN TipoAmortizacion ta ON ta.TipoAmortizacion = r.TipoAmortizacion WHERE c.ID = @ID
IF @Metodo IN (12, 22) SELECT @SaldoInteresesOrdinarios = 0.0, @SaldoInteresesOrdinariosIVA = 0.0 
IF @Metodo = 50 SELECT @ImpuestoAdicional = DefImpuesto FROM EmpresaGral WHERE Empresa = @Empresa
SELECT @ImporteD = @Saldo + ISNULL(@DescuentoRecargos, 0.0) + ISNULL(@SaldoInteresesOrdinarios, 0.0) + ISNULL(@SaldoInteresesMoratorios, 0.0) + ISNULL(@SaldoInteresesOrdinariosIVA, 0.0) + ISNULL(@SaldoInteresesMoratoriosIVA, 0.0) 
SELECT @FactorImpuestos = ISNULL(@ImporteD,0.0) / ((ISNULL(@ImporteTotal,0.0)+ ISNULL(@SaldoInteresesOrdinarios, 0.0) + ISNULL(@SaldoInteresesMoratorios, 0.0) + ISNULL(@SaldoInteresesOrdinariosIVA,0.0)+ISNULL(@SaldoInteresesMoratoriosIVA,0.0)) )
SET @ImpuestosProporcional = (ISNULL(@Impuestos,0.0)+ISNULL(@SaldoInteresesOrdinariosIVA,0.0)+ISNULL(@SaldoInteresesMoratoriosIVA,0.0)) * @FactorImpuestos 
SET @RetencionProporcional = ISNULL(@Retencion,0.0) * @FactorImpuestos 
SET @Retencion2Proporcional = ISNULL(@Retencion2,0.0) * @FactorImpuestos 
SET @Retencion3Proporcional = ISNULL(@Retencion3,0.0) * @FactorImpuestos 
UPDATE Cxc SET Importe = @ImporteD, Impuestos = NULL, Saldo = NULL, Retencion = NULL, Retencion2 = NULL, Retencion3 = NULL, Cajero = @Cajero, CtaDinero = @CtaDinero, AplicaManual = 1, UltimoCambio = @FechaEmision WHERE ID = @IDGenerar 
IF @GenerarMovTipo IN ('CXC.C', 'CXC.CD', 'CXC.D', 'CXC.DM', 'CXC.FAC') AND @CfgCobroImpuestos = 1
BEGIN
UPDATE Cxc SET Importe = @ImporteD - @ImpuestosProporcional + @RetencionProporcional + @Retencion2Proporcional + @Retencion3Proporcional, Impuestos = @ImpuestosProporcional, Retencion = @RetencionProporcional, Retencion2 = @Retencion2Proporcional, Retencion3 = @Retencion3Proporcional WHERE ID = @IDGenerar 
END
IF @@ERROR <> 0 SELECT @Ok = 1
INSERT INTO CxcD (Sucursal,  ID,         Renglon, RenglonSub, Aplica, AplicaID, Importe, DescuentoRecargos,  InteresesOrdinarios,                    InteresesMoratorios,                    ImpuestoAdicional,  InteresesOrdinariosIVA,                   InteresesMoratoriosIVA) 
VALUES (@Sucursal, @IDGenerar, 2048,    0,          @Mov,   @MovID,   @Saldo,  @DescuentoRecargos, NULLIF(@SaldoInteresesOrdinarios, 0.0), NULLIF(@SaldoInteresesMoratorios, 0.0), @ImpuestoAdicional, ISNULL(@SaldoInteresesOrdinariosIVA,0.0), ISNULL(@SaldoInteresesMoratoriosIVA,0.0)) 
END ELSE
IF @Modulo = 'CXP'
BEGIN
SELECT @DescuentoRecargos = NULL
IF @Base = 'SELECCION'
BEGIN
SELECT @TasaDiaria = NULL, @Dias = NULL
SELECT @TasaDiaria = NULLIF(Flotante, 0.0)/100.0/360.0 FROM SPIDTemp WHERE SPID = @@SPID
SELECT @Dias = DATEDIFF(day, (SELECT FechaEmision FROM Cxp WHERE ID = @IDGenerar), (SELECT Vencimiento FROM Cxp WHERE ID = @ID))
IF ISNULL(@Dias, 0) > 0
SELECT @DescuentoRecargos = -@TasaDiaria * @Dias * @Saldo
END
IF (@GenerarMovTipo IN ('CXP.D') AND @GenerarSubMovTipo IN ('CXP.SLCCORTE')) AND (@MovTipo IN ('CXP.F') AND @SubMovTipo IN ('CXP.SLC')) AND (@Ok IS NULL OR @Ok IN (80030))
BEGIN
SET @ConsignacionFechaCorte = dbo.fnFechaSinHora(GETDATE())
EXEC spCxpSLCCalcularCorte @@SPID, @ID, @IDGenerar, @ConsignacionFechaCorte, @Saldo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
SELECT @SaldoTotal = @Saldo + ISNULL(@SaldoInteresesOrdinarios, 0.0) + ISNULL(@SaldoInteresesMoratorios, 0.0) + ISNULL(@SaldoInteresesOrdinariosIVA, 0.0) + ISNULL(@SaldoInteresesMoratoriosIVA, 0.0) 
SELECT @ImporteD = @SaldoTotal
UPDATE Cxp SET Importe = @ImporteD, Impuestos = NULL, Saldo = NULL, Cajero = @Cajero, CtaDinero = @CtaDinero, AplicaManual = 1, UltimoCambio = @FechaEmision WHERE ID = @IDGenerar
IF @GenerarMovTipo = 'CXP.FAC'
BEGIN
UPDATE Cxp
SET Importe = dbo.fnR3(@ImporteTotal, @Importe, @Saldo/*Total*/),
Impuestos = dbo.fnR3(@ImporteTotal, ISNULL(@Impuestos,0.0)+ISNULL(@SaldoInteresesOrdinariosIVA,0.0)+ISNULL(@SaldoInteresesMoratoriosIVA,0.0), @Saldo/*Total*/), 
Retencion = dbo.fnR3(@ImporteTotal, @Retencion, @Saldo/*Total*/),
Retencion2 = dbo.fnR3(@ImporteTotal, @Retencion2, @Saldo/*Total*/),
Retencion3 = dbo.fnR3(@ImporteTotal, @Retencion3, @Saldo/*Total*/)
WHERE ID = @IDGenerar
END
IF @@ERROR <> 0 SELECT @Ok = 1
INSERT INTO CxpD (Sucursal,  ID,         Renglon, RenglonSub, Aplica, AplicaID, Importe, DescuentoRecargos,  InteresesOrdinarios,                    InteresesMoratorios,                    InteresesOrdinariosIVA,                   InteresesMoratoriosIVA) 
VALUES (@Sucursal, @IDGenerar, 2048,    0,          @Mov,   @MovID,   @Saldo,  @DescuentoRecargos, NULLIF(@SaldoInteresesOrdinarios, 0.0), NULLIF(@SaldoInteresesMoratorios, 0.0), NULLIF(@SaldoInteresesOrdinariosIVA,0.0), NULLIF(@SaldoInteresesMoratoriosIVA,0.0)) 
IF @GenerarMovTipo = 'CXP.PAG'
UPDATE Cxp SET Condicion = NULL WHERE ID = @IDGenerar
END ELSE
IF @Modulo = 'AGENT'
BEGIN
UPDATE Agent SET Importe = @Saldo, Impuestos = NULL, Retencion = NULL, Saldo = NULL, UltimoCambio = @FechaEmision WHERE ID = @IDGenerar
IF @@ERROR <> 0 SELECT @Ok = 1
INSERT INTO AgentD (Sucursal, ID,  Renglon, RenglonSub, Aplica, AplicaID, Importe) VALUES (@Sucursal, @IDGenerar, 2048, 0, @Mov, @MovID, @Saldo)
END
END
IF @GenerarMovTipo IN ('CXC.CA','CXC.CAD','CXC.CAP','CXC.NC','CXC.NCD','CXC.NCF','CXC.NCP','CXC.DV',/*'CXC.RA', */
'CXP.CA','CXP.CAD','CXP.CAP','CXP.NC','CXP.NCD','CXP.NCF','CXP.NCP')
BEGIN
IF @Impuestos > 0.0 SELECT @Porcentaje = ((@Importe+@Impuestos-@Retencion-@Retencion2-@Retencion3)/CONVERT(float, @Importe)) ELSE SELECT @Porcentaje = 1.0
SELECT @ImporteSinImpuestos = (@Saldo / @Porcentaje)
IF @Modulo = 'CXC' UPDATE Cxc SET Importe = @ImporteD - @ImpuestosProporcional + @RetencionProporcional + @Retencion2Proporcional + @Retencion3Proporcional, Impuestos = @ImpuestosProporcional, Retencion = @RetencionProporcional, Retencion2 = @Retencion2Proporcional, Retencion3 = @Retencion3Proporcional, Saldo = NULL, UltimoCambio = @FechaEmision WHERE ID = @IDGenerar ELSE 
IF @Modulo = 'CXP' UPDATE Cxp SET Importe = @ImporteSinImpuestos, Impuestos = (@Saldo - @ImporteSinImpuestos), Saldo = NULL, UltimoCambio = @FechaEmision WHERE ID = @IDGenerar
END ELSE
IF @GenerarMovTipo IN ('CXC.ANC', 'CXC.ACA', 'CXP.ACA', 'CXC.DAC', 'CXC.EST', 'CXP.ANC', 'CXP.RA', 'CXC.RA', 'CXP.DAC', 'CXO.EST')
BEGIN
IF @GenerarMovTipo IN ('CXC.ANC', 'CXC.ACA', 'CXP.ACA', 'CXP.ANC', 'CXC.EST', 'CXP.EST') SELECT @GenerarAplicaManual = 1 ELSE SELECT @GenerarAplicaManual = 0
IF @Modulo = 'CXC' UPDATE Cxc SET Importe = @Saldo, Impuestos = NULL, Retencion = NULL, Retencion2 = NULL, Retencion3 = NULL, Saldo = NULL, UltimoCambio = @FechaEmision, Referencia = RTRIM(@Mov)+' '+RTRIM(@MovID), MovAplica = @Mov, MovAplicaID = @MovID, AplicaManual = @GenerarAplicaManual, Moneda = ClienteMoneda,   TipoCambio = ClienteTipoCambio   WHERE ID = @IDGenerar ELSE
IF @Modulo = 'CXP' UPDATE Cxp SET Importe = @Saldo, Impuestos = NULL, Saldo = NULL, UltimoCambio = @FechaEmision, Referencia = RTRIM(@Mov)+' '+RTRIM(@MovID), MovAplica = @Mov, MovAplicaID = @MovID, AplicaManual = @GenerarAplicaManual, Moneda = ProveedorMoneda, TipoCambio = ProveedorTipoCambio WHERE ID = @IDGenerar
END
SELECT @ArrastrarTipoCambioGenerarMov = ISNULL(ArrastrarTipoCambioGenerarMov, 0) FROM EmpresaGral  WHERE Empresa = @Empresa
IF @GenerarMovTipo IN ('CXP.ANC')
BEGIN
IF @Accion = 'GENERAR' AND (@ArrastrarTipoCambioGenerarMov=1 OR (SELECT ISNULL(ArrastrarTipoCambioGenerarMov, 0) FROM MovTipo WHERE Modulo = @Modulo AND Mov = @GenerarMov) = 1  )
BEGIN
IF @Modulo = 'CXP' UPDATE Cxp set ProveedorMoneda = @MovMoneda, ProveedorTipoCambio = @MovTipoCambio,  Moneda = @MovMoneda, TipoCambio = @MovTipoCambio WHERE ID = @IDGenerar
END
END
IF @GenerarMovTipo IN ('CXC.FAC', 'CXP.FAC')
BEGIN
IF @Modulo = 'CXC' UPDATE Cxc SET UltimoCambio = @FechaEmision, Referencia = RTRIM(@Mov)+' '+RTRIM(@MovID), MovAplica = @Mov, MovAplicaID = @MovID, AplicaManual = 0, Moneda = ClienteMoneda,   TipoCambio = ClienteTipoCambio   WHERE ID = @IDGenerar ELSE
IF @Modulo = 'CXP' UPDATE Cxp SET UltimoCambio = @FechaEmision, Referencia = RTRIM(@Mov)+' '+RTRIM(@MovID), MovAplica = @Mov, MovAplicaID = @MovID, AplicaManual = 0, Moneda = ProveedorMoneda, TipoCambio = ProveedorTipoCambio WHERE ID = @IDGenerar
SELECT @ArrastrarTipoCambioGenerarMov = ISNULL(ArrastrarTipoCambioGenerarMov, 0) FROM EmpresaGral  WHERE Empresa = @Empresa
IF @Accion = 'GENERAR' AND (@ArrastrarTipoCambioGenerarMov=1 OR (SELECT ISNULL(ArrastrarTipoCambioGenerarMov, 0) FROM MovTipo WHERE Modulo = @Modulo AND Mov = @GenerarMov) = 1  )
BEGIN
IF @Modulo = 'CXP' UPDATE Cxp set ProveedorMoneda = @MovMoneda, ProveedorTipoCambio = @MovTipoCambio,  Moneda = @MovMoneda, TipoCambio = @MovTipoCambio WHERE ID = @IDGenerar
END
IF @GenerarMovTipo = 'CXC.FAC'
BEGIN
IF EXISTS(SELECT * FROM EmpresaCfgMov WHERE Empresa = @Empresa AND CxcFacturaSeguro = @GenerarMov)
EXEC spGenerarFacturaSeguro @Empresa, @ID, @Mov, @MovID, @MovMoneda, @MovTipoCambio, @Contacto, @IDGenerar, @ImporteTotal
ELSE
IF EXISTS(SELECT * FROM EmpresaGral WHERE Empresa = @Empresa AND Ford = 1 AND FordMovCxcFactura = @GenerarMov)
UPDATE Cxc SET Cliente = cfg.FordCliente FROM Cxc c, EmpresaGral cfg WHERE c.ID = @IDGenerar AND cfg.Empresa = @Empresa
END
END
EXEC xpGenerarCxFinal @Modulo, @ID, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END
END

