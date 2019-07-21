SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisInterfazInforTransferenciaArt
@ID		 int,
@iSolicitud     int,
@Version	 float,
@Resultado	 varchar(max) = NULL OUTPUT,
@Ok		 int		  = NULL OUTPUT,
@OkRef		 varchar(255) = NULL OUTPUT

AS BEGIN
IF @Ok IS NULL
BEGIN
DECLARE
@Articulo			varchar(20),
@Datos				varchar(max),
@Solicitud			varchar(max),
@ReferenciaIS			varchar(100),
@SubReferencia			varchar(100),
@IDNuevo			int,
@Datos2				varchar(max),
@Resultado2			varchar(max),
@Usuario			varchar(10),
@Contrasena			varchar(32)	,
@ReferenciaIntelisisService	varchar(50)
DECLARE
@Tabla	table (
CodigoArticulo		        varchar(20),
Descripcion			varchar(100),
ReferenciaIntelisisService	varchar(50),
TipoArticulo			varchar(50),
Existencia              	float ,
StockMinimo			float   ,
Familia				varchar(50),
Subfamilia 			varchar(50),
UltimoPrecioCoste		float ,
PrecioCosteMedio		float ,
ProveedorHabooleanual 		varchar(50),
PlazoAprovisionam		int ,
PlazoSeguridad			float ,
SerieMinimaRentable		float ,
StockMaximo			float ,
UnidReservadas			float ,
UnidOrdenadas			float,
Codigo2				varchar(50),
Codigo3				varchar(20) ,
FechaUltimaCompra		datetime ,
FechaUltimaEntrada		datetime ,
FechaUltimaSalida		datetime ,
FechaCreacion			datetime ,
PesoNeto			float   ,
PesoBruto			float   ,
UnidMedidaCompra		varchar(50),
UnidMedidaVenta			varchar(50),
UnidMedidaAlmacen		varchar(50),
MultiploFabricacion		float   ,
TipoEnvase			varchar(30),
CantidadEnvase			float   ,
NumPlano			varchar(20) ,
CodigoMoldeMatriz	    	varchar(20) ,
EstadoArticulo			varchar(15),
UnidConverCompra		float   ,
AlmacenDefecto 			varchar(10),
CodigoUltimoProv 		varchar	(10),
Inventariable			bit  ,
UbicacionDefecto        	varchar(8),
FechaDeAlta			datetime ,
FechaUltimaModificacion	        datetime   ,
UsuarioAlta			varchar(10),
UsuarioModificacion		datetime ,
Version				int ,
GuardaVersion           	varchar(1),
Descripcion2			varchar(255),
SumatorioComponentes		float ,
UnidConverVenta			varchar(50),
PrecioCosteStandard		float ,
PrecioCompra			float ,
PrecioCompraDivisa		varchar(10),
CodigoMoneda			varchar(10),
PorcIVA				float   ,
PorcRecargo			float ,
ABC				varchar(1),
CriterioAsignacionLote  	varchar(4) ,
NumeroSerie			varchar(20) ,
DiasCuarentena			int,
RevisionPlano			varchar(10),
FechaUltimaRevisionPlano	datetime   ,
UnidMedidasEnvase		varchar(50),
MedidaEnvaseLargo		float ,
MedidaEnvaseAncho		float ,
MedidaEnvaseAlto		float ,
UnidVolumenEnvase		varchar(50) ,
MedidaEnvaseVolumen		float ,
ClientePrincipal		varchar(10) ,
ClienteExclusivo		varchar(10) ,
PrecioHIFO			money   ,
FechaPrecioHIFO			datetime ,
MultiploConsumo			float   ,
ValorNumeroSerie		varchar(20)   ,
CosteStandarMOE			float ,
PrecioVenta			money   ,
IDDocumAdjuntos			int ,
MesesGarantia			int,
SistemaDistribucionObjetivos	varchar(10) ,
PorcComision			float ,
CodNomenclaturaCombinada	varchar(25) ,
RegimenEstadisticoHabooleanual	varchar(1),
NaturalezaTransaccionA  	varchar(1) ,
NaturalezaTransaccionB  	varchar(1) ,
CodUnidadSuplem         	varchar(50),
FactorConversionSuplem		varchar(50),
ClaseArticulo			varchar(20),
Plantilla			int ,
GeneradorPlantilla		varchar(20) ,
CodigoEstructura		varchar(20) ,
TipoImpuesto			float   ,
TipoArticuloVariantes		int ,
MesesCaducidad			decimal (6,2),
Generico			int ,
FijarCosteStandard		bit ,
ProveedorHabooleanualObjeto	varchar(10),
AlmacenDefectoObjeto		varchar(10),
UbicacionDefectoObjeto		varchar(10),
TipoDeAsignacion		varchar(20),
TiempoEntrega           	int	,
Trazabilidad			bit,
LotificacionPropia      	bit,
UltimoNoLote            	int,
UnidadesMaxLote         	int,
TieneNumerodeSerie      	bit,
CantidadMinimaVenta     	float,
INFORAlmacenProd		varchar(20),
Tipo             		varchar(20),
Situacion             		varchar(50)
)
SELECT @Articulo = Articulo FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Art')
WITH (Articulo varchar(255))
SELECT @ReferenciaIS = Referencia ,@Usuario = Usuario , @SubReferencia = SubReferencia
FROM IntelisisService
WHERE ID = @ID
SELECT @Contrasena = Contrasena
FROM Usuario
WHERE Usuario = @Usuario
SET @Resultado	= '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/></Intelisis>'
SET @Datos		= '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.Cuenta.Articulo.Listado" SubReferencia="'+@SubReferencia+'" Version="1.0"><Solicitud><Parametro Campo="Articulo" Valor="'+@Articulo+'"/></Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario,@Contrasena,@Datos,@Resultado,@Ok Output,@OkRef Output,1,0,@IDNuevo Output
SELECT @Solicitud = Resultado
FROM IntelisisService
WHERE ID = @IDNuevo
EXEC	sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
INSERT @Tabla (CodigoArticulo, ReferenciaIntelisisService, Descripcion,  TipoArticulo,                                                                                                                             Existencia, StockMinimo,                                    Familia,				Subfamilia,     PrecioCosteMedio,							ProveedorHabooleanual,  PlazoAprovisionam,			PlazoSeguridad,					CantidadMinimaVenta ,             StockMaximo,					 Codigo2,       PesoNeto,   PesoBruto,  UnidMedidaCompra,								UnidMedidaVenta,								 UnidMedidaAlmacen,						 MultiploFabricacion,			TipoEnvase,  CantidadEnvase,            EstadoArticulo, UnidConverCompra,			AlmacenDefecto,			CodigoUltimoProv, FechaUltimaModificacion, UsuarioAlta, Descripcion2,  UnidConverVenta,				PrecioCosteStandard,                      PrecioCompra,                             PrecioCompraDivisa,							CodigoMoneda, PorcIVA,   ABC, RevisionPlano,            FechaUltimaRevisionPlano, UnidMedidasEnvase,	PrecioHIFO,					MultiploConsumo,   ValorNumeroSerie, CosteStandarMOE,							PrecioVenta, CodUnidadSuplem,  FactorConversionSuplem, ClaseArticulo,       TipoImpuesto,								ProveedorHabooleanualObjeto, AlmacenDefectoObjeto,	UltimoPrecioCoste,			UnidReservadas,     UnidOrdenadas,     Codigo3,        FechaUltimaCompra,	     FechaUltimaEntrada,        FechaUltimaSalida,        FechaCreacion,	         NumPlano,        CodigoMoldeMatriz,        Inventariable ,    UbicacionDefecto,        FechaDeAlta,	         UsuarioModificacion,        Version,     GuardaVersion ,        SumatorioComponentes,	   PorcRecargo,	      CriterioAsignacionLote,		 NumeroSerie,	DiasCuarentena,				MedidaEnvaseLargo,	        MedidaEnvaseAncho,	        MedidaEnvaseAlto,	     UnidVolumenEnvase,	        MedidaEnvaseVolumen,	    ClientePrincipal,	      ClienteExclusivo,	        FechaPrecioHIFO, 	         IDDocumAdjuntos,	 	     MesesGarantia,	    SistemaDistribucionObjetivos,	     PorcComision,	    CodNomenclaturaCombinada,	     RegimenEstadisticoHabooleanual,	    NaturalezaTransaccionA,	        NaturalezaTransaccionB , 	    Plantilla,	        GeneradorPlantilla,	        CodigoEstructura,	     MesesCaducidad,									Generico,     FijarCosteStandard,	    UbicacionDefectoObjeto,			TiempoEntrega,																																						Trazabilidad,		LotificacionPropia  ,    UltimoNoLote,                    UnidadesMaxLote,                   TieneNumerodeSerie, SerieMinimaRentable,	TipoDeAsignacion,		INFORAlmacenProd, Tipo, Situacion)
SELECT	   Articulo,		ReferenciaIntelisisService,	Descripcion1, CASE INFORTipo WHEN 'PRODUCTO ACABADO' THEN 1 WHEN 'SEMIELABORADO' THEN 2 WHEN 'TRABAJO EXTERIOR' THEN 3 WHEN 'MATERIA PRIMA' THEN 4 END, '0',        INFORStockMinimo=ISNULL(INFORStockMinimo,0),	SUBSTRING(Familia,1,4), Linea,			CONVERT(float,ISNULL(CostoPromedio,0.00)),  ISNULL(Proveedor,''),	ISNULL(TiempoEntrega,0),	ISNULL(TiempoEntregaSeg,0.00),	ISNULL(CantidadMinimaVenta,0.00), ISNULL(INFORStockMaximo,0.00), CodigoAlterno, Peso,		Peso, UnidadCompra, UnidadTraspaso, Unidad, ISNULL(MultiplosOrdenar,0.00), LoteOrdenar, ISNULL(CantidadOrdenar,0), Estatus,        ISNULL(FactorCompra,''),	ISNULL(AlmacenROP,''),  Proveedor,        UltimoCambio,            Usuario,     Descripcion2,  ISNULL(UnidadTraspaso,''),   CONVERT(float,ISNULL(CostoEstandar,0.0)), CONVERT(float,ISNULL(CostoEstandar,0.0)), CONVERT(float,ISNULL(CostoEstandar,0.0)),   MonedaCosto,  Impuesto1, ABC, RevisionFrecuenciaUnidad, RevisionUltima,           ISNULL(UnidadCompra,''),	ISNULL(PrecioLista,0.00),	MultiplosOrdenar,  Consecutivo,		 CONVERT(float,ISNULL(CostoEstandar,0.0)),  PrecioLista, CodigoAlterno,    Factor,                 SUBSTRING(Tipo,1,4), SUBSTRING(CONVERT(varchar,Impuesto1),1,3),	Proveedor,                   ISNULL(AlmacenROP,''),	ISNULL(UltimoCosto,0.0),	UnidReservadas = 0, UnidOrdenadas = 0, Codigo3 = NULL, FechaUltimaCompra = NULL, FechaUltimaEntrada = NULL, FechaUltimaSalida = NULL, FechaCreacion = GETDATE(), NumPlano = NULL, CodigoMoldeMatriz = NULL, Inventariable = 1 ,UbicacionDefecto = NULL, FechaDeAlta = GETDATE(), UsuarioModificacion = Null, Version = 0, GuardaVersion = NULL , SumatorioComponentes = 0, PorcRecargo = 0.0, CriterioAsignacionLote = NULL, INFORNoSerie,	isnull(INFORCuarentena,''),	MedidaEnvaseLargo = NULL,	MedidaEnvaseAncho = NULL,	MedidaEnvaseAlto = NULL, UnidVolumenEnvase = NULL,	MedidaEnvaseVolumen	= NULL,	ClientePrincipal = NULL,  ClienteExclusivo = NULL,	FechaPrecioHIFO	= GETDATE(), IDDocumAdjuntos	= NULL,  MesesGarantia = 0,	SistemaDistribucionObjetivos = NULL, PorcComision = 0,	CodNomenclaturaCombinada = NULL, RegimenEstadisticoHabooleanual = NULL,	NaturalezaTransaccionA = NULL,	NaturalezaTransaccionB = NULL, 	Plantilla = NULL,	GeneradorPlantilla = NULL,	CodigoEstructura = NULL, CEILING(CONVERT(float,CaducidadMinima) / 30.0) ,	Generico = 0, FijarCosteStandard = 1,	UbicacionDefectoObjeto = NULL,	isnull(TiempoEntrega * CASE WHEN TiempoEntregaUnidad ='Dias' Then 1 WHEN TiempoEntregaUnidad ='Semanas' Then 7 WHEN TiempoEntregaUnidad ='Meses' Then 30 END, 0),	INFORTrazabilidad,	INFORLotificacionPropia, ISNULL(INFORUltimoNumeroLote,0), ISNULL(INFORUnidadesMaximaLote,0), INFORTieneNoSerie,  ISNULL(INFORSMR,0.0),	INFORTipoDeAsignacion,	isnull(INFORAlmacenProd,''), ISNULL(Tipo,''), ISNULL(Situacion,'')
FROM	OPENXML (@iSolicitud, '/Intelisis/Resultado/Art',1)
WITH	(Articulo varchar(100),ReferenciaIntelisisService varchar(100), Descripcion1 varchar(100), INFORTipo varchar(100), INFORStockMinimo varchar(100), Familia varchar(100), Linea varchar(100), CostoEstandar varchar(100), GarantiaPlazo varchar(100), TiempoEntregaSeg varchar(100), CantidadMinimaVenta    float, INFORStockMaximo varchar(100), CodigoAlterno varchar(100), Peso varchar(100), UnidadCompra varchar(100), UnidadTraspaso varchar(100), Unidad varchar(100), MultiplosOrdenar varchar(100), LoteOrdenar varchar(100), CantidadOrdenar varchar(100), Estatus varchar(100), FactorCompra varchar(100), AlmacenROP varchar(100), Proveedor varchar(100), UltimoCambio varchar(100), Alta varchar(100), Usuario varchar(100),Descripcion2 varchar(100), MonedaCosto varchar(100), Impuesto1 varchar(100), ABC varchar(100), RevisionFrecuenciaUnidad varchar(100), RevisionUltima varchar(100), LotesAuto varchar(100), Consecutivo varchar(100), PrecioLista varchar(100), Factor varchar(100), Tipo varchar(100),CostoPromedio varchar(100),UltimoCosto varchar(100) ,TiempoEntrega varchar(100) ,TiempoEntregaUnidad varchar(100),CaducidadMinima varchar(100),INFORCuarentena varchar(100),INFORTrazabilidad varchar(100), INFORLotificacionPropia varchar(100), INFORUltimoNumeroLote varchar(100), INFORUnidadesMaximaLote varchar(100), INFORTieneNoSerie varchar(100), INFORSMR varchar(100),INFORTipoDeAsignacion varchar(100),INFORNoSerie varchar(100),INFORAlmacenProd varchar(20),  Situacion varchar(50))
EXEC	sp_xml_removedocument @iSolicitud
SELECT	@ReferenciaIntelisisService = ReferenciaIntelisisService
FROM	@Tabla
SET		@Resultado2 = CONVERT(varchar(max), (SELECT * FROM @Tabla oArticulo FOR XML AUTO))
SET		@Datos2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Infor" Contenido="Solicitud" Referencia=' + CHAR(34) +'Infor.Cuenta.Articulo.Mantenimiento' + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Solicitud IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')   + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)  + ' ReferenciaIntelisisService='+ CHAR(34)+ ISNULL(@ReferenciaIntelisisService,'')+CHAR(34)+ ' >' + ISNULL(@Resultado2,'') + '</Solicitud></Intelisis>'
EXEC	spIntelisisService @Usuario,@Contrasena,@Datos2,@Resultado2,@Ok Output,@OkRef Output,0,0,@IDNuevo Output
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL AND @@ERROR <> 0
SET @Ok = 1
END
END

