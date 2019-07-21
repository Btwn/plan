SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSSurtidosPendientes
@Empresa	varchar(5),
@Estacion	int

AS BEGIN
DECLARE
@ID				int,
@Tarima			varchar(20),
@Articulo		varchar(20),
@Almacen		varchar(10),
@Posicion		varchar(10),
@Disponible		float,
@Apartado		float,
@Movimiento		varchar(50),
@OrigenTipo		varchar(10),
@CantidadPedido float,
@SerieLote		varchar(50)
DELETE FROM WMSTarimaSurtido WHERE Estacion = @Estacion AND ID IN (SELECT ID FROM ListaID WHERE Estacion = @Estacion)
DECLARE CrTarima CURSOR FOR
SELECT DISTINCT ListaID.ID,
Tarima.Tarima,
SerieLote.SerieLote,
ArtDisponibleTarima.Articulo,
Tarima.Almacen,
Tarima.Posicion,
CASE WHEN ISNULL(SerieLote.Tarima,'') <> ''
THEN SerieLote.Existencia
ELSE ArtDisponibleTarima.Disponible
END,
CASE WHEN ISNULL(ArtApartadoTarimaSL.Tarima,'') <> ''
THEN ArtApartadoTarimaSL.Apartado
ELSE ArtDisponibleTarima.Apartado
END,
RTRIM(LTRIM(TMA.Mov))+' '+ISNULL(TMA.MovID,''),
CASE WHEN Tarima.Tarima = TMAD.Tarima AND ISNULL(SerieLote.SerieLote,'') = ISNULL(SerieLoteMov.SerieLote,'')
THEN TMAD.CantidadPicking
ELSE 0
END,
TMA.OrigenTipo
FROM Tarima
LEFT JOIN AlmPos
ON Tarima.Almacen = AlmPos.Almacen
AND Tarima.Posicion = AlmPos.Posicion
JOIN ArtDisponibleTarima
ON Tarima.Tarima = ArtDisponibleTarima.Tarima
JOIN TMA
ON ArtDisponibleTarima.Empresa = TMA.Empresa
AND Tarima.Almacen = TMA.Almacen
JOIN TMAD
ON TMA.ID = TMAD.ID
AND ArtDisponibleTarima.Articulo = TMAD.Articulo
AND Tarima.Almacen = TMAD.Almacen
JOIN ListaID
ON ListaID.ID = TMA.ID
LEFT JOIN SerieLote
ON SerieLote.Tarima = Tarima.Tarima
AND	SerieLote.Empresa = TMA.Empresa
AND SerieLote.Almacen = TMA.Almacen
AND TMAD.Articulo = SerieLote.Articulo
LEFT JOIN SerieLoteMov
ON SerieLote.SerieLote = SerieLoteMov.SerieLote
AND SerieLote.Tarima = SerieLoteMov.Tarima
AND SerieLoteMov.Modulo = 'TMA'
AND TMA.ID = SerieLoteMov.ID
AND TMAD.Articulo = SerieLoteMov.Articulo
LEFT JOIN ArtApartadoTarimaSL
ON Tarima.Tarima = ArtApartadoTarimaSL.Tarima
AND SerieLote.SerieLote = ArtApartadoTarimaSL.SerieLote
WHERE ListaID.Estacion = @Estacion
AND ArtDisponibleTarima.Empresa = @Empresa
AND ArtDisponibleTarima.Disponible > 0
AND Tarima.Estatus = 'ALTA'
AND (CHARINDEX('-', Tarima.Tarima)-1) < 0
AND AlmPos.Tipo IN ('Domicilio','Ubicacion','Cross Docking')
OPEN CrTarima
FETCH NEXT FROM CrTarima INTO @ID, @Tarima, @SerieLote, @Articulo, @Almacen, @Posicion, @Disponible, @Apartado, @Movimiento, @CantidadPedido, @OrigenTipo
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT WMSTarimaSurtido(Estacion, ID, Empresa, Tarima, SerieLote, Articulo, Almacen, Posicion,	Disponible, Apartado, CantidadA, Movimiento, OrigenTipo)
VALUES(@Estacion, @ID, @Empresa, @Tarima,ISNULL(@SerieLote,''), @Articulo, @Almacen, @Posicion, @Disponible, @Apartado, @CantidadPedido, @Movimiento, @OrigenTipo)
FETCH NEXT FROM CrTarima INTO @ID, @Tarima, @SerieLote, @Articulo, @Almacen, @Posicion, @Disponible, @Apartado, @Movimiento, @CantidadPedido, @OrigenTipo
END
CLOSE CrTarima
DEALLOCATE CrTarima
END

