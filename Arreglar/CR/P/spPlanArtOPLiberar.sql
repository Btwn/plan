SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPlanArtOPLiberar
@Sucursal		int,
@Empresa		char(5),
@Usuario		char(10),
@Referencia		varchar(50) = NULL,
@ReferenciaModulo	varchar(5)  = NULL,
@ReferenciaActividad	varchar(5)  = NULL

AS BEGIN
DECLARE
@Conteo			int,
@Modulo			char(5),
@Accion			char(20),
@Estatus			char(15),
@ProdMov			char(20),
@CompraMov			char(20),
@OrdenTransferencia 	char(20),
@OrdenTraspaso		char(20),
@ID				int,
@Mov			char(20),
@MovID			varchar(20),
@Renglon			float,
@RenglonID			int,
@RenglonTipo		char(1),
@Articulo			char(20),
@SubCuenta			varchar(50),
@Almacen			char(10),
@SucursalDestino		int,
@AlmacenDestino		char(10),
@FechaRegistro		datetime,
@FechaEmision		datetime,
@FechaEntrega		datetime,
@FechaEntregaEncabezado	datetime,
@MovMoneda			char(10),
@MovTipoCambio		float,
@MovZonaImpuesto		varchar(30),
@Cantidad			float,
@CantidadInventario		float,
@CantidadOrden		float,
@Unidad			varchar(50),
@Ruta			varchar(20),
@Proveedor			char(10),
@ArtTipo			char(20),
@ArtImpuesto1		float,
@ArtImpuesto2		float,
@ArtImpuesto3		money,
@ArtRetencion1		float,
@ArtRetencion2		float,
@ArtRetencion3		float,
@Moneda			char(10),
@TipoCambio			float,
@AutoReservar		bit,
@IDGenerar			int,
@ContID			int,
@Ok				int,
@OkRef			varchar(255),
@VolverAfectar		int,
@UltProv			char(10),
@UltRuta			varchar(20),
@UltAlmacen			char(10),
@UltAlmacenDestino		char(10),
@AfectarOrdenesDistribucion bit,
@CfgCompraCostoSugerido  	char(20),
@CfgMultiUnidades		bit,
@CfgMultiUnidadesNivel	char(20),
@PlanLiberarCompra		char(30),
@PlanLiberarProduccion	char(30),
@PlanLiberarDistribucion	char(30),
@PlanUnidadDistribucion	varchar(20),
@Costo			money,
@PlanEditarOrdenes		bit,
@CompraMultiAlmacen		bit,
@CfgBackOrders		bit,
@VerDestino			bit,
@VentaID			int,
@VentaMov			varchar(20),
@VentaMovID			varchar(20),
@InvID			int,
@InvMov			varchar(20),
@InvMovID			varchar(20),
@DestinoTipo		varchar(10),
@Destino			varchar(20),
@DestinoID			varchar(20),
@ReferenciaProyecto		varchar(50),
@PrecioListaProv varchar(50)
SELECT @FechaRegistro    = GETDATE(), @Conteo = 0, @AutoReservar = 0, @Ok = NULL, @OkRef = NULL, @PlanEditarOrdenes = 0, @VerDestino = 0,
@Referencia       = NULLIF(NULLIF(NULLIF(RTRIM(@Referencia), '(Todos)'), ''), '0'),
@ReferenciaModulo = NULLIF(NULLIF(NULLIF(RTRIM(@ReferenciaModulo), '(Todos)'), ''), '0')
SELECT @FechaEmision = @FechaRegistro
EXEC spExtraerFecha @FechaEmision OUTPUT
SELECT @ProdMov            = ProdOrdenProduccion,
@CompraMov          = CompraOrden,
@OrdenTransferencia = InvOrdenTransferencia,
@OrdenTraspaso      = InvOrdenTraspaso
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
IF (SELECT ISNULL(PlanEditarOrdenes, 0) FROM UsuarioCfg2 WHERE Usuario = @Usuario) = 1
SELECT @ProdMov            = ISNULL(NULLIF(RTRIM(PlanOrdenProduccion), ''), @ProdMov),
@CompraMov          = ISNULL(NULLIF(RTRIM(PlanOrdenCompra), ''), @CompraMov),
@OrdenTransferencia = ISNULL(NULLIF(RTRIM(PlanOrdenTransferencia), ''), @OrdenTransferencia),
@OrdenTraspaso      = ISNULL(NULLIF(RTRIM(PlanOrdenTraspaso), ''), @OrdenTraspaso)
FROM UsuarioCfg2
WHERE Usuario = @Usuario
SELECT @Moneda = m.Moneda,
@TipoCambio = m.TipoCambio,
@CfgCompraCostoSugerido = cfg.CompraCostoSugerido,
@CfgBackOrders	= cfg.BackOrders
FROM EmpresaCfg cfg, Mon m
WHERE Empresa = @Empresa AND m.Moneda = cfg.ContMoneda
SELECT @AutoReservar 		     = ProdAutoReservar,
@AfectarOrdenesDistribucion = PlanAfectarOrdenesDistribucion,
@CfgMultiUnidades           = MultiUnidades,
@CfgMultiUnidadesNivel      = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD'),
@PlanLiberarCompra	     = ISNULL(UPPER(PlanLiberarCompra),	'ORDEN POR PROVEEDOR'),
@PlanLiberarProduccion	     = ISNULL(UPPER(PlanLiberarProduccion), 'ORDEN POR SELECCION'),
@PlanLiberarDistribucion    = ISNULL(UPPER(PlanLiberarDistribucion), 'ORDEN POR ALMACEN'),
@PlanUnidadDistribucion     = ISNULL(UPPER(PlanUnidadDistribucion), 'COMPRA/PRODUCCION'),
@CompraMultiAlmacen	     = CompraMultiAlmacen
FROM EmpresaCfg2
WHERE Empresa = @Empresa
IF @Referencia IS NOT NULL
BEGIN
IF @ReferenciaModulo = 'VTAS'
BEGIN
SELECT @VentaID = MAX(ID) FROM Venta WHERE Empresa = @Empresa AND @Referencia = RTRIM(Mov)+' '+RTRIM(MovID) AND Estatus = 'PENDIENTE'
IF @VentaID IS NOT NULL
BEGIN
SELECT @VerDestino = @CfgBackOrders
SELECT @VentaMov = Mov, @VentaMovID = MovID FROM Venta WHERE ID = @VentaID
END
END ELSE
IF @ReferenciaModulo = 'INV'
BEGIN
SELECT @InvID = MAX(ID) FROM Inv WHERE Empresa = @Empresa AND @Referencia = RTRIM(Mov)+' '+RTRIM(MovID) AND Estatus = 'PENDIENTE'
IF @InvID IS NOT NULL
BEGIN
SELECT @VerDestino = @CfgBackOrders
SELECT @InvMov = Mov, @InvMovID = MovID FROM Inv WHERE ID = @InvID
END
END
END
BEGIN TRANSACTION
/********** Orden Produccion **********/
SELECT @Mov = @ProdMov, @ID = NULL, @Modulo = 'PROD', @UltRuta = NULL, @Accion = 'CONSECUTIVO', @Estatus = 'CONFIRMAR'
IF @PlanLiberarProduccion = 'ORDEN POR RUTA'
DECLARE crLiberarProd CURSOR FOR
SELECT NULLIF(p.Sucursal, @Sucursal), p.Articulo, NULLIF(RTRIM(p.SubCuenta), ''), NULLIF(RTRIM(p.Almacen), ''), p.FechaEntrega, ISNULL(p.Cantidad, 0.0), a.UnidadCompra, NULLIF(RTRIM(p.Ruta), ''), a.Tipo
FROM PlanArtOP p, Art a
WHERE p.Articulo = a.Articulo AND p.Empresa = @Empresa AND UPPER(p.Estado) = 'LIBERADO' AND UPPER(p.Accion) = 'PRODUCIR' AND p.LiberacionID IS NULL AND ISNULL(p.Cantidad, 0.0) > 0.0
ORDER BY p.Ruta, p.FechaLiberacion, p.Articulo, p.SubCuenta, p.Almacen, p.Cantidad
ELSE
DECLARE crLiberarProd CURSOR FOR
SELECT NULLIF(p.Sucursal, @Sucursal), p.Articulo, NULLIF(RTRIM(p.SubCuenta), ''), NULLIF(RTRIM(p.Almacen), ''), p.FechaEntrega, ISNULL(p.Cantidad, 0.0), a.UnidadCompra, NULLIF(RTRIM(p.Ruta), ''), a.Tipo
FROM PlanArtOP p, Art a
WHERE p.Articulo = a.Articulo AND p.Empresa = @Empresa AND UPPER(p.Estado) = 'LIBERADO' AND UPPER(p.Accion) = 'PRODUCIR' AND p.LiberacionID IS NULL AND ISNULL(p.Cantidad, 0.0) > 0.0
ORDER BY p.FechaLiberacion, p.Articulo, p.SubCuenta, p.Ruta, p.Almacen, p.Cantidad
OPEN crLiberarProd
FETCH NEXT FROM crLiberarProd INTO @SucursalDestino, @Articulo, @SubCuenta, @Almacen, @FechaEntrega, @Cantidad, @Unidad, @Ruta, @ArtTipo
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @ID IS NULL OR (@UltRuta <> @Ruta AND @PlanLiberarProduccion = 'ORDEN POR RUTA') OR @PlanLiberarProduccion = 'ORDEN POR RENGLON'
BEGIN
IF @Almacen IS NULL SELECT @Ok = 20820, @OkRef = @Articulo
IF @ID IS NOT NULL
BEGIN
SELECT @FechaEntregaEncabezado = MIN(FechaRequerida) FROM ProdD WHERE ID = @ID
UPDATE Prod SET RenglonID = @RenglonID, FechaEntrega = @FechaEntregaEncabezado WHERE ID = @ID
EXEC spInv @ID, @Modulo, @Accion, 'TODO', @FechaRegistro, @Mov, @Usuario, 1, 0, NULL,
@Mov, @MovID OUTPUT, @IDGenerar, @ContID, @Ok, @OkRef, @VolverAfectar
IF @Ok = 80060 SELECT @Ok = NULL, @OkRef = NULL
UPDATE PlanArtOP
SET LiberacionModulo = @Modulo,
LiberacionID     = @ID,
LiberacionMov    = @Mov,
LiberacionMovID  = @MovID
WHERE Empresa = @Empresa AND UPPER(Estado) = 'LIBERADO' AND UPPER(Accion) = 'PRODUCIR' AND LiberacionID IS NULL
END
IF @ReferenciaModulo = 'PROY' SET @ReferenciaProyecto = @Referencia
INSERT Prod (Sucursal, SucursalDestino, OrigenTipo, Empresa,  Usuario,  Estatus,  Mov,  FechaEmision,  Moneda,  TipoCambio,  Almacen,  Prioridad, AutoReservar,  Referencia,  VerDestino, Proyecto,             Actividad)
SELECT      @Sucursal, @SucursalDestino, 'PLAN',    @Empresa, @Usuario, @Estatus, @Mov, @FechaEmision, @Moneda, @TipoCambio, @Almacen, 'Normal',  @AutoReservar, @Referencia, @VerDestino, @ReferenciaProyecto, @ReferenciaActividad
SELECT @ID = SCOPE_IDENTITY(), @Renglon = 0.0, @RenglonID = 0, @Conteo = @Conteo + 1
SELECT @UltRuta = @Ruta
IF @VentaID IS NOT NULL
EXEC xpSetVentaProdID @VentaID, @ID
END
EXEC xpCantidadInventario @Articulo, @SubCuenta, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
EXEC spRenglonTipo @ArtTipo, @SubCuenta, @RenglonTipo OUTPUT
SELECT @Renglon = @Renglon + 2048.0, @RenglonID = @RenglonID + 1
SELECT @CantidadOrden = ROUND(@Cantidad / (@CantidadInventario / @Cantidad), 4), @CantidadInventario = @Cantidad
SELECT @DestinoTipo = NULL, @Destino = NULL, @DestinoID = NULL
IF @VerDestino = 1
BEGIN
IF @ReferenciaModulo = 'VTAS'
IF (SELECT ISNULL(SUM(CantidadPendiente), 0) FROM VentaD WHERE ID = @VentaID AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')) >= @CantidadOrden
SELECT @DestinoTipo = 'VTAS', @Destino = @VentaMov, @DestinoID = @VentaMovID
IF @ReferenciaModulo = 'INV'
IF (SELECT ISNULL(SUM(CantidadPendiente), 0) FROM InvD WHERE ID = @InvID AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')) >= @CantidadOrden
SELECT @DestinoTipo = 'INV', @Destino = @InvMov, @DestinoID = @InvMovID
END
INSERT ProdD (Sucursal,  ID,  Renglon,  RenglonSub, RenglonID,  RenglonTipo,  Articulo,  SubCuenta,  Almacen,  Cantidad,        Unidad,  CantidadInventario, Ruta,  FechaRequerida, DestinoTipo,  Destino,  DestinoID)
VALUES (@Sucursal, @ID, @Renglon, 0,          @RenglonID, @RenglonTipo, @Articulo, @SubCuenta, @Almacen, @CantidadOrden, @Unidad, @CantidadInventario, @Ruta, @FechaEntrega,  @DestinoTipo, @Destino, @DestinoID)
EXEC xpPlanArtOPLiberar @Empresa, @Sucursal, @Usuario, @Modulo, @ID, @Moneda, @Renglon, 0, @Articulo, @SubCuenta, @Almacen, @Cantidad, @Unidad, @CantidadInventario, @Ruta, @FechaEntrega, @Ok OUTPUT, @OkRef OUTPUT
END
FETCH NEXT FROM crLiberarProd INTO @SucursalDestino, @Articulo, @SubCuenta, @Almacen, @FechaEntrega, @Cantidad, @Unidad, @Ruta, @ArtTipo
END
CLOSE crLiberarProd
DEALLOCATE crLiberarProd
IF @ID IS NOT NULL
BEGIN
SELECT @FechaEntregaEncabezado = MIN(FechaRequerida) FROM ProdD WHERE ID = @ID
IF @VerDestino = 1
IF NOT EXISTS(SELECT * FROM ProdD WHERE ID = @ID AND DestinoTipo IS NOT NULL)
UPDATE Prod SET VerDestino = 0 WHERE ID = @ID
UPDATE Prod SET RenglonID = @RenglonID, FechaEntrega = @FechaEntregaEncabezado WHERE ID = @ID
EXEC spInv @ID, @Modulo, @Accion, 'TODO', @FechaRegistro, @Mov, @Usuario, 1, 0, NULL,
@Mov, @MovID OUTPUT, @IDGenerar, @ContID, @Ok, @OkRef, @VolverAfectar
IF @Ok = 80060 SELECT @Ok = NULL, @OkRef = NULL
UPDATE PlanArtOP
SET LiberacionModulo = @Modulo,
LiberacionID     = @ID,
LiberacionMov    = @Mov,
LiberacionMovID  = @MovID
WHERE Empresa = @Empresa AND UPPER(Estado) = 'LIBERADO' AND UPPER(Accion) = 'PRODUCIR' AND LiberacionID IS NULL
END
/********** Ordenes Compra **********/
SELECT @Mov = @CompraMov, @ID = NULL, @UltAlmacen = NULL, @Modulo = 'COMS', @UltProv = NULL, @Accion = 'CONSECUTIVO', @Estatus = 'CONFIRMAR'
DECLARE crLiberarProd CURSOR FOR
SELECT NULLIF(p.Sucursal, @Sucursal), p.Articulo, NULLIF(RTRIM(p.SubCuenta), ''), NULLIF(RTRIM(p.Almacen), ''), p.FechaEntrega, ISNULL(p.Cantidad, 0.0), a.UnidadCompra, NULLIF(RTRIM(p.Proveedor), ''), a.Tipo, a.Impuesto1, a.Impuesto2, a.Impuesto3, a.Retencion1, a.Retencion2, a.Retencion3
FROM PlanArtOP p, Art a
WHERE p.Articulo = a.Articulo AND p.Empresa = @Empresa AND UPPER(p.Estado) = 'LIBERADO' AND UPPER(p.Accion) = 'COMPRAR' AND p.LiberacionID IS NULL AND ISNULL(p.Cantidad, 0.0) > 0.0
ORDER BY p.Proveedor, p.Almacen, p.FechaLiberacion, p.Articulo, p.SubCuenta, p.Cantidad
OPEN crLiberarProd
FETCH NEXT FROM crLiberarProd INTO @SucursalDestino, @Articulo, @SubCuenta, @Almacen, @FechaEntrega, @Cantidad, @Unidad, @Proveedor, @ArtTipo, @ArtImpuesto1, @ArtImpuesto2, @ArtImpuesto3, @ArtRetencion1, @ArtRetencion2, @ArtRetencion3
WHILE @@FETCH_STATUS <> -1
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
UPDATE PlanArtOP
SET LiberacionModulo = @Modulo,
LiberacionID     = @ID,
LiberacionMov    = @Mov,
LiberacionMovID  = @MovID
WHERE Empresa = @Empresa AND UPPER(Estado) = 'LIBERADO' AND UPPER(Accion) = 'COMPRAR' AND LiberacionID IS NULL AND NULLIF(RTRIM(Proveedor), '') = @UltProv
END
IF @ReferenciaModulo = 'PROY' SET @ReferenciaProyecto = @Referencia
INSERT Compra (Sucursal,  OrigenTipo, Empresa,  Usuario,  Estatus,  Mov,  FechaEmision,  Moneda,  TipoCambio,   Proveedor,  Almacen,  Prioridad, Referencia,  VerDestino,  FechaRequerida, Proyecto,            Actividad)
VALUES (@Sucursal, 'PLAN',     @Empresa, @Usuario, @Estatus, @Mov, @FechaEmision, @Moneda, @TipoCambio, @Proveedor, @Almacen, 'Normal',   @Referencia, @VerDestino, @FechaEntrega,  @ReferenciaProyecto, @ReferenciaActividad)
SELECT @ID = SCOPE_IDENTITY(), @Renglon = 0.0, @RenglonID = 0, @Conteo = @Conteo + 1
IF @Proveedor IS NOT NULL
UPDATE Compra
SET Proyecto 	= ISNULL(Compra.Proyecto,p.Proyecto),
FormaEnvio 	= p.FormaEnvio,
Agente	= p.Agente,
Condicion	= p.Condicion,
ZonaImpuesto	= p.ZonaImpuesto,
Idioma 	= p.Idioma,
Moneda       = m.Moneda,
TipoCambio	= m.TipoCambio
FROM Compra, Prov p, Mon m
WHERE Compra.ID = @ID AND p.Proveedor = @Proveedor AND m.Moneda = ISNULL(p.DefMoneda, @Moneda)
SELECT @MovMoneda = Moneda, @MovTipoCambio = TipoCambio, @MovZonaImpuesto = ZonaImpuesto FROM Compra WHERE ID = @ID
SELECT @UltProv = @Proveedor, @UltAlmacen = @Almacen
END
EXEC xpCantidadInventario @Articulo, @SubCuenta, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
EXEC spRenglonTipo @ArtTipo, @SubCuenta, @RenglonTipo OUTPUT
EXEC spZonaImp @MovZonaImpuesto, @ArtImpuesto1 OUTPUT
EXEC spZonaImp @MovZonaImpuesto, @ArtImpuesto2 OUTPUT
EXEC spZonaImp @MovZonaImpuesto, @ArtImpuesto3 OUTPUT
EXEC spTipoImpuesto @Modulo, @ID, @Mov, @FechaEmision, @Empresa, @Sucursal, @Contacto = @Proveedor, @Articulo = @Articulo, @EnSilencio = 1, @Impuesto1 = @ArtImpuesto1 OUTPUT, @Impuesto2 = @ArtImpuesto2 OUTPUT, @Impuesto3 = @ArtImpuesto3 OUTPUT
SELECT @Renglon = @Renglon + 2048.0, @RenglonID = @RenglonID + 1
SELECT @CantidadOrden = ROUND(@Cantidad / (@CantidadInventario / @Cantidad), 4), @CantidadInventario = @Cantidad
EXEC spVerCosto @Sucursal, @Empresa, @Proveedor, @Articulo, @SubCuenta, @Unidad, @CfgCompraCostoSugerido, @MovMoneda, @MovTipoCambio, @Costo OUTPUT, 0
SELECT @PrecioListaProv=ListaPreciosEsp FROM Prov WHERE Proveedor=@Proveedor
IF ISNULL(@PrecioListaProv,'')<>''
BEGIN
SET @Costo = NULL
EXEC spPrecioEsp @PrecioListaProv, @Moneda, @Articulo, @SubCuenta, @Costo OUTPUT, @Unidad = @Unidad
SET @PrecioListaProv = NULL
END
SELECT @DestinoTipo = NULL, @Destino = NULL, @DestinoID = NULL
IF @VerDestino = 1
BEGIN
IF @ReferenciaModulo = 'VTAS'
IF (SELECT ISNULL(SUM(CantidadPendiente), 0) FROM VentaD WHERE ID = @VentaID AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')) >= @CantidadOrden
SELECT @DestinoTipo = 'VTAS', @Destino = @VentaMov, @DestinoID = @VentaMovID
IF @ReferenciaModulo = 'INV'
IF (SELECT ISNULL(SUM(CantidadPendiente), 0) FROM InvD WHERE ID = @InvID AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')) >= @CantidadOrden
SELECT @DestinoTipo = 'INV', @Destino = @InvMov, @DestinoID = @InvMovID
END
INSERT CompraD (Sucursal, ID, Renglon,   RenglonSub, RenglonID,  RenglonTipo,  Articulo,  SubCuenta,   Almacen,  Cantidad,       Unidad,  CantidadInventario,  Costo,  FechaEntrega,  FechaRequerida, Impuesto1,     Impuesto2,     Impuesto3,     Retencion1,     Retencion2,     Retencion3,     DestinoTipo,  Destino,  DestinoID)
VALUES (@Sucursal, @ID, @Renglon, 0,          @RenglonID, @RenglonTipo, @Articulo, @SubCuenta, @Almacen, @CantidadOrden, @Unidad, @CantidadInventario, @Costo, @FechaEntrega, @FechaEntrega,  @ArtImpuesto1, @ArtImpuesto2, @ArtImpuesto3, @ArtRetencion1, @ArtRetencion2, @ArtRetencion3, @DestinoTipo, @Destino, @DestinoID)
EXEC xpPlanArtOPLiberar @Empresa, @Sucursal, @Usuario, @Modulo, @ID, @Moneda, @Renglon, 0, @Articulo, @SubCuenta, @Almacen, @Cantidad, @Unidad, @CantidadInventario, @Proveedor, @FechaEntrega, @Ok OUTPUT, @OkRef OUTPUT
END
FETCH NEXT FROM crLiberarProd INTO @SucursalDestino, @Articulo, @SubCuenta, @Almacen, @FechaEntrega, @Cantidad, @Unidad, @Proveedor, @ArtTipo, @ArtImpuesto1, @ArtImpuesto2, @ArtImpuesto3, @ArtRetencion1, @ArtRetencion2, @ArtRetencion3
END
CLOSE crLiberarProd
DEALLOCATE crLiberarProd
IF @ID IS NOT NULL
BEGIN
IF @VerDestino = 1
IF NOT EXISTS(SELECT * FROM CompraD WHERE ID = @ID AND DestinoTipo IS NOT NULL)
UPDATE Compra SET VerDestino = 0 WHERE ID = @ID
UPDATE Compra SET RenglonID = @RenglonID WHERE ID = @ID
EXEC spInv @ID, @Modulo, @Accion, 'TODO', @FechaRegistro, @Mov, @Usuario, 1, 0, NULL,
@Mov, @MovID OUTPUT, @IDGenerar, @ContID, @Ok, @OkRef, @VolverAfectar
IF @Ok = 80060 SELECT @Ok = NULL, @OkRef = NULL
UPDATE PlanArtOP
SET LiberacionModulo = @Modulo,
LiberacionID     = @ID,
LiberacionMov    = @Mov,
LiberacionMovID  = @MovID
WHERE Empresa = @Empresa AND UPPER(Estado) = 'LIBERADO' AND UPPER(Accion) = 'COMPRAR' AND LiberacionID IS NULL AND NULLIF(RTRIM(Proveedor), '') = @UltProv
END
/********** Ordenes Distribucion **********/
SELECT @ID = NULL, @UltAlmacen = NULL, @UltAlmacenDestino = NULL, @Modulo = 'INV'
IF @AfectarOrdenesDistribucion = 1
SELECT @Accion = 'AFECTAR', @Estatus = 'SINAFECTAR'
ELSE SELECT @Accion = 'CONSECUTIVO', @Estatus = 'CONFIRMAR'
DECLARE crLiberarProd CURSOR FOR
SELECT NULLIF(p.Sucursal, @Sucursal), p.Articulo, NULLIF(RTRIM(p.SubCuenta), ''), NULLIF(RTRIM(p.Almacen), ''), NULLIF(RTRIM(p.AlmacenDestino), ''), p.FechaEntrega, ISNULL(p.Cantidad, 0.0), CASE @PlanUnidadDistribucion WHEN 'VENTA' THEN a.Unidad WHEN 'TRASPASO' THEN ISNULL(a.UnidadTraspaso, a.UnidadCompra) ELSE a.UnidadCompra END, a.Tipo
FROM PlanArtOP p, Art a
WHERE p.Articulo = a.Articulo AND p.Empresa = @Empresa AND UPPER(p.Estado) = 'LIBERADO' AND UPPER(p.Accion) = 'DISTRIBUIR' AND p.LiberacionID IS NULL AND ISNULL(p.Cantidad, 0.0) > 0.0
ORDER BY p.Almacen, p.AlmacenDestino, p.FechaLiberacion, a.Categoria, a.Familia, p.Articulo, p.SubCuenta, p.Cantidad
OPEN crLiberarProd
FETCH NEXT FROM crLiberarProd INTO @SucursalDestino, @Articulo, @SubCuenta, @Almacen, @AlmacenDestino, @FechaEntrega, @Cantidad, @Unidad, @ArtTipo
WHILE @@FETCH_STATUS <> -1
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
EXEC spInv @ID, @Modulo, @Accion, 'TODO', @FechaRegistro, @Mov, @Usuario, 1, 0, NULL,
@Mov, @MovID OUTPUT, @IDGenerar, @ContID, @Ok, @OkRef, @VolverAfectar
IF @Ok = 80060 SELECT @Ok = NULL, @OkRef = NULL
IF @Accion = 'AFECTAR'
DELETE PlanArtOP
WHERE Empresa = @Empresa AND UPPER(Estado) = 'LIBERADO' AND UPPER(Accion) = 'DISTRIBUIR' AND LiberacionID IS NULL AND NULLIF(RTRIM(Almacen), '') = @UltAlmacen AND NULLIF(RTRIM(AlmacenDestino), '') = @UltAlmacenDestino
ELSE
UPDATE PlanArtOP
SET LiberacionModulo = @Modulo,
LiberacionID     = @ID,
LiberacionMov    = @Mov,
LiberacionMovID  = @MovID
WHERE Empresa = @Empresa AND UPPER(Estado) = 'LIBERADO' AND UPPER(Accion) = 'DISTRIBUIR' AND LiberacionID IS NULL AND NULLIF(RTRIM(Almacen), '') = @UltAlmacen AND NULLIF(RTRIM(AlmacenDestino), '') = @UltAlmacenDestino
END
IF (SELECT Sucursal FROM Alm WHERE Almacen = @Almacen) <> (SELECT Sucursal FROM Alm WHERE Almacen = @AlmacenDestino)
SELECT @Mov = @OrdenTraspaso
ELSE
SELECT @Mov = @OrdenTransferencia
IF @ReferenciaModulo = 'PROY' SET @ReferenciaProyecto = @Referencia
INSERT Inv (Sucursal,  OrigenTipo, Empresa,  Usuario,  Estatus,  Mov,  FechaEmision,  Moneda,  TipoCambio,  Almacen,  AlmacenDestino,  Prioridad, Referencia, FechaRequerida, Proyecto,            Actividad)
SELECT      @Sucursal, 'PLAN',     @Empresa, @Usuario, @Estatus, @Mov, @FechaEmision, @Moneda, @TipoCambio, @Almacen, @AlmacenDestino, 'Normal', @Referencia, @FechaEntrega,  @ReferenciaProyecto, @ReferenciaActividad
SELECT @ID = SCOPE_IDENTITY(), @Renglon = 0.0, @RenglonID = 0, @Conteo = @Conteo + 1
SELECT @UltAlmacen = @Almacen, @UltAlmacenDestino = @AlmacenDestino
END
EXEC xpCantidadInventario @Articulo, @SubCuenta, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
EXEC spRenglonTipo @ArtTipo, @SubCuenta, @RenglonTipo OUTPUT
SELECT @Renglon = @Renglon + 2048.0, @RenglonID = @RenglonID + 1
SELECT @CantidadOrden = ROUND(@Cantidad / (@CantidadInventario / @Cantidad), 4), @CantidadInventario = @Cantidad
EXEC spVerCosto @Sucursal, @Empresa, @Proveedor, @Articulo, @SubCuenta, @Unidad, @CfgCompraCostoSugerido, @MovMoneda, @MovTipoCambio, @Costo OUTPUT, 0
INSERT InvD (Sucursal,  ID,  Renglon,  RenglonSub, RenglonID,  RenglonTipo,  Articulo,  SubCuenta,  Almacen,  Cantidad,       Unidad,  CantidadInventario, FechaRequerida, Costo)
VALUES (@Sucursal, @ID, @Renglon, 0,          @RenglonID, @RenglonTipo, @Articulo, @SubCuenta, @Almacen, @CantidadOrden, @Unidad, @CantidadInventario, @FechaEntrega, @Costo)
EXEC xpPlanArtOPLiberar @Empresa, @Sucursal, @Usuario, @Modulo, @ID, @Moneda, @Renglon, 0, @Articulo, @SubCuenta, @Almacen, @CantidadOrden, @Unidad, @CantidadInventario, @AlmacenDestino, @FechaEntrega, @Ok OUTPUT, @OkRef OUTPUT
END
FETCH NEXT FROM crLiberarProd INTO @SucursalDestino, @Articulo, @SubCuenta, @Almacen, @AlmacenDestino, @FechaEntrega, @Cantidad, @Unidad, @ArtTipo
END
CLOSE crLiberarProd
DEALLOCATE crLiberarProd
IF @ID IS NOT NULL
BEGIN
UPDATE Inv SET RenglonID = @RenglonID WHERE ID = @ID
EXEC spInv @ID, @Modulo, @Accion, 'TODO', @FechaRegistro, @Mov, @Usuario, 1, 0, NULL,
@Mov, @MovID OUTPUT, @IDGenerar, @ContID, @Ok, @OkRef, @VolverAfectar
IF @Ok = 80060 SELECT @Ok = NULL, @OkRef = NULL
IF @Accion = 'AFECTAR'
DELETE PlanArtOP
WHERE Empresa = @Empresa AND UPPER(Estado) = 'LIBERADO' AND UPPER(Accion) = 'DISTRIBUIR' AND LiberacionID IS NULL AND NULLIF(RTRIM(Almacen), '') = @UltAlmacen AND NULLIF(RTRIM(AlmacenDestino), '') = @UltAlmacenDestino
ELSE
UPDATE PlanArtOP
SET LiberacionModulo = @Modulo,
LiberacionID     = @ID,
LiberacionMov    = @Mov,
LiberacionMovID  = @MovID
WHERE Empresa = @Empresa AND UPPER(Estado) = 'LIBERADO' AND UPPER(Accion) = 'DISTRIBUIR' AND LiberacionID IS NULL AND NULLIF(RTRIM(Almacen), '') = @UltAlmacen AND NULLIF(RTRIM(AlmacenDestino), '') = @UltAlmacenDestino
END
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
IF @Conteo = 1
SELECT 'Se generó con éxito '+LTRIM(CONVERT(char, @Conteo))+' Orden'
ELSE
SELECT 'Se generaron con éxito '+LTRIM(CONVERT(char, @Conteo))+' Ordenes'
END ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT RTRIM(Descripcion)+' '+RTRIM(@OkRef) FROM MensajeLista WHERE Mensaje = @Ok
END
RETURN
END

