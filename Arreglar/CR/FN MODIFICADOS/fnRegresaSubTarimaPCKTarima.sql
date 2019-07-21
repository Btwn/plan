SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnRegresaSubTarimaPCKTarima (@Tarima varchar(20), @MovTipo varchar(20))
RETURNS varchar(20)
AS BEGIN
IF @MovTipo = 'TMA.OPCKTarima'
BEGIN
IF (SELECT a.Tipo
FROM Tarima t WITH(NOLOCK)
JOIN AlmPos a WITH(NOLOCK)
ON t.Almacen = a.Almacen
AND t.Posicion = a.Posicion
AND t.Tarima = @Tarima) = 'Ubicacion'
BEGIN
IF NOT EXISTS(SELECT d.Tarima
FROM TMAD d WITH(NOLOCK)
JOIN TMA t WITH(NOLOCK)
ON t.ID = d.ID
WHERE t.Estatus IN('CONCLUIDO', 'PENDIENTE', 'PROCESAR')
AND d.Tarima LIKE @Tarima + '-%'
GROUP BY d.Tarima)
SELECT @Tarima = @Tarima + '-1'
ELSE
SELECT TOP 1 @Tarima = RTRIM(SUBSTRING(d.Tarima,1,LEN(@Tarima)+1)) + CONVERT(varchar(10),CONVERT(int,RTRIM(SUBSTRING(d.Tarima,LEN(@Tarima)+2,LEN(@Tarima))))+1)
FROM TMAD d WITH(NOLOCK)
JOIN TMA t WITH(NOLOCK)
ON t.ID = d.ID
WHERE t.Estatus IN('CONCLUIDO', 'PENDIENTE', 'PROCESAR')
AND d.Tarima LIKE @Tarima + '-%'
ORDER BY D.ID DESC
END
END
RETURN (@Tarima)
END

