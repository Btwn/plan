SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER procedure dbo.spAPIArtAnexo
@Cuenta		varchar(max),
@IDR		varchar(max),
@name		varchar(max),
@extension	varchar(max),
@mimeType	varchar(max),
@Usuario	varchar(max)
AS BEGIN
DECLARE @NomArch	varchar(255),
@finalPath	varchar(MAX),
@finalName	varchar(255),
@Tipo		varchar(10),
@icono	    int,
@maxOrder	int
SET @finalPath = 'C:\Temp\'
SET @NomArch = @finalPath + @name
SET @finalName = LEFT(REPLACE(@name, @extension, ''), LEN(REPLACE(@name, @extension, ''))-1)
IF (LOWER(@extension) IN  ('png', 'jpg', 'bmp', 'gif'))
SELECT @icono = 59, @Tipo = 'Imagen'
IF (LOWER(@extension) IN  ('pdf'))
SELECT @icono = 745, @Tipo = 'Archivo'
IF (LOWER(@extension) IN  ('doc', 'docx'))
SELECT @icono = 738, @Tipo = 'Archivo'
IF (LOWER(@extension) IN  ('xls', 'xlsx'))
SELECT @icono = 733, @Tipo = 'Archivo'
SELECT @maxOrder = MAX(Orden) FROM AnexoCta WITH(NOLOCK) WHERE Rama = 'INV' AND Cuenta = @Cuenta
SET @maxOrder = ISNULL(@maxOrder, 0);
SET @maxOrder = @maxOrder + 1
SELECT * FROM AnexoCta WITH(NOLOCK) WHERE Rama = 'INV' AND Cuenta = @Cuenta
SELECT 'INV', @Cuenta,	@IDR,	@finalName,	@Tipo,	@NomArch,	@icono,	@maxOrder,	GETDATE(),	GETDATE(),		@Usuario
SELECT '' Ok, '' OkRef
RETURN
END

