SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCFDCxcCadenaOriginal ()
RETURNS @Resultado TABLE (OrdenExportacion varchar(255), ID int, CadenaOriginal varchar(255))

AS BEGIN
DECLARE
@OrdenExportacion	varchar(255),
@ID					int,
@CadenaOriginal 	varchar(max),
@ModuloID			int
SELECT @ModuloID = ID FROM CFDFlexSesion WHERE Estacion = @@SPID AND Modulo = 'CXC'
DECLARE crCFDCxcCadenaOriginal CURSOR FOR
SELECT REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,Cxc.ID))))) + RTRIM(LTRIM(CONVERT(varchar,Cxc.ID))) +
REPLICATE(' ',12) +
REPLICATE(' ',7) +
REPLICATE(' ',50)
OrdenExportacion,
Cxc.ID ID,
CFD.CadenaOriginal
FROM Cxc JOIN CFD
ON CFD.ModuloID = Cxc.ID AND CFD.Modulo = 'CXC'
WHERE Cxc.ID = @ModuloID
OPEN crCFDCxcCadenaOriginal
FETCH NEXT FROM crCFDCxcCadenaOriginal INTO @OrdenExportacion, @ID, @CadenaOriginal
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT @Resultado ( OrdenExportacion,  ID,  CadenaOriginal)
SELECT              @OrdenExportacion, @ID, CadenaOriginal
FROM dbo.fnTextoaTabla(@CadenaOriginal, 130)
FETCH NEXT FROM crCFDCxcCadenaOriginal INTO @OrdenExportacion, @ID, @CadenaOriginal
END
CLOSE crCFDCxcCadenaOriginal
DEALLOCATE crCFDCxcCadenaOriginal
RETURN
END

