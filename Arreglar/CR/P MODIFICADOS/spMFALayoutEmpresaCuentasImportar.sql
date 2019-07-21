SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMFALayoutEmpresaCuentasImportar
@Usuario				varchar(20),
@Empresa				varchar(5),
@Ejercicio			int,
@Periodo				int,
@Ok					int			 = NULL OUTPUT,
@OkRef				varchar(255) = NULL OUTPUT

AS BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @OkDesc			varchar(255),
@OkTipo			varchar(50),
@EmpresaAux		varchar(5),
@EmpresaAuxAnt	varchar(5)
SELECT @Empresa = NULLIF(RTRIM(UPPER(@Empresa)), '')
IF @Ok IS NULL AND @Periodo IS NULL
SELECT @Ok = 10385
IF @Ok IS NULL AND @Ejercicio IS NULL
SELECT @Ok = 10050
IF @Ok IS NULL
BEGIN
SELECT @EmpresaAuxAnt = ''
WHILE(1=1)
BEGIN
SELECT @EmpresaAux = MIN(Empresa)
FROM EmpresaMFA WITH (NOLOCK)
WHERE Empresa > @EmpresaAuxAnt
AND Empresa = ISNULL(@Empresa, Empresa)
IF @EmpresaAux IS NULL BREAK
SELECT @EmpresaAuxAnt = @EmpresaAux
EXEC spMFALayoutImportar_Cuentas @Usuario, @EmpresaAux, @Ejercicio, @Periodo, @EnSilencio = 1
END
END
IF @Ok IS NULL
SELECT @OkRef = NULL
ELSE
SELECT @OkDesc = Descripcion,
@OkTipo = Tipo
FROM MensajeLista WITH (NOLOCK)
WHERE Mensaje = @Ok
SELECT @Ok, @OkDesc, @OkTipo, @OkRef, NULL
END

