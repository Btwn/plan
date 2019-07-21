SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spCampanaAgregarContactos]
 @Estacion INT
,@Usuario VARCHAR(10)
,@ID INT
,@ContactoTipo BIT
,@Sembrados BIT
,@Empresa VARCHAR(5)
AS
BEGIN
	DECLARE
		@SituacionPorOmision VARCHAR(30)
	   ,@Contacto VARCHAR(10)
	   ,@TieneColonias BIT
	   ,@Colonia VARCHAR(100)
	   ,@Poblacion VARCHAR(50)
	   ,@Estado VARCHAR(50)
	   ,@Campana VARCHAR(50)
	   ,@Nombre VARCHAR(100)
	   ,@Telefono VARCHAR(100)
	   ,@Base VARCHAR(100)
	   ,@SQL VARCHAR(MAX)
	SELECT @SituacionPorOmision = ISNULL(dbo.fnCampanaSituacionPorOmision(@ID), '')
		  ,@TieneColonias = 0
	SELECT @Campana = CampanaTipo
	FROM Campana
	WHERE ID = @ID
	SELECT @Base = ISNULL(BasePersonalMAVI, '')
	FROM EmpresaGral
	WHERE Empresa = @Empresa
	SELECT @SQL = ''

	IF (
			SELECT COUNT(Colonia)
			FROM ColoniasEliminarMAVI
			WHERE IDCampana = @ID
		)
		> 0
		SELECT @TieneColonias = 1

	IF @ContactoTipo = 0
	BEGIN
		DECLARE
			crListaFiltro
			CURSOR LOCAL FOR
			SELECT DISTINCT Clave
			FROM ListaFiltro
			WHERE Estacion = @Estacion
			AND Clave NOT IN (SELECT Contacto FROM CampanaD WHERE ID = @ID)
		OPEN crListaFiltro
		FETCH NEXT FROM crListaFiltro INTO @Contacto
		WHILE @@FETCH_STATUS <> -1
		BEGIN

		IF @@FETCH_STATUS <> -2
		BEGIN
			INSERT INTO CampanaD (ID, Nombre, Tipo, ContactoTipo, Situacion, Contacto, Usuario, Delegacion, Direccion, Colonia, Poblacion,
			Estado, Pais, CodigoPostal, Telefono, Extencion)
				SELECT @ID
					  ,dbo.fnContactoNivel('Cliente', @Contacto, 'NOMBRE')
					  ,dbo.fnContactoNivel('Cliente', @Contacto, 'Sub Tipo')
					  ,@Contacto
					  ,@SituacionPorOmision
					  ,@Contacto
					  ,@Usuario
					  ,c.Delegacion
					  ,c.Direccion + '' + ISNULL(c.DireccionNumero, '')
					  ,c.Colonia
					  ,c.Poblacion
					  ,c.Estado
					  ,c.Pais
					  ,c.CodigoPostal
					  ,dbo.fn_ValidaTelefonosCampanaMAVI(ISNULL(ct.Lada, '') + '' + ISNULL(ct.Telefono, ''))
					  ,ct.Extencion
				FROM CTE c
				LEFT OUTER JOIN CteTel ct
					ON c.Cliente = ct.Cliente
				WHERE c.Cliente = @Contacto
		END

		FETCH NEXT FROM crListaFiltro INTO @Contacto
		END
		CLOSE crListaFiltro
		DEALLOCATE crListaFiltro
	END

	IF @Sembrados = 1
		AND @Base <> ''
	BEGIN
		SELECT @SQL = '
INSERT INTO CampanaD (ID,Nombre,Tipo,ContactoTipo,Situacion,Contacto,Usuario,Delegacion,Direccion,Colonia,Poblacion,
Estado,Pais,CodigoPostal,Telefono)
SELECT DISTINCT ' + CONVERT(VARCHAR, @ID) + ',RTRIM(ISNULL(ApellidoPaterno, ''''))+'' ''+RTRIM(ISNULL(ApellidoMaterno, ''''))+'' ''+RTRIM(Nombre),Tipo,
Personal,' + CHAR(39) + @SituacionPorOmision + CHAR(39) + ',Personal,' + CHAR(39) + @Usuario + CHAR(39) + ', Delegacion, Direccion + '' '' + ISNULL(DireccionNumero,'' ''), Colonia, Poblacion,
Estado,Pais,CodigoPostal,dbo.fn_ValidaTelefonosCampanaMAVI(Telefono)
FROM ' + @Base + '.dbo.Personal
WHERE Sembrado = 1'
		EXEC (@SQL)
	END

	IF @Campana <> 'CORREO'
		DELETE FROM CampanaD
		WHERE Telefono = 1
			AND ID = @ID
	ELSE
	BEGIN
		DECLARE
			crCampanaD
			CURSOR LOCAL FOR
			SELECT Nombre
				  ,Telefono
			FROM CampanaD
			WHERE ID = @ID
		OPEN crCampanaD
		FETCH NEXT FROM crCampanaD INTO @Nombre, @Telefono
		WHILE @@FETCH_STATUS <> -1
		BEGIN

		IF @@FETCH_STATUS <> -2
		BEGIN

			IF EXISTS (SELECT Nombre FROM CampanaD WHERE Nombre = @Nombre)
				DELETE FROM CampanaD
				WHERE Nombre = @Nombre
					AND Telefono <> @Telefono
					AND ID = @ID

		END

		FETCH NEXT FROM crCampanaD INTO @Nombre, @Telefono
		END
		CLOSE crCampanaD
		DEALLOCATE crCampanaD
	END

	IF @TieneColonias = 1
	BEGIN
		DECLARE
			crBorraColonias
			CURSOR LOCAL FOR
			SELECT Colonia
				  ,Poblacion
				  ,Estado
			FROM ColoniasEliminarMAVI
			WHERE IDCampana = @ID
		OPEN crBorraColonias
		FETCH NEXT FROM crBorraColonias INTO @Colonia, @Poblacion, @Estado
		WHILE @@FETCH_STATUS <> -1
		BEGIN

		IF @@FETCH_STATUS <> -2
		BEGIN
			DELETE FROM CampanaD
			WHERE Colonia = @Colonia
				AND Delegacion = @Poblacion
				AND Estado = @Estado
				AND ID = @ID
		END

		FETCH NEXT FROM crBorraColonias INTO @Colonia, @Poblacion, @Estado
		END
		CLOSE crBorraColonias
		DEALLOCATE crBorraColonias
	END

	RETURN
END

