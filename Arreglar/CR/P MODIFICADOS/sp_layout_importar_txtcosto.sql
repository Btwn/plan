SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sp_layout_importar_txtcosto
@usuario						varchar(20),
@archivo						varchar(255)

AS BEGIN
DECLARE
@cmd				varchar(8000),
@with				varchar(255)
SELECT @usuario = UPPER(@usuario),
@archivo = NULLIF(RTRIM(@archivo), '')
SELECT @with = 'CODEPAGE = ''RAW'', FIELDTERMINATOR = ''|'', FIRSTROW = 1'
IF @archivo IS NOT NULL
BEGIN
TRUNCATE TABLE Layout_CostoMovs
SET @cmd = 'BULK INSERT Layout_CostoMovs FROM '''+@archivo+''' WITH ('+@with+')'
EXEC(@cmd)
END
RETURN
END

