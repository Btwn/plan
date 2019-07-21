SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSInfoDetalleMovCOMS_O
@ID                      int,
@iSolicitud              int,
@Version                 float,
@Resultado               varchar(max) = NULL OUTPUT,
@Ok                      int = NULL OUTPUT,
@OkRef                   varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa                 varchar(5),
@Mov                     varchar(20),
@MovID                   varchar(20),
@ID2                     int,
@Tolerancia              float,
@CaducidadMinima         int,
@FechaHoy                datetime,
@Fecha                   datetime,
@Unidad                  varchar(50),
@Codigo                  varchar(30),
@idx                     int,
@Articulo                varchar(20),
@ReferenciaIS            varchar(100),
@SubReferencia           varchar(100),
@Texto                   xml
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Mov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mov'
SELECT @MovID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovID'
SET @Empresa  = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Mov      = LTRIM(RTRIM(ISNULL(@Mov,'')))
SET @MovID    = LTRIM(RTRIM(ISNULL(@MovID,'')))
SET @FechaHoy = dbo.fnFechaSinHora(GETDATE())
SELECT @ID2   = ID FROM Compra WHERE Mov = @Mov AND MovID = @MovID
SELECT @Tolerancia = ISNULL(CompraRecibirDemasTolerancia,0)
FROM EmpresaCfg2
WHERE Empresa = @Empresa
AND CompraRecibirDemas = 1
SET @Tolerancia = ISNULL(@Tolerancia,0)
IF @ID2 > 0
BEGIN
DECLARE @Tabla Table(
idx                  int IDENTITY(1,1),
Renglon              float,
RenglonSub           int,
RenglonID            int,
Articulo             varchar(20),
SubCuenta            varchar(50),
Descripcion1         varchar(100),
Cantidad             float,
CantidadPendiente    float,
CantidadCancelada    float,
CantidadA            float,
CantidadInventario   float,
CantidadMaxima       float,
FechaCaducidadMinima varchar(8),
Unidad               varchar(50),
Codigo               varchar(30),
Factor               float,
Tipo                 varchar(20),
SerieLoteInfo        int
)
INSERT INTO @Tabla(Renglon,RenglonSub,RenglonID,Articulo,SubCuenta,Cantidad,CantidadPendiente,CantidadCancelada,CantidadA,CantidadInventario,CantidadMaxima,Unidad,Factor)
SELECT ISNULL(Renglon,0),
ISNULL(RenglonSub,0),
ISNULL(RenglonID,0),
ISNULL(Articulo,''),
ISNULL(SubCuenta,''),
ISNULL(Cantidad,0.0),
ISNULL(CantidadPendiente,0.0),
ISNULL(CantidadCancelada,0.0),
ISNULL(CantidadA,0.0),
ISNULL(CantidadInventario,0.0),
ISNULL(Cantidad,0.0),
ISNULL(Unidad,''),
ISNULL(Factor,0.0)
FROM CompraD
WHERE ID = @ID2
IF @Tolerancia > 0
BEGIN
UPDATE @Tabla SET CantidadMaxima = ROUND((CantidadPendiente - CantidadCancelada) * ((100 + @Tolerancia) / 100), 0)
END
ELSE
BEGIN
UPDATE @Tabla SET CantidadMaxima = ROUND((CantidadPendiente - CantidadCancelada), 0)
END
UPDATE @Tabla
SET Descripcion1  = ISNULL(b.Descripcion1,''),
Tipo          = ISNULL(b.Tipo,'Normal'),
SerieLoteInfo = ISNULL(b.SerieLoteInfo,0)
FROM @Tabla a
INNER JOIN Art b ON (a.Articulo = b.Articulo)
DECLARE InfoDetalle_cr CURSOR FOR SELECT idx,Articulo,Unidad FROM @Tabla
OPEN InfoDetalle_cr
FETCH NEXT FROM InfoDetalle_cr INTO @idx, @Articulo, @Unidad
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @CaducidadMinima = CaducidadMinima
FROM Art
WHERE Articulo = @Articulo
AND TieneCaducidad = 1
AND ControlArticulo = 'Caducidad'
SET @CaducidadMinima = ISNULL(@CaducidadMinima,0)
IF @CaducidadMinima > 0
BEGIN
SET @Fecha = DATEADD(day, @CaducidadMinima, @FechaHoy)
UPDATE @Tabla
SET FechaCaducidadMinima = CAST(DATEPART(YEAR,@Fecha) AS VARCHAR) + RIGHT('00' + CAST(DATEPART(MONTH,@Fecha) AS VARCHAR) ,2) + RIGHT('00' + CAST(DATEPART(DAY,@Fecha) AS VARCHAR),2)
WHERE idx = @idx
END
SELECT @Codigo = Codigo
FROM CB
WHERE TipoCuenta = 'Articulos'
AND Cuenta = @Articulo
AND Unidad = @Unidad
UPDATE @Tabla SET Codigo = ISNULL(@Codigo,'') WHERE idx = @idx
FETCH NEXT FROM InfoDetalle_cr INTO @idx, @Articulo, @Unidad
END
CLOSE InfoDetalle_cr
DEALLOCATE InfoDetalle_cr
SELECT @Texto = (SELECT CAST(Renglon AS varchar)            AS Renglon,
CAST(RenglonSub AS varchar)         AS RenglonSub,
CAST(RenglonID AS varchar)          AS RenglonID,
ISNULL(Articulo,'')                 AS Articulo,
ISNULL(SubCuenta,'')                AS SubCuenta,
ISNULL(Descripcion1,'')             AS Descripcion1,
CAST(Cantidad AS varchar)           AS Cantidad,
CAST(CantidadPendiente AS varchar)  AS CantidadPendiente,
CAST(CantidadCancelada AS varchar)  AS CantidadCancelada,
CAST(CantidadA AS varchar)          AS CantidadA,
CAST(CantidadInventario AS varchar) AS CantidadInventario,
CAST(CantidadMaxima AS varchar)     AS CantidadMaxima,
ISNULL(FechaCaducidadMinima,'')     AS FechaCaducidadMinima,
ISNULL(Unidad,'')                   AS Unidad,
ISNULL(Codigo,'')                   AS Codigo,
CAST(Factor AS varchar)             AS Factor,
ISNULL(Tipo,'')                     AS Tipo,
CAST(SerieLoteInfo AS varchar)      AS SerieLoteInfo
FROM @Tabla AS TMA
FOR XML AUTO)
END
ELSE
BEGIN
SET @Ok = 10160
END
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @ReferenciaIS = Referencia FROM IntelisisService WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
END

