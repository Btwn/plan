SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CteMovBitacora

AS
SELECT
b.Modulo,
b.ID,
b.RID,
b.Fecha,
b.Evento,
b.Usuario,
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
FROM CteMov m WITH (NOLOCK)
JOIN MovBitacora b WITH (NOLOCK) ON m.ID = b.ID AND m.Modulo = b.Modulo

