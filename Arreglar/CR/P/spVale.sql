SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVale
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
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Sucursal		int,
@SucursalDestino	int,
@SucursalOrigen	int,
@EnLinea		bit,
@PuedeEditar	bit,
@Empresa	      	char(5),
@MovTipo   		char(20),
@MovMoneda		char(10),
@MovTipoCambio	float,
@FechaEmision     	datetime,
@FechaAfectacion	datetime,
@FechaConclusion	datetime,
@Proyecto	      	varchar(50),
@MovUsuario	      	char(10),
@Autorizacion     	char(10),
@DocFuente	      	int,
@Observaciones    	varchar(255),
@Estatus          	char(15),
@EstatusNuevo	char(15),
@Ejercicio	      	int,
@Periodo	      	int,
@Concepto		varchar(50),
@Referencia  	varchar(50),
@CtaDinero		char(10),
@FormaPago		varchar(50),
@Tipo		varchar(50),
@Precio		money,
@TipoTieneVigencia	bit,
@FechaInicio	datetime,
@FechaTermino	datetime,
@Cliente		char(10),
@Agente		char(10),
@Condicion		varchar(50),
@Vencimiento	datetime,
@Descuento		varchar(50),
@MovNCredito 	varchar(20),
@MovNCargo	 	varchar(20),
@GenerarMovID	varchar(20),
@GenerarPoliza	bit,
@CfgContX		bit,
@CfgContXGenerar	char(20)/*,
@Verificar		bit*/,
@OrigenTipo         varchar(20)
SELECT @Tipo            	= NULL,
@Precio	  	= NULL,
@TipoTieneVigencia	= 0,
@CfgContX        	= 0,
@CfgContXGenerar 	= 'NO'/*,
@Verificar	  	= 1*/
SELECT @Sucursal = Sucursal, @SucursalDestino = SucursalDestino, @SucursalOrigen = SucursalOrigen,
@Empresa = Empresa, @MovID = MovID, @Mov = Mov, @FechaEmision = FechaEmision, @Proyecto = Proyecto,
@MovUsuario = Usuario, @Autorizacion = Autorizacion,
@MovMoneda = Moneda, @MovTipoCambio = TipoCambio,
@DocFuente = DocFuente, @Observaciones = Observaciones, @Estatus = UPPER(Estatus),
@Tipo = NULLIF(RTRIM(Tipo), ''), @Precio = NULLIF(Precio, 0), @FechaInicio = FechaInicio, @FechaTermino = FechaTermino,
@Cliente = NULLIF(RTRIM(Cliente), ''), @Agente = NULLIF(RTRIM(Agente), ''), @Condicion = NULLIF(RTRIM(Condicion), ''), @Vencimiento = Vencimiento, @Descuento = NULLIF(RTRIM(Descuento), ''),
@Concepto = Concepto, @Referencia = Referencia, @CtaDinero = NULLIF(RTRIM(CtaDinero), ''), @FormaPago = NULLIF(RTRIM(FormaPago), ''),
@GenerarPoliza = GenerarPoliza, @FechaConclusion = FechaConclusion,
@OrigenTipo = NULLIF(OrigenTipo,'')
FROM Vale
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @MovNCredito = CxcNCredito,
@MovNCargo   = CxcNCargo
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
IF NULLIF(RTRIM(@Usuario), '') IS NULL SELECT @Usuario = @MovUsuario
EXEC spFechaAfectacion @Empresa, @Modulo, @ID, @Accion, @FechaEmision OUTPUT, @FechaRegistro, @FechaAfectacion OUTPUT
EXEC spExtraerFecha @FechaAfectacion OUTPUT
EXEC spExtraerFecha @FechaInicio OUTPUT
EXEC spExtraerFecha @FechaTermino OUTPUT
EXEC spMovTipo @Modulo, @Mov, @FechaAfectacion, NULL, NULL, NULL, @MovTipo OUTPUT, @Periodo OUTPUT, @Ejercicio OUTPUT, @Ok OUTPUT
EXEC spMovOk @SincroFinal, @ID, @Estatus, @Sucursal, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @FechaAfectacion, @FechaRegistro, @Ejercicio, @Periodo, @Proyecto, @Ok OUTPUT, @OkRef OUTPUT
IF @OrigenTipo = 'POS' AND @MovTipo IN('VALE.ET')
SELECT @Precio =  ISNULL(Precio,0.0)
FROM Vale
WHERE ID = @ID
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
EXEC spAsignarSucursalEstatus @ID, @Modulo, @Sucursal, @Estatus
END
END
END
IF (@Accion <> 'CANCELAR' AND @Estatus IN ('SINAFECTAR', 'PENDIENTE', 'VIGENTE')) OR
(@Accion = 'CANCELAR'  AND @Estatus IN ('CONCLUIDO',  'PENDIENTE', 'VIGENTE'))
BEGIN
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
IF @Accion = 'CANCELAR'
SELECT @EstatusNuevo = 'CANCELADO'
ELSE
BEGIN
IF @MovTipo IN ('VALE.AMLDI','VALE.ACTMLDI')AND @Estatus = 'SINAFECTAR' AND @OrigenTipo NOT IN ('POS')
BEGIN
SELECT @EstatusNuevo = 'PENDIENTE'
END
ELSE
SELECT @EstatusNuevo = 'CONCLUIDO'
END
IF @MovTipo IN ('VALE.E', 'VALE.EV', 'VALE.ET', 'VALE.EO')
SELECT @TipoTieneVigencia = TieneVigencia
FROM ValeTipo
WHERE Tipo = @Tipo
IF @MovTipo NOT IN ('VALE.V', 'VALE.D', 'VALE.EV', 'VALE.EO', 'VALE.O'/*, 'VALE.OT'*/)
SELECT @Cliente = NULL, @Agente = NULL, @Descuento = NULL
IF (@Conexion = 0 OR @Accion = 'CANCELAR') AND @Accion NOT IN ('GENERAR', 'CONSECUTIVO'/*, 'SINCRO'*/) AND @Ok IS NULL
BEGIN
EXEC spValeVerificar @ID, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaEmision, @Estatus,
@Tipo, @Precio, @TipoTieneVigencia, @FechaInicio, @FechaTermino,
@Cliente,@Agente, @Condicion, @Vencimiento, @Descuento, @CtaDinero, @FormaPago,
@Conexion, @SincroFinal, @Sucursal,
@CfgContX, @CfgContXGenerar, @GenerarPoliza,
@Ok OUTPUT, @OkRef OUTPUT
IF @Ok BETWEEN 80000 AND 89999 AND @Accion IN ('AFECTAR', 'CANCELAR') SELECT @Ok = NULL ELSE
IF @Accion = 'VERIFICAR' AND @Ok IS NULL
BEGIN
SELECT @Ok = 80000
EXEC xpOk_80000 @Empresa, @Usuario, @Accion, @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
END
END
IF @Accion IN ('AFECTAR', 'GENERAR', 'CANCELAR', 'CONSECUTIVO', 'SINCRO') AND @Ok IS NULL
EXEC spValeAfectar @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID OUTPUT, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaEmision, @FechaAfectacion, @FechaConclusion,
@Proyecto, @Usuario, @Autorizacion, @DocFuente, @Observaciones,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo,
@Tipo, @Precio, @TipoTieneVigencia, @FechaInicio, @FechaTermino,
@Cliente, @Agente, @Condicion, @Vencimiento, @Descuento, @Concepto, @Referencia, @CtaDinero, @FormaPago,
@MovNCredito, @MovNCargo,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen,
@CfgContX, @CfgContXGenerar, @GenerarPoliza,
@GenerarMov OUTPUT, @IDGenerar OUTPUT, @GenerarMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
END ELSE
BEGIN
IF @Estatus = 'SINAFECTAR' AND @Accion = 'CANCELAR' EXEC spMovCancelarSinAfectar @Modulo, @ID, @Ok OUTPUT ELSE
IF @Estatus = 'AFECTANDO' SELECT @Ok = 80020 ELSE
IF @Estatus = 'CONCLUIDO' SELECT @Ok = 80010
ELSE SELECT @Ok = 60040, @OkRef = 'Estatus: '+@Estatus
END
IF @Accion = 'SINCRO' AND @Ok = 80060
BEGIN
SELECT @Ok = NULL, @OkRef = NULL
EXEC spSucursalEnLinea @SucursalDestino, @EnLinea OUTPUT
IF @EnLinea = 1 EXEC spSincroFinalModulo @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NOT NULL AND @OkRef IS NULL
IF @Ok = 80030
SELECT @OkRef = 'Movimiento: '+RTRIM(@GenerarMov)+' '+LTRIM(Convert(Char, @GenerarMovID))
ELSE
SELECT @OkRef = 'Movimiento: '+RTRIM(@Mov)+' '+LTRIM(Convert(Char, @MovID)), @IDGenerar = NULL
RETURN
END

