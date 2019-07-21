SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW pNetCampana
AS
SELECT
c.ID,
LTRIM(RTRIM(ISNULL(c.Mov,''))) + ' ' + LTRIM(RTRIM(ISNULL(c.MovID,''))) Movimiento,
c.Asunto,
c.CampanaTipo,
c.FechaEmision,
c.Estatus,
c.Usuario,
c.Empresa,
c.Mov,
c.MovID,
c.UltimoCambio,
c.Concepto,
c.Proyecto,
c.Observaciones,
c.FechaRegistro,
c.Sucursal,
c.Agente,
a.Nombre AgenteNombre,
(SELECT COUNT(RID) FROM CampanaD cd WHERE cd.ID = c.ID) TotalContactos
FROM Campana c
LEFT JOIN Agente a ON c.Agente = a.Agente
LEFT JOIN MovTipo mt ON 'CMP' = mt.Modulo AND c.Mov = mt.Mov
WHERE mt.Clave = 'CMP.C'
GROUP BY c.ID, c.Mov, c.MovID, c.Asunto, c.CampanaTipo, c.FechaEmision, c.Estatus, c.Usuario, c.Empresa, c.Mov, c.MovID,
c.UltimoCambio, c.Concepto, c.Proyecto, c.Observaciones, c.FechaRegistro, c.Sucursal, c.Agente, a.Nombre

