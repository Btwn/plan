SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisCOMSMovListado
@ID                        int,
@iSolicitud                           int,
@Version                              float,
@Resultado                         varchar(max) = NULL OUTPUT,
@Ok                                                      int = NULL OUTPUT,
@OkRef                                 varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@IDO                                             int,
@Texto                                  xml,
@Empresa                            varchar(5),
@Mov                                    varchar(20),
@MovID                                               varchar(20),
@FechaEmision                                 datetime   ,
@Concepto                          varchar(50),
@Proyecto                            varchar(50),
@Actividad                          varchar(100),
@UEN                                    int   ,
@Moneda                                            varchar(10),
@TipoCambio                                                    float   ,
@Usuario                              varchar(10),
@Referencia                        varchar(50),
@Estatus                               varchar(15),
@RenglonID                        int   ,
@Proveedor                         varchar(10),
@FormaEnvio                                                    varchar(50),
@FechaRequerida                                            datetime   ,
@Almacen                           varchar(10),
@Condicion                         varchar(50),
@Vencimiento                                   datetime   ,
@ActivoFijo                          bit   ,
@Agente                                              varchar(10),
@Importe                             money   ,
@Impuestos                         money   ,
@Saldo                                 money   ,
@OrigenTipo                                                      varchar(10),
@Origen                                               varchar(20),
@OrigenID                           varchar(20),
@FechaCancelacion                        datetime   ,
@Peso                                   float   ,
@Volumen                           float   ,
@FechaEntrega                                 datetime   ,
@EmbarqueEstado                                           varchar(50),
@Sucursal                             int   ,
@ZonaImpuesto                                varchar(30),
@VIN                                     varchar(20),
@SubModulo                                                     varchar(5),
@Cliente                               varchar(10),
@SucursalOrigen                                               int   ,
@SucursalDestino                              int ,
@ReferenciaIS                                    varchar(100),
@SubReferencia                                varchar(100)
BEGIN TRANSACTION
IF @Ok IS NULL
BEGIN
SELECT @IDO = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ID'
SELECT @MovID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovID'
SELECT @FechaEmision = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FechaEmision'
SELECT @Concepto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Concepto'
SELECT @Proyecto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Proyecto'
SELECT @Actividad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Actividad'
SELECT @UEN = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'UEN'
SELECT @Moneda = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Moneda'
SELECT @TipoCambio = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TipoCambio'
SELECT @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SELECT @Referencia = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Referencia'
SELECT @Estatus = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Estatus'
SELECT @RenglonID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RenglonID'
SELECT @Proveedor = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Proveedor'
SELECT @FormaEnvio = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FormaEnvio'
SELECT @FechaRequerida = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FechaRequerida'
SELECT @Almacen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Almacen'
SELECT @Condicion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Condicion'
SELECT @Vencimiento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Vencimiento'
SELECT @ActivoFijo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ActivoFijo'
SELECT @Agente = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Agente'
SELECT @Importe = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Importe'
SELECT @Impuestos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Impuestos'
SELECT @Saldo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Saldo'
SELECT @OrigenTipo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'OrigenTipo'
SELECT @Origen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Origen'
SELECT @OrigenID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'OrigenID'
SELECT @FechaCancelacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FechaCancelacion'
SELECT @Peso = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Peso'
SELECT @Volumen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Volumen'
SELECT @FechaEntrega = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FechaEntrega'
SELECT @EmbarqueEstado = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EmbarqueEstado'
SELECT @Sucursal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SELECT @ZonaImpuesto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ZonaImpuesto'
SELECT @VIN = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'VIN'
SELECT @SubModulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SubModulo'
SELECT @Cliente = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cliente'
SELECT @SucursalOrigen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SucursalOrigen'
SELECT @SucursalDestino = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SucursalDestino'
SELECT @Texto =(SELECT * FROM Compra Compra   WITH(NOLOCK) JOIN CompraD CompraD  WITH(NOLOCK) ON Compra.ID = CompraD.ID LEFT OUTER JOIN SerieLoteMov SerieLoteMov
 WITH(NOLOCK) ON SerieLoteMov.ID = CompraD.ID  AND SerieLoteMov.RenglonID = CompraD.RenglonID AND SerieLoteMov.Articulo = CompraD.Articulo AND ISNULL(SerieLoteMov.SubCuenta,'') = ISNULL(CompraD.SubCuenta,'') AND SerieLoteMov.Modulo = 'COMS' AND SerieLoteMov.Empresa = @Empresa
WHERE  ISNULL(Compra.ID,'') = ISNULL(ISNULL(@IDO,Compra.ID),'')
AND ISNULL(Compra.Empresa,'') = ISNULL(ISNULL(@Empresa,Compra.Empresa),'')
AND       ISNULL(Compra.Mov,'') = ISNULL(ISNULL(@Mov,Compra.Mov),'')
AND       ISNULL(Compra.MovID,'') = ISNULL(ISNULL(@MovID,Compra.MovID),'')
AND       ISNULL(Compra.FechaEmision,'') = ISNULL(ISNULL(@FechaEmision,Compra.FechaEmision),'')
AND       ISNULL(Compra.Concepto,'') = ISNULL(ISNULL(@Concepto,Compra.Concepto),'')
AND       ISNULL(Compra.Proyecto,'') = ISNULL(ISNULL(@Proyecto,Compra.Proyecto),'')
AND       ISNULL(Compra.Actividad,'') = ISNULL(ISNULL(@Actividad,Compra.Actividad),'')
AND       ISNULL(Compra.UEN,'') = ISNULL(ISNULL(@UEN,Compra.UEN),'')
AND       ISNULL(Compra.Moneda,'') = ISNULL(ISNULL(@Moneda,Compra.Moneda),'')
AND       ISNULL(Compra.TipoCambio,'') = ISNULL(ISNULL(@TipoCambio,Compra.TipoCambio),'')
AND       ISNULL(Compra.Usuario,'') = ISNULL(ISNULL(@Usuario,Compra.Usuario),'')
AND       ISNULL(Compra.Estatus,'') = ISNULL(ISNULL(@Estatus,Compra.Estatus),'')
AND       ISNULL(Compra.RenglonID,'') = ISNULL(ISNULL(@RenglonID,Compra.RenglonID),'')
AND       ISNULL(Compra.Proveedor,'') = ISNULL(ISNULL(@Proveedor,Compra.Proveedor),'')
AND       ISNULL(Compra.FormaEnvio,'') = ISNULL(ISNULL(@FormaEnvio,Compra.FormaEnvio),'')
AND       ISNULL(Compra.FechaRequerida,'') = ISNULL(ISNULL(@FechaRequerida,Compra.FechaRequerida),'')
AND       ISNULL(Compra.Almacen,'') = ISNULL(ISNULL(@Almacen,Compra.Almacen),'')
AND       ISNULL(Compra.Condicion,'') = ISNULL(ISNULL(@Condicion,Compra.Condicion),'')
AND       ISNULL(Compra.Vencimiento,'') = ISNULL(ISNULL(@Vencimiento,Compra.Vencimiento),'')
AND       ISNULL(Compra.Importe,'') = ISNULL(ISNULL(@Importe,Compra.Importe),'')
AND       ISNULL(Compra.Impuestos,'') = ISNULL(ISNULL(@Impuestos,Compra.Impuestos),'')
AND       ISNULL(Compra.Saldo,'') = ISNULL(ISNULL(@Saldo,Compra.Saldo),'')
AND       ISNULL(Compra.OrigenTipo,'') = ISNULL(ISNULL(@OrigenTipo,Compra.OrigenTipo),'')
AND       ISNULL(Compra.Origen,'') = ISNULL(ISNULL(@Origen,Compra.Origen),'')
AND       ISNULL(Compra.OrigenID,'') = ISNULL(ISNULL(@OrigenID,Compra.OrigenID),'')
AND       ISNULL(Compra.FechaCancelacion,'') = ISNULL(ISNULL(@FechaCancelacion,Compra.FechaCancelacion),'')
AND       ISNULL(Compra.Peso,'') = ISNULL(ISNULL(@Peso,Compra.Peso),'')
AND       ISNULL(Compra.FechaEntrega,'') = ISNULL(ISNULL(@FechaEntrega,Compra.FechaEntrega),'')
AND       ISNULL(Compra.EmbarqueEstado,'') = ISNULL(ISNULL(@EmbarqueEstado,Compra.EmbarqueEstado),'')
AND       ISNULL(Compra.Sucursal,'') = ISNULL(ISNULL(@Sucursal,Compra.Sucursal),'')
AND       ISNULL(Compra.ZonaImpuesto,'') = ISNULL(ISNULL(@ZonaImpuesto,Compra.ZonaImpuesto),'')
AND       ISNULL(Compra.VIN,'') = ISNULL(ISNULL(@VIN,Compra.VIN),'')
AND       ISNULL(Compra.SubModulo,'') = ISNULL(ISNULL(@SubModulo,Compra.SubModulo),'')
AND       ISNULL(Compra.Cliente,'') = ISNULL(ISNULL(@Cliente,Compra.Cliente),'')
AND       ISNULL(Compra.SucursalOrigen,'') = ISNULL(ISNULL(@SucursalOrigen,Compra.SucursalOrigen),'')
AND       ISNULL(Compra.SucursalDestino,'') = ISNULL(ISNULL(@SucursalDestino,Compra.SucursalDestino),'')
FOR XML AUTO)
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WITH(NOLOCK) WHERE ID = @ID
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),@Texto) + '</Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
END
END
END

