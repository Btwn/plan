SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDocInXmlNSListarNodo2
(
@XML				 varchar(max),
@Nodo                           varchar(max),
@Estacion                       int,
@Resultado2			varchar(max) OUTPUT
)

AS BEGIN
DECLARE
@Prefijo			varchar(max),
@Nombre			varchar(max),
@Path			varchar(max),
@XMLNS			varchar(max),
@NodoPrincipalXML    	varchar(max),
@SQL			nvarchar(max),
@Resultado			varchar(max)
SET @Resultado2 = ''
IF @Nodo = '/' RETURN
IF @Nodo = '' RETURN
SET @XMLNS = dbo.fneDocInXmlns(CONVERT(varchar(max),@XML),0)
DECLARE crXMLNS CURSOR FOR
SELECT Prefijo, Nombre
FROM eDocInNSPrefijo
WHERE Estacion = @Estacion
ORDER BY ID
OPEN crXMLNS
FETCH NEXT FROM crXMLNS INTO @Prefijo, @Nombre
WHILE @@FETCH_STATUS = 0 AND NULLIF(@Resultado,'') IS  NULL
BEGIN
IF @Nodo <> '/'
SET @Path = @Nodo
SET @SQL = N'SET ANSI_NULLS ON ' +
N'SET ANSI_WARNINGS ON ' +
N'SET QUOTED_IDENTIFIER ON ' +
N'  SELECT  @Resultado = @xml.value(' + CHAR(39) + @XMLNS + 'local-name((//'+ISNULL(@Prefijo,'')+@Path+'/*)[1])' + CHAR(39) + ',' + CHAR(39) + 'varchar(max)' + CHAR(39) + ')'
EXEC sp_executesql @SQL, N'@XML xml, @Resultado varchar(max)  OUTPUT', @XML = @XML, @Resultado = @Resultado OUTPUT
IF NULLIF(@Resultado,'') IS NOT NULL
SELECT @Resultado2 = ISNULL(@Prefijo,'')+@Nodo
FETCH NEXT FROM crXMLNS INTO @Prefijo, @Nombre
END
CLOSE crXMLNS
DEALLOCATE crXMLNS
END

