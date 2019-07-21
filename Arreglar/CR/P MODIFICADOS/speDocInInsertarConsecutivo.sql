SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInInsertarConsecutivo
@XML				xml OUTPUT,
@Path				varchar(max),
@ConsecutivoNombre		varchar(255),
@ConsecutivoInicial		int,
@ConsecutivoIncremento	        int,
@Ok				int = NULL OUTPUT,
@OkRef				varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@CantidadElementos		int,
@SQL					nvarchar(max),
@Path2					varchar(max),
@UltimoCaracter			char(1),
@Contador				int,
@Error					int,
@ErrorRef				varchar(255),
@XMLNS					nvarchar(max)
SELECT @Error = NULL, @ErrorRef = NULL
SET @UltimoCaracter = SUBSTRING(@Path,LEN(@Path),1)
IF  @UltimoCaracter = '/'
BEGIN
SET @Path2 = SUBSTRING(@Path,1,LEN(@Path)-1)
END
ELSE IF @UltimoCaracter <> '/'
BEGIN
SET @Path2 = @Path
SET @Path = @Path + '/'
END
SET @XMLNS = dbo.fneDocInXmlns(CONVERT(varchar(max),@XML),0)
SET @SQL = N'SET ANSI_NULLS ON ' +
N'SET ANSI_WARNINGS ON ' +
N'SET QUOTED_IDENTIFIER ON ' +
N'BEGIN TRY ' +
N'  SET @CantidadElementos = @xml.query(' + CHAR(39) + @XMLNS + '  count(' + ISNULL(@Path,'') + '/.)' + CHAR(39) + ').value(' + CHAR(39) + '.' + CHAR(39) + ',' + CHAR(39) + 'int' + CHAR(39) + ') ' +
N'END TRY ' +
N'BEGIN CATCH ' +
N'  SELECT @Error = @@ERROR,  @ErrorRef = ERROR_MESSAGE() ' +
N'  IF XACT_STATE() = -1 ' +
N'  BEGIN ' +
N'    ROLLBACK TRAN ' +
N'    SET @ErrorRef = ' + CHAR(39) + N'Error '+ CHAR(39) + N' + CONVERT(varchar,@Error) + ' + CHAR(39) + N', ' + CHAR(39) + N' + @ErrorRef ' +
N'    RAISERROR(@ErrorRef,20,1) WITH LOG ' +
N'  END ' +
N'END CATCH '
EXEC sp_executesql @SQL, N'@XML xml, @CantidadElementos int OUTPUT, @Error int OUTPUT, @ErrorRef varchar(255) OUTPUT', @XML = @XML, @CantidadElementos = @CantidadElementos OUTPUT, @Error = @Error OUTPUT, @ErrorRef = @ErrorRef OUTPUT
IF @Error IS NOT NULL SELECT @Ok = 72310, @OkRef = 'Error al insertar consecutivo '+@Path+' '+CONVERT(varchar,@Error) + '. ' + SUBSTRING(ISNULL(@ErrorRef,''),1,200)
IF @Ok IS NULL AND @CantidadElementos > 0
BEGIN
SET @SQL = N'SET ANSI_NULLS ON ' +
N'SET ANSI_WARNINGS ON ' +
N'SET QUOTED_IDENTIFIER ON ' +
N'BEGIN TRY '
SET @Contador = 1
WHILE @Contador <= @CantidadElementos
BEGIN
SET @SQL = @SQL + N'SET @XML.modify(' + CHAR(39) + @XMLNS + ' insert attribute ' + ISNULL(@ConsecutivoNombre,'') + ' {' + RTRIM(LTRIM(CONVERT(varchar,ISNULL(@ConsecutivoInicial,1)))) + '} into (' + ISNULL(@Path2,'') + ')[' + RTRIM(LTRIM(CONVERT(varchar,@Contador))) + ']' + CHAR(39) + ') '
SET @ConsecutivoInicial = @ConsecutivoInicial + @ConsecutivoIncremento
SET @Contador = @Contador + 1
END
SET @SQL = @SQL +
N'END TRY ' +
N'BEGIN CATCH ' +
N'  SELECT @Error = @@ERROR,  @ErrorRef = ERROR_MESSAGE() ' +
N'  IF XACT_STATE() = -1 ' +
N'  BEGIN ' +
N'    ROLLBACK TRAN ' +
N'    SET @ErrorRef = ' + CHAR(39) + N'Error  ' +CHAR(39) + N' + CONVERT(varchar,@Error) + ' + CHAR(39) + N', ' + CHAR(39) + N' + @ErrorRef ' +
N'    RAISERROR(@ErrorRef,20,1) WITH LOG ' +
N'  END ' +
N'END CATCH '
EXEC sp_executesql @SQL, N'@XML xml OUTPUT, @Error int OUTPUT, @ErrorRef varchar(255) OUTPUT', @XML = @XML OUTPUT, @Error = @Error OUTPUT, @ErrorRef = @ErrorRef OUTPUT
IF @Error IS NOT NULL SELECT @Ok = 72310, @OkRef = 'Error al insertar consecutivo '+@Path+' '+CONVERT(varchar,@Error) + '. ' + SUBSTRING(ISNULL(@ErrorRef,''),1,200)
END
END

