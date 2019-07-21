SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spRM0855A_CtoAvalRecomienda]
 @ClienteRecomienda VARCHAR(50) = NULL
,@Prospecto VARCHAR(50) = NULL
,@Accion VARCHAR(50) = NULL
,@IDgenerado INT = NULL
AS
BEGIN
	DECLARE
		@IDENT INT
	   ,@Empresa VARCHAR(100)
	   ,@ID INT
	   ,@Tel VARCHAR(50)
	   ,@lada VARCHAR(10)
	   ,@EdoCivil VARCHAR(10)
	   ,@idCto INT
	SET @IDENT = 0

	IF EXISTS (SELECT * FROM Cte WHERE Cliente = @ClienteRecomienda)
		AND @Accion = 'Genera'
	BEGIN
		INSERT INTO CteCto (Tipo, Cliente, Nombre, ApellidoPaterno, ApellidoMaterno, Cargo, Grupo, FechaNacimiento, Telefonos, Extencion, eMail, Fax
		, PedirTono, EnviarA, Tratamiento, Sexo, Atencion, Usuario, CFD_Enviar, MaviEstatus, TieneMovimientos, CteEnviarAExpress
		, ViveConMAVI, ViveEnCalidadDeMAVI, EstadoCivilMavi, LadaMavi, IdPadreMavi, CteSupervisado, TipoMavi, EsCasa, NumCuenta)
			SELECT 'AVAL'
				  ,@Prospecto
				  ,PersonalNombres
				  ,PersonalApellidoPaterno
				  ,PersonalApellidoMaterno
				  ,NULL
				  ,Grupo
				  ,FechaNacimiento
				  ,Telefonos
				  ,Extencion1
				  ,eMail1
				  ,Fax
				  ,PedirTono
				  ,EnviarA
				  ,NULL
				  ,Sexo
				  ,NULL
				  ,Usuario
				  ,CFD_Enviar
				  ,MaviEstatus
				  ,TieneMovimientos
				  ,EnviarA
				  ,NULL
				  ,ViveEnCalidad
				  ,EstadoCivil
				  ,TelefonosLada
				  ,NULL
				  ,CASE
					   WHEN MaviEstatus = 'Resupervision'
						   OR MaviEstatus = 'Supervisado' THEN 1
					   ELSE 0
				   END
				  ,'NORMAL'
				  ,1
				  ,@ClienteRecomienda
			FROM Cte
			WHERE Cliente = @ClienteRecomienda
		SET @IDENT = SCOPE_IDENTITY()
		UPDATE CteCto
		SET IDPadreMavi = @IDENT
		WHERE ID = @IDENT
		INSERT INTO CteCtoDireccion (Cliente, ID, Tipo, Direccion, Delegacion, Colonia, Poblacion, Estado, CodigoPostal, MaviNumero, MaviNumeroInterno
		, TipoCalle, Pais, AntiguedadAniosMAVI, AntiguedadMesesMAVI, Cruces)
			SELECT @Prospecto
				  ,@IDENT
				  ,'Particular'
				  ,Direccion
				  ,Delegacion
				  ,Colonia
				  ,Poblacion
				  ,Estado
				  ,CodigoPostal
				  ,DireccionNumero
				  ,DireccionNumeroInt
				  ,TipoCalle
				  ,Pais
				  ,0
				  ,0
				  ,EntreCalles
			FROM Cte
			WHERE Cliente = @ClienteRecomienda

		IF EXISTS (SELECT * FROM ClienteExpressMavi WHERE Cliente = @ClienteRecomienda)
		BEGIN
			SELECT @Empresa = EEmpresa
				  ,@ID = ID
			FROM ClienteExpressMavi
			WHERE Cliente = @ClienteRecomienda

			IF NULLIF(@Empresa, '') IS NOT NULL
			BEGIN
				SELECT @Tel = ISNULL(Telefono, '') + ISNULL(Lada, '')
				FROM CteTel
				WHERE Cliente = @ClienteRecomienda
				AND Tipo = 'Trabajo'
				INSERT INTO MAVICTECTOEMPLEO (Cliente, ID, Empresa, Funciones, Departamento, JefeInmediato, PuestoJefeInmediato, Ingresos, PeriodoIngresos, Comprobables,
				Direccion, Colonia, Delegacion, CodigoPostal, Estado, Cruces, Telefono, Extension, TrabajoAnterior, TACodigoPostal, TAColonia,
				TADelegacion, NumeroExterior, NumeroInterior, Poblacion, Pais, TADireccion, TANumeroExterior, TANumeroInterior, TAEntreCalles,
				TAPoblacion, TAEstado, TAPais, TATelefono, TAExtension, TipoCalle, TATipoCalle, AntiguedadMesesMAVI, AntiguedadAniosMAVI, IDPadreMavi, TipoMavi)
					SELECT @Prospecto
						  ,@IDENT
						  ,EEmpresa
						  ,EFunciones
						  ,EDepartamento
						  ,EJefeInmediato
						  ,EPuestoJefeInmediato
						  ,EIngresos
						  ,EPeriodoIngresos
						  ,EComprobables
						  ,EDireccion
						  ,EColonia
						  ,EDelegacion
						  ,ECodigoPostal
						  ,EEstado
						  ,ECruces
						  ,@Tel
						  ,NULL
						  ,ETrabajoAnterior
						  ,ETACodigoPostal
						  ,ETAColonia
						  ,ETADelegacion
						  ,ENumeroExterior
						  ,ENumeroInterior
						  ,EDelegacion
						  ,EPais
						  ,ETADireccion
						  ,ETANumeroExterior
						  ,ETANumeroInterior
						  ,ETAEntreCalles
						  ,ETADelegacion
						  ,ETAEstado
						  ,ETAPais
						  ,NULL
						  ,NULL
						  ,ETipoCalle
						  ,ETATipoCalle
						  ,EAntiguedadMesesMAVI
						  ,EAntiguedadAniosMAVI
						  ,@IDENT
						  ,'LABORAL'
					FROM ClienteExpressMavi
					WHERE Cliente = @ClienteRecomienda
			END

		END

	END

	IF @Accion = 'Elimina'
	BEGIN
		DELETE CteCto
		WHERE IDPadreMavi = @IDgenerado
			AND Cliente = @Prospecto

		IF EXISTS (SELECT * FROM CteCtoDireccion WHERE ID = @IDgenerado AND Cliente = @Prospecto)
			DELETE CteCtoDireccion
			WHERE ID = @IDgenerado
				AND Cliente = @Prospecto

		IF EXISTS (SELECT * FROM MaviCteCtoEmpleo WHERE ID = @IDgenerado AND Cliente = @Prospecto)
			DELETE MaviCteCtoEmpleo
			WHERE IDPadreMavi = @IDgenerado
				AND Cliente = @Prospecto

		SELECT 0
	END

	IF @IDgenerado <> 0
		SELECT @IDENT

END
GO