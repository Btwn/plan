SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSDividirPorReservado
@ModuloID       int,
@Modulo         char(5),
@Empresa        char(5),
@Articulo       char(20),
@SubCuenta      varchar(50),
@Almacen        char(10),
@Cantidad       float,
@Tarima         varchar(20),
@Usuario        varchar(10),
@Estacion       int,
@Ok             int OUTPUT,
@OkRef          varchar(255)OUTPUT

AS BEGIN
DECLARE
@ID                 int,
@Renglon            float,
@RenglonSub			int,
@Requiere			float,
@Obtenido           float,
@Pendiente          float,
@Procesado          bit,
@Unidad				varchar(50),
@Factor				float
SELECT @Requiere = @Cantidad, @SubCuenta = NULLIF(RTRIM(@SubCuenta), ''), @Procesado = 0
IF @Modulo = 'VTAS'
DECLARE crDividirPorReservado CURSOR FOR
SELECT Venta.ID, VentaD.Renglon, VentaD.RenglonSub, ISNULL(VentaD.CantidadPendiente, 0.0), VentaD.Unidad, VentaD.Factor
FROM VentaD, Venta
WHERE Venta.Estatus = 'PENDIENTE'
AND Venta.ID = @ModuloID
AND VentaD.ID = Venta.ID
AND VentaD.Almacen = @Almacen
AND VentaD.Articulo = @Articulo
AND VentaD.SubCuenta = @SubCuenta
AND NULLIF(VentaD.Tarima,'') IS NULL
AND ISNULL(VentaD.CantidadPendiente, 0.0) > 0 
ORDER BY Venta.ID, VentaD.Renglon, VentaD.RenglonSub
ELSE
IF @Modulo = 'INV'
DECLARE crDividirPorReservado CURSOR FOR
SELECT Inv.ID, InvD.Renglon, InvD.RenglonSub, ISNULL(InvD.CantidadPendiente, 0.0), InvD.Unidad, InvD.Factor
FROM InvD, Inv
WHERE Inv.Estatus = 'PENDIENTE'
AND Inv.ID = @ModuloID
AND InvD.ID = Inv.ID
AND InvD.Almacen = @Almacen
AND InvD.Articulo = @Articulo
AND InvD.SubCuenta = @SubCuenta
AND NULLIF(InvD.Tarima,'') IS NULL
AND ISNULL(InvD.CantidadPendiente, 0.0) > 0 
ORDER BY Inv.ID, InvD.Renglon, InvD.RenglonSub
ELSE
IF @Modulo = 'COMS'
DECLARE crDividirPorReservado CURSOR FOR
SELECT Compra.ID, CompraD.Renglon, CompraD.RenglonSub, ISNULL(CompraD.CantidadPendiente, 0.0), CompraD.Unidad, CompraD.Factor
FROM CompraD, Compra
WHERE Compra.Estatus = 'PENDIENTE'
AND Compra.ID = @ModuloID
AND CompraD.ID = Compra.ID
AND CompraD.Almacen = @Almacen
AND CompraD.Articulo = @Articulo
AND CompraD.SubCuenta = @SubCuenta
AND NULLIF(CompraD.Tarima,'') IS NULL
AND ISNULL(CompraD.CantidadPendiente, 0.0) > 0 
ORDER BY Compra.ID, CompraD.Renglon, CompraD.RenglonSub
OPEN crDividirPorReservado
FETCH NEXT FROM crDividirPorReservado INTO @ID, @Renglon, @RenglonSub, @Pendiente, @Unidad, @Factor
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Obtenido = @Requiere/ @Factor
IF @Modulo = 'VTAS'
BEGIN
IF (OBJECT_ID('Tempdb..#VentaDetalle')) IS NOT NULL
DROP TABLE #VentaDetalle
UPDATE VentaD SET Cantidad = Cantidad - @Obtenido, CantidadPendiente = CantidadPendiente - @Obtenido, CantidadInventario = CantidadInventario - @Requiere WHERE CURRENT OF crDividirPorReservado
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT * INTO #VentaDetalle FROM cVentaDWMS WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
IF @@ERROR <> 0 SELECT @Ok = 1
SET @RenglonSub = ISNULL(@RenglonSub, 0)
SELECT @RenglonSub = @RenglonSub + MAX(RenglonSub)+1 FROM VentaD WHERE ID = @ID AND Renglon = @Renglon
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #VentaDetalle SET Cantidad = @Obtenido, CantidadInventario = @Requiere, CantidadPendiente = @Obtenido, Almacen = @Almacen, RenglonSub = @RenglonSub, CantidadReservada = 0
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #VentaDetalle SET DescuentoImporte = (Cantidad*Costo)*(DescuentoLinea/100.0)
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #VentaDetalle SET CantidadPendiente = Cantidad, CantidadA = 0
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE VentaD SET CantidadPendiente = ISNULL(Cantidad,0), CantidadReservada = 0, CantidadA = 0 WHERE CURRENT OF crDividirPorReservado
IF @@ERROR <> 0 SELECT @Ok = 1
INSERT INTO #WMSVentaDR
SELECT * FROM #VentaDetalle
IF @@ERROR <> 0 SELECT @Ok = 1
DELETE VentaD WHERE Cantidad = 0 AND ID = @ModuloID
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE VentaD SET CantidadA = @Obtenido, CantidadReservada = 0 WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @Procesado = 1
END
ELSE
IF @Modulo = 'INV'
BEGIN
IF (OBJECT_ID('Tempdb..#InvDetalle')) IS NOT NULL
DROP TABLE #InvDetalle
UPDATE InvD SET Cantidad = Cantidad - @Obtenido, CantidadPendiente = CantidadPendiente - @Obtenido, CantidadInventario = CantidadInventario - @Requiere WHERE CURRENT OF crDividirPorReservado
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT * INTO #InvDetalle FROM cInvDWMS WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @RenglonSub = MAX(RenglonSub)+1 FROM InvD WHERE ID = @ID AND Renglon = @Renglon
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #InvDetalle SET Cantidad = @Obtenido, CantidadInventario = @Requiere, CantidadPendiente = @Obtenido, Almacen = @Almacen, RenglonSub = @RenglonSub, CantidadReservada = 0
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #InvDetalle SET CantidadPendiente = Cantidad, CantidadA = 0
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE InvD SET CantidadPendiente = ISNULL(Cantidad,0), CantidadReservada = 0, CantidadA = 0 WHERE CURRENT OF crDividirPorReservado
IF @@ERROR <> 0 SELECT @Ok = 1
INSERT INTO #WMSInvDR
SELECT * FROM #InvDetalle
IF @@ERROR <> 0 SELECT @Ok = 1
DELETE InvD WHERE Cantidad = 0 AND ID = @ModuloID
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE InvD SET CantidadA = CantidadPendiente, CantidadReservada = 0 WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @Procesado = 1
END
ELSE
IF @Modulo = 'COMS'
BEGIN
IF (OBJECT_ID('Tempdb..#ComsDetalle')) IS NOT NULL
DROP TABLE #ComsDetalle
UPDATE CompraD SET Cantidad = Cantidad - @Obtenido, CantidadPendiente = CantidadPendiente - @Obtenido, CantidadInventario = CantidadInventario - @Requiere WHERE CURRENT OF crDividirPorReservado
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT * INTO #ComsDetalle FROM cCompraD WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @RenglonSub = MAX(RenglonSub)+1 FROM CompraD WHERE ID = @ID AND Renglon = @Renglon
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #ComsDetalle SET Cantidad = @Obtenido, CantidadInventario = @Requiere, CantidadPendiente = @Obtenido, Almacen = @Almacen, RenglonSub = @RenglonSub
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #ComsDetalle SET CantidadPendiente = Cantidad, CantidadA = 0
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE CompraD SET CantidadPendiente = ISNULL(Cantidad,0), CantidadA = 0 WHERE CURRENT OF crDividirPorReservado
IF @@ERROR <> 0 SELECT @Ok = 1
INSERT INTO #WMSComsDR
SELECT * FROM #ComsDetalle
IF @@ERROR <> 0 SELECT @Ok = 1
DELETE CompraD WHERE Cantidad = 0 AND ID = @ModuloID
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE CompraD SET CantidadA = CantidadPendiente WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @Procesado = 1
END
SELECT @Requiere = @Requiere - @Obtenido
END
FETCH NEXT FROM crDividirPorReservado INTO @ID, @Renglon, @RenglonSub, @Pendiente, @Unidad, @Factor
IF @@ERROR <> 0 SELECT @Ok = 1
END
CLOSE crDividirPorReservado
DEALLOCATE crDividirPorReservado
IF @Procesado = 0
BEGIN
IF @Modulo = 'VTAS'
UPDATE VentaD SET Tarima = @Tarima WHERE ID = @ModuloID AND NULLIF(Tarima,'') IS NULL AND ISNULL(CantidadReservada,0) > 0
ELSE
IF @Modulo = 'INV'
UPDATE InvD SET Tarima = @Tarima WHERE ID = @ModuloID AND NULLIF(Tarima,'') IS NULL AND ISNULL(CantidadReservada,0) > 0
END
RETURN
END

