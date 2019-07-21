SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSInfoTarima
@ID                 int,
@iSolicitud         int,
@Version            float,
@Resultado          varchar(max) = NULL OUTPUT,
@Ok                 int = NULL OUTPUT,
@OkRef              varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto              xml,
@ReferenciaIS       varchar(100),
@SubReferencia      varchar(100),
@ID2                varchar(20),
@Empresa            varchar(5),
@Almacen            varchar(10),
@Tarima             varchar(20),
@MultiUnidades      bit,
@Posicion           varchar(10),
@PosicionTipo       varchar(20),
@Articulo           varchar(20),
@Descripcion1       varchar(100),
@SubCuenta          varchar(50),
@ArticuloTipo       varchar(20),
@Unidad             varchar(50),
@Codigo             varchar(30),
@SerieLote          varchar(50),
@Disponible         float,
@InvID              int
DECLARE @Tabla table (
Articulo          varchar(20),
SubCuenta         varchar(50),
Descripcion1      varchar(100),
ArticuloTipo      varchar(20),
Unidad            varchar(50),
Codigo            varchar(30),
SerieLote         varchar(50),
Disponible        varchar(50)
)
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @ID2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ID'
SELECT @Almacen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Almacen'
SELECT @Posicion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Posicion'
SELECT @Tarima = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tarima'
SELECT @MultiUnidades = MultiUnidades
FROM EmpresaCfg2 WITH(NOLOCK) WHERE Empresa = @Empresa
SET @MultiUnidades = ISNULL(@MultiUnidades,0)
IF NOT EXISTS(SELECT * FROM Tarima WITH(NOLOCK) WHERE Posicion = @Posicion AND Tarima = @Tarima)
SET @Ok = 13190
IF @Ok IS NULL
BEGIN
SELECT @Articulo = LTRIM(RTRIM(ISNULL(ArticuloEsp,''))),
@SubCuenta = LTRIM(RTRIM(ISNULL(SubCuenta,''))),
@PosicionTipo = UPPER(LTRIM(RTRIM(ISNULL(Tipo,''))))
FROM AlmPos
WITH(NOLOCK) WHERE Almacen = @Almacen AND Posicion = @Posicion
IF ISNULL(@Articulo,'') = ''
SELECT @Articulo = LTRIM(RTRIM(ISNULL(Articulo,''))),
@SubCuenta = LTRIM(RTRIM(ISNULL(SubCuenta,'')))
FROM Tarima
WITH(NOLOCK) WHERE Tarima = @Tarima
SELECT @Descripcion1 = LTRIM(RTRIM(ISNULL(Descripcion1,''))),
@ArticuloTipo = LTRIM(RTRIM(ISNULL(Tipo,'')))
FROM Art
WITH(NOLOCK) WHERE Articulo = @Articulo
SELECT @SerieLote = LTRIM(RTRIM(ISNULL(SerieLote,'')))
FROM SerieLote
WITH(NOLOCK) WHERE Tarima = @Tarima
SELECT @Disponible = ISNULL(Disponible,0)
FROM ArtSubDisponibleTarima
WITH(NOLOCK) WHERE Tarima = @Tarima
IF @MultiUnidades = 0
SELECT @Unidad = UnidadTraspaso FROM Art WITH(NOLOCK) WHERE Articulo = @Articulo
ELSE
SELECT @Unidad = Unidad FROM ArtUnidad WITH(NOLOCK) WHERE Articulo = @Articulo
SELECT @Codigo = LTRIM(RTRIM(ISNULL(Codigo,'')))
FROM CB
WITH(NOLOCK) WHERE TipoCuenta = 'Articulos'
AND Cuenta = @Articulo
AND ISNULL(SubCuenta,'') = @SubCuenta
AND Unidad = @Unidad
IF @MultiUnidades = 1
BEGIN
IF NOT EXISTS (SELECT Unidad FROM ArtUnidad WITH(NOLOCK) WHERE Articulo = @Articulo)
SELECT @Ok = 20560, @OkRef = 'No est� definida la unidad para el Art�culo indicado'
END
IF @Ok IS NULL AND ISNULL(@Unidad,'') = ''
SELECT @Ok = 20560, @OkRef = 'No est� definida la unidad traspaso para el Art�culo indicado'
IF @Ok IS NULL
BEGIN
INSERT @Tabla(Articulo,SubCuenta,Descripcion1,ArticuloTipo,Unidad,Codigo,SerieLote,Disponible)
VALUES (ISNULL(@Articulo,''),
ISNULL(@SubCuenta,''),
ISNULL(@Descripcion1,''),
ISNULL(@ArticuloTipo,''),
ISNULL(@Unidad,''),
ISNULL(@Codigo,''),
ISNULL(@SerieLote,''),
CAST(ISNULL(@Disponible,0) AS varchar(50)))
SELECT @Texto = (SELECT Articulo,
SubCuenta,
Descripcion1,
ArticuloTipo,
Unidad,
Codigo,
SerieLote,
Disponible
FROM @Tabla TMA
FOR XML AUTO)
IF @Texto IS NULL
BEGIN
SET @Ok = 13110
SELECT @OkRef = descripcion FROM Mensajelista WITH(NOLOCK) WHERE Mensaje = 13110
END
END
END
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WITH(NOLOCK) WHERE ID = @ID
IF @Ok IS NOT NULL
SET @OkRef = @OkRef + ' ' + @Articulo
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),ISNULL(@Texto,'')) + '</Resultado></Intelisis>'
END

