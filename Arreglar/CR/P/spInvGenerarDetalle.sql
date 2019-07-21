SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvGenerarDetalle
@Sucursal		int,
@Modulo		char(5),
@ID                	int,
@Renglon		float,
@RenglonSub		int,
@GenerarID		int,
@GenerarDirecto	bit,
@Mov			char(20),
@MovID		varchar(20),
@Cantidad		float,
@Ok			int	OUTPUT

AS BEGIN
IF @GenerarDirecto = 1 SELECT @Mov = NULL, @MovID = NULL
IF @Modulo = 'VTAS'
BEGIN
SELECT * INTO #VentaDetalle FROM cVentaD WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #VentaDetalle SET Sucursal = @Sucursal, ID = @GenerarID, SustitutoArticulo = NULL, SustitutoSubCuenta = NULL, CantidadReservada = NULL, CantidadOrdenada = NULL, CantidadPendiente = NULL, CantidadA = NULL, CantidadCancelada = NULL, Aplica = @Mov, AplicaID = @MovID, Cantidad = @Cantidad, UltimoReservadoCantidad = NULL, UltimoReservadoFecha = NULL, AplicaRenglon = @Renglon
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #VentaDetalle SET DescuentoImporte = (Cantidad*Precio)*(DescuentoLinea/100.0)
IF @@ERROR <> 0 SELECT @Ok = 1
INSERT INTO cVentaD SELECT * FROM #VentaDetalle
IF @@ERROR <> 0 SELECT @Ok = 1
DROP TABLE #VentaDetalle
IF @@ERROR <> 0 SELECT @Ok = 1
END ELSE
IF @Modulo = 'PROD'
BEGIN
SELECT * INTO #ProdDetalle FROM cProdD WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #ProdDetalle SET Sucursal = @Sucursal, ID = @GenerarID, SustitutoArticulo = NULL, SustitutoSubCuenta = NULL, CantidadReservada = NULL, CantidadOrdenada = NULL, CantidadPendiente = NULL, CantidadA = NULL, CantidadCancelada = NULL, Aplica = @Mov, AplicaID = @MovID, Cantidad = @Cantidad, UltimoReservadoCantidad = NULL, UltimoReservadoFecha = NULL, AplicaRenglon = @Renglon
IF @@ERROR <> 0 SELECT @Ok = 1
INSERT INTO cProdD SELECT * FROM #ProdDetalle
IF @@ERROR <> 0 SELECT @Ok = 1
DROP TABLE #ProdDetalle
IF @@ERROR <> 0 SELECT @Ok = 1
END ELSE
IF @Modulo = 'COMS'
BEGIN
SELECT * INTO #CompraDetalle FROM cCompraD WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #CompraDetalle SET Sucursal = @Sucursal, ID = @GenerarID, CantidadPendiente = NULL, CantidadA = NULL, CantidadCancelada = NULL, Aplica = @Mov, AplicaID = @MovID, Cantidad = @Cantidad, AplicaRenglon = @Renglon
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #CompraDetalle SET DescuentoImporte = (Cantidad*Costo)*(DescuentoLinea/100.0)
IF @@ERROR <> 0 SELECT @Ok = 1
INSERT INTO cCompraD SELECT * FROM #CompraDetalle
IF @@ERROR <> 0 SELECT @Ok = 1
DROP TABLE #CompraDetalle
IF @@ERROR <> 0 SELECT @Ok = 1
END ELSE
IF @Modulo = 'INV'
BEGIN
SELECT * INTO #InvDetalle FROM cInvD WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #InvDetalle SET Sucursal = @Sucursal, ID = @GenerarID, CantidadReservada = NULL, CantidadOrdenada = NULL, CantidadPendiente = NULL, CantidadA = NULL, CantidadCancelada = NULL, Aplica = @Mov, AplicaID = @MovID, Cantidad = @Cantidad, UltimoReservadoCantidad = NULL, UltimoReservadoFecha = NULL, AplicaRenglon = @Renglon
IF @@ERROR <> 0 SELECT @Ok = 1
INSERT INTO cInvD SELECT * FROM #InvDetalle
IF @@ERROR <> 0 SELECT @Ok = 1
DROP TABLE #InvDetalle
IF @@ERROR <> 0 SELECT @Ok = 1
END
RETURN
END

