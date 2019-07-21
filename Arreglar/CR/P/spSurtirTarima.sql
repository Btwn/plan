SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSurtirTarima
@Estacion	int,
@Empresa	varchar(5),
@Modulo		varchar(5),
@ModuloID	int,
@Mov		varchar(20),
@MovID		varchar(20),
@Accion		varchar(20),
@Conexion	bit		= 0

AS BEGIN
DECLARE
@MovTipo			varchar(20),
@Almacen			varchar(10),
@Posicion			varchar(10),
@Tarima			varchar(20),
@Articulo			varchar(20),
@SubCuenta			varchar(50),
@Unidad			varchar(50),
@Cantidad			float,
@CantidadPendiente		float,
@Renglon			float,
@RenglonSub			int,
@RenglonSubN		int,
@MAXRenglonID		int,
@Ok				int,
@OkRef			varchar(255),
@CfgVentaMultiAlmacen	bit,
@CfgCompraMultiAlmacen	bit,
@CfgInvMultiAlmacen		bit
IF @Modulo NOT IN ('VTAS', 'COMS', 'INV', 'PROD') RETURN
SELECT @Ok = NULL, @OkRef = NULL
SELECT @Accion = UPPER(@Accion)
SELECT @MovTipo = Clave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov
SELECT @CfgInvMultiAlmacen	= InvMultiAlmacen,
@CfgCompraMultiAlmacen	= CompraMultiAlmacen,
@CfgVentaMultiAlmacen  = VentaMultiAlmacen
FROM EmpresaCfg2
WHERE Empresa = @Empresa
IF @Conexion = 0
BEGIN TRANSACTION
IF @Accion = 'SUGERIR'
DELETE SurtirTarimaMov WHERE Estacion = @Estacion
IF @Accion = 'ACEPTAR'
BEGIN
SELECT @MAXRenglonID = 0
IF @Modulo = 'VTAS'
BEGIN
SELECT @Almacen = Almacen FROM Venta WHERE ID = @ModuloID
IF @CfgVentaMultiAlmacen = 0 UPDATE VentaD SET Almacen = @Almacen WHERE ID = @ModuloID AND Almacen <> @Almacen
SELECT @MAXRenglonID = ISNULL(MAX(RenglonID), 0) FROM VentaD WHERE ID = @ModuloID
END ELSE
IF @Modulo = 'INV'
BEGIN
SELECT @Almacen = Almacen FROM Inv WHERE ID = @ModuloID
IF @CfgInvMultiAlmacen = 0 UPDATE InvD SET Almacen = @Almacen WHERE ID = @ModuloID AND Almacen <> @Almacen
SELECT @MAXRenglonID = ISNULL(MAX(RenglonID), 0) FROM InvD WHERE ID = @ModuloID
END ELSE
IF @Modulo = 'COMS'
BEGIN
SELECT @Almacen = Almacen FROM Compra WHERE ID = @ModuloID
IF @CfgCompraMultiAlmacen = 0 UPDATE CompraD SET Almacen = @Almacen WHERE ID = @ModuloID AND Almacen <> @Almacen
SELECT @MAXRenglonID = ISNULL(MAX(RenglonID), 0) FROM CompraD WHERE ID = @ModuloID
END ELSE
IF @Modulo = 'PROD'
BEGIN
SELECT @Almacen = Almacen FROM Prod WHERE ID = @ModuloID
SELECT @MAXRenglonID = ISNULL(MAX(RenglonID), 0) FROM ProdD WHERE ID = @ModuloID
END
DECLARE crSurtirTarima CURSOR LOCAL FOR
SELECT Almacen, Posicion, Tarima, Articulo, NULLIF(RTRIM(SubCuenta), ''), NULLIF(RTRIM(Unidad), ''), SUM(Cantidad)
FROM SurtirTarimaMov
WHERE Estacion = @Estacion
GROUP BY Almacen, Posicion, Tarima, Articulo, NULLIF(RTRIM(SubCuenta), ''), NULLIF(RTRIM(Unidad), '')
OPEN crSurtirTarima
FETCH NEXT FROM crSurtirTarima INTO @Almacen, @Posicion, @Tarima, @Articulo, @SubCuenta, @Unidad, @Cantidad
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2 AND NULLIF(@Cantidad, 0.0) IS NOT NULL
BEGIN
SELECT @Renglon = NULL, @RenglonSub = NULL, @CantidadPendiente = NULL
IF @Modulo = 'VTAS'
BEGIN
SELECT TOP(1) @Renglon = Renglon, @RenglonSub = RenglonSub, @CantidadPendiente = NULLIF(Cantidad, 0.0)
FROM VentaD
WHERE ID = @ModuloID AND Almacen = @Almacen AND Articulo = @Articulo AND NULLIF(RTRIM(Tarima), '') IS NULL AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') 
IF ISNULL(@CantidadPendiente, 0.0) >= @Cantidad
BEGIN
SELECT @RenglonSubN = 0
SELECT @RenglonSubN = MAX(RenglonSub) FROM VentaD WHERE ID = @ModuloID AND Renglon = @Renglon
SELECT @RenglonSubN = ISNULL(@RenglonSubN, 0) + 1, @MAXRenglonID = ISNULL(@MAXRenglonID, 0) + 1
SELECT * INTO #VentaDetalle FROM cVentaD WHERE ID = @ModuloID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
UPDATE #VentaDetalle SET Cantidad = @Cantidad, Tarima = @Tarima, RenglonSub = @RenglonSubN, RenglonID = @MAXRenglonID
INSERT INTO cVentaD SELECT * FROM #VentaDetalle
DROP TABLE #VentaDetalle
UPDATE VentaD SET Cantidad = NULLIF(Cantidad - @Cantidad, 0.0) WHERE ID = @ModuloID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
END ELSE SELECT @Ok = 13240, @OkRef = @Articulo
END ELSE
IF @Modulo = 'INV'
BEGIN
SELECT TOP(1) @Renglon = Renglon, @RenglonSub = RenglonSub, @CantidadPendiente = NULLIF(Cantidad, 0.0)
FROM InvD
WHERE ID = @ModuloID AND Almacen = @Almacen AND Articulo = @Articulo AND NULLIF(RTRIM(Tarima), '') IS NULL AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') 
IF ISNULL(@CantidadPendiente, 0.0) >= @Cantidad
BEGIN
SELECT @RenglonSubN = 0
SELECT @RenglonSubN = MAX(RenglonSub) FROM InvD WHERE ID = @ModuloID AND Renglon = @Renglon
SELECT @RenglonSubN = ISNULL(@RenglonSubN, 0) + 1, @MAXRenglonID = ISNULL(@MAXRenglonID, 0) + 1
SELECT * INTO #InvDetalle FROM cInvD WHERE ID = @ModuloID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
UPDATE #InvDetalle SET Cantidad = @Cantidad, Tarima = @Tarima, RenglonSub = @RenglonSubN, RenglonID = @MAXRenglonID
INSERT INTO cInvD SELECT * FROM #InvDetalle
DROP TABLE #InvDetalle
UPDATE InvD SET Cantidad = NULLIF(Cantidad - @Cantidad, 0.0) WHERE ID = @ModuloID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
END ELSE SELECT @Ok = 13240, @OkRef = @Articulo
END ELSE
IF @Modulo = 'COMS'
BEGIN
SELECT TOP(1) @Renglon = Renglon, @RenglonSub = RenglonSub, @CantidadPendiente = NULLIF(Cantidad, 0.0)
FROM CompraD
WHERE ID = @ModuloID AND Almacen = @Almacen AND Articulo = @Articulo AND NULLIF(RTRIM(Tarima), '') IS NULL AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') 
IF ISNULL(@CantidadPendiente, 0.0) >= @Cantidad
BEGIN
SELECT @RenglonSubN = 0
SELECT @RenglonSubN = MAX(RenglonSub) FROM CompraD WHERE ID = @ModuloID AND Renglon = @Renglon
SELECT @RenglonSubN = ISNULL(@RenglonSubN, 0) + 1, @MAXRenglonID = ISNULL(@MAXRenglonID, 0) + 1
SELECT * INTO #CompraDetalle FROM cCompraD WHERE ID = @ModuloID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
UPDATE #CompraDetalle SET Cantidad = @Cantidad, Tarima = @Tarima, RenglonSub = @RenglonSubN, RenglonID = @MAXRenglonID
INSERT INTO cCompraD SELECT * FROM #CompraDetalle
DROP TABLE #CompraDetalle
UPDATE CompraD SET Cantidad = NULLIF(Cantidad - @Cantidad, 0.0) WHERE ID = @ModuloID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
END ELSE SELECT @Ok = 13240, @OkRef = @Articulo
END ELSE
IF @Modulo = 'PROD'
BEGIN
SELECT TOP(1) @Renglon = Renglon, @RenglonSub = RenglonSub, @CantidadPendiente = NULLIF(Cantidad, 0.0)
FROM ProdD
WHERE ID = @ModuloID AND Almacen = @Almacen AND Articulo = @Articulo AND NULLIF(RTRIM(Tarima), '') IS NULL AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') 
IF ISNULL(@CantidadPendiente, 0.0) >= @Cantidad
BEGIN
SELECT @RenglonSubN = 0
SELECT @RenglonSubN = MAX(RenglonSub) FROM ProdD WHERE ID = @ModuloID AND Renglon = @Renglon
SELECT @RenglonSubN = ISNULL(@RenglonSubN, 0) + 1, @MAXRenglonID = ISNULL(@MAXRenglonID, 0) + 1
SELECT * INTO #ProdDetalle FROM cProdD WHERE ID = @ModuloID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
UPDATE #ProdDetalle SET Cantidad = @Cantidad, Tarima = @Tarima, RenglonSub = @RenglonSubN, RenglonID = @MAXRenglonID
INSERT INTO cProdD SELECT * FROM #ProdDetalle
DROP TABLE #ProdDetalle
UPDATE ProdD SET Cantidad = NULLIF(Cantidad - @Cantidad, 0.0) WHERE ID = @ModuloID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
END ELSE SELECT @Ok = 13240, @OkRef = @Articulo
END
END
FETCH NEXT FROM crSurtirTarima INTO @Almacen, @Posicion, @Tarima, @Articulo, @SubCuenta, @Unidad, @Cantidad
END
CLOSE crSurtirTarima
DEALLOCATE crSurtirTarima
END
IF @Modulo = 'VTAS'
BEGIN
UPDATE Venta SET RenglonID = @MAXRenglonID WHERE ID = @ModuloID
DELETE VentaD WHERE ID = @ModuloID AND NULLIF(Cantidad, 0.0) IS NULL
END ELSE
IF @Modulo = 'INV'
BEGIN
UPDATE Inv SET RenglonID = @MAXRenglonID WHERE ID = @ModuloID
DELETE InvD WHERE ID = @ModuloID AND NULLIF(Cantidad, 0.0) IS NULL
END ELSE
IF @Modulo = 'COMS'
BEGIN
UPDATE Compra SET RenglonID = @MAXRenglonID WHERE ID = @ModuloID
DELETE CompraD WHERE ID = @ModuloID AND NULLIF(Cantidad, 0.0) IS NULL
END ELSE
IF @Modulo = 'PROD'
BEGIN
UPDATE Prod SET RenglonID = @MAXRenglonID WHERE ID = @ModuloID
DELETE ProdD WHERE ID = @ModuloID AND NULLIF(Cantidad, 0.0) IS NULL
END
IF @Conexion = 0
BEGIN
IF @Ok IS NULL
COMMIT TRANSACTION
ELSE
BEGIN
ROLLBACK TRANSACTION
EXEC spOk_RAISERROR @Ok, @OkRef
END
END
RETURN
END

