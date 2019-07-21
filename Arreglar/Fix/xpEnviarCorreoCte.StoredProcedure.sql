SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[xpEnviarCorreoCte]
 @ID INT
,@Estacion INT
AS
BEGIN
	DECLARE
		@Cliente CHAR(10)
	   ,@Contacto VARCHAR(100)
	   ,@Grupo VARCHAR(50)
	   ,@eMail VARCHAR(255)
	   ,@Asunto VARCHAR(255)
	   ,@Mensaje VARCHAR(8000)
	   ,@Anexos VARCHAR(255)
	   ,@Conteo INT
	   ,@Clientes INT
	SELECT @Conteo = 0
		  ,@Clientes = 0
	SELECT @Asunto = Asunto
		  ,@Mensaje = Mensaje
		  ,@Anexos = Anexos
		  ,@Grupo = NULLIF(NULLIF(RTRIM(Grupo), ''), '(Todos)')
	FROM EnviarCorreo
	WHERE ID = @ID
	EXEC master..xp_startmail

	IF @@Error = 0
	BEGIN
		CREATE TABLE #Contactos (
			Contacto VARCHAR(100) COLLATE Database_Default NULL
		   ,eMail VARCHAR(255) COLLATE Database_Default NULL
		)
		DECLARE
			crListaSt
			CURSOR FOR
			SELECT DISTINCT Clave
			FROM ListaSt
			WHERE Estacion = @Estacion
		OPEN crListaSt
		FETCH NEXT FROM crListaSt INTO @Cliente
		WHILE @@FETCH_STATUS <> -1
		AND @@Error = 0
		BEGIN

		IF @@FETCH_STATUS <> -2
			AND NULLIF(RTRIM(@Cliente), '') IS NOT NULL
		BEGIN
			SELECT @Clientes = @Clientes + 1
			TRUNCATE TABLE #Contactos

			IF @Grupo IS NULL
			BEGIN
				INSERT #Contactos (Contacto, eMail)
					SELECT Nombre
						  ,eMail
					FROM CteCto
					WHERE Cliente = @Cliente
				INSERT #Contactos (Contacto, eMail)
					SELECT Contacto1
						  ,eMail1
					FROM Cte
					WHERE Cliente = @Cliente
				INSERT #Contactos (Contacto, eMail)
					SELECT Contacto2
						  ,eMail2
					FROM Cte
					WHERE Cliente = @Cliente
			END
			ELSE
				INSERT #Contactos (Contacto, eMail)
					SELECT Nombre
						  ,eMail
					FROM CteCto
					WHERE Cliente = @Cliente
					AND Grupo = @Grupo

			DECLARE
				crContactos
				CURSOR LOCAL FOR
				SELECT Contacto
					  ,eMail
				FROM #Contactos
				WHERE NULLIF(RTRIM(eMail), '') IS NOT NULL
				GROUP BY Contacto
						,eMail
				ORDER BY Contacto, eMail
			OPEN crContactos
			FETCH NEXT FROM crContactos INTO @Contacto, @eMail
			WHILE @@FETCH_STATUS <> -1
			AND @@Error = 0
			BEGIN

			IF @@FETCH_STATUS <> -2
			BEGIN
				SELECT @Conteo = @Conteo + 1
				EXEC spEnviarCorreo @eMail
								   ,@Asunto
								   ,@Mensaje
								   ,@Anexos
			END

			FETCH NEXT FROM crContactos INTO @Contacto, @eMail
			END
			CLOSE crContactos
			DEALLOCATE crContactos
		END

		FETCH NEXT FROM crListaSt INTO @Cliente
		END
		CLOSE crListaSt
		DEALLOCATE crListaSt
		EXEC master..xp_stopmail
	END

	SELECT CONVERT(VARCHAR, @Conteo) + ' Mensajes Enviados a ' + CONVERT(VARCHAR, @Clientes) + ' Clientes'
	RETURN
END
GO