SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSTarimasPorCerrarLista
@ID                        int,
@iSolicitud                int,
@Version                   float,
@Resultado                 varchar(max) = NULL OUTPUT,
@Ok                        int = NULL OUTPUT,
@OkRef                     varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto                     xml,
@ReferenciaIS              varchar(100),
@SubReferencia             varchar(100),
@Empresa                   varchar(5),
@Almacen                   varchar(10),
@Sucursal                  int,
@SucursalNombre            varchar(100),
@Usuario                   varchar(20),
@Agente                    varchar(10)
DECLARE @Tabla Table(
Empresa                    varchar(5),
Almacen                    varchar(10),
ModuloID                   int,
Mov                        varchar(20),
MovID                      varchar(20),
Movimiento                 varchar(40),
Tarima                     varchar(20),
Articulo                   varchar(20),
Cantidad                   float,
TarimaCierre               varchar(20),
PosicionDestino            varchar(10),
DescripcionPosicionDestino varchar(100),
Fecha                      datetime,
Referencia                 varchar(50),
Observaciones              varchar(100)
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @SucursalNombre = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SucursalNombre'
SELECT @Almacen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Almacen'
SELECT @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SET @Empresa         = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @SucursalNombre  = LTRIM(RTRIM(ISNULL(@SucursalNombre,'')))
SET @Almacen         = LTRIM(RTRIM(ISNULL(@Almacen,'')))
SET @Usuario         = LTRIM(RTRIM(ISNULL(@Usuario,'')))
SELECT TOP 1 @Sucursal = Sucursal FROM Sucursal WHERE Nombre = @SucursalNombre
SELECT @Agente = DefAgente FROM Usuario WHERE Usuario = @Usuario
IF LTRIM(RTRIM(ISNULL(@Almacen,'')))= ''
BEGIN
SELECT @Almacen = LTRIM(RTRIM(ISNULL(DefAlmacen,''))) From Usuario WHERE Usuario = @Usuario
SET @Almacen = LTRIM(RTRIM(ISNULL(@Almacen,'')))
END
INSERT INTO @Tabla(ModuloID, Mov, MovId, Fecha, Referencia, Observaciones, TarimaCierre)
SELECT t.ID, t.Mov, t.MovID, t.FechaEmision, t.Referencia, t.Observaciones, t.TarimaSurtido
FROM TMA t
JOIN MovTipo m ON (t.Mov = m.Mov AND m.Modulo = 'TMA')
WHERE t.Empresa = @Empresa
AND t.Sucursal = @Sucursal
AND t.Agente = @Agente
AND t.Estatus = 'PROCESAR'
AND m.Clave = 'TMA.TSUR'
AND m.SubClave = 'TMA.TSURP'
UPDATE @Tabla
SET Empresa = @Empresa,
Almacen = @Almacen,
Movimiento = LTRIM(RTRIM(ISNULL(Mov,''))) + ' ' + LTRIM(RTRIM(ISNULL(MovID,'')))
UPDATE @Tabla
SET Tarima = ISNULL(b.Tarima, ''),
Articulo = b.Articulo,
Cantidad = b.CantidadPicking,
PosicionDestino = b.PosicionDestino
FROM @Tabla a
JOIN TMAD b ON(a.ModuloID = b.ID)
UPDATE @Tabla
SET DescripcionPosicionDestino = b.Descripcion
FROM @Tabla a
JOIN AlmPos b ON (a.Almacen = b.Almacen AND a.PosicionDestino = b.Posicion)
SELECT @Texto = (SELECT CAST(ISNULL(ModuloID,0) AS varchar)                AS ModuloID,
ISNULL(Mov,'')                                     AS Mov,
ISNULL(MovID,'')                                   AS MovID,
ISNULL(Movimiento,'')                              AS Movimiento,
ISNULL(Tarima,'')                                  AS Tarima,
ISNULL(Articulo,'')                                AS Articulo,
CAST(ISNULL(Cantidad,0) AS varchar)                AS Cantidad,
ISNULL(TarimaCierre,'')                            AS TarimaCierre,
ISNULL(PosicionDestino,'')                         AS PosicionDestino,
ISNULL(DescripcionPosicionDestino,'')              AS DescripcionPosicionDestino,
CONVERT(varchar(11), ISNULL(Fecha,'20150101'),113) AS Fecha,
ISNULL(Referencia,'')                              AS Referencia,
ISNULL(Observaciones,'')                           AS Observaciones
FROM @Tabla AS TMA
FOR XML AUTO)
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @ReferenciaIS = Referencia FROM IntelisisService WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

