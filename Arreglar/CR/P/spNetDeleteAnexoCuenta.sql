SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNetDeleteAnexoCuenta
@Rama			varchar(5)		= NULL,
@Cuenta		varchar(20)		= NULL,
@Documento		varchar(255)	= NULL,
@Ruta			varchar(255)	= NULL,
@Nombre		varchar(100)	= NULL
AS BEGIN
DECLARE
@Ok			int,
@OkRef			varchar(255),
@AnexoBase64	varchar(8)
SELECT @AnexoBase64 = SUBSTRING(CAST(Comentario as varchar(max)), charindex(',', CAST(Comentario as varchar(max)))+1, LEN(CAST(Comentario as varchar(max))))
FROM AnexoCta WHERE Rama = @Rama AND Cuenta = @Cuenta AND Nombre = @Nombre
DELETE FROM AnexoBase64 WHERE AnexoBase64 = @AnexoBase64
DELETE FROM AnexoCta WHERE Rama = @Rama AND Cuenta = @Cuenta AND Nombre = @Nombre
IF NOT EXISTS (SELECT 1 FROM AnexoCta WHERE Rama = @Rama AND Cuenta = @Cuenta AND Documento = @Documento)
BEGIN
IF ISNULL(@Rama,'') = 'NOM' SELECT @Rama = 'RH'
DELETE FROM DocCta WHERE Rama = @Rama AND Cuenta = @Cuenta AND Documento = @Documento
END
SELECT @Ok Ok, @OkRef OkRef
RETURN
END

