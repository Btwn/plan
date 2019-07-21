SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInDentroTabla
@XML		    varchar(max),
@Path               varchar(max),
@Tabla              varchar(255),
@Existe             bit = 0 OUTPUT,
@Ok                 int = NULL OUTPUT,
@OkRef              varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Valor              varchar(255),
@SQL	       	nvarchar(max),
@SQL2	       	nvarchar(max),
@XMLNS		nvarchar(max)
SET @Existe = 0
IF NULLIF(@OK,0) IS NULL AND NULLIF(CONVERT(varchar,@XML),'') IS NULL SELECT @Ok = 72340 ELSE
IF NULLIF(@OK,0) IS NULL AND NULLIF(CONVERT(varchar,@Path),'') IS NULL SELECT @Ok = 72350 ELSE
IF NULLIF(@OK,0) IS NULL AND NULLIF(CONVERT(varchar,@Tabla),'') IS NULL SELECT @Ok = 72330
SET @XMLNS = dbo.fneDocInXmlns(CONVERT(varchar(max),@XML),0)
SET @SQL = N'SET ANSI_NULLS ON ' +
N'SET ANSI_WARNINGS ON ' +
N'SET QUOTED_IDENTIFIER ON ' +
N'BEGIN TRY ' +
N'  SELECT  @Valor = @xml.value(' + CHAR(39) + @XMLNS +'('+ @Path +')[1]'  + CHAR(39)+ ',' + CHAR(39) + 'varchar(max)' + CHAR(39) + ')' +
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
EXEC sp_executesql @SQL, N'@XML xml, @Valor  varchar(255)  OUTPUT, @Ok   int OUTPUT, @OkRef varchar(255) OUTPUT',@XML = @XML, @Valor  = @Valor  OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END TRY
BEGIN CATCH
SELECT @Ok = @@ERROR,  @OkRef = ERROR_MESSAGE()
IF XACT_STATE() = -1
BEGIN
ROLLBACK TRAN
SET @OkRef = ' Error  al verificar la tabla TablaValorD' + CONVERT(varchar,@Ok) + @OkRef+'('+@Tabla+')'
RAISERROR(@OkRef,20,1) WITH LOG
END
END CATCH
IF @OK IS NOT NULL
SET @OkRef = ' Error  al verificar la tabla TablaValorD (' + CONVERT(varchar,@Ok) +') '+@OkRef+'('+@Tabla+')'
SET @SQL2 = N'IF EXISTS(SELECT  * FROM TablaValorD WHERE TablaValor = ' + CHAR(39) + @Tabla + CHAR(39) + ' AND Valor = ' + CHAR(39) + ISNULL(@Valor,'') + CHAR(39) + ')
SELECT @Existe = 1 ELSE  SELECT @Existe = 0'
IF @Ok IS NULL
BEGIN TRY
EXEC sp_executesql @SQL2, N'@Existe  bit  OUTPUT', @Existe  = @Existe  OUTPUT
END TRY
BEGIN CATCH
SELECT @Ok = @@ERROR,  @OkRef = ERROR_MESSAGE()
IF XACT_STATE() = -1
BEGIN
ROLLBACK TRAN
SET @OkRef = ' Error  al verificar la tabla TablaValorD' + CONVERT(varchar,@Ok) + @OkRef
RAISERROR(@OkRef,20,1) WITH LOG
END
END CATCH
IF @OK IS NOT NULL
SET @OkRef = ' Error  al verificar la tabla TablaValorD(' + CONVERT(varchar,@Ok) +') ' + @OkRef+'('+@Tabla+')'
END

