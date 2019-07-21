SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSValidarCB
@ID         int,
@iSolicitud int,
@Version    float,
@Resultado  varchar(max) = NULL OUTPUT,
@Ok         int = NULL OUTPUT,
@OkRef      varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa            varchar(5),
@Referencia         varchar(50),
@ID2                int,
@ModuloID           int,
@Mov                varchar(20),
@MovID              varchar(20),
@CB                 varchar(30),
@Anden              varchar(20),
@Articulo           varchar(20),
@SubCuenta          varchar(50),
@Texto              xml,
@ReferenciaIS       varchar(100),
@SubReferencia      varchar(100),
@UsuarioSucursal    bit,
@Cantidad           float,
@Caducidad          int,
@FechaCaducidad     datetime,
@Fecha              datetime,
@Sucursal           int,
@Cantidad2          float,
@Tipo               varchar(20),
@Serie              varchar(20),
@RenglonID          int,
@RenglonID2         int,
@Sustituir          varchar(5),
@TieneCaducidad     bit,
@Propiedades        varchar(20),
@UnidadCompra       varchar(20),
@Factor             float,
@Unidad             varchar(20),
@ArtSerieLoteInfo   bit,
@Renglon            float,
@RenglonSub         int,
@CantidadLote       float
DECLARE @Tabla Table(
Cuenta              varchar(20),
SubCuenta           varchar(50),
Descripcion         varchar(100),
Unidad              varchar(20),
TieneCaducidad      bit,
CaducidadMinima     int
)
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @ModuloID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModuloID'
SELECT @Mov= Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mov'
SELECT @MovID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovID'
SELECT @CB = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Codigo'
SELECT @Cantidad = CONVERT(float, Valor) FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro') 
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cantidad'
SELECT @Referencia = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Referencia'
SELECT @Serie = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Serie'
SELECT @Sustituir = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sustituir'
SELECT @TieneCaducidad = CONVERT(bit, Valor) FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TieneCaducidad'
SET @FechaCaducidad = NULL
IF @TieneCaducidad = 1
SELECT @FechaCaducidad = CONVERT(datetime, Valor) FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FechaCaducidad'
SELECT @Propiedades = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Propiedades'
SELECT @Renglon = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Renglon'
SELECT @RenglonSub = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RenglonSub'
SELECT @RenglonID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RenglonID'
INSERT @Tabla(Cuenta,SubCuenta,Descripcion,Unidad,TieneCaducidad,CaducidadMinima)
SELECT c.Cuenta,c.SubCuenta,a.Descripcion1,c.Unidad,a.TieneCaducidad,a.CaducidadMinima
FROM CB c
JOIN Art a ON c.Cuenta = a.Articulo
WHERE c.Codigo = @CB
SELECT @ID2 = ID,
@Sucursal = Sucursal
FROM Compra
WHERE ID = @ModuloID
IF ISNULL(@CB,'') = '' SET @Ok = 72043 
IF @Ok IS NULL AND NOT EXISTS(SELECT * FROM CB WHERE Codigo = @CB) SET @Ok = 72040
IF @Ok IS NULL
BEGIN
SELECT @Fecha = GETDATE()
SELECT @Articulo = Cuenta,
@SubCuenta = ISNULL(SubCuenta,''),
@UnidadCompra = Unidad
FROM CB
WHERE Codigo = @CB
SELECT @Caducidad = ISNULL(CaducidadMinima,0),
@Tipo = Tipo,
@ArtSerieLoteInfo = SerieLoteInfo
FROM Art
WHERE Articulo = @Articulo
IF NOT EXISTS(SELECT * FROM Compra c JOIN CompraD d ON c.ID = d.ID WHERE c.Empresa = @Empresa AND c.Mov = @Mov AND c.MovID = @MovID AND d.Articulo = @Articulo AND d.Unidad = @UnidadCompra)
SELECT @Ok =10530
IF @Ok IS NULL AND @TieneCaducidad = 1 AND @FechaCaducidad IS NULL SET @Ok = 25125
IF @Ok IS NULL AND @TieneCaducidad = 1 AND @FechaCaducidad < (@Fecha + @Caducidad) SET @Ok = 25126
IF @Ok IS NULL AND LTRIM(RTRIM(ISNULL(@Referencia,''))) = '' SET @Ok = 80201
BEGIN TRANSACTION
IF @OK IS NULL
BEGIN
UPDATE Compra SET Idioma = @Referencia WHERE ID = @ModuloID
UPDATE CompraD
SET FechaCaducidad = @FechaCaducidad
WHERE ID = @ModuloID
AND renglon = @Renglon
AND RenglonSub = @RenglonSub
AND RenglonID = @RenglonID
END
IF @Ok IS NULL 
BEGIN
SELECT @Cantidad2  = CantidadA
FROM CompraD
WHERE ID = @ModuloID
AND Renglon = @Renglon
AND RenglonSub = @RenglonSub
AND RenglonID = @RenglonID
IF UPPER(LTRIM(RTRIM(@Sustituir))) = 'SI'
BEGIN
IF @Tipo = 'Normal'
BEGIN
UPDATE CompraD
SET CantidadA = ISNULL(@Cantidad,0)
WHERE ID = @ModuloID
AND Renglon = @Renglon
AND RenglonSub = @RenglonSub
AND RenglonID = @RenglonID
END
IF @Tipo = 'Lote'
BEGIN
UPDATE SerieLoteMov
SET Cantidad = @Cantidad
WHERE Empresa = @Empresa
AND Modulo = 'COMS'
AND ID = @ModuloID
AND RenglonID = @RenglonID
AND Articulo = @Articulo
AND SubCuenta = @SubCuenta
AND SerieLote = @Serie
AND ISNULL(Propiedades,'') = ISNULL(@Propiedades,'')
IF NOT EXISTS(SELECT * FROM SerieLoteMov WHERE ID = @ModuloID AND RenglonID = @RenglonID AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND SerieLote = @Serie AND Modulo = 'COMS' AND Empresa = @Empresa AND ISNULL(Propiedades,'') = ISNULL(@Propiedades,''))
INSERT SerieLoteMov (Empresa, Modulo,   ID,  RenglonID,  Articulo,  SubCuenta, SerieLote,  Cantidad, CantidadAlterna, Propiedades,             Ubicacion, Cliente, Localizacion,  Sucursal, ArtCostoInv)
SELECT                    @Empresa,'COMS', @ID2, @RenglonID, @Articulo, @SubCuenta,    @Serie, @Cantidad,            NULL, ISNULL(@Propiedades,''),      NULL,    NULL,         NULL, @Sucursal,        NULL
SELECT @CantidadLote = SUM(ISNULL(Cantidad,0))
FROM SerieLoteMov
WHERE ID = @ModuloID
AND RenglonID = @RenglonID
AND Articulo = @Articulo
AND SubCuenta = @SubCuenta
AND SerieLote = @Serie
AND Modulo = 'COMS'
AND Empresa = @Empresa
AND ISNULL(Propiedades,'') = ISNULL(@Propiedades,'')
UPDATE CompraD
SET CantidadA = ISNULL(@CantidadLote,0)  
WHERE ID = @ModuloID
AND Renglon = @Renglon
AND RenglonSub = @RenglonSub
AND RenglonID = @RenglonID
END
IF @@ERROR <> 0 SET @Ok = 1
END
IF UPPER(LTRIM(RTRIM(@Sustituir))) = 'NO'
BEGIN
UPDATE CompraD
SET CantidadA = ISNULL(@Cantidad2,0.0) + @Cantidad
WHERE ID = @ModuloID
AND Renglon = @Renglon
AND RenglonSub = @RenglonSub
AND RenglonID = @RenglonID
IF @Tipo = 'Lote'
BEGIN
IF EXISTS(SELECT * FROM SerieLoteMov WHERE ID = @ModuloID AND RenglonID = @RenglonID AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND SerieLote = @Serie AND Modulo = 'COMS' AND Empresa = @Empresa AND ISNULL(Propiedades,'') = ISNULL(@Propiedades,''))
UPDATE SerieLoteMov SET Cantidad =  ISNULL(Cantidad,0) + ISNULL(@Cantidad,0)
WHERE ID = @ModuloID
AND RenglonID = @RenglonID
AND Articulo = @Articulo
AND SubCuenta = @SubCuenta
AND SerieLote = @Serie
AND Modulo = 'COMS'
AND Empresa = @Empresa
AND ISNULL(Propiedades,'') = ISNULL(@Propiedades,'')
ELSE
INSERT SerieLoteMov(
Empresa, Modulo, ID, RenglonID, Articulo,
SubCuenta, SerieLote, Cantidad, CantidadAlterna, Propiedades,
Ubicacion, Cliente, Localizacion, Sucursal, ArtCostoInv)
SELECT @Empresa, 'COMS', @ID2, @RenglonID, @Articulo,
@SubCuenta, @Serie, @Cantidad, NULL, ISNULL(@Propiedades,''),
NULL, NULL, NULL, @Sucursal, NULL
END
END
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
IF @Ok IS NULL AND @Tipo IN ('Serie', 'Lote') AND ISNULL(RTRIM(LTRIM(@Serie)),'') = '' AND @ArtSerieLoteInfo = 0 
SET @Ok = 20051
IF @Ok IS NULL AND @Cantidad NOT IN (0,1) AND @Tipo IN ('Serie') AND ISNULL(RTRIM(LTRIM(@Serie)),'') <> '' 
SET @Ok = 20332 
IF @Ok IS NULL AND @Tipo IN ('Serie', 'Lote') AND ISNULL(RTRIM(LTRIM(@Serie)),'') <> ''  
BEGIN
/*
SELECT @RenglonID = ISNULL(MAX(RenglonID),0) FROM SerieLoteMov WHERE Modulo = 'COMS' AND ID = @ID2 AND Articulo = @Articulo
IF @RenglonID = 0
SELECT @RenglonID = ISNULL(MAX(RenglonID),0) FROM SerieLoteMov WHERE Modulo = 'COMS' AND ID = @ID2
IF NOT EXISTS(SELECT * FROM SerieLoteMov WHERE Modulo = 'COMS' AND ID = @ID2 AND Articulo = @Articulo)
SELECT @RenglonID = @RenglonID + 1
*/
IF @Tipo IN ('Serie')
BEGIN
IF @Sustituir = 'No'
BEGIN
IF NOT EXISTS(SELECT * FROM SerieLoteMov WHERE ID = @ModuloID AND RenglonID = @RenglonID AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND SerieLote = @Serie AND Modulo = 'COMS' AND Empresa = @Empresa AND ISNULL(Propiedades,'') = ISNULL(@Propiedades,''))
INSERT SerieLoteMov (Empresa, Modulo,   ID,  RenglonID,  Articulo,  SubCuenta, SerieLote,  Cantidad, CantidadAlterna, Propiedades,            Ubicacion, Cliente, Localizacion,  Sucursal, ArtCostoInv)
SELECT                 @Empresa, 'COMS', @ID2, @RenglonID, @Articulo, @SubCuenta,    @Serie, @Cantidad,            NULL, ISNULL(@Propiedades,''),     NULL,    NULL,         NULL, @Sucursal,        NULL
ELSE
SELECT @Ok = 20080
END
END
END
END
END
SELECT @Texto =ISNULL((SELECT Cuenta, SubCuenta, Descripcion, TieneCaducidad, CaducidadMinima, @UnidadCompra as Unidad, @Sustituir as Sustituir FROM @Tabla ArtCB
FOR XML AUTO),'')
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
END
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),ISNULL(@Texto,'')) + '</Resultado></Intelisis>'
END

