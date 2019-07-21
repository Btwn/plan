SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvGenerarEstadistica
@Empresa	char(5),
@Sucursal	int,
@Modulo		char(5),
@ID		int,
@Mov		varchar(20),
@MovID		varchar(20),
@Accion		varchar(20),
@Contacto	varchar(10),
@Ok 		int	     	OUTPUT,
@OkRef 		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@VentaID	int
IF @Modulo <> 'COMS' RETURN
IF @Accion = 'CANCELAR'
BEGIN
SELECT @VentaID = MIN(ID) FROM Venta WHERE OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID AND Estatus IN ('CONCLUIDO', 'PENDIENTE')
END ELSE
BEGIN
IF NOT EXISTS(SELECT * FROM Cte WHERE Cliente = @Contacto AND Estatus = 'ALTA') SELECT @Ok = 26065, @OkRef = @Contacto ELSE
IF NOT EXISTS(SELECT * FROM MovTipo WHERE Modulo = 'VTAS' AND Mov = @Mov AND Clave = 'VTAS.EST') SELECT @Ok = 10490, @OkRef = @Mov+' (Ventas)'
IF @Ok IS NULL
BEGIN
INSERT Venta (
Estatus,      Usuario, OrigenTipo, Origen, OrigenID, Mov, MovID, Concepto, Empresa, FechaEmision, Referencia, Sucursal, Cliente,   Almacen, Moneda, TipoCambio, ListaPreciosEsp, Proyecto, UEN, FormaEnvio)
SELECT 'SINAFECTAR', Usuario, @Modulo,    Mov,    MovID,    Mov, MovID, Concepto, Empresa, FechaEmision, Referencia, Sucursal, Proveedor, Almacen, Moneda, TipoCambio, ListaPreciosEsp, Proyecto, UEN, FormaEnvio
FROM Compra
WHERE ID = @ID
SELECT @VentaID = SCOPE_IDENTITY()
INSERT VentaD (
ID,       Renglon,  RenglonID,  RenglonTipo,  Codigo, Articulo,  SubCuenta,  Cantidad,  CantidadInventario,  Factor, Unidad,  Paquete, Costo, Precio,  Impuesto1,  Impuesto2,  Impuesto3,  Almacen,  DescripcionExtra, ContUso, ContUso2, ContUso3)
SELECT @VentaID, Renglon,  RenglonID,  RenglonTipo,  Codigo, Articulo,  SubCuenta,  Cantidad,  CantidadInventario,  Factor, Unidad,  Paquete, Costo, NULL,    Impuesto1,  Impuesto2,  Impuesto3,  Almacen,  DescripcionExtra, ContUso, ContUso2, ContUso3
FROM CompraD
WHERE ID = @ID AND EsEstadistica = 1
END
END
IF @Ok IS NULL AND @VentaID IS NOT NULL
BEGIN
EXEC spAfectar 'VTAS', @VentaID, @Accion, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'VTAS', @VentaID, @Mov, @MovID, @Ok OUTPUT
END
RETURN
END

