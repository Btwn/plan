SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisInterfazInforTransferenciaEmpresa
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS
BEGIN
DECLARE
@Empresa     			varchar(20),
@Datos					varchar(max),
@Solicitud				varchar(max),
@ReferenciaIS			varchar(100),
@SubReferencia			varchar(100),
@IDNuevo				int,
@Datos2					varchar(max),
@Resultado2				varchar(max),
@Usuario				varchar(10),
@Contrasena				varchar(32)	,
@ReferenciaIntelisisService			varchar(50),
@ContMoneda				varchar(20)
DECLARE
@Tabla			 table
(
Clave			varchar(5),
CodigoId			int,
RazonSocial		varchar(40),
NombreComercial	varchar(40),
Moneda	 		varchar(4),
MonedaObjeto	varchar(4),
Direccion1	 	varchar(40),
Direccion2	 	varchar(40),
Poblacion	 	varchar(40),
Provincia	 	varchar(40),
CodigoPostal 	varchar(10),
CodigoPais	 	varchar(4),
Telefono1	 	varchar(16),
Fax	 			varchar(16),
FormaDePago		varchar(2),
TipoDeEfecto	int,
ReferenciaIntelisisService  varchar(50),
ContMoneda				varchar(20)
)
IF @Ok IS NULL
BEGIN
SELECT @Empresa = Empresa FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Empresa')
WITH (Empresa varchar(255))
SELECT @ReferenciaIS = Referencia ,@Usuario = Usuario , @SubReferencia = SubReferencia
FROM IntelisisService
WITH(NOLOCK) WHERE ID = @ID
SELECT @Contrasena = Contrasena
FROM Usuario
WITH(NOLOCK) WHERE Usuario = @Usuario
SELECT @ContMoneda = ContMoneda FROM EmpresaCfg WITH(NOLOCK) WHERE Empresa = @Empresa
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/></Intelisis>'
SET @Datos=
'<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.Cuenta.Empresa.Listado" SubReferencia="'+@SubReferencia+'" Version="1.0"><Solicitud><Parametro Campo="Empresa" Valor="'+@Empresa+'"/></Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario,@Contrasena,@Datos,@Resultado,@Ok Output,@OkRef Output,1,0,@IDNuevo Output
SELECT @Solicitud = Resultado
FROM IntelisisService
WITH(NOLOCK) WHERE ID = @IDNuevo
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
INSERT @Tabla (Clave,   CodigoId,     RazonSocial, NombreComercial, Moneda,        MonedaObjeto,       Direccion1,                 Direccion2,                                 Poblacion, Provincia, CodigoPostal, CodigoPais, Telefono1,                Fax,                     FormaDePago,        TipoDeEfecto,      ReferenciaIntelisisService,ContMoneda)
SELECT Empresa, CodigoId = 1, Nombre,      Nombre,          @ContMoneda, MonedaObjeto='PESO', substring(Direccion,1,40), (DireccionNumero + ' ' + DireccionNumeroInt), Poblacion, Estado,    CodigoPostal, Pais,       substring(Telefonos,1,16),Fax=substring(Fax,1,16), FormadePAgo = 'CO', TipodeEfecto= 1, ReferenciaIntelisisService,@ContMoneda
FROM OPENXML (@iSolicitud, '/Intelisis/Resultado/Empresa',1)
WITH (Empresa varchar (100),Nombre  varchar(100), Direccion    varchar(100), DireccionNumero  varchar(100), DireccionNumeroInt varchar(100), Estado varchar(100), CodigoPostal varchar(100), Pais varchar(100), Telefonos varchar(100), Fax varchar(100), Poblacion varchar(100),ReferenciaIntelisisService  varchar(100))
EXEC sp_xml_removedocument @iSolicitud
SELECT @ReferenciaIntelisisService = ReferenciaIntelisisService from @Tabla
SET @Resultado2 = CONVERT(varchar(max) ,(SELECT * FROM @Tabla oEmpresa FOR XML AUTO))
SET @Datos2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Infor" Contenido="Solicitud" Referencia=' + CHAR(34) +'Infor.Cuenta.Empresa.Mantenimiento' + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Solicitud IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')   + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)  + ' ReferenciaIntelisisService='+ CHAR(34)+ ISNULL(@ReferenciaIntelisisService,'')+CHAR(34)+ ' >' + @Resultado2 + '</Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario,@Contrasena,@Datos2,@Resultado2,@Ok Output,@OkRef Output,0,0,@IDNuevo Output
END
END

