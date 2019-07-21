SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDistArticulo
@Articulo              varchar(20)

AS
BEGIN
SET @Articulo = LTRIM(RTRIM(ISNULL(@Articulo,'')))
SELECT LTRIM(RTRIM(ISNULL(Articulo,''))) AS Articulo,
LTRIM(RTRIM(ISNULL(Descripcion1,''))) AS Descripcion1
FROM Art
WHERE Articulo = @Articulo
END

