SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISIntelisisINVInsertarMovINV_S
@ID               int,
@iSolicitud       int,
@Version          float,
@Resultado        varchar(max) = NULL OUTPUT,
@Ok               int = NULL OUTPUT,
@OkRef                  varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@IDGenerar                     int,
@IDGenerar2                    int,
@IDAjuste                      int,
@IDAcceso                      int,
@MovTipo                       varchar(20),
@ReferenciaIS            varchar(100),
@Usuario2                      varchar(10),
@Estacion                      int,
@SubReferencia                 varchar(100),
@Empresa                       varchar(5),
@Mov                     varchar(20),
@Mov2                          varchar(20),
@Mov3                          varchar(20),
@MovID                         varchar(20),
@FechaEmision                  datetime   ,
@UltimoCambio                  datetime   ,
@Concepto                varchar(50),
@Proyecto                varchar(50),
@Actividad               varchar(100),
@UEN                     int   ,
@Moneda                        varchar(10),
@TipoCambio                     float   ,
@Usuario                       varchar(10),
@Autorizacion                  varchar(10),
@Referencia                    varchar(50),
@DocFuente               int   ,
@Observaciones                 varchar(100),
@Estatus                       varchar(15),
@Situacion               varchar(50),
@SituacionFecha                datetime   ,
@SituacionUsuario              varchar(10),
@SituacionNota                 varchar(100),
@Prioridad               varchar(10),
@Directo                       bit   ,
@RenglonID               int   ,
@Almacen                       varchar(10),
@AlmacenDestino                varchar(10),
@AlmacenTransito                 varchar(10),
@Largo                         bit   ,
@FechaRequerida                datetime   ,
@Condicion               varchar(50),
@Vencimiento                   datetime   ,
@FormaEnvio                    varchar(50),
@OrigenTipo                    varchar(10),
@Origen                        varchar(20),
@OrigenID                varchar(20),
@Poliza                        varchar(20),
@PolizaID                varchar(20),
@GenerarPoliza                 bit   ,
@ContID                        int   ,
@Ejercicio               int   ,
@Periodo                       int   ,
@FechaRegistro                 datetime   ,
@FechaConclusion                 datetime   ,
@FechaCancelacion              datetime   ,
@FechaOrigen                   datetime   ,
@Peso                          float   ,
@Volumen                       float   ,
@Paquetes                int   ,
@FechaEntrega                  datetime   ,
@EmbarqueEstado                varchar(50),
@Sucursal                int   ,
@Sucursal2               int   ,
@Importe                       money   ,
@Logico1                       bit   ,
@Logico2                       bit   ,
@Logico3                       bit   ,
@Logico4                       bit   ,
@Logico5                       bit   ,
@Logico6                       bit   ,
@Logico7                       bit   ,
@Logico8                       bit   ,
@Logico9                       bit   ,
@VerLote                       bit   ,
@EspacioResultado              bit   ,
@VerDestino                    bit   ,
@EstaImpreso                   bit   ,
@Personal                varchar(10),
@Reabastecido                  bit   ,
@Conteo                        int   ,
@Agente                        varchar(10),
@ACRetencion                   float   ,
@SubModulo               varchar(5),
@SucursalOrigen                int   ,
@SucursalDestino                 int   ,
@PedimentoExtraccion             varchar(50),
@MovMES                  bit,
@IDD                      int   ,
@Renglon                       float   ,
@Renglon2                float   ,
@RenglonSub                    int   ,
@RenglonIDD                    int   ,
@RenglonIDD2                   int   ,
@RenglonTipo             char(1),
@Cantidad                float   ,
@AlmacenD                varchar(10),
@Codigo                  varchar(30),
@Articulo                varchar(20),
@ArticuloDestino                 varchar(20),
@SubCuenta               varchar(50),
@SubCuentaDestino                varchar(50),
@Costo                   money   ,
@CostoInv                      money   ,
@ContUso                       varchar(20),
@Espacio                       varchar(10),
@CantidadReservada             float   ,
@CantidadCancelada             float   ,
@CantidadOrdenada              float   ,
@CantidadPendiente             float   ,
@CantidadA               float   ,
@Paquete                       int   ,
@Aplica                        varchar(20),
@AplicaID                varchar(20),
@DestinoTipo                   varchar(10),
@Destino                       varchar(20),
@DestinoID               varchar(20),
@Cliente                       varchar(10),
@Unidad                        varchar(50),
@Factor                        float   ,
@CantidadInventario            float   ,
@UltimoReservadoCantidad         float   ,
@UltimoReservadoFecha           datetime   ,
@ProdSerieLote                 varchar(50),
@Merma                         float   ,
@Desperdicio                   float   ,
@Producto                varchar(20),
@SubProducto                   varchar(20),
@Tipo                          varchar(20),
@Precio                  money   ,
@SegundoConteo                 float   ,
@DescripcionExtra              varchar(100),
@AjusteCosteo            money   ,
@CostoUEPS                     money   ,
@CostoPEPS                     money   ,
@UltimoCosto             money   ,
@PrecioLista             money   ,
@DepartamentoDetallista                int   ,
@AjustePrecioLista             money   ,
@Posicion                varchar(10),
@Tarima                        varchar(20),
@Seccion                       smallint   ,
@CostoEstandar                 money   ,
@FechaCaducidad                datetime   ,
@CostoPromedio                 money   ,
@CostoReposicion               money  ,
@Proveedor                     varchar(10),
@ReferenciaIntelisisService         varchar(50),
@Articulo2                     varchar(20),
@Lote                    varchar(50),
@Cantidad2                     float,
@UltRenglonID            int,
@UltRenglonID2                 int,
@Tipo2                   varchar(20),
@ArtTipo                       varchar(20),
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
@ArticuloSol                        varchar(20),
@CantAfectar                        float,
@CantidadSol                        float ,
@ToleranciaAjuste                   float,
@RedondeoMonetarios					int,
@SerieLote							varchar(50),
@SerieLoteD							varchar(50)
DECLARE @Temp2             table
(
IDR int IDENTITY,
RenglonIDD                 int ,
IDD                int   ,
Renglon                 float   ,
RenglonSub              int   ,
RenglonID          int   ,
RenglonTipo        char(1),
Cantidad           float   ,
Almacen                 varchar(10),
Codigo             varchar(30),
Articulo           varchar(20),
ArticuloDestino         varchar(20),
SubCuenta          varchar(50),
SubCuentaDestino        varchar(50),
Costo              money   ,
CostoInv                money   ,
ContUso                 varchar(20),
Espacio                 varchar(10),
CantidadReservada       float   ,
CantidadCancelada       float   ,
CantidadOrdenada        float   ,
CantidadPendiente       float   ,
CantidadA          float   ,
Paquete                 int   ,
FechaRequerida          datetime   ,
Aplica                  varchar(20),
AplicaID           varchar(20),
DestinoTipo             varchar(10),
Destino                 varchar(20),
DestinoID          varchar(20),
Cliente                 varchar(10),
Unidad                  varchar(50),
Factor                  float   ,
CantidadInventario      float   ,
UltimoReservadoCantidad float   ,
UltimoReservadoFecha   datetime   ,
ProdSerieLote           varchar(50),
Merma                   float   ,
Desperdicio             float   ,
Producto           varchar(20),
SubProducto             varchar(20),
Tipo                    varchar(20),
Sucursal           int   ,
Precio             money   ,
SegundoConteo           float   ,
DescripcionExtra        varchar(100),
AjusteCosteo       money   ,
CostoUEPS               money   ,
CostoPEPS               money   ,
UltimoCosto        money   ,
PrecioLista        money   ,
DepartamentoDetallista        int   ,
AjustePrecioLista       money   ,
Posicion           varchar(10),
SucursalOrigen          int   ,
Tarima                  varchar(20),
Seccion                 smallint   ,
CostoEstandar           money   ,
FechaCaducidad          datetime   ,
CostoPromedio           money   ,
CostoReposicion         money  ,
INFORCostoConsumoMat       float,
INFORCostoManoObra         float,
INFORCostoIndirecto        float
)
DECLARE @Temp             table
(
IDR int IDENTITY,
RenglonIDD                 int ,
IDD                int   ,
Renglon                 float   ,
RenglonSub              int   ,
RenglonID          int   ,
RenglonTipo        char(1),
Cantidad           float   ,
Almacen                 varchar(10),
Codigo             varchar(30),
Articulo           varchar(20),
ArticuloDestino         varchar(20),
SubCuenta          varchar(50),
SubCuentaDestino        varchar(50),
Costo              money   ,
CostoInv                money   ,
ContUso                 varchar(20),
Espacio                 varchar(10),
CantidadReservada       float   ,
CantidadCancelada       float   ,
CantidadOrdenada        float   ,
CantidadPendiente       float   ,
CantidadA          float   ,
Paquete                 int   ,
FechaRequerida          datetime   ,
Aplica                  varchar(20),
AplicaID           varchar(20),
DestinoTipo             varchar(10),
Destino                 varchar(20),
DestinoID          varchar(20),
Cliente                 varchar(10),
Unidad                  varchar(50),
Factor                  float   ,
CantidadInventario      float   ,
UltimoReservadoCantidad float   ,
UltimoReservadoFecha   datetime   ,
ProdSerieLote           varchar(50),
Merma                   float   ,
Desperdicio             float   ,
Producto           varchar(20),
SubProducto             varchar(20),
Tipo                    varchar(20),
Sucursal           int   ,
Precio             money   ,
SegundoConteo           float   ,
DescripcionExtra        varchar(100),
AjusteCosteo       money   ,
CostoUEPS               money   ,
CostoPEPS               money   ,
UltimoCosto        money   ,
PrecioLista        money   ,
DepartamentoDetallista        int   ,
AjustePrecioLista       money   ,
Posicion           varchar(10),
SucursalOrigen          int   ,
Tarima                  varchar(20),
Seccion                 smallint   ,
CostoEstandar           money   ,
FechaCaducidad          datetime   ,
CostoPromedio           money   ,
CostoReposicion         money  ,
INFORCostoConsumoMat       float,
INFORCostoManoObra         float,
INFORCostoIndirecto        float,
SerieLote				varchar(50) NULL
)
DECLARE @Tabla table (
IDR int IDENTITY,
Empresa            varchar(5),
Modulo       varchar(5),
ID                 int,
RenglonID          int,
Articulo           varchar(20),
SubCuenta          varchar(50),
SerieLote          varchar(50),
Cantidad           float,
CantidadAlterna    float,
Propiedades  varchar(20),
Ubicacion          int,
Cliente            varchar(10),
Localizacion varchar(10),
Sucursal           int,
ArtCostoInv  money)
DECLARE
@Tabla2 table (
IDR int IDENTITY,
Articulo    varchar(20),
SubCuenta   varchar(50),
Almacen     varchar(10),
Serielote   varchar(50),
Renglon     float,
RenglonID   int ,
Costo       float,
Cantidad    float,
Unidad      varchar(10)
)
SELECT @IDAcceso = dbo.fnAccesoID(@@SPID)
SELECT @Estacion = EstacionTrabajo  FROM Acceso WITH(NOLOCK) WHERE ID = @IDAcceso
IF @Ok IS NULL
BEGIN
SELECT @Mov =  NULLIF(Mov,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH (Mov varchar(255))
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
SELECT @Mov2 = Mov FROM MapeoMovimientosInforIntelisis WITH(NOLOCK)  WHERE INFORMov = @Mov
SELECT @MovTipo = Clave
FROM MovTipo WITH(NOLOCK)
WHERE Modulo = 'INV' AND Mov = @Mov2
IF @Ok IS NULL
BEGIN
SELECT  @Mov = NULLIF(Mov,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Mov   varchar(255))
SELECT  @MovID = NULLIF(MovID,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(MovID   varchar(255))
SELECT  @FechaEmision = dbo.fnFechaSinHora(GETDATE())
SELECT  @UltimoCambio = CONVERT(datetime,UltimoCambio)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(UltimoCambio   varchar(255))
SELECT  @Concepto = NULLIF(Concepto,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Concepto   varchar(255))
SELECT  @Proyecto = NULLIF(Proyecto,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Proyecto   varchar(255))
SELECT  @Actividad = NULLIF(Actividad,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Actividad   varchar(255))
SELECT  @UEN = CONVERT(int,UEN)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(UEN   varchar(255))
SELECT  @Moneda = NULLIF(Moneda,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Moneda   varchar(255))
SELECT  @TipoCambio = CONVERT(float , TipoCambio)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(TipoCambio   varchar(255))
SELECT  @Usuario = NULLIF(Usuario,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Usuario   varchar(255))
SELECT  @Autorizacion = NULLIF(Autorizacion,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Autorizacion   varchar(255))
SELECT  @Referencia = NULLIF(Referencia,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Referencia   varchar(255))
SELECT  @DocFuente = CONVERT(int,DocFuente)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(DocFuente   varchar(255))
SELECT  @Observaciones = NULLIF(Observaciones,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Observaciones   varchar(255))
SELECT  @Estatus = NULLIF(Estatus,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Estatus   varchar(255))
SELECT  @Situacion = NULLIF(Situacion,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Situacion   varchar(255))
SELECT  @SituacionFecha = CONVERT(datetime,SituacionFecha)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(SituacionFecha   varchar(255))
SELECT  @SituacionUsuario = NULLIF(SituacionUsuario,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(SituacionUsuario   varchar(255))
SELECT  @SituacionNota = NULLIF(SituacionNota,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(SituacionNota   varchar(255))
SELECT  @Prioridad = NULLIF(Prioridad,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Prioridad   varchar(255))
SELECT  @Directo = CONVERT(bit,Directo)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Directo   varchar(255))
SELECT  @RenglonID = CONVERT(int,RenglonID)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(RenglonID   varchar(255))
SELECT  @Almacen = NULLIF(Almacen,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Almacen   varchar(255))
SELECT  @AlmacenDestino = NULLIF(AlmacenDestino,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(AlmacenDestino   varchar(255))
SELECT  @AlmacenTransito = NULLIF(AlmacenTransito,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(AlmacenTransito   varchar(255))
SELECT  @Largo = CONVERT(bit,Largo)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Largo   varchar(255))
SELECT  @FechaRequerida = CONVERT(datetime,FechaRequerida)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(FechaRequerida   varchar(255))
SELECT  @Condicion = NULLIF(Condicion,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Condicion   varchar(255))
SELECT  @Vencimiento = CONVERT(datetime,Vencimiento)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Vencimiento   varchar(255))
SELECT  @FormaEnvio = NULLIF(FormaEnvio,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(FormaEnvio   varchar(255))
SELECT  @OrigenTipo = NULLIF(OrigenTipo,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(OrigenTipo   varchar(255))
SELECT  @Origen = NULLIF(Origen,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Origen   varchar(255))
SELECT  @OrigenID = NULLIF(OrigenID,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(OrigenID   varchar(255))
SELECT  @Poliza = NULLIF(Poliza,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Poliza   varchar(255))
SELECT  @PolizaID = NULLIF(PolizaID,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(PolizaID   varchar(255))
SELECT  @GenerarPoliza = CONVERT(bit,GenerarPoliza)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(GenerarPoliza   varchar(255))
SELECT  @ContID = CONVERT(int,ContID)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(ContID   varchar(255))
SELECT  @Ejercicio = CONVERT(int,Ejercicio)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Ejercicio   varchar(255))
SELECT  @Periodo = CONVERT(int,Periodo)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Periodo   varchar(255))
SELECT  @FechaRegistro = GETDATE()
SELECT  @FechaConclusion = CONVERT(datetime,FechaConclusion)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(FechaConclusion   varchar(255))
SELECT  @FechaCancelacion = CONVERT(datetime,FechaCancelacion)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(FechaCancelacion   varchar(255))
SELECT  @FechaOrigen = CONVERT(datetime,FechaOrigen)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(FechaOrigen   varchar(255))
SELECT  @Peso = CONVERT(float , Peso)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Peso   varchar(255))
SELECT  @Volumen = CONVERT(float , Volumen)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Volumen   varchar(255))
SELECT  @Paquetes = CONVERT(int,Paquetes)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Paquetes   varchar(255))
SELECT  @FechaEntrega = CONVERT(datetime,FechaEntrega)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(FechaEntrega   varchar(255))
SELECT  @EmbarqueEstado = NULLIF(EmbarqueEstado,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(EmbarqueEstado   varchar(255))
SELECT  @Importe = CONVERT(money,Importe)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Importe   varchar(255))
SELECT  @Logico1 = CONVERT(bit,Logico1)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Logico1   varchar(255))
SELECT  @Logico2 = CONVERT(bit,Logico2)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Logico2   varchar(255))
SELECT  @Logico3 = CONVERT(bit,Logico3)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Logico3   varchar(255))
SELECT  @Logico4 = CONVERT(bit,Logico4)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Logico4   varchar(255))
SELECT  @Logico5 = CONVERT(bit,Logico5)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Logico5   varchar(255))
SELECT  @Logico6 = CONVERT(bit,Logico6)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Logico6   varchar(255))
SELECT  @Logico7 = CONVERT(bit,Logico7)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Logico7   varchar(255))
SELECT  @Logico8 = CONVERT(bit,Logico8)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Logico8   varchar(255))
SELECT  @Logico9 = CONVERT(bit,Logico9)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Logico9   varchar(255))
SELECT  @VerLote = CONVERT(bit,VerLote)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(VerLote   varchar(255))
SELECT  @EspacioResultado = CONVERT(bit,EspacioResultado)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(EspacioResultado   varchar(255))
SELECT  @VerDestino = CONVERT(bit,VerDestino)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(VerDestino   varchar(255))
SELECT  @EstaImpreso = CONVERT(bit,EstaImpreso)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(EstaImpreso   varchar(255))
SELECT  @Personal = NULLIF(Personal,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Personal   varchar(255))
SELECT  @Reabastecido = CONVERT(bit,Reabastecido)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Reabastecido   varchar(255))
SELECT  @Conteo = CONVERT(int,Conteo)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Conteo   varchar(255))
SELECT  @Agente = NULLIF(Agente,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Agente   varchar(255))
SELECT  @ACRetencion = CONVERT(float , ACRetencion)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(ACRetencion   varchar(255))
SELECT  @SubModulo = NULLIF(SubModulo,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(SubModulo   varchar(255))
SELECT  @SucursalOrigen = CONVERT(int,SucursalOrigen)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(SucursalOrigen   varchar(255))
SELECT  @SucursalDestino = CONVERT(int,SucursalDestino)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(SucursalDestino   varchar(255))
SELECT  @PedimentoExtraccion = NULLIF(PedimentoExtraccion,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(PedimentoExtraccion   varchar(255))
SELECT  @ReferenciaIntelisisService = NULLIF(ReferenciaIntelisisService,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(ReferenciaIntelisisService   varchar(255))
SELECT  @MovMES = CONVERT(bit,MovMES)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(MovMES   varchar(255))
SELECT  @ReferenciaMES = NULLIF(ReferenciaMES,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(ReferenciaMES   varchar(255))
SELECT  @PedidoMES = NULLIF(PedidoMES ,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(PedidoMES    varchar(255))
SELECT  @IDMES = CONVERT(int,IDMES)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(IDMES   varchar(255))
SELECT  @IDMarcaje = CONVERT(int,IDMarcaje)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(IDMarcaje   varchar(255))
END
IF @Ok IS NULL
BEGIN
SET @Estatus = 'CONFIRMAR'
SELECT @Empresa = Empresa ,@Sucursal =Sucursal, @SucursalOrigen = Sucursal
FROM MapeoPlantaIntelisisMes WITH(NOLOCK)
WHERE Referencia = @ReferenciaIntelisisService
SELECT @Sucursal2 = @Sucursal
SELECT @AjustesAutomaticosMES = AjustesAutomaticosMES, @FormaCosteo = FormaCosteo, @TipoCosteo = TipoCosteo, @ToleranciaAjuste = ISNULL(ToleranciaAjuste,0)  FROM EmpresaCfg WITH(NOLOCK) WHERE Empresa = @Empresa
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
INSERT @Temp2 (  RenglonTipo, Cantidad, Almacen, Codigo, Articulo, ArticuloDestino, SubCuenta, SubCuentaDestino, Costo, CostoInv, ContUso, Espacio, CantidadReservada, CantidadCancelada, CantidadOrdenada, CantidadPendiente, CantidadA, Paquete, FechaRequerida, Aplica, AplicaID, DestinoTipo, Destino, DestinoID, Cliente, Unidad,            Factor, CantidadInventario, UltimoReservadoCantidad, UltimoReservadoFecha, ProdSerieLote, Merma, Desperdicio, Producto, SubProducto, Tipo, Sucursal, Precio, SegundoConteo, DescripcionExtra, AjusteCosteo, CostoUEPS, CostoPEPS, UltimoCosto, PrecioLista, DepartamentoDetallista, AjustePrecioLista, Posicion, SucursalOrigen, Tarima, Seccion, CostoEstandar, FechaCaducidad, CostoPromedio, CostoReposicion,INFORCostoConsumoMat, INFORCostoManoObra , INFORCostoIndirecto )
SELECT          RenglonTipo, Cantidad, Almacen, Codigo, Articulo, ArticuloDestino, SubCuenta, SubCuentaDestino, Costo, CostoInv, ContUso, Espacio, CantidadReservada, CantidadCancelada, CantidadOrdenada, CantidadPendiente, CantidadA, Paquete, FechaRequerida, Aplica, AplicaID, DestinoTipo, Destino, DestinoID, Cliente, DescripcionUnidad, Factor, CantidadInventario, UltimoReservadoCantidad, UltimoReservadoFecha, ProdSerieLote, Merma, Desperdicio, Producto, SubProducto, Tipo, Sucursal, Precio, SegundoConteo, DescripcionExtra, AjusteCosteo, CostoUEPS, CostoPEPS, UltimoCosto, PrecioLista, DepartamentoDetallista, AjustePrecioLista, Posicion, SucursalOrigen, Tarima, Seccion, CostoEstandar, FechaCaducidad, CostoPromedio, CostoReposicion, INFORCostoConsumoMat, INFORCostoManoObra , INFORCostoIndirecto
FROM OPENXML(@iSolicitud, '/Intelisis/Solicitud/Inv/DetalleInv',1)
WITH (RenglonSub  varchar(100), RenglonID  varchar(100), RenglonTipo  varchar(100), Cantidad  varchar(100), Almacen  varchar(100), Codigo  varchar(100), Articulo  varchar(100), ArticuloDestino  varchar(100), SubCuenta  varchar(100), SubCuentaDestino  varchar(100), Costo  varchar(100), CostoInv  varchar(100), ContUso  varchar(100), Espacio  varchar(100), CantidadReservada  varchar(100), CantidadCancelada  varchar(100), CantidadOrdenada  varchar(100), CantidadPendiente  varchar(100), CantidadA  varchar(100), Paquete  varchar(100), FechaRequerida  varchar(100), Aplica  varchar(100), AplicaID  varchar(100), DestinoTipo  varchar(100), Destino  varchar(100), DestinoID  varchar(100), Cliente  varchar(100), Unidad  varchar(100), Factor  varchar(100), CantidadInventario  varchar(100), UltimoReservadoCantidad  varchar(100), UltimoReservadoFecha  varchar(100), ProdSerieLote  varchar(100), Merma  varchar(100), Desperdicio  varchar(100), Producto  varchar(100), SubProducto  varchar(100), Tipo  varchar(100), Sucursal  varchar(100), Precio  varchar(100), SegundoConteo  varchar(100), DescripcionExtra  varchar(100), AjusteCosteo  varchar(100), CostoUEPS  varchar(100), CostoPEPS  varchar(100), UltimoCosto  varchar(100), PrecioLista  varchar(100), DepartamentoDetallista  varchar(100), AjustePrecioLista  varchar(100), Posicion  varchar(100), SucursalOrigen  varchar(100), Tarima  varchar(100), Seccion  varchar(100), CostoEstandar  varchar(100), FechaCaducidad  varchar(100), CostoPromedio  varchar(100), CostoReposicion varchar(100),INFORCostoConsumoMat  varchar(100), INFORCostoManoObra varchar(100), INFORCostoIndirecto varchar(100),ReferenciaMES varchar(100),PedidoMES varchar(100),IDMarcaje varchar(100),RenglonIDD varchar(100), DescripcionUnidad varchar(100))
ORDER BY Articulo
IF @@ERROR <> 0 SET @Ok = 1
/*
SELECT al.Empresa, al.Almacen, al.SerieLote, al.Articulo, al.SubCuenta, Unidad=ISNULL(u.Unidad,AL.Unidad), Existencia = SUM((ISNULL(al.Entrada, 0.0)-ISNULL(al.Salida, 0.0))) /*SUM((ISNULL(Entrada, 0.0)-ISNULL(Salida, 0.0))/ISNULL(Factor, 1.0))*/, ExistenciaAlterna = SUM((ISNULL(al.Entrada, 0.0)-ISNULL(al.Salida, 0.0))), al.Posicion
FROM AuxiliarAlterno al WITH(NOLOCK)
Join art a WITH(NOLOCK) ON al.Articulo = a.Articulo
LEFT OUTER JOIN ArtUnidad u WITH(NOLOCK) ON u.Articulo = a.Articulo AND u.Factor = 1
where a.Articulo='MPPRUEBA1' and al.Almacen='MP-GDL' and al.SerieLote='RR'
GROUP BY al.Empresa, al.Almacen, al.SerieLote, al.Articulo, al.SubCuenta, al.Posicion, ISNULL(u.Unidad,AL.Unidad)
*/
update @Temp2 set Posicion = isnull(Posicion, 'SURTIDO')
INSERT @Tabla (Articulo, SerieLote, Cantidad, SubCuenta  )
SELECT         Articulo, Lote, Cantidad  , SubCuenta
FROM OPENXML(@iSolicitud, '/Intelisis/Solicitud/Inv/SerieLoteMov',1)
WITH (Articulo  varchar(100), Lote  varchar(100), Cantidad  varchar(100), SubCuenta varchar(100))
ORDER BY Articulo
INSERT @Temp (  RenglonTipo, Cantidad, Almacen, Codigo, Articulo, ArticuloDestino, SubCuenta, SubCuentaDestino, Costo, CostoInv, ContUso, Espacio, CantidadReservada, CantidadCancelada, CantidadOrdenada, CantidadPendiente, CantidadA, Paquete, FechaRequerida, Aplica, AplicaID, DestinoTipo, Destino, DestinoID, Cliente, Unidad,            Factor, CantidadInventario, UltimoReservadoCantidad, UltimoReservadoFecha, ProdSerieLote, Merma, Desperdicio, Producto, SubProducto, Tipo, Sucursal, Precio, SegundoConteo, DescripcionExtra, AjusteCosteo, CostoUEPS, CostoPEPS, UltimoCosto, PrecioLista, DepartamentoDetallista, AjustePrecioLista, Posicion, SucursalOrigen, Tarima, Seccion, CostoEstandar, FechaCaducidad, CostoPromedio, CostoReposicion,INFORCostoConsumoMat, INFORCostoManoObra , INFORCostoIndirecto, SerieLote )
SELECT A.RenglonTipo, SUM(A.Cantidad), A.Almacen, A.Codigo, A.Articulo, A.ArticuloDestino, A.SubCuenta, A.SubCuentaDestino,
A.Costo, A.CostoInv, A.ContUso, A.Espacio, A.CantidadReservada, A.CantidadCancelada, A.CantidadOrdenada, A.CantidadPendiente,
A.CantidadA, A.Paquete, A.FechaRequerida, A.Aplica, A.AplicaID, A.DestinoTipo, A.Destino, A.DestinoID, A.Cliente, A.Unidad,
A.Factor, A.CantidadInventario, A.UltimoReservadoCantidad, A.UltimoReservadoFecha, A.ProdSerieLote, A.Merma, A.Desperdicio, A.Producto,
A.SubProducto, A.Tipo, A.Sucursal, A.Precio, A.SegundoConteo, A.DescripcionExtra, A.AjusteCosteo, A.CostoUEPS, A.CostoPEPS, A.UltimoCosto,
A.PrecioLista, A.DepartamentoDetallista, A.AjustePrecioLista, A.Posicion, A.SucursalOrigen, A.Tarima, A.Seccion, A.CostoEstandar, A.FechaCaducidad,
A.CostoPromedio, A.CostoReposicion, A.INFORCostoConsumoMat, A.INFORCostoManoObra , A.INFORCostoIndirecto, B.SerieLote
FROM @Temp2 A JOIN @Tabla B ON A.IDR = B.IDR AND A.Articulo = B.Articulo
GROUP BY  A.RenglonTipo, A.Almacen, A.Codigo, A.Articulo, A.ArticuloDestino, A.SubCuenta, A.SubCuentaDestino,
A.Costo, A.CostoInv, A.ContUso, A.Espacio, A.CantidadReservada, A.CantidadCancelada, A.CantidadOrdenada, A.CantidadPendiente,
A.CantidadA, A.Paquete, A.FechaRequerida, A.Aplica, A.AplicaID, A.DestinoTipo, A.Destino, A.DestinoID, A.Cliente, A.Unidad,
A.Factor, A.CantidadInventario, A.UltimoReservadoCantidad, A.UltimoReservadoFecha, A.ProdSerieLote, A.Merma, A.Desperdicio, A.Producto,
A.SubProducto, A.Tipo, A.Sucursal, A.Precio, A.SegundoConteo, A.DescripcionExtra, A.AjusteCosteo, A.CostoUEPS, A.CostoPEPS, A.UltimoCosto,
A.PrecioLista, A.DepartamentoDetallista, A.AjustePrecioLista, A.Posicion, A.SucursalOrigen, A.Tarima, A.Seccion, A.CostoEstandar, A.FechaCaducidad,
A.CostoPromedio, A.CostoReposicion, A.INFORCostoConsumoMat, A.INFORCostoManoObra , A.INFORCostoIndirecto, B.SerieLote
/*
INSERT @Temp (  RenglonTipo, Cantidad, Almacen, Codigo, Articulo, ArticuloDestino, SubCuenta, SubCuentaDestino, Costo, CostoInv, ContUso, Espacio, CantidadReservada, CantidadCancelada, CantidadOrdenada, CantidadPendiente, CantidadA, Paquete, FechaRequerida, Aplica, AplicaID, DestinoTipo, Destino, DestinoID, Cliente, Unidad,            Factor, CantidadInventario, UltimoReservadoCantidad, UltimoReservadoFecha, ProdSerieLote, Merma, Desperdicio, Producto, SubProducto, Tipo, Sucursal, Precio, SegundoConteo, DescripcionExtra, AjusteCosteo, CostoUEPS, CostoPEPS, UltimoCosto, PrecioLista, DepartamentoDetallista, AjustePrecioLista, Posicion, SucursalOrigen, Tarima, Seccion, CostoEstandar, FechaCaducidad, CostoPromedio, CostoReposicion,INFORCostoConsumoMat, INFORCostoManoObra , INFORCostoIndirecto )
SELECT           RenglonTipo, SUM(Cantidad), Almacen, Codigo, Articulo, ArticuloDestino, SubCuenta, SubCuentaDestino, Costo, CostoInv, ContUso, Espacio, CantidadReservada, CantidadCancelada, CantidadOrdenada, CantidadPendiente, CantidadA, Paquete, FechaRequerida, Aplica, AplicaID, DestinoTipo, Destino, DestinoID, Cliente, Unidad,            Factor, CantidadInventario, UltimoReservadoCantidad, UltimoReservadoFecha, ProdSerieLote, Merma, Desperdicio, Producto, SubProducto, Tipo, Sucursal, Precio, SegundoConteo, DescripcionExtra, AjusteCosteo, CostoUEPS, CostoPEPS, UltimoCosto, PrecioLista, DepartamentoDetallista, AjustePrecioLista, Posicion, SucursalOrigen, Tarima, Seccion, CostoEstandar, FechaCaducidad, CostoPromedio, CostoReposicion,INFORCostoConsumoMat, INFORCostoManoObra , INFORCostoIndirecto
FROM @Temp2
GROUP BY  RenglonTipo, Almacen, Codigo, Articulo, ArticuloDestino, SubCuenta, SubCuentaDestino, Costo, CostoInv, ContUso, Espacio, CantidadReservada, CantidadCancelada, CantidadOrdenada, CantidadPendiente, CantidadA, Paquete, FechaRequerida, Aplica, AplicaID, DestinoTipo, Destino, DestinoID, Cliente, Unidad,            Factor, CantidadInventario, UltimoReservadoCantidad, UltimoReservadoFecha, ProdSerieLote, Merma, Desperdicio, Producto, SubProducto, Tipo, Sucursal, Precio, SegundoConteo, DescripcionExtra, AjusteCosteo, CostoUEPS, CostoPEPS, UltimoCosto, PrecioLista, DepartamentoDetallista, AjustePrecioLista, Posicion, SucursalOrigen, Tarima, Seccion, CostoEstandar, FechaCaducidad, CostoPromedio, CostoReposicion,INFORCostoConsumoMat, INFORCostoManoObra , INFORCostoIndirecto
*/
IF EXISTS(SELECT * FROM Inv i WITH(NOLOCK) JOIN MovTipo m WITH(NOLOCK) ON i.Mov = m.Mov AND m.Modulo = 'INV'   WHERE m.Clave = 'INV.SOL' AND i.Estatus = 'PENDIENTE' AND i.Referencia = @Referencia AND i.OrigenTipo = 'I:MES')
BEGIN
BEGIN TRANSACTION
SELECT TOP 1 @IDSol = i.ID FROM Inv i WITH(NOLOCK) JOIN MovTipo m WITH(NOLOCK) ON i.Mov = m.Mov AND m.Modulo = 'INV'   WHERE m.Clave = 'INV.SOL' AND i.Estatus = 'PENDIENTE' AND i.Referencia = @Referencia AND i.OrigenTipo = 'I:MES'
IF EXISTS(SELECT * FROM InvD d WITH(NOLOCK) JOIN @Temp t WITH(NOLOCK) ON d.Articulo = t.Articulo AND ISNULL(d.SubCuenta,'') = ISNULL(t.SubCuenta,'') WHERE d.ID = @IDSol AND d.CantidadPendiente >= t.Cantidad AND t.Almacen = ISNULL(NULLIF(d.Almacen,''),@Almacen))
BEGIN
UPDATE InvD WITH(ROWLOCK) SET CantidadA  = t.Cantidad
FROM InvD d WITH(NOLOCK) JOIN @Temp t WITH(NOLOCK) ON d.Articulo = t.Articulo AND ISNULL(d.SubCuenta,'') = ISNULL(t.SubCuenta,'') AND ISNULL(NULLIF(d.Almacen,''),@Almacen) = t.Almacen
WHERE d.ID = @IDSol AND d.CantidadPendiente >= t.Cantidad
IF @Ok IS NULL
EXEC spAfectar 'INV', @IDSol, 'RESERVAR', 'Seleccion', NULL, @Usuario, NULL, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT,@EnSilencio = 1, @Conexion = 1, @Estacion = @Estacion
END
IF @Ok IS NULL AND EXISTS(SELECT * FROM InvD WITH(NOLOCK) WHERE ID = @IDSol AND CantidadReservada > 0.0)
BEGIN
UPDATE InvD WITH(ROWLOCK) SET CantidadA  = t.Cantidad
FROM InvD d WITH(NOLOCK) JOIN @Temp t WITH(NOLOCK) ON d.Articulo = t.Articulo AND ISNULL(d.SubCuenta,'') = ISNULL(t.SubCuenta,'') AND ISNULL(NULLIF(d.Almacen,''),@Almacen) = t.Almacen
WHERE d.ID = @IDSol AND d.CantidadReservada  >= t.Cantidad
UPDATE @Temp SET Cantidad  = t.Cantidad-ISNULL(d.CantidadA,0.0)
FROM InvD d WITH(NOLOCK) JOIN @Temp t WITH(NOLOCK) ON d.Articulo = t.Articulo AND ISNULL(d.SubCuenta,'') = ISNULL(t.SubCuenta,'')AND ISNULL(NULLIF(d.Almacen,''),@Almacen)= t.Almacen
WHERE d.ID = @IDSol AND d.CantidadA <= t.Cantidad
EXEC @IDGenerar2 =  spAfectar 'INV', @IDSol, 'GENERAR', 'Seleccion', @Mov2, @Usuario, NULL, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT,@EnSilencio = 1, @Conexion = 1, @Estacion = @Estacion
IF @Ok IS NULL OR @Ok BETWEEN 80000 AND 81000
SELECT @Ok = NULL
UPDATE Inv WITH(NOLOCK) SET MovMES = 1 , OrigenTipo = 'I:MES' WHERE ID = @IDGenerar2
END
IF @Ok IS NULL AND EXISTS(SELECT * FROM @Tabla)
BEGIN
DECLARE crSerieLote CURSOR LOCAL FAST_FORWARD FOR
SELECT d.Articulo, d.Cantidad
FROM InvD d WITH(NOLOCK) JOIN Art b WITH(NOLOCK) ON d.Articulo = b.Articulo
WHERE b.Tipo  IN ('Lote','Serie')
AND d.ID = @IDGenerar2
OPEN crSerieLote
FETCH NEXT FROM crSerieLote INTO  @ArticuloSol,@CantidadSol
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
DECLARE crDetalle3 CURSOR LOCAL FAST_FORWARD FOR
SELECT a.Articulo,a.SerieLote,SUM(a.Cantidad),a.SubCuenta,NULL
FROM @Tabla a JOIN Art b WITH(NOLOCK) ON a.Articulo = b.Articulo
WHERE b.Tipo  IN ('Lote','Serie')
AND a.ARticulo = @ArticuloSol
GROUP BY a.Articulo,a.SerieLote,a.SubCuenta
OPEN crDetalle3
FETCH NEXT FROM crDetalle3 INTO  @Articulo2,@Lote,@Cantidad2,@SubCuenta,@UltRenglonID
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF @Cantidad2 < = @CantidadSol
SELECT @CantAfectar = @Cantidad2
ELSE
SELECT @CantAfectar = @CantidadSol
SELECT @Tipo2 = Tipo FROM Art WITH(NOLOCK) WHERE Articulo = @Articulo2
SELECT @UltRenglonID = ISNULL(MAX(RenglonID), 0) FROM InvD WITH(NOLOCK) WHERE ID = @IDGenerar2 AND Articulo=@Articulo2 AND Cantidad >= @CantAfectar AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
IF @Lote IS NOT NULL  AND @Tipo2  IN ('Lote','Serie') AND @Articulo2 IS NOT NULL
BEGIN
INSERT SerieLoteMov (Empresa,  Modulo, ID,          RenglonID,     Articulo, Cantidad,        SubCuenta,     SerieLote, Sucursal)
SELECT               @Empresa, 'INV',  @IDGenerar2, @UltRenglonID, @Articulo2,@CantAfectar, ISNULL(@SubCuenta,''), @Lote,   ISNULL(@Sucursal,@Sucursal2)
IF @@ERROR <> 0 SET @Ok = 1
END
UPDATE @Tabla SET Cantidad = Cantidad -@CantAfectar WHERE Articulo = @Articulo2 AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'') AND SerieLote = @Lote AND Cantidad = @Cantidad2
FETCH NEXT FROM crDetalle3 INTO  @Articulo2,@Lote,@Cantidad2,@SubCuenta,@UltRenglonID
END
CLOSE crDetalle3
DEALLOCATE crDetalle3
SELECT @Articulo2 = NULL,@Lote= NULL, @Articulo2 = NULL,@Cantidad2= NULL,@SubCuenta= NULL,@UltRenglonID= NULL
FETCH NEXT FROM crSerieLote INTO  @ArticuloSol,@CantidadSol
END
CLOSE crSerieLote
DEALLOCATE crSerieLote
END
DELETE @Tabla WHERE ISNULL(Cantidad,0) <=0.0
IF @Ok IS NULL OR @Ok BETWEEN 80000 AND 81000
SELECT @Ok = NULL
DELETE @Temp WHERE ISNULL(Cantidad,0.0) <=0.0
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
END
END
IF EXISTS(SELECT * FROM @Temp WHERE ISNULL(Cantidad,0.0) > 0.0) AND @Ok IS NULL
BEGIN
SELECT @OrigenTipo='I:MES'
INSERT INTO Inv (Empresa, Mov,   MovID, FechaEmision,   UltimoCambio, Concepto, Proyecto, Actividad,   UEN,   Moneda,   TipoCambio,   Usuario,   Autorizacion,   Referencia, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario,   SituacionNota,   Prioridad, Directo, RenglonID, Almacen,   AlmacenDestino,   AlmacenTransito,   Largo,   FechaRequerida,   Condicion,   Vencimiento, FormaEnvio, OrigenTipo, Origen, OrigenID, Poliza,   PolizaID,   GenerarPoliza, ContID, Ejercicio, Periodo,   FechaRegistro,   FechaConclusion,   FechaCancelacion,   FechaOrigen,   Peso, Volumen, Paquetes, FechaEntrega, EmbarqueEstado,   Sucursal,   Importe,   Logico1, Logico2, Logico3, Logico4, Logico5,   Logico6,   Logico7,   Logico8,   Logico9, VerLote, EspacioResultado,   VerDestino, EstaImpreso,   Personal, Reabastecido,   Conteo, Agente,   ACRetencion, SubModulo,   SucursalOrigen, SucursalDestino,   PedimentoExtraccion, MovMES,ReferenciaMES, PedidoMES   ,IDMES,IDMarcaje)
SELECT  @Empresa, @Mov2, @MovID, @FechaEmision, @UltimoCambio, @Concepto, @Proyecto, @Actividad, @UEN, @Moneda, @TipoCambio, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, @Estatus, @Situacion, @SituacionFecha, @SituacionUsuario, @SituacionNota, @Prioridad, @Directo, @RenglonID, @Almacen, @AlmacenDestino, @AlmacenTransito, @Largo, @FechaRequerida, @Condicion, @Vencimiento, @FormaEnvio, @OrigenTipo, @Origen, @OrigenID, @Poliza, @PolizaID, @GenerarPoliza, @ContID, @Ejercicio, @Periodo, @FechaRegistro, @FechaConclusion, @FechaCancelacion, @FechaOrigen, @Peso, @Volumen, @Paquetes, @FechaEntrega, @EmbarqueEstado, ISNULL(@Sucursal,@Sucursal2), @Importe, @Logico1, @Logico2, @Logico3, @Logico4, @Logico5, @Logico6, @Logico7, @Logico8, @Logico9, @VerLote, @EspacioResultado, @VerDestino, @EstaImpreso, @Personal, @Reabastecido, @Conteo, @Agente, @ACRetencion, @SubModulo, @SucursalOrigen, @SucursalDestino, @PedimentoExtraccion, @MovMES,@ReferenciaMES, @PedidoMES  ,@IDMES ,@IDMarcaje
IF @@ERROR <> 0 SET @Ok = 1
SET @IDGenerar = @@IDENTITY
SELECT @RenglonSub = 0
SET @RenglonIDD =0
UPDATE @Temp
SET @RenglonIDD = RenglonID = @RenglonIDD + 1
FROM @Temp
IF @Ok IS NULL
BEGIN
DECLARE crDetalle CURSOR LOCAL FAST_FORWARD FOR
SELECT  RenglonTipo, Cantidad, Almacen, Codigo, Articulo, ArticuloDestino, SubCuenta, SubCuentaDestino, Costo, CostoInv, ContUso, Espacio, CantidadReservada, CantidadCancelada, CantidadOrdenada, CantidadPendiente, CantidadA, Paquete, FechaRequerida, Aplica, AplicaID, DestinoTipo, Destino, DestinoID, Cliente, Unidad, Factor, Cantidad*dbo.fnArtUnidadFactor(@Empresa, Articulo, Unidad), UltimoReservadoCantidad, UltimoReservadoFecha, ProdSerieLote, Merma, Desperdicio, Producto, SubProducto, Tipo, Precio, SegundoConteo, DescripcionExtra, AjusteCosteo, CostoUEPS, CostoPEPS, UltimoCosto, PrecioLista, DepartamentoDetallista, AjustePrecioLista, Posicion,  Tarima, Seccion, CostoEstandar, FechaCaducidad, CostoPromedio, CostoReposicion,INFORCostoConsumoMat, INFORCostoManoObra , INFORCostoIndirecto ,RenglonID, SerieLote
FROM @Temp
SET @Renglon = 0.0
OPEN crDetalle
FETCH NEXT FROM crDetalle INTO   @RenglonTipo, @Cantidad, @AlmacenD, @Codigo, @Articulo, @ArticuloDestino, @SubCuenta, @SubCuentaDestino, @Costo, @CostoInv, @ContUso, @Espacio, @CantidadReservada, @CantidadCancelada, @CantidadOrdenada, @CantidadPendiente, @CantidadA, @Paquete, @FechaRequerida, @Aplica, @AplicaID, @DestinoTipo, @Destino, @DestinoID, @Cliente, @Unidad, @Factor, @CantidadInventario, @UltimoReservadoCantidad, @UltimoReservadoFecha, @ProdSerieLote, @Merma, @Desperdicio, @Producto, @SubProducto, @Tipo, @Precio, @SegundoConteo, @DescripcionExtra, @AjusteCosteo, @CostoUEPS, @CostoPEPS, @UltimoCosto, @PrecioLista, @DepartamentoDetallista, @AjustePrecioLista, @Posicion,  @Tarima, @Seccion, @CostoEstandar, @FechaCaducidad, @CostoPromedio, @CostoReposicion,@INFORCostoConsumoMat, @INFORCostoManoObra , @INFORCostoIndirecto  ,@RenglonIDD, @SerieLote
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF NOT EXISTS(SELECT * FROM Alm WITH(NOLOCK) WHERE Almacen = @Almacen )
SELECT @Ok = 20830
IF @Cantidad < 0 SET @Ok = 20010
IF @AlmacenD NOT IN(SELECT Almacen FROM Alm WITH(NOLOCK) WHERE Sucursal = @Sucursal)
SELECT @AlmacenD = AlmacenPrincipal FROM Sucursal WITH(NOLOCK) WHERE Sucursal = @Sucursal
IF @FormaCosteo = 'Articulo'
SELECT @Cual = TipoCosteo FROM Art WITH(NOLOCK) WHERE Articulo = @Articulo
ELSE
SELECT @Cual = @TipoCosteo
IF UPPER(@Cual) <> 'ESTANDAR'
EXEC spVerCosto @Sucursal, @Empresa, NULL, @Articulo, @SubCuenta, @Unidad, @Cual, @Moneda, @TipoCambio, @Costo OUTPUT, @ConReturn = 0
ELSE
BEGIN
SELECT @Costo = @CostoEstandar
IF NULLIF(@Costo,0.0) IS NULL
EXEC spVerCosto @Sucursal, @Empresa, NULL, @Articulo, @SubCuenta, @Unidad, @Cual, @Moneda, @TipoCambio, @Costo OUTPUT, @ConReturn = 0
END
SELECT @ArtTipo = Tipo FROM Art WITH(NOLOCK) WHERE Articulo = @Articulo
EXEC spRenglonTipo @ArtTipo, @Subcuenta, @RenglonTipo OUTPUT
SET @Renglon = @Renglon + 2048.0
BEGIN TRY
IF EXISTS(SELECT Articulo FROM WITH(NOLOCK) InvD WHERE ID = @IDGenerar and Articulo = @Articulo)
BEGIN
UPDATE INVD WITH(ROWLOCK) SET Cantidad = Cantidad + @Cantidad, CantidadReservada = CantidadReservada + @CantidadReservada, CantidadInventario = CantidadInventario + @CantidadInventario WHERE ID = @IDGenerar and Articulo = @Articulo
END
ELSE
BEGIN
INSERT InvD (   ID        ,  Renglon,  RenglonSub,  RenglonID,  RenglonTipo,  Cantidad,  Almacen,  Codigo,  Articulo,  ArticuloDestino,  SubCuenta,  SubCuentaDestino,  Costo,  CostoInv,  ContUso,  Espacio,  CantidadReservada,  CantidadCancelada,  CantidadOrdenada,  CantidadPendiente,  CantidadA,  Paquete,  FechaRequerida,  Aplica,  AplicaID,  DestinoTipo,  Destino,  DestinoID,  Cliente,  Unidad,  Factor,  CantidadInventario,  UltimoReservadoCantidad,  UltimoReservadoFecha,  ProdSerieLote,  Merma,  Desperdicio,  Producto,  SubProducto,  Tipo,  Sucursal,  Precio,  SegundoConteo,  DescripcionExtra,  AjusteCosteo,  CostoUEPS,  CostoPEPS,  UltimoCosto,  PrecioLista,  DepartamentoDetallista,  AjustePrecioLista,  Posicion,  SucursalOrigen,  Tarima,  Seccion,  CostoEstandar,  FechaCaducidad,  CostoPromedio,  CostoReposicion, INFORCostoConsumoMat, INFORCostoManoObra , INFORCostoIndirecto   )
VALUES         (@IDGenerar, @Renglon, @RenglonSub, @RenglonIDD, @RenglonTipo, @Cantidad, @AlmacenD, @Codigo, @Articulo, @ArticuloDestino, ISNULL(@SubCuenta,''), @SubCuentaDestino, @Costo, @CostoInv, @ContUso, @Espacio, @CantidadReservada, @CantidadCancelada, @CantidadOrdenada, @CantidadPendiente, @CantidadA, @Paquete, @FechaRequerida, @Aplica, @AplicaID, @DestinoTipo, @Destino, @DestinoID, @Cliente, @Unidad, @Factor, @CantidadInventario, @UltimoReservadoCantidad, @UltimoReservadoFecha, @ProdSerieLote, @Merma, @Desperdicio, @Producto, @SubProducto, @Tipo, ISNULL(@Sucursal,@Sucursal2), @Precio, @SegundoConteo, @DescripcionExtra, @AjusteCosteo, @CostoUEPS, @CostoPEPS, @UltimoCosto, @PrecioLista, @DepartamentoDetallista, @AjustePrecioLista, @Posicion, @SucursalOrigen, @Tarima, @Seccion, @CostoEstandar, @FechaCaducidad, @CostoPromedio, @CostoReposicion ,@INFORCostoConsumoMat, @INFORCostoManoObra , @INFORCostoIndirecto   )
END
END TRY
BEGIN CATCH
SET @okref = ERROR_MESSAGE()
END CATCH
SELECT @Disponible = Disponible
FROM ArtSubDisponible WITH(NOLOCK)
WHERE Empresa   = @Empresa
AND Almacen   = @AlmacenD
AND Articulo  = @Articulo
AND SubCuenta = ISNULL(@SubCuenta,'')
IF (@ArtTipo IN ('Serie','Lote'))
BEGIN
DECLARE @Disponible2 float
SELECT @Disponible2 = isnull(SerieLote.Existencia, 0)
FROM SerieLote WITH(NOLOCK) JOIN Alm WITH(NOLOCK) ON SerieLote.Almacen=Alm.Almacen
WHERE SerieLote.Empresa=@Empresa AND SerieLote.Articulo=@Articulo AND SerieLote.Existencia>0
AND SerieLote.SerieLote = @SerieLote AND SerieLote.Almacen = @Almacen
SET @Disponible = ISNULL(@Disponible2, 0)
end
IF @Cantidad > @Disponible  AND @ArtTipo ='Normal'
BEGIN
SELECT @Renglon2 = MAX(Renglon) FROM @Tabla2
SELECT @Renglon2 = ISNULL(@Renglon2,0.0)
SET @Renglon2 = @Renglon2 + 2048.00
INSERT @Tabla2 (Renglon,Articulo,SubCuenta,Almacen,Serielote,Costo,Cantidad,Unidad)
SELECT          @Renglon2,@Articulo,@SubCuenta,ISNULL(@AlmacenD,@Almacen),null,@Costo,(@Cantidad-@Disponible),@Unidad
END
IF @Cantidad > @Disponible AND @ArtTipo IN ('Serie','Lote')
BEGIN
IF EXISTS(SELECT * FROM SerieLote WITH(NOLOCK) WHERE Sucursal = ISNULL(@Sucursal,@Sucursal2) AND Empresa =  @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND SerieLote = @Lote AND Almacen = ISNULL(@AlmacenD,@Almacen)AND Existencia IS NOT NULL)
SELECT @Ok = 20080 ,@OkRef= @OkRef+' Articulo  '+@Articulo
IF @Ok IS NULL
BEGIN
SELECT @Renglon2 = MAX(Renglon) FROM @Tabla2
SELECT @Renglon2 = ISNULL(@Renglon2,0.0)
SET @Renglon2 = @Renglon2 + 2048.00
INSERT @Tabla2 (Renglon,Articulo,SubCuenta,Almacen,Serielote,Costo,Cantidad,Unidad)
SELECT          @Renglon2,@Articulo,@SubCuenta,ISNULL(@AlmacenD,@Almacen),SerieLote,@Costo,(@Cantidad-@Disponible),@Unidad
FROM @Tabla WHERE Articulo = @Articulo AND Cantidad=@Cantidad AND SubCuenta =@SubCuenta AND SerieLote = @SerieLote
END
END
IF @Ok IS NULL AND EXISTS(SELECT * FROM @Tabla)
BEGIN
DECLARE crSerieLote CURSOR LOCAL FAST_FORWARD FOR
SELECT Articulo, Cantidad, SerieLote
FROM @Tabla
WHERE SerieLote = @SerieLote
OPEN crSerieLote
FETCH NEXT FROM crSerieLote INTO  @ArticuloSol,@CantidadSol, @SerieLoteD
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
DECLARE crDetalle3 CURSOR LOCAL FAST_FORWARD FOR
SELECT a.Articulo,a.SerieLote,SUM(a.Cantidad),a.SubCuenta,NULL
FROM @Tabla a JOIN Art b WITH(NOLOCK) ON a.Articulo = b.Articulo
WHERE b.Tipo  IN ('Lote','Serie')
AND a.ARticulo = @ArticuloSol
AND a.SerieLote = @SerieLoteD
GROUP BY a.Articulo,a.SerieLote,a.SubCuenta
OPEN crDetalle3
FETCH NEXT FROM crDetalle3 INTO  @Articulo2,@Lote,@Cantidad2,@SubCuenta,@UltRenglonID
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF @Cantidad2 < = @CantidadSol
SELECT @CantAfectar = @Cantidad2
ELSE
SELECT @CantAfectar = @CantidadSol
SELECT @Tipo2 = Tipo FROM Art WITH(NOLOCK) WHERE Articulo = @Articulo2
SELECT @UltRenglonID = MIN(RenglonID) FROM @Temp WHERE Articulo=@Articulo2
IF @Lote IS NOT NULL  AND @Tipo2  IN ('Lote','Serie') AND @Articulo2 IS NOT NULL
BEGIN
begin try
IF NOT EXISTS (SELECT ID FROM SerieLoteMov WITH(NOLOCK) WHERE
ID = @IDGenerar AND Articulo = @Articulo2 AND RenglonID = @UltRenglonID AND SubCuenta = ISNULL(@SubCuenta,'') AND SerieLote = @Lote AND Empresa = @Empresa)
BEGIN
INSERT SerieLoteMov (Empresa,  Modulo, ID,          RenglonID,     Articulo,   Cantidad,        SubCuenta,     SerieLote, Sucursal)
SELECT               @Empresa, 'INV',  @IDGenerar, @UltRenglonID, @Articulo2, @CantAfectar, ISNULL(@SubCuenta,''), @Lote,   ISNULL(@Sucursal,@Sucursal2)
END
end try
begin catch
SElECT @Ok = 1, @OkRef = ERROR_MESSAGE()
end catch
END
FETCH NEXT FROM crDetalle3 INTO  @Articulo2,@Lote,@Cantidad2,@SubCuenta,@UltRenglonID
END
CLOSE crDetalle3
DEALLOCATE crDetalle3
FETCH NEXT FROM crSerieLote INTO  @ArticuloSol, @CantidadSol, @SerieLoteD
END
CLOSE crSerieLote
DEALLOCATE crSerieLote
END
FETCH NEXT FROM crDetalle INTO  @RenglonTipo, @Cantidad, @AlmacenD, @Codigo, @Articulo, @ArticuloDestino, @SubCuenta, @SubCuentaDestino, @Costo, @CostoInv, @ContUso, @Espacio, @CantidadReservada, @CantidadCancelada, @CantidadOrdenada, @CantidadPendiente, @CantidadA, @Paquete, @FechaRequerida, @Aplica, @AplicaID, @DestinoTipo, @Destino, @DestinoID, @Cliente, @Unidad, @Factor, @CantidadInventario, @UltimoReservadoCantidad, @UltimoReservadoFecha, @ProdSerieLote, @Merma, @Desperdicio, @Producto, @SubProducto, @Tipo, @Precio, @SegundoConteo, @DescripcionExtra, @AjusteCosteo, @CostoUEPS, @CostoPEPS, @UltimoCosto, @PrecioLista, @DepartamentoDetallista, @AjustePrecioLista, @Posicion,  @Tarima, @Seccion, @CostoEstandar, @FechaCaducidad, @CostoPromedio, @CostoReposicion,@INFORCostoConsumoMat, @INFORCostoManoObra , @INFORCostoIndirecto, @RenglonIDD, @SerieLote
END
CLOSE crDetalle
DEALLOCATE crDetalle
END
END
SELECT @Ajuste = COUNT(*) FROM @Tabla2
SELECT @RedondeoMonetarios = dbo.fnRedondeoMonetarios()
IF @Ajuste > 0 AND @AjustesAutomaticosMES =1 AND @Ok IS NULL AND EXISTS (SELECT * FROM @Tabla2 WHERE ROUND(ISNULL(Cantidad,0),@RedondeoMonetarios) <= ROUND(@ToleranciaAjuste,@RedondeoMonetarios))
BEGIN
SET @RenglonIDD =0
UPDATE @Tabla2
SET @RenglonIDD = RenglonID = @RenglonIDD + 1
FROM @Tabla2
SELECT @Mov3 = Mov FROM MovTipo WITH(NOLOCK) WHERE Modulo = 'INV' AND Clave ='INV.E' AND SubClave ='INV.EA'
BEGIN TRY
INSERT INTO Inv (Empresa, Mov,    FechaEmision,   UltimoCambio, Concepto, Proyecto, Actividad,   UEN,   Moneda,   TipoCambio,   Usuario,   Autorizacion,   Referencia, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario,   SituacionNota,   Prioridad, Directo, RenglonID, Almacen,   AlmacenDestino,   AlmacenTransito,   Largo,   FechaRequerida,   Condicion,   Vencimiento, FormaEnvio, OrigenTipo, Origen, OrigenID, Poliza,   PolizaID,   GenerarPoliza, ContID, Ejercicio, Periodo,   FechaRegistro,   FechaConclusion,   FechaCancelacion,   FechaOrigen,   Peso, Volumen, Paquetes, FechaEntrega, EmbarqueEstado,   Sucursal,   Importe,   Logico1, Logico2, Logico3, Logico4, Logico5,   Logico6,   Logico7,   Logico8,   Logico9, VerLote, EspacioResultado,   VerDestino, EstaImpreso,   Personal, Reabastecido,   Conteo, Agente,   ACRetencion, SubModulo,   SucursalOrigen, SucursalDestino,   PedimentoExtraccion, MovMES,ReferenciaMES, PedidoMES ,IDMarcaje  )
SELECT  @Empresa, @Mov3,  @FechaEmision, @UltimoCambio, @Concepto, @Proyecto, @Actividad, @UEN, @Moneda, @TipoCambio, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, @Estatus, @Situacion, @SituacionFecha, @SituacionUsuario, @SituacionNota, @Prioridad, @Directo, @RenglonID, @Almacen, @AlmacenDestino, @AlmacenTransito, @Largo, @FechaRequerida, @Condicion, @Vencimiento, @FormaEnvio, @OrigenTipo, @Origen, @OrigenID, @Poliza, @PolizaID, @GenerarPoliza, @ContID, @Ejercicio, @Periodo, @FechaRegistro, @FechaConclusion, @FechaCancelacion, @FechaOrigen, @Peso, @Volumen, @Paquetes, @FechaEntrega, @EmbarqueEstado, ISNULL(@Sucursal,@Sucursal2), @Importe, @Logico1, @Logico2, @Logico3, @Logico4, @Logico5, @Logico6, @Logico7, @Logico8, @Logico9, @VerLote, @EspacioResultado, @VerDestino, @EstaImpreso, @Personal, @Reabastecido, @Conteo, @Agente, @ACRetencion, @SubModulo, @SucursalOrigen, @SucursalDestino, @PedimentoExtraccion, @MovMES,@ReferenciaMES, @PedidoMES,@IDMarcaje
SET @IDAjuste = @@IDENTITY
INSERT INTO InvD(ID,Renglon,RenglonID,Articulo,SubCuenta,Almacen,Cantidad,Costo,Unidad,CantidadInventario)
SELECT @IDAjuste, MIN(Renglon), MIN(RenglonID), Articulo, ISNULL(SubCuenta,''), Almacen, SUM(Cantidad), Costo, Unidad, SUM(Cantidad*dbo.fnArtUnidadFactor(@Empresa, Articulo, Unidad))
FROM @Tabla2
WHERE ROUND(ISNULL(Cantidad,0),@RedondeoMonetarios) <= ROUND(@ToleranciaAjuste,@RedondeoMonetarios)
GROUP BY Articulo, ISNULL(SubCuenta,''), Almacen, Costo, Unidad
DECLARE @RenglonIDaJUSTE int, @ArticuloAjuste varchar(50), @SubCuentaAjuste varchar(50), @SerieLoteAjuste varchar(50), @CantidadAjuste2 float, @UltRenglonIDAjuste int
DECLARE ajusteLote_cursor CURSOR FOR
SELECT RenglonID, Articulo, ISNULL(SubCuenta,''), SerieLote, Cantidad
FROM @Tabla2
WHERE Serielote IS NOT NULL AND ROUND(ISNULL(Cantidad,0),@RedondeoMonetarios) <= ROUND(@ToleranciaAjuste,@RedondeoMonetarios)
OPEN ajusteLote_cursor
FETCH NEXT FROM ajusteLote_cursor
INTO @RenglonIDaJUSTE, @ArticuloAjuste, @SubCuentaAjuste, @SerieLoteAjuste, @CantidadAjuste2
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @UltRenglonIDAjuste = MIN(RenglonID) FROM INVD WITH(NOLOCK) WHERE ID = @IDAjuste AND Articulo=@ArticuloAjuste
INSERT SerieLoteMov (Empresa,  Modulo, ID,        RenglonID,			Articulo,		 SubCuenta,			SerieLote,		 Sucursal,					   Cantidad)
SELECT               @Empresa, 'INV',  @IDAjuste, @UltRenglonIDAjuste, @ArticuloAjuste, @SubCuentaAjuste, @SerieLoteAjuste, ISNULL(@Sucursal,@Sucursal2), @CantidadAjuste2
FETCH NEXT FROM ajusteLote_cursor
INTO @RenglonIDaJUSTE, @ArticuloAjuste, @SubCuentaAjuste, @SerieLoteAjuste, @CantidadAjuste2
END
CLOSE ajusteLote_cursor;
DEALLOCATE ajusteLote_cursor;
END TRY
BEGIN CATCH
SELECT @Ok = 1, @okref = ERROR_MESSAGE()
END CATCH
BEGIN TRANSACTION
IF @Ok IS NULL AND @IDAjuste IS NOT NULL
EXEC spAfectar 'INV', @IDAjuste, 'AFECTAR', 'Todo', NULL, @Usuario, NULL, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT,@EnSilencio = 1, @Conexion = 1, @Estacion = @Estacion
IF @Ok IS NULL OR @Ok BETWEEN 80000 AND 81000
SELECT @Ok = NULL
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
IF @IDAjuste IS NOT NULL
UPDATE Inv WITH(ROWLOCK) SET Estatus = 'BORRADOR' WHERE ID = @IDAjuste
END
END
BEGIN TRANSACTION
IF @Ok IS NULL AND @IDGenerar2 IS NOT NULL
EXEC spAfectar 'INV', @IDGenerar2, 'VERIFICAR', 'Todo', NULL, @Usuario, NULL, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT,@EnSilencio = 1, @Conexion = 1, @Estacion = @Estacion
IF @Ok IS NULL OR @Ok BETWEEN 80000 AND 81000
SELECT @Ok = NULL
IF @Ok IS NULL AND  @IDGenerar2 IS NOT NULL
EXEC spAfectar 'INV', @IDGenerar2, 'AFECTAR', 'Todo', NULL, @Usuario, NULL, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT,@EnSilencio = 1, @Conexion = 1, @Estacion = @Estacion
IF @Ok IS NULL OR @Ok BETWEEN 80000 AND 81000
SELECT @Ok = NULL
IF @Ok IS NULL AND @IDGenerar IS NOT NULL
EXEC spAfectar 'INV', @IDGenerar, 'VERIFICAR', 'Todo', NULL, @Usuario, NULL, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT,@EnSilencio = 1, @Conexion = 1, @Estacion = @Estacion
IF @Ok IS NULL OR @Ok BETWEEN 80000 AND 81000
SELECT @Ok = NULL
IF @Ok IS NULL AND @Estatus IN ('CONFIRMAR', 'SINAFECTAR') AND @IDGenerar IS NOT NULL
EXEC spAfectar 'INV', @IDGenerar, 'AFECTAR', 'Todo', NULL, @Usuario, NULL, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT,@EnSilencio = 1, @Conexion = 1, @Estacion = @Estacion
IF @Ok IS NULL OR @Ok BETWEEN 80000 AND 81000
SELECT @Ok = NULL
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
IF @IDGenerar IS NOT NULL
UPDATE Inv WITH(ROWLOCK) SET Estatus = 'BORRADOR' WHERE ID = @IDGenerar
IF @IDGenerar2 IS NOT NULL
UPDATE Inv WITH(ROWLOCK) SET Estatus = 'BORRADOR' WHERE ID = @IDGenerar2
END
END
IF @Ok IS NULL
BEGIN
SELECT @ReferenciaIS = Referencia
FROM IntelisisService WITH(NOLOCK)
WHERE ID = @ID
END
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + ' Modulo="INV" ModuloID =' + CHAR(34) + ISNULL(CONVERT(varchar,ISNULL(@IDGenerar,@IDGenerar2)),'') + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/></Intelisis>'
END

