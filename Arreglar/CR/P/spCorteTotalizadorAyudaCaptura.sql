SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCorteTotalizadorAyudaCaptura
@Mov			varchar(20)	= NULL,
@Modulo			varchar(5)	= NULL

AS
BEGIN
CREATE TABLE #Totalizador(Totalizador		varchar(255) COLLATE DATABASE_DEFAULT NULL)
IF ISNULL(@Mov, '') = '' AND ISNULL(@Modulo, '') = ''
BEGIN
INSERT INTO #Totalizador(
Totalizador)
SELECT Campo
FROM SysCampoExt
WHERE TipoDatos IN('money', 'float')
AND Tabla IN(SELECT dbo.fnMovTabla(Modulo) FROM Modulo)
GROUP BY Campo
ORDER BY Campo
END
ELSE
BEGIN
INSERT INTO #Totalizador(
Totalizador)
SELECT Campo
FROM SysCampoExt
JOIN CorteMovTotalizador ON SysCampoExt.Campo = CorteMovTotalizador.Totalizador
WHERE TipoDatos IN('money', 'float')
AND CorteMovTotalizador.Mov = @Mov
AND Tabla IN(SELECT dbo.fnMovTabla(@Modulo))
GROUP BY Campo
ORDER BY Campo
END
SELECT * FROM #Totalizador
END

