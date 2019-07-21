SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnWMSPorSurtirEnSurtidoPerdido (@Tarima varchar(20))
RETURNS bit
AS BEGIN
DECLARE @Resultado bit
SELECT @Resultado = 0
IF (SELECT SUM(Cantidad) from dbo.fnWMSPorSurtir(@Tarima))- (SELECT SUM(Cantidad) from dbo.fnWMSEnSurtidoPorArticulo(@Tarima)) = 0
BEGIN
IF NOT EXISTS(SELECT 1 FROM TMA t WITH(NOLOCK) JOIN TMAD d WITH(NOLOCK) ON t.ID = d.ID WHERE Mov IN(SELECT Mov FROM MovTipo WITH(NOLOCK) WHERE Modulo = 'TMA' AND Clave = 'TMA.SURPER' AND d.Tarima = @Tarima) AND t.Estatus = 'CONCLUIDO') OR
NOT EXISTS(SELECT 1 FROM TMA t WITH(NOLOCK) JOIN TMAD d WITH(NOLOCK) ON t.ID = d.ID WHERE Mov IN(SELECT Mov FROM MovTipo WITH(NOLOCK) WHERE Modulo = 'TMA' AND Clave = 'TMA.SUR' AND d.Tarima = @Tarima) AND t.Estatus = 'CONCLUIDO')
SELECT @Resultado = 1
END
RETURN (@Resultado)
END

