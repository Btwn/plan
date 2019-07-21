SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISIntelisisINVInsertarMovINV_EST
@ID							int,
@iSolicitud					int,
@Version					float,
@Resultado					varchar(max) = NULL OUTPUT,
@Ok							int = NULL OUTPUT,
@OkRef						varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@IDGenerar					int,
@IDAcceso					int,
@MovTipo					varchar(20),
@ReferenciaIS				varchar(100),
@Usuario2					varchar(10),
@Estacion					int,
@SubReferencia				varchar(100),
@Empresa					varchar(5),
@Mov						varchar(20),
@Mov2						varchar(20),
@MovID						varchar(20),
@FechaEmision				datetime,
@UltimoCambio				datetime,
@Concepto					varchar(50),
@Proyecto					varchar(50),
@Actividad					varchar(100),
@UEN						int,
@Moneda						varchar(10),
@TipoCambio					float,
@Usuario					varchar(10),
@Autorizacion				varchar(10),
@Referencia					varchar(50),
@DocFuente					int,
@Observaciones				varchar(100),
@Estatus					varchar(15),
@Situacion					varchar(50),
@SituacionFecha				datetime,
@SituacionUsuario			varchar(10),
@SituacionNota				varchar(100),
@Prioridad					varchar(10),
@Directo					bit,
@RenglonID					int,
@Almacen					varchar(10),
@AlmacenDestino				varchar(10),
@AlmacenTransito			varchar(10),
@Largo						bit,
@FechaRequerida				datetime,
@Condicion					varchar(50),
@Vencimiento				datetime   ,
@FormaEnvio					varchar(50),
@OrigenTipo					varchar(10),
@Origen						varchar(20),
@OrigenID					varchar(20),
@Poliza						varchar(20),
@PolizaID					varchar(20),
@GenerarPoliza				bit,
@ContID						int,
@Ejercicio					int,
@Periodo					int,
@FechaRegistro				datetime,
@FechaConclusion			datetime,
@FechaCancelacion			datetime,
@FechaOrigen				datetime,
@Peso						float,
@Volumen					float,
@Paquetes					int,
@FechaEntrega				datetime,
@EmbarqueEstado				varchar(50),
@Sucursal					int,
@Sucursal2					int,
@Importe					money,
@Logico1					bit,
@Logico2					bit,
@Logico3					bit,
@Logico4					bit,
@Logico5					bit,
@Logico6					bit,
@Logico7					bit,
@Logico8					bit,
@Logico9					bit,
@VerLote					bit,
@EspacioResultado			bit,
@VerDestino					bit,
@EstaImpreso				bit,
@Personal					varchar(10),
@Reabastecido				bit,
@Conteo						int,
@Agente						varchar(10),
@ACRetencion				float,
@SubModulo					varchar(5),
@SucursalOrigen				int,
@SucursalDestino			int,
@PedimentoExtraccion		varchar(50),
@MovMES						bit,
@IDD						int,
@Renglon					float,
@RenglonSub					int,
@RenglonIDD					int,
@RenglonTipo				char(1),
@Cantidad					float   ,
@AlmacenD					varchar(10),
@Codigo						varchar(30),
@Articulo					varchar(20),
@ArticuloDestino			varchar(20),
@SubCuenta					varchar(50),
@SubCuentaDestino			varchar(50),
@Costo						money,
@CostoInv					money,
@ContUso					varchar(20),
@Espacio					varchar(10),
@CantidadReservada			float,
@CantidadCancelada			float,
@CantidadOrdenada			float,
@CantidadPendiente			float,
@CantidadA					float,
@Paquete					int,
@Aplica						varchar(20),
@AplicaID					varchar(20),
@DestinoTipo				varchar(10),
@Destino					varchar(20),
@DestinoID					varchar(20),
@Cliente					varchar(10),
@Unidad						varchar(50),
@Factor						float,
@CantidadInventario			float,
@UltimoReservadoCantidad	float,
@UltimoReservadoFecha		datetime,
@ProdSerieLote				varchar(50),
@Merma						float,
@Desperdicio				float,
@Producto					varchar(20),
@SubProducto				varchar(20),
@Tipo						varchar(20),
@Precio						money,
@SegundoConteo				float,
@DescripcionExtra			varchar(100),
@AjusteCosteo				money,
@CostoUEPS					money,
@CostoPEPS					money,
@UltimoCosto				money,
@PrecioLista				money,
@DepartamentoDetallista		int,
@AjustePrecioLista			money,
@Posicion					varchar(10),
@Tarima                     varchar(20),
@Seccion                    smallint,
@CostoEstandar              money,
@FechaCaducidad				datetime,
@CostoPromedio              money,
@CostoReposicion			money,
@Proveedor                  varchar(10),
@ReferenciaIntelisisService	varchar(50),
@Articulo2                  varchar(20),
@ArtCompra                  varchar(20),
@Lote                       Varchar(50),
@Cantidad2                  float,
@UltRenglonID				int,
@Tipo2                      varchar(20),
@ArtTipo					varchar(20),
@CostoConsumoMat			float,
@CostoManoObra				float,
@CostoIndirecto				float,
@CostoServicio				float,
@ReferenciaMES				varchar(50),
@PedidoMES					varchar(20),
@Motivo						varchar(8),
@Planta						varchar(20),
@IDMES						int,
@Serie						varchar(3),
@IDVenta					int,
@MovVenta					varchar(20),
@RenglonCompra				float,
@CantidadVenta				float,
@Reservar					bit,
@CfgReservar				bit,
@NuevoID					int ,
@MovO						varchar(20),
@MoVIDO						varchar(20),
@IDMarcaje					int,
@SubClave					varchar(20),
@ArticuloD					varchar(20),
@CantidadD					float,
@CantidadResta				float,
@SubCuentaD					varchar(50),
@UnidadD					varchar(50),
@UnidadP					varchar(50),
@IDPedido					int,
@RenglonD					float,
@AlmacenDD					varchar(10),
@AlmacenO					varchar(10),
@ArticuloO					varchar(20),
@CantidadO					float,
@IDSol						int,
@SubCuentaO					varchar(50),
@UnidadO					varchar(50),
@RenglonO					float,
@CantidadReservar			float,
@CantidadPendienteO			float,
@UnidadPO					varchar(50),
@AlmacenP					varchar(10)
DECLARE @Temp             table
(
IDD                        int,
Renglon                    float,
RenglonSub                 int,
RenglonID					int,
RenglonTipo				char(1),
Cantidad					float,
Almacen                    varchar(10),
Codigo                     varchar(30),
Articulo					varchar(20),
ArticuloDestino			varchar(20),
SubCuenta					varchar(50),
SubCuentaDestino			varchar(50),
Costo                      float,
CostoInv                   float,
ContUso                    varchar(20),
Espacio                    varchar(10),
CantidadReservada			float,
CantidadCancelada			float,
CantidadOrdenada			float,
CantidadPendiente			float,
CantidadA					float,
Paquete                    int,
FechaRequerida				datetime,
Aplica                     varchar(20),
AplicaID					varchar(20),
DestinoTipo                varchar(10),
Destino                    varchar(20),
DestinoID					varchar(20),
Cliente                    varchar(10),
Unidad                     varchar(50),
Factor                     float,
CantidadInventario			float,
UltimoReservadoCantidad	float,
UltimoReservadoFecha		datetime,
ProdSerieLote				varchar(50),
Merma                      float,
Desperdicio                float,
Producto					varchar(20),
SubProducto                 varchar(20),
Tipo                       varchar(20),
Sucursal					int,
Precio                     float,
SegundoConteo				float,
DescripcionExtra			varchar(100),
AjusteCosteo				float,
CostoUEPS                  float,
CostoPEPS                  float,
UltimoCosto				float,
PrecioLista				float,
DepartamentoDetallista		int,
AjustePrecioLista			float,
Posicion					varchar(10),
SucursalOrigen				int,
Tarima                     varchar(20),
Seccion                    smallint,
CostoEstandar              float,
FechaCaducidad				datetime,
CostoPromedio              float,
CostoReposicion			float,
CostoConsumoMat			float,
CostoManoObra				float,
CostoIndirecto				float,
CostoServicio				float
)
SELECT @IDAcceso = dbo.fnAccesoID(@@SPID)
SELECT @Estacion = EstacionTrabajo  FROM Acceso WHERE ID = @IDAcceso
IF @Ok IS NULL
BEGIN
SELECT  @Mov2 = NULLIF(Mov,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Mov   varchar(255))
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
SELECT @Mov2 = Mov FROM MapeoMovimientosInforIntelisis WHERE INFORMov = @Mov
SELECT @MovTipo = Clave,@SubClave = SubClave
FROM MovTipo
WHERE Modulo = 'INV' AND Mov = @Mov2
IF @MovTipo <> 'INV.EST' SELECT @Ok = 35005, @OkRef = @Mov
IF @Ok IS NULL
BEGIN
SELECT  @Mov = NULLIF(Dev,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Dev   varchar(255))
IF @Mov IS NULL
BEGIN
SELECT  @Mov = NULLIF(Mov,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Mov   varchar(255))
END
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
SELECT  @Motivo = NULLIF(MotivoRechazo,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(MotivoRechazo   varchar(255))
SELECT  @ReferenciaMES = NULLIF(ReferenciaMES,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(ReferenciaMES   varchar(255))
SELECT  @PedidoMES = NULLIF(PedidoMES ,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(PedidoMES    varchar(255))
SELECT  @IDMES = CONVERT(int,IDMES)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(IDMES   varchar(255))
SELECT  @Serie = NULLIF(Serie ,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(Serie    varchar(255))
SELECT  @IDMarcaje = CONVERT(int,IDMarcaje)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Inv')
WITH(IDMarcaje   varchar(255))
END
IF @Ok IS NULL
BEGIN
SET @Estatus = 'SINAFECTAR'
SELECT @Empresa = Empresa ,@Sucursal = Sucursal, @SucursalOrigen = Sucursal
FROM MapeoPlantaIntelisisMes
WHERE Referencia = @ReferenciaIntelisisService
SELECT @Sucursal2 = @Sucursal
SELECT @CfgReservar = PedidosReservar FROM EmpresaCfg WHERE Empresa = @Empresa
IF NOT EXISTS(SELECT * FROM Mon WHERE Moneda = @Moneda ) SELECT @Ok = 20196
IF NOT EXISTS(SELECT * FROM Alm WHERE Almacen = @Almacen ) SELECT @Ok = 20830
IF NOT EXISTS(SELECT * FROM Proy WHERE Proyecto = @Proyecto ) AND NULLIF(@Proyecto,'') IS NOT NULL SELECT @Ok = 15010
IF NOT EXISTS(SELECT * FROM UEN WHERE UEN = @UEN ) AND NULLIF(@UEN,'') IS NOT NULL SELECT @Ok = 10070
IF NOT EXISTS(SELECT * FROM MovTipo WHERE Mov = @Mov2 ) SELECT @Ok = 14055
IF NOT EXISTS(SELECT * FROM Sucursal WHERE Sucursal = @Sucursal )SELECT @Ok = 72060
IF NOT EXISTS(SELECT * FROM Empresa WHERE Empresa =  @Empresa)SELECT @Ok =26070
END
IF @Ok IS NULL
BEGIN
IF @Almacen NOT IN(SELECT Almacen FROM Alm WHERE Sucursal = @Sucursal)
SELECT @Almacen = AlmacenPrincipal FROM Sucursal WHERE Sucursal = @Sucursal
SELECT @OrigenTipo ='I:MES'
INSERT INTO Inv (Empresa, Mov,   MovID, FechaEmision,   UltimoCambio, Concepto, Proyecto, Actividad,   UEN,   Moneda,   TipoCambio,   Usuario,   Autorizacion,   Referencia, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario,   SituacionNota,   Prioridad, Directo, RenglonID, Almacen,   AlmacenDestino,   AlmacenTransito,   Largo,   FechaRequerida,   Condicion,   Vencimiento, FormaEnvio, OrigenTipo, Origen, OrigenID, Poliza,   PolizaID,   GenerarPoliza, ContID, Ejercicio, Periodo,   FechaRegistro,   FechaConclusion,   FechaCancelacion,   FechaOrigen,   Peso, Volumen, Paquetes, FechaEntrega, EmbarqueEstado,   Sucursal,   Importe,   Logico1, Logico2, Logico3, Logico4, Logico5,   Logico6,   Logico7,   Logico8,   Logico9, VerLote, EspacioResultado,   VerDestino, EstaImpreso,   Personal, Reabastecido,   Conteo, Agente,   ACRetencion, SubModulo,   SucursalOrigen, SucursalDestino,   PedimentoExtraccion, MovMES,Motivo,ReferenciaMES, PedidoMES ,IDMES  ,Serie,IDMarcaje)
SELECT  @Empresa, @Mov2, @MovID, @FechaEmision, @UltimoCambio, @Concepto, @Proyecto, @Actividad, @UEN, @Moneda, @TipoCambio, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, @Estatus, @Situacion, @SituacionFecha, @SituacionUsuario, @SituacionNota, @Prioridad, @Directo, @RenglonID, @Almacen, @AlmacenDestino, @AlmacenTransito, @Largo, @FechaRequerida, @Condicion, @Vencimiento, @FormaEnvio, @OrigenTipo, @Origen, @OrigenID, @Poliza, @PolizaID, @GenerarPoliza, @ContID, @Ejercicio, @Periodo, @FechaRegistro, @FechaConclusion, @FechaCancelacion, @FechaOrigen, @Peso, @Volumen, @Paquetes, @FechaEntrega, @EmbarqueEstado, ISNULL(@Sucursal,@Sucursal2), @Importe, @Logico1, @Logico2, @Logico3, @Logico4, @Logico5, @Logico6, @Logico7, @Logico8, @Logico9, @VerLote, @EspacioResultado, @VerDestino, @EstaImpreso, @Personal, @Reabastecido, @Conteo, @Agente, @ACRetencion, @SubModulo, @SucursalOrigen, @SucursalDestino, @PedimentoExtraccion, @MovMES,@Motivo,@ReferenciaMES, @PedidoMES  ,@IDMES,@Serie ,@IDMarcaje
IF @@ERROR <> 0 SET @Ok = 1
SET @IDGenerar = SCOPE_IDENTITY()
END
SELECT @RenglonSub = 0
INSERT @Temp (  RenglonTipo, Cantidad, Almacen, Codigo, Articulo, ArticuloDestino, SubCuenta, SubCuentaDestino, Costo, CostoInv, ContUso, Espacio, CantidadReservada, CantidadCancelada, CantidadOrdenada, CantidadPendiente, CantidadA, Paquete, FechaRequerida, Aplica, AplicaID, DestinoTipo, Destino, DestinoID, Cliente, Unidad,            Factor, CantidadInventario,                   UltimoReservadoCantidad, UltimoReservadoFecha, ProdSerieLote, Merma, Desperdicio, Producto, SubProducto, Tipo, Sucursal, Precio, SegundoConteo, DescripcionExtra, AjusteCosteo, CostoUEPS, CostoPEPS, UltimoCosto, PrecioLista, DepartamentoDetallista, AjustePrecioLista, Posicion, SucursalOrigen, Tarima, Seccion, CostoEstandar, FechaCaducidad, CostoPromedio, CostoReposicion, CostoConsumoMat, CostoManoObra, CostoIndirecto, CostoServicio)
SELECT          RenglonTipo, Cantidad, Almacen, Codigo, Articulo, ArticuloDestino, SubCuenta, SubCuentaDestino, Costo, CostoInv, ContUso, Espacio, CantidadReservada, CantidadCancelada, CantidadOrdenada, CantidadPendiente, CantidadA, Paquete, FechaRequerida, Aplica, AplicaID, DestinoTipo, Destino, DestinoID, Cliente, DescripcionUnidad, Factor, ISNULL(CantidadInventario, Cantidad), UltimoReservadoCantidad, UltimoReservadoFecha, ProdSerieLote, Merma, Desperdicio, Producto, SubProducto, Tipo, Sucursal, Precio, SegundoConteo, DescripcionExtra, AjusteCosteo, CostoUEPS, CostoPEPS, UltimoCosto, PrecioLista, DepartamentoDetallista, AjustePrecioLista, Posicion, SucursalOrigen, Tarima, Seccion, CostoEstandar, FechaCaducidad, CostoPromedio, CostoReposicion, CostoConsumoMat, CostoManoObra, CostoIndirecto, CostoServicio
FROM OPENXML(@iSolicitud, '/Intelisis/Solicitud/Inv/DetalleInv',1)
WITH (RenglonSub  varchar(100), RenglonID  varchar(100), RenglonTipo  varchar(100), Cantidad  varchar(100), Almacen  varchar(100), Codigo  varchar(100), Articulo  varchar(100), ArticuloDestino  varchar(100), SubCuenta  varchar(100), SubCuentaDestino  varchar(100), Costo  varchar(100), CostoInv  varchar(100), ContUso  varchar(100), Espacio  varchar(100), CantidadReservada  varchar(100), CantidadCancelada  varchar(100), CantidadOrdenada  varchar(100), CantidadPendiente  varchar(100), CantidadA  varchar(100), Paquete  varchar(100), FechaRequerida  varchar(100), Aplica  varchar(100), AplicaID  varchar(100), DestinoTipo  varchar(100), Destino  varchar(100), DestinoID  varchar(100), Cliente  varchar(100), Unidad  varchar(100), Factor  varchar(100), CantidadInventario  varchar(100), UltimoReservadoCantidad  varchar(100), UltimoReservadoFecha  varchar(100), ProdSerieLote  varchar(100), Merma  varchar(100), Desperdicio  varchar(100), Producto  varchar(100), SubProducto  varchar(100), Tipo  varchar(100), Sucursal  varchar(100), Precio  varchar(100), SegundoConteo  varchar(100), DescripcionExtra  varchar(100), AjusteCosteo  varchar(100), CostoUEPS  varchar(100), CostoPEPS  varchar(100), UltimoCosto  varchar(100), PrecioLista  varchar(100), DepartamentoDetallista  varchar(100), AjustePrecioLista  varchar(100), Posicion  varchar(100), SucursalOrigen  varchar(100), Tarima  varchar(100), Seccion  varchar(100), CostoEstandar  varchar(100), FechaCaducidad  varchar(100), CostoPromedio  varchar(100), CostoReposicion varchar(100),ES varchar(100),PR varchar(100),UC varchar(100),MO varchar(100),CI varchar(100),CM varchar(100),MA varchar(100),ReferenciaMES varchar(100),PedidoMES varchar(100),IDMarcaje  varchar(100), DescripcionUnidad varchar(100), CostoConsumoMat float, CostoManoObra float, CostoIndirecto float, CostoServicio float)
SET @RenglonIDD =0
UPDATE @Temp
SET @RenglonIDD = RenglonID = @RenglonIDD + 1
FROM @Temp
IF @OK IS NULL
BEGIN
DECLARE @tblCostoReposicion as TABLE (Articulo varchar(20), CostoReposicion float)
DECLARE crDetalle CURSOR LOCAL FAST_FORWARD FOR
SELECT  RenglonTipo, Cantidad, Almacen, Codigo, Articulo, ArticuloDestino, SubCuenta, SubCuentaDestino, Costo, CostoInv, ContUso, Espacio, CantidadReservada, CantidadCancelada, CantidadOrdenada, CantidadPendiente, CantidadA, Paquete, FechaRequerida, Aplica, AplicaID, DestinoTipo, Destino, DestinoID, Cliente, Unidad, Factor, Cantidad*dbo.fnArtUnidadFactor(@Empresa, Articulo, Unidad), UltimoReservadoCantidad, UltimoReservadoFecha, ProdSerieLote, Merma, Desperdicio, Producto, SubProducto, Tipo, Precio, SegundoConteo, DescripcionExtra, AjusteCosteo, CostoUEPS, CostoPEPS, UltimoCosto, PrecioLista, DepartamentoDetallista, AjustePrecioLista, Posicion,  Tarima, Seccion, CostoEstandar, FechaCaducidad, CostoPromedio, CostoReposicion,CostoConsumoMat, CostoManoObra, CostoIndirecto, CostoServicio ,RenglonID
FROM @Temp
SET @Renglon = 0.0
OPEN crDetalle
FETCH NEXT FROM crDetalle INTO   @RenglonTipo, @Cantidad, @AlmacenD, @Codigo, @Articulo, @ArticuloDestino, @SubCuenta, @SubCuentaDestino, @Costo, @CostoInv, @ContUso, @Espacio, @CantidadReservada, @CantidadCancelada, @CantidadOrdenada, @CantidadPendiente, @CantidadA, @Paquete, @FechaRequerida, @Aplica, @AplicaID, @DestinoTipo, @Destino, @DestinoID, @Cliente, @Unidad, @Factor, @CantidadInventario, @UltimoReservadoCantidad, @UltimoReservadoFecha, @ProdSerieLote, @Merma, @Desperdicio, @Producto, @SubProducto, @Tipo, @Precio, @SegundoConteo, @DescripcionExtra, @AjusteCosteo, @CostoUEPS, @CostoPEPS, @UltimoCosto, @PrecioLista, @DepartamentoDetallista, @AjustePrecioLista, @Posicion,  @Tarima, @Seccion, @CostoEstandar, @FechaCaducidad, @CostoPromedio, @CostoReposicion, @CostoConsumoMat, @CostoManoObra, @CostoIndirecto, @CostoServicio,@RenglonID
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @Costo = ISNULL(NULLIF(@Costo,0.0),@CostoEstandar)
IF NOT EXISTS(SELECT * FROM Alm WHERE Almacen = @Almacen ) SELECT @Ok = 20830
IF @Cantidad < 0 SET @Ok = 20010
IF @Costo < 0 SET @Ok = 20140
SELECT @Aplica = i.Mov, @AplicaID = i.MovID FROM Inv i JOIN MovTipo mt ON i.Mov = mt.Mov AND mt.Modulo = 'INV' WHERE i.ReferenciaMES = @ReferenciaMES AND i.OrigenTipo = @OrigenTipo AND mt.Clave= '' AND i.Estatus = 'PENDIENTE'
IF @AlmacenD NOT IN(SELECT Almacen FROM Alm WHERE Sucursal = @Sucursal) AND @Ok IS NULL
SELECT @AlmacenD = AlmacenPrincipal FROM Sucursal WHERE Sucursal = @Sucursal
SELECT @ArtTipo = Tipo FROM Art WHERE Articulo = @Articulo
EXEC spRenglonTipo @ArtTipo, @Subcuenta, @RenglonTipo OUTPUT
SET @Renglon = @Renglon + 2048.0
INSERT InvD (   ID        ,  Renglon,RenglonID,  RenglonSub,  RenglonTipo,  Cantidad,  Almacen,  Codigo,  Articulo,  ArticuloDestino,  SubCuenta,  SubCuentaDestino,  Costo,  CostoInv,  ContUso,  Espacio,  CantidadReservada,  CantidadCancelada,  CantidadOrdenada,  CantidadPendiente,  CantidadA,  Paquete,  FechaRequerida,  Aplica,  AplicaID,  DestinoTipo,  Destino,  DestinoID,  Cliente,  Unidad,  Factor,  CantidadInventario,  UltimoReservadoCantidad,  UltimoReservadoFecha,  ProdSerieLote,  Merma,  Desperdicio,  Producto,  SubProducto,  Tipo,  Sucursal,  Precio,  SegundoConteo,  DescripcionExtra,  AjusteCosteo,  CostoUEPS,  CostoPEPS,  UltimoCosto,  PrecioLista,  DepartamentoDetallista,  AjustePrecioLista,  Posicion,  SucursalOrigen,  Tarima,  Seccion,  CostoEstandar,  FechaCaducidad,  CostoPromedio,  CostoReposicion   )
VALUES         (@IDGenerar, @Renglon,@RenglonID, @RenglonSub,  @RenglonTipo, @Cantidad, @AlmacenD, @Codigo, @Articulo, @ArticuloDestino, @SubCuenta, @SubCuentaDestino, @Costo, @CostoInv, @ContUso, @Espacio, @CantidadReservada, @CantidadCancelada, @CantidadOrdenada, @CantidadPendiente, @CantidadA, @Paquete, @FechaRequerida, @Aplica, @AplicaID, @DestinoTipo, @Destino, @DestinoID, @Cliente, @Unidad, @Factor, @CantidadInventario, @UltimoReservadoCantidad, @UltimoReservadoFecha, @ProdSerieLote, @Merma, @Desperdicio, @Producto, @SubProducto, @Tipo, ISNULL(@Sucursal,@Sucursal2), @Precio, @SegundoConteo, @DescripcionExtra, @AjusteCosteo, @CostoUEPS, @CostoPEPS, @UltimoCosto, @PrecioLista, @DepartamentoDetallista, @AjustePrecioLista, @Posicion, @SucursalOrigen, @Tarima, @Seccion, @CostoEstandar, @FechaCaducidad, @CostoPromedio, @CostoReposicion   )
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
INSERT InvDCosto(ID,Renglon,RenglonID,Articulo,CostoEstandar,CostoServicio, CostoManoObra, CostoIndirecto, CostoMateriales)
SELECT          @IDGenerar,@Renglon,@RenglonIDD,@Articulo,ISNULL(@Costo,0.0), ISNULL(@CostoServicio,0.0) , ISNULL(@CostoManoObra,0.0) ,ISNULL(@CostoIndirecto,0.0), ISNULL(@CostoConsumoMat,0.0)
INSERT @tblCostoReposicion (Articulo, CostoReposicion)
SELECT @Articulo, ISNULL(@Costo,0.0)
END
IF @@ERROR <> 0 SET @Ok = 1
FETCH NEXT FROM crDetalle INTO  @RenglonTipo, @Cantidad, @AlmacenD, @Codigo, @Articulo, @ArticuloDestino, @SubCuenta, @SubCuentaDestino, @Costo, @CostoInv, @ContUso, @Espacio, @CantidadReservada, @CantidadCancelada, @CantidadOrdenada, @CantidadPendiente, @CantidadA, @Paquete, @FechaRequerida, @Aplica, @AplicaID, @DestinoTipo, @Destino, @DestinoID, @Cliente, @Unidad, @Factor, @CantidadInventario, @UltimoReservadoCantidad, @UltimoReservadoFecha, @ProdSerieLote, @Merma, @Desperdicio, @Producto, @SubProducto, @Tipo, @Precio, @SegundoConteo, @DescripcionExtra, @AjusteCosteo, @CostoUEPS, @CostoPEPS, @UltimoCosto, @PrecioLista, @DepartamentoDetallista, @AjustePrecioLista, @Posicion,  @Tarima, @Seccion, @CostoEstandar, @FechaCaducidad, @CostoPromedio, @CostoReposicion, @CostoConsumoMat, @CostoManoObra, @CostoIndirecto, @CostoServicio,@RenglonID
END
CLOSE crDetalle
DEALLOCATE crDetalle
END
BEGIN TRANSACTION
IF @Ok IS NULL AND @Estatus = 'SINAFECTAR'
EXEC spAfectar 'INV', @IDGenerar, 'AFECTAR', 'Todo', NULL, @Usuario, NULL, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @EnSilencio = 1, @Conexion = 1, @Estacion = @Estacion
IF @Ok IS NULL
BEGIN
UPDATE Art
SET CostoReposicion = T.CostoReposicion
FROM @tblCostoReposicion T
WHERE Art.Articulo = T.Articulo
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
UPDATE Inv SET Estatus = 'BORRADOR' WHERE ID = @IDGenerar
END
IF @Ok IS NULL
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + ' Modulo="INV" ModuloID =' + CHAR(34) + ISNULL(CONVERT(varchar,@IDGenerar),'') + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/></Intelisis>'
END

