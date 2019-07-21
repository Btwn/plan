SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisCuentaArtFamListado
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Familia		   varchar(50),
@FamiliaMaestra   varchar(50),
@Icono			   int   ,
@Precios		   bit   ,
@PrecioLista	   money   ,
@Precio2          money   ,
@Precio3          money   ,
@Precio4          money   ,
@CostoReposicion  float   ,
@BasePresupuesto  varchar(20),
@UltimoQuiebre    datetime   ,
@QuiebreFechaD    datetime   ,
@QuiebreFechaA    datetime   ,
@Impuesto1        float   ,
@Impuesto2        float   ,
@Impuesto3        float   ,
@Clave            varchar(20),
@Texto						xml,
@ReferenciaIS				varchar(100),
@SubReferencia				varchar(100)
BEGIN TRANSACTION
IF @Ok IS NULL
BEGIN
SELECT @Familia = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Familia'
SELECT @FamiliaMaestra = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FamiliaMaestra'
SELECT @Icono = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Icono'
SELECT @Precios = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Precios'
SELECT @PrecioLista = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PrecioLista'
SELECT @Precio2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Precio3'
SELECT @Precio3 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Precio3'
SELECT @Precio4 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Precio4'
SELECT @CostoReposicion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CostoReposicion'
SELECT @BasePresupuesto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BasePresupuesto'
SELECT @UltimoQuiebre = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'UltimoQuiebre'
SELECT @QuiebreFechaD = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'QuiebreFechaD'
SELECT @QuiebreFechaA = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'QuiebreFechaA'
SELECT @Impuesto1 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Impuesto1'
SELECT @Impuesto2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Impuesto2'
SELECT @Impuesto3 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Impuesto3'
SELECT @Clave = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Clave'
SELECT @Texto =(SELECT * FROM ArtFam
WITH(NOLOCK) WHERE  ISNULL(Familia,'' ) = ISNULL(ISNULL(@Familia,Familia),'')
AND ISNULL(FamiliaMaestra,'' ) = ISNULL(ISNULL(@FamiliaMaestra,FamiliaMaestra),'')
AND ISNULL(Icono,'' ) = ISNULL(ISNULL(@Icono,Icono),'')
AND ISNULL(PrecioLista,'' ) = ISNULL(ISNULL(@PrecioLista,PrecioLista),'')
AND ISNULL(Precio2,'' ) = ISNULL(ISNULL(@Precio2,Precio2),'')
AND ISNULL(Precio3,'' ) = ISNULL(ISNULL(@Precio3,Precio3),'')
AND ISNULL(Precio4,'' ) = ISNULL(ISNULL(@Precio4,Precio4),'')
AND ISNULL(CostoReposicion,'' ) = ISNULL(ISNULL(@CostoReposicion,CostoReposicion),'')
AND ISNULL(BasePresupuesto,'' ) = ISNULL(ISNULL(@BasePresupuesto,BasePresupuesto),'')
AND ISNULL(UltimoQuiebre,'' ) = ISNULL(ISNULL(@UltimoQuiebre,UltimoQuiebre),'')
AND ISNULL(Impuesto1,'' ) = ISNULL(ISNULL(@Impuesto1,Impuesto1),'')
AND ISNULL(Impuesto2,'' ) = ISNULL(ISNULL(@Impuesto2,Impuesto2),'')
AND ISNULL(Impuesto3,'' ) = ISNULL(ISNULL(@Impuesto3,Impuesto3),'')
AND ISNULL(QuiebreFechaD,'' ) = ISNULL(ISNULL(@QuiebreFechaD,QuiebreFechaD),'')
AND ISNULL(QuiebreFechaA,'' ) = ISNULL(ISNULL(@QuiebreFechaA,QuiebreFechaA),'')
AND ISNULL(Clave,'' ) = ISNULL(ISNULL(@Clave,Clave),'')
FOR XML AUTO)
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WITH(NOLOCK) WHERE ID = @ID
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),@Texto) + '</Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
END
END
END

