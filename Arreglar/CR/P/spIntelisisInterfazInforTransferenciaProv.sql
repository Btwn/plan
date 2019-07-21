SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisInterfazInforTransferenciaProv
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Proveedor			varchar(10),
@Datos				varchar(max),
@Solicitud			varchar(max),
@ReferenciaIS			varchar(100),
@SubReferencia			varchar(100),
@IDNuevo			int,
@Datos2				varchar(max),
@Resultado2			varchar(max),
@Usuario			varchar(10),
@Contrasena			varchar(32)	,
@CIFDNI				varchar(40),
@TipoEfecto			varchar(40),
@PorcentajeIVA			varchar(40)	,
@ReferenciaIntelisisService	varchar(50)
DECLARE
@Tabla	table
(
CodigoProveedor 		varchar(10),
RazonSocial			varchar(40),
NombreComercial                varchar(40),
Direccion1			varchar(40),
Direccion2			varchar(40),
Poblacion			varchar(40),
Provincia			varchar(40),
CodigoPostal			varchar(40),
CIFDNI				varchar(40),
FormaPago  			varchar(40),
CodigoMoneda 			varchar(40),
TipoEfecto			varchar(40),
ProveedorFormasPagoObjeto	varchar(40),
TipoImpuesto			varchar(40),
ProveedorMonedaObjeto		varchar(40),
BajaComercial			varchar(40),
PorcentajeIVA			varchar(40),
Almacen			varchar(10),
ReferenciaIntelisisService     varchar(50),
TallerExterior			bit,
TipoProveedor			bit
)
SELECT @Proveedor = Proveedor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Prov')
WITH (Proveedor varchar(255))
SELECT @ReferenciaIS = Referencia ,@Usuario = Usuario , @SubReferencia = SubReferencia
FROM IntelisisService
WHERE ID = @ID
SELECT @Contrasena = Contrasena
FROM Usuario
WHERE Usuario = @Usuario
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/></Intelisis>'
SET @CIFDNI = '000000000000001'
SET @TipoEfecto = '0'
SET @PorcentajeIVA = '15'
SET @Datos= '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.Cuenta.Prov.Listado" SubReferencia="'+@SubReferencia+'" Version="1.0"><Solicitud><Parametro Campo="Proveedor" Valor="'+@Proveedor+'"/></Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario,@Contrasena,@Datos,@Resultado,@Ok OUTPUT,@OkRef OUTPUT,1,0,@IDNuevo Output
IF @Ok IS NULL
SELECT @Solicitud = Resultado
FROM IntelisisService
WHERE ID = @IDNuevo
IF @Ok IS NULL
BEGIN
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
IF @@ERROR <> 0 SET @Ok = 1
INSERT @Tabla (CodigoProveedor, RazonSocial,             NombreComercial, Direccion1, Direccion2, Poblacion, Provincia, CodigoPostal, CIFDNI,  FormaPago,                 CodigoMoneda, TipoEfecto,  ProveedorFormasPagoObjeto, TipoImpuesto, ProveedorMonedaObjeto,  BajaComercial, PorcentajeIVA, Almacen, ReferenciaIntelisisService,TallerExterior,     TipoProveedor)
SELECT Proveedor ,      SUBSTRING(Nombre,1,40)  ,NombreCorto ,    Direccion , ' '       , Poblacion, Estado   , CodigoPostal, @CIFDNI, SUBSTRING(FormaPago,1,40), DefMoneda,    @TipoEfecto, DefMoneda,                 '',           DefMoneda,              Estatus,       @PorcentajeIVA,Almacen, ReferenciaIntelisisService,INFORTallerExterior,INFORProveedorNal
FROM OPENXML (@iSolicitud, '/Intelisis/Resultado/Prov',1)
WITH (Proveedor varchar(100), Nombre varchar(100), NombreCorto varchar(100), Direccion varchar(100), Direccion2 varchar(100), Poblacion varchar(100), Estado varchar(100), CodigoPostal varchar(100), FormaPago varchar(100), DefMoneda varchar(100), Estatus varchar(100),ReferenciaIntelisisService  varchar(100),Almacen  varchar(100), INFORTallerExterior varchar(100),INFORProveedorNal varchar(100))
IF @@ERROR <> 0 SET @Ok = 1
EXEC sp_xml_removedocument @iSolicitud
IF @@ERROR <> 0 SET @Ok = 1
END
SELECT @ReferenciaIntelisisService = ReferenciaIntelisisService from @Tabla
SET @Resultado2 = CONVERT(varchar(max) ,(SELECT * FROM @Tabla oProveedor FOR XML AUTO))
SET @Datos2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Infor" Contenido="Solicitud" Referencia=' + CHAR(34) +  'Infor.Cuenta.Proveedor.Mantenimiento'  + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Solicitud IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')   + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)  + ' ReferenciaIntelisisService='+ CHAR(34)+ ISNULL(@ReferenciaIntelisisService,'')+CHAR(34)+ ' >' + @Resultado2 + '</Solicitud></Intelisis>'
IF @Ok IS NULL
EXEC spIntelisisService @Usuario,@Contrasena,@Datos2,@Resultado2,@Ok Output,@OkRef Output,0,0,@IDNuevo Output
END

