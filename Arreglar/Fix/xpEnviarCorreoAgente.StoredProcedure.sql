SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[xpEnviarCorreoAgente]
 @ID INT
,@Estacion INT
AS
BEGIN
	DECLARE
		@Agente CHAR(10)
	   ,@Contacto VARCHAR(100)
	   ,@eMail VARCHAR(255)
	   ,@Asunto VARCHAR(255)
	   ,@Mensaje VARCHAR(8000)
	   ,@Anexos VARCHAR(255)
	   ,@Conteo INT
	   ,@Agentes INT
	SELECT @Conteo = 0
		  ,@Agentes = 0
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
		FETCH NEXT FROM crListaSt INTO @Agente
		WHILE @@FETCH_STATUS <> -1
		AND @@Error = 0
		BEGIN

		IF @@FETCH_STATUS <> -2
			AND NULLIF(RTRIM(@Agente), '') IS NOT NULL
		BEGIN
			SELECT @Agentes = @Agentes + 1
			SELECT @Contacto = Nombre
				  ,@eMail = eMail
			FROM Agente
			WHERE Agente = @Agente

			IF NULLIF(RTRIM(@eMail), '') IS NOT NULL
			BEGIN
				SELECT @Conteo = @Conteo + 1
				EXEC spEnviarCorreo @eMail
								   ,@Asunto
								   ,@Mensaje
								   ,@Anexos
			END

		END

		FETCH NEXT FROM crListaSt INTO @Agente
		END
		CLOSE crListaSt
		DEALLOCATE crListaSt
		EXEC master..xp_stopmail
	END

	SELECT CONVERT(VARCHAR, @Conteo) + ' Mensajes Enviados a ' + CONVERT(VARCHAR, @Agentes) + ' Agentes'
	RETURN
END
GO