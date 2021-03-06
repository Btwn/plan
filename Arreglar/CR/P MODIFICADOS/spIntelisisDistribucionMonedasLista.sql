SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisDistribucionMonedasLista
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
@Empresa       varchar(5)
DECLARE @Tabla   table(
IDR            int identity (1,1),
Moneda         varchar(10),
Orden          int,
TipoCambio     float
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SET @Empresa = ISNULL(@Empresa,'')
INSERT INTO @Tabla (Moneda, Orden, TipoCambio)
SELECT Moneda, Orden, TipoCambio
FROM Mon WITH(NOLOCK)
WHERE  TipoCambio = 1
INSERT INTO @Tabla (Moneda, Orden, TipoCambio)
SELECT Moneda, Orden, TipoCambio
FROM Mon WITH(NOLOCK)
WHERE  TipoCambio <> 1
SELECT @Texto = (SELECT LTRIM(RTRIM(ISNULL(Moneda,'')))       AS Moneda,
CAST(ISNULL(Orden,0) AS varchar)      AS Orden,
CAST(ISNULL(TipoCambio,0) AS varchar) AS TipoCambio
FROM @Tabla AS Tabla
ORDER BY IDR
FOR XML AUTO)
IF NOT ISNULL(@Ok, 0) = 0 SELECT @OkRef = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @ReferenciaIS = Referencia, @SubReferencia = SubReferencia FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

