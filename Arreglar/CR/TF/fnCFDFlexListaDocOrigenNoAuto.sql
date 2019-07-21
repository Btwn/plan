SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCFDFlexListaDocOrigenNoAuto (@ID int)
RETURNS @Resultado TABLE (ID int, Empresa varchar(5), Mov varchar(20), MovID varchar(20))

AS BEGIN
DECLARE
@Modulo		varchar(5)
SET @Modulo = 'CXC'
INSERT @Resultado (  ID, Empresa,   Mov,   MovID)
SELECT o.ID, o.Empresa, o.Mov, o.MovID
FROM Cxc c
JOIN MovTipo mt ON mt.Mov = c.Mov AND mt.Modulo = 'CXC'
LEFT OUTER JOIN DocAuto da ON c.Origen = da.Mov AND c.OrigenID = da.MovID AND c.OrigenTipo = da.Modulo AND c.Empresa = da.Empresa
JOIN Cxc o ON c.Origen = o.Mov AND c.OrigenID = o.MovID AND c.OrigenTipo = 'CXC' AND c.Empresa = o.Empresa
WHERE mt.Clave = 'CXC.D' AND da.ID IS NULL AND c.Estatus = 'PENDIENTE' AND c.ID = @ID
GROUP BY o.ID, o.Empresa, o.Mov, o.MovID
UNION
SELECT oo.ID, oo.Empresa, oo.Mov, oo.MovID
FROM Cxc c
JOIN CxcD d ON c.ID = d.ID
JOIN Cxc o ON o.Mov = d.Aplica AND o.MovID = d.AplicaID
JOIN CxcD od ON od.ID = o.ID
JOIN Cxc oo ON oo.Mov = od.Aplica AND oo.MovID = od.AplicaID AND oo.Empresa = c.Empresa
JOIN MovTipo mt ON mt.Mov = o.Mov AND mt.Modulo = 'cxc'
LEFT OUTER JOIN DocAuto da ON oo.Origen = da.Mov AND oo.OrigenID = da.MovID
WHERE da.Mov IS NULL AND da.MovID IS NULL AND c.ID = @ID AND mt.Clave = 'CXC.D' AND c.Empresa = oo.Empresa
GROUP BY oo.ID, oo.Empresa, oo.Mov, oo.MovID
RETURN
END

