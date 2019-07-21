SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocXMLLimpiarAuto
@XML		xml OUTPUT,
@Path		varchar(max)

AS BEGIN
DECLARE
@Contador				int,
@CantidadElementos	int,
@SQL					nvarchar(max)
SET @SQL = N'SET ANSI_NULLS ON ' +
N'SET ANSI_WARNINGS ON ' +
N'SET QUOTED_IDENTIFIER ON ' +
N'DECLARE @Contador			int, ' +
N'        @CantidadElementos	int, ' +
N'        @NuevoPath			varchar(max),  ' +
N'        @PathElemento		varchar(max)   ' +
N'SET @CantidadElementos = @xml.query(' + CHAR(39) + 'count(' + ISNULL(@Path,'') + '*)' + CHAR(39) + ').value(' + CHAR(39) + '.' + CHAR(39) + ',' + CHAR(39) + 'int' + CHAR(39) + ') ' +
N'SELECT @Contador = @CantidadElementos ' +
N'WHILE @Contador > 0 ' +
N'BEGIN ' +
N'  SELECT  @NuevoPath = @Path + @xml.value(' + CHAR(39) + 'local-name((' + ISNULL(@Path,'') + '*[sql:variable("@Contador")])[1])' + CHAR(39) + ',' + CHAR(39) + 'varchar(max)' + CHAR(39) + ') + ' + CHAR(39) + '/' + CHAR(39) + ' ' +
N'  EXEC speDocXMLLimpiarAtributosAuto @XML OUTPUT, @NuevoPath ' +
N'  EXEC speDocXMLLimpiarAuto @XML OUTPUT, @NuevoPath ' +
N'  SELECT @PathElemento = SUBSTRING(@NuevoPath,1,LEN(@NuevoPath)-1) ' +
N'  EXEC speDocXMLEliminarElementoVacio @PathElemento, @XML OUTPUT ' +
N'  SET @Contador = @Contador - 1 ' +
N'END '
EXEC sp_executesql @SQL, N'@Path varchar(max), @XML xml OUTPUT', @Path = @Path, @XML = @XML OUTPUT
END

