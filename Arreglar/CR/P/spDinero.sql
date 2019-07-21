SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDinero
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
@EstacionTrabajo int = NULL 

AS BEGIN
DECLARE
@Sucursal			int,
@SucursalDestino		int,
@SucursalOrigen		int,
@PuedeEditar		bit,
@EnLinea			bit,
@Empresa	      		char(5),
@MovTipo   			char(20),
@FechaEmision     		datetime,
@FechaAfectacion		datetime,
@FechaConclusion		datetime,
@Concepto	      		varchar(50),
@Proyecto	      		varchar(50),
@MovMoneda	      		char(10),
@MovTipoCambio	   	float,
@MovUsuario	      		char(10),
@Autorizacion     		char(10),
@Referencia	      		varchar(50),
@DocFuente	      		int,
@Beneficiario		int,
@BeneficiarioNombre		varchar(100),
@Observaciones    		varchar(255),
@Estatus          		char(15),
@Ejercicio	      		int,
@Periodo	      		int,
@AutoConciliar		bit,
@Cajero			char(10),
@FormaPago			varchar(50),
@IVAFiscal			float,
@IEPSFiscal			float,
@CtaDinero		        char(10),
@CtaDineroTipo		char(20),
@CtaDineroDestino		char(10),
@CtaDineroDestinoTipo	char(20),
@CtaDineroFactor		float,
@CtaDineroTipoCambio	float,
@CtaDineroMoneda  		char(10),
@CtaDineroDestinoMoneda	char(10),
@Contacto			char(10),
@ContactoTipo		varchar(20),
@ContactoEnviarA		int,
@TipoCambioDestino		float,
@CtaEmpresa			char(5),
@Importe   			money,
@Impuestos	        	money,
@Saldo			money,
@Serie		 	char(20),
@Corte			int,
@CorteDestino		int,
@Directo			bit,
@ConDesglose                bit,
@CfgAfectarComision		bit,
@CfgAfectarComisionIVA	bit,
@CfgChequesPendientes	bit,
@CfgeChequesPendientes	bit,
@CfgCajeros			bit,
@CfgAutoFaltanteSobrante	bit,
@CfgSobregiros		bit,
@CfgFormaPagoRequerida	bit,
@CfgChequesDirectos		bit,
@CfgContX			bit,
@CfgEmbarcar		bit,
@CfgContXGenerar		char(20),
@GenerarPoliza		bit,
@OrigenTipo			char(10),
@OrigenMov			char(20),
@OrigenMovID		varchar(20),
@OrigenMovTipo		char(20),
@CajeroActual		char(10),
@Dias			int,
@TasaDiaria			float,
@Retencion			money,
@CfgInversionIntereses 	varchar(20),
@InteresTipo		varchar(20),
@Titulo			varchar(10),
@TituloValor		float,
@ValorOrigen		float,
@Cliente			varchar(10),
@ClienteEnviarA		int,
@Proveedor			varchar(10),
@GenerarGasto		bit,
@EstatusNuevo	      	char(15),
@Generar                    bit,
@GenerarAfectado		bit,
@GenerarAfectando		bit,
@GenerarCopia		bit,
@GenerarMovID		varchar(20),
@GenerarSerie		char(20),
@GenerarEstatus	 	char(15),
@GenerarMovTipo 		char(20),
@GenerarPeriodo 		int,
@GenerarEjercicio 		int,
@Autorizar			bit,
@Utilizar			bit,
@UtilizarID 		int,
@UtilizarMov 		char(20),
@UtilizarMovID 		varchar(20),
@UtilizarMovTipo		char(20)/*,
@Verificar			bit*/,
@SubClave                   varchar(20),
@ChequeDevuelto		bit 
SELECT @Generar	  	 = 0,
@GenerarAfectado 	 = 0,
@GenerarAfectando	 = 0,
@GenerarCopia	  	 = 1,
@GenerarSerie		 = NULL,
@Utilizar		 = 0,
@Impuestos		 = 0.0,
@Saldo			 = 0.0,
@Directo		 = 0,
@Beneficiario		 = NULL,
@BeneficiarioNombre     = NULL,
@CtaDineroMoneda  	 = NULL,
@CtaDineroDestinoMoneda = NULL,
@TipoCambioDestino	 = 1.0,
@Serie			 = NULL,
@CfgContX		 = 0,
@CfgContXGenerar	 = 'NO',
@CfgEmbarcar		 = 0,
@Autorizar		 = 0,
@OrigenMovTipo		 = NULL/*,
@Verificar		 = 1*/
IF @Accion = 'CANCELAR' SELECT @EstatusNuevo = 'CANCELADO' ELSE SELECT @EstatusNuevo = 'CONCLUIDO'
SELECT @Sucursal = Sucursal, @SucursalDestino = SucursalDestino, @SucursalOrigen = SucursalOrigen, @Empresa = Empresa, @MovID = MovID, @Mov = Mov, @FechaEmision = FechaEmision, @Concepto = Concepto, @Proyecto = Proyecto,
@MovMoneda = Moneda, @MovTipoCambio = TipoCambio, @MovUsuario = Usuario, @Autorizacion = Autorizacion, @Referencia = Referencia,
@DocFuente = DocFuente, @Observaciones = Observaciones, @Beneficiario = Beneficiario, @BeneficiarioNombre = BeneficiarioNombre, @Estatus = UPPER(Estatus), @Directo = Directo,
@CtaDinero = NULLIF(RTRIM(CtaDinero), ''), @CtaDineroDestino = NULLIF(RTRIM(CtaDineroDestino), ''), @FormaPago = NULLIF(RTRIM(FormaPago), ''),
@Importe = ISNULL(Importe, 0.0), @Impuestos = ISNULL(Impuestos, 0.0), @Saldo = ISNULL(Saldo, 0.0), @ConDesglose = ConDesglose,
@GenerarPoliza = GenerarPoliza, @OrigenTipo = OrigenTipo, @OrigenMov = Origen, @OrigenMovID = OrigenID, @FechaConclusion = FechaConclusion,
@AutoConciliar = AutoConciliar, @Corte = Corte, @CorteDestino = CorteDestino, @Cajero = NULLIF(RTRIM(Cajero), ''), @IVAFiscal = IVAFiscal, @IEPSFiscal = IEPSFiscal,
@TipoCambioDestino = TipoCambioDestino, @Dias = DATEDIFF(day, FechaOrigen, Vencimiento), @TasaDiaria = Tasa / NULLIF(TasaDias, 0), @Retencion = ISNULL(Retencion, 0.0), 
@InteresTipo = ISNULL(NULLIF(RTRIM(UPPER(InteresTipo)), ''), 'TASA FIJA'), @Titulo = NULLIF(RTRIM(Titulo), ''), @TituloValor = ISNULL(TituloValor, 0.0), @ValorOrigen = ISNULL(ValorOrigen, 0.0),
@Contacto = Contacto, @ContactoTipo = ContactoTipo, @ContactoEnviarA = ContactoEnviarA, @Cliente = NULLIF(RTRIM(Cliente), ''), @ClienteEnviarA = ClienteEnviarA, @Proveedor = NULLIF(RTRIM(Proveedor), ''), @ChequeDevuelto = ISNULL(ChequeDevuelto,0) 
FROM Dinero
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @SubClave = SubClave FROM MovTipo WHERE Mov = @Mov AND Modulo = @Modulo
IF @Accion = 'AUTORIZAR'
SELECT @Autorizacion = @Usuario, @Accion = 'AFECTAR'
IF @GenerarMov IS NOT NULL
IF @Accion = 'AFECTAR' SELECT @Utilizar = 1 ELSE
IF @Accion = 'GENERAR' SELECT @Generar = 1
IF @Generar = 1 SELECT @EstatusNuevo = @Estatus
EXEC spFechaAfectacion @Empresa, @Modulo, @ID, @Accion, @FechaEmision OUTPUT, @FechaRegistro, @FechaAfectacion OUTPUT
EXEC spExtraerFecha @FechaAfectacion OUTPUT
EXEC spMovTipo @Modulo, @Mov, @FechaAfectacion, @Empresa, @Estatus, @Concepto OUTPUT, @MovTipo OUTPUT, @Periodo OUTPUT, @Ejercicio OUTPUT, @Ok OUTPUT, @GenerarGasto = @GenerarGasto OUTPUT
EXEC spMovOk @SincroFinal, @ID, @Estatus, @Sucursal, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @FechaAfectacion, @FechaRegistro, @Ejercicio, @Periodo, @Proyecto, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
IF @SucursalDestino IS NOT NULL AND @SucursalDestino <> @Sucursal AND @Accion = 'AFECTAR'
BEGIN
EXEC spSucursalEnLinea @SucursalDestino, @EnLinea OUTPUT
IF @EnLinea = 1
BEGIN
IF @MovTipo IN ('DIN.CH', 'DIN.CHE') SELECT @Serie = @CtaDinero
EXEC spMovConsecutivo @Sucursal, @SucursalOrigen, @SucursalDestino, @Empresa, @Usuario, @Modulo, @Ejercicio, @Periodo, @ID, @Mov, @Serie, @Estatus, @Concepto, @Accion, @Conexion, @SincroFinal, @MovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
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
EXEC spAsignarSucursalEstatus @ID, @Modulo, @Sucursal, @Estatus
END
END
END
IF NULLIF(RTRIM(@Usuario), '') IS NULL SELECT @Usuario = @MovUsuario
IF (@Accion <> 'CANCELAR' AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR','POSFECHADO', 'PENDIENTE')) OR
(@Accion = 'CANCELAR'  AND @Estatus IN ('CONCLUIDO',  'PENDIENTE'))
BEGIN
IF @OrigenMovID IS NOT NULL AND @OrigenMov IS NOT NULL
SELECT @OrigenMovTipo = Clave FROM MovTipo WHERE Modulo = @OrigenTipo AND Mov = @OrigenMov
SELECT @CfgChequesPendientes    = ChequesPendientes,
@CfgeChequesPendientes   = eChequesPendientes,
@CfgCajeros              = Cajeros,
@CfgAutoFaltanteSobrante = DineroAutoFaltanteSobrante,
@CfgSobregiros	    = DineroControlarSobregiros,
@CfgFormaPagoRequerida   = FormaPagoRequerida,
@CfgChequesDirectos      = ChequesDirectos,
@CfgAfectarComision	    = DineroAfectarComision,
@CfgAfectarComisionIVA   = DineroAfectarComisionIVA,
@CfgInversionIntereses   = UPPER(DineroInversionIntereses)
FROM EmpresaCfg
WHERE Empresa = @Empresa
IF @@ERROR <> 0 SELECT @Ok = 1
IF @CfgCajeros = 1
SELECT @CfgCajeros = Cajeros FROM Sucursal WHERE Sucursal = @Sucursal
SELECT @CfgContX = ContX
FROM EmpresaGral
WHERE Empresa = @Empresa
IF @@ERROR <> 0 SELECT @Ok = 1
IF @CfgContX = 1
SELECT @CfgContXGenerar = ContXGenerar
FROM EmpresaCfgModulo
WHERE Empresa = @Empresa
AND Modulo  = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 1
IF EXISTS(SELECT * FROM EmpresaCfgMovEsp WHERE Empresa = @Empresa AND Asunto = 'EMB' AND Modulo = @Modulo AND Mov = @Mov)
SELECT @CfgEmbarcar = 1
SELECT @CtaDineroTipo = UPPER(Tipo), @CtaDineroMoneda = Moneda, @CtaEmpresa = NULLIF(RTRIM(Empresa), '') FROM CtaDinero WHERE CtaDinero = @CtaDinero
IF @CtaDineroDestino IS NOT NULL
SELECT @CtaDineroDestinoTipo = UPPER(Tipo), @CtaDineroDestinoMoneda = Moneda FROM CtaDinero WHERE CtaDinero = @CtaDineroDestino
IF @Accion <> 'CANCELAR' AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR','POSFECHADO')
BEGIN
IF @MovTipo IN ('DIN.INV', 'DIN.TI') SELECT @EstatusNuevo = 'PENDIENTE'
IF @MovTipo = 'DIN.CH'  AND @CfgChequesPendientes = 1 SELECT @EstatusNuevo = 'PENDIENTE' ELSE
IF @MovTipo = 'DIN.CHE' AND @CfgeChequesPendientes = 1 SELECT @EstatusNuevo = 'PENDIENTE' ELSE
IF (@MovTipo IN ('DIN.DA', 'DIN.I', 'DIN.E', 'DIN.F', 'DIN.CNI') AND @CtaDineroTipo <> 'CAJA') OR (@MovTipo IN ('DIN.SD', 'DIN.SCH')) SELECT @EstatusNuevo = 'PENDIENTE'
END
IF @CtaDineroTipo        = 'CAJA' SELECT @CtaDineroMoneda        = @MovMoneda
IF @CtaDineroDestinoTipo = 'CAJA' SELECT @CtaDineroDestinoMoneda = @MovMoneda
IF @Ok IS NULL
EXEC spMoneda NULL, @MovMoneda, @MovTipoCambio, @MovMoneda, @CtaDineroFactor OUTPUT, @CtaDineroTipoCambio OUTPUT, @Ok OUTPUT
IF @MovTipo = 'DIN.ACXC' SELECT @ContactoTipo = 'Cliente',   @Contacto = @Cliente, @ContactoEnviarA = @ClienteEnviarA ELSE
IF @MovTipo = 'DIN.ACXP' SELECT @ContactoTipo = 'Proveedor', @Contacto = @Proveedor
IF @Accion <> 'GENERAR'
BEGIN
IF @CtaDineroTipo = 'CAJA'
BEGIN
IF @MovTipo NOT IN ('DIN.TC','DIN.A','DIN.AP','DIN.I', 'DIN.SD', 'DIN.E', 'DIN.F', 'DIN.SCH', 'DIN.CP', 'DIN.C', 'DIN.RND', 'DIN.PR') SELECT @Ok = 30270
END ELSE
BEGIN
IF @MovTipo NOT IN ('DIN.D','DIN.DE','DIN.CH','DIN.CHE','DIN.CB','DIN.AB','DIN.DF','DIN.CD','DIN.T','DIN.INV','DIN.RET','DIN.A','DIN.AP','DIN.DA','DIN.SD','DIN.SCH','DIN.RE','DIN.REI','DIN.RND', 'DIN.PR', 'DIN.ACXC', 'DIN.ACXP', 'DIN.TI', 'DIN.CNI')  AND @SubClave <>'DIN.TCMULTIMONEDA' SELECT @Ok = 30260 ELSE
IF @CtaDinero IS NULL AND @EstatusNuevo = 'PENDIENTE' AND @MovTipo NOT IN ( 'DIN.SD', 'DIN.SCH') SELECT @Ok = 40030
END
END
IF @Accion <> 'GENERAR'
BEGIN
SELECT @CajeroActual = NULL
IF @MovTipo IN ('DIN.I', 'DIN.E', 'DIN.F', 'DIN.A', 'DIN.AP','DIN.CP', 'DIN.C', 'DIN.TC') AND @CfgCajeros = 1 AND @SubClave NOT IN ('DIN.AMULTIMONEDA' ,'DIN.CMULTIMONEDA' ,'DIN.CPMULTIMONEDA','DIN.TCMULTIMONEDA' )
BEGIN
SELECT @CajeroActual = NULLIF(RTRIM(Cajero), '')
FROM CtaDineroCajero
WHERE Moneda = ''/*@MovMoneda*/ AND CtaDinero = CASE WHEN @MovTipo IN ('DIN.A', 'DIN.AP') THEN @CtaDineroDestino ELSE @CtaDinero END
IF @Cajero IS NULL
BEGIN
IF @MovTipo IN ('DIN.I', 'DIN.E')
BEGIN
SELECT @Cajero = @CajeroActual
UPDATE Dinero SET Cajero = @Cajero WHERE ID = @ID
END ELSE
SELECT @Ok = 30490
END
IF (@MovTipo = 'DIN.A' AND @Accion <> 'CANCELAR') AND @SubClave NOT IN( 'DIN.AMULTIMONEDA') OR (@MovTipo = 'DIN.C' AND @Accion = 'CANCELAR' AND @SubClave  NOT IN('DIN.CMULTIMONEDA')OR (@MovTipo = 'DIN.TC' AND @Accion = 'CANCELAR' AND @SubClave  NOT IN('DIN.TCMULTIMONEDA')))
BEGIN
IF @CajeroActual IS NOT NULL AND @OrigenTipo <>'POS' SELECT @Ok = 30430, @OkRef = @CajeroActual
END ELSE
BEGIN
IF @CajeroActual IS NULL
SELECT @Ok = 30440
ELSE
IF @CajeroActual <> @Cajero AND @OrigenTipo <>'POS'
SELECT @Ok = 30430, @OkRef = @CajeroActual
END
IF @MovTipo = 'DIN.TC'
IF (SELECT NULLIF(RTRIM(Cajero), '') FROM CtaDineroCajero WHERE Moneda = ''/*@MovMoneda*/ AND CtaDinero = @CtaDineroDestino) IS NULL
SELECT @Ok = 30440
END
END
IF /*(@Conexion = 0 OR @Accion = 'CANCELAR') AND */@Accion NOT IN ('GENERAR', 'CONSECUTIVO'/*, 'SINCRO'*/) AND @Ok IS NULL
BEGIN
EXEC spDineroVerificar @ID, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio, @FechaEmision, @Estatus, @EstatusNuevo, @BeneficiarioNombre,
@CtaDinero, @CtaDineroTipo, @CtaDineroDestino, @CtaDineroFactor, @CtaDineroTipoCambio, @CtaDineroMoneda, @CtaDineroDestinoMoneda, @CtaDineroDestinoTipo, @CtaEmpresa, @Cajero, @FormaPago, @Referencia,
@Importe, @Impuestos, @Saldo, @Corte, @CorteDestino, @Dias, @TasaDiaria, @Retencion, @CfgInversionIntereses, @InteresTipo, @Titulo, @TituloValor, @ValorOrigen,
@Contacto, @ContactoTipo, @ContactoEnviarA,
@Directo, @ConDesglose, @CfgCajeros, @CfgSobregiros, @CfgFormaPagoRequerida, @CfgChequesDirectos, @CfgContX, @CfgContXGenerar, @OrigenTipo, @OrigenMovTipo, @Conexion, @SincroFinal, @Sucursal,
@Autorizacion, @Autorizar OUTPUT, @ChequeDevuelto, @Ok OUTPUT, @OkRef OUTPUT, @EstacionTrabajo = @EstacionTrabajo 
IF @Autorizar = 1
UPDATE Dinero SET Mensaje = @Ok WHERE ID = @ID
IF @Ok BETWEEN 80000 AND 89999 AND @Accion IN ('AFECTAR','GENERAR', 'CANCELAR') SELECT @Ok = NULL ELSE
IF @Accion = 'VERIFICAR' AND @Ok IS NULL
BEGIN
SELECT @Ok = 80000
EXEC xpOk_80000 @Empresa, @Usuario, @Accion, @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
END
END
IF (@Generar = 1 OR @Utilizar = 1) AND @Ok IS NULL
BEGIN
EXEC spMovTipo @Modulo, @GenerarMov, @FechaAfectacion, @Empresa, NULL, NULL, @GenerarMovTipo OUTPUT, @GenerarPeriodo OUTPUT, @GenerarEjercicio OUTPUT, @Ok OUTPUT
IF @GenerarMovTipo IN ('DIN.CH', 'DIN.CHE') SELECT @GenerarSerie = @CtaDinero
IF @Accion = 'GENERAR' SELECT @GenerarEstatus = 'SINAFECTAR' ELSE SELECT @GenerarEstatus = 'CANCELADO'
EXEC spMovGenerar @Sucursal, @Empresa, @Modulo, @Ejercicio, @Periodo, @Usuario, @FechaRegistro, @GenerarEstatus,
NULL, NULL,
@Mov, @MovID, 0,
@GenerarMov, @GenerarSerie, @GenerarMovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
UPDATE Dinero SET Beneficiario = @Beneficiario, BeneficiarioNombre = @BeneficiarioNombre, ConDesglose = @ConDesglose, Directo = 0, Importe = @Saldo WHERE ID = @IDGenerar
IF @@ERROR <> 0 SELECT @Ok = 1
IF @MovTipo = 'DIN.TI' AND @GenerarMovTipo IN ('DIN.D', 'DIN.DE')
UPDATE Dinero SET CtaDinero = CtaDineroDestino, CtaDineroDestino = NULL WHERE ID = @IDGenerar
IF @GenerarMovTipo = 'DIN.RET'
UPDATE Dinero SET CtaDinero = CtaDineroDestino, CtaDineroDestino = CtaDinero WHERE ID = @IDGenerar
IF @ConDesglose = 1
BEGIN 
INSERT DineroD (Sucursal,  ID,         Renglon, Aplica, AplicaID, Importe, FormaPago, Referencia)
SELECT @Sucursal, @IDGenerar, Renglon, @Mov,   @MovID,   Importe, FormaPago, Referencia
FROM DineroD
WHERE ID = @ID
END 
ELSE
INSERT DineroD (Sucursal,  ID,         Renglon, Aplica, AplicaID, Importe)
VALUES (@Sucursal, @IDGenerar,  2048.0, @Mov,   @MovID,   @Saldo)
IF @@ERROR <> 0 SELECT @Ok = 1
END
END
IF @Utilizar = 1 AND @Ok IS NULL
BEGIN
SELECT @Estatus =  'SINAFECTAR'
SELECT @UtilizarID = @ID, @UtilizarMov = @Mov, @UtilizarMovID = @MovID, @UtilizarMovTipo = @MovTipo,
@ID = @IDGenerar, @Mov = @GenerarMov, @MovID = @GenerarMovID, @GenerarMov = NULL,
@ConDesglose = 1, @Directo = 0
EXEC spMovTipo @Modulo, @Mov, @FechaAfectacion, @Empresa, NULL, NULL, @MovTipo OUTPUT, @Periodo OUTPUT, @Ejercicio OUTPUT, @Ok OUTPUT
END
IF @Accion IN ('AFECTAR','CONSECUTIVO','SINCRO','CANCELAR') AND @Ok IS NULL
EXEC spDineroAfectar @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID OUTPUT, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaEmision, @FechaAfectacion, @FechaConclusion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo,
@CtaDinero, @CtaDineroTipo, @CtaDineroDestino, @CtaDineroFactor, @CtaDineroTipoCambio, @CtaDineroMoneda, @CtaDineroDestinoMoneda, @TipoCambioDestino, @Cajero, @FormaPago, @IVAFiscal, @IEPSFiscal,
@Importe, @Impuestos, @Saldo, @Dias, @TasaDiaria, @Retencion, @CfgInversionIntereses, @InteresTipo, @Titulo, @TituloValor, @ValorOrigen,
@Contacto, @ContactoTipo, @ContactoEnviarA,
@Directo, @ConDesglose, @AutoConciliar,
@OrigenTipo, @OrigenMov, @OrigenMovID, @OrigenMovTipo, @Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen,
@GenerarGasto, @CfgCajeros, @CfgAutoFaltanteSobrante, @CfgSobregiros, @CfgAfectarComision, @CfgAfectarComisionIVA, @CfgContX, @CfgContXGenerar, @CfgEmbarcar, @GenerarPoliza,
@Utilizar, @UtilizarID, @UtilizarMov, @UtilizarMovTipo, @UtilizarMovID,
@Generar, @GenerarMov, @GenerarAfectado, @GenerarAfectando, @GenerarCopia, @IDGenerar OUTPUT, @GenerarMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT, @EstacionTrabajo = @EstacionTrabajo 
IF (@Utilizar = 1 OR @Generar = 1) AND @Ok IS NULL
BEGIN
IF @Utilizar = 1 EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @UtilizarID, @UtilizarMov, @UtilizarMovID, @Modulo, @ID, @Mov, @MovID, @Ok OUTPUT
IF @Generar  = 1 EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @Modulo, @IDGenerar, @GenerarMov, @GenerarMovID, @Ok OUTPUT
IF @Accion <> 'CANCELAR' AND @Ok IS NULL
SELECT @Ok = 80030, @OkRef = NULL
END
END ELSE
IF @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR','POSFECHADO') AND @Accion = 'CANCELAR' EXEC spMovCancelarSinAfectar @Modulo, @ID, @Ok OUTPUT ELSE
IF @Estatus = 'AFECTANDO' SELECT @Ok = 80020 ELSE
IF @Estatus = 'CONCLUIDO' SELECT @Ok = 80010
ELSE SELECT @Ok = 60040, @OkRef = 'Estatus: '+@Estatus
IF @Accion = 'SINCRO' AND @Ok = 80060
BEGIN
SELECT @Ok = NULL, @OkRef = NULL
EXEC spSucursalEnLinea @SucursalDestino, @EnLinea OUTPUT
IF @EnLinea = 1 EXEC spSincroFinalModulo @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NOT NULL AND @OkRef IS NULL
BEGIN
IF @Ok = 80030
BEGIN
IF @Utilizar = 1 SELECT @OkRef = 'Movimiento: '+RTRIM(@Mov)        + ' ' +LTRIM(Convert(Char, @MovID))
IF @Generar  = 1 SELECT @OkRef = 'Movimiento: '+RTRIM(@GenerarMov) + ' ' +LTRIM(Convert(Char, @GenerarMovID))
END
ELSE
SELECT @OkRef = 'Movimiento: '+RTRIM(@Mov)+' '+LTRIM(Convert(Char, @MovID)), @IDGenerar = NULL
END
RETURN
END

