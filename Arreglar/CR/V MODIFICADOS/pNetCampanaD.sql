SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW pNetCampanaD
AS
SELECT
cd.ID,
cd.RID,
cd.Contacto,
cd.ContactoTipo,
cd.Situacion,
dbo.fnFechaSinHora(cd.SituacionFecha) SituacionFecha,
cd.Observaciones,
cd.Usuario,
cd.Sucursal,
cd.SucursalOrigen,
p.Nombre,
p.Tipo,
LTRIM(RTRIM(c.Mov)) + ' ' + LTRIM(RTRIM(c.MovID)) Movimiento,
p.Origen,
p.Categoria,
c.CampanaTipo,
c.FechaEmision,
p.Agente,
a.Nombre AgenteNombre,
c.Estatus
FROM CampanaD cd WITH(NOLOCK) JOIN Prospecto p WITH(NOLOCK) ON cd.ContactoTipo = 'Prospecto' AND cd.Contacto = p.Prospecto
LEFT JOIN Agente a WITH(NOLOCK) ON p.Agente = a.Agente
JOIN Campana c WITH(NOLOCK) ON cd.ID = c.ID

