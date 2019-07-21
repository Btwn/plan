SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarOrdenEntarimado
@Modulo			varchar(5),
@ID               		int,
@Accion			varchar(20),
@Empresa          		varchar(5),
@Sucursal			int,
@Usuario			varchar(10),
@Mov			varchar(20),
@MovID			varchar(20),
@MovTipo			varchar(20),
@Almacen			varchar(10),
@Ok               		int           	OUTPUT,
@OkRef            		varchar(255)  	OUTPUT

AS BEGIN
DECLARE
@OrdenID	int,
@OrdenMov	varchar(20),
@OrdenMovID	varchar(20), 
@Posicion	varchar(10), 
@PosicionD	varchar(10),
@AlmacenOrigen  varchar(10)
SELECT @OrdenMov = InvOrdenEntarimado FROM EmpresaCfgMov WHERE Empresa = @Empresa
IF @Accion = 'CANCELAR'
SELECT @OrdenID = ID FROM Inv WHERE Mov = @OrdenMov AND OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
ELSE BEGIN
IF @Modulo = 'COMS'
SELECT @Posicion = Posicion FROM Compra WHERE ID = @ID
ELSE
IF @Modulo = 'INV'
SELECT @Posicion = PosicionWMS, @PosicionD = PosicionDWMS FROM Inv WHERE ID = @ID
ELSE
IF @Modulo = 'VTAS'
SELECT @Posicion = PosicionWMS FROM Venta WHERE ID = @ID
IF @Accion = 'RESERVARPARCIAL' SELECT @Accion = 'AFECTAR'
IF @Modulo = 'VTAS'
BEGIN
INSERT Inv (
Empresa,  Sucursal,  Mov,       Almacen,  FechaEmision, Concepto, Referencia, Proyecto, UEN, Usuario, Estatus,       Moneda, TipoCambio, OrigenTipo, Origen, OrigenID, CrossDocking, SucursalOrigen, SucursalDestino, PosicionWMS) 
SELECT Empresa, Sucursal, @OrdenMov, @Almacen, FechaEmision, Concepto, Referencia, Proyecto, UEN, @Usuario, 'SINAFECTAR', Moneda, TipoCambio, 'INV/EP',    @Mov,   @MovID, CrossDocking, SucursalOrigen, SucursalDestino, PosicionWMS   
FROM Venta
WHERE ID = @ID
SELECT @OrdenID = SCOPE_IDENTITY()
INSERT InvD (
ID,       Renglon, RenglonSub, RenglonID, Sucursal,  Almacen,  Articulo, SubCuenta, Cantidad, Unidad, Factor, CantidadInventario, Costo)
SELECT @OrdenID, Renglon, RenglonSub, VentaD.RenglonID, VentaD.Sucursal, @Almacen, VentaD.Articulo, SubCuenta, Cantidad, Unidad, Factor, CantidadInventario, (ArtCosto.CostoPromedio*Factor)/Venta.TipoCambio 
FROM VentaD
JOIN Venta ON Venta.ID = VentaD.ID
LEFT OUTER JOIN ArtCosto ON VentaD.Articulo = ArtCosto.Articulo AND ArtCosto.Empresa = @Empresa AND ArtCosto.Sucursal = @Sucursal
WHERE Venta.ID = @ID
END ELSE
IF @Modulo = 'COMS'
BEGIN
INSERT Inv (
Empresa,  Sucursal,  Mov,       Almacen,  FechaEmision, Concepto, Referencia, Proyecto, UEN, Usuario, Estatus,       Moneda, TipoCambio, OrigenTipo, Origen, OrigenID, CrossDocking, SucursalOrigen, SucursalDestino, PosicionWMS) 
SELECT Empresa, Sucursal, @OrdenMov, @Almacen, FechaEmision, Concepto, Referencia, Proyecto, UEN, @Usuario, 'SINAFECTAR', Moneda, TipoCambio, @Modulo,    @Mov,   @MovID, CrossDocking, SucursalOrigen, SucursalDestino, PosicionWMS 
FROM Compra
WHERE ID = @ID
SELECT @OrdenID = SCOPE_IDENTITY()
INSERT InvD (
ID,       Renglon, RenglonSub, RenglonID, Sucursal,  Almacen,  Articulo, SubCuenta, Cantidad, Unidad, Factor, CantidadInventario, Costo, CostoInv, FechaCaducidad)
SELECT @OrdenID, Renglon, RenglonSub, CompraD.RenglonID, CompraD.Sucursal, @Almacen, CompraD.Articulo, SubCuenta, CASE WHEN ISNULL(CantidadInventario,0) = 0 THEN Cantidad*Factor ELSE Cantidad END, Unidad, Factor, CantidadInventario, (ArtCosto.CostoPromedio*Factor)/Compra.TipoCambio, CostoInv, FechaCaducidad 
FROM CompraD
JOIN Compra ON CompraD.ID = Compra.ID
LEFT OUTER JOIN ArtCosto ON CompraD.Articulo = ArtCosto.Articulo AND ArtCosto.Empresa = @Empresa AND ArtCosto.Sucursal = @Sucursal
WHERE CompraD.ID = @ID
END ELSE
IF @Modulo = 'INV'
BEGIN
INSERT Inv (
Empresa,  Sucursal,  Mov,       Almacen,  FechaEmision, Concepto, Referencia, Proyecto, UEN, Usuario, Estatus,       Moneda, TipoCambio, OrigenTipo, Origen, OrigenID, CrossDocking, SucursalOrigen, SucursalDestino, PosicionWMS) 
SELECT Empresa, Sucursal, @OrdenMov, @Almacen, FechaEmision, Concepto, Referencia, Proyecto, UEN, @Usuario, 'SINAFECTAR', Moneda, TipoCambio, @Modulo,    @Mov,   @MovID, CrossDocking, SucursalOrigen, SucursalDestino, PosicionWMS 
FROM Inv
WHERE ID = @ID
SELECT @AlmacenOrigen = Almacen FROM Inv WHERE ID = @ID
SELECT @OrdenID = SCOPE_IDENTITY()
INSERT InvD (
ID,       Renglon, RenglonSub, RenglonID, Sucursal,  Almacen,  Articulo, SubCuenta, Cantidad, Unidad, Factor, CantidadInventario, Costo, CostoInv, FechaCaducidad)
SELECT @OrdenID, Renglon, RenglonSub, InvD.RenglonID, InvD.Sucursal, @Almacen, ArtCosto.Articulo, SubCuenta, CASE WHEN ISNULL(CantidadInventario,0) = 0 THEN Cantidad*Factor ELSE Cantidad END, Unidad, Factor, CantidadInventario, (ArtCosto.CostoPromedio*Factor)/Inv.TipoCambio, CostoInv, FechaCaducidad 
FROM InvD
JOIN Inv ON InvD.ID = Inv.ID
LEFT OUTER JOIN ArtCosto ON InvD.Articulo = ArtCosto.Articulo AND ArtCosto.Empresa = @Empresa AND ArtCosto.Sucursal = @Sucursal
WHERE InvD.ID = @ID
AND Cantidad > 0
END ELSE
IF @Modulo = 'PROD'
BEGIN
INSERT Inv (
Empresa,  Sucursal,  Mov,       Almacen,  FechaEmision, Concepto, Referencia, Proyecto, UEN, Usuario, Estatus,       Moneda, TipoCambio, OrigenTipo, Origen, OrigenID, PosicionDWMS, CrossDocking, SucursalOrigen, SucursalDestino) 
SELECT Empresa, Sucursal, @OrdenMov, @Almacen, FechaEmision, Concepto, Referencia, Proyecto, UEN, @Usuario, 'SINAFECTAR', Moneda, TipoCambio, @Modulo,    @Mov,   @MovID, PosicionDWMS, CrossDocking, SucursalOrigen, SucursalDestino    
FROM Prod
WHERE ID = @ID
SELECT @OrdenID = SCOPE_IDENTITY()
INSERT InvD (
ID,       Renglon, RenglonSub, RenglonID, Sucursal,  Almacen,  Articulo, SubCuenta, Cantidad, Unidad, Factor, CantidadInventario, Costo)
SELECT @OrdenID, Renglon, RenglonSub, ProdD.RenglonID, ProdD.Sucursal, @Almacen, ProdD.Articulo, SubCuenta, Cantidad, Unidad, Factor, CantidadInventario, (ArtCosto.CostoPromedio*Factor)/Prod.TipoCambio 
FROM ProdD
JOIN Prod ON ProdD.ID = Prod.ID
LEFT OUTER JOIN ArtCosto ON ProdD.Articulo = ArtCosto.Articulo AND ArtCosto.Empresa = @Empresa AND ArtCosto.Sucursal = @Sucursal
WHERE Prod.ID = @ID
END
INSERT SerieLoteMov (
Sucursal,  Empresa,   Modulo, ID,       RenglonID,   Articulo,   SubCuenta,   SerieLote,   Cantidad,   CantidadAlterna,   Propiedades,   Ubicacion,   Cliente,   Localizacion,   ArtCostoInv)
SELECT m.Sucursal, m.Empresa, 'INV',  @OrdenID, m.RenglonID, m.Articulo, m.SubCuenta, m.SerieLote, m.Cantidad, m.CantidadAlterna, m.Propiedades, m.Ubicacion, m.Cliente, m.Localizacion, m.ArtCostoInv
FROM SerieLoteMov m
JOIN InvD d ON d.ID = @OrdenID AND d.RenglonID = m.RenglonID AND d.Articulo = m.Articulo AND ISNULL(d.SubCuenta, '') = ISNULL(m.SubCuenta, '')
WHERE m.Modulo = @Modulo AND m.ID = @ID
END
IF @Modulo = 'COMS'
SELECT @Posicion = PosicionWMS FROM Compra WHERE ID = @ID
ELSE
IF @Modulo = 'INV'
SELECT @Posicion = PosicionWMS, @PosicionD = PosicionDWMS FROM Inv WHERE ID = @ID
ELSE
IF @Modulo = 'VTAS'
SELECT @Posicion = PosicionWMS FROM Venta WHERE ID = @ID
UPDATE Inv SET PosicionWMS = @Posicion WHERE ID = @OrdenID
EXEC spActualizarOrdenEntarimadoWMS @OrdenID, @ID, @Accion, @Modulo, @Posicion, @PosicionD
IF @OrdenID IS NOT NULL
BEGIN
EXEC spAfectar 'INV', @OrdenID, @Accion, 'TODO', @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @OrdenMov = Mov, @OrdenMovID = MovID FROM Inv WHERE ID = @OrdenID 
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'INV', @OrdenID, @OrdenMov, @OrdenMovID, @Ok OUTPUT
END
RETURN
END

