SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarConsumoChep
@Modulo			varchar(5),
@ID             int,
@Accion			varchar(20),
@Empresa        varchar(5),
@Sucursal		int,
@Usuario		varchar(10),
@Mov			varchar(20),
@MovID			varchar(20),
@MovTipo		varchar(20),
@Almacen		varchar(10),
@MovDestino		varchar(20),
@Ok             int         OUTPUT,
@OkRef          varchar(255)OUTPUT

AS BEGIN
DECLARE
@OrdenID			int,
@MovDestinoID		varchar(20),
@Posicion			varchar(10),
@Cantidad			float,
@TarimaChep			varchar(20),
@CantidadTarima		int,
@CantidadEstibas	int,
@Renglon			int,
@RenglonID			int,
@ArticuloD			varchar(20),
@SucursalD			int,
@AlmacenD			varchar(10),
@Unidad				varchar(50),
@FechaCaducidad		datetime,
@Precio				float,
@CantidadD			float
IF @Accion = 'CANCELAR'
SELECT @OrdenID = ID FROM Inv WITH(NOLOCK) WHERE Mov = @MovDestino AND OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
ELSE BEGIN
IF @Accion = 'RESERVARPARCIAL' SELECT @Accion = 'AFECTAR'
IF @Modulo = 'VTAS' AND EXISTS (SELECT * FROM CteTarimaChep WITH(NOLOCK) WHERE Cliente IN (SELECT Cliente FROM Venta WITH(NOLOCK) WHERE ID = @ID) AND Articulo IN (SELECT Articulo FROM VentaD WITH(NOLOCK) WHERE ID = @ID))
BEGIN
INSERT Inv (
Empresa,  Sucursal,  Mov,       Almacen,  FechaEmision, Concepto, Referencia, Proyecto, UEN, Usuario, Estatus,       Moneda, TipoCambio, OrigenTipo, Origen, OrigenID, PosicionWMS, Agente)
SELECT @Empresa, @Sucursal, @MovDestino, @Almacen, FechaEmision, Concepto, Referencia, Proyecto, UEN, @Usuario, 'SINAFECTAR', Moneda, TipoCambio, @Modulo,    @Mov,   @MovID, PosicionWMS, Agente
FROM Venta
WITH(NOLOCK) WHERE ID = @ID
SELECT @OrdenID = @@IDENTITY
SET @RenglonID = 1
SET @Renglon = 2048
DECLARE crCheap CURSOR FOR
SELECT SUM(d.Cantidad) / (t.CantidadTarima * t.CantidadEstibas), t.TarimaChep, t.CantidadTarima, t.CantidadEstibas, d.Sucursal, d.Almacen, d.Unidad, NULL, AVG(Precio), SUM(d.Cantidad)
FROM VentaD d
 WITH(NOLOCK) JOIN Venta v  WITH(NOLOCK) ON d.ID = v.ID
JOIN CteTarimaChep t
 WITH(NOLOCK) ON d.Articulo = t.Articulo AND d.Unidad = t.UnidadVenta AND v.Cliente = t.Cliente
WHERE d.ID = @ID AND d.Almacen = @Almacen AND NULLIF(RTRIM(Tarima), '') IS NULL
AND d.Articulo IN (SELECT Articulo FROM VentaD WITH(NOLOCK) WHERE ID = @ID)
GROUP BY d.Sucursal,  d.Almacen,  d.Articulo, d.Unidad, t.TarimaChep, t.CantidadTarima, t.CantidadEstibas
OPEN crCheap
FETCH NEXT FROM crCheap  INTO @Cantidad, @TarimaChep, @CantidadTarima, @CantidadEstibas, @SucursalD, @AlmacenD, @Unidad, @FechaCaducidad, @Precio, @CantidadD
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Cantidad =  ROUND((@Cantidad + .49),0)
INSERT InvD (
ID,       Renglon, RenglonSub, RenglonID, Sucursal,  Almacen,  Articulo, SubCuenta, Cantidad, Unidad, Factor, CantidadInventario, Costo)
SELECT @OrdenID, @Renglon, 0, @RenglonID, @SucursalD, @AlmacenD, @TarimaChep, NULL, @Cantidad, @Unidad, 1, @CantidadTarima, @Precio
SELECT @Renglon = @Renglon + 2048
SELECT @RenglonID = @RenglonID + 1
FETCH NEXT FROM crCheap  INTO @Cantidad, @TarimaChep, @CantidadTarima, @CantidadEstibas, @SucursalD, @AlmacenD, @Unidad, @FechaCaducidad, @Precio, @CantidadD
END
CLOSE crCheap
DEALLOCATE crCheap
END
END
IF @OrdenID IS NOT NULL AND @OK IS NULL
BEGIN
EXEC spAfectar 'INV', @OrdenID, @Accion, 'TODO', @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @MovDestino = Mov, @MovDestinoID = MovID FROM Inv WHERE ID = @OrdenID
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'INV', @OrdenID, @MovDestino, @MovDestinoID, @Ok OUTPUT
END
RETURN
END

