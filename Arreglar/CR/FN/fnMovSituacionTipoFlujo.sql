SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnMovSituacionTipoFlujo(
@Empresa		varchar(5),
@Modulo			varchar(5),
@Mov			varchar(20),
@Estatus		varchar(15)
)
RETURNS varchar(20)
AS
BEGIN
DECLARE @Resultado				varchar(20),
@MovSituacionBinaria		bit,
@Flujo					varchar(20)
SELECT @MovSituacionBinaria = ISNULL(MovSituacionBinaria, 0) FROM EmpresaGral WHERE Empresa = @Empresa
SELECT @Flujo = Flujo FROM MovSituacionL WHERE Modulo = @Modulo AND Mov = @Mov AND Estatus = @Estatus
IF @Flujo IS NOT NULL
IF @MovSituacionBinaria = 0  OR (@MovSituacionBinaria = 1 AND @Flujo = 'Normal')
SELECT @Resultado = 'Normal'
ELSE
SELECT @Resultado = 'Condicional'
ELSE
SELECT @Resultado = 'Normal'
RETURN @Resultado
END

