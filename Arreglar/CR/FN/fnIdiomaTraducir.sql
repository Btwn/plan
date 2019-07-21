SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnIdiomaTraducir
(
@Usuario				varchar(10),
@Texto					varchar(255)
)
RETURNS varchar(255)

AS BEGIN
DECLARE
@TextoTraducido	varchar(255)
SET @TextoTraducido = NULL
SELECT @TextoTraducido = RTRIM(ie.Nombre)
FROM IdiomaEtiqueta ie JOIN Idioma i
ON i.Idioma = ie.Idioma JOIN Usuario u
ON u.Idioma = i.Idioma
WHERE u.Usuario = @Usuario
AND RTRIM(ie.Etiqueta) = RTRIM(@Texto)
IF @TextoTraducido IS NULL
SELECT @TextoTraducido = RTRIM(ie.Etiqueta)
FROM IdiomaEtiqueta ie JOIN Idioma i
ON i.Idioma = ie.Idioma JOIN Usuario u
ON u.Idioma = i.Idioma
WHERE u.Usuario = @Usuario
AND RTRIM(ie.Nombre) = RTRIM(@Texto)
IF @TextoTraducido IS NULL SET @TextoTraducido = @Texto
RETURN (@TextoTraducido)
END

