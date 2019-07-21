SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCorreosAUsuarios
(
@Correos				varchar(max)
)
RETURNS @Usuarios TABLE
(
Usuario			varchar(10)
)

AS BEGIN
DECLARE
@CorreosSobrantes				varchar(max),
@Correo						varchar(255),
@FinCorreo					bigint,
@PosicionComa					bigint,
@Usuario						varchar(10)
DECLARE @UsuariosTemp TABLE
(
Usuario			varchar(10)
)
SET @CorreosSobrantes = ISNULL(@Correos,'')
WHILE NULLIF(@CorreosSobrantes,'') IS NOT NULL
BEGIN
SET @PosicionComa = CHARINDEX(',',@CorreosSobrantes)
IF @PosicionComa > 0
SET @FinCorreo = @PosicionComa - 1
ELSE
SET @FinCorreo = LEN(@CorreosSobrantes)
SET @Correo = RTRIM(SUBSTRING(@CorreosSobrantes,1,@FinCorreo))
IF @PosicionComa > 0
SET @CorreosSobrantes = SUBSTRING(@CorreosSobrantes,@PosicionComa + 1,LEN(@CorreosSobrantes))
ELSE
SET @CorreosSobrantes = ''
INSERT @UsuariosTemp (Usuario)
SELECT
NULLIF(Usuario,'')
FROM Usuario WITH (NOLOCK)
WHERE RTRIM(Email) = @Correo
INSERT @UsuariosTemp (Usuario)
SELECT
u.Usuario
FROM Personal p WITH (NOLOCK) LEFT OUTER JOIN Usuario u WITH (NOLOCK)
ON u.Personal = p.Personal
WHERE RTRIM(p.Email) = @Correo
END
INSERT @Usuarios (Usuario)
SELECT DISTINCT Usuario
FROM @UsuariosTemp
WHERE NULLIF(Usuario,'') IS NOT NULL
RETURN
END

