SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincronizarCRM
@Tabla			varchar(20) = NULL,
@valor			varchar(2)

AS BEGIN
DECLARE
@Query						varchar(max),
@ValorSincronizar			varchar(2),
@GUI						uniqueidentifier,
@prospectoID				varchar(20),
@cteID						varchar(20),
@ID							varchar(20)
IF RTRIM(LTRIM(UPPER(@Valor))) = 'S'
SET @ValorSincronizar = '1'
ELSE
IF RTRIM(LTRIM(UPPER(@Valor))) = 'N'
SET @ValorSincronizar = '0'
IF RTRIM(LTRIM(UPPER(@Tabla))) = 'PROSPECTO'
SET @ID = 'prospecto'
ELSE
IF RTRIM(LTRIM(UPPER(@Tabla))) = 'CTE'
SET @ID = 'cliente'
SET @Query= '
DECLARE
@IDcur	varchar(20),
@GUI		uniqueidentifier,
@Sincro	bit,
@Tmp		varchar(30),
@vquery	varchar(max)
SET @vquery=''''
DECLARE crSincronizarCRM CURSOR FOR
SELECT SincronizarCRM, CRMID, ' +  @ID  + ' FROM  ' + @Tabla + ' WHERE Estatus=''ALTA'' AND SincronizarCRM <> ' + @ValorSincronizar +
' OPEN crSincronizarCRM
FETCH NEXT FROM crSincronizarCRM INTO @Sincro, @GUI, @IDcur
WHILE @@FETCH_STATUS = 0
BEGIN
SET @Tmp = ''CRMID = CRMID''
IF RTRIM(LTRIM(UPPER(''' + @valor + '''))) = ''S''
BEGIN
IF @GUI IS NULL
UPDATE ' + @Tabla + ' SET SincronizarCRM = ' + @ValorSincronizar  + ', CRMID = NEWID() WHERE ' + @ID + ' = @IDcur' +
' ELSE
UPDATE ' + @Tabla + ' SET SincronizarCRM = ' + @ValorSincronizar  + ' WHERE ' + @ID + ' = @IDcur' +
' END
ELSE
UPDATE ' + @Tabla + ' SET SincronizarCRM = ' + @ValorSincronizar  + ' WHERE ' + @ID + ' = @IDcur' +
' FETCH NEXT FROM crSincronizarCRM INTO @Sincro,@GUI,@IDcur
END
CLOSE crSincronizarCRM
DEALLOCATE crSincronizarCRM'
EXEC (@Query)
RETURN
END

