SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisCuentaSucursalListado
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Sucursal  			    varchar(10)  ,
@Nombre  					varchar(100),
@Prefijo  					char(5),
@Relacion  			    varchar(20),
@Direccion  			    varchar(100),
@DireccionNumero  			varchar(20),
@DireccionNumeroInt  		varchar(20),
@Delegacion  			    varchar(100),
@GLN  						varchar(50),
@Colonia  					varchar(30),
@Poblacion  			    varchar(30),
@Estado  					varchar(30),
@Pais  					varchar(30),
@CodigoPostal  			varchar(15),
@Telefonos  			    varchar(100),
@Fax  						varchar(50),
@Estatus  					char(15),
@UltimoCambio  			datetime   ,
@RFC  						varchar(20),
@RegistroPatronal  		varchar(20),
@Encargado  			    varchar(100),
@Alta  					datetime   ,
@Region  					varchar(50),
@CentralRegional  			bit   ,
@EnLinea  					bit   ,
@SucursalPrincipal  		int   ,
@ListaPreciosEsp  			varchar(20),
@Cajeros  					bit   ,
@CentroCostos  			varchar(20),
@OperacionContinua  		bit   ,
@ZonaEconomica  			varchar(30),
@Grupo  					varchar(50),
@AlmacenPrincipal  		char(10),
@Servidor  			    varchar(50),
@BaseDatos  			    varchar(50),
@Usuario  					varchar(10),
@ZonaImpuesto  			varchar(30),
@CajaCentral  			    varchar(10),
@wMovVentas  			    varchar(20),
@wAlmacen  			    varchar(10),
@wAgente  					varchar(10),
@wUsuario  			    varchar(10),
@wUEN  					int   ,
@wConcepto  			    varchar(50),
@CRTipoCredito  			varchar(20),
@Cliente  					varchar(10),
@Categoria  			    varchar(50),
@Acreedor  			    varchar(10),
@LocalidadCNBV  		    varchar(10),
@Tipo  					varchar(50),
@FechaApertura  		    datetime   ,
@VencimientoContrato  	    datetime   ,
@Metros   					float   ,
@CostoBase  			    varchar(50),
@UltimaSincronizacion      datetime   ,
@IP  						varchar(20),
@IPDinamica  			    bit   ,
@IPPuerto  			    int   ,
@ComunicacionEncriptada    bit   ,
@MapaLatitud   		    float   ,
@MapaLongitud   		    float   ,
@MapaPrecision  		    int   ,
@BloquearCobroTarjeta      bit   ,
@FiscalRegimen  		    varchar(30),
@ReferenciaIntelisisService varchar(50),
@Texto						xml,
@ReferenciaIS				varchar(100),
@SubReferencia				varchar(100)
SELECT @Sucursal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SELECT @Nombre = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Nombre'
SELECT @Prefijo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Prefijo'
SELECT @Relacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Relacion'
SELECT @Direccion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Direccion'
SELECT @DireccionNumero = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DireccionNumero'
SELECT @DireccionNumeroInt = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DireccionNumeroInt'
SELECT @Delegacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Delegacion'
SELECT @GLN = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'GLN'
SELECT @Colonia = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Colonia'
SELECT @Poblacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Poblacion'
SELECT @Estado = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Estado'
SELECT @Pais = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Pais'
SELECT @CodigoPostal  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CodigoPostal'
SELECT @Telefonos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Telefonos'
SELECT @Fax = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Fax'
SELECT @Estatus = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Estatus'
SELECT @UltimoCambio = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'UltimoCambio'
SELECT @RFC = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RFC'
SELECT @RegistroPatronal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RegistroPatronal'
SELECT @Encargado = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Encargado'
SELECT @Alta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Alta'
SELECT @Region = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Region'
SELECT @CentralRegional = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CentralRegional'
SELECT @EnLinea = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EnLinea'
SELECT @SucursalPrincipal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SucursalPrincipal'
SELECT @ListaPreciosEsp = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ListaPreciosEsp'
SELECT @Cajeros = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cajeros'
SELECT @CentroCostos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CentroCostos'
SELECT @OperacionContinua = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'OperacionContinua'
SELECT @ZonaEconomica = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ZonaEconomica'
SELECT @Grupo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Grupo'
SELECT @AlmacenPrincipal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AlmacenPrincipal'
SELECT @Servidor = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Servidor'
SELECT @BaseDatos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BaseDatos'
SELECT @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SELECT @ZonaImpuesto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ZonaImpuesto'
SELECT @CajaCentral = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CajaCentral'
SELECT @wMovVentas = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'wMovVentas'
SELECT @wAlmacen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'wAlmacen'
SELECT @wAgente = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'wAgente'
SELECT @wUsuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'wUsuario'
SELECT @wUEN = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'wUEN'
SELECT @wConcepto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'wConcepto'
SELECT @CRTipoCredito = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CRTipoCredito'
SELECT @Cliente = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cliente'
SELECT @Categoria = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Categoria'
SELECT @Acreedor = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Acreedor'
SELECT @LocalidadCNBV = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'LocalidadCNBV'
SELECT @Tipo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tipo'
SELECT @FechaApertura = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FechaApertura'
SELECT @VencimientoContrato = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'VencimientoContrato'
SELECT @Metros = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Metros'
SELECT @CostoBase = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CostoBase'
SELECT @UltimaSincronizacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'UltimaSincronizacion'
SELECT @IP = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'IP'
SELECT @IPDinamica = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'IPDinamica'
SELECT @IPPuerto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'IPPuerto'
SELECT @ComunicacionEncriptada = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ComunicacionEncriptada'
SELECT @MapaLatitud = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MapaLatitud'
SELECT @MapaLongitud = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MapaLongitud'
SELECT @MapaPrecision = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MapaPrecision'
SELECT @BloquearCobroTarjeta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearCobroTarjeta'
SELECT @FiscalRegimen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FiscalRegimen'
SELECT @Texto =(SELECT * FROM Sucursal
WITH(NOLOCK) WHERE ISNULL(Sucursal,'') = ISNULL(ISNULL(@Sucursal,Sucursal),'')
AND ISNULL(Nombre,'') = ISNULL(ISNULL(@Nombre,Nombre),'')
AND ISNULL(Prefijo,'') = ISNULL(ISNULL(@Prefijo,Prefijo),'')
AND ISNULL(Relacion,'') = ISNULL(ISNULL(@Relacion,Relacion),'')
AND ISNULL(Direccion,'') = ISNULL(ISNULL(@Direccion,Direccion),'')
AND ISNULL(DireccionNumero,'') = ISNULL(ISNULL(@DireccionNumero,DireccionNumero),'')
AND ISNULL(DireccionNumeroInt,'') = ISNULL(ISNULL(@DireccionNumeroInt,DireccionNumeroInt),'')
AND ISNULL(Delegacion,'') = ISNULL(ISNULL(@Delegacion,Delegacion),'')
AND ISNULL(GLN,'') = ISNULL(ISNULL(@GLN,GLN),'')
AND ISNULL(Colonia,'') = ISNULL(ISNULL(@Colonia,Colonia),'')
AND ISNULL(Poblacion,'') = ISNULL(ISNULL(@Poblacion,Poblacion),'')
AND ISNULL(Estado,'') = ISNULL(ISNULL(@Estado,Estado),'')
AND ISNULL(Pais,'') = ISNULL(ISNULL(@Pais,Pais),'')
AND ISNULL(CodigoPostal,'') = ISNULL(ISNULL(@CodigoPostal,CodigoPostal),'')
AND ISNULL(Telefonos,'') = ISNULL(ISNULL(@Telefonos,Telefonos),'')
AND ISNULL(Fax,'') = ISNULL(ISNULL(@Fax,Fax),'')
AND ISNULL(Estatus,'') = ISNULL(ISNULL(@Estatus,Estatus),'')
AND ISNULL(UltimoCambio,'') = ISNULL(ISNULL(@UltimoCambio,UltimoCambio),'')
AND ISNULL(RFC,'') = ISNULL(ISNULL(@RFC,RFC),'')
AND ISNULL(RegistroPatronal,'') = ISNULL(ISNULL(@RegistroPatronal,RegistroPatronal),'')
AND ISNULL(Encargado,'') = ISNULL(ISNULL(@Encargado,Encargado),'')
AND ISNULL(Alta,'') = ISNULL(ISNULL(@Alta,Alta),'')
AND ISNULL(Region,'') = ISNULL(ISNULL(@Region,Region),'')
AND ISNULL(CentralRegional,'') = ISNULL(ISNULL(@CentralRegional,CentralRegional),'')
AND ISNULL(EnLinea,'') = ISNULL(ISNULL(@EnLinea,EnLinea),'')
AND ISNULL(SucursalPrincipal,'') = ISNULL(ISNULL(@SucursalPrincipal,SucursalPrincipal),'')
AND ISNULL(ListaPreciosEsp,'') = ISNULL(ISNULL(@ListaPreciosEsp,ListaPreciosEsp),'')
AND ISNULL(Cajeros,'') = ISNULL(ISNULL(@Cajeros,Cajeros),'')
AND ISNULL(CentroCostos,'') = ISNULL(ISNULL(@CentroCostos,CentroCostos),'')
AND ISNULL(OperacionContinua,'') = ISNULL(ISNULL(@OperacionContinua,OperacionContinua),'')
AND ISNULL(ZonaEconomica,'') = ISNULL(ISNULL(@ZonaEconomica,ZonaEconomica),'')
AND ISNULL(Grupo,'') = ISNULL(ISNULL(@Grupo,Grupo),'')
AND ISNULL(AlmacenPrincipal,'') = ISNULL(ISNULL(@AlmacenPrincipal,AlmacenPrincipal),'')
AND ISNULL(Servidor,'') = ISNULL(ISNULL(@Servidor,Servidor),'')
AND ISNULL(BaseDatos,'') = ISNULL(ISNULL(@BaseDatos,BaseDatos),'')
AND ISNULL(Usuario,'') = ISNULL(ISNULL(@Usuario,Usuario),'')
AND ISNULL(ZonaImpuesto,'') = ISNULL(ISNULL(@ZonaImpuesto,ZonaImpuesto),'')
AND ISNULL(CajaCentral,'') = ISNULL(ISNULL(@CajaCentral,CajaCentral),'')
AND ISNULL(wMovVentas,'') = ISNULL(ISNULL(@wMovVentas,wMovVentas),'')
AND ISNULL(wAlmacen,'') = ISNULL(ISNULL(@wAlmacen,wAlmacen),'')
AND ISNULL(wAgente,'') = ISNULL(ISNULL(@wAgente,wAgente),'')
AND ISNULL(wUsuario,'') = ISNULL(ISNULL(@wUsuario,wUsuario),'')
AND ISNULL(wUEN,'') = ISNULL(ISNULL(@wUEN,wUEN),'')
AND ISNULL(wConcepto,'') = ISNULL(ISNULL(@wConcepto,wConcepto),'')
AND ISNULL(CRTipoCredito,'') = ISNULL(ISNULL(@CRTipoCredito,CRTipoCredito),'')
AND ISNULL(Cliente,'') = ISNULL(ISNULL(@Cliente,Cliente),'')
AND ISNULL(Categoria,'') = ISNULL(ISNULL(@Categoria,Categoria),'')
AND ISNULL(Acreedor,'') = ISNULL(ISNULL(@Acreedor,Acreedor),'')
AND ISNULL(LocalidadCNBV,'') = ISNULL(ISNULL(@LocalidadCNBV,LocalidadCNBV),'')
AND ISNULL(Tipo,'') = ISNULL(ISNULL(@Tipo,Tipo),'')
AND ISNULL(FechaApertura,'') = ISNULL(ISNULL(@FechaApertura,FechaApertura),'')
AND ISNULL(VencimientoContrato,'') = ISNULL(ISNULL(@VencimientoContrato,VencimientoContrato),'')
AND ISNULL(Metros,'') = ISNULL(ISNULL(@Metros,Metros),'')
AND ISNULL(CostoBase,'') = ISNULL(ISNULL(@CostoBase,CostoBase),'')
AND ISNULL(UltimaSincronizacion,'') = ISNULL(ISNULL(@UltimaSincronizacion,UltimaSincronizacion),'')
AND ISNULL(IP,'') = ISNULL(ISNULL(@IP,IP),'')
AND ISNULL(IPDinamica,'') = ISNULL(ISNULL(@IPDinamica,IPDinamica),'')
AND ISNULL(IPPuerto,'') = ISNULL(ISNULL(@IPPuerto,IPPuerto),'')
AND ISNULL(ComunicacionEncriptada,'') = ISNULL(ISNULL(@ComunicacionEncriptada,ComunicacionEncriptada),'')
AND ISNULL(MapaLatitud,'') = ISNULL(ISNULL(@MapaLatitud,MapaLatitud),'')
AND ISNULL(MapaLongitud,'') = ISNULL(ISNULL(@MapaLongitud,MapaLongitud),'')
AND ISNULL(MapaPrecision,'') = ISNULL(ISNULL(@MapaPrecision,MapaPrecision),'')
AND ISNULL(BloquearCobroTarjeta,'') = ISNULL(ISNULL(@BloquearCobroTarjeta,BloquearCobroTarjeta),'')
AND ISNULL(FiscalRegimen,'') = ISNULL(ISNULL(@FiscalRegimen,FiscalRegimen),'')
FOR XML AUTO)
IF @@ERROR <> 0 SET @Ok = 1
BEGIN
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WITH(NOLOCK) WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),@Texto) + '</Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
END
END
END

