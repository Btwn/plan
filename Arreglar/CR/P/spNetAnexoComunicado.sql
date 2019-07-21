SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNetAnexoComunicado
@ID	INT,
@Nombre VARCHAR(100),
@Extension VARCHAR(5),
@MimeType VARCHAR(100),
@Size INT,
@Archivo	VARCHAR(MAX)
AS
BEGIN
SET NOCOUNT ON
DECLARE @strChars		AS VARCHAR(62),
@AnexoBase64	AS VARCHAR(8),
@index			AS INT,
@cont			AS INT,
@IDb64			AS INT,
@Ok				AS INT,
@OkRef			AS varchar(max)
SET @strChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
SET @AnexoBase64 = ''
SET @cont = 0
WHILE @cont < 8
BEGIN
SET @index = ceiling((SELECT RAND()) * (len(@strChars)))
SET @AnexoBase64 = @AnexoBase64 + substring(@strChars, @index, 1)
SET @cont = @cont + 1
END
IF (NULLIF(@AnexoBase64,'') IS NULL OR LEN(@AnexoBase64) <> 8)
BEGIN
RAISERROR ('Error al generar identificador de anexo', 18, 1)
RETURN
END
IF (NULLIF(@Archivo,'') IS NULL OR LEN(@Archivo) < 30)
BEGIN
RAISERROR ('Error al cargar anexo', 18, 1)
RETURN
END
BEGIN TRY
IF  NOT EXISTS(SELECT * FROM AnexoBase64 WHERE AnexoBase64 = @AnexoBase64) AND EXISTS(SELECT * FROM pNetComunicado WHERE IDComunicado = @ID)
BEGIN
INSERT INTO pNetAnexoComunicado (IDComunicado,AnexoBase64,Nombre,Extension,MimeType,Size)
VALUES (@ID, @AnexoBase64,@Nombre,@Extension,@MimeType,@Size)
INSERT INTO AnexoBase64 (AnexoBase64, Archivo)
VALUES (@AnexoBase64, @Archivo)
SELECT @IDb64 = SCOPE_IDENTITY()
END
IF (@@rowcount <> 1)
BEGIN
SET @OK = 1
SET @OkRef = 'Error al generar el registro'
END
END TRY
BEGIN CATCH
SET @OK = 1
SET @OkRef = ERROR_MESSAGE()
END CATCH
SELECT @Ok Ok, @OkRef OkRef
SET NOCOUNT OFF
END

