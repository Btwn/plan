SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebArtInsertarWebCatArt_Art2
@Estacion        int,
@IDArt           int,
@IDCat           int

AS BEGIN
DECLARE
@CategoriaID     int,
@Columns         varchar(255),
@Categoria1      int
IF NOT EXISTS(SELECT * FROM WebCatArtTemp WHERE Estacion = @Estacion AND ID = @IDCat   AND IDArt = @IDArt)
INSERT WebCatArtTemp(Estacion, ID,IDArt,Nombre)
SELECT              @Estacion,@IDCat, @IDArt,Nombre
FROM WebCatArt WHERE ID =@IDCat
END

