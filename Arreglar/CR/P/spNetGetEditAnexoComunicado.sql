SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNetGetEditAnexoComunicado
@ID	INT
AS
BEGIN
SET NOCOUNT ON
DECLARE @strChars		AS VARCHAR(62),
@AnexoBase64	AS VARCHAR(8),
@index			AS INT,
@cont			AS INT,
@IDb64			AS INT,
@Ok				AS INT,
@OkRef			AS varchar(max),
@urlApi			varchar(255)
BEGIN TRY
SELECT @urlApi = URL FROM PortalNetCfg WHERE Descripcion = 'APIMedia' AND Estatus = 'Alta'
SELECT C.IDComunicado,
AC.AnexoBase64,
AC.Nombre,
AC.Extension,
AC.MimeType,
AC.Size,
@urlApi as urlApi
FROM pNetComunicado C
JOIN pNetAnexoComunicado AC ON C.IDComunicado = AC.IDComunicado
JOIN AnexoBase64 B64 ON AC.AnexoBase64 = B64.AnexoBase64 WHERE C.IDComunicado = @ID
END TRY
BEGIN CATCH
SET @OK = 1
SET @OkRef = ERROR_MESSAGE()
END CATCH
SET NOCOUNT OFF
END

