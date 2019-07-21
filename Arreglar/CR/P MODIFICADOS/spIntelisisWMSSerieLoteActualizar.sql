SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSSerieLoteActualizar
@ID                      int,
@iSolicitud              int,
@Version                 float,
@Resultado               varchar(max) = NULL OUTPUT,
@Ok                      int = NULL OUTPUT,
@OkRef                   varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa                 varchar(5),
@Modulo                  varchar(5),
@ModuloID                varchar(255),
@RenglonID               varchar(255),
@Articulo                varchar(20),
@SubCuenta               varchar(50),
@SerieLote               varchar(50),
@Cantidad                varchar(255),
@ModuloID2               int,
@RenglonID2              int,
@Cantidad2               float,
@ReferenciaIS            varchar(100),
@SubReferencia           varchar(100),
@Texto                   xml
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Modulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Modulo'
SELECT @ModuloID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModuloID'
SELECT @RenglonID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RenglonID'
SELECT @Articulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Articulo'
SELECT @SubCuenta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SubCuenta'
SELECT @SerieLote = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SerieLote'
SELECT @Cantidad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cantidad'
SET @Empresa    = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Modulo     = LTRIM(RTRIM(ISNULL(@Modulo,'')))
SET @ModuloID2  = CAST(ISNULL(@ModuloID,'0') AS int)
SET @RenglonID2 = CAST(ISNULL(@RenglonID,'0') AS int)
SET @Articulo   = LTRIM(RTRIM(ISNULL(@Articulo,'')))
SET @SubCuenta  = LTRIM(RTRIM(ISNULL(@SubCuenta,'')))
SET @SerieLote  = LTRIM(RTRIM(ISNULL(@SerieLote,'')))
SET @Cantidad2  = CAST(ISNULL(@Cantidad,'0') AS float)
IF @ModuloID > 0
BEGIN
DECLARE @Tabla Table(
Empresa              varchar(5),
Modulo               varchar(5),
ModuloID             int,
RenglonID            int,
Articulo             varchar(20),
SubCuenta            varchar(20),
SerieLote            varchar(50),
Cantidad             float
)
IF @Modulo = 'INV'
BEGIN
UPDATE SerieLoteMovMovil
 WITH(ROWLOCK) SET Cantidad = @Cantidad2
WHERE Empresa = @Empresa
AND Modulo = @Modulo
AND ID = @ModuloID2
AND RenglonID = @RenglonID2
AND Articulo = @Articulo
AND LTRIM(RTRIM(ISNULL(SubCuenta,''))) = @SubCuenta
AND SerieLote = @SerieLote
DELETE SerieLoteMovMovil
WHERE Empresa = @Empresa
AND Modulo = @Modulo
AND ID = @ModuloID2
AND RenglonID = @RenglonID2
AND ISNULL(Cantidad,0) = 0
INSERT INTO @Tabla (Empresa,Modulo,ModuloID,RenglonID,Articulo,SubCuenta,SerieLote,Cantidad)
SELECT Empresa,Modulo,ID,RenglonID,Articulo,SubCuenta,SerieLote,Cantidad
FROM SerieLoteMovMovil WITH(NOLOCK)
WHERE Empresa = @Empresa
AND Modulo = @Modulo
AND ID = @ModuloID2
AND RenglonID = @RenglonID2
AND Articulo = @Articulo
AND LTRIM(RTRIM(ISNULL(SubCuenta,''))) = @SubCuenta
AND SerieLote = @SerieLote
END
IF @Modulo = 'COMS'
BEGIN
UPDATE SerieLoteMov
 WITH(ROWLOCK) SET Cantidad = @Cantidad2
WHERE Empresa = @Empresa
AND Modulo = @Modulo
AND ID = @ModuloID2
AND RenglonID = @RenglonID2
AND Articulo = @Articulo
AND LTRIM(RTRIM(ISNULL(SubCuenta,''))) = @SubCuenta
AND SerieLote = @SerieLote
DELETE SerieLoteMov
WHERE Empresa = @Empresa
AND Modulo = @Modulo
AND ID = @ModuloID2
AND RenglonID = @RenglonID2
AND ISNULL(Cantidad,0) = 0
INSERT INTO @Tabla (Empresa,Modulo,ModuloID,RenglonID,Articulo,SubCuenta,SerieLote,Cantidad)
SELECT Empresa,Modulo,ID,RenglonID,Articulo,SubCuenta,SerieLote,Cantidad
FROM SerieLoteMov WITH(NOLOCK)
WHERE Empresa = @Empresa
AND Modulo = @Modulo
AND ID = @ModuloID2
AND RenglonID = @RenglonID2
AND Articulo = @Articulo
AND LTRIM(RTRIM(ISNULL(SubCuenta,''))) = @SubCuenta
AND SerieLote = @SerieLote
END
SELECT @Texto = (SELECT Empresa,
Modulo,
CAST(ModuloID AS VARCHAR) AS ModuloID,
CAST(RenglonID AS VARCHAR) AS RenglonID,
Articulo,
SubCuenta,
SerieLote,
CAST(Cantidad AS VARCHAR) AS Cantidad
FROM @Tabla AS TMA
FOR XML AUTO)
END
ELSE
BEGIN
SET @Ok = 10160
END
SELECT @ReferenciaIS = Referencia FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

