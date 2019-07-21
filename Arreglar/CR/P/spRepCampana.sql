SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRepCampana
@Mov    varchar(20),
@MovID  varchar(20)

AS BEGIN
DECLARE
@ID    int
SELECT @ID = ID
FROM Campana
WHERE Mov=@Mov AND MovID = @MovID
SELECT Campana.ID,           Campana.Empresa,  Campana.Mov,         Campana.MovID,
Campana.FechaEmision, Campana.Concepto, Campana.Proyecto,    Campana.Estatus,
Campana.Asunto,       Campana.Agente,   Campana.CampanaTipo, Campana.TieneVigencia,
Campana.FechaD,       Campana.FechaA,   ProyDescripcion = Proy.Descripcion,
UEN.UEN,              UEN.Nombre,
AgenteNombre = Agente.Nombre,
CampanaTipo.ParaProspectos,
CampanaTipo.ParaClientes,
CampanaTipo.ParaProveedores,
CampanaTipo.ParaPersonal,
CampanaTipo.ParaAgentes,
e.Nombre as 'NombreEmpresa'
FROM Campana LEFT OUTER JOIN UEN
ON Campana.UEN=UEN.UEN LEFT OUTER JOIN Proy
ON Campana.Proyecto=Proy.Proyecto LEFT OUTER JOIN Agente
ON Campana.Agente=Agente.Agente LEFT OUTER JOIN CampanaTipo
ON Campana.CampanaTipo=CampanaTipo.CampanaTipo JOIN Empresa e
ON Campana.Empresa = e.Empresa
WHERE Campana.ID = @ID ORDER BY Campana.ID DESC
RETURN
END

