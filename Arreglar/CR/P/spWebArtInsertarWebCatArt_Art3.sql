SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebArtInsertarWebCatArt_Art3
@Estacion        int,
@IDArt           int

AS BEGIN
DECLARE
@CategoriaID     int,
@Columns         varchar(255),
@Categoria1      int
INSERT WebCatArt_Art(IDWebArt, IDWebCatArt, Orden, Nombre)
SELECT               IDArt,   ID         ,0,      Nombre
FROM WebCatArtTemp
WHERE Estacion = @Estacion
AND ID NOT IN (SELECT IDWebCatArt FROM WebCatArt_Art  WHERE IDWebArt = @IDArt)
END

