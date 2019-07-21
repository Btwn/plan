SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocGenerarXMLSchema
(
@Modulo			varchar(5),
@eDoc			varchar(50)
)

AS
BEGIN
DECLARE @IDSQL		varchar(100),
@XSD				nvarchar(MAX),
@XMLSchema		nvarchar(max),
@Clave			varchar(50)
SELECT
@Clave = XSD
FROM eDoc
WHERE Modulo = @Modulo
AND eDoc = @eDoc
SET @IDSQL = @Clave
SELECT @XSD = REPLACE(REPLACE(LTRIM(RTRIM(XSD)),CHAR(13),''),CHAR(10),'')
FROM eDocXSD
WHERE Clave = @Clave
AND Modulo = @Modulo
IF EXISTS (SELECT * FROM sys.xml_schema_collections WHERE name = @IDSQL)
BEGIN
SET @XMLSchema = 'DROP XML SCHEMA COLLECTION ' + '[' + RTRIM(@IDSQL) + ']'
EXECUTE sp_executesql @XMLSchema
BEGIN
SET @XMLSchema = 'CREATE XML SCHEMA COLLECTION ' + '[' + RTRIM(@IDSQL) + ']' + ' AS ' + 'N' + CHAR(39) + RTRIM(@XSD) + CHAR(39)
EXECUTE sp_executesql @XMLSchema
END
END
ELSE
BEGIN
IF NULLIF(RTRIM(@XSD),'') IS NOT NULL
BEGIN
SET @XMLSchema = 'CREATE XML SCHEMA COLLECTION ' + '[' + RTRIM(@IDSQL) + ']' + ' AS ' + 'N' + CHAR(39) + RTRIM(@XSD) + CHAR(39)
EXECUTE sp_executesql @XMLSchema
END
END
END

