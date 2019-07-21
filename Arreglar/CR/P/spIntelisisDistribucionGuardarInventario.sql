SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisDistribucionGuardarInventario
@ID                      int,
@iSolicitud              int,
@Version                 float,
@Resultado               varchar(max) = NULL OUTPUT,
@Ok                      int = NULL OUTPUT,
@OkRef                   varchar(255) = NULL OUTPUT

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
@InvID                   int,
@FechaRequerida          datetime,
@Proveedor               varchar(10),
@Articulo                varchar(20),
@SubCuenta               varchar(50),
@Unidad                  varchar(50),
@TipoCosteo              varchar(10),
@MonedaCosto             varchar(10),
@TipoCambio              float,
@Costo                   money,
@i                       int,
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
Subcuenta                varchar(50),
Costo                    money,
FechaRequerida           datetime,
Unidad                   varchar(50),
Factor                   float
)
DECLARE @Tabla Table(
Mensaje                  varchar(255)
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
SET @Empresa  = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Sucursal = LTRIM(RTRIM(ISNULL(@Sucursal,'')))
SET @Usuario  = LTRIM(RTRIM(ISNULL(@Usuario,'')))
SET @Proveedor = NULL
SET @SubCuenta = NULL
INSERT INTO @TablaInvD (ID, Renglon, RenglonSub, RenglonID, Cantidad, Almacen, Articulo, Codigo, SubCuenta, Unidad, Factor)
SELECT ID, Renglon, RenglonSub, RenglonID, Cantidad, Almacen, Articulo, Codigo, Subcuenta, Unidad, Factor
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
Factor      float         '@Factor');
SELECT @k = MAX(IDX) FROM @TablaInvD
SET    @k = ISNULL(@k, 0)
SET @i = 0
WHILE @i < @k
BEGIN
SET @i = @i + 1
SELECT @Articulo  = Articulo,
@SubCuenta = Subcuenta,
@Unidad    = Unidad
FROM @tablaInvD
WHERE IDX = @i
SELECT @TipoCosteo  = TipoCosteo,
@MonedaCosto = MonedaCosto
FROM Art
WHERE Articulo = @Articulo
SELECT @TipoCambio = TipoCambio
FROM Mon
WHERE Moneda = @MonedaCosto
EXEC spVerCosto @sucursal, @Empresa, @Proveedor, @Articulo, @SubCuenta, @Unidad, @TipoCosteo, @MonedaCosto, @TipoCambio, @Costo OUTPUT, 0
UPDATE @TablaInvD SET Costo = @Costo WHERE IDX = @i
END
SELECT @InvID = ID FROM @TablaInvD WHERE IDX = @k
SELECT @FechaRequerida = Fechaemision FROM Inv WHERE ID = @InvID
UPDATE @TablaInvD SET FechaRequerida = @FechaRequerida
MERGE INTO InvD t
USING @TablaInvD s
ON t.ID         = s.ID
AND t.Renglon    = s.Renglon
AND t.RenglonSub = s.RenglonSub
AND t.RenglonID  = s.RenglonID
WHEN MATCHED THEN
UPDATE
SET Cantidad           = s.Cantidad,
Codigo             = s.Codigo,
Costo              = s.Costo,
CantidadInventario = ISNULL(s.Cantidad, 0) * ISNULL(s.Factor, 1),
FechaRequerida     = s.FechaRequerida
WHEN NOT MATCHED BY TARGET THEN
INSERT(ID, Renglon, RenglonSub, RenglonID, Cantidad, Codigo, Almacen, Articulo, Costo, FechaRequerida, Unidad, Factor, CantidadInventario)
VALUES(s.ID, s.Renglon, s.RenglonSub, s.RenglonID, s.Cantidad, s.Codigo, s.Almacen, s.Articulo, s.Costo, s.FechaRequerida, s.Unidad, s.Factor, ISNULL(s.Cantidad, 0) * ISNULL(s.Factor, 1));
DELETE InvD WHERE ID = @InvID AND Cantidad = 0
INSERT INTO @Tabla (Mensaje) VALUES ('Inventario guardado con éxito.')
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
INSERT INTO @Tabla (Mensaje) VALUES (@OkRef)
END CATCH
SELECT @Texto = (SELECT LTRIM(RTRIM(ISNULL(Mensaje,''))) AS Mensaje
FROM @Tabla AS Tabla
FOR XML AUTO)
SELECT @ReferenciaIS = Referencia FROM IntelisisService WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

