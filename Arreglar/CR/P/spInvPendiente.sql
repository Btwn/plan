SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvPendiente
@ID			int,
@Modulo		char(5),
@Empresa            char(5),
@MovTipo		char(20),
@Almacen		char(10),
@AlmacenDestino	char(10),
@AplicaMov		char(20),
@AplicaMovID	varchar(20),
@AplicaMovTipo	char(20),
@Articulo		char(20),
@SubCuenta		varchar(50),
@MovUnidad		varchar(50),
@CantidadOrdenada	float		OUTPUT,
@CantidadPendiente	float	 	OUTPUT,
@CantidadReservada	float	 	OUTPUT,
@AplicaClienteProv	char(10) 	OUTPUT,
@Ok			int	 	OUTPUT,
@OkRef            	varchar(255)  	OUTPUT

AS BEGIN
DECLARE
@DelAlmacen	char(10),
@IDAplica	int
/** 28.07.2006 **/
IF @MovTipo IN ('INV.R', 'INV.EI') SELECT @DelAlmacen = @AlmacenDestino ELSE SELECT @DelAlmacen = @Almacen
SELECT @CantidadOrdenada = 0.0, @CantidadPendiente = 0.0, @CantidadReservada = 0.0, @AplicaClienteProv = NULL, @IDAplica = NULL
IF @Modulo = 'INV'
BEGIN
SELECT @IDAplica = MIN(Inv.ID),
@CantidadOrdenada = SUM(ISNULL(Cantidad, 0)-ISNULL(CantidadCancelada, 0)),
@CantidadPendiente = SUM(CantidadPendiente), @CantidadReservada = Sum(CantidadReservada)
FROM InvD, Inv
WHERE InvD.ID     = Inv.ID
AND Inv.Empresa = @Empresa
AND Inv.Mov     = @AplicaMov
AND Inv.MovID   = @AplicaMovID
AND Inv.Estatus = 'PENDIENTE'
AND InvD.Almacen= @DelAlmacen
AND Articulo    = @Articulo
AND ISNULL(RTRIM(SubCuenta), '') = ISNULL(RTRIM(@SubCuenta), '')
AND ISNULL(Unidad, '') = ISNULL(@MovUnidad, '')
END ELSE
IF @Modulo = 'PROD'
BEGIN
SELECT @IDAplica = MIN(e.ID),
@CantidadOrdenada = SUM(ISNULL(Cantidad, 0)-ISNULL(CantidadCancelada, 0)),
@CantidadPendiente = Sum(d.CantidadPendiente), @CantidadReservada = Sum(d.CantidadReservada)
FROM ProdD d, Prod e
WHERE d.ID       = e.ID
AND e.Empresa  = @Empresa
AND e.Mov      = @AplicaMov
AND e.MovID    = @AplicaMovID
AND e.Estatus  = 'PENDIENTE'
AND d.Almacen  = @DelAlmacen
AND d.Articulo = @Articulo
AND ISNULL(RTRIM(SubCuenta), '') = ISNULL(RTRIM(@SubCuenta), '')
AND ISNULL(d.Unidad, '') = ISNULL(@MovUnidad, '')
END ELSE
IF @Modulo = 'VTAS'
BEGIN
IF @AplicaMovTipo = 'VTAS.CO'
BEGIN
SELECT @IDAplica = MIN(Venta.ID),
@AplicaClienteProv = MIN(Venta.Cliente)
FROM VentaD, Venta
WHERE VentaD.ID     = Venta.ID
AND Venta.Empresa = @Empresa
AND Venta.Mov     = @AplicaMov
AND Venta.MovID   = @AplicaMovID
AND Venta.Estatus = 'CONFIRMAR'
AND VentaD.Almacen= @DelAlmacen
IF @AplicaClienteProv IS NOT NULL SELECT @CantidadPendiente = 1
END ELSE
IF @AplicaMovTipo IN ('VTAS.VC', 'VTAS.VCR')
BEGIN
SELECT @IDAplica = MIN(Venta.ID),
@CantidadOrdenada = SUM(ISNULL(Cantidad, 0)-ISNULL(CantidadCancelada, 0)),
@CantidadPendiente = Sum(CantidadPendiente), @CantidadReservada = Sum(CantidadReservada),
@AplicaClienteProv = MIN(Venta.Cliente)
FROM VentaD, Venta
WHERE VentaD.ID            = Venta.ID
AND Venta.Empresa        = @Empresa
AND Venta.Mov            = @AplicaMov
AND Venta.MovID          = @AplicaMovID
AND Venta.Estatus        = 'PENDIENTE'
AND Venta.AlmacenDestino = @DelAlmacen
AND Articulo             = @Articulo
AND ISNULL(RTRIM(SubCuenta), '') = ISNULL(RTRIM(@SubCuenta), '')
AND ISNULL(Unidad, '') = ISNULL(@MovUnidad, '')
END ELSE BEGIN
SELECT @IDAplica = MIN(Venta.ID),
@CantidadOrdenada = SUM(ISNULL(Cantidad, 0)-ISNULL(CantidadCancelada, 0)),
@CantidadPendiente = Sum(CantidadPendiente), @CantidadReservada = Sum(CantidadReservada),
@AplicaClienteProv = MIN(Venta.Cliente)
FROM VentaD, Venta
WHERE VentaD.ID     = Venta.ID
AND Venta.Empresa = @Empresa
AND Venta.Mov     = @AplicaMov
AND Venta.MovID   = @AplicaMovID
AND Venta.Estatus = 'PENDIENTE'
AND VentaD.Almacen= @DelAlmacen
AND Articulo      = @Articulo
AND ISNULL(RTRIM(SubCuenta), '') = ISNULL(RTRIM(@SubCuenta), '')
AND ISNULL(Unidad, '') = ISNULL(@MovUnidad, '')
IF @IDAplica IS NULL AND @MovTipo = @AplicaMovTipo
SELECT @IDAplica = MIN(Venta.ID),
@CantidadOrdenada = SUM(ISNULL(Cantidad, 0)-ISNULL(CantidadCancelada, 0)),
@CantidadPendiente = Sum(CantidadPendiente), @CantidadReservada = Sum(CantidadReservada),
@AplicaClienteProv = MIN(Venta.Cliente)
FROM VentaD, Venta
WHERE VentaD.ID     = Venta.ID
AND Venta.Empresa = @Empresa
AND Venta.Mov     = @AplicaMov
AND Venta.MovID   = @AplicaMovID
AND Venta.Estatus = 'PENDIENTE'
AND Articulo      = @Articulo
AND ISNULL(RTRIM(SubCuenta), '') = ISNULL(RTRIM(@SubCuenta), '')
AND Unidad        = @MovUnidad
END
END ELSE
IF @Modulo = 'COMS'
BEGIN
SELECT @IDAplica = MIN(Compra.ID),
@CantidadOrdenada = SUM(ISNULL(Cantidad, 0)-ISNULL(CantidadCancelada, 0)),
@CantidadPendiente = Sum(CantidadPendiente),
@AplicaClienteProv = MAX(Compra.Proveedor)
FROM CompraD, Compra
WHERE CompraD.ID     = Compra.ID
AND Compra.Empresa = @Empresa
AND Compra.Mov     = @AplicaMov
AND Compra.MovID   = @AplicaMovID
AND Compra.Estatus = 'PENDIENTE'
AND CompraD.Almacen= CASE WHEN @MovTipo = 'COMS.DG' OR @AplicaMovTipo IN ('COMS.R', 'COMS.O') THEN CompraD.Almacen ELSE @DelAlmacen END
AND Articulo       = @Articulo
AND ISNULL(RTRIM(SubCuenta), '') = ISNULL(RTRIM(@SubCuenta), '')
AND Unidad         = @MovUnidad
END
IF @@ERROR <> 0 SELECT @Ok = 1
IF @IDAplica IS NULL AND @AplicaMovTipo NOT IN ('CXC.CA', 'CXC.CAP')	
BEGIN
SELECT @Ok = 20181, @OkRef = 'Articulo: '+RTRIM(@Articulo)
END
IF @CantidadPendiente IS NULL SELECT @CantidadPendiente = 0.0
IF @CantidadReservada IS NULL SELECT @CantidadReservada = 0.0
RETURN
END

