SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInforTransferenciaCOMS_OC
@ID                        int,
@iSolicitud                           int,
@Version                              float,
@Resultado                         varchar(max) = NULL OUTPUT,
@Ok                                                      int = NULL OUTPUT,
@OkRef                                 varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@IDO                                     varchar(10),
@Datos                                                 varchar(max),
@Solicitud                                           varchar(max),
@ReferenciaIS                                    varchar(100),
@SubReferencia                                varchar(100),
@IDNuevo                                           int,
@Datos2                               varchar(max),
@Resultado2                                       varchar(max),
@Resultado3                                       varchar(max),
@Resultado4                                       varchar(max),
@Usuario                                             varchar(10),
@Contrasena                                      varchar(32),
@Almacen                        varchar(10),
@ArtSecundario                  varchar(20),
@Articulop                      varchar(20),
@Empresa                        varchar(5),
@ReferenciaIntelisisService            varchar(50),
@Sucursal                       int
DECLARE
@Tabla                                table
(
Serie                                                     varchar(3),
NumeroDePedido                             varchar(20),
CodigoProveedor                              varchar(10),
FechaPedido                                    datetime,
Aprovisionamiento                          int,
MargenSeguridad                                            int,
SuPedido                                           varchar(40),
Referencia                                         varchar(40),
FormaDePago                                   varchar(2),
TipoDeEfecto                                     int,
EntregarA                                           varchar(10),
RazonSocialProveedor                     varchar(40),
NombreProveedor                                          varchar(40),
Observaciones_1                                             varchar(40),
ValorarPedido                                   bit,
Moneda                                              varchar(10),
EstadoPedido                                   varchar(40),
EnviarConfirmacion                         bit,
EnviarAvisoExpedicion                    bit,
FechaDeAlta                                     datetime,
UsuarioAlta                                        varchar(10),
FechaSolicitudAProveedor             datetime,
FechaRecepcionSolicitada             datetime,
FechaRecepcionConfirmada         datetime,
ReferenciaIntelisisService      varchar(50),
Estatus                                                  varchar(20)
)
DECLARE
@Tabla2                                             table
(    Serie                                              varchar(3),
NumeroDePedido                                     varchar(20),
NumeroOrdenLinea                                         int,
CodigoArticulo                                   varchar(20),
SubCuenta                                          varchar(50),
CantidadPedida                                float,
Estado                                  varchar(40),
EntregarA                            varchar(10),
FechaRecepcionSolicitada                     datetime,
FechaRecepcionConfirmada                 datetime,
CantidadRecibida                                           float,
CantidadPendiente                                         float,
PrecioUnitario                                                   float,
PrecioUnitarioDivisa                                float,
PorcDescuento1                                               float,
PorcDescuento2                                               float,
UnidMedidaAlmacen                       varchar(50),
ImporteLinea                                                     float,
CosteEstandar                                                   float,
CosteMedio                         float,
CosteUltimo                         float,
FechaRecepcionFirme                                    datetime,
CantidadReclamada                                        float,
CantidadPendienteReclamar                float,
Cliente                                  varchar(10),
NumeroPedidoLinea                                        int,
CantDisponible                                                 float,
CantidadCancelada                                float,
ArticuloSecundario                      varchar(20)
)
BEGIN TRANSACTION
IF @Ok IS NULL
BEGIN
SELECT @IDO = ID, @Empresa = Empresa, @Sucursal = Sucursal FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Compra')
WITH (ID varchar(255), Empresa varchar(5), Sucursal int)
SELECT @Almacen = Almacen FROM Venta WITH(NOLOCK) WHERE ID = @IDO
SELECT @ReferenciaIS = Referencia ,@Usuario = Usuario , @SubReferencia = SubReferencia
FROM IntelisisService
WITH(NOLOCK) WHERE ID = @ID
SELECT @Contrasena = Contrasena
FROM Usuario
WITH(NOLOCK) WHERE Usuario = @Usuario
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/></Intelisis>'
SET @Datos='<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.COMS.Mov.Listado" SubReferencia="'+@SubReferencia+'" Version="1.0"><Solicitud><Parametro Campo="ID" Valor="'+@IDO+'"/></Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario,@Contrasena,@Datos,@Resultado,@Ok Output,@OkRef Output,1,0,@IDNuevo Output
SELECT @Solicitud = Resultado
FROM IntelisisService
WITH(NOLOCK) WHERE ID = @IDNuevo
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
INSERT @Tabla (Serie,  NumeroDePedido,  CodigoProveedor, FechaPedido,   Aprovisionamiento,   MargenSeguridad, SuPedido,  Referencia,  FormaDePago,  TipoDeEfecto,   EntregarA, RazonSocialProveedor,      NombreProveedor,      Observaciones_1,  ValorarPedido,       Moneda,    EnviarConfirmacion,   EnviarAvisoExpedicion,   FechaDeAlta,    UsuarioAlta,  FechaSolicitudAProveedor,  FechaRecepcionSolicitada, FechaRecepcionConfirmada,  Estatus)
SELECT         'IP1',  MovID,           Proveedor,       FechaRegistro, 0,                   0,               OrigenID,  Referencia,  '1',          1,              Almacen,   RazonSocialProveedor=NULL, NombreProveedor=NULL, Observaciones,    ValorarPedido = 1,   Moneda,    EnviarConfirmacion=0, EnviarAvisoExpedicion=0, FechaRegistro,  Usuario,      FechaEmision,              FechaRequerida,           FechaEntrega,                       Estatus
FROM OPENXML (@iSolicitud, '/Intelisis/Resultado/Compra',1)
WITH ( Cliente varchar(100), Proveedor varchar(100),OrigenID varchar(100),Referencia varchar(100),Almacen varchar(100),Observaciones varchar(100),Moneda varchar(100), FechaRegistro varchar(100), Usuario varchar(100), FechaEmision varchar(100), MovID varchar(100), RenglonID varchar(100), Articulo varchar(100), Estatus varchar(100), FechaConclusion varchar(100), Cantidad varchar(100), CantidadPendiente varchar(100), PrecioLista varchar(100), DescuentoLinea varchar(100), DescuentoImporte varchar(100), Costo varchar(100), CostoInv varchar(100), CostoUEPS varchar(100), FechaRequerida varchar(100), CantidadPendienteCliente varchar(100),FechaEntrega varchar(100))
EXEC sp_xml_removedocument @iSolicitud
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
INSERT @Tabla2(Serie, NumeroDePedido,  NumeroOrdenLinea,    CodigoArticulo,SubCuenta, CantidadPedida, EntregarA ,              FechaRecepcionSolicitada,   CantidadRecibida,   PrecioUnitario,     PorcDescuento1,  PorcDescuento2,  UnidMedidaAlmacen, ImporteLinea,  CosteEstandar,  CosteMedio,  CosteUltimo,  FechaRecepcionFirme,  CantidadReclamada,                           CantidadPendienteReclamar,         Cliente, NumeroPedidoLinea,  CantDisponible,CantidadCancelada)
SELECT         'IP1',  MovID,            RenglonID,           Articulo, SubCuenta,     Cantidad,      Almacen,  FechaRequerida,                  0.0,            PrecioLista,    DescuentoLinea,  DescuentoImporte, Unidad,           Costo,         Costo,          CostoInv,    CostoUEPS,    FechaRequerida,          ( ISNULL(Cantidad,0.00) + ISNULL(CantidadPendiente,0.00)) , ISNULL(CantidadPendiente,0.00),    Cliente, RenglonID,          Cantidad  ,   CantidadCancelada
FROM OPENXML (@iSolicitud, '/Intelisis/Resultado/Compra/CompraD',1)
WITH ( Cliente varchar(100), Almacen varchar(100), SubCuenta varchar(100), Moneda varchar(100), Unidad varchar(100), MovID varchar(100), RenglonID varchar(100), Articulo varchar(100), FechaConclusion varchar(100), Cantidad float, CantidadPendiente float, PrecioLista varchar(100), DescuentoLinea varchar(100), DescuentoImporte varchar(100), Costo varchar(100), CostoInv varchar(100), CostoUEPS varchar(100), FechaRequerida varchar(100),CantidadCancelada varchar(100))
EXEC sp_xml_removedocument @iSolicitud
UPDATE @Tabla2 SET CantidadPedida = (ISNULL(CantidadPedida,0.0) * dbo.fnArtUnidadFactor(@Empresa, CodigoArticulo, UnidMedidaAlmacen)) * (dbo.fnInforArtUnidadCompraFactor(@Empresa,CodigoArticulo)) ,
CantidadReclamada = (ISNULL(CantidadReclamada,0.0) * dbo.fnArtUnidadFactor(@Empresa, CodigoArticulo, UnidMedidaAlmacen)) * (dbo.fnInforArtUnidadCompraFactor(@Empresa,CodigoArticulo)) ,
CantidadPendienteReclamar = (ISNULL(CantidadPendienteReclamar,0.0) * dbo.fnArtUnidadFactor(@Empresa, CodigoArticulo, UnidMedidaAlmacen)) * (dbo.fnInforArtUnidadCompraFactor(@Empresa,CodigoArticulo)) ,
CantDisponible = (ISNULL(CantDisponible,0.0) * dbo.fnArtUnidadFactor(@Empresa, CodigoArticulo, UnidMedidaAlmacen)) * (dbo.fnInforArtUnidadCompraFactor(@Empresa,CodigoArticulo)) ,
CantidadCancelada = (ISNULL(CantidadCancelada,0.0) * dbo.fnArtUnidadFactor(@Empresa, CodigoArticulo, UnidMedidaAlmacen)) * (dbo.fnInforArtUnidadCompraFactor(@Empresa,CodigoArticulo)) ,
UnidMedidaAlmacen =  dbo.fnInforArtUnidadCompra(CodigoArticulo)
SET @Resultado2 = CONVERT(varchar(max) ,(SELECT * FROM @Tabla oCompraCab FOR XML AUTO))
SET @Resultado3 = CONVERT(varchar(max) ,(SELECT * FROM @Tabla2 oCompraLinea FOR XML AUTO))
SELECT @Resultado4 = @Resultado2 + @Resultado3
SELECT @ReferenciaIntelisisService = Referencia
FROM MapeoPlantaIntelisisMes
WITH(NOLOCK) WHERE Empresa = @Empresa AND Sucursal = @Sucursal
SET @Datos2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Infor" Contenido="Solicitud" Referencia=' + CHAR(34) + 'Infor.Movimiento.Procesar.COMS_OC' + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Solicitud IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')   + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)  + ' ModuloID='+ CHAR(34)  +@IDO+ CHAR(34)+ ' ReferenciaIntelisisService='+ CHAR(34)+ ISNULL(@ReferenciaIntelisisService,'')+CHAR(34)+' >' + @Resultado4 +'</Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario,@Contrasena,@Datos2,@Resultado4,@Ok Output,@OkRef Output,0,0,@IDNuevo Output
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

