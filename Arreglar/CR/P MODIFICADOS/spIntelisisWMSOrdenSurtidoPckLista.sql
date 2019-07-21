SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSOrdenSurtidoPckLista
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
IDR                        int identity(1,1),
ID                         int,
Mov                        varchar(20),
MovID                      varchar(20),
MovMovID                   varchar(40),
OrigenTipo                 varchar(10),
Origen                     varchar(20),
OrigenID                   varchar(20),
IDOrigen                   int
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SET @Empresa = LTRIM(RTRIM(ISNULL(@Empresa,'')))
INSERT INTO @Tabla (ID, Mov, MovID, Origentipo, Origen, OrigenID)
SELECT DISTINCT a.ID, a.Mov, a.MovID, a.Origentipo, a.Origen, a.OrigenID
FROM TMA a
 WITH(NOLOCK) JOIN TMA b  WITH(NOLOCK) ON (a.Mov = b.Origen AND a.MovID = b.OrigenID AND b.OrigenTipo = 'TMA')
WHERE a.Empresa = @Empresa
AND a.Mov     = 'Orden Surtido PCK'
AND a.Estatus = 'PENDIENTE'
AND b.Mov     = 'Surtido Transito PCK'
AND b.Estatus = 'PROCESAR'
UPDATE @Tabla
SET IDOrigen = b.ID
FROM @Tabla a
JOIN Venta b WITH(NOLOCK) ON(a.Origen = b.Mov AND a.OrigenID = b.MovID)
UPDATE @Tabla SET MovMovID = LTRIM(RTRIM(ISNULL(Mov,''))) + ' ' + LTRIM(RTRIM(ISNULL(MovID,'')))
SELECT @Texto = (SELECT CAST(ISNULL(ID,0) AS varchar)       AS ID,
LTRIM(RTRIM(ISNULL(Mov,'')))        AS Mov,
LTRIM(RTRIM(ISNULL(MovID,'')))      AS MovID,
LTRIM(RTRIM(ISNULL(MovMovID,'')))   AS MovMovID,
LTRIM(RTRIM(ISNULL(OrigenTipo,''))) AS OrigenTipo,
LTRIM(RTRIM(ISNULL(Origen,'')))     AS Origen,
CAST(ISNULL(OrigenID,0) AS varchar) AS OrigenID,
CAST(ISNULL(IDOrigen,0) AS varchar) AS IDOrigen
FROM @Tabla AS Tabla
ORDER BY IDR
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

