SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISEnviarCorreo
@IntelisisServiceID		int

AS BEGIN
DECLARE
@SincroISDBMailPerfil				varchar(50),
@SincroISDBMailAsunto				varchar(8000),
@SincroISDBMailMensaje				varchar(8000),
@eMail								varchar(50),
@SubReferencia						varchar(100),
@Estatus							varchar(15),
@FechaEstatus						datetime,
@Conversacion						uniqueidentifier,
@SincroGUID							uniqueidentifier,
@SucursalOrigen						int,
@SucursalDestino					int,
@IntelisisServiceOk					int,
@IntelisisServiceOkRef				varchar(255)
SELECT
@SincroISDBMailPerfil = SincroISDBMailPerfil,
@SincroISDBMailAsunto = SincroISDBMailAsunto,
@SincroISDBMailMensaje = SincroISDBMailMensaje
FROM Version
SELECT
@SubReferencia         = SubReferencia,
@Estatus               = Estatus,
@FechaEstatus          = FechaEstatus,
@Conversacion          = Conversacion,
@SincroGUID            = SincroGUID,
@SucursalOrigen        = SucursalOrigen,
@SucursalDestino       = SucursalDestino,
@IntelisisServiceOk    = Ok,
@IntelisisServiceOkRef = OkRef
FROM IntelisisService
WHERE ID = @IntelisisServiceID
SELECT @SincroISDBMailAsunto = REPLACE(@SincroISDBMailAsunto,'#IntelisisServiceID#',LTRIM(RTRIM(CONVERT(varchar,ISNULL(@IntelisisServiceID,0)))))
SELECT @SincroISDBMailAsunto = REPLACE(@SincroISDBMailAsunto,'#SubReferencia#',LTRIM(RTRIM(ISNULL(@SubReferencia,''))))
SELECT @SincroISDBMailAsunto = REPLACE(@SincroISDBMailAsunto,'#Estatus#',LTRIM(RTRIM(ISNULL(@Estatus,''))))
SELECT @SincroISDBMailAsunto = REPLACE(@SincroISDBMailAsunto,'#IntelisisServiceOk#',LTRIM(RTRIM(CONVERT(varchar,ISNULL(@IntelisisServiceOk,-1)))))
SELECT @SincroISDBMailAsunto = REPLACE(@SincroISDBMailAsunto,'#IntelisisServiceOkRef#',LTRIM(RTRIM(ISNULL(@IntelisisServiceOkRef,''))))
SELECT @SincroISDBMailAsunto = REPLACE(@SincroISDBMailAsunto,'#FechaEstatus#',LTRIM(RTRIM(CONVERT(varchar,ISNULL(@FechaEstatus,GETDATE())))))
SELECT @SincroISDBMailAsunto = REPLACE(@SincroISDBMailAsunto,'#Conversacion#',LTRIM(RTRIM(ISNULL(CONVERT(varchar(100),@Conversacion),''))))
SELECT @SincroISDBMailAsunto = REPLACE(@SincroISDBMailAsunto,'#SincroGUID#',LTRIM(RTRIM(ISNULL(CONVERT(varchar(100),@SincroGUID),''))))
SELECT @SincroISDBMailAsunto = REPLACE(@SincroISDBMailAsunto,'#SucursalOrigen#',LTRIM(RTRIM(CONVERT(varchar,ISNULL(@SucursalOrigen,-1)))))
SELECT @SincroISDBMailAsunto = REPLACE(@SincroISDBMailAsunto,'#SucursalDestino#',LTRIM(RTRIM(CONVERT(varchar,ISNULL(@SucursalDestino,-1)))))
SELECT @SincroISDBMailMensaje = REPLACE(@SincroISDBMailMensaje,'#IntelisisServiceID#',LTRIM(RTRIM(CONVERT(varchar,ISNULL(@IntelisisServiceID,0)))))
SELECT @SincroISDBMailMensaje = REPLACE(@SincroISDBMailMensaje,'#SubReferencia#',LTRIM(RTRIM(ISNULL(@SubReferencia,''))))
SELECT @SincroISDBMailMensaje = REPLACE(@SincroISDBMailMensaje,'#Estatus#',LTRIM(RTRIM(ISNULL(@Estatus,''))))
SELECT @SincroISDBMailMensaje = REPLACE(@SincroISDBMailMensaje,'#IntelisisServiceOk#',LTRIM(RTRIM(CONVERT(varchar,ISNULL(@IntelisisServiceOk,-1)))))
SELECT @SincroISDBMailMensaje = REPLACE(@SincroISDBMailMensaje,'#IntelisisServiceOkRef#',LTRIM(RTRIM(ISNULL(@IntelisisServiceOkRef,''))))
SELECT @SincroISDBMailMensaje = REPLACE(@SincroISDBMailMensaje,'#FechaEstatus#',LTRIM(RTRIM(CONVERT(varchar,ISNULL(@FechaEstatus,GETDATE())))))
SELECT @SincroISDBMailMensaje = REPLACE(@SincroISDBMailMensaje,'#Conversacion#',LTRIM(RTRIM(ISNULL(CONVERT(varchar(100),@Conversacion),''))))
SELECT @SincroISDBMailMensaje = REPLACE(@SincroISDBMailMensaje,'#SincroGUID#',LTRIM(RTRIM(ISNULL(CONVERT(varchar(100),@SincroGUID),''))))
SELECT @SincroISDBMailMensaje = REPLACE(@SincroISDBMailMensaje,'#SucursalOrigen#',LTRIM(RTRIM(CONVERT(varchar,ISNULL(@SucursalOrigen,-1)))))
SELECT @SincroISDBMailMensaje = REPLACE(@SincroISDBMailMensaje,'#SucursalDestino#',LTRIM(RTRIM(CONVERT(varchar,ISNULL(@SucursalDestino,-1)))))
IF NULLIF(@SincroISDBMailPerfil,'') IS NOT NULL AND NULLIF(@SincroISDBMailAsunto,'') IS NOT NULL AND NULLIF(@SincroisdbMailMensaje,'') IS NOT NULL
BEGIN
DECLARE crUsuario CURSOR FOR
SELECT u.eMail
FROM Usuario u JOIN UsuarioCfg2 uc2
ON uc2.Usuario = uc2.Usuario
WHERE uc2.SincroISNotificarError = 1
AND NULLIF(u.eMail,'') IS NOT NULL
OPEN crUsuario
FETCH NEXT FROM crUsuario INTO @eMail
WHILE @@FETCH_STATUS = 0
BEGIN
EXEC spEnviarDBMail @SincroISDBMailPerfil, @eMail, NULL, NULL, @SincroISDBMailAsunto, @SincroISDBMailMensaje
FETCH NEXT FROM crUsuario INTO @eMail
END
CLOSE crUsuario
DEALLOCATE crUsuario
END
END

