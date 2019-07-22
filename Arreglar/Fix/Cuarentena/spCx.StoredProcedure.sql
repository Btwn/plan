SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1 
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spCx]
 @ID INT
,@Modulo CHAR(5)
,@Accion CHAR(20)
,@Base CHAR(20)
,@FechaRegistro DATETIME
,@GenerarMov CHAR(20)
,@Usuario CHAR(10)
,@Conexion BIT
,@SincroFinal BIT
,@Mov CHAR(20) OUTPUT
,@MovID VARCHAR(20) OUTPUT
,@IDGenerar INT OUTPUT
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
,@INSTRUCCIONES_ESP VARCHAR(20) = NULL
,@EstacionTrabajo INT = NULL
AS
BEGIN
	DECLARE
		@Sucursal INT
	   ,@SucursalDestino INT
	   ,@SucursalOrigen INT
	   ,@EnLinea BIT
	   ,@PuedeEditar BIT
	   ,@Empresa CHAR(5)
	   ,@MovTipo CHAR(20)
	   ,@MovUsuario CHAR(10)
	   ,@FechaEmision DATETIME
	   ,@FechaAfectacion DATETIME
	   ,@FechaConclusion DATETIME
	   ,@Concepto VARCHAR(50)
	   ,@Proyecto VARCHAR(50)
	   ,@MovMoneda CHAR(10)
	   ,@MovTipoCambio FLOAT
	   ,@Autorizacion CHAR(10)
	   ,@Mensaje INT
	   ,@Referencia VARCHAR(50)
	   ,@DocFuente INT
	   ,@Observaciones VARCHAR(255)
	   ,@Estatus CHAR(15)
	   ,@Ejercicio INT
	   ,@Periodo INT
	   ,@FormaPago VARCHAR(50)
	   ,@CobroDesglosado MONEY
	   ,@CobroDelEfectivo MONEY
	   ,@CobroCambio MONEY
	   ,@ImpuestosPorcentaje MONEY
	   ,@RetencionPorcentaje MONEY
	   ,@IDOrigen INT
	   ,@OrigenTipo CHAR(10)
	   ,@Origen VARCHAR(20)
	   ,@OrigenID VARCHAR(20)
	   ,@OrigenMovTipo VARCHAR(20)
	   ,@ProveedorAutoEndoso VARCHAR(10)
	   ,@Nota VARCHAR(100)
	   ,@Condicion VARCHAR(50)
	   ,@Vencimiento DATETIME
	   ,@FechaProntoPago DATETIME
	   ,@DescuentoProntoPago FLOAT
	   ,@Contacto CHAR(10)
	   ,@ContactoEnviarA INT
	   ,@ContactoTipo CHAR(20)
	   ,@ContactoFactor FLOAT
	   ,@ContactoTipoCambio FLOAT
	   ,@ContactoMoneda CHAR(10)
	   ,@Importe MONEY
	   ,@ValesCobrados MONEY
	   ,@Impuestos MONEY
	   ,@Retencion MONEY
	   ,@Retencion2 MONEY
	   ,@Retencion3 MONEY
	   ,@Comisiones MONEY
	   ,@ComisionesIVA MONEY
	   ,@IVAFiscal FLOAT
	   ,@IEPSFiscal FLOAT
	   ,@CtaDinero CHAR(10)
	   ,@Cajero CHAR(10)
	   ,@Agente CHAR(10)
	   ,@Saldo MONEY
	   ,@SaldoInteresesOrdinarios MONEY
	   ,@SaldoInteresesMoratorios MONEY
	   ,@AplicaManual BIT
	   ,@ConDesglose BIT
	   ,@MovAplica CHAR(20)
	   ,@MovAplicaID VARCHAR(20)
	   ,@MovAplicaMovTipo CHAR(20)
	   ,@Beneficiario INT
	   ,@AgenteNomina BIT
	   ,@AgentePersonal CHAR(10)
	   ,@AgenteNominaMov CHAR(20)
	   ,@AgenteNominaConcepto VARCHAR(50)
	   ,@DineroID INT
	   ,@DineroMov CHAR(20)
	   ,@DineroMovID CHAR(20)
	   ,@DineroImporte MONEY
	   ,@CfgAplicaAutoOrden CHAR(20)
	   ,@CfgContX BIT
	   ,@CfgContXGenerar CHAR(20)
	   ,@CfgEmbarcar BIT
	   ,@CfgFormaCobroDA VARCHAR(50)
	   ,@AutoAjuste MONEY
	   ,@AutoAjusteMov MONEY
	   ,@CfgDescuentoRecargos BIT
	   ,@CfgRefinanciamientoTasa FLOAT
	   ,@CfgMovCargoDiverso CHAR(20)
	   ,@CfgMovCreditoDiverso CHAR(20)
	   ,@CfgVentaComisionesCobradas BIT
	   ,@CfgCobroImpuestos BIT
	   ,@CfgComisionBase CHAR(20)
	   ,@CfgComisionCreditos BIT
	   ,@CfgAnticiposFacturados BIT
	   ,@CfgVentaLimiteNivelSucursal BIT
	   ,@CfgSugerirProntoPago BIT
	   ,@CfgRetencionAlPago BIT
	   ,@CfgValidarPPMorosos BIT
	   ,@CfgRetencionMov CHAR(20)
	   ,@CfgRetencionAcreedor CHAR(10)
	   ,@CfgRetencionConcepto VARCHAR(50)
	   ,@CfgRetencion2Acreedor CHAR(10)
	   ,@CfgRetencion2Concepto VARCHAR(50)
	   ,@CfgRetencion3Acreedor CHAR(10)
	   ,@CfgRetencion3Concepto VARCHAR(50)
	   ,@CfgAgentAfectarGastos BIT
	   ,@CfgAC BIT
	   ,@GenerarGasto BIT
	   ,@GenerarPoliza BIT
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
	   ,@FormaCobroVales VARCHAR(50)
	   ,@Pagares BIT
	   ,@Aforo FLOAT
	   ,@Tasa VARCHAR(50)
	   ,@EstatusNuevo CHAR(15)
	   ,@AfectarCantidadA BIT
	   ,@AfectarCantidadPendiente BIT
	   ,@Generar BIT
	   ,@GenerarSerie CHAR(20)
	   ,@GenerarAfectado BIT
	   ,@GenerarCopia BIT
	   ,@GenerarMovID VARCHAR(20)
	   ,@Autorizar BIT
	   ,@Indirecto BIT
	   ,@RedondeoMonetarios INT
	   ,@LineaCredito VARCHAR(20)
	   ,@TipoAmortizacion VARCHAR(20)
	   ,@TipoTasa VARCHAR(20)
	   ,@RamaID INT
	   ,@SaldoInteresesOrdinariosIVA FLOAT
	   ,@SaldoInteresesMoratoriosIVA FLOAT
	   ,@EmidaCarrierID VARCHAR(255)
	   ,@CtaDineroOmision VARCHAR(10)
	SELECT @RedondeoMonetarios = dbo.fnRedondeoMonetarios()
	SELECT @AfectarCantidadA = 0
		  ,@AfectarCantidadPendiente = 0
		  ,@ConDesglose = 0
		  ,@Generar = 0
		  ,@GenerarSerie = NULL
		  ,@GenerarAfectado = 0
		  ,@GenerarCopia = 1
		  ,@CobroDesglosado = 0.0
		  ,@CobroDelEfectivo = 0.0
		  ,@CobroCambio = 0.0
		  ,@ValesCobrados = 0.0
		  ,@ImpuestosPorcentaje = 0.0
		  ,@RetencionPorcentaje = 0.0
		  ,@Retencion = 0.0
		  ,@Retencion2 = 0.0
		  ,@Retencion3 = 0.0
		  ,@ContactoTipo = NULL
		  ,@Autorizacion = NULL
		  ,@Mensaje = NULL
		  ,@ContactoEnviarA = NULL
		  ,@IDOrigen = NULL
		  ,@OrigenMovTipo = NULL
		  ,@ProveedorAutoEndoso = NULL
		  ,@Nota = NULL
		  ,@DineroID = NULL
		  ,@DineroMov = NULL
		  ,@DineroMovID = NULL
		  ,@DineroImporte = NULL
		  ,@IVAFiscal = NULL
		  ,@IEPSFiscal = NULL
		  ,@OrigenMovTipo = NULL
		  ,@Indirecto = 0
		  ,@Autorizar = 0
		  ,@ContactoTipoCambio = 0.0
		  ,@GenerarGasto = 0
		  ,@CfgContX = 0
		  ,@CfgContXGenerar = 'NO'
		  ,@CfgEmbarcar = 0
		  ,@Contacto = NULL
		  ,@Beneficiario = NULL
		  ,@Agente = NULL
		  ,@Cajero = NULL
		  ,@Saldo = 0.0
		  ,@SaldoInteresesOrdinarios = 0.0
		  ,@SaldoInteresesMoratorios = 0.0
		  ,@SaldoInteresesOrdinariosIVA = 0.0
		  ,@SaldoInteresesMoratoriosIVA = 0.0
		  ,@AplicaManual = 1
		  ,@AgenteNomina = 0

	IF @Accion = 'CANCELAR'
		SELECT @EstatusNuevo = 'CANCELADO'
	ELSE
		SELECT @EstatusNuevo = 'CONCLUIDO'

	IF @Modulo = 'CXC'
	BEGIN
		SELECT @OrigenTipo = NULLIF(RTRIM(OrigenTipo), '')
			  ,@Origen = NULLIF(RTRIM(Origen), '')
			  ,@OrigenID = NULLIF(RTRIM(OrigenID), '')
			  ,@Sucursal = Sucursal
			  ,@SucursalDestino = SucursalDestino
			  ,@SucursalOrigen = SucursalOrigen
			  ,@Empresa = Empresa
			  ,@MovID = MovID
			  ,@Mov = Mov
			  ,@FechaEmision = FechaEmision
			  ,@Concepto = Concepto
			  ,@Proyecto = Proyecto
			  ,@MovUsuario = Usuario
			  ,@MovMoneda = Moneda
			  ,@MovTipoCambio = TipoCambio
			  ,@Autorizacion = Autorizacion
			  ,@Referencia = Referencia
			  ,@DocFuente = DocFuente
			  ,@Observaciones = Observaciones
			  ,@Estatus = UPPER(Estatus)
			  ,@Condicion = NULLIF(RTRIM(Condicion), '')
			  ,@Vencimiento = Vencimiento
			  ,@FormaPago = NULLIF(RTRIM(FormaCobro), '')
			  ,@FechaProntoPago = FechaProntoPago
			  ,@DescuentoProntoPago = DescuentoProntoPago
			  ,@Contacto = NULLIF(RTRIM(Cliente), '')
			  ,@ContactoEnviarA = ClienteEnviarA
			  ,@ContactoMoneda = NULLIF(RTRIM(ClienteMoneda), '')
			  ,@ContactoTipoCambio = ISNULL(ClienteTipoCambio, 0.0)
			  ,@Importe = ISNULL(Importe, 0.0)
			  ,@Impuestos = ISNULL(Impuestos, 0.0)
			  ,@Retencion = ISNULL(Retencion, 0.0)
			  ,@Retencion2 = ISNULL(Retencion2, 0.0)
			  ,@Retencion3 = ISNULL(Retencion3, 0.0)
			  ,@CtaDinero = NULLIF(RTRIM(CtaDinero), '')
			  ,@Cajero = NULLIF(RTRIM(Cajero), '')
			  ,@Agente = NULLIF(RTRIM(Agente), '')
			  ,@Saldo = ISNULL(Saldo, 0.0)
			  ,@SaldoInteresesOrdinarios = ISNULL(SaldoInteresesOrdinarios, 0.0)
			  ,@SaldoInteresesMoratorios = ISNULL(SaldoInteresesMoratorios, 0.0)
			  ,@AplicaManual = AplicaManual
			  ,@ConDesglose = ConDesglose
			  ,@Importe1 = ISNULL(Importe1, 0.0)
			  ,@Importe2 = ISNULL(Importe2, 0.0)
			  ,@Importe3 = ISNULL(Importe3, 0.0)
			  ,@Importe4 = ISNULL(Importe4, 0.0)
			  ,@Importe5 = ISNULL(Importe5, 0.0)
			  ,@FormaCobro1 = RTRIM(FormaCobro1)
			  ,@FormaCobro2 = RTRIM(FormaCobro2)
			  ,@FormaCobro3 = RTRIM(FormaCobro3)
			  ,@FormaCobro4 = RTRIM(FormaCobro4)
			  ,@FormaCobro5 = RTRIM(FormaCobro5)
			  ,@CobroDelEfectivo = ISNULL(DelEfectivo, 0.0)
			  ,@CobroCambio = ISNULL(Cambio, 0.0)
			  ,@MovAplica = NULLIF(RTRIM(MovAplica), '')
			  ,@MovAplicaID = NULLIF(RTRIM(MovAplicaID), '')
			  ,@GenerarPoliza = GenerarPoliza
			  ,@Indirecto = Indirecto
			  ,@FechaConclusion = FechaConclusion
			  ,@IVAFiscal = IVAFiscal
			  ,@IEPSFiscal = IEPSFiscal
			  ,@Nota = Nota
			  ,@Tasa = NULLIF(RTRIM(Tasa), '')
			  ,@RamaID = NULLIF(RamaID, 0)
			  ,@LineaCredito = NULLIF(RTRIM(LineaCredito), '')
			  ,@TipoAmortizacion = NULLIF(RTRIM(TipoAmortizacion), '')
			  ,@TipoTasa = NULLIF(RTRIM(TipoTasa), '')
			  ,@Comisiones = ISNULL(Comisiones, 0.0)
			  ,@ComisionesIVA = ISNULL(ComisionesIVA, 0.0)
			  ,@SaldoInteresesOrdinariosIVA = ISNULL(SaldoInteresesOrdinariosIVA, 0.0)
			  ,@SaldoInteresesMoratoriosIVA = ISNULL(SaldoInteresesMoratoriosIVA, 0.0)
		FROM Cxc WITH(NOLOCK)
		WHERE ID = @ID
		SELECT @CobroDesglosado = @Importe1 + @Importe2 + @Importe3 + @Importe4 + @Importe5
		SELECT @FormaCobroVales = CxcFormaCobroVales
		FROM EmpresaCfg WITH(NOLOCK)
		WHERE Empresa = @Empresa

		IF @FormaCobro1 = @FormaCobroVales
			SELECT @ValesCobrados = @ValesCobrados + @Importe1

		IF @FormaCobro2 = @FormaCobroVales
			SELECT @ValesCobrados = @ValesCobrados + @Importe2

		IF @FormaCobro3 = @FormaCobroVales
			SELECT @ValesCobrados = @ValesCobrados + @Importe3

		IF @FormaCobro4 = @FormaCobroVales
			SELECT @ValesCobrados = @ValesCobrados + @Importe4

		IF @FormaCobro5 = @FormaCobroVales
			SELECT @ValesCobrados = @ValesCobrados + @Importe5

		SELECT @ContactoTipo = UPPER(Tipo)
			  ,@CfgDescuentoRecargos = DescuentoRecargos
		FROM Cte WITH(NOLOCK)
		WHERE Cliente = @Contacto
	END
	ELSE

	IF @Modulo = 'CXP'
	BEGIN
		SELECT @OrigenTipo = NULLIF(RTRIM(OrigenTipo), '')
			  ,@Origen = NULLIF(RTRIM(Origen), '')
			  ,@OrigenID = NULLIF(RTRIM(OrigenID), '')
			  ,@Sucursal = Sucursal
			  ,@SucursalDestino = SucursalDestino
			  ,@SucursalOrigen = SucursalOrigen
			  ,@Empresa = Empresa
			  ,@MovID = MovID
			  ,@Mov = Mov
			  ,@FechaEmision = FechaEmision
			  ,@Concepto = Concepto
			  ,@Proyecto = Proyecto
			  ,@MovUsuario = Usuario
			  ,@MovMoneda = Moneda
			  ,@MovTipoCambio = TipoCambio
			  ,@Autorizacion = NULLIF(RTRIM(Autorizacion), '')
			  ,@Mensaje = Mensaje
			  ,@Referencia = Referencia
			  ,@DocFuente = DocFuente
			  ,@Observaciones = Observaciones
			  ,@Estatus = UPPER(Estatus)
			  ,@Condicion = NULLIF(RTRIM(Condicion), '')
			  ,@Vencimiento = Vencimiento
			  ,@FormaPago = NULLIF(RTRIM(FormaPago), '')
			  ,@FechaProntoPago = FechaProntoPago
			  ,@DescuentoProntoPago = DescuentoProntoPago
			  ,@Contacto = NULLIF(RTRIM(Proveedor), '')
			  ,@ContactoMoneda = NULLIF(RTRIM(ProveedorMoneda), '')
			  ,@ContactoTipoCambio = ISNULL(ProveedorTipoCambio, 0.0)
			  ,@Importe = ISNULL(Importe, 0.0)
			  ,@Impuestos = ISNULL(Impuestos, 0.0)
			  ,@Retencion = ISNULL(Retencion, 0.0)
			  ,@Retencion2 = ISNULL(Retencion2, 0.0)
			  ,@Retencion3 = ISNULL(Retencion3, 0.0)
			  ,@CtaDinero = NULLIF(RTRIM(CtaDinero), '')
			  ,@Cajero = NULLIF(RTRIM(Cajero), '')
			  ,@Saldo = ISNULL(Saldo, 0.0)
			  ,@SaldoInteresesOrdinarios = ISNULL(SaldoInteresesOrdinarios, 0.0)
			  ,@SaldoInteresesMoratorios = ISNULL(SaldoInteresesMoratorios, 0.0)
			  ,@AplicaManual = AplicaManual
			  ,@MovAplica = NULLIF(RTRIM(MovAplica), '')
			  ,@MovAplicaID = NULLIF(RTRIM(MovAplicaID), '')
			  ,@GenerarPoliza = GenerarPoliza
			  ,@Indirecto = Indirecto
			  ,@Beneficiario = Beneficiario
			  ,@FechaConclusion = FechaConclusion
			  ,@IVAFiscal = IVAFiscal
			  ,@IEPSFiscal = IEPSFiscal
			  ,@ProveedorAutoEndoso = ProveedorAutoEndoso
			  ,@Nota = Nota
			  ,@Tasa = NULLIF(RTRIM(Tasa), '')
			  ,@RamaID = NULLIF(RamaID, 0)
			  ,@LineaCredito = NULLIF(RTRIM(LineaCredito), '')
			  ,@TipoAmortizacion = NULLIF(RTRIM(TipoAmortizacion), '')
			  ,@TipoTasa = NULLIF(RTRIM(TipoTasa), '')
			  ,@Comisiones = ISNULL(Comisiones, 0.0)
			  ,@ComisionesIVA = ISNULL(ComisionesIVA, 0.0)
			  ,@SaldoInteresesOrdinariosIVA = ISNULL(SaldoInteresesOrdinariosIVA, 0.0)
			  ,@SaldoInteresesMoratoriosIVA = ISNULL(SaldoInteresesMoratoriosIVA, 0.0)
			  ,@EmidaCarrierID = ISNULL(EmidaCarrierID, '')
		FROM Cxp WITH(NOLOCK)
		WHERE ID = @ID
		SELECT @ContactoTipo = UPPER(Tipo)
			  ,@CfgDescuentoRecargos = DescuentoRecargos
			  ,@Pagares = Pagares
			  ,@Aforo = ISNULL(Aforo, 0)
			  ,@CtaDineroOmision = NULLIF(CtaDinero, '')
		FROM Prov WITH(NOLOCK)
		WHERE Proveedor = @Contacto
	END
	ELSE

	IF @Modulo = 'AGENT'
	BEGIN
		SELECT @OrigenTipo = NULLIF(RTRIM(OrigenTipo), '')
			  ,@Origen = NULLIF(RTRIM(Origen), '')
			  ,@OrigenID = NULLIF(RTRIM(OrigenID), '')
			  ,@Sucursal = Sucursal
			  ,@SucursalDestino = SucursalDestino
			  ,@SucursalOrigen = SucursalOrigen
			  ,@Empresa = Empresa
			  ,@MovID = MovID
			  ,@Mov = Mov
			  ,@FechaEmision = FechaEmision
			  ,@Concepto = Concepto
			  ,@Proyecto = Proyecto
			  ,@MovUsuario = Usuario
			  ,@MovMoneda = Moneda
			  ,@MovTipoCambio = TipoCambio
			  ,@Autorizacion = Autorizacion
			  ,@Referencia = Referencia
			  ,@DocFuente = DocFuente
			  ,@Observaciones = Observaciones
			  ,@Estatus = UPPER(Estatus)
			  ,@FormaPago = NULLIF(RTRIM(FormaPago), '')
			  ,@Contacto = NULLIF(RTRIM(Agente), '')
			  ,@ContactoMoneda = NULLIF(RTRIM(Moneda), '')
			  ,@ContactoTipoCambio = ISNULL(TipoCambio, 0.0)
			  ,@Importe = ISNULL(Importe, 0.0)
			  ,@Impuestos = ISNULL(Impuestos, 0.0)
			  ,@Agente = NULLIF(RTRIM(Agente), '')
			  ,@ImpuestosPorcentaje = ISNULL(ImpuestosPorcentaje, 0.0)
			  ,@RetencionPorcentaje = ISNULL(RetencionPorcentaje, 0.0)
			  ,@CtaDinero = NULLIF(RTRIM(CtaDinero), '')
			  ,@Saldo = ISNULL(Saldo, 0.0)
			  ,@GenerarPoliza = GenerarPoliza
			  ,@FechaConclusion = FechaConclusion
		FROM Agent WITH(NOLOCK)
		WHERE ID = @ID
		SELECT @AgenteNomina = Nomina
			  ,@AgentePersonal = Personal
			  ,@AgenteNominaMov = NominaMov
			  ,@AgenteNominaConcepto = NominaConcepto
		FROM Agente WITH(NOLOCK)
		WHERE Agente = @Agente
	END

	IF @Accion = 'AUTORIZAR'
		SELECT @Autorizacion = @Usuario
			  ,@Accion = 'AFECTAR'

	IF @MovAplica IS NOT NULL
		SELECT @MovAplicaMovTipo = Clave
		FROM MovTipo WITH(NOLOCK)
		WHERE Modulo = @Modulo
		AND Mov = @MovAplica

	IF @ContactoTipo = 'ESTRUCTURA'
		SELECT @Ok = 20680

	IF NULLIF(RTRIM(@Usuario), '') IS NULL
		SELECT @Usuario = @MovUsuario

	IF @GenerarMov IS NOT NULL
		AND @Accion <> 'CANCELAR'
		SELECT @Generar = 1

	IF @Generar = 1
		AND @OrigenTipo <> 'CAM'
		SELECT @Cajero = DefCajero
			  ,@CtaDinero = DefCtaDinero
		FROM Usuario WITH(NOLOCK)
		WHERE Usuario = @Usuario

	IF @CtaDinero IS NULL
		AND @CtaDineroOmision IS NOT NULL
		SELECT @CtaDinero = @CtaDineroOmision

	EXEC spFechaAfectacion @Empresa
						  ,@Modulo
						  ,@ID
						  ,@Accion
						  ,@FechaEmision OUTPUT
						  ,@FechaRegistro
						  ,@FechaAfectacion OUTPUT
	EXEC spExtraerFecha @FechaAfectacion OUTPUT
	EXEC spMovTipo @Modulo
				  ,@Mov
				  ,@FechaAfectacion
				  ,@Empresa
				  ,@Estatus
				  ,@Concepto OUTPUT
				  ,@MovTipo OUTPUT
				  ,@Periodo OUTPUT
				  ,@Ejercicio OUTPUT
				  ,@Ok OUTPUT
				  ,@GenerarGasto = @GenerarGasto OUTPUT
	EXEC spMovOk @SincroFinal
				,@ID
				,@Estatus
				,@Sucursal
				,@Accion
				,@Empresa
				,@Usuario
				,@Modulo
				,@Mov
				,@FechaAfectacion
				,@FechaRegistro
				,@Ejercicio
				,@Periodo
				,@Proyecto
				,@Ok OUTPUT
				,@OkRef OUTPUT

	IF @OrigenTipo IS NOT NULL
		AND @Origen IS NOT NULL
	BEGIN
		EXEC spMovEnMaxID @OrigenTipo
						 ,@Empresa
						 ,@Origen
						 ,@OrigenID
						 ,@IDOrigen OUTPUT
						 ,@Ok OUTPUT
		SELECT @OrigenMovTipo = Clave
		FROM MovTipo WITH(NOLOCK)
		WHERE Modulo = @OrigenTipo
		AND Mov = @Origen
	END

	IF @Ok IS NULL
	BEGIN

		IF @SucursalDestino IS NOT NULL
			AND @SucursalDestino <> @Sucursal
			AND @Accion = 'AFECTAR'
		BEGIN
			EXEC spSucursalEnLinea @SucursalDestino
								  ,@EnLinea OUTPUT

			IF @EnLinea = 1
			BEGIN
				EXEC spMovConsecutivo @Sucursal
									 ,@SucursalOrigen
									 ,@SucursalDestino
									 ,@Empresa
									 ,@Usuario
									 ,@Modulo
									 ,@Ejercicio
									 ,@Periodo
									 ,@ID
									 ,@Mov
									 ,NULL
									 ,@Estatus
									 ,@Concepto
									 ,@Accion
									 ,@Conexion
									 ,@SincroFinal
									 ,@MovID OUTPUT
									 ,@Ok OUTPUT
									 ,@OkRef OUTPUT
				EXEC spAsignarSucursalEstatus @ID
											 ,@Modulo
											 ,@SucursalDestino
											 ,NULL
				SELECT @Sucursal = @SucursalDestino
			END
			ELSE
				SELECT @Accion = 'SINCRO'

		END

		IF @Estatus = 'SINCRO'
			AND @Accion = 'CANCELAR'
		BEGIN
			EXEC spPuedeEditarMovMatrizSucursal @Sucursal
											   ,@SucursalOrigen
											   ,@ID
											   ,@Modulo
											   ,@Empresa
											   ,@Usuario
											   ,@Mov
											   ,@Estatus
											   ,1
											   ,@PuedeEditar OUTPUT

			IF @PuedeEditar = 0
				SELECT @Ok = 60300
			ELSE
			BEGIN
				SELECT @Estatus = 'SINAFECTAR'
				EXEC spAsignarSucursalEstatus @ID
											 ,@Modulo
											 ,@Sucursal
											 ,'SINAFECTAR'
			END

		END

	END

	IF @MovTipo = 'CXC.AR'
	BEGIN

		IF @Accion <> 'VERIFICAR'
			BEGIN TRANSACTION

		IF EXISTS (SELECT * FROM CxcD d WITH(NOLOCK), Cxc e WITH(NOLOCK) WHERE d.ID = @ID AND d.Aplica = e.Mov AND d.AplicaID = e.MovID AND e.Empresa = @Empresa AND e.Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'CANCELADO') AND e.Sucursal <> @SucursalDestino)
			SELECT @Ok = 60390

	END

	IF (@Accion <> 'CANCELAR' AND @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'PENDIENTE'))
		OR (@Accion = 'CANCELAR' AND @Estatus IN ('CONCLUIDO', 'PENDIENTE'))
	BEGIN
		SELECT @CfgAplicaAutoOrden =
			   CASE @Modulo
				   WHEN 'CXC' THEN ISNULL(UPPER(RTRIM(CxcAplicaAutoOrden)), 'FECHA VENCIMIENTO')
				   WHEN 'CXP' THEN ISNULL(UPPER(RTRIM(CxpAplicaAutoOrden)), 'FECHA VENCIMIENTO')
				   WHEN 'AGENT' THEN ISNULL(UPPER(RTRIM(CxpAplicaAutoOrden)), 'FECHA VENCIMIENTO')
			   END
			  ,@AutoAjuste =
			   CASE @Modulo
				   WHEN 'CXC' THEN ISNULL(NULLIF(CxcAutoAjuste, 0.0), 0.01)
				   WHEN 'CXP' THEN ISNULL(NULLIF(CxpAutoAjuste, 0.0), 0.01)
				   WHEN 'AGENT' THEN ISNULL(NULLIF(CxpAutoAjuste, 0.0), 0.01)
			   END
			  ,@AutoAjusteMov =
			   CASE @Modulo
				   WHEN 'CXC' THEN ISNULL(NULLIF(CxcAutoAjusteMov, 0.0), 0.01)
				   WHEN 'CXP' THEN ISNULL(NULLIF(CxpAutoAjusteMov, 0.0), 0.01)
				   WHEN 'AGENT' THEN ISNULL(NULLIF(CxpAutoAjusteMov, 0.0), 0.01)
			   END
			  ,@CfgFormaCobroDA =
			   CASE @Modulo
				   WHEN 'CXC' THEN NULLIF(RTRIM(CxcFormaCobroDA), '')
				   WHEN 'CXP' THEN NULLIF(RTRIM(CxcFormaCobroDA), '')
				   ELSE NULL
			   END
			  ,@CfgRefinanciamientoTasa =
			   CASE @Modulo
				   WHEN 'CXC' THEN ISNULL(CxcRefinanciamientoTasa, 0.0)
				   ELSE NULL
			   END
			  ,@CfgVentaComisionesCobradas = VentaComisionesCobradas
			  ,@CfgComisionBase = UPPER(ComisionBase)
			  ,@CfgValidarPPMorosos = ISNULL(CxcValidarDescPPMorosos, 0)
		FROM EmpresaCfg WITH(NOLOCK)
		WHERE Empresa = @Empresa

		IF @@ERROR <> 0
			SELECT @Ok = 1

		SELECT @CfgAnticiposFacturados = CxcAnticiposFacturados
			  ,@CfgCobroImpuestos = CxcCobroImpuestos
			  ,@CfgComisionCreditos = CxcComisionCreditos
			  ,@CfgVentaLimiteNivelSucursal = VentaLimiteNivelSucursal
			  ,@CfgSugerirProntoPago = CxcSugerirProntoPago
			  ,@CfgRetencionAlPago = ISNULL(RetencionAlPago, 0)
			  ,@CfgRetencionAcreedor = NULLIF(RTRIM(GastoRetencionAcreedor), '')
			  ,@CfgRetencionConcepto = NULLIF(RTRIM(GastoRetencionConcepto), '')
			  ,@CfgRetencion2Acreedor = NULLIF(RTRIM(GastoRetencion2Acreedor), '')
			  ,@CfgRetencion2Concepto = NULLIF(RTRIM(GastoRetencion2Concepto), '')
			  ,@CfgRetencion3Acreedor = NULLIF(RTRIM(GastoRetencion3Acreedor), '')
			  ,@CfgRetencion3Concepto = NULLIF(RTRIM(GastoRetencion3Concepto), '')
			  ,@CfgAgentAfectarGastos = ISNULL(AgentAfectarGastos, 0)
		FROM EmpresaCfg2 WITH(NOLOCK)
		WHERE Empresa = @Empresa

		IF @@ERROR <> 0
			SELECT @Ok = 1

		SELECT @AutoAjuste = @AutoAjuste
		SELECT @CfgContX = ContX
			  ,@CfgAC = ISNULL(AC, 0)
		FROM EmpresaGral WITH(NOLOCK)
		WHERE Empresa = @Empresa

		IF @@ERROR <> 0
			SELECT @Ok = 1

		IF @CfgContX = 1
			SELECT @CfgContXGenerar = ContXGenerar
			FROM EmpresaCfgModulo WITH(NOLOCK)
			WHERE Empresa = @Empresa
			AND Modulo = @Modulo

		IF @@ERROR <> 0
			SELECT @Ok = 1

		SELECT @CfgRetencionMov =
		 CASE
			 WHEN @MovTipo = 'CXP.DC' THEN CxpDevRetencion
			 ELSE CxpRetencion
		 END
		FROM EmpresaCfgMov WITH(NOLOCK)
		WHERE Empresa = @Empresa

		IF @@ERROR <> 0
			SELECT @Ok = 1

		SELECT @CfgMovCargoDiverso = NULL
			  ,@CfgMovCreditoDiverso = NULL

		IF EXISTS (SELECT * FROM EmpresaCfgMovEsp WITH(NOLOCK) WHERE Empresa = @Empresa AND Asunto = 'EMB' AND Modulo = @Modulo AND Mov = @Mov)
			SELECT @CfgEmbarcar = 1

		IF @MovTipo IN ('CXC.NCP', 'CXP.NCP')
			SELECT @AplicaManual = 0

		IF @Accion <> 'CANCELAR'

			IF (@MovTipo IN ('CXC.A', 'CXC.AR', 'CXC.FAC', 'CXC.DAC', 'CXC.F', 'CXC.FA', 'CXC.AF', 'CXC.VV', 'CXC.IM', 'CXC.RM', 'CXC.CD', 'CXC.D', 'CXC.DM', 'CXC.DA', 'CXC.DP',
				'CXP.A', 'CXP.F', 'CXP.FAC', 'CXP.DAC', 'CXP.AF', 'CXP.CD', 'CXP.D', 'CXP.DM', 'CXP.PAG', 'CXP.DA', 'CXP.DP',
				'CXC.SD', 'CXC.SCH', 'CXP.SD', 'CXP.SCH',
				'AGENT.C', 'AGENT.D', 'AGENT.A'))
				OR (@MovTipo IN ('CXC.NC', 'CXC.NCD', 'CXC.NCF', 'CXC.CA', 'CXC.CAD', 'CXC.CAP', 'CXC.NCP', 'CXC.DV',
				'CXP.NC', 'CXP.NCD', 'CXP.NCF', 'CXP.CA', 'CXP.CAD', 'CXP.CAP', 'CXP.NCP') AND @AplicaManual = 0)
				SELECT @EstatusNuevo = 'PENDIENTE'

		EXEC spMoneda @Accion
					 ,@MovMoneda
					 ,@MovTipoCambio
					 ,@ContactoMoneda
					 ,@ContactoFactor
					 ,@ContactoTipoCambio
					 ,@Ok OUTPUT
		SELECT @ContactoFactor = @ContactoTipoCambio / @MovTipoCambio

		IF (@Conexion = 0 OR @Accion = 'CANCELAR')
			AND @Accion NOT IN ('GENERAR', 'CONSECUTIVO')
			AND @Ok IS NULL
		BEGIN
			EXEC spCxVerificar @ID
							  ,@Accion
							  ,@Empresa
							  ,@Usuario
							  ,@Autorizacion
							  ,@Mensaje
							  ,@Modulo
							  ,@Mov
							  ,@MovID
							  ,@MovTipo
							  ,@MovMoneda
							  ,@MovTipoCambio
							  ,@FechaEmision
							  ,@Condicion OUTPUT
							  ,@Vencimiento OUTPUT
							  ,@FormaPago
							  ,@Referencia
							  ,@Contacto
							  ,@ContactoTipo
							  ,@ContactoEnviarA
							  ,@ContactoMoneda
							  ,@ContactoFactor
							  ,@ContactoTipoCambio
							  ,@Importe
							  ,@ValesCobrados
							  ,@Impuestos
							  ,@Retencion
							  ,@Retencion2
							  ,@Retencion3
							  ,@Saldo
							  ,@CtaDinero
							  ,@Agente
							  ,@AplicaManual
							  ,@ConDesglose
							  ,@CobroDesglosado
							  ,@CobroDelEfectivo
							  ,@CobroCambio
							  ,@Indirecto
							  ,@Conexion
							  ,@SincroFinal
							  ,@Sucursal
							  ,@SucursalDestino
							  ,@SucursalOrigen
							  ,@EstatusNuevo
							  ,@AfectarCantidadPendiente
							  ,@AfectarCantidadA
							  ,@CfgContX
							  ,@CfgContXGenerar
							  ,@CfgEmbarcar
							  ,@AutoAjuste
							  ,@AutoAjusteMov
							  ,@CfgDescuentoRecargos
							  ,@CfgFormaCobroDA
							  ,@CfgRefinanciamientoTasa
							  ,@CfgAnticiposFacturados
							  ,@CfgValidarPPMorosos
							  ,@CfgAC
							  ,@Pagares
							  ,@OrigenTipo
							  ,@OrigenMovTipo
							  ,@MovAplica
							  ,@MovAplicaID
							  ,@MovAplicaMovTipo
							  ,@AgenteNomina
							  ,@RedondeoMonetarios
							  ,@Autorizar OUTPUT
							  ,@Ok OUTPUT
							  ,@OkRef OUTPUT
							  ,@INSTRUCCIONES_ESP
							  ,@EmidaCarrierID

			IF @Autorizar = 1
				AND @Modulo = 'CXP'
			BEGIN
				UPDATE Cxp WITH(ROWLOCK)
				SET Mensaje = @Ok
				WHERE ID = @ID
			END

			IF @Ok BETWEEN 80000 AND 89999
				AND @Accion IN ('AFECTAR', 'GENERAR', 'CANCELAR')
				SELECT @Ok = NULL
			ELSE

			IF @Accion = 'VERIFICAR'
				AND @Ok IS NULL
			BEGIN
				SELECT @Ok = 80000
				EXEC xpOk_80000 @Empresa
							   ,@Usuario
							   ,@Accion
							   ,@Modulo
							   ,@ID
							   ,@Ok OUTPUT
							   ,@OkRef OUTPUT
			END

		END

		IF @Estatus = 'PENDIENTE'
			AND @Accion = 'AFECTAR'
			AND @Ok IS NULL
			SELECT @Ok = 60040

		IF @Accion IN ('AFECTAR', 'GENERAR', 'CANCELAR', 'CONSECUTIVO', 'SINCRO')
			AND @Ok IS NULL
		BEGIN
			EXEC spCxAfectar @ID
							,@Accion
							,@Empresa
							,@Modulo
							,@Mov
							,@MovID OUTPUT
							,@MovTipo
							,@MovMoneda
							,@MovTipoCambio
							,@FechaEmision
							,@FechaAfectacion
							,@FechaConclusion
							,@Concepto
							,@Proyecto
							,@Usuario
							,@Autorizacion
							,@Referencia
							,@DocFuente
							,@Observaciones
							,@Estatus
							,@EstatusNuevo
							,@FechaRegistro
							,@Ejercicio
							,@Periodo
							,@Beneficiario
							,@Condicion
							,@Vencimiento
							,@FechaProntoPago
							,@DescuentoProntoPago
							,@FormaPago
							,@Contacto
							,@ContactoEnviarA
							,@ContactoMoneda
							,@ContactoFactor
							,@ContactoTipoCambio
							,@Importe
							,@ValesCobrados
							,@Impuestos
							,@Retencion
							,@Retencion2
							,@Retencion3
							,@Comisiones
							,@ComisionesIVA
							,@Saldo
							,@SaldoInteresesOrdinarios
							,@SaldoInteresesMoratorios
							,@CtaDinero
							,@Cajero
							,@Agente
							,@AplicaManual
							,@ConDesglose
							,@CobroDesglosado
							,@CobroDelEfectivo
							,@CobroCambio
							,@ImpuestosPorcentaje
							,@RetencionPorcentaje
							,@Aforo
							,@Tasa
							,@CfgAplicaAutoOrden
							,@AfectarCantidadPendiente
							,@AfectarCantidadA
							,@Conexion
							,@SincroFinal
							,@Sucursal
							,@SucursalDestino
							,@SucursalOrigen
							,@CfgRetencionAlPago
							,@CfgRetencionMov
							,@CfgRetencionAcreedor
							,@CfgRetencionConcepto
							,@CfgRetencion2Acreedor
							,@CfgRetencion2Concepto
							,@CfgRetencion3Acreedor
							,@CfgRetencion3Concepto
							,@CfgAgentAfectarGastos
							,@CfgContX
							,@CfgContXGenerar
							,@CfgEmbarcar
							,@AutoAjuste
							,@AutoAjusteMov
							,@CfgDescuentoRecargos
							,@CfgFormaCobroDA
							,@CfgMovCargoDiverso
							,@CfgMovCreditoDiverso
							,@CfgVentaComisionesCobradas
							,@CfgCobroImpuestos
							,@CfgComisionBase
							,@CfgComisionCreditos
							,@CfgVentaLimiteNivelSucursal
							,@CfgSugerirProntoPago
							,@CfgAC
							,@GenerarGasto
							,@GenerarPoliza
							,@IDOrigen
							,@OrigenTipo
							,@OrigenMovTipo
							,@MovAplica
							,@MovAplicaID
							,@MovAplicaMovTipo
							,@AgenteNomina
							,@AgentePersonal
							,@AgenteNominaMov
							,@AgenteNominaConcepto
							,@IVAFiscal
							,@IEPSFiscal
							,@ProveedorAutoEndoso
							,@RamaID
							,@LineaCredito
							,@TipoAmortizacion
							,@TipoTasa
							,@Generar
							,@GenerarMov OUTPUT
							,@GenerarSerie
							,@GenerarAfectado
							,@GenerarCopia
							,@RedondeoMonetarios
							,@IDGenerar OUTPUT
							,@GenerarMovID OUTPUT
							,@Ok OUTPUT
							,@OkRef OUTPUT
							,@INSTRUCCIONES_ESP
							,@Nota
							,@Base = @Base
							,@Origen = @Origen
							,@OrigenID = @OrigenID
							,@SaldoInteresesOrdinariosIVA = @SaldoInteresesOrdinariosIVA
							,@SaldoInteresesMoratoriosIVA = @SaldoInteresesMoratoriosIVA
							,@EstacionTrabajo = @EstacionTrabajo

			IF @Generar = 1
			BEGIN
				EXEC spMovFlujo @Sucursal
							   ,@Accion
							   ,@Empresa
							   ,@Modulo
							   ,@ID
							   ,@Mov
							   ,@MovID
							   ,@Modulo
							   ,@IDGenerar
							   ,@GenerarMov
							   ,@GenerarMovID
							   ,@Ok OUTPUT

				IF @Ok IS NULL
					AND @Accion <> 'CANCELAR'
					SELECT @Ok = 80030
						  ,@Mov = @GenerarMov

			END

		END

	END
	ELSE

	IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR')
		AND @Accion = 'CANCELAR'
		EXEC spMovCancelarSinAfectar @Modulo
									,@ID
									,@Ok OUTPUT
	ELSE

	IF @Estatus = 'AFECTANDO'
		SELECT @Ok = 80020
	ELSE

	IF @Estatus = 'CONCLUIDO'
		SELECT @Ok = 80010
	ELSE
		SELECT @Ok = 60040

	IF @Accion = 'SINCRO'
		AND @Ok = 80060
	BEGIN
		SELECT @Ok = NULL
			  ,@OkRef = NULL
		EXEC spSucursalEnLinea @SucursalDestino
							  ,@EnLinea OUTPUT

		IF @EnLinea = 1
			EXEC spSincroFinalModulo @Modulo
									,@ID
									,@Ok OUTPUT
									,@OkRef OUTPUT

	END

	IF @MovTipo = 'CXC.AR'
		AND @Accion <> 'VERIFICAR'
	BEGIN

		IF @Accion IN ('SINCRO', 'CANCELAR')
		BEGIN

			IF @Ok IN (80030, 80060)
				SELECT @Ok = NULL

			IF @ConDesglose = 1
				AND @CobroDelEfectivo > 0.0
				SELECT @Ok = 60380
			ELSE
			BEGIN
				SELECT @DineroImporte = @Importe + @Impuestos - @Retencion - @Retencion2 - @Retencion3
				EXEC @DineroID = spGenerarDinero @Sucursal
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
												,NULL
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
												,@Nota = @Nota

				IF @Ok = 80030
					SELECT @Ok = NULL
						  ,@OkRef = NULL

				IF @Ok IS NULL
					EXEC spMovFlujo @Sucursal
								   ,@Accion
								   ,@Empresa
								   ,@Modulo
								   ,@ID
								   ,@Mov
								   ,@MovID
								   ,'DIN'
								   ,@DineroID
								   ,@DineroMov
								   ,@DineroMovID
								   ,@Ok OUTPUT

			END

		END
		ELSE

		IF @SucursalOrigen = @Sucursal
			SELECT @Ok = 60370

		IF @Ok IN (NULL, 80030, 80060)
			COMMIT TRANSACTION
		ELSE
			ROLLBACK TRANSACTION

	END

	IF @Ok IS NOT NULL
		AND @OkRef IS NULL

		IF @Ok = 80030
			SELECT @OkRef = 'Movimiento: ' + RTRIM(@GenerarMov) + ' ' + LTRIM(CONVERT(CHAR, @GenerarMovID))
		ELSE
			SELECT @OkRef = 'Movimiento: ' + RTRIM(@Mov) + ' ' + LTRIM(CONVERT(CHAR, @MovID))
				  ,@IDGenerar = NULL

	RETURN ISNULL(@IDGenerar, 0)
END
GO