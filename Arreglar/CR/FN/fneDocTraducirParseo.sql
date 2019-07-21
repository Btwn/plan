SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fneDocTraducirParseo
(
@Modulo			varchar(5),
@eDoc				varchar(50),
@IDSeccion		int,
@RID				int,
@ValorOriginal	varchar(50)
)
RETURNS varchar(100)
AS
BEGIN
DECLARE
@Resultado		varchar(100),
@TablaSt		varchar(50)
SELECT
@TablaSt = ISNULL(NULLIF(eddmc.TablaSt,''),edd.TablaSt)
FROM eDocD edd JOIN eDocDMapeoCampo eddmc
ON eddmc.Modulo = edd.Modulo AND eddmc.eDoc = edd.eDoc AND eddmc.IDSeccion = edd.RID
WHERE edd.Modulo = @Modulo
AND RTRIM(edd.eDoc) = RTRIM(@eDoc)
AND edd.RID = @IDSeccion
AND eddmc.RID = @RID
SELECT @Resultado = Valor
FROM TablaStD
WHERE TablaSt = @TablaSt
AND Nombre = @ValorOriginal
SET @Resultado = ISNULL(@Resultado,@ValorOriginal)
RETURN RTRIM(LTRIM(@Resultado))
END

