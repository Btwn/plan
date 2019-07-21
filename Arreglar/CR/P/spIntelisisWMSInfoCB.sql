SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSInfoCB
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa            varchar(5),
@Referencia         varchar(50), 
@ID2                 int,
@Mov                varchar(20),
@CB                varchar(30),
@Anden                varchar(20),
@MovID  			varchar(20),
@Articulo 			varchar(20),
@SubCuenta 			varchar(50),
@Texto				xml,
@ReferenciaIS		varchar(100),
@SubReferencia		varchar(100),
@UsuarioSucursal    bit,
@Cantidad           float,
@Caducidad          int,
@FechaCaducidad     datetime,
@Fecha              datetime,
@Sucursal			int,
@Cantidad2          float,
@Tipo				varchar(20),
@Serie				varchar(20),
@RenglonID			int,
@RenglonID2			int,
@Sustituir          varchar(5),
@TieneCaducidad		bit,
@Propiedades		varchar(20),
@UnidadCompra       varchar(20) 
DECLARE
@Tabla Table(
Cuenta                  varchar(20),
SubCuenta               varchar(50),
Descripcion             varchar(100),
Unidad                  varchar(20),
TieneCaducidad          bit,
CaducidadMinima         int,
CantidadPresentacion    float,
Presentacion            varchar(50) NULL,
Factor                  float,
CantidadCamaTarima      int NULL,
CamasTarima             int NULL,
Amarre                  int NULL
)
SELECT  @Empresa   = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT  @Mov= Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mov'
SELECT  @MovID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovID'
SELECT  @CB = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Codigo'
SELECT  @Referencia = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Referencia'
SELECT  @Serie = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Serie'
SELECT  @Sustituir = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sustituir'
SELECT  @FechaCaducidad = CONVERT(datetime, Valor) FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FechaCaducidad'
SELECT  @Propiedades = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Propiedades'
IF NOT EXISTS(SELECT * FROM CB WHERE Codigo = @CB)SET @Ok = 72040
IF @Ok IS NULL
BEGIN
SELECT @Articulo = Cuenta, @SubCuenta=ISNULL(SubCuenta,'') FROM CB WHERE Codigo = @CB
IF NOT EXISTS(SELECT * FROM Compra c JOIN CompraD d ON c.ID = d.ID WHERE c.Empresa = @Empresa AND c.Mov = @Mov AND c.MovID = @MovID AND d.Articulo = @Articulo) SELECT @Ok =10530
SELECT @Fecha = GETDATE()
SELECT @Caducidad =ISNULL(CaducidadMinima,0), @TieneCaducidad = ISNULL(TieneCaducidad,0)  FROM Art WHERE Articulo = @Articulo
IF @TieneCaducidad = 1 AND @FechaCaducidad='99981231' SELECT @Ok=25125 
IF @Referencia = '' or @Referencia is NULL SET @Ok = 80201
END
IF @Ok IS NULL
BEGIN
INSERT @Tabla(Cuenta, SubCuenta,               Descripcion,                                    Unidad,               TieneCaducidad,              CaducidadMinima,              CantidadPresentacion,              Presentacion,               Factor,              CantidadCamaTarima,              CamasTarima,              Amarre)
SELECT      c.Cuenta, ISNULL(c.SubCuenta, ''), ISNULL(a.Descripcion1, '')+'      Clave:'+RTRIM(c.Cuenta)+'.', ISNULL(c.Unidad, ''), ISNULL(a.TieneCaducidad, 0), ISNULL(a.CaducidadMinima, 0), ISNULL(a.CantidadPresentacion, 0), ISNULL(a.Presentacion, ''), ISNULL(au.Factor,0), ISNULL(a.CantidadCamaTarima, 0), ISNULL(a.CamasTarima, 0), ISNULL(a.CantidadCamaTarima*a.CamasTarima, 0)
FROM CB c JOIN Art a ON c.Cuenta = a.Articulo
JOIN ArtUnidad au ON AU.Articulo=a.Articulo AND au.Unidad=a.UnidadCompra
WHERE  c.Codigo = @CB
END
SELECT @Texto =ISNULL((SELECT Cuenta, SubCuenta, Descripcion, TieneCaducidad, CaducidadMinima, Unidad,
CONVERT(varchar, CantidadPresentacion) CantidadPresentacion, Presentacion,
CONVERT(varchar, Factor) Factor,
CONVERT(varchar, CantidadCamaTarima) CantidadCamaTarima,
CONVERT(varchar, CamasTarima) CamasTarima,
CONVERT(varchar, Amarre) Amarre
FROM @Tabla FOR XML AUTO),'')
IF @Texto IS NULL
SELECT @Ok = 10530, @OkRef=''
IF @@ERROR <> 0 SET @Ok = 1
BEGIN
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),ISNULL(@Texto,'')) + '</Resultado></Intelisis>'
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),ISNULL(@Texto,'')) + '</Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
END
END

