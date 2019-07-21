SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnWebValidarContacto
(
@Estacion                                 int
)
RETURNS varchar(255)

AS BEGIN
DECLARE
@Resultado			varchar(255)
SET @Resultado = NULL
IF EXISTS(SELECT * FROM WebUsuarioTemp WHERE NULLIF(Nombre,'') IS NULL AND Estacion = @Estacion)
SELECT @Resultado = 'El Campo Nombre Es Requerido'
IF EXISTS(SELECT * FROM WebUsuarioTemp WHERE NULLIF(eMail,'') IS NULL AND Estacion = @Estacion)
SELECT @Resultado = 'El Campo Correo Electrónico Es Requerido'
IF EXISTS(SELECT * FROM WebUsuarioTemp WHERE NULLIF(Cliente,'') IS NULL AND Estacion = @Estacion)
SELECT @Resultado = 'El Campo Cliente Es Requerido'
IF EXISTS(SELECT * FROM WebUsuarioTemp WHERE NULLIF(Contrasena,'') IS NULL AND Estacion = @Estacion)
SELECT @Resultado = 'El Campo Contrasena Es Requerido'
RETURN (@Resultado)
END

