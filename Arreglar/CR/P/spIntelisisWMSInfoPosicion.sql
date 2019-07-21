SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSInfoPosicion
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
@Almacen            varchar(10),
@Posicion           varchar(10),
@Tarima             varchar(20),
@Tipo               varchar(20)
DECLARE
@Tabla Table(
Almacen             varchar(10),
Posicion            varchar(10),
Tipo                varchar(20),
Descripcion         varchar(100),
Pasillo             int,
Fila                int,
Nivel               int,
Zona                varchar(50),
Capacidad           int,
Estatus             varchar(15),
ArticuloEsp         varchar(20),
Alto                float,
Largo               float,
Ancho               float,
Volumen             float,
PesoMaximo          float,
Orden               int,
TipoRotacion        varchar(10),
CambioDomicilios    bit,
TipoTarimaEsp       varchar(20),
SubCuenta           varchar(50),
Tarima              varchar(20)
)
SELECT @Almacen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Almacen'
SELECT @Posicion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Posicion'
SELECT @Tipo = Tipo
FROM AlmPos
WHERE Almacen = @Almacen
AND Posicion = @Posicion
AND Estatus = 'ALTA'
IF @Tipo = 'Domicilio'
BEGIN
SELECT @Tarima = Tarima
FROM Tarima
WHERE Almacen = @Almacen
AND Posicion = @Posicion
AND Estatus = 'ALTA'
END
INSERT INTO @Tabla
SELECT @Almacen,
@Posicion,
ISNULL(Tipo,''),
ISNULL(Descripcion,''),
ISNULL(Pasillo,0),
ISNULL(Fila,0),
ISNULL(Nivel,0),
ISNULL(Zona,''),
ISNULL(Capacidad,0),
ISNULL(Estatus,''),
ISNULL(ArticuloEsp,''),
ISNULL(Alto,0),
ISNULL(Largo,0),
ISNULL(Ancho,0),
ISNULL(Volumen,0),
ISNULL(PesoMaximo,0),
ISNULL(Orden,0),
ISNULL(TipoRotacion,0),
ISNULL(CambioDomicilios,''),
ISNULL(TipoTarimaEsp,''),
ISNULL(SubCuenta,''),
ISNULL(@Tarima,'')
FROM AlmPos
WHERE Almacen = @Almacen
AND Posicion = @Posicion
SELECT @Texto = (SELECT *
FROM @Tabla TMA
FOR XML AUTO)
SET @Texto = ISNULL(@Texto,'')
IF @@ERROR <> 0 SET @Ok = 1
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NOT NULL
SELECT @OkRef = Descripcion
FROM MensajeLista
WHERE Mensaje = @Ok
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),@Texto) + '</Resultado></Intelisis>'
IF @@ERROR <> 0
SET @Ok = 1
END

