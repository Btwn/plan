SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spReenviarReciboNomina
@Empresa     varchar(5),
@ID			int = NULL,
@Estacion		varchar(5)

AS BEGIN
DECLARE
@Anexos				varchar(100),
@EnviarXML			bit,
@process_id			int,
@mailitem_id		float,
@RID				float,
@Personal			varchar(100),
@Shell				varchar(100)
SET @Anexos = 0
SET @EnviarXML = 0
SET @Shell ='TASKKILL /F /IM DatabaseMail.exe'
EXEC xp_cmdshell @Shell
DECLARE crProcesos CURSOR FOR
SELECT   process_id FROM  CFDINominaRecibo cr INNER JOIN msdb.dbo.sysmail_event_log sl ON sl.mailitem_id= cr.mailitem_id
WHERE id =@ID AND event_type IN ('error','information') GROUP BY   process_id
OPEN crProcesos
FETCH NEXT FROM crProcesos INTO @process_id
WHILE @@FETCH_STATUS = 0
BEGIN
DECLARE crReenviarCorreo CURSOR FOR
SELECT  DISTINCT RID,Personal FROM CFDINominaRecibo cr
INNER JOIN msdb.dbo.sysmail_event_log sl on sl.mailitem_id= cr.mailitem_id
WHERE process_id =@process_id and event_type ='error'
OPEN crReenviarCorreo
FETCH NEXT FROM crReenviarCorreo INTO  @RID,@Personal
WHILE @@FETCH_STATUS = 0
BEGIN
EXEC spEnviarReciboNomina @Empresa,@RID,@Personal,@Estacion
FETCH NEXT FROM crReenviarCorreo INTO  @RID,@Personal
END
CLOSE crReenviarCorreo
DEALLOCATE crReenviarCorreo
FETCH NEXT FROM crProcesos INTO @process_id
END
CLOSE crProcesos
DEALLOCATE crProcesos
SELECT ''
RETURN
END

