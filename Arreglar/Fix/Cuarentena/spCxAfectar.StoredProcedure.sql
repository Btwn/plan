SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spCxAfectar]
 @ID INT
,@Accion CHAR(20)
,@Empresa CHAR(5)
,@Modulo CHAR(5)
,@Mov CHAR(20)
,@MovID VARCHAR(20) OUTPUT
,@MovTipo CHAR(20)
,@MovMoneda CHAR(10)
,@MovTipoCambio FLOAT
,@FechaEmision DATETIME
,@FechaAfectacion DATETIME
,@FechaConclusion DATETIME
,@Concepto VARCHAR(50)
,@Proyecto VARCHAR(50)
,@Usuario CHAR(10)
,@Autorizacion CHAR(10)
,@Referencia VARCHAR(50)
,@DocFuente INT
,@Observaciones VARCHAR(255)
,@Estatus CHAR(15)
,@EstatusNuevo CHAR(15)
,@FechaRegistro DATETIME
,@Ejercicio INT
,@Periodo INT
,@Beneficiario INT
,@Condicion VARCHAR(50)
,@Vencimiento DATETIME
,@FechaProntoPago DATETIME
,@DescuentoProntoPago FLOAT
,@FormaPago VARCHAR(50)
,@Contacto CHAR(10)
,@ContactoEnviarA INT
,@ContactoMoneda CHAR(10)
,@ContactoFactor FLOAT
,@ContactoTipoCambio FLOAT
,@Importe MONEY
,@ValesCobrados MONEY
,@Impuestos MONEY
,@Retencion MONEY
,@Retencion2 MONEY
,@Retencion3 MONEY
,@Comisiones MONEY
,@ComisionesIVA MONEY
,@Saldo MONEY
,@SaldoInteresesOrdinarios MONEY
,@SaldoInteresesMoratorios MONEY
,@CtaDinero CHAR(10)
,@Cajero CHAR(10)
,@Agente CHAR(10)
,@AplicaManual BIT
,@ConDesglose BIT
,@CobroDesglosado MONEY
,@CobroDelEfectivo MONEY
,@CobroCambio MONEY
,@ImpuestosPorcentaje MONEY
,@RetencionPorcentaje MONEY
,@Aforo FLOAT
,@Tasa VARCHAR(50)
,@CfgAplicaAutoOrden CHAR(20)
,@AfectarCantidadPendiente BIT
,@AfectarCantidadA BIT
,@Conexion BIT
,@SincroFinal BIT
,@Sucursal INT
,@SucursalDestino INT
,@SucursalOrigen INT
,@CfgRetencionAlPago BIT
,@CfgRetencionMov CHAR(20)
,@CfgRetencionAcreedor CHAR(10)
,@CfgRetencionConcepto VARCHAR(50)
,@CfgRetencion2Acreedor CHAR(10)
,@CfgRetencion2Concepto VARCHAR(50)
,@CfgRetencion3Acreedor CHAR(10)
,@CfgRetencion3Concepto VARCHAR(50)
,@CfgAgentAfectarGastos BIT
,@CfgContX BIT
,@CfgContXGenerar CHAR(20)
,@CfgEmbarcar BIT
,@AutoAjuste MONEY
,@AutoAjusteMov MONEY
,@CfgDescuentoRecargos BIT
,@CfgFormaCobroDA VARCHAR(50)
,@CfgMovCargoDiverso CHAR(20)
,@CfgMovCreditoDiverso CHAR(20)
,@CfgVentaComisionesCobradas BIT
,@CfgCobroImpuestos BIT
,@CfgComisionBase CHAR(20)
,@CfgComisionCreditos BIT
,@CfgVentaLimiteNivelSucursal BIT
,@CfgSugerirProntoPago BIT
,@CfgAC BIT
,@GenerarGasto BIT
,@GenerarPoliza BIT
,@IDOrigen INT
,@OrigenTipo CHAR(10)
,@OrigenMovTipo CHAR(20)
,@MovAplica CHAR(20)
,@MovAplicaID VARCHAR(20)
,@MovAplicaMovTipo CHAR(20)
,@AgenteNomina BIT
,@AgentePersonal CHAR(10)
,@AgenteNominaMov CHAR(20)
,@AgenteNominaConcepto VARCHAR(50)
,@IVAFiscal FLOAT
,@IEPSFiscal FLOAT
,@ProveedorAutoEndoso VARCHAR(10)
,@RamaID INT
,@LineaCredito VARCHAR(20)
,@TipoAmortizacion VARCHAR(20)
,@TipoTasa VARCHAR(20)
,@Generar BIT
,@GenerarMov CHAR(20) OUTPUT
,@GenerarSerie CHAR(20)
,@GenerarAfectado BIT
,@GenerarCopia BIT
,@RedondeoMonetarios INT
,@IDGenerar INT OUTPUT
,@GenerarMovID VARCHAR(20) OUTPUT
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
,@INSTRUCCIONES_ESP VARCHAR(20) = NULL
,@Nota VARCHAR(100) = NULL
,@Base VARCHAR(20) = NULL
,@Origen VARCHAR(20) = NULL
,@OrigenID VARCHAR(20) = NULL
,@SaldoInteresesOrdinariosIVA FLOAT = NULL
,@SaldoInteresesMoratoriosIVA FLOAT = NULL
,@EstacionTrabajo INT = NULL
AS
BEGIN
	DECLARE
		@ImporteTotal MONEY
	   ,@NuevoPendiente FLOAT
	   ,@Porcentaje FLOAT
	   ,@ImporteComision MONEY
	   ,@ImporteSinImpuestos MONEY
	   ,@ContactoImporte MONEY
	   ,@SaldoNuevo MONEY
	   ,@Dias INT
	   ,@MovAplicaSaldo MONEY
	   ,@MovAplicaEstatus CHAR(15)
	   ,@MovAplicaContacto CHAR(10)
	   ,@FechaCancelacion DATETIME
	   ,@EsCargo BIT
	   ,@RamaAfectar CHAR(5)
	   ,@MovAfectar CHAR(20)
	   ,@GenerarEstatus CHAR(15)
	   ,@GenerarMovTipo CHAR(20)
	   ,@GenerarSubMovTipo VARCHAR(20)
	   ,@GenerarPolizaTemp BIT
	   ,@GenerarPeriodo INT
	   ,@GenerarEjercicio INT
	   ,@DineroID INT
	   ,@DineroImporte MONEY
	   ,@DineroMov CHAR(20)
	   ,@DineroMovID VARCHAR(20)
	   ,@DineroTipo CHAR(20)
	   ,@NominaID INT
	   ,@NominaMov CHAR(20)
	   ,@NominaMovID VARCHAR(20)
	   ,@TieneDescuentoRecargos BIT
	   ,@AplicaPosfechado BIT
	   ,@ImporteAplicado MONEY
	   ,@DA BIT
	   ,@IDAplica INT
	   ,@GenerarAplicaManual BIT
	   ,@CxModulo CHAR(5)
	   ,@CxMov CHAR(20)
	   ,@CxMovID VARCHAR(20)
	   ,@AforoID INT
	   ,@AforoMov CHAR(20)
	   ,@AforoMovID VARCHAR(20)
	   ,@AforoImporte MONEY
	   ,@SaldoSinImpuestos MONEY
	   ,@Limite MONEY
	   ,@Excedente MONEY
	   ,@LimiteDesde DATETIME
	   ,@LimiteHasta DATETIME
	   ,@VentaNeta MONEY
	   ,@ImporteMN MONEY
	   ,@ImpuestosMN MONEY
	   ,@MonedaMN CHAR(10)
	   ,@ImporteD MONEY
	   ,@DescuentoRecargos MONEY
	   ,@SumaAnticiposFacturados MONEY
	   ,@TasaDiaria FLOAT
	   ,@ComisionesFinanciadas BIT
	   ,@DiaRevision VARCHAR(10)
	   ,@FechaRevision DATETIME
	   ,@Metodo INT
	   ,@ImpuestoAdicional FLOAT
	   ,@LCCtaDinero VARCHAR(10)
	   ,@LCCtaDineroImporte MONEY
	   ,@MovAplicaRetencionAlPago BIT
	   ,@MovAplicaRetencion MONEY
	   ,@MovAplicaRetencion2 MONEY
	   ,@MovAplicaRetencion3 MONEY
	   ,@Importe1 MONEY
	   ,@Importe2 MONEY
	   ,@Importe3 MONEY
	   ,@Importe4 MONEY
	   ,@Importe5 MONEY
	   ,@FormaCobro1 VARCHAR(50)
	   ,@FormaCobro2 VARCHAR(50)
	   ,@FormaCobro3 VARCHAR(50)
	   ,@FormaCobro4 VARCHAR(50)
	   ,@FormaCobro5 VARCHAR(50)
	   ,@TarjetasCobradas MONEY
	   ,@FormaCobroTarjetas VARCHAR(50)
	   ,@MovAplicaImporteTotal MONEY
	   ,@MovAplicaTipoCambio FLOAT
	   ,@MovAplicaImporteNeto MONEY
	   ,@MovAplicaFactor FLOAT
	   ,@MovAplicaMoneda VARCHAR(20)
	   ,@SubFolio VARCHAR(20)
	   ,@SaldoTotal MONEY
	   ,@NomAuto BIT
	   ,@CompraID INT
	   ,@CompraImporte MONEY
	   ,@OrigenImporte MONEY
	   ,@ConsignacionFechaCorte DATETIME
	   ,@SubMovTipo VARCHAR(20)
	   ,@ContUso VARCHAR(20)
	   ,@ContUso2 VARCHAR(20)
	   ,@ContUso3 VARCHAR(20)
	   ,@Rama VARCHAR(5)
	   ,@IDCancelaCXPCA INT
	   ,@LDI BIT
	   ,@LDITarjeta BIT
	   ,@LDIServicio VARCHAR(20)
	   ,@CFDFlex BIT
	   ,@LDIOkRef VARCHAR(255)
	   ,@LDIOk INT
	   ,@Referencia1 VARCHAR(50)
	   ,@Referencia2 VARCHAR(50)
	   ,@Referencia3 VARCHAR(50)
	   ,@Referencia4 VARCHAR(50)
	   ,@Referencia5 VARCHAR(50)
	   ,@ReferenciaTarjetas VARCHAR(50)
		 ,@OrigenTipoCxc VARCHAR(10)
	SET @LDIOkRef = NULL
	SET @LDIOk = NULL
	SELECT @LDI = ISNULL(InterfazLDI, 0)
	FROM EmpresaGral WITH(NOLOCK)
	WHERE Empresa = @Empresa
	SELECT @CFDFlex = ISNULL(CFDFlex, 0)
	FROM MovTipo WITH(NOLOCK)
	WHERE Mov = @Mov
	AND Modulo = @Modulo
	SELECT @SubMovTipo = SubClave
	FROM MovTipo WITH(NOLOCK)
	WHERE Modulo = @Modulo
	AND Mov = @Mov
	SELECT @ContactoImporte = 0.0
		  ,@SaldoNuevo = 0.0
		  ,@EsCargo = 0
		  ,@AplicaPosfechado = 0
		  ,@ComisionesFinanciadas = 0
		  ,@NomAuto = 0
	EXEC spCxAfectar2 @ID OUTPUT
					 ,@Accion OUTPUT
					 ,@Empresa OUTPUT
					 ,@Modulo OUTPUT
					 ,@Mov OUTPUT
					 ,@MovID OUTPUT
					 ,@MovTipo OUTPUT
					 ,@MovMoneda OUTPUT
					 ,@MovTipoCambio OUTPUT
					 ,@FechaEmision OUTPUT
					 ,@FechaAfectacion OUTPUT
					 ,@Concepto OUTPUT
					 ,@Usuario OUTPUT
					 ,@Estatus OUTPUT
					 ,@FechaRegistro OUTPUT
					 ,@Ejercicio OUTPUT
					 ,@Periodo OUTPUT
					 ,@Contacto OUTPUT
					 ,@ContactoEnviarA OUTPUT
					 ,@Importe OUTPUT
					 ,@Impuestos OUTPUT
					 ,@Retencion OUTPUT
					 ,@Retencion2 OUTPUT
					 ,@Retencion3 OUTPUT
					 ,@Comisiones OUTPUT
					 ,@ComisionesIVA OUTPUT
					 ,@Saldo OUTPUT
					 ,@SaldoInteresesOrdinarios OUTPUT
					 ,@SaldoInteresesMoratorios OUTPUT
					 ,@CtaDinero OUTPUT
					 ,@Cajero OUTPUT
					 ,@Conexion OUTPUT
					 ,@SincroFinal OUTPUT
					 ,@Sucursal OUTPUT
					 ,@SucursalDestino OUTPUT
					 ,@SucursalOrigen OUTPUT
					 ,@CfgCobroImpuestos OUTPUT
					 ,@CfgVentaLimiteNivelSucursal OUTPUT
					 ,@CfgSugerirProntoPago OUTPUT
					 ,@CfgAC OUTPUT
					 ,@TipoAmortizacion OUTPUT
					 ,@Generar OUTPUT
					 ,@GenerarMov OUTPUT
					 ,@GenerarSerie OUTPUT
					 ,@RedondeoMonetarios OUTPUT
					 ,@IDGenerar OUTPUT
					 ,@GenerarMovID OUTPUT
					 ,@Ok OUTPUT
					 ,@OkRef OUTPUT
					 ,@Base OUTPUT
					 ,@ComisionesFinanciadas OUTPUT
					 ,@ImporteTotal OUTPUT
					 ,@Limite OUTPUT
					 ,@VentaNeta OUTPUT
					 ,@LimiteDesde OUTPUT
					 ,@LimiteHasta OUTPUT
					 ,@Excedente OUTPUT
					 ,@GenerarEstatus OUTPUT
					 ,@GenerarMovTipo OUTPUT
					 ,@GenerarSubMovTipo OUTPUT
					 ,@GenerarPolizaTemp OUTPUT
					 ,@GenerarPeriodo OUTPUT
					 ,@GenerarEjercicio OUTPUT
					 ,@DescuentoRecargos OUTPUT
					 ,@ImpuestoAdicional OUTPUT
					 ,@Metodo OUTPUT
					 ,@ImporteD OUTPUT
					 ,@SaldoSinImpuestos OUTPUT
					 ,@TasaDiaria OUTPUT
					 ,@Dias OUTPUT
					 ,@SubMovTipo OUTPUT
					 ,@ConsignacionFechaCorte OUTPUT
					 ,@SaldoTotal OUTPUT
					 ,@Porcentaje OUTPUT
					 ,@ImporteSinImpuestos OUTPUT
					 ,@GenerarAplicaManual OUTPUT
					 ,@SaldoInteresesOrdinariosIVA OUTPUT
					 ,@SaldoInteresesMoratoriosIVA OUTPUT

	IF @Accion IN ('CONSECUTIVO', 'SINCRO')
		RETURN

	IF @Generar = 1
		AND @Ok IS NULL
		RETURN

	IF @OK IS NOT NULL
		RETURN

	IF @Conexion = 0
		BEGIN TRANSACTION

	EXEC spMovEstatus @Modulo
					 ,'AFECTANDO'
					 ,@ID
					 ,@Generar
					 ,@IDGenerar
					 ,@GenerarAfectado
					 ,@Ok OUTPUT

	IF @Accion <> 'CANCELAR'
		AND @Ok IS NULL
		EXEC spRegistrarMovimiento @Sucursal
								  ,@Empresa
								  ,@Modulo
								  ,@Mov
								  ,@MovID
								  ,@ID
								  ,@Ejercicio
								  ,@Periodo
								  ,@FechaRegistro
								  ,@FechaEmision
								  ,@Concepto
								  ,@Proyecto
								  ,@MovMoneda
								  ,@MovTipoCambio
								  ,@Usuario
								  ,@Autorizacion
								  ,@Referencia
								  ,@DocFuente
								  ,@Observaciones
								  ,@Generar
								  ,@GenerarMov
								  ,@GenerarMovID
								  ,@IDGenerar
								  ,@Ok OUTPUT

	IF @MovTipo NOT IN ('CXC.C', 'CXC.CD', 'CXC.D', 'CXC.DM', 'CXC.RA', 'CXC.A', 'CXC.AR', 'CXC.AA', 'CXC.DE', 'CXC.F', 'CXC.FA', 'CXC.DFA', 'CXC.AF', 'CXC.CA', 'CXC.CAD', 'CXC.CAP', 'CXC.VV', 'CXC.OV', 'CXC.IM', 'CXC.RM', 'CXC.NC', 'CXC.NCD', 'CXC.NCF', 'CXC.DV', 'CXC.NCP',
		'CXP.A', 'CXP.AA', 'CXP.DE', 'CXP.F', 'CXP.AF', 'CXP.CA', 'CXP.CAD', 'CXP.CAP', 'CXP.NC', 'CXP.NCD', 'CXP.NCF', 'CXP.NCP',
		'AGENT.P', 'AGENT.CO', 'CXC.FAC', 'CXP.FAC')
		SELECT @Impuestos = 0.0

	SELECT @ImporteTotal = @Importe + @Impuestos - @Retencion - @Retencion2 - @Retencion3

	IF @ComisionesFinanciadas = 1
		SELECT @ImporteTotal = @ImporteTotal + ISNULL(@Comisiones, 0.0) + ISNULL(@ComisionesIVA, 0.0)

	IF @Accion <> 'CANCELAR'
		AND @Ok IS NULL
		AND @MovTipo IN ('CXC.NCD', 'CXC.DV', 'CXC.A', 'CXC.AR', 'CXC.AA', 'CXC.VV', 'CXC.OV', 'CXC.F', 'CXC.CD', 'CXC.DE', 'CXC.DI', 'CXC.AJE', 'CXC.AJR', 'CXC.FA', 'CXC.AF',
		'CXP.NCD', 'CXP.A', 'CXP.AA', 'CXP.F', 'CXP.AF', 'CXP.CD', 'CXP.DE', 'CXP.AJE', 'CXP.AJR',
		'CXC.SD', 'CXC.SCH', 'CXP.SD', 'CXP.SCH')
		OR (@MovTipo IN ('CXC.NC', 'CXC.NCD', 'CXC.NCF', 'CXP.NC', 'CXP.NCD', 'CXP.NCF') AND @AplicaManual = 0)
	BEGIN

		IF @Modulo = 'CXC'
			DELETE CxcD
			WHERE ID = @ID
		ELSE

		IF @Modulo = 'CXP'
			DELETE CxpD
			WHERE ID = @ID

	END

	IF @MovTipo IN ('CXP.CD')
		AND @Accion IN ('CANCELAR')
		AND @OrigenTipo IN ('DIN')
		AND @Ok IS NULL
	BEGIN
		UPDATE Dinero WITH(ROWLOCK)
		SET ChequeDevuelto = 0
		WHERE ID = @IDOrigen

		IF @@ERROR <> 0
			SET @Ok = 1

	END

	IF @MovTipo IN ('CXC.F', 'CXC.CA', 'CXC.CAP', 'CXC.CAD', 'CXC.D', 'CXC.DM', 'CXP.F', 'CXP.CA', 'CXP.CAP', 'CXP.CAD', 'CXP.D', 'CXP.DM')
		AND @Condicion IS NOT NULL
	BEGIN

		IF @CfgAC = 1
			OR EXISTS (SELECT * FROM Condicion WITH(NOLOCK) WHERE Condicion = @Condicion AND DA = 1)
			EXEC spCxCancelarDocAuto @Empresa
									,@Usuario
									,@Modulo
									,@ID
									,@Mov
									,@MovID
									,0
									,@FechaRegistro
									,@Ok OUTPUT
									,@OkRef OUTPUT

	END

	IF @Accion = 'AFECTAR'
		AND @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR')
	BEGIN

		IF (
				SELECT Sincro
				FROM Version WITH(NOLOCK)
			)
			= 1
		BEGIN

			IF @Modulo = 'CXC'
				EXEC sp_executesql N'UPDATE CxcD WITH(ROWLOCK) SET Sucursal = @Sucursal, SincroC = 1 WHERE ID = @ID AND (Sucursal <> @Sucursal OR SincroC <> 1)'
								  ,N'@Sucursal int, @ID int'
								  ,@Sucursal
								  ,@ID
			ELSE

			IF @Modulo = 'CXP'
				EXEC sp_executesql N'UPDATE CxpD WITH(ROWLOCK) SET Sucursal = @Sucursal, SincroC = 1 WHERE ID = @ID AND (Sucursal <> @Sucursal OR SincroC <> 1)'
								  ,N'@Sucursal int, @ID int'
								  ,@Sucursal
								  ,@ID
			ELSE

			IF @Modulo = 'AGENT'
				EXEC sp_executesql N'UPDATE AgentD WITH(ROWLOCK) SET Sucursal = @Sucursal, SincroC = 1 WHERE ID = @ID AND (Sucursal <> @Sucursal OR SincroC <> 1)'
								  ,N'@Sucursal int, @ID int'
								  ,@Sucursal
								  ,@ID

		END

	END

	IF @MovTipo IN ('CXC.FAC', 'CXC.DAC', 'CXP.FAC', 'CXP.DAC')
		AND @Accion = 'AFECTAR'
	BEGIN

		IF @Modulo = 'CXC'
			SELECT @IVAFiscal = IVAFiscal
				  ,@IEPSFiscal = IEPSFiscal
				  ,@Condicion = '(Fecha)'
				  ,@Vencimiento = Vencimiento
			FROM Cxc WITH(NOLOCK)
			WHERE Empresa = @Empresa
			AND Mov = @MovAplica
			AND MovID = @MovAplicaID
			AND Estatus = 'PENDIENTE'
		ELSE

		IF @Modulo = 'CXP'
			SELECT @IVAFiscal = IVAFiscal
				  ,@IEPSFiscal = IEPSFiscal
				  ,@Condicion = '(Fecha)'
				  ,@Vencimiento = Vencimiento
			FROM Cxp WITH(NOLOCK)
			WHERE Empresa = @Empresa
			AND Mov = @MovAplica
			AND MovID = @MovAplicaID
			AND Estatus = 'PENDIENTE'

	END

	IF @MovTipo = 'CXP.PAG'
		AND @Accion = 'CANCELAR'
		AND @Ok IS NULL
	BEGIN
		SELECT @AforoID = NULL
		SELECT @AforoID = DID
			  ,@AforoMov = DMov
			  ,@AforoMovID = DMovID
		FROM MovFlujo WITH(NOLOCK)
		WHERE Cancelado = 0
		AND Empresa = @Empresa
		AND OModulo = @Modulo
		AND OID = @ID
		AND DModulo = @Modulo

		IF @AforoID IS NOT NULL
		BEGIN
			EXEC spCx @AforoID
					 ,@Modulo
					 ,@Accion
					 ,'TODO'
					 ,@FechaEmision
					 ,NULL
					 ,@Usuario
					 ,1
					 ,0
					 ,@AforoMov OUTPUT
					 ,@AforoMovID OUTPUT
					 ,@IDGenerar OUTPUT
					 ,@Ok OUTPUT
					 ,@OkRef OUTPUT
			EXEC spMovFlujo @Sucursal
						   ,@Accion
						   ,@Empresa
						   ,@Modulo
						   ,@ID
						   ,@Mov
						   ,@MovID
						   ,@Modulo
						   ,@AforoID
						   ,@AforoMov
						   ,@AforoMovID
						   ,@Ok OUTPUT
		END

	END

	IF @MovTipo = 'CXC.DFA'
		AND (@Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') OR @EstatusNuevo = 'CANCELADO')
	BEGIN

		IF @Accion = 'CANCELAR'
			SELECT @EsCargo = 1
		ELSE
			SELECT @EsCargo = 0

		IF @Accion = 'CANCELAR'
			UPDATE Cxc WITH(ROWLOCK)
			SET AnticipoSaldo = ISNULL(AnticipoSaldo, 0) + vfa.Importe
			FROM Cxc c, CxcFacturaAnticipo vfa WITH(NOLOCK)
			WHERE vfa.ID = @ID
			AND vfa.CxcID = c.ID
		ELSE
		BEGIN
			SELECT @SumaAnticiposFacturados = SUM(AnticipoAplicar)
			FROM Cxc WITH(NOLOCK)
			WHERE AnticipoAplicaModulo = @Modulo
			AND AnticipoAplicaID = @ID

			IF @ImporteTotal <> @SumaAnticiposFacturados
				SELECT @Ok = 30405
			ELSE

			IF EXISTS (SELECT * FROM Cxc WITH(NOLOCK) WHERE AnticipoAplicaModulo = @Modulo AND AnticipoAplicaID = @ID AND (ISNULL(AnticipoAplicar, 0) < 0.0 OR ROUND(AnticipoAplicar, 0) > ROUND(AnticipoSaldo, 0)))
				SELECT @Ok = 30405
			ELSE
			BEGIN
				INSERT CxcFacturaAnticipo (ID, CxcID, Importe)
					SELECT @ID
						  ,ID
						  ,AnticipoAplicar
					FROM Cxc WITH(NOLOCK)
					WHERE AnticipoAplicaModulo = @Modulo
					AND AnticipoAplicaID = @ID
				UPDATE Cxc WITH(ROWLOCK)
				SET AnticipoSaldo = ISNULL(AnticipoSaldo, 0) - ISNULL(AnticipoAplicar, 0)
				   ,AnticipoAplicar = NULL
				   ,AnticipoAplicaModulo = NULL
				   ,AnticipoAplicaID = NULL
				WHERE AnticipoAplicaModulo = @Modulo
				AND AnticipoAplicaID = @ID
			END

		END

		IF @Ok IS NULL
			EXEC spSaldo @Sucursal
						,@Accion
						,@Empresa
						,@Usuario
						,'CANT'
						,@ContactoMoneda
						,@ContactoTipoCambio
						,@Contacto
						,NULL
						,NULL
						,NULL
						,@Modulo
						,@ID
						,@Mov
						,@MovID
						,@EsCargo
						,@ImporteTotal
						,NULL
						,NULL
						,@FechaAfectacion
						,@Ejercicio
						,@Periodo
						,@Mov
						,@MovID
						,0
						,0
						,0
						,@Ok OUTPUT
						,@OkRef OUTPUT

	END

	IF @Ok IS NULL
	BEGIN

		IF (@MovTipo IN ('CXC.AF', 'CXC.AA', 'CXC.C', 'CXC.AJM', 'CXC.AJA', 'CXC.NET', 'CXC.DC', 'CXC.D', 'CXC.DM', 'CXC.DA', 'CXC.DP', 'CXC.AE', 'CXC.ANC', 'CXC.ACA', 'CXP.ACA', 'CXC.IM', 'CXC.RM',
			'CXP.AF', 'CXP.AA', 'CXP.P', 'CXP.AJM', 'CXP.AJA', 'CXP.NET', 'CXP.D', 'CXP.DM', 'CXP.PAG', 'CXP.DA', 'CXP.DC', 'CXP.DP', 'CXP.AE', 'CXP.ANC',
			'AGENT.P', 'AGENT.CO'))
			OR (@MovTipo IN ('CXC.NC', 'CXC.NCD', 'CXC.CA', 'CXC.CAD', 'CXC.CAP', 'CXC.NCF', 'CXC.DV', 'CXC.NCP',
			'CXP.NC', 'CXP.NCD', 'CXP.CA', 'CXP.CAD', 'CXP.CAP', 'CXP.NCF', 'CXP.NCP') AND @AplicaManual = 1)
		BEGIN

			IF @AplicaManual = 0
				AND @Modulo IN ('CXC', 'CXP')
				AND @Accion <> 'CANCELAR'
				AND @MovTipo NOT IN ('CXC.IM', 'CXC.RM')
			BEGIN

				IF @Modulo = 'CXC'
					DELETE CxcD
					WHERE ID = @ID
				ELSE

				IF @Modulo = 'CXP'
					DELETE CxpD
					WHERE ID = @ID

				IF @@ERROR <> 0
					SELECT @Ok = 1

				IF @MovTipo NOT IN ('CXC.AF', 'CXC.AA', 'CXC.DC', 'CXP.AF', 'CXP.AA', 'CXP.DC')
					EXEC spCxAutoAplicacion @Sucursal
										   ,@Empresa
										   ,@Modulo
										   ,@ID
										   ,@Mov
										   ,@MovID
										   ,@MovMoneda
										   ,@MovTipoCambio
										   ,@Contacto
										   ,@ContactoMoneda
										   ,@ContactoFactor
										   ,@ContactoTipoCambio
										   ,@ImporteTotal
										   ,@Accion
										   ,@FechaEmision
										   ,@Referencia
										   ,@Condicion
										   ,@Vencimiento
										   ,@Proyecto
										   ,@Usuario
										   ,@CfgAplicaAutoOrden
										   ,@CfgMovCargoDiverso
										   ,@CfgMovCreditoDiverso
										   ,@Ok OUTPUT
										   ,@OkRef OUTPUT

			END

			EXEC spCxAplicar @ID
							,@Accion
							,@Empresa
							,@Usuario
							,@Modulo
							,@Mov
							,@MovID
							,@MovTipo
							,@MovMoneda
							,@MovTipoCambio
							,@Referencia
							,@Concepto
							,@Proyecto
							,@Condicion
							,@Vencimiento
							,@FechaEmision
							,@FechaAfectacion
							,@FechaRegistro
							,@Ejercicio
							,@Periodo
							,@Contacto
							,@ContactoEnviarA
							,@ContactoMoneda
							,@ContactoFactor
							,@ContactoTipoCambio
							,@Agente
							,@Importe
							,@Impuestos
							,@Retencion
							,@Retencion2
							,@Retencion3
							,@ImporteTotal
							,@Conexion
							,@SincroFinal
							,@Sucursal
							,@SucursalDestino
							,@SucursalOrigen
							,@OrigenTipo
							,@OrigenMovTipo
							,@MovAplica
							,@MovAplicaID
							,@MovAplicaMovTipo
							,@CfgContX
							,@CfgContXGenerar
							,@CfgEmbarcar
							,@AutoAjuste
							,@AutoAjusteMov
							,@CfgDescuentoRecargos
							,NULL
							,@CfgComisionCreditos
							,@CfgMovCargoDiverso
							,@CfgMovCreditoDiverso
							,@CfgVentaComisionesCobradas
							,@CfgComisionBase
							,@CfgRetencionAlPago
							,@CfgRetencionMov
							,@CfgRetencionAcreedor
							,@CfgRetencionConcepto
							,@CfgRetencion2Acreedor
							,@CfgRetencion2Concepto
							,@CfgRetencion3Acreedor
							,@CfgRetencion3Concepto
							,@CfgAC
							,0
							,@TieneDescuentoRecargos OUTPUT
							,@AplicaPosfechado OUTPUT
							,@ImporteAplicado OUTPUT
							,@RedondeoMonetarios
							,@Ok OUTPUT
							,@OkRef OUTPUT

			IF @MovTipo IN ('AGENT.P', 'AGENT.CO')
			BEGIN
				SELECT @Impuestos = 0.0
					  ,@Retencion = 0.0
					  ,@Retencion2 = 0.0
					  ,@Retencion3 = 0.0
				SELECT @Importe = SUM(Importe)
				FROM AgentD WITH(NOLOCK)
				WHERE ID = @ID
				SELECT @Impuestos = @Importe * (@ImpuestosPorcentaje / 100)
					  ,@Retencion = @Importe * (@RetencionPorcentaje / 100)
				SELECT @ImporteTotal = @Importe + @Impuestos - @Retencion - @Retencion2 - @Retencion3
			END

		END

		SELECT @ContactoImporte = @ImporteTotal / @ContactoFactor
	END

	IF @Modulo = 'CXP'
		AND @Accion = 'CANCELAR'

		IF EXISTS (SELECT * FROM Cxp c WITH(NOLOCK) JOIN MovTipo mt WITH(NOLOCK) ON mt.Modulo = 'CXP' AND c.Mov = mt.Mov AND mt.Clave = 'CXP.RE' JOIN CxpD d WITH(NOLOCK) ON c.ID = d.ID WHERE c.Estatus = 'CONCLUIDO' AND c.Empresa = @Empresa AND d.Aplica = @Mov AND d.AplicaID = @MovID)
			SELECT @Ok = 30411

	IF @Modulo = 'CXC'
		AND @Accion = 'CANCELAR'

		IF EXISTS (SELECT * FROM Cxc c WITH(NOLOCK) JOIN MovTipo mt WITH(NOLOCK) ON mt.Modulo = 'CXC' AND c.Mov = mt.Mov AND mt.Clave = 'CXC.RE' JOIN CxcD d WITH(NOLOCK) ON c.ID = d.ID WHERE c.Estatus = 'CONCLUIDO' AND c.Empresa = @Empresa AND d.Aplica = @Mov AND d.AplicaID = @MovID)
			SELECT @Ok = 30411

	IF @OrigenTipo = 'AUTO/RE'
		AND @Accion IN ('AFECTAR', 'CANCELAR')
		AND @Ok IS NULL
		EXEC spCxAplicarReevaluacion @ID
									,@Accion
									,@Empresa
									,@Usuario
									,@Modulo
									,@Mov
									,@MovID
									,@MovTipo
									,@Contacto
									,@ContactoMoneda
									,@ContactoTipoCambio
									,@Ok OUTPUT
									,@OkRef OUTPUT

	IF @MovTipo IN ('CXC.INT', 'CXP.INT')
		AND @Accion IN ('AFECTAR', 'CANCELAR')
		AND @Ok IS NULL
		EXEC spCxAplicarIntereses @ID
								 ,@Accion
								 ,@Empresa
								 ,@Usuario
								 ,@Modulo
								 ,@Mov
								 ,@MovID
								 ,@MovTipo
								 ,@MovMoneda
								 ,@MovTipoCambio
								 ,@FechaEmision
								 ,@Ok OUTPUT
								 ,@OkRef OUTPUT

	IF @MovTipo IN ('CXC.DESCINFLACION', 'CXP.DESCINFLACION')
		AND @Accion IN ('AFECTAR', 'CANCELAR')
		AND @Ok IS NULL
		EXEC spCxAplicarIVADescuentoInflacion @ID
											 ,@Accion
											 ,@Empresa
											 ,@Usuario
											 ,@Modulo
											 ,@Mov
											 ,@MovID
											 ,@MovTipo
											 ,@MovMoneda
											 ,@MovTipoCambio
											 ,@FechaEmision
											 ,@Ok OUTPUT
											 ,@OkRef OUTPUT

	IF (@MovTipo IN ('CXP.D') AND @SubMovTipo IN ('CXP.SLCCORTE'))
		AND ((@Accion IN ('AFECTAR') AND @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR')) OR (@Accion IN ('CANCELAR') AND @Estatus IN ('PENDIENTE')))
		AND @Ok IS NULL
	BEGIN
		SELECT @ConsignacionFechaCorte = dbo.fnFechaSinHora(ConsignacionFechaCorte)
		FROM Cxp WITH(NOLOCK)
		WHERE ID = @ID
		EXEC spCxpSLCCorte @@SPID
						  ,@Modulo
						  ,@IDOrigen
						  ,@ID
						  ,@Mov
						  ,@MovID
						  ,@ConsignacionFechaCorte
						  ,@Accion
						  ,@Estatus
						  ,@EstatusNuevo
						  ,@Ok OUTPUT
						  ,@OkRef OUTPUT
	END

	IF @Ok IS NULL
	BEGIN

		IF (@MovTipo IN ('CXC.A', 'CXC.AR', 'CXC.FAC', 'CXC.DAC', 'CXC.F', 'CXC.FA', 'CXC.AF', 'CXC.VV', 'CXC.IM', 'CXC.RM', 'CXC.CD', 'CXC.D', 'CXC.DM', 'CXC.DA', 'CXC.DP',
			'CXP.A', 'CXP.F', 'CXP.AF', 'CXP.CD', 'CXP.D', 'CXP.DM', 'CXP.PAG', 'CXP.DA', 'CXP.DP',
			'CXP.FAC', 'CXP.DAC',
			'CXC.SD', 'CXC.SCH', 'CXP.SD', 'CXP.SCH',
			'AGENT.C', 'AGENT.D', 'AGENT.A'))
			OR (@MovTipo IN ('CXC.NC', 'CXC.NCD', 'CXC.NCF', 'CXC.CA', 'CXC.CAD', 'CXC.CAP', 'CXC.NCP', 'CXC.DV',
			'CXP.NC', 'CXP.NCD', 'CXP.NCF', 'CXP.CA', 'CXP.CAD', 'CXP.CAP', 'CXP.NCP') AND @AplicaManual = 0)
		BEGIN
			SELECT @EsCargo = 1

			IF @MovTipo IN ('CXC.DAC', 'CXC.A', 'CXC.AR', 'CXC.DA', 'CXC.ACA', 'CXP.ACA', 'CXP.A', 'CXP.DA', 'CXC.NC', 'CXC.NCD', 'CXC.NCF', 'CXC.DV', 'CXC.NCP',
				'CXP.DAC', 'CXP.NC', 'CXP.NCD', 'CXP.NCF', 'CXP.NCP', 'AGENT.D', 'AGENT.A', 'CXC.SCH', 'CXP.SD')
				SELECT @EsCargo = 0

			IF @Accion = 'CANCELAR'
				SELECT @EsCargo = ~@EsCargo

			SELECT @SaldoNuevo = @ContactoImporte
			EXEC spSaldo @Sucursal
						,@Accion
						,@Empresa
						,@Usuario
						,@Modulo
						,@ContactoMoneda
						,@ContactoTipoCambio
						,@Contacto
						,NULL
						,NULL
						,NULL
						,@Modulo
						,@ID
						,@Mov
						,@MovID
						,@EsCargo
						,@SaldoNuevo
						,NULL
						,NULL
						,@FechaAfectacion
						,@Ejercicio
						,@Periodo
						,@Mov
						,@MovID
						,0
						,0
						,0
						,@Ok OUTPUT
						,@OkRef OUTPUT

			IF @MovTipo = 'CXC.FA'
				AND @Ok IS NULL
			BEGIN

				IF @Accion <> 'CANCELAR'
					UPDATE Cxc WITH(ROWLOCK)
					SET AnticipoSaldo = @SaldoNuevo
					   ,AnticipoAplicar = NULL
					   ,AnticipoAplicaModulo = NULL
					   ,AnticipoAplicaID = NULL
					WHERE ID = @ID
				ELSE
					UPDATE Cxc WITH(ROWLOCK)
					SET AnticipoAplicaModulo = NULL
					   ,AnticipoAplicaID = NULL
					   ,AnticipoAplicar = NULL
					WHERE ID = @ID

				EXEC spSaldo @Sucursal
							,@Accion
							,@Empresa
							,@Usuario
							,'CANT'
							,@ContactoMoneda
							,@ContactoTipoCambio
							,@Contacto
							,NULL
							,NULL
							,NULL
							,@Modulo
							,@ID
							,@Mov
							,@MovID
							,@EsCargo
							,@SaldoNuevo
							,NULL
							,NULL
							,@FechaAfectacion
							,@Ejercicio
							,@Periodo
							,@Mov
							,@MovID
							,0
							,0
							,0
							,@Ok OUTPUT
							,@OkRef OUTPUT
			END

			IF @Accion = 'CANCELAR'
				SELECT @SaldoNuevo = 0.0

		END
		ELSE

		IF @MovTipo IN ('CXC.AE', 'CXC.DE', 'CXC.AJE', 'CXC.AJR', 'CXP.AE', 'CXP.DE', 'CXP.AJE', 'CXP.AJR')
		BEGIN

			IF @Accion = 'CANCELAR'
				SELECT @EsCargo = 0
			ELSE
				SELECT @EsCargo = 1

			IF @Modulo = 'CXC'
			BEGIN

				IF @MovTipo = 'CXC.AJR'
					SELECT @RamaAfectar = 'CRND'
						  ,@MovAfectar = 'Redondeo'
				ELSE
					SELECT @RamaAfectar = 'CEFE'
						  ,@MovAfectar = 'Saldo a Favor'

			END
			ELSE

			IF @Modulo = 'CXP'
			BEGIN

				IF @MovTipo = 'CXP.AJR'
					SELECT @RamaAfectar = 'PRND'
						  ,@MovAfectar = 'Redondeo'
				ELSE
					SELECT @RamaAfectar = 'PEFE'
						  ,@MovAfectar = 'Saldo a Favor'

			END

			EXEC spSaldo @Sucursal
						,@Accion
						,@Empresa
						,@Usuario
						,@RamaAfectar
						,@MovMoneda
						,@MovTipoCambio
						,@Contacto
						,NULL
						,NULL
						,NULL
						,@Modulo
						,@ID
						,@Mov
						,@MovID
						,@EsCargo
						,@ImporteTotal
						,NULL
						,NULL
						,@FechaAfectacion
						,@Ejercicio
						,@Periodo
						,@MovAfectar
						,NULL
						,0
						,0
						,0
						,@Ok OUTPUT
						,@OkRef OUTPUT
		END

		IF @MovTipo IN ('CXC.ANC', 'CXC.ACA', 'CXP.ACA', 'CXC.RA', 'CXC.FAC', 'CXC.DAC', 'CXP.ANC', 'CXP.RA', 'CXP.FAC', 'CXP.DAC')
		BEGIN

			IF @Modulo = 'CXC'
				SELECT @IDAplica = ID
					  ,@MovAplicaContacto = Cliente
					  ,@MovAplicaSaldo = ISNULL(Saldo, 0.0)
					  ,@MovAplicaEstatus = Estatus
					  ,@MovAplicaRetencion = ISNULL(Retencion, 0)
					  ,@MovAplicaRetencion2 = ISNULL(Retencion2, 0.0)
					  ,@MovAplicaRetencion3 = ISNULL(Retencion3, 0.0)
					  ,@MovAplicaImporteTotal = ISNULL(Importe, 0.0) + ISNULL(Impuestos, 0.0)
					  ,@MovAplicaTipoCambio = TipoCambio
					  ,@MovAplicaMoneda = Moneda
				FROM Cxc WITH(NOLOCK)
				WHERE Empresa = @Empresa
				AND Mov = @MovAplica
				AND MovID = @MovAplicaID
				AND Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'CANCELADO')
			ELSE

			IF @Modulo = 'CXP'
				SELECT @IDAplica = ID
					  ,@MovAplicaContacto = Proveedor
					  ,@MovAplicaSaldo = ISNULL(Saldo, 0.0)
					  ,@MovAplicaEstatus = Estatus
					  ,@MovAplicaRetencionAlPago = RetencionAlPago
					  ,@MovAplicaRetencion = ISNULL(Retencion, 0)
					  ,@MovAplicaRetencion2 = ISNULL(Retencion2, 0)
					  ,@MovAplicaRetencion3 = ISNULL(Retencion3, 0)
					  ,@MovAplicaImporteTotal = ISNULL(Importe, 0.0) + ISNULL(Impuestos, 0.0)
					  ,@MovAplicaTipoCambio = TipoCambio
					  ,@MovAplicaMoneda = Moneda
				FROM Cxp WITH(NOLOCK)
				WHERE Empresa = @Empresa
				AND Mov = @MovAplica
				AND MovID = @MovAplicaID
				AND Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'CANCELADO')

			IF @@ERROR <> 0
				SELECT @Ok = 1

			SELECT @MovAplicaImporteNeto = ISNULL(@MovAplicaImporteTotal, 0.0) - ISNULL(@MovAplicaRetencion, 0.0) - ISNULL(@MovAplicaRetencion2, 0.0) - ISNULL(@MovAplicaRetencion3, 0.0)
			SELECT @MovAplicaFactor = (@ImporteTotal * @MovTipoCambio) / NULLIF(CONVERT(FLOAT, @MovAplicaImporteNeto * @MovAplicaTipoCambio), 0)

			IF @MovMoneda <> @MovAplicaMoneda
				SELECT @MovAplicaFactor = @MovAplicaFactor / @MovTipoCambio * @MovAplicaTipoCambio

			IF @MovAplicaMovTipo IN ('CXC.NCP', 'CXP.NCP')
				SELECT @AplicaPosfechado = 1

			IF @MovTipo IN ('CXC.FAC', 'CXP.FAC', 'CXC.ACA', 'CXP.ACA')
				SELECT @EsCargo = 0
			ELSE
				SELECT @EsCargo = 1

			IF @Accion = 'CANCELAR'
				SELECT @EsCargo = ~@EsCargo

			EXEC spSaldo @Sucursal
						,@Accion
						,@Empresa
						,@Usuario
						,@Modulo
						,@ContactoMoneda
						,@ContactoTipoCambio
						,@MovAplicaContacto
						,NULL
						,NULL
						,NULL
						,@Modulo
						,@ID
						,@Mov
						,@MovID
						,@EsCargo
						,@ContactoImporte
						,NULL
						,NULL
						,@FechaAfectacion
						,@Ejercicio
						,@Periodo
						,@MovAplica
						,@MovAplicaID
						,0
						,0
						,0
						,@Ok OUTPUT
						,@OkRef OUTPUT

			IF @Accion = 'CANCELAR'
				SELECT @MovAplicaSaldo = @MovAplicaSaldo + @ContactoImporte
			ELSE
				SELECT @MovAplicaSaldo = @MovAplicaSaldo - @ContactoImporte

			SELECT @MovAplicaSaldo = NULLIF(@MovAplicaSaldo, 0.0)

			IF @MovAplicaSaldo IS NULL
				SELECT @MovAplicaEstatus = 'CONCLUIDO'
			ELSE
				SELECT @MovAplicaEstatus = 'PENDIENTE'

			IF @MovAplicaEstatus = 'CONCLUIDO'
				SELECT @FechaConclusion = @FechaEmision
			ELSE

			IF @MovAplicaEstatus <> 'CANCELADO'
				SELECT @FechaConclusion = NULL

			EXEC spValidarTareas @Empresa
								,@Modulo
								,@IDAplica
								,@MovAplicaEstatus
								,@Ok OUTPUT
								,@OkRef OUTPUT

			IF @Modulo = 'CXC'
				UPDATE Cxc WITH(ROWLOCK)
				SET Saldo = @MovAplicaSaldo
				   ,UltimoCambio = @FechaEmision
				   ,FechaConclusion = @FechaConclusion
				   ,Estatus = @MovAplicaEstatus
				WHERE ID = @IDAplica
			ELSE

			IF @Modulo = 'CXP'
				UPDATE Cxp WITH(ROWLOCK)
				SET Saldo = @MovAplicaSaldo
				   ,UltimoCambio = @FechaEmision
				   ,FechaConclusion = @FechaConclusion
				   ,Estatus = @MovAplicaEstatus
				WHERE ID = @IDAplica

			IF @@ERROR <> 0
				SELECT @Ok = 1

			IF @MovTipo IN ('CXC.FAC', 'CXP.FAC', 'CXC.RA', 'CXP.RA', 'CXC.DAC', 'CXP.DAC')
				AND @Accion <> 'CANCELAR'
				INSERT MovImpuesto (Modulo, ModuloID, OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenDeducible, OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, Importe1, Importe2, Importe3, SubTotal, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal)
					SELECT @Modulo
						  ,@ID
						  ,OrigenModulo
						  ,OrigenModuloID
						  ,OrigenConcepto
						  ,ISNULL(OrigenDeducible, 100)
						  ,OrigenFecha
						  ,LoteFijo
						  ,Retencion1
						  ,Retencion2
						  ,Retencion3
						  ,Excento1
						  ,Excento2
						  ,Excento3
						  ,Impuesto1
						  ,Impuesto2
						  ,Impuesto3
						  ,TipoImpuesto1
						  ,TipoImpuesto2
						  ,TipoImpuesto3
						  ,TipoRetencion1
						  ,TipoRetencion2
						  ,TipoRetencion3
						  ,Importe1 * @MovAplicaFactor
						  ,Importe2 * @MovAplicaFactor
						  ,Importe3 * @MovAplicaFactor
						  ,SubTotal * @MovAplicaFactor
						  ,ContUso
						  ,ContUso2
						  ,ContUso3
						  ,ClavePresupuestal
						  ,ClavePresupuestalImpuesto1
						  ,DescuentoGlobal
					FROM MovImpuesto WITH(NOLOCK)
					WHERE Modulo = @Modulo
					AND ModuloID = @IDAplica

			EXEC spMovFlujo @Sucursal
						   ,@Accion
						   ,@Empresa
						   ,@Modulo
						   ,@IDAplica
						   ,@MovAplica
						   ,@MovAplicaID
						   ,@Modulo
						   ,@ID
						   ,@Mov
						   ,@MovID
						   ,@Ok OUTPUT
		END

	END

	IF @Ok IS NULL
		OR (@Ok BETWEEN 80030 AND 81000)
	BEGIN

		IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR')
			AND @Accion <> 'CANCELAR'
		BEGIN

			IF @MovTipo IN ('CXC.F', 'CXC.AF', 'CXC.FAC', 'CXC.DAC', 'CXC.FA', 'CXC.CA', 'CXC.CAD', 'CXC.CAP', 'CXC.VV', 'CXC.CD', 'CXC.D', 'CXC.DM', 'CXC.DA', 'CXC.DP', 'CXC.NCP',
				'CXP.F', 'CXP.AF', 'CXP.FAC', 'CXP.DAC', 'CXP.CA', 'CXP.CAD', 'CXP.CAP', 'CXP.CD', 'CXP.D', 'CXP.DM', 'CXP.PAG', 'CXP.DA', 'CXP.DP', 'CXP.NCP', 'CXP.P')
				EXEC spCalcularVencimientoPP @Modulo
											,@Empresa
											,@Contacto
											,@Condicion
											,@FechaEmision
											,@Vencimiento OUTPUT
											,@Dias OUTPUT
											,@FechaProntoPago OUTPUT
											,@DescuentoProntoPago OUTPUT
											,@Tasa OUTPUT
											,@Ok OUTPUT
			ELSE
			BEGIN
				SELECT @Condicion = NULL
					  ,@Vencimiento = @FechaEmision
				EXEC spExtraerFecha @Vencimiento OUTPUT
			END

		END

		IF @MovTipo IN ('CXC.A', 'CXC.AR', 'CXC.AA', 'CXC.AF', 'CXP.A', 'CXP.AA', 'CXP.AF')
			EXEC spGenerarAP @Sucursal
							,@Accion
							,@Empresa
							,@Modulo
							,@ID
							,@MovTipo
							,@FechaRegistro
							,@Mov
							,@MovID
							,@MovMoneda
							,@MovTipoCambio
							,@Proyecto
							,@Contacto
							,@Referencia
							,NULL
							,@FechaEmision
							,@ImporteTotal
							,@Ok OUTPUT
							,@OkRef OUTPUT

		IF @EstatusNuevo <> 'PENDIENTE'
			AND @SaldoNuevo > 0.0
			SELECT @EstatusNuevo = 'PENDIENTE'

		IF @EstatusNuevo = 'PENDIENTE'
			AND @SaldoNuevo = 0.0
			AND @RamaID IS NULL
			SELECT @EstatusNuevo = 'CONCLUIDO'

		IF @EstatusNuevo = 'CANCELADO'
			SELECT @FechaCancelacion = @FechaRegistro
		ELSE
			SELECT @FechaCancelacion = NULL

		IF @EstatusNuevo = 'CONCLUIDO'
			SELECT @FechaConclusion = @FechaEmision
		ELSE

		IF @EstatusNuevo <> 'CANCELADO'
			SELECT @FechaConclusion = NULL

		IF @CfgContX = 1
			AND @CfgContXGenerar <> 'NO'
		BEGIN

			IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR')
				AND @EstatusNuevo <> 'CANCELADO'
				SELECT @GenerarPoliza = 1
			ELSE

			IF @Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR')
				AND @EstatusNuevo = 'CANCELADO'

				IF @GenerarPoliza = 1
					SELECT @GenerarPoliza = 0
				ELSE
					SELECT @GenerarPoliza = 1

		END

		IF @SaldoNuevo = 0.0
			SELECT @SaldoNuevo = NULL

		IF @Modulo IN ('CXC', 'CXP')
		BEGIN

			IF NULLIF(@IVAFiscal, 0) IS NULL
			BEGIN

				IF NULLIF(@Impuestos, 0) IS NULL
				BEGIN

					IF @Modulo = 'CXC'
						SELECT @IVAFiscal = SUM(d.Importe * a.IVAFiscal) / NULLIF(SUM(d.Importe), 0.0)
						FROM CxcD d WITH(NOLOCK)
							,Cxc a WITH(NOLOCK)
						WHERE d.Aplica = a.Mov
						AND d.AplicaID = a.MovID
						AND a.Empresa = @Empresa
						AND d.id = @ID
						AND UPPER(Estatus) NOT IN ('SINAFECTAR', 'CANCELADO')
					ELSE

					IF @Modulo = 'CXP'
						SELECT @IVAFiscal = SUM(d.Importe * a.IVAFiscal) / NULLIF(SUM(d.Importe), 0.0)
						FROM CxpD d WITH(NOLOCK)
							,Cxp a WITH(NOLOCK)
						WHERE d.Aplica = a.Mov
						AND d.AplicaID = a.MovID
						AND a.Empresa = @Empresa
						AND d.id = @ID
						AND UPPER(Estatus) NOT IN ('SINAFECTAR', 'CANCELADO')

				END

				IF NULLIF(@IVAFiscal, 0) IS NULL
					AND NULLIF(@IEPSFiscal, 0) IS NULL
					SELECT @IVAFiscal = CONVERT(FLOAT, NULLIF(@Impuestos, 0)) / NULLIF(@ImporteTotal, 0)

			END

			IF NULLIF(@IEPSFiscal, 0) IS NULL
			BEGIN

				IF @Modulo = 'CXC'
					SELECT @IEPSFiscal = SUM(d.Importe * a.IEPSFiscal) / SUM(d.Importe)
					FROM CxcD d WITH(NOLOCK)
						,CxcAplica a WITH(NOLOCK)
					WHERE d.Aplica = a.Mov
					AND d.AplicaID = a.MovID
					AND a.Empresa = @Empresa
					AND d.id = @ID
				ELSE

				IF @Modulo = 'CXP'
					SELECT @IEPSFiscal = SUM(d.Importe * a.IEPSFiscal) / SUM(d.Importe)
					FROM CxpD d WITH(NOLOCK)
						,CxpAplica a WITH(NOLOCK)
					WHERE d.Aplica = a.Mov
					AND d.AplicaID = a.MovID
					AND a.Empresa = @Empresa
					AND d.id = @ID

			END

		END

		EXEC spValidarTareas @Empresa
							,@Modulo
							,@ID
							,@EstatusNuevo
							,@Ok OUTPUT
							,@OkRef OUTPUT

		IF @Tasa IS NOT NULL
			EXEC spVerTasaDiaria @Tasa
								,@FechaEmision
								,@TasaDiaria OUTPUT
								,@Ok OUTPUT
								,@OkRef OUTPUT

		IF @Modulo = 'CXC'
		BEGIN
			SELECT @FechaRevision = @FechaEmision
			SELECT @DiaRevision = DiaRevision1
			FROM Cte WITH(NOLOCK)
			WHERE Cliente = @Contacto
			EXEC spRecorrerVencimiento @DiaRevision
									  ,@FechaRevision OUTPUT
			UPDATE Cxc WITH(ROWLOCK)
			SET Concepto = @Concepto
			   ,Impuestos = @Impuestos
			   ,IVAFiscal = @IVAFiscal
			   ,IEPSFiscal = @IEPSFiscal
			   ,Saldo = @SaldoNuevo
			   ,UltimoCambio = @FechaEmision
			   ,FechaConclusion = @FechaConclusion
			   ,FechaCancelacion = @FechaCancelacion
			   ,Estatus = @EstatusNuevo
			   ,Situacion =
				CASE
					WHEN @Estatus <> @EstatusNuevo THEN NULL
					ELSE Situacion
				END
			   ,GenerarPoliza = @GenerarPoliza
			   ,FechaProntoPago = @FechaProntoPago
			   ,DescuentoProntoPago = @DescuentoProntoPago
			   ,Condicion = @Condicion
			   ,Vencimiento = @Vencimiento
			   ,Tasa = @Tasa
			   ,TasaDiaria = ISNULL(@TasaDiaria, TasaDiaria)
			   ,Autorizacion = @Autorizacion
			   ,FechaRevision = @FechaRevision
			WHERE ID = @ID

			IF ISNULL(@Origen, '') = ''
				AND ISNULL(@OrigenID, '') = ''
				AND @Mov = 'Aplicacion'
				UPDATE Cxc WITH(ROWLOCK)
				SET Origen = @MovAplica
				   ,OrigenID = @MovAplicaID
				WHERE ID = @ID

			IF EXISTS (SELECT ID FROM Venta WITH(NOLOCK) WHERE MovID = @MovID AND Mov = @Mov AND Empresa = @Empresa AND Sucursal = @Sucursal)
				AND @OrigenTipo = 'VTAS'
			BEGIN
				SELECT @IVAFiscal = IVAFiscal
				FROM Venta WITH(NOLOCK)
				WHERE MovID = @MovID
				AND Mov = @Mov
				AND Empresa = @Empresa
				AND Sucursal = @Sucursal

				IF ISNULL(@IVAFiscal, 0) = 0
					UPDATE Cxc WITH(ROWLOCK)
					SET IVAFiscal = @IVAFiscal
					WHERE ID = @ID

			END

		END
		ELSE

		IF @Modulo = 'CXP'
		BEGIN
			UPDATE Cxp WITH(ROWLOCK)
			SET Concepto = @Concepto
			   ,Impuestos = @Impuestos
			   ,IVAFiscal = @IVAFiscal
			   ,IEPSFiscal = @IEPSFiscal
			   ,Saldo = @SaldoNuevo
			   ,UltimoCambio = @FechaEmision
			   ,FechaConclusion = @FechaConclusion
			   ,FechaCancelacion = @FechaCancelacion
			   ,Estatus = @EstatusNuevo
			   ,Situacion =
				CASE
					WHEN @Estatus <> @EstatusNuevo THEN NULL
					ELSE Situacion
				END
			   ,GenerarPoliza = @GenerarPoliza
			   ,FechaProntoPago = @FechaProntoPago
			   ,DescuentoProntoPago = @DescuentoProntoPago
			   ,Condicion = @Condicion
			   ,Vencimiento = @Vencimiento
			   ,Tasa = @Tasa
			   ,TasaDiaria = ISNULL(@TasaDiaria, TasaDiaria)
			   ,Autorizacion = @Autorizacion
			   ,Mensaje = NULL
			WHERE ID = @ID

			IF EXISTS (SELECT ID FROM Compra WITH(NOLOCK) WHERE MovID = @MovID AND Mov = @Mov AND Empresa = @Empresa AND Sucursal = @Sucursal)
				AND @OrigenTipo = 'COMS'
			BEGIN
				SELECT @IVAFiscal = IVAFiscal
				FROM Compra WITH(NOLOCK)
				WHERE MovID = @MovID
				AND Mov = @Mov
				AND Empresa = @Empresa
				AND Sucursal = @Sucursal

				IF ISNULL(@IVAFiscal, 0) = 0
					UPDATE Cxp WITH(ROWLOCK)
					SET IVAFiscal = @IVAFiscal
					WHERE ID = @ID

			END

		END
		ELSE

		IF @Modulo = 'AGENT'
			UPDATE Agent WITH(ROWLOCK)
			SET Concepto = @Concepto
			   ,Impuestos = @Impuestos
			   ,Saldo = @SaldoNuevo
			   ,UltimoCambio = @FechaEmision
			   ,FechaConclusion = @FechaConclusion
			   ,FechaCancelacion = @FechaCancelacion
			   ,Estatus = @EstatusNuevo
			   ,Situacion =
				CASE
					WHEN @Estatus <> @EstatusNuevo THEN NULL
					ELSE Situacion
				END
			   ,GenerarPoliza = @GenerarPoliza
			   ,Importe = @Importe
			   ,Retencion = @Retencion
			   ,Autorizacion = @Autorizacion
			WHERE ID = @ID

		IF @@ERROR <> 0
			SELECT @Ok = 1

		IF @Agente IS NOT NULL
			AND ((@OrigenMovTipo IS NULL AND @MovTipo IN ('CXC.F', 'CXC.NC', 'CXC.NCD')) OR (@MovTipo IN ('CXC.C', 'CXC.A', 'CXC.AR', 'CXC.AA', 'CXC.CD') AND @CfgVentaComisionesCobradas = 1 AND @CfgComisionBase = 'COBRO'))
		BEGIN
			SELECT @ImporteComision = 0.0

			IF @Accion <> 'CANCELAR'
			BEGIN
				EXEC xpComisionCalcular @ID
									   ,@Accion
									   ,@Empresa
									   ,@Usuario
									   ,@Modulo
									   ,@Mov
									   ,@MovID
									   ,@MovTipo
									   ,@MovMoneda
									   ,@MovTipoCambio
									   ,@FechaEmision
									   ,@FechaRegistro
									   ,@FechaAfectacion
									   ,@Agente
									   ,@Conexion
									   ,@SincroFinal
									   ,@Sucursal
									   ,NULL
									   ,NULL
									   ,NULL
									   ,NULL
									   ,@Importe
									   ,@Importe
									   ,@Impuestos
									   ,@Impuestos
									   ,NULL
									   ,NULL
									   ,NULL
									   ,@ImporteComision OUTPUT
									   ,@Ok OUTPUT
									   ,@OkRef OUTPUT

				IF ISNULL(@ImporteComision, 0.0) <> 0.0
					AND @Ok IS NULL
					UPDATE Cxc WITH(ROWLOCK)
					SET ComisionTotal = @ImporteComision
					   ,ComisionPendiente = @ImporteComision
					WHERE ID = @ID

			END
			ELSE
				SELECT @ImporteComision = ComisionTotal
				FROM Cxc WITH(NOLOCK)
				WHERE ID = @ID

			IF ISNULL(@ImporteComision, 0.0) <> 0.0
				AND @Ok IS NULL
				AND (@CfgVentaComisionesCobradas = 0 OR (@CfgVentaComisionesCobradas = 1 AND @MovTipo IN ('CXC.C', 'CXC.A', 'CXC.AR', 'CXC.AA', 'CXC.CD') AND @CfgComisionBase = 'COBRO'))
				EXEC spGenerarCx @Sucursal
								,@SucursalOrigen
								,@SucursalDestino
								,@Accion
								,'AGENT'
								,@Empresa
								,@Modulo
								,@ID
								,@Mov
								,@MovID
								,@MovTipo
								,@MovMoneda
								,@MovTipoCambio
								,@FechaAfectacion
								,@Concepto
								,@Proyecto
								,@Usuario
								,@Autorizacion
								,@Referencia
								,@DocFuente
								,@Observaciones
								,@FechaRegistro
								,@Ejercicio
								,@Periodo
								,NULL
								,NULL
								,@Contacto
								,NULL
								,@Agente
								,NULL
								,NULL
								,NULL
								,@Importe
								,NULL
								,NULL
								,@ImporteComision
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,@CxModulo
								,@CxMov
								,@CxMovID
								,@Ok OUTPUT
								,@OkRef OUTPUT

		END

		EXEC spEmbarqueMov @Accion
						  ,@Empresa
						  ,@Modulo
						  ,@ID
						  ,@Mov
						  ,@MovID
						  ,@Estatus
						  ,@EstatusNuevo
						  ,@CfgEmbarcar
						  ,@Ok OUTPUT

		IF @Generar = 1
		BEGIN

			IF @GenerarAfectado = 1
				SELECT @GenerarEstatus = 'CONCLUIDO'
			ELSE
				SELECT @GenerarEstatus = 'SINAFECTAR'

			IF @GenerarEstatus = 'CONCLUIDO'
				SELECT @FechaConclusion = @FechaEmision
			ELSE

			IF @GenerarEstatus <> 'CANCELADO'
				SELECT @FechaConclusion = NULL

			IF @GenerarEstatus = 'CONCLUIDO'
				AND @CfgContX = 1
				AND @CfgContXGenerar <> 'NO'
				SELECT @GenerarPolizaTemp = 1
			ELSE
				SELECT @GenerarPolizaTemp = 0

			EXEC spValidarTareas @Empresa
								,@Modulo
								,@IDGenerar
								,@GenerarEstatus
								,@Ok OUTPUT
								,@OkRef OUTPUT

			IF @Modulo = 'CXC'
				UPDATE Cxc WITH(ROWLOCK)
				SET FechaConclusion = @FechaConclusion
				   ,Estatus = @GenerarEstatus
				   ,GenerarPoliza = @GenerarPolizaTemp
				WHERE ID = @IDGenerar
			ELSE

			IF @Modulo = 'CXP'
				UPDATE Cxp WITH(ROWLOCK)
				SET FechaConclusion = @FechaConclusion
				   ,Estatus = @GenerarEstatus
				   ,GenerarPoliza = @GenerarPolizaTemp
				WHERE ID = @IDGenerar
			ELSE

			IF @Modulo = 'AGENT'
				UPDATE Agent WITH(ROWLOCK)
				SET FechaConclusion = @FechaConclusion
				   ,Estatus = @GenerarEstatus
				   ,GenerarPoliza = @GenerarPolizaTemp
				WHERE ID = @IDGenerar

			IF @@ERROR <> 0
				SELECT @Ok = 1

		END

	END

	IF NOT EXISTS (SELECT * FROM MovImpuesto WITH(NOLOCK) WHERE Modulo = @Modulo AND ModuloID = @ID)
		AND @Ok IS NULL
	BEGIN

		IF @IDOrigen IS NULL
		BEGIN
			SELECT @CompraID = NULL

			IF @MovTipo = 'CXP.A'
			BEGIN
				SELECT @CompraID = MIN(ID)
				FROM Compra WITH(NOLOCK)
				WHERE Empresa = @Empresa
				AND @Referencia = Mov + ' ' + MovID
				AND Estatus IN ('PENDIENTE', 'CONCLUIDO')

				IF @CompraID IS NOT NULL
				BEGIN
					SELECT @CompraImporte = ISNULL(Importe, 0.0)
					FROM Compra WITH(NOLOCK)
					WHERE ID = @CompraID
					INSERT MovImpuesto (Modulo, ModuloID, OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenDeducible, OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, Importe1, Importe2, Importe3, SubTotal, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal)
						SELECT @Modulo
							  ,@ID
							  ,OrigenModulo
							  ,OrigenModuloID
							  ,OrigenConcepto
							  ,ISNULL(OrigenDeducible, 100)
							  ,OrigenFecha
							  ,LoteFijo
							  ,Retencion1
							  ,Retencion2
							  ,Retencion3
							  ,Excento1
							  ,Excento2
							  ,Excento3
							  ,Impuesto1
							  ,Impuesto2
							  ,Impuesto3
							  ,TipoImpuesto1
							  ,TipoImpuesto2
							  ,TipoImpuesto3
							  ,TipoRetencion1
							  ,TipoRetencion2
							  ,TipoRetencion3
							  ,dbo.fnR3(@CompraImporte, Importe1, @Importe)
							  ,dbo.fnR3(@CompraImporte, Importe2, @Importe)
							  ,dbo.fnR3(@CompraImporte, Importe3, @Importe)
							  ,dbo.fnR3(@CompraImporte, SubTotal, @Importe)
							  ,ContUso
							  ,ContUso2
							  ,ContUso3
							  ,ClavePresupuestal
							  ,ClavePresupuestalImpuesto1
							  ,DescuentoGlobal
						FROM MovImpuesto WITH(NOLOCK)
						WHERE Modulo = 'COMS'
						AND ModuloID = @CompraID
				END
				ELSE
				BEGIN

					IF (
							SELECT CP
							FROM EmpresaGral WITH(NOLOCK)
							WHERE Empresa = @Empresa
						)
						= 1
						AND (
							SELECT CXPReferenciaEnAnticiposCP
							FROM empresacfg2 WITH(NOLOCK)
							WHERE Empresa = @Empresa
						)
						= 1
						SELECT @Ok = 20916
							  ,@OkRef = @Referencia

				END

			END

			IF @CompraID IS NULL
				OR (@OrigenTipo = 'INV' AND @OrigenMovTipo = 'INV.EI' AND EXISTS (SELECT ID FROM InvGastoDiverso WITH(NOLOCK) WHERE ID = @IDOrigen)
				)
			BEGIN

				IF @Modulo = 'CXC'
					SELECT @ContUso = NULLIF(ContUso, '')
						  ,@ContUso2 = NULLIF(ContUso2, '')
						  ,@ContUso3 = NULLIF(ContUso3, '')
					FROM Cxc WITH(NOLOCK)
					WHERE ID = @ID
				ELSE

				IF @Modulo = 'CXP'
					SELECT @ContUso = NULLIF(ContUso, '')
						  ,@ContUso2 = NULLIF(ContUso2, '')
						  ,@ContUso3 = NULLIF(ContUso3, '')
					FROM Cxp WITH(NOLOCK)
					WHERE ID = @ID

				INSERT MovImpuesto (Modulo, ModuloID, OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenFecha, Retencion1, Retencion2, Retencion3, Impuesto1, Importe1, SubTotal, ContUso, ContUso2, ContUso3)
					SELECT @Modulo
						  ,@ID
						  ,@Modulo
						  ,@ID
						  ,@Concepto
						  ,@FechaEmision
						  ,(@Retencion / NULLIF(@Importe, 0.0)) * 100.0
						  ,(@Retencion2 / NULLIF(@Importe, 0.0)) * 100.0
						  ,(@Retencion3 / NULLIF(@Importe, 0.0)) * 100.0
						  ,ROUND(dbo.fnR3(NULLIF(@Importe, 0.0), 100, @Impuestos), 2)
						  ,@Impuestos
						  ,@Importe
						  ,@ContUso
						  ,@ContUso2
						  ,@ContUso3
			END

		END
		ELSE
		BEGIN

			IF (@OrigenTipo = 'COMS' AND @OrigenMovTipo = 'COMS.EG' AND EXISTS (SELECT ID FROM CompraGastoDiverso WITH(NOLOCK) WHERE ID = @IDOrigen)
				)
				OR (@OrigenTipo = 'COMS' AND @OrigenMovTipo = 'COMS.EI')
				OR (@OrigenTipo = 'INV' AND @OrigenMovTipo = 'INV.EI' AND EXISTS (SELECT ID FROM InvGastoDiverso WITH(NOLOCK) WHERE ID = @IDOrigen)
				)
			BEGIN
				INSERT MovImpuesto (Modulo, ModuloID, OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenFecha, Retencion1, Retencion2, Retencion3, Impuesto1, Importe1, SubTotal)
					SELECT @Modulo
						  ,@ID
						  ,@OrigenTipo
						  ,@IDOrigen
						  ,@Concepto
						  ,FechaEmision
						  ,(@Retencion / NULLIF(@Importe, 0.0)) * 100.0
						  ,(@Retencion2 / NULLIF(@Importe, 0.0)) * 100.0
						  ,(@Retencion3 / NULLIF(@Importe, 0.0)) * 100.0
						  ,(@Impuestos / NULLIF(@Importe, 0.0)) * 100.0
						  ,@Impuestos
						  ,@Importe
					FROM Mov WITH(NOLOCK)
					WHERE Empresa = @Empresa
					AND Modulo = @OrigenTipo
					AND ID = @IDOrigen

				IF @OrigenTipo = 'COMS'
					UPDATE MovImpuesto WITH(ROWLOCK)
					SET Excento1 = c.Impuesto1Excento
					   ,Excento2 = c.Excento2
					   ,Excento3 = c.Excento3
					FROM MovImpuesto p
					JOIN CompraGastoDiverso g WITH(NOLOCK)
						ON p.OrigenModulo = @OrigenTipo
						AND p.OrigenModuloID = g.ID
						AND p.OrigenConcepto = g.Concepto
					JOIN Concepto c WITH(NOLOCK)
						ON c.Concepto = g.Concepto
					WHERE p.Modulo = 'CXP'
					AND p.ModuloID = @ID

				IF @OrigenTipo = 'INV'
					UPDATE MovImpuesto WITH(ROWLOCK)
					SET Excento1 = c.Impuesto1Excento
					   ,Excento2 = c.Excento2
					   ,Excento3 = c.Excento3
					FROM MovImpuesto p
					JOIN InvGastoDiverso g WITH(NOLOCK)
						ON p.OrigenModulo = @OrigenTipo
						AND p.OrigenModuloID = g.ID
						AND p.OrigenConcepto = g.Concepto
					JOIN Concepto c WITH(NOLOCK)
						ON c.Concepto = g.Concepto
					WHERE p.Modulo = 'CXP'
					AND p.ModuloID = @ID

			END
			ELSE

			IF @OrigenTipo = 'CXP'
				AND @OrigenMovTipo = 'CXP.RA'
				INSERT MovImpuesto (Modulo, ModuloID, OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenDeducible, OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, Importe1, Importe2, Importe3, SubTotal, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal)
					SELECT @Modulo
						  ,@ID
						  ,OrigenModulo
						  ,OrigenModuloID
						  ,OrigenConcepto
						  ,ISNULL(OrigenDeducible, 100)
						  ,OrigenFecha
						  ,LoteFijo
						  ,Retencion1
						  ,Retencion2
						  ,Retencion3
						  ,Excento1
						  ,Excento2
						  ,Excento3
						  ,Impuesto1
						  ,Impuesto2
						  ,Impuesto3
						  ,TipoImpuesto1
						  ,TipoImpuesto2
						  ,TipoImpuesto3
						  ,TipoRetencion1
						  ,TipoRetencion2
						  ,TipoRetencion3
						  ,Importe1
						  ,Importe2
						  ,Importe3
						  ,SubTotal
						  ,ContUso
						  ,ContUso2
						  ,ContUso3
						  ,ClavePresupuestal
						  ,ClavePresupuestalImpuesto1
						  ,DescuentoGlobal
					FROM MovImpuesto WITH(NOLOCK)
					WHERE Modulo = @Modulo
					AND ModuloID = @ID
			ELSE

			IF @OrigenTipo = 'GAS'
				AND @OrigenMovTipo = 'GAS.GTC'
				INSERT MovImpuesto (Modulo, ModuloID, OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenDeducible, OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, Importe1, Importe2, Importe3, SubTotal, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal)
					SELECT Modulo
						  ,ModuloID
						  ,OrigenModulo
						  ,OrigenModuloID
						  ,OrigenConcepto
						  ,ISNULL(OrigenDeducible, 100)
						  ,OrigenFecha
						  ,LoteFijo
						  ,Retencion1
						  ,Retencion2
						  ,Retencion3
						  ,Excento1
						  ,Excento2
						  ,Excento3
						  ,Impuesto1
						  ,Impuesto2
						  ,Impuesto3
						  ,TipoImpuesto1
						  ,TipoImpuesto2
						  ,TipoImpuesto3
						  ,TipoRetencion1
						  ,TipoRetencion2
						  ,TipoRetencion3
						  ,@Impuestos
						  ,Importe2
						  ,Importe3
						  ,@Importe
						  ,ContUso
						  ,ContUso2
						  ,ContUso3
						  ,ClavePresupuestal
						  ,ClavePresupuestalImpuesto1
						  ,DescuentoGlobal
					FROM MovImpuesto WITH(NOLOCK)
					WHERE Modulo = 'CXP'
					AND ModuloID = @ID
					AND OrigenConcepto = @Concepto
			ELSE
			BEGIN
				SELECT @OrigenImporte = SUM(SubTotal)
				FROM MovImpuesto WITH(NOLOCK)
				WHERE Modulo = @OrigenTipo
				AND ModuloID = @IDOrigen
				INSERT MovImpuesto (Modulo, ModuloID, OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenDeducible, OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, Importe1, Importe2, Importe3, SubTotal, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal)
					SELECT @Modulo
						  ,@ID
						  ,OrigenModulo
						  ,OrigenModuloID
						  ,OrigenConcepto
						  ,ISNULL(OrigenDeducible, 100)
						  ,OrigenFecha
						  ,LoteFijo
						  ,Retencion1
						  ,Retencion2
						  ,Retencion3
						  ,Excento1
						  ,Excento2
						  ,Excento3
						  ,Impuesto1
						  ,Impuesto2
						  ,Impuesto3
						  ,TipoImpuesto1
						  ,TipoImpuesto2
						  ,TipoImpuesto3
						  ,TipoRetencion1
						  ,TipoRetencion2
						  ,TipoRetencion3
						  ,dbo.fnR3(@OrigenImporte, Importe1, @Importe)
						  ,dbo.fnR3(@OrigenImporte, Importe2, @Importe)
						  ,dbo.fnR3(@OrigenImporte, Importe3, @Importe)
						  ,dbo.fnR3(@OrigenImporte, SubTotal, @Importe)
						  ,ContUso
						  ,ContUso2
						  ,ContUso3
						  ,ClavePresupuestal
						  ,ClavePresupuestalImpuesto1
						  ,DescuentoGlobal
					FROM MovImpuesto WITH(NOLOCK)
					WHERE Modulo = @OrigenTipo
					AND ModuloID = @IDOrigen
			END

		END

	END

	IF NOT EXISTS (SELECT * FROM MovImpuesto WITH(NOLOCK) WHERE Modulo = @Modulo AND ModuloID = @ID)
		AND @MovTipo = 'CXP.F'
		AND @OrigenMovTipo = 'GAS.GTC'
		AND @IDOrigen IS NOT NULL
	BEGIN
		SELECT @SubFolio = SUBSTRING(@MovID, PATINDEX('%-%', @MovID) + 1, 5)
		INSERT MovImpuesto (Modulo, ModuloID, OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenDeducible, OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, Importe1, Importe2, Importe3, SubTotal, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal)
			SELECT @Modulo
				  ,@ID
				  ,OrigenModulo
				  ,OrigenModuloID
				  ,OrigenConcepto
				  ,ISNULL(OrigenDeducible, 100)
				  ,OrigenFecha
				  ,LoteFijo
				  ,Retencion1
				  ,Retencion2
				  ,Retencion3
				  ,Excento1
				  ,Excento2
				  ,Excento3
				  ,Impuesto1
				  ,Impuesto2
				  ,Impuesto3
				  ,TipoImpuesto1
				  ,TipoImpuesto2
				  ,TipoImpuesto3
				  ,TipoRetencion1
				  ,TipoRetencion2
				  ,TipoRetencion3
				  ,Importe1
				  ,Importe2
				  ,Importe3
				  ,SubTotal
				  ,ContUso
				  ,ContUso2
				  ,ContUso3
				  ,ClavePresupuestal
				  ,ClavePresupuestalImpuesto1
				  ,DescuentoGlobal
			FROM MovImpuesto WITH(NOLOCK)
			WHERE Modulo = @OrigenTipo
			AND ModuloID = @IDOrigen
			AND SubFolio = @SubFolio
	END

	IF @MovTipo IN ('CXC.ANC', 'CXC.ACA', 'CXP.ANC', 'CXP.ACA')
		AND @Accion <> 'CANCELAR'
	BEGIN
		INSERT MovImpuesto (Modulo, ModuloID, OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenDeducible, OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, Importe1, Importe2, Importe3, SubTotal, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal)
			SELECT @Modulo
				  ,@ID
				  ,OrigenModulo
				  ,OrigenModuloID
				  ,OrigenConcepto
				  ,ISNULL(OrigenDeducible, 100)
				  ,OrigenFecha
				  ,LoteFijo
				  ,Retencion1
				  ,Retencion2
				  ,Retencion3
				  ,Excento1
				  ,Excento2
				  ,Excento3
				  ,Impuesto1
				  ,Impuesto2
				  ,Impuesto3
				  ,TipoImpuesto1
				  ,TipoImpuesto2
				  ,TipoImpuesto3
				  ,TipoRetencion1
				  ,TipoRetencion2
				  ,TipoRetencion3
				  ,Importe1 * @MovAplicaFactor
				  ,Importe2 * @MovAplicaFactor
				  ,Importe3 * @MovAplicaFactor
				  ,SubTotal * @MovAplicaFactor
				  ,ContUso
				  ,ContUso2
				  ,ContUso3
				  ,ClavePresupuestal
				  ,ClavePresupuestalImpuesto1
				  ,DescuentoGlobal
			FROM MovImpuesto WITH(NOLOCK)
			WHERE Modulo = @Modulo
			AND ModuloID = @IDAplica
	END

	IF @Ok IN (NULL, 80030)
		AND @RamaID IS NULL
		AND @MovTipo IN ('CXC.F', 'CXC.CA', 'CXC.CAP', 'CXC.CAD', 'CXC.D', 'CXC.DM', 'CXP.F', 'CXP.CA', 'CXP.CAP', 'CXP.CAD', 'CXP.D', 'CXP.DM')
		AND @Condicion IS NOT NULL
		AND @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR')
		AND @EstatusNuevo = 'PENDIENTE'
		AND @Accion = 'AFECTAR'
	BEGIN
		SELECT @Ok = NULL
			  ,@OkRef = NULL

		IF @CfgAC = 1
		BEGIN

			IF @OrigenTipo IN ('VTAS', 'COMS')
				EXEC spCopiarTablaAmortizacionGuia @OrigenTipo
												  ,@IDOrigen
												  ,@Modulo
												  ,@ID

			EXEC spTablaAmortizacion @Modulo
									,@ID
									,@Usuario
									,1
									,@FechaRegistro
									,@Ok OUTPUT
									,@OkRef OUTPUT
		END
		ELSE

		IF @INSTRUCCIONES_ESP <> 'SIN_DOCAUTO'
			AND EXISTS (SELECT * FROM Condicion WITH(NOLOCK) WHERE Condicion = @Condicion AND DA = 1)
			EXEC spCxDocAuto @Modulo
							,@ID
							,@Usuario
							,@Ok OUTPUT
							,@OkRef OUTPUT

	END

	IF @Ok IS NULL
	BEGIN

		IF @Modulo = 'CXC'
		BEGIN
			SELECT @FormaCobroTarjetas = CxcFormaCobroTarjetas
			FROM EmpresaCfg WITH(NOLOCK)
			WHERE Empresa = @Empresa
			SELECT @LDITarjeta = ISNULL(LDI, 0)
				  ,@LDIServicio = NULLIF(LDIServicio, '')
			FROM FormaPago WITH(NOLOCK)
			WHERE FormaPago = @FormaCobroTarjetas
			SELECT @TarjetasCobradas = 0.0
			SELECT @ConDesglose = ConDesglose
				  ,@Importe1 = ISNULL(Importe1, 0)
				  ,@FormaCobro1 = FormaCobro1
				  ,@Importe2 = ISNULL(Importe2, 0)
				  ,@FormaCobro2 = FormaCobro2
				  ,@Importe3 = ISNULL(Importe3, 0)
				  ,@FormaCobro3 = FormaCobro3
				  ,@Importe4 = ISNULL(Importe4, 0)
				  ,@FormaCobro4 = FormaCobro4
				  ,@Importe5 = ISNULL(Importe5, 0)
				  ,@FormaCobro5 = FormaCobro5
				  ,@Referencia1 = Referencia1
				  ,@Referencia2 = Referencia2
				  ,@Referencia3 = Referencia3
				  ,@Referencia4 = Referencia4
				  ,@Referencia5 = Referencia5
			FROM Cxc WITH(NOLOCK)
			WHERE ID = @ID

			IF @ConDesglose = 0
				AND @ImporteTotal > 0.0
				AND @FormaPago = @FormaCobroTarjetas
			BEGIN
				SELECT @TarjetasCobradas = @ImporteTotal
					  ,@FormaCobro1 = @FormaPago
			END
			ELSE
			BEGIN

				IF @FormaCobro1 = @FormaCobroTarjetas
					SELECT @TarjetasCobradas = @TarjetasCobradas + @Importe1
						  ,@ReferenciaTarjetas = @Referencia1

				IF @FormaCobro2 = @FormaCobroTarjetas
					SELECT @TarjetasCobradas = @TarjetasCobradas + @Importe2
						  ,@ReferenciaTarjetas = @Referencia2

				IF @FormaCobro3 = @FormaCobroTarjetas
					SELECT @TarjetasCobradas = @TarjetasCobradas + @Importe3
						  ,@ReferenciaTarjetas = @Referencia3

				IF @FormaCobro4 = @FormaCobroTarjetas
					SELECT @TarjetasCobradas = @TarjetasCobradas + @Importe4
						  ,@ReferenciaTarjetas = @Referencia4

				IF @FormaCobro5 = @FormaCobroTarjetas
					SELECT @TarjetasCobradas = @TarjetasCobradas + @Importe5
						  ,@ReferenciaTarjetas = @Referencia5

			END

			IF @MovTipo IN ('CXC.A', 'CXC.AR', 'CXC.AA', 'CXC.C', 'CXC.DC', 'CXC.DE')
			BEGIN

				IF @ValesCobrados > 0.0
					OR @TarjetasCobradas > 0.0
					EXEC spValeAplicarCobro @Empresa
										   ,@Modulo
										   ,@ID
										   ,@TarjetasCobradas
										   ,@Accion
										   ,@FechaEmision
										   ,@Ok OUTPUT
										   ,@OkRef OUTPUT

				IF @TarjetasCobradas <> 0.0
					AND @Ok IS NULL
					AND NOT EXISTS (SELECT * FROM TarjetaSerieMov t WITH(NOLOCK) JOIN ValeSerie v WITH(NOLOCK) ON t.Serie = v.Serie JOIN Art a WITH(NOLOCK) ON v.Articulo = a.Articulo WHERE t.Empresa = @Empresa AND t.Modulo = @Modulo AND t.ID = @ID AND ISNULL(t.Importe, 0) <> 0 AND ISNULL(a.LDI, 0) = 1)
					AND @LDITarjeta = 0
					EXEC spValeGeneraAplicacionTarjeta @Empresa
													  ,@Modulo
													  ,@ID
													  ,@Mov
													  ,@MovID
													  ,@Accion
													  ,@FechaEmision
													  ,@Usuario
													  ,@Sucursal
													  ,@TarjetasCobradas
													  ,@CtaDinero
													  ,@MovMoneda
													  ,@MovTipoCambio
													  ,@Ok OUTPUT
													  ,@OkRef OUTPUT
													  ,@Referencia = @ReferenciaTarjetas

			END

		END

		IF (@MovTipo IN ('CXC.A', 'CXC.AR', 'CXC.AA', 'CXC.C', 'CXP.CAP', 'CXP.DP', 'CXP.CD', 'CXP.DC', 'CXP.NCP', 'CXP.C', 'AGENT.A') AND @ConDesglose = 0 AND UPPER(@FormaPago) = UPPER(@CfgFormaCobroDA))
			OR (@MovTipo IN ('CXC.A', 'CXC.AR', 'CXC.AA', 'CXC.C') AND (@ConDesglose = 1 AND (
				SELECT UPPER(FormaCobro1)
				FROM Cxc WITH(NOLOCK)
				WHERE ID = @ID
			)
			= UPPER(@CfgFormaCobroDA)))

			IF EXISTS (SELECT Usuario, Nombre, Sucursal, GrupoTrabajo, Estatus, Configuracion, Acceso FROM Usuario WITH(NOLOCK) WHERE GrupoTrabajo <> 'CREDITO' AND Estatus = 'ALTA' AND Usuario = @Usuario)
				EXEC spDepositoAnticipado @Sucursal
									 ,@Accion
									 ,@ID
									 ,@Mov
									 ,@MovID
									 ,@Empresa
									 ,@Modulo
									 ,@CtaDinero
									 ,@ImporteTotal
									 ,@MovMoneda
									 ,@RedondeoMonetarios
									 ,@ConDesglose
									 ,@FormaPago
									 ,@CfgFormaCobroDA
									 ,@Referencia
									 ,@Ok OUTPUT
									 ,@OkRef OUTPUT
			ELSE
				SELECT @Ok = NULL
		ELSE

		IF (@MovTipo IN ('CXP.P', 'CXP.DP', 'CXP.NCP', 'CXP.ANC', 'CXP.A', 'CXP.AA', 'CXC.CAP', 'CXC.DE', 'CXC.DFA', 'CXC.DI', 'CXC.DC', 'AGENT.P', 'AGENT.A') AND @ConDesglose = 0 AND UPPER(@FormaPago) = UPPER(@CfgFormaCobroDA))
			OR (@MovTipo IN ('CXC.DE') AND (@ConDesglose = 1 AND (
				SELECT UPPER(FormaCobro1)
				FROM Cxc WITH(NOLOCK)
				WHERE ID = @ID
			)
			= UPPER(@CfgFormaCobroDA)))
			EXEC spCargoNoIdentificado @Sucursal
									  ,@Accion
									  ,@ID
									  ,@Mov
									  ,@MovID
									  ,@Empresa
									  ,@Modulo
									  ,@CtaDinero
									  ,@ImporteTotal
									  ,@MovMoneda
									  ,@RedondeoMonetarios
									  ,@ConDesglose
									  ,@FormaPago
									  ,@CfgFormaCobroDA
									  ,@Referencia
									  ,@Ok OUTPUT
									  ,@OkRef OUTPUT
		ELSE
		BEGIN
			SELECT @DineroImporte = @ImporteTotal

			IF @MovTipo = 'CXC.C'
				AND @ConDesglose = 1
				AND @CobroDelEfectivo > 0.0
			BEGIN

				IF @Accion <> 'CANCELAR'
					SELECT @EsCargo = 1
				ELSE
					SELECT @EsCargo = 0

				EXEC spSaldo @Sucursal
							,@Accion
							,@Empresa
							,@Usuario
							,'CEFE'
							,@MovMoneda
							,@MovTipoCambio
							,@Contacto
							,NULL
							,NULL
							,NULL
							,@Modulo
							,@ID
							,@Mov
							,@MovID
							,@EsCargo
							,@CobroDelEfectivo
							,NULL
							,NULL
							,@FechaAfectacion
							,@Ejercicio
							,@Periodo
							,'Saldo a Favor'
							,NULL
							,0
							,0
							,0
							,@Ok OUTPUT
							,@OkRef OUTPUT
				SELECT @DineroImporte = @DineroImporte - @CobroDelEfectivo
			END

			SELECT @OrigenTipoCxc = OrigenTipo
			FROM Cxc WITH(NOLOCK)
			WHERE ID = @ID

			IF ROUND(@DineroImporte, 2) > 0.0
				AND @Ok IS NULL
				AND ((@MovTipo IN ('CXC.C', 'CXC.AA', 'CXC.DE', 'CXC.DFA', 'CXC.DI', 'CXC.DC', 'CXP.P', 'CXP.AA', 'CXP.DE', 'CXP.DC', 'AGENT.P', 'AGENT.CO') AND @EstatusNuevo IN ('CONCLUIDO', 'CANCELADO')) OR (@MovTipo IN ('CXC.CAP', 'CXP.CAP', 'CXC.DP', 'CXC.NCP', 'CXC.CD', 'CXP.DP', 'CXP.NCP', 'CXP.CD', 'CXP.C', 'AGENT.A')) OR (@MovTipo IN ('CXC.A') AND @OrigenMovTipo <> 'CXC.RA') OR (@MovTipo = 'CXP.A' AND @OrigenMovTipo <> 'CXP.RA') OR (@MovTipo IN ('CXC.ANC', 'CXP.ANC') AND @AplicaPosfechado = 1)
				OR (@Mov IN ('Cancela Credilana', 'Cancela Prestamo') AND @OrigenTipoCxc = 'VTAS' AND ISNULL(@Concepto, '') != 'MONEDERO ELECTRONICO'))
			BEGIN

				IF @MovTipo IN ('AGENT.P', 'AGENT.CO')
					AND @AgenteNomina = 1
					AND @Mov NOT IN ('Cobro Dif Caja', 'Canc Dif Caja')
				BEGIN
					SELECT @NomAuto = NomAuto
					FROM EmpresaGral WITH(NOLOCK)
					WHERE Empresa = @Empresa
					SELECT @NominaID = NULL
						  ,@NominaMov = @AgenteNominaMov
						  ,@NominaMovID = NULL
					EXEC spGenerarNominaAuto @Sucursal
											,@Accion
											,@Empresa
											,@Modulo
											,@ID
											,@Mov
											,@MovID
											,@MovTipo
											,@MovMoneda
											,@MovTipoCambio
											,@FechaAfectacion
											,@FechaRegistro
											,@AgenteNominaConcepto
											,@Proyecto
											,@Usuario
											,@Autorizacion
											,@DocFuente
											,@Observaciones
											,@AgentePersonal
											,@NominaID OUTPUT
											,@NominaMov OUTPUT
											,@NominaMovID OUTPUT
											,@Ok OUTPUT
											,@OkRef OUTPUT
					SELECT @NominaID = NULL
						  ,@NominaMov = @AgenteNominaMov
						  ,@NominaMovID = NULL

					IF @OK IS NULL
						EXEC spGenerarNomina @Sucursal
											,@Accion
											,@Empresa
											,@Modulo
											,@ID
											,@Mov
											,@MovID
											,@MovTipo
											,@MovMoneda
											,@MovTipoCambio
											,@FechaAfectacion
											,@FechaRegistro
											,@AgenteNominaConcepto
											,@Proyecto
											,@Usuario
											,@Autorizacion
											,@DocFuente
											,@Observaciones
											,@AgentePersonal
											,@NominaID OUTPUT
											,@NominaMov OUTPUT
											,@NominaMovID OUTPUT
											,@Ok OUTPUT
											,@OkRef OUTPUT

				END
				ELSE

				IF @MovTipo IN ('AGENT.P', 'AGENT.CO')
					AND @CfgAgentAfectarGastos = 1
					EXEC spGenerarGasto @Accion
									   ,@Empresa
									   ,@Sucursal
									   ,@Usuario
									   ,@Modulo
									   ,@ID
									   ,@Mov
									   ,@MovID
									   ,@FechaEmision
									   ,@FechaRegistro
									   ,@Ok OUTPUT
									   ,@OkRef OUTPUT
									   ,@MovTipoGenerarGasto = 1
				ELSE
				BEGIN
					SELECT @DineroTipo = NULL

					IF @AplicaPosfechado = 1
						SELECT @DineroTipo = 'APLICA_POSFECHADO'

					IF @MovTipo IN ('CXC.CAP', 'CXP.CAP')
						OR (@Mov IN ('Cancela Credilana', 'Cancela Prestamo') AND ISNULL(@OrigenTipoCxc, '') = 'VTAS' AND ISNULL(@Concepto, '') != 'MONEDERO ELECTRONICO')
					BEGIN

						IF @MovTipo = 'CXC.CAP'
							OR (@Mov IN ('Cancela Credilana', 'Cancela Prestamo') AND ISNULL(@OrigenTipoCxc, '') = 'VTAS' AND ISNULL(@Concepto, '') != 'MONEDERO ELECTRONICO')
							SELECT @DineroImporte = @DineroImporte - ISNULL(InteresesAnticipados, 0.0) - ISNULL(Comisiones, 0.0) - ISNULL(ComisionesIVA, 0.0)
							FROM Cxc WITH(NOLOCK)
							WHERE ID = @ID
						ELSE

						IF @MovTipo = 'CXP.CAP'
							SELECT @DineroImporte = @DineroImporte - ISNULL(InteresesAnticipados, 0.0) - ISNULL(Comisiones, 0.0) - ISNULL(ComisionesIVA, 0.0)
							FROM Cxp WITH(NOLOCK)
							WHERE ID = @ID

					END

					IF @CfgAC = 1
						AND @MovTipo IN ('CXC.CAP', 'CXP.CAP')
						AND EXISTS (SELECT * FROM LCCtaDinero WITH(NOLOCK) WHERE LineaCredito = @LineaCredito)
					BEGIN
						SELECT @LCCtaDineroImporte = SUM(Importe)
						FROM LCCtaDinero WITH(NOLOCK)
						WHERE LineaCredito = @LineaCredito
						DECLARE
							crLCCtaDinero
							CURSOR LOCAL FOR
							SELECT CtaDinero
								  ,dbo.fnR3(@LCCtaDineroImporte, @DineroImporte, Importe)
							FROM LCCtaDinero WITH(NOLOCK)
							WHERE LineaCredito = @LineaCredito
						OPEN crLCCtaDinero
						FETCH NEXT FROM crLCCtaDinero INTO @LCCtaDinero, @LCCtaDineroImporte
						WHILE @@FETCH_STATUS <> -1
						AND @Ok IS NULL
						BEGIN

						IF @@FETCH_STATUS <> -2
							AND @Ok IS NULL
						BEGIN
							EXEC spGenerarDinero @Sucursal
												,@SucursalOrigen
												,@SucursalDestino
												,@Accion
												,@Empresa
												,@Modulo
												,@ID
												,@Mov
												,@MovID
												,@MovTipo
												,@MovMoneda
												,@MovTipoCambio
												,@FechaAfectacion
												,@Concepto
												,@Proyecto
												,@Usuario
												,@Autorizacion
												,@Referencia
												,@DocFuente
												,@Observaciones
												,@ConDesglose
												,0
												,@FechaRegistro
												,@Ejercicio
												,@Periodo
												,@FormaPago
												,@DineroTipo
												,@Beneficiario
												,@Contacto
												,@LCCtaDinero
												,@Cajero
												,@LCCtaDineroImporte
												,NULL
												,NULL
												,NULL
												,@Vencimiento
												,@DineroMov OUTPUT
												,@DineroMovID OUTPUT
												,@Ok OUTPUT
												,@OkRef OUTPUT
												,@ProveedorAutoEndoso = @ProveedorAutoEndoso
												,@Nota = @Nota
												,@EstacionTrabajo = @EstacionTrabajo

							IF @Ok = 80030
								SELECT @Ok = NULL
									  ,@OkRef = NULL

						END

						FETCH NEXT FROM crLCCtaDinero INTO @LCCtaDinero, @LCCtaDineroImporte
						END
						CLOSE crLCCtaDinero
						DEALLOCATE crLCCtaDinero
					END
					ELSE
						IF EXISTS (SELECT Usuario, Nombre, Sucursal, GrupoTrabajo, Estatus, Configuracion, Acceso FROM Usuario WITH(NOLOCK) WHERE GrupoTrabajo <> 'CREDITO' AND Estatus = 'ALTA' AND Usuario = @Usuario)
						BEGIN
							EXEC spGenerarDinero @Sucursal
											,@SucursalOrigen
											,@SucursalDestino
											,@Accion
											,@Empresa
											,@Modulo
											,@ID
											,@Mov
											,@MovID
											,@MovTipo
											,@MovMoneda
											,@MovTipoCambio
											,@FechaAfectacion
											,@Concepto
											,@Proyecto
											,@Usuario
											,@Autorizacion
											,@Referencia
											,@DocFuente
											,@Observaciones
											,@ConDesglose
											,0
											,@FechaRegistro
											,@Ejercicio
											,@Periodo
											,@FormaPago
											,@DineroTipo
											,@Beneficiario
											,@Contacto
											,@CtaDinero
											,@Cajero
											,@DineroImporte
											,NULL
											,NULL
											,NULL
											,@Vencimiento
											,@DineroMov OUTPUT
											,@DineroMovID OUTPUT
											,@Ok OUTPUT
											,@OkRef OUTPUT
											,@ProveedorAutoEndoso = @ProveedorAutoEndoso
											,@Nota = @Nota
											,@EstacionTrabajo = @EstacionTrabajo
						END
						ELSE
							SELECT @Ok = NULL
							  ,@OkRef = NULL

				END

			END

		END

		IF @MovTipo IN ('CXC.RA', 'CXP.RA')
		BEGIN
			EXEC @IDGenerar = spGenerarCx @Sucursal
										 ,@SucursalOrigen
										 ,@SucursalDestino
										 ,@Accion
										 ,@Modulo
										 ,@Empresa
										 ,@Modulo
										 ,@ID
										 ,@Mov
										 ,@MovID
										 ,@MovTipo
										 ,@MovMoneda
										 ,@MovTipoCambio
										 ,@FechaAfectacion
										 ,@Concepto
										 ,@Proyecto
										 ,@Usuario
										 ,NULL
										 ,NULL
										 ,NULL
										 ,NULL
										 ,@FechaRegistro
										 ,@Ejercicio
										 ,@Periodo
										 ,NULL
										 ,NULL
										 ,@Contacto
										 ,@ContactoEnviarA
										 ,@Agente
										 ,NULL
										 ,@CtaDinero
										 ,@FormaPago
										 ,@Importe
										 ,@Impuestos
										 ,NULL
										 ,NULL
										 ,NULL
										 ,NULL
										 ,NULL
										 ,NULL
										 ,NULL
										 ,NULL
										 ,@CxModulo OUTPUT
										 ,@CxMov OUTPUT
										 ,@CxMovID OUTPUT
										 ,@Ok OUTPUT
										 ,@OkRef OUTPUT

			IF @Ok IS NULL
				AND @Accion <> 'CANCELAR'
				SELECT @Ok = 80030
					  ,@GenerarMov = @CxMov
					  ,@GenerarMovID = @CxMovID

		END

		IF @MovTipo IN ('CXC.NCF', 'CXP.NCF')
		BEGIN
			SELECT @ImporteMN = @Importe * @ContactoTipoCambio
				  ,@ImpuestosMN = @Impuestos * @ContactoTipoCambio
				  ,@MonedaMN = NULL
			SELECT @MonedaMN = cfg.ContMoneda
			FROM EmpresaCfg cfg WITH(NOLOCK)
				,Mon m WITH(NOLOCK)
			WHERE cfg.Empresa = @Empresa
			AND m.Moneda = cfg.ContMoneda
			AND m.TipoCambio = 1.0

			IF @MonedaMN IS NULL
				SELECT MIN(Moneda)
				FROM Mon WITH(NOLOCK)
				WHERE TipoCambio = 1.0

			EXEC spGenerarCx @Sucursal
							,@SucursalOrigen
							,@SucursalDestino
							,@Accion
							,@Modulo
							,@Empresa
							,@Modulo
							,@ID
							,@Mov
							,@MovID
							,@MovTipo
							,@MonedaMN
							,1.0
							,@FechaAfectacion
							,NULL
							,@Proyecto
							,@Usuario
							,NULL
							,NULL
							,NULL
							,NULL
							,@FechaRegistro
							,@Ejercicio
							,@Periodo
							,NULL
							,NULL
							,@Contacto
							,@ContactoEnviarA
							,@Agente
							,NULL
							,@CtaDinero
							,@FormaPago
							,@ImporteMN
							,@ImpuestosMN
							,NULL
							,NULL
							,NULL
							,NULL
							,NULL
							,NULL
							,NULL
							,NULL
							,@CxModulo OUTPUT
							,@CxMov OUTPUT
							,@CxMovID OUTPUT
							,@Ok OUTPUT
							,@OkRef OUTPUT

			IF @Ok IS NULL
				AND @Accion <> 'CANCELAR'
				SELECT @Ok = 80030
					  ,@GenerarMov = @CxMov
					  ,@GenerarMovID = @CxMovID

		END

		IF @MovTipo IN ('CXC.VV', 'CXC.OV', 'CXC.DV', 'CXC.AV')
		BEGIN

			IF @MovTipo IN ('CXC.VV', 'CXC.OV')
				SELECT @EsCargo = 0
			ELSE
				SELECT @EsCargo = 1

			IF @Accion = 'CANCELAR'
				SELECT @EsCargo = ~@EsCargo

			EXEC spSaldo @Sucursal
						,@Accion
						,@Empresa
						,@Usuario
						,'CVALE'
						,@MovMoneda
						,@MovTipoCambio
						,@Contacto
						,NULL
						,NULL
						,NULL
						,@Modulo
						,@ID
						,@Mov
						,@MovID
						,@EsCargo
						,@ImporteTotal
						,NULL
						,NULL
						,@FechaAfectacion
						,@Ejercicio
						,@Periodo
						,'Vales en Circulacion'
						,NULL
						,0
						,0
						,0
						,@Ok OUTPUT
						,@OkRef OUTPUT
		END

		IF @MovTipo = 'CXP.PAG'
			AND @Aforo > 0.0
			AND @Accion <> 'CANCELAR'
			AND @Ok IS NULL
		BEGIN
			SELECT @AforoMovID = NULL
				  ,@AforoImporte = @ImporteTotal * (@Aforo / 100)
			SELECT @AforoMov = CxpAforo
			FROM EmpresaCfgMov WITH(NOLOCK)
			WHERE Empresa = @Empresa
			INSERT Cxp (Sucursal, Empresa, Mov, FechaEmision, Proyecto, Moneda, TipoCambio, Usuario, Referencia, Estatus,
			Proveedor, ProveedorMoneda, ProveedorTipoCambio, Importe, Condicion, Vencimiento, AplicaManual, OrigenTipo, Origen, OrigenID)
				VALUES (@Sucursal, @Empresa, @AforoMov, @FechaEmision, @Proyecto, @ContactoMoneda, @ContactoTipoCambio, @Usuario, @Referencia, 'SINAFECTAR', @Contacto, @ContactoMoneda, @ContactoTipoCambio, @AforoImporte, @Condicion, @Vencimiento, 1, 'PAGARE', @Mov, @MovID)
			SELECT @AforoID = SCOPE_IDENTITY()
			INSERT INTO CxpD (Sucursal, ID, Renglon, RenglonSub, Aplica, AplicaID, Importe)
				VALUES (@Sucursal, @AforoID, 2048.0, 0, @Mov, @MovID, @AforoImporte)
			EXEC spCx @AforoID
					 ,@Modulo
					 ,@Accion
					 ,'TODO'
					 ,@FechaEmision
					 ,NULL
					 ,@Usuario
					 ,1
					 ,0
					 ,@AforoMov OUTPUT
					 ,@AforoMovID OUTPUT
					 ,@IDGenerar OUTPUT
					 ,@Ok OUTPUT
					 ,@OkRef OUTPUT
			EXEC spMovFlujo @Sucursal
						   ,@Accion
						   ,@Empresa
						   ,@Modulo
						   ,@ID
						   ,@Mov
						   ,@MovID
						   ,@Modulo
						   ,@AforoID
						   ,@AforoMov
						   ,@AforoMovID
						   ,@Ok OUTPUT

			IF @Ok IS NULL
			BEGIN
				UPDATE Cxp WITH(ROWLOCK)
				SET Aforo = @AforoImporte
				WHERE ID = @ID
				SELECT @Ok = 80030
					  ,@GenerarMov = @AforoMov
					  ,@GenerarMovID = @AforoMovID
			END

		END

	END

	IF @Estatus = 'BORRADOR'
		AND @Accion = 'AFECTAR'
		AND @IDOrigen IS NOT NULL
		EXEC spMovFlujo @Sucursal
					   ,@Accion
					   ,@Empresa
					   ,@OrigenTipo
					   ,@IDOrigen
					   ,@Origen
					   ,@OrigenID
					   ,@Modulo
					   ,@ID
					   ,@Mov
					   ,@MovID
					   ,@Ok OUTPUT

	IF @MovTipo = 'CXC.C'
		AND @Accion = 'CANCELAR'
		EXEC spCxcVoucherCancelar @ID
								 ,@Usuario
								 ,@FechaRegistro
								 ,@Ok OUTPUT
								 ,@OkRef OUTPUT

	IF @Ok IS NULL
		OR @Ok BETWEEN 80030 AND 81000

		IF @GenerarGasto = 1
			EXEC spGenerarGasto @Accion
							   ,@Empresa
							   ,@Sucursal
							   ,@Usuario
							   ,@Modulo
							   ,@ID
							   ,@Mov
							   ,@MovID
							   ,@FechaEmision
							   ,@FechaRegistro
							   ,@Ok OUTPUT
							   ,@OkRef OUTPUT
							   ,@MovTipoGenerarGasto = 1

	IF @Ok IS NULL
		OR @Ok BETWEEN 80030 AND 81000
		EXEC spCxAfectarClavePresupuestal @ID
										 ,@Accion
										 ,@Empresa
										 ,@Usuario
										 ,@Modulo
										 ,@Mov
										 ,@MovID
										 ,@MovTipo
										 ,@MovMoneda
										 ,@MovTipoCambio
										 ,@FechaEmision
										 ,@Condicion
										 ,@Vencimiento
										 ,@FormaPago
										 ,@Contacto
										 ,@ContactoMoneda
										 ,@ContactoFactor
										 ,@ContactoTipoCambio
										 ,@Importe
										 ,@Impuestos
										 ,@Saldo
										 ,@CtaDinero
										 ,@AplicaManual
										 ,@ConDesglose
										 ,@Conexion
										 ,@SincroFinal
										 ,@Sucursal
										 ,@EstatusNuevo
										 ,@MovAplica
										 ,@MovAplicaID
										 ,@Ok OUTPUT
										 ,@OkRef OUTPUT
										 ,@Estatus

	IF @Ok IS NULL
		OR @Ok BETWEEN 80030 AND 81000
		EXEC xpCxAfectar @ID
						,@Accion
						,@Empresa
						,@Usuario
						,@Modulo
						,@Mov
						,@MovID
						,@MovTipo
						,@MovMoneda
						,@MovTipoCambio
						,@FechaEmision
						,@Condicion
						,@Vencimiento
						,@FormaPago
						,@Contacto
						,@ContactoMoneda
						,@ContactoFactor
						,@ContactoTipoCambio
						,@Importe
						,@Impuestos
						,@Saldo
						,@CtaDinero
						,@AplicaManual
						,@ConDesglose
						,@Conexion
						,@SincroFinal
						,@Sucursal
						,@EstatusNuevo
						,@MovAplica
						,@MovAplicaID
						,@Ok OUTPUT
						,@OkRef OUTPUT
						,@Estatus

	IF @Modulo = 'CXC'
	BEGIN

		IF (
				SELECT TieneMovimientos
				FROM Cte WITH(NOLOCK)
				WHERE Cliente = @Contacto
			)
			= 0
			UPDATE Cte WITH(ROWLOCK)
			SET TieneMovimientos = 1
			WHERE TieneMovimientos = 0
			AND Cliente = @Contacto

	END

	IF @Modulo = 'CXP'
	BEGIN

		IF (
				SELECT TieneMovimientos
				FROM Prov WITH(NOLOCK)
				WHERE Proveedor = @Contacto
			)
			= 0
			UPDATE Prov WITH(ROWLOCK)
			SET TieneMovimientos = 1
			WHERE Proveedor = @Contacto

	END

	IF @Modulo = 'AGENT'
	BEGIN

		IF (
				SELECT TieneMovimientos
				FROM Agente WITH(NOLOCK)
				WHERE Agente = @Contacto
			)
			= 0
			UPDATE Agente WITH(ROWLOCK)
			SET TieneMovimientos = 1
			WHERE Agente = @Contacto

	END

	IF @Agente IS NOT NULL
	BEGIN

		IF (
				SELECT TieneMovimientos
				FROM Agente WITH(NOLOCK)
				WHERE Agente = @Agente
			)
			= 0
			UPDATE Agente WITH(ROWLOCK)
			SET TieneMovimientos = 1
			WHERE Agente = @Agente

	END

	IF @Ok IS NULL
		OR @Ok BETWEEN 80030 AND 81000
		EXEC spMovFinal @Empresa
					   ,@Sucursal
					   ,@Modulo
					   ,@ID
					   ,@Estatus
					   ,@EstatusNuevo
					   ,@Usuario
					   ,@FechaEmision
					   ,@FechaRegistro
					   ,@Mov
					   ,@MovID
					   ,@MovTipo
					   ,@IDGenerar
					   ,@Ok OUTPUT
					   ,@OkRef OUTPUT
					   ,@EstacionTrabajo

	IF @Accion = 'CANCELAR'
		AND @EstatusNuevo = 'CANCELADO'
		AND @Ok IS NULL
		AND @MovTipo = 'CXP.P'
	BEGIN
		SELECT @IDCancelaCXPCA = mf.DID
		FROM MovFlujo mf WITH(NOLOCK)
		JOIN MovTipo mt WITH(NOLOCK)
			ON mf.DModulo = mt.Modulo
			AND mf.DMov = mt.Mov
		WHERE mf.OID = @ID
		AND mf.OModulo = @Modulo
		AND mf.DModulo = @Modulo
		AND mt.Clave = 'CXP.NCF'
		AND Cancelado = 0

		IF @IDCancelaCXPCA IS NOT NULL
			SELECT @IDCancelaCXPCA = mf.DID
			FROM MovFlujo mf WITH(NOLOCK)
			JOIN MovTipo mt WITH(NOLOCK)
				ON mf.DModulo = mt.Modulo
				AND mf.DMov = mt.Mov
			WHERE mf.OID = @IDCancelaCXPCA
			AND mf.OModulo = @Modulo
			AND mf.DModulo = @Modulo
			AND mt.Clave = 'CXP.CA'
			AND Cancelado = 0

		IF @IDCancelaCXPCA IS NOT NULL
			EXEC spCx @IDCancelaCXPCA
					 ,@Modulo
					 ,@Accion
					 ,'TODO'
					 ,@FechaEmision
					 ,NULL
					 ,@Usuario
					 ,1
					 ,0
					 ,NULL
					 ,NULL
					 ,NULL
					 ,@Ok = @Ok OUTPUT
					 ,@OkRef = @OkRef OUTPUT

	END

	IF @MovTipo IN ('CXC.A', 'CXC.AR', 'CXC.AA', 'CXC.C', 'CXC.DC', 'CXC.DE')
		AND @Modulo = 'CXC'
		AND (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
	BEGIN

		IF @TarjetasCobradas <> 0.0
			AND @LDI = 1
			AND @CFDFlex = 0
			AND EXISTS (SELECT * FROM TarjetaSerieMov t WITH(NOLOCK) JOIN ValeSerie v WITH(NOLOCK) ON t.Serie = v.Serie JOIN Art a WITH(NOLOCK) ON v.Articulo = a.Articulo WHERE t.Empresa = @Empresa AND t.Modulo = @Modulo AND t.ID = @ID AND ISNULL(t.Importe, 0) <> 0 AND ISNULL(a.LDI, 0) = 1)
			AND @LDITarjeta = 1
			AND @LDIServicio IS NOT NULL
			EXEC spValeGeneraAplicacionTarjeta @Empresa
											  ,@Modulo
											  ,@ID
											  ,@Mov
											  ,@MovID
											  ,@Accion
											  ,@FechaEmision
											  ,@Usuario
											  ,@Sucursal
											  ,@TarjetasCobradas
											  ,@CtaDinero
											  ,@MovMoneda
											  ,@MovTipoCambio
											  ,@LDIOk OUTPUT
											  ,@LDIOkRef OUTPUT
											  ,@LDI = 1
											  ,@Referencia = @ReferenciaTarjetas

		IF @LDIOk IS NOT NULL
			SELECT @Ok = @LDIOk
				  ,@OkRef = @LDIOkRef

	END

	IF @Accion = 'CANCELAR'
		AND @EstatusNuevo = 'CANCELADO'
		AND @Ok IS NULL
		EXEC spCancelarFlujo @Empresa
							,@Modulo
							,@ID
							,@Ok OUTPUT

	IF @Conexion = 0
	BEGIN

		IF @Ok IS NULL
			OR @Ok BETWEEN 80030 AND 81000
			COMMIT TRANSACTION
		ELSE
		BEGIN
			DECLARE
				@PolizaDescuadrada TABLE (
					Cuenta VARCHAR(20) NULL
				   ,SubCuenta VARCHAR(50) NULL
				   ,Concepto VARCHAR(50) NULL
				   ,Debe MONEY NULL
				   ,Haber MONEY NULL
				   ,SucursalContable INT NULL
				)

			IF EXISTS (SELECT * FROM PolizaDescuadrada WITH(NOLOCK) WHERE Modulo = @Modulo AND ID = @ID)
				INSERT @PolizaDescuadrada (Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable)
					SELECT Cuenta
						  ,SubCuenta
						  ,Concepto
						  ,Debe
						  ,Haber
						  ,SucursalContable
					FROM PolizaDescuadrada WITH(NOLOCK)
					WHERE Modulo = @Modulo
					AND ID = @ID

			ROLLBACK TRANSACTION
			DELETE PolizaDescuadrada
			WHERE Modulo = @Modulo
				AND ID = @ID
			INSERT PolizaDescuadrada (Modulo, ID, Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable)
				SELECT @Modulo
					  ,@ID
					  ,Cuenta
					  ,SubCuenta
					  ,Concepto
					  ,Debe
					  ,Haber
					  ,SucursalContable
				FROM @PolizaDescuadrada
		END

	END

	RETURN
END
GO