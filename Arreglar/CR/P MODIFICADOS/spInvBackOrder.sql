SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvBackOrder
@Sucursal		int,
@Accion			char(20),
@Estatus		char(15),
@EsEntrada		bit,
@Empresa		char(5),
@Usuario		char(10),
@OModulo		char(5),
@OID			int,
@OMov			char(20),
@OMovID			varchar(20),
@Modulo			varchar(10),
@Mov			varchar(20),
@MovID			varchar(20),
@Articulo		char(20),
@SubCuenta		varchar(50),
@MovUnidad		varchar(50),
@Cantidad		float		OUTPUT,
@FactorCompra		float,
@ArtMoneda		char(10),
@Almacen		char(10),
@FechaAfectacion	datetime,
@FechaRegistro		datetime,
@Ejercicio		int,
@Periodo		int,
@Ok 			int	     	OUTPUT,
@OkRef 			varchar(255)	OUTPUT,
@MovTipo		varchar(20) = NULL

AS BEGIN
IF @Estatus = 'PENDIENTE' AND @Accion IN ('RESERVARPARCIAL', 'RESERVAR', 'DESRESERVAR') RETURN
DECLARE
@DID			int,
@EsCargo			bit,
@ReservarEsCargo		bit,
@MovTipoOrigen		char(20),
@AlmacenOrigen		char(10),
@SucursalAlmacenOrigen	int,
@PendienteReal		float,
@Obtenido			float,
@ObtenidoReal		float,
@PendienteDif 		float,
@OrdenadoDif		float,
@CantidadOrdenada		float,
@CantidadOrdenadaReal	float,
@CantidadPendiente		float,
@CantidadPendienteReal	float,
@CantidadReservada 	float,
@CantidadReservadaReal 	float,
@CantidadAReservar 	float,
@FactorVenta		float,
@Renglon			float,
@RenglonSub		int,
@RenglonID			int,
@UltCantidad		float,
@UltFecha			datetime,
@EsCancelacion		BIT,
@ArtTipo			varchar(20)
SELECT @ArtTipo = Tipo FROM Art WITH(NOLOCK) WHERE Articulo = @Articulo
IF @ArtTipo = 'Servicio'
BEGIN
SELECT @OK = 20975, @OkRef = RTRIM(@Articulo)
RETURN
END
IF @Accion = 'CANCELAR' SELECT @EsCancelacion = 1 ELSE SELECT @EsCancelacion = 0
IF @MovTipo = 'COMS.CP' SELECT @EsCancelacion = ~@EsCancelacion
IF @MovTipo = 'VTAS.P' AND @Accion <> 'CANCELAR'  SELECT @EsCancelacion = ~@EsCancelacion
SELECT @PendienteReal = @Cantidad*@FactorCompra, @UltFecha = @FechaRegistro
EXEC spExtraerFecha @UltFecha OUTPUT
IF @Modulo = 'VTAS'
IF @MovTipo = 'VTAS.P'
DECLARE crBackOrder CURSOR
FOR SELECT Venta.ID, Renglon, RenglonSub, VentaD.RenglonID, ISNULL(CantidadOrdenada, 0.0), ISNULL(CantidadReservada, 0.0), ISNULL(CantidadPendiente, 0.0), VentaD.Factor, VentaD.Almacen, mt.Clave
FROM VentaD WITH(NOLOCK), Venta WITH(NOLOCK), MovTipo mt WITH(NOLOCK)
WHERE VentaD.ID = Venta.ID
AND Venta.Empresa = @Empresa
AND Venta.Mov = @Mov
AND Venta.MovID = @MovID
AND mt.Modulo = @Modulo
AND mt.Mov = @Mov
AND Estatus = 'AFECTANDO'
AND VentaD.Articulo = @Articulo
AND ISNULL(RTRIM(VentaD.SubCuenta), '') = ISNULL(RTRIM(@SubCuenta), '')
ELSE
DECLARE crBackOrder CURSOR
FOR SELECT Venta.ID, Renglon, RenglonSub, VentaD.RenglonID, ISNULL(CantidadOrdenada, 0.0), ISNULL(CantidadReservada, 0.0), ISNULL(CantidadPendiente, 0.0), VentaD.Factor, VentaD.Almacen, mt.Clave
FROM VentaD WITH(NOLOCK), Venta WITH(NOLOCK), MovTipo mt WITH(NOLOCK)
WHERE VentaD.ID = Venta.ID
AND Venta.Empresa = @Empresa
AND Venta.Mov = @Mov
AND Venta.MovID = @MovID
AND mt.Modulo = @Modulo
AND mt.Mov = @Mov
AND Estatus = 'PENDIENTE'
AND VentaD.Articulo = @Articulo
AND ISNULL(RTRIM(VentaD.SubCuenta), '') = ISNULL(RTRIM(@SubCuenta), '')
ELSE
IF @Modulo = 'INV'
DECLARE crBackOrder CURSOR
FOR SELECT Inv.ID, Renglon, RenglonSub, InvD.RenglonID, ISNULL(CantidadOrdenada, 0.0), ISNULL(CantidadReservada, 0.0), ISNULL(CantidadPendiente, 0.0), InvD.Factor, InvD.Almacen, mt.Clave
FROM InvD WITH(NOLOCK), Inv WITH(NOLOCK), MovTipo mt WITH(NOLOCK)
WHERE InvD.ID = Inv.ID
AND Inv.Empresa = @Empresa
AND Inv.Mov = @Mov
AND Inv.MovID = @MovID
AND mt.Modulo = @Modulo
AND mt.Mov = @Mov
AND Estatus = 'PENDIENTE'
AND InvD.Articulo = @Articulo
AND ISNULL(RTRIM(InvD.SubCuenta), '') = ISNULL(RTRIM(@SubCuenta), '')
ELSE
IF @Modulo = 'PROD'
DECLARE crBackOrder CURSOR
FOR SELECT e.ID, Renglon, RenglonSub, d.RenglonID, ISNULL(d.CantidadOrdenada, 0.0), ISNULL(d.CantidadReservada, 0.0), ISNULL(d.CantidadPendiente, 0.0), d.Factor, d.Almacen, mt.Clave
FROM ProdD d WITH(NOLOCK), Prod e WITH(NOLOCK), MovTipo mt WITH(NOLOCK)
WHERE d.ID = e.ID
AND e.Empresa = @Empresa
AND e.Mov = @Mov
AND e.MovID = @MovID
AND mt.Modulo = @Modulo
AND mt.Mov = @Mov
AND Estatus = 'PENDIENTE'
AND d.Articulo = @Articulo
AND ISNULL(RTRIM(d.SubCuenta), '') = ISNULL(RTRIM(@SubCuenta), '')
OPEN crBackOrder
FETCH NEXT FROM crBackOrder INTO @DID, @Renglon, @RenglonSub, @RenglonID, @CantidadOrdenada, @CantidadReservada, @CantidadPendiente, @FactorVenta, @AlmacenOrigen, @MovTipoOrigen
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @PendienteReal > 0.0 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @ObtenidoReal = 0.0, @CantidadPendienteReal = @CantidadPendiente*@FactorVenta,
@CantidadReservadaReal = @CantidadReservada*@FactorVenta,
@CantidadOrdenadaReal = @CantidadOrdenada*@FactorVenta
IF @EsEntrada = 0 SELECT @EsCargo = 1 ELSE SELECT @EsCargo = 0
IF @EsCancelacion = 0
BEGIN
IF @EsCargo = 0
BEGIN
IF @CantidadOrdenadaReal > 0.0
IF @CantidadOrdenadaReal > @PendienteReal SELECT @ObtenidoReal = -@PendienteReal ELSE SELECT @ObtenidoReal = -@CantidadOrdenadaReal
END ELSE
BEGIN
IF @CantidadPendienteReal > 0.0
IF @CantidadPendienteReal > @PendienteReal SELECT @ObtenidoReal = @PendienteReal ELSE SELECT @ObtenidoReal = @CantidadPendienteReal
END
END ELSE
BEGIN
IF @EsCargo = 0
BEGIN
IF @CantidadReservadaReal > 0.0
IF @CantidadReservadaReal > @PendienteReal SELECT @ObtenidoReal = @PendienteReal ELSE SELECT @ObtenidoReal = @CantidadReservadaReal
END ELSE
BEGIN
IF @CantidadOrdenadaReal > 0.0
IF @CantidadOrdenadaReal > @PendienteReal SELECT @ObtenidoReal = -@PendienteReal ELSE SELECT @ObtenidoReal = -@CantidadOrdenadaReal
END
END
SELECT @Obtenido = ROUND(@ObtenidoReal/@FactorVenta, 4)
IF @Obtenido <> 0.0
BEGIN
IF @EsEntrada = 1 AND @AlmacenOrigen = @Almacen
BEGIN
IF @EsCancelacion = 0 SELECT @ReservarEsCargo = 1 ELSE SELECT @ReservarEsCargo = 0
SELECT @CantidadAReservar = -@Obtenido
SELECT @OrdenadoDif = -@CantidadAReservar
IF @ReservarEsCargo = 1 SELECT @UltCantidad = @CantidadAReservar ELSE SELECT @UltCantidad = @CantidadAReservar
IF @Modulo = 'VTAS' UPDATE VentaD WITH(ROWLOCK) SET CantidadOrdenada = NULLIF(ISNULL(CantidadOrdenada, 0.0) - @CantidadAReservar, 0.0), CantidadReservada = NULLIF(ISNULL(CantidadReservada, 0.0) + @CantidadAReservar, 0.0), UltimoReservadoCantidad = @UltCantidad, UltimoReservadoFecha = @UltFecha WHERE CURRENT OF crBackOrder ELSE
IF @Modulo = 'INV'  UPDATE InvD   WITH(ROWLOCK) SET CantidadOrdenada = NULLIF(ISNULL(CantidadOrdenada, 0.0) - @CantidadAReservar, 0.0), CantidadReservada = NULLIF(ISNULL(CantidadReservada, 0.0) + @CantidadAReservar, 0.0), UltimoReservadoCantidad = @UltCantidad, UltimoReservadoFecha = @UltFecha WHERE CURRENT OF crBackOrder ELSE
IF @Modulo = 'PROD' UPDATE ProdD  WITH(ROWLOCK) SET CantidadOrdenada = NULLIF(ISNULL(CantidadOrdenada, 0.0) - @CantidadAReservar, 0.0), CantidadReservada = NULLIF(ISNULL(CantidadReservada, 0.0) + @CantidadAReservar, 0.0), UltimoReservadoCantidad = @UltCantidad, UltimoReservadoFecha = @UltFecha WHERE CURRENT OF crBackOrder
ELSE SELECT @Ok = 20650
INSERT BackOrderLog (Empresa,  OModulo,  OID,  OMov,  OMovID,  DModulo,  DID, DMov, DMovID, Articulo,  SubCuenta,  Cantidad,  Unidad)
VALUES (@Empresa, @OModulo, @OID, @OMov, @OMovID, @Modulo, @DID, @Mov, @MovID, @Articulo, @SubCuenta, @Cantidad, @MovUnidad)
SELECT @SucursalAlmacenOrigen = Sucursal FROM Alm WITH(NOLOCK) WHERE Almacen = @AlmacenOrigen
EXEC spSaldo @SucursalAlmacenOrigen, @Accion, @Empresa, @Usuario, 'RESV', @ArtMoneda, NULL, @Articulo, @SubCuenta, @AlmacenOrigen, NULL,
@Modulo, @DID, @Mov, @MovID, 1, NULL, @CantidadAReservar, @FactorVenta,
@FechaAfectacion, @Ejercicio, @Periodo, NULL, NULL, 0, 0, 0,
@Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID
EXEC spArtR @Empresa, @Modulo, @Articulo, @SubCuenta, @AlmacenOrigen, @MovTipoOrigen, @FactorVenta, NULL, NULL, NULL, @OrdenadoDif, NULL, NULL
EXEC xpInvReservado @DID, @Accion, NULL, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @Renglon, @RenglonSub,
@ReservarEsCargo, @CantidadAReservar, @FactorVenta, @Articulo, @SubCuenta, @FechaAfectacion,
@Ok OUTPUT, @OkRef OUTPUT
END ELSE
BEGIN
IF @Modulo = 'VTAS' UPDATE VentaD WITH(ROWLOCK) SET CantidadOrdenada = NULLIF(ISNULL(CantidadOrdenada, 0.0) + @Obtenido, 0.0), CantidadPendiente = NULLIF(ROUND(ISNULL(CantidadPendiente, 0.0) - @Obtenido, 10), 0.0) WHERE CURRENT OF crBackOrder ELSE
IF @Modulo = 'INV'  UPDATE InvD   WITH(ROWLOCK) SET CantidadOrdenada = NULLIF(ISNULL(CantidadOrdenada, 0.0) + @Obtenido, 0.0), CantidadPendiente = NULLIF(ROUND(ISNULL(CantidadPendiente, 0.0) - @Obtenido, 10), 0.0) WHERE CURRENT OF crBackOrder ELSE
IF @Modulo = 'PROD' UPDATE ProdD  WITH(ROWLOCK) SET CantidadOrdenada = NULLIF(ISNULL(CantidadOrdenada, 0.0) + @Obtenido, 0.0), CantidadPendiente = NULLIF(ROUND(ISNULL(CantidadPendiente, 0.0) - @Obtenido, 10), 0.0) WHERE CURRENT OF crBackOrder
ELSE SELECT @Ok = 20650
SELECT @PendienteDif = -@Obtenido, @OrdenadoDif = @Obtenido
EXEC spArtR @Empresa, @Modulo, @Articulo, @SubCuenta, @AlmacenOrigen, @MovTipoOrigen, @FactorVenta, @PendienteDif, NULL, NULL, @OrdenadoDif, NULL, NULL
END
SELECT @PendienteReal = @PendienteReal - ABS(@ObtenidoReal)
END
END
IF @PendienteReal > 0.0 AND @Ok IS NULL
BEGIN
FETCH NEXT FROM crBackOrder INTO @DID, @Renglon, @RenglonSub, @RenglonID, @CantidadOrdenada, @CantidadReservada, @CantidadPendiente, @FactorVenta, @AlmacenOrigen, @MovTipoOrigen
IF @@ERROR <> 0 SELECT @Ok = 1
END
END
CLOSE crBackOrder
DEALLOCATE crBackOrder
IF ROUND(@PendienteReal, 0) > 0.0 AND @EsEntrada = 0 AND @EsCancelacion = 0 SELECT @Ok = 20350, @OkRef = RTRIM(@Articulo)+'/'+RTRIM(@Mov)+' '+RTRIM(@MovID)
RETURN
END

