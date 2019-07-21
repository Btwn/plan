SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebArtInsertarWebCatArt_Art
@Estacion        int,
@IDArt           int

AS BEGIN
DECLARE
@CategoriaID     int,
@Columns         varchar(255),
@Categoria1      int
INSERT WebCatArt_Art(IDWebArt, IDWebCatArt, Orden, Nombre)
SELECT               @IDArt,   ID         ,0,      Nombre
FROM WebCatArt WHERE ID IN (SELECT ID FROM ListaID WHERE Estacion = @Estacion)
END

