SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisCuentaAlmListado
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@ProdInterfazINFOR		bit,
@Almacen				varchar(10),
@Rama					varchar(20),
@Nombre 				varchar(100),
@Colonia     			varchar(100),
@Delegacion				varchar(100),
@Poblacion				varchar(100),
@Estado					varchar(30),
@Pais					varchar(30),
@CodigoPostal 			varchar(15),
@Encargado				varchar(50),
@Grupo      			varchar(50),
@Categoria     			varchar(50),
@Zona        			varchar(30),
@Ruta       			varchar(50),
@Tipo       			varchar(15),
@Sucursal     			int,
@Estatus    			varchar(15),
@Alta       			datetime,
@ExcluirPlaneacion      bit,
@Cuenta					varchar(20),
@PermiteRechazos		bit,
@PermiteUbicaciones     bit,
@Texto					xml,
@ReferenciaIS			varchar(100),
@SubReferencia			varchar(100),
@EsAlmacenDeDeposito    bit,
@EsAlmacenMaterialesExteriores  bit,
@NoDisponibleConsumos    bit
IF @Ok IS NULL
BEGIN
SELECT @Almacen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Almacen'
SELECT @Rama = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Rama'
SELECT @Nombre = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Nombre'
SELECT @Colonia = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Colonia'
SELECT @Delegacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Delegacion'
SELECT @Poblacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Poblacion'
SELECT @Estado = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Estado'
SELECT @Pais = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Pais'
SELECT @CodigoPostal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CodigoPostal'
SELECT @Encargado = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Encargado'
SELECT @Grupo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Grupo '
SELECT @Categoria = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Categoria'
SELECT @Zona = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Zona'
SELECT @Ruta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Ruta'
SELECT @Tipo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tipo'
SELECT @Sucursal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SELECT @Estatus = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Estatus'
SELECT @Alta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Alta'
SELECT @ExcluirPlaneacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ExcluirPlaneacion'
SELECT @Cuenta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cuenta'
SELECT @PermiteRechazos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PermiteRechazos'
SELECT @PermiteUbicaciones = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PermiteUbicaciones'
SELECT @EsAlmacenDeDeposito = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EsAlmacenDeDeposito'
SELECT @EsAlmacenMaterialesExteriores = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EsAlmacenMaterialesExteriores'
SELECT @NoDisponibleConsumos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'NoDisponibleConsumos'
SELECT @Texto =(SELECT * FROM Alm
WHERE  ISNULL(Almacen,'') = ISNULL(ISNULL(@Almacen,Almacen),'')
AND ISNULL(Rama,'') = ISNULL(ISNULL(@Rama,Rama),'')
AND ISNULL(Nombre,'') = ISNULL(ISNULL(@Nombre,Nombre),'')
AND ISNULL(Colonia,'') = ISNULL(ISNULL(@Colonia,Colonia),'')
AND ISNULL(Delegacion,'') =	ISNULL(ISNULL(@Delegacion,Delegacion),'')
AND ISNULL(Poblacion,'')  =	ISNULL(ISNULL(@Poblacion,Poblacion),'')
AND ISNULL(Estado,'') =	ISNULL(ISNULL(@Estado,Estado),'')
AND ISNULL(Pais,'') =	ISNULL(ISNULL(@Pais,Pais),'')
AND ISNULL(CodigoPostal,'') = ISNULL(ISNULL(@CodigoPostal,CodigoPostal),'')
AND ISNULL(Encargado,'') = ISNULL(ISNULL(@Encargado,Encargado),'')
AND ISNULL(Grupo,'') = ISNULL(ISNULL(@Grupo,Grupo),'')
AND ISNULL(Categoria,'') = ISNULL(ISNULL(@Categoria,Categoria),'')
AND ISNULL(Zona,'') = ISNULL(ISNULL(@Zona,Zona),'')
AND ISNULL(Ruta,'') = ISNULL(ISNULL(@Ruta,Ruta),'')
AND ISNULL(Tipo,'') = ISNULL(ISNULL(@Tipo,Tipo),'')
AND ISNULL(Sucursal,'') = ISNULL(ISNULL(@Sucursal,Sucursal),'')
AND ISNULL(Estatus,'') = ISNULL(ISNULL(@Estatus,Estatus),'')
AND ISNULL(Alta,'') = ISNULL(ISNULL(@Alta,Alta),'')
AND ISNULL(ExcluirPlaneacion,'') = ISNULL(ISNULL(@ExcluirPlaneacion,ExcluirPlaneacion),'')
AND ISNULL(Cuenta,'') =	ISNULL(ISNULL(@Cuenta,Cuenta),'')
FOR XML AUTO)
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),@Texto) + '</Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
END
END

