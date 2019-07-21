SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSGuardarSerieLoteMov
@ID                        int,
@iSolicitud                int,
@Version                   float,
@Resultado                 varchar(max) = NULL OUTPUT,
@Ok                        int = NULL OUTPUT,
@OkRef                     varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto                   xml,
@ReferenciaIS            varchar(100),
@SubReferencia           varchar(100),
@Empresa                 varchar(5),
@Sucursal                int,
@Usuario                 varchar(10),
@xml                     xml
DECLARE
@Modulo                  varchar(5),
@ModuloID                int,
@RenglonID               int,
@Articulo                varchar(20),
@SubCuenta               varchar(50),
@SerieLote               varchar(50),
@Cantidad                float,
@Propiedades             varchar(20),
@Tarima                  varchar(20),
@idx                     int
DECLARE @TablaSerieLoteMov table(
IDX                      int identity (1,1),
Empresa                  varchar(5),
Modulo                   varchar(5),
ModuloID                 int,
RenglonID                int,
Articulo                 varchar(20),
Subcuenta                varchar(50),
SerieLote                varchar(50),
Cantidad                 float,
Propiedades              varchar(20),
Sucursal                 int,
Tarima                   varchar(20)
)
DECLARE @Tabla Table(
Mensaje                    varchar(255)
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Sucursal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SELECT @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SELECT @ModuloID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModuloID'
SET @Empresa  = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Sucursal = LTRIM(RTRIM(ISNULL(@Sucursal,0)))
SET @Usuario  = LTRIM(RTRIM(ISNULL(@Usuario,'')))
SET @ModuloID = LTRIM(RTRIM(ISNULL(@ModuloID,0)))
INSERT INTO @TablaSerieLoteMov (Empresa, Modulo, ModuloID, RenglonID, Articulo, Subcuenta, SerieLote, Cantidad, Propiedades, Sucursal, Tarima)
SELECT Empresa, Modulo, ModuloID, RenglonID, Articulo, Subcuenta, SerieLote, Cantidad, Propiedades, Sucursal, Tarima
FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Tabla')
WITH (
Empresa     varchar (5)  '@Empresa',
Modulo      varchar (5)  '@Modulo',
ModuloID    int          '@ModuloID',
RenglonID   int          '@RenglonID',
Articulo    varchar (20) '@Articulo',
Subcuenta   varchar (50) '@Subcuenta',
SerieLote   varchar (50) '@SerieLote',
Cantidad    float        '@Cantidad',
Propiedades varchar (20) '@Propiedades',
Sucursal    int          '@Sucursal',
Tarima      varchar (20) '@Tarima'
);
DECLARE TablaSerieLoteMov_cursor CURSOR FOR SELECT IDX, Empresa, Modulo, ModuloID, RenglonID, Articulo, Subcuenta, SerieLote, Cantidad, Propiedades, Sucursal, Tarima FROM @TablaSerieLoteMov
OPEN TablaSerieLoteMov_cursor
FETCH NEXT FROM TablaSerieLoteMov_cursor INTO @idx, @Empresa, @Modulo, @ModuloID, @RenglonID, @Articulo, @Subcuenta, @SerieLote, @Cantidad, @Propiedades, @Sucursal, @Tarima
WHILE @@FETCH_STATUS = 0
BEGIN
IF EXISTS(SELECT TOP 1 ID
FROM SerieLoteMov
WHERE Empresa   = @Empresa
AND Modulo    = @Modulo
AND ID        = @ModuloID
AND RenglonID = @RenglonID
AND Articulo  = @Articulo
AND SubCuenta = @SubCuenta
AND SerieLote = @SerieLote
)
BEGIN
IF ISNULL(@Cantidad,0) > 0
BEGIN
UPDATE SerieLoteMov
SET Cantidad    = @Cantidad,
Propiedades = @Propiedades,
Sucursal    = @Sucursal,
Tarima      = @Tarima
WHERE Empresa     = @Empresa
AND Modulo      = @Modulo
AND ID          = @ModuloID
AND RenglonID   = @RenglonID
AND Articulo    = @Articulo
AND SubCuenta   = @SubCuenta
AND SerieLote   = @SerieLote
END
ELSE
BEGIN
DELETE SerieLoteMov
WHERE Empresa     = @Empresa
AND Modulo      = @Modulo
AND ID          = @ModuloID
AND RenglonID   = @RenglonID
AND Articulo    = @Articulo
AND SubCuenta   = @SubCuenta
AND SerieLote   = @SerieLote
END
END
ELSE
BEGIN
IF ISNULL(@Cantidad,0) > 0
BEGIN
INSERT INTO SerieLoteMov (Empresa, Modulo, ID, RenglonID, Articulo, Subcuenta, SerieLote, Cantidad, Propiedades, Sucursal, Tarima)
VALUES (@Empresa, @Modulo, @ModuloID, @RenglonID, @Articulo, @Subcuenta, @SerieLote, @Cantidad, @Propiedades, @Sucursal, @Tarima)
END
END
FETCH NEXT FROM TablaSerieLoteMov_cursor INTO @idx, @Empresa, @Modulo, @ModuloID, @RenglonID, @Articulo, @Subcuenta, @SerieLote, @Cantidad, @Propiedades, @Sucursal, @Tarima
END
CLOSE TablaSerieLoteMov_cursor
DEALLOCATE TablaSerieLoteMov_cursor
SELECT @idx = MAX(IDX) FROM @TablaSerieLoteMov
INSERT INTO @Tabla (Mensaje) VALUES (CAST(ISNULL(@idx,0) AS varchar) + ' registros actualizados.')
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @Texto = (SELECT LTRIM(RTRIM(ISNULL(Mensaje,''))) AS Mensaje
FROM @Tabla AS Tabla
FOR XML AUTO)
SELECT @ReferenciaIS = Referencia FROM IntelisisService WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

