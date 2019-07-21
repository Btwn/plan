SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCx
@ID                  	int,
@Modulo	      		char(5),
@Accion			char(20),
@Base			char(20),
@FechaRegistro		datetime,
@GenerarMov			char(20),
@Usuario			char(10),
@Conexion			bit,
@SincroFinal			bit,
@Mov	      			char(20)	OUTPUT,
@MovID            		varchar(20)	OUTPUT,
@IDGenerar			int		OUTPUT,
@Ok				int		OUTPUT,
@OkRef			varchar(255)	OUTPUT,
@INSTRUCCIONES_ESP		varchar(20) 	= NULL,
@EstacionTrabajo				int = NULL 

AS BEGIN
DECLARE
@Sucursal			int,
@SucursalDestino		int,
@SucursalOrigen		int,
@EnLinea			bit,
@PuedeEditar		bit,
@Empresa	      		char(5),
@MovTipo   			char(20),
@MovUsuario			char(10),
@FechaEmision     		datetime,
@FechaAfectacion		datetime,
@FechaConclusion		datetime,
@Concepto	      		varchar(50),
@Proyecto	      		varchar(50),
@MovMoneda	      		char(10),
@MovTipoCambio	   	float,
@Autorizacion     		char(10),
@Mensaje			int,
@Referencia	      		varchar(50),
@DocFuente	      		int,
@Observaciones    		varchar(255),
@Estatus          		char(15),
@Ejercicio	      		int,
@Periodo	      		int,
@FormaPago			varchar(50),
@CobroDesglosado		money,
@CobroDelEfectivo		money,
@CobroCambio		money,
@ImpuestosPorcentaje	money,
@RetencionPorcentaje	money,
@IDOrigen			int,
@OrigenTipo			char(10),
@Origen			varchar(20),
@OrigenID			varchar(20),
@OrigenMovTipo		varchar(20),
@ProveedorAutoEndoso	varchar(10),
@Nota			varchar(100),
@Condicion			varchar(50),
@Vencimiento		datetime,
@FechaProntoPago		datetime,
@DescuentoProntoPago	float,
@Contacto			char(10),
@ContactoEnviarA		int,
@ContactoTipo		char(20),
@ContactoFactor		float,
@ContactoTipoCambio		float,
@ContactoMoneda		char(10),
@Importe   			money,
@ValesCobrados		money,
@Impuestos	        	money,
@Retencion 			money,
@Retencion2			money,
@Retencion3			money,
@Comisiones			money,
@ComisionesIVA		money,
@IVAFiscal			float,
@IEPSFiscal			float,
@CtaDinero			char(10),
@Cajero			char(10),
@Agente			char(10),
@Saldo			money,
@SaldoInteresesOrdinarios	money,
@SaldoInteresesMoratorios	money,
@AplicaManual               bit,
@ConDesglose		bit,
@MovAplica			char(20),
@MovAplicaID		varchar(20),
@MovAplicaMovTipo		char(20),
@Beneficiario		int,
@AgenteNomina		bit,
@AgentePersonal		char(10),
@AgenteNominaMov	 	char(20),
@AgenteNominaConcepto	varchar(50),
@DineroID			int,
@DineroMov			char(20),
@DineroMovID		char(20),
@DineroImporte		money,
@CfgAplicaAutoOrden		char(20),
@CfgContX			bit,
@CfgContXGenerar		char(20),
@CfgEmbarcar		bit,
@CfgFormaCobroDA		varchar(50),
@AutoAjuste			money,
@AutoAjusteMov		money,
@CfgDescuentoRecargos	bit,
@CfgRefinanciamientoTasa 	float,
@CfgMovCargoDiverso		char(20),
@CfgMovCreditoDiverso	char(20),
@CfgVentaComisionesCobradas bit,
@CfgCobroImpuestos		bit,
@CfgComisionBase		char(20),
@CfgComisionCreditos	bit,
@CfgAnticiposFacturados	bit,
@CfgVentaLimiteNivelSucursal bit,
@CfgSugerirProntoPago	bit,
@CfgRetencionAlPago		bit,
@CfgValidarPPMorosos	bit,
@CfgRetencionMov		char(20),
@CfgRetencionAcreedor	char(10),
@CfgRetencionConcepto	varchar(50),
@CfgRetencion2Acreedor	char(10),
@CfgRetencion2Concepto	varchar(50),
@CfgRetencion3Acreedor	char(10),
@CfgRetencion3Concepto	varchar(50),
@CfgAgentAfectarGastos	bit,
@CfgAC			bit,
@GenerarGasto		bit,
@GenerarPoliza		bit,
@Importe1			money,
@Importe2			money,
@Importe3			money,
@Importe4			money,
@Importe5			money,
@FormaCobro1		varchar(50),
@FormaCobro2		varchar(50),
@FormaCobro3		varchar(50),
@FormaCobro4		varchar(50),
@FormaCobro5		varchar(50),
@FormaCobroVales		varchar(50),
@Pagares			bit,
@Aforo			float,
@Tasa			varchar(50),
@EstatusNuevo	      	char(15),
@AfectarCantidadA   	bit,
@AfectarCantidadPendiente  	bit,
@Generar                    bit,
@GenerarSerie		char(20),
@GenerarAfectado		bit,
@GenerarCopia		bit,
@GenerarMovID		varchar(20),
@Autorizar			bit,
@Indirecto			bit,
@RedondeoMonetarios		int,
@LineaCredito		varchar(20),
@TipoAmortizacion		varchar(20),
@TipoTasa			varchar(20),
@RamaID			int,
@SaldoInteresesOrdinariosIVA	float,  
@SaldoInteresesMoratoriosIVA	float,   
@EmidaCarrierID	varchar(255), 
@CtaDineroOmision	varchar(10)  
SELECT @RedondeoMonetarios = dbo.fnRedondeoMonetarios()
SELECT @AfectarCantidadA 	   = 0,
@AfectarCantidadPendiente = 0,
@ConDesglose  		   = 0,
@Generar		   = 0,
@GenerarSerie		   = NULL,
@GenerarAfectado	   = 0,
@GenerarCopia		   = 1,
@CobroDesglosado	   = 0.0,
@CobroDelEfectivo	   = 0.0,
@CobroCambio		   = 0.0,
@ValesCobrados		   = 0.0,
@ImpuestosPorcentaje	   = 0.0,
@RetencionPorcentaje	   = 0.0,
@Retencion		   = 0.0,
@Retencion2		   = 0.0,
@Retencion3		   = 0.0,
@ContactoTipo		   = NULL,
@Autorizacion		   = NULL,
@Mensaje		   = NULL,
@ContactoEnviarA	   = NULL,
@IDOrigen		   = NULL,
@OrigenMovTipo		   = NULL,
@ProveedorAutoEndoso	   = NULL,
@Nota 			   = NULL,
@DineroID		   = NULL,
@DineroMov		   = NULL,
@DineroMovID		   = NULL,
@DineroImporte		   = NULL,
@IVAFiscal		   = NULL,
@IEPSFiscal		   = NULL,
@OrigenMovTipo		   = NULL,
@Indirecto		   = 0,
@Autorizar		   = 0,
@ContactoTipoCambio	   = 0.0,
@GenerarGasto		   = 0,
@CfgContX		   = 0,
@CfgContXGenerar	   = 'NO',
@CfgEmbarcar		   = 0,
@Contacto		   = NULL,
@Beneficiario		   = NULL,
@Agente	           = NULL,
@Cajero		   = NULL,
@Saldo 	           = 0.0,
@SaldoInteresesOrdinarios = 0.0,
@SaldoInteresesMoratorios = 0.0,
@SaldoInteresesOrdinariosIVA = 0.0, 
@SaldoInteresesMoratoriosIVA = 0.0, 
@AplicaManual	           = 1,
@AgenteNomina		   = 0/*,
@Verificar		   = 1*/
IF @Accion = 'CANCELAR' SELECT @EstatusNuevo = 'CANCELADO' ELSE SELECT @EstatusNuevo = 'CONCLUIDO'
IF @Modulo = 'CXC'
BEGIN
SELECT @OrigenTipo = NULLIF(RTRIM(OrigenTipo), ''), @Origen = NULLIF(RTRIM(Origen), ''), @OrigenID = NULLIF(RTRIM(OrigenID), ''), @Sucursal = Sucursal, @SucursalDestino = SucursalDestino, @SucursalOrigen = SucursalOrigen, @Empresa = Empresa, @MovID = MovID, @Mov = Mov, @FechaEmision = FechaEmision, @Concepto = Concepto, @Proyecto = Proyecto,
@MovUsuario = Usuario, @MovMoneda = Moneda, @MovTipoCambio = TipoCambio, @Autorizacion = Autorizacion, @Referencia = Referencia,
@DocFuente = DocFuente, @Observaciones = Observaciones, @Estatus = UPPER(Estatus), @Condicion = NULLIF(RTRIM(Condicion), ''), @Vencimiento = Vencimiento, @FormaPago = NULLIF(RTRIM(FormaCobro), ''),
@FechaProntoPago = FechaProntoPago, @DescuentoProntoPago = DescuentoProntoPago,
@Contacto = NULLIF(RTRIM(Cliente), ''), @ContactoEnviarA = ClienteEnviarA, @ContactoMoneda = NULLIF(RTRIM(ClienteMoneda), ''), @ContactoTipoCambio = ISNULL(ClienteTipoCambio, 0.0), @Importe = ISNULL(Importe, 0.0), @Impuestos = ISNULL(Impuestos, 0.0), @Retencion = ISNULL(Retencion, 0.0), @Retencion2 = ISNULL(Retencion2, 0.0), @Retencion3 = ISNULL(Retencion3, 0.0),
@CtaDinero = NULLIF(RTRIM(CtaDinero), ''), @Cajero = NULLIF(RTRIM(Cajero), ''), @Agente = NULLIF(RTRIM(Agente), ''), @Saldo = ISNULL(Saldo, 0.0), @SaldoInteresesOrdinarios = ISNULL(SaldoInteresesOrdinarios, 0.0), @SaldoInteresesMoratorios = ISNULL(SaldoInteresesMoratorios, 0.0), @AplicaManual = AplicaManual, @ConDesglose = ConDesglose,
@Importe1 = ISNULL(Importe1, 0.0), @Importe2 = ISNULL(Importe2, 0.0), @Importe3 = ISNULL(Importe3, 0.0), @Importe4 = ISNULL(Importe4, 0.0), @Importe5 = ISNULL(Importe5, 0.0),
@FormaCobro1 = RTRIM(FormaCobro1), @FormaCobro2 = RTRIM(FormaCobro2), @FormaCobro3 = RTRIM(FormaCobro3), @FormaCobro4 = RTRIM(FormaCobro4), @FormaCobro5 = RTRIM(FormaCobro5),
@CobroDelEfectivo = ISNULL(DelEfectivo, 0.0), @CobroCambio = ISNULL(Cambio, 0.0),
@MovAplica = NULLIF(RTRIM(MovAplica), ''), @MovAplicaID = NULLIF(RTRIM(MovAplicaID), ''),
@GenerarPoliza = GenerarPoliza, @Indirecto = Indirecto, @FechaConclusion = FechaConclusion,
@IVAFiscal = IVAFiscal, @IEPSFiscal = IEPSFiscal, @Nota = Nota, @Tasa = NULLIF(RTRIM(Tasa), ''),
@RamaID = NULLIF(RamaID, 0), @LineaCredito = NULLIF(RTRIM(LineaCredito), ''), @TipoAmortizacion = NULLIF(RTRIM(TipoAmortizacion), ''), @TipoTasa = NULLIF(RTRIM(TipoTasa), ''),
@Comisiones = ISNULL(Comisiones, 0.0), @ComisionesIVA = ISNULL(ComisionesIVA, 0.0), @SaldoInteresesOrdinariosIVA = ISNULL(SaldoInteresesOrdinariosIVA,0.0), @SaldoInteresesMoratoriosIVA = ISNULL(SaldoInteresesMoratoriosIVA,0.0) 
FROM Cxc
WHERE ID = @ID
SELECT @CobroDesglosado = @Importe1 + @Importe2 + @Importe3 + @Importe4 + @Importe5
SELECT @FormaCobroVales = CxcFormaCobroVales FROM EmpresaCfg WHERE Empresa = @Empresa
IF @FormaCobro1 = @FormaCobroVales SELECT @ValesCobrados = @ValesCobrados + @Importe1
IF @FormaCobro2 = @FormaCobroVales SELECT @ValesCobrados = @ValesCobrados + @Importe2
IF @FormaCobro3 = @FormaCobroVales SELECT @ValesCobrados = @ValesCobrados + @Importe3
IF @FormaCobro4 = @FormaCobroVales SELECT @ValesCobrados = @ValesCobrados + @Importe4
IF @FormaCobro5 = @FormaCobroVales SELECT @ValesCobrados = @ValesCobrados + @Importe5
SELECT @ContactoTipo = UPPER(Tipo),
@CfgDescuentoRecargos = DescuentoRecargos
FROM Cte
WHERE Cliente = @Contacto
END ELSE
IF @Modulo = 'CXP'
BEGIN
SELECT @OrigenTipo = NULLIF(RTRIM(OrigenTipo), ''), @Origen = NULLIF(RTRIM(Origen), ''), @OrigenID = NULLIF(RTRIM(OrigenID), ''), @Sucursal = Sucursal, @SucursalDestino = SucursalDestino, @SucursalOrigen = SucursalOrigen, @Empresa = Empresa, @MovID = MovID, @Mov = Mov, @FechaEmision = FechaEmision, @Concepto = Concepto, @Proyecto = Proyecto,
@MovUsuario = Usuario, @MovMoneda = Moneda, @MovTipoCambio = TipoCambio, @Autorizacion = NULLIF(RTRIM(Autorizacion), ''), @Mensaje = Mensaje, @Referencia = Referencia,
@DocFuente = DocFuente, @Observaciones = Observaciones, @Estatus = UPPER(Estatus), @Condicion = NULLIF(RTRIM(Condicion), ''), @Vencimiento = Vencimiento, @FormaPago = NULLIF(RTRIM(FormaPago), ''),
@FechaProntoPago = FechaProntoPago, @DescuentoProntoPago = DescuentoProntoPago,
@Contacto = NULLIF(RTRIM(Proveedor), ''), @ContactoMoneda = NULLIF(RTRIM(ProveedorMoneda), ''), @ContactoTipoCambio = ISNULL(ProveedorTipoCambio, 0.0), @Importe = ISNULL(Importe, 0.0), @Impuestos = ISNULL(Impuestos, 0.0), @Retencion = ISNULL(Retencion, 0.0), @Retencion2 = ISNULL(Retencion2, 0.0), @Retencion3 = ISNULL(Retencion3, 0.0),
@CtaDinero = NULLIF(RTRIM(CtaDinero), ''), @Cajero = NULLIF(RTRIM(Cajero), ''), @Saldo = ISNULL(Saldo, 0.0), @SaldoInteresesOrdinarios = ISNULL(SaldoInteresesOrdinarios, 0.0), @SaldoInteresesMoratorios = ISNULL(SaldoInteresesMoratorios, 0.0), @AplicaManual = AplicaManual,
@MovAplica = NULLIF(RTRIM(MovAplica), ''), @MovAplicaID = NULLIF(RTRIM(MovAplicaID), ''),
@GenerarPoliza = GenerarPoliza, @Indirecto = Indirecto, @Beneficiario = Beneficiario, @FechaConclusion = FechaConclusion,
@IVAFiscal = IVAFiscal, @IEPSFiscal = IEPSFiscal, @ProveedorAutoEndoso = ProveedorAutoEndoso, @Nota = Nota, @Tasa = NULLIF(RTRIM(Tasa), ''),
@RamaID = NULLIF(RamaID, 0), @LineaCredito = NULLIF(RTRIM(LineaCredito), ''), @TipoAmortizacion = NULLIF(RTRIM(TipoAmortizacion), ''), @TipoTasa = NULLIF(RTRIM(TipoTasa), ''),
@Comisiones = ISNULL(Comisiones, 0.0), @ComisionesIVA = ISNULL(ComisionesIVA, 0.0), @SaldoInteresesOrdinariosIVA = ISNULL(SaldoInteresesOrdinariosIVA,0.0), @SaldoInteresesMoratoriosIVA = ISNULL(SaldoInteresesMoratoriosIVA,0.0), 
@EmidaCarrierID =ISNULL(EmidaCarrierID,'') 
FROM Cxp
WHERE ID = @ID
SELECT @ContactoTipo = UPPER(Tipo),
@CfgDescuentoRecargos = DescuentoRecargos,
@Pagares = Pagares,
@Aforo   = ISNULL(Aforo, 0),
@CtaDineroOmision = NULLIF(CtaDinero, '')  
FROM Prov
WHERE Proveedor = @Contacto
END ELSE
IF @Modulo = 'AGENT'
BEGIN
SELECT @OrigenTipo = NULLIF(RTRIM(OrigenTipo), ''), @Origen = NULLIF(RTRIM(Origen), ''), @OrigenID = NULLIF(RTRIM(OrigenID), ''), @Sucursal = Sucursal, @SucursalDestino = SucursalDestino, @SucursalOrigen = SucursalOrigen, @Empresa = Empresa, @MovID = MovID, @Mov = Mov, @FechaEmision = FechaEmision, @Concepto = Concepto, @Proyecto = Proyecto,
@MovUsuario = Usuario, @MovMoneda = Moneda, @MovTipoCambio = TipoCambio, @Autorizacion = Autorizacion, @Referencia = Referencia,
@DocFuente = DocFuente, @Observaciones = Observaciones, @Estatus = UPPER(Estatus), @FormaPago = NULLIF(RTRIM(FormaPago), ''),
@Contacto = NULLIF(RTRIM(Agente), ''), @ContactoMoneda = NULLIF(RTRIM(Moneda), ''), @ContactoTipoCambio = ISNULL(TipoCambio, 0.0), @Importe = ISNULL(Importe, 0.0), @Impuestos = ISNULL(Impuestos, 0.0),
@Agente = NULLIF(RTRIM(Agente), ''), @ImpuestosPorcentaje = ISNULL(ImpuestosPorcentaje, 0.0), @RetencionPorcentaje = ISNULL(RetencionPorcentaje, 0.0),
@CtaDinero = NULLIF(RTRIM(CtaDinero), ''), @Saldo = ISNULL(Saldo, 0.0),
@GenerarPoliza = GenerarPoliza, @FechaConclusion = FechaConclusion
FROM Agent
WHERE ID = @ID
SELECT @AgenteNomina    	= Nomina,
@AgentePersonal  	= Personal,
@AgenteNominaMov 	= NominaMov,
@AgenteNominaConcepto= NominaConcepto
FROM Agente
WHERE Agente = @Agente
END
IF @Accion = 'AUTORIZAR'
SELECT @Autorizacion = @Usuario, @Accion = 'AFECTAR'
IF @MovAplica IS NOT NULL
SELECT @MovAplicaMovTipo = Clave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @MovAplica
IF @ContactoTipo = 'ESTRUCTURA' SELECT @Ok = 20680
IF NULLIF(RTRIM(@Usuario), '') IS NULL SELECT @Usuario = @MovUsuario
IF @GenerarMov IS NOT NULL AND @Accion <> 'CANCELAR'
SELECT @Generar = 1
IF @Generar = 1 AND @OrigenTipo <> 'CAM'
SELECT @Cajero = DefCajero, @CtaDinero = ISNULL(@CtaDinero,DefCtaDinero) FROM Usuario WHERE Usuario = @Usuario
IF @CtaDinero IS NULL AND @CtaDineroOmision IS NOT NULL
SELECT @CtaDinero = @CtaDineroOmision
EXEC spFechaAfectacion @Empresa, @Modulo, @ID, @Accion, @FechaEmision OUTPUT, @FechaRegistro, @FechaAfectacion OUTPUT
EXEC spExtraerFecha @FechaAfectacion OUTPUT
EXEC spMovTipo @Modulo, @Mov, @FechaAfectacion, @Empresa, @Estatus, @Concepto OUTPUT, @MovTipo OUTPUT, @Periodo OUTPUT, @Ejercicio OUTPUT, @Ok OUTPUT, @GenerarGasto = @GenerarGasto OUTPUT
EXEC spMovOk @SincroFinal, @ID, @Estatus, @Sucursal, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @FechaAfectacion, @FechaRegistro, @Ejercicio, @Periodo, @Proyecto, @Ok OUTPUT, @OkRef OUTPUT
IF @OrigenTipo IS NOT NULL AND @Origen IS NOT NULL
BEGIN
EXEC spMovEnMaxID @OrigenTipo, @Empresa, @Origen, @OrigenID, @IDOrigen OUTPUT, @Ok OUTPUT
SELECT @OrigenMovTipo = Clave FROM MovTipo WHERE Modulo = @OrigenTipo AND Mov = @Origen
END
IF @Ok IS NULL
BEGIN
IF @SucursalDestino IS NOT NULL AND @SucursalDestino <> @Sucursal AND @Accion = 'AFECTAR'
BEGIN
EXEC spSucursalEnLinea @SucursalDestino, @EnLinea OUTPUT
IF @EnLinea = 1
BEGIN
EXEC spMovConsecutivo @Sucursal, @SucursalOrigen, @SucursalDestino, @Empresa, @Usuario, @Modulo, @Ejercicio, @Periodo, @ID, @Mov, NULL, @Estatus, @Concepto, @Accion, @Conexion, @SincroFinal, @MovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spAsignarSucursalEstatus @ID, @Modulo, @SucursalDestino, NULL
SELECT @Sucursal = @SucursalDestino
END ELSE
SELECT @Accion = 'SINCRO'
END
IF @Estatus = 'SINCRO' AND @Accion = 'CANCELAR'
BEGIN
EXEC spPuedeEditarMovMatrizSucursal @Sucursal, @SucursalOrigen, @ID, @Modulo, @Empresa, @Usuario, @Mov, @Estatus, 1, @PuedeEditar OUTPUT
IF @PuedeEditar = 0
SELECT @Ok = 60300
ELSE BEGIN
SELECT @Estatus = 'SINAFECTAR'/*, @Verificar = 0*/
EXEC spAsignarSucursalEstatus @ID, @Modulo, @Sucursal, 'SINAFECTAR'
END
END
END
IF @MovTipo = 'CXC.AR'
BEGIN
IF @Accion <> 'VERIFICAR' BEGIN TRANSACTION
IF EXISTS(SELECT * FROM CxcD d, Cxc e WHERE d.ID = @ID AND d.Aplica = e.Mov AND d.AplicaID = e.MovID AND e.Empresa = @Empresa AND e.Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'CANCELADO') AND e.Sucursal <> @SucursalDestino) SELECT @Ok = 60390
END
IF (@Accion <> 'CANCELAR' AND @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'PENDIENTE')) OR
(@Accion = 'CANCELAR'  AND @Estatus IN ('CONCLUIDO', 'PENDIENTE'))
BEGIN
SELECT @CfgAplicaAutoOrden =
CASE @Modulo
WHEN 'CXC'   THEN ISNULL(UPPER(RTRIM(CxcAplicaAutoOrden)), 'FECHA VENCIMIENTO')
WHEN 'CXP'   THEN ISNULL(UPPER(RTRIM(CxpAplicaAutoOrden)), 'FECHA VENCIMIENTO')
WHEN 'AGENT' THEN ISNULL(UPPER(RTRIM(CxpAplicaAutoOrden)), 'FECHA VENCIMIENTO')
END,
@AutoAjuste =
CASE @Modulo
WHEN 'CXC'   THEN ISNULL(NULLIF(CxcAutoAjuste, 0.0), 0.01)
WHEN 'CXP'   THEN ISNULL(NULLIF(CxpAutoAjuste, 0.0), 0.01)
WHEN 'AGENT' THEN ISNULL(NULLIF(CxpAutoAjuste, 0.0), 0.01)
END,
@AutoAjusteMov =
CASE @Modulo
WHEN 'CXC'   THEN ISNULL(NULLIF(CxcAutoAjusteMov, 0.0), 0.01)
WHEN 'CXP'   THEN ISNULL(NULLIF(CxpAutoAjusteMov, 0.0), 0.01)
WHEN 'AGENT' THEN ISNULL(NULLIF(CxpAutoAjusteMov, 0.0), 0.01)
END,
@CfgFormaCobroDA =
CASE @Modulo
WHEN 'CXC' THEN NULLIF(RTRIM(CxcFormaCobroDA), '')
WHEN 'CXP' THEN NULLIF(RTRIM(CxcFormaCobroDA), '')
ELSE NULL
END,
@CfgRefinanciamientoTasa =
CASE @Modulo
WHEN 'CXC' THEN ISNULL(CxcRefinanciamientoTasa, 0.0)
ELSE NULL
END,
/*
@CfgControlEfectivo =
CASE @Modulo
WHEN 'CXC' THEN CxcControlEfectivo
WHEN 'CXP' THEN CxpControlEfectivo
ELSE NULL
END,
@TopeEfectivoAuto =
CASE @Modulo
WHEN 'CXC' THEN ISNULL(CxcTopeEfectivoAuto, 50.0)
WHEN 'CXP' THEN ISNULL(CxpTopeEfectivoAuto, 50.0)
ELSE convert(money, 0.0)
END,*/
@CfgVentaComisionesCobradas = VentaComisionesCobradas,
@CfgComisionBase	      = UPPER(ComisionBase),
@CfgValidarPPMorosos	      = ISNULL(CxcValidarDescPPMorosos, 0)
FROM EmpresaCfg
WHERE Empresa = @Empresa
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @CfgAnticiposFacturados    = CxcAnticiposFacturados,
@CfgCobroImpuestos         = CxcCobroImpuestos,
@CfgComisionCreditos       = CxcComisionCreditos,
@CfgVentaLimiteNivelSucursal = VentaLimiteNivelSucursal,
@CfgSugerirProntoPago      = CxcSugerirProntoPago,
@CfgRetencionAlPago        = ISNULL(RetencionAlPago, 0),
@CfgRetencionAcreedor      = NULLIF(RTRIM(GastoRetencionAcreedor), ''),
@CfgRetencionConcepto      = NULLIF(RTRIM(GastoRetencionConcepto), ''),
@CfgRetencion2Acreedor     = NULLIF(RTRIM(GastoRetencion2Acreedor), ''),
@CfgRetencion2Concepto     = NULLIF(RTRIM(GastoRetencion2Concepto), ''),
@CfgRetencion3Acreedor     = NULLIF(RTRIM(GastoRetencion3Acreedor), ''),
@CfgRetencion3Concepto     = NULLIF(RTRIM(GastoRetencion3Concepto), ''),
@CfgAgentAfectarGastos     = ISNULL(AgentAfectarGastos, 0)
/*@CfgComisionAnticipos      = UPPER(ComisionAnticipos),
@CfgComisionCreditoDiverso = CxcComisionCreditoDiverso,
@CfgAplicaDif =
CASE @Modulo
WHEN 'CXC' THEN CxcAplicaDif
WHEN 'CXP' THEN CxpAplicaDif
ELSE NULL
END*/
FROM EmpresaCfg2
WHERE Empresa = @Empresa
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @AutoAjuste = @AutoAjuste /* / @MovTipoCambio*/
SELECT @CfgContX = ContX,
@CfgAC = ISNULL(AC, 0)
FROM EmpresaGral
WHERE Empresa = @Empresa
IF @@ERROR <> 0 SELECT @Ok = 1
IF @CfgContX = 1
SELECT @CfgContXGenerar = ContXGenerar
FROM EmpresaCfgModulo
WHERE Empresa = @Empresa
AND Modulo  = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @CfgRetencionMov = CASE WHEN @MovTipo = 'CXP.DC' THEN CxpDevRetencion ELSE CxpRetencion END
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @CfgMovCargoDiverso = NULL,
@CfgMovCreditoDiverso = NULL
IF EXISTS(SELECT * FROM EmpresaCfgMovEsp WHERE Empresa = @Empresa AND Asunto = 'EMB' AND Modulo = @Modulo AND Mov = @Mov)
SELECT @CfgEmbarcar = 1
IF @MovTipo IN ('CXC.NCP','CXP.NCP') SELECT @AplicaManual = 0
IF @Accion <> 'CANCELAR'
IF (@MovTipo IN ('CXC.A','CXC.AR','CXC.FAC','CXC.DAC','CXC.F','CXC.FA','CXC.AF','CXC.VV','CXC.IM','CXC.RM','CXC.CD','CXC.D','CXC.DM','CXC.DA','CXC.DP',
'CXP.A','CXP.F', 'CXP.FAC','CXP.DAC','CXP.AF','CXP.CD','CXP.D','CXP.DM','CXP.PAG','CXP.DA','CXP.DP',
'CXC.SD', 'CXC.SCH', 'CXP.SD', 'CXP.SCH',
'AGENT.C', 'AGENT.D', 'AGENT.A')) OR
(@MovTipo IN ('CXC.NC','CXC.NCD','CXC.NCF','CXC.CA','CXC.CAD','CXC.CAP','CXC.NCP','CXC.DV',
'CXP.NC','CXP.NCD','CXP.NCF','CXP.CA','CXP.CAD','CXP.CAP','CXP.NCP') AND @AplicaManual = 0)
SELECT @EstatusNuevo = 'PENDIENTE'
EXEC spMoneda @Accion, @MovMoneda, @MovTipoCambio, @ContactoMoneda, @ContactoFactor, @ContactoTipoCambio, @Ok OUTPUT
SELECT @ContactoFactor = @ContactoTipoCambio / @MovTipoCambio
IF (@Conexion = 0 OR @Accion = 'CANCELAR') AND @Accion NOT IN ('GENERAR', 'CONSECUTIVO'/*, 'SINCRO'*/) AND @Ok IS NULL
BEGIN
EXEC spCxVerificar @ID, @Accion, @Empresa, @Usuario, @Autorizacion, @Mensaje, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaEmision, @Condicion OUTPUT, @Vencimiento OUTPUT, @FormaPago, @Referencia, @Contacto, @ContactoTipo, @ContactoEnviarA, @ContactoMoneda, @ContactoFactor, @ContactoTipoCambio, @Importe, @ValesCobrados, @Impuestos, @Retencion, @Retencion2, @Retencion3, @Saldo, @CtaDinero, @Agente, @AplicaManual, @ConDesglose,
@CobroDesglosado, @CobroDelEfectivo, @CobroCambio,
@Indirecto, @Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen, @EstatusNuevo, @AfectarCantidadPendiente, @AfectarCantidadA, @CfgContX, @CfgContXGenerar, @CfgEmbarcar, @AutoAjuste, @AutoAjusteMov, /*@CfgAplicaDif, */@CfgDescuentoRecargos, @CfgFormaCobroDA, @CfgRefinanciamientoTasa, @CfgAnticiposFacturados, @CfgValidarPPMorosos, @CfgAC,
@Pagares,
@OrigenTipo, @OrigenMovTipo, @MovAplica, @MovAplicaID, @MovAplicaMovTipo, @AgenteNomina,
@RedondeoMonetarios, @Autorizar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT,
@INSTRUCCIONES_ESP,
@EmidaCarrierID 
IF @Autorizar = 1 AND @Modulo = 'CXP'
BEGIN
UPDATE Cxp SET Mensaje = @Ok WHERE ID = @ID
END
IF @Ok BETWEEN 80000 AND 89999 AND @Accion IN ('AFECTAR','GENERAR','CANCELAR') SELECT @Ok = NULL ELSE
IF @Accion = 'VERIFICAR' AND @Ok IS NULL
BEGIN
SELECT @Ok = 80000
EXEC xpOk_80000 @Empresa, @Usuario, @Accion, @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
END
END
IF @Estatus = 'PENDIENTE' AND @Accion = 'AFECTAR' AND @Ok IS NULL
SELECT @Ok = 60040
IF @Accion IN ('AFECTAR','GENERAR','CANCELAR','CONSECUTIVO','SINCRO') AND @Ok IS NULL
BEGIN
EXEC spCxAfectar @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID OUTPUT, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaEmision, @FechaAfectacion, @FechaConclusion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo, @Beneficiario,
@Condicion, @Vencimiento, @FechaProntoPago, @DescuentoProntoPago, @FormaPago, @Contacto, @ContactoEnviarA, @ContactoMoneda, @ContactoFactor, @ContactoTipoCambio, @Importe, @ValesCobrados, @Impuestos, @Retencion, @Retencion2, @Retencion3, @Comisiones, @ComisionesIVA,
@Saldo, @SaldoInteresesOrdinarios, @SaldoInteresesMoratorios,
@CtaDinero, @Cajero, @Agente, @AplicaManual, @ConDesglose,
@CobroDesglosado, @CobroDelEfectivo, @CobroCambio, @ImpuestosPorcentaje, @RetencionPorcentaje, @Aforo, @Tasa,
@CfgAplicaAutoOrden,
@AfectarCantidadPendiente, @AfectarCantidadA,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen,
@CfgRetencionAlPago, @CfgRetencionMov, @CfgRetencionAcreedor, @CfgRetencionConcepto, @CfgRetencion2Acreedor, @CfgRetencion2Concepto, @CfgRetencion3Acreedor, @CfgRetencion3Concepto, @CfgAgentAfectarGastos,
@CfgContX, @CfgContXGenerar, @CfgEmbarcar, @AutoAjuste, @AutoAjusteMov, @CfgDescuentoRecargos, @CfgFormaCobroDA,
/*@CfgControlEfectivo, @TopeEfectivoAuto, @CfgAplicaDif, */@CfgMovCargoDiverso, @CfgMovCreditoDiverso, @CfgVentaComisionesCobradas, @CfgCobroImpuestos, @CfgComisionBase, /*@CfgComisionCreditoDiverso,*/ @CfgComisionCreditos, @CfgVentaLimiteNivelSucursal, @CfgSugerirProntoPago, @CfgAC,
@GenerarGasto, @GenerarPoliza,
@IDOrigen, @OrigenTipo, @OrigenMovTipo, @MovAplica, @MovAplicaID, @MovAplicaMovTipo,
@AgenteNomina, @AgentePersonal, @AgenteNominaMov, @AgenteNominaConcepto,
@IVAFiscal, @IEPSFiscal, @ProveedorAutoEndoso,
@RamaID, @LineaCredito, @TipoAmortizacion, @TipoTasa,
@Generar, @GenerarMov OUTPUT, @GenerarSerie, @GenerarAfectado, @GenerarCopia, @RedondeoMonetarios,
@IDGenerar OUTPUT, @GenerarMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT,
@INSTRUCCIONES_ESP, @Nota, @Base = @Base, @Origen = @Origen, @OrigenID = @OrigenID, @SaldoInteresesOrdinariosIVA = @SaldoInteresesOrdinariosIVA, @SaldoInteresesMoratoriosIVA = @SaldoInteresesMoratoriosIVA, 
@EstacionTrabajo = @EstacionTrabajo 
IF @Generar = 1
BEGIN
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @Modulo, @IDGenerar, @GenerarMov, @GenerarMovID, @Ok OUTPUT
IF @Ok IS NULL AND @Accion <> 'CANCELAR'
SELECT @Ok = 80030, @Mov = @GenerarMov
END
END
END ELSE
IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @Accion = 'CANCELAR' EXEC spMovCancelarSinAfectar @Modulo, @ID, @Ok OUTPUT ELSE
IF @Estatus = 'AFECTANDO' SELECT @Ok = 80020 ELSE
IF @Estatus = 'CONCLUIDO' SELECT @Ok = 80010
ELSE SELECT @Ok = 60040
IF @Accion = 'SINCRO' AND @Ok = 80060
BEGIN
SELECT @Ok = NULL, @OkRef = NULL
EXEC spSucursalEnLinea @SucursalDestino, @EnLinea OUTPUT
IF @EnLinea = 1 EXEC spSincroFinalModulo @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
END
IF @MovTipo = 'CXC.AR' AND @Accion <> 'VERIFICAR'
BEGIN
IF @Accion IN ('SINCRO', 'CANCELAR')
BEGIN
IF @Ok IN (80030, 80060) SELECT @Ok = NULL
IF @ConDesglose = 1 AND @CobroDelEfectivo > 0.0
SELECT @Ok = 60380
ELSE BEGIN
SELECT @DineroImporte = @Importe + @Impuestos - @Retencion - @Retencion2 - @Retencion3
EXEC @DineroID = spGenerarDinero @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, @ConDesglose, 0,
@FechaRegistro, @Ejercicio, @Periodo,
@FormaPago, NULL, @Beneficiario,
@Contacto, @CtaDinero, @Cajero, @DineroImporte, NULL,
NULL, NULL, @Vencimiento,
@DineroMov OUTPUT, @DineroMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT, @Nota = @Nota
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
IF @Ok IS NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'DIN', @DineroID, @DineroMov, @DineroMovID, @Ok OUTPUT
END
END ELSE
IF @SucursalOrigen = @Sucursal SELECT @Ok = 60370
IF @Ok IN (NULL, 80030, 80060)
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
END
IF @Ok IS NOT NULL AND @OkRef IS NULL
IF @Ok = 80030
SELECT @OkRef = 'Movimiento: '+RTRIM(@GenerarMov)+' '+LTRIM(Convert(Char, @GenerarMovID))
ELSE
SELECT @OkRef = 'Movimiento: '+RTRIM(@Mov)+' '+LTRIM(Convert(Char, @MovID)), @IDGenerar = NULL
RETURN ISNULL(@IDGenerar, 0)
END

