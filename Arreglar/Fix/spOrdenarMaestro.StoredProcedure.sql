SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spOrdenarMaestro]
 @Estacion INT
,@Tabla VARCHAR(50)
,@Modulo CHAR(5) = NULL
,@ID INT = NULL
,@Cuenta CHAR(50) = NULL
,@Llave VARCHAR(50) = NULL
AS
BEGIN
	DECLARE
		@Orden INT
	   ,@Clave VARCHAR(255)
	   ,@Actividad VARCHAR(10)
	   ,@ActividadID INT
	SELECT @Tabla = UPPER(@Tabla)
	BEGIN TRANSACTION
	SELECT @Orden = 0
	DECLARE
		crListaSt
		CURSOR FOR
		SELECT Clave
		FROM ListaSt WITH(NOLOCK)
		WHERE Estacion = @Estacion
		ORDER BY ID
	OPEN crListaSt
	FETCH NEXT FROM crListaSt INTO @Clave
	WHILE @@FETCH_STATUS <> -1
	BEGIN

	IF @@FETCH_STATUS <> -2
	BEGIN
		SELECT @Orden = @Orden + 1

		IF @Tabla = 'ALM'
			UPDATE Alm WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Almacen = @Clave
		ELSE

		IF @Tabla = 'TiposCoberturaMAVI'
			UPDATE TiposCoberturaMAVI WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Cobertura = @Clave
		ELSE

		IF @Tabla = 'MON'
			UPDATE Mon WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Moneda = @Clave
		ELSE

		IF @Tabla = 'UNIDAD'
			UPDATE Unidad WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Unidad = @Clave
		ELSE

		IF @Tabla = 'CONDICION'
			UPDATE Condicion WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Condicion = @Clave
		ELSE

		IF @Tabla = 'CENTRO'
			UPDATE Centro WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Centro = @Clave
		ELSE

		IF @Tabla = 'CONDICION'
			UPDATE Condicion WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Condicion = @Clave
		ELSE

		IF @Tabla = 'ARTSUSTITUTO'
			UPDATE ArtSustituto WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Sustituto = @Clave
		ELSE

		IF @Tabla = 'EMBARQUEESTADO'
			UPDATE EmbarqueEstado WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Estado = @Clave
		ELSE

		IF @Tabla = 'NACIONALIDAD'
			UPDATE Nacionalidad WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Nacionalidad = @Clave
		ELSE

		IF @Tabla = 'IDIOMA'
			UPDATE Idioma WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Idioma = @Clave
		ELSE

		IF @Tabla = 'ACTIVIDAD'
			UPDATE Actividad WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Actividad = @Clave
		ELSE

		IF @Tabla = 'FORMAPAGO'
			UPDATE FormaPago WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE FormaPago = @Clave
		ELSE

		IF @Tabla = 'PERSONALPROP'
			UPDATE PersonalProp WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Propiedad = @Clave
		ELSE

		IF @Tabla = 'SOPORTEESTADO'
			UPDATE SoporteEstado WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Estado = @Clave
		ELSE

		IF @Tabla = 'ZONA'
			UPDATE Zona WITH(ROWLOCK)
			SET OrdenEmbarque = @Orden
			WHERE Zona = @Clave
		ELSE

		IF @Tabla = 'TAREAESTADO'
			UPDATE TareaEstado WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Estado = @Clave
		ELSE

		IF @Tabla = 'CMPESTADO'
			UPDATE CMPEstado WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Estado = @Clave
		ELSE

		IF @Tabla = 'PRECIOCALC'
			UPDATE PrecioCalc WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE ListaPrecios = @Clave
		ELSE

		IF @Tabla = 'MOVCTE'
			UPDATE MovCte WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Nombre = @Clave
		ELSE

		IF @Tabla = 'MOVPROY'
			UPDATE MovProy WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Nombre = @Clave
		ELSE

		IF @Tabla = 'MOVPROV'
			UPDATE MovProv WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Nombre = @Clave
		ELSE

		IF @Tabla = 'FORMAVIRTUALCARPETA'
			UPDATE FormaVirtualCarpeta WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Carpeta = @Clave
			AND FormaVirtual = @Llave
		ELSE

		IF @Tabla = 'AUTORUTAD'
			UPDATE AutoRutaD WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Ruta = @Cuenta
			AND Localidad = @Clave
		ELSE

		IF @Tabla = 'AUTOCORRIDAPLANTILLA'
			UPDATE AutoCorridaPlantilla WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Corrida = @Cuenta
			AND ID = CONVERT(INT, @Clave)
		ELSE

		IF @Tabla = 'SERVICIOTIPOPLANTILLA'
			UPDATE ServicioTipoPlantilla WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Tipo = @Cuenta
			AND ID = CONVERT(INT, @Clave)
		ELSE

		IF @Tabla = 'EVALUACIONFORMATO'
			UPDATE EvaluacionFormato WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Evaluacion = @Cuenta
			AND Punto = @Clave
		ELSE

		IF @Tabla = 'CAUSA'
			UPDATE Causa WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Modulo = @Modulo
			AND Causa = @Clave
		ELSE

		IF @Tabla = 'CLASE'
			UPDATE Clase WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Modulo = @Modulo
			AND Clase = @Clave
		ELSE

		IF @Tabla = 'CONCEPTO'
			UPDATE Concepto WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Modulo = @Modulo
			AND Concepto = @Clave
		ELSE

		IF @Tabla = 'MOVTIPO'
			UPDATE MovTipo WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Modulo = @Modulo
			AND Mov = @Clave
		ELSE

		IF @Tabla = 'MOVTIPOFORMA'
			UPDATE MovTipoForma WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Modulo = @Modulo
			AND Mov = @Cuenta
			AND Campo = @Clave
		ELSE

		IF @Tabla = 'MOVTIPOFORMAAYUDA'
			UPDATE MovTipoFormaAyuda WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Modulo = @Modulo
			AND Mov = @Cuenta
			AND Campo = @Llave
			AND Ayuda = @Clave
		ELSE

		IF @Tabla = 'CFGMOVFLUJO'
			UPDATE CfgMovFlujo WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Modulo = @Modulo
			AND OMov = @Cuenta
			AND DMov = @Clave
		ELSE

		IF @Tabla = 'LISTAGRUPO'
			UPDATE ListaGrupo WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Rama = @Modulo
			AND Grupo = @Clave
		ELSE

		IF @Tabla = 'NOMXFORMULA'
			UPDATE NomXFormula WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE ID = @ID
			AND Formula = @Clave
		ELSE

		IF @Tabla = 'NOMXBASE'
			UPDATE NomXBase WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Formula = @Clave
		ELSE

		IF @Tabla = 'NOMXPERSONAL'
			UPDATE NomXPersonal WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE ID = @ID
			AND Concepto = @Clave
		ELSE

		IF @Tabla = 'SERVICIOTAREA'
			UPDATE ServicioTarea WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE ID = @ID
			AND Tarea = @Clave
		ELSE

		IF @Tabla = 'MOVTAREA'
			UPDATE MovTarea WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Modulo = @Modulo
			AND ID = @ID
			AND Tarea = @Clave
		ELSE

		IF @Tabla = 'ANEXOCTA'
			UPDATE AnexoCta WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Rama = @Modulo
			AND Cuenta = @Cuenta
			AND Nombre = @Clave
		ELSE

		IF @Tabla = 'ANEXOMOV'
			UPDATE AnexoMov WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Rama = @Modulo
			AND ID = @ID
			AND Nombre = @Clave
		ELSE

		IF @Tabla = 'ANEXOMOVD'
			UPDATE AnexoMovD WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Rama = @Modulo
			AND ID = @ID
			AND Cuenta = @Cuenta
			AND Nombre = @Clave
		ELSE

		IF @Tabla = 'CTERUTA'
			UPDATE Cte WITH(ROWLOCK)
			SET RutaOrden = @Orden
			WHERE Cliente = @Clave
		ELSE

		IF @Tabla = 'ARTINFOADICIONAL'
			UPDATE ArtInfoAdicional WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Articulo = @Cuenta
			AND Datos = @Clave
		ELSE

		IF @Tabla = 'MOVTIPOCONTAUTO'
			UPDATE MovTipoContAuto WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Modulo = @Modulo
			AND Clave = @Cuenta
			AND Nombre = @Clave
			AND Empresa = @Llave
		ELSE

		IF @Tabla = 'CAMPOEXTRAAYUDALISTA'
			UPDATE CampoExtraAyudaLista WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE CampoExtra = @Llave
			AND Opcion = @Clave
		ELSE

		IF @Tabla = 'COMPETENCIAFORMATO'
			UPDATE CompetenciaFormato WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Punto = @Clave
		ELSE

		IF @Tabla = 'ACTIVOFTIPOINDICADORLISTA'
			UPDATE ActivoFTipoIndicadorLista WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Valor = @Clave
			AND Tipo = @Cuenta
			AND Indicador = @Llave
		ELSE

		IF @Tabla = 'VisorWeb'
			UPDATE VisorWebConfigD WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Formato = @Cuenta
			AND RID = @Clave
		ELSE

		IF @Tabla = 'ALMPOS'
			UPDATE AlmPos WITH(ROWLOCK)
			SET Orden = @Orden
			WHERE Posicion = @Clave
			AND Almacen = @Llave

	END

	FETCH NEXT FROM crListaSt INTO @Clave
	END
	CLOSE crListaSt
	DEALLOCATE crListaSt
	COMMIT TRANSACTION
	RETURN
END
GO