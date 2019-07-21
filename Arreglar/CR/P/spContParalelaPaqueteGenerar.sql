SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spContParalelaPaqueteGenerar
@ID					int,
@Accion				varchar(20),
@Sucursal			int,
@Usuario			varchar(10),
@Empresa			varchar(5),
@Mov				varchar(20),
@MovID				varchar(20),
@MovTipo			varchar(20),
@BaseDatos			varchar(255),
@EmpresaOrigen		varchar(5),
@CuentaD			varchar(20),
@CuentaA			varchar(20),
@Nivel				varchar(20),
@CPBaseLocal		bit,
@CPBaseDatos		varchar(255),
@CPURL				varchar(255),
@CPCentralizadora	bit,
@CPUsuario			varchar(10),
@CPContrasena		varchar(32),
@ISReferencia		varchar(100),
@IDEmpresa			int,
@GeneraEjercicio	int,
@GeneraPeriodo		int,
@GeneraFechaD		datetime,
@GeneraFechaA		datetime,
@XML				varchar(max)	OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
DECLARE @Fecha				datetime,
@FechaAnt				datetime,
@GenerarMov			varchar(20),
@FechaTrabajo			datetime,
@GeneraID				int,
@CONTPConcluirPaquete	bit,
@IDCancela			int,
@IDCancelaAnt			int
SELECT @FechaTrabajo = GETDATE()
EXEC spExtraerFecha @FechaTrabajo OUTPUT
SELECT @GenerarMov = CPPaquete FROM EmpresaCfgMovContParalela WHERE Empresa = @Empresa
SELECT @CONTPConcluirPaquete = ISNULL(CONTPConcluirPaquete, 0) FROM EmpresaCfg2 WHERE Empresa = @Empresa
IF @Accion = 'AFECTAR'
BEGIN
CREATE TABLE #Mov(
RID				int IDENTITY,
Fecha				datetime
)
CREATE INDEX Fecha ON #Mov(Fecha)
INSERT INTO #Mov(
Fecha)
SELECT FechaEmision
FROM Cont
WHERE Empresa = @Empresa
AND Ejercicio = @GeneraEjercicio
AND Periodo = @GeneraPeriodo
AND Estatus = 'CONCLUIDO'
SELECT @FechaAnt = ''
WHILE(1=1)
BEGIN
SELECT @Fecha = MIN(Fecha)
FROM #Mov
WHERE Fecha > @FechaAnt
IF @Fecha IS NULL BREAK
SELECT @FechaAnt = @Fecha, @GeneraID = NULL
EXEC @GeneraID = spMovCopiar @Sucursal, 'CONTP', @ID, @Usuario, @FechaTrabajo, 1, 1, NULL, NULL, @GenerarMov, NULL, NULL, NULL, 1, 1
UPDATE ContParalela
SET Estatus = 'SINAFECTAR',
GeneraFechaD = @Fecha,
GeneraFechaA = @Fecha,
OrigenTipo = 'CONTP',
Origen = @Mov,
OrigenID = @MovID
WHERE ID = @GeneraID
EXEC spAfectar 'CONTP', @GeneraID, 'AFECTAR', @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL AND @CONTPConcluirPaquete = 1
EXEC spAfectar 'CONTP', @GeneraID, 'AFECTAR', @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NOT NULL RETURN
END
END
ELSE IF @Accion = 'CANCELAR'
BEGIN
SELECT @IDCancelaAnt = 0
WHILE(1=1)
BEGIN
SELECT @IDCancela = MIN(ID)
FROM ContParalela
WHERE Mov = @GenerarMov
AND OrigenTipo = 'CONTP'
AND Origen = @Mov
AND OrigenID = @MovID
AND Estatus = 'PENDIENTE'
AND ID > @IDCancelaAnt
IF @IDCancela IS NULL BREAK
SELECT @IDCancelaAnt = @IDCancela
EXEC spAfectar 'CONTP', @IDCancela, 'CANCELAR', @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
END
RETURN
END

