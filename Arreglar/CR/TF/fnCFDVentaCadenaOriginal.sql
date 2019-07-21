SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCFDVentaCadenaOriginal ()
RETURNS @Resultado TABLE (OrdenExportacion varchar(255), ID int, CadenaOriginal varchar(255))

AS BEGIN
DECLARE
@OrdenExportacion	varchar(255),
@ID					int,
@CadenaOriginal 	varchar(max),
@ModuloID			int
SELECT @ModuloID = ID FROM CFDFlexSesion WHERE Estacion = @@SPID AND Modulo = 'VTAS'
DECLARE crCFDVentaCadenaOriginal CURSOR FOR
SELECT REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,Venta.ID))))) + RTRIM(LTRIM(CONVERT(varchar,Venta.ID))) +
REPLICATE(' ',12) +
REPLICATE(' ',7) +
REPLICATE(' ',50)
OrdenExportacion,
Venta.ID ID,
CFD.CadenaOriginal
FROM Venta JOIN CFD
ON CFD.ModuloID = Venta.ID AND CFD.Modulo = 'VTAS'
WHERE Venta.ID = @ModuloID
OPEN crCFDVentaCadenaOriginal
FETCH NEXT FROM crCFDVentaCadenaOriginal INTO @OrdenExportacion, @ID, @CadenaOriginal
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT @Resultado ( OrdenExportacion,  ID,  CadenaOriginal)
SELECT              @OrdenExportacion, @ID, CadenaOriginal
FROM dbo.fnTextoaTabla(@CadenaOriginal, 130)
FETCH NEXT FROM crCFDVentaCadenaOriginal INTO @OrdenExportacion, @ID, @CadenaOriginal
END
CLOSE crCFDVentaCadenaOriginal
DEALLOCATE crCFDVentaCadenaOriginal
RETURN
END

