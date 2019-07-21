SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISIntelisisCOMSInsertarMovCOMS_Maquila
@ID               int,
@iSolicitud       int,
@Version          float,
@Resultado        varchar(max) = NULL OUTPUT,
@Ok               int = NULL OUTPUT,
@OkRef                  varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@IDGenerar        int,
@IDAcceso                 int,
@MovTipo               varchar(20),
@ReferenciaIS          varchar(100),
@Usuario2              varchar(10),
@Estacion              int,
@SubReferencia         varchar(100),
@Empresa               varchar(5),
@Mov              varchar(20),
@Mov2                  varchar(20),
@MovID                 varchar(20),
@FechaEmision          datetime,
@UltimoCambio          datetime,
@Concepto         varchar(50),
@Proyecto         varchar(50),
@Actividad        varchar(100),
@UEN              int,
@Moneda                varchar(10),
@TipoCambio            float,
@Usuario               varchar(10),
@Autorizacion          varchar(10),
@Referencia            varchar(50),
@DocFuente        int,
@Observaciones         varchar(100),
@Estatus               varchar(15),
@Situacion        varchar(50),
@SituacionFecha        datetime,
@SituacionUsuario      varchar(10),
@SituacionNota         varchar(100),
@Directo               bit,
@VerDestino            bit,
@Prioridad        varchar(10),
@Proveedor        varchar(10),
@FormaEnvio            varchar(50),
@FechaRequerida        datetime,
@Almacen               varchar(10),
@AlmacenDestino        varchar(10),
@AlmacenMatPrima       varchar(10),
@Condicion        varchar(50),
@Vencimiento           datetime,
@Manejo                 money,
@Fletes                money,
@ActivoFijo            bit,
@Instruccion           varchar(50),
@Agente                varchar(10),
@Descuento        varchar(30),
@DescuentoGlobal       float,
@Importe          money,
@Impuestos             money,
@Saldo                 money,
@DescuentoLineal       money,
@OrigenTipo            varchar(10),
@Origen                varchar(20),
@OrigenID         varchar(20),
@Poliza                varchar(20),
@PolizaID         varchar(20),
@GenerarPoliza         bit,
@ContID                 int,
@Ejercicio        int,
@Periodo               int,
@FechaRegistro         datetime,
@FechaConclusion       datetime,
@FechaCancelacion      datetime,
@Peso                  float,
@Volumen               float,
@Conciliado            bit,
@Causa                 varchar(50),
@Atencion         varchar(50),
@FechaEntrega          datetime,
@EmbarqueEstado        varchar(50),
@Sucursal         int,
@Sucursal2        int,
@ZonaImpuesto          varchar(30),
@Paquetes         int,
@Idioma                varchar(50),
@IVAFiscal        float,
@IEPSFiscal            float,
@ListaPreciosEsp       varchar(20),
@EstaImpreso           bit,
@Mensaje               int,
@Logico1               bit,
@Logico2               bit,
@Logico3               bit,
@Logico4               bit,
@Logico5               bit,
@Logico6               bit,
@Logico7               bit,
@Pagado                float,
@ProrrateoAplicaID     int,
@FormaEntrega          varchar(50),
@CancelarPendiente     bit,
@LineaCredito          varchar(20),
@TipoAmortizacion      varchar(20),
@TipoTasa         varchar(20),
@Comisiones            money,
@ComisionesIVA         money,
@OperacionRelevante    bit,
@VIN              varchar(20),
@SubModulo        varchar(5),
@AutoCargos            float,
@TieneTasaEsp          bit,
@TasaEsp               float,
@Cliente               varchar(10),
@SucursalOrigen        int,
@SucursalDestino       int,
@ContUso               varchar(20),
@ContUso2         varchar(20),
@ContUso3         varchar(20),
@ContratoID            int,
@ContratoMov           varchar(20),
@ContratoMovID         varchar(20),
@ReferenciaMES         varchar(50),
@IDD                    int   ,
@Renglon           float   ,
@RenglonSub             int   ,
@RenglonID              int   ,
@RenglonTipo       char(1),
@Cantidad         float   ,
@AlmacenD          varchar(10),
@Codigo                 varchar(30),
@Articulo          varchar(20),
@SubCuenta              varchar(50),
@FechaRequeridaD        datetime   ,
@FechaOrdenarD          datetime   ,
@FechaEntregaD          datetime   ,
@Costo                  float   ,
@Impuesto1              float   ,
@Impuesto2              float   ,
@Impuesto3              float   ,
@Retencion1             float   ,
@Retencion2             float   ,
@Retencion3             float   ,
@DescuentoD             varchar(30),
@DescuentoTipo          char(1),
@DescuentoLinea         money   ,
@DescuentoImporte       money   ,
@DescripcionExtra       varchar(100),
@ReferenciaExtra        varchar(50),
@ContUsoD          varchar(20),
@DestinoTipo            varchar(10),
@Destino           varchar(20),
@DestinoID              varchar(20),
@Aplica                 varchar(20),
@AplicaID          varchar(20),
@CantidadPendiente      float   ,
@CantidadCancelada      float   ,
@CantidadA              float   ,
@CostoInv          float   ,
@Unidad                 varchar(50),
@Factor                 float   ,
@CantidadInventario     float   ,
@ClienteD          varchar(10),
@ServicioArticulo       varchar(20),
@ServicioSerie          varchar(20),
@Paquete           int   ,
@SucursalD              int   ,
@ImportacionProveedor   varchar(10),
@ImportacionReferencia        varchar(50),
@ProveedorRef           varchar(10),
@AgenteRef              varchar(10),
@EstadoRef              varchar(50),
@FechaCaducidad         datetime   ,
@ProveedorArt           varchar(10),
@ProveedorArtCosto      float   ,
@AjusteCosteo           money   ,
@CostoUEPS              money   ,
@CostoPEPS              money   ,
@UltimoCosto            money   ,
@PrecioLista            money   ,
@Posicion          varchar(10),
@DepartamentoDetallista       int   ,
@Pais                   varchar(50),
@TratadoComercial       varchar(50),
@ProgramaSectorial      varchar(50),
@ValorAduana            money   ,
@ImportacionImpuesto1   float   ,
@ImportacionImpuesto2   float   ,
@ID1               char(2),
@ID2               char(2),
@FormaPago              varchar(50),
@EsEstadistica          bit   ,
@PresupuestoEsp         bit   ,
@SucursalOrigenD        int   ,
@ContUso2D              varchar(20),
@ContUso3D         varchar(20),
@Tarima                 varchar(20),
@EmpresaRef             varchar(5),
@Categoria              varchar(50),
@Estado                 varchar(30),
@CostoEstandar          money   ,
@ABC                    varchar(50),
@PaqueteCantidad        float   ,
@CantidadEmbarcada      float   ,
@ClavePresupuestal      varchar(50),
@TipoImpuesto1          varchar(10),
@TipoImpuesto2          varchar(10),
@TipoImpuesto3          varchar(10),
@TipoRetencion1         varchar(10),
@TipoRetencion2         varchar(10),
@TipoRetencion3         varchar(10),
@CostoConImpuesto       float   ,
@TipoImpuesto4          varchar(10),
@CostoPromedio          money   ,
@CostoReposicion        money   ,
@TipoImpuesto5          varchar(10),
@Impuesto5              float   ,
@ArtTipo                varchar(20),
@Decimales              int,
@ReferenciaIntelisisService    varchar(50),
@MovIntelisisMES        varchar(10),
@MovMoneda              varchar(10),
@MovTipoCambio          float,
@MovZonaImpuesto        varchar(30),
@ArtImpuesto1           float,
@ArtImpuesto2           float,
@ArtImpuesto3           money,
@ArtRetencion1          float,
@ArtRetencion2          float,
@ArtRetencion3          float,
@CfgCompraCostoSugerido       char(20),
@CfgMultiUnidades       bit,
@CfgMermaIncluida          bit,
@CfgDesperdicioIncluido    bit,
@CfgTipoMerma              char(1),
@CfgMultiUnidadesNivel  char(20),
@CantidadOrden             float,
@Planta                 varchar(20),
@ArtMaterial               varchar(20),
@UnidadMaterial            varchar(50),
@IDGenerarInv              int,
@MovTransferencia          varchar(20),
@RenglonInv                float,
@DefPosicionSurtido        varchar(10),
@DefPosicionRecibo         varchar(10),
@MovEntrada                varchar(20),
@TieneMateriales           bit,
@Transforma                bit
DECLARE @Temp             table
(
IDD                              int   ,
Renglon                                float   ,
RenglonSub                             int   ,
RenglonID                              int   ,
RenglonTipo                            char(1),
Cantidad                               float   ,
Almacen                                varchar(10),
Codigo                           varchar(30),
Articulo                               varchar(20),
SubCuenta                              varchar(50),
FechaRequerida                         datetime   ,
FechaOrdenar                     datetime   ,
FechaEntrega                     datetime   ,
Costo                            float   ,
Impuesto1                              float   ,
Impuesto2                              float   ,
Impuesto3                              float   ,
Retencion1                             float   ,
Retencion2                             float   ,
Retencion3                             float   ,
Descuento                              varchar(30),
DescuentoTipo                          char(1),
DescuentoLinea                           money   ,
DescuentoImporte                         money   ,
DescripcionExtra                         varchar(100),
ReferenciaExtra                          varchar(50),
ContUso                                varchar(20),
DestinoTipo                      varchar(10),
Destino                                varchar(20),
DestinoID                              varchar(20),
Aplica                           varchar(20),
AplicaID                               varchar(20),
CantidadPendiente                        float   ,
CantidadCancelada                        float   ,
CantidadA                              float   ,
CostoInv                               float   ,
Unidad                           varchar(50),
Factor                           float   ,
CantidadInventario                       float   ,
Cliente                                varchar(10),
ServicioArticulo                         varchar(20),
ServicioSerie                          varchar(20),
Paquete                                int   ,
Sucursal                               int   ,
ImportacionProveedor                     varchar(10),
ImportacionReferencia                    varchar(50),
ProveedorRef                     varchar(10),
AgenteRef                              varchar(10),
EstadoRef                              varchar(50),
FechaCaducidad                         datetime   ,
ProveedorArt                     varchar(10),
ProveedorArtCosto                        float   ,
AjusteCosteo                           money   ,
CostoUEPS                              money   ,
CostoPEPS                              money   ,
UltimoCosto                      money   ,
PrecioLista                      money   ,
Posicion                               varchar(10),
DepartamentoDetallista                   int   ,
Pais                             varchar(50),
TratadoComercial                         varchar(50),
ProgramaSectorial                      varchar(50),
ValorAduana                      money   ,
ImportacionImpuesto1                     float   ,
ImportacionImpuesto2                     float   ,
ID1                              char(2),
ID2                              char(2),
FormaPago                              varchar(50),
EsEstadistica                          bit   ,
PresupuestoEsp                         bit   ,
SucursalOrigen                         int   ,
ContUso2                               varchar(20),
ContUso3                               varchar(20),
Tarima                           varchar(20),
EmpresaRef                             varchar(5),
Categoria                              varchar(50),
Estado                           varchar(30),
CostoEstandar                          money   ,
ABC                              varchar(50),
PaqueteCantidad                          float   ,
CantidadEmbarcada                        float   ,
ClavePresupuestal                        varchar(50),
TipoImpuesto1                          varchar(10),
TipoImpuesto2                          varchar(10),
TipoImpuesto3                          varchar(10),
TipoRetencion1                         varchar(10),
TipoRetencion2                         varchar(10),
TipoRetencion3                         varchar(10),
CostoConImpuesto                         float   ,
TipoImpuesto4                          varchar(10),
CostoPromedio                          money   ,
CostoReposicion                          money   ,
TipoImpuesto5                          varchar(10),
Impuesto5                              float ,
MovIntelisisMES                  varchar(10),
Servicio                                      varchar(20)
)
SET @TieneMateriales = 0
SELECT @IDAcceso = dbo.fnAccesoID(@@SPID)
SELECT @Estacion = 1 ,@Usuario2 = Usuario FROM Acceso WHERE ID = @IDAcceso
IF @Ok IS NULL
BEGIN
SELECT @Mov =  NULLIF(Mov,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH (Mov varchar(255))
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
SELECT @Mov2 = Mov FROM MapeoMovimientosInforIntelisis WHERE INFORMov = @Mov
SELECT @MovTipo = Clave
FROM MovTipo
WHERE Modulo = 'COMS' AND Mov = @Mov
IF @MovTipo <> 'COMS.O' SELECT @Ok = 35005, @OkRef = @Mov
IF @Ok IS NULL
BEGIN
SELECT @Mov2 = NULLIF(Mov,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Mov  varchar(255))
SELECT @MovID = NULLIF(MovID,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(MovID  varchar(255))
SELECT @FechaEmision  = dbo.fnFechaSinHora(GETDATE())
SELECT @UltimoCambio  = CONVERT(datetime,UltimoCambio)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(UltimoCambio  varchar(255))
SELECT @Concepto = NULLIF(Concepto,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Concepto  varchar(255))
SELECT @Proyecto = NULLIF(Proyecto,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Proyecto  varchar(255))
SELECT @Actividad = NULLIF(Actividad,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Actividad  varchar(255))
SELECT @UEN   = CONVERT(int ,UEN)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(UEN  varchar(255))
SELECT @Moneda = NULLIF(Moneda,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Moneda  varchar(255))
SELECT @TipoCambio   = CONVERT(float,TipoCambio)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(TipoCambio  varchar(255))
SELECT @Usuario = NULLIF(Usuario,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Usuario  varchar(255))
SELECT @Autorizacion = NULLIF(Autorizacion,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Autorizacion  varchar(255))
SELECT @Referencia = NULLIF(Referencia,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Referencia  varchar(255))
SELECT @DocFuente   = CONVERT(int ,DocFuente)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(DocFuente  varchar(255))
SELECT @Observaciones = NULLIF(Observaciones,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Observaciones  varchar(255))
SELECT @Estatus = NULLIF(Estatus,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Estatus  varchar(255))
SELECT @Situacion = NULLIF(Situacion,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Situacion  varchar(255))
SELECT @SituacionFecha  = CONVERT(datetime,SituacionFecha)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(SituacionFecha  varchar(255))
SELECT @SituacionUsuario = NULLIF(SituacionUsuario,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(SituacionUsuario  varchar(255))
SELECT @SituacionNota = NULLIF(SituacionNota,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(SituacionNota  varchar(255))
SELECT @Directo  = CONVERT(bit,Directo)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Directo  varchar(255))
SELECT @VerDestino  = CONVERT(bit,VerDestino)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(VerDestino  varchar(255))
SELECT @Prioridad = NULLIF(Prioridad,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Prioridad  varchar(255))
SELECT @RenglonID   = CONVERT(int ,RenglonID)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(RenglonID  varchar(255))
SELECT @Proveedor = NULLIF(Proveedor,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Proveedor  varchar(255))
SELECT @FormaEnvio = NULLIF(FormaEnvio,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(FormaEnvio  varchar(255))
SELECT @FechaRequerida  = CONVERT(datetime,FechaRequerida)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(FechaRequerida  varchar(255))
SELECT @Almacen = NULLIF(Almacen,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Almacen  varchar(255))
SELECT @Condicion = NULLIF(Condicion,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Condicion  varchar(255))
SELECT @Vencimiento  = CONVERT(datetime,Vencimiento)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Vencimiento  varchar(255))
SELECT @Manejo   = CONVERT(money ,Manejo)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Manejo  varchar(255))
SELECT @Fletes   = CONVERT(money ,Fletes)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Fletes  varchar(255))
SELECT @ActivoFijo  = CONVERT(bit,ActivoFijo)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(ActivoFijo  varchar(255))
SELECT @Instruccion = NULLIF(Instruccion,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Instruccion  varchar(255))
SELECT @Agente = NULLIF(Agente,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Agente  varchar(255))
SELECT @Descuento = NULLIF(Descuento,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Descuento  varchar(255))
SELECT @DescuentoGlobal   = CONVERT(float,DescuentoGlobal)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(DescuentoGlobal  varchar(255))
SELECT @Importe   = CONVERT(money ,Importe)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Importe  varchar(255))
SELECT @Impuestos   = CONVERT(money ,Impuestos)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Impuestos  varchar(255))
SELECT @Saldo   = CONVERT(money ,Saldo)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Saldo  varchar(255))
SELECT @DescuentoLineal   = CONVERT(money ,DescuentoLineal)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(DescuentoLineal  varchar(255))
SELECT @OrigenTipo = NULLIF(OrigenTipo,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(OrigenTipo  varchar(255))
SELECT @Origen = NULLIF(Origen,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Origen  varchar(255))
SELECT @OrigenID = NULLIF(OrigenID,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(OrigenID  varchar(255))
SELECT @Poliza = NULLIF(Poliza,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Poliza  varchar(255))
SELECT @PolizaID = NULLIF(PolizaID,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(PolizaID  varchar(255))
SELECT @GenerarPoliza  = CONVERT(bit,GenerarPoliza)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(GenerarPoliza  varchar(255))
SELECT @ContID   = CONVERT(int ,ContID)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(ContID  varchar(255))
SELECT @Ejercicio   = CONVERT(int ,Ejercicio)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Ejercicio  varchar(255))
SELECT @Periodo   = CONVERT(int ,Periodo)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Periodo  varchar(255))
SELECT @FechaRegistro  = GETDATE()
SELECT @Peso   = CONVERT(float,Peso)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Peso  varchar(255))
SELECT @Volumen   = CONVERT(float,Volumen)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Volumen  varchar(255))
SELECT @Conciliado  = CONVERT(bit,Conciliado)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Conciliado  varchar(255))
SELECT @Causa = NULLIF(Causa,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Causa  varchar(255))
SELECT @Atencion = NULLIF(Atencion,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Atencion  varchar(255))
SELECT @FechaEntrega  = CONVERT(datetime,FechaEntrega)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(FechaEntrega  varchar(255))
SELECT @EmbarqueEstado = NULLIF(EmbarqueEstado,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(EmbarqueEstado  varchar(255))
SELECT @ZonaImpuesto = NULLIF(ZonaImpuesto,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(ZonaImpuesto  varchar(255))
SELECT @Paquetes   = CONVERT(int ,Paquetes)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Paquetes  varchar(255))
SELECT @Idioma = NULLIF(Idioma,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Idioma  varchar(255))
SELECT @IVAFiscal   = CONVERT(float,IVAFiscal)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(IVAFiscal  varchar(255))
SELECT @IEPSFiscal   = CONVERT(float,IEPSFiscal)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(IEPSFiscal  varchar(255))
SELECT @ListaPreciosEsp = NULLIF(ListaPreciosEsp,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(ListaPreciosEsp  varchar(255))
SELECT @EstaImpreso  = CONVERT(bit,EstaImpreso)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(EstaImpreso  varchar(255))
SELECT @Mensaje   = CONVERT(int ,Mensaje)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Mensaje  varchar(255))
SELECT @Logico1  = CONVERT(bit,Logico1)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Logico1  varchar(255))
SELECT @Logico2  = CONVERT(bit,Logico2)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Logico2  varchar(255))
SELECT @Logico3  = CONVERT(bit,Logico3)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Logico3  varchar(255))
SELECT @Logico4  = CONVERT(bit,Logico4)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Logico4  varchar(255))
SELECT @Logico5  = CONVERT(bit,Logico5)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Logico5  varchar(255))
SELECT @Logico6  = CONVERT(bit,Logico6)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Logico6  varchar(255))
SELECT @Logico7  = CONVERT(bit,Logico7)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Logico7  varchar(255))
SELECT @Pagado   = CONVERT(float,Pagado)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Pagado  varchar(255))
SELECT @ProrrateoAplicaID   = CONVERT(int ,ProrrateoAplicaID)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(ProrrateoAplicaID  varchar(255))
SELECT @FormaEntrega = NULLIF(FormaEntrega,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(FormaEntrega  varchar(255))
SELECT @CancelarPendiente  = CONVERT(bit,CancelarPendiente)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(CancelarPendiente  varchar(255))
SELECT @LineaCredito = NULLIF(LineaCredito,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(LineaCredito  varchar(255))
SELECT @TipoAmortizacion = NULLIF(TipoAmortizacion,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(TipoAmortizacion  varchar(255))
SELECT @TipoTasa = NULLIF(TipoTasa,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(TipoTasa  varchar(255))
SELECT @Comisiones   = CONVERT(money ,Comisiones)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Comisiones  varchar(255))
SELECT @ComisionesIVA   = CONVERT(money ,ComisionesIVA)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(ComisionesIVA  varchar(255))
SELECT @OperacionRelevante  = CONVERT(bit,OperacionRelevante)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(OperacionRelevante  varchar(255))
SELECT @VIN = NULLIF(VIN,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(VIN  varchar(255))
SELECT @SubModulo = NULLIF(SubModulo,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(SubModulo  varchar(255))
SELECT @AutoCargos   = CONVERT(float,AutoCargos)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(AutoCargos  varchar(255))
SELECT @TieneTasaEsp  = CONVERT(bit,TieneTasaEsp)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(TieneTasaEsp  varchar(255))
SELECT @TasaEsp   = CONVERT(float,TasaEsp)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(TasaEsp  varchar(255))
SELECT @Cliente = NULLIF(Cliente,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(Cliente  varchar(255))
SELECT @SucursalOrigen   = CONVERT(int ,SucursalOrigen)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(SucursalOrigen  varchar(255))
SELECT @SucursalDestino   = CONVERT(int ,SucursalDestino)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(SucursalDestino varchar(255))
SELECT @ContUso = NULLIF(ContUso,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(ContUso  varchar(255))
SELECT @ContUso2 = NULLIF(ContUso2,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(ContUso2  varchar(255))
SELECT @ContUso3 = NULLIF(ContUso3,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(ContUso3  varchar(255))
SELECT @ContratoID   = CONVERT(int ,ContratoID)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(ContratoID  varchar(255))
SELECT @ContratoMov = NULLIF(ContratoMov,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(ContratoMov  varchar(255))
SELECT @ContratoMovID = NULLIF(ContratoMovID,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(ContratoMovID  varchar(255))
SELECT @ReferenciaIntelisisService = NULLIF(ReferenciaIntelisisService,'')  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH(ReferenciaIntelisisService  varchar(255))
SELECT @MovIntelisisMES =  NULLIF(MovIntelisisMES,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH (MovIntelisisMES varchar(255))
SELECT @ReferenciaMES =  NULLIF(ReferenciaMES,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH (ReferenciaMES varchar(255))
SELECT @Transforma =  ISNULL(Transforma,0) FROM openxml (@iSolicitud,'/Intelisis')
WITH (Transforma bit)
END
IF @Ok IS NULL
BEGIN
IF NOT EXISTS(SELECT * FROM Prov WHERE Proveedor = @Proveedor ) SELECT @Ok = 26050
IF NOT EXISTS(SELECT * FROM Mon WHERE Moneda = @Moneda ) SELECT @Ok = 20196
IF NOT EXISTS(SELECT * FROM Proy WHERE Proyecto = @Proyecto ) AND NULLIF(@Proyecto,'') IS NOT NULL SELECT @Ok = 15010
IF NOT EXISTS(SELECT * FROM UEN WHERE UEN = @UEN ) AND NULLIF(@UEN,'') IS NOT NULL SELECT @Ok = 10070
IF NOT EXISTS(SELECT * FROM MovTipo WHERE Modulo = 'COMS' AND Mov = @Mov ) SELECT @Ok = 14055
SELECT @Empresa = Empresa ,@Sucursal = Sucursal, @SucursalOrigen = Sucursal, @AlmacenMatPrima = AlmacenMatPrima
FROM MapeoPlantaIntelisisMes
WHERE Referencia = @ReferenciaIntelisisService
SELECT @Sucursal2 = @Sucursal
END
IF @Ok IS NULL
BEGIN
IF @Almacen NOT IN(SELECT Almacen FROM Alm WHERE Sucursal = @Sucursal)
SELECT @Almacen = AlmacenPrincipal FROM Sucursal WHERE Sucursal = @Sucursal
SELECT @OrigenTipo='I:MES'
SELECT @Moneda = m.Moneda,
@TipoCambio = m.TipoCambio,
@CfgCompraCostoSugerido = cfg.CompraCostoSugerido
FROM EmpresaCfg cfg, Mon m
WHERE Empresa = @Empresa AND m.Moneda = cfg.ContMoneda
SELECT @CfgMermaIncluida    = ProdMermaIncluida,
@CfgDesperdicioIncluido = ProdDesperdicioIncluido,
@CfgMultiUnidades       = MultiUnidades,
@CfgMultiUnidadesNivel  = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD'),
@CfgTipoMerma       = ISNULL(ProdTipoMerma, '%')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
SET @Estatus = 'CONFIRMAR'
INSERT INTO Compra (Empresa,  Mov,  MovID,  FechaEmision,  UltimoCambio,  Concepto,  Proyecto,  Actividad,  UEN,  Moneda,  TipoCambio,  Usuario,  Autorizacion,  Referencia,  DocFuente,  Observaciones,  Estatus,  Situacion,  SituacionFecha,  SituacionUsuario,  SituacionNota,  Directo,  VerDestino,  Prioridad,  RenglonID,  Proveedor,  FormaEnvio,  FechaRequerida,  Almacen,  Condicion,  Vencimiento,  Manejo,  Fletes,  ActivoFijo,  Instruccion,  Agente,  Descuento,  DescuentoGlobal,  Importe,  Impuestos,  Saldo,  DescuentoLineal,  OrigenTipo,  Origen,  OrigenID,  Poliza,  PolizaID,  GenerarPoliza,  ContID,  Ejercicio,  Periodo,  FechaRegistro,  FechaConclusion,  FechaCancelacion,  Peso,  Volumen,  Conciliado,  Causa,  Atencion,  FechaEntrega,  EmbarqueEstado,  Sucursal,  ZonaImpuesto,  Paquetes,  Idioma,  IVAFiscal,  IEPSFiscal,  ListaPreciosEsp,  EstaImpreso,  Mensaje,  Logico1,  Logico2,  Logico3,  Logico4,  Logico5,  Logico6,  Logico7,  Pagado,  ProrrateoAplicaID,  FormaEntrega,  CancelarPendiente,  LineaCredito,  TipoAmortizacion,  TipoTasa,  Comisiones,  ComisionesIVA,  OperacionRelevante,  VIN,  SubModulo,  AutoCargos,  TieneTasaEsp,  TasaEsp,  Cliente, SucursalOrigen,  SucursalDestino,  ContUso,  ContUso2,  ContUso3,  ContratoID,  ContratoMov,  ContratoMovID ,MovIntelisisMES,ReferenciaMES)
VALUES (      @Empresa, @Mov2, @MovID, @FechaEmision, @UltimoCambio, @Concepto, @Proyecto, @Actividad, @UEN, @Moneda, @TipoCambio, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, @Estatus, @Situacion, @SituacionFecha, @SituacionUsuario, @SituacionNota, @Directo, @VerDestino, @Prioridad, @RenglonID, @Proveedor, @FormaEnvio, @FechaRequerida, @Almacen, @Condicion, @Vencimiento, @Manejo, @Fletes, @ActivoFijo, @Instruccion, @Agente, @Descuento, @DescuentoGlobal, @Importe, @Impuestos, @Saldo, @DescuentoLineal, @OrigenTipo, @Origen, @OrigenID, @Poliza, @PolizaID, @GenerarPoliza, @ContID, @Ejercicio, @Periodo, @FechaRegistro, @FechaConclusion, @FechaCancelacion, @Peso, @Volumen, @Conciliado, @Causa, @Atencion, @FechaEntrega, @EmbarqueEstado, ISNULL(@Sucursal,@Sucursal2), @ZonaImpuesto, @Paquetes, @Idioma, @IVAFiscal, @IEPSFiscal, @ListaPreciosEsp, @EstaImpreso, @Mensaje, @Logico1, @Logico2, @Logico3, @Logico4, @Logico5, @Logico6, @Logico7, @Pagado, @ProrrateoAplicaID, @FormaEntrega, @CancelarPendiente, @LineaCredito, @TipoAmortizacion, @TipoTasa, @Comisiones, @ComisionesIVA, @OperacionRelevante, @VIN, @SubModulo, @AutoCargos, @TieneTasaEsp, @TasaEsp, @Cliente, @SucursalOrigen, @SucursalDestino, @ContUso, @ContUso2, @ContUso3, @ContratoID, @ContratoMov, @ContratoMovID,ISNULL(@MovIntelisisMES,''),@ReferenciaMES)
IF @@ERROR <> 0 SET @Ok = 1
SET @IDGenerar = SCOPE_IDENTITY()
IF @Proveedor IS NOT NULL
UPDATE Compra
SET Proyecto       = ISNULL(Compra.Proyecto,p.Proyecto),
FormaEnvio      = p.FormaEnvio,
Agente    = p.Agente,
Condicion = p.Condicion,
ZonaImpuesto      = p.ZonaImpuesto,
Idioma      = p.Idioma,
Moneda       = m.Moneda,
TipoCambio      = m.TipoCambio
FROM Compra, Prov p, Mon m
WHERE Compra.ID = @IDGenerar AND p.Proveedor = @Proveedor AND m.Moneda = ISNULL(p.DefMoneda, @Moneda)
END
SELECT @RenglonSub = 0
INSERT @Temp (   Cantidad,  Almacen,  Codigo,  Articulo,  SubCuenta,  FechaRequerida,  FechaOrdenar,  FechaEntrega,  Costo,  Impuesto1,  Impuesto2,  Impuesto3,  Retencion1,  Retencion2,  Retencion3,  Descuento,  DescuentoTipo,  DescuentoLinea,  DescuentoImporte,  DescripcionExtra,  ReferenciaExtra,  ContUso,  DestinoTipo,  Destino,  DestinoID,  Aplica,  AplicaID,  CantidadPendiente,  CantidadCancelada,  CantidadA,  CostoInv,  Unidad,             Factor,  CantidadInventario,  Cliente,  ServicioArticulo,  ServicioSerie,  Paquete,  Sucursal,  ImportacionProveedor,  ImportacionReferencia,  ProveedorRef,  AgenteRef,  EstadoRef,  FechaCaducidad,  ProveedorArt,  ProveedorArtCosto,  AjusteCosteo,  CostoUEPS,  CostoPEPS,  UltimoCosto,  PrecioLista,  Posicion,  DepartamentoDetallista,  Pais,  TratadoComercial,  ProgramaSectorial,  ValorAduana,  ImportacionImpuesto1,  ImportacionImpuesto2,  ID1,  ID2,  FormaPago,  EsEstadistica,  PresupuestoEsp,  SucursalOrigen,  ContUso2,  ContUso3,  Tarima,  EmpresaRef,  Categoria,  Estado,  CostoEstandar,  ABC,  PaqueteCantidad,  CantidadEmbarcada,  ClavePresupuestal,  TipoImpuesto1,  TipoImpuesto2,  TipoImpuesto3,  TipoRetencion1,  TipoRetencion2,  TipoRetencion3,  CostoConImpuesto,  TipoImpuesto4,  CostoPromedio,  CostoReposicion,  TipoImpuesto5,  Impuesto5 ,Servicio )
SELECT          Cantidad,  Almacen,  Codigo,  Articulo,  SubCuenta,  FechaRequerida,  FechaOrdenar,  FechaEntrega,  Costo,  Impuesto1,  Impuesto2,  Impuesto3,  Retencion1,  Retencion2,  Retencion3,  Descuento,  DescuentoTipo,  DescuentoLinea,  DescuentoImporte,  DescripcionExtra,  ReferenciaExtra,  ContUso,  DestinoTipo,  Destino,  DestinoID,  Aplica,  AplicaID,  CantidadPendiente,  CantidadCancelada,  CantidadA,  CostoInv,   DescripcionUnidad,  Factor,  CantidadInventario,  Cliente,  ServicioArticulo,  ServicioSerie,  Paquete,  Sucursal,  ImportacionProveedor,  ImportacionReferencia,  ProveedorRef,  AgenteRef,  EstadoRef,  FechaCaducidad,  ProveedorArt,  ProveedorArtCosto,  AjusteCosteo,  CostoUEPS,  CostoPEPS,  UltimoCosto,  PrecioLista,  Posicion,  DepartamentoDetallista,  Pais,  TratadoComercial,  ProgramaSectorial,  ValorAduana,  ImportacionImpuesto1,  ImportacionImpuesto2,  ID1,  ID2,  FormaPago,  EsEstadistica,  PresupuestoEsp,  SucursalOrigen,  ContUso2,  ContUso3,  Tarima,  EmpresaRef,  Categoria,  Estado,  CostoEstandar,  ABC,  PaqueteCantidad,  CantidadEmbarcada,  ClavePresupuestal,  TipoImpuesto1,  TipoImpuesto2,  TipoImpuesto3,  TipoRetencion1,  TipoRetencion2,  TipoRetencion3,  CostoConImpuesto,  TipoImpuesto4,  CostoPromedio,  CostoReposicion,  TipoImpuesto5,  Impuesto5 ,Servicio
FROM OPENXML (@iSolicitud, '/Intelisis/Solicitud/Compra/DetalleCompra',1)
WITH (RenglonSub  varchar(100),  RenglonID  varchar(100),  RenglonTipo  varchar(100),  Cantidad  varchar(100),  Almacen  varchar(100),  Codigo  varchar(100),  Articulo  varchar(100),  SubCuenta  varchar(100),  FechaRequerida  varchar(100),  FechaOrdenar  varchar(100),  FechaEntrega  varchar(100),  Costo  varchar(100),  Impuesto1  varchar(100),  Impuesto2  varchar(100),  Impuesto3  varchar(100),  Retencion1  varchar(100),  Retencion2  varchar(100),  Retencion3  varchar(100),  Descuento  varchar(100),  DescuentoTipo  varchar(100),  DescuentoLinea  varchar(100),  DescuentoImporte  varchar(100),  DescripcionExtra  varchar(100),  ReferenciaExtra  varchar(100),  ContUso  varchar(100),  DestinoTipo  varchar(100),  Destino  varchar(100),  DestinoID  varchar(100),  Aplica  varchar(100),  AplicaID  varchar(100),  CantidadPendiente  varchar(100),  CantidadCancelada  varchar(100),  CantidadA  varchar(100),  CostoInv  varchar(100),  Unidad  varchar(100),  Factor  varchar(100),  CantidadInventario  varchar(100),  Cliente  varchar(100),  ServicioArticulo  varchar(100),  ServicioSerie  varchar(100),  Paquete  varchar(100),  Sucursal  varchar(100),  ImportacionProveedor  varchar(100),  ImportacionReferencia  varchar(100),  ProveedorRef  varchar(100),  AgenteRef  varchar(100),  EstadoRef  varchar(100),  FechaCaducidad  varchar(100),  ProveedorArt  varchar(100),  ProveedorArtCosto  varchar(100),  AjusteCosteo  varchar(100),  CostoUEPS  varchar(100),  CostoPEPS  varchar(100),  UltimoCosto  varchar(100),  PrecioLista  varchar(100),  Posicion  varchar(100),  DepartamentoDetallista  varchar(100),  Pais  varchar(100),  TratadoComercial  varchar(100),  ProgramaSectorial  varchar(100),  ValorAduana  varchar(100),  ImportacionImpuesto1  varchar(100),  ImportacionImpuesto2  varchar(100),  ID1  varchar(100),  ID2  varchar(100),  FormaPago  varchar(100),  EsEstadistica  varchar(100),  PresupuestoEsp  varchar(100),  SucursalOrigen  varchar(100),  ContUso2  varchar(100),  ContUso3  varchar(100),  Tarima  varchar(100),  EmpresaRef  varchar(100),  Categoria  varchar(100),  Estado  varchar(100),  CostoEstandar  varchar(100),  ABC  varchar(100),  PaqueteCantidad  varchar(100),  CantidadEmbarcada  varchar(100),  ClavePresupuestal  varchar(100),  TipoImpuesto1  varchar(100),  TipoImpuesto2  varchar(100),  TipoImpuesto3  varchar(100),  TipoRetencion1  varchar(100),  TipoRetencion2  varchar(100),  TipoRetencion3  varchar(100),  CostoConImpuesto  varchar(100),  TipoImpuesto4  varchar(100),CostoPromedio  varchar(100),  CostoReposicion  varchar(100),  TipoImpuesto5  varchar(100),  Impuesto5 varchar(100), DescripcionUnidad varchar(100), Servicio varchar(100) )
SELECT @AlmacenDestino = Almacen FROM Prov WHERE Proveedor = @Proveedor
SELECT @DefPosicionSurtido = DefPosicionSurtido FROM Alm WHERE Almacen = @AlmacenMatPrima
SELECT  @DefPosicionRecibo = DefPosicionRecibo FROM Alm WHERE Almacen = @AlmacenDestino
SELECT TOP 1 @MovTransferencia = Mov FROM MovTipo WHERE Modulo = 'INV' AND Clave = 'INV.OT'
SELECT TOP 1 @MovEntrada = Mov FROM MovTipo WHERE Modulo = 'INV' AND Clave = 'INV.E'
IF EXISTS(SELECT * FROM @Temp a JOIN ArtMaterial m ON a.Articulo = m.Articulo) AND @Transforma = 0
BEGIN
SET @TieneMateriales = 1
INSERT INTO Inv (Empresa, Mov,  MovID, FechaEmision,   Concepto, Proyecto, Actividad,   UEN,   Moneda,   TipoCambio,   Usuario, Referencia, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario,   SituacionNota,   Prioridad, Directo, RenglonID,    Almacen,          AlmacenDestino,   FechaRequerida,   Condicion,   Vencimiento, FormaEnvio, OrigenTipo, Origen, OrigenID, Poliza,   PolizaID,   GenerarPoliza, ContID, Ejercicio, Periodo,   FechaRegistro,   FechaConclusion,   FechaCancelacion,   Peso,  Volumen, Paquetes, FechaEntrega, EmbarqueEstado,   Sucursal,   Importe,    VerDestino, EstaImpreso,    SubModulo,   SucursalOrigen, SucursalDestino)
VALUES      (   @Empresa, @MovTransferencia, NULL, @FechaEmision,  @Concepto, @Proyecto, @Actividad, @UEN, @Moneda, @TipoCambio, @Usuario,  @Referencia, @DocFuente, @Observaciones, @Estatus, @Situacion, @SituacionFecha, @SituacionUsuario, @SituacionNota, @Prioridad, @Directo, @RenglonID, @AlmacenMatPrima, @AlmacenDestino, @FechaRequerida, @Condicion, @Vencimiento, @FormaEnvio, @OrigenTipo, @Origen, @OrigenID, @Poliza, @PolizaID, @GenerarPoliza, @ContID, @Ejercicio, @Periodo, @FechaRegistro, @FechaConclusion, @FechaCancelacion, @Peso, @Volumen, @Paquetes, @FechaEntrega, @EmbarqueEstado, @Sucursal, @Importe,  @VerDestino, @EstaImpreso,  'INV', @SucursalOrigen, @SucursalDestino)
IF @@ERROR <> 0 SET @Ok = 1
SET @IDGenerarInv = SCOPE_IDENTITY()
END
ELSE
IF NOT EXISTS(SELECT * FROM @Temp a JOIN ArtMaterial m ON a.Articulo = m.Articulo) AND @Transforma = 1
BEGIN
INSERT INTO Inv (Empresa, Mov,  MovID, FechaEmision,   Concepto, Proyecto, Actividad,   UEN,   Moneda,   TipoCambio,   Usuario, Referencia, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario,   SituacionNota,   Prioridad, Directo, RenglonID,    Almacen,          AlmacenDestino,   FechaRequerida,   Condicion,   Vencimiento, FormaEnvio, OrigenTipo, Origen, OrigenID, Poliza,   PolizaID,   GenerarPoliza, ContID, Ejercicio, Periodo,   FechaRegistro,   FechaConclusion,   FechaCancelacion,   Peso,  Volumen, Paquetes, FechaEntrega, EmbarqueEstado,   Sucursal,   Importe,    VerDestino, EstaImpreso,    SubModulo,   SucursalOrigen, SucursalDestino)
VALUES      (   @Empresa, @MovTransferencia, NULL, @FechaEmision,  @Concepto, @Proyecto, @Actividad, @UEN, @Moneda, @TipoCambio, @Usuario,  @Referencia, @DocFuente, @Observaciones, @Estatus, @Situacion, @SituacionFecha, @SituacionUsuario, @SituacionNota, @Prioridad, @Directo, @RenglonID, @AlmacenMatPrima, @AlmacenDestino, @FechaRequerida, @Condicion, @Vencimiento, @FormaEnvio, @OrigenTipo, @Origen, @OrigenID, @Poliza, @PolizaID, @GenerarPoliza, @ContID, @Ejercicio, @Periodo, @FechaRegistro, @FechaConclusion, @FechaCancelacion, @Peso, @Volumen, @Paquetes, @FechaEntrega, @EmbarqueEstado, @Sucursal, @Importe,  @VerDestino, @EstaImpreso,  'INV', @SucursalOrigen, @SucursalDestino)
IF @@ERROR <> 0 SET @Ok = 1
SET @IDGenerarInv = SCOPE_IDENTITY()
END
IF @OK IS NULL
BEGIN
DECLARE crDetalle CURSOR LOCAL FAST_FORWARD FOR
SELECT    Cantidad,  Almacen,  Codigo,  Servicio,  SubCuenta,  FechaRequerida,  FechaOrdenar,  FechaEntrega,  Costo,  Impuesto1,  Impuesto2,  Impuesto3,  Retencion1,  Retencion2,  Retencion3,  Descuento,  DescuentoTipo,  DescuentoLinea,  DescuentoImporte,  DescripcionExtra,  ReferenciaExtra,  ContUso,  DestinoTipo,  Destino,  DestinoID,  Aplica,  AplicaID,  CantidadPendiente,  CantidadCancelada,  CantidadA,  CostoInv,  Unidad,  Factor,  Cantidad*dbo.fnArtUnidadFactor(@Empresa, Articulo, Unidad),  Cliente,  ServicioArticulo,  ServicioSerie,  Paquete,  ImportacionProveedor,  ImportacionReferencia,  ProveedorRef,  AgenteRef,  EstadoRef,  FechaCaducidad,  ProveedorArt,  ProveedorArtCosto,  AjusteCosteo,  CostoUEPS,  CostoPEPS,  UltimoCosto,  PrecioLista,  Posicion,  DepartamentoDetallista,  Pais,  TratadoComercial,  ProgramaSectorial,  ValorAduana,  ImportacionImpuesto1,  ImportacionImpuesto2,  ID1,  ID2,  FormaPago,  EsEstadistica,  PresupuestoEsp, ContUso2,  ContUso3,  Tarima,  EmpresaRef,  Categoria,  Estado,  CostoEstandar,  ABC,  PaqueteCantidad,  CantidadEmbarcada,  ClavePresupuestal,  TipoImpuesto1,  TipoImpuesto2,  TipoImpuesto3,  TipoRetencion1,  TipoRetencion2,  TipoRetencion3,  CostoConImpuesto,  TipoImpuesto4,   CostoPromedio,  CostoReposicion,  TipoImpuesto5,  Impuesto5, Articulo
FROM @Temp
SET @Renglon = 0.0
SET @RenglonID = 0
OPEN crDetalle
FETCH NEXT FROM crDetalle INTO   @Cantidad, @AlmacenD, @Codigo, @Articulo, @SubCuenta, @FechaRequeridaD, @FechaOrdenarD, @FechaEntregaD, @Costo, @Impuesto1, @Impuesto2, @Impuesto3, @Retencion1, @Retencion2, @Retencion3, @DescuentoD, @DescuentoTipo, @DescuentoLinea, @DescuentoImporte, @DescripcionExtra, @ReferenciaExtra, @ContUso, @DestinoTipo, @Destino, @DestinoID, @Aplica, @AplicaID, @CantidadPendiente, @CantidadCancelada, @CantidadA, @CostoInv, @Unidad, @Factor, @CantidadInventario, @Cliente, @ServicioArticulo, @ServicioSerie, @Paquete,  @ImportacionProveedor, @ImportacionReferencia, @ProveedorRef, @AgenteRef, @EstadoRef, @FechaCaducidad, @ProveedorArt, @ProveedorArtCosto, @AjusteCosteo, @CostoUEPS, @CostoPEPS, @UltimoCosto, @PrecioLista, @Posicion, @DepartamentoDetallista, @Pais, @TratadoComercial, @ProgramaSectorial, @ValorAduana, @ImportacionImpuesto1, @ImportacionImpuesto2, @ID1, @ID2, @FormaPago, @EsEstadistica, @PresupuestoEsp, @ContUso2, @ContUso3, @Tarima, @EmpresaRef, @Categoria, @Estado, @CostoEstandar, @ABC, @PaqueteCantidad, @CantidadEmbarcada, @ClavePresupuestal, @TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoRetencion1, @TipoRetencion2, @TipoRetencion3, @CostoConImpuesto, @TipoImpuesto4, @CostoPromedio, @CostoReposicion, @TipoImpuesto5, @Impuesto5,  @ArtMaterial
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF NOT EXISTS(SELECT * FROM Alm WHERE Almacen = @Almacen ) SELECT @Ok = 20830
IF NOT EXISTS(SELECT * FROM Art WHERE Articulo = @Articulo ) SELECT @Ok = 10530
IF @Cantidad < 0 SET @Ok = 20010
IF @Costo < 0 SET @Ok = 20140
SELECT @ArtImpuesto1 = Impuesto1, @ArtImpuesto2=Impuesto2, @ArtImpuesto3=Impuesto3, @ArtRetencion1=Retencion1, @ArtRetencion2=Retencion2, @ArtRetencion3=Retencion3
FROM Art WHERE Articulo = @Articulo
IF @AlmacenD NOT IN(SELECT Almacen FROM Alm WHERE Sucursal = @Sucursal)
SELECT @AlmacenD = AlmacenPrincipal FROM Sucursal WHERE Sucursal = @Sucursal
SET @Renglon = @Renglon + 2048.0
SET @RenglonID = @RenglonID + 1
SELECT @ArtTipo = Tipo, @Unidad = UnidadCompra FROM Art WHERE Articulo = @Articulo
SELECT @UnidadMaterial = Unidad FROM Art WHERE Articulo = @ArtMaterial
EXEC spRenglonTipo @ArtTipo, @Subcuenta, @RenglonTipo OUTPUT
SELECT @MovMoneda = Moneda, @MovTipoCambio = TipoCambio, @MovZonaImpuesto = ZonaImpuesto, @Proveedor= Proveedor FROM Compra WHERE ID = @IDGenerar
EXEC xpCantidadInventario @Articulo, @SubCuenta, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
EXEC spUnidadFactor @Empresa, @Articulo, @SubCuenta, @Unidad, @Factor OUTPUT, @Decimales OUTPUT
EXEC spZonaImp @MovZonaImpuesto, @ArtImpuesto1 OUTPUT
EXEC spZonaImp @MovZonaImpuesto, @ArtImpuesto2 OUTPUT
EXEC spZonaImp @MovZonaImpuesto, @ArtImpuesto3 OUTPUT
EXEC spTipoImpuesto 'COMS' , @IDGenerar, @Mov, @FechaEmision, @Empresa, @Sucursal, @Contacto = @Proveedor, @Articulo = @Articulo, @EnSilencio = 1, @Impuesto1 = @ArtImpuesto1 OUTPUT, @Impuesto2 = @ArtImpuesto2 OUTPUT, @Impuesto3 = @ArtImpuesto3 OUTPUT
SELECT @CantidadOrden = ROUND(@Cantidad / (@CantidadInventario / @Cantidad), 4), @CantidadInventario = @Cantidad
EXEC spVerCosto @Sucursal, @Empresa, @Proveedor, @Articulo, @SubCuenta, @Unidad, @CfgCompraCostoSugerido, @MovMoneda, @MovTipoCambio, @Costo OUTPUT, 0
SELECT @DestinoTipo = NULL, @Destino = NULL, @DestinoID = NULL
IF EXISTS(SELECT * FROM Compra c JOIN CompraD d ON c.ID = d.ID JOIN MovTipo mt ON mt.Mov = c.Mov AND mt.Modulo = 'COMS' WHERE mt.Clave = 'COMS.C' AND c.Estatus = 'CONFIRMAR' AND c.Proveedor = @Proveedor AND d.Articulo = @Articulo)
BEGIN
SELECT TOP 1 @Costo = (d.Costo/d.Cantidad) FROM Compra c JOIN CompraD d ON c.ID = d.ID JOIN MovTipo mt ON mt.Mov = c.Mov AND mt.Modulo = 'COMS' WHERE mt.Clave = 'COMS.C' AND c.Estatus = 'CONFIRMAR' AND c.Proveedor = @Proveedor AND d.Articulo = @Articulo ORDER BY c.FechaEmision DESC
END
INSERT CompraD ( ID,       Renglon,   RenglonSub,  RenglonID,  RenglonTipo,  Cantidad,      Almacen,         Codigo,  Articulo,  SubCuenta,  FechaRequerida,  FechaOrdenar,    FechaEntrega,  Costo,  Impuesto1,  Impuesto2,  Impuesto3,  Retencion1,  Retencion2,  Retencion3,  Descuento,  DescuentoTipo,  DescuentoLinea,  DescuentoImporte,  DescripcionExtra,  ReferenciaExtra,  ContUso,  DestinoTipo,  Destino,  DestinoID,  Aplica,    AplicaID,  CantidadPendiente,  CantidadCancelada,  CantidadA,  CostoInv,  Unidad,  Factor,  CantidadInventario,  Cliente,  ServicioArticulo,  ServicioSerie,  Paquete,  Sucursal,  ImportacionProveedor,  ImportacionReferencia,  ProveedorRef,  AgenteRef,  EstadoRef,  FechaCaducidad,  ProveedorArt,  ProveedorArtCosto,  AjusteCosteo,  CostoUEPS,  CostoPEPS,  UltimoCosto,  PrecioLista,  Posicion,  DepartamentoDetallista,  Pais,  TratadoComercial,  ProgramaSectorial,  ValorAduana,  ImportacionImpuesto1,  ImportacionImpuesto2,  ID1,  ID2,  FormaPago,  EsEstadistica,  PresupuestoEsp,  SucursalOrigen,  ContUso2,  ContUso3,  Tarima,  EmpresaRef,  Categoria,  Estado,  CostoEstandar,  ABC,  PaqueteCantidad,  CantidadEmbarcada,  ClavePresupuestal,  TipoImpuesto1,  TipoImpuesto2,  TipoImpuesto3,  TipoRetencion1,  TipoRetencion2,  TipoRetencion3,  CostoConImpuesto,  TipoImpuesto4,   CostoPromedio,  CostoReposicion,  TipoImpuesto5,  Impuesto5, ArticuloMaquila)
VALUES         (@IDGenerar,@Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @CantidadOrden, @AlmacenMatPrima, @Codigo, @Articulo, @SubCuenta, @FechaRequeridaD, @FechaOrdenarD, @FechaEntregaD, @Costo,@ArtImpuesto1, @ArtImpuesto2, @ArtImpuesto3, @ArtRetencion1, @ArtRetencion2, @ArtRetencion3, @DescuentoD, @DescuentoTipo, @DescuentoLinea, @DescuentoImporte, @DescripcionExtra, @ReferenciaExtra, @ContUso, @DestinoTipo, @Destino, @DestinoID, @Aplica, @AplicaID, @CantidadPendiente, @CantidadCancelada, @CantidadA, @CostoInv, @Unidad, @Factor, @CantidadInventario, @Cliente, @ServicioArticulo, @ServicioSerie, @Paquete, ISNULL(@Sucursal,@Sucursal2), @ImportacionProveedor, @ImportacionReferencia, @ProveedorRef, @AgenteRef, @EstadoRef, @FechaCaducidad, @ProveedorArt, @ProveedorArtCosto, @AjusteCosteo, @CostoUEPS, @CostoPEPS, @UltimoCosto, @PrecioLista, @Posicion, @DepartamentoDetallista, @Pais, @TratadoComercial, @ProgramaSectorial, @ValorAduana, @ImportacionImpuesto1, @ImportacionImpuesto2, @ID1, @ID2, @FormaPago, @EsEstadistica, @PresupuestoEsp, ISNULL(@Sucursal,@Sucursal2), @ContUso2, @ContUso3, @Tarima, @EmpresaRef, @Categoria, @Estado, @CostoEstandar, @ABC, @PaqueteCantidad, @CantidadEmbarcada, @ClavePresupuestal, @TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoRetencion1, @TipoRetencion2, @TipoRetencion3, @CostoConImpuesto, @TipoImpuesto4, @CostoPromedio, @CostoReposicion, @TipoImpuesto5, @Impuesto5, @ArtMaterial)
IF @@ERROR <> 0 SET @Ok = 1
SELECT @RenglonInv = MAX(Renglon) FROM InvD WHERE ID = @IDGenerarInv
SELECT @RenglonInv = ISNULL(@RenglonInv,0)
IF @TieneMateriales = 1
BEGIN
EXEC spProdExp @IDGenerarInv, NULL, NULL,  NULL, NULL, @ArtMaterial, NULL, @Cantidad, @UnidadMaterial, @Factor, @Volumen , @AlmacenMatPrima, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @CfgMermaIncluida, @CfgDesperdicioIncluido, @CfgTipoMerma, @FechaRequeridaD, @RenglonInv, @Ok, @OkRef, 'INV'
IF @Ok IS NULL
UPDATE InvD SET Posicion = @DefPosicionSurtido, PosicionDestino = @DefPosicionRecibo, Almacen = @AlmacenMatPrima
WHERE ID = @IDGenerarInv
END
ELSE
BEGIN
INSERT InvD(ID,           Renglon,  RenglonSub,  RenglonID,  RenglonTipo,  Cantidad,       Unidad,  Almacen,          Codigo,  Articulo,     SubCuenta,  Costo,  Posicion, CantidadInventario)
SELECT      @IDGenerarInv,@Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @CantidadOrden, @UnidadMaterial, @AlmacenMatPrima, @Codigo, @ArtMaterial, @SubCuenta, @Costo, @DefPosicionRecibo, @CantidadInventario
END
FETCH NEXT FROM crDetalle INTO   @Cantidad, @AlmacenD, @Codigo, @Articulo, @SubCuenta, @FechaRequeridaD, @FechaOrdenarD, @FechaEntregaD, @Costo, @Impuesto1, @Impuesto2, @Impuesto3, @Retencion1, @Retencion2, @Retencion3, @DescuentoD, @DescuentoTipo, @DescuentoLinea, @DescuentoImporte, @DescripcionExtra, @ReferenciaExtra, @ContUso, @DestinoTipo, @Destino, @DestinoID, @Aplica, @AplicaID, @CantidadPendiente, @CantidadCancelada, @CantidadA, @CostoInv, @Unidad, @Factor, @CantidadInventario, @Cliente, @ServicioArticulo, @ServicioSerie, @Paquete,  @ImportacionProveedor, @ImportacionReferencia, @ProveedorRef, @AgenteRef, @EstadoRef, @FechaCaducidad, @ProveedorArt, @ProveedorArtCosto, @AjusteCosteo, @CostoUEPS, @CostoPEPS, @UltimoCosto, @PrecioLista, @Posicion, @DepartamentoDetallista, @Pais, @TratadoComercial, @ProgramaSectorial, @ValorAduana, @ImportacionImpuesto1, @ImportacionImpuesto2, @ID1, @ID2, @FormaPago, @EsEstadistica, @PresupuestoEsp, @ContUso2, @ContUso3, @Tarima, @EmpresaRef, @Categoria, @Estado, @CostoEstandar, @ABC, @PaqueteCantidad, @CantidadEmbarcada, @ClavePresupuestal, @TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoRetencion1, @TipoRetencion2, @TipoRetencion3, @CostoConImpuesto, @TipoImpuesto4, @CostoPromedio, @CostoReposicion, @TipoImpuesto5, @Impuesto5, @ArtMaterial
END
CLOSE crDetalle
DEALLOCATE crDetalle
END
IF EXISTS (SELECT * FROM CompraD WHERE ID = @IDGenerar AND NULLIF(Costo,0) IS NULL)
SELECT @Ok = 20101
BEGIN TRANSACTION
IF @Ok IS NULL AND @IDGenerarInv IS NOT NULL
EXEC spAfectar 'INV', @IDGenerarInv, 'AFECTAR', 'Todo', NULL, @Usuario2, NULL, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @EnSilencio = 1, @Conexion = 1, @Estacion = @Estacion
IF @Ok IS NULL AND @IDGenerar IS NOT NULL
EXEC spAfectar 'COMS', @IDGenerar, 'AFECTAR', 'Todo', NULL, @Usuario2, NULL, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @EnSilencio = 1, @Conexion = 1, @Estacion = @Estacion
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
SELECT @OkRef = Descripcion +' '+ISNULL(@OkRef,'')
FROM MensajeLista WHERE Mensaje = @Ok
ROLLBACK TRANSACTION
END
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + ' Modulo="COMS" ModuloID =' + CHAR(34) + ISNULL(CONVERT(varchar,@IDGenerar),'') + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + ' MovIntelisisMES="'+ISNULL(@MovIntelisisMES,'')+'" ReferenciaIntelisisService="'+ISNULL(@ReferenciaIntelisisService,'')+'"/></Intelisis>'
END

