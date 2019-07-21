SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISActivarTabla
@Tabla		varchar(100),
@Activar	bit = 1

AS BEGIN
DECLARE
@SQL				varchar(max),
@Trigger			varchar(100),
@CampoIdentity		varchar(100)
/* Eliminar Sincro Anterior */
SELECT @SQL = 'spDROP_TRIGGER ''sincro'+@Tabla+''''
EXEC (@SQL)
SELECT @SQL = 'spDROP_TRIGGER ''sincroT'+@Tabla+''''
EXEC (@SQL)
SELECT @SQL = 'spDROP_TRIGGER ''sincroR'+@Tabla+''''
EXEC (@SQL)
SELECT @SQL = 'spDROP_TRIGGER ''tg'+@Tabla+'SincroSSB_AC'''
EXEC (@SQL)
SELECT @SQL = 'spDROP_TRIGGER ''tg'+@Tabla+'SincroSSB_B'''
EXEC (@SQL)
IF @Activar = 1
BEGIN
EXEC spALTER_TABLE @Tabla, 'SincroID', 'timestamp NULL'
EXEC spADD_INDEX @Tabla, 'Sincro', 'SincroID'
EXEC spALTER_TABLE @Tabla, 'SincroGUID', 'uniqueidentifier NOT NULL DEFAULT NEWID() WITH VALUES'
EXEC spADD_INDEX @Tabla, 'SincroGUID', 'SincroGUID'
END
SELECT @Trigger = 'dbo.tg'+@Tabla+'SincroIS'
SELECT @SQL = 'spDROP_TRIGGER '''+@Trigger+'_AC'''
EXEC (@SQL)
SELECT @SQL = 'spDROP_TRIGGER '''+@Trigger+'_B'''
EXEC (@SQL)
IF @Activar = 1
BEGIN
SELECT @SQL =
'CREATE TRIGGER '+@Trigger+'_AC ON '+@Tabla+'

FOR INSERT, UPDATE
AS BEGIN
SET ANSI_NULLS OFF
DECLARE
@SincroIDMax		binary(8),
@SincroIDTabla	binary(8)
IF dbo.fnEstaSincronizando() = 1 RETURN
IF (SELECT SincroIS FROM Version) = 1
BEGIN
SELECT @SincroIDMax = MAX(SincroID) FROM ' + CASE WHEN @Tabla = 'IDRemoto' THEN 'SincroISIDRemotoControl' ELSE 'SincroISControl ' END + '
SELECT @SincroIDTabla = SincroID FROM SysTabla WHERE SysTabla = '''+@Tabla+'''
IF @SincroIDTabla < @SincroIDMax
UPDATE SysTabla WITH (ROWLOCK) SET UltimoCambio = GETDATE() WHERE SysTabla = '''+@Tabla+'''
END
END'
EXEC (@SQL)
EXEC spSincroISTablaEstructura @Tabla, @CampoIdentity = @CampoIdentity OUTPUT
IF @CampoIdentity IS NOT NULL
SET @CampoIdentity = CHAR(44) + CHAR(32) + @CampoIdentity
ELSE
SET @CampoIdentity = ''
SELECT @SQL =
'CREATE TRIGGER '+@Trigger+'_B ON '+@Tabla+'

FOR DELETE
AS BEGIN
DECLARE
@SincroIDMax		binary(8),
@SincroIDTabla	binary(8)
IF dbo.fnEstaSincronizando() = 1 RETURN
IF (SELECT SincroIS FROM Version) = 1
BEGIN
SELECT @SincroIDMax = MAX(SincroID) FROM ' + CASE WHEN @Tabla = 'IDRemoto' THEN 'SincroISIDRemotoControl' ELSE 'SincroISControl ' END + '
SELECT @SincroIDTabla = SincroID FROM SysTabla WHERE SysTabla = '''+@Tabla+'''
IF @SincroIDTabla < @SincroIDMax
UPDATE SysTabla WITH (ROWLOCK) SET UltimoCambio = GETDATE() WHERE SysTabla = '''+@Tabla+'''
DECLARE @Llave xml
SELECT @Llave = (SELECT SincroGUID ' + @CampoIdentity + ' FROM DELETED FOR XML RAW(''Llave''))
EXEC spSincroISBaja '''+@Tabla+''', @Llave
END
END'
BEGIN TRY
EXEC (@SQL)
END TRY
BEGIN CATCH
SELECT @SQL = 'Error al Creare el Trigger '+@Trigger+' en la Tabla '+@Tabla
RAISERROR (@SQL,16,-1)
END CATCH
END
RETURN
END

