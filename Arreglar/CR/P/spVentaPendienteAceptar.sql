SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVentaPendienteAceptar
@Estacion	int,
@ID		    int

AS BEGIN
DECLARE
@Empresa				char(5),
@Sucursal				int,
@Moneda					char(10),
@TipoCambio				float,
@Mov					char(20),
@MovID					varchar(20),
@MovTipo				char(20),
@Renglon				float,
@RenglonID				int,
@RenglonIDJuego			int,
@LModulo				char(5),
@LID					int,
@LRenglon				float,
@LRenglonSub			int,
@LRenglonID				int,
@FechaEmision			datetime,
@FechaRequerida			datetime,
@FechaEntrega			datetime,
@Codigo					varchar(50),
@Articulo				char(20),
@SubCuenta				varchar(50),
@ProdRuta				varchar(20),
@Precio					float,
@DescuentoTipo			char(1),
@DescuentoLinea			float,
@RenglonTipo			char(1),
@Almacen				char(10),
@AlmacenEncabezado		char(10),
@Proveedor				char(10),
@Cantidad				float,
@CantidadA				float,
@CantidadOrdenada		float,
@CantidadPendiente		float,
@CantidadReservada		float,
@CantidadInventario		float,
@Unidad					varchar(50),
@DescripcionExtra		varchar(100),
@PoliticaPrecios		varchar(255),
@EnviarA				int,
@Factor					float,
@Impuesto1				float,
@Impuesto2				float,
@Impuesto3				money,
@Agente					char(10),
@PrecioMoneda			char(10),
@PrecioTipoCambio		float,
@Costo					float,
@ContUso				varchar(20),
@OrdenCompra			varchar(50),
@Tarima					varchar(20)
SELECT @Renglon = 0.0,
@RenglonID = 0,
@Proveedor = NULL
SELECT @Empresa = v.Empresa,
@Sucursal = Sucursal,
@Moneda = v.Moneda,
@TipoCambio = v.TipoCambio,
@FechaEmision = v.FechaEmision,
@AlmacenEncabezado = v.Almacen
FROM Venta v
WHERE v.ID = @ID
SELECT @Renglon = ISNULL(MAX(Renglon), 0.0),
@RenglonID = ISNULL(MAX(RenglonID), 0)
FROM VentaD
WHERE ID = @ID
BEGIN TRANSACTION
DECLARE crLista CURSOR FOR
SELECT Modulo, ID, Renglon, RenglonSub
FROM ListaIDRenglon
WHERE Estacion = @Estacion
ORDER BY IDInterno
OPEN crLista
FETCH NEXT FROM crLista INTO @LModulo, @LID, @LRenglon, @LRenglonSub
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @DescripcionExtra = NULL
SELECT @Mov = e.Mov, @MovID = e.MovID, @RenglonTipo = RenglonTipo, @LRenglonID = d.RenglonID, @Codigo = d.Codigo, @Articulo = d.Articulo, @SubCuenta = d.SubCuenta, @Almacen = d.Almacen,
@CantidadOrdenada = ISNULL(d.Cantidad, 0.0)-ISNULL(d.CantidadCancelada, 0.0), @CantidadPendiente = ISNULL(d.CantidadPendiente, 0.0), @CantidadReservada = ISNULL(d.CantidadReservada, 0.0), @CantidadA = ISNULL(d.CantidadA, 0.0),
@Cantidad = ISNULL(d.CantidadPendiente, 0.0)+ISNULL(d.CantidadReservada, 0.0), @Unidad = d.Unidad, @Factor = d.Factor, @FechaRequerida = d.FechaRequerida,
@DescripcionExtra = d.DescripcionExtra,
@Precio = d.Precio, @DescuentoTipo = d.DescuentoTipo, @DescuentoLinea = d.DescuentoLinea,
@Impuesto1 = d.Impuesto1, @Impuesto2 = d.Impuesto2, @Impuesto3 = d.Impuesto3,
@Agente = d.Agente, @PoliticaPrecios = PoliticaPrecios, @PrecioMoneda = PrecioMoneda, @PrecioTipoCambio = PrecioTipoCambio,
@Costo = d.Costo, @ContUso = d.ContUso, @MovTipo = mt.Clave, @EnviarA = d.EnviarA, @OrdenCompra = d.OrdenCompra, @Tarima = d.Tarima
FROM Venta e, VentaD d, MovTipo mt
WHERE e.ID = d.ID AND d.ID = @LID AND d.Renglon = @LRenglon AND d.RenglonSub = @LRenglonSub
AND mt.Modulo = 'VTAS' AND mt.Mov = e.Mov
EXEC xpVentaPendienteAceptarCantidad @CantidadOrdenada, @CantidadPendiente, @CantidadReservada, @CantidadA, @Cantidad OUTPUT
IF NULLIF(@Cantidad, 0) IS NOT NULL
BEGIN
SELECT @Renglon = @Renglon + 2048.0, @RenglonID = @RenglonID + 1, @CantidadInventario = @Cantidad * @Factor
IF @RenglonTipo = 'J' SELECT @RenglonIDJuego = @RenglonID ELSE
IF @RenglonTipo = 'C' SELECT @RenglonID = @RenglonIDJuego
IF @MovTipo IN ('VTAS.VC', 'VTAS.VCR') SELECT @Almacen = @AlmacenEncabezado
INSERT VentaD (ID,  Renglon,  RenglonSub, RenglonID, RenglonTipo,  Aplica,  AplicaID,  Codigo,  Articulo, SubCuenta,   Almacen,  Cantidad,  Unidad,  Factor,  FechaRequerida,  Impuesto1,  Impuesto2,  Impuesto3,  DescripcionExtra,  Precio,  DescuentoTipo,  DescuentoLinea,  CantidadInventario,  Agente,  PoliticaPrecios,  PrecioMoneda,  PrecioTipoCambio,  EnviarA,  Costo,  ContUso, OrdenCompra, Tarima)
VALUES (@ID, @Renglon, 0,          @RenglonID, @RenglonTipo, @Mov,    @MovID,    @Codigo, @Articulo, @SubCuenta, @Almacen, @Cantidad, @Unidad, @Factor, @FechaRequerida, @Impuesto1, @Impuesto2, @Impuesto3, @DescripcionExtra, @Precio, @DescuentoTipo, @DescuentoLinea, @CantidadInventario, @Agente, @PoliticaPrecios, @PrecioMoneda, @PrecioTipoCambio, @EnviarA, @Costo, @ContUso, @OrdenCompra, @Tarima)
INSERT SerieLoteMov (Empresa, Sucursal, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Propiedades)
SELECT Empresa, @Sucursal, Modulo, @ID, @RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Propiedades
FROM SerieLoteMov
WHERE Modulo = 'VTAS' AND Empresa = @Empresa AND ID = @LID AND RenglonID = @LRenglonID AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
INSERT AnexoMovD (Sucursal, Rama, ID, Cuenta, Nombre, Direccion, Icono, Tipo, Orden, Comentario)
SELECT @Sucursal, 'VTAS', @ID, Cuenta, Nombre, Direccion, Icono, Tipo, Orden, Comentario
FROM AnexoMovD
WHERE Rama = 'VTAS' AND ID = @LID AND Cuenta = @Articulo
END
END
FETCH NEXT FROM crLista INTO @LModulo, @LID, @LRenglon, @LRenglonSub
END 
CLOSE crLista
DEALLOCATE crLista
UPDATE Venta SET Directo = 0, RenglonID = @RenglonID WHERE ID = @ID
DELETE ListaIDRenglon WHERE Estacion = @Estacion
COMMIT TRANSACTION
RETURN
END

