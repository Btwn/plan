SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvAsignarRenglon
@Sucursal		int,
@Accion		char(20),
@Modulo		char(5),
@ID                	int,
@Renglon		float,
@RenglonSub		int,
@DestinoModulo	char(5),
@Destino		char(20),
@DestinoID		varchar(20),
@Cantidad		float,
@Ok			int	OUTPUT

AS BEGIN
IF @Modulo = 'COMS'
BEGIN
SELECT * INTO #CompraDetalle FROM cCompraD WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @Renglon = MAX(Renglon) + 2048 FROM CompraD WHERE ID = @ID
IF @Accion = 'DESASIGNAR' SELECT @DestinoModulo = NULL, @Destino = NULL, @DestinoID = NULL
UPDATE #CompraDetalle SET Sucursal = @Sucursal, Renglon = @Renglon, RenglonSub = 1, CantidadPendiente = @Cantidad, CantidadA = NULL, CantidadCancelada = NULL, DestinoTipo = @DestinoModulo, Destino = @Destino, DestinoID = @DestinoID, Cantidad = @Cantidad, AplicaRenglon = @Renglon
IF @@ERROR <> 0 SELECT @Ok = 1
INSERT INTO cCompraD SELECT * FROM #CompraDetalle
IF @@ERROR <> 0 SELECT @Ok = 1
END ELSE
IF @Modulo = 'PROD'
BEGIN
SELECT * INTO #ProdDetalle FROM cProdD WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @Renglon = MAX(Renglon) + 2048 FROM ProdD WHERE ID = @ID
IF @Accion = 'DESASIGNAR' SELECT @DestinoModulo = NULL, @Destino = NULL, @DestinoID = NULL
UPDATE #ProdDetalle SET Sucursal = @Sucursal, Renglon = @Renglon, RenglonSub = 1, CantidadPendiente = @Cantidad, CantidadA = NULL, CantidadCancelada = NULL, DestinoTipo = @DestinoModulo, Destino = @Destino, DestinoID = @DestinoID, Cantidad = @Cantidad
IF @@ERROR <> 0 SELECT @Ok = 1
INSERT INTO cProdD SELECT * FROM #ProdDetalle
IF @@ERROR <> 0 SELECT @Ok = 1
END
END

