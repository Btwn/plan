SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroNivelRegistro
@CrearTrigger	bit = 1,
@VerTabla	bit = 0,
@Tabla		varchar(50) = NULL

AS BEGIN
SET NOCOUNT ON
DECLARE
@Llave 	varchar(255)
IF (SELECT SincroSSB FROM Version) = 1 OR (SELECT ModuloCentral FROM Version) = 1 RETURN
IF @CrearTrigger = 1 SELECT @CrearTrigger = Sincro FROM Version
DECLARE crTabla CURSOR FOR
SELECT RTRIM(s.SysTabla)
FROM SysTabla s, INFORMATION_SCHEMA.TABLES t
WHERE (UPPER(s.Tipo) LIKE 'CUENTA%' OR UPPER(s.Tipo) LIKE 'MOVIMIENTO%' OR UPPER(s.Tipo) LIKE 'SALDO%')
AND t.TABLE_TYPE = 'BASE TABLE' AND t.TABLE_NAME = s.SysTabla
AND s.SysTabla = ISNULL(@Tabla, s.SysTabla)
OPEN crTabla
FETCH NEXT FROM crTabla INTO @Tabla
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spSincroNivelRegistroCampos @Tabla
EXEC("if exists (select * from sysobjects where id = object_id('sincro"+@Tabla+"') and sysstat & 0xf = 8) drop trigger sincro"+@Tabla)
EXEC("if exists (select * from sysobjects where id = object_id('sincroR"+@Tabla+"') and sysstat & 0xf = 8) drop trigger sincroR"+@Tabla)
END
FETCH NEXT FROM crTabla INTO @Tabla
END
CLOSE crTabla
DEALLOCATE crTabla
END

