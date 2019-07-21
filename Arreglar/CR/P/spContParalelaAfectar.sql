SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContParalelaAfectar
@ID                		int,
@Accion					char(20),
@Empresa	      		char(5),
@Modulo	      			char(5),
@Mov	  	      		char(20),
@MovID             		varchar(20)	OUTPUT,
@MovTipo     			char(20),
@FechaEmision      		datetime,
@FechaAfectacion		datetime,
@FechaConclusion		datetime,
@Proyecto	      		varchar(50),
@Usuario	      		char(10),
@Autorizacion      		char(10),
@DocFuente	      		int,
@Observaciones     		varchar(255),
@Concepto     			varchar(50),
@Referencia				varchar(50),
@Estatus           		char(15),
@EstatusNuevo			char(15),
@FechaRegistro     		datetime,
@Ejercicio	      		int,
@Periodo	      		int,
@MovUsuario				char(10),
@CuentaD				varchar(20),
@CuentaA				varchar(20),
@Nivel					varchar(10),
@BaseDatos				varchar(255),
@EmpresaOrigen			varchar(5),
@CPBaseLocal			bit,
@CPBaseDatos			varchar(255),
@CPURL					varchar(255),
@CPCentralizadora		bit,
@CPUsuario				varchar(10),
@CPContrasena			varchar(32),
@ISReferencia			varchar(100),
@Conexion				bit,
@SincroFinal			bit,
@Sucursal				int,
@SucursalDestino		int,
@SucursalOrigen			int,
@CfgContX				bit,
@CfgContXGenerar		char(20),
@GenerarPoliza			bit,
@IDEmpresa				int,
@CONTEsCancelacion		bit,
@GeneraEjercicio		int,
@GeneraPeriodo			int,
@GeneraFechaD			datetime,
@GeneraFechaA			datetime,
@GeneraEmpresaOrigen	int,
@OrigenTipo				varchar(5),
@Origen					varchar(20),
@OrigenID				varchar(20),
@IDOrigen				int,
@GeneraMov				varchar(20),
@GeneraMovID			varchar(20),
@GeneraContMov			varchar(20),
@GeneraContMovID		varchar(20),
@GeneraContID			int,
@Generar				bit,
@GenerarMov				char(20),
@GenerarAfectado		bit,
@IDGenerar				int	     		OUTPUT,
@GenerarMovID	  		varchar(20)		OUTPUT,
@Ok                		int				OUTPUT,
@OkRef             		varchar(255)	OUTPUT

AS BEGIN
DECLARE @FechaCancelacion		datetime,
@GenerarMovTipo		varchar(20),
@GenerarEjercicio		int,
@GenerarPeriodo		int,
@XML					varchar(max),
@Resultado			varchar(max)
EXEC spMovConsecutivo @Sucursal, @SucursalOrigen, @SucursalDestino, @Empresa, @Usuario, @Modulo, @Ejercicio, @Periodo, @ID, @Mov, NULL, @Estatus, @Concepto, @Accion, @Conexion, @SincroFinal, @MovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR') AND @Accion <> 'CANCELAR' AND @Ok IS NULL
EXEC spMovChecarConsecutivo	@Empresa, @Modulo, @Mov, @MovID, NULL, @Ejercicio, @Periodo, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion IN ('CONSECUTIVO', 'SINCRO') AND @Ok IS NULL
BEGIN
IF @Accion = 'SINCRO' EXEC spAsignarSucursalEstatus @ID, @Modulo, @SucursalDestino, @Accion
SELECT @Ok = 80060, @OkRef = @MovID
RETURN
END
IF @OK IS NOT NULL RETURN
IF @Accion = 'GENERAR' AND @Ok IS NULL
BEGIN
EXEC spMovGenerar @Sucursal, @Empresa, @Modulo, @Ejercicio, @Periodo, @Usuario, @FechaRegistro, 'SINAFECTAR',
NULL, NULL,
@Mov, @MovID, 0,
@GenerarMov, NULL, @GenerarMovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spMovTipo @Modulo, @GenerarMov, @FechaAfectacion, @Empresa, NULL, NULL, @GenerarMovTipo OUTPUT, @GenerarPeriodo OUTPUT, @GenerarEjercicio OUTPUT, @Ok OUTPUT
RETURN
END
IF @Conexion = 0
BEGIN TRANSACTION
EXEC spMovEstatus @Modulo, 'AFECTANDO', @ID, @Generar, @IDGenerar, @GenerarAfectado, @Ok OUTPUT
IF @Accion <> 'CANCELAR'
EXEC spRegistrarMovimiento @Sucursal, @Empresa, @Modulo, @Mov, @MovID, @ID, @Ejercicio, @Periodo, @FechaRegistro, @FechaEmision,
NULL, @Proyecto, NULL, NULL,
@Usuario, @Autorizacion, NULL, @DocFuente, @Observaciones,
@Generar, @GenerarMov, @GenerarMovID, @IDGenerar,
@Ok OUTPUT
IF @Accion IN ('AFECTAR', 'CANCELAR')
BEGIN
IF @Ok IS NULL AND @Accion = 'AFECTAR' AND @MovTipo IN('CONTP.ENVIARCUENTAS')
BEGIN
EXEC spContParalelaCtaObtener @ID, @CuentaD, @CuentaA, @Nivel, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spContParalelaXMLGenerar @ID, @Empresa, @Mov, @MovID, @MovTipo, @BaseDatos, @EmpresaOrigen, @CuentaD, @CuentaA, @Nivel, @CPBaseLocal, @CPBaseDatos, @CPURL, @CPCentralizadora, @CPUsuario, @CPContrasena, @ISReferencia, @IDEmpresa, /*REQ25300*/ @CONTEsCancelacion, @XML OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @CPCentralizadora = 0
EXEC spContParalelaXMLSolicitud @ID, @Empresa, @Mov, @MovID, @MovTipo, @BaseDatos, @EmpresaOrigen, @CuentaD, @CuentaA, @CPBaseLocal, @CPBaseDatos, @CPURL, @CPCentralizadora, @CPUsuario, @CPContrasena, @XML, @ISReferencia, @IDEmpresa, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @CPCentralizadora = 0
EXEC spContParalelaXMLLeerResultado @ID, @Empresa, @Mov, @MovID, @MovTipo, @BaseDatos, @EmpresaOrigen, @CuentaD, @CuentaA, @CPBaseLocal, @CPBaseDatos, @CPURL, @CPCentralizadora, @CPUsuario, @CPContrasena, @Resultado, @ISReferencia, @IDEmpresa, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL AND @CPCentralizadora = 1 AND @Accion = 'AFECTAR' AND @MovTipo = 'CONTP.RECIBIRCUENTA'
BEGIN
EXEC spContParalelaCtaRecibir @ID, @Empresa, @Mov, @MovID, @BaseDatos, @EmpresaOrigen, @IDEmpresa, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spContParalelaXMLGenerar @ID, @Empresa, @Mov, @MovID, @MovTipo, @BaseDatos, @EmpresaOrigen, @CuentaD, @CuentaA, @Nivel, @CPBaseLocal, @CPBaseDatos, @CPURL, @CPCentralizadora, @CPUsuario, @CPContrasena, @ISReferencia, @IDEmpresa, /*REQ25300*/ @CONTEsCancelacion, @XML OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL AND @EstatusNuevo IN('CONCLUIDO', 'CANCELADO') AND @MovTipo = 'CONTP.GENERADORPAQ'
BEGIN
EXEC spContParalelaPaqueteGenerar @ID, @Accion, @Sucursal, @Usuario, @Empresa, @Mov, @MovID, @MovTipo, @BaseDatos, @EmpresaOrigen, @CuentaD, @CuentaA, @Nivel, @CPBaseLocal, @CPBaseDatos, @CPURL, @CPCentralizadora, @CPUsuario, @CPContrasena, @ISReferencia, @IDEmpresa, @GeneraEjercicio, @GeneraPeriodo, @GeneraFechaD, @GeneraFechaA, @XML OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL AND @EstatusNuevo IN('CONCLUIDO') AND @MovTipo = 'CONTP.PAQUETE'
BEGIN
IF @Ok IS NULL
EXEC spContParalelaPolizaObtener @ID, @Accion, @Sucursal, @Usuario, @Empresa, @Mov, @MovID, @MovTipo, @BaseDatos, @EmpresaOrigen, @CuentaD, @CuentaA, @Nivel, @CPBaseLocal, @CPBaseDatos, @CPURL, @CPCentralizadora, @CPUsuario, @CPContrasena, @ISReferencia, @IDEmpresa, @GeneraEjercicio, @GeneraPeriodo, @GeneraFechaD, @GeneraFechaA, @GeneraMov, @GeneraMovID, @GeneraContMov, @GeneraContMovID, /*REQ25300*/ @CONTEsCancelacion, @GeneraContID OUTPUT, @XML OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spContParalelaXMLGenerar @ID, @Empresa, @Mov, @MovID, @MovTipo, @BaseDatos, @EmpresaOrigen, @CuentaD, @CuentaA, @Nivel, @CPBaseLocal, @CPBaseDatos, @CPURL, @CPCentralizadora, @CPUsuario, @CPContrasena, @ISReferencia, @IDEmpresa, /*REQ25300*/ @CONTEsCancelacion, @XML OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @CPCentralizadora = 0
EXEC spContParalelaXMLSolicitud @ID, @Empresa, @Mov, @MovID, @MovTipo, @BaseDatos, @EmpresaOrigen, @CuentaD, @CuentaA, @CPBaseLocal, @CPBaseDatos, @CPURL, @CPCentralizadora, @CPUsuario, @CPContrasena, @XML, @ISReferencia, @IDEmpresa, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @CPCentralizadora = 0
EXEC spContParalelaXMLLeerResultado @ID, @Empresa, @Mov, @MovID, @MovTipo, @BaseDatos, @EmpresaOrigen, @CuentaD, @CuentaA, @CPBaseLocal, @CPBaseDatos, @CPURL, @CPCentralizadora, @CPUsuario, @CPContrasena, @Resultado, @ISReferencia, @IDEmpresa, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL AND @CPCentralizadora = 1 AND @EstatusNuevo IN('CONCLUIDO') AND @MovTipo = 'CONTP.RECIBIRPAQUETE'
BEGIN
EXEC spContParalelaPaqueteRecibir @ID, @Empresa, @Mov, @MovID, @BaseDatos, @EmpresaOrigen, @IDEmpresa, /*REQ25300*/ @CONTEsCancelacion, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spContParalelaPaqueteContabilizar @ID, @Empresa, @Mov, @MovID, @BaseDatos, @EmpresaOrigen, @IDEmpresa, /*REQ25300*/ @CONTEsCancelacion, @Usuario, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spContParalelaXMLGenerar @ID, @Empresa, @Mov, @MovID, @MovTipo, @BaseDatos, @EmpresaOrigen, @CuentaD, @CuentaA, @Nivel, @CPBaseLocal, @CPBaseDatos, @CPURL, @CPCentralizadora, @CPUsuario, @CPContrasena, @ISReferencia, @IDEmpresa, /*REQ25300*/ @CONTEsCancelacion, @XML OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL AND @CPCentralizadora = 1 AND @EstatusNuevo IN('CONCLUIDO', 'CANCELADO') AND @MovTipo = 'CONTP.TRANSFORMACION'
BEGIN
EXEC spContParalelaPolizaGenerar @ID, @Accion, @Sucursal, @Usuario, @Empresa, @Mov, @MovID, @MovTipo, @BaseDatos, @EmpresaOrigen, @CuentaD, @CuentaA, @Nivel, @CPBaseLocal, @CPBaseDatos, @CPURL, @CPCentralizadora, @CPUsuario, @CPContrasena, @ISReferencia, @IDEmpresa, @GeneraEjercicio, @GeneraPeriodo, @GeneraFechaD, @GeneraFechaA, @GeneraEmpresaOrigen, @GeneraMov, @GeneraMovID, @GeneraContMov, @GeneraContMovID, /*REQ25300*/ @CONTEsCancelacion, @XML OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL AND @CPCentralizadora = 1 AND @EstatusNuevo IN('CONCLUIDO', 'CANCELADO') AND @MovTipo = 'CONTP.POLIZA'
BEGIN
EXEC spContParalelaPolizaContabilizar @ID, @Accion, @Sucursal, @Usuario, @Empresa, @Mov, @MovID, @FechaEmision, @Referencia, @MovTipo, @BaseDatos, @EmpresaOrigen, @CuentaD, @CuentaA, @Nivel, @CPBaseLocal, @CPBaseDatos, @CPURL, @CPCentralizadora, @CPUsuario, @CPContrasena, @ISReferencia, @IDEmpresa, @GeneraEjercicio, @GeneraPeriodo, @GeneraFechaD, @GeneraFechaA, @GeneraEmpresaOrigen, @XML OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL AND @CPCentralizadora = 1 AND @EstatusNuevo IN('CONCLUIDO', 'CANCELADO') AND @MovTipo = 'CONTP.CIERRE'
BEGIN
EXEC spContParalelaCierrePeriodo @ID, @Accion, @Sucursal, @Usuario, @Empresa, @Mov, @MovID, @FechaEmision, @Referencia, @MovTipo, @BaseDatos, @EmpresaOrigen, @CuentaD, @CuentaA, @Nivel, @CPBaseLocal, @CPBaseDatos, @CPURL, @CPCentralizadora, @CPUsuario, @CPContrasena, @ISReferencia, @IDEmpresa, @GeneraEjercicio, @GeneraPeriodo, @GeneraFechaD, @GeneraFechaA, @GeneraEmpresaOrigen, @XML OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL AND @CPCentralizadora = 1
UPDATE ContParalelaEmpresa SET TieneMovimientos = 1 WHERE ID = @IDEmpresa
IF @Ok IN (NULL, 80030)
BEGIN
IF @EstatusNuevo = 'CANCELADO' SELECT @FechaCancelacion = @FechaRegistro ELSE SELECT @FechaCancelacion = NULL
IF @EstatusNuevo = 'CONCLUIDO' SELECT @FechaConclusion  = @FechaEmision  ELSE IF @EstatusNuevo <> 'CANCELADO' SELECT @FechaConclusion  = NULL
IF @CfgContX = 1 AND @CfgContXGenerar <> 'NO'
BEGIN
IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @EstatusNuevo <> 'CANCELADO' SELECT @GenerarPoliza = 1 ELSE
IF @Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @EstatusNuevo =  'CANCELADO' IF @GenerarPoliza = 1 SELECT @GenerarPoliza = 0 ELSE SELECT @GenerarPoliza = 1
END
EXEC spValidarTareas @Empresa, @Modulo, @ID, @EstatusNuevo, @Ok OUTPUT, @OkRef OUTPUT
UPDATE ContParalela
SET FechaConclusion  = @FechaConclusion,
FechaCancelacion = @FechaCancelacion,
UltimoCambio     = CASE WHEN UltimoCambio IS NULL THEN @FechaRegistro ELSE UltimoCambio END,
Estatus          = @EstatusNuevo,
Situacion 	    = CASE WHEN @Estatus<>@EstatusNuevo THEN NULL ELSE Situacion END,
GenerarPoliza    = @GenerarPoliza
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
END
END
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spMovFinal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
BEGIN
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @OrigenTipo, @IDOrigen, @Origen, @OrigenID, @Modulo, @ID, @Mov, @MovID, @Ok OUTPUT
END
IF @Accion = 'CANCELAR' AND @EstatusNuevo = 'CANCELADO' AND @Ok IS NULL
EXEC spCancelarFlujo @Empresa, @Modulo, @ID, @Ok OUTPUT, 1
IF @Conexion = 0
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
COMMIT TRANSACTION
ELSE
BEGIN
DECLARE @PolizaDescuadrada TABLE (Cuenta varchar(20) NULL, SubCuenta varchar(50) NULL, Concepto varchar(50) NULL, Debe money NULL, Haber money NULL, SucursalContable int NULL)
IF EXISTS(SELECT * FROM PolizaDescuadrada WHERE Modulo = @Modulo AND ID = @ID)
INSERT @PolizaDescuadrada (Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable) SELECT Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable FROM PolizaDescuadrada WHERE Modulo = @Modulo AND ID = @ID
ROLLBACK TRANSACTION
DELETE PolizaDescuadrada WHERE Modulo = @Modulo AND ID = @ID
INSERT PolizaDescuadrada (Modulo, ID, Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable) SELECT @Modulo, @ID, Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable FROM @PolizaDescuadrada
END
RETURN
END

