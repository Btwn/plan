SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRecArtDescripcion
@Empresa      varchar(5),
@Articulo     varchar(20)

AS BEGIN
SET NOCOUNT ON
IF EXISTS (SELECT TOP 1 Empresa FROM Empresa WHERE Empresa = @Empresa)
BEGIN
SELECT LTRIM(RTRIM(Descripcion1))
FROM Art
WHERE Articulo = @Articulo
END
END

