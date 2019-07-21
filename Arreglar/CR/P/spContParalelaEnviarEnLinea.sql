SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContParalelaEnviarEnLinea
@Empresa			char(5),
@Sucursal		int,
@ID				int,
@Accion			varchar(20),
@Usuario			char(10),
@FechaRegistro	datetime,
@Mov				char(20),
@MovID			varchar(20),
@Estacion		int,
@Ok				int				OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE @CONTPEnLinea			bit,
@MovGenera			varchar(20),
@BaseDatosOrigen		varchar(255),
@CONTPID				int,
@CONTEsCancelacion	bit,
@CPCentralizadora		bit,
@FechaEmision			datetime
SELECT @FechaEmision = GETDATE()
EXEC spExtraerFecha @FechaEmision OUTPUT
SELECT @CONTEsCancelacion = CASE @Accion WHEN 'CANCELAR' THEN 1 ELSE 0 END
SELECT @CPCentralizadora = ISNULL(CPCentralizadora, 0) FROM Version
SELECT @BaseDatosOrigen = DB_NAME()
SELECT @MovGenera = CPPaquete FROM EmpresaCfgMovContParalela WHERE Empresa = @Empresa
SELECT @CONTPEnLinea = ISNULL(CONTPEnLinea, 0) FROM EmpresaCfg2 WHERE Empresa = @Empresa
IF @CONTPEnLinea = 0 OR (@CPCentralizadora = 1) RETURN
INSERT INTO ContParalela(
Empresa,  Mov,        FechaEmision, Proyecto, UEN,  Usuario, Estatus,      OrigenTipo, Origen, OrigenID,  BaseDatosOrigen, EmpresaOrigen, Sucursal, GeneraEjercicio, GeneraPeriodo, GeneraFechaD, GeneraFechaA, GeneraContMov, GeneraContMovID, GeneraContID,  CONTEsCancelacion)
SELECT Empresa, @MovGenera, @FechaEmision, Proyecto, UEN, @Usuario, 'SINAFECTAR', 'CONT',     Mov,    MovID,    @BaseDatosOrigen, Empresa,       Sucursal, Ejercicio,       Periodo,       FechaEmision, FechaEmision, Mov,           MovID,           ID,           @CONTEsCancelacion
FROM Cont
WHERE ID = @ID
SELECT @CONTPID = SCOPE_IDENTITY()
IF @CONTPID IS NOT NULL
BEGIN
EXEC spAfectar 'CONTP', @CONTPID, 'AFECTAR', @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 0, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
EXEC spAfectar 'CONTP', @CONTPID, 'AFECTAR', @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 0, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
IF @Ok IS NOT NULL
BEGIN
IF ISNULL(@OkRef, '') = ''
SELECT @OkRef = 'Contabilidad Paralela'
ELSE
SELECT @OkRef = 'Contabilidad Paralela - ' + @OkRef
END
RETURN
END

