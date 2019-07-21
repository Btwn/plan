SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisDistribucionInventarioFisicoLista
@ID              int,
@iSolicitud      int,
@Version         float,
@Resultado       varchar(max) = NULL OUTPUT,
@Ok              int = NULL OUTPUT,
@OkRef           varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto                   xml,
@ReferenciaIS            varchar(100),
@SubReferencia           varchar(100),
@Empresa                 varchar(5),
@Usuario                 varchar(10),
@Agente                  varchar(10)
DECLARE @Tabla table(
ID                       int,
Mov                      varchar(20),
MovID                    varchar(20),
Almacen                  varchar(10),
AlmacenNombre            varchar(100),
fFechaEmision            datetime,
FechaEmision             varchar(10)
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SET @Empresa = ISNULL(@Empresa,'')
SET @Usuario = ISNULL(@Usuario,'')
SET @Agente  = ISNULL(@Usuario,'')
IF NOT EXISTS(SELECT * FROM Agente WHERE Agente = @Agente) SET @Ok = 26090
IF ISNULL(@Ok, 0) = 0
BEGIN
INSERT INTO @Tabla (ID, Mov, MovID, Almacen, AlmacenNombre, fFechaEmision)
SELECT i.ID, i.Mov, i.MovID, i.Almacen, a.Nombre, i.FechaEmision
FROM Inv i
JOIN MovTipo m ON (i.Mov = m.Mov AND m.Modulo = 'INV')
JOIN Alm a ON (i.almacen = a.Almacen)
WHERE i.Agente = @Agente
AND m.Clave = 'INV.IF'
AND i.Estatus = 'SINAFECTAR'
UPDATE @Tabla SET FechaEmision = CAST(YEAR(fFechaEmision) AS varchar) + '-'
+ RIGHT('00' + CAST(MONTH(fFechaEmision) AS varchar),2) + '-'
+ RIGHT('00' + CAST(DAY(fFechaEmision) AS varchar), 2)
SELECT @Texto = (SELECT CAST(ISNULL(ID,0) AS varchar)          AS ID,
LTRIM(RTRIM(ISNULL(Mov,'')))           AS Mov,
LTRIM(RTRIM(ISNULL(MovID,'')))         AS MovID,
LTRIM(RTRIM(ISNULL(Almacen,'')))       AS Almacen,
LTRIM(RTRIM(ISNULL(AlmacenNombre,''))) AS AlmacenNombre,
LTRIM(RTRIM(ISNULL(FechaEmision,'')))  AS FechaEmision
FROM @Tabla AS Tabla
FOR XML AUTO)
END
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @ReferenciaIS = Referencia, @SubReferencia = SubReferencia FROM IntelisisService WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

