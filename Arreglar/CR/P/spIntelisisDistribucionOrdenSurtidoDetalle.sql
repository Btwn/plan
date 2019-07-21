SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisDistribucionOrdenSurtidoDetalle
@ID                                int,
@iSolicitud                        int,
@Version                           float,
@Resultado                         varchar(max) = NULL OUTPUT,
@Ok                                int = NULL OUTPUT,
@OkRef                             varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa                           varchar(5),
@ReferenciaIS                      varchar(100),
@SubReferencia                     varchar(100),
@OrdenSurtidoID                    int,
@Texto                             xml
DECLARE
@IDR                               int,
@Articulo                          varchar(20),
@SubCuenta                         varchar(50),
@DescripcionSubCuenta              varchar(1000),
@Unidad                            varchar(50),
@Codigo                            varchar(30),
@CodigoTmp                         varchar(30),
@RenglonID                         int,
@Opcion                            varchar (20),
@Juego                             varchar(10),
@DescripcionJuego                  varchar(100),
@CantidadJuego                     float,
@SubCuentaOpcion                   varchar(50)
DECLARE @TablaCB table(
Codigo                             varchar(30)
)
DECLARE @Tabla Table(
IDR                                int identity (1,1),
ID                                 int,
Movimiento                         varchar(20),
MovimientoID                       varchar(20),
Renglon                            float,
RenglonSub                         int,
RenglonID                          int,
RenglonTipo                        char(1),
Almacen                            varchar(10),
Articulo                           varchar(20),
Codigo                             varchar(max),
SubCuenta                          varchar(50),
Descripcion1                       varchar(100),
Descripcion2                       varchar(255),
NombreCorto                        varchar(20),
DescripcionSubCuenta               varchar(1000),
Cantidad                           float,
CantidadPendiente                  float,
CantidadA                          float,
CantidadMaxima                     float,
Unidad                             varchar(50),
Factor                             float,
CantidadInventario                 float,
Tipo                               varchar(20),
TipoOpcion                         varchar(20),
Juego                              varchar(10),
DescripcionJuego                   varchar(100),
CantidadJuego                      float,
Opcion                             varchar(20),
SubCuentaOpcion                    varchar(50),
DescripcionSubCuentaOpcion         varchar(1000)
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @OrdenSurtidoID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'OrdenSurtidoID'
SET @Empresa = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @OrdenSurtidoID = ISNULL(@OrdenSurtidoID,0)
IF @OrdenSurtidoID > 0
BEGIN
INSERT INTO @Tabla(ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Almacen, Articulo, SubCuenta, Cantidad, CantidadPendiente, Unidad, Factor)
SELECT @OrdenSurtidoID,
ISNULL(Renglon,0.0),
ISNULL(RenglonSub,0),
ISNULL(RenglonID,0),
ISNULL(RenglonTipo,'N'),
ISNULL(Almacen,''),
LTRIM(RTRIM(ISNULL(Articulo,''))),
LTRIM(RTRIM(ISNULL(SubCuenta,''))),
ISNULL(Cantidad,0.0),
ISNULL(CantidadPendiente,0.0) + ISNULL(CantidadReservada,0.0),
ISNULL(Unidad,''),
ISNULL(Factor,0.0)
FROM VentaD
WHERE ID = @OrdenSurtidoID
UPDATE @Tabla
SET Movimiento = b.Mov,
MovimientoID = b.MovID
FROM @tabla a
INNER JOIN Venta b ON (a.ID = b.ID)
UPDATE @Tabla
SET Descripcion1 = ISNULL(b.Descripcion1, ''),
Descripcion2 = ISNULL(b.Descripcion2, ''),
NombreCorto  = ISNULL(b.NombreCorto, ''),
Tipo         = ISNULL(b.Tipo, ''),
TipoOpcion   = ISNULL(b.TipoOpcion, '')
FROM @Tabla a
INNER JOIN Art b ON (a.Articulo = b.Articulo)
UPDATE @Tabla SET CantidadMaxima = CantidadPendiente
UPDATE @Tabla SET DescripcionSubCuenta = dbo.fnDescribirOpciones(Subcuenta)
DECLARE OrdenSurtidoDetalle_cursor CURSOR FOR SELECT IDR, Articulo, SubCuenta, Unidad FROM @Tabla
OPEN OrdenSurtidoDetalle_cursor
FETCH NEXT FROM OrdenSurtidoDetalle_cursor INTO @IDR, @Articulo, @Subcuenta, @Unidad
WHILE @@FETCH_STATUS = 0
BEGIN
DELETE @TablaCB
INSERT INTO @TablaCB (Codigo)
SELECT LTRIM(RTRIM(ISNULL(Codigo,'')))
FROM CB
WHERE TipoCuenta = 'Articulos'
AND Cuenta = @Articulo
AND LTRIM(RTRIM(ISNULL(SubCuenta,''))) = @SubCuenta
AND Unidad = @Unidad
SET @CodigoTmp = ''
DECLARE TablaCB_cursor CURSOR FOR SELECT Codigo FROM @TablaCB
OPEN TablaCB_cursor
FETCH NEXT FROM TablaCB_cursor INTO @Codigo
WHILE @@FETCH_STATUS = 0
BEGIN
SET @CodigoTmp = @CodigoTmp + @Codigo + '~'
FETCH NEXT FROM TablaCB_cursor INTO @Codigo
END
CLOSE TablaCB_cursor
DEALLOCATE TablaCB_cursor
IF LEN(@CodigoTmp) > 0
BEGIN
SET @CodigoTmp = LEFT(@CodigoTmp, (LEN(@CodigoTmp) - 1))
UPDATE @Tabla SET Codigo = @CodigoTmp WHERE IDR = @IDR
END
FETCH NEXT FROM OrdenSurtidoDetalle_cursor INTO @IDR, @Articulo, @Subcuenta, @Unidad
END
CLOSE OrdenSurtidoDetalle_cursor
DEALLOCATE OrdenSurtidoDetalle_cursor
DECLARE OrdenSurtidoDetalleJuego_cursor CURSOR FOR SELECT IDR, RenglonID, Articulo FROM @Tabla WHERE RenglonTipo = 'J'
OPEN OrdenSurtidoDetalleJuego_cursor
FETCH NEXT FROM OrdenSurtidoDetalleJuego_cursor INTO @IDR, @RenglonID, @Articulo
WHILE @@FETCH_STATUS = 0
BEGIN
DECLARE Juego_cursor CURSOR FOR SELECT Articulo FROM @Tabla WHERE RenglonID = @RenglonID AND RenglonTipo = 'C'
OPEN Juego_cursor
FETCH NEXT FROM Juego_cursor INTO @Opcion
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT TOP 1 @Juego = Juego, @SubCuentaOpcion = SubCuenta
FROM ArtJuegoD
WHERE Articulo = @Articulo
AND Opcion = @Opcion
UPDATE @Tabla
SET Juego = @Juego,
Opcion = @Opcion,
SubCuentaOpcion = @SubCuentaOpcion
WHERE RenglonID = @RenglonID
AND Articulo = @Opcion
SELECT @DescripcionJuego = Descripcion,
@CantidadJuego = Cantidad
FROM ArtJuego
WHERE articulo = @Articulo
AND Juego = @Juego
UPDATE @Tabla
SET DescripcionJuego = @DescripcionJuego,
CantidadJuego = @CantidadJuego
WHERE RenglonID = @RenglonID
AND Articulo = @Opcion
UPDATE @Tabla SET DescripcionSubCuentaOpcion = dbo.fnDescribirOpciones(SubCuentaOpcion)
WHERE RenglonID = @RenglonID
AND RenglonTipo = 'C'
AND LTRIM(RTRIM(ISNULL(DescripcionSubCuentaOpcion,''))) <> ''
FETCH NEXT FROM Juego_cursor INTO @Opcion
END
CLOSE Juego_cursor
DEALLOCATE Juego_cursor
FETCH NEXT FROM OrdenSurtidoDetalleJuego_cursor INTO @IDR, @RenglonID, @Articulo
END
CLOSE OrdenSurtidoDetalleJuego_cursor
DEALLOCATE OrdenSurtidoDetalleJuego_cursor
SELECT @Texto = (SELECT LTRIM(RTRIM(ISNULL(Movimiento,'')))                 AS Movimiento,
LTRIM(RTRIM(ISNULL(MovimientoID,'')))               AS MovimientoID,
CAST(ISNULL(Renglon,0) AS varchar)                  AS Renglon,
CAST(ISNULL(RenglonSub,0) AS varchar)               AS RenglonSub,
CAST(ISNULL(RenglonID,0) AS varchar)                AS RenglonID,
LTRIM(RTRIM(ISNULL(RenglonTipo,'N')))               AS RenglonTipo,
LTRIM(RTRIM(ISNULL(Almacen,'')))                    AS Almacen,
LTRIM(RTRIM(ISNULL(Articulo,'')))                   AS Articulo,
LTRIM(RTRIM(ISNULL(Codigo,'')))                     AS Codigo,
LTRIM(RTRIM(ISNULL(SubCuenta,'')))                  AS SubCuenta,
LTRIM(RTRIM(ISNULL(Descripcion1,'')))               AS Descripcion1,
LTRIM(RTRIM(ISNULL(Descripcion2,'')))               AS Descripcion2,
LTRIM(RTRIM(ISNULL(NombreCorto,'')))                AS NombreCorto,
LTRIM(RTRIM(ISNULL(DescripcionSubCuenta,'')))       AS DescripcionSubCuenta,
CAST(ISNULL(Cantidad,0) AS varchar)                 AS Cantidad,
CAST(ISNULL(CantidadPendiente,0) AS varchar)        AS CantidadPendiente,
CAST(ISNULL(CantidadA,0) AS varchar)                AS CantidadA,
CAST(ISNULL(CantidadMaxima,0) AS varchar)           AS CantidadMaxima,
LTRIM(RTRIM(ISNULL(Unidad,'')))                     AS Unidad,
CAST(ISNULL(Factor,1) AS varchar)                   AS Factor,
CAST(ISNULL(CantidadInventario,0) AS varchar)       AS CantidadInventario,
LTRIM(RTRIM(ISNULL(Tipo,'')))                       AS Tipo,
LTRIM(RTRIM(ISNULL(TipoOpcion,'')))                 AS TipoOpcion,
LTRIM(RTRIM(ISNULL(Juego,'')))                      AS Juego,
LTRIM(RTRIM(ISNULL(DescripcionJuego,'')))           AS DescripcionJuego,
CAST(ISNULL(CantidadJuego,0) AS varchar)            AS CantidadJuego,
LTRIM(RTRIM(ISNULL(Opcion,'')))                     AS Opcion,
LTRIM(RTRIM(ISNULL(SubCuentaOpcion,'')))            AS SubCuentaOpcion,
LTRIM(RTRIM(ISNULL(DescripcionSubCuentaOpcion,''))) AS DescripcionSubCuentaOpcion
FROM @Tabla AS Tabla
ORDER BY IDR
FOR XML AUTO)
END
ELSE
BEGIN
SET @Ok = 10160
END
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @ReferenciaIS = Referencia FROM IntelisisService WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

