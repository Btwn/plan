SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[xpEnviarCorreoProv]
 @ID INT
,@Estacion INT
AS
BEGIN
	DECLARE
		@Proveedor CHAR(10)
	   ,@Contacto VARCHAR(100)
	   ,@eMail VARCHAR(255)
	   ,@Asunto VARCHAR(255)
	   ,@Mensaje VARCHAR(8000)
	   ,@Anexos VARCHAR(255)
	   ,@Conteo INT
	   ,@Proveedores INT
	SELECT @Conteo = 0
		  ,@Proveedores = 0
	SELECT @Asunto = Asunto
		  ,@Mensaje = Mensaje
		  ,@Anexos = Anexos
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
		FETCH NEXT FROM crListaSt INTO @Proveedor
		WHILE @@FETCH_STATUS <> -1
		AND @@Error = 0
		BEGIN

		IF @@FETCH_STATUS <> -2
			AND NULLIF(RTRIM(@Proveedor), '') IS NOT NULL
		BEGIN
			SELECT @Proveedores = @Proveedores + 1
			TRUNCATE TABLE #Contactos
			INSERT #Contactos (Contacto, eMail)
				SELECT Contacto1
					  ,eMail1
				FROM Prov
				WHERE Proveedor = @Proveedor
			INSERT #Contactos (Contacto, eMail)
				SELECT Contacto2
					  ,eMail2
				FROM Prov
				WHERE Proveedor = @Proveedor
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

		FETCH NEXT FROM crListaSt INTO @Proveedor
		END
		CLOSE crListaSt
		DEALLOCATE crListaSt
		EXEC master..xp_stopmail
	END

	SELECT CONVERT(VARCHAR, @Conteo) + ' Mensajes Enviados a ' + CONVERT(VARCHAR, @Proveedores) + ' Proveedores'
	RETURN
END
GO