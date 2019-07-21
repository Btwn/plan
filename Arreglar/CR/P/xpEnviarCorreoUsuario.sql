SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[xpEnviarCorreoUsuario]
 @ID INT
,@Estacion INT
AS
BEGIN
	DECLARE
		@Usuario CHAR(10)
	   ,@Contacto VARCHAR(100)
	   ,@eMail VARCHAR(255)
	   ,@Asunto VARCHAR(255)
	   ,@Mensaje VARCHAR(8000)
	   ,@Anexos VARCHAR(255)
	   ,@Conteo INT
	   ,@Usuarios INT
	SELECT @Conteo = 0
		  ,@Usuarios = 0
	SELECT @Asunto = Asunto
		  ,@Mensaje = Mensaje
		  ,@Anexos = Anexos
	FROM EnviarCorreo
	WHERE ID = @ID
	EXEC master..xp_startmail

	IF @@Error = 0
	BEGIN
		DECLARE
			crListaSt
			CURSOR FOR
			SELECT DISTINCT Clave
			FROM ListaSt
			WHERE Estacion = @Estacion
		OPEN crListaSt
		FETCH NEXT FROM crListaSt INTO @Usuario
		WHILE @@FETCH_STATUS <> -1
		AND @@Error = 0
		BEGIN

		IF @@FETCH_STATUS <> -2
			AND NULLIF(RTRIM(@Usuario), '') IS NOT NULL
		BEGIN
			SELECT @Usuarios = @Usuarios + 1
			SELECT @Contacto = Nombre
				  ,@eMail = eMail
			FROM Usuario
			WHERE Usuario = @Usuario

			IF NULLIF(RTRIM(@eMail), '') IS NOT NULL
			BEGIN
				SELECT @Conteo = @Conteo + 1
				EXEC spEnviarCorreo @eMail
								   ,@Asunto
								   ,@Mensaje
								   ,@Anexos
			END

		END

		FETCH NEXT FROM crListaSt INTO @Usuario
		END
		CLOSE crListaSt
		DEALLOCATE crListaSt
		EXEC master..xp_stopmail
	END

	SELECT CONVERT(VARCHAR, @Conteo) + ' Mensajes Enviados a ' + CONVERT(VARCHAR, @Usuarios) + ' Usuarios'
	RETURN
END

