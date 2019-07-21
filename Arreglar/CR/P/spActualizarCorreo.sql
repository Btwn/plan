SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spActualizarCorreo

AS BEGIN
DECLARE
@RID                       AS INT,
@ESTATUS    AS VARCHAR(50),
@mailitem_id as int
DECLARE ACTUALIZA_CURSOR CURSOR FOR
SELECT mailitem_id FROM CFDINominaRecibo where enviarMailSQL NOT IN('Enviado') AND mailitem_id!=NULL
OPEN ACTUALIZA_CURSOR
FETCH NEXT FROM ACTUALIZA_CURSOR
INTO @mailitem_id
WHILE (@@FETCH_STATUS = 0)
BEGIN
SELECT @Estatus=sent_status FROM msdb.dbo.sysmail_allitems where mailitem_id=@mailitem_id
SELECT @Estatus,@mailitem_id
IF ISNULL(@Estatus,'')<>''
UPDATE CFDINominaRecibo SET EnviarMailSql= CASE WHEN @Estatus='unsent' THEN 'Enviando' WHEN @Estatus='sent' THEN 'Enviado' WHEN @Estatus='failed' THEN 'Error' Else 'Reintentando' END ,  EnviarMail= CASE WHEN @Estatus='sent' THEN 1 WHEN @Estatus<>'sent' THEN 0 END WHERE mailitem_id=@mailitem_id
FETCH NEXT FROM ACTUALIZA_CURSOR
INTO @mailitem_id
END
CLOSE ACTUALIZA_CURSOR
DEALLOCATE ACTUALIZA_CURSOR
END

