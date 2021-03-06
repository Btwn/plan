SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInRutaNodos
@XML		    xml,
@Ruta               varchar(max)= NULL OUTPUT,
@Ok                 int = NULL OUTPUT,
@OkRef              varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@NodoPrincipalXML   varchar(100),
@SQL	       	nvarchar(max),
@XMLNS		nvarchar(max)
SET @Ruta = ''
SET @XMLNS = dbo.fneDocInXmlns(CONVERT(varchar(max),@XML),0)
SET @SQL = N'SET ANSI_NULLS ON ' +
N'SET ANSI_WARNINGS ON ' +
N'SET QUOTED_IDENTIFIER ON ' +
N'BEGIN TRY ' +
N'  SELECT  @NodoPrincipalXML = @xml.value(' + CHAR(39) + @XMLNS + 'local-name((/*/*/*)[1])' + CHAR(39) + ',' + CHAR(39) + 'varchar(max)' + CHAR(39) + ')' +
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
EXEC sp_executesql @SQL, N'@XML xml, @NodoPrincipalXML varchar(255)  OUTPUT,  @Ok   int OUTPUT, @OkRef varchar(255) OUTPUT', @XML = @XML, @NodoPrincipalXML = @NodoPrincipalXML OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END TRY
BEGIN CATCH
SELECT @Ok = @@ERROR,  @OkRef = ERROR_MESSAGE()
IF XACT_STATE() = -1
BEGIN
ROLLBACK TRAN
SET @OkRef = ' Error Nodo ' + @NodoPrincipalXML+' '+ CONVERT(varchar,@Ok) + @OkRef
RAISERROR(@OkRef,20,1) WITH LOG
END
END CATCH
IF @OK IS NOT NULL
SET @OkRef = ' Error Nodo ' + @NodoPrincipalXML+' (' + CONVERT(varchar,@Ok) +') '+@OkRef
SELECT @Ruta = ''+@NodoPrincipalXML
END

