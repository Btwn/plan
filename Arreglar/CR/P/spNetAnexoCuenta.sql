SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNetAnexoCuenta
@Rama		varchar(5)		= NULL,
@Cuenta	varchar(20)		= NULL,
@Documento	varchar(255)	= NULL,
@Ruta		varchar(255)	= NULL,
@Nombre	varchar(100)	= NULL,
@Extension	varchar(5)		= NULL,
@MimeType	varchar(100)	= NULL,
@Size		int				= NULL,
@Archivo	varchar(max)	= NULL
AS BEGIN
DECLARE
@strChars		varchar(62),
@AnexoBase64	varchar(8),
@index		int,
@cont			int,
@IDBase64		int,
@Ok		    int,
@OkRef		varchar(255),
@icono		int,
@Tipo			varchar(10),
@Comentario	varchar(max)
SET @strChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
SET @AnexoBase64 = ''
SET @cont = 0
WHILE @cont < 8
BEGIN
SET @index = ceiling((SELECT RAND()) * (len(@strChars)))
SET @AnexoBase64 = @AnexoBase64 + substring(@strChars, @index, 1)
SET @cont = @cont + 1
END
IF (LOWER(@Extension) IN  ('png', 'jpg', 'bmp', 'gif'))
SELECT @icono = 59, @Tipo = 'Imagen'
IF (LOWER(@Extension) IN  ('pdf'))
SELECT @icono = 745, @Tipo = 'Archivo'
IF (LOWER(@Extension) IN  ('doc', 'docx'))
SELECT @icono = 738, @Tipo = 'Archivo'
IF (LOWER(@Extension) IN  ('xls', 'xlsx'))
SELECT @icono = 733, @Tipo = 'Archivo'
IF (LOWER(@Extension) IN  ('ppt', 'pptx'))
SELECT @icono = 1, @Tipo = 'Archivo'
IF NOT EXISTS(SELECT * FROM AnexoBase64 WHERE AnexoBase64 = @AnexoBase64)
BEGIN
INSERT INTO AnexoBase64 (AnexoBase64, Archivo) SELECT @AnexoBase64, @Archivo
SELECT @IDBase64 = SCOPE_IDENTITY()
END
IF @IDBase64 IS NOT NULL
BEGIN
SELECT @Comentario = CONVERT(varchar(max),@IDBase64)+','+@AnexoBase64
INSERT INTO AnexoCta(Rama, Cuenta,  Nombre,  Direccion, Documento, Alta,      UltimoCambio, Comentario,	Icono, Tipo)
SELECT @Rama, @Cuenta, @Nombre, @Ruta,     @Documento, GETDATE(), GETDATE(),    @Comentario, @icono, @Tipo
END
ELSE
INSERT INTO AnexoCta(Rama, Cuenta,  Nombre,  Direccion, Documento, Alta,      UltimoCambio, Icono, Tipo)
SELECT @Rama, @Cuenta, @Nombre, @Ruta,     @Documento, GETDATE(), GETDATE(),   @icono, @Tipo
IF ISNULL(@Rama,'') = 'NOM' SELECT @Rama = 'RH'
IF ISNULL(@Documento,'') <> '' AND NOT EXISTS (SELECT 1 FROM DocCta WHERE Rama = @Rama AND Cuenta = @Cuenta AND Documento = @Documento)
BEGIN
INSERT INTO DocCta(Rama, Cuenta, Documento) SELECT @Rama, @Cuenta, @Documento
END
SELECT @Ok Ok, @OkRef OkRef
RETURN
END

