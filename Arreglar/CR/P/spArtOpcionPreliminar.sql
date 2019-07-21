SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spArtOpcionPreliminar
@Estacion	int,
@Articulo	varchar(20),
@CBSugerir	varchar(20)

AS BEGIN
DECLARE
@Opcion		char(1),
@TieneDetalle	bit,
@Codigo		varchar(30),
@SubCuenta		varchar(50)
DELETE ArtOpcionPreliminar WHERE Estacion = @Estacion
IF (SELECT UPPER(TipoOpcion) FROM Art WHERE Articulo = @Articulo) <> 'SI'
BEGIN
IF @CBSugerir = 'Código Compuesto'
SELECT @Codigo = @Articulo
ELSE
IF @CBSugerir = 'Código Consecutivo'
EXEC spConsecutivo 'Codigo Barras', 0, @Codigo OUTPUT
INSERT ArtOpcionPreliminar (Estacion, Codigo) VALUES (@Estacion, @Codigo)
END ELSE
BEGIN
CREATE TABLE #OpcionD (Opcion	char(1) COLLATE Database_Default NOT NULL, Numero int NULL, Nombre varchar(100) COLLATE Database_Default NULL, InformacionAdicional varchar(100) COLLATE Database_Default NULL, Imagen varchar(255) COLLATE Database_Default NULL)
CREATE TABLE #OpcionP1 (ID int NOT NULL IDENTITY(1,1) PRIMARY KEY, SubCuenta varchar(50) COLLATE Database_Default NULL)
CREATE TABLE #OpcionP2 (ID int NOT NULL IDENTITY(1,1) PRIMARY KEY, SubCuenta varchar(50) COLLATE Database_Default NULL)
EXEC spVerOpcionD @Articulo, @Generar = 1, @Estacion = @Estacion
DECLARE crArtOpcionWizard CURSOR LOCAL FOR
SELECT w.Opcion, o.TieneDetalle
FROM ArtOpcionWizard w
JOIN Opcion o ON o.Opcion = w.Opcion
WHERE w.Estacion = @Estacion AND w.Generar = 1
ORDER BY w.Opcion
OPEN crArtOpcionWizard
FETCH NEXT FROM crArtOpcionWizard INTO @Opcion, @TieneDetalle
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
EXEC spArtOpcionPreliminarAdd @Opcion, @TieneDetalle
FETCH NEXT FROM crArtOpcionWizard INTO @Opcion, @TieneDetalle
END
CLOSE crArtOpcionWizard
DEALLOCATE crArtOpcionWizard
IF @CBSugerir = 'Código Compuesto'
INSERT ArtOpcionPreliminar (Estacion, Codigo, SubCuenta)
SELECT @Estacion, @Articulo+'/'+SubCuenta, SubCuenta
FROM #OpcionP2
ORDER BY ID
ELSE
IF @CBSugerir = 'Código Consecutivo'
BEGIN
DECLARE crOpcionP2 CURSOR LOCAL FOR
SELECT SubCuenta
FROM #OpcionP2
ORDER BY ID
OPEN crOpcionP2
FETCH NEXT FROM crOpcionP2 INTO @SubCuenta
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spConsecutivo 'Codigo Barras', 0, @Codigo OUTPUT
INSERT ArtOpcionPreliminar (Estacion, Codigo, SubCuenta) VALUES (@Estacion, @Codigo, @SubCuenta)
END
FETCH NEXT FROM crOpcionP2 INTO @SubCuenta
END
CLOSE crOpcionP2
DEALLOCATE crOpcionP2
END
END
RETURN
END

