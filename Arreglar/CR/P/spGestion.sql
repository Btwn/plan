SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGestion
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
@Generar		bit,
@GenerarAfectado	bit,
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
@UEN		int,
@MovUsuario	      	char(10),
@Autorizacion     	char(10),
@FechaAutorizacion	datetime,
@DocFuente	      	int,
@Concepto    	varchar(50),
@Referencia 	varchar(50),
@Observaciones    	varchar(255),
@Prioridad		varchar(10),
@RamaID		int,
@IDOrigen		int,
@OrigenTipo		varchar(10),
@Origen		varchar(20),
@OrigenID		varchar(20),
@OrigenMovTipo	varchar(20),
@OrigenFechaD	datetime,
@OrigenFechaA	datetime,
@OrigenTodoElDia	bit,
@OrigenHoraD	varchar(5),
@OrigenHoraA	varchar(5),
@Estado		varchar(30),
@EstadoAnterior	varchar(30),
@Avance		float,
@AvanceAnterior	float,
@FechaD		datetime,
@FechaA		datetime,
@TodoElDia		bit,
@HoraD		varchar(5),
@HoraA		varchar(5),
@Motivo		varchar(255),
@Estatus          		char(15),
@EstatusNuevo		char(15),
@Ejercicio	      		int,
@Periodo	      		int,
@GenerarMovID		varchar(20),
@GenerarPoliza		bit,
@CfgContX			bit,
@CfgContXGenerar		char(20),
@RequiereAutorizacion	bit,
@OPORT				bit,
@ProyEnviarTareaGestion bit,
@Esfuerzo			float,
@EsfuerzoAnterior	float
SELECT @Generar	   = 0,
@GenerarAfectado  = 0,
@CfgContX         = 0,
@CfgContXGenerar  = 'NO'/*,
@Verificar        = 1*/
SELECT @Sucursal = Sucursal, @SucursalDestino = SucursalDestino, @SucursalOrigen = SucursalOrigen, @Empresa = Empresa, @MovID = MovID, @Mov = Mov, @FechaEmision = FechaEmision, @Proyecto = NULLIF(RTRIM(Proyecto), ''), @UEN = UEN,
@MovUsuario = Usuario, @Autorizacion = Autorizacion, @FechaAutorizacion = FechaAutorizacion,
@DocFuente = DocFuente, @Observaciones = Observaciones, @Estatus = UPPER(Estatus),
@FechaConclusion = FechaConclusion,
@Concepto = Concepto, @Referencia = Referencia,
@IDOrigen = IDOrigen, @OrigenTipo = NULLIF(RTRIM(OrigenTipo), ''), @Origen = NULLIF(RTRIM(Origen), ''), @OrigenID = NULLIF(RTRIM(OrigenID), ''),
@FechaD = FechaD, @FechaA = FechaA, @TodoElDia = ISNULL(TodoElDia, 0), @HoraD = ISNULL(RTRIM(HoraD), ''), @HoraA = ISNULL(RTRIM(HoraA), ''),
@Motivo = NULLIF(RTRIM(Motivo), ''),
@Estado = Estado, @EstadoAnterior = EstadoAnterior, @Avance = ISNULL(Avance, 0.0), @AvanceAnterior = ISNULL(AvanceAnterior, 0.0),
@Esfuerzo = ISNULL(Esfuerzo, 0.0), @EsfuerzoAnterior = ISNULL(EsfuerzoAnterior, 0.0),
@Prioridad = Prioridad
FROM Gestion
WHERE ID = @ID
IF @Accion = 'AUTORIZAR' AND @Estatus = 'AUTORIZAR'
BEGIN
IF EXISTS(SELECT * FROM Usuario WHERE Usuario = @Usuario AND Autorizar = 1 AND AutorizarGestion = 1)
SELECT @Autorizacion = @Usuario, @FechaAutorizacion = @FechaRegistro, @Estatus = 'SINAFECTAR', @Accion = 'AFECTAR'
ELSE SELECT @Ok = 46130
END
IF @IDOrigen IS NULL AND @OrigenTipo = @Modulo AND @Origen IS NOT NULL AND @OrigenID IS NOT NULL
SELECT @IDOrigen = MIN(ID) FROM Gestion WHERE Empresa = @Empresa AND Mov = @Origen AND MovID = @OrigenID AND Estatus IN ('PENDIENTE', 'ALTAPRIORIDAD', 'PRIORIDADBAJA', 'CONCLUIDO')
IF @IDOrigen IS NOT NULL
BEGIN
SELECT @RamaID = ISNULL(RamaID, ID),
@OrigenFechaD = FechaD,
@OrigenFechaA = FechaA,
@OrigenTodoElDia = ISNULL(TodoElDia, 0),
@OrigenHoraD = ISNULL(RTRIM(HoraD), ''),
@OrigenHoraA = ISNULL(RTRIM(HoraA), '')
FROM Gestion
WHERE ID = @IDOrigen
UPDATE Gestion
SET RamaID = @RamaID,
IDOrigen = @IDOrigen
WHERE ID = @ID
END
IF @IDOrigen IS NOT NULL
SELECT @OrigenMovTipo = Clave
FROM MovTipo
WHERE Modulo = @Modulo AND Mov = @Origen
IF NULLIF(RTRIM(@Usuario), '') IS NULL SELECT @Usuario = @MovUsuario
EXEC spFechaAfectacion @Empresa, @Modulo, @ID, @Accion, @FechaEmision OUTPUT, @FechaRegistro, @FechaAfectacion OUTPUT
EXEC spExtraerFecha @FechaAfectacion OUTPUT
EXEC spMovTipo @Modulo, @Mov, @FechaAfectacion, @Empresa, NULL, NULL, @MovTipo OUTPUT, @Periodo OUTPUT, @Ejercicio OUTPUT, @Ok OUTPUT
EXEC spMovOk @SincroFinal, @ID, @Estatus, @Sucursal, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @FechaAfectacion, @FechaRegistro, @Ejercicio, @Periodo, @Proyecto, @Ok OUTPUT, @OkRef OUTPUT
SELECT @RequiereAutorizacion = ISNULL(RequiereAutorizacion, 0)
FROM MovTipo
WHERE Modulo = @Modulo AND Mov = @Mov
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
IF (@Accion <> 'CANCELAR' AND @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'PENDIENTE', 'ALTAPRIORIDAD', 'PRIORIDADBAJA')) OR
(@Accion = 'CANCELAR'  AND @Estatus IN ('CONCLUIDO', 'PENDIENTE', 'ALTAPRIORIDAD', 'PRIORIDADBAJA'))
BEGIN
SELECT @CfgContX = ContX,
@OPORT	= ISNULL(OPORT, 0)
FROM EmpresaGral
WHERE Empresa = @Empresa
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @ProyEnviarTareaGestion = ProyEnviarTareaGestion
FROM EmpresaCfg
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
ELSE BEGIN
IF @RequiereAutorizacion = 1 AND @Autorizacion IS NULL AND @FechaAutorizacion IS NULL
SELECT @EstatusNuevo = 'AUTORIZAR'
ELSE BEGIN
SELECT @EstatusNuevo = 'CONCLUIDO'
IF @MovTipo IN ('GES.REU', 'GES.TAR')
SELECT @EstatusNuevo = dbo.fnTareaEstadoEnEstatus(@Estado)
ELSE
IF @MovTipo IN ('GES.SRES', 'GES.REU', 'GES.STAR', 'GES.OTAR')
IF EXISTS(SELECT * FROM GestionPara WHERE ID = @ID AND UPPER(Participacion) = 'REQUERIDO')
SELECT @EstatusNuevo = CASE UPPER(@Prioridad) WHEN 'ALTA' THEN 'ALTAPRIORIDAD' WHEN 'BAJA' THEN 'PRIORIDADBAJA' ELSE 'PENDIENTE' END
END
END
IF @MovTipo IN ('GES.SRES', 'GES.REU', 'GES.STAR', 'GES.OTAR') AND @Accion = 'CANCELAR' AND @Estatus = 'PENDIENTE'
EXEC spGestionCancelarHijos @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal, @Mov, @MovID, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
IF (@Conexion = 0 OR @Accion = 'CANCELAR') AND @Accion NOT IN ('GENERAR', 'CONSECUTIVO'/*, 'SINCRO'*/) AND @Ok IS NULL
BEGIN
EXEC spGestionVerificar @ID, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio, @FechaEmision, @Estatus, @EstatusNuevo,
@Conexion, @SincroFinal, @Sucursal, @MovUsuario,
@IDOrigen, @OrigenTipo, @Origen, @OrigenID, @OrigenMovTipo, @OrigenFechaD, @OrigenFechaA, @OrigenTodoElDia, @OrigenHoraD, @OrigenHoraA,
@Estado, @Avance, @FechaD, @FechaA, @TodoElDia, @HoraD, @HoraA, @Motivo,
@Ok OUTPUT, @OkRef OUTPUT
IF @Ok BETWEEN 80000 AND 89999 AND @Accion IN ('AFECTAR', 'CANCELAR') SELECT @Ok = NULL ELSE
IF @Accion = 'VERIFICAR' AND @Ok IS NULL
BEGIN
SELECT @Ok = 80000
EXEC xpOk_80000 @Empresa, @Usuario, @Accion, @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
END
END
IF @Accion IN ('AFECTAR', 'GENERAR', 'CANCELAR','CONSECUTIVO','SINCRO') AND @Ok IS NULL
EXEC spGestionAfectar @ID, @Accion, @Base, @Empresa, @Modulo, @Mov, @MovID OUTPUT, @MovTipo, @MovMoneda, @MovTipoCambio, @FechaEmision, @FechaAfectacion, @FechaConclusion,
@Proyecto, @UEN, @Usuario, @Autorizacion, @FechaAutorizacion, @DocFuente, @Observaciones, @Concepto, @Referencia,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo, @MovUsuario,
@IDOrigen, @OrigenTipo, @Origen, @OrigenID, @OrigenMovTipo,
@Estado, @EstadoAnterior, @Avance, @AvanceAnterior, @Esfuerzo, @EsfuerzoAnterior,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen, @CfgContX, @CfgContXGenerar, @GenerarPoliza,
@Generar, @GenerarMov, @GenerarAfectado, @OPORT, @ProyEnviarTareaGestion,  @IDGenerar OUTPUT, @GenerarMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
END ELSE
BEGIN
IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'AUTORIZAR') AND @Accion = 'CANCELAR' EXEC spMovCancelarSinAfectar @Modulo, @ID, @Ok OUTPUT ELSE
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

