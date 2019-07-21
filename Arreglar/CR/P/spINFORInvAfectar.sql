SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spINFORInvAfectar
@ID                                     int,
@Accion                                            char(20),
@Base                                               char(20),
@Empresa                                        char(5),
@Usuario                                          char(10),
@Modulo                                          char(5),
@Mov                                                char(20),
@MovID                                            varchar(20),
@MovTipo                        char(20),
@MovMoneda                                char(10),
@MovTipoCambio                        float,
@Estatus                                   char(15),
@EstatusNuevo                       char(15),
@FechaEmision                              datetime,
@FechaRegistro                              datetime,
@FechaAfectacion                         datetime,
@Conexion                                      bit,
@SincroFinal                                   bit,
@Sucursal                                         int,
@UtilizarID                                       int,
@UtilizarMovTipo                           char(20),
@Ok                                                   int                          OUTPUT,
@OkRef                                             varchar(255)       OUTPUT

AS BEGIN
DECLARE
@ProdInterfazINFOR         bit,
@AccesoID                                     int,
@Contrasena                 varchar(32),
@Resultado                                    varchar(max),
@Datos                                            varchar (max) ,
@MovIntelisisMES                varchar (10),
@MovIntelisisMES1              varchar (10),
@IDP                                int,
@IDV                                int,
@MovO                                           varchar (20),
@MovIDO                                       varchar(20),
@Aplica                                   varchar (20),
@AplicaID                                       varchar(20),
@ReferenciaIntelisisService varchar(50)
SELECT @ProdInterfazINFOR = ProdInterfazINFOR
FROM EmpresaGral WHERE Empresa = @Empresa
SELECT @Contrasena = Contrasena
FROM Usuario
WHERE Usuario = @Usuario
SELECT @MovO = Origen ,@MovIDO = OrigenID
FROM Compra
WHERE ID = @ID
SELECT @IDP =ID
FROM Compra
WHERE Mov = @MovO AND MovID = @MovIDO AND Empresa = @Empresa AND Sucursal = @Sucursal
SELECT @Aplica= Aplica ,@AplicaID = AplicaID
FROM VentaD
WHERE ID = @ID
SELECT @IDV =ID
FROM Venta
WHERE Mov = @Aplica AND MovID = @AplicaID AND Empresa = @Empresa AND Sucursal = @Sucursal
SELECT @MovIntelisisMES = MovIntelisisMES FROM Compra WHERE ID = @IDP
SELECT @MovIntelisisMES1 = MovIntelisisMES FROM Compra WHERE ID = @ID
IF @ProdInterfazINFOR = 1
BEGIN
SELECT @ReferenciaIntelisisService = Referencia
FROM MapeoPlantaIntelisisMes
WHERE Empresa = @Empresa AND Sucursal = @Sucursal
IF    EXISTS(SELECT * FROM MapeoMovimientosIntelisisInfor WHERE Movimiento = @Mov AND Modulo = @Modulo)
BEGIN
SET @Datos = NULL
IF @Modulo ='VTAS'
BEGIN
IF @MovTipo = 'VTAS.P'  AND @EstatusNuevo = 'PENDIENTE' AND @Accion IN('AFECTAR','RESERVARPARCIAL')
AND EXISTS(SELECT * FROM VentaD d JOIN Art a ON d.Articulo = a.Articulo JOIN Alm al ON a.INFORAlmacenProd = al.Almacen AND ISNULL(al.EsFactory,0) = 1 WHERE ISNULL(a.SeProduce,0) = 1 AND ISNULL(a.EsFactory,0) = 1 AND d.ID = @ID)
SELECT @Datos = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.Interfaz.Infor.Transferencia.VTAS_P" SubReferencia="'+CONVERT(varchar,@Mov)+'"'+' ReferenciaIntelisisService='+ CHAR(34)+ ISNULL(@ReferenciaIntelisisService,'')+CHAR(34)+' Version="1.0"><Solicitud> <Venta ID="'+CONVERT(varchar,@ID)+'"/>  </Solicitud> </Intelisis>'
IF @MovTipo = 'VTAS.P'  AND @EstatusNuevo IN('CANCELADO','PENDIENTE','CONCLUIDO') AND @Accion = 'CANCELAR'
SELECT @Datos = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.Interfaz.Infor.Transferencia.VTAS_P" SubReferencia="'+CONVERT(varchar,@Mov)+'"'+' ReferenciaIntelisisService='+ CHAR(34)+ ISNULL(@ReferenciaIntelisisService,'')+CHAR(34)+' Version="1.0"><Solicitud> <Venta ID="'+CONVERT(varchar,@ID)+'"/>  </Solicitud> </Intelisis>'
END
IF @Modulo ='COMS'
BEGIN
IF @MovTipo IN ('COMS.F') AND @EstatusNuevo IN('CANCELADO','PENDIENTE','CONCLUIDO')  AND @Accion = 'CANCELAR' 
SELECT @Datos = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.Interfaz.Infor.Transferencia.COMS_F" SubReferencia="'+CONVERT(varchar,@Mov)+'"'+' ReferenciaIntelisisService='+ CHAR(34)+ ISNULL(@ReferenciaIntelisisService,'')+CHAR(34)+' Version="1.0"><Solicitud> <Compra ID="'+CONVERT(varchar,@ID)+'"/>  </Solicitud> </Intelisis>'
IF @MovTipo IN ('COMS.O') AND @EstatusNuevo IN('CANCELADO','PENDIENTE','CONCLUIDO')  AND @Accion = 'CANCELAR' 
SELECT @Datos = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.Interfaz.Infor.Transferencia.COMS_OC" SubReferencia="'+CONVERT(varchar,@Mov)+'"'+' ReferenciaIntelisisService='+ CHAR(34)+ ISNULL(@ReferenciaIntelisisService,'')+CHAR(34)+' Version="1.0"><Solicitud> <Compra ID="'+CONVERT(varchar,@ID)+'"/>  </Solicitud> </Intelisis>'
IF @MovTipo IN ('COMS.O') AND @EstatusNuevo = 'PENDIENTE'  AND @Accion = 'AFECTAR'  
SELECT @Datos = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.Interfaz.Infor.Transferencia.COMS_O" SubReferencia="'+CONVERT(varchar,@Mov)+'"'+' ReferenciaIntelisisService='+ CHAR(34)+ ISNULL(@ReferenciaIntelisisService,'')+CHAR(34)+' Version="1.0"><Solicitud> <Compra ID="'+CONVERT(varchar,@ID)+'"/>  </Solicitud> </Intelisis>'
IF @MovTipo = 'COMS.F' AND @EstatusNuevo = 'CONCLUIDO'AND @Accion = 'AFECTAR' 
SELECT @Datos = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.Interfaz.Infor.Transferencia.COMS_F" SubReferencia="'+CONVERT(varchar,@Mov)+'"'+' ReferenciaIntelisisService='+ CHAR(34)+ ISNULL(@ReferenciaIntelisisService,'')+CHAR(34)+' Version="1.0"><Solicitud> <Compra ID="'+CONVERT(varchar,@ID)+'"/>  </Solicitud> </Intelisis>'
END
IF @Datos IS NOT NULL AND  @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spIntelisisService  @Usuario,@Contrasena,@Datos,@Resultado,@Ok Output,@OkRef Output,1,0,@Id Output
END
END
END

