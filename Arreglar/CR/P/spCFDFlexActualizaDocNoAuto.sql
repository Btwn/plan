SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexActualizaDocNoAuto
@ID			int

AS BEGIN
DECLARE
@OID			int,
@Contador		int,
@Referencia		varchar(50),
@ContadorFinal	int
SELECT
@Contador = 1,
@ContadorFinal = COUNT(ID)
FROM dbo.fnCFDFlexListaDocNoAuto(@ID)
DECLARE crActualizaDocNoAuto CURSOR FOR
SELECT ID, Referencia
FROM dbo.fnCFDFlexListaDocNoAuto(@ID)
OPEN crActualizaDocNoAuto
FETCH NEXT FROM crActualizaDocNoAuto INTO @OID, @Referencia
WHILE @@FETCH_STATUS <> -1
BEGIN
UPDATE Cxc
SET Referencia = @Referencia+' ('+CONVERT(varchar,@Contador)+ '/' +CONVERT(varchar,@ContadorFinal)+ ')'
FROM Cxc
WHERE ID = @OID AND Estatus IN('PENDIENTE','CONCLUIDO')
SELECT @Contador = @Contador + 1
FETCH NEXT FROM crActualizaDocNoAuto INTO @OID, @Referencia
END  
CLOSE crActualizaDocNoAuto
DEALLOCATE crActualizaDocNoAuto
RETURN
END

