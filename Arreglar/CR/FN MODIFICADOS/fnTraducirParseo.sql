SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnTraducirParseo
(
@Modulo		varchar(5),
@Mov			varchar(20),
@Exportacion		varchar(50),
@IDSeccion		int,
@ValorOriginal	varchar(100)
)
RETURNS varchar(100)
AS
BEGIN
DECLARE	@Resultado		varchar(100)
SELECT @Resultado = ValorDestino
FROM DiccionarioParseoD WITH(NOLOCK)
WHERE RTRIM(Exportacion) = RTRIM(@Exportacion)
AND IDSeccion = @IDSeccion
AND ValorOriginal = @ValorOriginal
SET @Resultado = ISNULL(@Resultado,@ValorOriginal)
RETURN RTRIM(LTRIM(@Resultado))
END

