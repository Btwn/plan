SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISCuentaUnidad
@ID                     int,
@iSolicitud             int,
@Version                float,
@Resultado              varchar(MAX) = NULL OUTPUT,
@Ok                     int = NULL OUTPUT,
@OkRef                  varchar(max) = NULL OUTPUT

AS BEGIN
SET NOCOUNT ON
DECLARE
@ReferenciaIS         varchar(100),
@SubReferenciaIS      varchar(100),
@Tabla                varchar(max)
SELECT @ReferenciaIS = Referencia ,@SubReferenciaIS = SubReferencia
FROM IntelisisService
WHERE ID = @ID
SELECT @Tabla = (SELECT * FROM Unidad FOR XML AUTO)
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia='+ CHAR(34) + ISNULL(@SubReferenciaIS,'') + CHAR(34) +' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)+ '>'+ISNULL(@Tabla,'')+'</Resultado></Intelisis>'
END

