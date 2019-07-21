SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSInventarioLista
@ID                   int,
@iSolicitud           int,
@Version              float,
@Resultado            varchar(max) = NULL OUTPUT,
@Ok                   int = NULL OUTPUT,
@OkRef                varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@ReferenciaIS       varchar(100),
@SubReferencia      varchar(100),
@Empresa            varchar(5),
@Sucursal           int,
@Usuario            varchar(10),
@Agente             varchar(10),
@Clave              varchar(20),
@Texto              xml
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Sucursal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SELECT @Clave = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Clave'
SELECT @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SELECT @Agente = DefAgente FROM Usuario WITH(NOLOCK) WHERE Usuario = @Usuario
IF EXISTS(SELECT TOP 1 Agente FROM Agente WITH(NOLOCK) WHERE Agente = @Agente)
BEGIN
DECLARE @TablaALm Table(
Sucursal                  int,
Almacen                   varchar(100)
)
DECLARE @Tabla Table(
ID                        int,
Movimiento                varchar(20),
FechaEmision              datetime,
Almacen                   varchar(100)
)
INSERT INTO @TablaALm(Sucursal, Almacen)
SELECT @Sucursal, Almacen
FROM Alm
WITH(NOLOCK) WHERE Sucursal = @Sucursal
AND WMS = 1
INSERT INTO @Tabla(ID, Movimiento, FechaEmision, Almacen)
SELECT i.ID, i.Mov, i.FechaEmision, i.Almacen
FROM Inv i
 WITH(NOLOCK) JOIN MovTipo mt WITH(NOLOCK) ON(i.Mov = mt.mov AND mt.Modulo = 'INV')
JOIN @TablaALm t ON (i.almacen = t.Almacen)
WHERE i.agente = @Agente
AND mt.Clave = @Clave
AND i.Estatus = 'SINAFECTAR'
SELECT @Texto = (SELECT CAST(ISNULL(ID,0) AS varchar)                             AS ID,
ISNULL(Movimiento,'')                                     AS Movimiento,
CONVERT(varchar(11), ISNULL(FechaEmision,'19000101'),113) AS FechaEmision,
ISNULL(Almacen,'')                                        AS Almacen
FROM @Tabla AS TMA
FOR XML AUTO)
END
ELSE
BEGIN
SET @Ok = 26090
END
SELECT @ReferenciaIS = Referencia FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

