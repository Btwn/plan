SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
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
		FROM ListaSt
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
			UPDATE Alm
			SET Orden = @Orden
			WHERE Almacen = @Clave
		ELSE

		IF @Tabla = 'TiposCoberturaMAVI'
			UPDATE TiposCoberturaMAVI
			SET Orden = @Orden
			WHERE Cobertura = @Clave
		ELSE

		IF @Tabla = 'MON'
			UPDATE Mon
			SET Orden = @Orden
			WHERE Moneda = @Clave
		ELSE

		IF @Tabla = 'UNIDAD'
			UPDATE Unidad
			SET Orden = @Orden
			WHERE Unidad = @Clave
		ELSE

		IF @Tabla = 'CONDICION'
			UPDATE Condicion
			SET Orden = @Orden
			WHERE Condicion = @Clave
		ELSE

		IF @Tabla = 'CENTRO'
			UPDATE Centro
			SET Orden = @Orden
			WHERE Centro = @Clave
		ELSE

		IF @Tabla = 'CONDICION'
			UPDATE Condicion
			SET Orden = @Orden
			WHERE Condicion = @Clave
		ELSE

		IF @Tabla = 'ARTSUSTITUTO'
			UPDATE ArtSustituto
			SET Orden = @Orden
			WHERE Sustituto = @Clave
		ELSE

		IF @Tabla = 'EMBARQUEESTADO'
			UPDATE EmbarqueEstado
			SET Orden = @Orden
			WHERE Estado = @Clave
		ELSE

		IF @Tabla = 'NACIONALIDAD'
			UPDATE Nacionalidad
			SET Orden = @Orden
			WHERE Nacionalidad = @Clave
		ELSE

		IF @Tabla = 'IDIOMA'
			UPDATE Idioma
			SET Orden = @Orden
			WHERE Idioma = @Clave
		ELSE

		IF @Tabla = 'ACTIVIDAD'
			UPDATE Actividad
			SET Orden = @Orden
			WHERE Actividad = @Clave
		ELSE

		IF @Tabla = 'FORMAPAGO'
			UPDATE FormaPago
			SET Orden = @Orden
			WHERE FormaPago = @Clave
		ELSE

		IF @Tabla = 'PERSONALPROP'
			UPDATE PersonalProp
			SET Orden = @Orden
			WHERE Propiedad = @Clave
		ELSE

		IF @Tabla = 'SOPORTEESTADO'
			UPDATE SoporteEstado
			SET Orden = @Orden
			WHERE Estado = @Clave
		ELSE

		IF @Tabla = 'ZONA'
			UPDATE Zona
			SET OrdenEmbarque = @Orden
			WHERE Zona = @Clave
		ELSE

		IF @Tabla = 'TAREAESTADO'
			UPDATE TareaEstado
			SET Orden = @Orden
			WHERE Estado = @Clave
		ELSE

		IF @Tabla = 'CMPESTADO'
			UPDATE CMPEstado
			SET Orden = @Orden
			WHERE Estado = @Clave
		ELSE

		IF @Tabla = 'PRECIOCALC'
			UPDATE PrecioCalc
			SET Orden = @Orden
			WHERE ListaPrecios = @Clave
		ELSE

		IF @Tabla = 'MOVCTE'
			UPDATE MovCte
			SET Orden = @Orden
			WHERE Nombre = @Clave
		ELSE

		IF @Tabla = 'MOVPROY'
			UPDATE MovProy
			SET Orden = @Orden
			WHERE Nombre = @Clave
		ELSE

		IF @Tabla = 'MOVPROV'
			UPDATE MovProv
			SET Orden = @Orden
			WHERE Nombre = @Clave
		ELSE

		IF @Tabla = 'FORMAVIRTUALCARPETA'
			UPDATE FormaVirtualCarpeta
			SET Orden = @Orden
			WHERE Carpeta = @Clave
			AND FormaVirtual = @Llave
		ELSE

		IF @Tabla = 'AUTORUTAD'
			UPDATE AutoRutaD
			SET Orden = @Orden
			WHERE Ruta = @Cuenta
			AND Localidad = @Clave
		ELSE

		IF @Tabla = 'AUTOCORRIDAPLANTILLA'
			UPDATE AutoCorridaPlantilla
			SET Orden = @Orden
			WHERE Corrida = @Cuenta
			AND ID = CONVERT(INT, @Clave)
		ELSE

		IF @Tabla = 'SERVICIOTIPOPLANTILLA'
			UPDATE ServicioTipoPlantilla
			SET Orden = @Orden
			WHERE Tipo = @Cuenta
			AND ID = CONVERT(INT, @Clave)
		ELSE

		IF @Tabla = 'EVALUACIONFORMATO'
			UPDATE EvaluacionFormato
			SET Orden = @Orden
			WHERE Evaluacion = @Cuenta
			AND Punto = @Clave
		ELSE

		IF @Tabla = 'CAUSA'
			UPDATE Causa
			SET Orden = @Orden
			WHERE Modulo = @Modulo
			AND Causa = @Clave
		ELSE

		IF @Tabla = 'CLASE'
			UPDATE Clase
			SET Orden = @Orden
			WHERE Modulo = @Modulo
			AND Clase = @Clave
		ELSE

		IF @Tabla = 'CONCEPTO'
			UPDATE Concepto
			SET Orden = @Orden
			WHERE Modulo = @Modulo
			AND Concepto = @Clave
		ELSE

		IF @Tabla = 'MOVTIPO'
			UPDATE MovTipo
			SET Orden = @Orden
			WHERE Modulo = @Modulo
			AND Mov = @Clave
		ELSE

		IF @Tabla = 'MOVTIPOFORMA'
			UPDATE MovTipoForma
			SET Orden = @Orden
			WHERE Modulo = @Modulo
			AND Mov = @Cuenta
			AND Campo = @Clave
		ELSE

		IF @Tabla = 'MOVTIPOFORMAAYUDA'
			UPDATE MovTipoFormaAyuda
			SET Orden = @Orden
			WHERE Modulo = @Modulo
			AND Mov = @Cuenta
			AND Campo = @Llave
			AND Ayuda = @Clave
		ELSE

		IF @Tabla = 'CFGMOVFLUJO'
			UPDATE CfgMovFlujo
			SET Orden = @Orden
			WHERE Modulo = @Modulo
			AND OMov = @Cuenta
			AND DMov = @Clave
		ELSE

		IF @Tabla = 'LISTAGRUPO'
			UPDATE ListaGrupo
			SET Orden = @Orden
			WHERE Rama = @Modulo
			AND Grupo = @Clave
		ELSE

		IF @Tabla = 'NOMXFORMULA'
			UPDATE NomXFormula
			SET Orden = @Orden
			WHERE ID = @ID
			AND Formula = @Clave
		ELSE

		IF @Tabla = 'NOMXBASE'
			UPDATE NomXBase
			SET Orden = @Orden
			WHERE Formula = @Clave
		ELSE

		IF @Tabla = 'NOMXPERSONAL'
			UPDATE NomXPersonal
			SET Orden = @Orden
			WHERE ID = @ID
			AND Concepto = @Clave
		ELSE

		IF @Tabla = 'SERVICIOTAREA'
			UPDATE ServicioTarea
			SET Orden = @Orden
			WHERE ID = @ID
			AND Tarea = @Clave
		ELSE

		IF @Tabla = 'MOVTAREA'
			UPDATE MovTarea
			SET Orden = @Orden
			WHERE Modulo = @Modulo
			AND ID = @ID
			AND Tarea = @Clave
		ELSE

		IF @Tabla = 'ANEXOCTA'
			UPDATE AnexoCta
			SET Orden = @Orden
			WHERE Rama = @Modulo
			AND Cuenta = @Cuenta
			AND Nombre = @Clave
		ELSE

		IF @Tabla = 'ANEXOMOV'
			UPDATE AnexoMov
			SET Orden = @Orden
			WHERE Rama = @Modulo
			AND ID = @ID
			AND Nombre = @Clave
		ELSE

		IF @Tabla = 'ANEXOMOVD'
			UPDATE AnexoMovD
			SET Orden = @Orden
			WHERE Rama = @Modulo
			AND ID = @ID
			AND Cuenta = @Cuenta
			AND Nombre = @Clave
		ELSE

		IF @Tabla = 'CTERUTA'
			UPDATE Cte
			SET RutaOrden = @Orden
			WHERE Cliente = @Clave
		ELSE

		IF @Tabla = 'ARTINFOADICIONAL'
			UPDATE ArtInfoAdicional
			SET Orden = @Orden
			WHERE Articulo = @Cuenta
			AND Datos = @Clave
		ELSE

		IF @Tabla = 'MOVTIPOCONTAUTO'
			UPDATE MovTipoContAuto
			SET Orden = @Orden
			WHERE Modulo = @Modulo
			AND Clave = @Cuenta
			AND Nombre = @Clave
			AND Empresa = @Llave
		ELSE

		IF @Tabla = 'CAMPOEXTRAAYUDALISTA'
			UPDATE CampoExtraAyudaLista
			SET Orden = @Orden
			WHERE CampoExtra = @Llave
			AND Opcion = @Clave
		ELSE

		IF @Tabla = 'COMPETENCIAFORMATO'
			UPDATE CompetenciaFormato
			SET Orden = @Orden
			WHERE Punto = @Clave
		ELSE

		IF @Tabla = 'ACTIVOFTIPOINDICADORLISTA'
			UPDATE ActivoFTipoIndicadorLista
			SET Orden = @Orden
			WHERE Valor = @Clave
			AND Tipo = @Cuenta
			AND Indicador = @Llave
		ELSE

		IF @Tabla = 'VisorWeb'
			UPDATE VisorWebConfigD
			SET Orden = @Orden
			WHERE Formato = @Cuenta
			AND RID = @Clave
		ELSE

		IF @Tabla = 'ALMPOS'
			UPDATE AlmPos
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