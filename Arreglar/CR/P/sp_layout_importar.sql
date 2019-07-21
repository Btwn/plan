SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sp_layout_importar
@usuario						varchar(20),
@tipo						varchar(50),	
@archivo						varchar(255)

AS BEGIN
DECLARE
@cmd				varchar(8000),
@with				varchar(255)
SELECT @usuario = UPPER(@usuario),
@tipo    = LOWER(@tipo),
@archivo = NULLIF(RTRIM(@archivo), '')
SELECT @with = 'CODEPAGE = ''RAW'', FIELDTERMINATOR = ''\t'', FIRSTROW = 2'
IF @archivo IS NOT NULL
BEGIN
IF @tipo = 'documentos'
BEGIN
TRUNCATE TABLE layout_documentos
SET @cmd = 'BULK INSERT layout_documentos FROM '''+@archivo+''' WITH ('+@with+')'
EXEC(@cmd)
EXEC sp_layout_importar_documentos @usuario
END ELSE
IF @tipo = 'aplicaciones'
BEGIN
TRUNCATE TABLE layout_aplicaciones
SET @cmd = 'BULK INSERT layout_aplicaciones FROM '''+@archivo+''' WITH ('+@with+')'
EXEC(@cmd)
EXEC sp_layout_importar_aplicaciones @usuario
END ELSE
IF @tipo = 'polizas'
BEGIN
TRUNCATE TABLE layout_polizas
SET @cmd = 'BULK INSERT layout_polizas FROM '''+@archivo+''' WITH ('+@with+')'
EXEC(@cmd)
EXEC sp_layout_importar_polizas @usuario
END ELSE
IF @tipo = 'cuentas'
BEGIN
TRUNCATE TABLE layout_cuentas
SET @cmd = 'BULK INSERT layout_cuentas FROM '''+@archivo+''' WITH ('+@with+')'
EXEC(@cmd)
EXEC sp_layout_importar_cuentas @usuario
END
END
RETURN
END

