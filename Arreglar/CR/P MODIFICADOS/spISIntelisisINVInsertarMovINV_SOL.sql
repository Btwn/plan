SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISIntelisisINVInsertarMovINV_SOL
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok			int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@IDGenerar				int,
@IDAcceso				int,
@MovTipo				varchar(20),
@ReferenciaIS			varchar(100),
@Usuario2				varchar(10),
@Estacion				int,
@SubReferencia			varchar(100),
@Empresa   				varchar(5),
@Mov   				varchar(20),
@Mov2   				varchar(20),
@Mov3    				varchar(20),
@MovID   				varchar(20),
@FechaEmision   		        datetime   ,
@UltimoCambio   		        datetime   ,
@Concepto   			varchar(50),
@Proyecto   			varchar(50),
@Actividad   			varchar(100),
@UEN   				int   ,
@Moneda   				varchar(10),
@TipoCambio 			float   ,
@Usuario   				varchar(10),
@Autorizacion   		        varchar(10),
@Referencia   			varchar(50),
@DocFuente   			int   ,
@Observaciones   		        varchar(100),
@Estatus   				varchar(15),
@Situacion   			varchar(50),
@SituacionFecha   		        datetime   ,
@SituacionUsuario   	        varchar(10),
@SituacionNota   		        varchar(100),
@Prioridad   			varchar(10),
@Directo   				bit   ,
@RenglonID   			int   ,
@Almacen   				varchar(10),
@AlmacenDestino   		        varchar(10),
@AlmacenTransito   		        varchar(10),
@Largo   				bit   ,
@FechaRequerida   		        datetime   ,
@Condicion   			varchar(50),
@Vencimiento   			datetime   ,
@FormaEnvio   			varchar(50),
@OrigenTipo   			varchar(10),
@Origen   				varchar(20),
@OrigenID   			varchar(20),
@Poliza   				varchar(20),
@PolizaID   			varchar(20),
@GenerarPoliza   		        bit   ,
@ContID   				int   ,
@Ejercicio   			int   ,
@Periodo   				int   ,
@FechaRegistro   		        datetime   ,
@FechaConclusion   		        datetime   ,
@FechaCancelacion   	        datetime   ,
@FechaOrigen   			datetime   ,
@Peso   				float   ,
@Volumen   				float   ,
@Paquetes   			int   ,
@FechaEntrega   		        datetime   ,
@EmbarqueEstado   		        varchar(50),
@Sucursal   			int   ,
@Sucursal2   			int   ,
@Importe				money   ,
@Logico1   				bit   ,
@Logico2   				bit   ,
@Logico3   				bit   ,
@Logico4   				bit   ,
@Logico5   				bit   ,
@Logico6   				bit   ,
@Logico7   				bit   ,
@Logico8   				bit   ,
@Logico9   				bit   ,
@VerLote   				bit   ,
@EspacioResultado   	        bit   ,
@VerDestino   			bit   ,
@EstaImpreso  			bit   ,
@Personal   			varchar(10),
@Reabastecido 			bit   ,
@Conteo   				int   ,
@Agente   				varchar(10),
@ACRetencion   			float   ,
@SubModulo   			varchar(5),
@SucursalOrigen   		        int   ,
@SucursalDestino   		        int   ,
@PedimentoExtraccion   	        varchar(50),
@MovMES				bit,
@IDD		   		int   ,
@Renglon   				float   ,
@Renglon2   			float   ,
@RenglonSub   			int   ,
@RenglonIDD   			int   ,
@RenglonIDD2   			int   ,
@RenglonTipo			char(1),
@Cantidad   			float   ,
@AlmacenD   			varchar(10),
@Codigo				varchar(30),
@Articulo   			varchar(20),
@ArticuloDestino   		        varchar(20),
@SubCuenta   			varchar(50),
@SubCuentaDestino  		        varchar(50),
@Costo				money   ,
@CostoInv				money   ,
@ContUso   				varchar(20),
@Espacio   				varchar(10),
@CantidadReservada   	        float   ,
@CantidadCancelada   	        float   ,
@CantidadOrdenada   	        float   ,
@CantidadPendiente   	        float   ,
@CantidadA   			float   ,
@Paquete   				int   ,
@Aplica   				varchar(20),
@AplicaID   			varchar(20),
@DestinoTipo   			varchar(10),
@Destino				varchar(20),
@DestinoID   			varchar(20),
@Cliente   				varchar(10),
@Unidad   				varchar(50),
@Factor   				float   ,
@CantidadInventario   	        float   ,
@UltimoReservadoCantidad            float   ,
@UltimoReservadoFecha               datetime   ,
@ProdSerieLote   		        varchar(50),
@Merma   				float   ,
@Desperdicio   			float   ,
@Producto   			varchar(20),
@SubProducto   			varchar(20),
@Tipo   				varchar(20),
@Precio				money   ,
@SegundoConteo   		        float   ,
@DescripcionExtra   	        varchar(100),
@AjusteCosteo			money   ,
@CostoUEPS				money   ,
@CostoPEPS				money   ,
@UltimoCosto			money   ,
@PrecioLista			money   ,
@DepartamentoDetallista             int   ,
@AjustePrecioLista		        money   ,
@Posicion   			varchar(10),
@Tarima   				varchar(20),
@Seccion				smallint   ,
@CostoEstandar			money   ,
@FechaCaducidad   		        datetime   ,
@CostoPromedio			money   ,
@CostoReposicion		        money  ,
@Proveedor				varchar(10),
@ReferenciaIntelisisService         varchar(50),
@Articulo2				varchar(20),
@Lote				Varchar(50),
@Cantidad2				float,
@UltRenglonID			int,
@UltRenglonID2			int,
@Tipo2				varchar(20),
@ArtTipo				varchar(20),
@INFORCostoConsumoMat               float,
@INFORCostoManoObra                 float,
@INFORCostoIndirecto                float,
@ReferenciaMES                      varchar(50),
@PedidoMES                          varchar(20),
@Planta                             varchar(20),
@MovO                               varchar(20),
@NuevoID                            int,
@Disponible                         float,
@Ajuste                             int,
@AjustesAutomaticosMES              bit,
@IDMES                              int,
@IDNuevo                            int,
@MoVIDO                             varchar(20),
@IDMarcaje                          int,
@IDSol                              int,
@FormaCosteo                        varchar(20),
@TipoCosteo                         varchar(20),
@Cual                               varchar(20),
@CostoEstandarArt                   float,
@WMS                                bit,
@DefPosicionSurtido                 varchar(10),
@CfgPosiciones		        bit
DECLARE @Temp   table (
RenglonIDD				int ,
IDD		   		int   ,
Renglon   				float   ,
RenglonSub   			int   ,
RenglonID   			int   ,
RenglonTipo			char(1),
Cantidad   			float   ,
Almacen   				varchar(10),
Codigo				varchar(30),
Articulo   			varchar(20),
ArticuloDestino   		        varchar(20),
SubCuenta   			varchar(50),
SubCuentaDestino  		        varchar(50),
Costo				money   ,
CostoInv				money   ,
ContUso   				varchar(20),
Espacio   				varchar(10),
CantidadReservada   	        float   ,
CantidadCancelada   	        float   ,
CantidadOrdenada   	        float   ,
CantidadPendiente   	        float   ,
CantidadA   			float   ,
Paquete   				int   ,
FechaRequerida   		        datetime   ,
Aplica   				varchar(20),
AplicaID   			varchar(20),
DestinoTipo   			varchar(10),
Destino   				varchar(20),
DestinoID   			varchar(20),
Cliente   				varchar(10),
Unidad   				varchar(50),
Factor   				float   ,
CantidadInventario   	        float   ,
UltimoReservadoCantidad            float   ,
UltimoReservadoFecha               datetime   ,
ProdSerieLote   		        varchar(50),
Merma   				float   ,
Desperdicio   			float   ,
Producto   			varchar(20),
SubProducto   			varchar(20),
Tipo   				varchar(20),
Sucursal   			int   ,
Precio				money   ,
SegundoConteo   		        float   ,
DescripcionExtra   	        varchar(100),
AjusteCosteo			money   ,
CostoUEPS				money   ,
CostoPEPS				money   ,
UltimoCosto			money   ,
PrecioLista			money   ,
DepartamentoDetallista             int   ,
AjustePrecioLista		        money   ,
Posicion   			varchar(10),
SucursalOrigen   		        int   ,
Tarima   				varchar(20),
Seccion				smallint   ,
CostoEstandar			money   ,
FechaCaducidad   		        datetime   ,
CostoPromedio			money   ,
CostoReposicion		        money  ,
INFORCostoConsumoMat               float,
INFORCostoManoObra                 float,
INFORCostoIndirecto                float)
DECLARE @Tabla  table (
Empresa				varchar(5),
Modulo				varchar(5),
ID					int,
RenglonID				int,
Articulo				varchar(20),
SubCuenta				varchar(50),
SerieLote				varchar(50),
Cantidad				float,
CantidadAlterna		        float,
Propiedades			varchar(20),
Ubicacion				int,
Cliente				varchar(10),
Localizacion			varchar(10),
Sucursal				int,
ArtCostoInv			money)
DECLARE @Temp2   table (
RenglonIDD				int ,
IDD		   		int   ,
Renglon   				float   ,
RenglonSub   			int   ,
RenglonID   			int   ,
RenglonTipo			char(1),
Cantidad   			float   ,
Almacen   				varchar(10),
Codigo				varchar(30),
Articulo   			varchar(20),
ArticuloDestino   		        varchar(20),
SubCuenta   			varchar(50),
SubCuentaDestino  		        varchar(50),
Costo				money   ,
CostoInv				money   ,
ContUso   				varchar(20),
Espacio   				varchar(10),
CantidadReservada   	        float   ,
CantidadCancelada   	        float   ,
CantidadOrdenada   	        float   ,
CantidadPendiente   	        float   ,
CantidadA   			float   ,
Paquete   				int   ,
FechaRequerida   		        datetime   ,
Aplica   				varchar(20),
AplicaID   			varchar(20),
DestinoTipo   			varchar(10),
Destino   				varchar(20),
DestinoID   			varchar(20),
Cliente   				varchar(10),
Unidad   				varchar(50),
Factor   				float   ,
CantidadInventario   	        float   ,
UltimoReservadoCantidad            float   ,
UltimoReservadoFecha               datetime   ,
ProdSerieLote   		        varchar(50),
Merma   				float   ,
Desperdicio   			float   ,
Producto   			varchar(20),
SubProducto   			varchar(20),
Tipo   				varchar(20),
Sucursal   			int   ,
Precio				money   ,
SegundoConteo   		        float   ,
DescripcionExtra   	        varchar(100),
AjusteCosteo			money   ,
CostoUEPS				money   ,
CostoPEPS				money   ,
UltimoCosto			money   ,
PrecioLista			money   ,
DepartamentoDetallista             int   ,
AjustePrecioLista		        money   ,
Posicion   			varchar(10),
SucursalOrigen   		        int   ,
Tarima   				varchar(20),
Seccion				smallint   ,
CostoEstandar			money   ,
FechaCaducidad   		        datetime   ,
CostoPromedio			money   ,
CostoReposicion		        money  ,
INFORCostoConsumoMat               float,
INFORCostoManoObra                 float,
INFORCostoIndirecto                float)
SELECT @IDAcceso = dbo.fnAccesoID(@@SPID), @Estacion = EstacionTrabajo
FROM Acceso WITH(NOLOCK)
WHERE ID = @IDAcceso
IF @Ok IS NULL
BEGIN
SELECT  @Mov = NULLIF(Mov,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Mov   varchar(255))
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
SELECT @Mov2 = Mov FROM MapeoMovimientosInforIntelisis WITH(NOLOCK) WHERE INFORMov = @Mov
SELECT @MovTipo = Clave
FROM MovTipo WITH(NOLOCK)
WHERE Modulo   = 'INV' AND Mov = @Mov2
IF @MovTipo <> 'INV.SOL' SELECT @Ok = 35005, @OkRef = @Mov
IF @Ok IS NULL
BEGIN
SELECT  @Mov                           = NULLIF(Dev,'')						FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Dev                             varchar(255))
IF @Mov IS NULL
BEGIN
SELECT @Mov                          = NULLIF(Mov,'')						FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH (Mov                            varchar(255))
END
SELECT  @MovID                         = NULLIF(MovID,'')						FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (MovID                           varchar(255))
SELECT  @FechaEmision                  = dbo.fnFechaSinHora(GETDATE())
SELECT  @UltimoCambio                  = CONVERT(datetime,UltimoCambio)		FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (UltimoCambio                    varchar(255))
SELECT  @Concepto                      = NULLIF(Concepto,'')					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Concepto                        varchar(255))
SELECT  @Proyecto                      = NULLIF(Proyecto,'')					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Proyecto                        varchar(255))
SELECT  @Actividad                     = NULLIF(Actividad,'')					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Actividad                       varchar(255))
SELECT  @UEN                           = CONVERT(int,UEN)						FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (UEN                             varchar(255))
SELECT  @Moneda                        = NULLIF(Moneda,'')						FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Moneda                          varchar(255))
SELECT  @TipoCambio                    = CONVERT(float , TipoCambio)			FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (TipoCambio                      varchar(255))
SELECT  @Usuario                       = NULLIF(Usuario,'')					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Usuario                         varchar(255))
SELECT  @Autorizacion                  = NULLIF(Autorizacion,'')				FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Autorizacion                    varchar(255))
SELECT  @Referencia                    = NULLIF(Referencia,'')					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Referencia                      varchar(255))
SELECT  @DocFuente                     = CONVERT(int,DocFuente)				FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (DocFuente                       varchar(255))
SELECT  @Observaciones                 = NULLIF(Observaciones,'')				FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Observaciones                   varchar(255))
SELECT  @Estatus                       = NULLIF(Estatus,'')					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Estatus                         varchar(255))
SELECT  @Situacion                     = NULLIF(Situacion,'')					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Situacion                       varchar(255))
SELECT  @SituacionFecha                = CONVERT(datetime,SituacionFecha)		FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (SituacionFecha                  varchar(255))
SELECT  @SituacionUsuario              = NULLIF(SituacionUsuario,'')			FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (SituacionUsuario                varchar(255))
SELECT  @SituacionNota                 = NULLIF(SituacionNota,'')				FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (SituacionNota                   varchar(255))
SELECT  @Prioridad                     = NULLIF(Prioridad,'')					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Prioridad                       varchar(255))
SELECT  @Directo                       = CONVERT(bit,Directo)					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Directo                         varchar(255))
SELECT  @RenglonID                     = CONVERT(int,RenglonID)				FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (RenglonID                       varchar(255))
SELECT  @Almacen                       = NULLIF(Almacen,'')					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Almacen                         varchar(255))
SELECT  @AlmacenDestino                = NULLIF(AlmacenDestino,'')				FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (AlmacenDestino                  varchar(255))
SELECT  @AlmacenTransito               = NULLIF(AlmacenTransito,'')			FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (AlmacenTransito                 varchar(255))
SELECT  @Largo                         = CONVERT(bit,Largo)					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Largo                           varchar(255))
SELECT  @FechaRequerida                = CONVERT(datetime,FechaRequerida)		FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (FechaRequerida                  varchar(255))
SELECT  @Condicion                     = NULLIF(Condicion,'')					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Condicion                       varchar(255))
SELECT  @Vencimiento                   = CONVERT(datetime,Vencimiento)			FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Vencimiento                     varchar(255))
SELECT  @FormaEnvio                    = NULLIF(FormaEnvio,'')					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (FormaEnvio                      varchar(255))
SELECT  @OrigenTipo                    = NULLIF(OrigenTipo,'')					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (OrigenTipo                      varchar(255))
SELECT  @Origen                        = NULLIF(Origen,'')						FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Origen                          varchar(255))
SELECT  @OrigenID                      = NULLIF(OrigenID,'')					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (OrigenID                        varchar(255))
SELECT  @Poliza                        = NULLIF(Poliza,'')						FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Poliza                          varchar(255))
SELECT  @PolizaID                      = NULLIF(PolizaID,'')					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (PolizaID                        varchar(255))
SELECT  @GenerarPoliza                 = CONVERT(bit,GenerarPoliza)			FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (GenerarPoliza                   varchar(255))
SELECT  @ContID                        = CONVERT(int,ContID)					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (ContID                          varchar(255))
SELECT  @Ejercicio                     = CONVERT(int,Ejercicio)				FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Ejercicio                       varchar(255))
SELECT  @Periodo                       = CONVERT(int,Periodo)					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Periodo                         varchar(255))
SELECT  @FechaRegistro                 = GETDATE()
SELECT  @Peso                          = CONVERT(float , Peso)					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Peso                            varchar(255))
SELECT  @Volumen                       = CONVERT(float , Volumen)				FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Volumen                         varchar(255))
SELECT  @Paquetes                      = CONVERT(int,Paquetes)					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Paquetes                        varchar(255))
SELECT  @FechaEntrega                  = CONVERT(datetime,FechaEntrega)		FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (FechaEntrega                    varchar(255))
SELECT  @EmbarqueEstado                = NULLIF(EmbarqueEstado,'')				FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (EmbarqueEstado                  varchar(255))
SELECT  @Importe                       = CONVERT(money,Importe)				FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Importe                         varchar(255))
SELECT  @Logico1                       = CONVERT(bit,Logico1)					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Logico1                         varchar(255))
SELECT  @Logico2                       = CONVERT(bit,Logico2)					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Logico2                         varchar(255))
SELECT  @Logico3                       = CONVERT(bit,Logico3)					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Logico3                         varchar(255))
SELECT  @Logico4                       = CONVERT(bit,Logico4)					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Logico4                         varchar(255))
SELECT  @Logico5                       = CONVERT(bit,Logico5)					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Logico5                         varchar(255))
SELECT  @Logico6                       = CONVERT(bit,Logico6)					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Logico6                         varchar(255))
SELECT  @Logico7                       = CONVERT(bit,Logico7)					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Logico7                         varchar(255))
SELECT  @Logico8                       = CONVERT(bit,Logico8)					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Logico8                         varchar(255))
SELECT  @Logico9                       = CONVERT(bit,Logico9)					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Logico9                         varchar(255))
SELECT  @VerLote                       = CONVERT(bit,VerLote)					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (VerLote                         varchar(255))
SELECT  @EspacioResultado              = CONVERT(bit,EspacioResultado)			FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (EspacioResultado                varchar(255))
SELECT  @VerDestino                    = CONVERT(bit,VerDestino)				FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (VerDestino                      varchar(255))
SELECT  @EstaImpreso                   = CONVERT(bit,EstaImpreso)				FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (EstaImpreso                     varchar(255))
SELECT  @Personal                      = NULLIF(Personal,'')					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Personal                        varchar(255))
SELECT  @Reabastecido                  = CONVERT(bit,Reabastecido)				FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Reabastecido                    varchar(255))
SELECT  @Conteo                        = CONVERT(int,Conteo)					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Conteo                          varchar(255))
SELECT  @Agente                        = NULLIF(Agente,'')						FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (Agente                          varchar(255))
SELECT  @ACRetencion                   = CONVERT(float , ACRetencion)			FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (ACRetencion                     varchar(255))
SELECT  @SubModulo                     = NULLIF(SubModulo,'')					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (SubModulo                       varchar(255))
SELECT  @SucursalOrigen                = CONVERT(int,SucursalOrigen)			FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (SucursalOrigen                  varchar(255))
SELECT  @SucursalDestino               = CONVERT(int,SucursalDestino)			FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (SucursalDestino                 varchar(255))
SELECT  @PedimentoExtraccion           = NULLIF(PedimentoExtraccion,'')		FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (PedimentoExtraccion             varchar(255))
SELECT  @ReferenciaIntelisisService	= NULLIF(ReferenciaIntelisisService,'')	FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (ReferenciaIntelisisService       varchar(255))
SELECT  @MovMES                        = CONVERT(bit,MovMES)					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (MovMES                          varchar(255))
SELECT  @ReferenciaMES                 = NULLIF(ReferenciaMES,'')				FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (ReferenciaMES                   varchar(255))
SELECT  @PedidoMES                     = NULLIF(PedidoMES ,'')					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (PedidoMES                       varchar(255))
SELECT  @IDMES                         = CONVERT(int,IDMES)					FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (IDMES                           varchar(255))
SELECT  @IDMarcaje                     = CONVERT(int,IDMarcaje)				FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH  (IDMarcaje                       varchar(255))
END
IF @Ok IS NULL
BEGIN
SET @Estatus = 'BORRADOR'
SELECT @Empresa = Empresa ,@Sucursal = Sucursal, @SucursalOrigen = Sucursal
FROM MapeoPlantaIntelisisMes WITH(NOLOCK)
WHERE Referencia = @ReferenciaIntelisisService
SELECT @Sucursal2 = @Sucursal
SELECT @WMS = ISNULL(WMS,0)
FROM EmpresaGral WITH(NOLOCK)
WHERE Empresa = @Empresa
SELECT @FormaCosteo = FormaCosteo, @TipoCosteo = TipoCosteo, @CfgPosiciones = ISNULL(Posiciones, 0) FROM EmpresaCfg WITH(NOLOCK) WHERE Empresa = @Empresa
IF NOT EXISTS(SELECT * FROM Mon WITH(NOLOCK) WHERE Moneda = @Moneda ) SELECT @Ok = 20196
IF NOT EXISTS(SELECT * FROM Alm WITH(NOLOCK) WHERE Almacen = @Almacen ) SELECT @Ok = 20830
IF NOT EXISTS(SELECT * FROM Proy WITH(NOLOCK) WHERE Proyecto = @Proyecto ) AND NULLIF(@Proyecto,'') IS NOT NULL SELECT @Ok = 15010
IF NOT EXISTS(SELECT * FROM UEN WITH(NOLOCK) WHERE UEN = @UEN ) AND NULLIF(@UEN,'') IS NOT NULL SELECT @Ok = 10070
IF NOT EXISTS(SELECT * FROM MovTipo WITH(NOLOCK) WHERE Mov = @Mov2 ) SELECT @Ok = 14055
IF NOT EXISTS(SELECT * FROM Sucursal WITH(NOLOCK) WHERE Sucursal = @Sucursal )SELECT @Ok = 72060
IF NOT EXISTS(SELECT * FROM Empresa WITH(NOLOCK) WHERE Empresa =  @Empresa)SELECT @Ok =26070
END
IF @Ok IS NULL
BEGIN
IF @Almacen NOT IN(SELECT Almacen FROM Alm WITH(NOLOCK) WHERE Sucursal = @Sucursal)
SELECT @Almacen = AlmacenPrincipal FROM Sucursal WITH(NOLOCK) WHERE Sucursal = @Sucursal
SELECT @OrigenTipo ='I:MES'
IF @WMS = 1
BEGIN
IF EXISTS(SELECT * FROM Alm WITH(NOLOCK) WHERE ISNULL(WMS,0) = 1 AND NULLIF(DefPosicionSurtido,'') IS NOT NULL AND Almacen = @Almacen)
SELECT @DefPosicionSurtido = DefPosicionSurtido FROM Alm WITH(NOLOCK) WHERE ISNULL(WMS,0) = 1 AND NULLIF(DefPosicionSurtido,'') IS NOT NULL AND Almacen = @Almacen
END
INSERT INTO Inv (Empresa,  Mov,   MovID, FechaEmision,   UltimoCambio,  Concepto,  Proyecto,  Actividad,  UEN,  Moneda,  TipoCambio,  Usuario,  Autorizacion,  Referencia,  DocFuente,  Observaciones,  Estatus,  Situacion,  SituacionFecha,  SituacionUsuario,  SituacionNota,  Prioridad,  Directo,  RenglonID,  Almacen,   AlmacenDestino, AlmacenTransito,  Largo,  FechaRequerida,  Condicion,  Vencimiento,  FormaEnvio,  OrigenTipo,  Origen,  OrigenID,  Poliza,  PolizaID,  GenerarPoliza,  ContID,  Ejercicio,  Periodo,  FechaRegistro,  FechaConclusion,  FechaCancelacion,  FechaOrigen,  Peso,  Volumen,  Paquetes,  FechaEntrega,  EmbarqueEstado,  Sucursal,                     Importe,  Logico1,  Logico2,  Logico3,  Logico4,  Logico5,  Logico6,  Logico7,  Logico8,  Logico9,  VerLote,  EspacioResultado,  VerDestino,  EstaImpreso,  Personal,  Reabastecido,  Conteo,  Agente,  ACRetencion,  SubModulo,  SucursalOrigen,  SucursalDestino,  PedimentoExtraccion,  MovMES,  ReferenciaMES,  PedidoMES ,   IDMES  , IDMarcaje,  PosicionWMS)
SELECT  @Empresa, @Mov2, @MovID, @FechaEmision, @UltimoCambio, @Concepto, @Proyecto, @Actividad, @UEN, @Moneda, @TipoCambio, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, @Estatus, @Situacion, @SituacionFecha, @SituacionUsuario, @SituacionNota, @Prioridad, @Directo, @RenglonID, @Almacen, @AlmacenDestino, @AlmacenTransito, @Largo, @FechaRequerida, @Condicion, @Vencimiento, @FormaEnvio, @OrigenTipo, @Origen, @OrigenID, @Poliza, @PolizaID, @GenerarPoliza, @ContID, @Ejercicio, @Periodo, @FechaRegistro, @FechaConclusion, @FechaCancelacion, @FechaOrigen, @Peso, @Volumen, @Paquetes, @FechaEntrega, @EmbarqueEstado, ISNULL(@Sucursal,@Sucursal2), @Importe, @Logico1, @Logico2, @Logico3, @Logico4, @Logico5, @Logico6, @Logico7, @Logico8, @Logico9, @VerLote, @EspacioResultado, @VerDestino, @EstaImpreso, @Personal, @Reabastecido, @Conteo, @Agente, @ACRetencion, @SubModulo, @SucursalOrigen, @SucursalDestino, @PedimentoExtraccion, @MovMES, @ReferenciaMES, @PedidoMES  , @IDMES , @IDMarcaje, @DefPosicionSurtido
IF @@ERROR <> 0 SET @Ok = 1
SET @IDGenerar = @@IDENTITY
END
SELECT @RenglonSub = 0
INSERT @Temp2 (  RenglonTipo, Cantidad, Almacen, Codigo, Articulo, ArticuloDestino, SubCuenta, SubCuentaDestino, Costo, CostoInv, ContUso, Espacio, CantidadReservada, CantidadCancelada, CantidadOrdenada, CantidadPendiente, CantidadA, Paquete, FechaRequerida, Aplica, AplicaID, DestinoTipo, Destino, DestinoID, Cliente, Unidad,            Factor, CantidadInventario, UltimoReservadoCantidad, UltimoReservadoFecha, ProdSerieLote, Merma, Desperdicio, Producto, SubProducto, Tipo, Sucursal, Precio, SegundoConteo, DescripcionExtra, AjusteCosteo, CostoUEPS, CostoPEPS, UltimoCosto, PrecioLista, DepartamentoDetallista, AjustePrecioLista, Posicion, SucursalOrigen, Tarima, Seccion, CostoEstandar, FechaCaducidad, CostoPromedio, CostoReposicion  )
SELECT          RenglonTipo, Cantidad, Almacen, Codigo, Articulo, ArticuloDestino, SubCuenta, SubCuentaDestino, Costo, CostoInv, ContUso, Espacio, CantidadReservada, CantidadCancelada, CantidadOrdenada, CantidadPendiente, CantidadA, Paquete, FechaRequerida, Aplica, AplicaID, DestinoTipo, Destino, DestinoID, Cliente, DescripcionUnidad, Factor, ISNULL(CantidadInventario, Cantidad), UltimoReservadoCantidad, UltimoReservadoFecha, ProdSerieLote, Merma, Desperdicio, Producto, SubProducto, Tipo, Sucursal, Precio, SegundoConteo, DescripcionExtra, AjusteCosteo, CostoUEPS, CostoPEPS, UltimoCosto, PrecioLista, DepartamentoDetallista, AjustePrecioLista, Posicion, SucursalOrigen, Tarima, Seccion, CostoEstandar, FechaCaducidad, CostoPromedio, CostoReposicion
FROM OPENXML(@iSolicitud, '/Intelisis/Solicitud/Inv/DetalleInv',1)
WITH (RenglonSub  varchar(100), RenglonID  varchar(100), RenglonTipo  varchar(100), Cantidad  varchar(100), Almacen  varchar(100), Codigo  varchar(100), Articulo  varchar(100), ArticuloDestino  varchar(100), SubCuenta  varchar(100), SubCuentaDestino  varchar(100), Costo  varchar(100), CostoInv  varchar(100), ContUso  varchar(100), Espacio  varchar(100), CantidadReservada  varchar(100), CantidadCancelada  varchar(100), CantidadOrdenada  varchar(100), CantidadPendiente  varchar(100), CantidadA  varchar(100), Paquete  varchar(100), FechaRequerida  varchar(100), Aplica  varchar(100), AplicaID  varchar(100), DestinoTipo  varchar(100), Destino  varchar(100), DestinoID  varchar(100), Cliente  varchar(100), Unidad  varchar(100), Factor  varchar(100), CantidadInventario  varchar(100), UltimoReservadoCantidad  varchar(100), UltimoReservadoFecha  varchar(100), ProdSerieLote  varchar(100), Merma  varchar(100), Desperdicio  varchar(100), Producto  varchar(100), SubProducto  varchar(100), Tipo  varchar(100), Sucursal  varchar(100), Precio  varchar(100), SegundoConteo  varchar(100), DescripcionExtra  varchar(100), AjusteCosteo  varchar(100), CostoUEPS  varchar(100), CostoPEPS  varchar(100), UltimoCosto  varchar(100), PrecioLista  varchar(100), DepartamentoDetallista  varchar(100), AjustePrecioLista  varchar(100), Posicion  varchar(100), SucursalOrigen  varchar(100), Tarima  varchar(100), Seccion  varchar(100), CostoEstandar  varchar(100), FechaCaducidad  varchar(100), CostoPromedio  varchar(100), CostoReposicion varchar(100),ES varchar(100),PR varchar(100),UC varchar(100),MO varchar(100),CI varchar(100),CM varchar(100),MA varchar(100),ReferenciaMES varchar(100),PedidoMES varchar(100),IDMarcaje  varchar(100), DescripcionUnidad varchar(100))
INSERT @Temp (  RenglonTipo, Cantidad, Almacen, Codigo, Articulo, ArticuloDestino, SubCuenta, SubCuentaDestino, Costo, CostoInv, ContUso, Espacio, CantidadReservada, CantidadCancelada, CantidadOrdenada, CantidadPendiente, CantidadA, Paquete, FechaRequerida, Aplica, AplicaID, DestinoTipo, Destino, DestinoID, Cliente, Unidad,            Factor, CantidadInventario, UltimoReservadoCantidad, UltimoReservadoFecha, ProdSerieLote, Merma, Desperdicio, Producto, SubProducto, Tipo, Sucursal, Precio, SegundoConteo, DescripcionExtra, AjusteCosteo, CostoUEPS, CostoPEPS, UltimoCosto, PrecioLista, DepartamentoDetallista, AjustePrecioLista, Posicion, SucursalOrigen, Tarima, Seccion, CostoEstandar, FechaCaducidad, CostoPromedio, CostoReposicion  )
SELECT RenglonTipo, SUM(Cantidad), Almacen, Codigo, Articulo, ArticuloDestino, SubCuenta, SubCuentaDestino, Costo, CostoInv, ContUso, Espacio, CantidadReservada, CantidadCancelada, CantidadOrdenada, CantidadPendiente, CantidadA, Paquete, FechaRequerida, Aplica, AplicaID, DestinoTipo, Destino, DestinoID, Cliente, Unidad,            Factor, CantidadInventario, UltimoReservadoCantidad, UltimoReservadoFecha, ProdSerieLote, Merma, Desperdicio, Producto, SubProducto, Tipo, Sucursal, Precio, SegundoConteo, DescripcionExtra, AjusteCosteo, CostoUEPS, CostoPEPS, UltimoCosto, PrecioLista, DepartamentoDetallista, AjustePrecioLista, Posicion, SucursalOrigen, Tarima, Seccion, CostoEstandar, FechaCaducidad, CostoPromedio, CostoReposicion
FROM @Temp2
GROUP BY RenglonTipo, Almacen, Codigo, Articulo, ArticuloDestino, SubCuenta, SubCuentaDestino, Costo, CostoInv, ContUso, Espacio, CantidadReservada, CantidadCancelada, CantidadOrdenada, CantidadPendiente, CantidadA, Paquete, FechaRequerida, Aplica, AplicaID, DestinoTipo, Destino, DestinoID, Cliente, Unidad,            Factor, CantidadInventario, UltimoReservadoCantidad, UltimoReservadoFecha, ProdSerieLote, Merma, Desperdicio, Producto, SubProducto, Tipo, Sucursal, Precio, SegundoConteo, DescripcionExtra, AjusteCosteo, CostoUEPS, CostoPEPS, UltimoCosto, PrecioLista, DepartamentoDetallista, AjustePrecioLista, Posicion, SucursalOrigen, Tarima, Seccion, CostoEstandar, FechaCaducidad, CostoPromedio, CostoReposicion
INSERT @Tabla (Articulo, SerieLote, Cantidad ,SubCuenta )
SELECT         Articulo, Lote, Cantidad  ,SubCuenta
FROM OPENXML(@iSolicitud, '/Intelisis/Solicitud/Inv/SerieLoteMov',1)
WITH (Articulo  varchar(100), Lote  varchar(100), Cantidad  varchar(100),SubCuenta varchar(100) )
SET @RenglonIDD =0
UPDATE @Temp
SET @RenglonIDD = RenglonID = @RenglonIDD + 1
FROM @Temp
SET @RenglonIDD =0
UPDATE @Tabla
SET @RenglonIDD = RenglonID = @RenglonIDD + 1
FROM @Tabla
BEGIN
DECLARE crDetalle CURSOR LOCAL FAST_FORWARD FOR
SELECT  RenglonTipo, Cantidad, Almacen, Codigo, Articulo, ArticuloDestino, SubCuenta, SubCuentaDestino, Costo, CostoInv, ContUso, Espacio, CantidadReservada, CantidadCancelada, CantidadOrdenada, CantidadPendiente, CantidadA, Paquete, FechaRequerida, Aplica, AplicaID, DestinoTipo, Destino, DestinoID, Cliente, Unidad, Factor, Cantidad*dbo.fnArtUnidadFactor(@Empresa, Articulo, Unidad), UltimoReservadoCantidad, UltimoReservadoFecha, ProdSerieLote, Merma, Desperdicio, Producto, SubProducto, Tipo, Precio, SegundoConteo, DescripcionExtra, AjusteCosteo, CostoUEPS, CostoPEPS, UltimoCosto, PrecioLista, DepartamentoDetallista, AjustePrecioLista, Posicion,  Tarima, Seccion, CostoEstandar, FechaCaducidad, CostoPromedio, CostoReposicion,RenglonID
FROM @Temp
SET @Renglon = 0.0
SET @RenglonIDD = 0
OPEN crDetalle
FETCH NEXT FROM crDetalle INTO   @RenglonTipo, @Cantidad, @AlmacenD, @Codigo, @Articulo, @ArticuloDestino, @SubCuenta, @SubCuentaDestino, @Costo, @CostoInv, @ContUso, @Espacio, @CantidadReservada, @CantidadCancelada, @CantidadOrdenada, @CantidadPendiente, @CantidadA, @Paquete, @FechaRequerida, @Aplica, @AplicaID, @DestinoTipo, @Destino, @DestinoID, @Cliente, @Unidad, @Factor, @CantidadInventario, @UltimoReservadoCantidad, @UltimoReservadoFecha, @ProdSerieLote, @Merma, @Desperdicio, @Producto, @SubProducto, @Tipo, @Precio, @SegundoConteo, @DescripcionExtra, @AjusteCosteo, @CostoUEPS, @CostoPEPS, @UltimoCosto, @PrecioLista, @DepartamentoDetallista, @AjustePrecioLista, @Posicion,  @Tarima, @Seccion, @CostoEstandar, @FechaCaducidad, @CostoPromedio, @CostoReposicion, @RenglonID
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF NOT EXISTS(SELECT * FROM Alm WITH(NOLOCK) WHERE Almacen = @Almacen ) SELECT @Ok = 20830
IF @Cantidad < 0 SET @Ok = 20010
IF @Costo < 0 SET @Ok = 20140
IF @AlmacenD NOT IN(SELECT Almacen FROM Alm WITH(NOLOCK) WHERE Sucursal = @Sucursal) AND @Ok IS NULL
SELECT @AlmacenD = AlmacenPrincipal FROM Sucursal WITH(NOLOCK) WHERE Sucursal = @Sucursal
SELECT @ArtTipo = Tipo, @CostoEstandarArt = CostoEstandar FROM Art WHERE Articulo = @Articulo
IF @CfgPosiciones = 1
SELECT @Posicion = DefPosicionSurtido FROM Alm WITH(NOLOCK) WHERE ISNULL(Ubicaciones,0) = 1 AND NULLIF(DefPosicionSurtido,'') IS NOT NULL AND Almacen = @AlmacenD
EXEC spRenglonTipo @ArtTipo, @Subcuenta, @RenglonTipo OUTPUT
SET @Renglon = @Renglon + 2048.0
IF @FormaCosteo = 'Articulo'
SELECT @Cual = TipoCosteo FROM Art WITH(NOLOCK) WHERE Articulo = @Articulo
ELSE
SELECT @Cual = @TipoCosteo
IF UPPER(@Cual) <> 'ESTANDAR'
EXEC spVerCosto @Sucursal, @Empresa, NULL, @Articulo, @SubCuenta, @Unidad, @Cual, @Moneda, @TipoCambio, @Costo OUTPUT, @ConReturn = 0
ELSE
BEGIN
SELECT @Costo = @CostoEstandar
IF @Costo IS NULL
EXEC spVerCosto @Sucursal, @Empresa, NULL, @Articulo, @SubCuenta, @Unidad, @Cual, @Moneda, @TipoCambio, @Costo OUTPUT, @ConReturn = 0
END
IF NULLIF(@Costo,0.0) IS NULL
SELECT @Costo = @CostoEstandarArt
INSERT InvD (   ID        ,  Renglon,RenglonID,  RenglonSub,  RenglonTipo,  Cantidad,  Almacen,  Codigo,  Articulo,  ArticuloDestino,  SubCuenta,  SubCuentaDestino,  Costo,  CostoInv,  ContUso,  Espacio,  CantidadReservada,  CantidadCancelada,  CantidadOrdenada,  CantidadPendiente,  CantidadA,  Paquete,  FechaRequerida,  Aplica,  AplicaID,  DestinoTipo,  Destino,  DestinoID,  Cliente,  Unidad,  Factor,  CantidadInventario,  UltimoReservadoCantidad,  UltimoReservadoFecha,  ProdSerieLote,  Merma,  Desperdicio,  Producto,  SubProducto,  Tipo,  Sucursal,  Precio,  SegundoConteo,  DescripcionExtra,  AjusteCosteo,  CostoUEPS,  CostoPEPS,  UltimoCosto,  PrecioLista,  DepartamentoDetallista,  AjustePrecioLista,  Posicion,  SucursalOrigen,  Tarima,  Seccion,  CostoEstandar,  FechaCaducidad,  CostoPromedio,  CostoReposicion   )
VALUES         (@IDGenerar, @Renglon,@RenglonID, @RenglonSub,  @RenglonTipo, @Cantidad, @AlmacenD, @Codigo, @Articulo, @ArticuloDestino, @SubCuenta, @SubCuentaDestino, @Costo, @CostoInv, @ContUso, @Espacio, @CantidadReservada, @CantidadCancelada, @CantidadOrdenada, @CantidadPendiente, @CantidadA, @Paquete, @FechaRequerida, @Aplica, @AplicaID, @DestinoTipo, @Destino, @DestinoID, @Cliente, @Unidad, @Factor, @CantidadInventario, @UltimoReservadoCantidad, @UltimoReservadoFecha, @ProdSerieLote, @Merma, @Desperdicio, @Producto, @SubProducto, @Tipo, ISNULL(@Sucursal,@Sucursal2), @Precio, @SegundoConteo, @DescripcionExtra, @AjusteCosteo, @CostoUEPS, @CostoPEPS, @UltimoCosto, @PrecioLista, @DepartamentoDetallista, @AjustePrecioLista, @Posicion, @SucursalOrigen, @Tarima, @Seccion, @CostoEstandar, @FechaCaducidad, @CostoPromedio, @CostoReposicion   )
IF @@ERROR <> 0 SET @Ok = 1
FETCH NEXT FROM crDetalle INTO  @RenglonTipo, @Cantidad, @AlmacenD, @Codigo, @Articulo, @ArticuloDestino, @SubCuenta, @SubCuentaDestino, @Costo, @CostoInv, @ContUso, @Espacio, @CantidadReservada, @CantidadCancelada, @CantidadOrdenada, @CantidadPendiente, @CantidadA, @Paquete, @FechaRequerida, @Aplica, @AplicaID, @DestinoTipo, @Destino, @DestinoID, @Cliente, @Unidad, @Factor, @CantidadInventario, @UltimoReservadoCantidad, @UltimoReservadoFecha, @ProdSerieLote, @Merma, @Desperdicio, @Producto, @SubProducto, @Tipo, @Precio, @SegundoConteo, @DescripcionExtra, @AjusteCosteo, @CostoUEPS, @CostoPEPS, @UltimoCosto, @PrecioLista, @DepartamentoDetallista, @AjustePrecioLista, @Posicion,  @Tarima, @Seccion, @CostoEstandar, @FechaCaducidad, @CostoPromedio, @CostoReposicion, @RenglonID
END
CLOSE crDetalle
DEALLOCATE crDetalle
END
IF @Ok IS NULL
BEGIN
DECLARE crDetalle2 CURSOR LOCAL FAST_FORWARD FOR
SELECT a.Articulo,a.SerieLote,a.Cantidad,a.SubCuenta,a.RenglonID
FROM @Tabla a JOIN Art b WITH(NOLOCK) ON a.Articulo = b.Articulo
WHERE b.Tipo  IN ('Lote','Serie')
OPEN crDetalle2
FETCH NEXT FROM crDetalle2 INTO  @Articulo2,@Lote,@Cantidad2,@SubCuenta,@UltRenglonID
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @Tipo2 = Tipo FROM Art WITH(NOLOCK) WHERE Articulo = @Articulo2
SELECT @UltRenglonID = ISNULL(MAX(RenglonID), 0) FROM InvD WHERE ID = @IDGenerar AND Articulo=@Articulo2 AND Cantidad = @Cantidad2 AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
IF @Lote IS NOT NULL  AND @Tipo2  IN ('Lote','Serie')
BEGIN
INSERT SerieLoteMov (Empresa,  Modulo, ID,          RenglonID,     Articulo, Cantidad,        SubCuenta,     SerieLote, Sucursal)
SELECT               @Empresa, 'INV',  @IDGenerar, @UltRenglonID, @Articulo2,@Cantidad2, ISNULL(@SubCuenta,''), @Lote,   ISNULL(@Sucursal,@Sucursal2)
IF @@ERROR <> 0 SET @Ok = 1
END
FETCH NEXT FROM crDetalle2 INTO  @Articulo2,@Lote,@Cantidad2,@SubCuenta,@UltRenglonID
END
CLOSE crDetalle2
DEALLOCATE crDetalle2
END
BEGIN TRANSACTION
IF @Ok IS NULL
EXEC spAfectar 'INV', @IDGenerar, 'VERIFICAR', 'Todo', NULL, @Usuario, NULL, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @EnSilencio = 1, @Conexion = 1, @Estacion = @Estacion
IF @Ok IS NULL OR @Ok = 80000
SELECT @Ok = NULL
IF @Ok IS NULL AND @Estatus = 'BORRADOR' AND @IDGenerar IS NOT NULL
EXEC spAfectar 'INV', @IDGenerar, 'AFECTAR', 'Todo', NULL, @Usuario, NULL, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @EnSilencio = 1, @Conexion = 1, @Estacion = @Estacion
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
END
IF @Ok IS NULL
BEGIN
SELECT @ReferenciaIS = Referencia
FROM IntelisisService WITH(NOLOCK)
WHERE ID = @ID
END
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + ' Modulo="INV" ModuloID =' + CHAR(34) + ISNULL(CONVERT(varchar,@IDGenerar),'') + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/></Intelisis>'
END

