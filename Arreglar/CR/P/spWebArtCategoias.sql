SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebArtCategoias
@ID         int

AS BEGIN
DECLARE
@CategoriaID     int,
@Columns         varchar(255),
@Categoria1      int
SELECT TOP 1 @Categoria1 =   IDWebCatArt
FROM  WebCatArt_Art
WHERE IDWebArt = @ID
ORDER by IDWebCatArt
SELECT @columns = ISNULL(@columns,'') + ',' + Convert(varchar,IDWebCatArt)
FROM  WebCatArt_Art
WHERE IDWebArt = @ID
ORDER by IDWebCatArt
UPDATE WebArt SET CategoriaIDS =  stuff(@columns,1,1,'' ), Categoria1 = @Categoria1
WHERE ID = @ID
END

