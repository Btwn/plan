SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisDistribucionMovimientosRecepcionLista
@ID              int,
@iSolicitud      int,
@Version         float,
@Resultado       varchar(max) = NULL OUTPUT,
@Ok              int = NULL OUTPUT,
@OkRef           varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto         xml,
@ReferenciaIS  varchar(100),
@SubReferencia varchar(100),
@Empresa       varchar(5),
@Usuario       varchar(10)
DECLARE @Tabla   table(
Mov            varchar(20),
Orden          int,
Clave          varchar(20),
SubClave       varchar(20)
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
INSERT INTO @Tabla (Mov, Orden, Clave, SubClave)
SELECT Mov, Orden, Clave, SubClave
FROM MovTipo
WHERE Modulo = 'COMS'
AND Clave = 'COMS.O'
AND Mov IN ('Orden Compra')
ORDER BY Orden
INSERT INTO @Tabla (Mov, Orden, Clave, SubClave)
SELECT Mov, Orden, Clave, SubClave
FROM MovTipo
WHERE Modulo = 'INV'
AND Clave = 'INV.TI'
AND LTRIM(RTRIM(ISNULL(SubClave,''))) = ''
AND Mov IN ('Transito')
ORDER BY Orden
SELECT @Texto = (SELECT LTRIM(RTRIM(ISNULL(Mov,'')))      AS Mov,
CAST(ISNULL(Orden,0) AS varchar)  AS Orden,
LTRIM(RTRIM(ISNULL(Clave,'')))    AS Clave,
LTRIM(RTRIM(ISNULL(SubClave,''))) AS SubClave
FROM @Tabla AS Tabla
FOR XML AUTO)
IF NOT ISNULL(@Ok, 0) = 0 SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @ReferenciaIS = Referencia, @SubReferencia = SubReferencia FROM IntelisisService WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

