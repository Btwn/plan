SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW vwSWCte_ConAtenRep
AS
SELECT
S.ID,
RTrim(S.Mov) + isnull(' ' + RTrim(S.MovID), '') Titulo,
S.Prioridad,
S.FechaEmision,
S.FechaConclusion,
isnull(R.Nombre, 'Sin Asignar') Nombre,
S.Estatus,
S.Cliente,
S.Empresa
FROM Soporte S LEFT JOIN Recurso R ON S.UsuarioResponsable = R.Recurso
WHERE S.Submodulo IN ('ST')

