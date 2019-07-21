SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CteMovTarea

AS
SELECT
'Modulo' = CONVERT(char(5), 'VTAS'),
t.ID,
t.Tarea,
t.Problema,
t.Solucion,
t.Fecha,
t.Estado,
t.Responsable,
t.FechaEstimada,
t.FechaConclusion,
m.Mov,
m.MovID,
m.Estatus,
m.Situacion,
m.SituacionFecha,
m.SituacionUsuario,
m.SituacionNota,
m.FechaEmision,
m.Empresa,
m.Sucursal,
m.Cliente,
m.Referencia,
m.Concepto,
m.UEN,
m.Proyecto
FROM Venta m
JOIN ServicioTarea t ON m.ID = t.ID
UNION ALL
SELECT
'Modulo' = CONVERT(char(5), 'ST'),
t.ID,
t.Tarea,
t.Problema,
t.Solucion,
t.Fecha,
t.Estado,
t.Responsable,
t.FechaEstimada,
t.FechaConclusion,
m.Mov,
m.MovID,
m.Estatus,
m.Situacion,
m.SituacionFecha,
m.SituacionUsuario,
m.SituacionNota,
m.FechaEmision,
m.Empresa,
m.Sucursal,
m.Cliente,
m.Referencia,
m.Concepto,
m.UEN,
m.Proyecto
FROM Soporte m
JOIN MovTarea t ON m.ID = t.ID
WHERE
t.Modulo = 'ST'

