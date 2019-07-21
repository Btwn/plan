SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spContParalelaPolizaGenerar
@ID						int,
@Accion					varchar(20),
@Sucursal				int,
@Usuario				varchar(10),
@Empresa				varchar(5),
@Mov					varchar(20),
@MovID					varchar(20),
@MovTipo				varchar(20),
@BaseDatos				varchar(255),
@EmpresaOrigen			varchar(5),
@CuentaD				varchar(20),
@CuentaA				varchar(20),
@Nivel					varchar(20),
@CPBaseLocal			bit,
@CPBaseDatos			varchar(255),
@CPURL					varchar(255),
@CPCentralizadora		bit,
@CPUsuario				varchar(10),
@CPContrasena			varchar(32),
@ISReferencia			varchar(100),
@IDEmpresa				int,
@GeneraEjercicio		int,
@GeneraPeriodo			int,
@GeneraFechaD			datetime,
@GeneraFechaA			datetime,
@GeneraEmpresaOrigen	int,
@GeneraMov				varchar(20),
@GeneraMovID			varchar(20),
@GeneraContMov			varchar(20),
@GeneraContMovID		varchar(20),
@CONTEsCancelacion		bit,
@XML					varchar(max)	OUTPUT,
@Ok						int				OUTPUT,
@OkRef					varchar(255)	OUTPUT

AS
BEGIN
DECLARE @GenerarMov			varchar(20),
@FechaTrabajo			datetime,
@GeneraID				int,
@CONTPConcluirPolizas	bit,
@IDCancela			int,
@IDCancelaAnt			int,
@IDEmpresaAux			int,
@IDEmpresaAuxAnt		int,
@IDAux				int,
@IDAuxAnt				int,
@CPPolizaID			int,
@BaseDatosRemota		varchar(255),
@EmpresaRemota		varchar(255),
@CONTPEnLinea			bit
SELECT @FechaTrabajo = GETDATE()
EXEC spExtraerFecha @FechaTrabajo OUTPUT
SELECT @GenerarMov = CPPoliza FROM EmpresaCfgMovContParalela WHERE Empresa = @Empresa
SELECT @CONTPConcluirPolizas = ISNULL(CONTPConcluirPolizas, 0), @CONTPEnLinea = ISNULL(CONTPEnLinea, 0) FROM EmpresaCfg2 WHERE Empresa = @Empresa
IF @Accion = 'AFECTAR'
BEGIN
SELECT @IDEmpresaAuxAnt = 0
WHILE(1=1)
BEGIN
SELECT @IDEmpresaAux = MIN(ID)
FROM ContParalelaEmpresa
WHERE Empresa = @Empresa
AND ID = ISNULL(@GeneraEmpresaOrigen, ID)
AND ID > @IDEmpresaAuxAnt
IF @IDEmpresaAux IS NULL BREAK
SELECT @IDEmpresaAuxAnt = @IDEmpresaAux
SELECT @BaseDatosRemota = NULL,  @EmpresaRemota = NULL
SELECT @BaseDatosRemota = BaseDatosRemota,  @EmpresaRemota = EmpresaRemota FROM ContParalelaEmpresa WHERE ID = @IDEmpresaAux
SELECT @IDAuxAnt = 0
WHILE(1=1)
BEGIN
SELECT @IDAux = MIN(ID)
FROM ContParalelaPoliza
WHERE IDEmpresa = @IDEmpresaAux
AND ID > @IDAuxAnt
AND CPPolizaID IS NULL
AND Mov   = ISNULL(@GeneraMov, Mov)
AND MovID = ISNULL(@GeneraMovID, MovID)
AND Estatus = CASE @CONTEsCancelacion WHEN 1 THEN 'CANCELADO' ELSE 'CONCLUIDO' END
IF @IDAux IS NULL BREAK
SELECT @IDAuxAnt = @IDAux
SELECT @CPPolizaID = NULL
EXEC spContParalelaPolizaConstruir @ID, @Sucursal, @Usuario, @Empresa, @Mov, @MovID, @IDEmpresaAux, @IDAux, @GenerarMov, @FechaTrabajo, @BaseDatosRemota, @EmpresaRemota, /*REQ25300*/ @CONTEsCancelacion, @CPPolizaID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @CONTPConcluirPolizas = 1 OR (@CONTPEnLinea = 1)
EXEC spAfectar 'CONTP', @CPPolizaID, 'AFECTAR', @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
END
END
ELSE IF @Accion = 'CANCELAR'
BEGIN
DELETE ContParalelaD
WHERE ID IN(SELECT ID FROM ContParalela WHERE Mov = @GenerarMov AND OrigenTipo = 'CONTP' AND Origen = @Mov AND OrigenID = @MovID AND Estatus = 'CONFIRMAR')
DELETE ContParalela WHERE Mov = @GenerarMov AND OrigenTipo = 'CONTP' AND Origen = @Mov AND OrigenID = @MovID AND Estatus = 'CONFIRMAR'
SELECT @IDCancelaAnt = 0
WHILE(1=1)
BEGIN
SELECT @IDCancela = MIN(ID)
FROM ContParalela
WHERE Mov = @GenerarMov
AND OrigenTipo = 'CONTP'
AND Origen = @Mov
AND OrigenID = @MovID
AND Estatus = 'CONCLUIDO'
AND ID > @IDCancelaAnt
IF @IDCancela IS NULL BREAK
SELECT @IDCancelaAnt = @IDCancela
EXEC spAfectar 'CONTP', @IDCancela, 'CANCELAR', @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
END
RETURN
END

