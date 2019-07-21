SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroNivelTabla
@CrearTrigger	bit = 1,
@TodasTablas	bit = 0

AS BEGIN
SET NOCOUNT ON
DECLARE
@Tabla		varchar(50)
IF (SELECT SincroSSB FROM Version) = 1 RETURN
IF @CrearTrigger = 1 SELECT @CrearTrigger = Sincro FROM Version
DECLARE crTabla CURSOR FOR
SELECT RTRIM(s.SysTabla)
FROM SysTabla s
JOIN INFORMATION_SCHEMA.TABLES t ON t.TABLE_TYPE = 'BASE TABLE' AND t.TABLE_NAME = s.SysTabla
WHERE (@TodasTablas = 0 AND UPPER(s.Tipo) = 'MAESTRO') OR (@TodasTablas = 1 AND UPPER(s.Tipo) <> 'N/A')
OPEN crTabla
FETCH NEXT FROM crTabla INTO @Tabla
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC("if exists (select * from sysobjects where id = object_id('sincro"+@Tabla+"') and sysstat & 0xf = 8) drop trigger sincro"+@Tabla)
EXEC("if exists (select * from sysobjects where id = object_id('sincroT"+@Tabla+"') and sysstat & 0xf = 8) drop trigger sincroT"+@Tabla)
IF @CrearTrigger = 1
EXEC("CREATE TRIGGER sincroT"+@Tabla+" ON "+@Tabla+"  FOR INSERT, UPDATE, DELETE AS BEGIN   IF dbo.fnEstaSincronizando() = 1 RETURN  UPDATE SysTabla WITH (ROWLOCK) SET UltimoCambio = GETDATE() WHERE SysTabla = '"+@Tabla+"' END")
END
FETCH NEXT FROM crTabla INTO @Tabla
END
CLOSE crTabla
DEALLOCATE crTabla
END

