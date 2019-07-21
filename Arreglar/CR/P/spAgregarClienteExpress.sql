SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spAgregarClienteExpress]
 @TipoCalle VARCHAR(25)
,@DireccionNumero VARCHAR(20)
,@DireccionNumeroInt VARCHAR(20)
,@TelMovil VARCHAR(30)
,@FiscalRegimen VARCHAR(30)
,@Clave CHAR(20)
,@Nombre VARCHAR(100)
,@Direccion VARCHAR(100)
,@Delegacion VARCHAR(50)
,@Colonia VARCHAR(30)
,@Ruta VARCHAR(50)
,@Poblacion VARCHAR(30)
,@Estado VARCHAR(30)
,@Pais VARCHAR(30)
,@CodigoPostal VARCHAR(15)
,@RFC VARCHAR(15)
,@Telefonos VARCHAR(100)
,@Contacto VARCHAR(50)
,@eMail VARCHAR(50)
,@Categoria VARCHAR(50)
,@Grupo VARCHAR(50)
,@Familia VARCHAR(50)
,@Agente VARCHAR(10)
,@Tipo VARCHAR(20)
,@Comentarios VARCHAR(255)
,@Moneda VARCHAR(10)
,@Prefijo VARCHAR(5)
,@PrefijoLike CHAR(10)
,@Digitos INT
,@Condicion VARCHAR(50)
,@Credito VARCHAR(50) = NULL
,@CPID INT = NULL
,@Empresa VARCHAR(5) = NULL
,@Cta VARCHAR(20) = NULL
,@PersonalNombres VARCHAR(50) = NULL
,@PersonalAPaterno VARCHAR(50) = NULL
,@PersonalAMaterno VARCHAR(50) = NULL
,@IEPS VARCHAR(20) = NULL
,@Sucursal INT = NULL
,@ZonaImpuesto VARCHAR(30) = NULL
,@MapaLatitud FLOAT = 0.0
,@MapaLongitud FLOAT = 0.0
,@MapaUbicacion VARCHAR(255) = ''
,@FueraLinea BIT = 0
AS
BEGIN
	DECLARE
		@Ok INT
	   ,@OkRef VARCHAR(255)
	   ,@Mensaje VARCHAR(255)
	   ,@NombreCorto CHAR(20)
	   ,@Pos INT
	   ,@Consecutivo INT
	   ,@PrefijoSucursal CHAR(5)
	   ,@ConsecutivoGral BIT
	   ,@UsarPrefijoSucursal BIT
	   ,@OkRegistro BIT
		 ,@CreditoEspecial BIT
	SELECT @Clave = UPPER(RTRIM(NULLIF(@Clave, '0')))
		  ,@TipoCalle = UPPER(RTRIM(NULLIF(@TipoCalle, '0')))
		  ,@DireccionNumero = UPPER(RTRIM(NULLIF(@DireccionNumero, '0')))
		  ,@DireccionNumeroInt = UPPER(RTRIM(NULLIF(@DireccionNumeroInt, '0')))
		  ,@TelMovil = UPPER(RTRIM(NULLIF(@TelMovil, '0')))
		  ,@FiscalRegimen = UPPER(RTRIM(NULLIF(@FiscalRegimen, '0')))
		  ,@Nombre = RTRIM(NULLIF(@Nombre, '0'))
		  ,@Direccion = RTRIM(NULLIF(@Direccion, '0'))
		  ,@Delegacion = RTRIM(NULLIF(@Delegacion, '0'))
		  ,@Colonia = RTRIM(NULLIF(@Colonia, '0'))
		  ,@Ruta = RTRIM(NULLIF(@Ruta, '0'))
		  ,@Poblacion = RTRIM(NULLIF(@Poblacion, '0'))
		  ,@Estado = RTRIM(NULLIF(@Estado, '0'))
		  ,@Pais = RTRIM(NULLIF(@Pais, '0'))
		  ,@CodigoPostal = RTRIM(NULLIF(@CodigoPostal, '0'))
		  ,@RFC = RTRIM(NULLIF(@RFC, '0'))
		  ,@Telefonos = RTRIM(NULLIF(@Telefonos, '0'))
		  ,@Contacto = RTRIM(NULLIF(@Contacto, '0'))
		  ,@eMail = RTRIM(NULLIF(@eMail, '0'))
		  ,@Categoria = RTRIM(NULLIF(@Categoria, '0'))
		  ,@Grupo = RTRIM(NULLIF(@Grupo, '0'))
		  ,@Familia = RTRIM(NULLIF(@Familia, '0'))
		  ,@Agente = RTRIM(NULLIF(@Agente, '0'))
		  ,@Tipo = RTRIM(NULLIF(@Tipo, '0'))
		  ,@Prefijo = RTRIM(NULLIF(@Prefijo, '0'))
		  ,@PrefijoLike = RTRIM(NULLIF(@PrefijoLike, '0'))
		  ,@Condicion = RTRIM(NULLIF(@Condicion, '0'))
		  ,@Credito = RTRIM(NULLIF(@Credito, '0'))
		  ,@CPID = NULLIF(@CPID, 0)
		  ,@Empresa = RTRIM(NULLIF(@Empresa, '0'))
		  ,@Cta = RTRIM(NULLIF(@Cta, '0'))
		  ,@PersonalNombres = RTRIM(NULLIF(@PersonalNombres, '0'))
		  ,@PersonalAPaterno = RTRIM(NULLIF(@PersonalAPaterno, '0'))
		  ,@PersonalAMaterno = RTRIM(NULLIF(@PersonalAMaterno, '0'))
		  ,@IEPS = RTRIM(NULLIF(@IEPS, '0'))
		  ,@ZonaImpuesto = RTRIM(NULLIF(@ZonaImpuesto, '0'))
	SELECT @PrefijoSucursal = NULL
		  ,@Ok = NULL
		  ,@OkRef = NULL
		  ,@UsarPrefijoSucursal = 0
	SELECT @UsarPrefijoSucursal = CteExpressUsarPrefijoSucursal
		  ,@Condicion = CteExpressCondicion
		  ,@ConsecutivoGral = SugerirConsecCentralizado
	FROM EmpresaGral
	WHERE Empresa = @Empresa

	IF @UsarPrefijoSucursal = 1
		SELECT @PrefijoSucursal = NULLIF(RTRIM(Prefijo), '')
		FROM Sucursal s
			,Version v
		WHERE s.Sucursal = v.Sucursal

	IF @CPID IS NOT NULL
		SELECT @CodigoPostal = CodigoPostal
			  ,@Colonia = Colonia
			  ,@Delegacion = Delegacion
			  ,@Ruta = Ruta
			  ,@Estado = Estado
			  ,@Pais = 'Mexico'
		FROM CodigoPostal
		WHERE ID = @CPID

	IF @PrefijoSucursal IS NOT NULL
		SELECT @Prefijo = @PrefijoSucursal
			  ,@PrefijoLike = RTRIM(@PrefijoSucursal) + '[0-9]%'

	IF @Tipo IS NULL
		SELECT @Tipo = 'Cliente'

	IF @Clave = '(RFC)'
	BEGIN

		IF NOT EXISTS (SELECT * FROM Cte WHERE UPPER(RTRIM(LTRIM(RFC))) = UPPER(RTRIM(LTRIM(@RFC))))
			SELECT @Clave = RTRIM(LTRIM(@RFC))
		ELSE
			SELECT @Clave = '(CONSECUTIVO)'

	END

	IF @Clave = '(TELEFONO)'
	BEGIN
		SELECT @Clave = SUBSTRING(@Telefonos, 1, 10)
		SELECT @Pos = PATINDEX('%%', @Clave)

		IF @Pos > 1
			SELECT @Clave = SUBSTRING(RTRIM(LTRIM(@Clave)), 1, @Pos - 1)

	END

	IF @Clave IN ('(CONSECUTIVO)', NULL)
	BEGIN

		IF @ConsecutivoGral = 1
			EXEC spConsecutivo 'Cte'
							  ,@Sucursal
							  ,@Clave OUTPUT
		ELSE
		BEGIN
			SELECT @Clave = MAX(RTRIM(LTRIM(Cliente)))
			FROM Cte
			WHERE Tipo = 'Prospecto'

			IF @Clave IS NULL
				SELECT @Consecutivo = 1
			ELSE
				SELECT @Consecutivo = CONVERT(INT, STUFF(@Clave, 1, LEN(RTRIM(@Prefijo)), NULL)) + 1

			EXEC spLlenarCeros @Consecutivo
							  ,@Digitos
							  ,@Clave OUTPUT
			SELECT @Clave = RTRIM(@Prefijo) + RTRIM(LTRIM(@Clave))
		END

	END

	SELECT @Clave = NULLIF(RTRIM(LTRIM(@Clave)), '')

	IF @Clave IS NULL
	BEGIN
		SELECT @Mensaje = 'Es Necesario Configurar el Consecutivo General del Tipo Cte.'
		RAISERROR (@Mensaje, 16, -1)
		RETURN
	END
	ELSE
	BEGIN
		EXEC spRegistroOk 'RFC'
						 ,@RFC
						 ,@Empresa
						 ,1
						 ,@OkRegistro OUTPUT

		IF @OkRegistro = 0
		BEGIN
			SELECT @Mensaje = 'EL RFC es Incorrecto:"' + RTRIM(LTRIM(@RFC)) + '"'
			RAISERROR (@Mensaje, 16, -1)
			RETURN
		END

	END

	BEGIN TRANSACTION

	IF NOT EXISTS (SELECT * FROM Cte WHERE RTRIM(LTRIM(Cliente)) = RTRIM(LTRIM(@Clave)))
	BEGIN

		IF EXISTS (SELECT * FROM Cte WHERE UPPER(Nombre) = UPPER(@Nombre) AND UPPER(RTRIM(LTRIM(RFC))) = UPPER(RTRIM(LTRIM(@RFC))))
		BEGIN
			SELECT @Clave = Cliente
			FROM Cte
			WHERE UPPER(Nombre) = UPPER(@Nombre)
			AND UPPER(RTRIM(LTRIM(RFC))) = UPPER(RTRIM(LTRIM(@RFC)))
			SELECT @Ok = 1
		END
		ELSE

		IF EXISTS (SELECT * FROM Cte WHERE UPPER(RTRIM(LTRIM(RFC))) = UPPER(RTRIM(LTRIM(@RFC))))
		BEGIN
			SELECT @Clave = Cliente
			FROM Cte
			WHERE UPPER(RTRIM(LTRIM(RFC))) = UPPER(RTRIM(LTRIM(@RFC)))
			SELECT @Mensaje = 'El RFC Ya Existe en"' + RTRIM(LTRIM(@Clave)) + '"'
			RAISERROR (@Mensaje, 16, -1)
		END
		ELSE
		BEGIN

			IF @Categoria IS NOT NULL
				AND NOT EXISTS (SELECT * FROM CteCat WHERE UPPER(Categoria) = UPPER(@Categoria))
				SELECT @Ok = 10060
					  ,@OkRef = @Categoria
			ELSE

			IF @Grupo IS NOT NULL
				AND NOT EXISTS (SELECT * FROM CteGrupo WHERE UPPER(Grupo) = UPPER(@Grupo))
				SELECT @Ok = 10060
					  ,@OkRef = @Grupo
			ELSE

			IF @Familia IS NOT NULL
				AND NOT EXISTS (SELECT * FROM CteFam WHERE UPPER(Familia) = UPPER(@Familia))
				SELECT @Ok = 10060
					  ,@OkRef = @Familia

			SELECT @CreditoEspecial = 1
			SELECT @NombreCorto = LEFT(@Nombre, 20)
			INSERT Cte (Cliente, Tipo, Nombre, NombreCorto, Direccion, Delegacion, Colonia, Estado, Pais, Ruta, Poblacion, CodigoPostal, RFC, IEPS, ZonaImpuesto, Telefonos, Contacto1, eMail1, Categoria, Grupo, Familia, DefMoneda, Condicion, Credito, Agente, Estatus, Alta, Cuenta, PersonalNombres, PersonalApellidoPaterno, PersonalApellidoMaterno, CreditoEspecial, BonificacionTipo, MaviEstatus, TipoCalle, DireccionNumero, DireccionNumeroInt, PersonalTelefonoMovil, FiscalRegimen, FueraLinea, MapaLatitud, MapaLongitud, MapaUbicacion)
				VALUES (LEFT(@Clave, 10), 'Prospecto', @Nombre, @NombreCorto, @Direccion, @Delegacion, @Colonia, @Estado, @Pais, @Ruta, @Poblacion, @CodigoPostal, @RFC, @IEPS, @ZonaImpuesto, @Telefonos, @Contacto, @eMail, @Categoria, @Grupo, @Familia, @Moneda, @Condicion, @Credito, @Agente, 'ALTA', GETDATE(), @Cta, @PersonalNombres, @PersonalAPaterno, @PersonalAMaterno, @CreditoEspecial, 'Multiple', 'Nuevo', @TipoCalle, @DireccionNumero, @DireccionNumeroInt, @TelMovil, @FiscalRegimen, @FueraLinea, @MapaLatitud, @MapaLongitud, @MapaUbicacion)
			INSERT CteBonificacion (Cliente, Concepto, Porcentaje, FechaD, FechaA)
				VALUES (LEFT(@Clave, 10), 'BONIFICACION MAYOREO 2', 19.0, '01/01/2000', '01/01/2050')

			IF @Comentarios IS NOT NULL

				IF EXISTS (SELECT * FROM NotaCta WHERE Rama = 'CXC' AND RTRIM(LTRIM(Cuenta)) = RTRIM(LTRIM(@Clave)))
					UPDATE NotaCta
					SET Comentarios = @Comentarios
					WHERE Rama = 'CXC'
					AND RTRIM(LTRIM(Cuenta)) = RTRIM(LTRIM(@Clave))
				ELSE
					INSERT NotaCta (Rama, Cuenta, Comentarios)
						VALUES ('CXC', @Clave, @Comentarios)

		END

	END

	IF @Ok IS NULL
		COMMIT TRANSACTION
	ELSE
		ROLLBACK TRANSACTION

	IF @Ok = 10060
	BEGIN
		SELECT @Mensaje = '"' + LTRIM(RTRIM(ISNULL(@OkRef, ''))) + '" ' + Descripcion
		FROM MensajeLista
		WHERE Mensaje = @Ok
		RAISERROR (@Mensaje, 16, -1)
	END
	ELSE

	IF @Ok IS NULL
		AND EXISTS (SELECT * FROM Cte WHERE RTRIM(LTRIM(Cliente)) = RTRIM(LTRIM(@Clave)) AND RTRIM(LTRIM(RFC)) = RTRIM(LTRIM(@RFC)))
	BEGIN
		SELECT "Clave" = RTRIM(LTRIM(@Clave))
		RETURN
	END
	ELSE

	IF @Ok IS NOT NULL
	BEGIN
		SELECT "Clave" = RTRIM(LTRIM(@Clave))
		RETURN
	END
	ELSE
		SELECT "Clave" = RTRIM(LTRIM(@Clave))

	RETURN
END

