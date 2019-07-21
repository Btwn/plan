SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDocInXmlNSListarNodo
(
@XML2			varchar(max),
@estacion               int
)

AS BEGIN
DECLARE
@Prefijo			varchar(max),
@Nombre			varchar(max),
@Path			varchar(max),
@XMLNS			varchar(max),
@NodoPrincipalXML    	varchar(max),
@SQL			nvarchar(max),
@Resultado			varchar(max),
@xml                        xml,
@Valor                      varchar(36)
SELECT @Valor=NEWID()
DELETE eDocInNodoTemp WHERE Estacion = @estacion
EXEC speDocInPrefijo @xml2,@Estacion
SET @XMLNS = dbo.fneDocInXmlns(CONVERT(varchar(max),@XML),0)
DECLARE crXMLNS CURSOR FOR
SELECT ISNULL(Prefijo,''), Nombre
FROM eDocInNSPrefijo
WHERE Estacion = @Estacion
ORDER BY ID
OPEN crXMLNS
FETCH NEXT FROM crXMLNS INTO @Prefijo, @Nombre
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @XML2 = REPLACE(@xml2,@prefijo,REPLACE(@Prefijo,CHAR(58),@Valor))
FETCH NEXT FROM crXMLNS INTO @Prefijo, @Nombre
END
CLOSE crXMLNS
DEALLOCATE crXMLNS
SELECT @xml = CONVERT(xml,@xml2);
WITH Xml_CTE AS
(SELECT CAST('/' + node.value('local-name(.)','varchar(max)') AS varchar(max)) AS name,
node.query('*') AS children
FROM @xml.nodes('/*') AS roots(node)
UNION ALL
SELECT CAST(x.name + '/' + node.value('local-name(.)', 'varchar(max)') AS varchar(max)),
node.query('*') AS children
FROM Xml_CTE x
CROSS APPLY x.children.nodes('*') AS child(node))
INSERT eDocInNodoTemp(Estacion,Nodo,NodoNombre)
SELECT DISTINCT @estacion, REPLACE(name,@Valor,CHAR(58))+'/',REPLACE(stuff(REPLACE(name,@Valor,CHAR(58)),1,1,'' ),'/','_')
FROM Xml_CTE
OPTION (MAXRECURSION 1000)
END

