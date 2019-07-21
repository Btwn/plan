SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSISAfectarVenta
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok			int          = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Cliente     	        varchar(10),
@Datos		        varchar(max),
@Empresa                varchar(5),
@ReferenciaIS           varchar(50),
@SubReferenciaIS        varchar(50),
@Solicitud              varchar(max),
@IDVenta                int,
@CodigoRedondeo	        varchar(50),
@IDPOS                  varchar(50),
@ArticuloRedondeo	varchar(20),
@Usuario                varchar(10),
@Monedero               varchar(10),
@Sucursal               int,
@Estatus                varchar(15),
@Mov                    varchar(20),
@MovClave               varchar(20),
@Articulo               varchar(20),
@SubCuenta              varchar(50),
@Unidad                 varchar(50),
@Moneda                 varchar(10),
@TipoCambio             float,
@Renglon                float,
@Costo                  float,
@SugerirCostoDev        varchar(20),
@ContMoneda             varchar(10),
@ContMonedaTC           float,
@VentaPreciosImpuestoIncluido		bit
DECLARE @Venta table(
ID                    varchar(50),
Empresa               varchar(5) ,
Mov                   varchar(20),
MovID                 varchar(20),
FechaEmision          datetime,
Concepto              varchar(50),
Proyecto              varchar(50),
UEN                   int,
Moneda                varchar(10),
TipoCambio            float,
Usuario               varchar(10),
Referencia            varchar(50),
Observaciones         varchar(100),
Estatus               varchar(15),
Cliente               varchar(10),
EnviarA               int,
Almacen               varchar(10),
Agente                varchar(10),
AgenteServicio        varchar(10),
AgenteComision        float,
FormaEnvio            varchar(50),
Condicion             varchar(50),
Vencimiento           datetime   ,
CtaDinero             varchar(10),
Descuento             varchar(30),
DescuentoGlobal       float,
Importe               money,
Impuestos             money,
Saldo                 money,
DescuentoLineal       money,
OrigenTipo            varchar(10),
Origen                varchar(20),
OrigenID              varchar(20),
FechaRegistro         datetime   ,
Causa                 varchar(50),
Atencion              varchar(50),
AtencionTelefono      varchar(50),
ListaPreciosEsp       varchar(20),
ZonaImpuesto          varchar(30),
Sucursal              int,
SucursalOrigen        int,
POSDescuento          varchar(30),
ReferenciaOrdenCompra varchar(50),
Directo               bit,
PedidoReferencia      varchar(50),
PedidoReferenciaID    int
)
DECLARE @VentaD table(
ID                    varchar(50),
Renglon               float,
RenglonSub            int,
RenglonID             int,
RenglonTipo           char(1),
Cantidad              float,
Almacen               varchar(10),
EnviarA               int,
Articulo              varchar(20),
SubCuenta             varchar(50),
Precio                float,
DescuentoLinea        money,
Impuesto1             float,
Impuesto2             float,
Impuesto3             float,
Aplica                varchar(20),
AplicaID              varchar(20),
CantidadPendiente     float,
CantidadReservada     float,
CantidadCancelada     float,
CantidadOrdenada      float,
CantidadA             float,
Unidad                varchar(50),
Factor                float,
Puntos                money,
CantidadObsequio      float,
OfertaID              int,
Sucursal              int,
PrecioImpuestoInc     float,
AnticipoRetencion     float,
AnticipoFacturado     bit,
AplicaDescGlobal      bit,
Codigo                varchar(30)
)
DECLARE @SerieLote table(
IDL			varchar(50),
Orden			int,
ID			varchar(36),
RenglonID		int,
Articulo		varchar(20),
SubCuenta		varchar(50),
SerieLote		varchar(50))
DECLARE @VentaCobro table(
ID                    varchar(36),
Importe1              money,
Importe2              money,
Importe3              money,
Importe4              money,
Importe5              money,
FormaCobro1           varchar(50),
FormaCobro2           varchar(50),
FormaCobro3           varchar(50),
FormaCobro4           varchar(50),
FormaCobro5           varchar(50),
Referencia1           varchar(50),
Referencia2           varchar(50),
Referencia3           varchar(50),
Referencia4           varchar(50),
Referencia5           varchar(50),
Observaciones1        varchar(100),
Observaciones2        varchar(100),
Observaciones3        varchar(100),
Observaciones4        varchar(100),
Observaciones5        varchar(100),
Cambio                money,
Redondeo              money,
DelEfectivo           money,
Sucursal              int,
CtaDinero             varchar(10),
Cajero                varchar(10),
Condicion             varchar(50),
Vencimiento           datetime,
Actualizado           bit,
TotalCobrado          money,
SucursalOrigen        int,
POSTipoCambio1        float,
POSTipoCambio2        float,
POSTipoCambio3        float,
POSTipoCambio4        float,
POSTipoCambio5        float )
DECLARE @TarjetaSerieMov table(
Empresa             varchar(5),
Modulo              varchar(5),
ID                  int,
Serie               varchar(20),
Importe             money,
Sucursal            int,
TipoCambioTarjeta   float,
ImporteTarjeta      float)
DECLARE @Anticipos table(
ID                   int,
AnticipoAplicar      float
)
BEGIN TRANSACTION
SELECT @ReferenciaIS = Referencia , @SubReferenciaIS = SubReferencia, @Solicitud = Solicitud
FROM IntelisisService
WHERE ID = @ID
SELECT @Empresa = Empresa, @Usuario = Usuario, @Monedero = Monedero, @Sucursal = Sucursal, @IDPOS = ID, @Mov = Mov, @Moneda = Moneda, @TipoCambio = ISNULL(TipoCambio,1.0)
FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Venta')
WITH (Empresa varchar(5), Usuario varchar(10), Monedero varchar(20), Sucursal int, ID varchar(36), Mov varchar(20), Moneda varchar(10), TipoCambio float)
SELECT  @MovClave = Clave
FROM MovTipo WHERE Mov = @Mov AND Modulo = 'VTAS'
SELECT @CodigoRedondeo = pc.RedondeoVentaCodigo
FROM POSCfg pc
WHERE pc.Empresa = @Empresa
SELECT @VentaPreciosImpuestoIncluido = VentaPreciosImpuestoIncluido, @SugerirCostoDev = SugerirCostoDev, @ContMoneda = ContMoneda
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @ContMonedaTC = TipoCambio FROM POSLTipoCambioRef WHERE Sucursal = @Sucursal AND Moneda = @ContMoneda
SELECT @ArticuloRedondeo = Cuenta
FROM CB
WHERE Codigo = @CodigoRedondeo
AND TipoCuenta = 'Articulos'
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
INSERT @Venta(ID, Empresa, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Moneda, TipoCambio, Usuario, Referencia, Observaciones, Estatus,      Cliente, EnviarA, Almacen, Agente, AgenteServicio, AgenteComision, FormaEnvio, Condicion, Vencimiento, CtaDinero, Descuento, DescuentoGlobal, Importe, Impuestos, Saldo, DescuentoLineal, OrigenTipo, Origen, OrigenID, FechaRegistro, Causa, Atencion, AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, Sucursal, SucursalOrigen, POSDescuento,  ReferenciaOrdenCompra,    PedidoReferencia, PedidoReferenciaID)
SELECT        ID, Empresa, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Moneda, TipoCambio, Usuario, Referencia, Observaciones, 'SINAFECTAR', Cliente, EnviarA, Almacen, Agente, AgenteServicio, AgenteComision, FormaEnvio, Condicion, Vencimiento, CtaDinero, Descuento, DescuentoGlobal, Importe, Impuestos, Saldo, DescuentoLineal, OrigenTipo, Origen, OrigenID, FechaRegistro, Causa, Atencion, AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, Sucursal, SucursalOrigen, Descuento,     ID,                       PedidoReferencia, PedidoReferenciaID
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/Venta')
WITH (ID  varchar(36), Empresa  varchar(5), Mov  varchar(20), MovID  varchar(20), FechaEmision  datetime, Concepto  varchar(50), Proyecto  varchar(50), UEN  int, Moneda  varchar(10), TipoCambio  float, Usuario  varchar(10), Referencia  varchar(50), Observaciones  varchar(100), Estatus  varchar(15), Cliente  varchar(10), EnviarA  int, Almacen  varchar(10), Agente  varchar(10), AgenteServicio  varchar(10), AgenteComision  float, FormaEnvio  varchar(50), Condicion  varchar(50), Vencimiento  datetime, CtaDinero  varchar(10), Descuento  varchar(30), DescuentoGlobal  float, Importe  money, Impuestos  money, Saldo  money, DescuentoLineal  money, OrigenTipo  varchar(10), Origen  varchar(20), OrigenID  varchar(20), FechaRegistro  datetime, Causa  varchar(50), Atencion  varchar(50), AtencionTelefono  varchar(50), ListaPreciosEsp  varchar(20), ZonaImpuesto  varchar(30), Sucursal  int, SucursalOrigen  int, AnticipoFacturadoTipoServicio bit, PedidoReferencia  varchar(50), PedidoReferenciaID   int)
EXEC sp_xml_removedocument @iSolicitud
IF @@ERROR<>0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
INSERT @VentaD(ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Cantidad, Almacen, EnviarA, Articulo, SubCuenta, Precio, DescuentoLinea, Impuesto1, Impuesto2, Impuesto3, Aplica, AplicaID, CantidadPendiente, CantidadReservada, CantidadCancelada, CantidadOrdenada, CantidadA, Unidad, Factor, Puntos, CantidadObsequio, OfertaID, Sucursal, PrecioImpuestoInc, AnticipoRetencion, AnticipoFacturado, AplicaDescGlobal, Codigo)
SELECT         ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Cantidad, Almacen, EnviarA, Articulo, SubCuenta, Precio, DescuentoLinea, Impuesto1, Impuesto2, Impuesto3, Aplica, AplicaID, CantidadPendiente, CantidadReservada, CantidadCancelada, CantidadOrdenada, CantidadA, Unidad, Factor, Puntos, CantidadObsequio, OfertaID, Sucursal, PrecioImpuestoInc, AnticipoRetencion, AnticipoFacturado, AplicaDescGlobal, Codigo
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/Venta/VentaD')
WITH (ID varchar(36),Renglon  float, RenglonSub  int, RenglonID  int, RenglonTipo  char(1), Cantidad  float, Almacen  varchar(10), EnviarA  int, Articulo  varchar(20), SubCuenta  varchar(50), Precio  float, DescuentoLinea  float, Impuesto1  float, Impuesto2  float, Impuesto3  float, Aplica  varchar(20), AplicaID  varchar(20), CantidadPendiente  float, CantidadReservada  float, CantidadCancelada  float, CantidadOrdenada  float, CantidadA  float, Unidad  varchar(50), Factor  float, Puntos  money, CantidadObsequio  float, OfertaID  int, Sucursal  int, PrecioImpuestoInc float, AnticipoRetencion float,AnticipoFacturado bit, AplicaDescGlobal  bit, Codigo  varchar(30))
EXEC sp_xml_removedocument @iSolicitud
IF @@ERROR<>0 SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
INSERT @SerieLote(IDL, Orden, ID, RenglonID, Articulo, SubCuenta, SerieLote)
SELECT            IDL, Orden, ID, RenglonID, Articulo, SubCuenta, SerieLote
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/SerieLote')
WITH (IDL varchar(36), Orden  int, ID varchar(36), RenglonID  int,Articulo  varchar(20),SubCuenta  varchar(50),SerieLote varchar(50))
EXEC sp_xml_removedocument @iSolicitud
IF @@ERROR<>0 SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
INSERT @VentaCobro(ID, Importe1, Importe2, Importe3, Importe4, Importe5, FormaCobro1, FormaCobro2, FormaCobro3, FormaCobro4, FormaCobro5, Referencia1, Referencia2, Referencia3, Referencia4, Referencia5, Observaciones1, Observaciones2, Observaciones3, Observaciones4, Observaciones5, Cambio, Redondeo, DelEfectivo, Sucursal, CtaDinero, Cajero, Condicion, Vencimiento, Actualizado, TotalCobrado, SucursalOrigen, POSTipoCambio1, POSTipoCambio2, POSTipoCambio3, POSTipoCambio4, POSTipoCambio5)
SELECT             ID, Importe1, Importe2, Importe3, Importe4, Importe5, FormaCobro1, FormaCobro2, FormaCobro3, FormaCobro4, FormaCobro5, Referencia1, Referencia2, Referencia3, Referencia4, Referencia5, Observaciones1, Observaciones2, Observaciones3, Observaciones4, Observaciones5, Cambio, Redondeo, DelEfectivo, Sucursal, CtaDinero, Cajero, Condicion, Vencimiento, Actualizado, TotalCobrado, SucursalOrigen, POSTipoCambio1, POSTipoCambio2, POSTipoCambio3, POSTipoCambio4, POSTipoCambio5
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/VentaCobro')
WITH (ID  varchar(36), Importe1  money, Importe2  money, Importe3  money, Importe4  money, Importe5  money, FormaCobro1  varchar(50), FormaCobro2  varchar(50), FormaCobro3  varchar(50), FormaCobro4  varchar(50), FormaCobro5  varchar(50), Referencia1  varchar(50), Referencia2  varchar(50), Referencia3  varchar(50), Referencia4  varchar(50), Referencia5  varchar(50), Observaciones1  varchar(100), Observaciones2  varchar(100), Observaciones3  varchar(100), Observaciones4  varchar(100), Observaciones5  varchar(100), Cambio  money, Redondeo  money, DelEfectivo  money, Sucursal  int, CtaDinero  varchar(10), Cajero  varchar(10), Condicion  varchar(50), Vencimiento  datetime, Actualizado  bit, TotalCobrado  money, SucursalOrigen  int, POSTipoCambio1  float, POSTipoCambio2  float, POSTipoCambio3  float, POSTipoCambio4  float, POSTipoCambio5  float)
EXEC sp_xml_removedocument @iSolicitud
IF @@ERROR<>0 SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
INSERT @TarjetaSerieMov(Empresa,Modulo,ID,Serie,Importe,Sucursal,TipoCambioTarjeta,ImporteTarjeta)
SELECT            Empresa,Modulo,ID,Serie,Importe,Sucursal,TipoCambioTarjeta,ImporteTarjeta
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/TarjetaSerieMov')
WITH (Empresa varchar(5), Modulo varchar(5), ID int, Serie varchar(20),Importe money, Sucursal int, TipoCambioTarjeta   float, ImporteTarjeta      float)
EXEC sp_xml_removedocument @iSolicitud
IF @@ERROR<>0 SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
INSERT @Anticipos(ID,AnticipoAplicar)
SELECT            ID,AnticipoAplicar
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/POSCxcAnticipoTemp')
WITH ( ID int, AnticipoAplicar float)
EXEC sp_xml_removedocument @iSolicitud
IF @@ERROR<>0 SET @Ok = 1
END
IF NOT EXISTS(SELECT * FROM Venta WHERE ReferenciaOrdenCompra = @IDPOS AND Estatus = 'CONCLUIDO')
BEGIN
IF @Ok IS NULL
BEGIN
INSERT Venta (Empresa,  Mov,  MovID, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda, TipoCambio,                                                                           Usuario, Referencia, Estatus,      Observaciones, Cliente, EnviarA,    Almacen,  Agente,  FormaEnvio,  Condicion,  Vencimiento,  CtaDinero,    DescuentoGlobal, Causa,  Atencion,  AtencionTelefono,  ListaPreciosEsp,  ZonaImpuesto,  Sucursal,  OrigenTipo,  Origen,  OrigenID, ReferenciaOrdenCompra,GenerarDinero,SucursalOrigen, AnticipoFacturadoTipoServicio, POSDescuento,  Directo,                                                                                          PedidoReferencia, PedidoReferenciaID )
SELECT        Empresa,  Mov,  MovID, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda, CASE WHEN Moneda <> @ContMoneda THEN  (TipoCambio/@ContMonedaTC) ELSE TipoCambio END, Usuario, Referencia, 'SINAFECTAR', Observaciones, Cliente, EnviarA,    Almacen,  Agente,  FormaEnvio,  Condicion,  Vencimiento,  CtaDinero,    0.0            , Causa,  Atencion,  AtencionTelefono,  ListaPreciosEsp,  ZonaImpuesto,  Sucursal,  'POS',       Origen,  OrigenID, ID,                   1            ,Sucursal,       1,                             Descuento,  CASE WHEN (NULLIF(Origen,'') IS NOT NULL AND NULLIF(OrigenID,'') IS NOT NULL)  THEN 0 ELSE 1 END, PedidoReferencia, PedidoReferenciaID
FROM @Venta
SELECT @IDVenta = SCOPE_IDENTITY()
END
IF @Ok IS NULL AND @IDVenta IS NOT NULL
BEGIN
INSERT VentaD (ID,        Renglon,     RenglonID,     Aplica,       AplicaID,       RenglonTipo,     Cantidad,     CantidadObsequio,     Almacen,                                   EnviarA,     Articulo,     SubCuenta,      Precio,                                                                                                                                                                                                 Impuesto1,     Impuesto2,     Impuesto3,     Unidad,     Factor,     Sucursal,   Puntos,     AnticipoFacturado,     AnticipoRetencion,     AnticipoMoneda, AnticipoTipoCambio, DescuentoLinea,                                                                                                                              DescuentoImporte,                                                                                                                                                               POSDesGlobal,                                                                                POSDesLinea,                    Codigo )
SELECT        @IDVenta,   pmv.Renglon, pmv.RenglonID, pmv.Aplica,   pmv.AplicaID  , pmv.RenglonTipo, pmv.Cantidad, pmv.CantidadObsequio, ISNULL(NULLIF(pmv.Almacen,''),v.Almacen) , pmv.EnviarA, pmv.Articulo, pmv.SubCuenta,  CASE WHEN pmv.Articulo = @ArticuloRedondeo THEN pmv.Precio / (1-(ISNULL(v.DescuentoGlobal,0)/100)) ELSE CASE WHEN @VentaPreciosImpuestoIncluido = 1 THEN pmv.PrecioImpuestoInc ELSE pmv.Precio END END, pmv.Impuesto1, pmv.Impuesto2, pmv.Impuesto3, pmv.Unidad, 1,         v.Sucursal, pmv.Puntos, pmv.AnticipoFacturado, pmv.AnticipoRetencion, v.Moneda,       v.TipoCambio,        dbo.fnPOSCalcDescuentosVenta(CASE WHEN ISNULL(pmv.AplicaDescGlobal, 1) = 1 THEN ISNULL(v.DescuentoGlobal,0.0) ELSE 0 END,pmv.DescuentoLinea), (pmv.Cantidad*pmv.Precio)*(dbo.fnPOSCalcDescuentosVenta(CASE WHEN ISNULL(pmv.AplicaDescGlobal, 1) = 1 THEN ISNULL(v.DescuentoGlobal,0.0) ELSE 0 END,pmv.DescuentoLinea)/100.0), CASE WHEN ISNULL(pmv.AplicaDescGlobal, 1) = 1 THEN ISNULL(v.DescuentoGlobal,0.0) ELSE 0 END, ISNULL(pmv.DescuentoLinea,0.0), pmv.Codigo
FROM @VentaD   pmv
JOIN @Venta v ON v.ID = pmv.ID
END
IF EXISTS(SELECT * FROM POSValeSerie WHERE Serie = @Monedero)AND @IDVenta IS NOT NULL
INSERT TarjetaSerieMov(Empresa,  ID,       Modulo, Serie,     Sucursal)
SELECT                 @Empresa, @IDVenta, 'VTAS', @Monedero, @Sucursal
IF EXISTS(SELECT * FROM @SerieLote pls )AND @IDVenta IS NOT NULL
INSERT SerieLoteMov (Empresa,  Modulo, ID,       RenglonID,     Articulo,     SubCuenta,                 SerieLote,     Cantidad, Sucursal)
SELECT               @Empresa, 'VTAS', @IDVenta, pls.RenglonID, pls.Articulo, ISNULL(pls.SubCuenta, ''), pls.SerieLote, COUNT(*), @Sucursal
FROM @SerieLote pls
GROUP BY Articulo, ISNULL(SubCuenta,''), SerieLote, RenglonID
IF EXISTS(SELECT * FROM @VentaCobro)AND @IDVenta IS NOT NULL
INSERT VentaCobro(ID,       Importe1,  Importe2,  Importe3,  Importe4,  Importe5, FormaCobro1, FormaCobro2, FormaCobro3, FormaCobro4, FormaCobro5, Referencia1, Referencia2, Referencia3, Referencia4, Referencia5, CtaDinero, Cajero,POSTipoCambio1, POSTipoCambio2, POSTipoCambio3, POSTipoCambio4, POSTipoCambio5 )
SELECT            @IDVenta, Importe1,  Importe2,  Importe3,  Importe4,  Importe5, FormaCobro1, FormaCobro2, FormaCobro3, FormaCobro4, FormaCobro5, Referencia1, Referencia2, Referencia3, Referencia4, Referencia5, CtaDinero, Cajero,POSTipoCambio1, POSTipoCambio2, POSTipoCambio3, POSTipoCambio4, POSTipoCambio5
FROM @VentaCobro
IF EXISTS (SELECT * FROM @TarjetaSerieMov)AND @IDVenta IS NOT NULL
INSERT TarjetaSerieMov( Empresa, ID,       Importe, ImporteTarjeta, Modulo, Serie, Sucursal, TipoCambioTarjeta)
SELECT                  Empresa, @IDVenta, Importe, ImporteTarjeta, 'VTAS', Serie, Sucursal, TipoCambioTarjeta
FROM @TarjetaSerieMov
IF EXISTS(SELECT * FROM @Anticipos)AND @IDVenta IS NOT NULL
BEGIN
UPDATE Cxc SET AnticipoAplicaID = @IDVenta ,AnticipoAplicaModulo = 'VTAS',AnticipoAplicar =a.AnticipoAplicar
FROM @Anticipos a JOIN Cxc c ON a.ID = c.ID
END
IF @MovClave IN ('VTAS.D') AND @Ok IS NULL
BEGIN
DECLARE crDetalle CURSOR LOCAL FOR
SELECT Renglon, Articulo, SubCuenta, Unidad
FROM VentaD
WHERE ID = @IDVenta
OPEN crDetalle
FETCH NEXT FROM crDetalle INTO  @Renglon, @Articulo, @SubCuenta, @Unidad
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
SET @Costo = NULL
EXEC spVerCosto @Sucursal, @Empresa, NULL, @Articulo, @SubCuenta, @Unidad, @SugerirCostoDev , @Moneda, @TipoCambio, @Costo OUTPUT, 0
UPDATE VentaD SET Costo = @Costo  WHERE ID = @IDVenta AND Renglon = @Renglon AND Articulo = @Articulo
FETCH NEXT FROM crDetalle INTO @Renglon, @Articulo, @SubCuenta, @Unidad
END
CLOSE crDetalle
DEALLOCATE crDetalle
END
IF @Ok IS NULL AND @IDVenta IS NOT NULL AND @Usuario IS NOT NULL
EXEC spAfectar 'VTAS', @IDVenta, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
ELSE
SELECT @IDVenta = ID FROM Venta WHERE ReferenciaOrdenCompra = @IDPOS
SELECT @OkRef = REPLACE(ISNULL(@OkRef,''),'<BR>','@##@')
IF @Ok IS NULL
BEGIN
SELECT @Estatus = Estatus FROM Venta WHERE ID = @IDVenta
COMMIT TRANSACTION
END
ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT @IDVenta = NULL
END
SELECT @Datos = '<Relleno '+'A="'+REPLICATE('X',4000)+'" />'
SELECT @Resultado = '<Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34)
+ ' SubReferencia='+ CHAR(34) + ISNULL(@SubReferenciaIS,'') + CHAR(34)
+' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + (ISNULL(@OkRef,'')) + CHAR(34)+' IDModulo=' + CHAR(34) + ISNULL(CONVERT(varchar,@IDVenta),'') + CHAR(34) + ' EstatusModulo=' + CHAR(34) + ISNULL(@Estatus,'') + CHAR(34) + ' >'+ISNULL(@Datos,'')+'</Resultado></Intelisis>'
END

