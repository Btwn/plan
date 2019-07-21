SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRepCampanaD
@Mov    varchar(20),
@MovID  varchar(20)

AS BEGIN
DECLARE
@ID    int
SELECT @ID = ID
FROM Campana
WHERE Mov=@Mov AND MovID = @MovID
SELECT CampanaD.ID,           CampanaD.RID,           CampanaD.Sucursal,  CampanaD.SucursalOrigen,
CampanaD.Contacto,     CampanaD.ContactoTipo,  CampanaD.Situacion, CampanaD.SituacionFecha,
CampanaD.Calificacion, CampanaD.Observaciones, CampanaD.Usuario,   Usuario.Nombre,
Agente = (SELECT '(' + cte.Agente + ') ' + a.Nombre from Cte JOIN Agente a ON Cte.Agente = a.Agente WHERE Cte.Cliente=CampanaD.Contacto and CampanaD.ContactoTipo='Cliente'),
(dbo.fnContactoNivel(CampanaD.ContactoTipo, CampanaD.Contacto, 'Nombre')) ContactoNombre,
(dbo.fnContactoNivel(CampanaD.ContactoTipo, CampanaD.Contacto, 'Sub Tipo')) ContactoSubTipo,
(dbo.fnCampanaTipoSituacionIcono (CampanaD.ID, CampanaD.Situacion)) Icono
FROM CampanaD LEFT OUTER JOIN Usuario
ON CampanaD.Usuario=Usuario.Usuario
WHERE CampanaD.ID= @ID
RETURN
END

