SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMFALayoutEmpresaImportar
@Usuario				varchar(20),
@Empresa				varchar(5),
@Ejercicio			int,
@Periodo				int,
@FechaD				datetime,
@FechaA				datetime,
@Ok					int			 = NULL OUTPUT,
@OkRef				varchar(255) = NULL OUTPUT

AS BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @OkDesc			varchar(255),
@OkTipo			varchar(50),
@EmpresaAux		varchar(5),
@EmpresaAuxAnt	varchar(5)
IF YEAR(@FechaD) = 1899 SELECT @FechaD = NULL
IF YEAR(@FechaA) = 1899 SELECT @FechaA = NULL
IF @Ejercicio IS NOT NULL OR @Periodo IS NOT NULL
SELECT @FechaD = NULL, @FechaA = NULL
SELECT @Empresa = NULLIF(RTRIM(UPPER(@Empresa)), '')
IF @Ok IS NULL AND @Ejercicio IS NOT NULL AND @Periodo IS NULL
SELECT @Ok = 10385
IF @Ok IS NULL AND @Periodo IS NOT NULL AND @Ejercicio IS NULL
SELECT @Ok = 10050
IF @Ok IS NULL AND @Ejercicio IS NULL AND @Periodo IS NULL AND (@FechaD IS NULL OR @FechaA IS NULL)
SELECT @Ok = 55090
IF @Ok IS NOT NULL AND @Empresa IS NOT NULL AND NOT EXISTS(SELECT Empresa FROM Empresa WHERE Empresa = @Empresa)
SELECT @Ok = 26070, @OkRef = UPPER(@Empresa)
IF @Ok IS NULL
BEGIN
SELECT @EmpresaAuxAnt = ''
WHILE(1=1)
BEGIN
SELECT @EmpresaAux = MIN(Empresa)
FROM EmpresaMFA
WHERE Empresa > @EmpresaAuxAnt
AND Empresa = ISNULL(@Empresa, Empresa)
IF @EmpresaAux IS NULL BREAK
SELECT @EmpresaAuxAnt = @EmpresaAux
EXEC spMFALayoutImportar @Usuario, @EmpresaAux, @Ejercicio, @Periodo, @FechaD = @FechaD, @FechaA = @FechaA, @EnSilencio = 1
END
END
IF @Ok IS NULL
SELECT @OkRef = NULL
ELSE
SELECT @OkDesc = Descripcion,
@OkTipo = Tipo
FROM MensajeLista
WHERE Mensaje = @Ok
SELECT @Ok, @OkDesc, @OkTipo, @OkRef, NULL
END

