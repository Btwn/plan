SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSInventarioActualizar
@ID                      int,
@iSolicitud              int,
@Version                 float,
@Resultado               varchar(max) = NULL OUTPUT,
@Ok                      int = NULL OUTPUT,
@OkRef                   varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa                 varchar(5),
@ModuloID                varchar(255),
@Renglon                 varchar(255),
@RenglonSub              varchar(255),
@RenglonID               varchar(255),
@Cantidad                varchar(255),
@ModuloID2               int,
@Renglon2                float,
@RenglonSub2             int,
@RenglonID2              int,
@Cantidad2               float,
@ReferenciaIS            varchar(100),
@SubReferencia           varchar(100),
@Texto                   xml
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @ModuloID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModuloID'
SELECT @Renglon = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Renglon'
SELECT @RenglonSub = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RenglonSub'
SELECT @RenglonID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RenglonID'
SELECT @Cantidad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cantidad'
SET @Empresa     = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @ModuloID2   = CAST(ISNULL(@ModuloID,'0') AS int)
SET @Renglon2    = CAST(ISNULL(@Renglon,'0') AS float)
SET @RenglonSub2 = CAST(ISNULL(@RenglonSub,'0') AS int)
SET @RenglonID2  = CAST(ISNULL(@RenglonID,'0') AS int)
SET @Cantidad2   = CAST(ISNULL(@Cantidad,'0') AS float)
SET @Texto = ''
IF @ModuloID > 0
BEGIN
UPDATE InvD
 WITH(ROWLOCK) SET Cantidad = @Cantidad2,
CantidadInventario = (ISNULL(Factor,1) * @Cantidad2)
WHERE ID = @ModuloID2
AND Renglon = @Renglon2
AND RenglonSub = @RenglonSub2
AND RenglonID = @RenglonID2
END
ELSE
BEGIN
SET @Ok = 10160
END
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WITH(NOLOCK) WHERE ID = @ID
IF @Ok IS NOT NULL
SELECT @OkRef = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
END

