SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSDividirPorReservadoPck
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
@RenglonWMS		float,
@RenglonSubWMS	int,
@Ok             int OUTPUT,
@OkRef          varchar(255)OUTPUT

AS BEGIN
DECLARE
@ID                 int,
@Renglon            float,
@RenglonID          int,
@cRenglonID          int,
@RenglonSub			int,
@Requiere			float,
@Obtenido           float,
@Pendiente          float,
@Procesado          bit,
@Unidad				varchar(50),
@Factor				float,
@CantidadTotal		float,
@Estatus			varchar(15),
@cRenglon           float
SELECT @Requiere = @Cantidad, @SubCuenta = NULLIF(RTRIM(@SubCuenta), ''), @Procesado = 0
IF @Modulo = 'VTAS'
BEGIN
SELECT @CantidadTotal = SUM(CantidadPendiente*Factor)
FROM VentaD, Venta
WHERE Venta.Estatus = 'PENDIENTE'
AND Venta.ID = @ModuloID
AND VentaD.ID = Venta.ID
AND VentaD.Almacen = @Almacen
AND VentaD.Articulo = @Articulo
AND VentaD.SubCuenta = @SubCuenta
AND ISNULL(VentaD.CantidadPendiente, 0.0) > 0 
AND NULLIF(VentaD.Tarima,'') IS NULL
IF @CantidadTotal <= @Cantidad
BEGIN
UPDATE VentaD
SET Tarima = @Tarima
FROM VentaD, Venta
WHERE Venta.Estatus = 'PENDIENTE'
AND Venta.ID = @ModuloID
AND VentaD.ID = Venta.ID
AND VentaD.Almacen = @Almacen
AND VentaD.Articulo = @Articulo
AND VentaD.SubCuenta = @SubCuenta
AND ISNULL(VentaD.CantidadPendiente, 0.0) > 0 
AND NULLIF(VentaD.Tarima,'') IS NULL
IF NOT EXISTS (SELECT * FROM SerieLoteMov WHERE ID = @ModuloID AND Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'') AND Modulo = @Modulo AND Empresa = @Empresa AND Tarima = @Tarima)
INSERT SerieLoteMov(Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, CantidadAlterna, Propiedades,
Ubicacion, Cliente, Localizacion, Sucursal, ArtCostoInv, Tarima, AsignacionUbicacion)
SELECT slm.Empresa, slm.Modulo, slm.ID, slm.RenglonID, slm.Articulo, slm.SubCuenta, slm.SerieLote, SUM(slm.Cantidad), NULLIF(SUM(ISNULL(slm.CantidadAlterna,0)),0), slm.Propiedades,
slm.Ubicacion, slm.Cliente, slm.Localizacion, slm.Sucursal, slm.ArtCostoInv, VentaD.Tarima, slm.AsignacionUbicacion
FROM SerieLoteMov slm, VentaD, Venta
WHERE Venta.Estatus = 'PENDIENTE'
AND Venta.ID = @ModuloID
AND VentaD.ID = Venta.ID
AND VentaD.Almacen = @Almacen
AND VentaD.Articulo = @Articulo
AND VentaD.SubCuenta = @SubCuenta
AND ISNULL(VentaD.CantidadPendiente, 0.0) > 0
AND slm.Empresa = @Empresa
AND slm.Modulo = @Modulo
AND slm.ID = Venta.ID
AND VentaD.Articulo = slm.Articulo
AND ISNULL(VentaD.SubCuenta,'') = ISNULL(slm.SubCuenta,'')
AND VentaD.RenglonID = slm.RenglonID
AND VentaD.Tarima = @Tarima
GROUP BY slm.Empresa, slm.Modulo, slm.ID, slm.RenglonID, slm.Articulo, slm.SubCuenta, slm.SerieLote, slm.Propiedades,
slm.Ubicacion, slm.Cliente, slm.Localizacion, slm.Sucursal, slm.ArtCostoInv, VentaD.Tarima, slm.AsignacionUbicacion
IF @@ROWCOUNT <> 0
DELETE SerieLoteMov
WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ModuloID AND Tarima <> @Tarima AND Articulo = @Articulo
AND Tarima NOT IN(SELECT Tarima FROM VentaD WHERE ID = @ModuloID AND Articulo = @Articulo AND Renglon = @RenglonWMS)
END
DECLARE crDividirPorReservado CURSOR FOR
SELECT Venta.ID, VentaD.Renglon, VentaD.RenglonSub, ISNULL(VentaD.CantidadPendiente, 0.0), VentaD.Unidad, VentaD.Factor, VentaD.RenglonID
FROM VentaD, Venta
WHERE Venta.Estatus = 'PENDIENTE'
AND Venta.ID = @ModuloID
AND VentaD.ID = Venta.ID
AND VentaD.Almacen = @Almacen
AND VentaD.Articulo = @Articulo
AND VentaD.SubCuenta = @SubCuenta
AND ISNULL(VentaD.CantidadPendiente, 0.0) > 0 
AND NULLIF(VentaD.Tarima,'') IS NULL
ORDER BY Venta.ID, VentaD.Renglon, VentaD.RenglonSub
END
ELSE
IF @Modulo = 'INV'
BEGIN
SELECT @CantidadTotal = SUM(CantidadPendiente*Factor)
FROM InvD, Inv
WHERE Inv.Estatus = 'PENDIENTE'
AND Inv.ID = @ModuloID
AND InvD.ID = Inv.ID
AND InvD.Almacen = @Almacen
AND InvD.Articulo = @Articulo
AND InvD.SubCuenta = @SubCuenta
AND ISNULL(InvD.CantidadPendiente, 0.0) > 0 
AND NULLIF(InvD.Tarima,'') IS NULL
IF @CantidadTotal <= @Cantidad
BEGIN
UPDATE InvD
SET Tarima = @Tarima
FROM InvD, Inv
WHERE Inv.Estatus = 'PENDIENTE'
AND Inv.ID = @ModuloID
AND InvD.ID = Inv.ID
AND InvD.Almacen = @Almacen
AND InvD.Articulo = @Articulo
AND InvD.SubCuenta = @SubCuenta
AND ISNULL(InvD.CantidadPendiente, 0.0) > 0 
AND NULLIF(InvD.Tarima,'') IS NULL
IF NOT EXISTS (SELECT * FROM SerieLoteMov WHERE ID = @ModuloID AND Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'') AND Modulo = @Modulo AND Empresa = @Empresa AND Tarima = @Tarima)
INSERT SerieLoteMov(Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, CantidadAlterna, Propiedades,
Ubicacion, Cliente, Localizacion, Sucursal, ArtCostoInv, Tarima, AsignacionUbicacion)
SELECT slm.Empresa, slm.Modulo, slm.ID, slm.RenglonID, slm.Articulo, slm.SubCuenta, slm.SerieLote, SUM(slm.Cantidad), NULLIF(SUM(ISNULL(slm.CantidadAlterna,0)),0), slm.Propiedades,
slm.Ubicacion, slm.Cliente, slm.Localizacion, slm.Sucursal, slm.ArtCostoInv, InvD.Tarima, slm.AsignacionUbicacion
FROM SerieLoteMov slm, InvD, Inv
WHERE Inv.Estatus = 'PENDIENTE'
AND Inv.ID = @ModuloID
AND InvD.ID = Inv.ID
AND InvD.Almacen = @Almacen
AND InvD.Articulo = @Articulo
AND InvD.SubCuenta = @SubCuenta
AND ISNULL(InvD.CantidadPendiente, 0.0) > 0
AND slm.Empresa = @Empresa
AND slm.Modulo = @Modulo
AND slm.ID = Inv.ID
AND InvD.Articulo = slm.Articulo
AND ISNULL(InvD.SubCuenta,'') = ISNULL(slm.SubCuenta,'')
AND InvD.RenglonID = slm.RenglonID
AND InvD.Tarima = @Tarima
GROUP BY slm.Empresa, slm.Modulo, slm.ID, slm.RenglonID, slm.Articulo, slm.SubCuenta, slm.SerieLote, slm.Propiedades,
slm.Ubicacion, slm.Cliente, slm.Localizacion, slm.Sucursal, slm.ArtCostoInv, InvD.Tarima, slm.AsignacionUbicacion
IF @@ROWCOUNT <> 0
DELETE SerieLoteMov
WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ModuloID AND Tarima <> @Tarima AND Articulo = @Articulo
AND Tarima NOT IN(SELECT Tarima FROM InvD WHERE ID = @ModuloID AND Articulo = @Articulo AND Renglon = @RenglonWMS)
END
DECLARE crDividirPorReservado CURSOR FOR
SELECT Inv.ID, InvD.Renglon, InvD.RenglonSub, ISNULL(InvD.CantidadPendiente, 0.0), InvD.Unidad, InvD.Factor, InvD.RenglonID
FROM InvD, Inv
WHERE Inv.Estatus = 'PENDIENTE'
AND Inv.ID = @ModuloID
AND InvD.ID = Inv.ID
AND InvD.Almacen = @Almacen
AND InvD.Articulo = @Articulo
AND InvD.SubCuenta = @SubCuenta
AND ISNULL(InvD.CantidadPendiente, 0.0) > 0 
AND NULLIF(InvD.Tarima,'') IS NULL
ORDER BY Inv.ID, InvD.Renglon, InvD.RenglonSub
END
ELSE
IF @Modulo = 'COMS'
BEGIN
SELECT @CantidadTotal = SUM(CantidadPendiente*Factor)
FROM CompraD, Compra
WHERE Compra.Estatus = 'PENDIENTE'
AND Compra.ID = @ModuloID
AND CompraD.ID = Compra.ID
AND CompraD.Almacen = @Almacen
AND CompraD.Articulo = @Articulo
AND CompraD.SubCuenta = @SubCuenta
AND ISNULL(CompraD.CantidadPendiente, 0.0) > 0 
AND NULLIF(CompraD.Tarima,'') IS NULL
IF @CantidadTotal <= @Cantidad
BEGIN
UPDATE CompraD
SET Tarima = @Tarima
FROM CompraD, Compra
WHERE Compra.Estatus = 'PENDIENTE'
AND Compra.ID = @ModuloID
AND CompraD.ID = Compra.ID
AND CompraD.Almacen = @Almacen
AND CompraD.Articulo = @Articulo
AND CompraD.SubCuenta = @SubCuenta
AND ISNULL(CompraD.CantidadPendiente, 0.0) > 0 
AND NULLIF(CompraD.Tarima,'') IS NULL
IF NOT EXISTS (SELECT * FROM SerieLoteMov WHERE ID = @ModuloID AND Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'') AND Modulo = @Modulo AND Empresa = @Empresa AND Tarima = @Tarima)
INSERT SerieLoteMov(Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, CantidadAlterna, Propiedades,
Ubicacion, Cliente, Localizacion, Sucursal, ArtCostoInv, Tarima, AsignacionUbicacion)
SELECT slm.Empresa, slm.Modulo, slm.ID, slm.RenglonID, slm.Articulo, slm.SubCuenta, slm.SerieLote, SUM(slm.Cantidad), NULLIF(SUM(ISNULL(slm.CantidadAlterna,0)),0), slm.Propiedades,
slm.Ubicacion, slm.Cliente, slm.Localizacion, slm.Sucursal, slm.ArtCostoInv, CompraD.Tarima, slm.AsignacionUbicacion
FROM SerieLoteMov slm, CompraD, Compra
WHERE Compra.Estatus = 'PENDIENTE'
AND Compra.ID = @ModuloID
AND CompraD.ID = Compra.ID
AND CompraD.Almacen = @Almacen
AND CompraD.Articulo = @Articulo
AND CompraD.SubCuenta = @SubCuenta
AND ISNULL(CompraD.CantidadPendiente, 0.0) > 0
AND slm.Empresa = @Empresa
AND slm.Modulo = @Modulo
AND slm.ID = Compra.ID
AND CompraD.Articulo = slm.Articulo
AND ISNULL(CompraD.SubCuenta,'') = ISNULL(slm.SubCuenta,'')
AND CompraD.RenglonID = slm.RenglonID
AND CompraD.Tarima = @Tarima
GROUP BY slm.Empresa, slm.Modulo, slm.ID, slm.RenglonID, slm.Articulo, slm.SubCuenta, slm.SerieLote, slm.Propiedades,
slm.Ubicacion, slm.Cliente, slm.Localizacion, slm.Sucursal, slm.ArtCostoInv, CompraD.Tarima, slm.AsignacionUbicacion
IF @@ROWCOUNT <> 0
DELETE SerieLoteMov
WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ModuloID AND Tarima <> @Tarima AND Articulo = @Articulo
AND Tarima NOT IN(SELECT Tarima FROM CompraD WHERE ID = @ModuloID AND Articulo = @Articulo AND Renglon = @RenglonWMS)
END
DECLARE crDividirPorReservado CURSOR FOR
SELECT Compra.ID, CompraD.Renglon, CompraD.RenglonSub, ISNULL(CompraD.CantidadPendiente, 0.0), CompraD.Unidad, CompraD.Factor, CompraD.RenglonID
FROM CompraD, Compra
WHERE Compra.Estatus = 'PENDIENTE'
AND Compra.ID = @ModuloID
AND CompraD.ID = Compra.ID
AND CompraD.Almacen = @Almacen
AND CompraD.Articulo = @Articulo
AND CompraD.SubCuenta = @SubCuenta
AND ISNULL(CompraD.CantidadPendiente, 0.0) > 0 
AND NULLIF(CompraD.Tarima,'') IS NULL
ORDER BY Compra.ID, CompraD.Renglon, CompraD.RenglonSub
END
OPEN crDividirPorReservado
FETCH NEXT FROM crDividirPorReservado INTO @ID, @Renglon, @RenglonSub, @Pendiente, @Unidad, @Factor, @RenglonID
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF 1=1
BEGIN
IF @Modulo = 'VTAS'
BEGIN
IF (OBJECT_ID('Tempdb..#VentaDetalle')) IS NOT NULL
DROP TABLE #VentaDetalle
IF @Cantidad IS NOT NULL AND (@Cantidad) >= (@Pendiente*@Factor)
BEGIN
UPDATE VentaD SET Tarima = @Tarima WHERE CURRENT OF crDividirPorReservado
SELECT @Cantidad = @Cantidad - (@Pendiente*@Factor)
END
ELSE IF @Cantidad IS NOT NULL AND (@Cantidad) < (@Pendiente*@Factor)
BEGIN
UPDATE VentaD
SET Tarima = @Tarima,
Cantidad = @Cantidad / @Factor,
CantidadPendiente = @Cantidad / @Factor,
CantidadInventario = @Cantidad
WHERE CURRENT OF crDividirPorReservado
SELECT * INTO #VentaDetalle
FROM cVentaDWMS
WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub AND RenglonID = @RenglonID
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @RenglonSub = MAX(RenglonSub)+1, @cRenglonID = MAX(RenglonID)+1 FROM VentaD WHERE ID = @ID AND Renglon = @Renglon AND RenglonID = @RenglonID
SELECT @cRenglon = MAX(Renglon) + 2048 FROM VentaD WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #VentaDetalle
SET Cantidad = (@Pendiente*@Factor - @Cantidad)/@Factor,
CantidadInventario = (@Pendiente*@Factor - @Cantidad),
CantidadPendiente = (@Pendiente*@Factor - @Cantidad)/@Factor,
Almacen = @Almacen,
Renglon = @cRenglon,
RenglonID = @cRenglonID,
CantidadReservada = 0,
Tarima = NULL
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #VentaDetalle SET CantidadPendiente = Cantidad, CantidadA = 0
IF @@ERROR <> 0 SELECT @Ok = 1
INSERT INTO cVentaDWMS SELECT * FROM #VentaDetalle
DELETE VentaD WHERE Cantidad = 0 AND ID = @ID
SELECT @Cantidad = NULL
IF NOT EXISTS (SELECT * FROM SerieLoteMov WHERE ID = @ModuloID AND Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'') AND Modulo = @Modulo AND Empresa = @Empresa AND Tarima = @Tarima)
INSERT SerieLoteMov(Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, CantidadAlterna, Propiedades,
Ubicacion, Cliente, Localizacion, Sucursal, ArtCostoInv, Tarima, AsignacionUbicacion)
SELECT slm.Empresa, slm.Modulo, slm.ID, slm.RenglonID, slm.Articulo, slm.SubCuenta, slm.SerieLote, SUM(slm.Cantidad), NULLIF(SUM(ISNULL(slm.CantidadAlterna,0)),0), slm.Propiedades,
slm.Ubicacion, slm.Cliente, slm.Localizacion, slm.Sucursal, slm.ArtCostoInv, VentaD.Tarima, slm.AsignacionUbicacion
FROM SerieLoteMov slm, VentaD, Venta
WHERE Venta.Estatus = 'PENDIENTE'
AND Venta.ID = @ModuloID
AND VentaD.ID = Venta.ID
AND VentaD.Almacen = @Almacen
AND VentaD.Articulo = @Articulo
AND VentaD.SubCuenta = @SubCuenta
AND ISNULL(VentaD.CantidadPendiente, 0.0) > 0
AND slm.Empresa = @Empresa
AND slm.Modulo = @Modulo
AND slm.ID = Venta.ID
AND VentaD.Articulo = slm.Articulo
AND ISNULL(VentaD.SubCuenta,'') = ISNULL(slm.SubCuenta,'')
AND VentaD.RenglonID = slm.RenglonID
AND VentaD.Tarima IS NOT NULL
GROUP BY slm.Empresa, slm.Modulo, slm.ID, slm.RenglonID, slm.Articulo, slm.SubCuenta, slm.SerieLote, slm.Propiedades,
slm.Ubicacion, slm.Cliente, slm.Localizacion, slm.Sucursal, slm.ArtCostoInv, VentaD.Tarima, slm.AsignacionUbicacion
IF @@ROWCOUNT <> 0
DELETE SerieLoteMov
WHERE Empresa = @Empresa
AND Modulo = @Modulo
AND ID = @ModuloID
AND Tarima <> @Tarima
AND Articulo = @Articulo
AND RenglonID = @RenglonID
END
END
ELSE
IF @Modulo = 'INV'
BEGIN
IF (OBJECT_ID('Tempdb..#InvDetalle')) IS NOT NULL
DROP TABLE #InvDetalle
IF @Cantidad IS NOT NULL AND (@Cantidad) >= (@Pendiente*@Factor)
BEGIN
UPDATE InvD SET Tarima = @Tarima WHERE CURRENT OF crDividirPorReservado
SELECT @Cantidad = @Cantidad - (@Pendiente*@Factor)
END
ELSE IF @Cantidad IS NOT NULL AND (@Cantidad) < (@Pendiente*@Factor)
BEGIN
UPDATE InvD
SET Tarima = @Tarima,
Cantidad = @Cantidad / @Factor,
CantidadPendiente = @Cantidad / @Factor,
CantidadInventario = @Cantidad,
CantidadReservada = 0
WHERE CURRENT OF crDividirPorReservado
SELECT * INTO #InvDetalle FROM cInvDWMS WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @RenglonSub = MAX(RenglonSub)+1, @cRenglonID = MAX(RenglonID)+1 FROM InvD WHERE ID = @ID AND Renglon = @Renglon AND RenglonID = @RenglonID
SELECT @cRenglon = MAX(Renglon) + 2048 FROM InvD WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #InvDetalle
SET Cantidad = (@Pendiente*@Factor - @Cantidad)/@Factor,
CantidadInventario = (@Pendiente*@Factor - @Cantidad),
CantidadPendiente = (@Pendiente*@Factor - @Cantidad)/@Factor,
Almacen = @Almacen,
Renglon = @cRenglon,
RenglonID =  @cRenglonID,
CantidadReservada = 0,
Tarima = NULL
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #InvDetalle SET CantidadPendiente = Cantidad, CantidadA = 0
IF @@ERROR <> 0 SELECT @Ok = 1
INSERT INTO cInvDWMS SELECT * FROM #InvDetalle
DELETE InvD WHERE Cantidad = 0 AND ID = @ID
SELECT @Cantidad = NULL
IF NOT EXISTS (SELECT * FROM SerieLoteMov WHERE ID = @ModuloID AND Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'') AND Modulo = @Modulo AND Empresa = @Empresa AND Tarima = @Tarima)
INSERT SerieLoteMov(Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, CantidadAlterna, Propiedades,
Ubicacion, Cliente, Localizacion, Sucursal, ArtCostoInv, Tarima, AsignacionUbicacion)
SELECT slm.Empresa, slm.Modulo, slm.ID, slm.RenglonID, slm.Articulo, slm.SubCuenta, slm.SerieLote, SUM(slm.Cantidad), NULLIF(SUM(ISNULL(slm.CantidadAlterna,0)),0), slm.Propiedades,
slm.Ubicacion, slm.Cliente, slm.Localizacion, slm.Sucursal, slm.ArtCostoInv, InvD.Tarima, slm.AsignacionUbicacion
FROM SerieLoteMov slm, InvD, Inv
WHERE Inv.Estatus = 'PENDIENTE'
AND Inv.ID = @ModuloID
AND InvD.ID = Inv.ID
AND InvD.Almacen = @Almacen
AND InvD.Articulo = @Articulo
AND InvD.SubCuenta = @SubCuenta
AND ISNULL(InvD.CantidadPendiente, 0.0) > 0
AND slm.Empresa = @Empresa
AND slm.Modulo = @Modulo
AND slm.ID = Inv.ID
AND InvD.Articulo = slm.Articulo
AND ISNULL(InvD.SubCuenta,'') = ISNULL(slm.SubCuenta,'')
AND InvD.RenglonID = slm.RenglonID
AND InvD.Tarima IS NOT NULL
GROUP BY slm.Empresa, slm.Modulo, slm.ID, slm.RenglonID, slm.Articulo, slm.SubCuenta, slm.SerieLote, slm.Propiedades,
slm.Ubicacion, slm.Cliente, slm.Localizacion, slm.Sucursal, slm.ArtCostoInv, InvD.Tarima, slm.AsignacionUbicacion
IF @@ROWCOUNT <> 0
DELETE SerieLoteMov
WHERE Empresa = @Empresa
AND Modulo = @Modulo
AND ID = @ModuloID
AND Tarima <> @Tarima
AND Articulo = @Articulo
AND RenglonID = @RenglonID
END
END
ELSE
IF @Modulo = 'COMS'
BEGIN
IF (OBJECT_ID('Tempdb..#CompraDetalle')) IS NOT NULL
DROP TABLE #CompraDetalle
IF @Cantidad IS NOT NULL AND (@Cantidad) >= (@Pendiente*@Factor)
BEGIN
UPDATE CompraD SET Tarima = @Tarima WHERE CURRENT OF crDividirPorReservado
SELECT @Cantidad = @Cantidad - (@Pendiente*@Factor)
END
ELSE IF @Cantidad IS NOT NULL AND (@Cantidad) < (@Pendiente*@Factor)
BEGIN
UPDATE CompraD
SET Tarima = @Tarima,
Cantidad = @Cantidad / @Factor,
CantidadPendiente = @Cantidad / @Factor,
CantidadInventario = @Cantidad
WHERE CURRENT OF crDividirPorReservado
SELECT * INTO #CompraDetalle FROM cCompraD WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @RenglonSub = MAX(RenglonSub)+1, @cRenglonID = MAX(RenglonID)+1 FROM CompraD WHERE ID = @ID AND Renglon = @Renglon
SELECT @cRenglon = MAX(Renglon) + 2048 FROM CompraD WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #CompraDetalle
SET Cantidad = (@Pendiente*@Factor - @Cantidad)/@Factor,
CantidadInventario = (@Pendiente*@Factor - @Cantidad),
CantidadPendiente = (@Pendiente*@Factor - @Cantidad)/@Factor,
Almacen = @Almacen,
Renglon = @cRenglon,
RenglonID = @cRenglonID,
CantidadReservada = 0,
Tarima = NULL
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #CompraDetalle SET CantidadPendiente = Cantidad, CantidadA = 0
IF @@ERROR <> 0 SELECT @Ok = 1
INSERT INTO cCompraD SELECT * FROM #CompraDetalle
DELETE CompraD WHERE Cantidad = 0 AND ID = @ID
SELECT @Cantidad = NULL
IF NOT EXISTS (SELECT * FROM SerieLoteMov WHERE ID = @ModuloID AND Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'') AND Modulo = @Modulo AND Empresa = @Empresa AND Tarima = @Tarima)
INSERT SerieLoteMov(Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, CantidadAlterna, Propiedades,
Ubicacion, Cliente, Localizacion, Sucursal, ArtCostoInv, Tarima, AsignacionUbicacion)
SELECT slm.Empresa, slm.Modulo, slm.ID, slm.RenglonID, slm.Articulo, slm.SubCuenta, slm.SerieLote, SUM(slm.Cantidad), NULLIF(SUM(ISNULL(slm.CantidadAlterna,0)),0), slm.Propiedades,
slm.Ubicacion, slm.Cliente, slm.Localizacion, slm.Sucursal, slm.ArtCostoInv, CompraD.Tarima, slm.AsignacionUbicacion
FROM SerieLoteMov slm, CompraD, Compra
WHERE Compra.Estatus = 'PENDIENTE'
AND Compra.ID = @ModuloID
AND CompraD.ID = Compra.ID
AND CompraD.Almacen = @Almacen
AND CompraD.Articulo = @Articulo
AND CompraD.SubCuenta = @SubCuenta
AND ISNULL(CompraD.CantidadPendiente, 0.0) > 0
AND slm.Empresa = @Empresa
AND slm.Modulo = @Modulo
AND slm.ID = Compra.ID
AND CompraD.Articulo = slm.Articulo
AND ISNULL(CompraD.SubCuenta,'') = ISNULL(slm.SubCuenta,'')
AND CompraD.RenglonID = slm.RenglonID
GROUP BY slm.Empresa, slm.Modulo, slm.ID, slm.RenglonID, slm.Articulo, slm.SubCuenta, slm.SerieLote, slm.Propiedades,
slm.Ubicacion, slm.Cliente, slm.Localizacion, slm.Sucursal, slm.ArtCostoInv, CompraD.Tarima, slm.AsignacionUbicacion
IF @@ROWCOUNT <> 0
DELETE SerieLoteMov
WHERE Empresa = @Empresa
AND Modulo = @Modulo
AND ID = @ModuloID
AND Tarima <> @Tarima
AND Articulo = @Articulo
AND RenglonID = @RenglonID
END
END
END
END
FETCH NEXT FROM crDividirPorReservado INTO @ID, @Renglon, @RenglonSub, @Pendiente, @Unidad, @Factor, @RenglonID
IF @@ERROR <> 0 SELECT @Ok = 1
END
CLOSE crDividirPorReservado
DEALLOCATE crDividirPorReservado
END

