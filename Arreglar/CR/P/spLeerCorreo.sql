SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spLeerCorreo
@Archivo				varchar(max) OUTPUT,
@Ok						int = NULL OUTPUT,
@OkRef					varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@UID						uniqueidentifier,
@UIDTexto					varchar(50),
@RutaCompleta				varchar(255),
@RecibirCorreoPerfil		varchar(50),
@RecibirCorreoPOP3		varchar(255),
@CadenaConexion			varchar(max),
@Shell					varchar(8000),
@iDatos					int,
@Cuenta					varchar(50),
@Fecha					varchar(50),
@CantidadMensajes			int,
@Servidor					varchar(50),
@BaseDatos				varchar(50),
@Empresa					varchar(5)
DECLARE @Mensaje TABLE
(
ID				int NULL,
De				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Para				varchar(max) COLLATE DATABASE_DEFAULT NULL,
CC				varchar(max) COLLATE DATABASE_DEFAULT NULL,
Asunto			varchar(max) COLLATE DATABASE_DEFAULT NULL,
Mensaje			varchar(max) COLLATE DATABASE_DEFAULT NULL,
Enviado			varchar(50) COLLATE DATABASE_DEFAULT NULL
)
SET @UID = NEWID()
SET @UIDTexto = LTRIM(RTRIM(CONVERT(varchar(50),@UID)))
SELECT
@RutaCompleta = LTRIM(RTRIM(ISNULL(RecibirCorreoRuta,''))),
@RecibirCorreoPerfil = LTRIM(RTRIM(ISNULL(RecibirCorreoPerfil,''))),
@RecibirCorreoPOP3 = LTRIM(RTRIM(ISNULL(RecibirCorreoRutaComponentePOP,'')))
FROM Version
IF NULLIF(@RecibirCorreoPerfil,'') IS NULL SELECT @Ok = 53060 ELSE
IF NULLIF(@RutaCompleta,'') IS NULL SELECT @Ok = 53070 ELSE
IF NULLIF(@RecibirCorreoPOP3,'') IS NULL SELECT @Ok = 53080
IF @Ok IS NULL
BEGIN
DELETE FROM CorreoRecibido WHERE SPID = @@SPID
IF SUBSTRING(REVERSE(@RutaCompleta),1,1) = '\'
SET @RutaCompleta = @RutaCompleta + 'CorreoRecibido_' + @UIDTexto + '.XML'
ELSE
SET @RutaCompleta = @RutaCompleta + '\CorreoRecibido_' + @UIDTexto + '.XML'
SELECT @CadenaConexion = dbo.fnGenerarCadenaConexionCorreo(@RutaCompleta, @RecibirCorreoPerfil)
SET @Shell = @RecibirCorreoPOP3 + ' ' + @CadenaConexion
EXEC xp_cmdshell @Shell, no_output
EXEC spLeerArchivo @RutaCompleta, @Archivo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC sp_xml_preparedocument @iDatos OUTPUT, @Archivo
SELECT
@Cuenta = Cuenta,
@Fecha = Fecha,
@CantidadMensajes = CantidadMensajes,
@Servidor = Servidor,
@BaseDatos = BaseDatos,
@Empresa = Empresa
FROM OPENXML (@iDatos, '/Mensajes', 1) WITH (Cuenta varchar(50), Fecha varchar(50), CantidadMensajes int, Servidor varchar(50), BaseDatos varchar(50), Empresa varchar(5))
INSERT CorreoRecibido (SPID,   ID, Cuenta,  Fecha,  CantidadMensajes,  Servidor,  BaseDatos,  Empresa,  De, Para, CC, Asunto, Mensaje, Enviado)
SELECT  @@SPID, ID, @Cuenta, @Fecha, @CantidadMensajes, @Servidor, @BaseDatos, @Empresa, De, Para, CC, Asunto, Mensaje, Enviado
FROM OPENXML (@iDatos, '/Mensajes/Mensaje', 1) WITH (ID int, De varchar(255), Para varchar(max), CC varchar(max), Asunto varchar(max), Mensaje varchar(max), Enviado varchar(50))
EXEC sp_xml_removedocument @iDatos
END
END

