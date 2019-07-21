SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ExplorarGestion
AS
SELECT
g.ID,
g.Empresa,
g.Mov,
g.MovID,
ISNULL(RTRIM(g.Mov),'') + ' ' + ISNULL(RTRIM(g.MovID),'') Movimiento,
NULLIF(RTRIM(ISNULL(RTRIM(g.Origen),'') + ' ' + ISNULL(RTRIM(g.OrigenID),'')),'') Rama,
CASE WHEN EXISTS(SELECT 1 FROM Gestion g1 WITH (NOLOCK) WHERE RTRIM(g1.Origen) = RTRIM(g.Mov) AND RTRIM(g1.OrigenID) = RTRIM(g.MovID) AND g1.Estatus IN ('PENDIENTE','CONCLUIDO')) THEN 1 ELSE 0 END EsAcumulativo,
g.FechaEmision,
g.UltimoCambio,
g.Concepto,
g.Proyecto,
g.UEN,
g.Usuario,
g.Autorizacion,
g.Referencia,
g.DocFuente,
g.Observaciones,
g.Estatus,
g.Situacion,
g.SituacionFecha,
g.SituacionUsuario,
g.SituacionNota,
g.RamaID,
g.IDOrigen,
g.OrigenTipo,
g.Origen,
g.OrigenID,
g.Ejercicio,
g.Periodo,
g.FechaRegistro,
g.FechaAutorizacion,
g.FechaConclusion,
g.FechaCancelacion,
g.Sucursal,
g.Asunto,
g.Motivo,
g.Espacio,
g.Comentarios,
g.FechaD,
g.FechaA,
g.HoraD,
g.HoraA,
g.TodoElDia,
g.Duracion,
g.Estado,
g.EstadoAnterior,
g.Avance,
g.AvanceAnterior,
g.Prioridad,
g.PuedeDevolver,
g.Mensaje,
g.Gastos,
g.SucursalOrigen,
g.SucursalDestino
FROM
Gestion g WITH (NOLOCK)
WHERE Estatus IN ('PENDIENTE','CONCLUIDO','SINAFECTAR','BORRADOR')

