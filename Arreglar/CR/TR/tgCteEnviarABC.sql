SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER [dbo].[tgCteEnviarABC]
ON [dbo].[CteEnviarA]
FOR INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE
		@ClienteN VARCHAR(10)
	   ,@ClienteA VARCHAR(10)
	   ,@IDN INT
	   ,@IDA INT

	IF dbo.fnEstaSincronizando() = 1
		RETURN

	SELECT @ClienteN = Cliente
		  ,@IDN = ID
	FROM Inserted
	SELECT @ClienteA = Cliente
		  ,@IDA = ID
	FROM Deleted

	IF @ClienteA IS NOT NULL
		AND UPDATE(Direccion)
	BEGIN
		UPDATE EmbarqueMov
		SET Ruta = R.Ruta
		   ,zona = R.Zona
		   ,ZonaTipo = Z.Tipo
		   ,Nombre = i.Nombre
		   ,NombreEnvio = i.Nombre
		   ,Direccion = i.Direccion
		   ,EntreCalles = i.EntreCalles
		   ,Plano = i.Plano
		   ,Observaciones = i.Observaciones
		   ,Colonia = i.Colonia
		   ,Poblacion = i.Poblacion
		   ,Estado = i.Estado
		   ,Pais = i.Pais
		   ,CodigoPostal = i.CodigoPostal
		FROM Inserted i
		JOIN EmbarqueMov e
			ON i.Cliente = e.Cliente
		JOIN Ruta R
			ON R.Ruta = I.Ruta
		JOIN Zona Z
			ON Z.Zona = R.Zona
		WHERE e.Cliente = @ClienteN
		AND e.ClienteEnviarA = @IDN
		AND e.Concluido = 0

		IF @ClienteN <> @ClienteA
			OR @IDN <> @IDA
		BEGIN

			IF @ClienteN IS NULL
				DELETE CteEnviarAOtrosDatos
				WHERE Cliente = @ClienteA
					AND ID = @IDA
			ELSE
				UPDATE CteEnviarAOtrosDatos
				SET Cliente = @ClienteN
				   ,ID = @IDN
				WHERE Cliente = @ClienteA
				AND ID = @IDA

		END

	END

END

