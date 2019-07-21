SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSRecoleccionLista
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
@Usuario                   varchar(20),
@FechaHoy                  datetime,
@Cuantos                   int,
@Dias                      int,
@Fecha                     datetime
DECLARE @Tabla Table(
Paquete                    varchar(20),
IDOrigen                   int,
OrigenTipo                 varchar(10),
Origen                     varchar(20),
OrigenID                   varchar(20),
MovOrigen                  varchar(50),
TarimaSurtido              varchar(20),
dtFecha                    datetime,
sFecha                     varchar(12)
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SET @Empresa = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Usuario = LTRIM(RTRIM(ISNULL(@Usuario,'')))
SET @FechaHoy = dbo.fnFechaSinHora(getdate())
SET @Cuantos  = 50
SET @Dias     = 15
SET @Fecha    = dateadd(day, (@dias * (-1)), @fechaHoy)
INSERT INTO @Tabla(Paquete, IDorigen, TarimaSurtido, dtFecha)
SELECT TOP (@Cuantos) Paquete, IDorigen, TarimaSurtido, Fecha
FROM WMSPaquete
WITH(NOLOCK) WHERE Usuario = @Usuario
AND Fecha > @Fecha
GROUP BY Paquete, IDorigen, TarimaSurtido, Fecha
UPDATE @Tabla
SET OrigenTipo = LTRIM(RTRIM(ISNULL(b.OrigenTipo,''))),
Origen     = LTRIM(RTRIM(ISNULL(b.Origen,''))),
OrigenID   = LTRIM(RTRIM(ISNULL(b.OrigenID,'')))
FROM @Tabla a
JOIN TMA b WITH(NOLOCK) ON(a.IDOrigen = b.ID)
UPDATE @Tabla
SET MovOrigen = Origen + ' ' + OrigenID,
sFecha = CONVERT(varchar(20), dtFecha, 103)
SELECT @Texto = (SELECT ISNULL(Tabla.Paquete,'')                  AS Paquete,
CAST(ISNULL(Tabla.IDOrigen,0) AS varchar) AS IDOrigen,
ISNULL(Tabla.OrigenTipo,'')               AS OrigenTipo,
ISNULL(Tabla.Origen,'')                   AS Origen,
CAST(ISNULL(Tabla.OrigenID,0) AS varchar) AS OrigenID,
ISNULL(Tabla.MovOrigen,'')                AS MovOrigen,
ISNULL(Tabla.TarimaSurtido,'')            AS TarimaSurtido,
ISNULL(Tabla.sFecha,'')                   AS Fecha
FROM @Tabla AS Tabla
ORDER BY Tabla.dtFecha DESC
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

