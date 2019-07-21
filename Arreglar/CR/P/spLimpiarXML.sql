SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spLimpiarXML
(
@Exportacion varchar(50),
@Modulo varchar(15),
@ID int
)

AS
BEGIN
DECLARE
@TagLimpiar			varchar(MAX),
@DocumentoTexto		varchar(MAX),
@Cont			int,
@RID			int
SET @RID = 1
SELECT @Cont = COUNT(RID)
FROM TablaParseoD
WHERE Exportacion = @Exportacion
WHILE @RID <= @Cont
BEGIN
SELECT @DocumentoTexto = DocumentoTexto
FROM MovXML
WHERE Modulo = @Modulo AND ModuloID = @ID
SELECT @TagLimpiar = TagLimpiar
FROM TablaParseoD
WHERE Exportacion = @Exportacion AND RID = @RID
IF @TagLimpiar IS NULL or @TagLimpiar = ''
SET @RID = @RID+1
ELSE
BEGIN
UPDATE MovXML
SET DocumentoTexto = (SELECT REPLACE(@DocumentoTexto,@TagLimpiar,''))
WHERE Modulo = @Modulo AND ModuloID = @ID
SET @RID = @RID+1
END
END
END

