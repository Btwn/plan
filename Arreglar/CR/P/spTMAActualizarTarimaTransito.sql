SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spTMAActualizarTarimaTransito
@ID				int,
@MovTipo		varchar(20)

AS
BEGIN
DECLARE @Tarima			varchar(20),
@TarimaAnt		varchar(20),
@TarimaSurtido	varchar(20)
IF @MovTipo <> 'TMA.OSUR' RETURN
SELECT @TarimaAnt = ''
WHILE(1=1)
BEGIN
SELECT @Tarima = MIN(Tarima)
FROM TMAD
WHERE ID = @ID
AND Tarima > @TarimaAnt
IF @Tarima IS NULL BREAK
SELECT @TarimaAnt = @Tarima, @TarimaSurtido = NULL
IF (SELECT a.Tipo
FROM Tarima t
JOIN AlmPos a
ON t.Almacen = a.Almacen
AND t.Posicion = a.Posicion
AND t.Tarima = @Tarima) = 'Domicilio'
BEGIN
EXEC spTarimaTransitoC @Tarima, @TarimaSurtido OUTPUT
UPDATE TMAD SET Tarima = @TarimaSurtido WHERE ID = @ID AND Tarima = @Tarima
END
END
END

