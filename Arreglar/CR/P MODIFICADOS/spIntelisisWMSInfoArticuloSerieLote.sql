SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSInfoArticuloSerieLote
@ID                 int,
@iSolicitud         int,
@Version            float,
@Resultado          varchar(max) = NULL OUTPUT,
@Ok                 int = NULL OUTPUT,
@OkRef              varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa            varchar(5),
@ReferenciaIS       varchar(100),
@SubReferencia      varchar(100),
@ModuloID           int,
@RenglonID          int,
@Mov                varchar(20),
@MovID              varchar(20),
@Articulo           varchar(20),
@Descripcion1       varchar(100),
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
SELECT @RenglonID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RenglonID'
SELECT @Articulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Articulo'
DECLARE @Tabla Table(
RenglonID                 int,
Articulo                  varchar(20),
SubCuenta                 varchar(50),
Descripcion1              varchar(100),
SerieLote                 varchar(50),
Cantidad                  float
)
SELECT @ModuloID = ID
FROM Compra
WITH(NOLOCK) WHERE Empresa = @Empresa
AND Mov = @Mov
AND MovID = @MovID
INSERT INTO @Tabla (RenglonID, Articulo, SubCuenta, SerieLote, Cantidad)
SELECT ISNULL(s.RenglonID,0),
ISNULL(s.Articulo,''),
ISNULL(s.SubCuenta,''),
ISNULL(s.SerieLote,''),
ISNULL(s.Cantidad,0)
FROM SerieLoteMov s
WITH(NOLOCK) WHERE s.Modulo = 'COMS'
AND s.ID = @ModuloID
AND s.RenglonID = @RenglonID
DELETE @Tabla WHERE Cantidad = '0' OR LTRIM(RTRIM(ISNULL(SerieLote,''))) = ''
UPDATE @Tabla
SET Descripcion1 = ISNULL(b.Descripcion1,'')
FROM @Tabla a
INNER JOIN Art b  WITH(NOLOCK) ON (a.Articulo = b.Articulo)
SELECT @Texto = (SELECT CAST(RenglonID AS varchar) AS RenglonID,
ISNULL(Articulo,'')        AS Articulo,
ISNULL(SubCuenta,'')       AS SubCuenta,
ISNULL(Descripcion1,'')    AS Descripcion1,
ISNULL(SerieLote,'')       AS SerieLote,
CAST(Cantidad AS varchar)  AS Cantidad
FROM @Tabla AS TMA
FOR XML AUTO)
SELECT @ReferenciaIS = Referencia FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

