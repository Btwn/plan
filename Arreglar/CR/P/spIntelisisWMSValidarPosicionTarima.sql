SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSValidarPosicionTarima
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
@Posicion                varchar(20),
@Tarima                  varchar(20),
@Articulo                varchar(20),
@TarimaCompleta          varchar(20),
@ID2                     int,
@Renglon                 int,
@RenglonID               int,
@Almacen                 varchar(20),
@Cantidad                float,
@SucursalOrigen          int,
@FechaRequerida          datetime,
@UnidadCompra            varchar(20),
@FormaCosteo             varchar(20),
@TipoCosteo              varchar(20),
@Sucursal2               varchar(100),
@Costo                   float,
@Moneda                  varchar(20),
@TipoCambio              float,
@Empresa                 varchar(5),
@Sucursal                int,
@Cantidad1               float,
@Sustituir               varchar(5),
@SubCuenta               varchar(50),
@Tipo                    varchar(20),
@Serie                   varchar(20),
@Propiedades             varchar(20),
@Unidad                  varchar(20),
@Factor                  float,
@CantidadInventario      float,
@PosicionActual          varchar(20), 
@ExisteInvD              bit,
@ExisteSerieLote         bit,
@CantidadInventarioLote  float,
@CantidadLote            float
BEGIN TRANSACTION
SELECT @ID2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ID'
SELECT @Posicion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Posicion'
SELECT @Tarima = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tarima'
SELECT @Articulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Articulo'
SELECT @TarimaCompleta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TarimaCompleta'
SELECT @Sustituir = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sustituir'
SELECT @Cantidad1 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cantidad'
SELECT @Serie = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Serie'
SELECT @Propiedades = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Propiedades'
SELECT @Almacen        = Almacen,
@SucursalOrigen = Sucursal,
@FechaRequerida = FechaEmision,
@Moneda         = Moneda,
@TipoCambio     = TipoCambio,
@Empresa        = Empresa,
@Sucursal       = Sucursal
FROM Inv
WHERE ID = @ID2
SELECT @FormaCosteo = FormaCosteo
FROM EmpresaCfg
WHERE Empresa = @Empresa
IF @FormaCosteo = 'Articulo'
SELECT @TipoCosteo = TipoCosteo
FROM Art
WHERE Articulo = @Articulo
ELSE
SELECT @TipoCosteo = TipoCosteo
FROM EmpresaCfg
WHERE Empresa = @Empresa
IF NOT EXISTS(SELECT * FROM CB WHERE Codigo = @Articulo)
SET @Ok = 72050
SELECT @Articulo = Cuenta,
@SubCuenta=ISNULL(SubCuenta,''),
@Unidad = Unidad
FROM CB
WHERE Codigo = @Articulo
SELECT @UnidadCompra = UnidadCompra,
@Tipo = Tipo
FROM Art
WHERE Articulo = @Articulo
SELECT @Unidad = ISNULL(@Unidad, @UnidadCompra)
SELECT @Factor = Factor
FROM ArtUnidad
WHERE Articulo = @Articulo
AND Unidad = @Unidad
SELECT @Factor = ISNULL(@Factor, 1)
IF NOT EXISTS(SELECT * FROM Tarima WHERE Tarima = @Tarima)
SELECT @Ok = 13110, @OkRef=@Tarima
SELECT @PosicionActual = Posicion FROM Tarima WHERE Tarima = @Tarima
IF @Ok IS NULL
IF NOT EXISTS (SELECT * FROM AlmPos WHERE Posicion = @Posicion) SET @Ok = 13030
IF @Ok IS NULL
IF NOT EXISTS (SELECT * FROM Art WHERE Articulo = @Articulo) SET @Ok = 10530
IF @Ok IS NULL
IF NOT EXISTS (SELECT * FROM Inv WHERE ID = @ID2) SET @Ok = 14055
IF @Ok IS NULL
BEGIN
IF (SELECT COUNT(*) FROM InvD WHERE ID = @ID2 AND Tarima = @Tarima AND Articulo = @Articulo AND Unidad = @Unidad) > 0
SET @ExisteInvD = 1
ELSE
SET @ExisteInvD = 0
END
IF @TarimaCompleta = 1
BEGIN
IF @Ok IS NULL
IF NOT EXISTS (SELECT * FROM Tarima t JOIN ArtDisponibleTarima d ON t.Tarima = d.Tarima
WHERE t.Tarima = @Tarima AND t.Posicion = @Posicion AND d.Tarima = @Tarima AND d.Articulo = @Articulo)
SET @Ok = 13110
IF @Ok IS NULL
BEGIN
SELECT @Cantidad = Disponible
FROM Tarima t
JOIN ArtDisponibleTarima ON t.Tarima = ArtDisponibleTarima.Tarima
WHERE t.Tarima = @Tarima
AND t.Posicion = @Posicion
AND ArtDisponibleTarima.Tarima = @Tarima
AND ArtDisponibleTarima.Articulo = @Articulo
END
END
IF @TarimaCompleta = 0
BEGIN
SET @Cantidad = @Cantidad1
IF @Ok IS NULL
IF NOT EXISTS (SELECT * FROM AlmPos WHERE Posicion = @Posicion AND ArticuloEsp = @Articulo /*AND Tipo = 'Domicilio'*/)
SET @Ok = 13030 
END
SELECT @Texto = (SELECT ISNULL(Disponible,0.0) Disponible,
ISNULL(ArtDisponibleTarima.Tarima,'') Tarima
FROM Tarima t JOIN ArtDisponibleTarima ON t.Tarima = ArtDisponibleTarima.Tarima
WHERE t.Tarima = @Tarima
AND t.Posicion = @Posicion
AND ArtDisponibleTarima.Tarima = @Tarima
AND ArtDisponibleTarima.Articulo = @Articulo
FOR XML AUTO)
SET @CantidadInventario = @Cantidad * @Factor
IF @Ok IS NULL
IF @Tipo IN ('Serie', 'Lote') AND LTRIM(RTRIM(ISNULL(@Serie,''))) = ''
SET @Ok = 20051
IF @Tipo IN ('Serie') AND (@Cantidad NOT IN (0,1))
SET @Ok = 20052
IF @Ok IS NULL AND @Tipo IN ('Serie', 'Lote')
BEGIN
SELECT @RenglonID = MAX(RenglonID) FROM SerieLoteMovMovil WHERE Modulo = 'INV' AND ID = @ID2 AND Articulo = @Articulo AND ISNULL(Tarima,'') = ISNULL(@Tarima,'')
SET @RenglonID = ISNULL(@RenglonID,0)
IF @RenglonID = 0
SELECT @RenglonID = MAX(RenglonID) FROM SerieLoteMovMovil WHERE Modulo = 'INV' AND ID = @ID2
SET @RenglonID = ISNULL(@RenglonID,0) + 1
IF NOT EXISTS(SELECT * FROM SerieLoteMovMovil WHERE Modulo = 'INV' AND ID = @ID2 AND Articulo = @Articulo)
SELECT @RenglonID = @RenglonID + 1
IF @Ok IS NULL AND @Tipo IN ('Serie')
BEGIN
IF EXISTS(SELECT *
FROM SerieLoteMovMovil
WHERE Empresa = @Empresa
AND Modulo = 'INV'
AND ID = @ID2
AND Articulo = @Articulo
AND SubCuenta = @SubCuenta
AND SerieLote = @Serie
)
SET @ExisteSerieLote = 1
ELSE
SET @ExisteSerieLote = 0
IF @ExisteSerieLote = 1
SET @OK = 20080
IF @Ok IS NULL AND @ExisteSerieLote = 0 AND @ExisteInvD = 1
BEGIN
SELECT @Renglon = Renglon,
@RenglonID = RenglonID
FROM InvD
WHERE ID = @ID2
AND Tarima = @Tarima
AND Articulo = @Articulo
AND Unidad = @Unidad
IF @Ok IS NULL AND @ExisteSerieLote = 0
BEGIN
INSERT SerieLoteMovMovil (Empresa, Modulo,   ID,  RenglonID,  Articulo,  SubCuenta, SerieLote,  Cantidad,          CantidadAlterna, Propiedades,             Ubicacion, Cliente, Localizacion,  Sucursal, ArtCostoInv, Tarima)
SELECT                 @Empresa, 'INV', @ID2, @RenglonID, @Articulo, @SubCuenta,    @Serie, @CantidadInventario,            NULL, ISNULL(@Propiedades,''),      NULL,    NULL,         NULL, @Sucursal,        NULL,  @Tarima
SELECT @CantidadInventarioLote = SUM(Cantidad)
FROM SerieLoteMovMovil
WHERE ID = @ID2 AND RenglonID = @RenglonID AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Modulo = 'INV' AND Empresa = @Empresa AND ISNULL(Propiedades,'') = ISNULL(@Propiedades,'') AND ISNULL(Tarima,'') = @Tarima
SET @CantidadLote = @CantidadInventarioLote / @Factor
UPDATE InvD SET Cantidad = @CantidadLote, CantidadInventario = ISNULL(@CantidadInventarioLote,0) WHERE ID = @ID2 AND Renglon = @Renglon AND RenglonID = @RenglonID
END
END
IF @Ok IS NULL AND @ExisteSerieLote = 0 AND @ExisteInvD = 0
BEGIN
SELECT @Renglon = ISNULL(MAX(Renglon),0) + 2048,
@RenglonID = ISNULL(MAX(RenglonID),0) + 1
FROM InvD
WHERE ID = @ID2
EXEC spVerCosto @Sucursal, @Empresa, NULL, @Articulo, NULL, @UnidadCompra, @TipoCosteo, @Moneda, @TipoCambio, @Costo OUTPUT, 0
INSERT InvD (  ID,  Renglon, RenglonSub,  RenglonID,  Cantidad,  Almacen,  Articulo,  Tarima,  Costo,  FechaRequerida, Unidad,  Factor,  CantidadInventario,  Sucursal,  SucursalOrigen,         Posicion, PosicionReal) 
SELECT       @ID2, @Renglon,          0, @RenglonID, @Cantidad, @Almacen, @Articulo, @Tarima, @Costo, @FechaRequerida, @Unidad, @Factor, @CantidadInventario, @Sucursal, @SucursalOrigen, @PosicionActual, @Posicion
IF EXISTS(SELECT * FROM SerieLoteMovMovil WHERE ID = @ID2 AND RenglonID = @RenglonID AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND SerieLote = @Serie AND Modulo = 'INV' AND Empresa = @Empresa AND ISNULL(Propiedades,'') = ISNULL(@Propiedades,'') AND ISNULL(Tarima,'') = @Tarima)
SET @ExisteSerieLote = 1
ELSE
SET @ExisteSerieLote = 0
INSERT SerieLoteMovMovil (Empresa, Modulo,   ID,  RenglonID,  Articulo,  SubCuenta, SerieLote,  Cantidad,          CantidadAlterna, Propiedades,             Ubicacion, Cliente, Localizacion,  Sucursal, ArtCostoInv, Tarima)
SELECT                 @Empresa, 'INV', @ID2, @RenglonID, @Articulo, @SubCuenta,    @Serie, @CantidadInventario,            NULL, ISNULL(@Propiedades,''),      NULL,    NULL,         NULL, @Sucursal,        NULL,  @Tarima
END
END
IF @Ok IS NULL AND @Tipo IN ('Lote')
BEGIN
IF @ExisteInvD = 1
BEGIN
SELECT @Renglon = Renglon,
@RenglonID = RenglonID
FROM InvD
WHERE ID = @ID2
AND Tarima = @Tarima
AND Articulo = @Articulo
AND Unidad = @Unidad
IF EXISTS(SELECT * FROM SerieLoteMovMovil WHERE ID = @ID2 AND RenglonID = @RenglonID AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND SerieLote = @Serie AND Modulo = 'INV' AND Empresa = @Empresa AND ISNULL(Propiedades,'') = ISNULL(@Propiedades,'') AND ISNULL(Tarima,'') = @Tarima)
SET @ExisteSerieLote = 1
ELSE
SET @ExisteSerieLote = 0
IF @Ok IS NULL AND @TarimaCompleta = 1 AND EXISTS(SELECT * FROM SerieLoteMovMovil WHERE ID = @ID2 AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Modulo = 'INV' AND Empresa = @Empresa AND ISNULL(Propiedades,'') = ISNULL(@Propiedades,'') AND ISNULL(Tarima,'') = @Tarima)
BEGIN
UPDATE SerieLoteMovMovil SET SerieLote = @Serie WHERE ID = @ID2 AND RenglonID = @RenglonID AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Modulo = 'INV' AND Empresa = @Empresa AND ISNULL(Propiedades,'') = ISNULL(@Propiedades,'') AND ISNULL(Tarima,'') = @Tarima
IF EXISTS(SELECT * FROM SerieLoteMovMovil WHERE ID = @ID2 AND RenglonID = @RenglonID AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND SerieLote = @Serie AND Modulo = 'INV' AND Empresa = @Empresa AND ISNULL(Propiedades,'') = ISNULL(@Propiedades,'') AND ISNULL(Tarima,'') = @Tarima)
SET @ExisteSerieLote = 1
ELSE
SET @ExisteSerieLote = 0
END
IF @ExisteSerieLote = 1 AND @Sustituir = 'No'
UPDATE SerieLoteMovMovil SET Cantidad = Cantidad + @CantidadInventario WHERE ID = @ID2 AND RenglonID = @RenglonID AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND SerieLote = @Serie AND Modulo = 'INV' AND Empresa = @Empresa AND ISNULL(Propiedades,'') = ISNULL(@Propiedades,'') AND ISNULL(Tarima,'') = @Tarima
IF @ExisteSerieLote = 1 AND (@Sustituir = 'Si' OR @TarimaCompleta = 1)
UPDATE SerieLoteMovMovil SET Cantidad = @CantidadInventario WHERE ID = @ID2 AND RenglonID = @RenglonID AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND SerieLote = @Serie AND Modulo = 'INV' AND Empresa = @Empresa AND ISNULL(Propiedades,'') = ISNULL(@Propiedades,'') AND ISNULL(Tarima,'') = @Tarima
IF @ExisteSerieLote = 0
INSERT SerieLoteMovMovil (Empresa, Modulo,   ID,  RenglonID,  Articulo,  SubCuenta, SerieLote,  Cantidad,          CantidadAlterna, Propiedades,             Ubicacion, Cliente, Localizacion,  Sucursal, ArtCostoInv, Tarima)
SELECT                 @Empresa, 'INV', @ID2, @RenglonID, @Articulo, @SubCuenta,    @Serie, @CantidadInventario,            NULL, ISNULL(@Propiedades,''),      NULL,    NULL,         NULL, @Sucursal,        NULL,  @Tarima
IF @Sustituir = 'No'
BEGIN
UPDATE InvD SET Cantidad = Cantidad + @Cantidad1, CantidadInventario = ISNULL(CantidadInventario,0) + ISNULL(@CantidadInventario,0) WHERE ID = @ID2 AND Renglon = @Renglon AND RenglonID = @RenglonID
END
IF @Sustituir = 'Si' OR @TarimaCompleta = 1
BEGIN
SELECT @CantidadInventarioLote = SUM(Cantidad)
FROM SerieLoteMovMovil
WHERE ID = @ID2 AND RenglonID = @RenglonID AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Modulo = 'INV' AND Empresa = @Empresa AND ISNULL(Propiedades,'') = ISNULL(@Propiedades,'') AND ISNULL(Tarima,'') = @Tarima
SET @CantidadLote = @CantidadInventarioLote / @Factor
UPDATE InvD SET Cantidad = @CantidadLote, CantidadInventario = ISNULL(@CantidadInventarioLote,0) WHERE ID = @ID2 AND Renglon = @Renglon AND RenglonID = @RenglonID
END
END
IF @ExisteInvD = 0
BEGIN
SELECT @Renglon = ISNULL(MAX(Renglon),0) + 2048,
@RenglonID = ISNULL(MAX(RenglonID),0) + 1
FROM InvD
WHERE ID = @ID2
EXEC spVerCosto @Sucursal, @Empresa, NULL, @Articulo, NULL, @UnidadCompra, @TipoCosteo, @Moneda, @TipoCambio, @Costo OUTPUT, 0
INSERT InvD (  ID,  Renglon, RenglonSub,  RenglonID,  Cantidad,  Almacen,  Articulo,  Tarima,  Costo,  FechaRequerida, Unidad,  Factor,  CantidadInventario,  Sucursal,  SucursalOrigen,         Posicion, PosicionReal) 
SELECT       @ID2, @Renglon,          0, @RenglonID, @Cantidad, @Almacen, @Articulo, @Tarima, @Costo, @FechaRequerida, @Unidad, @Factor, @CantidadInventario, @Sucursal, @SucursalOrigen, @PosicionActual, @Posicion
IF EXISTS(SELECT * FROM SerieLoteMovMovil WHERE ID = @ID2 AND RenglonID = @RenglonID AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND SerieLote = @Serie AND Modulo = 'INV' AND Empresa = @Empresa AND ISNULL(Propiedades,'') = ISNULL(@Propiedades,'') AND ISNULL(Tarima,'') = @Tarima)
SET @ExisteSerieLote = 1
ELSE
SET @ExisteSerieLote = 0
IF @ExisteSerieLote = 1 AND @Sustituir = 'No'
UPDATE SerieLoteMovMovil SET Cantidad = Cantidad + @CantidadInventario WHERE ID = @ID2 AND RenglonID = @RenglonID AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND SerieLote = @Serie AND Modulo = 'INV' AND Empresa = @Empresa AND ISNULL(Propiedades,'') = ISNULL(@Propiedades,'') AND ISNULL(Tarima,'') = @Tarima
IF @ExisteSerieLote = 1 AND @Sustituir = 'Si'
UPDATE SerieLoteMovMovil SET Cantidad = @CantidadInventario WHERE ID = @ID2 AND RenglonID = @RenglonID AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND SerieLote = @Serie AND Modulo = 'INV' AND Empresa = @Empresa AND ISNULL(Propiedades,'') = ISNULL(@Propiedades,'') AND ISNULL(Tarima,'') = @Tarima
IF @ExisteSerieLote = 0
INSERT SerieLoteMovMovil (Empresa, Modulo,   ID,  RenglonID,  Articulo,  SubCuenta, SerieLote,  Cantidad,          CantidadAlterna, Propiedades,             Ubicacion, Cliente, Localizacion,  Sucursal, ArtCostoInv, Tarima)
SELECT                 @Empresa, 'INV', @ID2, @RenglonID, @Articulo, @SubCuenta,    @Serie, @CantidadInventario,            NULL, ISNULL(@Propiedades,''),      NULL,    NULL,         NULL, @Sucursal,        NULL,  @Tarima
END
END
END
IF @Ok IS NULL AND @Tipo NOT IN ('Serie', 'Lote')
BEGIN
IF @ExisteInvD = 1
BEGIN
SELECT @Renglon = Renglon,
@RenglonID = RenglonID
FROM InvD
WHERE ID = @ID2
AND Tarima = @Tarima
AND Articulo = @Articulo
AND Unidad = @Unidad
IF @Sustituir = 'NO'
UPDATE InvD SET Cantidad = Cantidad + @Cantidad1, CantidadInventario = ISNULL(CantidadInventario,0) + ISNULL(@CantidadInventario,0) WHERE ID = @ID2 AND Renglon = @Renglon AND RenglonID = @RenglonID
IF @Sustituir = 'Si' AND @Cantidad1 > 0
UPDATE InvD SET Cantidad = @Cantidad1, CantidadInventario = ISNULL(@CantidadInventario,0) WHERE ID = @ID2 AND Renglon = @Renglon AND RenglonID = @RenglonID
IF @Sustituir = 'Si' AND @Cantidad1 = 0
DELETE InvD WHERE ID = @ID2 AND Tarima = @Tarima AND Articulo = @Articulo AND Unidad = @Unidad
END
IF @ExisteInvD = 0
BEGIN
SELECT @Renglon = ISNULL(MAX(Renglon),0) + 2048,
@RenglonID = ISNULL(MAX(RenglonID),0) + 1
FROM InvD WHERE ID = @ID2
EXEC spVerCosto @Sucursal, @Empresa, NULL, @Articulo, NULL, @UnidadCompra, @TipoCosteo, @Moneda, @TipoCambio, @Costo OUTPUT, 0
INSERT InvD (  ID,  Renglon, RenglonSub,  RenglonID,  Cantidad,  Almacen,  Articulo,  Tarima,  Costo,  FechaRequerida, Unidad,  Factor,  CantidadInventario,  Sucursal,  SucursalOrigen,         Posicion, PosicionReal) 
SELECT       @ID2, @Renglon,          0, @RenglonID, @Cantidad, @Almacen, @Articulo, @Tarima, @Costo, @FechaRequerida, @Unidad, @Factor, @CantidadInventario, @Sucursal, @SucursalOrigen, @PosicionActual, @Posicion
END
END
IF @@ERROR <> 0
SET @Ok = 1
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NOT NULL
SELECT @OkRef = Descripcion
FROM MensajeLista
WHERE Mensaje = @Ok
IF @TarimaCompleta = 1
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),ISNULL(@Texto,'')) + '</Resultado></Intelisis>'
ELSE
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),ISNULL(@Texto,'')) + '</Resultado></Intelisis>'
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
END
END

