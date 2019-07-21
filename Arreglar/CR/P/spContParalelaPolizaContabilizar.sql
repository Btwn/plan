SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spContParalelaPolizaContabilizar
@ID						int,
@Accion					varchar(20),
@Sucursal				int,
@Usuario				varchar(10),
@Empresa				varchar(5),
@Mov					varchar(20),
@MovID					varchar(20),
@FechaEmision			datetime,
@Referencia				varchar(50),
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
@XML					varchar(max)	OUTPUT,
@Ok						int				OUTPUT,
@OkRef					varchar(255)	OUTPUT

AS
BEGIN
DECLARE @Moneda			varchar(10),
@TipoCambio		float,
@GeneraMov		varchar(20),
@ContID			int,
@IDAux			int,
@ContMov			varchar(20),
@FechaRegistro	datetime
SELECT @FechaRegistro = GETDATE()
SELECT @IDAux = IDAux FROM ContParalela WHERE ID = @ID
SELECT @ContMov = Mov FROM ContParalelaPoliza WHERE IDEmpresa = @IDEmpresa AND ID = @IDAux
SELECT @GeneraMov = Mov FROM MovTipo WHERE Modulo = 'CONT' AND Mov = @ContMov
IF @GeneraMov IS NULL
SELECT @GeneraMov = Mov FROM ContParalelaMovPoliza WHERE IDEmpresa = @IDEmpresa AND MovOrigen = @ContMov
IF @GeneraMov IS NULL
BEGIN
SELECT @Ok = 30170, @OkRef = @ContMov
RETURN
END
IF @Accion = 'AFECTAR'
BEGIN
SELECT @Moneda = ContMoneda FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @TipoCambio = TipoCambio FROM Mon WHERE Moneda = @Moneda
INSERT INTO Cont(
Empresa,  Mov,        FechaEmision,  FechaContable,  Moneda,  TipoCambio,  Usuario,  Referencia, Estatus,      OrigenTipo,  Origen,  OrigenID,  Sucursal)
SELECT @Empresa, @GeneraMov, @FechaEmision, @FechaEmision,  @Moneda, @TipoCambio, @Usuario, @Referencia, 'SINAFECTAR', 'CONTP',    @Mov,    @MovID,    @Sucursal
SELECT @ContID = SCOPE_IDENTITY()
INSERT INTO ContD(
ID,     Renglon, RenglonSub, Cuenta, Debe, Haber)
SELECT @ContID, Renglon, 0,          Cuenta, Debe, Haber
FROM ContParalelaD
WHERE ID = @ID
IF @ContID IS NOT NULL
EXEC spAfectar 'CONT', @ContID, 'AFECTAR', @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
UPDATE ContParalelaPoliza SET CPPolizaID = @ID WHERE IDEmpresa = @IDEmpresa AND ID = @IDAux
END
ELSE
BEGIN
SELECT @ContID = ID
FROM Cont
WHERE Empresa = @Empresa
AND Mov = @GeneraMov
AND OrigenTipo = 'CONTP'
AND Origen = @Mov
AND OrigenID = @MovID
AND Estatus = 'CONCLUIDO'
IF @ContID IS NOT NULL
EXEC spAfectar 'CONT', @ContID, 'CANCELAR', @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
UPDATE ContParalelaPoliza SET CPPolizaID = NULL WHERE IDEmpresa = @IDEmpresa AND ID = @IDAux
END
RETURN
END

