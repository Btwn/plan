SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTMAPendienteSeleccionar
@Estacion		int,
@Sucursal		int,
@ID			int

AS BEGIN
DECLARE
@Tarima		varchar(20),
@Almacen		varchar(10),
@Posicion		varchar(10),
@PosicionDestino  	varchar(10),
@Renglon		float
SELECT @Renglon = MAX(Renglon) FROM TMAD WHERE ID = @ID
DECLARE crTMAPendiente CURSOR LOCAL FOR
SELECT d.Tarima, d.Almacen, d.Posicion, d.PosicionDestino
FROM TMAD d
JOIN ListaIDRenglon l ON l.Estacion = @Estacion AND l.Modulo = 'TMA' AND l.ID = d.ID AND l.Renglon = d.Renglon
OPEN crTMAPendiente
FETCH NEXT FROM crTMAPendiente INTO @Tarima, @Almacen, @Posicion, @PosicionDestino
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF NOT EXISTS(SELECT * FROM TMAD WHERE ID = @ID AND Tarima = @Tarima)
BEGIN
SELECT @Renglon = ISNULL(@Renglon, 0.0) + 2048.0
INSERT TMAD
(ID,  Sucursal,  Renglon,  Tarima,  Almacen,  Posicion,  PosicionDestino)
VALUES (@ID, @Sucursal, @Renglon, @Tarima, @Almacen, @Posicion, @PosicionDestino)
END
END
FETCH NEXT FROM crTMAPendiente INTO @Tarima, @Almacen, @Posicion, @PosicionDestino
END
CLOSE crTMAPendiente
DEALLOCATE crTMAPendiente
RETURN
END

