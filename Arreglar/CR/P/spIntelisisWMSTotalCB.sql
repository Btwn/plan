SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSTotalCB
@ID            int,
@iSolicitud    int,
@Version       float,
@Resultado     varchar(max) = NULL OUTPUT,
@Ok            int = NULL OUTPUT,
@OkRef         varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa            varchar(5),
@ReferenciaIS       varchar(100),
@SubReferencia      varchar(100),
@ID2                int,
@Mov                varchar(20),
@MovID              varchar(20),
@Articulo           varchar(20),
@Descripcion        varchar(100),
@Texto              xml
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Mov= Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mov'
SELECT @MovID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovID'
SELECT @Articulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Articulo'
DECLARE @Tabla Table(
Articulo               varchar(20),
Total                  varchar(100)
)
SELECT @ID2 = ID
FROM Compra
WHERE Empresa = @Empresa
AND Mov = @Mov
AND MovID = @MovID
INSERT INTO @Tabla (Articulo, Total)
SELECT @Articulo,
CAST(ISNULL(sum(s.Cantidad),0) AS VARCHAR)
FROM SerieLoteMovMovil s
WHERE ID = @ID2
AND Empresa = @Empresa
AND Modulo = 'COMS'
AND Articulo = @Articulo
SELECT @Texto = (SELECT TMA.Articulo,
TMA.Total
FROM @Tabla TMA
FOR XML AUTO)
IF @@ERROR <> 0 SET @Ok = 1
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + ' Descripcion="' + ISNULL(@Descripcion,'') +'">' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
END

