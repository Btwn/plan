SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISIntelisisPCInsertarMovPC_C
@ID                        int,
@iSolicitud                           int,
@Version                              float,
@Resultado                         varchar(max) = NULL OUTPUT,
@Ok                                                      int = NULL OUTPUT,
@OkRef                                 varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@IDGenerar                                    int,
@IDAcceso                                       int,
@MovTipo                                       varchar(20),
@ReferenciaIS                                                varchar(100),
@Usuario2                                       varchar(10),
@Estacion                                        int,
@SubReferencia                            varchar(100),
@Empresa                    varchar(5),
@Mov                        varchar(20),
@MovID                      varchar(20),
@FechaEmision               datetime   ,
@UltimoCambio               datetime   ,
@Proyecto                   varchar(50),
@UEN                        int   ,
@Concepto                   varchar(50),
@Moneda                     varchar(10),
@TipoCambio                 float   ,
@Usuario                    varchar(10),
@Autorizacion               varchar(10),
@DocFuente                  int   ,
@Observaciones              varchar(100),
@Referencia                 varchar(50),
@Estatus                    varchar(15),
@Situacion                  varchar(50),
@SituacionFecha             datetime   ,
@SituacionUsuario           varchar(10),
@SituacionNota              varchar(100),
@OrigenTipo                 varchar(10),
@Origen                     varchar(20),
@OrigenID                   varchar(20),
@Ejercicio                  int   ,
@Periodo                    int   ,
@FechaRegistro              datetime   ,
@FechaConclusion            datetime   ,
@FechaCancelacion           datetime   ,
@Poliza                     varchar(20),
@PolizaID                   varchar(20),
@GenerarPoliza              bit   ,
@ContID                     int   ,
@Sucursal                   int   ,
@ListaModificar             varchar(20),
@Proveedor                  varchar(10),
@FechaInicio                datetime   ,
@FechaTermino               datetime   ,
@Recalcular                 bit   ,
@Parcial                    bit   ,
@Metodo                     varchar(50),
@Monto                      float   ,
@Logico1                    bit   ,
@Logico2                    bit   ,
@Logico3                    bit   ,
@Logico4                    bit   ,
@Logico5                    bit   ,
@Logico6                    bit   ,
@Logico7                    bit   ,
@Logico8                    bit   ,
@Logico9                    bit   ,
@SincroID                   timestamp   ,
@SincroC                    int   ,
@SucursalOrigen             int   ,
@SucursalDestino            int,
@Articulo                   varchar(20),
@SubCuenta                  varchar(50),
@Unidad                     varchar(50),
@Nuevo                      money   ,
@Anterior                   money   ,
@Baja                       bit   ,
@ExistenciaSucursal         float   ,
@ListaModificarD            varchar(20),
@SucursalEsp                int   ,
@MontoD                     float   ,
@SucursalD                  int   ,
@SucursalOrigenD            int   ,
@CostoBase                  money   ,
@Renglon                    float,
@ReferenciaIntelisisService  varchar(50),
@Mov2                       varchar(20),
@Precio                     float,
@Planta                     varchar(20)
DECLARE @Temp                table
(
ID            int,
Renglon       float,
Articulo      varchar(20),
SubCuenta     varchar(50),
Unidad        varchar(50),
Nuevo         money,
Anterior      money,
Baja          bit,
ExistenciaSucursal  float,
ListaModificar  varchar(20),
SucursalEsp       int,
Monto         float,
Sucursal      int,
SucursalOrigen  int,
CostoBase  money
)
BEGIN TRANSACTION
SELECT @IDAcceso = dbo.fnAccesoID(@@SPID)
SELECT @Estacion = EstacionTrabajo  FROM Acceso WITH(NOLOCK) WHERE ID = @IDAcceso
IF @Ok IS NULL
BEGIN
SELECT @Mov =  NULLIF(Mov,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Mov varchar(255))
IF @@ERROR <> 0 SET @Ok = 1
END
SELECT @Mov2 = Mov FROM MapeoMovimientosInforIntelisis WITH(NOLOCK) WHERE INFORMov = @Mov
SELECT @MovTipo = Clave
FROM MovTipo WITH(NOLOCK)
WHERE Modulo = 'PC' AND Mov = @Mov2
IF @MovTipo <> 'PC.C' SELECT @Ok = 35005, @OkRef = @Mov
IF @Ok IS NULL
BEGIN
SELECT  @Empresa = NULLIF(Empresa,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Empresa  varchar(255))
SELECT  @FechaEmision = CONVERT(datetime,FechaEmision)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (FechaEmision  varchar(255))
SELECT  @UltimoCambio = CONVERT(datetime,UltimoCambio)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (UltimoCambio  varchar(255))
SELECT  @Proyecto = NULLIF(Proyecto,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Proyecto  varchar(255))
SELECT  @UEN = CONVERT(int,UEN)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (UEN  varchar(255))
SELECT  @Concepto = NULLIF(Concepto,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Concepto  varchar(255))
SELECT  @Moneda = NULLIF(Moneda,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Moneda  varchar(255))
SELECT  @TipoCambio = CONVERT(float,TipoCambio)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (TipoCambio  varchar(255))
SELECT  @Usuario = NULLIF(Usuario,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Usuario  varchar(255))
SELECT  @Autorizacion = NULLIF(Autorizacion,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Autorizacion  varchar(255))
SELECT  @DocFuente = CONVERT(int,DocFuente)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (DocFuente  varchar(255))
SELECT  @Observaciones = NULLIF(Observaciones,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Observaciones  varchar(255))
SELECT  @Referencia = NULLIF(Referencia,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Referencia  varchar(255))
SELECT  @Estatus = NULLIF(Estatus,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Estatus  varchar(255))
SELECT  @Situacion = NULLIF(Situacion,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Situacion  varchar(255))
SELECT  @SituacionFecha = CONVERT(datetime,SituacionFecha)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (SituacionFecha  varchar(255))
SELECT  @SituacionUsuario = NULLIF(SituacionUsuario,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (SituacionUsuario  varchar(255))
SELECT  @SituacionNota = NULLIF(SituacionNota,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (SituacionNota  varchar(255))
SELECT  @OrigenTipo = NULLIF(OrigenTipo,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (OrigenTipo  varchar(255))
SELECT  @Origen = NULLIF(Origen,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Origen  varchar(255))
SELECT  @OrigenID = NULLIF(OrigenID,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (OrigenID  varchar(255))
SELECT  @Ejercicio = CONVERT(int,Ejercicio)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Ejercicio  varchar(255))
SELECT  @Periodo = CONVERT(int,Periodo)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Periodo  varchar(255))
SELECT  @FechaRegistro = CONVERT(datetime,FechaRegistro)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (FechaRegistro  varchar(255))
SELECT  @FechaConclusion = CONVERT(datetime,FechaConclusion)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (FechaConclusion  varchar(255))
SELECT  @FechaCancelacion = CONVERT(datetime,FechaCancelacion)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (FechaCancelacion  varchar(255))
SELECT  @Poliza = NULLIF(Poliza,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Poliza  varchar(255))
SELECT  @PolizaID = NULLIF(PolizaID,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (PolizaID  varchar(255))
SELECT  @GenerarPoliza = CONVERT(bit,GenerarPoliza)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (GenerarPoliza  varchar(255))
SELECT  @ContID = CONVERT(int,ContID)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (ContID  varchar(255))
SELECT  @Sucursal = CONVERT(int,Sucursal)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Sucursal  varchar(255))
SELECT  @ListaModificar = NULLIF(ListaModificar,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (ListaModificar  varchar(255))
SELECT  @Proveedor = NULLIF(Proveedor,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Proveedor  varchar(255))
SELECT  @FechaInicio = CONVERT(datetime,FechaInicio)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (FechaInicio  varchar(255))
SELECT  @FechaTermino = CONVERT(datetime,FechaTermino)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (FechaTermino  varchar(255))
SELECT  @Recalcular = CONVERT(bit,Recalcular)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Recalcular  varchar(255))
SELECT  @Parcial = CONVERT(bit,Parcial)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Parcial  varchar(255))
SELECT  @Metodo = NULLIF(Metodo,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Metodo  varchar(255))
SELECT  @Monto = CONVERT(float,Monto)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Monto  varchar(255))
SELECT  @Logico1 = CONVERT(bit,Logico1)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Logico1  varchar(255))
SELECT  @Logico2 = CONVERT(bit,Logico2)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Logico2  varchar(255))
SELECT  @Logico3 = CONVERT(bit,Logico3)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Logico3  varchar(255))
SELECT  @Logico4 = CONVERT(bit,Logico4)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Logico4  varchar(255))
SELECT  @Logico5 = CONVERT(bit,Logico5)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Logico5  varchar(255))
SELECT  @Logico6 = CONVERT(bit,Logico6)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Logico6  varchar(255))
SELECT  @Logico7 = CONVERT(bit,Logico7)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Logico7  varchar(255))
SELECT  @Logico8 = CONVERT(bit,Logico8)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Logico8  varchar(255))
SELECT  @Logico9 = CONVERT(bit,Logico9)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (Logico9  varchar(255))
SELECT  @SucursalOrigen = CONVERT(int,SucursalOrigen)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (SucursalOrigen  varchar(255))
SELECT  @SucursalDestino = CONVERT(int,SucursalDestino)  FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (SucursalDestino  varchar(255))
SELECT  @ReferenciaIntelisisService = NULLIF(ReferenciaIntelisisService,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/PC')
WITH (ReferenciaIntelisisService  varchar(255))
END
IF @Ok IS NULL
BEGIN
SET @Estatus = 'SINAFECTAR'
SELECT @OrigenTipo='I:MES'
SELECT @Empresa = Empresa ,@Planta=Planta
FROM MapeoPlantaIntelisisMes WITH(NOLOCK)
WHERE Referencia = @ReferenciaIntelisisService
SELECT @Sucursal = Sucursal, @SucursalOrigen = Sucursal
FROM PlantaProductiva WITH(NOLOCK) WHERE Clave =@Planta
IF NOT EXISTS(SELECT * FROM Mon WITH(NOLOCK) WHERE Moneda = @Moneda ) SELECT @Ok = 20196
IF NOT EXISTS(SELECT * FROM Proy WITH(NOLOCK) WHERE Proyecto = @Proyecto ) AND NULLIF(@Proyecto,'') IS NOT NULL SELECT @Ok = 15010
IF NOT EXISTS(SELECT * FROM UEN WITH(NOLOCK) WHERE UEN = @UEN ) AND NULLIF(@UEN,'') IS NOT NULL SELECT @Ok = 10070
IF NOT EXISTS(SELECT * FROM MovTipo WITH(NOLOCK) WHERE Mov = @Mov ) SELECT @Ok = 14055
IF NOT EXISTS(SELECT * FROM Sucursal WITH(NOLOCK) WHERE Sucursal =  @Sucursal)SELECT @Ok = 72060
IF NOT EXISTS(SELECT * FROM Empresa WITH(NOLOCK) WHERE Empresa =  @Empresa)SELECT @Ok =26070
END
IF @Ok IS NULL
BEGIN
INSERT INTO PC ( Empresa, Mov, FechaEmision, UltimoCambio, Proyecto, UEN, Concepto, Moneda, TipoCambio, Usuario, Autorizacion, DocFuente, Observaciones, Referencia, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, OrigenTipo, Origen, OrigenID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, Poliza, PolizaID, GenerarPoliza, ContID, Sucursal, ListaModificar, Proveedor, FechaInicio, FechaTermino, Recalcular, Parcial, Metodo, Monto, Logico1, Logico2, Logico3, Logico4, Logico5, Logico6, Logico7, Logico8, Logico9, SucursalOrigen, SucursalDestino)
VALUES (   @Empresa, @Mov,  @FechaEmision, @UltimoCambio, @Proyecto, @UEN, @Concepto, @Moneda, @TipoCambio, @Usuario, @Autorizacion, @DocFuente, @Observaciones, @Referencia, @Estatus, @Situacion, @SituacionFecha, @SituacionUsuario, @SituacionNota, @OrigenTipo, @Origen, @OrigenID, @Ejercicio, @Periodo, @FechaRegistro, @FechaConclusion, @FechaCancelacion, @Poliza, @PolizaID, @GenerarPoliza, @ContID, @Sucursal, @ListaModificar, @Proveedor, @FechaInicio, @FechaTermino, @Recalcular, @Parcial, @Metodo, @Monto, @Logico1, @Logico2, @Logico3, @Logico4, @Logico5, @Logico6, @Logico7, @Logico8, @Logico9,  @SucursalOrigen, @SucursalDestino)
IF @@ERROR <> 0 SET @Ok = 1
SET @IDGenerar = SCOPE_IDENTITY()
END
INSERT @Temp (  Articulo, SubCuenta, Unidad, Nuevo, Anterior, Baja, ExistenciaSucursal, ListaModificar, SucursalEsp, Monto, Sucursal, SucursalOrigen, CostoBase)
SELECT          Articulo, SubCuenta, Unidad, Nuevo, Anterior, Baja, ExistenciaSucursal, ListaModificar, SucursalEsp, Monto, Sucursal, SucursalOrigen, CostoBase
FROM OPENXML(@iSolicitud, '/Intelisis/Solicitud/PC/PCD',1)
WITH (Articulo   varchar(100), SubCuenta   varchar(100), Unidad   varchar(100), Nuevo   varchar(100), Anterior   varchar(100), Baja   varchar(100), ExistenciaSucursal   varchar(100), ListaModificar   varchar(100), SucursalEsp   varchar(100), Monto   varchar(100), Sucursal   varchar(100), SucursalOrigen   varchar(100), CostoBase  varchar(100))
BEGIN
DECLARE crDetalle CURSOR LOCAL FAST_FORWARD FOR
SELECT   Articulo, SubCuenta, Unidad, Nuevo, Anterior, Baja, ExistenciaSucursal, ListaModificar, SucursalEsp, Monto, Sucursal, SucursalOrigen, CostoBase
FROM @Temp
SET @Renglon = 0.0
OPEN crDetalle
FETCH NEXT FROM crDetalle INTO   @Articulo,@SubCuenta , @Unidad, @Nuevo, @Anterior, @Baja, @ExistenciaSucursal, @ListaModificarD, @SucursalEsp, @MontoD, @SucursalD, @SucursalOrigenD, @CostoBase
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @SubCuenta =ISNULL(@SubCuenta,'')
EXEC spPCGet @Sucursal, @Empresa, @Articulo, @SubCuenta, @Unidad, @Moneda, @TipoCambio, @ListaModificar, @Precio OUTPUT
SELECT @Anterior = @Precio
SET @Renglon = @Renglon + 2048.0
INSERT PCD (   ID        ,  Renglon,  Articulo, SubCuenta, Unidad, Nuevo, Anterior, Baja, ExistenciaSucursal, ListaModificar, SucursalEsp, Monto, Sucursal, SucursalOrigen)
VALUES         (@IDGenerar, @Renglon, @Articulo, @SubCuenta, @Unidad, @Nuevo, @Anterior, @Baja, @ExistenciaSucursal, @ListaModificarD, @SucursalEsp, @MontoD, @Sucursal, @SucursalOrigen)
IF @@ERROR <> 0 SET @Ok = 1
FETCH NEXT FROM crDetalle INTO  @Articulo, @SubCuenta, @Unidad, @Nuevo, @Anterior, @Baja, @ExistenciaSucursal, @ListaModificarD, @SucursalEsp, @MontoD, @SucursalD, @SucursalOrigenD, @CostoBase
END
CLOSE crDetalle
DEALLOCATE crDetalle
END
IF @Ok IS NULL
EXEC spAfectar 'PC', @IDGenerar, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
SELECT @ReferenciaIS = Referencia
FROM IntelisisService WITH(NOLOCK)
WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + ' Modulo="PC" ModuloID =' + CHAR(34) + ISNULL(CONVERT(varchar,@IDGenerar),'') + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/></Intelisis>'
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
END
END

