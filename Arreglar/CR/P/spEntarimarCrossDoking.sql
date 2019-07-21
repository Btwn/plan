SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEntarimarCrossDoking
@Modulo                 varchar(5),
@IDGenerar              int,
@Empresa                varchar(5),
@ID               		int,
@Almacen                varchar(10),
@PosicionWMS		    varchar(10)

AS BEGIN
DECLARE @Articulo         varchar(20),
@Cantidad         float,
@Tarima	        varchar(20),
@Costo            money,
@SerieLote        varchar(50),
@Sucursal         int,
@SubCuenta        varchar(50),
@Ok               int,
@OkRef            varchar(255)
IF @Modulo = 'INV'
BEGIN
DECLARE entarimacd_cursor CURSOR FOR
SELECT Articulo
FROM INVD
WHERE ID = @ID
GROUP BY Articulo
OPEN entarimacd_cursor
FETCH NEXT FROM entarimacd_cursor
INTO @Articulo
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Cantidad = SUM(CANTIDAD) ,
@Costo    = SUM(COSTO)
FROM INVD
WHERE ID = @ID
AND ARTICULO = @Articulo
EXEC spConsecutivo 'Tarima', 0, @Tarima OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
INSERT Tarima (
Tarima,  Almacen,  Posicion,  Estatus, Alta, Articulo
)
SELECT @Tarima, @Almacen, @PosicionWMS, 'ALTA', GETDATE(), @Articulo
INSERT InvD (ID, Renglon, RenglonSub,     RenglonID,      RenglonTipo, Cantidad,  Almacen, Articulo,  Costo,  Aplica, AplicaID, Unidad, Factor, CantidadInventario, Sucursal, CostoUEPS, CostoPEPS, UltimoCosto, CostoEstandar, Tarima,  Seccion, SucursalOrigen, AsignacionUbicacion, FechaCaducidad)
SELECT TOP 1 ID, Renglon, RenglonSub + 1, RenglonID + 1,  RenglonTipo, @Cantidad, Almacen, Articulo,  @Costo, Aplica, AplicaID, Unidad, Factor, @Cantidad,          Sucursal, CostoUEPS, CostoPEPS, UltimoCosto, CostoEstandar, @Tarima, 1,       SucursalOrigen, AsignacionUbicacion, FechaCaducidad
FROM INVD
WHERE ID = @ID
AND Articulo = @Articulo
FETCH NEXT FROM entarimacd_cursor
INTO @Articulo
END
CLOSE entarimacd_cursor;
DEALLOCATE entarimacd_cursor;
INSERT SerieLoteMov  (Empresa, Sucursal,  Modulo,  ID,        RenglonID,     Articulo, SubCuenta, SerieLote, Cantidad, Tarima, Propiedades)
SELECT Empresa, slm.Sucursal, @Modulo, @IDGenerar, slm.RenglonID + 1, slm.Articulo, slm.SubCuenta, slm.SerieLote, slm.Cantidad, @Tarima, slm.Propiedades
FROM SerieLoteMov slm
JOIN InvD d ON d.ID = slm.ID AND d.RenglonID = slm.RenglonID AND d.Articulo = slm.Articulo AND ISNULL(d.SubCuenta, '') = slm.SubCuenta
JOIN Art a ON a.Articulo = d.Articulo
WHERE slm.Modulo = @Modulo AND slm.ID = @ID AND Seccion IS NULL
AND a.SerieLoteInfo = 0
END
IF @Modulo = 'COMS'
BEGIN
DECLARE entarimacd_cursor CURSOR FOR
SELECT Articulo
FROM CompraD
WHERE ID = @ID
GROUP BY Articulo
OPEN entarimacd_cursor
FETCH NEXT FROM entarimacd_cursor
INTO @Articulo
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Cantidad = SUM(CANTIDAD) ,
@Costo    = SUM(COSTO)
FROM CompraD
WHERE ID = @ID
AND ARTICULO = @Articulo
EXEC spConsecutivo 'Tarima', 0, @Tarima OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
INSERT Tarima (
Tarima,  Almacen,  Posicion,  Estatus, Alta, Articulo
)
SELECT @Tarima, @Almacen, @PosicionWMS, 'ALTA', GETDATE(), @Articulo
INSERT CompraD (ID, Renglon, RenglonSub,     RenglonID,      RenglonTipo, Cantidad,  Almacen, Articulo,  Costo,  Aplica, AplicaID, Unidad, Factor, CantidadInventario, Sucursal, CostoUEPS, CostoPEPS, UltimoCosto, CostoEstandar, Tarima,  SucursalOrigen,  FechaCaducidad)
SELECT TOP 1 ID, Renglon, RenglonSub + 1, RenglonID + 1,  RenglonTipo, @Cantidad, Almacen, Articulo,  @Costo, Aplica, AplicaID, Unidad, Factor, @Cantidad,          Sucursal, CostoUEPS, CostoPEPS, UltimoCosto, CostoEstandar, @Tarima,     SucursalOrigen,  FechaCaducidad
FROM CompraD
WHERE ID = @ID
AND Articulo = @Articulo
FETCH NEXT FROM entarimacd_cursor
INTO @Articulo
END
CLOSE entarimacd_cursor;
DEALLOCATE entarimacd_cursor;
INSERT SerieLoteMov  (
Empresa, Sucursal,  Modulo,  ID,        RenglonID,     Articulo, SubCuenta, SerieLote, Cantidad, Tarima, Propiedades)
SELECT Empresa, slm.Sucursal, @Modulo, @IDGenerar, slm.RenglonID + 1   , slm.Articulo, slm.SubCuenta, slm.SerieLote, slm.Cantidad, @Tarima, slm.Propiedades
FROM SerieLoteMov slm
JOIN CompraD d ON d.ID = slm.ID AND d.RenglonID = slm.RenglonID AND d.Articulo = slm.Articulo AND ISNULL(d.SubCuenta, '') = slm.SubCuenta
JOIN Art a ON a.Articulo = d.Articulo
WHERE slm.Modulo = @Modulo AND slm.ID = @ID
AND a.SerieLoteInfo = 0
END
IF @Modulo = 'VTAS'
BEGIN
DECLARE entarimacd_cursor CURSOR FOR
SELECT Articulo
FROM VentaD
WHERE ID = @ID
GROUP BY Articulo
OPEN entarimacd_cursor
FETCH NEXT FROM entarimacd_cursor
INTO @Articulo
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Cantidad = SUM(CANTIDAD) ,
@Costo    = SUM(COSTO)
FROM VentaD
WHERE ID = @ID
AND ARTICULO = @Articulo
EXEC spConsecutivo 'Tarima', 0, @Tarima OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
INSERT Tarima (
Tarima,  Almacen,  Posicion,  Estatus, Alta, Articulo
)
SELECT @Tarima, @Almacen, @PosicionWMS, 'ALTA', GETDATE(), @Articulo
INSERT VentaD (ID, Renglon, RenglonSub,     RenglonID,      RenglonTipo, Cantidad,  Almacen, Articulo,  Costo,  Aplica, AplicaID, Unidad, Factor, CantidadInventario, Sucursal, CostoUEPS, CostoPEPS, UltimoCosto, CostoEstandar, Tarima,  SucursalOrigen)
SELECT TOP 1 ID, Renglon, RenglonSub + 1, RenglonID + 1,  RenglonTipo, @Cantidad, Almacen, Articulo,  @Costo, Aplica, AplicaID, Unidad, Factor, @Cantidad,          Sucursal, CostoUEPS, CostoPEPS, UltimoCosto, CostoEstandar, @Tarima,   SucursalOrigen
FROM VentaD
WHERE ID = @ID
AND Articulo = @Articulo
FETCH NEXT FROM entarimacd_cursor
INTO @Articulo
END
CLOSE entarimacd_cursor;
DEALLOCATE entarimacd_cursor;
INSERT SerieLoteMov  (
Empresa, Sucursal,  Modulo,  ID,        RenglonID,     Articulo, SubCuenta, SerieLote, Cantidad, Tarima, Propiedades)
SELECT Empresa, slm.Sucursal, @Modulo, @IDGenerar, slm.RenglonID + 1, slm.Articulo, slm.SubCuenta, slm.SerieLote, slm.Cantidad, @Tarima, slm.Propiedades
FROM SerieLoteMov slm
JOIN VentaD d ON d.ID = slm.ID AND d.RenglonID = slm.RenglonID AND d.Articulo = slm.Articulo AND ISNULL(d.SubCuenta, '') = slm.SubCuenta
JOIN Art a ON a.Articulo = d.Articulo
WHERE slm.Modulo = @Modulo AND slm.ID = @ID
AND a.SerieLoteInfo = 0
END
IF @Modulo = 'PROD'
BEGIN
DECLARE entarimacd_cursor CURSOR FOR
SELECT Articulo
FROM ProdD
WHERE ID = @ID
GROUP BY Articulo
OPEN entarimacd_cursor
FETCH NEXT FROM entarimacd_cursor
INTO @Articulo
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Cantidad = SUM(CANTIDAD) ,
@Costo    = SUM(COSTO)
FROM ProdD
WHERE ID = @ID
AND ARTICULO = @Articulo
EXEC spConsecutivo 'Tarima', 0, @Tarima OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
INSERT Tarima (
Tarima,  Almacen,  Posicion,  Estatus, Alta, Articulo
)
SELECT @Tarima, @Almacen, @PosicionWMS, 'ALTA', GETDATE(), @Articulo
INSERT ProdD (ID, Renglon, RenglonSub,     RenglonID,      RenglonTipo, Cantidad,  Almacen, Articulo,  Costo,  Aplica, AplicaID, Unidad, Factor, CantidadInventario, Sucursal, CostoUEPS, CostoPEPS, UltimoCosto, CostoEstandar, Tarima,  SucursalOrigen)
SELECT TOP 1 ID, Renglon, RenglonSub + 1, RenglonID + 1,  RenglonTipo, @Cantidad, Almacen, Articulo,  @Costo, Aplica, AplicaID, Unidad, Factor, @Cantidad,          Sucursal, CostoUEPS, CostoPEPS, UltimoCosto, CostoEstandar, @Tarima,  SucursalOrigen
FROM ProdD
WHERE ID = @ID
AND Articulo = @Articulo
FETCH NEXT FROM entarimacd_cursor
INTO @Articulo
END
CLOSE entarimacd_cursor;
DEALLOCATE entarimacd_cursor;
INSERT SerieLoteMov  (
Empresa, Sucursal, Modulo,  ID,        RenglonID,     Articulo, SubCuenta, SerieLote, Cantidad, Tarima, Propiedades)
SELECT Empresa, slm.Sucursal, @Modulo, @IDGenerar, slm.RenglonID + 1, slm.Articulo, slm.SubCuenta, slm.SerieLote, slm.Cantidad, @Tarima, slm.Propiedades
FROM SerieLoteMov slm
JOIN InvD d ON d.ID = slm.ID AND d.RenglonID = slm.RenglonID AND d.Articulo = slm.Articulo AND ISNULL(d.SubCuenta, '') = slm.SubCuenta
JOIN Art a ON a.Articulo = d.Articulo
WHERE slm.Modulo = @Modulo AND slm.ID = @ID
AND a.SerieLoteInfo = 0
END
RETURN
END

