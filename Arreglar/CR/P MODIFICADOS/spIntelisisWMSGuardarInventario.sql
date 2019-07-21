SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSGuardarInventario
@ID                        int,
@iSolicitud                int,
@Version                   float,
@Resultado                 varchar(max) = NULL OUTPUT,
@Ok                        int = NULL OUTPUT,
@OkRef                     varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto                   xml,
@ReferenciaIS            varchar(100),
@SubReferencia           varchar(100),
@Empresa                 varchar(5),
@Sucursal                int,
@Usuario                 varchar(10),
@xml                     xml
DECLARE
@Renglon                 float,
@RenglonSub              int,
@RenglonID               int,
@RenglonTipo	           char(1),
@Cantidad                float,
@CantidadInventario      float,
@Almacen                 varchar(10),
@Factor                  float,
@Posicion                varchar(10),
@Tarima                  varchar(20)
DECLARE
@InventarioID            int,
@FechaRequerida          datetime,
@Proveedor               varchar(10),
@Articulo                varchar(20),
@SubCuenta               varchar(50),
@Unidad                  varchar(50),
@Codigo                  varchar(30),
@TipoCosteo              varchar(10),
@MonedaCosto             varchar(10),
@TipoCambio              float,
@Costo                   money,
@idx                     int,
@k                       int
DECLARE @TablaInvD table(
IDX                      int identity (1,1),
ID                       int,
Renglon                  float,
RenglonSub               int,
RenglonID                int,
Cantidad                 float,
Almacen                  varchar(10),
Articulo                 varchar(20),
Codigo                   varchar(30),
Subcuenta                varchar(20),
Costo                    money,
FechaRequerida           datetime,
Unidad                   varchar(50),
Factor                   float,
Posicion                 varchar(10),
Tarima                   varchar(20)
)
DECLARE @Tabla Table(
Mensaje                    varchar(255)
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Sucursal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SELECT @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SELECT @InventarioID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'InventarioID'
SET @Empresa  = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Sucursal = LTRIM(RTRIM(ISNULL(@Sucursal,0)))
SET @Usuario  = LTRIM(RTRIM(ISNULL(@Usuario,'')))
SET @InventarioID  = LTRIM(RTRIM(ISNULL(@InventarioID,0)))
SET @Proveedor = NULL
SET @SubCuenta = NULL
INSERT INTO @TablaInvD (ID, Renglon, RenglonSub, RenglonID, Cantidad, Almacen, Articulo, Codigo, SubCuenta, Unidad, Factor, Posicion, Tarima)
SELECT ID, Renglon, RenglonSub, RenglonID, Cantidad, Almacen, Articulo, Codigo, Subcuenta, Unidad, Factor, Posicion, Tarima
FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Tabla')
WITH (ID          int           '@ID',
Renglon     float         '@Renglon',
RenglonSub  int           '@RenglonSub',
RenglonID   int           '@RenglonID',
Cantidad    float         '@Cantidad',
Almacen     varchar (10)  '@Almacen',
Articulo    varchar (20)  '@Articulo',
Codigo      varchar (30)  '@Codigo',
Subcuenta   varchar (50)  '@Subcuenta',
Unidad      varchar (50)  '@Unidad',
Factor      float         '@Factor',
Posicion    varchar (10)  '@Posicion',
Tarima      varchar (20)  '@Tarima');
DECLARE TablaInvD_cursor CURSOR FOR SELECT IDX, Renglon, RenglonSub, RenglonID, Cantidad, Factor, Posicion, Tarima FROM @TablaInvD
OPEN TablaInvD_cursor
FETCH NEXT FROM TablaInvD_cursor INTO @idx, @Renglon, @RenglonSub, @RenglonID, @Cantidad, @Factor, @Posicion, @Tarima
WHILE @@FETCH_STATUS = 0
BEGIN
IF ISNULL(@Factor,0) = 0 SET @Factor = 1
IF @Renglon > 0
BEGIN
UPDATE InvD
 WITH(ROWLOCK) SET Cantidad = ISNULL(@Cantidad,0),
CantidadInventario = ISNULL(@Cantidad,0) * ISNULL(@Factor,1)
WHERE ID = @InventarioID
AND Renglon = @Renglon
AND RenglonSub = @RenglonSub
AND RenglonID = @RenglonID
END
ELSE
BEGIN
SELECT @Articulo  = Articulo,
@SubCuenta = Subcuenta
FROM @TablaInvD
WHERE IDX = @idx
SELECT @Unidad      = UnidadTraspaso,
@TipoCosteo  = TipoCosteo,
@MonedaCosto = MonedaCosto,
@RenglonTipo = UPPER(LEFT(Tipo,1))
FROM Art
WITH(NOLOCK) WHERE Articulo = @Articulo
SELECT @Factor = Factor
FROM ArtUnidad
WITH(NOLOCK) WHERE Articulo = @Articulo
AND Unidad = @Unidad
SET @Factor = ISNULL(@Factor,1)
SELECT @TipoCambio = TipoCambio
FROM Mon
WITH(NOLOCK) WHERE Moneda = @MonedaCosto
EXEC spVerCosto @sucursal, @Empresa, @Proveedor, @Articulo, @SubCuenta, @Unidad, @TipoCosteo, @MonedaCosto, @TipoCambio, @Costo OUTPUT, 0
SELECT @Renglon = Max(Renglon) FROM InvD WHERE ID = @InventarioID
SET @Renglon = ISNULL(@Renglon,0) + 2048
SET @RenglonSub = ISNULL(@RenglonSub,0)
SELECT @RenglonID = MAX(RenglonID) FROM InvD WHERE ID = @InventarioID
SET @RenglonID = ISNULL(@RenglonID,0) + 1
SELECT @FechaRequerida = Fechaemision,
@Almacen = Almacen
FROM Inv
WITH(NOLOCK) WHERE ID = @InventarioID
SET @CantidadInventario = ISNULL(@Cantidad,0) * ISNULL(@Factor,1)
INSERT INTO InvD (ID, Renglon, RenglonSub, RenglonID, Cantidad, Codigo, Almacen, Articulo, Costo, FechaRequerida, Unidad, Factor, CantidadInventario, Sucursal, SucursalOrigen, RenglonTipo, Tarima, PosicionActual, PosicionReal)
VALUES (@InventarioID, @Renglon, @RenglonSub, @RenglonID, @Cantidad, @Codigo, @Almacen, @Articulo, @Costo, @FechaRequerida, @Unidad, @Factor, @CantidadInventario, @Sucursal, @Sucursal , @RenglonTipo, @Tarima, @Posicion, @Posicion)
END
FETCH NEXT FROM TablaInvD_cursor INTO @idx, @Renglon, @RenglonSub, @RenglonID, @Cantidad, @Factor, @Posicion, @Tarima
END
CLOSE TablaInvD_cursor
DEALLOCATE TablaInvD_cursor
SELECT @idx = MAX(IDX) FROM @TablaInvD
INSERT INTO @Tabla (Mensaje) VALUES (CAST(ISNULL(@idx,0) AS varchar) + ' registros actualizados.')
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @Texto = (SELECT LTRIM(RTRIM(ISNULL(Mensaje,''))) AS Mensaje
FROM @Tabla AS Tabla
FOR XML AUTO)
SELECT @ReferenciaIS = Referencia FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

