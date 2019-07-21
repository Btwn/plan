SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCFDFlexListaDocNoAuto (@ID int)
RETURNS @Resultado TABLE (ID int, Referencia varchar(50))

AS BEGIN
DECLARE
@OID			int,
@OEmpresa		char(5),
@OMov			varchar(20),
@OMovID			varchar(20)
SELECT
@OID = ID,
@OEmpresa = Empresa,
@OMov = Mov,
@OMovID = MovID
FROM dbo.fnCFDFlexListaDocOrigenNoAuto(@ID)
INSERT @Resultado (ID, Referencia)
SELECT c.ID, @OMov + ' ' + @OMovID
FROM Cxc c
JOIN MovTipo mt
ON mt.Mov = c.Mov AND mt.Modulo = 'CXC'
WHERE c.Origen = @OMov
AND c.OrigenID = @OMovID
AND c.Empresa = @OEmpresa
AND c.ID <> @OID
AND mt.Clave = 'CXC.D' AND c.Estatus = 'PENDIENTE'
UNION
SELECT c.ID, @OMov + ' ' + @OMovID
FROM Cxc c
JOIN CxcD d ON c.ID = d.ID
JOIN MovTipo mt
ON mt.Mov = c.Mov AND mt.Modulo = 'CXC'
WHERE d.Aplica = @OMov
AND d.AplicaID = @OMovID
AND mt.Clave = 'CXC.D' AND c.Estatus = 'PENDIENTE'
UNION
SELECT c.ID, @OMov + ' ' + @OMovID
FROM Cxc c
JOIN MovTipo mt
ON mt.Mov = c.Mov AND mt.Modulo = 'CXC'
JOIN Cxc o ON c.Origen = o.Mov AND c.OrigenID = c.OrigenID AND c.Empresa = o.Empresa
WHERE c.Origen = @OMov
AND c.OrigenID = @OMovID
AND c.Empresa = @OEmpresa
AND c.ID <> @OID
AND mt.Clave = 'CXC.D' AND c.Estatus = 'CONCLUIDO'
UNION
SELECT c.ID, @OMov + ' ' + @OMovID
FROM Cxc c
JOIN CxcD d ON c.ID = d.ID
JOIN MovTipo mt
ON mt.Mov = c.Mov AND mt.Modulo = 'CXC'
JOIN Cxc o ON c.Origen = o.Mov AND c.OrigenID = c.OrigenID AND c.Empresa = o.Empresa
WHERE d.Aplica = @OMov
AND d.AplicaID = @OMovID
AND mt.Clave = 'CXC.D' AND c.Estatus = 'CONCLUIDO'
RETURN
END

