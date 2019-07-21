SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisDistribucionOrdenCompraDetalle
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
@OrdenCompraID                     int,
@Texto                             xml
DECLARE
@CfgCompraRecibirDemas             bit,
@CfgCompraRecibirDemasTolerancia   float,
@CfgRecibirDemasSinLimites         bit
DECLARE
@idx                               int,
@Articulo                          varchar(20),
@SubCuenta                         varchar(50),
@Unidad                            varchar(50),
@Codigo                            varchar(30),
@CodigoTmp                         varchar(30)
DECLARE @TablaCB table(
Codigo                             varchar(30)
)
DECLARE @Tabla Table(
IDX                                int identity (1,1),
ID                                 int,
Movimiento                         varchar(20),
MovimientoID                       varchar(20),
Renglon                            float,
RenglonSub                         int,
RenglonID                          int,
Almacen                            varchar(10),
Articulo                           varchar(20),
Codigo                             varchar(max),
SubCuenta                          varchar(50),
Descripcion1                       varchar(100),
Descripcion2                       varchar(255),
NombreCorto                        varchar(20),
Cantidad                           float,
CantidadPendiente                  float,
CantidadA                          float,
CantidadMaxima                     float,
Unidad                             varchar(50),
Factor                             float,
CantidadInventario                 float,
Tipo                               varchar(20)
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @OrdenCompraID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'OrdenCompraID'
SET @Empresa = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @OrdenCompraID = ISNULL(@OrdenCompraID,0)
IF @OrdenCompraID > 0
BEGIN
SELECT @CfgCompraRecibirDemas = ISNULL(CompraRecibirDemas,0),
@CfgCompraRecibirDemasTolerancia = ISNULL(CompraRecibirDemasTolerancia,0)
FROM EmpresaCfg2 WHERE Empresa = @Empresa
IF @CfgCompraRecibirDemas = 1 AND @CfgCompraRecibirDemasTolerancia = 0
SET @CfgRecibirDemasSinLimites = 1
ELSE
SET @CfgRecibirDemasSinLimites = 0
INSERT INTO @Tabla(ID, Renglon, RenglonSub, RenglonID, Almacen, Articulo, SubCuenta, Cantidad, CantidadPendiente, Unidad, Factor)
SELECT @OrdenCompraID,
ISNULL(Renglon,0.0),
ISNULL(RenglonSub,0),
ISNULL(RenglonID,0),
ISNULL(Almacen,''),
LTRIM(RTRIM(ISNULL(Articulo,''))),
LTRIM(RTRIM(ISNULL(SubCuenta,''))),
ISNULL(Cantidad,0.0),
ISNULL(CantidadPendiente,0.0),
ISNULL(Unidad,''),
ISNULL(Factor,0.0)
FROM CompraD
WITH(NOLOCK) WHERE ID = @OrdenCompraID
UPDATE @Tabla
SET Movimiento = b.Mov,
MovimientoID = b.MovID
FROM @tabla a
INNER JOIN Compra b  WITH(NOLOCK) ON (a.ID = b.ID)
UPDATE @Tabla
SET Descripcion1 = ISNULL(b.Descripcion1, ''),
Descripcion2 = ISNULL(b.Descripcion2, ''),
NombreCorto  = ISNULL(b.NombreCorto, ''),
Tipo         = ISNULL(b.Tipo, '')
FROM @Tabla a
INNER JOIN Art b  WITH(NOLOCK) ON (a.Articulo = b.Articulo)
DECLARE OrdenCompraDetalle_cursor CURSOR FOR SELECT IDX, Articulo, SubCuenta, Unidad FROM @Tabla
OPEN OrdenCompraDetalle_cursor
FETCH NEXT FROM OrdenCompraDetalle_cursor INTO @idx, @Articulo, @Subcuenta, @Unidad
WHILE @@FETCH_STATUS = 0
BEGIN
DELETE @TablaCB
INSERT INTO @TablaCB (Codigo)
SELECT LTRIM(RTRIM(ISNULL(Codigo,'')))
FROM CB
WITH(NOLOCK) WHERE TipoCuenta = 'Articulos'
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
UPDATE @Tabla SET Codigo = @CodigoTmp WHERE IDX = @idx
END
FETCH NEXT FROM OrdenCompraDetalle_cursor INTO @idx, @Articulo, @Subcuenta, @Unidad
END
CLOSE OrdenCompraDetalle_cursor
DEALLOCATE OrdenCompraDetalle_cursor
IF @CfgCompraRecibirDemas = 0
BEGIN
UPDATE @Tabla SET CantidadMaxima = Cantidad
END
ELSE
BEGIN
IF @CfgRecibirDemasSinLimites = 1
UPDATE @Tabla SET CantidadMaxima = 0  
ELSE
UPDATE @Tabla SET CantidadMaxima = CAST(Cantidad * (1 + (@CfgCompraRecibirDemasTolerancia / 100)) AS int)
END
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
CAST(ISNULL(CantidadPendiente,0) AS varchar)  AS CantidadPendiente,
CAST(ISNULL(CantidadA,0) AS varchar)          AS CantidadA,
CAST(ISNULL(CantidadMaxima,0) AS varchar)     AS CantidadMaxima,
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
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @ReferenciaIS = Referencia FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

