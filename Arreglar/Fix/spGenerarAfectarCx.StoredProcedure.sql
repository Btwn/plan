SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spGenerarAfectarCx]
 @Sucursal INT
,@SucursalOrigen INT
,@SucursalDestino INT
,@Accion CHAR(20)
,@ModuloAfectar CHAR(5)
,@Empresa CHAR(5)
,@Modulo CHAR(5)
,@ID INT
,@Mov CHAR(20)
,@MovID VARCHAR(20)
,@MovTipo CHAR(20)
,@MovMoneda CHAR(10)
,@MovTipoCambio FLOAT
,@FechaEmision DATETIME
,@Concepto VARCHAR(50)
,@Proyecto VARCHAR(50)
,@Usuario CHAR(10)
,@Autorizacion CHAR(10)
,@Referencia VARCHAR(50)
,@DocFuente INT
,@Observaciones VARCHAR(255)
,@FechaRegistro DATETIME
,@Ejercicio INT
,@Periodo INT
,@Condicion VARCHAR(50)
,@Vencimiento DATETIME
,@Contacto CHAR(10)
,@EnviarA INT
,@Agente CHAR(10)
,@Tipo CHAR(20)
,@CtaDinero CHAR(10)
,@FormaPago VARCHAR(50)
,@Importe MONEY
,@Impuestos MONEY
,@Retencion MONEY
,@ComisionTotal MONEY
,@Beneficiario INT
,@Aplica CHAR(20)
,@AplicaMovID VARCHAR(20)
,@ImporteAplicar MONEY
,@VIN VARCHAR(20)
,@MovEspecifico VARCHAR(20)
,@CxModulo CHAR(5) OUTPUT
,@CxMov CHAR(20) OUTPUT
,@CxMovID VARCHAR(20) OUTPUT
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
,@INSTRUCCIONES_ESP VARCHAR(20) = NULL
,@IVAFiscal FLOAT = NULL
,@IEPSFiscal FLOAT = NULL
,@PersonalCobrador CHAR(10) = NULL
,@Retencion2 MONEY = NULL
,@Retencion3 MONEY = NULL
,@ModuloEspecifico CHAR(5) = NULL
,@EndosarA VARCHAR(10) = NULL
,@Conteo INT = NULL
,@Nota VARCHAR(100) = NULL
,@MovIDEspecifico VARCHAR(20) = NULL
,@ContUso VARCHAR(20) = NULL
,@LineaCredito VARCHAR(20) = NULL
,@LineaCreditoExpress BIT = NULL
,@TipoAmortizacion VARCHAR(20) = NULL
,@TipoTasa VARCHAR(20) = NULL
,@TieneTasaEsp BIT = NULL
,@TasaEsp FLOAT = NULL
,@Comisiones MONEY = NULL
,@ComisionesIVA MONEY = NULL
,@CopiarMovImpuesto BIT = 0
,@NoAutoAplicar BIT = 0
AS
BEGIN
	DECLARE
		@ReferenciaOriginal VARCHAR(50)
	   ,@EndosoID INT
	   ,@CxID INT
	   ,@CxMovTipo VARCHAR(20)
	   ,@CxEsCredito BIT
	   ,@IDGenerar INT
	   ,@Saldo MONEY
	   ,@CfgMovCxcAnticipo CHAR(20)
	   ,@CfgMovCxpAnticipo CHAR(20)
	   ,@CfgMovCxcAjusteSaldo CHAR(20)
	   ,@CfgMovCxpAjusteSaldo CHAR(20)
	   ,@CfgMovFaltanteCaja CHAR(20)
	   ,@CfgMovCxcForwardPorCobrar CHAR(20)
	   ,@CfgMovCxpForwardPorPagar CHAR(20)
	   ,@CfgMovFactura CHAR(20)
	   ,@CfgMovGastoDiverso CHAR(20)
	   ,@CfgMovCobro CHAR(20)
	   ,@CfgMovPago CHAR(20)
	   ,@CfgMovCxpNomina CHAR(20)
	   ,@CfgMovCxpCancelacionNomina CHAR(20)
	   ,@CfgMovCxcNomina CHAR(20)
	   ,@CfgMovCxcCancelacionNomina CHAR(20)
	   ,@CfgMovAvanceCxp CHAR(20)
	   ,@CfgMovRetrocesoCxp CHAR(20)
	   ,@CfgMovEmbarqueCxp CHAR(20)
	   ,@CfgMovCxcVentaVales CHAR(20)
	   ,@CfgMovCxcObsequioVales CHAR(20)
	   ,@CfgMovCxcObsequioTarjetas CHAR(20)
	   ,@CfgMovCxcAplicacionVales CHAR(20)
	   ,@CfgMovCxcAplicacionTarjetas CHAR(20)
	   ,@CfgMovCxcDevolucionVales CHAR(20)
	   ,@CfgMovCxpGastoDev CHAR(20)
	   ,@CfgMovCxpGastoDevProrrateada CHAR(20)
	   ,@CfgMovCxpImportacion CHAR(20)
	   ,@CfgMovCxcEndoso CHAR(20)
	   ,@CfgMovCxpEndoso CHAR(20)
	   ,@CfgMovCxcEndosoAFavor CHAR(20)
	   ,@CfgMovCxpEndosoAFavor CHAR(20)
	   ,@CfgComisionEspecial BIT
	   ,@CfgCompraAutoEndoso BIT
	   ,@CfgCompraAutoEndosoEmpresas BIT
	   ,@CfgCompraAutoEndosoWS BIT
	   ,@CfgCompraAutoEndosoWSDL VARCHAR(255)
	   ,@CfgCompraAutoEndosoMovs BIT
	   ,@CfgCompraAutoEndosoAutoCargos BIT
	   ,@CfgEmbarqueCobrarDemas BIT
	   ,@CfgConsecutivoIndep BIT
	   ,@CfgComisionesCobradas BIT
	   ,@ComisionPendiente MONEY
	   ,@AplicaManual BIT
	   ,@CxcMonedaCont BIT
	   ,@CxpMonedaCont BIT
	   ,@AgentMonedaCont BIT
	   ,@IDOrigen INT
	   ,@OrigenTipo CHAR(20)
	   ,@Origen CHAR(20)
	   ,@OrigenID CHAR(20)
	   ,@OrigenEstatus CHAR(15)
	   ,@OrigenSucursal INT
	   ,@OrigenUEN INT
	   ,@Endoso VARCHAR(10)
	   ,@CxEndosoID INT
	   ,@CxEndosoMov CHAR(20)
	   ,@CxEndosoMovID VARCHAR(20)
	   ,@ContactoOriginal CHAR(10)
	   ,@ProveedorAutoEndoso VARCHAR(10)
	   ,@AutoAplicar BIT
	   ,@SaldoMN MONEY
	   ,@AplicaSaldoMN MONEY
	   ,@GastoCxc BIT
	   ,@AC BIT
	   ,@RetencionAlPago BIT
	   ,@DefImpuesto FLOAT
	   ,@ZonaImpuesto VARCHAR(50)
	   ,@ArrastrarMovID BIT
	   ,@AplicarDemas BIT
	   ,@CxEstatus VARCHAR(15)
	   ,@CfgGenerarEnBorrador BIT
	   ,@ContratoID INT
	   ,@ContratoMov VARCHAR(20)
	   ,@ContratoMovID VARCHAR(20)
	   ,@SubClave VARCHAR(20)
	   ,@GasConceptoMultiple BIT
	   ,@MonedaOrigen CHAR(10)
	   ,@TipoCambioOrigen FLOAT
	   ,@CteMoneda CHAR(10)
	   ,@CteTipoCambio FLOAT
	   ,@OrigenMovTipo CHAR(20)
	SELECT @CxModulo = NULL
		  ,@CxMov = NULL
		  ,@CxMovID = NULL
		  ,@Endoso = NULL
		  ,@ComisionPendiente = NULL
		  ,@CfgConsecutivoIndep = 0
		  ,@CxcMonedaCont = 0
		  ,@CxpMonedaCont = 0
		  ,@AgentMonedaCont = 0
		  ,@OrigenTipo = @Modulo
		  ,@Origen = @Mov
		  ,@OrigenID = @MovID
		  ,@ContactoOriginal = @Contacto
		  ,@ProveedorAutoEndoso = NULL
		  ,@CxEsCredito = 0
		  ,@GastoCxc = 0
		  ,@AC = 0
		  ,@RetencionAlPago = 0
		  ,@ReferenciaOriginal = @Referencia
		  ,@AplicarDemas = 0
		  ,@ContratoID = NULL
		  ,@ContratoMov = NULL
		  ,@ContratoMovID = NULL
		  ,@OrigenMovTipo = NULL
	SELECT @SubClave = SubClave
	FROM MovTipo
	WHERE Mov = @Mov
	AND Modulo = @Modulo
	EXEC xpGenerarAfectarCxOrigenID @Modulo
								   ,@ID
								   ,@OrigenID OUTPUT

	IF @INSTRUCCIONES_ESP = 'SIN_ORIGEN'
		SELECT @OrigenTipo = NULL
			  ,@Origen = NULL
			  ,@OrigenID = NULL

	IF @INSTRUCCIONES_ESP = 'RETENCION'
		SELECT @OrigenTipo = @INSTRUCCIONES_ESP

	SELECT @AC = ISNULL(AC, 0)
	FROM EmpresaGral
	WHERE Empresa = @Empresa
	SELECT @CfgComisionesCobradas = VentaComisionesCobradas
		  ,@CfgComisionEspecial = ISNULL(ComisionEspecial, 0)
		  ,@CfgCompraAutoEndoso = ISNULL(CompraAutoEndoso, 0)
		  ,@CfgCompraAutoEndosoEmpresas = ISNULL(CompraAutoEndosoEmpresas, 0)
		  ,@CfgCompraAutoEndosoWS = ISNULL(CompraAutoEndosoWS, 0)
		  ,@CfgCompraAutoEndosoWSDL = CompraAutoEndosoWSDL
		  ,@CfgCompraAutoEndosoMovs = ISNULL(CompraAutoEndosoMovs, 0)
		  ,@CfgCompraAutoEndosoAutoCargos = ISNULL(CompraAutoEndosoAutoCargos, 0)
		  ,@CfgEmbarqueCobrarDemas = ISNULL(EmbarqueCobrarDemas, 0)
	FROM EmpresaCfg
	WHERE Empresa = @Empresa
	SELECT @CfgConsecutivoIndep =
		   CASE @MovTipo
			   WHEN 'VTAS.D' THEN VentaDevConsecutivoIndep
			   WHEN 'VTAS.DF' THEN VentaDevConsecutivoIndep
			   WHEN 'VTAS.B' THEN VentaBonifConsecutivoIndep
			   WHEN 'COMS.D' THEN CompraDevConsecutivoIndep
			   WHEN 'COMS.B' THEN CompraBonifConsecutivoIndep
			   ELSE 0
		   END
		  ,@AutoAplicar =
		   CASE @MovTipo
			   WHEN 'VTAS.D' THEN VentaDevAutoAplicar
			   WHEN 'VTAS.DF' THEN VentaDevAutoAplicar
			   WHEN 'VTAS.B' THEN VentaDevAutoAplicar
			   WHEN 'COMS.D' THEN CompraDevAutoAplicar
			   WHEN 'COMS.B' THEN CompraDevAutoAplicar
			   ELSE 0
		   END
		  ,@CxcMonedaCont = CxcMonedaCont
		  ,@CxpMonedaCont = CxpMonedaCont
		  ,@AgentMonedaCont = AgentMonedaCont
		  ,@GastoCxc = ISNULL(GastoCxc, 0)
		  ,@GasConceptoMultiple = ISNULL(GasConceptoMultiple, 0)
	FROM EmpresaCfg2
	WHERE Empresa = @Empresa

	IF @CfgCompraAutoEndoso = 1
		AND @Modulo = 'COMS'
	BEGIN
		SELECT @Endoso = NULLIF(RTRIM(AutoEndoso), '')
		FROM Prov
		WHERE Proveedor = @Contacto
		EXEC xpCompraAutoEndoso @Empresa
							   ,@Accion
							   ,@Modulo
							   ,@ID
							   ,@Mov
							   ,@MovID
							   ,@MovTipo
							   ,@Endoso OUTPUT
							   ,@Ok OUTPUT
							   ,@OkRef OUTPUT

		IF @Endoso IS NOT NULL
		BEGIN

			IF NOT EXISTS (SELECT * FROM Prov WHERE Proveedor = @Endoso)
				SELECT @Ok = 26050
					  ,@OkRef = @Endoso

			IF @CfgCompraAutoEndosoEmpresas = 1
				AND @Ok IS NULL
			BEGIN

				IF NOT EXISTS (SELECT * FROM Cte WHERE Cliente = @Empresa)
					SELECT @Ok = 26060
						  ,@OkRef = @Empresa

				IF NOT EXISTS (SELECT * FROM Empresa WHERE Empresa = @Endoso)
					SELECT @Ok = 26070
						  ,@OkRef = @Endoso

				IF NOT EXISTS (SELECT * FROM MovTipo WHERE Modulo = 'CXC' AND Mov = @Mov)
					SELECT @Ok = 26080
						  ,@OkRef = RTRIM(@Mov) + ' en Cuentas por Cobrar (Auto Endosar CXP)'

			END

			IF @CfgCompraAutoEndosoAutoCargos = 0
				AND @Ok IS NULL
			BEGIN

				IF @CfgCompraAutoEndosoMovs = 1
					SELECT @EndosarA = @Endoso
				ELSE
					SELECT @ProveedorAutoEndoso = @Contacto
						  ,@Contacto = @Endoso

			END

		END

	END

	IF @CfgComisionesCobradas = 1
		SELECT @ComisionPendiente = @ComisionTotal

	IF @ModuloAfectar = 'AGENT'
	BEGIN

		IF @CfgComisionEspecial = 1
			RETURN 0

		SELECT @CxMov = @MovEspecifico
			  ,@CxModulo = @ModuloAfectar

		IF @CxMov IS NULL
			SELECT @CxMov =
			 CASE
				 WHEN @MovTipo IN ('CXC.C', 'CXC.A', 'CXC.AA', 'CXC.AR', 'VTAS.F', 'VTAS.FAR', 'VTAS.FB', 'CXC.F', 'CXC.FA', 'CXC.AF', 'VTAS.N', 'VTAS.NO', 'VTAS.NR', 'VTAS.FM', 'CXC.CA', 'CXC.CAD', 'CXC.ANC')
					 AND (ISNULL(@ComisionTotal, 0.0) >= 0.0) THEN NULLIF(RTRIM(AgentComision), '')
				 WHEN (@MovTipo IN ('VTAS.D', 'VTAS.DF', 'CXC.NC', 'CXC.NCD', 'CXC.CD'))
					 OR (@MovTipo IN ('VTAS.N', 'VTAS.NO', 'VTAS.NR', 'VTAS.FM', 'VTAS.F', 'VTAS.FAR') AND (ISNULL(@ComisionTotal, 0.0) < 0.0)) THEN NULLIF(RTRIM(AgentDevolucion), '')
				 WHEN @MovTipo = 'VTAS.B' THEN NULLIF(RTRIM(AgentBonificacion), '')
				 WHEN @MovTipo = 'DIN.F' THEN NULLIF(RTRIM(AgentFaltanteCaja), '')
				 WHEN @MovTipo = 'INV.A' THEN NULLIF(RTRIM(AgentAjusteInv), '')
			 END
			FROM EmpresaCfgMov
			WHERE Empresa = @Empresa

		SELECT @Referencia = RTRIM(@Mov) + ' ' + LTRIM(CONVERT(CHAR, @MovID))
		SELECT @ComisionTotal = ABS(@ComisionTotal)
	END
	ELSE
	BEGIN

		IF @Modulo = 'CAM'
			SELECT @CxMovID = NULL
				  ,@Referencia = LTRIM(CONVERT(CHAR, @MovID))
		ELSE
			SELECT @CxMovID = @MovID

		IF @Modulo = 'GAS'
			AND @GasConceptoMultiple = 1
			SET @CxMovID = NULL

		IF @MovTipo IN ('VTAS.D', 'VTAS.DF', 'VTAS.B', 'COMS.D', 'COMS.B')
			AND @CfgConsecutivoIndep = 1
			SELECT @CxMovID = NULL
				  ,@Referencia = RTRIM(@Mov) + ' ' + LTRIM(CONVERT(CHAR, @MovID))

		IF @Modulo IN ('VTAS', 'VALE', 'CXC', 'DIN')
			SELECT @CxModulo = 'CXC'
		ELSE

		IF @Modulo IN ('COMS', 'PROD', 'INV', 'CXP')
			SELECT @CxModulo = 'CXP'
		ELSE

		IF @Modulo = 'GAS'
		BEGIN
			SELECT @CxModulo = 'CXP'
			SELECT @RetencionAlPago = ISNULL(RetencionAlPago, 0)
			FROM Gasto
			WHERE ID = @ID

			IF @GastoCxc = 1

				IF EXISTS (SELECT * FROM Cte WHERE Cliente = @Contacto AND EsProveedor = 1)
					SELECT @CxModulo = 'CXC'

		END
		ELSE

		IF @Modulo = 'CAM'

			IF UPPER(@Tipo) IN ('COMPRA', 'COBRO')
				SELECT @CxModulo = 'CXC'
			ELSE
				SELECT @CxModulo = 'CXP'

		IF @MovTipo = 'VTAS.FX'
		BEGIN
			SELECT @CxModulo = 'CXP'
				  ,@Vencimiento = NULL
				  ,@Contacto = NULL
				  ,@Retencion = NULL
				  ,@Retencion2 = NULL
				  ,@Retencion3 = NULL
				  ,@ComisionTotal = NULL
			SELECT @Contacto = p.Proveedor
				  ,@Condicion = p.Condicion
				  ,@ZonaImpuesto = p.ZonaImpuesto
			FROM Venta v
				,Prov p
			WHERE v.ID = @ID
			AND p.Proveedor = v.GastoAcreedor

			IF @Contacto IS NULL
				SELECT @Ok = 55110

			SELECT @DefImpuesto = DefImpuesto
			FROM EmpresaGral
			WHERE Empresa = @Empresa
			EXEC spZonaImp @ZonaImpuesto
						  ,@DefImpuesto OUTPUT
			SELECT @Importe = SUM(CostoTotal)
			FROM VentaTCalc
			WHERE ID = @ID
			SELECT @Impuestos = @Importe * (@DefImpuesto / 100)
		END

		IF @Modulo = 'EMB'
		BEGIN

			IF UPPER(@Tipo) IN ('COBRADO', 'COBRO PARCIAL')
				SELECT @CxModulo = 'CXC'
					  ,@CxMovID = NULL
			ELSE

			IF UPPER(@Tipo) = 'PAGADO'
				SELECT @CxModulo = 'CXP'
					  ,@CxMovID = NULL
			ELSE

			IF UPPER(@Tipo) = 'CXP'
				SELECT @CxModulo = 'CXP'

		END

		IF @MovTipo = 'GAS.ASC'
			SELECT @CxModulo = 'AGENT'

		IF @Modulo = 'FIS'
			SELECT @CxModulo = @ModuloAfectar

		SELECT @Saldo = ISNULL(@Importe, 0.0) + ISNULL(@Impuestos, 0.0) - ISNULL(@Retencion, 0.0) - ISNULL(@Retencion2, 0.0) - ISNULL(@Retencion3, 0.0)
			  ,@IDGenerar = NULL
		SELECT @CfgMovCobro = NULLIF(RTRIM(CxcCobro), '')
			  ,@CfgMovPago = NULLIF(RTRIM(CxpPago), '')
			  ,@CfgMovCxpNomina = NULLIF(RTRIM(CxpNomina), '')
			  ,@CfgMovCxpCancelacionNomina = NULLIF(RTRIM(CxpCancelacionNomina), '')
			  ,@CfgMovCxcNomina = NULLIF(RTRIM(CxcNomina), '')
			  ,@CfgMovCxcCancelacionNomina = NULLIF(RTRIM(CxcCancelacionNomina), '')
			  ,@CfgMovGastoDiverso = NULLIF(RTRIM(CxpGastoDiverso), '')
			  ,@CfgMovEmbarqueCxp = NULLIF(RTRIM(EmbarqueCxp), '')
			  ,@CfgMovAvanceCxp = NULLIF(RTRIM(ProdAvanceCxp), '')
			  ,@CfgMovRetrocesoCxp = NULLIF(RTRIM(ProdRetrocesoCxp), '')
			  ,@CfgMovCxcAnticipo = NULLIF(RTRIM(CxcAnticipo), '')
			  ,@CfgMovCxpAnticipo = NULLIF(RTRIM(CxpAnticipo), '')
			  ,@CfgMovCxcAjusteSaldo = NULLIF(RTRIM(CxcAjusteSaldo), '')
			  ,@CfgMovCxpAjusteSaldo = NULLIF(RTRIM(CxpAjusteSaldo), '')
			  ,@CfgMovCxcForwardPorCobrar = NULLIF(RTRIM(CxcForwardPorCobrar), '')
			  ,@CfgMovCxpForwardPorPagar = NULLIF(RTRIM(CxpForwardPorPagar), '')
			  ,@CfgMovCxcVentaVales = NULLIF(RTRIM(CxcVentaVales), '')
			  ,@CfgMovCxcObsequioVales = NULLIF(RTRIM(CxcObsequioVales), '')
			  ,@CfgMovCxcAplicacionVales = NULLIF(RTRIM(CxcAplicacionVales), '')
			  ,@CfgMovCxcAplicacionTarjetas = NULLIF(RTRIM(CxcAplicacionTarjetas), '')
			  ,@CfgMovCxcDevolucionVales = NULLIF(RTRIM(CxcDevolucionVales), '')
			  ,@CfgMovCxpGastoDev = CxpGastoDev
			  ,@CfgMovCxpGastoDevProrrateada = CxpGastoDevProrrateada
			  ,@CfgMovCxpImportacion = NULLIF(RTRIM(CxpImportacion), '')
			  ,@CfgMovFaltanteCaja = CxcFaltanteCaja
			  ,@CfgMovCxcEndoso = CxcEndoso
			  ,@CfgMovCxpEndoso = CxpEndoso
			  ,@CfgMovCxcEndosoAFavor = CxcEndosoAFavor
			  ,@CfgMovCxpEndosoAFavor = CxpEndosoAFavor
		FROM EmpresaCfgMov
		WHERE Empresa = @Empresa

		IF @@ERROR <> 0
			SELECT @Ok = 1

		IF @ModuloEspecifico IS NOT NULL
			SELECT @CxModulo = @ModuloEspecifico

		IF @MovEspecifico IS NOT NULL
		BEGIN
			SELECT @CxMov = @MovEspecifico
				  ,@CxMovID = @MovIDEspecifico
		END
		ELSE
		BEGIN

			IF @Modulo = 'CXC'
			BEGIN
				SELECT @CxModulo = @ModuloAfectar
					  ,@CxMovID = NULL

				IF @MovTipo = 'CXC.RA'
					SELECT @CxMov = @CfgMovCxcAnticipo
				ELSE

				IF @MovTipo = 'CXC.NCF'
					SELECT @CxMov = @CfgMovCxcForwardPorCobrar

			END
			ELSE

			IF @Modulo = 'CXP'
			BEGIN
				SELECT @CxModulo = @ModuloAfectar
					  ,@CxMovID = NULL

				IF @MovTipo = 'CXP.RA'
					SELECT @CxMov = @CfgMovCxpAnticipo
				ELSE

				IF @MovTipo = 'CXP.NCF'
					SELECT @CxMov = @CfgMovCxpForwardPorPagar

			END
			ELSE

			IF @Modulo = 'NOM'
			BEGIN
				SELECT @CxMovID = NULL

				IF @CxModulo = 'CXP'
					SELECT @CxMov =
					 CASE
						 WHEN @Importe < 0 THEN @CfgMovCxpCancelacionNomina
						 ELSE @CfgMovCxpNomina
					 END
				ELSE

				IF @CxModulo = 'CXC'
					SELECT @CxMov =
					 CASE
						 WHEN @Importe < 0 THEN @CfgMovCxcCancelacionNomina
						 ELSE @CfgMovCxcNomina
					 END

				IF @Importe < 0
					SELECT @Importe = -@Importe
						  ,@Impuestos = -@Impuestos
						  ,@ComisionTotal = -@ComisionTotal

			END
			ELSE

			IF @Modulo = 'VALE'
			BEGIN
				SELECT @CxMovID = NULL

				IF @MovTipo IN ('VALE.V', 'VALE.EV')
					SELECT @CxMov = @CfgMovCxcVentaVales
				ELSE

				IF @MovTipo = 'VALE.O'
					SELECT @CxMov = @CfgMovCxcObsequioVales
				ELSE

				IF @MovTipo = 'VALE.A'
					SELECT @CxMov = @CfgMovCxcAplicacionVales
				ELSE

				IF @MovTipo = 'VALE.AT'
					SELECT @CxMov = @CfgMovCxcAplicacionTarjetas
				ELSE

				IF @MovTipo = 'VALE.D'
					SELECT @CxMov = @CfgMovCxcDevolucionVales

			END
			ELSE

			IF @Modulo = 'CAM'
			BEGIN

				IF UPPER(@Tipo) IN ('COBRO', 'VENTA')
					SELECT @CxMov = 'Venta'
				ELSE

				IF UPPER(@Tipo) IN ('COMPRA', 'PAGO')
					SELECT @CxMov = 'Compra'

			END
			ELSE

			IF @Modulo = 'CAP'
			BEGIN
				SELECT @CxMov = @Mov
					  ,@CxMovID = NULL

				IF @MovTipo IN ('CAP.AC', 'CAP.CAP')
					SELECT @CxModulo = 'CXC'
				ELSE

				IF @MovTipo IN ('CAP.DC', 'CAP.DIV')
					SELECT @CxModulo = 'CXP'

			END
			ELSE

			IF @Modulo = 'EMB'
			BEGIN

				IF UPPER(@Tipo) IN ('COBRADO', 'COBRO PARCIAL')
				BEGIN
					SELECT @CxMov = @CfgMovCobro

					IF @CfgEmbarqueCobrarDemas = 1
						SELECT @AplicarDemas = 1

				END
				ELSE

				IF UPPER(@Tipo) = 'PAGADO'
					SELECT @CxMov = @CfgMovPago
				ELSE

				IF UPPER(@Tipo) = 'CXP'
				BEGIN
					SELECT @CxMov = @CfgMovEmbarqueCxp

					IF @CxMov = @CfgMovGastoDiverso
						SELECT @CxMovID = NULL

				END

			END
			ELSE
			BEGIN

				IF @MovTipo IN ('COMS.EG', 'COMS.EI', 'INV.EI')
					AND @Tipo = 'DESGLOSE'
					SELECT @CxMov = @CfgMovGastoDiverso
						  ,@CxMovID = NULL
				ELSE

				IF @MovTipo IN ('COMS.EG', 'COMS.EI')
					AND @Tipo = 'CXC'
					SELECT @CxModulo = 'CXC'
						  ,@CxMov = @CfgMovGastoDiverso
				ELSE

				IF @MovTipo IN ('VTAS.FM', 'VTAS.N', 'VTAS.NO', 'VTAS.NR', 'VTAS.F', 'VTAS.FX', 'VTAS.FAR', 'VTAS.FB', 'COMS.F', 'COMS.FL', 'COMS.CA', 'COMS.GX', 'COMS.EG', 'INV.EI', 'GAS.G', 'GAS.GP', 'GAS.ASC')
					SELECT @CxMov = @Mov
				ELSE

				IF @MovTipo = 'GAS.GTC'
					SELECT @CxMov = @Mov
						  ,@CxMovID = RTRIM(@MovID) + '-' + CONVERT(VARCHAR, @Conteo)
				ELSE

				IF @MovTipo = 'COMS.EI'
					SELECT @CxMov = @CfgMovCxpImportacion
						  ,@CxMovID = NULL
				ELSE

				IF @MovTipo = 'GAS.DG'
					SELECT @CxMov = @CfgMovCxpGastoDev
						  ,@CxMovID = NULL
				ELSE

				IF @MovTipo = 'GAS.DGP'
					SELECT @CxMov = @CfgMovCxpGastoDevProrrateada
						  ,@CxMovID = NULL
				ELSE

				IF @MovTipo IN ('VTAS.D', 'VTAS.DF', 'VTAS.B', 'COMS.D', 'COMS.B')
					SELECT @CxMov = ConsecutivoMov
					FROM MovTipo
					WHERE Modulo = @Modulo
					AND Mov = @Mov
					AND Clave = @MovTipo
				ELSE

				IF @MovTipo IN ('PROD.A', 'PROD.E')
					SELECT @CxMov = @CfgMovAvanceCxp
						  ,@CxMovID = NULL
				ELSE

				IF @MovTipo IN ('PROD.R')
					SELECT @CxMov = @CfgMovRetrocesoCxp
						  ,@CxMovID = NULL
				ELSE

				IF @MovTipo = 'DIN.F'
					SELECT @CxMov = @CfgMovFaltanteCaja
				ELSE

				IF @MovTipo = 'DIN.ACXC'
					SELECT @CxModulo = @ModuloAfectar
						  ,@CxMov = @CfgMovCxcAnticipo
				ELSE

				IF @MovTipo = 'DIN.ACXP'
					SELECT @CxModulo = @ModuloAfectar
						  ,@CxMov = @CfgMovCxpAnticipo
				ELSE

				IF @MovTipo IN ('DIN.SD', 'DIN.SCH')
					SELECT @CxModulo = @ModuloAfectar
						  ,@CxMov = @Mov
						  ,@CxMovID = @MovID
				ELSE

				IF @SubClave = 'VTAS.FA'
					SELECT @CxMov = @Mov
				ELSE
					SELECT @Ok = 70021

			END

			IF EXISTS (SELECT * FROM EmpresaCfgMovGenera WHERE Empresa = @Empresa AND Modulo = @Modulo AND Mov = @Mov AND GeneraModulo = @CxModulo)
			BEGIN
				SELECT @CxMov = GeneraMov
					  ,@ArrastrarMovID = ArrastrarMovID
				FROM EmpresaCfgMovGenera
				WHERE Empresa = @Empresa
				AND Modulo = @Modulo
				AND Mov = @Mov
				AND GeneraModulo = @CxModulo

				IF @ArrastrarMovID = 1
					SELECT @CxMovID = @MovID

			END

		END

	END

	EXEC xpGenerarAfectarCxMov @Accion
							  ,@ModuloAfectar
							  ,@Empresa
							  ,@Modulo
							  ,@ID
							  ,@Mov
							  ,@MovID
							  ,@MovTipo
							  ,@Referencia
							  ,@CxMov OUTPUT
							  ,@CxMovID OUTPUT
							  ,@Ok OUTPUT
							  ,@OkRef OUTPUT

	IF @CxMov IS NULL
		SELECT @Ok = 70020

	IF @Ok IS NULL

		IF NOT EXISTS (SELECT * FROM MovTipo WHERE Modulo = @CxModulo AND Mov = @CxMov)
			SELECT @Ok = 70025
				  ,@OkRef = RTRIM(@CxMov) + ' (' + RTRIM(@CxModulo) + ')'

	IF @Ok IS NOT NULL
		RETURN 0

	IF (@MovTipoCambio <> 1.0)
		AND ((@CxModulo = 'CXC' AND @CxcMonedaCont = 1) OR (@CxModulo = 'CXP' AND @CxpMonedaCont = 1) OR (@CxModulo = 'AGENT' AND @AgentMonedaCont = 1))
	BEGIN
		SELECT @Importe = @Importe * @MovTipoCambio
			  ,@Impuestos = @Impuestos * @MovTipoCambio
			  ,@Retencion = @Retencion * @MovTipoCambio
			  ,@Retencion2 = @Retencion2 * @MovTipoCambio
			  ,@Retencion3 = @Retencion3 * @MovTipoCambio
			  ,@Saldo = @Saldo * @MovTipoCambio
			  ,@ComisionTotal = @ComisionTotal * @MovTipoCambio
			  ,@ImporteAplicar = @ImporteAplicar * @MovTipoCambio
		SELECT @MovTipoCambio = 1.0
		SELECT @MovMoneda = ContMoneda
		FROM EmpresaCfg
		WHERE Empresa = @Empresa
	END

	SELECT @CxMovTipo = Clave
	FROM MovTipo
	WHERE Modulo = @CxModulo
	AND Mov = @CxMov

	IF @CxMovTipo IN ('CXC.DA', 'CXC.NC', 'CXC.NCD', 'CXC.NCF', 'CXC.DV', 'CXC.NCP', 'CXC.DC', 'CXP.A', 'CXP.NC', 'CXP.NCD', 'CXP.NCP', 'CXP.NCF', 'CXP.DC')
		SELECT @CxEsCredito = 1

	IF @EndosarA IS NOT NULL
	BEGIN

		IF @CxEsCredito = 1
		BEGIN
			SELECT @CxEndosoMov =
			 CASE @CxModulo
				 WHEN 'CXC' THEN @CfgMovCxcEndosoAFavor
				 WHEN 'CXP' THEN @CfgMovCxpEndosoAFavor
			 END
		END
		ELSE
		BEGIN
			SELECT @CxEndosoMov =
			 CASE @CxModulo
				 WHEN 'CXC' THEN @CfgMovCxcEndoso
				 WHEN 'CXP' THEN @CfgMovCxpEndoso
			 END
		END

	END

	IF @Condicion IS NOT NULL
		AND @CxModulo IN ('CXC', 'CXP')
	BEGIN

		IF EXISTS (SELECT * FROM Condicion WHERE Condicion = @Condicion AND Neteo = 1)

			IF NOT EXISTS (SELECT * FROM Cte WHERE Cliente = @Contacto AND EsProveedor = 1)
				SELECT @Ok = 10280
			ELSE
			BEGIN
				SELECT @AutoAplicar = 0

				IF @CxModulo = 'CXC'
					SELECT @CxModulo = 'CXP'
				ELSE

				IF @CxModulo = 'CXP'
					SELECT @CxModulo = 'CXC'

				SELECT @CxMov =
				 CASE @CxModulo
					 WHEN 'CXC' THEN @CfgMovCxcAjusteSaldo
					 ELSE @CfgMovCxpAjusteSaldo
				 END
				SELECT @Importe = @Importe + @Impuestos - @Retencion
				SELECT @Impuestos = 0.0
					  ,@Retencion = 0.0

				IF @CxEsCredito = 0
					SELECT @Importe = -@Importe

			END

	END

	IF @Accion NOT IN ('CANCELAR', 'GENERAR')
		SELECT @Accion = 'AFECTAR'

	IF @Accion <> 'CANCELAR'
	BEGIN

		IF @AC = 1
		BEGIN

			IF @CxModulo = 'CXC'
				AND @Modulo = 'VTAS'
				SELECT @LineaCredito = LineaCredito
					  ,@TipoAmortizacion = TipoAmortizacion
					  ,@TipoTasa = TipoTasa
					  ,@TieneTasaEsp = TieneTasaEsp
					  ,@TasaEsp = TasaEsp
					  ,@Comisiones = Comisiones
					  ,@ComisionesIVA = ComisionesIVA
				FROM Venta
				WHERE ID = @ID

			IF @CxModulo = 'CXP'
				AND @Modulo = 'COMS'
				SELECT @LineaCredito = LineaCredito
					  ,@TipoAmortizacion = TipoAmortizacion
					  ,@TipoTasa = TipoTasa
					  ,@TieneTasaEsp = TieneTasaEsp
					  ,@TasaEsp = TasaEsp
					  ,@Comisiones = Comisiones
					  ,@ComisionesIVA = ComisionesIVA
				FROM Compra
				WHERE ID = @ID

		END

		IF @Aplica IS NOT NULL
			AND @AplicaMovID IS NOT NULL
			SELECT @AplicaManual = 1
		ELSE
			SELECT @AplicaManual = 0

		SELECT @IDOrigen = dbo.fnModuloID(@Empresa, @OrigenTipo, @Origen, @OrigenID, @Ejercicio, @Periodo)
		EXEC spMovInfo @IDOrigen
					  ,@OrigenTipo
					  ,@Origen
					  ,@OrigenID
					  ,@OrigenEstatus OUTPUT
					  ,@OrigenSucursal OUTPUT
					  ,@OrigenUEN OUTPUT

		IF @AutoAplicar = 1
			AND @CxModulo IN ('CXC', 'CXP')
			AND ISNULL(@NoAutoAplicar, 0) = 0
		BEGIN
			EXEC xpAutoAplicarCx @Modulo
								,@ID
								,@AutoAplicar OUTPUT

			IF @AutoAplicar = 1
			BEGIN
				SELECT @Aplica = NULL
					  ,@AplicaMovID = NULL
					  ,@AplicaSaldoMN = NULL
					  ,@SaldoMN = @Saldo * @MovTipoCambio

				IF @CxModulo = 'CXC'
					SELECT @Aplica = Mov
						  ,@AplicaMovID = MovID
						  ,@AplicaSaldoMN = Saldo * TipoCambio
					FROM Cxc
					WHERE Empresa = @Empresa
					AND Cliente = @Contacto
					AND Estatus = 'PENDIENTE'
					AND @ReferenciaOriginal = RTRIM(Mov) + ' ' + RTRIM(MovID)
				ELSE

				IF @CxModulo = 'CXP'
					SELECT @Aplica = Mov
						  ,@AplicaMovID = MovID
						  ,@AplicaSaldoMN = Saldo * TipoCambio
					FROM Cxp
					WHERE Empresa = @Empresa
					AND Proveedor = @Contacto
					AND Estatus = 'PENDIENTE'
					AND @ReferenciaOriginal = RTRIM(Mov) + ' ' + RTRIM(MovID)

				IF ISNULL(@AplicaSaldoMN, 0.0) > 0.0
				BEGIN
					SELECT @AplicaManual = 1

					IF @AplicaSaldoMN > @SaldoMN
						SELECT @ImporteAplicar = @Saldo
					ELSE
						SELECT @ImporteAplicar = @AplicaSaldoMN / @MovTipoCambio

				END

			END

		END

		SELECT @CxEstatus = 'SINAFECTAR'

		IF @CxModulo IN ('CXC', 'CXP')
			AND @Modulo IN ('VTAS', 'COMS', 'GAS', 'PROD')
		BEGIN
			SELECT @CfgGenerarEnBorrador =
			 CASE
				 WHEN @CxModulo = 'CXC' THEN CxcGenerarEnBorrador
				 ELSE CxpGenerarEnBorrador
			 END
			FROM EmpresaCfg2
			WHERE Empresa = @Empresa

			IF @CfgGenerarEnBorrador = 1
				SELECT @CxEstatus = 'BORRADOR'

			EXEC xpCxGenerarEnBorrador @Modulo
									  ,@ID
									  ,@CxEstatus OUTPUT
		END

		IF @Modulo = 'VTAS'
			SELECT @ContratoID = ContratoID
				  ,@ContratoMov = ContratoMov
				  ,@ContratoMovID = ContratoMovID
			FROM Venta
			WHERE ID = @ID
		ELSE

		IF @Modulo = 'COMS'
			SELECT @ContratoID = ContratoID
				  ,@ContratoMov = ContratoMov
				  ,@ContratoMovID = ContratoMovID
			FROM Compra
			WHERE ID = @ID
		ELSE

		IF @Modulo = 'GAS'
			SELECT @ContratoID = ContratoID
				  ,@ContratoMov = ContratoMov
				  ,@ContratoMovID = ContratoMovID
			FROM Gasto
			WHERE ID = @ID

		IF @CxModulo = 'CXC'
		BEGIN

			IF EXISTS (SELECT * FROM Cte WHERE Cliente = @Contacto)
			BEGIN
				SELECT @CteMoneda = @MovMoneda
					  ,@CteTipoCambio = @MovTipoCambio
				SELECT @OrigenMovTipo = Clave
				FROM MovTipo
				WHERE Modulo = @OrigenTipo
				AND Mov = @Origen

				IF @OrigenTipo = 'VTAS'
					AND @OrigenMovTipo IN ('VTAS.B', 'VTAS.D')
					AND @AutoAplicar = 1
					AND @CxMovTipo IN ('CXC.NC')
				BEGIN
					SELECT @MonedaOrigen = Moneda
						  ,@TipoCambioOrigen = TipoCambio
					FROM Venta
					WHERE Mov = @Aplica
					AND MovID = @AplicaMovID

					IF @MovMoneda <> @MonedaOrigen
						AND @MovTipoCambio <> @TipoCambioOrigen
						SELECT @CteMoneda = @MonedaOrigen
							  ,@CteTipoCambio = @TipoCambioOrigen

				END

				IF @PersonalCobrador IS NULL
					SELECT @PersonalCobrador = PersonalCobrador
					FROM Cte
					WHERE Cliente = @Contacto

				INSERT INTO Cxc (Sucursal, SucursalOrigen, SucursalDestino, Empresa, Mov, MovID, FechaEmision, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Autorizacion, Referencia, DocFuente, Observaciones, Estatus, UltimoCambio,
				Cliente, ClienteEnviarA, ClienteMoneda, ClienteTipoCambio, Condicion, Vencimiento, CtaDinero, Importe, Impuestos, Retencion, Retencion2, Retencion3, Saldo,
				FormaCobro, Agente, Cajero, ComisionTotal, ComisionPendiente, AplicaManual,
				OrigenTipo, Origen, OrigenID, UEN, VIN, IVAFiscal, IEPSFiscal, PersonalCobrador, Nota, LineaCredito, TipoAmortizacion, TipoTasa, TieneTasaEsp, TasaEsp, Comisiones, ComisionesIVA, ContratoID, ContratoMov, ContratoMovID, NoAutoAplicar)
					VALUES (@Sucursal, @SucursalOrigen, @SucursalDestino, @Empresa, @CxMov, @CxMovID, @FechaEmision, @Concepto, @Proyecto, @MovMoneda, @MovTipoCambio, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, @CxEstatus, @FechaRegistro, @Contacto, @EnviarA, ISNULL(@CteMoneda, @MovMoneda), ISNULL(@CteTipoCambio, @MovTipoCambio), @Condicion, @Vencimiento, @CtaDinero, @Importe, @Impuestos, @Retencion, @Retencion2, @Retencion3, @Saldo, @FormaPago, @Agente, @Agente, @ComisionTotal, @ComisionPendiente, @AplicaManual, @OrigenTipo, @Origen, @OrigenID, @OrigenUEN, @VIN, @IVAFiscal, @IEPSFiscal, @PersonalCobrador, @Nota, @LineaCredito, @TipoAmortizacion, @TipoTasa, @TieneTasaEsp, @TasaEsp, @Comisiones, @ComisionesIVA, @ContratoID, @ContratoMov, @ContratoMovID, @NoAutoAplicar)
				SELECT @CxID = SCOPE_IDENTITY()

				IF @AplicaManual = 1
					INSERT INTO CxcD (Sucursal, ID, Renglon, RenglonSub, Aplica, AplicaID, Importe)
						VALUES (@Sucursal, @CxID, 2048, 0, @Aplica, @AplicaMovID, @ImporteAplicar)

				IF @AplicarDemas = 1
					AND @ImporteAplicar <> @Importe + ISNULL(@Impuestos, 0.0)
					INSERT CxcAplicaDif (ID, Mov, Importe, Cliente, ClienteEnviarA, Sucursal, SucursalOrigen)
						SELECT @CxID
							  ,'Saldo a Favor'
							  ,@Importe + ISNULL(@Impuestos, 0.0) - @ImporteAplicar
							  ,@Contacto
							  ,@EnviarA
							  ,@Sucursal
							  ,@SucursalOrigen

			END
			ELSE
				SELECT @Ok = 26060
					  ,@OkRef = @Contacto

		END
		ELSE

		IF @CxModulo = 'CXP'
		BEGIN

			IF EXISTS (SELECT * FROM Prov WHERE Proveedor = @Contacto)
			BEGIN
				INSERT INTO Cxp (Sucursal, SucursalOrigen, SucursalDestino, Empresa, Mov, MovID, FechaEmision, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Autorizacion, Referencia, DocFuente, Observaciones, Estatus, UltimoCambio,
				Proveedor, ProveedorMoneda, ProveedorTipoCambio, Condicion, Vencimiento, CtaDinero, Importe, Impuestos, Retencion, Retencion2, Retencion3, Saldo, AplicaManual,
				FormaPago, Beneficiario,
				OrigenTipo, Origen, OrigenID, UEN, VIN, IVAFiscal, IEPSFiscal, ProveedorAutoEndoso, Nota, LineaCredito, TipoAmortizacion, TipoTasa, TieneTasaEsp, TasaEsp, Comisiones, ComisionesIVA, RetencionAlPago, ContratoID, ContratoMov, ContratoMovID, NoAutoAplicar)
					VALUES (@Sucursal, @SucursalOrigen, @SucursalDestino, @Empresa, @CxMov, @CxMovID, @FechaEmision, @Concepto, @Proyecto, @MovMoneda, @MovTipoCambio, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, @CxEstatus, @FechaRegistro, @Contacto, @MovMoneda, @MovTipoCambio, @Condicion, @Vencimiento, @CtaDinero, @Importe, @Impuestos, @Retencion, @Retencion2, @Retencion3, @Saldo, @AplicaManual, @FormaPago, @Beneficiario, @OrigenTipo, @Origen, @OrigenID, @OrigenUEN, @VIN, @IVAFiscal, @IEPSFiscal, @ProveedorAutoEndoso, @Nota, @LineaCredito, @TipoAmortizacion, @TipoTasa, @TieneTasaEsp, @TasaEsp, @Comisiones, @ComisionesIVA, @RetencionAlPago, @ContratoID, @ContratoMov, @ContratoMovID, @NoAutoAplicar)
				SELECT @CxID = SCOPE_IDENTITY()

				IF @AplicaManual = 1
					INSERT INTO CxpD (Sucursal, ID, Renglon, RenglonSub, Aplica, AplicaID, Importe)
						VALUES (@Sucursal, @CxID, 2048, 0, @Aplica, @AplicaMovID, @ImporteAplicar)

			END
			ELSE
				SELECT @Ok = 26050
					  ,@OkRef = @Contacto

		END
		ELSE

		IF @CxModulo = 'AGENT'
		BEGIN

			IF EXISTS (SELECT * FROM Agente WHERE Agente = @Agente)
			BEGIN

				IF NULLIF(RTRIM(@Observaciones), '') IS NOT NULL
					SELECT @Observaciones = RTRIM(@Observaciones) + ' '

				IF @Contacto IS NOT NULL
					AND NULLIF(@Importe, 0) IS NOT NULL
					SELECT @Observaciones = RTRIM(@Observaciones) + '(' + RTRIM(@Contacto) + ', ' + LTRIM(CONVERT(CHAR, ROUND(@ComisionTotal / @Importe * 100, 2))) + '%)'

				INSERT INTO Agent (Sucursal, SucursalDestino, Empresa, Mov, MovID, FechaEmision, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Autorizacion, Referencia, DocFuente, Estatus, UltimoCambio,
				Agente, Importe, Observaciones,
				OrigenTipo, Origen, OrigenID, UEN)
					VALUES (@Sucursal, @SucursalDestino, @Empresa, @CxMov, @CxMovID, @FechaEmision, @Concepto, @Proyecto, @MovMoneda, @MovTipoCambio, @Usuario, @Autorizacion, @Referencia, @DocFuente, 'SINAFECTAR', @FechaRegistro, @Agente, @ComisionTotal, @Observaciones, @OrigenTipo, @Origen, @OrigenID, @OrigenUEN)
				SELECT @CxID = SCOPE_IDENTITY()
			END
			ELSE
				SELECT @Ok = 26090
					  ,@OkRef = @Agente

		END

		EXEC spMovCopiarAnexos @Sucursal
							  ,@Modulo
							  ,@ID
							  ,@CxModulo
							  ,@CxID

		IF @Modulo = 'EMB'
			AND @CxModulo = 'CXC'
			AND (
				SELECT EmbarqueSugerirCobros
				FROM EmpresaCfg
				WHERE Empresa = @Empresa
			)
			= 1
			EXEC spSugerirCobro 'Importe Especifico'
							   ,@CxModulo
							   ,@CxID
							   ,@ImporteAplicar

		IF @CopiarMovImpuesto = 1
		BEGIN
			INSERT MovImpuesto (Modulo, ModuloID, OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenDeducible, OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, Importe1, Importe2, Importe3, SubTotal, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal)
				SELECT @CxModulo
					  ,@CxID
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
				FROM MovImpuesto
				WHERE Modulo = @Modulo
				AND ModuloID = @ID
			INSERT MovPresupuesto (Modulo, ModuloID, CuentaPresupuesto, Importe)
				SELECT @CxModulo
					  ,@CxID
					  ,CuentaPresupuesto
					  ,Importe
				FROM MovPresupuesto
				WHERE Modulo = @Modulo
				AND ModuloID = @ID
		END

	END
	ELSE
	BEGIN
		SELECT @CxID = NULL

		IF @INSTRUCCIONES_ESP = 'SIN_ORIGEN'
		BEGIN

			IF @CxModulo = 'CXC'
				SELECT @CxID = f.DID
					  ,@CxMov = f.DMov
					  ,@CxMovID = f.DMovID
					  ,@CxEstatus = e.Estatus
				FROM MovFlujo f
					,Cxc e
				WHERE f.Cancelado = 0
				AND f.Empresa = @Empresa
				AND f.OModulo = @Modulo
				AND f.OID = @ID
				AND f.DModulo = @CxModulo
				AND f.DID = e.ID
				AND e.OrigenTipo IS NULL
			ELSE

			IF @CxModulo = 'CXP'
				SELECT @CxID = f.DID
					  ,@CxMov = f.DMov
					  ,@CxMovID = f.DMovID
					  ,@CxEstatus = e.Estatus
				FROM MovFlujo f
					,Cxp e
				WHERE f.Cancelado = 0
				AND f.Empresa = @Empresa
				AND f.OModulo = @Modulo
				AND f.OID = @ID
				AND f.DModulo = @CxModulo
				AND f.DID = e.ID
				AND e.OrigenTipo IS NULL
			ELSE

			IF @CxModulo = 'AGENT'
				SELECT @CxID = f.DID
					  ,@CxMov = f.DMov
					  ,@CxMovID = f.DMovID
				FROM MovFlujo f
					,Agent e
				WHERE f.Cancelado = 0
				AND f.Empresa = @Empresa
				AND f.OModulo = @Modulo
				AND f.OID = @ID
				AND f.DModulo = @CxModulo
				AND f.DID = e.ID
				AND e.OrigenTipo IS NULL

		END
		ELSE
		BEGIN

			IF @CxModulo = 'CXC'
				SELECT @CxID = f.DID
					  ,@CxMov = f.DMov
					  ,@CxMovID = f.DMovID
					  ,@CxEstatus = e.Estatus
				FROM MovFlujo f
					,Cxc e
				WHERE f.Cancelado = 0
				AND f.Empresa = @Empresa
				AND f.OModulo = @Modulo
				AND f.OID = @ID
				AND f.DModulo = @CxModulo
				AND f.DID = e.ID
				AND e.OrigenTipo IS NOT NULL
			ELSE

			IF @CxModulo = 'CXP'
				SELECT @CxID = f.DID
					  ,@CxMov = f.DMov
					  ,@CxMovID = f.DMovID
					  ,@CxEstatus = e.Estatus
				FROM MovFlujo f
					,Cxp e
				WHERE f.Cancelado = 0
				AND f.Empresa = @Empresa
				AND f.OModulo = @Modulo
				AND f.OID = @ID
				AND f.DModulo = @CxModulo
				AND f.DID = e.ID
				AND e.OrigenTipo IS NOT NULL
			ELSE

			IF @CxModulo = 'AGENT'
				SELECT @CxID = f.DID
					  ,@CxMov = f.DMov
					  ,@CxMovID = f.DMovID
				FROM MovFlujo f
					,Agent e
				WHERE f.Cancelado = 0
				AND f.Empresa = @Empresa
				AND f.OModulo = @Modulo
				AND f.OID = @ID
				AND f.DModulo = @CxModulo
				AND f.DID = e.ID
				AND e.OrigenTipo IS NOT NULL

			IF @@ROWCOUNT <> 0

				IF @CxID IS NULL
					SELECT @Ok = 60060
						  ,@OkRef = 'Origen: ' + RTRIM(@Mov) + ' ' + LTRIM(CONVERT(CHAR, @MovID)) + ' - Destino: ' + RTRIM(@CxMov) + ' ' + LTRIM(CONVERT(CHAR, @CxMovID))

			IF @CxModulo = 'CXC'
				AND @Modulo = 'EMB'
				AND @Accion = 'CANCELAR'
			BEGIN
				DECLARE
					@tempIDCobroEmbarque INT
				SELECT @tempIDCobroEmbarque = NULL
				SELECT @tempIDCobroEmbarque = ID
				FROM CXC
				WHERE Empresa = @Empresa
				AND Sucursal = @Sucursal
				AND Origen = @Mov
				AND OrigenID = @MovID
				AND OrigenTipo = 'EMB'
				AND Estatus = 'SINAFECTAR'

				IF @tempIDCobroEmbarque IS NOT NULL
				BEGIN
					DELETE Cxc
					WHERE ID = @tempIDCobroEmbarque
					DELETE CxcD
					WHERE ID = @tempIDCobroEmbarque
				END

			END

		END

	END

	IF @LineaCreditoExpress = 1
	BEGIN
		EXEC spLCExpress @CxModulo
						,@CxID
						,@LineaCredito OUTPUT

		IF @CxModulo = 'CXC'
			UPDATE Cxc
			SET LineaCredito = @LineaCredito
			WHERE ID = @CxID
		ELSE

		IF @CxModulo = 'CXP'
			UPDATE Cxp
			SET LineaCredito = @LineaCredito
			WHERE ID = @CxID

	END

	IF @CxModulo = 'AGENT'
		AND @Accion = 'CANCELAR'
	BEGIN
		EXEC spCx @CxID
				 ,@CxModulo
				 ,@Accion
				 ,'TODO'
				 ,@FechaRegistro
				 ,NULL
				 ,@Usuario
				 ,1
				 ,0
				 ,@CxMov OUTPUT
				 ,@CxMovID OUTPUT
				 ,@IDGenerar
				 ,@Ok = @Ok OUTPUT
				 ,@OkRef = @OkRef OUTPUT
	END

	IF @Ok IS NULL
		AND @CxID IS NOT NULL
		EXEC xpGenerarCx @Sucursal
						,@SucursalOrigen
						,@SucursalDestino
						,@Accion
						,@ModuloAfectar
						,@Empresa
						,@Modulo
						,@ID
						,@Mov
						,@MovID
						,@MovTipo
						,@MovMoneda
						,@MovTipoCambio
						,@FechaEmision
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
						,@Condicion
						,@Vencimiento
						,@Contacto
						,@EnviarA
						,@Agente
						,@Tipo
						,@CtaDinero
						,@FormaPago
						,@Importe
						,@Impuestos
						,@Retencion
						,@ComisionTotal
						,@Beneficiario
						,@Aplica
						,@AplicaMovID
						,@ImporteAplicar
						,@VIN
						,@MovEspecifico
						,@CxModulo
						,@CxMov
						,@CxMovID
						,@Ok OUTPUT
						,@OkRef OUTPUT
						,@INSTRUCCIONES_ESP
						,@IVAFiscal
						,@IEPSFiscal
						,@CxID
						,@ContUso

	IF (@Accion IN ('AFECTAR', 'CANCELAR') AND @Ok IS NULL AND @CxID IS NOT NULL AND @CxEstatus = 'SINAFECTAR')
		OR (@Accion IN ('CANCELAR') AND @Ok IS NULL AND @CxID IS NOT NULL AND @CxEstatus IN ('PENDIENTE', 'BORRADOR', 'CONCLUIDO'))
		OR (@Accion IN ('AFECTAR') AND @Ok IS NULL AND @CxID IS NOT NULL AND @CxEstatus IN ('BORRADOR'))
	BEGIN

		IF @Accion = 'CANCELAR'
			AND @EndosarA IS NOT NULL
			AND @CxModulo IN ('CXC', 'CXP')
		BEGIN
			SELECT @CxEndosoID = NULL

			IF @CxModulo = 'CXC'
				SELECT @CxEndosoID = ID
					  ,@CxEndosoMov = Mov
					  ,@CxEndosoMovID = MovID
				FROM Cxc
				WHERE Empresa = @Empresa
				AND Mov = @CxEndosoMov
				AND Cliente = @EndosarA
				AND OrigenTipo = @CxModulo
				AND Origen = @CxMov
				AND OrigenID = @CxMovID
				AND Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'CANCELADO')
			ELSE

			IF @CxModulo = 'CXP'
				SELECT @CxEndosoID = ID
					  ,@CxEndosoMov = Mov
					  ,@CxEndosoMovID = MovID
				FROM Cxp
				WHERE Empresa = @Empresa
				AND Mov = @CxEndosoMov
				AND Proveedor = @EndosarA
				AND OrigenTipo = @CxModulo
				AND Origen = @CxMov
				AND OrigenID = @CxMovID
				AND Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'CANCELADO')

			IF @CxEndosoID IS NOT NULL
				EXEC spCx @CxEndosoID
						 ,@CxModulo
						 ,@Accion
						 ,'TODO'
						 ,@FechaRegistro
						 ,NULL
						 ,@Usuario
						 ,1
						 ,0
						 ,@CxEndosoMov OUTPUT
						 ,@CxEndosoMovID OUTPUT
						 ,@IDGenerar OUTPUT
						 ,@Ok OUTPUT
						 ,@OkRef OUTPUT

		END

		IF @Ok IS NULL
		BEGIN

			IF NOT (@CxEstatus IN ('BORRADOR') AND @Accion IN ('AFECTAR'))
			BEGIN
				EXEC spCx @CxID
						 ,@CxModulo
						 ,@Accion
						 ,'TODO'
						 ,@FechaRegistro
						 ,NULL
						 ,@Usuario
						 ,1
						 ,0
						 ,@CxMov OUTPUT
						 ,@CxMovID OUTPUT
						 ,@IDGenerar OUTPUT
						 ,@Ok OUTPUT
						 ,@OkRef OUTPUT
						 ,@INSTRUCCIONES_ESP
			END

			EXEC spMovFlujo @Sucursal
						   ,@Accion
						   ,@Empresa
						   ,@Modulo
						   ,@ID
						   ,@Mov
						   ,@MovID
						   ,@CxModulo
						   ,@CxID
						   ,@CxMov
						   ,@CxMovID
						   ,@Ok OUTPUT
		END

	END

	IF @Endoso IS NOT NULL
		AND @CfgCompraAutoEndosoEmpresas = 1
		AND @Accion IN ('AFECTAR', 'CANCELAR')
		AND @Ok IS NULL
	BEGIN

		IF @CfgCompraAutoEndosoAutoCargos = 1
			SELECT @ProveedorAutoEndoso = @Contacto
				  ,@Contacto = @Endoso

		IF @CfgCompraAutoEndosoWS = 1
		BEGIN
			INSERT WSEnviar (WSDL, Estatus, EstatusFecha)
				VALUES (@CfgCompraAutoEndosoWSDL, 'SINAFECTAR', GETDATE())
			SELECT @EndosoID = SCOPE_IDENTITY()
			INSERT WSEnviarD (ID, Datos)
				SELECT @EndosoID
					  ,'<?xml version="1.0" encoding="UTF-8"?>'
			INSERT WSEnviarD (ID, Datos)
				SELECT @EndosoID
					  ,'<Intelisis>'
			INSERT WSEnviarD (ID, Datos)
				SELECT @EndosoID
					  ,'<Movimiento' +
					   dbo.fnXML('Version', '1.0') +
					   dbo.fnXML('Accion', @Accion) +
					   dbo.fnXML('Tipo', 'CompraAutoEndoso') +
					   dbo.fnXML('Empresa', @Empresa) +
					   dbo.fnXML('Endoso', @Endoso) +
					   dbo.fnXMLInt('Sucursal', @Sucursal) +
					   dbo.fnXML('Usuario', @Usuario) +
					   dbo.fnXML('Modulo', @CxModulo) +
					   dbo.fnXMLInt('ID', @CxID) +
					   dbo.fnXML('Mov', @CxMov) +
					   dbo.fnXML('MovID', @CxMovID) +
					   dbo.fnXML('MovTipo', @CxMovTipo) +
					   dbo.fnXMLDateTime('FechaEmision', @FechaEmision) +
					   dbo.fnXML('Condicion', @Condicion) +
					   dbo.fnXMLDateTime('Vencimiento', @Vencimiento) +
					   dbo.fnXML('Concepto', @Concepto) +
					   dbo.fnXML('Proyecto', @Proyecto) +
					   dbo.fnXML('Referencia', @Referencia) +
					   dbo.fnXML('Observaciones', @Observaciones) +
					   dbo.fnXML('Proveedor', @ContactoOriginal) +
					   dbo.fnXML('Moneda', @MovMoneda) +
					   dbo.fnXMLFloat('TipoCambio', @MovTipoCambio) +
					   dbo.fnXMLMoney('Importe', @Importe) +
					   dbo.fnXMLMoney('Impuestos', @Impuestos) +
					   dbo.fnXMLMoney('Retencion', @Retencion) +
					   dbo.fnXMLMoney('Retencion2', @Retencion2) +
					   dbo.fnXMLMoney('Retencion3', @Retencion3) +
					   dbo.fnXMLFloat('IVAFiscal', @IVAFiscal) +
					   dbo.fnXMLFloat('IEPSFiscal', @IEPSFiscal) +
					   '>'
			INSERT WSEnviarD (ID, Datos)
				SELECT @EndosoID
					  ,'<Proveedor' +
					   dbo.fnXML('Nombre', Nombre) +
					   dbo.fnXML('NombreCorto', NombreCorto) +
					   dbo.fnXML('Direccion', Direccion) +
					   dbo.fnXML('EntreCalles', EntreCalles) +
					   dbo.fnXML('Plano', Plano) +
					   dbo.fnXML('Observaciones', Observaciones) +
					   dbo.fnXML('Delegacion', Delegacion) +
					   dbo.fnXML('Colonia', Colonia) +
					   dbo.fnXML('Poblacion', Poblacion) +
					   dbo.fnXML('Estado', Estado) +
					   dbo.fnXML('Zona', Zona) +
					   dbo.fnXML('Pais', Pais) +
					   dbo.fnXML('CodigoPostal', CodigoPostal) +
					   dbo.fnXML('Telefonos', Telefonos) +
					   dbo.fnXML('Fax', Fax) +
					   dbo.fnXML('Contacto1', Contacto1) +
					   dbo.fnXML('Contacto2', Contacto2) +
					   dbo.fnXML('Extencion1', Extencion1) +
					   dbo.fnXML('Extencion2', Extencion2) +
					   dbo.fnXML('eMail1', eMail1) +
					   dbo.fnXML('eMail2', eMail2) +
					   dbo.fnXML('RFC', RFC) +
					   dbo.fnXML('CURP', CURP) +
					   dbo.fnXML('BeneficiarioNombre', BeneficiarioNombre) +
					   dbo.fnXML('LeyendaCheque', LeyendaCheque) +
					   '/>'
				FROM Prov
				WHERE Proveedor = @ContactoOriginal
			INSERT WSEnviarD (ID, Datos)
				SELECT @EndosoID
					  ,'</Movimiento>'
			INSERT WSEnviarD (ID, Datos)
				SELECT @EndosoID
					  ,'</Intelisis>'
			UPDATE WSEnviar
			SET Estatus = 'PENDIENTE'
			   ,EstatusFecha = GETDATE()
			WHERE ID = @EndosoID
		END
		ELSE
		BEGIN
			SELECT @EndosoID = NULL

			IF @Accion = 'CANCELAR'
				SELECT @EndosoID = ID
				FROM Cxp
				WHERE Empresa = @Endoso
				AND Mov = @CxMov
				AND MovID = @CxMovID
				AND Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'CANCELADO')
			ELSE
			BEGIN
				INSERT INTO Cxp (Sucursal, SucursalOrigen, SucursalDestino, Empresa, Mov, MovID, FechaEmision, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Autorizacion, Referencia, DocFuente, Observaciones, Estatus, UltimoCambio,
				Proveedor, ProveedorMoneda, ProveedorTipoCambio, Condicion, Vencimiento, CtaDinero, Importe, Impuestos, Retencion, Retencion2, Retencion3,
				FormaPago, Beneficiario,
				OrigenTipo, Origen, OrigenID, UEN, VIN, IVAFiscal, IEPSFiscal, Nota, AplicaManual)
					VALUES (@Sucursal, @SucursalOrigen, @SucursalDestino, @Endoso, @CxMov, @CxMovID, @FechaEmision, @Concepto, @Proyecto, @MovMoneda, @MovTipoCambio, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, 'SINAFECTAR', @FechaRegistro, @ContactoOriginal, @MovMoneda, @MovTipoCambio, @Condicion, @Vencimiento, @CtaDinero, @Importe, @Impuestos, @Retencion, @Retencion2, @Retencion3, @FormaPago, @Beneficiario, 'ENDOSO', @Origen, @OrigenID, @OrigenUEN, @VIN, @IVAFiscal, @IEPSFiscal, @Nota, @AplicaManual)
				SELECT @EndosoID = SCOPE_IDENTITY()

				IF @AplicaManual = 1
					INSERT INTO CxpD (Sucursal, ID, Renglon, RenglonSub, Aplica, AplicaID, Importe)
						VALUES (@Sucursal, @EndosoID, 2048.0, 0, @Aplica, @AplicaMovID, @ImporteAplicar)

			END

			IF @EndosoID IS NOT NULL
			BEGIN
				EXEC xpEndosoGenerado @Sucursal
									 ,@ID
									 ,@CxID
									 ,@EndosoID
									 ,'CXP'
									 ,@CxMovTipo
									 ,@Ok OUTPUT
									 ,@OkRef OUTPUT
				EXEC spCx @EndosoID
						 ,'CXP'
						 ,@Accion
						 ,'TODO'
						 ,@FechaRegistro
						 ,NULL
						 ,@Usuario
						 ,1
						 ,0
						 ,@CxMov OUTPUT
						 ,@CxMovID OUTPUT
						 ,@IDGenerar OUTPUT
						 ,@Ok OUTPUT
						 ,@OkRef OUTPUT
			END

			IF @Ok IS NULL
			BEGIN
				SELECT @EndosoID = NULL

				IF @Accion = 'CANCELAR'
					SELECT @EndosoID = ID
					FROM Cxc
					WHERE Empresa = @Endoso
					AND Mov = @CxMov
					AND MovID = @CxMovID
					AND Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'CANCELADO')
				ELSE
				BEGIN
					INSERT INTO Cxc (Sucursal, SucursalOrigen, SucursalDestino, Empresa, Mov, MovID, FechaEmision, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Autorizacion, Referencia, DocFuente, Observaciones, Estatus, UltimoCambio,
					Cliente, ClienteEnviarA, ClienteMoneda, ClienteTipoCambio, Condicion, Vencimiento, CtaDinero, Importe, Impuestos, Retencion, Retencion2, Retencion3,
					FormaCobro, Agente, Cajero, ComisionTotal, ComisionPendiente,
					OrigenTipo, Origen, OrigenID, UEN, VIN, IVAFiscal, IEPSFiscal, PersonalCobrador, Nota, LineaCredito, TipoAmortizacion, TipoTasa, TieneTasaEsp, TasaEsp, Comisiones, ComisionesIVA, AplicaManual)
						VALUES (@Sucursal, @SucursalOrigen, @SucursalDestino, @Endoso, @CxMov, @CxMovID, @FechaEmision, @Concepto, @Proyecto, @MovMoneda, @MovTipoCambio, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, 'SINAFECTAR', @FechaRegistro, @Empresa, NULL, @MovMoneda, @MovTipoCambio, @Condicion, @Vencimiento, @CtaDinero, @Importe, @Impuestos, @Retencion, @Retencion2, @Retencion3, @FormaPago, @Agente, @Agente, @ComisionTotal, @ComisionPendiente, 'ENDOSO', @Origen, @OrigenID, @OrigenUEN, @VIN, @IVAFiscal, @IEPSFiscal, @PersonalCobrador, @Nota, @LineaCredito, @TipoAmortizacion, @TipoTasa, @TieneTasaEsp, @TasaEsp, @Comisiones, @ComisionesIVA, @AplicaManual)
					SELECT @EndosoID = SCOPE_IDENTITY()

					IF @AplicaManual = 1
						INSERT INTO CxcD (Sucursal, ID, Renglon, RenglonSub, Aplica, AplicaID, Importe)
							VALUES (@Sucursal, @EndosoID, 2048.0, 0, @Aplica, @AplicaMovID, @ImporteAplicar)

				END

				IF @EndosoID IS NOT NULL
				BEGIN
					EXEC xpEndosoGenerado @Sucursal
										 ,@ID
										 ,@CxID
										 ,@EndosoID
										 ,'CXC'
										 ,@CxMovTipo
										 ,@Ok OUTPUT
										 ,@OkRef OUTPUT
					EXEC spCx @EndosoID
							 ,'CXC'
							 ,@Accion
							 ,'TODO'
							 ,@FechaRegistro
							 ,NULL
							 ,@Usuario
							 ,1
							 ,0
							 ,@CxMov OUTPUT
							 ,@CxMovID OUTPUT
							 ,@IDGenerar OUTPUT
							 ,@Ok OUTPUT
							 ,@OkRef OUTPUT
				END

			END

		END

	END

	IF @Accion <> 'CANCELAR'
		AND @EndosarA IS NOT NULL
		AND @CxModulo IN ('CXC', 'CXP')
	BEGIN
		EXEC spCx @CxID
				 ,@CxModulo
				 ,'GENERAR'
				 ,'TODO'
				 ,@FechaRegistro
				 ,@CxEndosoMov
				 ,@Usuario
				 ,1
				 ,0
				 ,@CxEndosoMov OUTPUT
				 ,@CxEndosoMovID OUTPUT
				 ,@CxEndosoID OUTPUT
				 ,@Ok OUTPUT
				 ,@OkRef OUTPUT

		IF @Ok = 80030
			SELECT @Ok = NULL
				  ,@OkRef = NULL

		IF @Ok IS NULL
		BEGIN

			IF @CxModulo = 'CXC'
				UPDATE Cxc
				SET FechaEmision = @FechaEmision
				   ,Cliente = @EndosarA
				   ,ClienteEnviarA = NULL
				WHERE ID = @CxEndosoID
			ELSE

			IF @CxModulo = 'CXP'
				UPDATE Cxp
				SET FechaEmision = @FechaEmision
				   ,Proveedor = @EndosarA
				WHERE ID = @CxEndosoID

			EXEC spCx @CxEndosoID
					 ,@CxModulo
					 ,'AFECTAR'
					 ,'TODO'
					 ,@FechaRegistro
					 ,NULL
					 ,@Usuario
					 ,1
					 ,0
					 ,@CxEndosoMov OUTPUT
					 ,@CxEndosoMovID OUTPUT
					 ,NULL
					 ,@Ok OUTPUT
					 ,@OkRef OUTPUT
		END

	END

	RETURN @CxID
END
GO