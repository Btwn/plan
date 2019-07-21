SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spSincroISTransmisorDropBox
@ID						int,
@ISGUID					uniqueidentifier,
@Sucursal				int,
@SucursalDestino		int,
@SucursalOrigen			int,
@SincroTabla			varchar(100),
@SubReferencia			varchar(100),
@SincroISDropBox		bit,
@SincroISDropBoxRuta	varchar(255),
@Ok						int			 OUTPUT,
@OkRef					varchar(255) OUTPUT

AS
BEGIN
DECLARE @ManejadorObjeto				int,
@IDArchivo					int,
@XML							varchar(max),
@SincroISDropBoxRutaSucursal	varchar(255),
@ArchivoXML					varchar(255),
@ArchivoZIP					varchar(255)
CREATE TABLE #IntelisisService(
Tag										int					NULL,
Parent									int					NULL,
[IntelisisService!1!]					int					NULL,
[IntelisisService!2!ID]					int					NULL,
[IntelisisService!2!Sistema]			varchar(100)		NULL,
[IntelisisService!2!Contenido]			varchar(100)		NULL,
[IntelisisService!2!Referencia]			varchar(100)		NULL,
[IntelisisService!2!SubReferencia]		varchar(100)		NULL,
[IntelisisService!2!Version]			float				NULL,
[IntelisisService!2!Usuario]			varchar(10)			NULL,
[IntelisisService!2!Solicitud!cdata]	varchar(max)		NULL,
[IntelisisService!2!Resultado!cdata]	varchar(max)		NULL,
[IntelisisService!2!Estatus]			varchar(15)			NULL,
[IntelisisService!2!FechaEstatus]		datetime			NULL,
[IntelisisService!2!Ok]					int					NULL,
[IntelisisService!2!OkRef]				varchar(255)		NULL,
[IntelisisService!2!Conversacion]		uniqueidentifier	NULL,
[IntelisisService!2!SincroGUID]			uniqueidentifier	NULL,
[IntelisisService!2!SucursalOrigen]		int					NULL,
[IntelisisService!2!SucursalDestino]	int					NULL,
[IntelisisService!2!eDocInArchivo]		varchar(255)		NULL,
[IntelisisService!2!SincroTabla]		varchar(100)		NULL,
[IntelisisService!2!SincroSolicitud]	uniqueidentifier	NULL
)
IF ISNULL(@SincroISDropBoxRuta, '') = '' AND ISNULL(@SincroISDropBox, 0) = 1
BEGIN
SELECT @Ok = 71665
RETURN
END
IF @Sucursal = 0
SELECT @SincroISDropBoxRutaSucursal = @SincroISDropBoxRuta + '\' + CONVERT(varchar, @SucursalDestino)
ELSE
SELECT @SincroISDropBoxRutaSucursal = @SincroISDropBoxRuta + '\0'
INSERT INTO #IntelisisService
SELECT 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
UNION ALL
SELECT 2, 1, NULL, ID, Sistema, Contenido, Referencia, SubReferencia, Version, Usuario, Solicitud, Resultado, Estatus, FechaEstatus, Ok, OkRef, Conversacion, SincroGUID, SucursalOrigen, SucursalDestino, eDocInArchivo, SincroTabla, SincroSolicitud
FROM IntelisisService
WHERE ID = @ID
SELECT @XML = (SELECT * FROM #IntelisisService FOR XML EXPLICIT)
EXEC spCrearDirectorio @SincroISDropBoxRutaSucursal, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @ArchivoXML = @SincroISDropBoxRutaSucursal + '\' + dbo.fnSincroISDropBoxNombreArchivo(@ID, @SucursalOrigen, @SucursalDestino, @SincroTabla, @SubReferencia) + '.xml',
@ArchivoZIP = @SincroISDropBoxRutaSucursal + '\' + dbo.fnSincroISDropBoxNombreArchivo(@ID, @SucursalOrigen, @SucursalDestino, @SincroTabla, @SubReferencia) + '.zip'
EXEC spCrearArchivo @ArchivoXML, @ManejadorObjeto OUTPUT, @IDArchivo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL
EXEC spInsertaEnArchivo @IDArchivo, @XML, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spCerrarArchivo @IDArchivo, @ManejadorObjeto, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spComprimirArchivo @ArchivoXML, @ArchivoZIP, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spEliminarArchivo @ArchivoXML, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

