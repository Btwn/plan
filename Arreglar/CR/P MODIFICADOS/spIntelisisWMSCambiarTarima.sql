SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSCambiarTarima
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
@Usuario                   varchar(20),
@Mov                       varchar(20),
@MovID                     varchar(20),
@TarimaCambio              varchar(20),
@TarimaCambioPosicion      varchar(20),
@IdTma                     int
DECLARE @Tabla Table(
IdTma                      int,
Tarima                     varchar(20),
Posicion                   varchar(10)
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Almacen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Almacen'
SELECT @Mov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mov'
SELECT @MovID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovID'
SELECT @TarimaCambio = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TarimaCambio'
SELECT @TarimaCambioPosicion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TarimaCambioPosicion'
SET @Empresa              = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Almacen              = LTRIM(RTRIM(ISNULL(@Almacen,'')))
SET @Mov                  = LTRIM(RTRIM(ISNULL(@Mov,'')))
SET @MovID                = LTRIM(RTRIM(ISNULL(@MovID,'')))
SET @TarimaCambio         = LTRIM(RTRIM(ISNULL(@TarimaCambio,'')))
SET @TarimaCambioPosicion = LTRIM(RTRIM(ISNULL(@TarimaCambioPosicion,'')))
SELECT @Usuario = Usuario FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
SET @Usuario = LTRIM(RTRIM(ISNULL(@Usuario,'')))
IF LTRIM(RTRIM(ISNULL(@Almacen,''))) = ''
SELECT @Almacen = LTRIM(RTRIM(ISNULL(DefAlmacen,''))) From Usuario WITH(NOLOCK) WHERE Usuario = @Usuario
SET @Almacen = LTRIM(RTRIM(ISNULL(@Almacen,'')))
SELECT @IdTma = ID
FROM TMA
WITH(NOLOCK) WHERE Empresa = @Empresa
AND Almacen = @Almacen
AND Mov     = @Mov
AND MovID   = @MovID
SET @IdTma = ISNULL(@IdTma,0)
IF LEN(@TarimaCambio) > 0 AND LEN(@TarimaCambioPosicion) > 0
BEGIN
UPDATE TMAD
 WITH(ROWLOCK) SET Tarima = @TarimaCambio,
Posicion = @TarimaCambioPosicion
WHERE ID = @IdTma
END
INSERT INTO @Tabla(IdTma,Tarima,Posicion)
VALUES (@IdTma,@TarimaCambio,@TarimaCambioPosicion)
SELECT @Texto = (SELECT CAST(ISNULL(IdTma,0) AS varchar)  AS IdTma,
LTRIM(RTRIM(ISNULL(Tarima,'')))   AS Tarima,
LTRIM(RTRIM(ISNULL(Posicion,''))) AS Posicion
FROM @Tabla AS TMA
FOR XML AUTO)
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @ReferenciaIS = Referencia FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

