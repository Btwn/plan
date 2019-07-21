SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInListarAtributosXML
@Estacion	int,
@XML		xml,
@Path		varchar(max),
@Nodo		varchar(255)

AS BEGIN
DECLARE
@Contador				int,
@CantidadElementos		int,
@SQL					nvarchar(max),
@XMLNS					nvarchar(max)
IF @Path = '/' RETURN
SET @XMLNS = dbo.fneDocInXmlns(CONVERT(varchar(max),@XML),0)
SET @SQL = N'SET ANSI_NULLS ON ' +
N'SET ANSI_WARNINGS ON ' +
N'SET QUOTED_IDENTIFIER ON ' +
N'DECLARE @Contador			int, ' +
N'        @CantidadAtributos	int, ' +
N'        @PathAtributo		varchar(max),  ' +
N'        @Nombre				varchar(max)   ' +
N'SET @CantidadAtributos = @xml.query(' + CHAR(39) + @XMLNS + 'count(' + ISNULL(@Path,'') + '@*)' + CHAR(39) + ').value(' + CHAR(39) + '.' + CHAR(39) + ',' + CHAR(39) + 'int' + CHAR(39) + ') ' +
N'SELECT @Contador = @CantidadAtributos ' +
N'WHILE @Contador > 0 ' +
N'BEGIN ' +
N'  SELECT  @PathAtributo = @xml.value(' + CHAR(39) + @XMLNS + 'local-name((' + ISNULL(@Path,'') + '@*[sql'+CHAR(58)+'variable("@Contador")])[1])' + CHAR(39) + ',' + CHAR(39) + 'varchar(max)' + CHAR(39) + ') ' +
N'  SELECT  @Nombre = @Nodo + ''_'' + @PathAtributo ' +
N'IF RTRIM(ISNULL(@PathAtributo,'''')) <> '''' AND NOT EXISTS(SELECT 1 FROM eDocInAtributoTemp WHERE Estacion = @Estacion AND ISNULL(AtributoRuta,'''') = ISNULL(@Path,'''') AND ISNULL(AtributoNombre,'''') = ISNULL(@PathAtributo,'''')) INSERT eDocInAtributoTemp (Estacion, AtributoRuta, AtributoNombre, Campo, Nodo) VALUES (@Estacion, @Path, @PathAtributo, @Nombre, @Nodo) ' +
N'  SET @Contador = @Contador - 1 ' +
N'END '
EXEC sp_executesql @SQL, N'@Estacion int, @Path varchar(max), @XML xml, @Nodo varchar(255)', @Estacion = @Estacion, @Path = @Path, @XML = @XML, @Nodo = @Nodo
END

