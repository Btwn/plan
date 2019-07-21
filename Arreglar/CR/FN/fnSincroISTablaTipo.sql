SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnSincroISTablaTipo
(
@Tabla					varchar(50)
)
RETURNS varchar(20)

AS BEGIN
DECLARE
@Resultado	varchar(20)
SET @Resultado = NULL
SELECT @Resultado = Tipo FROM SysTabla WHERE SysTabla = @Tabla
IF @Tabla IN ('Precio','PrecioD','AroEventoPerdida','AroEventoPerdidaD','AroEvaluacion','AroEvaluacionD','ArtMaterialHist','ArtMaterialHistD','GRP_Presupuesto','GRP_PresupuestoD','MovSituacion','MovSituacionD','MovSituacionUsuario','PlantillaOffice','PlantillaOfficeD','CteCto','CteCtoGrupo','CteCtoComites','CteCtoActividad','CteCtoDireccion','CteCtoHist','TareaBitacora','Tarea','NomX','NomXPersonal','NomXDin','NomXGasto','NomXCxp','NomXCxc','NomXFormula','NomXPersonalGrupo','eDocD','eDocDMapeoCampo','eDocDTagSostener','ContX','ContXD','Evento','EventoD') SELECT @Resultado = 'Movimiento'
RETURN (@Resultado)
END

