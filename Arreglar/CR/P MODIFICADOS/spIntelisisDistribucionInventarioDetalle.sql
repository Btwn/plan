SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisDistribucionInventarioDetalle
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
ID                   int,
Movimiento           varchar(20),
MovimientoID         varchar(20),
Renglon              float,
RenglonSub           int,
RenglonID            int,
Almacen              varchar(10),
Articulo             varchar(20),
Codigo               varchar(30),
SubCuenta            varchar(50),
Descripcion1         varchar(100),
Descripcion2         varchar(255),
NombreCorto          varchar(20),
Cantidad             float,
Unidad               varchar(50),
Factor               float,
CantidadInventario   float,
Tipo                 varchar(20)
)
INSERT INTO @Tabla(ID, Renglon,RenglonSub,RenglonID,Almacen,Articulo,SubCuenta,Cantidad,Unidad,Factor,CantidadInventario)
SELECT @InventarioID,
ISNULL(Renglon,0.0),
ISNULL(RenglonSub,0),
ISNULL(RenglonID,0),
ISNULL(Almacen,''),
ISNULL(Articulo,''),
ISNULL(SubCuenta,''),
ISNULL(Cantidad,0.0),
ISNULL(Unidad,''),
ISNULL(Factor,0.0),
ISNULL(CantidadInventario,0.0)
FROM InvD
WITH(NOLOCK) WHERE ID = @InventarioID
UPDATE @Tabla
SET Movimiento = b.Mov,
MovimientoID = b.MovID
FROM @tabla a
INNER JOIN Inv b  WITH(NOLOCK) ON (a.ID = b.ID)
UPDATE @Tabla
SET Descripcion1 = ISNULL(b.Descripcion1, ''),
Descripcion2 = ISNULL(b.Descripcion2, ''),
NombreCorto  = ISNULL(b.NombreCorto, ''),
Tipo         = ISNULL(b.Tipo, '')
FROM @Tabla a
INNER JOIN Art b  WITH(NOLOCK) ON (a.Articulo = b.Articulo)
UPDATE @Tabla
SET Codigo = ISNULL(b.Codigo, '')
FROM @Tabla a
INNER JOIN CB b  WITH(NOLOCK) ON (a.Articulo = b.Cuenta AND ISNULL(a.SubCuenta,'') = ISNULL(b.SubCuenta,'') AND a.Unidad = b.Unidad)
WHERE b.TipoCuenta = 'Articulos'
SELECT @Texto = (SELECT LTRIM(RTRIM(ISNULL(Movimiento,'')))           AS Movimiento,
LTRIM(RTRIM(ISNULL(MovimientoID,'')))         AS MovimientoID,
CAST(ISNULL(Renglon,0) AS varchar)            AS Renglon,
CAST(ISNULL(RenglonSub,0) AS varchar)         AS RenglonSub,
CAST(ISNULL(RenglonID,0) AS varchar)          AS RenglonID,
LTRIM(RTRIM(ISNULL(Almacen,'')))              AS Almacen,
LTRIM(RTRIM(ISNULL(Articulo,'')))             AS Articulo,
LTRIM(RTRIM(ISNULL(Codigo,'')))               AS Codigo,
LTRIM(RTRIM(ISNULL(SubCuenta,'')))            AS SubCuenta,
LTRIM(RTRIM(ISNULL(Descripcion1,'')))         AS Descripcion1,
LTRIM(RTRIM(ISNULL(Descripcion2,'')))         AS Descripcion2,
LTRIM(RTRIM(ISNULL(NombreCorto,'')))          AS NombreCorto,
CAST(ISNULL(Cantidad,0) AS varchar)           AS Cantidad,
LTRIM(RTRIM(ISNULL(Unidad,'')))               AS Unidad,
CAST(ISNULL(Factor,1) AS varchar)             AS Factor,
CAST(ISNULL(CantidadInventario,0) AS varchar) AS CantidadInventario,
LTRIM(RTRIM(ISNULL(Tipo,'')))                 AS Tipo
FROM @Tabla AS Tabla
FOR XML AUTO)
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
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

