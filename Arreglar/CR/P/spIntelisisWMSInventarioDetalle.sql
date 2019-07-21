SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSInventarioDetalle
@ID                      int,
@iSolicitud              int,
@Version                 float,
@Resultado               varchar(max) = NULL OUTPUT,
@Ok                      int = NULL OUTPUT,
@OkRef                   varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa                 varchar(5),
@ReferenciaIS            varchar(100),
@SubReferencia           varchar(100),
@InventarioID            int,
@Texto                   xml
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @InventarioID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'InventarioID'
SET @Empresa = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @InventarioID = ISNULL(@InventarioID,0)
IF @InventarioID > 0
BEGIN
DECLARE @Tabla Table(
Renglon                   float,
RenglonSub                int,
RenglonID                 int,
PosicionReal              varchar(10),
PosicionRealDescripcion   varchar(100),
Almacen                   varchar(10),
Tarima                    varchar(20),
Articulo                  varchar(20),
SubCuenta                 varchar(50),
Descripcion1              varchar(100),
Cantidad                  float,
Unidad                    varchar(50),
Factor                    float,
CantidadInventario        float,
ArticuloTipo              varchar(20),
Movimiento                varchar(20)
)
INSERT INTO @Tabla(Renglon,RenglonSub,RenglonID,PosicionReal,Almacen,Tarima,Articulo,SubCuenta,Cantidad,Unidad,Factor,CantidadInventario)
SELECT ISNULL(Renglon,0.0),
ISNULL(RenglonSub,0),
ISNULL(RenglonID,0),
ISNULL(PosicionReal,''),
ISNULL(Almacen,''),
ISNULL(Tarima,''),
ISNULL(Articulo,''),
ISNULL(SubCuenta,''),
ISNULL(Cantidad,0.0),
ISNULL(Unidad,''),
ISNULL(Factor,0.0),
ISNULL(CantidadInventario,0.0)
FROM InvD
WHERE ID = @InventarioID
DELETE @Tabla WHERE LTRIM(RTRIM(ISNULL(PosicionReal,''))) = ''
DELETE @Tabla WHERE LTRIM(RTRIM(ISNULL(Tarima,''))) = ''
UPDATE @Tabla
SET Movimiento = Mov
FROM Inv
WHERE ID = @InventarioID
UPDATE @Tabla
SET Descripcion1 = ISNULL(b.Descripcion1, ''),
ArticuloTipo = ISNULL(b.Tipo, '')
FROM @Tabla a
INNER JOIN Art b ON (a.Articulo = b.Articulo)
UPDATE @Tabla
SET PosicionRealDescripcion = ISNULL(b.Descripcion, '')
FROM @Tabla a
INNER JOIN AlmPos b ON (a.PosicionReal = b.Posicion)
SELECT @Texto = (SELECT CAST(ISNULL(Renglon,0) AS varchar)            AS Renglon,
CAST(ISNULL(RenglonSub,0) AS varchar)         AS RenglonSub,
CAST(ISNULL(RenglonID,0) AS varchar)          AS RenglonID,
ISNULL(PosicionReal,'')                       AS PosicionReal,
ISNULL(PosicionRealDescripcion,'')            AS PosicionRealDescripcion,
ISNULL(Almacen,'')                            AS Almacen,
ISNULL(Tarima,'')                             AS Tarima,
ISNULL(Articulo,'')                           AS Articulo,
ISNULL(SubCuenta,'')                          AS SubCuenta,
ISNULL(Descripcion1,'')                       AS Descripcion1,
CAST(ISNULL(Cantidad,0) AS varchar)           AS Cantidad,
ISNULL(Unidad,'')                             AS Unidad,
CAST(ISNULL(Factor,0) AS varchar)             AS Factor,
CAST(ISNULL(CantidadInventario,0) AS varchar) AS CantidadInventario,
ISNULL(ArticuloTipo,'')                       AS ArticuloTipo,
ISNULL(Movimiento,'')                         AS Movimiento
FROM @Tabla AS TMA
FOR XML AUTO)
END
ELSE
BEGIN
SET @Ok = 10160
END
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @Ok IS NOT NULL
SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

