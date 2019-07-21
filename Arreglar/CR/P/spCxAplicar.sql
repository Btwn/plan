SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spCxAplicar]
 @ID INT
,@Accion CHAR(20)
,@Empresa CHAR(5)
,@Usuario CHAR(10)
,@Modulo CHAR(5)
,@Mov CHAR(20)
,@MovID VARCHAR(20)
,@MovTipo CHAR(20)
,@MovMoneda CHAR(10)
,@MovTipoCambio FLOAT
,@Referencia VARCHAR(50)
,@Concepto VARCHAR(50)
,@Proyecto VARCHAR(50)
,@Condicion VARCHAR(50) OUTPUT
,@Vencimiento DATETIME OUTPUT
,@FechaEmision DATETIME
,@FechaAfectacion DATETIME
,@FechaRegistro DATETIME
,@Ejercicio INT
,@Periodo INT
,@Contacto CHAR(10)
,@ContactoEnviarA INT
,@ContactoMoneda CHAR(10)
,@ContactoFactor FLOAT
,@ContactoTipoCambio FLOAT
,@Agente CHAR(10)
,@Importe MONEY
,@Impuestos MONEY
,@Retencion MONEY
,@Retencion2 MONEY
,@Retencion3 MONEY
,@ImporteTotal MONEY
,@Conexion BIT
,@SincroFinal BIT
,@Sucursal INT
,@SucursalDestino INT
,@SucursalOrigen INT
,@OrigenTipo CHAR(10)
,@OrigenMovTipo CHAR(20)
,@MovAplica CHAR(20)
,@MovAplicaID VARCHAR(20)
,@MovAplicaMovTipo CHAR(20)
,@CfgContX BIT
,@CfgContXGenerar CHAR(20)
,@CfgEmbarcar BIT
,@AutoAjuste MONEY
,@AutoAjusteMov MONEY
,@CfgDescuentoRecargos BIT
,@CfgRefinanciamientoTasa FLOAT
,@CfgComisionCreditos BIT
,@CfgMovCargoDiverso CHAR(20)
,@CfgMovCreditoDiverso CHAR(20)
,@CfgVentaComisionesCobradas BIT
,@CfgComisionBase CHAR(20)
,@CfgRetencionAlPago BIT
,@CfgRetencionMov CHAR(20)
,@CfgRetencionAcreedor CHAR(10)
,@CfgRetencionConcepto VARCHAR(50)
,@CfgRetencion2Acreedor CHAR(10)
,@CfgRetencion2Concepto VARCHAR(50)
,@CfgRetencion3Acreedor CHAR(10)
,@CfgRetencion3Concepto VARCHAR(50)
,@CfgAC BIT
,@VerificarAplica BIT
,@TieneDescuentoRecargos BIT OUTPUT
,@AplicaPosfechado BIT OUTPUT
,@ImporteAplicado MONEY OUTPUT
,@RedondeoMonetarios INT
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
AS
BEGIN
	DECLARE
		@DiversoID INT
	   ,@DiversoMov CHAR(20)
	   ,@DiversoMovID VARCHAR(20)
	   ,@DiversoImporte MONEY
	   ,@DiversoSaldo MONEY
	   ,@IDGenerar INT
	   ,@EsCargo BIT
	   ,@RamaAfectar CHAR(5)
	   ,@RamaEfectivo CHAR(5)
	   ,@RamaRedondeo CHAR(5)
	   ,@Abono BIT
	   ,@IDAplica INT
	   ,@IDOrigen INT
	   ,@IDMovAplica INT
	   ,@AplicaMov CHAR(20)
	   ,@AplicaMovID VARCHAR(20)
	   ,@ImporteAplicarFactor INT
	   ,@ImporteAplicar MONEY
	   ,@OrdinariosAplicar MONEY
	   ,@OrdinariosNetos MONEY
	   ,@OrdinariosIVAAplicar FLOAT
	   ,@OrdinariosIVANetos FLOAT
	   ,@OtrosCargos MONEY
	   ,@MoratoriosAplicar MONEY
	   ,@MoratoriosNetos MONEY
	   ,@MoratoriosIVAAplicar FLOAT
	   ,@MoratoriosIVANetos FLOAT
	   ,@ImporteNeto MONEY
	   ,@SumaImporteNeto MONEY
	   ,@Saldo MONEY
	   ,@SaldoCto MONEY
	   ,@AutoAjusteD MONEY
	   ,@Ligado BIT
	   ,@LigadoDR BIT
	   ,@Estatus CHAR(20)
	   ,@ContactoImporte MONEY
	   ,@ContactoOrdinarios MONEY
	   ,@ContactoMoratorios MONEY
	   ,@ContactoOrdinariosIVA FLOAT
	   ,@ContactoMoratoriosIVA FLOAT
	   ,@ImporteDetalle MONEY
	   ,@Renglon FLOAT
	   ,@RenglonSub FLOAT
	   ,@AplicaEstatus CHAR(15)
	   ,@AplicaEstatusNuevo CHAR(15)
	   ,@AplicaMovTipo CHAR(20)
	   ,@AplicaMoneda CHAR(10)
	   ,@AplicaTipoCambio FLOAT
	   ,@AplicaContacto CHAR(10)
	   ,@AplicaSaldo MONEY
	   ,@AplicaSaldoN MONEY
	   ,@AplicaSaldoOrdinarios MONEY
	   ,@AplicaSaldoOrdinariosN MONEY
	   ,@AplicaSaldoOrdinariosIVA FLOAT
	   ,@AplicaSaldoOrdinariosIVAN FLOAT
	   ,@AplicaSaldoMoratorios MONEY
	   ,@AplicaSaldoMoratoriosN MONEY
	   ,@AplicaSaldoMoratoriosIVA FLOAT
	   ,@AplicaSaldoMoratoriosIVAN FLOAT
	   ,@AplicaImporte MONEY
	   ,@AplicaImporteTotal MONEY
	   ,@AplicaImporteNeto MONEY
	   ,@AplicaComisionTotal MONEY
	   ,@AplicaComisionPendiente MONEY
	   ,@AplicaComisionPendienteN MONEY
	   ,@AplicaVencimiento DATETIME
	   ,@AplicaFechaEmision DATETIME
	   ,@AplicaFecha DATETIME
	   ,@AplicaFechaAnterior DATETIME
	   ,@AplicaAgente CHAR(10)
	   ,@AplicaLineaCredito VARCHAR(20)
	   ,@ImpuestoAdicional FLOAT
	   ,@NuevoVencimiento DATETIME
	   ,@AfectarComision BIT
	   ,@DescuentoRecargos MONEY
	   ,@ImporteComision MONEY
	   ,@CxModulo CHAR(5)
	   ,@CxMov CHAR(20)
	   ,@CxMovID VARCHAR(20)
	   ,@AplicaSucursal INT
	   ,@AplicaDifID INT
	   ,@AplicaDifMov CHAR(20)
	   ,@AplicaDifMovID VARCHAR(20)
	   ,@AplicaDifMovTipo CHAR(20)
	   ,@AplicaDifEnviarA INT
	   ,@AplicaDifConcepto VARCHAR(50)
	   ,@AplicaDifReferencia VARCHAR(50)
	   ,@AplicaDifImporte MONEY
	   ,@AplicaDifImporteCto MONEY
	   ,@AplicaDifImpuestos MONEY
	   ,@AplicaDifImpuestosCto MONEY
	   ,@AplicaDifImporteDetalle MONEY
	   ,@AplicaDifImporteDetalleCto MONEY
	   ,@AplicaDifEnRojo BIT
	   ,@AplicaSaldoFactor FLOAT
	   ,@AplicaRetencionAlPago BIT
	   ,@AplicaRetencion MONEY
	   ,@AplicaRetencion2 MONEY
	   ,@AplicaRetencion3 MONEY
	   ,@AplicaConcepto VARCHAR(50)
	   ,@AplicaOrigenTipo VARCHAR(10)
	   ,@AplicaOrigen VARCHAR(20)
	   ,@AplicaOrigenID VARCHAR(20)
	   ,@AplicaFactor FLOAT
	   ,@RetencionConcepto VARCHAR(50)
	   ,@Retencion2Concepto VARCHAR(50)
	   ,@Retencion3Concepto VARCHAR(50)
	   ,@IVA FLOAT
	   ,@DRID INT
	   ,@DRRenglon FLOAT
	   ,@DRMov CHAR(20)
	   ,@DRMovID VARCHAR(20)
	   ,@DRAplica CHAR(20)
	   ,@DRAplicaID VARCHAR(20)
	   ,@DRConcepto VARCHAR(50)
	   ,@DRImporte MONEY
	   ,@DRImpuestos MONEY
	   ,@DRImporteTotal MONEY
	   ,@DREsCredito BIT
	   ,@MovDescuento CHAR(20)
	   ,@MovRecargos CHAR(20)
	   ,@ConceptoDescuento VARCHAR(50)
	   ,@ConceptoRecargos VARCHAR(50)
	   ,@UltimoVencimiento DATETIME
	   ,@FechaConclusion DATETIME
	   ,@EsReferencia BIT
	   ,@Peru BIT
	   ,@PPTO BIT
	   ,@CfgPeruRetenciones BIT
	   ,@CfgPeruRetencionesTopeExcento MONEY
	   ,@ContactoAfectar CHAR(10)
	   ,@Fiscal BIT
	   ,@FiscalGenerarRetenciones BIT
	   ,@CfgDevRetencionMov VARCHAR(20)
	   ,@RetencionAlPagoMovImpuesto BIT
	   ,@IDAgent INT
	   ,@IDAgentD INT
	   ,@AgentDevolucion VARCHAR(20)
	   ,@IDAgentDev INT
	   ,@MovIDAgentDev VARCHAR(20)
	   ,@AplicaEjercicio INT
	   ,@AplicaPeriodo INT
	   ,@NoAutoAjustar BIT
	   ,@RamaInteresOrdinario VARCHAR(5)
	   ,@RamaInteresMoratorio VARCHAR(5)
	   ,@SaldoInteresesOrdinarios FLOAT
	   ,@AplicaProyecto VARCHAR(50)
	   ,@CP BIT
		 ,@MovA VARCHAR(20)
	SELECT @RetencionAlPagoMovImpuesto = RetencionAlPagoMovImpuesto
		  ,@FiscalGenerarRetenciones = ISNULL(FiscalGenerarRetenciones, 0)
	FROM EmpresaCfg2
	WHERE Empresa = @Empresa
	SELECT @CfgDevRetencionMov = CxpDevRetencion
	FROM EmpresaCfgMov
	WHERE Empresa = @Empresa
	SELECT @PPTO = PPTO
		  ,@Fiscal = ISNULL(Fiscal, 0)
		  ,@CP = ISNULL(CP, 0)
	FROM EmpresaGral
	WHERE Empresa = @Empresa
	SELECT @Peru = Peru
	FROM Version

	IF @VerificarAplica = 0
	BEGIN
		CREATE TABLE #CxAplicaMovImpuesto (
			Renglon FLOAT NOT NULL
		   ,RenglonSub INT NOT NULL
		   ,Impuesto1 FLOAT NULL
		   ,Impuesto2 FLOAT NULL
		   ,Impuesto3 FLOAT NULL
		   ,Importe1 MONEY NULL
		   ,Importe2 MONEY NULL
		   ,Importe3 MONEY NULL
		   ,SubTotal MONEY NULL
		   ,TipoImpuesto1 VARCHAR(10) COLLATE Database_Default NULL
		   ,TipoImpuesto2 VARCHAR(10) COLLATE Database_Default NULL
		   ,TipoImpuesto3 VARCHAR(10) COLLATE Database_Default NULL
		   ,TipoRetencion1 VARCHAR(10) COLLATE Database_Default NULL
		   ,TipoRetencion2 VARCHAR(10) COLLATE Database_Default NULL
		   ,TipoRetencion3 VARCHAR(10) COLLATE Database_Default NULL
		   ,LoteFijo VARCHAR(20) COLLATE Database_Default NULL
		   ,OrigenModulo VARCHAR(5) COLLATE Database_Default NULL
		   ,OrigenModuloID INT NULL
		   ,OrigenConcepto VARCHAR(50) COLLATE Database_Default NULL
		   ,OrigenDeducible FLOAT NULL DEFAULT 100
		   ,OrigenFecha DATETIME NULL
		   ,Retencion1 FLOAT NULL
		   ,Retencion2 FLOAT NULL
		   ,Retencion3 FLOAT NULL
		   ,Excento1 BIT NULL DEFAULT 0
		   ,Excento2 BIT NULL DEFAULT 0
		   ,Excento3 BIT NULL DEFAULT 0
		   ,ContUso VARCHAR(20) COLLATE Database_Default NULL
		   ,ContUso2 VARCHAR(20) COLLATE Database_Default NULL
		   ,ContUso3 VARCHAR(20) COLLATE Database_Default NULL
		   ,ClavePresupuestal VARCHAR(50) COLLATE Database_Default NULL
		   ,ClavePresupuestalImpuesto1 VARCHAR(50) COLLATE Database_Default NULL
		   ,DescuentoGlobal FLOAT NULL
		)

		IF @PPTO = 1
			CREATE TABLE #CxAplicaMovPresupuesto (
				Renglon FLOAT NOT NULL
			   ,RenglonSub INT NOT NULL
			   ,Importe MONEY NULL
			   ,CuentaPresupuesto VARCHAR(20) COLLATE Database_Default NULL
			)

	END

	SELECT @ContactoAfectar = @Contacto
	SELECT @SumaImporteNeto = 0.0
		  ,@ImporteAplicado = 0.0
		  ,@TieneDescuentoRecargos = 0
		  ,@AplicaPosfechado = 0
		  ,@AfectarComision = 0
		  ,@UltimoVencimiento = NULL
		  ,@IDMovAplica = NULL

	IF @Modulo = 'CXC'
		SELECT @RamaEfectivo = 'CEFE'
			  ,@RamaRedondeo = 'CRND'
	ELSE

	IF @Modulo = 'CXP'
		SELECT @RamaEfectivo = 'PEFE'
			  ,@RamaRedondeo = 'PRND'

	IF @MovAplica IS NOT NULL
		AND @MovAplicaID IS NOT NULL
		AND @MovAplicaMovTipo IS NOT NULL
	BEGIN

		IF @Modulo = 'CXC'
			SELECT @IDMovAplica = ID
				  ,@AplicaProyecto = NULLIF(Proyecto, '')
			FROM Cxc
			WHERE Empresa = @Empresa
			AND Mov = @MovAplica
			AND MovID = @MovAplicaID
			AND Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'CANCELADO')
		ELSE

		IF @Modulo = 'CXP'
			SELECT @IDMovAplica = ID
				  ,@AplicaProyecto = NULLIF(Proyecto, '')
			FROM Cxp
			WHERE Empresa = @Empresa
			AND Mov = @MovAplica
			AND MovID = @MovAplicaID
			AND Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'CANCELADO')

		IF @CP = 1

			IF @Proyecto <> @AplicaProyecto
				SET @Ok = 70216

	END

	IF @MovTipo NOT IN ('CXC.A', 'CXC.AR', 'CXC.AA', 'CXC.AF', 'CXP.A', 'CXP.AA', 'CXP.AF')
		OR @Accion = 'CANCELAR'
	BEGIN

		IF @Modulo = 'CXC'
			DECLARE
				crCxDetalle
				CURSOR LOCAL FOR
				SELECT Renglon
					  ,RenglonSub
					  ,NULLIF(RTRIM(Aplica), '')
					  ,AplicaID
					  ,ISNULL(Importe, 0.0)
					  ,ISNULL(InteresesOrdinarios, 0.0)
					  ,ISNULL(InteresesOrdinarios * (1 - (ISNULL(InteresesOrdinariosQuita, 0.0) / 100)), 0.0)
					  ,ISNULL(InteresesMoratorios, 0.0)
					  ,ISNULL(InteresesMoratorios * (1 - (ISNULL(InteresesMoratoriosQuita, 0.0) / 100)), 0.0)
					  ,ISNULL(ImpuestoAdicional, 0.0)
					  ,ISNULL(OtrosCargos, 0.0)
					  ,Fecha
					  ,FechaAnterior
					  ,ISNULL(DescuentoRecargos, 0.0)
					  ,Ligado
					  ,LigadoDR
					  ,ISNULL(EsReferencia, 0)
					  ,ISNULL(InteresesOrdinariosIVA, 0.0)
					  ,ISNULL(InteresesOrdinariosIVA * (1 - (ISNULL(InteresesOrdinariosQuita, 0.0) / 100)), 0.0)
					  ,ISNULL(InteresesMoratoriosIVA, 0.0)
					  ,ISNULL(InteresesMoratoriosIVA * (1 - (ISNULL(InteresesMoratoriosQuita, 0.0) / 100)), 0.0)
				FROM CxcD
				WHERE ID = @ID
		ELSE

		IF @Modulo = 'CXP'
			DECLARE
				crCxDetalle
				CURSOR LOCAL FOR
				SELECT Renglon
					  ,RenglonSub
					  ,NULLIF(RTRIM(Aplica), '')
					  ,AplicaID
					  ,ISNULL(Importe, 0.0)
					  ,ISNULL(InteresesOrdinarios, 0.0)
					  ,ISNULL(InteresesOrdinarios * (1 - (ISNULL(InteresesOrdinariosQuita, 0.0) / 100)), 0.0)
					  ,ISNULL(InteresesMoratorios, 0.0)
					  ,ISNULL(InteresesMoratorios * (1 - (ISNULL(InteresesMoratoriosQuita, 0.0) / 100)), 0.0)
					  ,0.0
					  ,0.0
					  ,Fecha
					  ,FechaAnterior
					  ,ISNULL(DescuentoRecargos, 0.0)
					  ,Ligado
					  ,LigadoDR
					  ,0
					  ,ISNULL(InteresesOrdinariosIVA, 0.0)
					  ,ISNULL(InteresesOrdinariosIVA * (1 - (ISNULL(InteresesOrdinariosQuita, 0.0) / 100)), 0.0)
					  ,ISNULL(InteresesMoratoriosIVA, 0.0)
					  ,ISNULL(InteresesMoratoriosIVA * (1 - (ISNULL(InteresesMoratoriosQuita, 0.0) / 100)), 0.0)
				FROM CxpD
				WHERE ID = @ID
		ELSE

		IF @Modulo = 'AGENT'
			DECLARE
				crCxDetalle
				CURSOR LOCAL FOR
				SELECT Renglon
					  ,RenglonSub
					  ,NULLIF(RTRIM(Aplica), '')
					  ,AplicaID
					  ,ISNULL(Importe, 0.0)
					  ,0.0
					  ,0.0
					  ,0.0
					  ,0.0
					  ,0.0
					  ,0.0
					  ,GETDATE()
					  ,GETDATE()
					  ,0.0
					  ,0
					  ,0
					  ,0
					  ,0.0
					  ,0.0
					  ,0.0
					  ,0.0
				FROM AgentD
				WHERE ID = @ID

		OPEN crCxDetalle
		FETCH NEXT FROM crCxDetalle INTO @Renglon, @RenglonSub, @AplicaMov, @AplicaMovID, @ImporteAplicar, @OrdinariosAplicar, @OrdinariosNetos, @MoratoriosAplicar, @MoratoriosNetos, @ImpuestoAdicional, @OtrosCargos, @AplicaFecha, @AplicaFechaAnterior, @DescuentoRecargos, @Ligado, @LigadoDR, @EsReferencia, @OrdinariosIVAAplicar, @OrdinariosIVANetos, @MoratoriosIVAAplicar, @MoratoriosIVANetos

		IF @@ERROR <> 0
			SELECT @Ok = 1

		WHILE @@FETCH_STATUS <> -1
		AND @Ok IS NULL
		BEGIN

		IF @AplicaMov = @MovAplica
			AND @AplicaMovID = @MovAplicaID
			SELECT @Ok = 20180

		SELECT @AplicaMovTipo = Clave
		FROM MovTipo
		WHERE Modulo = @Modulo
		AND Mov = @AplicaMov

		IF @@FETCH_STATUS <> -2
			AND (@ImporteAplicar <> 0.0 OR @OrdinariosAplicar <> 0.0 OR @MoratoriosAplicar <> 0.0 OR @OtrosCargos <> 0.0 OR @Modulo = 'AGENT')
			AND @Ok IS NULL
		BEGIN
			SELECT @ImporteNeto = @ImporteAplicar + @DescuentoRecargos

			IF @DescuentoRecargos < 0.0
				SELECT @ImporteAplicar = @ImporteAplicar + @DescuentoRecargos

			IF @AplicaMovTipo IN ('CXC.DP', 'CXP.DP')
				SELECT @AplicaPosfechado = 1

			IF @MovTipo = 'AGENT.P'
			BEGIN

				IF @AplicaMovTipo IN ('AGENT.D', 'AGENT.A')
				BEGIN

					IF @ImporteAplicar > 0.0
						SELECT @Ok = 30350

				END
				ELSE

				IF @ImporteAplicar < 0.0
					SELECT @Ok = 30351

			END
			ELSE

			IF @MovTipo = 'AGENT.CO'
			BEGIN

				IF @AplicaMovTipo IN ('AGENT.D', 'AGENT.A')
				BEGIN

					IF @ImporteAplicar < 0.0
						SELECT @Ok = 30351

				END
				ELSE

				IF @ImporteAplicar > 0.0
					SELECT @Ok = 30350

			END

			IF @VerificarAplica = 1
			BEGIN

				IF @Modulo = 'CXC'
					SELECT @AplicaMoneda = ClienteMoneda
						  ,@AplicaSaldo = ISNULL(Saldo, 0.0)
						  ,@AplicaSaldoOrdinarios = ISNULL(SaldoInteresesOrdinarios, 0.0)
						  ,@AplicaSaldoOrdinariosIVA = ISNULL(SaldoInteresesOrdinariosIVA, 0.0)
						  ,@AplicaSaldoMoratorios = ISNULL(SaldoInteresesMoratorios, 0.0)
						  ,@AplicaSaldoMoratoriosIVA = ISNULL(SaldoInteresesMoratoriosIVA, 0.0)
						  ,@AplicaContacto = Cliente
						  ,@AplicaVencimiento = Vencimiento
					FROM Cxc
					WHERE Empresa = @Empresa
					AND Mov = @AplicaMov
					AND MovID = @AplicaMovID
					AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
				ELSE

				IF @Modulo = 'CXP'
					SELECT @AplicaMoneda = ProveedorMoneda
						  ,@AplicaSaldo = ISNULL(Saldo, 0.0)
						  ,@AplicaSaldoOrdinarios = ISNULL(SaldoInteresesOrdinarios, 0.0)
						  ,@AplicaSaldoOrdinariosIVA = ISNULL(SaldoInteresesOrdinariosIVA, 0.0)
						  ,@AplicaSaldoMoratorios = ISNULL(SaldoInteresesMoratorios, 0.0)
						  ,@AplicaSaldoMoratoriosIVA = ISNULL(SaldoInteresesMoratoriosIVA, 0.0)
						  ,@AplicaContacto = Proveedor
						  ,@AplicaVencimiento = Vencimiento
					FROM Cxp
					WHERE Empresa = @Empresa
					AND Mov = @AplicaMov
					AND MovID = @AplicaMovID
					AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
				ELSE

				IF @Modulo = 'AGENT'
					SELECT @AplicaMoneda = Moneda
						  ,@AplicaSaldo = ISNULL(Saldo, 0.0)
						  ,@AplicaContacto = Agente
					FROM Agent
					WHERE Empresa = @Empresa
					AND Mov = @AplicaMov
					AND MovID = @AplicaMovID
					AND Estatus IN ('PENDIENTE', 'CONCLUIDO')

				IF (@AplicaMoneda <> @ContactoMoneda AND @Modulo = 'AGENT')
					OR ((@AplicaContacto <> @Contacto OR @AplicaMoneda <> @ContactoMoneda) AND @Modulo <> 'AGENT')
					SELECT @Ok = 30210

				IF @UltimoVencimiento IS NULL
					OR @AplicaVencimiento > @UltimoVencimiento
					SELECT @UltimoVencimiento = @AplicaVencimiento

				IF @MovTipo = 'CXC.RM'
				BEGIN

					IF ROUND(@ImporteAplicar, @RedondeoMonetarios) <> ROUND(CONVERT(MONEY, @AplicaSaldo * DATEDIFF(DAY, @AplicaVencimiento, @AplicaFecha) * (@CfgRefinanciamientoTasa / 100.0)), @RedondeoMonetarios)
						SELECT @Ok = 30240

				END

				IF @Modulo = 'CXC'
					AND @MovTipo = 'CXC.DC'
					AND @AplicaMovTipo NOT IN ('CXC.NC', 'CXC.NCD', 'CXC.DAC', 'CXC.NCF', 'CXC.DV', 'CXC.A', 'CXC.AR', 'CXC.DA')
					SELECT @Ok = 20180
				ELSE

				IF @Modulo = 'CXP'
					AND @MovTipo = 'CXP.DC'
					AND @AplicaMovTipo NOT IN ('CXP.NC', 'CXP.NCD', 'CXP.DAC', 'CXP.NCF', 'CXP.A', 'CXP.DA')
					SELECT @Ok = 20180

			END

			IF @DescuentoRecargos <> 0.0
			BEGIN

				IF @MovTipo IN ('CXC.C', 'CXC.D', 'CXC.DM', 'CXC.ANC', 'CXP.P', 'CXP.D', 'CXP.DM', 'CXP.PAG', 'CXP.ANC')
					AND @CfgDescuentoRecargos = 1
				BEGIN
					SELECT @TieneDescuentoRecargos = 1
				END
				ELSE
					SELECT @Ok = 30325

			END

			SELECT @ContactoImporte = @ImporteAplicar / @ContactoFactor
				  ,@ContactoOrdinarios = @OrdinariosAplicar / @ContactoFactor
				  ,@ContactoOrdinariosIVA = @OrdinariosIVAAplicar / @ContactoFactor
				  ,@ContactoMoratorios = @MoratoriosAplicar / @ContactoFactor
				  ,@ContactoMoratoriosIVA = @MoratoriosIVAAplicar / @ContactoFactor

			IF UPPER(@AplicaMov) IN ('EFECTIVO A FAVOR', 'SALDO A FAVOR', 'REDONDEO', 'ANTICIPOS ACUMULADOS')
			BEGIN

				IF @MovTipo IN ('CXC.IM', 'CXC.RM')
					SELECT @Ok = 20180

				IF @VerificarAplica = 0
				BEGIN

					IF @MovTipo IN ('CXC.DA', 'CXC.DC', 'CXC.ACA', 'CXP.ACA', 'CXP.DA', 'CXP.DC')
						SELECT @EsCargo = 1
					ELSE
						SELECT @EsCargo = 0

					IF @Accion = 'CANCELAR'
						SELECT @EsCargo = ~@EsCargo

					IF UPPER(@AplicaMov) = 'REDONDEO'
						SELECT @RamaAfectar = @RamaRedondeo
					ELSE
						SELECT @RamaAfectar = @RamaEfectivo

					EXEC spSaldo @Sucursal
								,@Accion
								,@Empresa
								,@Usuario
								,@RamaAfectar
								,@ContactoMoneda
								,@ContactoTipoCambio
								,@ContactoAfectar
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
								,@AplicaMov
								,NULL
								,0
								,0
								,0
								,@Ok OUTPUT
								,@OkRef OUTPUT
				END

			END
			ELSE
			BEGIN
				SELECT @AplicaSaldo = 0.0
					  ,@AplicaSaldoOrdinarios = 0.0
					  ,@AplicaSaldoOrdinariosIVA = 0.0
					  ,@AplicaSaldoMoratorios = 0.0
					  ,@AplicaSaldoMoratoriosIVA = 0.0
					  ,@AutoAjusteD = 0.0
					  ,@IDAplica = NULL
					  ,@AplicaImporteTotal = 0.0
					  ,@AplicaComisionTotal = 0.0
					  ,@AplicaComisionPendiente = 0.0
					  ,@AplicaRetencionAlPago = 0
					  ,@AplicaRetencion = 0.0
					  ,@AplicaRetencion2 = 0.0
					  ,@AplicaRetencion3 = 0.0
					  ,@AplicaOrigenTipo = NULL
					  ,@AplicaOrigen = NULL
					  ,@AplicaOrigenID = NULL

				IF @Modulo = 'CXC'
					SELECT @IDAplica = ID
						  ,@AplicaEstatus = Estatus
						  ,@AplicaConcepto = Concepto
						  ,@AplicaSaldo = ISNULL(Saldo, 0.0)
						  ,@AplicaSaldoOrdinarios = ISNULL(SaldoInteresesOrdinarios, 0.0)
						  ,@AplicaSaldoOrdinariosIVA = ISNULL(SaldoInteresesOrdinariosIVA, 0.0)
						  ,@AplicaSaldoMoratorios = ISNULL(InteresesMoratorios, 0.0)
						  ,@AplicaSaldoMoratoriosIVA = ISNULL(InteresesMoratoriosIVA, 0.0)
						  ,@AplicaImporte = ISNULL(Importe, 0.0)
						  ,@AplicaImporteTotal = ISNULL(Importe, 0.0) + ISNULL(Impuestos, 0.0)
						  ,@AutoAjusteD = ISNULL(AutoAjuste, 0.0)
						  ,@AplicaMoneda = Moneda
						  ,@AplicaTipoCambio = TipoCambio
						  ,@AplicaFechaEmision = FechaEmision
						  ,@AplicaVencimiento = Vencimiento
						  ,@Estatus = Estatus
						  ,@AplicaOrigenTipo = OrigenTipo
						  ,@AplicaOrigen = PadreMAVI
						  ,@AplicaOrigenID = PadreIDMAVI
						  ,@AplicaLineaCredito = LineaCredito
						  ,@AplicaComisionTotal = ISNULL(ComisionTotal, 0.0)
						  ,@AplicaComisionPendiente = ISNULL(ComisionPendiente, 0.0)
						  ,@AplicaAgente = NULLIF(RTRIM(Agente), '')
						  ,@AplicaRetencion = ISNULL(Retencion, 0.0)
						  ,@AplicaRetencion2 = ISNULL(Retencion2, 0.0)
						  ,@AplicaRetencion3 = ISNULL(Retencion3, 0.0)
						  ,@AplicaEjercicio = Ejercicio
						  ,@AplicaPeriodo = Periodo
						  ,@NoAutoAjustar = ISNULL(NoAutoAjustar, 0)
						  ,@AplicaProyecto = NULLIF(Proyecto, '')
					FROM Cxc
					WHERE Empresa = @Empresa
					AND Mov = @AplicaMov
					AND MovID = @AplicaMovID
					AND Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'CANCELADO')
				ELSE

				IF @Modulo = 'CXP'
					SELECT @IDAplica = ID
						  ,@AplicaEstatus = Estatus
						  ,@AplicaConcepto = Concepto
						  ,@AplicaSaldo = ISNULL(Saldo, 0.0)
						  ,@AplicaSaldoOrdinarios = ISNULL(SaldoInteresesOrdinarios, 0.0)
						  ,@AplicaSaldoOrdinariosIVA = ISNULL(SaldoInteresesOrdinariosIVA, 0.0)
						  ,@AplicaSaldoMoratorios = ISNULL(InteresesMoratorios, 0.0)
						  ,@AplicaSaldoMoratoriosIVA = ISNULL(InteresesMoratoriosIVA, 0.0)
						  ,@AplicaImporte = ISNULL(Importe, 0.0)
						  ,@AplicaImporteTotal = ISNULL(Importe, 0.0) + ISNULL(Impuestos, 0.0)
						  ,@AutoAjusteD = ISNULL(AutoAjuste, 0.0)
						  ,@AplicaMoneda = Moneda
						  ,@AplicaTipoCambio = TipoCambio
						  ,@AplicaFechaEmision = FechaEmision
						  ,@AplicaVencimiento = Vencimiento
						  ,@Estatus = Estatus
						  ,@AplicaOrigenTipo = OrigenTipo
						  ,@AplicaOrigen = Origen
						  ,@AplicaOrigenID = OrigenID
						  ,@AplicaLineaCredito = LineaCredito
						  ,@AplicaRetencionAlPago = ISNULL(RetencionAlPago, 0)
						  ,@AplicaRetencion = ISNULL(Retencion, 0.0)
						  ,@AplicaRetencion2 = ISNULL(Retencion2, 0.0)
						  ,@AplicaRetencion3 = ISNULL(Retencion3, 0.0)
						  ,@AplicaEjercicio = Ejercicio
						  ,@AplicaPeriodo = Periodo
						  ,@NoAutoAjustar = ISNULL(NoAutoAjustar, 0)
						  ,@AplicaProyecto = NULLIF(Proyecto, '')
					FROM Cxp
					WHERE Empresa = @Empresa
					AND Mov = @AplicaMov
					AND MovID = @AplicaMovID
					AND Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'CANCELADO')

				IF @Modulo = 'AGENT'
					SELECT @IDAplica = ID
						  ,@AplicaEstatus = Estatus
						  ,@AplicaConcepto = Concepto
						  ,@AplicaSaldo = ISNULL(Saldo, 0.0)
						  ,@AplicaImporte = ISNULL(Importe, 0.0)
						  ,@AplicaImporteTotal = ISNULL(Importe, 0.0)
						  ,@AutoAjusteD = ISNULL(AutoAjuste, 0.0)
						  ,@AplicaMoneda = Moneda
						  ,@AplicaTipoCambio = TipoCambio
						  ,@AplicaFechaEmision = FechaEmision
						  ,@Estatus = Estatus
						  ,@AplicaEjercicio = Ejercicio
						  ,@AplicaPeriodo = Periodo
					FROM Agent
					WHERE Empresa = @Empresa
					AND Mov = @AplicaMov
					AND MovID = @AplicaMovID
					AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'CANCELADO')

				IF @@ERROR <> 0
					SELECT @Ok = 1

				SELECT @AplicaImporteNeto = @AplicaImporteTotal - @AplicaRetencion - @AplicaRetencion2 - @AplicaRetencion3

				IF @CP = 1

					IF @Proyecto <> @AplicaProyecto
						AND @Modulo IN ('CXC', 'CXP')
						SET @Ok = 70216

				IF @Ok IS NULL
					AND @Accion <> 'CANCELAR'
					EXEC spValidarFechaAplicacion @Sucursal
												 ,@Accion
												 ,@Empresa
												 ,@Modulo
												 ,@ID
												 ,@Mov
												 ,@MovID
												 ,@FechaEmision
												 ,@Ejercicio
												 ,@Periodo
												 ,@AplicaMov
												 ,@AplicaMovID
												 ,@Modulo
												 ,@IDAplica
												 ,@AplicaFechaEmision
												 ,@AplicaEjercicio
												 ,@AplicaPeriodo
												 ,@Ok = @Ok OUTPUT
												 ,@OkRef = @OkRef OUTPUT

				IF @Ok IS NULL
					AND @Accion <> 'CANCELAR'
					EXEC spEmpresaValidarFechaAplicacion @Sucursal
														,@Accion
														,@Empresa
														,@Modulo
														,@ID
														,@Mov
														,@MovID
														,@FechaEmision
														,@Ejercicio
														,@Periodo
														,@AplicaMov
														,@AplicaMovID
														,@Modulo
														,@IDAplica
														,@AplicaFechaEmision
														,@AplicaEjercicio
														,@AplicaPeriodo
														,@Ok = @Ok OUTPUT
														,@OkRef = @OkRef OUTPUT

				IF (@MovMoneda <> @AplicaMoneda)
					SELECT @AplicaFactor = (@ImporteAplicar * @MovTipoCambio) / NULLIF(CONVERT(FLOAT, @AplicaImporteNeto * @AplicaTipoCambio), 0)
				ELSE
					SELECT @AplicaFactor = @ImporteAplicar / NULLIF(CONVERT(FLOAT, @AplicaImporteNeto), 0)

				IF @MovMoneda <> @AplicaMoneda
					SELECT @AplicaFactor = @AplicaFactor / @MovTipoCambio * @AplicaTipoCambio

				IF @VerificarAplica = 1
				BEGIN
					EXEC spAplicaOk @Empresa
								   ,@Usuario
								   ,@Modulo
								   ,@IDAplica
								   ,@Ok OUTPUT
								   ,@OkRef OUTPUT
								   ,@AplicaSucursal OUTPUT

					IF @MovTipo = 'CXC.AR'
					BEGIN

						IF @AplicaSucursal = @SucursalDestino
							SELECT @Ok = NULL
								  ,@OkRef = NULL
						ELSE
							SELECT @Ok = 60300

					END

					IF @IDMovAplica IS NOT NULL
						AND @Ok IS NULL
						EXEC spAplicaOk @Empresa
									   ,@Usuario
									   ,@Modulo
									   ,@IDMovAplica
									   ,@Ok OUTPUT
									   ,@OkRef OUTPUT
									   ,@AplicaSucursal OUTPUT

				END

				IF @IDAplica IS NULL
					AND @EsReferencia = 0
					SELECT @Ok = 30120

				IF @Accion NOT IN ('CANCELAR', 'GENERAR')
				BEGIN

					IF @MovTipo IN ('CXC.AJA', 'CXP.AJA')
					BEGIN

						IF @Estatus NOT IN ('PENDIENTE', 'CONCLUIDO')
							SELECT @Ok = 30060

					END
					ELSE
					BEGIN

						IF @Estatus = 'PENDIENTE'
						BEGIN
							SELECT @MovA = Mov
							FROM CXC
							WHERE ID = @ID

							IF (ABS(@AplicaSaldo) - ABS(@ContactoImporte) <= -@AutoAjuste)
								AND @Ligado = 0
								AND @MovTipo NOT IN ('CXC.IM', 'CXC.RM')
								AND @MovA NOT IN ('React Incobrable F', 'React Incobrable NV')
								SELECT @Ok = 30070

							IF @CfgAC = 1
							BEGIN

								IF (@AplicaSaldoOrdinarios - @ContactoOrdinarios <= -@AutoAjuste)
									AND @Ligado = 0
									AND (
										SELECT UPPER(CobroIntereses)
										FROM LC
										WHERE LineaCredito = @AplicaLineaCredito
									)
									= 'DEVENGADOS'
									SELECT @Ok = 30071

								IF (@AplicaSaldoMoratorios - @ContactoMoratorios <= -@AutoAjuste)
									AND @Ligado = 0
									SELECT @Ok = 30072

							END

						END
						ELSE

						IF (ABS(@AplicaSaldo) - ABS(@ContactoImporte) <= -@AutoAjuste)
							AND @Ligado = 0
							AND @MovTipo NOT IN ('CXC.IM', 'CXC.RM')
							SELECT @Ok = 30070

					END

				END

				IF @Ok IS NULL
				BEGIN

					IF @VerificarAplica = 0
						AND @EsReferencia = 0
					BEGIN

						IF @MovTipo IN ('CXC.IM', 'CXC.RM')
						BEGIN

							IF @MovTipo = 'CXC.IM'
								SELECT @NuevoVencimiento = @FechaAfectacion
							ELSE

							IF @MovTipo = 'CXC.RM'
								SELECT @NuevoVencimiento = @AplicaFecha

							IF @Accion = 'CANCELAR'
								SELECT @NuevoVencimiento = @AplicaFechaAnterior
							ELSE
								UPDATE CxcD
								SET FechaAnterior = @AplicaVencimiento
								WHERE CURRENT OF crCxDetalle

							UPDATE Cxc
							SET Condicion = '(Fecha)'
							   ,Vencimiento = @NuevoVencimiento
							WHERE ID = @IDAplica
						END
						ELSE
						BEGIN

							IF @Accion <> 'CANCELAR'
								SELECT @EsCargo = 0
									  ,@ImporteDetalle = -@ContactoImporte
							ELSE
								SELECT @EsCargo = 1
									  ,@ImporteDetalle = @ContactoImporte

							IF @MovTipo IN ('CXC.ACA', 'CXP.ACA')
								OR ((@AplicaMovTipo IN ('CXC.DA', 'CXC.NC', 'CXC.NCD', 'CXC.NCF', 'CXC.DV', 'CXC.NCP', 'CXC.DC', 'CXP.A', 'CXP.NC', 'CXP.NCD', 'CXP.NCP', 'CXP.NCF', 'CXP.DC', 'CXC.DAC', 'CXP.DAC')) OR (@Modulo = 'AGENT' AND @ImporteAplicar < 0.0))

								IF @EsCargo = 0
									SELECT @EsCargo = 1
								ELSE
									SELECT @EsCargo = 0

							IF @MovTipo IN ('CXC.ACA', 'CXP.ACA')
								OR ((@AplicaMovTipo IN ('CXC.A', 'CXC.AR', 'CXC.DA', 'CXC.NC', 'CXC.NCD', 'CXC.NCF', 'CXC.DV', 'CXC.NCP', 'CXP.A', 'CXP.DA', 'CXP.NC', 'CXP.NCD', 'CXP.NCF', 'CXP.NCP', 'CXC.DAC', 'CXP.DAC') AND @MovTipo NOT IN ('CXC.DA', 'CXC.DC', 'CXP.DA', 'CXP.DC')) OR (@Modulo = 'AGENT' AND @ImporteAplicar < 0.0))
								SELECT @ImporteDetalle = -@ImporteDetalle

							IF @MovTipo IN ('CXC.CA', 'CXC.CAD', 'CXC.CAP', 'CXP.CA', 'CXP.CAD', 'CXP.CAP')
								SELECT @ImporteDetalle = -@ImporteDetalle

							IF @Modulo IN ('CXC', 'CXP')
								AND (@AplicaOrigenTipo IN (NULL, 'VTAS', 'COMS', 'CXC', 'CXP', 'GAS', 'INV') OR (@PPTO = 1 AND @AplicaOrigenTipo = 'GAS'))
							BEGIN
								SELECT @IDOrigen = NULL

								IF @AplicaOrigenTipo = 'VTAS'
									SELECT @IDOrigen = ID
									FROM Venta
									WHERE Mov = @AplicaOrigen
									AND MovID = @AplicaOrigenID
									AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
								ELSE

								IF @AplicaOrigenTipo = 'COMS'
									SELECT @IDOrigen = ID
									FROM Compra
									WHERE Mov = @AplicaOrigen
									AND MovID = @AplicaOrigenID
									AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
								ELSE

								IF @AplicaOrigenTipo = 'GAS'
									SELECT @IDOrigen = ID
									FROM Gasto
									WHERE Mov = @AplicaOrigen
									AND MovID = @AplicaOrigenID
									AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
								ELSE

								IF @AplicaOrigenTipo = 'CXC'
									OR (@AplicaOrigenTipo IS NULL AND @Modulo = 'CXC')
									SELECT @IDOrigen = ID
									FROM Cxc
									WHERE Mov = @AplicaMov
									AND MovID = @AplicaMovID
									AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
								ELSE

								IF @AplicaOrigenTipo = 'CXP'
									OR (@AplicaOrigenTipo IS NULL AND @Modulo = 'CXP')
									SELECT @IDOrigen = ID
									FROM Cxp
									WHERE Mov = @AplicaMov
									AND MovID = @AplicaMovID
									AND Estatus IN ('PENDIENTE', 'CONCLUIDO')

								IF @IDAplica IS NOT NULL
								BEGIN
									INSERT #CxAplicaMovImpuesto (Renglon, RenglonSub, OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenDeducible, OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, Importe1, Importe2, Importe3, SubTotal, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal)
										SELECT @Renglon
											  ,@RenglonSub
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
											  ,Importe1 * @AplicaFactor
											  ,Importe2 * @AplicaFactor
											  ,Importe3 * @AplicaFactor
											  ,SubTotal * @AplicaFactor
											  ,ContUso
											  ,ContUso2
											  ,ContUso3
											  ,ClavePresupuestal
											  ,ClavePresupuestalImpuesto1
											  ,DescuentoGlobal
										FROM MovImpuesto
										WHERE Modulo = @Modulo
										AND ModuloID = @IDAplica

									IF @PPTO = 1
										INSERT #CxAplicaMovPresupuesto (Renglon, RenglonSub, CuentaPresupuesto, Importe)
											SELECT @Renglon
												  ,@RenglonSub
												  ,CuentaPresupuesto
												  ,Importe * @AplicaFactor
											FROM MovPresupuesto
											WHERE Modulo = @Modulo
											AND ModuloID = @IDAplica

								END

							END

							IF @Ligado = 0
								AND @EsReferencia = 0
							BEGIN

								IF @Accion = 'CANCELAR'
									SELECT @AplicaSaldoOrdinariosN = @AplicaSaldoOrdinarios + @OrdinariosAplicar
										  ,@AplicaSaldoMoratoriosN = @AplicaSaldoMoratorios + @MoratoriosAplicar
										  ,@AplicaSaldoOrdinariosIVAN = @AplicaSaldoOrdinariosIVA + @OrdinariosIVAAplicar
										  ,@AplicaSaldoMoratoriosIVAN = @AplicaSaldoMoratoriosIVA + @MoratoriosIVAAplicar
								ELSE
									SELECT @AplicaSaldoOrdinariosN = @AplicaSaldoOrdinarios - @OrdinariosAplicar
										  ,@AplicaSaldoMoratoriosN = @AplicaSaldoMoratorios - @MoratoriosAplicar
										  ,@AplicaSaldoOrdinariosIVAN = @AplicaSaldoOrdinariosIVA - @OrdinariosIVAAplicar
										  ,@AplicaSaldoMoratoriosIVAN = @AplicaSaldoMoratoriosIVA - @MoratoriosIVAAplicar

								IF @AplicaSaldoOrdinariosN < 0.0
									SELECT @Ok = 30070
										  ,@OkRef = 'Intereses Ordinarios'
								ELSE

								IF @AplicaSaldoMoratoriosN < 0.0
									SELECT @Ok = 30070
										  ,@OkRef = 'Intereses Moratorios'
								ELSE

								IF @AplicaSaldoOrdinariosN < 0.0
									SELECT @Ok = 30070
										  ,@OkRef = 'IVA Intereses Ordinarios'
								ELSE

								IF @AplicaSaldoMoratoriosN < 0.0
									SELECT @Ok = 30070
										  ,@OkRef = 'IVA Intereses Moratorios'

								IF @ImporteAplicar < 0.0
									SELECT @ImporteAplicarFactor = -1
								ELSE
									SELECT @ImporteAplicarFactor = 1

								IF @Accion <> 'CANCELAR'
									AND ABS(@AplicaSaldo + @ImporteDetalle + @AplicaSaldoOrdinariosN + @AplicaSaldoOrdinariosIVAN + @AplicaSaldoMoratoriosN + @AplicaSaldoMoratoriosIVAN) <= (@AutoAjuste / @ContactoFactor)
									AND @NoAutoAjustar = 0
								BEGIN
									SELECT @ImporteAplicar = @AplicaSaldo * @ContactoFactor
									SELECT @ContactoImporte = @ImporteAplicar / @ContactoFactor
									SELECT @AutoAjusteD = NULLIF(@AplicaSaldo + @ImporteDetalle, 0.0)
									SELECT @AplicaSaldoN = NULL
										  ,@AplicaEstatusNuevo = 'CONCLUIDO'
									SELECT @ImporteAplicar = @ImporteAplicar * @ImporteAplicarFactor
										  ,@ContactoImporte = @ContactoImporte * @ImporteAplicarFactor

									IF @MovTipo IN ('CXC.DP', 'CXP.DP')
										SELECT @FechaConclusion = @Vencimiento
									ELSE
										SELECT @FechaConclusion = @FechaEmision

									EXEC spValidarTareas @Empresa
														,@Modulo
														,@IDAplica
														,@AplicaEstatusNuevo
														,@Ok OUTPUT
														,@OkRef OUTPUT

									IF @Modulo = 'CXC'
										UPDATE Cxc
										SET Saldo = @AplicaSaldoN
										   ,SaldoInteresesOrdinarios = @AplicaSaldoOrdinariosN
										   ,SaldoInteresesOrdinariosIVA = @AplicaSaldoOrdinariosIVAN
										   ,SaldoInteresesMoratorios = @AplicaSaldoMoratoriosN
										   ,SaldoInteresesMoratoriosIVA = @AplicaSaldoMoratoriosIVAN
										   ,AutoAjuste = @AutoAjusteD
										   ,Estatus = @AplicaEstatusNuevo
										   ,FechaConclusion = @FechaConclusion
										   ,UltimoCambio = @FechaEmision
										WHERE ID = @IDAplica
									ELSE

									IF @Modulo = 'CXP'
										UPDATE Cxp
										SET Saldo = @AplicaSaldoN
										   ,SaldoInteresesOrdinarios = @AplicaSaldoOrdinariosN
										   ,SaldoInteresesOrdinariosIVA = @AplicaSaldoOrdinariosIVAN
										   ,SaldoInteresesMoratorios = @AplicaSaldoMoratoriosN
										   ,SaldoInteresesMoratoriosIVA = @AplicaSaldoMoratoriosIVAN
										   ,AutoAjuste = @AutoAjusteD
										   ,Estatus = @AplicaEstatusNuevo
										   ,FechaConclusion = @FechaConclusion
										   ,UltimoCambio = @FechaEmision
										WHERE ID = @IDAplica
									ELSE

									IF @Modulo = 'AGENT'
										UPDATE Agent
										SET Saldo = @AplicaSaldoN
										   ,AutoAjuste = @AutoAjusteD
										   ,Estatus = @AplicaEstatusNuevo
										   ,FechaConclusion = @FechaConclusion
										   ,UltimoCambio = @FechaEmision
										WHERE ID = @IDAplica

									IF @AplicaPosfechado = 1
										AND ISNULL(@AplicaSaldoN, 0) <> 0
										AND @Accion <> 'CANCELAR'
										SELECT @Ok = 30395

								END
								ELSE
								BEGIN
									SELECT @AplicaSaldoN = NULLIF(@AplicaSaldo + @AutoAjusteD + @ImporteDetalle, 0.0)

									IF @AplicaSaldoN IS NULL
										AND ROUND(@AplicaSaldoOrdinariosN, 0) = 0.0
										AND ROUND(@AplicaSaldoOrdinariosIVAN, 0) = 0.0
										AND ROUND(@AplicaSaldoMoratoriosN, 0) = 0.0
										AND ROUND(@AplicaSaldoMoratoriosIVAN, 0) = 0.0
										SELECT @AplicaEstatusNuevo = 'CONCLUIDO'
									ELSE
										SELECT @AplicaEstatusNuevo = 'PENDIENTE'

									EXEC spValidarTareas @Empresa
														,@Modulo
														,@IDAplica
														,@AplicaEstatusNuevo
														,@Ok OUTPUT
														,@OkRef OUTPUT

									IF @Modulo = 'CXC'
										UPDATE Cxc
										SET Saldo = @AplicaSaldoN
										   ,SaldoInteresesOrdinarios = @AplicaSaldoOrdinariosN
										   ,SaldoInteresesOrdinariosIVA = @AplicaSaldoOrdinariosIVAN
										   ,SaldoInteresesMoratorios = @AplicaSaldoMoratoriosN
										   ,SaldoInteresesMoratoriosIVA = @AplicaSaldoMoratoriosIVAN
										   ,AutoAjuste = NULL
										   ,Estatus = @AplicaEstatusNuevo
										   ,FechaConclusion = NULL
										   ,UltimoCambio = @FechaEmision
										WHERE ID = @IDAplica
									ELSE

									IF @Modulo = 'CXP'
										UPDATE Cxp
										SET Saldo = @AplicaSaldoN
										   ,SaldoInteresesOrdinarios = @AplicaSaldoOrdinariosN
										   ,SaldoInteresesOrdinariosIVA = @AplicaSaldoOrdinariosIVAN
										   ,SaldoInteresesMoratorios = @AplicaSaldoMoratoriosN
										   ,SaldoInteresesMoratoriosIVA = @AplicaSaldoMoratoriosIVAN
										   ,AutoAjuste = NULL
										   ,Estatus = @AplicaEstatusNuevo
										   ,FechaConclusion = NULL
										   ,UltimoCambio = @FechaEmision
										WHERE ID = @IDAplica
									ELSE

									IF @Modulo = 'AGENT'
										UPDATE Agent
										SET Saldo = @AplicaSaldoN
										   ,AutoAjuste = NULL
										   ,Estatus = @AplicaEstatusNuevo
										   ,FechaConclusion = NULL
										   ,UltimoCambio = @FechaEmision
										WHERE ID = @IDAplica

									IF @AplicaPosfechado = 1
										AND ISNULL(@AplicaSaldoN, 0) <> 0
										AND @Accion <> 'CANCELAR'
										SELECT @Ok = 30395

								END

								IF @Accion <> 'CANCELAR'
									SELECT @ContactoImporte = @ContactoImporte - (ISNULL(@AutoAjusteD, 0))

								SELECT @AplicaSaldoFactor = ISNULL(((ISNULL(@AplicaSaldo, 0) - ISNULL(@AplicaSaldoN, 0)) / NULLIF(@AplicaImporteNeto, 0)), 0)

								IF (@Fiscal = 0 OR @FiscalGenerarRetenciones = 1)
									AND (@AplicaRetencionAlPago = 1 OR @CfgRetencionAlPago = 1)
									AND @Modulo = 'CXP'
									AND (@MovTipo NOT IN ('CXP.AJM', 'CXP.AJA', 'CXP.AJR', 'CXP.AJE'))
									AND (@RetencionAlPagoMovImpuesto = 0 OR (@MovTipo <> 'CXP.D' AND @RetencionAlPagoMovImpuesto = 1))
								BEGIN

									IF @AplicaRetencion < 0
										SELECT @AplicaRetencion = @AplicaRetencion * -1
											  ,@CfgRetencionMov = @CfgDevRetencionMov

									IF @AplicaRetencion2 < 0
										SELECT @AplicaRetencion2 = @AplicaRetencion2 * -1
											  ,@CfgRetencionMov = @CfgDevRetencionMov

									IF @AplicaRetencion3 < 0
										SELECT @AplicaRetencion3 = @AplicaRetencion3 * -1
											  ,@CfgRetencionMov = @CfgDevRetencionMov

									IF @AplicaMovTipo = 'CXP.NC'
										SELECT @CfgRetencionMov = @CfgDevRetencionMov

									IF @RetencionAlPagoMovImpuesto = 1
										EXEC spGenerarRetencionMovImpuesto @Sucursal
																		  ,@SucursalOrigen
																		  ,@SucursalDestino
																		  ,@Accion
																		  ,@Empresa
																		  ,@Modulo
																		  ,@ID
																		  ,@movTipo
																		  ,@Mov
																		  ,@MovID
																		  ,@AplicaMoneda
																		  ,@AplicaTipoCambio
																		  ,@FechaEmision
																		  ,@Proyecto
																		  ,@Usuario
																		  ,@FechaRegistro
																		  ,@Ejercicio
																		  ,@Periodo
																		  ,@CfgRetencionMov
																		  ,@CfgRetencionAcreedor
																		  ,@cfgRetencionConcepto
																		  ,@CfgRetencion2Acreedor
																		  ,@cfgRetencion2Concepto
																		  ,@CfgRetencion3Acreedor
																		  ,@cfgRetencion3Concepto
																		  ,@IDAplica
																		  ,@AplicasaldoFactor
																		  ,@RedondeoMonetarios
																		  ,@Ok OUTPUT
																		  ,@okRef OUTPUT
									ELSE
									BEGIN
										EXEC spGastoConcepto @CfgRetencionConcepto
															,@AplicaConcepto
															,@RetencionConcepto OUTPUT
										EXEC spGastoConcepto @CfgRetencion2Concepto
															,@AplicaConcepto
															,@Retencion2Concepto OUTPUT
										EXEC spGastoConcepto @CfgRetencion3Concepto
															,@AplicaConcepto
															,@Retencion3Concepto OUTPUT
										SELECT @AplicaRetencion = ROUND(@AplicaRetencion * @AplicaSaldoFactor, @RedondeoMonetarios)
											  ,@AplicaRetencion2 = ROUND(@AplicaRetencion2 * @AplicaSaldoFactor, @RedondeoMonetarios)
											  ,@AplicaRetencion3 = ROUND(@AplicaRetencion3 * @AplicaSaldoFactor, @RedondeoMonetarios)

										IF @AplicaRetencion <> 0.0
										BEGIN

											IF @CfgRetencionAcreedor IS NULL
												SELECT @Ok = 70100
											ELSE
												EXEC spGenerarCx @Sucursal
																,@SucursalOrigen
																,@SucursalDestino
																,@Accion
																,NULL
																,@Empresa
																,@Modulo
																,@ID
																,@Mov
																,@MovID
																,@MovTipo
																,@AplicaMoneda
																,@AplicaTipoCambio
																,@FechaEmision
																,@RetencionConcepto
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
																,@CfgRetencionAcreedor
																,NULL
																,NULL
																,NULL
																,NULL
																,NULL
																,@AplicaRetencion
																,NULL
																,NULL
																,NULL
																,NULL
																,NULL
																,NULL
																,NULL
																,NULL
																,@CfgRetencionMov
																,@CxModulo OUTPUT
																,@CxMov OUTPUT
																,@CxMovID OUTPUT
																,@Ok OUTPUT
																,@OkRef OUTPUT
																,@INSTRUCCIONES_ESP = 'RETENCION'

										END

										IF @AplicaRetencion2 <> 0.0
										BEGIN

											IF @CfgRetencion2Acreedor IS NULL
												SELECT @Ok = 70100
											ELSE
												EXEC spGenerarCx @Sucursal
																,@SucursalOrigen
																,@SucursalDestino
																,@Accion
																,NULL
																,@Empresa
																,@Modulo
																,@ID
																,@Mov
																,@MovID
																,@MovTipo
																,@AplicaMoneda
																,@AplicaTipoCambio
																,@FechaEmision
																,@Retencion2Concepto
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
																,@CfgRetencion2Acreedor
																,NULL
																,NULL
																,NULL
																,NULL
																,NULL
																,@AplicaRetencion2
																,NULL
																,NULL
																,NULL
																,NULL
																,NULL
																,NULL
																,NULL
																,NULL
																,@CfgRetencionMov
																,@CxModulo OUTPUT
																,@CxMov OUTPUT
																,@CxMovID OUTPUT
																,@Ok OUTPUT
																,@OkRef OUTPUT
																,@INSTRUCCIONES_ESP = 'RETENCION'

										END

										IF @AplicaRetencion3 <> 0.0
										BEGIN

											IF @CfgRetencion3Acreedor IS NULL
												SELECT @Ok = 70100
											ELSE
												EXEC spGenerarCx @Sucursal
																,@SucursalOrigen
																,@SucursalDestino
																,@Accion
																,NULL
																,@Empresa
																,@Modulo
																,@ID
																,@Mov
																,@MovID
																,@MovTipo
																,@AplicaMoneda
																,@AplicaTipoCambio
																,@FechaEmision
																,@Retencion3Concepto
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
																,@CfgRetencion3Acreedor
																,NULL
																,NULL
																,NULL
																,NULL
																,NULL
																,@AplicaRetencion3
																,NULL
																,NULL
																,NULL
																,NULL
																,NULL
																,NULL
																,NULL
																,NULL
																,@CfgRetencionMov
																,@CxModulo OUTPUT
																,@CxMov OUTPUT
																,@CxMovID OUTPUT
																,@Ok OUTPUT
																,@OkRef OUTPUT
																,@INSTRUCCIONES_ESP = 'RETENCION'

										END

									END

								END

								IF @Ok IS NULL
									OR @Ok BETWEEN 80030 AND 81000
									EXEC spMovFinal @Empresa
												   ,@Sucursal
												   ,@Modulo
												   ,@IDAplica
												   ,@AplicaEstatus
												   ,@AplicaEstatusNuevo
												   ,@Usuario
												   ,@FechaEmision
												   ,@FechaRegistro
												   ,@AplicaMov
												   ,@AplicaMovID
												   ,@AplicaMovTipo
												   ,@IDGenerar
												   ,@Ok OUTPUT
												   ,@OkRef OUTPUT

								IF @Modulo = 'CXC'
									AND @AplicaMovTipo IN ('CXC.F', 'CXC.CA', 'CXC.CAD', 'CXC.NC', 'CXC.NCD')
									AND @CfgVentaComisionesCobradas = 1
									AND (ISNULL(@AplicaSaldo, 0.0) > 0.0 OR @Accion = 'CANCELAR')
									AND @Ok IS NULL
								BEGIN
									SELECT @ImporteComision = 0.0

									IF @Accion = 'CANCELAR'
										SELECT @ImporteComision = ISNULL(Comision, 0.0)
										FROM CxcD
										WHERE ID = @ID
										AND Renglon = @Renglon
										AND RenglonSub = @RenglonSub
									ELSE
									BEGIN
										SELECT @AplicaComisionPendienteN = (ISNULL(@AplicaSaldoN, 0.0) * @AplicaComisionPendiente) / @AplicaSaldo
										SELECT @ImporteComision = @AplicaComisionPendiente - @AplicaComisionPendienteN
										EXEC xpComisionCobro @ID
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
															,@AplicaAgente
															,@Conexion
															,@SincroFinal
															,@Sucursal
															,@IDAplica
															,@AplicaMov
															,@AplicaMovID
															,@AplicaMovTipo
															,@AplicaFechaEmision
															,@AplicaVencimiento
															,@AplicaImporteTotal
															,@AplicaSaldo
															,@AplicaComisionTotal
															,@AplicaComisionPendiente
															,@ImporteAplicar
															,@ImporteComision OUTPUT
															,@Ok OUTPUT
															,@OkRef OUTPUT
									END

									IF ISNULL(@ImporteComision, 0.0) <> 0.0
										AND @Ok IS NULL
									BEGIN

										IF @Accion = 'CANCELAR'
											SELECT @AplicaComisionPendienteN = @AplicaComisionPendiente + @ImporteComision
										ELSE
										BEGIN
											UPDATE CxcD
											SET Comision = @ImporteComision
											WHERE CURRENT OF crCxDetalle
											SELECT @AplicaComisionPendienteN = @AplicaComisionPendiente - @ImporteComision

											IF @AplicaComisionPendienteN <= 0.0
												SELECT @AplicaComisionPendiente = NULL

										END

										UPDATE Cxc
										SET ComisionPendiente = NULLIF(@AplicaComisionPendienteN, 0.0)
										WHERE ID = @IDAplica

										IF @CfgComisionBase = 'VENTA'
											AND (@MovTipo NOT IN ('CXC.ANC', 'CXC.NC', 'CXC.NCD') OR @CfgComisionCreditos = 1 OR @MovAplicaMovTipo IN ('CXC.A', 'CXC.AR'))
										BEGIN

											IF @Accion = 'CANCELAR'
												UPDATE Cxc
												SET ComisionGenerada = ISNULL(ComisionGenerada, 0.0) - @ImporteComision
												WHERE ID = @IDAplica
											ELSE
												UPDATE Cxc
												SET ComisionGenerada = ISNULL(ComisionGenerada, 0.0) + @ImporteComision
												WHERE ID = @IDAplica

											EXEC spCxGenerarComision @Sucursal
																	,@SucursalOrigen
																	,@SucursalDestino
																	,@Accion
																	,@Empresa
																	,@Modulo
																	,@IDAplica
																	,@AplicaMov
																	,@AplicaMovID
																	,@AplicaMovTipo
																	,@AplicaMoneda
																	,@AplicaTipoCambio
																	,@FechaAfectacion
																	,@Proyecto
																	,@Usuario
																	,@FechaRegistro
																	,@Ejercicio
																	,@Periodo
																	,@ContactoAfectar
																	,@AplicaAgente
																	,@AplicaImporte
																	,@ImporteComision
																	,@CxModulo
																	,@CxMov
																	,@CxMovID
																	,@RedondeoMonetarios
																	,@Ok OUTPUT
																	,@OkRef OUTPUT
										END

									END

								END

							END
							ELSE
							BEGIN

								IF @Accion = 'CANCELAR'
									AND @LigadoDR = 0
								BEGIN

									IF ROUND(@AplicaSaldo, 2) = ROUND(@AplicaImporteTotal, 2)
									BEGIN
										EXEC spValidarTareas @Empresa
															,@Modulo
															,@IDAplica
															,'CANCELADO'
															,@Ok OUTPUT
															,@OkRef OUTPUT

										IF @Modulo = 'CXC'
											UPDATE Cxc
											SET Saldo = NULL
											   ,Estatus = 'CANCELADO'
											   ,FechaCancelacion = @FechaAfectacion
											   ,UltimoCambio = @FechaEmision
											WHERE ID = @IDAplica
										ELSE

										IF @Modulo = 'CXP'
											UPDATE Cxp
											SET Saldo = NULL
											   ,Estatus = 'CANCELADO'
											   ,FechaCancelacion = @FechaAfectacion
											   ,UltimoCambio = @FechaEmision
											WHERE ID = @IDAplica
										ELSE

										IF @Modulo = 'AGENT'
											UPDATE Agent
											SET Saldo = NULL
											   ,Estatus = 'CANCELADO'
											   ,FechaCancelacion = @FechaAfectacion
											   ,UltimoCambio = @FechaEmision
											WHERE ID = @IDAplica

									END
									ELSE
										SELECT @Ok = 60060
											  ,@OkRef = RTRIM(@AplicaMov) + ' ' + LTRIM(CONVERT(CHAR, @AplicaMovID))

								END

							END

							IF (@Ligado = 0 OR @Accion = 'CANCELAR')
								AND (@LigadoDR = 0 OR @AplicaMovTipo IN ('CXC.CA', 'CXC.CAD', 'CXP.CA', 'CXP.CAD'))
								AND @EsReferencia = 0
							BEGIN

								IF @Accion <> 'CANCELAR'
									SELECT @EsCargo = 0
								ELSE
									SELECT @EsCargo = 1

								IF @MovTipo IN ('CXC.CA', 'CXC.CAD', 'CXC.CAP', 'CXC.DC', 'CXC.DA', 'CXC.ACA',
									'CXP.CA', 'CXP.CAD', 'CXP.CAP', 'CXP.DC', 'CXP.DA', 'CXP.ACA', 'AGENT.CO')
									SELECT @EsCargo = ~@EsCargo

								EXEC spSaldo @Sucursal
											,@Accion
											,@Empresa
											,@Usuario
											,@Modulo
											,@ContactoMoneda
											,@ContactoTipoCambio
											,@ContactoAfectar
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
											,@AplicaMov
											,@AplicaMovID
											,0
											,0
											,0
											,@Ok OUTPUT
											,@OkRef OUTPUT
								SET @RamaInteresOrdinario =
								CASE
									WHEN @Modulo = 'CXC' THEN 'CIO'
									ELSE 'PIO'
								END
								SET @RamaInteresMoratorio =
								CASE
									WHEN @Modulo = 'CXC' THEN 'CIM'
									ELSE 'PIM'
								END
								EXEC spSaldo @Sucursal
											,@Accion
											,@Empresa
											,@Usuario
											,@RamaInteresOrdinario
											,@ContactoMoneda
											,@ContactoTipoCambio
											,@ContactoAfectar
											,NULL
											,NULL
											,NULL
											,@Modulo
											,@ID
											,@Mov
											,@MovID
											,@EsCargo
											,@ContactoOrdinarios
											,NULL
											,NULL
											,@FechaAfectacion
											,@Ejercicio
											,@Periodo
											,@AplicaMov
											,@AplicaMovID
											,0
											,0
											,0
											,@Ok OUTPUT
											,@OkRef OUTPUT
								EXEC spSaldo @Sucursal
											,@Accion
											,@Empresa
											,@Usuario
											,@RamaInteresMoratorio
											,@ContactoMoneda
											,@ContactoTipoCambio
											,@ContactoAfectar
											,NULL
											,NULL
											,NULL
											,@Modulo
											,@ID
											,@Mov
											,@MovID
											,@EsCargo
											,@ContactoMoratorios
											,NULL
											,NULL
											,@FechaAfectacion
											,@Ejercicio
											,@Periodo
											,@AplicaMov
											,@AplicaMovID
											,0
											,0
											,0
											,@Ok OUTPUT
											,@OkRef OUTPUT
								EXEC spSaldo @Sucursal
											,@Accion
											,@Empresa
											,@Usuario
											,@RamaInteresOrdinario
											,@ContactoMoneda
											,@ContactoTipoCambio
											,@ContactoAfectar
											,NULL
											,NULL
											,NULL
											,@Modulo
											,@ID
											,@Mov
											,@MovID
											,@EsCargo
											,@ContactoOrdinariosIVA
											,NULL
											,NULL
											,@FechaAfectacion
											,@Ejercicio
											,@Periodo
											,@AplicaMov
											,@AplicaMovID
											,0
											,0
											,0
											,@Ok OUTPUT
											,@OkRef OUTPUT
								EXEC spSaldo @Sucursal
											,@Accion
											,@Empresa
											,@Usuario
											,@RamaInteresMoratorio
											,@ContactoMoneda
											,@ContactoTipoCambio
											,@ContactoAfectar
											,NULL
											,NULL
											,NULL
											,@Modulo
											,@ID
											,@Mov
											,@MovID
											,@EsCargo
											,@ContactoMoratoriosIVA
											,NULL
											,NULL
											,@FechaAfectacion
											,@Ejercicio
											,@Periodo
											,@AplicaMov
											,@AplicaMovID
											,0
											,0
											,0
											,@Ok OUTPUT
											,@OkRef OUTPUT
							END

						END

						EXEC spMovFlujo @Sucursal
									   ,@Accion
									   ,@Empresa
									   ,@Modulo
									   ,@IDAplica
									   ,@AplicaMov
									   ,@AplicaMovID
									   ,@Modulo
									   ,@ID
									   ,@Mov
									   ,@MovID
									   ,@Ok OUTPUT
					END

				END

				IF @Accion <> 'CANCELAR'
					AND @EsReferencia = 0
				BEGIN

					IF (@VerificarAplica = 1)
						AND @AplicaMovTipo IN ('CXC.A', 'CXC.AR', 'CXC.DA', 'CXC.NC', 'CXC.NCD', 'CXC.NCF', 'CXC.DV', 'CXC.NCP', 'CXP.A', 'CXP.DA', 'CXP.NC', 'CXP.NCD', 'CXP.NCF', 'CXP.NCP', 'CXC.DAC', 'CXP.DAC')
						AND @MovTipo NOT IN ('CXC.DA', 'CXC.DC', 'CXP.DA', 'CXP.DC', 'CXC.RE', 'CXP.RE')
					BEGIN

						IF @ImporteAplicar > 0.0
							SELECT @Ok = 30100

					END
					ELSE
					BEGIN

						IF @ImporteAplicar < 0.0
							AND @Ligado = 0
							AND @AplicaMovTipo NOT IN ('CXC.A', 'CXC.AR', 'CXC.DA', 'CXC.NC', 'CXC.NCD', 'CXC.NCF', 'CXC.DV', 'CXC.NCP', 'CXP.A', 'CXP.DA', 'CXP.NC', 'CXP.NCD', 'CXP.NCF', 'CXP.NCP', 'CXC.RE', 'CXP.RE', 'CXC.DAC', 'CXP.DAC')
							AND @MovTipo NOT IN ('AGENT.P', 'AGENT.CO', 'CXC.AJA', 'CXP.AJA')
							SELECT @Ok = 30100

					END

				END

				IF @Ok IS NOT NULL
					AND @OkRef IS NULL
					SELECT @OkRef = RTRIM(@AplicaMov) + ' ' + LTRIM(CONVERT(CHAR, @AplicaMovID))

			END

			SELECT @ImporteAplicado = @ImporteAplicado + (((@ImporteAplicar + @OrdinariosNetos + @MoratoriosNetos + @OtrosCargos) * (1 + (@ImpuestoAdicional / 100.0))) + ISNULL(@OrdinariosIVANetos, 0.0) + ISNULL(@MoratoriosIVANetos, 0.0))

			IF @DescuentoRecargos > 0.0
				SELECT @ImporteAplicado = @ImporteAplicado + @DescuentoRecargos

			SELECT @SumaImporteNeto = @SumaImporteNeto + @ImporteNeto
		END

		IF @Accion = 'CANCELAR'
			AND @LigadoDR = 1
		BEGIN

			IF @Modulo = 'CXC'
				SELECT @DRID = ID
				FROM Cxc
				WHERE Empresa = @Empresa
				AND Mov = @AplicaMov
				AND MovID = @AplicaMovID
				AND Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'CANCELADO')
			ELSE

			IF @Modulo = 'CXP'
				SELECT @DRID = ID
				FROM Cxp
				WHERE Empresa = @Empresa
				AND Mov = @AplicaMov
				AND MovID = @AplicaMovID
				AND Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'CANCELADO')

			EXEC spCx @DRID
					 ,@Modulo
					 ,@Accion
					 ,'TODO'
					 ,@FechaEmision
					 ,NULL
					 ,@Usuario
					 ,1
					 ,0
					 ,@DRMov OUTPUT
					 ,@DRMovID OUTPUT
					 ,@IDGenerar OUTPUT
					 ,@Ok OUTPUT
					 ,@OkRef OUTPUT
		END

		FETCH NEXT FROM crCxDetalle INTO @Renglon, @RenglonSub, @AplicaMov, @AplicaMovID, @ImporteAplicar, @OrdinariosAplicar, @OrdinariosNetos, @MoratoriosAplicar, @MoratoriosNetos, @ImpuestoAdicional, @OtrosCargos, @AplicaFecha, @AplicaFechaAnterior, @DescuentoRecargos, @Ligado, @LigadoDR, @EsReferencia, @OrdinariosIVAAplicar, @OrdinariosIVANetos, @MoratoriosIVAAplicar, @MoratoriosIVANetos

		IF @@ERROR <> 0
			SELECT @Ok = 1

		END
		CLOSE crCxDetalle
		DEALLOCATE crCxDetalle
	END

	IF @VerificarAplica = 0
		AND @Peru = 1
		AND @MovTipo IN ('CXP.P', 'CXP.ANC', 'CXP.NET')
		AND (ISNULL(@Retencion, 0.0) + ISNULL(@Retencion2, 0.0) + ISNULL(@Retencion3, 0.0)) <> 0.0
		AND @Ok IS NULL
	BEGIN
		EXEC spGastoConcepto @CfgRetencionConcepto
							,@Concepto
							,@RetencionConcepto OUTPUT
		EXEC spGastoConcepto @CfgRetencion2Concepto
							,@Concepto
							,@Retencion2Concepto OUTPUT
		EXEC spGastoConcepto @CfgRetencion3Concepto
							,@Concepto
							,@Retencion3Concepto OUTPUT

		IF @Retencion < 0
			SELECT @Retencion = @Retencion * -1
				  ,@CfgRetencionMov = @CfgDevRetencionMov

		IF @Retencion2 < 0
			SELECT @Retencion2 = @Retencion2 * -1
				  ,@CfgRetencionMov = @CfgDevRetencionMov

		IF @Retencion3 < 0
			SELECT @Retencion3 = @Retencion3 * -1
				  ,@CfgRetencionMov = @CfgDevRetencionMov

		IF ISNULL(@Retencion, 0.0) <> 0.0
		BEGIN

			IF @CfgRetencionAcreedor IS NULL
				SELECT @Ok = 70100
			ELSE
				EXEC spGenerarCx @Sucursal
								,@SucursalOrigen
								,@SucursalDestino
								,@Accion
								,NULL
								,@Empresa
								,@Modulo
								,@ID
								,@Mov
								,@MovID
								,@MovTipo
								,@MovMoneda
								,@MovTipoCambio
								,@FechaEmision
								,@RetencionConcepto
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
								,@CfgRetencionAcreedor
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,@Retencion
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,@CfgRetencionMov
								,@CxModulo OUTPUT
								,@CxMov OUTPUT
								,@CxMovID OUTPUT
								,@Ok OUTPUT
								,@OkRef OUTPUT
								,@INSTRUCCIONES_ESP = 'RETENCION'

		END

		IF ISNULL(@Retencion2, 0.0) <> 0.0
		BEGIN

			IF @CfgRetencion2Acreedor IS NULL
				SELECT @Ok = 70100
			ELSE
				EXEC spGenerarCx @Sucursal
								,@SucursalOrigen
								,@SucursalDestino
								,@Accion
								,NULL
								,@Empresa
								,@Modulo
								,@ID
								,@Mov
								,@MovID
								,@MovTipo
								,@MovMoneda
								,@MovTipoCambio
								,@FechaEmision
								,@Retencion2Concepto
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
								,@CfgRetencion2Acreedor
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,@Retencion2
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,@CfgRetencionMov
								,@CxModulo OUTPUT
								,@CxMov OUTPUT
								,@CxMovID OUTPUT
								,@Ok OUTPUT
								,@OkRef OUTPUT
								,@INSTRUCCIONES_ESP = 'RETENCION'

		END

		IF ISNULL(@Retencion3, 0.0) <> 0.0
		BEGIN

			IF @CfgRetencion3Acreedor IS NULL
				SELECT @Ok = 70100
			ELSE
				EXEC spGenerarCx @Sucursal
								,@SucursalOrigen
								,@SucursalDestino
								,@Accion
								,NULL
								,@Empresa
								,@Modulo
								,@ID
								,@Mov
								,@MovID
								,@MovTipo
								,@MovMoneda
								,@MovTipoCambio
								,@FechaEmision
								,@Retencion3Concepto
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
								,@CfgRetencion3Acreedor
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,@Retencion3
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,@CfgRetencionMov
								,@CxModulo OUTPUT
								,@CxMov OUTPUT
								,@CxMovID OUTPUT
								,@Ok OUTPUT
								,@OkRef OUTPUT
								,@INSTRUCCIONES_ESP = 'RETENCION'

		END

	END

	IF @Modulo IN ('CXC', 'CXP')
		AND @Accion <> 'CANCELAR'
		AND @Ok IS NULL
	BEGIN

		IF @Modulo = 'CXC'
			SELECT @Renglon = ISNULL(MAX(Renglon), 0.0) + 2048
			FROM CxcD
			WHERE ID = @ID
		ELSE

		IF @Modulo = 'CXP'
			SELECT @Renglon = ISNULL(MAX(Renglon), 0.0) + 2048
			FROM CxpD
			WHERE ID = @ID

		IF @MovTipo IN ('CXC.IM', 'CXC.RM', 'CXC.DA', 'CXC.DC', 'CXP.DA', 'CXP.DC')
		BEGIN

			IF dbo.fnImporteSimilar(@ImporteAplicado, @ImporteTotal) = 0
				SELECT @Ok = 30230

		END
		ELSE
		BEGIN
			SELECT @Saldo = ISNULL(@ImporteTotal - @ImporteAplicado, 0.0)

			IF @MovTipo IN ('CXC.AJA', 'CXP.AJA')
				AND @Saldo <> 0.0
				SELECT @Ok = 35340
					  ,@OkRef = CONVERT(VARCHAR, @Saldo)

			IF @Peru = 1
				AND @MovTipo IN ('CXP.P', 'CXP.ANC', 'CXP.NET')
				SELECT @Saldo = @Saldo + ISNULL(@Retencion, 0.0) + ISNULL(@Retencion2, 0.0) + ISNULL(@Retencion3, 0.0)

			IF @Saldo <> 0.0
				OR @TieneDescuentoRecargos = 1
				AND @Ok IS NULL
			BEGIN

				IF @VerificarAplica = 0
				BEGIN
					SELECT @ContactoImporte = @Saldo / @ContactoFactor

					IF @TieneDescuentoRecargos = 1
					BEGIN
						SELECT @MovDescuento =
							   CASE @Modulo
								   WHEN 'CXC' THEN CxcNCreditoProntoPago
								   WHEN 'CXP' THEN CxpProntoPago
							   END
							  ,@MovRecargos =
							   CASE @Modulo
								   WHEN 'CXC' THEN CxcNCargoRecargos
								   WHEN 'CXP' THEN CxpRecargos
							   END
						FROM EmpresaCfgMov
						WHERE Empresa = @Empresa
						SELECT @ConceptoDescuento =
							   CASE @Modulo
								   WHEN 'CXC' THEN CxcProntoPagoConcepto
								   WHEN 'CXP' THEN CxpProntoPagoConcepto
							   END
							  ,@ConceptoRecargos =
							   CASE @Modulo
								   WHEN 'CXC' THEN CxcRecargosConcepto
								   WHEN 'CXP' THEN CxpRecargosConcepto
							   END
						FROM EmpresaCfg
						WHERE Empresa = @Empresa
						SELECT @IVA = DefImpuesto
						FROM EmpresaGral
						WHERE Empresa = @Empresa
						SELECT @DREsCredito = 1
							  ,@DRMov = @MovDescuento
							  ,@DRConcepto = @ConceptoDescuento
							  ,@DRID = NULL
							  ,@DRRenglon = 0.0
							  ,@DRImporte = 0.0
							  ,@DRImpuestos = 0.0
							  ,@DRImporteTotal = 0.0

						IF @Modulo = 'CXC'
							DECLARE
								crDescuentoRecargos
								CURSOR LOCAL FOR
								SELECT Aplica
									  ,AplicaID
									  ,ISNULL(-DescuentoRecargos, 0.0) / @ContactoFactor
								FROM CxcD
								WHERE ID = @ID
								AND ISNULL(DescuentoRecargos, 0.0) < 0.0
						ELSE

						IF @Modulo = 'CXP'
							DECLARE
								crDescuentoRecargos
								CURSOR LOCAL FOR
								SELECT Aplica
									  ,AplicaID
									  ,ISNULL(-DescuentoRecargos, 0.0) / @ContactoFactor
								FROM CxpD
								WHERE ID = @ID
								AND ISNULL(DescuentoRecargos, 0.0) < 0.0

						OPEN crDescuentoRecargos
						FETCH NEXT FROM crDescuentoRecargos INTO @DRAplica, @DRAplicaID, @DescuentoRecargos
						WHILE @@FETCH_STATUS <> -1
						AND @Ok IS NULL
						BEGIN

						IF @@FETCH_STATUS <> -2
						BEGIN

							IF @DRID IS NULL
							BEGIN

								IF @Modulo = 'CXC'
									INSERT Cxc (Sucursal, Empresa, Mov, FechaEmision, Proyecto, Moneda, TipoCambio, Usuario, Referencia, Estatus, Concepto,
									Cliente, ClienteEnviarA, ClienteMoneda, ClienteTipoCambio, AplicaManual, OrigenTipo, Origen, OrigenID)
										VALUES (@Sucursal, @Empresa, @DRMov, @FechaEmision, @Proyecto, @ContactoMoneda, @ContactoTipoCambio, @Usuario, @Referencia, 'SINAFECTAR', @DRConcepto, @Contacto, @ContactoEnviarA, @ContactoMoneda, @ContactoTipoCambio, @DREsCredito, 'PP/RECARGO', @Mov, @MovID)

								IF @Modulo = 'CXP'
									INSERT Cxp (Sucursal, Empresa, Mov, FechaEmision, Proyecto, Moneda, TipoCambio, Usuario, Referencia, Estatus, Concepto,
									Proveedor, ProveedorMoneda, ProveedorTipoCambio, AplicaManual, OrigenTipo, Origen, OrigenID)
										VALUES (@Sucursal, @Empresa, @DRMov, @FechaEmision, @Proyecto, @ContactoMoneda, @ContactoTipoCambio, @Usuario, @Referencia, 'SINAFECTAR', @DRConcepto, @Contacto, @ContactoMoneda, @ContactoTipoCambio, @DREsCredito, 'PP/RECARGO', @Mov, @MovID)

								SELECT @DRID = SCOPE_IDENTITY()
							END

							SELECT @DRRenglon = @DRRenglon + 2048.0

							IF @Modulo = 'CXC'
								INSERT INTO CxcD (Sucursal, ID, Renglon, RenglonSub, Aplica, AplicaID, Importe)
									VALUES (@Sucursal, @DRID, @DRRenglon, 0, @DRAplica, @DRAplicaID, @DescuentoRecargos)

							IF @Modulo = 'CXP'
								INSERT INTO CxpD (Sucursal, ID, Renglon, RenglonSub, Aplica, AplicaID, Importe)
									VALUES (@Sucursal, @DRID, @DRRenglon, 0, @DRAplica, @DRAplicaID, @DescuentoRecargos)

							SELECT @DRImporteTotal = @DRImporteTotal + @DescuentoRecargos
						END

						FETCH NEXT FROM crDescuentoRecargos INTO @DRAplica, @DRAplicaID, @DescuentoRecargos
						END
						CLOSE crDescuentoRecargos
						DEALLOCATE crDescuentoRecargos

						IF @DRID IS NOT NULL
						BEGIN
							SELECT @DRImpuestos = @DRImpuestos + ((@DRImporteTotal / (1 + (@IVA / 100.0))) * (@IVA / 100.0))
							SELECT @DRImporte = @DRImporteTotal - @DRImpuestos

							IF @Modulo = 'CXC'
								UPDATE Cxc
								SET Importe = @DRImporte
								   ,Impuestos = @DRImpuestos
								WHERE ID = @DRID
							ELSE

							IF @Modulo = 'CXP'
								UPDATE Cxp
								SET Importe = @DRImporte
								   ,Impuestos = @DRImpuestos
								WHERE ID = @DRID

							EXEC spMovCopiarAnexos @Sucursal
												  ,@Modulo
												  ,@ID
												  ,@Modulo
												  ,@DRID
							EXEC spCx @DRID
									 ,@Modulo
									 ,'AFECTAR'
									 ,'TODO'
									 ,@FechaEmision
									 ,NULL
									 ,@Usuario
									 ,1
									 ,0
									 ,@DRMov OUTPUT
									 ,@DRMovID OUTPUT
									 ,@IDGenerar OUTPUT
									 ,@Ok OUTPUT
									 ,@OkRef OUTPUT
							SELECT @Renglon = @Renglon + 2048.0

							IF @Modulo = 'CXC'
								INSERT INTO CxcD (Sucursal, ID, Renglon, RenglonSub, Aplica, AplicaID, Importe, Ligado, LigadoDR)
									VALUES (@Sucursal, @ID, @Renglon, 0, @DRMov, @DRMovID, -@DRImporteTotal * @ContactoFactor, @DREsCredito, 1)

							IF @Modulo = 'CXP'
								INSERT INTO CxpD (Sucursal, ID, Renglon, RenglonSub, Aplica, AplicaID, Importe, Ligado, LigadoDR)
									VALUES (@Sucursal, @ID, @Renglon, 0, @DRMov, @DRMovID, -@DRImporteTotal * @ContactoFactor, @DREsCredito, 1)

							EXEC spMovFlujo @Sucursal
										   ,@Accion
										   ,@Empresa
										   ,@Modulo
										   ,@DRID
										   ,@DRMov
										   ,@DRMovID
										   ,@Modulo
										   ,@ID
										   ,@Mov
										   ,@MovID
										   ,@Ok OUTPUT
						END

						SELECT @DREsCredito = 0
							  ,@DRMov = @MovRecargos
							  ,@DRConcepto = @ConceptoRecargos
							  ,@DRID = NULL
							  ,@DRRenglon = 0.0
							  ,@DRImporte = 0.0
							  ,@DRImpuestos = 0.0
							  ,@DRImporteTotal = 0.0

						IF @Modulo = 'CXC'
							DECLARE
								crDescuentoRecargos
								CURSOR LOCAL FOR
								SELECT Aplica
									  ,AplicaID
									  ,ISNULL(DescuentoRecargos, 0.0) / @ContactoFactor
								FROM CxcD
								WHERE ID = @ID
								AND ISNULL(DescuentoRecargos, 0.0) > 0.0
						ELSE

						IF @Modulo = 'CXP'
							DECLARE
								crDescuentoRecargos
								CURSOR LOCAL FOR
								SELECT Aplica
									  ,AplicaID
									  ,ISNULL(DescuentoRecargos, 0.0) / @ContactoFactor
								FROM CxpD
								WHERE ID = @ID
								AND ISNULL(DescuentoRecargos, 0.0) > 0.0

						OPEN crDescuentoRecargos
						FETCH NEXT FROM crDescuentoRecargos INTO @DRAplica, @DRAplicaID, @DescuentoRecargos
						WHILE @@FETCH_STATUS <> -1
						AND @Ok IS NULL
						BEGIN

						IF @@FETCH_STATUS <> -2
						BEGIN

							IF @DRID IS NULL
							BEGIN

								IF @Modulo = 'CXC'
									INSERT Cxc (Sucursal, Empresa, Mov, FechaEmision, Proyecto, Moneda, TipoCambio, Usuario, Referencia, Estatus, Concepto,
									Cliente, ClienteEnviarA, ClienteMoneda, ClienteTipoCambio, AplicaManual, OrigenTipo, Origen, OrigenID)
										VALUES (@Sucursal, @Empresa, @DRMov, @FechaEmision, @Proyecto, @ContactoMoneda, @ContactoTipoCambio, @Usuario, @Referencia, 'SINAFECTAR', @DRConcepto, @Contacto, @ContactoEnviarA, @ContactoMoneda, @ContactoTipoCambio, @DREsCredito, 'PP/RECARGO', @Mov, @MovID)

								IF @Modulo = 'CXP'
									INSERT Cxp (Sucursal, Empresa, Mov, FechaEmision, Proyecto, Moneda, TipoCambio, Usuario, Referencia, Estatus, Concepto,
									Proveedor, ProveedorMoneda, ProveedorTipoCambio, AplicaManual, OrigenTipo, Origen, OrigenID)
										VALUES (@Sucursal, @Empresa, @DRMov, @FechaEmision, @Proyecto, @ContactoMoneda, @ContactoTipoCambio, @Usuario, @Referencia, 'SINAFECTAR', @DRConcepto, @Contacto, @ContactoMoneda, @ContactoTipoCambio, @DREsCredito, 'PP/RECARGO', @Mov, @MovID)

								SELECT @DRID = SCOPE_IDENTITY()
							END

							SELECT @DRRenglon = @DRRenglon + 2048.0
							SELECT @DRImporteTotal = @DRImporteTotal + @DescuentoRecargos
						END

						FETCH NEXT FROM crDescuentoRecargos INTO @DRAplica, @DRAplicaID, @DescuentoRecargos
						END
						CLOSE crDescuentoRecargos
						DEALLOCATE crDescuentoRecargos

						IF @DRID IS NOT NULL
						BEGIN
							SELECT @DRImpuestos = @DRImpuestos + ((@DRImporteTotal / (1 + (@IVA / 100.0))) * (@IVA / 100.0))
							SELECT @DRImporte = @DRImporteTotal - @DRImpuestos

							IF @Modulo = 'CXC'
								UPDATE Cxc
								SET Importe = @DRImporte
								   ,Impuestos = @DRImpuestos
								WHERE ID = @DRID
							ELSE

							IF @Modulo = 'CXP'
								UPDATE Cxp
								SET Importe = @DRImporte
								   ,Impuestos = @DRImpuestos
								WHERE ID = @DRID

							EXEC spMovCopiarAnexos @Sucursal
												  ,@Modulo
												  ,@ID
												  ,@Modulo
												  ,@DRID
							EXEC spCx @DRID
									 ,@Modulo
									 ,'AFECTAR'
									 ,'TODO'
									 ,@FechaEmision
									 ,NULL
									 ,@Usuario
									 ,1
									 ,0
									 ,@DRMov OUTPUT
									 ,@DRMovID OUTPUT
									 ,@IDGenerar OUTPUT
									 ,@Ok OUTPUT
									 ,@OkRef OUTPUT
							EXEC spValidarTareas @Empresa
												,@Modulo
												,@DRID
												,'CONCLUIDO'
												,@Ok OUTPUT
												,@OkRef OUTPUT

							IF @Modulo = 'CXC'
								UPDATE Cxc
								SET Estatus = 'CONCLUIDO'
								   ,FechaConclusion = @FechaEmision
								   ,Saldo = NULL
								   ,UltimoCambio = @FechaEmision
								WHERE ID = @DRID
							ELSE

							IF @Modulo = 'CXP'
								UPDATE Cxp
								SET Estatus = 'CONCLUIDO'
								   ,FechaConclusion = @FechaEmision
								   ,Saldo = NULL
								   ,UltimoCambio = @FechaEmision
								WHERE ID = @DRID

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
										,@DRImporteTotal
										,NULL
										,NULL
										,@FechaAfectacion
										,@Ejercicio
										,@Periodo
										,@DRMov
										,@DRMovID
										,0
										,0
										,0
										,@Ok OUTPUT
										,@OkRef OUTPUT
							SELECT @Renglon = @Renglon + 2048.0

							IF @Modulo = 'CXC'
								INSERT INTO CxcD (Sucursal, ID, Renglon, RenglonSub, Aplica, AplicaID, Importe, Ligado, LigadoDR)
									VALUES (@Sucursal, @ID, @Renglon, 0, @DRMov, @DRMovID, @DRImporteTotal * @ContactoFactor, @DREsCredito, 1)

							IF @Modulo = 'CXP'
								INSERT INTO CxpD (Sucursal, ID, Renglon, RenglonSub, Aplica, AplicaID, Importe, Ligado, LigadoDR)
									VALUES (@Sucursal, @ID, @Renglon, 0, @DRMov, @DRMovID, @DRImporteTotal * @ContactoFactor, @DREsCredito, 1)

							EXEC spMovFlujo @Sucursal
										   ,@Accion
										   ,@Empresa
										   ,@Modulo
										   ,@DRID
										   ,@DRMov
										   ,@DRMovID
										   ,@Modulo
										   ,@ID
										   ,@Mov
										   ,@MovID
										   ,@Ok OUTPUT
						END

					END

					IF ABS(@Saldo) > @AutoAjusteMov
						AND @Ok IS NULL
					BEGIN

						IF @Saldo < 0.0
							SELECT @AplicaDifEnRojo = 1
						ELSE
							SELECT @AplicaDifEnRojo = 0

						IF @Modulo = 'CXC'
							DECLARE
								crAplicaDif
								CURSOR LOCAL FOR
								SELECT NULLIF(RTRIM(Mov), '')
									  ,Concepto
									  ,ISNULL(Importe, 0.0)
									  ,ISNULL(Impuestos, 0.0)
									  ,Referencia
									  ,ClienteEnviarA
								FROM CxcAplicaDif
								WHERE ID = @ID
						ELSE

						IF @Modulo = 'CXP'
							DECLARE
								crAplicaDif
								CURSOR LOCAL FOR
								SELECT NULLIF(RTRIM(Mov), '')
									  ,Concepto
									  ,ISNULL(Importe, 0.0)
									  ,ISNULL(Impuestos, 0.0)
									  ,Referencia
									  ,CONVERT(INT, NULL)
								FROM CxpAplicaDif
								WHERE ID = @ID

						OPEN crAplicaDif
						FETCH NEXT FROM crAplicaDif INTO @AplicaDifMov, @AplicaDifConcepto, @AplicaDifImporte, @AplicaDifImpuestos, @AplicaDifReferencia, @AplicaDifEnviarA
						WHILE @@FETCH_STATUS <> -1
						AND @Ok IS NULL
						BEGIN

						IF @@FETCH_STATUS <> -2
						BEGIN
							SELECT @AplicaDifMovTipo = Clave
							FROM MovTipo
							WHERE Modulo = @Modulo
							AND Mov = @AplicaDifMov

							IF @AplicaDifMov IS NULL
								OR (@AplicaDifEnRojo = 0 AND NOT (UPPER(@AplicaDifMov) = 'SALDO A FAVOR' OR @AplicaDifMovTipo IN ('CXC.NC', 'CXC.NCD', 'CXC.NCF', 'CXP.NC', 'CXP.NCD', 'CXP.NCF')))
								OR (@AplicaDifEnRojo = 1 AND NOT (@AplicaDifMovTipo IN ('CXC.CA', 'CXC.CAD', 'CXP.CA', 'CXP.CAD')))
								SELECT @Ok = 20180

							SELECT @AplicaDifImporteDetalle = @AplicaDifImporte + @AplicaDifImpuestos

							IF @AplicaDifImporteDetalle <= 0.0
								SELECT @Ok = 30100

							IF @AplicaDifEnRojo = 1
								SELECT @AplicaDifImporteDetalle = -@AplicaDifImporteDetalle

							SELECT @AplicaDifImporteCto = @AplicaDifImporte / @ContactoFactor
								  ,@AplicaDifImpuestosCto = @AplicaDifImpuestos / @ContactoFactor
								  ,@AplicaDifImporteDetalleCto = @AplicaDifImporteDetalle / @ContactoFactor

							IF UPPER(@AplicaDifMov) = 'SALDO A FAVOR'
								EXEC spSaldo @Sucursal
											,@Accion
											,@Empresa
											,@Usuario
											,@RamaEfectivo
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
											,0
											,@AplicaDifImporteDetalleCto
											,NULL
											,NULL
											,@FechaAfectacion
											,@Ejercicio
											,@Periodo
											,@AplicaDifMov
											,NULL
											,0
											,0
											,0
											,@Ok OUTPUT
											,@OkRef OUTPUT
							ELSE
							BEGIN

								IF @Modulo = 'CXC'
									INSERT Cxc (Sucursal, Empresa, Mov, FechaEmision, Proyecto, Moneda, TipoCambio, Usuario, Referencia, Estatus, Concepto,
									Cliente, ClienteEnviarA, ClienteMoneda, ClienteTipoCambio, Condicion, Vencimiento, Importe, Impuestos, AplicaManual, OrigenTipo, Origen, OrigenID, Indirecto)
										VALUES (@Sucursal, @Empresa, @AplicaDifMov, @FechaEmision, @Proyecto, @ContactoMoneda, @ContactoTipoCambio, @Usuario, @AplicaDifReferencia, 'SINAFECTAR', @AplicaDifConcepto, @Contacto, @AplicaDifEnviarA, @ContactoMoneda, @ContactoTipoCambio, @Condicion, @Vencimiento, @AplicaDifImporteCto, @AplicaDifImpuestosCto, 0, @Modulo, @Mov, @MovID, 1)

								IF @Modulo = 'CXP'
									INSERT Cxp (Sucursal, Empresa, Mov, FechaEmision, Proyecto, Moneda, TipoCambio, Usuario, Referencia, Estatus, Concepto,
									Proveedor, ProveedorMoneda, ProveedorTipoCambio, Condicion, Vencimiento, Importe, Impuestos, AplicaManual, OrigenTipo, Origen, OrigenID, Indirecto)
										VALUES (@Sucursal, @Empresa, @AplicaDifMov, @FechaEmision, @Proyecto, @ContactoMoneda, @ContactoTipoCambio, @Usuario, @AplicaDifReferencia, 'SINAFECTAR', @AplicaDifConcepto, @Contacto, @ContactoMoneda, @ContactoTipoCambio, @Condicion, @Vencimiento, @AplicaDifImporteCto, @AplicaDifImpuestosCto, 0, @Modulo, @Mov, @MovID, 1)

								SELECT @AplicaDifID = SCOPE_IDENTITY()
								EXEC spMovCopiarAnexos @Sucursal
													  ,@Modulo
													  ,@ID
													  ,@Modulo
													  ,@AplicaDifID
								EXEC spCx @AplicaDifID
										 ,@Modulo
										 ,'AFECTAR'
										 ,'TODO'
										 ,@FechaEmision
										 ,NULL
										 ,@Usuario
										 ,1
										 ,0
										 ,@AplicaDifMov OUTPUT
										 ,@AplicaDifMovID OUTPUT
										 ,@IDGenerar OUTPUT
										 ,@Ok OUTPUT
										 ,@OkRef OUTPUT
							END

							SELECT @Renglon = @Renglon + 2048.0

							IF @Modulo = 'CXC'
								INSERT INTO CxcD (Sucursal, ID, Renglon, RenglonSub, Aplica, AplicaID, Importe, Ligado)
									VALUES (@Sucursal, @ID, @Renglon, 0, @AplicaDifMov, @AplicaDifMovID, @AplicaDifImporteDetalle, 1)

							IF @Modulo = 'CXP'
								INSERT INTO CxpD (Sucursal, ID, Renglon, RenglonSub, Aplica, AplicaID, Importe, Ligado)
									VALUES (@Sucursal, @ID, @Renglon, 0, @AplicaDifMov, @AplicaDifMovID, @AplicaDifImporteDetalle, 1)

							EXEC spMovFlujo @Sucursal
										   ,@Accion
										   ,@Empresa
										   ,@Modulo
										   ,@ID
										   ,@Mov
										   ,@MovID
										   ,@Modulo
										   ,@AplicaDifID
										   ,@AplicaDifMov
										   ,@AplicaDifMovID
										   ,@Ok OUTPUT
							SELECT @Renglon = @Renglon + 2048.0
								  ,@Saldo = ROUND(@Saldo - @AplicaDifImporteDetalle, @RedondeoMonetarios)
						END

						FETCH NEXT FROM crAplicaDif INTO @AplicaDifMov, @AplicaDifConcepto, @AplicaDifImporte, @AplicaDifImpuestos, @AplicaDifReferencia, @AplicaDifEnviarA
						END
						CLOSE crAplicaDif
						DEALLOCATE crAplicaDif
					END

					IF @Saldo <> 0.0
						AND @Ok IS NULL
					BEGIN
						SELECT @SaldoCto = @Saldo / @ContactoFactor

						IF @MovTipo IN ('CXC.AA', 'CXC.AF', 'CXP.AA', 'CXP.AF')
						BEGIN
							SELECT @Renglon = @Renglon + 2048.0

							IF @Modulo = 'CXC'
								INSERT INTO CxcD (Sucursal, ID, Renglon, RenglonSub, Aplica, AplicaID, Importe)
									VALUES (@Sucursal, @ID, @Renglon, 0, 'Saldo a Favor', NULL, @Saldo)
							ELSE

							IF @Modulo = 'CXP'
								INSERT INTO CxpD (Sucursal, ID, Renglon, RenglonSub, Aplica, AplicaID, Importe)
									VALUES (@Sucursal, @ID, @Renglon, 0, 'Saldo a Favor', NULL, @Saldo)

							IF @@ERROR <> 0
								SELECT @Ok = 1

							EXEC spSaldo @Sucursal
										,@Accion
										,@Empresa
										,@Usuario
										,@RamaEfectivo
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
										,0
										,@SaldoCto
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
						END
						ELSE

						IF ABS(@Saldo) <= @AutoAjusteMov
						BEGIN
							SELECT @Renglon = @Renglon + 2048.0

							IF @Modulo = 'CXC'
								INSERT INTO CxcD (Sucursal, ID, Renglon, RenglonSub, Aplica, AplicaID, Importe)
									VALUES (@Sucursal, @ID, @Renglon, 0, 'Redondeo', NULL, @Saldo)
							ELSE

							IF @Modulo = 'CXP'
								INSERT INTO CxpD (Sucursal, ID, Renglon, RenglonSub, Aplica, AplicaID, Importe)
									VALUES (@Sucursal, @ID, @Renglon, 0, 'Redondeo', NULL, @Saldo)

							IF @@ERROR <> 0
								SELECT @Ok = 1

							EXEC spSaldo @Sucursal
										,@Accion
										,@Empresa
										,@Usuario
										,@RamaRedondeo
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
										,0
										,@SaldoCto
										,NULL
										,NULL
										,@FechaAfectacion
										,@Ejercicio
										,@Periodo
										,'Redondeo'
										,NULL
										,0
										,0
										,0
										,@Ok OUTPUT
										,@OkRef OUTPUT
						END
						ELSE
							SELECT @Ok = 30230
								  ,@OkRef = 'Diferencia: ' + LTRIM(CONVERT(CHAR, @Saldo))

					END

				END

			END

		END

	END

	IF @VerificarAplica = 1
		AND @MovTipo = 'CXP.PAG'
		AND @Ok IS NULL
		AND @Vencimiento < @UltimoVencimiento
		SELECT @Condicion = '(Fecha)'
			  ,@Vencimiento = @UltimoVencimiento

	IF @VerificarAplica = 0
		AND @CfgAC = 1
		AND @Ok IS NULL
		AND @MovTipo = 'CXC.C'
		EXEC spCxFacturarIntereses @ID
								  ,@Accion
								  ,@Empresa
								  ,@Usuario
								  ,@Modulo
								  ,@Mov
								  ,@MovID
								  ,@MovTipo
								  ,@MovMoneda
								  ,@MovTipoCambio
								  ,@Sucursal
								  ,@Ok OUTPUT
								  ,@OkRef OUTPUT

	IF @VerificarAplica = 0
	BEGIN
		DELETE MovImpuesto
		WHERE Modulo = @Modulo
			AND ModuloID = @ID

		IF EXISTS (SELECT * FROM #CxAplicaMovImpuesto)
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
					  ,SUM(Importe1)
					  ,SUM(Importe2)
					  ,SUM(Importe3)
					  ,SUM(SubTotal)
					  ,ContUso
					  ,ContUso2
					  ,ContUso3
					  ,ClavePresupuestal
					  ,ClavePresupuestalImpuesto1
					  ,DescuentoGlobal
				FROM #CxAplicaMovImpuesto
				GROUP BY OrigenModulo
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
						,ContUso
						,ContUso2
						,ContUso3
						,ClavePresupuestal
						,ClavePresupuestalImpuesto1
						,DescuentoGlobal
				ORDER BY OrigenModulo, OrigenModuloID, OrigenConcepto, ISNULL(OrigenDeducible, 100), OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal
		END

		IF @PPTO = 1
		BEGIN

			IF EXISTS (SELECT * FROM #CxAplicaMovPresupuesto)
			BEGIN
				INSERT MovPresupuesto (Modulo, ModuloID, CuentaPresupuesto, Importe)
					SELECT @Modulo
						  ,@ID
						  ,CuentaPresupuesto
						  ,SUM(Importe)
					FROM #CxAplicaMovPresupuesto
					GROUP BY CuentaPresupuesto
					ORDER BY CuentaPresupuesto
			END

		END

	END

	RETURN
END

