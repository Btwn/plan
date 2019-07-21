SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvBackOrderCliente
@Sucursal		int,
@Empresa		char(5),
@Usuario		char(10),
@Cliente		char(10),
@Articulo		char(20),
@SubCuenta		varchar(50),
@Cantidad		float,
@FactorCompra		float,
@ArtMoneda		char(10),
@Almacen		char(10),
@FechaAfectacion	datetime,
@FechaRegistro		datetime,
@Ejercicio		int,
@Periodo		int,
@Ok 			int	     	OUTPUT,
@OkRef 			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@ID			int,
@Mov			char(20),
@MovID			varchar(20),
@MovTipo			char(20),
@Renglon			float,
@RenglonSub		int,
@RenglonID			int,
@EsCargo			bit,
@PendienteReal		float,
@ObtenidoReal		float,
@PendienteDif 		float,
@NuevoPendiente		float,
@CantidadPendiente		float,
@CantidadPendienteReal 	float,
@CantidadReservada 	float,
@CantidadAReservar 	float,
@FactorVenta		float,
@UltCantidad		float,
@UltFecha			datetime,
@SucursalAlmacen		INT,
@ArtTipo				varchar(20)
SELECT @ArtTipo = Tipo FROM Art WITH(NOLOCK) WHERE Articulo = @Articulo
IF @ArtTipo = 'Servicio'
BEGIN
SELECT @OK = 20975, @OkRef = RTRIM(@Articulo)
RETURN
END
SELECT @PendienteReal = @Cantidad*@FactorCompra, @EsCargo = 1, @UltFecha = @FechaRegistro
EXEC spExtraerFecha @UltFecha OUTPUT
DECLARE crBackOrderCte CURSOR
FOR SELECT Venta.ID, Venta.Mov, Venta.MovID, Renglon, RenglonSub, VentaD.RenglonID, ISNULL(CantidadReservada, 0.0), ISNULL(CantidadPendiente, 0.0), ISNULL(NULLIF(VentaD.Factor, 0.0), 1.0), mt.Clave
FROM VentaD 
JOIN Venta WITH(NOLOCK) ON VentaD.ID = Venta.ID
JOIN MovTipo mt WITH(NOLOCK) ON mt.Modulo = 'VTAS' AND mt.Mov = Venta.Mov
WHERE Venta.Cliente = @Cliente
AND mt.Clave IN ('VTAS.P', 'VTAS.S', 'VTAS.F','VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX')
AND Estatus = 'PENDIENTE'
AND VentaD.Articulo = @Articulo
AND VentaD.SubCuenta = @SubCuenta
AND ISNULL(CantidadPendiente, 0.0) > 0.0
AND VentaD.Almacen = @Almacen
ORDER BY Venta.FechaRequerida, Venta.FechaEmision
OPEN crBackOrderCte
FETCH NEXT FROM crBackOrderCte INTO @ID, @Mov, @MovID, @Renglon, @RenglonSub, @RenglonID, @CantidadReservada, @CantidadPendiente, @FactorVenta, @MovTipo
WHILE @@FETCH_STATUS <> -1 AND @PendienteReal > 0.0 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @ObtenidoReal = 0.0, @CantidadPendienteReal = @CantidadPendiente*@FactorVenta
IF @CantidadPendienteReal > @PendienteReal SELECT @ObtenidoReal = @PendienteReal ELSE SELECT @ObtenidoReal = @CantidadPendienteReal
SELECT @CantidadAReservar = FLOOR(@ObtenidoReal/@FactorVenta)
IF @CantidadAReservar <> 0.0
BEGIN
IF @EsCargo = 1 SELECT @UltCantidad = @CantidadAReservar ELSE SELECT @UltCantidad = -@CantidadAReservar
UPDATE VentaD WITH(ROWLOCK)
SET CantidadPendiente = NULLIF(ISNULL(CantidadPendiente, 0.0) - @CantidadAReservar, 0.0), CantidadReservada = NULLIF(ISNULL(CantidadReservada, 0.0) + @CantidadAReservar, 0.0),
UltimoReservadoCantidad = @UltCantidad, UltimoReservadoFecha = @UltFecha
WHERE CURRENT OF crBackOrderCte
SELECT @NuevoPendiente = CantidadPendiente FROM VentaD WITH(NOLOCK) WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
SELECT @SucursalAlmacen = Sucursal FROM Alm WITH(NOLOCK) WHERE Almacen = @Almacen
EXEC spSaldo @SucursalAlmacen, 'AFECTAR', @Empresa, @Usuario, 'RESV', @ArtMoneda, NULL, @Articulo, @SubCuenta, @Almacen, NULL,
'VTAS', @ID, @Mov, @MovID, 1, NULL, @CantidadAReservar, @FactorVenta,
@FechaAfectacion, @Ejercicio, @Periodo, NULL, NULL, 0, 0, 0,
@Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID
EXEC spArtR @Empresa, 'VTAS', @Articulo, @SubCuenta, @Almacen, @MovTipo, @FactorVenta, NULL, @CantidadPendiente, @NuevoPendiente, NULL, NULL, NULL
EXEC xpInvReservado @ID, 'AFECTAR', NULL, @Empresa, @Usuario, 'VTAS', @Mov, @MovID, @Renglon, @RenglonSub,
@EsCargo, @CantidadAReservar, @FactorVenta, @Articulo, @SubCuenta, @FechaAfectacion,
@Ok OUTPUT, @OkRef OUTPUT
SELECT @PendienteReal = @PendienteReal - ABS(@ObtenidoReal)
END
END
IF @PendienteReal > 0.0 AND @Ok IS NULL
FETCH NEXT FROM crBackOrderCte INTO @ID, @Mov, @MovID, @Renglon, @RenglonSub, @RenglonID, @CantidadReservada, @CantidadPendiente, @FactorVenta, @MovTipo
END
CLOSE crBackOrderCte
DEALLOCATE crBackOrderCte
RETURN
END

