SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTransferirConsignacion
@Empresa		char(5),
@Articulo		char(20),
@SubCuenta		varchar(50),
@Almacen		char(10),
@AlmacenDestino		char(10),
@Cantidad		float,
@Ok                	int          OUTPUT

AS BEGIN
DECLARE
@ID			int,
@Renglon		float,
@RenglonSub 	int,
@Requiere   	float,
@Obtenido		float,
@Pendiente		float
SELECT @Requiere = @Cantidad, @SubCuenta = NULLIF(RTRIM(@SubCuenta), '')
DECLARE crTransferirConsig CURSOR
FOR SELECT CompraD.ID, CompraD.Renglon, CompraD.RenglonSub, ISNULL(CompraD.CantidadPendiente, 0.0)
FROM CompraD, Compra, MovTipo
WHERE Compra.Estatus = 'PENDIENTE'
AND MovTipo.Mov = Compra.Mov
AND MovTipo.Clave = 'COMS.CC'
AND CompraD.ID = Compra.ID
AND CompraD.Almacen = @Almacen
AND CompraD.Articulo = @Articulo
AND CompraD.SubCuenta = @SubCuenta
AND CompraD.CantidadPendiente > 0.0
ORDER BY CompraD.ID, CompraD.Renglon, CompraD.RenglonSub
OPEN crTransferirConsig
FETCH NEXT FROM crTransferirConsig INTO @ID, @Renglon, @RenglonSub, @Pendiente
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL AND @Requiere > 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Requiere < @Pendiente
BEGIN
SELECT @Obtenido = @Requiere
UPDATE CompraD SET Cantidad = Cantidad - @Obtenido, CantidadPendiente = CantidadPendiente - @Obtenido, CantidadInventario = (Cantidad - @Obtenido)*Factor WHERE CURRENT OF crTransferirConsig
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT * INTO #CompraDetalle FROM cCompraD WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @RenglonSub = MAX(RenglonSub)+1 FROM CompraD WHERE ID = @ID AND Renglon = @Renglon
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #CompraDetalle SET Cantidad = @Obtenido, CantidadPendiente = @Obtenido, Almacen = @AlmacenDestino, RenglonSub = @RenglonSub, CantidadInventario = @Obtenido * Factor, AplicaRenglon = @Renglon
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #CompraDetalle SET DescuentoImporte = (Cantidad*Costo)*(DescuentoLinea/100.0)
IF @@ERROR <> 0 SELECT @Ok = 1
INSERT INTO cCompraD SELECT * FROM #CompraDetalle
IF @@ERROR <> 0 SELECT @Ok = 1
END ELSE
BEGIN
SELECT @Obtenido = @Pendiente
UPDATE CompraD SET Almacen = @AlmacenDestino WHERE CURRENT OF crTransferirConsig
IF @@ERROR <> 0 SELECT @Ok = 1
END
SELECT @Requiere = @Requiere - @Obtenido
END
IF @Requiere > 0
FETCH NEXT FROM crTransferirConsig INTO @ID, @Renglon, @RenglonSub, @Pendiente
IF @@ERROR <> 0 SELECT @Ok = 1
END
CLOSE crTransferirConsig
DEALLOCATE crTransferirConsig
IF @Requiere > 0 AND @Ok IS NULL
SELECT @Ok = 30130
END

