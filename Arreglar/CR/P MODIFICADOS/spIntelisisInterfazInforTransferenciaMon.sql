SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisInterfazInforTransferenciaMon
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Moneda							    varchar(10),
@Datos								varchar(max),
@Solicitud							varchar(max),
@ReferenciaIS						varchar(100),
@SubReferencia						varchar(100),
@IDNuevo							int,
@Datos2								varchar(max),
@Resultado2							varchar(max),
@Usuario							varchar(10),
@Contrasena							varchar(32)	,
@ReferenciaIntelisisService			varchar(50)
DECLARE
@Tabla			 table
(
Codigo			    	 varchar(10),
Descripcion			 varchar(30),
DescripcionAbreviada    varchar(4),
ReferenciaIntelisisService      varchar(50),
DecimalesMoneda			int ,
DecimalesPrecios			int
)
SELECT @Moneda = Moneda FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Mon')
WITH (Moneda varchar(255))
SELECT @ReferenciaIS = Referencia ,@Usuario = Usuario , @SubReferencia = SubReferencia
FROM IntelisisService
WITH(NOLOCK) WHERE ID = @ID
SELECT @Contrasena = Contrasena
FROM Usuario
WITH(NOLOCK) WHERE Usuario = @Usuario
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + 'Alm' + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/></Intelisis>'
SET @Datos=
'<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.Cuenta.Mon.Listado" SubReferencia="'+@SubReferencia+'" Version="1.0"><Solicitud><Parametro Campo="Moneda" Valor="'+@Moneda+'"/></Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario,@Contrasena,@Datos,@Resultado,@Ok OUTPUT,@OkRef OUTPUT,1,0,@IDNuevo Output
IF @Ok IS NULL
SELECT @Solicitud = Resultado
FROM IntelisisService
WITH(NOLOCK) WHERE ID = @IDNuevo
IF @Ok IS NULL
BEGIN
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
IF @@ERROR <> 0 SET @Ok = 1
INSERT @Tabla ( Codigo, Descripcion, DescripcionAbreviada,ReferenciaIntelisisService,DecimalesMoneda  ,DecimalesPrecios)
SELECT     Moneda, Nombre,     InforClave,ReferenciaIntelisisService,DecimalesMoneda =2, DecimalesPrecios=2
FROM OPENXML (@iSolicitud, '/Intelisis/Resultado/Mon',1)
WITH (Moneda varchar(100),Nombre varchar(100), InforClave varchar(100),ReferenciaIntelisisService varchar(100))
IF @@ERROR <> 0 SET @Ok = 1
IF @@ERROR <> 0 SET @Ok = 1
END
SELECT @ReferenciaIntelisisService = ReferenciaIntelisisService from @Tabla
SET @Resultado2 = CONVERT(varchar(max) ,(SELECT * FROM @Tabla oMoneda FOR XML AUTO))
SET @Datos2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Infor" Contenido="Solicitud" Referencia=' + CHAR(34) +  'Infor.Cuenta.Moneda.Mantenimiento'  + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Solicitud IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')   + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)  + ' ReferenciaIntelisisService='+ CHAR(34)+ ISNULL(@ReferenciaIntelisisService,'')+CHAR(34)+ ' >' + @Resultado2 + '</Solicitud></Intelisis>'
IF @Ok IS NULL
EXEC spIntelisisService @Usuario,@Contrasena,@Datos2,@Resultado2,@Ok Output,@OkRef Output,0,0,@IDNuevo Output
END

