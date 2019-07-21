SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spOrdenarPlanRutaDistribucion]
@Estacion	int,
@Almacen	varchar(10)

AS BEGIN
DECLARE
@Orden			int,
@AlmacenOrigen	varchar(10)
DECLARE CrAlmacen CURSOR FOR
SELECT A.AlmacenOrigen
FROM RutaDistribucionMaxMin A
JOIN ListaSt B ON A.AlmacenOrigen = B.Clave
WHERE A.AlmacenDestino = @Almacen
AND B.Estacion = @Estacion
ORDER BY B.ID
OPEN CrAlmacen
FETCH NEXT FROM CrAlmacen INTO @AlmacenOrigen
WHILE @@FETCH_STATUS = 0
BEGIN
SET @Orden = ISNULL(@Orden,0) + 1
UPDATE RutaDistribucionMaxMin SET Orden = @Orden WHERE AlmacenOrigen = @AlmacenOrigen AND AlmacenDestino = @Almacen
FETCH NEXT FROM CrAlmacen INTO @AlmacenOrigen
END
CLOSE CrAlmacen
DEALLOCATE CrAlmacen
END

