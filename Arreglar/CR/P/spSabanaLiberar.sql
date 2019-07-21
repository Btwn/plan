SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSabanaLiberar
@Sucursal               INT,
@Empresa                CHAR(5),
@Usuario                CHAR(10),
@Estacion               INT,
@Tipo                   INT

AS BEGIN
DECLARE
@Conteo            int,
@Modulo            char(5),
@Accion            char(20),
@Estatus            char(15),
@CompraMov            char(20),
@OrdenTransferencia     char(20),
@OrdenTraspaso        char(20),
@ID                int,
@Mov            char(20),
@MovID            varchar(20),
@Renglon            float,
@RenglonID            int,
@RenglonTipo        char(1),
@Articulo            char(20),
@Almacen            char(10),
@SucursalDestino        int,
@AlmacenDestino        char(10),
@FechaRegistro        datetime,
@FechaEmision        datetime,
@FechaEntrega        datetime,
@FechaEntregaEncabezado    datetime,
@MovMoneda            char(10),
@MovTipoCambio        float,
@MovZonaImpuesto        varchar(30),
@Cantidad            float,
@CantidadInventario        float,
@CantidadOrden        float,
@Unidad            varchar(50),
@Ruta            varchar(20),
@Proveedor            char(10),
@ArtTipo            char(20),
@ArtImpuesto1        float,
@ArtImpuesto2        float,
@ArtImpuesto3        money,
@ArtRetencion1        float,
@ArtRetencion2        float,
@ArtRetencion3        float,
@Moneda            char(10),
@TipoCambio            float,
@AutoReservar        bit,
@IDGenerar            int,
@ContID            int,
@Ok                int,
@OkRef            varchar(255),
@VolverAfectar        int,
@UltProv            char(10),
@UltRuta            varchar(20),
@UltAlmacen            char(10),
@UltAlmacenDestino        char(10),
@AfectarOrdenesDistribucion bit,
@CfgCompraCostoSugerido      char(20),
@CfgMultiUnidades        bit,
@CfgMultiUnidadesNivel    char(20),
@PlanLiberarCompra        char(30),
@PlanLiberarProduccion    char(30),
@PlanLiberarDistribucion    char(30),
@PlanUnidadDistribucion    varchar(20),
@Costo            money,
@PlanEditarOrdenes        bit,
@CompraMultiAlmacen        bit,
@CfgBackOrders        bit,
@VerDestino            bit,
@VentaID            int,
@VentaMov            varchar(20),
@VentaMovID            varchar(20),
@InvID            int,
@InvMov            varchar(20),
@InvMovID            varchar(20),
@DestinoTipo        varchar(10),
@Destino            varchar(20),
@DestinoID            varchar(20),
@ReferenciaProyecto        varchar(50),
@DescuentoProveedor     money,
@GandhiCategoria        varchar(50),
@CategoriaArticulo      varchar(50),
@UltCategoria           varchar(50),
@ArticuloError          varchar(20),
@ArtImpuesto1Ultimo     float,
@DescuentoProveedorUltimo  FLOAT,
@Disponible                 FLOAT,
@GandhiObservacion          VARCHAR(100),
@GandhiObservacionT          VARCHAR(100),
@GandhiFechaRequerida       DATETIME,
@GandhiPlanFechaEntrega     DATETIME,
@GandhiPlanRecepcion        VARCHAR(255),
@GandhiPlanVenta            VARCHAR(255),
@GandhiPlanProveedor        VARCHAR(255),
@GandhiPlanContabilidad     VARCHAR(255),
@MensajeGrises              VARCHAR(255),
@GandhiPlanCondicion        VARCHAR(50),
@GandhiPlanEstatus          VARCHAR(30),
@LiveTime                   DATETIME,
@TiempoE                    DATETIME
SELECT @FechaRegistro    = GETDATE(), @Conteo = 0, @AutoReservar = 0, @Ok = NULL, @OkRef = NULL, @PlanEditarOrdenes = 0, @VerDestino = 0, @MensajeGrises = ''
SELECT @FechaEmision = @FechaRegistro
EXEC spExtraerFecha @FechaEmision OUTPUT
SELECT @CompraMov          = CompraOrden,
@OrdenTransferencia = InvOrdenTransferencia,
@OrdenTraspaso      = InvOrdenTraspaso
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
IF (SELECT ISNULL(PlanEditarOrdenes, 0) FROM UsuarioCfg2 WHERE Usuario = @Usuario) = 1
SELECT @CompraMov               = ISNULL(NULLIF(RTRIM(PlanOrdenCompra), ''), @CompraMov),
@OrdenTransferencia      = ISNULL(NULLIF(RTRIM(PlanOrdenTransferencia), ''), @OrdenTransferencia),
@OrdenTraspaso           = ISNULL(NULLIF(RTRIM(PlanOrdenTraspaso), ''), @OrdenTraspaso)
FROM UsuarioCfg2
WHERE Usuario = @Usuario
SELECT @Moneda = m.Moneda,
@TipoCambio = m.TipoCambio,
@CfgCompraCostoSugerido = cfg.CompraCostoSugerido,
@CfgBackOrders    = cfg.BackOrders
FROM EmpresaCfg cfg, Mon m
WHERE Empresa = @Empresa AND m.Moneda = cfg.ContMoneda
SELECT @AutoReservar              = ProdAutoReservar,
@AfectarOrdenesDistribucion = PlanAfectarOrdenesDistribucion,
@CfgMultiUnidades           = MultiUnidades,
@CfgMultiUnidadesNivel      = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD'),
@PlanLiberarCompra         = ISNULL(UPPER(PlanLiberarCompra),    'ORDEN POR PROVEEDOR'),
@PlanLiberarProduccion         = ISNULL(UPPER(PlanLiberarProduccion), 'ORDEN POR SELECCION'),
@PlanLiberarDistribucion    = ISNULL(UPPER(PlanLiberarDistribucion), 'ORDEN POR ALMACEN'),
@PlanUnidadDistribucion     = ISNULL(UPPER(PlanUnidadDistribucion), 'COMPRA/PRODUCCION'),
@CompraMultiAlmacen         = CompraMultiAlmacen
FROM EmpresaCfg2
WHERE Empresa = @Empresa
BEGIN TRANSACTION
/********** Ordenes Compra **********/
IF @Tipo IN (1, 3)
BEGIN
SELECT @Mov = @CompraMov, @ID = NULL, @UltAlmacen = NULL, @Modulo = 'COMS', @UltProv = NULL, @Accion = 'CONSECUTIVO', @Estatus = 'CONFIRMAR'
DECLARE crLiberarProd CURSOR FOR
SELECT NULLIF(p.Sucursal, @Sucursal), p.Articulo, NULLIF(RTRIM(p.Almacen), ''), ISNULL(p.CantidadComprar, 0.0), a.UnidadCompra, NULLIF(RTRIM(p.Proveedor), ''), a.Tipo, a.Impuesto1, a.Impuesto2, a.Impuesto3, a.Retencion1, a.Retencion2, a.Retencion3
FROM SabanaD p
JOIN Art a ON p.Articulo = a.Articulo
WHERE p.Estacion = @Estacion AND ISNULL(p.CantidadComprar, 0.0) > 0.0
ORDER BY p.Proveedor, p.Almacen, p.Articulo, p.CantidadComprar
OPEN crLiberarProd
FETCH NEXT FROM crLiberarProd INTO @SucursalDestino, @Articulo, @Almacen, @Cantidad, @Unidad, @Proveedor, @ArtTipo, @ArtImpuesto1, @ArtImpuesto2, @ArtImpuesto3, @ArtRetencion1, @ArtRetencion2, @ArtRetencion3
WHILE @@FETCH_STATUS <> -1  AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @ID IS NULL OR @UltProv <> @Proveedor OR @PlanLiberarCompra = 'ORDEN POR RENGLON' OR (@UltAlmacen <> @Almacen AND @CompraMultiAlmacen = 0)
BEGIN
IF @Almacen IS NULL SELECT @Ok = 20820, @OkRef = @Articulo
IF @ID IS NOT NULL
BEGIN
UPDATE Compra SET RenglonID = @RenglonID WHERE ID = @ID
EXEC spInv @ID, @Modulo, @Accion, 'TODO', @FechaRegistro, @Mov, @Usuario, 1, 0, NULL,
@Mov, @MovID OUTPUT, @IDGenerar, @ContID, @Ok, @OkRef, @VolverAfectar
IF @Ok = 80060 SELECT @Ok = NULL, @OkRef = NULL
IF ISNULL(@GandhiPlanEstatus,'CONFIRMAR')='PENDIENTE'
BEGIN
EXEC spAfectar @Modulo, @ID, 'AFECTAR', 'TODO', NULL,@Usuario, 0, 1, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok = 80060 SELECT @Ok = NULL, @OkRef = NULL
END
END
SELECT @Moneda = ISNULL(NULLIF(DefMoneda, ''), 'Pesos') FROM Prov WHERE Proveedor = @Proveedor
SELECT @TipoCambio = TipoCambio FROM Mon WHERE Moneda = @Moneda
INSERT Compra (Sucursal,  OrigenTipo, Empresa,  Usuario,  Estatus,  Mov,  FechaEmision,  Moneda,  TipoCambio,   Proveedor, Almacen,  Prioridad,
Observaciones,      VerDestino,  FechaRequerida,         Proyecto,            Concepto)
VALUES (@Sucursal, 'PLAN',     @Empresa, @Usuario, @Estatus, @Mov, @FechaEmision, @Moneda, @TipoCambio, @Proveedor, @Almacen, 'Normal',
@GandhiObservacion, @VerDestino, @GandhiFechaRequerida,  @ReferenciaProyecto, @CategoriaArticulo)
SELECT @ID = SCOPE_IDENTITY(), @Renglon = 0.0, @RenglonID = 0, @Conteo = @Conteo + 1
IF @Proveedor IS NOT NULL
UPDATE Compra
SET Proyecto     = ISNULL(c.Proyecto,p.Proyecto),
FormaEnvio   = p.FormaEnvio,
Agente       = p.Agente,
Condicion    = ISNULL(NULLIF(@GandhiPlanCondicion, ''), p.Condicion),
ZonaImpuesto = p.ZonaImpuesto,
Idioma       = p.Idioma,
Moneda       = m.Moneda,
TipoCambio   = m.TipoCambio
FROM Compra c
JOIN Prov p ON c.Proveedor = p.Proveedor
JOIN Mon m ON c.Moneda = m.Moneda
WHERE c.ID = @ID AND p.Proveedor = @Proveedor AND m.Moneda = ISNULL(p.DefMoneda, @Moneda)
SELECT @MovMoneda = Moneda, @MovTipoCambio = TipoCambio, @MovZonaImpuesto = ZonaImpuesto FROM Compra WHERE ID = @ID
SELECT @UltProv = @Proveedor, @UltAlmacen = @Almacen
END
EXEC xpCantidadInventario @Articulo, NULL, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
EXEC spRenglonTipo @ArtTipo, NULL, @RenglonTipo OUTPUT
EXEC spZonaImp @MovZonaImpuesto, @ArtImpuesto1 OUTPUT
EXEC spZonaImp @MovZonaImpuesto, @ArtImpuesto2 OUTPUT
EXEC spZonaImp @MovZonaImpuesto, @ArtImpuesto3 OUTPUT
EXEC spTipoImpuesto @Modulo, @ID, @Mov, @FechaEmision, @Empresa, @Sucursal, @Contacto = @Proveedor, @Articulo = @Articulo, @EnSilencio = 1, @Impuesto1 = @ArtImpuesto1 OUTPUT, @Impuesto2 = @ArtImpuesto2 OUTPUT, @Impuesto3 = @ArtImpuesto3 OUTPUT
SELECT @Renglon = @Renglon + 2048.0, @RenglonID = @RenglonID + 1
SELECT @CantidadOrden = ROUND(@Cantidad / (@CantidadInventario / @Cantidad), 4), @CantidadInventario = @Cantidad
EXEC spVerCosto @Sucursal, @Empresa, @Proveedor, @Articulo, NULL, @Unidad, @CfgCompraCostoSugerido, @MovMoneda, @MovTipoCambio, @Costo OUTPUT, 0
SELECT @DestinoTipo = NULL, @Destino = NULL, @DestinoID = NULL
INSERT CompraD (Sucursal, ID, Renglon,   RenglonSub, RenglonID,  RenglonTipo,  Articulo,  SubCuenta,   Almacen,  Cantidad,       Unidad,  CantidadInventario,  Costo,  FechaEntrega,  FechaRequerida, Impuesto1,     Impuesto2,     Impuesto3,     Retencion1,     Retencion2,     Retencion3,     DestinoTipo,  Destino,  DestinoID)
VALUES (@Sucursal, @ID, @Renglon, 0,          @RenglonID, @RenglonTipo, @Articulo, NULL, @Almacen, @CantidadOrden, @Unidad, @CantidadInventario, @Costo, @FechaEntrega, @FechaEntrega,  @ArtImpuesto1, @ArtImpuesto2, @ArtImpuesto3, @ArtRetencion1, @ArtRetencion2, @ArtRetencion3, @DestinoTipo, @Destino, @DestinoID)
END
FETCH NEXT FROM crLiberarProd INTO @SucursalDestino, @Articulo, @Almacen, @Cantidad, @Unidad, @Proveedor, @ArtTipo, @ArtImpuesto1, @ArtImpuesto2, @ArtImpuesto3, @ArtRetencion1, @ArtRetencion2, @ArtRetencion3
END
CLOSE crLiberarProd
DEALLOCATE crLiberarProd
IF @ID IS NOT NULL
BEGIN
UPDATE Compra SET RenglonID = @RenglonID WHERE ID = @ID
EXEC spInv @ID, @Modulo, @Accion, 'TODO', @FechaRegistro, @Mov, @Usuario, 1, 0, NULL,
@Mov, @MovID OUTPUT, @IDGenerar, @ContID, @Ok, @OkRef, @VolverAfectar
IF @Ok = 80060 SELECT @Ok = NULL, @OkRef = NULL
IF ISNULL(@GandhiPlanEstatus,'CONFIRMAR')='PENDIENTE'
BEGIN
EXEC spAfectar @Modulo, @ID, 'AFECTAR', 'TODO', NULL,@Usuario, 0, 1, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok = 80060 SELECT @Ok = NULL, @OkRef = NULL
END
END
DELETE FROM SabanaD
WHERE Estacion = @Estacion AND ISNULL(CantidadComprar, 0.0) > 0.0 AND Traspaso = 'No'
UPDATE SabanaD SET CantidadComprar = 0 WHERE Estacion = @Estacion AND ISNULL(CantidadComprar, 0.0) > 0.0 AND Traspaso = 'Si'
END
/********** Ordenes Distribucion **********/
IF @Tipo IN (2, 3)
BEGIN
SELECT @ID = NULL, @UltAlmacen = NULL, @UltAlmacenDestino = NULL, @Modulo = 'INV'
SELECT @Accion = 'AFECTAR'
SET @Estatus = 'SINAFECTAR'
DECLARE crLiberarProd CURSOR FOR
SELECT NULLIF(p.Sucursal, @Sucursal), p.Articulo, NULLIF(RTRIM(t.Almacen), ''), NULLIF(RTRIM(t.AlmacenDestino), ''), ISNULL(t.CantidadTraspasar, 0.0), CASE @PlanUnidadDistribucion WHEN 'VENTA' THEN a.Unidad WHEN 'TRASPASO' THEN ISNULL(a.UnidadTraspaso, a.UnidadCompra) ELSE a.UnidadCompra END, a.Tipo
FROM SabanaD p
JOIN SabanaTraspaso t ON p.Estacion = t.Estacion AND p.Articulo = t.Articulo AND p.Sucursal = t.Sucursal
JOIN Art a ON p.Articulo = a.Articulo
JOIN ArtProv p2 ON p.Proveedor = p2.Proveedor AND p.Articulo = p2.Articulo
WHERE p.Estacion = @Estacion AND p.Traspaso = 'SI' AND ISNULL(t.CantidadTraspasar, 0.0) > 0.0
ORDER BY p.Almacen, t.AlmacenDestino, a.Categoria, a.Familia, p.Articulo, t.CantidadTraspasar
OPEN crLiberarProd
FETCH NEXT FROM crLiberarProd INTO @SucursalDestino, @Articulo, @Almacen, @AlmacenDestino, @Cantidad, @Unidad, @ArtTipo
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @UltAlmacen <> @Almacen OR @UltAlmacenDestino <> @AlmacenDestino OR @PlanLiberarDistribucion = 'ORDEN POR RENGLON'
BEGIN
IF @Almacen IS NULL SELECT @Ok = 20830, @OkRef = @Articulo
IF @AlmacenDestino IS NULL SELECT @Ok = 20840, @OkRef = @Articulo
IF @ID IS NOT NULL
BEGIN
UPDATE Inv SET RenglonID = @RenglonID WHERE ID = @ID
EXEC spAfectar @Modulo, @ID, 'AFECTAR', 'TODO', NULL,@Usuario, 0, 1, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok = 80060 SELECT @Ok = NULL, @OkRef = NULL
END
IF (SELECT Sucursal FROM Alm WHERE Almacen = @Almacen) <> (SELECT Sucursal FROM Alm WHERE Almacen = @AlmacenDestino)
SELECT @Mov = @OrdenTraspaso
ELSE
SELECT @Mov = @OrdenTransferencia
INSERT Inv (Sucursal,  OrigenTipo, Empresa,  Usuario,  Estatus,  Mov,  FechaEmision, FechaRequerida,                 Moneda,  TipoCambio,  Almacen,  AlmacenDestino,  Prioridad, Observaciones, Proyecto)
SELECT      @Sucursal, 'PLAN',     @Empresa, @Usuario, @Estatus, @Mov, @FechaEmision, @FechaEmision+15, @Moneda, @TipoCambio, @Almacen, @AlmacenDestino, 'Normal', 'Sabana de Compras', @ReferenciaProyecto
SELECT @ID = SCOPE_IDENTITY(), @Renglon = 0.0, @RenglonID = 0, @Conteo = @Conteo + 1
SELECT @UltAlmacen = @Almacen, @UltAlmacenDestino = @AlmacenDestino
END
SELECT @Disponible = 0
EXEC xpCantidadInventario @Articulo, NULL, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
EXEC spRenglonTipo @ArtTipo, NULL, @RenglonTipo OUTPUT
SELECT @Renglon = @Renglon + 2048.0, @RenglonID = @RenglonID + 1
SELECT @CantidadOrden = ROUND(@Cantidad / (@CantidadInventario / @Cantidad), 4), @CantidadInventario = @Cantidad
EXEC spVerCosto @Sucursal, @Empresa, @Proveedor, @Articulo, NULL, @Unidad, @CfgCompraCostoSugerido, @MovMoneda, @MovTipoCambio, @Costo OUTPUT, 0
INSERT InvD (Sucursal,  ID,  Renglon,  RenglonSub, RenglonID,  RenglonTipo,  Articulo,  SubCuenta,  Almacen,  Cantidad,       Unidad,  CantidadInventario, Costo)
VALUES (@Sucursal, @ID, @Renglon, 0,          @RenglonID, @RenglonTipo, @Articulo, NULL, @Almacen, @CantidadOrden, @Unidad, @CantidadInventario, @Costo)
UPDATE SabanaD SET Existencia = Existencia - @CantidadOrden WHERE Estacion = @Estacion AND Almacen = @Almacen AND Articulo = @Articulo
END
FETCH NEXT FROM crLiberarProd INTO @SucursalDestino, @Articulo, @Almacen, @AlmacenDestino, @Cantidad, @Unidad, @ArtTipo
END
CLOSE crLiberarProd
DEALLOCATE crLiberarProd
IF @ID IS NOT NULL
BEGIN
UPDATE Inv SET RenglonID = @RenglonID WHERE ID = @ID
IF @Ok = 80060 SELECT @Ok = NULL, @OkRef = NULL
EXEC spAfectar @Modulo, @ID, 'AFECTAR', 'TODO', NULL,@Usuario, 0, 1, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok = 80060 SELECT @Ok = NULL, @OkRef = NULL
DELETE FROM SabanaTraspaso
WHERE Estacion = @Estacion AND ISNULL(CantidadTraspasar, 0.0) > 0.0
END
END
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
IF @Conteo = 1
SELECT 'Se Genero con Exito '+LTRIM(CONVERT(char, @Conteo))+' Orden. ' + @MensajeGrises
ELSE
SELECT 'Se Generaron con Exito '+LTRIM(CONVERT(char, @Conteo))+' Ordenes. ' + @MensajeGrises
END ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT RTRIM(Descripcion)+' '+RTRIM(@OkRef) FROM MensajeLista WHERE Mensaje = @Ok
END
RETURN
END

