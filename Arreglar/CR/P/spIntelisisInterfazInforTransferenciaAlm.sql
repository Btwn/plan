SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisInterfazInforTransferenciaAlm
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Almacen							varchar(10),
@EsAlmacenDeDeposito				int,
@EsAlmacenMaterialesExteriores		int,
@NoDisponibleConsumos				int,
@Datos								varchar(max),
@Solicitud							varchar(max),
@ReferenciaIS						varchar(100),
@SubReferencia						varchar(100),
@IDNuevo							int,
@Datos2								varchar(max),
@Resultado2							varchar(max),
@Usuario							varchar(10),
@Contrasena							varchar(32)	,
@ReferenciaIntelisisService			varchar(50)	,
@Planta								varchar(8),
@PlantaDescripcion					varchar(40)
DECLARE
@Tabla			 table
(
CodigoAlmacen			    	 varchar(10),
RazonSocial			         varchar(40),
NombreComercial                 varchar(40),
ContemplarEnCalculoNecesidades  bit,
PermiteRechazos	             bit,
PermiteUbicaciones              bit,
EsAlmacenDeDeposito             bit,
EsAlmacenMaterialesExteriores   bit,
NoDisponibleConsumos            bit,
ReferenciaIntelisisService      varchar(50),
Planta							 varchar(8)
)
IF @Ok IS NULL
BEGIN
SELECT @Almacen = Almacen FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Alm')
WITH (Almacen varchar(255))
SELECT @Planta = INFORClavePlanta FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Alm')
WITH (INFORClavePlanta varchar(255))
SELECT @ReferenciaIS = Referencia ,@Usuario = Usuario , @SubReferencia = SubReferencia
FROM IntelisisService
WHERE ID = @ID
SELECT @Contrasena = Contrasena
FROM Usuario
WHERE Usuario = @Usuario
SELECT @PlantaDescripcion = Descripcion FROM PlantaProductiva WHERE Clave = @Planta
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/></Intelisis>'
SET @Datos='<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.Cuenta.Alm.Listado" SubReferencia="'+@SubReferencia+'" Version="1.0"><Solicitud><Parametro Campo="Almacen" Valor="'+@Almacen+'"/></Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario,@Contrasena,@Datos,@Resultado,@Ok Output,@OkRef Output,1,0,@IDNuevo Output
SELECT @Solicitud = Resultado
FROM IntelisisService
WHERE ID = @IDNuevo
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
INSERT @Tabla (CodigoAlmacen,          RazonSocial ,             NombreComercial,         ContemplarEnCalculoNecesidades, PermiteRechazos,                   PermiteUbicaciones,      EsAlmacenDeDeposito,  EsAlmacenMaterialesExteriores, NoDisponibleConsumos, ReferenciaIntelisisService,Planta)
SELECT Almacen ,SUBSTRING(Nombre,1,40)  , SUBSTRING(Nombre,1,40) , ExcluirPlaneacion  ,            ISNULL(PermiteRechazos,''), ISNULL(PermiteUbicaciones,''),  EsAlmacenDeDeposito,  EsAlmacenMaterialesExteriores, NoDisponibleConsumos ,ReferenciaIntelisisService ,INFORClavePlanta
FROM OPENXML (@iSolicitud, '/Intelisis/Resultado/Alm',1)
WITH (Almacen varchar(100), Nombre varchar(100),ExcluirPlaneacion varchar(100),PermiteRechazos varchar(100),PermiteUbicaciones varchar(100),ReferenciaIntelisisService varchar(100), EsAlmacenDeDeposito varchar(100),   EsAlmacenMaterialesExteriores varchar(100), NoDisponibleConsumos varchar(100), INFORClavePlanta varchar(100))
EXEC sp_xml_removedocument @iSolicitud
SELECT  @ReferenciaIntelisisService =  ReferenciaIntelisisService	FROM @Tabla
SET @Resultado2 = CONVERT(varchar(max) ,(SELECT * FROM @Tabla oAlmacen FOR XML AUTO))
SET @Datos2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Infor" Contenido="Solicitud" Referencia=' + CHAR(34) + 'Infor.Cuenta.Almacen.Mantenimiento' + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Solicitud IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')   + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)  +' ReferenciaIntelisisService='+ CHAR(34)+ ISNULL(@ReferenciaIntelisisService,'')+CHAR(34)+ ' >' + @Resultado2 + '</Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario,@Contrasena,@Datos2,@Resultado2,@Ok Output,@OkRef Output,0,0,@IDNuevo Output
IF @@ERROR <> 0 SET @Ok = 1
END
END

