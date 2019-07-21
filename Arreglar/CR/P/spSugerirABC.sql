SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSugerirABC
@Estacion	int,
@Empresa	char(5),
@FechaD		datetime,
@FechaA		datetime

AS BEGIN
DECLARE
@Categoria		varchar(50),
@ABC		char(1),
@ABCPorcentaje	float,
@Articulo		char(20),
@Cantidad		float,
@Valor		float,
@ValorTotal		money,
@Participacion	float,
@ParticipacionAcum	float,
@FechaHora		datetime
EXEC spExplotarPresupuesto @Estacion, @Empresa, @FechaD, @FechaA
SELECT @FechaHora = GETDATE()
DELETE ABCSugeridoCat WHERE Estacion = @Estacion
INSERT ABCSugeridoCat (Estacion, Categoria, FechaHora) SELECT @Estacion, Clave, @FechaHora FROM ListaSt WHERE Estacion = @Estacion
DECLARE crArtCat CURSOR FOR
SELECT Categoria
FROM ABCSugeridoCat
WHERE Estacion = @Estacion
OPEN crArtCat
FETCH NEXT FROM crArtCat INTO @Categoria
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
DELETE ABCSugerido WHERE Categoria = @Categoria
UPDATE Art SET ABC = NULL WHERE Categoria = @Categoria
SELECT @ABC = MIN(ABC) FROM ArtCatABC WHERE Categoria = @Categoria
SELECT @ABCPorcentaje = ISNULL(Porcentaje, 0) FROM ArtCatABC WHERE Categoria = @Categoria AND ABC = @ABC
SELECT @ValorTotal = NULLIF(SUM(e.Cantidad*a.CostoEstandar), 0)
FROM ArtExplosion e
JOIN Art a ON a.Articulo = e.Articulo AND a.Categoria = @Categoria
WHERE e.Estacion = @Estacion AND NULLIF(e.Cantidad*a.CostoEstandar, 0) IS NOT NULL
SELECT @ParticipacionAcum = 0.0
DECLARE crArt CURSOR LOCAL FOR
SELECT a.Articulo, ISNULL(e.Cantidad, 0), ISNULL(e.Cantidad*a.CostoEstandar, 0), ISNULL(e.Cantidad*a.CostoEstandar/@ValorTotal, 0)*100
FROM Art a
LEFT OUTER JOIN ArtExplosion e ON e.Articulo = a.Articulo AND e.Estacion = @Estacion
WHERE a.Categoria = @Categoria
ORDER BY e.Cantidad*a.CostoEstandar DESC
OPEN crArt
FETCH NEXT FROM crArt INTO @Articulo, @Cantidad, @Valor, @Participacion
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @ParticipacionAcum + @Participacion > @ABCPorcentaje
BEGIN
SELECT @ABC = MIN(ABC) FROM ArtCatABC WHERE Categoria = @Categoria AND ABC > @ABC
SELECT @ABCPorcentaje = @ABCPorcentaje + ISNULL(Porcentaje, 0) FROM ArtCatABC WHERE Categoria = @Categoria AND ABC = @ABC
END
INSERT ABCSugerido
(Categoria,  Articulo,   ABC,  Cantidad,  Valor,  Participacion)
VALUES (@Categoria, @Articulo, @ABC, @Cantidad, @Valor, @Participacion)
SELECT @ParticipacionAcum = @ParticipacionAcum + @Participacion
END
FETCH NEXT FROM crArt INTO @Articulo, @Cantidad, @Valor, @Participacion
END
CLOSE crArt
DEALLOCATE crArt
END
FETCH NEXT FROM crArtCat INTO @Categoria
END
CLOSE crArtCat
DEALLOCATE crArtCat
SELECT 'Proceso Concluido.'
RETURN
END

