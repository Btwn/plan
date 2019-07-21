SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisMapeoMovMovilListado
@ID            int,
@iSolicitud    int,
@Version       float,
@Resultado     varchar(max) = NULL OUTPUT,
@Ok            int = NULL OUTPUT,
@OkRef         varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto              xml,
@ReferenciaIS       varchar(100),
@SubReferencia      varchar(100),
@Clave              varchar(20),
@Descripcion        varchar(100)
SELECT @Clave = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Clave'
DECLARE @Tabla Table(
Mov                      varchar(20),
Modulo                   varchar(5),
RequiereMontacarga       char(1),
MovTransito              varchar(20),
MovFinal                 varchar(20),
ClaveAfectacion          varchar(20)
)
IF @Clave = 'TMA.SADO'
INSERT INTO @Tabla(Mov, Modulo, RequiereMontacarga, MovTransito, Movfinal, ClaveAfectacion)
SELECT ISNULL(mmm.Mov,''),
ISNULL(mmm.Modulo,''),
CAST(ISNULL(mmm.RequiereMontacarga,1) AS varchar),
ISNULL(mmm.MovTransito,''),
ISNULL(mmm.MovFinal,''),
ISNULL(mt.Clave,'')
FROM MapeoMovMovil mmm
 WITH(NOLOCK) JOIN MovTipo mt  WITH(NOLOCK) ON (mmm.Mov = mt.Mov AND mt.Modulo = 'TMA' AND mt.SubClave IS NULL)
WHERE mt.Clave IN (@Clave,'TMA.OADO')
ORDER BY 3 DESC
IF @Clave = 'TMA.OSUR'
INSERT INTO @Tabla(Mov, Modulo, RequiereMontacarga, MovTransito, Movfinal, ClaveAfectacion)
SELECT ISNULL(mmm.Mov,''),
ISNULL(mmm.Modulo,''),
CAST(ISNULL(mmm.RequiereMontacarga,1) AS varchar),
ISNULL(mmm.MovTransito,''),
ISNULL(mmm.MovFinal,''),
ISNULL(mt.Clave,'')
FROM MapeoMovMovil mmm
 WITH(NOLOCK) JOIN MovTipo mt  WITH(NOLOCK) ON (mmm.Mov = mt.Mov AND mt.Modulo = 'TMA')
WHERE mt.Clave IN (@Clave,'TMA.OPCKTARIMA')
ORDER BY 3 DESC
IF @Clave NOT IN ('TMA.SADO','TMA.OSUR')
INSERT INTO @Tabla(Mov, Modulo, RequiereMontacarga, MovTransito, Movfinal, ClaveAfectacion)
SELECT ISNULL(mmm.Mov,''),
ISNULL(mmm.Modulo,''),
CAST(ISNULL(mmm.RequiereMontacarga,1) AS varchar),
ISNULL(mmm.MovTransito,''),
ISNULL(mmm.MovFinal,''),
ISNULL(mt.Clave,'')
FROM MapeoMovMovil mmm
 WITH(NOLOCK) JOIN MovTipo mt  WITH(NOLOCK) ON (mmm.Mov = mt.Mov AND mt.Modulo = 'TMA' AND mt.SubClave IS NULL)
WHERE mt.Clave = ISNULL(@Clave, mt.Clave)
ORDER BY 3 DESC
SELECT @Texto = (SELECT * FROM @Tabla AS TMA FOR XML AUTO)
IF @Texto IS NULL
SELECT @Ok = 70150, @OkRef = @Clave
IF @@ERROR <> 0
SET @Ok = 1
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WITH(NOLOCK) WHERE ID = @ID
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NOT NULL
SELECT @Descripcion = Descripcion + ' ' + @OkRef FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok 
SELECT @OkRef = ''  
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + '  Descripcion=' + CHAR(34) + ISNULL(@Descripcion,'') + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max), ISNULL(@Texto,'')) + '</Resultado></Intelisis>' 
IF @@ERROR <> 0
SET @Ok = 1
END

