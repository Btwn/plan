SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInListarNodosXML
@Estacion	int,
@XML		xml,
@Path		varchar(max),
@Nodo		varchar(255)

AS BEGIN
DECLARE
@Contador			int,
@CantidadElementos		int,
@SQL					nvarchar(max),
@XMLNS					nvarchar(max)
SET @XMLNS = dbo.fneDocInXmlns(CONVERT(varchar(max),@XML),0)
SET @SQL = N'SET ANSI_NULLS ON ' +
N'SET ANSI_WARNINGS ON ' +
N'SET QUOTED_IDENTIFIER ON ' +
N'DECLARE @Contador			int, ' +
N'        @CantidadElementos	int, ' +
N'        @NuevoPath			varchar(max),  ' +
N'        @NuevoNodo			varchar(max),  ' +
N'        @PathElemento		varchar(max),  ' +
N'        @PathAtributo		varchar(max)   ' +
N'IF NOT EXISTS(SELECT 1 FROM eDocInNodoTemp WHERE Estacion = @Estacion AND ISNULL(Nodo,'''') = ISNULL(@Path,'''')) INSERT eDocInNodoTemp (Estacion, Nodo, NodoNombre) VALUES (@Estacion, @Path, @Nodo) ' +
N'SET @CantidadElementos = @xml.query(' + CHAR(39) + @XMLNS + 'count(' + ISNULL(@Path,'') + '*)' + CHAR(39) + ').value(' + CHAR(39) + '.' + CHAR(39) + ',' + CHAR(39) + 'int' + CHAR(39) + ') ' +
N'SELECT @Contador = @CantidadElementos ' +
N'WHILE @Contador > 0 ' +
N'BEGIN ' +
N'  SELECT  @PathElemento = @xml.value(' + CHAR(39) + @XMLNS + 'local-name((' + ISNULL(@Path,'') + '*[sql'+CHAR(58)+'variable("@Contador")])[1])' + CHAR(39) + ',' + CHAR(39) + 'varchar(max)' + CHAR(39) + ') ' +
N'  SELECT  @NuevoPath = @Path + @PathElemento + ''/'' ' +
N'  SELECT  @NuevoNodo = @Nodo + CASE WHEN @Nodo = '''' THEN '''' ELSE ''_'' END + @PathElemento ' +
N'  IF RTRIM(ISNULL(@PathElemento,'''')) <> '''' ' +
N'    EXEC speDocInListarNodosXML @Estacion, @XML, @NuevoPath, @NuevoNodo ' +
N'  SET @Contador = @Contador - 1 ' +
N'END '
EXEC sp_executesql @SQL, N'@Estacion int, @Path varchar(max), @XML xml, @Nodo varchar(255)', @Estacion = @Estacion, @Path = @Path, @XML = @XML, @Nodo = @Nodo
END

