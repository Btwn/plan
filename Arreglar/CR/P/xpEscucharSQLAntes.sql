SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpEscucharSQLAntes
@ID				int = NULL
AS BEGIN
DECLARE
@Expresion	varchar(max),
@XML		varchar(max),
@iDatos		int
IF NULLIF(@ID,0) IS NULL
SELECT TOP 1
@XML = Solicitud,
@ID  = ID
FROM IntelisisService
WITH(NOLOCK)
WHERE Estatus = 'SINPROCESAR'
AND Sistema = 'SDK'
AND Referencia = 'SDK.ReportePDF'
AND Contenido = 'Solicitud'
IF @ID IS NOT NULL
BEGIN
UPDATE IntelisisService SET Estatus = 'PROCESANDO' WHERE ID = @ID
EXEC sp_xml_preparedocument @iDatos OUTPUT, @XML
SELECT
@Expresion = Expresion
FROM OPENXML (@iDatos, '/Intelisis/Solicitud', 2) WITH (Expresion varchar(max))
EXEC sp_xml_removedocument @iDatos
END
SELECT @Expresion = REPLACE(@Expresion, '<T>', CHAR(39)) 
SELECT "ID" = @ID, "Expresion" = @Expresion
END

