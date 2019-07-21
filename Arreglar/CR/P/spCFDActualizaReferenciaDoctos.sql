SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDActualizaReferenciaDoctos
@Modulo	varchar(20),
@ID		int,
@Ok		int OUTPUT,
@OkRef		varchar(255) OUTPUT

AS BEGIN
DECLARE
@OID			int,
@Contador		int,
@Referencia		varchar(50),
@ContadorFinal	int
CREATE TABLE #Doctos (ID int, IDFactura int, EmpresaFactura varchar(5), MovFactura varchar(20), MovIDFactura varchar(20))
INSERT #Doctos (  ID, IDFactura, EmpresaFactura,   MovFactura,   MovIDFactura)
SELECT @ID, o.ID, o.Empresa, o.Mov, o.MovID
FROM Cxc c
JOIN CxcD d ON c.Id = d.ID
JOIN MovTipo mt ON mt.Modulo = 'CXC' AND mt.Mov = d.Aplica AND mt.Clave ='CXC.D'
JOIN MovFlujo mf ON d.Aplica = mf.DMov AND d.AplicaID = mf.DMovID AND mf.Empresa = c.Empresa AND mf.OModulo = 'CXC' AND mf.Cancelado = 0
JOIN MovTipo mo ON mo.Modulo = mf.OModulo AND mf.OMov = mo.Mov AND mo.Clave ='CXC.F'
JOIN Cxc o ON o.ID = mf.OID
WHERE c.ID = @ID
DECLARE
@IDFactura	   int,
@MovFactura	   varchar(20),
@MovIDFactura  varchar(20)
SELECT @IDFactura = IDFactura,
@MovFactura = MovFactura,
@MovIDFactura = MovIDFactura
FROM #Doctos WHERE ID = @ID
CREATE TABLE #doctos2 (ID int, IDDocto int, ReferenciaDocto varchar(50))
INSERT #doctos2 (ID, IDDocto, ReferenciaDocto)
SELECT @ID, c.ID, @MovFactura + ' ' + @MovIDFactura
FROM Cxc c
JOIN MovFlujo mf ON mf.OID = @IDFactura AND mf.DID = c.ID AND mf.Cancelado = 0
JOIN MovTipo mt ON mf.DMov = mt.Mov AND mt.Clave = 'CXC.D'
SELECT @Contador = 1, @ContadorFinal = COUNT(ID)  FROM #Doctos2 WHERE ID = @ID
DECLARE crActualizaDocNoAuto CURSOR FOR
SELECT IDDocto, ReferenciaDocto
FROM #Doctos2 WHERE ID = @ID
ORDER BY IDDocto Asc
OPEN crActualizaDocNoAuto
FETCH NEXT FROM crActualizaDocNoAuto INTO @OID, @Referencia
WHILE @@FETCH_STATUS <> -1
BEGIN
UPDATE Cxc
SET Referencia = @Referencia+' ('+CONVERT(varchar,@Contador)+ '/' +CONVERT(varchar,@ContadorFinal)+ ')'
FROM Cxc
WHERE ID = @OID
SELECT @Contador = @Contador + 1
FETCH NEXT FROM crActualizaDocNoAuto INTO @OID, @Referencia
END  
CLOSE crActualizaDocNoAuto
DEALLOCATE crActualizaDocNoAuto
RETURN
END

