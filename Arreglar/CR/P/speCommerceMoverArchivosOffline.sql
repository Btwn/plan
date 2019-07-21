SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speCommerceMoverArchivosOffline

AS BEGIN
DECLARE
@Solicitud   varchar(8000),
@Resultado   varchar(8000),
@Nombre      varchar(255),
@Nombre2      varchar(255),
@Nombre3      varchar(255),
@ID          int,
@Estacion    int,
@Origen2     varchar(255),
@Destino2    varchar(255),
@Contrasena  varchar(32),
@Existe      int,
@Contador    int,
@Archivo     varchar(255),
@ArchivoDestino varchar(255),
@Archivo2     varchar(255),
@ArchivoDestino2 varchar(255),
@Archivo3     varchar(255),
@ArchivoDestino3 varchar(255),
@Ruta        varchar(255),
@RutaProc    varchar(255),
@RutaError   varchar(255),
@DropBox     varchar(255),
@eCommerceSucursal  varchar(10),
@Sucursal    int,
@Usuario     varchar(10),
@Extencion   varchar(255),
@Tipo        varchar(50),
@Ok	       int,
@Error       int,
@OkRef       varchar(255)
SELECT @DropBox = DirSFTP, @Usuario = WebUsuario  FROM WebVersion
SELECT @Contrasena = Contrasena FROM Usuario WHERE Usuario = @Usuario
SELECT @Estacion = @@SPID
DELETE eCommerceDirDetalle2 WHERE Estacion = @Estacion
IF EXISTS(SELECT * FROM Sucursal WHERE eCommerce = 1 AND NULLIF(eCommerceSucursal,'') IS NOT NULL)
BEGIN
DECLARE crSucursal CURSOR local FOR
SELECT Sucursal, eCommerceSucursal
FROM Sucursal
WHERE eCommerce = 1 AND NULLIF(eCommerceSucursal,'') IS NOT NULL
OPEN crSucursal
FETCH NEXT FROM crSucursal INTO @Sucursal, @eCommerceSucursal
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @Ruta = @DropBox + '\' + @eCommerceSucursal+'\OffLine'
EXEC speCommerceListarDirectorio2 @Ruta, @Estacion, 1
EXEC speCommerceCopiarDirectorio @Ruta, @Estacion, 1 , @DropBox, NULL, @eCommerceSucursal
FETCH NEXT FROM crSucursal INTO @Sucursal, @eCommerceSucursal
END
CLOSE crSucursal
DEALLOCATE crSucursal
END
END

