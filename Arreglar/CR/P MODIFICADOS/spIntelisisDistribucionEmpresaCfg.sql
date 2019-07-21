SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisDistribucionEmpresaCfg
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
@CB                      bit,
@CBDirAlmacen            bit,
@CBPreguntarCantidad     bit,
@CBProcesarLote          bit,
@CBSerieLote             bit,
@CBSubCodigos            bit,
@CBSubCuentas            bit
DECLARE @Tabla   table(
CB                       bit,
CBDirAlmacen             bit,
CBPreguntarCantidad      bit,
CBProcesarLote           bit,
CBSerieLote              bit,
CBSubCodigos             bit,
CBSubCuentas             bit
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SET @Empresa = ISNULL(@Empresa,'')
INSERT INTO @Tabla (CB, CBDirAlmacen, CBPreguntarCantidad, CBProcesarLote, CBSerieLote, CBSubCodigos, CBSubCuentas)
SELECT ISNULL(CB,0),
ISNULL(CBDirAlmacen,0),
ISNULL(CBPreguntarCantidad,0),
ISNULL(CBProcesarLote,0),
ISNULL(CBSerieLote,0),
ISNULL(CBSubCodigos,0),
ISNULL(CBSubCuentas,0)
FROM EmpresaCfg
WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @Texto = (SELECT CAST(ISNULL(CB,0) AS varchar)                  AS CB,
CAST(ISNULL(CBDirAlmacen,0) AS varchar)        AS CBDirAlmacen,
CAST(ISNULL(CBPreguntarCantidad,0) AS varchar) AS CBPreguntarCantidad,
CAST(ISNULL(CBProcesarLote,0) AS varchar)      AS CBProcesarLote,
CAST(ISNULL(CBSerieLote,0) AS varchar)         AS CBSerieLote,
CAST(ISNULL(CBSubCodigos,0) AS varchar)        AS CBSubCodigos,
CAST(ISNULL(CBSubCuentas,0) AS varchar)        AS CBSubCuentas
FROM @Tabla AS Tabla
FOR XML AUTO)
IF NOT ISNULL(@Ok, 0) = 0 SELECT @OkRef = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @ReferenciaIS = Referencia, @SubReferencia = SubReferencia FROM IntelisisService with(nolock) WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

