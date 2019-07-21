SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW pNetCampanaEvento
AS
SELECT c.ID, cd.RID, ce.EventoID, ce.FechaHora, ce.Tipo, ce.Situacion, ce.SituacionFecha, ce.Observaciones, ce.Sucursal, cd.Contacto, p.Nombre,
c.CampanaTipo, cd.Usuario, u.Nombre UsuarioNombre, LTRIM(RTRIM(c.Mov))+' '+LTRIM(RTRIM(c.MovID)) Movimiento, c.Estatus
FROM Campana c JOIN CampanaD cd ON c.ID = cd.ID
JOIN CampanaEvento ce ON cd.ID = ce.ID AND cd.RID = ce.RID
LEFT JOIN Usuario u ON cd.Usuario =  u.Usuario
LEFT JOIN Prospecto p ON cd.ContactoTipo = 'Prospecto' AND cd.Contacto = p.Prospecto

