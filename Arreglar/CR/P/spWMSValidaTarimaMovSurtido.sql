SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSValidaTarimaMovSurtido
@Estacion	int,
@Borrar		int

AS
BEGIN
DECLARE
@ID					int,
@Movimiento			varchar(50),
@Tarima				varchar(20),
@CantidadDiponible	float,
@CantidadA			float,
@CantidadPedido		float,
@CantidadApartada	float,
@Ok					int,
@OkRef				varchar(255)
IF @Borrar = 1
BEGIN
DELETE FROM WMSTarimaSurtido WHERE Estacion = @Estacion
RETURN
END
IF @Borrar = 0
BEGIN
DECLARE CrTarimas CURSOR FOR
SELECT A.ID, C.Movimiento, C.Tarima, C.Disponible, C.CantidadA, B.CantidadPicking
FROM TMA A
JOIN TMAD B
ON A.ID = B.ID
JOIN WMSTarimaSurtido C
ON A.ID = C.ID
WHERE C.Estacion = @Estacion
AND C.CantidadA > 0
OPEN CrTarimas
FETCH NEXT FROM CrTarimas INTO @ID, @Movimiento, @Tarima, @CantidadDiponible, @CantidadA, @CantidadPedido
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @CantidadApartada = SUM(CantidadA)
FROM WMSTarimaSurtido
WHERE Estacion = @Estacion
AND Tarima = @Tarima
IF @CantidadApartada > @CantidadDiponible
BEGIN
SELECT @Ok = Mensaje, @OkRef = Descripcion+'<BR>Tarima: '+@Tarima
FROM MensajeLista
WHERE MENSAJE = 20020
END
IF @CantidadDiponible < @CantidadA
SELECT @Ok = Mensaje, @OkRef = Descripcion+'<BR>Mov: '+@Movimiento+'<BR>Tarima: '+@Tarima
FROM MensajeLista
WHERE MENSAJE = 20020
IF @Ok IS NULL
BEGIN
SELECT @CantidadA = SUM(CantidadA) FROM WMSTarimaSurtido WHERE Estacion = @Estacion AND ID = @ID
END
IF @CantidadA > @CantidadPedido AND @Ok IS NULL
SELECT @Ok = Mensaje, @OkRef = Descripcion+'<BR>Mov: '+@Movimiento
FROM MensajeLista
WHERE MENSAJE = 13240
FETCH NEXT FROM CrTarimas INTO @ID, @Movimiento, @Tarima, @CantidadDiponible, @CantidadA, @CantidadPedido
END
CLOSE CrTarimas
DEALLOCATE CrTarimas
IF @Ok IS NOT NULL
SELECT @OkRef
ELSE
SELECT ''
END
END

