SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisArticuloUnidadListado
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto						xml,
@ReferenciaIS				varchar(100),
@SubReferencia				varchar(100),
@Mov						varchar(20),
@MovID			            varchar(20),
@Empresa				    varchar(5),
@Sucursal			        int,
@Sucursal2					varchar(100),
@Tarima						varchar(20),
@Posicion					varchar(10),
@ArticuloEsp			    varchar(20),
@Descripcion			    varchar(100),
@Unidad						varchar(50),
@Cantidad			        float,
@Tipo						varchar(20),
@Disponible				    float,
@DescripcionPosicion		varchar(100),
@PosicionDestino			varchar(10),
@DescripcionPosicionDestino varchar(100)  ,
@Completo                   int,
@Codigo					    varchar(50),
@CfgMultiUnidades	        bit,
@CfgMultiUnidadesNivel      char(20)
SELECT  @Empresa  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT  @ArticuloEsp  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ArticuloEsp'
SELECT @CfgMultiUnidades         = ISNULL(MultiUnidades,0),
@CfgMultiUnidadesNivel    = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
IF @CfgMultiUnidadesNivel = 'ARTICULO'
SELECT @Texto =(SELECT Unidad, ISNULL(Factor ,1) Factor
FROM ArtUnidad
WITH(NOLOCK) WHERE Articulo=@ArticuloEsp
FOR XML AUTO)
IF @Texto IS NULL
SELECT @Texto =(SELECT Unidad, ISNULL(Factor ,1) Factor
FROM Unidad with(nolock)
FOR XML AUTO)
IF @Texto IS NULL 
SELECT @Ok = 14055, @OkRef='' 
IF @@ERROR <> 0 SET @Ok = 1
BEGIN
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WITH(NOLOCK) WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NOT NULL SELECT @Descripcion = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + ' Descripcion="' + ISNULL(@Descripcion,'') +'">' + CONVERT(varchar(max),ISNULL(@Texto,'')) + '</Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
END
END

