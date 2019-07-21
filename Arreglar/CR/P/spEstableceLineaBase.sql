SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spEstableceLineaBase
@IDProyecto	int,
@Accion varchar(20)

AS BEGIN
IF EXISTS(SELECT * FROM LineaBase WHERE ID = @IDProyecto)
DELETE FROM LineaBase WHERE ID = @IDProyecto
IF EXISTS(SELECT * FROM LineaBaseD WHERE ID = @IDProyecto)
DELETE FROM LineaBaseD WHERE ID = @IDProyecto
IF @Accion = 'ESTABLECE'
BEGIN
INSERT LineaBase SELECT ID,GETDATE(),Empresa,Mov,MovID,ISNULL(FechaEmision,''),ISNULL(UltimoCambio,''),Proyecto,ProyectoReestructurar,Reestructurar,ISNULL(FechaRevision,''),ContactoTipo,Prospecto,Cliente,Proveedor,Personal,Agente,Riesgo,ProyectoRama,UEN,Concepto,Usuario,Autorizacion,DocFuente,Observaciones,Referencia,Estatus,Situacion,ISNULL(SituacionFecha,''),SituacionUsuario,SituacionNota,Moneda,TipoCambio,OrigenTipo,Origen,OrigenID,Ejercicio,Periodo,ISNULL(FechaRegistro,''),ISNULL(FechaConclusion,''),ISNULL(FechaCancelacion,''),ISNULL(Comienzo,''),ISNULL(Fin,''),ConsiderarAvanceActual,CalculoInverso,Sucursal,Prioridad,Supervisor,DiasHabiles,HorasDia,	MontoEstimado,ISNULL(FechaEstimada,''),Probabilidad,Avance,Comentarios,ISNULL(FechaRequerida,''),Descripcion,SucursalOrigen,SucursalDestino FROM Proyecto WHERE ID = @IDProyecto
INSERT LineaBaseD SELECT ID,Actividad,Predecesora,Orden,EsFase,Clave,Asunto,Tipo,Categoria,Grupo,Familia,Duracion,DuracionUnidad,DuracionDias,
Comentarios,Usuario,UltimoCambio,Comienzo,Fin,Estado,Avance,Prioridad,ComienzoEsp,Sincronizando,Proyecto,EstaLiberado,FechaLiberacion,
TieneMovimientos,EsNuevo,FechaInicio,FechaConclusion,Sucursal,SucursalOrigen,SucursalDestino,IDGestion,MovGestion,RecursosAsignados,
Indicador,Esfuerzo FROM ProyectoD WHERE ID = @IDProyecto
END
END

