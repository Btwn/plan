SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocXMLEliminarAtributoVacio
@Path		varchar(max),
@Atributo	varchar(max),
@XML		xml OUTPUT

AS BEGIN
DECLARE
@SQL			nvarchar(max)
SET @SQL = N'SET ANSI_NULLS ON ' +
N'SET ANSI_WARNINGS ON ' +
N'SET QUOTED_IDENTIFIER ON ' +
'SET @XML.modify(' + CHAR(39) + 'delete ' + @Path + '[@' + @Atributo + '=""]/@' + @Atributo + CHAR(39) + ') '
EXEC sp_executesql @SQL, N'@Path varchar(max), @Atributo varchar(max), @XML xml OUTPUT', @Path = @Path, @Atributo = @Atributo, @XML = @XML OUTPUT
END

