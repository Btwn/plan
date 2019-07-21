SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spWriteStringToFile
(
@String Varchar(max),
@Path VARCHAR(255),
@Filename VARCHAR(100)
)

AS
BEGIN
DECLARE @objFileSystem   int,
@objTextStream   int,
@objErrorObject  int,
@strErrorMessage Varchar(1000),
@Command         varchar(1000),
@hr              int,
@fileAndPath     varchar(80)
SET NOCOUNT ON
SELECT  @strErrorMessage = 'opening the File System Object'
EXECUTE @HR = sp_OACreate 'Scripting.FileSystemObject', @objFileSystem OUT
SELECT @FileAndPath = @path + '\' + @filename
IF @HR=0
SELECT @objErrorObject = @objFileSystem, @strErrorMessage = 'Creating file "' + @FileAndPath + '"'
IF @HR=0
EXECUTE @HR = sp_OAMethod @objFileSystem, 'CreateTextFile', @objTextStream OUT, @FileAndPath, 2, False
IF @HR=0
SELECT @objErrorObject = @objTextStream, @strErrorMessage = 'writing to the file "' + @FileAndPath + '"'
IF @HR=0
EXECUTE @HR = sp_OAMethod @objTextStream, 'Write', Null, @String
IF @HR=0
SELECT @objErrorObject = @objTextStream, @strErrorMessage = 'closing the file "' + @FileAndPath + '"'
IF @HR=0
EXECUTE @HR = sp_OAMethod @objTextStream, 'Close'
IF @HR<>0
BEGIN
DECLARE @Source      Varchar(255),
@Description Varchar(255),
@Helpfile    Varchar(255),
@HelpID      int
EXECUTE sp_OAGetErrorInfo @objErrorObject, @source output,@Description output,@Helpfile output,@HelpID output
SELECT @strErrorMessage='Error whilst ' + coalesce(@strErrorMessage,'doing something') + ', ' + coalesce(@Description,'')
RAISERROR(@strErrorMessage,16,1)
END
EXECUTE sp_OADestroy @objTextStream
SET NOCOUNT OFF
END

