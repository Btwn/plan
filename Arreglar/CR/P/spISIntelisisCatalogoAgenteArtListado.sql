SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISIntelisisCatalogoAgenteArtListado
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@ReferenciaIS			varchar(100),
@SubReferenciaIS		varchar(100),
@Tabla			varchar(max),
@Agente			varchar(10)
SELECT
@ReferenciaIS    = Referencia,
@SubReferenciaIS = SubReferencia
FROM OPENXML (@iSolicitud,'/Intelisis')
WITH (Referencia varchar(100), SubReferencia varchar(100))
SELECT
@Agente    = Agente
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Agente varchar(10))
IF NOT EXISTS(SELECT * FROM Agente WHERE Agente = @Agente)
SELECT @Ok = 26090
IF @Ok IS NOT NULL
SET @OkRef = ISNULL(@OkRef,'')+(SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok)
SELECT @Tabla = ( SELECT Art.Articulo, Art.Descripcion1, Art.Descripcion2, Art.Grupo, Art.Categoria, Art.Familia, Art.Linea, CONVERT(Decimal(20,6),Art.Impuesto1)Impuesto1,  CONVERT(Decimal(20,6),Art.Impuesto2)Impuesto2,  CONVERT(Decimal(20,6),Art.Impuesto3)Impuesto3, Art.Unidad, Art.Tipo, Art.MonedaPrecio, Art.Estatus, Art.Situacion,  CONVERT(Decimal(20,6),Art.Retencion1)Retencion1,  CONVERT(Decimal(20,6),Art.Retencion2)Retencion2,ArtUnidad.*
FROM Art Art JOIN Agenteart aa ON Art.Articulo = aa.Articulo
LEFT JOIN ArtUnidad ArtUnidad ON Art.Articulo = ArtUnidad.Articulo
WHERE aa.Agente = @Agente FOR XML AUTO)
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia='+ CHAR(34) + ISNULL(@SubReferenciaIS,'') + CHAR(34) +' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)+ '>'+ISNULL(@Tabla,'')+'</Resultado></Intelisis>'
END

