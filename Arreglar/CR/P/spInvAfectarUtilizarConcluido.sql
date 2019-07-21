SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvAfectarUtilizarConcluido
@Empresa		varchar(5),
@Modulo			varchar(5),
@FechaEmision		datetime,
@UtilizarID		int,
@AfectarMatando		bit,
@UtilizarEstatus	varchar(15)	OUTPUT,
@SumaPendiente		float		OUTPUT,
@FechaConclusion	datetime	OUTPUT,
@Ok			int		OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
SELECT @UtilizarEstatus = 'CONCLUIDO', @SumaPendiente = 0.0
IF @AfectarMatando = 1
BEGIN
IF @Modulo = 'VTAS' SELECT @SumaPendiente = Sum(ROUND(ISNULL(CantidadPendiente,0.0), 4)) + Sum(ROUND(ISNULL(CantidadReservada,0.0), 4)) FROM VentaD WHERE ID = @UtilizarID ELSE
IF @Modulo = 'COMS' SELECT @SumaPendiente = Sum(ROUND(ISNULL(CantidadPendiente,0.0), 4)) FROM CompraD WHERE ID = @UtilizarID ELSE
IF @Modulo = 'INV'  SELECT @SumaPendiente = Sum(ROUND(ISNULL(CantidadPendiente,0.0), 4)) + Sum(ROUND(ISNULL(CantidadReservada,0.0), 4)) FROM InvD   WHERE ID = @UtilizarID ELSE
IF @Modulo = 'PROD' SELECT @SumaPendiente = Sum(ROUND(ISNULL(CantidadPendiente,0.0), 4)) + Sum(ROUND(ISNULL(CantidadReservada,0.0), 4)) FROM ProdD  WHERE ID = @UtilizarID
IF @@ERROR <> 0 SELECT @Ok = 1
IF @SumaPendiente > 0.0 SELECT @UtilizarEstatus = 'PENDIENTE'
END
IF @UtilizarEstatus = 'CONCLUIDO' SELECT @FechaConclusion = @FechaEmision ELSE IF @UtilizarEstatus <> 'CANCELADO' SELECT @FechaConclusion = NULL
EXEC spValidarTareas @Empresa, @Modulo, @UtilizarID, @UtilizarEstatus, @Ok OUTPUT, @OkRef OUTPUT
IF @Modulo = 'VTAS' UPDATE Venta  SET FechaConclusion = @FechaConclusion, Estatus = @UtilizarEstatus WHERE ID = @UtilizarID ELSE
IF @Modulo = 'COMS' UPDATE Compra SET FechaConclusion = @FechaConclusion, Estatus = @UtilizarEstatus WHERE ID = @UtilizarID ELSE
IF @Modulo = 'INV'  UPDATE Inv    SET FechaConclusion = @FechaConclusion, Estatus = @UtilizarEstatus WHERE ID = @UtilizarID ELSE
IF @Modulo = 'PROD' UPDATE Prod   SET FechaConclusion = @FechaConclusion, Estatus = @UtilizarEstatus WHERE ID = @UtilizarID
IF @@ERROR <> 0 SELECT @Ok = 1
END

