SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSMovimientosRecoleccionLista
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
ID                         int,
Mov                        varchar(20),
MovID                      varchar(20),
Movimiento                 varchar(40)
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
SELECT TOP 1 @Sucursal = Sucursal FROM Sucursal WITH(NOLOCK) WHERE Nombre = @SucursalNombre
SELECT @Agente = DefAgente FROM Usuario WITH(NOLOCK) WHERE Usuario = @Usuario
IF LTRIM(RTRIM(ISNULL(@Almacen,'')))= ''
BEGIN
SELECT @Almacen = LTRIM(RTRIM(ISNULL(DefAlmacen,''))) From Usuario WITH(NOLOCK) WHERE Usuario = @Usuario
SET @Almacen = LTRIM(RTRIM(ISNULL(@Almacen,'')))
END
INSERT INTO @Tabla(Mov, MovID, Movimiento)
SELECT DISTINCT t.Origen, t.OrigenID, LTRIM(RTRIM(ISNULL(t.Origen,''))) + ' ' + LTRIM(RTRIM(ISNULL(t.OrigenID,'')))
FROM TMA t
 WITH(NOLOCK) JOIN MovTipo m  WITH(NOLOCK) ON (t.Mov = m.Mov AND m.Modulo = 'TMA')
WHERE t.Empresa = @Empresa
AND t.Sucursal = @Sucursal
AND t.Agente = @Agente
AND m.Clave = 'TMA.TSUR'
AND m.SubClave = 'TMA.TSURP'
AND t.Estatus = 'PROCESAR'
AND ISNULL(t.Empacado,0) = 0
UPDATE @Tabla
SET ID = ISNULL(b.ID, '0')
FROM @Tabla a
JOIN TMA b WITH(NOLOCK) ON(a.Mov = b.Mov AND a.MovID = b.MovID)
SELECT @Texto = (SELECT CAST(ISNULL(ID,0) AS varchar) AS ID,
ISNULL(Mov,'')                AS Mov,
ISNULL(MovID,'')              AS MovID,
ISNULL(Movimiento,'')         AS Movimiento
FROM @Tabla AS TMA
FOR XML AUTO)
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @ReferenciaIS = Referencia FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

