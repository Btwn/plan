SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spSincroISTransmisorPaqueteDropBox
@Conversacion				uniqueidentifier,
@Sucursal					int,
@SucursalDestino			int,
@SucursalOrigen				int,
@SincroISDropBox			bit,
@SincroISDropBoxRuta		varchar(255),
@Ok							int			 OUTPUT,
@OkRef						varchar(255) OUTPUT

AS
BEGIN
DECLARE @SincroISDropBoxRutaSucursal	varchar(255),
@ArchivoXML					varchar(255),
@ArchivoPAQ					varchar(255),
@ManejadorObjeto				int,
@IDArchivo					int,
@XML							varchar(max)
IF ISNULL(@SincroISDropBoxRuta, '') = '' AND ISNULL(@SincroISDropBox, 0) = 1
BEGIN
SELECT @Ok = 71665
RETURN
END
IF @Sucursal = 0
SELECT @SincroISDropBoxRutaSucursal = @SincroISDropBoxRuta + '\' + CONVERT(varchar, @SucursalDestino)
ELSE
SELECT @SincroISDropBoxRutaSucursal = @SincroISDropBoxRuta + '\0'
EXEC spCrearDirectorio @SincroISDropBoxRutaSucursal, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @ArchivoXML = @SincroISDropBoxRutaSucursal + '\' + CONVERT(varchar(255), @Conversacion) + '.xml',
@ArchivoPAQ = @SincroISDropBoxRutaSucursal + '\' + CONVERT(varchar(255), @Conversacion) + '.paq'
EXEC spCrearArchivo @ArchivoXML, @ManejadorObjeto OUTPUT, @IDArchivo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL
BEGIN
SELECT @XML = (SELECT ID 'IntelisisServiceID', Conversacion FROM IntelisisService WHERE Conversacion = @Conversacion AND SucursalOrigen = @Sucursal AND Estatus IN('SINPROCESAR', 'ENVIADO') FOR XML AUTO, ROOT('SincroISDropBoxPaquete'))
EXEC spInsertaEnArchivo @IDArchivo, @XML, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL
EXEC spCerrarArchivo @IDArchivo, @ManejadorObjeto, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spComprimirArchivo @ArchivoXML, @ArchivoPAQ, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spEliminarArchivo @ArchivoXML, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

