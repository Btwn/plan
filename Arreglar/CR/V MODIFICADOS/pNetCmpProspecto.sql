SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW pNetCmpProspecto
AS
SELECT cd.ID, cd.RID, cd.Contacto, p.Nombre, p.Tipo, cd.Situacion, cd.SituacionFecha, cd.Observaciones, p.Agente, u.Nombre Usuario
FROM CampanaD cd WITH(NOLOCK) JOIN Prospecto p WITH(NOLOCK)
ON cd.Contacto = p.Prospecto AND cd.ContactoTipo = 'Prospecto' LEFT JOIN Usuario u WITH(NOLOCK)
ON cd.Usuario = u.Usuario

