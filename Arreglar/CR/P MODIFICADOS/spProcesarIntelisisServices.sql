SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spProcesarIntelisisServices
@Empresa         varchar (10)
 
AS BEGIN
DECLARE
@ProdInterfazINFOR bit,
@ID int,
@Procesando bit
SELECT @ProdInterfazINFOR = ProdInterfazINFOR
FROM EmpresaGral WITH(NOLOCK) WHERE Empresa = @Empresa
DELETE ProcesarIntelisisService WHERE ID NOT IN (SELECT ID FROM IntelisisService WITH(NOLOCK))
IF @ProdInterfazINFOR = 1
BEGIN
DECLARE	crProcesarIS CURSOR LOCAL FAST_FORWARD FOR
SELECT	ID, Procesando FROM ProcesarIntelisisService WHERE Procesado = 0 ORDER By Id ASC
OPEN	crProcesarIS
FETCH NEXT FROM crProcesarIS INTO @ID, @Procesando
WHILE @@FETCH_STATUS = 0
BEGIN
IF @Procesando = 0
BEGIN
UPDATE ProcesarIntelisisService WITH(ROWLOCK) SET Procesando = 1 WHERE ID = @ID
EXEC spIntelisisServiceProcesar @ID
UPDATE ProcesarIntelisisService WITH(ROWLOCK) SET Procesado = 1 WHERE ID = @ID
END
FETCH NEXT FROM crProcesarIS INTO @ID, @Procesando
END
CLOSE crProcesarIS
DEALLOCATE crProcesarIS
END
RETURN
END

