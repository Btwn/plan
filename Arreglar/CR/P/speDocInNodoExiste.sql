SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInNodoExiste
@XML		varchar(max),
@Path		varchar(max),
@Existe         bit =0 OUTPUT,
@Ok             int = NULL OUTPUT,
@OkRef          varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@SQL					nvarchar(max),
@XMLNS					nvarchar(max)
IF NULLIF(@OK,0) IS NULL AND NULLIF(CONVERT(varchar,@XML),'') IS NULL SELECT @Ok = 72340 ELSE
IF NULLIF(@OK,0) IS NULL AND NULLIF(CONVERT(varchar,@Path),'') IS NULL SELECT @Ok = 72350
SET @XMLNS = dbo.fneDocInXmlns(CONVERT(varchar(max),@XML),0)
SET @SQL = N'SET ANSI_NULLS ON ' +
N'SET ANSI_WARNINGS ON ' +
N'SET QUOTED_IDENTIFIER ON ' +
N'BEGIN TRY ' +
N'SET @Existe = @xml.exist(' + CHAR(39) + @XMLNS + ISNULL(@Path,'') +CHAR(39)+ ') ' +
N'END TRY ' +
N'BEGIN CATCH ' +
N'  SELECT @Ok = @@ERROR,  @OkRef = ERROR_MESSAGE() ' +
N'  IF XACT_STATE() = -1 ' +
N'  BEGIN ' +
N'    ROLLBACK TRAN ' +
N'    SET @OkRef = ' + CHAR(39) + N'Error  ' + CHAR(39) + N' + CONVERT(varchar,@Ok) + ' + CHAR(39) + N', ' + CHAR(39) + N' + @OkRef ' +
N'    RAISERROR(@OkRef,20,1) WITH LOG ' +
N'  END ' +
N'END CATCH '
BEGIN TRY
EXEC sp_executesql @SQL, N' @Path varchar(max), @XML xml, @Existe bit OUTPUT, @Ok   int OUTPUT, @OkRef varchar(255) OUTPUT', @XML = @XML, @Path = @Path, @Existe = @Existe OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END TRY
BEGIN CATCH
SELECT @Ok = @@ERROR,  @OkRef = ERROR_MESSAGE()
IF XACT_STATE() = -1
BEGIN
ROLLBACK TRAN
SET @OkRef = ' Error no existe el Nodo (' + CONVERT(varchar,@Ok) +') '+ @OkRef+'('+@Path+')'
RAISERROR(@OkRef,20,1) WITH LOG
END
END CATCH
IF @Ok IS NOT NULL
SET @OkRef = ' Error no existe el Nodo (' + CONVERT(varchar,@Ok) +') '+ @OkRef+'('+@Path+')'
END

