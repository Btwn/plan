SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPlanArtMaxMinProcesar(
@Empresa                   varchar(5),
@Sucursal                  int,
@Usuario                   varchar(10),
@Estacion                  int
)

AS BEGIN
DECLARE
@SPID                      varchar(20),
@FechaHoy                  datetime,
@Cuenta                    int,
@GeneradosDistribuir       int,
@GeneradosComprar          int,
@MovIdLog                  varchar(20),
@EstatusLog                varchar(15),
@TipoMovimiento            varchar(20),
@Movimiento                varchar(20),
@Observacion               varchar(4000),
@Mensaje                   varchar(4000),
@Almacen                   varchar(10),
@AlmacenDestino            varchar(10),
@ArtTipo                   varchar(20),
@AlmacenCr                 varchar(10),
@ProveedorCr               varchar(10),
@Corrida                   int,
@SucursalLog               int,
@idx                       int,
@MovEstatus                varchar(15),
@MovConsecutivo            bit,
@MovReservar               bit,
@Modulo                    varchar(5),
@Accion                    varchar(20),
@Base                      varchar(20),
@GenerarMov                varchar(20),
@SincroFinal               bit,
@EnSilencio                bit,
@Conexion                  bit,
@Ok                        int,
@OkRef                     varchar(255),
@FechaRegistro             datetime,
@ID                        int,
@Mov                       varchar(20),
@MovID                     varchar(20),
@FechaEmision              datetime,
@Proyecto                  varchar(50),
@Moneda                    varchar(10),
@TipoCambio                float,
@Concepto                  varchar(50),
@Referencia                varchar(50),
@DocFuente                 int,
@Observaciones             varchar(100),
@Estatus                   varchar(15),
@Situacion                 varchar(50),
@SituacionFecha            datetime,
@SituacionUsuario          varchar(10),
@SituacionNota             varchar(100),
@Directo                   bit,
@RenglonID                 int,
@AlmacenTransito           varchar(10),
@Largo                     bit,
@Condicion                 varchar(50),
@Vencimiento               datetime,
@FormaEnvio                varchar(50),
@Autorizacion              varchar(10),
@OrigenTipo                varchar(10),
@Origen                    varchar(20),
@OrigenID                  varchar(20),
@Poliza                    varchar(20),
@PolizaID                  varchar(20),
@FechaConclusion           datetime,
@FechaCancelacion          datetime,
@FechaOrigen               datetime,
@FechaRequerida            datetime,
@Peso                      float,
@Volumen                   float,
@SucursalOrigen            int,
@VerLote                   bit,
@UEN                       int,
@VerDestino                bit,
@Personal                  varchar(10),
@Conteo                    int,
@Agente                    varchar(10),
@ACRetencion               float,
@SubModulo                 varchar(5),
@Motivo                    varchar(8),
@ReferenciaMES             varchar(50),
@PedidoMES                 varchar(50),
@Serie                     varchar(3),
@IDMES                     int,
@IDMarcaje                 int,
@MovMES                    bit,
@Actividad                 varchar(100),
@PedimentoExtraccion       varchar(50),
@PosicionWMS               varchar(10),
@PosicionDWMS              varchar(10),
@SucursalDestino           int,
@Renglon                   float,
@RenglonSub                int,
@RenglonTipo               char(1),
@Cantidad                  float,
@Codigo                    varchar(30),
@Articulo                  varchar(20),
@ArticuloDestino           varchar(20),
@SubCuenta                 varchar(50),
@SubCuentaDestino          varchar(50),
@Costo                     money,
@CostoInv                  money,
@ContUso                   varchar(20),
@Espacio                   varchar(10),
@CantidadA                 float,
@Paquete                   int,
@Aplica                    varchar(20),
@AplicaID                  varchar(20),
@DestinoTipo               varchar(10),
@Destino                   varchar(20),
@DestinoID                 varchar(20),
@Cliente                   varchar(10),
@DefUnidad                 varchar(50),
@Unidad                    varchar(50),
@Factor                    float,
@CantidadInventario        float,
@ProdSerieLote             varchar(50),
@Merma                     float,
@Desperdicio               float,
@Producto                  varchar(20),
@SubProducto               varchar(20),
@Tipo                      varchar(20),
@Precio                    money,
@SegundoConteo             float,
@DescripcionExtra          varchar(100),
@Posicion                  varchar(10),
@UltimoCambio              datetime,
@Prioridad                 varchar(10),
@Proveedor                 varchar(10),
@FechaEntrega              datetime,
@Manejo                    money,
@Fletes                    money,
@Instruccion               varchar(50),
@Descuento                 varchar(30),
@DescuentoH                varchar(30),
@DescuentoGlobal           float,
@Importe                   money,
@Impuestos                 money,
@DescuentoLineal           money,
@Atencion                  varchar(50),
@Causa                     varchar(50),
@ZonaImpuesto              varchar(30),
@Idioma                    varchar(50),
@ListaPreciosEsp           varchar(20),
@FormaEntrega              varchar(50),
@CancelarPendiente         bit,
@LineaCredito              varchar(20),
@TipoAmortizacion          varchar(20),
@TipoTasa                  varchar(20),
@Comisiones                money,
@ComisionesIVA             money,
@VIN                       varchar(20),
@AutoCargos                float,
@TieneTasaEsp              bit,
@TasaEsp                   float,
@FechaOrdenar              datetime,
@Impuesto1                 float,
@Impuesto2                 float,
@Impuesto3                 float,
@DescuentoTipo             char(1),
@DescuentoLinea            money,
@DescuentoImporte          money,
@ReferenciaExtra           varchar(50),
@ServicioArticulo          varchar(20),
@ServicioSerie             varchar(20),
@ImportacionProveedor      varchar(10),
@ImportacionReferencia     varchar(50),
@Retencion1                float,
@Retencion2                float,
@Retencion3                float,
@FechaCaducidad            datetime,
@ProveedorArt              varchar(10),
@ProveedorArtCosto         float,
@Pais                      varchar(50),
@TratadoComercial          varchar(50),
@ProgramaSectorial         varchar(50),
@ValorAduana               money,
@ID1                       char(2),
@ID2                       char(2),
@FormaPago                 varchar(50),
@ImportacionImpuesto1      float,
@ImportacionImpuesto2      float,
@EsEstadistica             bit,
@CfgCompraCostoSugerido    varchar(20),
@MultiUnidad               varchar(20)
SET @Empresa  = UPPER(LTRIM(RTRIM(ISNULL(@Empresa,''))))
SET @Sucursal = UPPER(LTRIM(RTRIM(ISNULL(@Sucursal,''))))
SET @Usuario  = UPPER(LTRIM(RTRIM(ISNULL(@Usuario,''))))
SET @Estacion = ISNULL(@Estacion,1)
SET @SucursalLog = @Sucursal
SELECT @CfgCompraCostoSugerido = CompraCostoSugerido FROM EmpresaCfg WHERE Empresa = @Empresa
SET @FechaHoy = GETDATE()
SET @GeneradosDistribuir = 0
SET @GeneradosComprar = 0
SET @MovEstatus = 'PENDIENTE'
SET @MovConsecutivo = 0
SET @MovReservar = 1
SET @SPID = LTRIM(RTRIM(CAST(@@SPID AS varchar)))
SELECT @Corrida = MAX(Corrida) FROM PlanArtMaxMinHist
SET @Corrida = ISNULL(@Corrida,0) + 1
SELECT @MultiUnidad = NivelFactorMultiUnidad FROM EmpresaCFG2 WHERE Empresa = @Empresa
SELECT @Moneda = DefMoneda,@UEN = UEN FROM Usuario WHERE Usuario = @Usuario
SELECT @TipoCambio = TipoCambio FROM Mon WHERE Moneda = @Moneda
SELECT @DefUnidad = ISNULL(DefUnidad,'pza') FROM EmpresaGral WHERE Empresa = @Empresa
SET @ID = NULL
SET @MovID = NULL
SET @FechaEmision = dbo.fnFechaSinHora(@FechaHoy)
SET @UltimoCambio = @FechaHoy
SET @Proyecto = NULL
SET @Concepto = 'Traspaso entre sucursales'
SET @Referencia = NULL
SET @DocFuente = NULL
SET @Observaciones = 'Para Surtir Almacen'
SET @Estatus = 'SINAFECTAR'
SET @Situacion = NULL
SET @SituacionFecha = NULL
SET @SituacionUsuario = NULL
SET @SituacionNota = NULL
SET @Directo = 1
SET @RenglonID = NULL
SET @AlmacenDestino = NULL
SET @AlmacenTransito = '(TRANSITO)'
SET @Largo = 0
SET @Condicion = NULL
SET @Vencimiento = @FechaEmision
SET @FormaEnvio = NULL
SET @Autorizacion = NULL
SET @OrigenTipo = NULL
SET @Origen = NULL
SET @OrigenID = NULL
SET @Poliza = NULL
SET @PolizaID = NULL
SET @FechaConclusion = NULL
SET @FechaCancelacion = NULL
SET @FechaOrigen = NULL
SET @FechaRequerida = @FechaEmision
SET @Peso = NULL
SET @Volumen = NULL
SET @VerLote = 0
SET @VerDestino = 0
SET @Personal = NULL
SET @Conteo = NULL
SET @Agente = @Usuario
SET @ACRetencion = NULL
SET @SubModulo = 'INV'
SET @Motivo = NULL
SET @ReferenciaMES = NULL
SET @PedidoMES = NULL
SET @Serie = NULL
SET @IDMES = NULL
SET @IDMarcaje = NULL
SET @MovMES = NULL
SET @Actividad = NULL
SET @PedimentoExtraccion = NULL
SET @PosicionWMS = 0
SET @PosicionDWMS = NULL
SET @RenglonSub = 0
SET @RenglonTipo = NULL
SET @Prioridad = 'Normal'
SET @Modulo = 'INV'
SET @Accion = 'AFECTAR'
SET @Base = 'TODO'
SET @GenerarMov = NULL
SET @SincroFinal = 0
SET @EnSilencio = 1
SET @Conexion = 0
SET @Observacion = ''
SET @Mensaje = ''
DECLARE @TablaDistribuir Table (
IDR                   int IDENTITY(1,1) NOT NULL,
ID                    int               NULL,
Almacen               varchar(10)       NULL,
AlmacenDestino        varchar(10)       NULL,
Articulo              varchar(20)       NULL,
SubCuenta             varchar(50)       NULL,
Cantidad              float             NULL,
Procesado             bit               NULL
)
DECLARE @TablaComprar Table (
IDR                   int IDENTITY(1,1) NOT NULL,
ID                    int               NULL,
Almacen               varchar(10)       NULL,
Proveedor             varchar(10)       NULL,
Articulo              varchar(20)       NULL,
SubCuenta             varchar(50)       NULL,
Cantidad              float             NULL,
Procesado             bit               NULL
)
DECLARE @TablaAfectar table(
Ok                  int,
OkDesc              varchar(255),
OkTipo              varchar(50),
OkRef               varchar(255),
IDGenerar           int
)
INSERT INTO @TablaDistribuir(ID,Almacen,AlmacenDestino,Articulo,SubCuenta,Cantidad,Procesado)
SELECT ID,Almacen,AlmacenD,Articulo,SubCuenta,CantidadA,0
FROM PlanArtMaxMin
WHERE Empresa = @Empresa AND Usuario = @Usuario AND Estacion = @Estacion
AND Tipo = 'Distribuir' AND Aplicar = 1 AND CantidadA > 0
ORDER BY Almacen, AlmacenD, Articulo, SubCuenta
SELECT TOP 1 @Mov = Movimiento FROM PlanArtMaxMin WHERE Tipo = 'Distribuir'
IF EXISTS(SELECT * FROM @TablaDistribuir)
IF NOT EXISTS(SELECT * FROM MovTipo WHERE Modulo = 'INV' AND Mov = @Mov AND Clave = 'INV.OT')
IF EXISTS(SELECT *
FROM @TablaDistribuir A
JOIN Alm B
ON A.Almacen = B.Almacen
JOIN Alm C
ON A.AlmacenDestino = C.Almacen
WHERE B.Sucursal = C.Sucursal)
BEGIN
SELECT 'No se pueden realizar Transferencias entre Almacenes de la misma Sucursal.
Revisar la configuración en: Configurar | Planeación | Máximos y Mínimos.'
RETURN
END
INSERT INTO @TablaComprar (ID,Almacen,Proveedor,Articulo,SubCuenta,Cantidad,Procesado)
SELECT ID,Almacen,Proveedor,Articulo,SubCuenta,CantidadA,0
FROM PlanArtMaxMin
WHERE Empresa = @Empresa AND Usuario = @Usuario AND Estacion = @Estacion
AND Tipo = 'Comprar' AND Aplicar = 1 AND CantidadA > 0
ORDER BY Almacen, AlmacenD, Proveedor, Articulo
BEGIN TRY
SELECT @idx = MIN(IDR) FROM @TablaDistribuir WHERE  Procesado = 0
SET @idx = ISNULL (@idx,0)
WHILE @idx > 0
BEGIN
SELECT @Almacen = Almacen,
@AlmacenDestino = AlmacenDestino
FROM @TablaDistribuir
WHERE IDR = @idx
SELECT @RenglonID = COUNT(AlmacenDestino)
FROM @TablaDistribuir
WHERE AlmacenDestino = @AlmacenDestino
AND Almacen = @Almacen
SELECT @Sucursal = Sucursal FROM Alm WHERE Almacen = @Almacen
SELECT @SucursalOrigen = Sucursal FROM Alm WHERE ALmacen = @Almacen
SET @SucursalDestino = NULL
INSERT INTO Inv (
Empresa, Mov, MovID, FechaEmision, Proyecto, Moneda, TipoCambio, Concepto, Referencia, DocFuente,
Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Directo,
RenglonID, Almacen, AlmacenDestino, AlmacenTransito, Largo, Condicion, Vencimiento, FormaEnvio,
Autorizacion, Usuario, OrigenTipo, Origen, OrigenID, Poliza, PolizaID, FechaConclusion,
FechaCancelacion, FechaOrigen, FechaRequerida, Peso, Volumen, Sucursal, SucursalOrigen, VerLote,
UEN, VerDestino, Personal, Conteo, Agente, ACRetencion, SubModulo, Actividad, PedimentoExtraccion,
SucursalDestino
)
VALUES
(
@Empresa, @Mov, @MovID, @FechaEmision, @Proyecto, @Moneda, @TipoCambio, @Concepto, @Referencia,
@DocFuente, @Observaciones, @Estatus, @Situacion, @SituacionFecha, @SituacionUsuario, @SituacionNota,
@Directo, @RenglonID, @Almacen, @AlmacenDestino, @AlmacenTransito, @Largo, @Condicion, @Vencimiento,
@FormaEnvio, @Autorizacion, @Usuario, @OrigenTipo, @Origen, @OrigenID, @Poliza, @PolizaID, @FechaConclusion,
@FechaCancelacion, @FechaOrigen, @FechaRequerida, @Peso, @Volumen, @Sucursal, @SucursalOrigen, @VerLote, @UEN,
@VerDestino, @Personal, @Conteo, @Agente, @ACRetencion, @SubModulo, @Actividad, @PedimentoExtraccion, @SucursalDestino
)
SET @ID = SCOPE_IDENTITY()
SET @RenglonID = 0
DECLARE crTablaDistribuir CURSOR FOR
SELECT Articulo, SubCuenta, Cantidad FROM @TablaDistribuir
WHERE Almacen = @Almacen AND AlmacenDestino = @AlmacenDestino
OPEN crTablaDistribuir
FETCH NEXT FROM crTablaDistribuir INTO @Articulo,@SubCuenta,@Cantidad
WHILE @@FETCH_STATUS = 0
BEGIN
SET @RenglonID = @RenglonID + 1
SET @Renglon   = @RenglonID * 2048
SELECT @Unidad = UnidadTraspaso, @ArtTipo = Tipo FROM Art WITH(NOLOCK) WHERE Articulo = @Articulo
SET @Unidad = ISNULL(@Unidad, @DefUnidad)
IF @MultiUnidad = 'Articulo'
SELECT @Factor = Factor FROM ArtUnidad WITH(NOLOCK) WHERE Unidad = @Unidad AND Articulo = @Articulo
IF @MultiUnidad = 'Unidad'
SELECT @Factor = Factor FROM Unidad WITH(NOLOCK) WHERE Unidad = @Unidad
IF ISNULL(@MultiUnidad,'') = '' OR ISNULL(@Factor, '') = ''
SELECT @Factor = 1
EXEC spRenglonTipo @ArtTipo, @SubCuenta, @RenglonTipo
IF NOT @RenglonTipo IN('N','S','L','V','J') SET @RenglonTipo = 'N'
EXEC spPrecioEsp '(Precio Lista)', @Moneda, @Articulo, @SubCuenta, @Precio OUTPUT
SET @CantidadInventario = ISNULL(@Cantidad * @Factor, 0)
SET @Cantidad = @Cantidad / @Factor
IF ISNULL(@SubCuenta,'') = '' SET @SubCuenta = NULL
INSERT INTO InvD (
ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Almacen, Codigo, Articulo, SubCuenta, ArticuloDestino,
SubCuentaDestino, Cantidad, Paquete, Costo, CantidadA, Aplica, AplicaID, ContUso, Unidad, Factor,
CantidadInventario, FechaRequerida, ProdSerieLote, Merma, Desperdicio, Producto, SubProducto, Tipo,
Sucursal, SucursalOrigen, Precio, CostoInv, Espacio, DestinoTipo, Destino, DestinoID, Cliente,
SegundoConteo, DescripcionExtra, Posicion
)
VALUES
(
@ID, @Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @Almacen, @Codigo, @Articulo, @SubCuenta, @ArticuloDestino,
@SubCuentaDestino, @Cantidad, @Paquete, @Costo, @Cantidad, @Aplica, @AplicaID, @ContUso, @Unidad, @Factor,
@CantidadInventario, @FechaRequerida, @ProdSerieLote, @Merma, @Desperdicio, @Producto, @SubProducto, @Tipo,
@Sucursal, @SucursalOrigen, @Precio, @CostoInv, @Espacio, @DestinoTipo, @Destino, @DestinoID, @Cliente,
@SegundoConteo, @DescripcionExtra, @Posicion
)
UPDATE @TablaDistribuir SET Procesado = 1 WHERE Almacen = @Almacen AND AlmacenDestino = @AlmacenDestino
FETCH NEXT FROM crTablaDistribuir INTO @Articulo, @SubCuenta, @Cantidad
END
CLOSE crTablaDistribuir
DEALLOCATE crTablaDistribuir
SET @Observacion = ''
IF @MovEstatus = 'SIN AFECTAR' AND @MovConsecutivo = 1
BEGIN
SET @Accion = 'Consecutivo'
SET @Base = 'Todo'
EXECUTE spAfectar @Modulo, @ID, @Accion, @Base, @GenerarMov, @Usuario, @SincroFinal, @EnSilencio, @Ok OUTPUT, @OkRef OUTPUT, @FechaRegistro, @Conexion, @Estacion
IF ISNULL(@Ok,0) > 0
BEGIN
SELECT @Observacion = LTRIM(RTRIM(ISNULL(Descripcion,''))) FROM MensajeLista WHERE Mensaje = @Ok
SET @Observacion = @Observacion + ' (' + LTRIM(RTRIM(ISNULL(@OkRef,''))) + ')' + ' '
END
SET @Ok = NULL
END
IF @MovEstatus = 'PENDIENTE'
BEGIN
SET @Accion = 'Afectar'
SET @Base = 'Todo'
EXECUTE spAfectar @Modulo, @ID, @Accion, @Base, @GenerarMov, @Usuario, @SincroFinal, @EnSilencio, @Ok OUTPUT, @OkRef OUTPUT, @FechaRegistro, @Conexion, @Estacion
IF ISNULL(@Ok,0) > 0
BEGIN
SELECT @Observacion = @Observacion + LTRIM(RTRIM(ISNULL(Descripcion,''))) FROM MensajeLista WHERE Mensaje = @Ok + ' '
SET @Observacion = @Observacion + ' (' + LTRIM(RTRIM(ISNULL(@OkRef,''))) + ')'
END
SET @Ok = NULL
END
IF @MovEstatus = 'PENDIENTE' AND @MovReservar = 1
BEGIN
SET @Accion = 'Reservar'
SET @Base = 'Pendiente'
EXECUTE spAfectar @Modulo, @ID, @Accion, @Base, @GenerarMov, @Usuario, @SincroFinal, @EnSilencio, @Ok OUTPUT, @OkRef OUTPUT, @FechaRegistro, @Conexion, @Estacion
IF ISNULL(@Ok,0) > 0
BEGIN
SELECT @Observacion = @Observacion + LTRIM(RTRIM(ISNULL(Descripcion,''))) FROM MensajeLista WHERE Mensaje = @Ok
SET @Observacion = @Observacion + ' (' + LTRIM(RTRIM(ISNULL(@OkRef,''))) + ')'
END
SET @Ok = NULL
END
SELECT @SucursalDestino = Sucursal FROM Alm WHERE ALmacen = @AlmacenDestino
UPDATE Inv SET SucursalDestino = @SucursalDestino WHERE ID = @ID
SET @SucursalDestino = NULL
SELECT @MovIdLog = MovID, @EstatusLog = Estatus FROM Inv WHERE ID = @ID
INSERT INTO PlanArtMaxMinLog (Empresa, Sucursal, Usuario, Estacion, Corrida, Almacen, AlmacenDestino, Reservar, InvID, InvMov, InvMovId, Estatus, FechaLog, Observacion)
VALUES (@Empresa, @SucursalLog, @Usuario, @Estacion, @Corrida, @Almacen, @AlmacenDestino, @MovReservar, @ID, @Mov, @MovIdLog, @EstatusLog, GETDATE(), @Observacion)
SET @Observacion = ''
SET @GeneradosDistribuir = @GeneradosDistribuir + 1
SELECT @idx = MIN(IDR) FROM @TablaDistribuir WHERE Procesado = 0
SET @idx = ISNULL (@idx,0)
END
INSERT INTO PlanArtMaxMinHist (
ID, Empresa, Sucursal, Usuario, Estacion, Corrida, Grupo, Categoria, Familia, Linea, Fabricante, Proveedor, Nombre, Almacen,
AlmacenNombre, Articulo, SubCuenta, Descripcion1, Descripcion2, NombreCorto, Unidad, ABC, Maximo, Minimo, VentaPromedio, Precio,
ImporteTotal, Existencia, EnCompra, PorRecibir, PorEntregar, Disponible, DiasInvInicio, AlmacenD, AlmacenNombreD, MaximoD, MinimoD,
VentaPromedioD, ExistenciaD, EnCompraD, PorRecibirD, PorEntregarD, DisponibleD, DiasInvD, Solicitar, Cantidad, CantidadA,
DiasInvFin, Tipo, Movimiento, Aplicar
)
SELECT	a.ID, a.Empresa, a.Sucursal, a.Usuario, a.Estacion, @Corrida, a.Grupo, a.Categoria, a.Familia, a.Linea, a.Fabricante, a.Proveedor, a.Nombre, a.Almacen,
a.AlmacenNombre, a.Articulo, a.SubCuenta, a.Descripcion1, a.Descripcion2, a.NombreCorto, a.Unidad, a.ABC, a.Maximo, a.Minimo, a.VentaPromedio, a.Precio,
a.ImporteTotal, a.Existencia, a.EnCompra, a.PorRecibir, a.PorEntregar, a.Disponible, a.DiasInvInicio, a.AlmacenD, a.AlmacenNombreD, a.MaximoD, a.MinimoD,
a.VentaPromedioD, a.ExistenciaD, a.EnCompraD, a.PorRecibirD, a.PorEntregarD, a.DisponibleD, a.DiasInvD, a.Solicitar, a.Cantidad, a.CantidadA,
a.DiasInvFin, a.Tipo, a.Movimiento, a.Aplicar
FROM PlanArtMaxMin a
JOIN @TablaDistribuir b ON a.ID = b.ID
WHERE b.Procesado = 1
DELETE a FROM PlanArtMaxMin AS a INNER JOIN @TablaDistribuir b ON (a.ID = b.ID) WHERE b.Procesado = 1
SELECT TOP 1 @Mov = Movimiento FROM PlanArtMaxMin WHERE Tipo = 'Comprar'
SELECT @idx = MIN(IDR) FROM @TablaComprar WHERE Procesado = 0
SET @idx = ISNULL (@idx,0)
WHILE @idx > 0
BEGIN
SELECT TOP 1 @Mov = Movimiento FROM PlanArtMaxMin WHERE Tipo = 'Comprar'
SET @MovID = NULL
SET @Concepto = 'STOCK'
SET @Estatus = 'SINAFECTAR'
SET @FechaEntrega = @FechaHoy
SET @FechaRequerida = @FechaHoy
SET @Manejo = NULL
SET @Fletes = NULL
SET @Instruccion = NULL
SET @DescuentoGlobal = NULL
SET @Importe = NULL
SET @Impuestos = NULL
SET @DescuentoLineal = NULL
SET @Origen = 'INT'
SET @Origen = NULL
SET @Poliza = NULL
SET @PolizaID = NULL
SET @Peso = 0
SET @Atencion = NULL
SET @Causa = NULL
SET @SucursalOrigen = 0
SET @Idioma = NULL
SET @ListaPreciosEsp = NULL
SET @UEN = NULL
SET @Mensaje = NULL
SET @FormaEntrega = NULL
SET @CancelarPendiente = 0
SET @LineaCredito = NULL
SET @TipoAmortizacion = NULL
SET @TipoTasa = NULL
SET @Comisiones = NULL
SET @ComisionesIVA = 0
SET @VIN = NULL
SET @SubModulo = 'COMS'
SET @AutoCargos = NULL
SET @TieneTasaEsp = 0
SET @TasaEsp = NULL
SET @Cliente = NULL
SET @Renglon = 0
SET @RenglonID = NULL
SELECT @Almacen = Almacen, @Proveedor = Proveedor FROM @TablaComprar WHERE IDR = @idx
SELECT @Condicion = Condicion, @ZonaImpuesto = ZonaImpuesto, @DescuentoH = Descuento, @Agente = Agente FROM Prov WHERE Proveedor = @Proveedor
SELECT @Descuento = Porcentaje FROM Descuento WHERE Descuento = @DescuentoH
SELECT @Vencimiento = DATEADD(d,DiasVencimiento,GETDATE()) FROM Condicion WHERE Condicion = @Condicion
SELECT @Impuesto1 = Porcentaje FROM ZonaImp WHERE Zona = @ZonaImpuesto
SELECT @Sucursal = Sucursal FROM Alm WHERE Almacen = @Almacen
SELECT @Agente = DefAgente FROM Usuario WHERE Usuario = @Usuario
SET @Agente = ISNULL(@Agente,'')
SET @SucursalOrigen = @SucursalLog
INSERT INTO Compra (
Empresa, Mov, MovID, FechaEmision, UltimoCambio, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Autorizacion, Referencia, DocFuente, Observaciones, Estatus,
Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Directo, VerDestino, Prioridad, RenglonID, Proveedor, FormaEnvio, FechaEntrega, FechaRequerida,
Almacen, Condicion, Vencimiento, Manejo, Fletes, Instruccion, Agente, Descuento, DescuentoGlobal, Importe, Impuestos, DescuentoLineal, OrigenTipo, Origen,
OrigenID, Poliza, PolizaID, Peso, Volumen, Atencion, Causa, Sucursal, SucursalOrigen, ZonaImpuesto, Idioma, ListaPreciosEsp, UEN, Mensaje, FormaEntrega,
CancelarPendiente, LineaCredito, TipoAmortizacion, TipoTasa, Comisiones, ComisionesIVA, VIN, SubModulo, AutoCargos, TieneTasaEsp, TasaEsp, Cliente
)
VALUES
(
@Empresa, @Mov, @MovID, @FechaEmision, @UltimoCambio, @Concepto, @Proyecto, @Moneda, @TipoCambio, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, @Estatus,
@Situacion, @SituacionFecha, @SituacionUsuario, @SituacionNota, @Directo, @VerDestino, @Prioridad, @RenglonID, @Proveedor, @FormaEnvio, @FechaEntrega, @FechaRequerida,
@Almacen, @Condicion, @Vencimiento, @Manejo, @Fletes, @Instruccion, @Agente, @DescuentoH, @DescuentoGlobal, @Importe, @Impuestos, @DescuentoLineal, @OrigenTipo, @Origen,
@OrigenID, @Poliza, @PolizaID, @Peso, @Volumen, @Atencion, @Causa, @Sucursal, @SucursalOrigen, @ZonaImpuesto, @Idioma, @ListaPreciosEsp, @UEN, @Mensaje, @FormaEntrega,
@CancelarPendiente, @LineaCredito, @TipoAmortizacion, @TipoTasa, @Comisiones, @ComisionesIVA, @VIN, @SubModulo, @AutoCargos, @TieneTasaEsp, @TasaEsp, @Cliente
)
SET @ID = SCOPE_IDENTITY()
SET @RenglonID = 0
DECLARE crTablaComprarTMP CURSOR FOR
SELECT Almacen,Proveedor,Articulo,SubCuenta,SUM(Cantidad) AS Cantidad FROM @TablaComprar
WHERE Almacen = @Almacen AND Proveedor = @Proveedor
GROUP BY Almacen,Proveedor,Articulo,SubCuenta
OPEN crTablaComprarTMP
FETCH NEXT FROM crTablaComprarTMP INTO @AlmacenCr, @ProveedorCr, @Articulo, @SubCuenta, @Cantidad
WHILE @@FETCH_STATUS = 0
BEGIN
SET @RenglonID = @RenglonID + 1
SET @Renglon   = @RenglonID * 2048
IF ISNULL(@SubCuenta,'') = '' SET @SubCuenta = NULL
SELECT @Sucursal = Sucursal FROM alm WHERE Almacen = @AlmacenCr
SELECT @Unidad = UnidadCompra FROM Art WHERE Articulo = @Articulo
SELECT @Factor = Factor FROM Unidad WHERE Unidad = @Unidad
SET @Factor = ISNULL(@Factor,1)
EXEC spVerCosto @Sucursal, @Empresa, @Proveedor, @Articulo, @SubCuenta, NULL, @CfgCompraCostoSugerido, @Moneda, @TipoCambio, @Costo OUTPUT, 0
SELECT @Impuesto1 = Impuesto1 FROM Art WHERE Articulo = @Articulo
SET @Costo = ISNULL(@Costo,0)
SET @FechaRequerida = @FechaHoy
SET @FechaOrdenar = NULL
SET @FechaEntrega = @FechaHoy
SET @Codigo = NULL
SET @CostoInv = NULL
SET @Impuesto2 = 0.0
SET @Impuesto3 = 0.0
SET @DescuentoTipo = NULL
SET @DescuentoLinea = @Descuento
SET @DescuentoImporte = NULL
SET @DescripcionExtra = NULL
SET @ReferenciaExtra = NULL
SET @DestinoTipo = NULL
SET @Destino = NULL
SET @DestinoID = NULL
SET @Cliente = NULL
SET @Aplica = NULL
SET @AplicaID = NULL
SET @CantidadInventario = @Cantidad * @Factor
SET @CantidadA = NULL
SET @ContUso = NULL
SET @ServicioArticulo = NULL
SET @ServicioSerie = NULL
SET @Sucursal = 0
SET @SucursalOrigen = 0
SET @Paquete = NULL
SET @ImportacionProveedor = NULL
SET @ImportacionReferencia = NULL
SET @Retencion1 = NULL
SET @Retencion2 = NULL
SET @Retencion3 = NULL
SET @FechaCaducidad = NULL
SET @ProveedorArt = NULL
SET @ProveedorArtCosto = NULL
SET @Posicion = NULL
SET @Pais = NULL
SET @TratadoComercial = NULL
SET @ProgramaSectorial = NULL
SET @ValorAduana = NULL
SET @ID1 = NULL
SET @ID2 = NULL
SET @FormaPago = NULL
SET @ImportacionImpuesto1 = NULL
SET @ImportacionImpuesto2 = NULL
SET @EsEstadistica = 0
INSERT INTO CompraD (
ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Almacen, FechaRequerida, FechaOrdenar, FechaEntrega, Codigo, Articulo, SubCuenta, Cantidad,
Costo, CostoInv, Impuesto1, Impuesto2, Impuesto3, Descuento, DescuentoTipo, DescuentoLinea, DescuentoImporte, DescripcionExtra, ReferenciaExtra,
DestinoTipo, Destino, DestinoID, Cliente, Aplica, AplicaID, CantidadInventario, CantidadA, ContUso, Unidad, Factor, ServicioArticulo, ServicioSerie,
Sucursal, SucursalOrigen, Paquete, ImportacionProveedor, ImportacionReferencia, Retencion1, Retencion2, Retencion3, FechaCaducidad, ProveedorArt,
ProveedorArtCosto, Posicion, Pais, TratadoComercial, ProgramaSectorial, ValorAduana, ID1, ID2, FormaPago, ImportacionImpuesto1, ImportacionImpuesto2, EsEstadistica
)
VALUES (
@ID, @Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @AlmacenCr, @FechaRequerida, @FechaOrdenar, @FechaEntrega, @Codigo, @Articulo, @SubCuenta, @Cantidad,
@Costo, @CostoInv, @Impuesto1, @Impuesto2, @Impuesto3, @DescuentoH, @DescuentoTipo, @DescuentoLinea, @DescuentoImporte, @DescripcionExtra, @ReferenciaExtra,
@DestinoTipo, @Destino, @DestinoID, @Cliente, @Aplica, @AplicaID, @CantidadInventario, @CantidadA, @ContUso, @Unidad, @Factor, @ServicioArticulo, @ServicioSerie,
@Sucursal, @SucursalOrigen, @Paquete, @ImportacionProveedor, @ImportacionReferencia, @Retencion1, @Retencion2, @Retencion3, @FechaCaducidad, @ProveedorArt,
@ProveedorArtCosto, @Posicion, @Pais, @TratadoComercial, @ProgramaSectorial, @ValorAduana, @ID1, @ID2, @FormaPago, @ImportacionImpuesto1, @ImportacionImpuesto2, @EsEstadistica
)
UPDATE @TablaComprar SET Procesado = 1
WHERE Almacen = @AlmacenCr AND Proveedor = @ProveedorCr
FETCH NEXT FROM crTablaComprarTMP INTO @AlmacenCr, @ProveedorCr, @Articulo, @SubCuenta, @Cantidad
END
CLOSE crTablaComprarTMP
DEALLOCATE crTablaComprarTMP
SET @Modulo = 'COMS'
SET @Accion = 'AFECTAR'
SET @Base = 'Todo'
SET @Observacion = ''
EXECUTE spAfectar @Modulo, @ID, @Accion, @Base, @GenerarMov, @Usuario, @SincroFinal, @EnSilencio, @Ok OUTPUT, @OkRef OUTPUT, @FechaRegistro, @Conexion, @Estacion
IF ISNULL(@Ok,0) > 0
BEGIN
SELECT @Observacion = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SET @Observacion = @Observacion + ' (' + LTRIM(RTRIM(ISNULL(@OkRef,''))) + ')'
END
SET @Ok = NULL
INSERT INTO PlanArtMaxMinLog (
Empresa, Sucursal, Usuario, Estacion, Corrida, Almacen, AlmacenDestino, Reservar, InvID, InvMov, InvMovId, Estatus, FechaLog, Observacion)
VALUES (
@Empresa, @SucursalLog, @Usuario, @Estacion, @Corrida, @Almacen, @AlmacenDestino, @MovReservar, @ID, @Mov, @MovIdLog, @EstatusLog, GETDATE(), @Observacion)
SET @GeneradosComprar = @GeneradosComprar + 1
SELECT @idx = MIN(IDR) FROM @TablaComprar WHERE Procesado = 0
SET @idx = ISNULL (@idx,0)
END
INSERT INTO PlanArtMaxMinHist (
ID, Empresa, Sucursal, Usuario, Estacion, Corrida, Grupo, Categoria, Familia, Linea, Fabricante, Proveedor, Nombre, Almacen, AlmacenNombre, Articulo,
SubCuenta, Descripcion1, Descripcion2, NombreCorto, Unidad, ABC, Maximo, Minimo, VentaPromedio, Precio, ImporteTotal, Existencia, EnCompra, PorRecibir,
PorEntregar, Disponible, DiasInvInicio, AlmacenD, AlmacenNombreD, MaximoD, MinimoD, VentaPromedioD, ExistenciaD, EnCompraD, PorRecibirD, PorEntregarD,
DisponibleD, DiasInvD, Solicitar, Cantidad, CantidadA, DiasInvFin, Tipo, Movimiento, Aplicar
)
SELECT
a.ID, a.Empresa, a.Sucursal, a.Usuario, a.Estacion, @Corrida, a.Grupo, a.Categoria, a.Familia, a.Linea, a.Fabricante, a.Proveedor, a.Nombre, a.Almacen, a.AlmacenNombre, a.Articulo,
a.SubCuenta, a.Descripcion1, a.Descripcion2, a.NombreCorto, a.Unidad, a.ABC, a.Maximo, a.Minimo, a.VentaPromedio, a.Precio, a.ImporteTotal, a.Existencia, a.EnCompra, a.PorRecibir,
a.PorEntregar, a.Disponible, a.DiasInvInicio, a.AlmacenD, a.AlmacenNombreD, a.MaximoD, a.MinimoD, a.VentaPromedioD, a.ExistenciaD, a.EnCompraD, a.PorRecibirD, a.PorEntregarD,
a.DisponibleD, a.DiasInvD, a.Solicitar, a.Cantidad, a.CantidadA, a.DiasInvFin, a.Tipo, a.Movimiento, a.Aplicar
FROM PlanArtMaxMin a
JOIN @TablaComprar b ON a.ID = b.ID
WHERE b.Procesado = 1
DELETE a FROM PlanArtMaxMin AS a INNER JOIN @TablaComprar b ON (a.ID = b.ID)
SET @Mensaje = CAST((@GeneradosDistribuir + @GeneradosComprar) AS varchar) + ' movimientos generados'
END TRY
BEGIN CATCH
SET @Mensaje = ERROR_MESSAGE()
END CATCH
SELECT @Mensaje AS Mensaje
END

