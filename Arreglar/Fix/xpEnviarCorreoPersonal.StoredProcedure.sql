SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[xpEnviarCorreoPersonal]
 @ID INT
,@Estacion INT
,@Empresa VARCHAR(10)
AS
BEGIN
	DECLARE
		@Personal CHAR(10)
	   ,@Contacto VARCHAR(100)
	   ,@eMail VARCHAR(255)
	   ,@Asunto VARCHAR(255)
	   ,@Mensaje VARCHAR(8000)
	   ,@Anexos VARCHAR(255)
	   ,@Conteo INT
	   ,@Personals INT
	SELECT @Conteo = 0
		  ,@Personals = 0
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
		FETCH NEXT FROM crListaSt INTO @Personal
		WHILE @@FETCH_STATUS <> -1
		AND @@Error = 0
		BEGIN

		IF @@FETCH_STATUS <> -2
			AND NULLIF(RTRIM(@Personal), '') IS NOT NULL
		BEGIN
			SELECT @Personals = @Personals + 1
			SELECT @Contacto = Nombre
				  ,@eMail = eMail
			FROM Personal
			WHERE Personal = @Personal

			IF NULLIF(RTRIM(@eMail), '') IS NOT NULL
			BEGIN
				SELECT @Conteo = @Conteo + 1
				EXEC spEnviarCorreo @Empresa
								   ,@eMail
								   ,@Asunto
								   ,@Mensaje
								   ,@Anexos
			END

		END

		FETCH NEXT FROM crListaSt INTO @Personal
		END
		CLOSE crListaSt
		DEALLOCATE crListaSt
		EXEC master..xp_stopmail
	END

	SELECT CONVERT(VARCHAR, @Conteo) + ' Mensajes Enviados a ' + CONVERT(VARCHAR, @Personals) + ' Personals'
	RETURN
END
GO