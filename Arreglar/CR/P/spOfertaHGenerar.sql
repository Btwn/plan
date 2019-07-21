SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOfertaHGenerar
@Estacion	int,
@ID		int

AS BEGIN
DECLARE
@Sucursal	int,
@Usar	varchar(20),
@Desde	float,
@Hasta	float
SELECT @Sucursal = Sucursal, @Usar = Usar FROM Oferta WHERE ID = @ID
DELETE OfertaD    WHERE ID = @ID
DELETE OfertaDVol WHERE ID = @ID
SELECT @Desde = NULL, @Hasta = NULL
IF @Usar = 'PRECIO'
INSERT OfertaD (
ID,  Renglon, Sucursal,  SucursalOrigen, Articulo, Precio)
SELECT @ID, 2048.0,  @Sucursal, @Sucursal,      Articulo, Monto1
FROM OfertaH
WHERE Estacion = @Estacion AND ID = @ID
ELSE IF @Usar = 'PORCENTAJE'
INSERT OfertaD (
ID,  Renglon,  Sucursal,  SucursalOrigen, Articulo, Porcentaje)
SELECT @ID, 2048.0,   @Sucursal, @Sucursal,      Articulo, Monto1
FROM OfertaH
WHERE Estacion = @Estacion AND ID = @ID
ELSE IF @Usar = 'CANTIDAD'
INSERT OfertaD (
ID,  Renglon,  Sucursal,  SucursalOrigen, Articulo, Cantidad)
SELECT @ID, 2048.0,   @Sucursal, @Sucursal,      Articulo, Monto1
FROM OfertaH
WHERE Estacion = @Estacion AND ID = @ID
ELSE IF @Usar = 'IMPORTE'
INSERT OfertaD (
ID,  Renglon,  Sucursal,  SucursalOrigen, Articulo, Importe)
SELECT @ID, 2048.0,   @Sucursal, @Sucursal,      Articulo, Monto1
FROM OfertaH
WHERE Estacion = @Estacion AND ID = @ID
DECLARE crEscala CURSOR LOCAL FOR
SELECT Cantidad
FROM OfertaHVol
WHERE Estacion = @Estacion AND ID = @ID
OPEN crEscala
FETCH NEXT FROM crEscala INTO @Desde
IF @@FETCH_STATUS = 0
BEGIN
FETCH NEXT FROM crEscala INTO @Hasta
EXEC spOfertaHVolGenerar @Estacion, @ID, @Sucursal, @Desde, @Hasta, @Usar, 1
END
SELECT @Desde = @Hasta, @Hasta = NULL
IF @@FETCH_STATUS = 0
BEGIN
FETCH NEXT FROM crEscala INTO @Hasta
EXEC spOfertaHVolGenerar @Estacion, @ID, @Sucursal, @Desde, @Hasta, @Usar, 2
END
SELECT @Desde = @Hasta, @Hasta = NULL
IF @@FETCH_STATUS = 0
BEGIN
FETCH NEXT FROM crEscala INTO @Hasta
EXEC spOfertaHVolGenerar @Estacion, @ID, @Sucursal, @Desde, @Hasta, @Usar, 3
END
SELECT @Desde = @Hasta, @Hasta = NULL
IF @@FETCH_STATUS = 0
BEGIN
FETCH NEXT FROM crEscala INTO @Hasta
EXEC spOfertaHVolGenerar @Estacion, @ID, @Sucursal, @Desde, @Hasta, @Usar, 4
END
SELECT @Desde = @Hasta, @Hasta = NULL
IF @@FETCH_STATUS = 0
BEGIN
FETCH NEXT FROM crEscala INTO @Hasta
EXEC spOfertaHVolGenerar @Estacion, @ID, @Sucursal, @Desde, @Hasta, @Usar, 5
END
SELECT @Desde = @Hasta, @Hasta = NULL
IF @@FETCH_STATUS = 0
BEGIN
FETCH NEXT FROM crEscala INTO @Hasta
EXEC spOfertaHVolGenerar @Estacion, @ID, @Sucursal, @Desde, @Hasta, @Usar, 6
END
SELECT @Desde = @Hasta, @Hasta = NULL
IF @@FETCH_STATUS = 0
BEGIN
FETCH NEXT FROM crEscala INTO @Hasta
EXEC spOfertaHVolGenerar @Estacion, @ID, @Sucursal, @Desde, @Hasta, @Usar, 7
END
SELECT @Desde = @Hasta, @Hasta = NULL
IF @@FETCH_STATUS = 0
BEGIN
FETCH NEXT FROM crEscala INTO @Hasta
EXEC spOfertaHVolGenerar @Estacion, @ID, @Sucursal, @Desde, @Hasta, @Usar, 8
END
SELECT @Desde = @Hasta, @Hasta = NULL
IF @@FETCH_STATUS = 0
BEGIN
FETCH NEXT FROM crEscala INTO @Hasta
EXEC spOfertaHVolGenerar @Estacion, @ID, @Sucursal, @Desde, @Hasta, @Usar, 9
END
SELECT @Desde = @Hasta, @Hasta = NULL
IF @@FETCH_STATUS = 0
BEGIN
FETCH NEXT FROM crEscala INTO @Hasta
EXEC spOfertaHVolGenerar @Estacion, @ID, @Sucursal, @Desde, @Hasta, @Usar, 10
END
CLOSE crEscala
DEALLOCATE crEscala
DELETE OfertaDVol WHERE ID = @ID AND NULLIF(Precio, 0.0) IS NULL AND NULLIF(Cantidad, 0.0) IS NULL AND NULLIF(Porcentaje, 0.0) IS NULL AND NULLIF(Importe, 0.0) IS NULL
DELETE OfertaH WHERE Estacion = @Estacion
DELETE OfertaHVol WHERE Estacion = @Estacion
RETURN
END

