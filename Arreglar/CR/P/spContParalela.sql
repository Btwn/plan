SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContParalela
@ID             int,
@Modulo	      	char(5),
@Accion			char(20),
@Base			char(20),
@FechaRegistro	datetime,
@GenerarMov		char(20),
@Usuario		char(10),
@Conexion		bit,
@SincroFinal	bit,
@Mov	      	char(20)	OUTPUT,
@MovID          varchar(20)	OUTPUT,
@IDGenerar		int			OUTPUT,
@Ok				int			OUTPUT,
@OkRef			varchar(255)OUTPUT

AS BEGIN
DECLARE
@Generar				bit,
@GenerarAfectado		bit,
@Sucursal				int,
@SucursalDestino		int,
@SucursalOrigen			int,
@EnLinea				bit,
@PuedeEditar			bit,
@IDEmpresa				int,
@Empresa	      		char(5),
@MovTipo   				char(20),
@FechaEmision     		datetime,
@FechaAfectacion		datetime,
@FechaConclusion		datetime,
@Proyecto	      		varchar(50),
@MovUsuario	      		char(10),
@Autorizacion     		char(10),
@DocFuente	      		int,
@Concepto    			varchar(50),
@Referencia 			varchar(50),
@Observaciones    		varchar(255),
@Estatus          		char(15),
@EstatusNuevo			char(15),
@Ejercicio	      		int,
@Periodo	      		int,
@GenerarMovID			varchar(20),
@GenerarPoliza			bit,
@CfgContX				bit,
@CfgContXGenerar		char(20),
@CuentaD				varchar(20),
@CuentaA				varchar(20),
@Nivel					varchar(10),
@OrigenTipo				varchar(5),
@Origen					varchar(20),
@OrigenID				varchar(20),
@IDOrigen				int,
@MonedaOrigen			varchar(10),
@BaseDatos				varchar(255),
@EmpresaOrigen			varchar(5),
@CPBaseLocal			bit,
@CPBaseDatos			varchar(255),
@CPURL					varchar(255),
@CPCentralizadora		bit,
@CPUsuario				varchar(10),
@CPContrasena			varchar(32),
@ISReferencia			varchar(100),
@GeneraEjercicio		int,
@GeneraPeriodo			int,
@GeneraFechaD			datetime,
@GeneraFechaA			datetime,
@GeneraEmpresaOrigen	int,
@GeneraMov				varchar(20),
@GeneraMovID			varchar(20),
@GeneraContMov			varchar(20),
@GeneraContMovID		varchar(20),
@GeneraContID			int,
@CONTEsCancelacion		bit
SELECT @CPBaseLocal		= ISNULL(CPBaseLocal, 0),
@CPBaseDatos		= NULLIF(RTRIM(CPBaseDatos), ''),
@CPURL				= NULLIF(RTRIM(CPURL), ''),
@CPCentralizadora	= ISNULL(CPCentralizadora, 0),
@CPUsuario			= ISNULL(CPUsuario, 0),
@CPContrasena		= ISNULL(CPContrasena, 0)
FROM Version
SELECT @Generar	   = 0,
@GenerarAfectado  = 0,
@CfgContX         = 0,
@CfgContXGenerar  = 'NO'/*,
@Verificar        = 1*/
IF @Accion = 'CANCELAR' SELECT @EstatusNuevo = 'CANCELADO' ELSE SELECT @EstatusNuevo = 'CONCLUIDO'
SELECT @Sucursal = Sucursal, @SucursalDestino = SucursalDestino, @SucursalOrigen = SucursalOrigen, @Empresa = Empresa, @MovID = MovID, @Mov = Mov,
@FechaEmision = FechaEmision, @Proyecto = NULLIF(RTRIM(Proyecto), ''),@MovUsuario = Usuario, @Autorizacion = Autorizacion,
@DocFuente = DocFuente, @Observaciones = Observaciones, @Estatus = UPPER(Estatus), @GenerarPoliza = GenerarPoliza,
@FechaConclusion = FechaConclusion,@Concepto = Concepto, @Referencia = Referencia, @CuentaD = NULLIF(RTRIM(CuentaD), ''),
@CuentaA = NULLIF(RTRIM(CuentaA), ''), @Nivel = ISNULL(NULLIF(RTRIM(Nivel), ''), 'Auxiliar'), @OrigenTipo = OrigenTipo, @Origen = Origen,
@OrigenID = OrigenID, @BaseDatos = BaseDatosOrigen, @EmpresaOrigen = EmpresaOrigen, @IDEmpresa = IDEmpresa, @GeneraEjercicio = NULLIF(GeneraEjercicio, 0),
@GeneraPeriodo = NULLIF(GeneraPeriodo, 0), @GeneraFechaD = GeneraFechaD, @GeneraFechaA = GeneraFechaA, @GeneraEmpresaOrigen = GeneraEmpresaOrigen,
@GeneraMov = NULLIF(RTRIM(GeneraMov), ''), @GeneraMovID = NULLIF(RTRIM(GeneraMovID), ''), @GeneraContMov = NULLIF(RTRIM(GeneraContMov), ''), @GeneraContMovID = NULLIF(RTRIM(GeneraContMovID), ''),
@GeneraContID = ContID, /*REQ25300*/ @CONTEsCancelacion = ISNULL(CONTEsCancelacion, 0)
FROM ContParalela
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Origen IS NOT NULL AND @OrigenID IS NOT NULL
EXEC spContParalelaMovEnID @OrigenTipo, @Empresa, @Origen, @OrigenID, @IDOrigen OUTPUT, @MonedaOrigen OUTPUT, @Ok OUTPUT
ELSE
SELECT @IDOrigen = NULL
IF NULLIF(RTRIM(@Usuario), '') IS NULL SELECT @Usuario = @MovUsuario
EXEC spFechaAfectacion @Empresa, @Modulo, @ID, @Accion, @FechaEmision OUTPUT, @FechaRegistro, @FechaAfectacion OUTPUT
EXEC spExtraerFecha @FechaAfectacion OUTPUT
EXEC spMovTipo @Modulo, @Mov, @FechaAfectacion, @Empresa, NULL, NULL, @MovTipo OUTPUT, @Periodo OUTPUT, @Ejercicio OUTPUT, @Ok OUTPUT
EXEC spMovOk @SincroFinal, @ID, @Estatus, @Sucursal, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @FechaAfectacion, @FechaRegistro, @Ejercicio, @Periodo, @Proyecto, @Ok OUTPUT, @OkRef OUTPUT
SELECT @ISReferencia = CASE @MovTipo
WHEN 'CONTP.ENVIARCUENTAS' THEN 'ContParalela.CentralizarCuentas'
WHEN 'CONTP.PAQUETE'       THEN 'ContParalela.PaqueteContable'
ELSE ''
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
EXEC spAsignarSucursalEstatus @ID, @Modulo, @Sucursal, @Estatus
END
END
END
IF (@Accion <> 'CANCELAR' AND @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR', 'PENDIENTE')) OR
(@Accion = 'CANCELAR'  AND @Estatus IN ('CONCLUIDO', 'PENDIENTE'))
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
IF @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR') AND @Accion <> 'CANCELAR'
BEGIN
IF @MovTipo IN('CONTP.GENERADORPAQ', 'CONTP.PAQUETE', 'CONTP.TRANSFORMACION') AND @Estatus = 'SINAFECTAR'
SELECT @EstatusNuevo = 'PENDIENTE'
ELSE
SELECT @EstatusNuevo = 'CONCLUIDO'
END
IF /*(@Conexion = 0 OR @Accion = 'CANCELAR') AND */@Accion NOT IN ('GENERAR', 'CONSECUTIVO'/*, 'SINCRO'*/) AND @Ok IS NULL
BEGIN
EXEC spContParalelaVerificar @ID, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo, @FechaEmision, @Estatus, @EstatusNuevo,
@CuentaD, @CuentaA, @BaseDatos, @EmpresaOrigen, @CPBaseLocal, @CPBaseDatos, @CPURL, @CPCentralizadora, @CPUsuario, @CPContrasena ,@ISReferencia,
@OrigenTipo, @Origen, @OrigenID, @IDEmpresa, @GeneraEjercicio, @GeneraPeriodo, @GeneraFechaD, @GeneraFechaA, @GeneraEmpresaOrigen,
@GeneraMov, @GeneraMovID, @GeneraContMov, @GeneraContMovID, @GeneraContID,
@Conexion, @SincroFinal, @Sucursal, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok BETWEEN 80000 AND 89999 AND @Accion IN ('AFECTAR', 'CANCELAR') SELECT @Ok = NULL ELSE
IF @Accion = 'VERIFICAR' AND @Ok IS NULL
BEGIN
SELECT @Ok = 80000
EXEC xpOk_80000 @Empresa, @Usuario, @Accion, @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
END
END
IF @Accion IN ('AFECTAR', 'GENERAR', 'CANCELAR','CONSECUTIVO','SINCRO') AND @Ok IS NULL
EXEC spContParalelaAfectar @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID OUTPUT, @MovTipo, @FechaEmision, @FechaAfectacion, @FechaConclusion,
@Proyecto, @Usuario, @Autorizacion, @DocFuente, @Observaciones, @Concepto, @Referencia,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo, @MovUsuario,
@CuentaD, @CuentaA, @Nivel, @BaseDatos, @EmpresaOrigen, @CPBaseLocal, @CPBaseDatos, @CPURL, @CPCentralizadora, @CPUsuario, @CPContrasena, @ISReferencia,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen, @CfgContX, @CfgContXGenerar, @GenerarPoliza, @IDEmpresa, /*REQ25300*/ @CONTEsCancelacion,
@GeneraEjercicio, @GeneraPeriodo, @GeneraFechaD, @GeneraFechaA, @GeneraEmpresaOrigen,
@OrigenTipo, @Origen, @OrigenID, @IDOrigen, @GeneraMov, @GeneraMovID, @GeneraContMov, @GeneraContMovID, @GeneraContID,
@Generar, @GenerarMov, @GenerarAfectado, @IDGenerar OUTPUT, @GenerarMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
END ELSE
BEGIN
IF @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR') AND @Accion = 'CANCELAR' EXEC spMovCancelarSinAfectar @Modulo, @ID, @Ok OUTPUT ELSE
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

