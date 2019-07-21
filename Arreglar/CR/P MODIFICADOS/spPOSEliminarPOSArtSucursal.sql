SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSEliminarPOSArtSucursal
@Estacion           int,
@Sucursal           int

AS
BEGIN
DELETE POSArtSucursal
WHERE Articulo IN (SELECT Clave FROM ListaSt WITH (NOLOCK) WHERE Estacion = @Estacion)
AND Sucursal = @Sucursal
DELETE POSArtCodigoSucursal
WHERE Articulo IN (SELECT Clave FROM ListaSt WITH (NOLOCK) WHERE Estacion = @Estacion)
AND Sucursal = @Sucursal
SELECT 'Operación Realizada Exitosamente'
END

