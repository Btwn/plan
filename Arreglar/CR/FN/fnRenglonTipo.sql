SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnRenglonTipo (@ArtTipo varchar(50))
RETURNS char(1)

AS BEGIN
DECLARE
@Resultado char(1)
SELECT @ArtTipo = NULLIF(RTRIM(UPPER(@ArtTipo)), ''), @Resultado = 'N'
IF @ArtTipo = 'SERIE'       SELECT @Resultado = 'S' ELSE
IF @ArtTipo = 'LOTE'        SELECT @Resultado = 'L' ELSE
IF @ArtTipo = 'VIN'         SELECT @Resultado = 'V' ELSE
IF @ArtTipo = 'JUEGO'	      SELECT @Resultado = 'J' /*ELSE
IF @ArtTipo = 'MATRIZ'      SELECT @Resultado = 'M' ELSE
IF @ArtTipo = 'PARTIDA'     SELECT @Resultado = 'A' ELSE
*/
RETURN(@Resultado)
END

