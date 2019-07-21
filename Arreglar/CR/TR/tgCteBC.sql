SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER [dbo].[tgCteBC]
ON [dbo].[Cte]
FOR UPDATE, DELETE
AS
BEGIN
	DECLARE
		@ClaveNueva VARCHAR(10)
	   ,@ClaveAnterior VARCHAR(10)
	   ,@TipoNuevo VARCHAR(15)
	   ,@TipoAnterior VARCHAR(15)
	   ,@NombreNuevo VARCHAR(100)
	   ,@NombreAnterior VARCHAR(100)
	   ,@RFCNuevo VARCHAR(20)
	   ,@RFCAnterior VARCHAR(20)
	   ,@CURPNuevo VARCHAR(30)
	   ,@CURPAnterior VARCHAR(30)
	   ,@Mensaje VARCHAR(255)
	   ,@RutaA VARCHAR(100)
	   ,@RutaN VARCHAR(100)
	   ,@NombreA VARCHAR(100)
	   ,@NombreN VARCHAR(100)
	   ,@DireccionA VARCHAR(100)
	   ,@DireccionN VARCHAR(100)
	   ,@EntreCallesA VARCHAR(100)
	   ,@EntreCallesN VARCHAR(100)
	   ,@PlanoA VARCHAR(100)
	   ,@PlanoN VARCHAR(100)
	   ,@ObservacionesA VARCHAR(100)
	   ,@ObservacionesN VARCHAR(100)
	   ,@ColoniaA VARCHAR(100)
	   ,@ColoniaN VARCHAR(100)
	   ,@PoblacionA VARCHAR(100)
	   ,@PoblacionN VARCHAR(100)
	   ,@EstadoA VARCHAR(100)
	   ,@EstadoN VARCHAR(100)
	   ,@PaisA VARCHAR(100)
	   ,@PaisN VARCHAR(100)
	   ,@CodigoPostalA VARCHAR(100)
	   ,@CodigoPostalN VARCHAR(100)
	   ,@TelefonosA VARCHAR(100)
	   ,@TelefonosN VARCHAR(100)
	   ,@Contacto1A VARCHAR(100)
	   ,@Contacto1N VARCHAR(100)
	   ,@Contacto2A VARCHAR(100)
	   ,@Contacto2N VARCHAR(100)
	   ,@Extencion1A VARCHAR(100)
	   ,@Extencion1N VARCHAR(100)
	   ,@Extencion2A VARCHAR(100)
	   ,@Extencion2N VARCHAR(100)
	SELECT @ClaveNueva = Cliente
		  ,@TipoNuevo = Tipo
		  ,@NombreNuevo = Nombre
		  ,@RFCNuevo = RFC
		  ,@CURPNuevo = CURP
		  ,@RutaN = Ruta
		  ,@NombreN = Nombre
		  ,@DireccionN = Direccion
		  ,@EntreCallesN = EntreCalles
		  ,@PlanoN = Plano
		  ,@ObservacionesN = Observaciones
		  ,@ColoniaN = Colonia
		  ,@PoblacionN = Poblacion
		  ,@EstadoN = Estado
		  ,@PaisN = Pais
		  ,@CodigoPostalN = CodigoPostal
		  ,@TelefonosN = Telefonos
		  ,@Contacto1N = Contacto1
		  ,@Contacto2N = Contacto2
		  ,@Extencion1N = Extencion1
		  ,@Extencion2N = Extencion2
	FROM Inserted
	SELECT @ClaveAnterior = Cliente
		  ,@TipoAnterior = Tipo
		  ,@NombreAnterior = Nombre
		  ,@RFCAnterior = RFC
		  ,@CURPAnterior = CURP
		  ,@RutaA = Ruta
		  ,@NombreA = Nombre
		  ,@DireccionA = Direccion
		  ,@EntreCallesA = EntreCalles
		  ,@PlanoA = Plano
		  ,@ObservacionesA = Observaciones
		  ,@ColoniaA = Colonia
		  ,@PoblacionA = Poblacion
		  ,@EstadoA = Estado
		  ,@PaisA = Pais
		  ,@CodigoPostalA = CodigoPostal
		  ,@TelefonosA = Telefonos
		  ,@Contacto1A = Contacto1
		  ,@Contacto2A = Contacto2
		  ,@Extencion1A = Extencion1
		  ,@Extencion2A = Extencion2
	FROM Deleted

	IF ISNULL(@RutaA, '') <> ISNULL(@RutaN, '')
		OR ISNULL(@NombreA, '') <> ISNULL(@NombreN, '')
		OR ISNULL(@DireccionA, '') <> ISNULL(@DireccionN, '')
		OR ISNULL(@EntreCallesA, '') <> ISNULL(@EntreCallesN, '')
		OR ISNULL(@PlanoA, '') <> ISNULL(@PlanoN, '')
		OR ISNULL(@ObservacionesA, '') <> ISNULL(@ObservacionesN, '')
		OR ISNULL(@ColoniaA, '') <> ISNULL(@ColoniaN, '')
		OR ISNULL(@PoblacionA, '') <> ISNULL(@PoblacionN, '')
		OR ISNULL(@EstadoA, '') <> ISNULL(@EstadoN, '')
		OR ISNULL(@PaisA, '') <> ISNULL(@PaisN, '')
		OR ISNULL(@CodigoPostalA, '') <> ISNULL(@CodigoPostalN, '')
		OR ISNULL(@TelefonosA, '') <> ISNULL(@TelefonosN, '')
		OR ISNULL(@Contacto1A, '') <> ISNULL(@Contacto1N, '')
		OR ISNULL(@Contacto2A, '') <> ISNULL(@Contacto2N, '')
		OR ISNULL(@Extencion1A, '') <> ISNULL(@Extencion1N, '')
		OR ISNULL(@Extencion2A, '') <> ISNULL(@Extencion2N, '')
		UPDATE EmbarqueMov
		SET Ruta = i.Ruta
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
		   ,Telefonos = i.Telefonos
		   ,Contacto1 = i.Contacto1
		   ,Contacto2 = i.Contacto2
		   ,Extencion1 = i.Extencion1
		   ,Extencion2 = i.Extencion2
		FROM Inserted i, EmbarqueMov e
		WHERE e.Cliente = i.Cliente
		AND e.Cliente = @ClaveNueva
		AND NULLIF(e.ClienteEnviarA, 0) IS NULL
		AND e.Concluido = 0

	IF @ClaveNueva = @ClaveAnterior
		AND @TipoNuevo = @TipoAnterior
		RETURN

	IF @ClaveNueva IS NULL
	BEGIN

		IF EXISTS (SELECT * FROM Cte WHERE Rama = @ClaveAnterior)
		BEGIN
			SELECT @Mensaje = '"' + LTRIM(RTRIM(@ClaveAnterior)) + '" ' + Descripcion
			FROM MensajeLista
			WHERE Mensaje = 30165
			RAISERROR (@Mensaje, 16, -1)
		END
		ELSE
		BEGIN
			DELETE CteEnviarA
			WHERE Cliente = @ClaveAnterior
			DELETE CteEnviarAOtrosDatos
			WHERE Cliente = @ClaveAnterior
			DELETE CteRep
			WHERE Cliente = @ClaveAnterior
			DELETE CteBonificacion
			WHERE Cliente = @ClaveAnterior
			DELETE CteCto
			WHERE Cliente = @ClaveAnterior
			DELETE CteAcceso
			WHERE Cliente = @ClaveAnterior
			DELETE CteTel
			WHERE Cliente = @ClaveAnterior
			DELETE CteUEN
			WHERE Cliente = @ClaveAnterior
			DELETE CteOtrosDatos
			WHERE Cliente = @ClaveAnterior
			DELETE CteCapacidadPago
			WHERE Cliente = @ClaveAnterior
			DELETE Sentinel
			WHERE Cliente = @ClaveAnterior
			DELETE CteCFD
			WHERE Cliente = @ClaveAnterior
			DELETE CteEmpresaCFD
			WHERE Cliente = @ClaveAnterior
			DELETE CteDepto
			WHERE Cliente = @ClaveAnterior
			DELETE CteEntregaMercancia
			WHERE Cliente = @ClaveAnterior
			DELETE CteEstadoFinanciero
			WHERE Cliente = @ClaveAnterior
			DELETE Prop
			WHERE Cuenta = @ClaveAnterior
				AND Rama = 'CXC'
			DELETE ListaD
			WHERE Cuenta = @ClaveAnterior
				AND Rama = 'CXC'
			DELETE AnexoCta
			WHERE Cuenta = @ClaveAnterior
				AND Rama = 'CXC'
			DELETE CuentaTarea
			WHERE Cuenta = @ClaveAnterior
				AND Rama = 'CXC'
			DELETE CtoCampoExtra
			WHERE Tipo = 'Cliente'
				AND Clave = @ClaveAnterior
			DELETE FormaExtraValor
			WHERE Aplica = 'Cliente'
				AND AplicaClave = @ClaveAnterior
			DELETE FormaExtraD
			WHERE Aplica = 'Cliente'
				AND AplicaClave = @ClaveAnterior
		END

	END
	ELSE

	IF @ClaveNueva <> @ClaveAnterior
	BEGIN

		IF (
				SELECT Sincro
				FROM Version
			)
			= 1
			EXEC sp_executesql N'UPDATE Cte SET Rama = @ClaveNueva, SincroC = SincroC WHERE Rama = @ClaveAnterior'
							  ,N'@ClaveNueva varchar(20), @ClaveAnterior varchar(20)'
							  ,@ClaveNueva = @ClaveNueva
							  ,@ClaveAnterior = @ClaveAnterior
		ELSE
			UPDATE Cte
			SET Rama = @ClaveNueva
			WHERE Rama = @ClaveAnterior

		UPDATE CteEnviarA
		SET Cliente = @ClaveNueva
		WHERE Cliente = @ClaveAnterior
		UPDATE CteEnviarAOtrosDatos
		SET Cliente = @ClaveNueva
		WHERE Cliente = @ClaveAnterior
		UPDATE CteRep
		SET Cliente = @ClaveNueva
		WHERE Cliente = @ClaveAnterior
		UPDATE CteBonificacion
		SET Cliente = @ClaveNueva
		WHERE Cliente = @ClaveAnterior
		UPDATE CteCto
		SET Cliente = @ClaveNueva
		WHERE Cliente = @ClaveAnterior
		UPDATE CteAcceso
		SET Cliente = @ClaveNueva
		WHERE Cliente = @ClaveAnterior
		UPDATE CteTel
		SET Cliente = @ClaveNueva
		WHERE Cliente = @ClaveAnterior
		UPDATE CteUEN
		SET Cliente = @ClaveNueva
		WHERE Cliente = @ClaveAnterior
		UPDATE CteOtrosDatos
		SET Cliente = @ClaveNueva
		WHERE Cliente = @ClaveAnterior
		UPDATE CteCapacidadPago
		SET Cliente = @ClaveNueva
		WHERE Cliente = @ClaveAnterior
		UPDATE Sentinel
		SET Cliente = @ClaveNueva
		WHERE Cliente = @ClaveAnterior
		UPDATE CteCFD
		SET Cliente = @ClaveNueva
		WHERE Cliente = @ClaveAnterior
		UPDATE CteEmpresaCFD
		SET Cliente = @ClaveNueva
		WHERE Cliente = @ClaveAnterior
		UPDATE CteDepto
		SET Cliente = @ClaveNueva
		WHERE Cliente = @ClaveAnterior
		UPDATE CteEntregaMercancia
		SET Cliente = @ClaveNueva
		WHERE Cliente = @ClaveAnterior
		UPDATE CteEstadoFinanciero
		SET Cliente = @ClaveNueva
		WHERE Cliente = @ClaveAnterior
		UPDATE Prop
		SET Cuenta = @ClaveNueva
		WHERE Cuenta = @ClaveAnterior
		AND Rama = 'CXC'
		UPDATE ListaD
		SET Cuenta = @ClaveNueva
		WHERE Cuenta = @ClaveAnterior
		AND Rama = 'CXC'
		UPDATE AnexoCta
		SET Cuenta = @ClaveNueva
		WHERE Cuenta = @ClaveAnterior
		AND Rama = 'CXC'
		UPDATE CuentaTarea
		SET Cuenta = @ClaveNueva
		WHERE Cuenta = @ClaveAnterior
		AND Rama = 'CXC'
		UPDATE CtoCampoExtra
		SET Clave = @ClaveNueva
		WHERE Clave = @ClaveAnterior
		AND Tipo = 'Cliente'
		UPDATE FormaExtraValor
		SET AplicaClave = @ClaveNueva
		WHERE AplicaClave = @ClaveAnterior
		AND Aplica = 'Cliente'
		UPDATE FormaExtraD
		SET AplicaClave = @ClaveNueva
		WHERE AplicaClave = @ClaveAnterior
		AND Aplica = 'Cliente'
	END

END

