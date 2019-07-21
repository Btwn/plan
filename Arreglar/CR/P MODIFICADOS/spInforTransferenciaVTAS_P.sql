SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInforTransferenciaVTAS_P
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
@ReferenciaIntelisisService            varchar(50),
@Empresa                                           varchar(5),
@Sucursal                                            int,
@PlantaSucEmpresa                        varchar(10)          ,
@Almacen                                           varchar(10),
@ArtSecundario                  varchar(20)         ,
@ArticuloP                      varchar(20)               ,
@Mov                                    varchar(20)         ,
@Serie                                   varchar(3)
DECLARE
@Tabla                                table
(
Serie                                                     varchar(3),
NumeroDePedido                             varchar(20),
ID                            int,
CodigoCliente                                    varchar(10),
FechaPedido                                    datetime,
FechaEntrega                                   datetime,
CodigoProveedor                                             varchar(10),
SuPedido                                             varchar(40),
Referencia                                           varchar(40),
FormaDePago                                    varchar(2),
TipoDeEfecto                                     int,
EntregarA                                            varchar(3),
ServirDesde                                       varchar(10),
Observaciones_1                                             varchar(40),
Moneda                               varchar(10),
EstadoPedido                                    varchar(40),
EnviarConfirmacion                         bit,
FechaDeAlta                                      datetime,
FechaUltimaModificacion                      datetime,
UsuarioAlta                                        varchar(10),
PedidoPorRepresentante                        bit,
Zona                                                     varchar(8),
Departamento                                  varchar(4),
PeriodoFacturacion                          int,
Estatus                                                  varchar(20),
ReferenciaIntelisisService      varchar(50),
Sucursal                                               int
)
DECLARE
@Tabla2                                              table
(     Serie                                                     varchar(3),
NumeroDePedido                             varchar(20),
NumeroOrdenLinea                          int,
CodigoArticulo                    varchar(20),
SubCuenta                       varchar(50),
Estado                                                 varchar(40),
FechaEntregaConfirmada                      datetime,
PrecioUnitario                                   varchar(40),
UnidMedidaAlmacen                     varchar(50),
PresentacionPedida                        varchar(50),
FactorConversionUnidades        varchar(40),
CantidadPedida                                              varchar(40),
AlmacenSalida                                  varchar(10),
FechaEntregaRequerida         datetime,
FechaConfirmado                                           datetime,
CantidadServida                                             float,
FechaUltimaModificacion         datetime,
UsuarioAltaD                                      varchar(10),
UsuarioModificacion                        varchar(10),
FechaEntregaInicial                        datetime,
FechaConfirmadaInicial          datetime,
SuReferencia                                     varchar(40),
ImporteLinea                                      varchar(40),
CantidadIntroducida                       float,
CosteEstandar                                  varchar(40),
CosteMedio                                       varchar(40),
CosteUltimo                                       varchar(40),
Familia                                                varchar(4),
Subfamilia                                         varchar(4),
FechaLlegadaRequerida         datetime,
FechaLlegadaConfirmada                     datetime,
CantidadCancelada               float,
CantidadReservada                  float ,
CantidadPendiente                         float )
DECLARE
@Tabla3                                              table
(     Serie                              varchar(3),
NumeroDePedido                             varchar(20),
NumeroOrdenLinea                          int,
CodigoArticulo                    varchar(20),
SubCuenta                                          varchar(50),
Estado                                                 varchar(40),
FechaEntregaConfirmada                      datetime,
PrecioUnitario                                    varchar(40),
UnidMedidaAlmacen                     varchar(50),
PresentacionPedida                        varchar(50),
FactorConversionUnidades        varchar(40),
CantidadPedida                                              varchar(40),
AlmacenSalida                                  varchar(10),
FechaEntregaRequerida         datetime,
FechaConfirmado                                           datetime,
CantidadServida                                             float,
FechaUltimaModificacion         datetime,
UsuarioAltaD                                      varchar(10),
UsuarioModificacion                        varchar(10),
FechaEntregaInicial                        datetime,
FechaConfirmadaInicial          datetime,
SuReferencia                                     varchar(40),
ImporteLinea                                      varchar(40),
CantidadIntroducida                       float,
CosteEstandar                                  varchar(40),
CosteMedio                                       varchar(40),
CosteUltimo                                       varchar(40),
Familia                                                varchar(4),
Subfamilia                                         varchar(4),
FechaLlegadaRequerida         datetime,
FechaLlegadaConfirmada                     datetime,
CantidadCancelada               float,
CantidadReservada                  float ,
CantidadPendiente                         float,
Planta                                                   varchar(20),
ArticuloSecundario              varchar(20)
)
BEGIN TRANSACTION
IF @Ok IS NULL
BEGIN
SELECT @IDO = ID FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Venta')
WITH (ID varchar(255))
SELECT @Almacen = Almacen ,@Mov =Mov FROM Venta with(nolock) WHERE ID = @IDO
SELECT @Serie = SerieMES FROM MovTipo WITH(NOLOCK) WHERE Mov = @Mov
SELECT @ReferenciaIS = Referencia ,@Usuario = Usuario , @SubReferencia = SubReferencia
FROM IntelisisService with(nolock)
WITH(NOLOCK) WHERE ID = @ID
SELECT @Contrasena = Contrasena
FROM Usuario
WITH(NOLOCK) WHERE Usuario = @Usuario
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/></Intelisis>'
SET @Datos='<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.VTAS.Mov.Listado" SubReferencia="'+@SubReferencia+'" Version="1.0"><Solicitud><Parametro Campo="ID" Valor="'+@IDO+'"/></Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario,@Contrasena,@Datos,@Resultado,@Ok Output,@OkRef Output,1,0,@IDNuevo Output
SELECT @Solicitud = Resultado
FROM IntelisisService
WITH(NOLOCK) WHERE ID = @IDNuevo
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
SELECT @Empresa = Empresa , @Sucursal = Sucursal
FROM OPENXML (@iSolicitud, '/Intelisis/Resultado/Venta',1)
WITH ( Empresa varchar(100), Sucursal varchar(100))
EXEC sp_xml_removedocument @iSolicitud
SELECT @ReferenciaIntelisisService = Referencia
FROM MapeoPlantaIntelisisMes
WITH(NOLOCK) WHERE Empresa = @Empresa AND Sucursal = @Sucursal
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
INSERT @Tabla (Serie,      ID,   NumeroDePedido, CodigoCliente, FechaPedido,  FechaEntrega, CodigoProveedor,      SuPedido,   Referencia, FormaDePago,     TipoDeEfecto,   EntregarA, ServirDesde, Observaciones_1, Moneda, EstadoPedido,   EnviarConfirmacion,   FechaDeAlta,   FechaUltimaModificacion, UsuarioAlta, PedidoPorRepresentante,   Zona,         Departamento, PeriodoFacturacion,       ReferenciaIntelisisService, Estatus,Sucursal)
SELECT         @Serie,ID,   MovID,             Cliente,       FechaEmision, FechaEntrega, CodigoProveedor=null, Referencia, Referencia, FormaDePago='1', TipoDeEfecto=1, EnviarA,   Almacen,     Mov+' '+MovID,   Moneda, EstadoPedido=1, EnviarConfirmacion=0, FechaRegistro, FechaRegistro,           Usuario,     PedidoPorRepresentante=0, ZonaImpuesto, Departamento, PeriodoFacturacion=0, @ReferenciaIntelisisService, Estatus ,@Sucursal
FROM OPENXML (@iSolicitud, '/Intelisis/Resultado/Venta',1)
WITH ( ID varchar(100),Mov varchar(100), MovID varchar(100), Cliente varchar(100),FechaEmision varchar(100),Referencia varchar(100),Almacen varchar(100),FechaEntrega varchar(100),Moneda varchar(100), EnviarA varchar(100), Observaciones varchar(100), FechaRegistro varchar(100), Usuario varchar(100), ZonaImpuesto varchar(100), Departamento varchar(100), RenglonID varchar(100), Articulo varchar(100), FechaRequerida varchar(100), PrecioLista varchar(100), Unidad varchar(100), Factor varchar(100), Cantidad varchar(100), Precio varchar(100),  UltimoCosto  varchar(100),   Costo  varchar(100), CostoUEPS varchar(100), Estatus varchar(100))
EXEC sp_xml_removedocument @iSolicitud
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
DECLARE @DivRenglon float
SET @DivRenglon = 2048
INSERT @Tabla2(Serie,  NumeroOrdenLinea, CodigoArticulo, SubCuenta, Estado,   FechaEntregaConfirmada, PrecioUnitario, UnidMedidaAlmacen, PresentacionPedida, FactorConversionUnidades, CantidadPedida, AlmacenSalida, FechaEntregaRequerida, FechaConfirmado,      CantidadServida,      FechaUltimaModificacion, UsuarioAltaD, UsuarioModificacion, FechaEntregaInicial, FechaConfirmadaInicial, SuReferencia,  ImporteLinea,                                  CantidadIntroducida, CosteEstandar, CosteMedio, CosteUltimo, Familia,      Subfamilia,      FechaLlegadaRequerida, FechaLlegadaConfirmada,CantidadCancelada,CantidadReservada,CantidadPendiente)
SELECT         @Serie, RenglonID,        Articulo,       SubCuenta, Estado=1, FechaRequerida,         PrecioLista,    Unidad,            Unidad,             Factor,                   Cantidad,       Almacen,       FechaRequerida,        FechaConfirmado=Null, CantidadServida=Null, FechaRegistro,            Usuario,      Usuario,             FechaRequerida,      FechaRequerida,         Referencia,   (CONVERT(float,ISNULL (Cantidad,1.00))* CONVERT(float,ISNULL( Precio,0.00))) , Cantidad,           CostoEstandar, Costo,      UltimoCosto, Familia=null, Subfamilia=null, FechaRequerida,        FechaRequerida       , CantidadCancelada,CantidadReservada,CantidadPendiente
FROM OPENXML (@iSolicitud, '/Intelisis/Resultado/VentaD',1)
WITH ( ID varchar(100),RenglonID int, Cliente varchar(100),SubCuenta varchar(100),FechaEmision varchar(100),Referencia varchar(100),Almacen varchar(100),FechaEntrega varchar(100),Moneda varchar(100), EnviarA varchar(100), Observaciones varchar(100), FechaRegistro varchar(100), Usuario varchar(100), ZonaImpuesto varchar(100), Departamento varchar(100), Renglon varchar(100), Articulo varchar(100), FechaRequerida varchar(100), PrecioLista varchar(100), Unidad varchar(100), Factor varchar(100), Cantidad float, Precio varchar(100),  UltimoCosto  varchar(100),   Costo  varchar(100), CostoEstandar varchar(100),CantidadCancelada float, CantidadReservada float,CantidadPendiente float)
EXEC sp_xml_removedocument @iSolicitud
UPDATE @Tabla2 SET CantidadPedida = (ISNULL(CantidadPedida,0.0) * dbo.fnArtUnidadFactor(@Empresa, CodigoArticulo, UnidMedidaAlmacen)) * (dbo.fnInforArtUnidadCompraFactor(@Empresa,CodigoArticulo)) ,
CantidadServida = (ISNULL(CantidadServida,0.0) * dbo.fnArtUnidadFactor(@Empresa, CodigoArticulo, UnidMedidaAlmacen)) * (dbo.fnInforArtUnidadCompraFactor(@Empresa,CodigoArticulo)) ,
CantidadIntroducida = (ISNULL(CantidadIntroducida,0.0) * dbo.fnArtUnidadFactor(@Empresa, CodigoArticulo, UnidMedidaAlmacen)) * (dbo.fnInforArtUnidadCompraFactor(@Empresa,CodigoArticulo)) ,
CantidadReservada = (ISNULL(CantidadReservada,0.0) * dbo.fnArtUnidadFactor(@Empresa, CodigoArticulo, UnidMedidaAlmacen)) * (dbo.fnInforArtUnidadCompraFactor(@Empresa,CodigoArticulo)) ,
CantidadPendiente = (ISNULL(CantidadPendiente,0.0) * dbo.fnArtUnidadFactor(@Empresa, CodigoArticulo, UnidMedidaAlmacen)) * (dbo.fnInforArtUnidadCompraFactor(@Empresa,CodigoArticulo)) ,
CantidadCancelada = (ISNULL(CantidadPedida,0.0) * dbo.fnArtUnidadFactor(@Empresa, CodigoArticulo, UnidMedidaAlmacen)) * (dbo.fnInforArtUnidadCompraFactor(@Empresa,CodigoArticulo)) ,
UnidMedidaAlmacen =  dbo.fnInforArtUnidadCompra(CodigoArticulo)
INSERT @Tabla3(Serie,        NumeroOrdenLinea, CodigoArticulo,SubCuenta, Estado,   FechaEntregaConfirmada, PrecioUnitario, UnidMedidaAlmacen, PresentacionPedida, FactorConversionUnidades, CantidadPedida, AlmacenSalida, FechaEntregaRequerida, FechaConfirmado,      CantidadServida,      FechaUltimaModificacion, UsuarioAltaD, UsuarioModificacion, FechaEntregaInicial, FechaConfirmadaInicial, SuReferencia,  ImporteLinea,                                  CantidadIntroducida, CosteEstandar, CosteMedio, CosteUltimo, Familia,      Subfamilia,      FechaLlegadaRequerida, FechaLlegadaConfirmada,CantidadCancelada,CantidadReservada,CantidadPendiente, Planta)
SELECT a.Serie,        a.NumeroOrdenLinea, a.CodigoArticulo,a.SubCuenta, a.Estado,   a.FechaEntregaConfirmada, a.PrecioUnitario, a.UnidMedidaAlmacen, a.PresentacionPedida, a.FactorConversionUnidades, a.CantidadPedida, a.AlmacenSalida, a.FechaEntregaRequerida, a.FechaConfirmado,      a.CantidadServida,      a.FechaUltimaModificacion, a.UsuarioAltaD, a.UsuarioModificacion, a.FechaEntregaInicial, a.FechaConfirmadaInicial, a.SuReferencia,  a.ImporteLinea,                                  a.CantidadIntroducida, ISNULL(a.CosteEstandar,0), ISNULL(a.CosteMedio,0), ISNULL(a.CosteUltimo,0), a.Familia,      a.Subfamilia,      a.FechaLlegadaRequerida, a.FechaLlegadaConfirmada,a.CantidadCancelada,a.CantidadReservada,a.CantidadPendiente,c.INFORClavePlanta
FROM @Tabla2 a
JOIN Art b  WITH(NOLOCK) ON a.CodigoArticulo = b.Articulo AND b.SeProduce = 1 AND ISNULL(b.EsFactory,0) = 1
JOIN Alm c  WITH(NOLOCK) ON c.Almacen= b.INFORAlmacenProd AND ISNULL(c.EsFactory,0) = 1
SELECT @ReferenciaIntelisisService = ReferenciaIntelisisService from @Tabla
SET @Resultado2 = CONVERT(varchar(max) ,(SELECT * FROM @Tabla oPedidoVentaCab FOR XML AUTO))
SET @Resultado3 = CONVERT(varchar(max) ,(SELECT * FROM @Tabla3 oPedidoVentaLinea FOR XML AUTO))
SELECT @Resultado4 = @Resultado2 + @Resultado3
IF EXISTS(SELECT CantidadPendiente FROM @Tabla2 WHERE CantidadPendiente > 0)
BEGIN
SET @Datos2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Infor" Contenido="Solicitud" Referencia=' + CHAR(34) + 'Infor.Movimiento.Procesar.VTAS_P' + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Solicitud IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')   + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)  + ' ReferenciaIntelisisService='+ CHAR(34)+ ISNULL(@ReferenciaIntelisisService,'')+CHAR(34)+ ' >' + @Resultado4 + '</Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario,@Contrasena,@Datos2,@Resultado4,@Ok Output,@OkRef Output,0,0,@IDNuevo Output
END
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

