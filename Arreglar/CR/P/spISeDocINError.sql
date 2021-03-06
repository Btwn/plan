SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISeDocINError
@ID			int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok			int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa				varchar(5),
@Usuario                              varchar(10),
@Sucursal                             int,
@XML2                                 xml,
@Ruta                                 varchar(max),
@Texto                                varchar(max),
@XMLTexto                             varchar(max),
@XML3                                 varchar(max),
@XML                                  xml,
@ReferenciaIS		                varchar(100),
@Estacion                             int,
@Nodo                                 varchar(max),
@Origen                               varchar(max),
@ErrorRef			        varchar(255)
BEGIN TRANSACTION
SELECT @Estacion = @@SPID
SELECT
@Empresa = Empresa,
@Usuario = Usuario,
@Sucursal = Sucursal ,
@Origen = Origen ,
@Ok = Ok    ,
@OkRef = OkRef
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud')
WITH (Empresa varchar(5), Usuario varchar(10), Sucursal int, Origen  varchar(max), Ok int, OkRef varchar(255))
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
COMMIT TRANSACTION
ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT @ErrorRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SELECT @OkRef = ISNULL(@ErrorRef,'')+' '+ISNULL(@OkRef,'')
END
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
SELECT @Texto =(SELECT * FROM eDocInRutaTemp WHERE Estacion = @Estacion FOR XML AUTO)
SELECT @Resultado = '<Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia="" Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
END

