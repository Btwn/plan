SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInforSaldoU
@Sucursal                                            int,
@Accion                               char(20),
@Empresa                                           char(5),
@Usuario                                             char(10),
@Rama                                                 char(5),
@Moneda                            char(10),
@Cuenta                              char(20),
@SubCuenta                                      varchar(50),
@Grupo                                                char(10),
@Modulo                              char(5),
@ID                        int,
@Mov                                                   char(20),
@MovID                                varchar(20),
@Cargo                                                money,
@Abono                               money,
@CargoU                              float,
@AbonoU                            float,
@Fecha                                                datetime,
@EjercicioAfectacion            int,
@PeriodoAfectacion              int,
@AcumulaSinDetalles              bit,
@AcumulaEnLinea                            bit,
@GeneraAuxiliar                                bit,
@GeneraSaldo                           bit,
@Conciliar                                   bit,
@Aplica                                                char(20),
@AplicaID                                            varchar(20),
@EsTransferencia                bit,
@EsResultados                            bit,
@EsTipoSerie                                      bit,
@InvNegativoU                                 float,
@ConsignacionU                                      float,
@IDGenerar                      int,
@Ok                                                      int                           OUTPUT,
@OkRef                                                varchar(255)       OUTPUT,
@Renglon                                           float                       = NULL,
@RenglonSub                                    int                          = NULL,
@RenglonID                                       int                          = NULL,
@SubGrupo                                varchar(20)          = NULL

AS BEGIN
DECLARE
@ProdInterfazINFOR                         bit,
@Cantidadslm                                   float,
@Cantidad                                          float,
@Datos                                                 varchar(max),
@Resultado                                         varchar(max),
@ReferenciaIS                                    varchar(100),
@SubReferencia                                varchar(100),
@IDNuevo                                           int           ,
@Contrasena                                      varchar(32),
@ReferenciaIntelisisService     varchar(50),
@PlantaSucEmpresa                 varchar(10),
@TipoMovimiento                 varchar(20),
@Almacen                                          varchar(10),
@MovMES                           bit,
@IDO                                                    int,
@MovO                         char(20),
@MovIDO                                    varchar(20),
@ArtSecundario                  varchar(20),
@Articulop                      varchar(20),
@Rama2                          varchar(20),
@SubClave                       varchar(20)
DECLARE @Tabla   table(
Codigo                                 varchar(20),
SubCuenta               varchar(50),
CodigoID                             int,
CodigoArticulo            varchar(20),
FechaMovimiento                            datetime,
EntradaSalida                    varchar(1),
Cantidad                             float,
TipoMovimiento                                varchar(20),
NuevoStock                         float,
CodigoAlmacen                 varchar(10),
PrecioVenta                        float,
PrecioCoste                         float,
Importe                                float,
NumPedido                         int,
ClienteDestino                   varchar(10),
ProveedorDestino             varchar(10),
AlmacenDestino                                varchar(10),
NumeroLote                        varchar(50),
Lanzamiento                      int,
Fase                                      int,
NumeroTrabajo                  int,
FechaEntregaPrevista      datetime,
Observaciones1                 varchar(40),
FechaDeAlta                       datetime,
FechaUltimaModificacion              datetime,
UsuarioAlta                          varchar(10),
Ubicaci�n                            varchar(8),
NuevoStockAlmacen        float,
NuevoStockLote                 float,
SeriePedido                        varchar(3),
SerieDocumento                               varchar(3),
NumLineaDocumento      int,
TipoCambio                        float,
Divisa                                    varchar(10),
Serie                                      varchar(3),
Numero                                int,
Linea                                     int,
FechaMovimientoHora    datetime,
ReferenciaIntelisisService      varchar(50),
NumDocumento            varchar(20) ,
ArticuloSecundario      varchar(20),
StockAntes              float
)
SELECT @SubClave = SubClave FROM MovTipo WITH(NOLOCK) WHERE Mov = @Mov AND Modulo = @Modulo
SELECT @ProdInterfazINFOR = ProdInterfazINFOR
FROM EmpresaGral WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @Contrasena = Contrasena
FROM Usuario
WITH(NOLOCK) WHERE Usuario = @Usuario
SELECT @Rama2 = Rama FROM AuxiliarU WITH(NOLOCK)  WHERE ID = @IDGenerar
SELECT @MovO = Origen , @MovIDO = OrigenID FROM Inv WITH(NOLOCK)  WHERE ID = @ID
SELECT @IDO = ID FROM Inv WITH(NOLOCK) WHERE Mov = @MovO AND MovID = @MovIDO AND Empresa = @Empresa AND Sucursal = @Sucursal
SELECT @TipoMovimiento =       ReferenciaIntelisisMes
FROM MapeoMovimientosIntelisisInfor
WITH(NOLOCK) WHERE Movimiento = @Mov AND Modulo = @Modulo
IF @ProdInterfazINFOR = 1   AND @Accion IN ('AFECTAR','CANCELAR','RESERVARPARCIAL') AND @IDGenerar IS NOT NULL
BEGIN
IF @Modulo = 'COMS'
BEGIN
SELECT @Cantidadslm = SUM(slm.Cantidad)
FROM SerieLoteMov slm  WITH(NOLOCK) JOIN CompraD md
 WITH(NOLOCK) ON slm.ID = md.ID AND slm.Modulo = @Modulo AND slm.RenglonID = md.RenglonID AND slm.Articulo = md.Articulo AND ISNULL(slm.SubCuenta,'') = ISNULL(md.SubCuenta,'') AND slm.Empresa = @Empresa
JOIN AuxiliarU a  WITH(NOLOCK) ON a.Modulo = @Modulo AND a.ModuloID = md.ID AND a.Renglon = md.Renglon AND a.RenglonSub = md.RenglonSub
JOIN Alm al  WITH(NOLOCK) ON a.Grupo = al.Almacen
JOIN Art ar  WITH(NOLOCK) ON slm.Articulo = ar.Articulo
WHERE a.ID = @IDGenerar
AND ISNULL(al.EsFactory,0) = 1
AND ISNULL(ar.EsFactory,0) = 1
SELECT @Cantidad = ISNULL(a.CargoU,a.AbonoU)
FROM AuxiliarU a  WITH(NOLOCK) JOIN Alm al  WITH(NOLOCK) ON a.Grupo = al.Almacen
JOIN Art ar  WITH(NOLOCK) ON a.Cuenta = ar.Articulo
WHERE a.ID = @IDGenerar
AND ISNULL(al.EsFactory,0) = 1
AND ISNULL(ar.EsFactory,0) = 1
SELECT @Almacen = Almacen FROM Compra WITH(NOLOCK) WHERE ID = @ID
SELECT @ReferenciaIntelisisService = Referencia
FROM MapeoPlantaIntelisisMes
WITH(NOLOCK) WHERE Empresa = @Empresa AND Sucursal = @Sucursal
INSERT @Tabla (Codigo, CodigoID, CodigoArticulo, FechaMovimiento, EntradaSalida,                                     Cantidad,                                     TipoMovimiento,    NuevoStock,   CodigoAlmacen, PrecioVenta,    PrecioCoste, Importe,                                      NumPedido, ClienteDestino, ProveedorDestino, AlmacenDestino, NumeroLote,                    Lanzamiento, Fase, NumeroTrabajo, FechaEntregaPrevista, Observaciones1, FechaDeAlta,     FechaUltimaModificacion, UsuarioAlta, Ubicaci�n, NuevoStockAlmacen, NuevoStockLote, SeriePedido, SerieDocumento,     NumLineaDocumento, TipoCambio, Divisa,   Serie, Numero, Linea,        FechaMovimientoHora, SubCuenta,               ReferenciaIntelisisService,  NumDocumento )
SELECT  @Cuenta, NULL,    @Cuenta,        @Fecha,          CASE  WHEN a.CargoU IS NULL AND a.AbonoU >0.0 THEN 'S' WHEN a.CargoU IS NULL AND a.AbonoU <0.0 THEN 'E' WHEN a.AbonoU IS NULL AND a.CargoU >0.0  THEN 'E' WHEN a.AbonoU IS NULL AND a.CargoU <0.0 THEN 'S' END, ISNULL(slm.Cantidad,ISNULL(CASE WHEN a.CargoU >0.0 THEN a.CargoU WHEN a.CargoU <0.0 THEN a.CargoU*-1 END ,CASE WHEN a.AbonoU >0.0 THEN a.AbonoU WHEN a.AbonoU <0.0 THEN a.AbonoU*-1 END)), @TipoMovimiento, e.Existencia, a.Grupo,    ar.PrecioLista, md.Costo,   (ISNULL(a.CargoU,a.AbonoU)* ar.PrecioLista)  , 0,       null,     null,      a.Grupo,     ISNULL(slm.SerieLote,''),                    0,          0, 0,            md.FechaRequerida,   m.Mov+' '+m.MovID,           m.FechaRegistro, NULL,                    m.Usuario,   NULL,      0,               0,            'IP',         'IP',           md.RenglonID,      NULL,       m.Moneda, 'IP',  NULL,   md.RenglonID,  m.FechaRegistro,    ISNULL(md.SubCuenta,''),@ReferenciaIntelisisService, @MovID
FROM AuxiliarU a
 WITH(NOLOCK) JOIN CompraD md  WITH(NOLOCK) ON a.Modulo = @Modulo AND a.ModuloID = md.ID AND a.Renglon = md.Renglon AND a.RenglonSub = md.RenglonSub
JOIN Compra m   WITH(NOLOCK) ON md.ID = m.ID LEFT OUTER
JOIN SerieLoteMov slm   WITH(NOLOCK) ON slm.ID = md.ID AND slm.Modulo = @Modulo AND slm.RenglonID = md.RenglonID AND slm.Articulo = md.Articulo AND ISNULL(slm.SubCuenta,'') = ISNULL(md.SubCuenta,'') AND slm.Empresa = m.Empresa
JOIN Art ar   WITH(NOLOCK) ON md.Articulo = ar.Articulo  AND md.Articulo = @Cuenta AND  ar.Articulo = @Cuenta
JOIN ArtExistenciaNeta e   WITH(NOLOCK) ON a.Empresa = e.Empresa AND a.Cuenta = e.Articulo AND a.Moneda = e.Moneda AND a.Grupo = e.Almacen
JOIN Alm al  WITH(NOLOCK) ON a.Grupo = al.Almacen
WHERE a.ID = @IDGenerar
AND ISNULL(al.EsFactory,0) = 1
AND ISNULL(ar.EsFactory,0) = 1
END
IF @Modulo = 'VTAS'
BEGIN
SELECT @Cantidadslm = SUM(slm.Cantidad)
FROM SerieLoteMov slm
 WITH(NOLOCK) JOIN VentaD md   WITH(NOLOCK) ON slm.ID = md.ID AND slm.Modulo = @Modulo AND slm.RenglonID = md.RenglonID AND slm.Articulo = md.Articulo AND ISNULL(slm.SubCuenta,'') = ISNULL(md.SubCuenta,'') AND slm.Empresa = @Empresa
JOIN AuxiliarU a  WITH(NOLOCK) ON a.Modulo = @Modulo AND a.ModuloID = md.ID AND a.Renglon = md.Renglon AND a.RenglonSub = md.RenglonSub
JOIN Alm al  WITH(NOLOCK) ON a.Grupo = al.Almacen
JOIN Art ar  WITH(NOLOCK) ON slm.Articulo = ar.Articulo
WHERE a.ID = @IDGenerar
AND ISNULL(al.EsFactory,0) = 1
AND ISNULL(ar.EsFactory,0) = 1
SELECT @Cantidad = ISNULL(a.CargoU,a.AbonoU)
FROM AuxiliarU a  WITH(NOLOCK) JOIN Alm al  WITH(NOLOCK) ON a.Grupo = al.Almacen
JOIN Art ar  WITH(NOLOCK) ON a.Cuenta = ar.Articulo
WHERE a.ID = @IDGenerar
AND ISNULL(al.EsFactory,0) = 1
AND ISNULL(ar.EsFactory,0) = 1
SELECT @Almacen = Almacen FROM Venta WITH(NOLOCK) WHERE ID = @ID
SELECT @ReferenciaIntelisisService = Referencia
FROM MapeoPlantaIntelisisMes
WITH(NOLOCK) WHERE Empresa = @Empresa AND Sucursal = @Sucursal
INSERT @Tabla (Codigo, CodigoID, CodigoArticulo, FechaMovimiento, EntradaSalida,                                     Cantidad,                                     TipoMovimiento,   NuevoStock,   CodigoAlmacen, PrecioVenta,    PrecioCoste, Importe,                                      NumPedido, ClienteDestino, ProveedorDestino, AlmacenDestino, NumeroLote,                    Lanzamiento, Fase, NumeroTrabajo, FechaEntregaPrevista, Observaciones1, FechaDeAlta,     FechaUltimaModificacion, UsuarioAlta, Ubicaci�n, NuevoStockAlmacen, NuevoStockLote, SeriePedido, SerieDocumento,     NumLineaDocumento, TipoCambio, Divisa,   Serie, Numero, Linea,        FechaMovimientoHora, SubCuenta,               ReferenciaIntelisisService, NumDocumento )
SELECT  @Cuenta, NULL,    @Cuenta,        @Fecha,          CASE  WHEN a.CargoU IS NULL AND a.AbonoU >0.0 THEN 'S' WHEN a.CargoU IS NULL AND a.AbonoU <0.0 THEN 'E' WHEN a.AbonoU IS NULL AND a.CargoU >0.0  THEN 'E' WHEN a.AbonoU IS NULL AND a.CargoU <0.0 THEN 'S' END, ISNULL(slm.Cantidad,ISNULL(CASE WHEN a.CargoU >0.0 THEN a.CargoU WHEN a.CargoU <0.0 THEN a.CargoU*-1 END ,CASE WHEN a.AbonoU >0.0 THEN a.AbonoU WHEN a.AbonoU <0.0 THEN a.AbonoU*-1 END)), @TipoMovimiento, e.Existencia, a.Grupo,    ar.PrecioLista, md.Costo,   (ISNULL(a.CargoU,a.AbonoU)* ar.PrecioLista)  , 0,       null,     null,      a.Grupo,     ISNULL(slm.SerieLote,''),                    0,          0, 0,            md.FechaRequerida,   m.Mov+' '+m.MovID,           m.FechaRegistro, NULL,                    m.Usuario,   NULL,      0,               0,            'IP',         'IP',           md.RenglonID,      NULL,       m.Moneda, 'IP',  NULL,   md.RenglonID,  m.FechaRegistro,    ISNULL(md.SubCuenta,''),@ReferenciaIntelisisService, @MovID
FROM AuxiliarU a
 WITH(NOLOCK) JOIN VentaD md  WITH(NOLOCK) ON a.Modulo = @Modulo AND a.ModuloID = md.ID AND a.Renglon = md.Renglon AND a.RenglonSub = md.RenglonSub
JOIN Venta m  WITH(NOLOCK) ON md.ID = m.ID
LEFT JOIN SerieLoteMov slm  WITH(NOLOCK) ON slm.ID = md.ID AND slm.Modulo = @Modulo AND slm.RenglonID = md.RenglonID AND slm.Articulo = md.Articulo AND ISNULL(slm.SubCuenta,'') = ISNULL(md.SubCuenta,'') AND slm.Empresa = m.Empresa
JOIN Art ar  WITH(NOLOCK) ON md.Articulo = ar.Articulo AND md.Articulo = @Cuenta
JOIN ArtExistenciaNeta e  WITH(NOLOCK) ON a.Empresa = e.Empresa AND a.Cuenta = e.Articulo AND a.Moneda = e.Moneda AND a.Grupo = e.Almacen
JOIN Alm al  WITH(NOLOCK) ON a.Grupo = al.Almacen
WHERE a.ID = @IDGenerar
AND ISNULL(al.EsFactory,0) = 1
AND ISNULL(ar.EsFactory,0) = 1
END
IF @Modulo = 'PROD'
BEGIN
SELECT @Cantidadslm = SUM(slm.Cantidad)
FROM SerieLoteMov slm
 WITH(NOLOCK) JOIN ProdD md  WITH(NOLOCK) ON slm.ID = md.ID AND slm.Modulo = @Modulo AND slm.RenglonID = md.RenglonID AND slm.Articulo = md.Articulo AND ISNULL(slm.SubCuenta,'') = ISNULL(md.SubCuenta,'') AND slm.Empresa = @Empresa
JOIN AuxiliarU a  WITH(NOLOCK) ON a.Modulo = @Modulo AND a.ModuloID = md.ID AND a.Renglon = md.Renglon AND a.RenglonSub = md.RenglonSub
JOIN Alm al  WITH(NOLOCK) ON a.Grupo = al.Almacen
WHERE a.ID = @IDGenerar
AND ISNULL(al.EsFactory,0) = 1
SELECT @Cantidad = ISNULL(a.CargoU,a.AbonoU)
FROM AuxiliarU a  WITH(NOLOCK) JOIN Alm al  WITH(NOLOCK) ON a.Grupo = al.Almacen
WHERE a.ID = @IDGenerar
AND ISNULL(al.EsFactory,0) = 1
SELECT @Almacen = Almacen FROM Prod WITH(NOLOCK) WHERE ID = @ID
SELECT @ReferenciaIntelisisService = Referencia
FROM MapeoPlantaIntelisisMes
WITH(NOLOCK) WHERE Empresa = @Empresa AND Sucursal = @Sucursal
INSERT @Tabla (Codigo, CodigoID, CodigoArticulo, FechaMovimiento, EntradaSalida,                                     Cantidad,                                       TipoMovimiento, NuevoStock,   CodigoAlmacen, PrecioVenta,    PrecioCoste, Importe,                                      NumPedido, ClienteDestino, ProveedorDestino, AlmacenDestino, NumeroLote,                    Lanzamiento, Fase, NumeroTrabajo, FechaEntregaPrevista, Observaciones1, FechaDeAlta,     FechaUltimaModificacion, UsuarioAlta, Ubicaci�n, NuevoStockAlmacen, NuevoStockLote, SeriePedido, SerieDocumento,     NumLineaDocumento, TipoCambio, Divisa,   Serie, Numero, Linea,        FechaMovimientoHora, SubCuenta,               ReferenciaIntelisisService, NumDocumento )
SELECT  @Cuenta, NULL,    @Cuenta,        @Fecha,          CASE  WHEN a.CargoU IS NULL AND a.AbonoU >0.0 THEN 'S' WHEN a.CargoU IS NULL AND a.AbonoU <0.0 THEN 'E' WHEN a.AbonoU IS NULL AND a.CargoU >0.0  THEN 'E' WHEN a.AbonoU IS NULL AND a.CargoU <0.0 THEN 'S' END, ISNULL(slm.Cantidad,ISNULL(CASE WHEN a.CargoU >0.0 THEN a.CargoU WHEN a.CargoU <0.0 THEN a.CargoU*-1 END ,CASE WHEN a.AbonoU >0.0 THEN a.AbonoU WHEN a.AbonoU <0.0 THEN a.AbonoU*-1 END)), @TipoMovimiento, e.Existencia, a.Grupo,    ar.PrecioLista, ISNULL(md.Costo,0),   (ISNULL(a.CargoU,a.AbonoU)* ar.PrecioLista)  , 0,       null,     null,      a.Grupo,     ISNULL(slm.SerieLote,''),                    0,          0, 0,            md.FechaRequerida,   m.Mov+' '+m.MovID,           m.FechaRegistro, NULL,                    m.Usuario,   NULL,      0,               0,            'IP',         'IP',           md.RenglonID,      NULL,       m.Moneda, 'IP',  NULL,   md.RenglonID,  m.FechaRegistro,    ISNULL(md.SubCuenta,''),@ReferenciaIntelisisService, @MovID
FROM AuxiliarU a
 WITH(NOLOCK) JOIN ProdD md  WITH(NOLOCK) ON a.Modulo = @Modulo AND a.ModuloID = md.ID AND a.Renglon = md.Renglon AND a.RenglonSub = md.RenglonSub
JOIN Prod m  WITH(NOLOCK) ON md.ID = m.ID
LEFT OUTER JOIN SerieLoteMov slm   WITH(NOLOCK) ON slm.ID = md.ID AND slm.Modulo = @Modulo AND slm.RenglonID = md.RenglonID AND slm.Articulo = md.Articulo AND ISNULL(slm.SubCuenta,'') = ISNULL(md.SubCuenta,'') AND slm.Empresa = m.Empresa
LEFT OUTER JOIN Art ar  WITH(NOLOCK) ON md.Articulo = ar.Articulo AND md.Articulo = @Cuenta
JOIN ArtExistenciaNeta e  WITH(NOLOCK) ON a.Empresa = e.Empresa AND a.Cuenta = e.Articulo AND a.Moneda = e.Moneda AND a.Grupo = e.Almacen
JOIN Alm al  WITH(NOLOCK) ON a.Grupo = al.Almacen
WHERE a.ID = @IDGenerar
AND ISNULL(al.EsFactory,0) = 1
END
IF @Modulo = 'INV'
SELECT @MovMES = MovMES FROM Inv WITH(NOLOCK) WHERE ID = @ID
IF (@Modulo = 'INV' AND (@MovMES <> 1 OR @MovMES IS NULL ) AND @Rama2 <>'RESV') OR (@Modulo = 'INV' AND @Accion = 'CANCELAR' AND @Rama2 <>'RESV')
BEGIN
SELECT @Cantidadslm = SUM(slm.Cantidad)
FROM SerieLoteMov slm
 WITH(NOLOCK) JOIN InvD md  WITH(NOLOCK) ON slm.ID = md.ID AND slm.Modulo = @Modulo AND slm.RenglonID = md.RenglonID AND slm.Articulo = md.Articulo AND ISNULL(slm.SubCuenta,'') = ISNULL(md.SubCuenta,'') AND slm.Empresa = @Empresa
JOIN AuxiliarU a  WITH(NOLOCK) ON a.Modulo = @Modulo AND a.ModuloID = md.ID AND a.Renglon = md.Renglon AND a.RenglonSub = md.RenglonSub
JOIN Alm al  WITH(NOLOCK) ON a.Grupo = al.Almacen
JOIN Art ar  WITH(NOLOCK) ON slm.Articulo = ar.Articulo
WHERE a.ID = @IDGenerar
AND ISNULL(al.EsFactory,0) = 1
AND ISNULL(ar.EsFactory,0) = 1
SELECT @Cantidad = ISNULL(a.CargoU,a.AbonoU)
FROM AuxiliarU a  WITH(NOLOCK) JOIN Alm al  WITH(NOLOCK) ON a.Grupo = al.Almacen
JOIN Art ar  WITH(NOLOCK) ON a.Cuenta = ar.Articulo
WHERE a.ID = @IDGenerar
AND ISNULL(al.EsFactory,0) = 1
AND ISNULL(ar.EsFactory,0) = 1
SELECT @Almacen = Almacen FROM Inv WITH(NOLOCK) WHERE ID = @ID
SELECT @ReferenciaIntelisisService = Referencia
FROM MapeoPlantaIntelisisMes
WITH(NOLOCK) WHERE Empresa = @Empresa AND Sucursal = @Sucursal
INSERT @Tabla (Codigo, CodigoID, CodigoArticulo, FechaMovimiento, EntradaSalida,                                                                                                     Cantidad,                                                                                                             TipoMovimiento, NuevoStock,   CodigoAlmacen, PrecioVenta,    PrecioCoste,            Importe,                                      NumPedido, ClienteDestino, ProveedorDestino, AlmacenDestino, NumeroLote,                    Lanzamiento, Fase, NumeroTrabajo, FechaEntregaPrevista, Observaciones1, FechaDeAlta,     FechaUltimaModificacion, UsuarioAlta, Ubicaci�n, NuevoStockAlmacen, NuevoStockLote, SeriePedido, SerieDocumento,     NumLineaDocumento, TipoCambio, Divisa,   Serie, Numero, Linea,        FechaMovimientoHora, SubCuenta,               ReferenciaIntelisisService, NumDocumento )
SELECT         @Cuenta, NULL,    @Cuenta,        @Fecha,          CASE  WHEN a.CargoU IS NULL AND a.AbonoU >0.0 THEN 'S' WHEN a.CargoU IS NULL AND a.AbonoU <0.0 THEN 'E' WHEN a.AbonoU IS NULL AND a.CargoU >0.0  THEN 'E' WHEN a.AbonoU IS NULL AND a.CargoU <0.0 THEN 'S' END, ISNULL(slm.Cantidad,ISNULL(CASE WHEN a.CargoU >0.0 THEN a.CargoU WHEN a.CargoU <0.0 THEN a.CargoU*-1 END ,CASE WHEN a.AbonoU >0.0 THEN a.AbonoU WHEN a.AbonoU <0.0 THEN a.AbonoU*-1 END))*dbo.fnInforArtUnidadCompraFactor(@Empresa,md.Articulo), @TipoMovimiento, e.Existencia, a.Grupo,      ar.PrecioLista, ISNULL(md.Costo,0),    (ISNULL(a.CargoU,a.AbonoU)* ar.PrecioLista)  , 0,       null,     null,      a.Grupo,     ISNULL(slm.SerieLote,''),                    0,          0, 0,            md.FechaRequerida,   m.Mov+' '+m.MovID,           m.FechaRegistro, NULL,                    m.Usuario,   NULL,      0,               0,            'IP',         'IP',           md.RenglonID,      NULL,       m.Moneda, 'IP',  NULL,   md.RenglonID,  m.FechaRegistro,    ISNULL(md.SubCuenta,''),@ReferenciaIntelisisService, @MovID
FROM AuxiliarU a
 WITH(NOLOCK) JOIN Invd md  WITH(NOLOCK) ON a.Modulo = @Modulo AND a.ModuloID = md.ID AND a.Renglon = md.Renglon AND a.RenglonSub = md.RenglonSub
JOIN Inv m    WITH(NOLOCK) ON md.ID = m.ID
LEFT OUTER JOIN SerieLoteMov slm  WITH(NOLOCK) ON slm.ID = md.ID AND slm.Modulo = @Modulo AND slm.RenglonID = md.RenglonID AND slm.Articulo = md.Articulo AND ISNULL(slm.SubCuenta,'') = ISNULL(md.SubCuenta,'') AND slm.Empresa = m.Empresa
LEFT OUTER JOIN Art ar  WITH(NOLOCK) ON md.Articulo = ar.Articulo AND md.Articulo = @Cuenta
JOIN ArtExistenciaNeta e  WITH(NOLOCK) ON a.Empresa = e.Empresa AND a.Cuenta = e.Articulo AND a.Moneda = e.Moneda AND a.Grupo = e.Almacen
JOIN Alm al  WITH(NOLOCK) ON a.Grupo = al.Almacen
WHERE a.ID = @IDGenerar
AND ISNULL(al.EsFactory,0) = 1
AND ISNULL(ar.EsFactory,0) = 1
END
IF EXISTS(SELECT * FROM @Tabla)
BEGIN
UPDATE @Tabla SET StockAntes = s.Existencia
FROM @Tabla t JOIN Art a  WITH(NOLOCK) ON a.Articulo = t.Codigo
LEFT JOIN SerieLote s   WITH(NOLOCK) ON t.Codigo = s.Articulo AND t.AlmacenDestino = s.Almacen AND t.NumeroLote = s.SerieLote AND s.Empresa = @Empresa AND s.Sucursal = @Sucursal  AND ISNULL(t.SubCuenta,'') = ISNULL(s.SubCuenta,'')
WHERE a.Tipo IN ('SERIE','LOTE')
UPDATE @Tabla SET StockAntes = ISNULL(s.Disponible,0)+ISNULL(s.Reservado,0)
FROM @Tabla t JOIN Art a  WITH(NOLOCK) ON a.Articulo = t.Codigo
LEFT JOIN ArtDisponibleReservado s   WITH(NOLOCK) ON t.Codigo = s.Articulo AND t.AlmacenDestino = s.Almacen  AND s.Empresa = @Empresa
WHERE a.Tipo IN ('Normal')
END
IF EXISTS(SELECT * FROM @Tabla)
BEGIN
UPDATE @Tabla SET StockAntes = 0.0 WHERE StockAntes = NULL
SET @Resultado = CONVERT(varchar(max) ,(SELECT * FROM @Tabla MovimientoArticulo FOR XML AUTO))
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL AND ((@MovMES <> 1 OR @MovMES IS NULL)OR (@Accion = 'CANCELAR'))AND @Rama2 <> 'RESV' AND EXISTS (SELECT * FROM AuxiliarU AU  WITH(NOLOCK) JOIN MovTipo MT  WITH(NOLOCK) ON AU.Mov = MT.Mov AND MT.Clave <> 'INV.TMA' WHERE AU.ID = @IDGenerar)
BEGIN
SELECT @Datos = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Infor" Contenido="Solicitud" Referencia="Infor.Movimiento.Procesar.INV" SubReferencia="'+@Modulo+'" Version="1.0"><Solicitud IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@IDNuevo),'')   + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)  + ' ReferenciaIntelisisService='+ CHAR(34)+ ISNULL(@ReferenciaIntelisisService,'')+CHAR(34)+ ' >' + @Resultado + '</Solicitud></Intelisis>'
EXEC spIntelisisService  @Usuario,@Contrasena,@Datos,@Resultado,@Ok Output,@OkRef Output,0,0,@IDNuevo Output
IF @@ERROR <> 0 SET @Ok = 1
END
END
END
RETURN
END

