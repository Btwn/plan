SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpArtOpcionInfoExp
@Empresa    char(5),
@Articulo   varchar(20),
@SubCuenta  varchar(50),
@Referencia varchar(50)
AS BEGIN
DECLARE
@Exp				varchar(8000)
SELECT @Exp = 'Asigna(Info.Articulo,' + CHAR(39) + @Articulo + CHAR(39) + ') ' +
'Forma(' + CHAR(39) + 'ArtInfo' + CHAR(39) + ')'
SELECT 'Expresion' = @Exp
RETURN
END

