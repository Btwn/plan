SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContParalelaPaqueteContabilizar
@ID					int,
@Empresa			varchar(5),
@Mov				varchar(20),
@MovID				varchar(20),
@BaseDatos			varchar(255),
@EmpresaOrigen		varchar(5),
@IDEmpresa			int,
@CONTEsCancelacion	bit,
@Usuario			varchar(10),
@Ok					int			 OUTPUT,
@OkRef				varchar(255) OUTPUT

AS
BEGIN
DECLARE @CONTPEnLinea		bit,
@MovGenera		varchar(20),
@FechaEmision		datetime,
@CONTPID			int
SELECT @FechaEmision = GETDATE()
EXEC spExtraerFecha @FechaEmision OUTPUT
SELECT @CONTPEnLinea = ISNULL(CONTPEnLinea, 0) FROM EmpresaCfg2 WHERE Empresa = @Empresa
IF @CONTPEnLinea = 0 RETURN
IF(SELECT COUNT(*) FROM ContParalelaD WHERE ID = @ID) > 1 RETURN
SELECT @MovGenera = CPTransformacion FROM EmpresaCfgMovContParalela WHERE Empresa = @Empresa
INSERT INTO ContParalela(
Empresa,               Mov,        FechaEmision, Proyecto,              UEN,               Usuario, Estatus,      OrigenTipo, Origen,           OrigenID,            BaseDatosOrigen,  EmpresaOrigen, Sucursal,              GeneraEjercicio,              GeneraPeriodo,              GeneraFechaD,                    GeneraFechaA,                    GeneraMov,              GeneraMovID,              GeneraContID,         GeneraEmpresaOrigen,           CONTEsCancelacion)
SELECT ContParalela.Empresa, @MovGenera, @FechaEmision, ContParalela.Proyecto, ContParalela.UEN, @Usuario, 'SINAFECTAR', 'CONTP',    ContParalela.Mov, ContParalela.MovID, @BaseDatos,       @EmpresaOrigen, ContParalela.Sucursal, ContParalelaPoliza.Ejercicio, ContParalelaPoliza.Periodo, ContParalelaPoliza.FechaEmision, ContParalelaPoliza.FechaEmision, ContParalelaPoliza.Mov, ContParalelaPoliza.MovID, ContParalelaD.ContID, ContParalelaPoliza.IDEmpresa, @CONTEsCancelacion
FROM ContParalela
JOIN ContParalelaD ON ContParalela.ID = ContParalelaD.ID
JOIN ContParalelaPoliza ON ContParalela.IDEmpresa = ContParalelaPoliza.IDEmpresa AND ContParalelaD.ContID = ContParalelaPoliza.ID
WHERE ContParalela.ID = @ID
AND ISNULL(ContParalelaPoliza.CONTEsCancelacion, 0) = ISNULL(@CONTEsCancelacion, 0)
SELECT @CONTPID = SCOPE_IDENTITY()
IF @Ok IS NULL AND @CONTPID IS NOT NULL
BEGIN
EXEC spAfectar 'CONTP', @CONTPID, 'AFECTAR', @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
EXEC spAfectar 'CONTP', @CONTPID, 'AFECTAR', @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
RETURN
END

