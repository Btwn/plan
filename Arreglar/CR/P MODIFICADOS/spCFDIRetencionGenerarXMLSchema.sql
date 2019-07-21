SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionGenerarXMLSchema
@Version		varchar(5)

AS
BEGIN
DECLARE @IDSQL		varchar(100),
@XSD			nvarchar(max),
@XMLSchema	nvarchar(max)
SELECT @XSD		  = REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(XSD)),CHAR(13),''),CHAR(10),''), '''', '')
FROM CFDIRetencionXMLXSD WITH (NOLOCK)
WHERE Version = @Version
SET @IDSQL = 'Retencion_' + @Version
IF EXISTS (SELECT * FROM sys.xml_schema_collections WHERE name = @IDSQL)
BEGIN
SET @XMLSchema = 'DROP XML SCHEMA COLLECTION ' + '[' + RTRIM(@IDSQL) + ']'
EXECUTE sp_executesql @XMLSchema
IF NULLIF(RTRIM(@XSD),'') IS NOT NULL
BEGIN
SET @XMLSchema = 'CREATE XML SCHEMA COLLECTION ' + '[' + RTRIM(@IDSQL) + ']' + ' AS ' + CHAR(39) + RTRIM(@XSD) + CHAR(39)
EXECUTE sp_executesql @XMLSchema
END
END
ELSE
BEGIN
IF NULLIF(RTRIM(@XSD),'') IS NOT NULL
BEGIN
SET @XMLSchema = 'CREATE XML SCHEMA COLLECTION ' + '[' + RTRIM(@IDSQL) + ']' + ' AS ' + CHAR(39) + RTRIM(@XSD) + CHAR(39)
EXECUTE sp_executesql @XMLSchema
END
END
END

