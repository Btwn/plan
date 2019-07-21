SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpOrdenarMaestroWMS
@Estacion	int			= NULL,
@Tabla		varchar(50) = NULL,
@Llave		varchar(50) = NULL
AS BEGIN
DECLARE
@Orden		int,
@Clave		varchar(255)
SELECT @Tabla = UPPER(@Tabla)
SELECT @Orden = 0
DECLARE crListaSt CURSOR FOR SELECT Clave FROM ListaSt WHERE Estacion = @Estacion ORDER BY ID
OPEN crListaSt
FETCH NEXT FROM crListaSt INTO @Clave
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Orden = @Orden + 1
IF @Tabla = 'ALMPOS' UPDATE AlmPos SET Orden = @Orden WHERE Posicion = @Clave AND Almacen = @Llave
END
FETCH NEXT FROM crListaSt INTO @Clave
END 
CLOSE crListaSt
DEALLOCATE crListaSt
RETURN
END

