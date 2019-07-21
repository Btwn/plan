SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvAfectarUnidades
@Sucursal		int,
@Accion			char(20),
@Base			char(20),
@Empresa		char(5),
@Usuario		char(10),
@Modulo			char(5),
@ID			int,
@Mov			char(20),
@MovID			varchar(20),
@MovTipo		char(20),
@MovMoneda	      	char(10),
@MovTipoCambio	 	float,
@Estatus		char(15),
@Articulo		char(20),
@ArtMoneda		char(10),
@ArtTipoCambio		float,
@ArtTipo		char(20),
@SubCuenta		varchar(50),
@Almacen		char(10),
@AlmacenTipo		char(15),
@AlmacenDestino		char(10),
@AlmacenDestinoTipo	char(15),
@EsCargo        	bit,
@CantidadOriginal	float,
@Cantidad		float,
@Factor			float,
@Renglon		float,
@RenglonSub		int,
@RenglonID		int,
@RenglonTipo		char(1),
@FechaRegistro		datetime,
@FechaAfectacion   	datetime,
@Ejercicio		int,
@Periodo		int,
@AplicaMov		varchar(20),
@AplicaMovID		varchar(20),
@OrigenTipo		varchar(10),
@AfectarCostos		bit,
@AfectarPiezas		bit,
@AfectarVtasMostrador	bit,
@FacturarVtasMostrador	bit,
@AfectarConsignacion	bit,
@EsTransferencia	bit,
@CfgSeriesLotesMayoreo	bit,
@CfgFormaCosteo    	char(20),
@CfgTipoCosteo     	char(20),
@CantidadReservada	float,
@ReservadoParcial	float	     OUTPUT,
@UltRenglonIDJuego	int	     OUTPUT,
@CantidadJuego		float	     OUTPUT,
@CantidadMinimaJuego	int	     OUTPUT,
@UltReservadoCantidad 	float	     OUTPUT,
@UltReservadoFecha   	datetime     OUTPUT,
@AfectarCantidad	float	     OUTPUT,
@AfectarAlmacen		char(10)     OUTPUT,
@AfectarAlmacenDestino	char(10)     OUTPUT,
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT,
@Tarima			varchar(20) = NULL

AS BEGIN
DECLARE
@EsPrestamoGarantia			bit,
@NoEsCargo				bit,
@AlmFisico				char(10),
@AlmGarantia			char(10),
@AfectarRama	    		char(5),
@ArtCostoPromedio			float,
@AplicaCostoPromedio		float,
@EsTipoSerie			bit,
@CostoInvTotal			float,
@Disponible				float,
@FactorJuego			float,
@CfgPedidosReservarLineaCompleta	bit,
@AlmWMS                 bit,
@AlmDWMS                bit
SELECT @AlmWMS = WMS FROM Alm WHERE Almacen = @Almacen
SELECT @AlmDWMS = WMS FROM Alm WHERE Almacen = @AlmacenDestino
SELECT @AfectarAlmacen = @Almacen, @AfectarAlmacenDestino = @AlmacenDestino
SELECT @ReservadoParcial = 0, @EsTipoSerie = 0, @EsPrestamoGarantia = 0
IF @MovTipo IN ('INV.P', 'INV.R') AND @AlmacenTipo <> @AlmacenDestinoTipo AND (@AlmacenTipo IN ('NORMAL','PROCESO','GARANTIAS') OR @AlmacenDestinoTipo IN ('NORMAL','PROCESO','GARANTIAS'))
SELECT @EsPrestamoGarantia = 1
IF @Accion = 'RESERVARPARCIAL'
BEGIN
SELECT @CfgPedidosReservarLineaCompleta = PedidosReservarLineaCompleta FROM EmpresaCFG WHERE Empresa = @Empresa
IF @RenglonTipo = 'C' AND @Modulo IN ('VTAS', 'INV', 'PROD') AND (SELECT dbo.fxReservarJuego(@Empresa)) = 0
BEGIN
IF @UltRenglonIDJuego <> @RenglonID
BEGIN
SELECT @UltRenglonIDJuego = @RenglonID
EXEC spInvCantidadReservarJuego @Empresa, @Modulo, @ID, @Estatus, @Almacen, @AlmacenTipo,
@AfectarConsignacion, @RenglonID, @CantidadJuego OUTPUT, @CantidadMinimaJuego OUTPUT, @Ok OUTPUT
END
SELECT @FactorJuego = @CantidadOriginal/@CantidadJuego
SELECT @Cantidad = FLOOR(@CantidadMinimaJuego*@FactorJuego), @ReservadoParcial = FLOOR(@CantidadMinimaJuego*@FactorJuego)
END ELSE
BEGIN
EXEC spArtSubDisponible @Empresa, @Almacen, @Articulo, @ArtTipo, @SubCuenta, @AfectarConsignacion, @AlmacenTipo, @Factor, @Disponible OUTPUT, @Ok OUTPUT
IF @Disponible < 0 SELECT @Disponible = 0.0  
IF @Disponible < @Cantidad
BEGIN
IF @CfgPedidosReservarLineaCompleta = 0
SELECT @Cantidad = @Disponible, @ReservadoParcial = @Disponible
ELSE
SELECT @Cantidad = 0, @ReservadoParcial = 0
END
ELSE
SELECT @ReservadoParcial = @Cantidad
END
END
SELECT @AfectarCantidad = @Cantidad
IF @MovTipo IN ('VTAS.F','VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX') AND @Accion = 'AFECTAR' AND @Estatus = 'PENDIENTE'
EXEC spSaldo @Sucursal, 'DESRESERVAR', @Empresa, @Usuario, 'RESV', @ArtMoneda, NULL, @Articulo, @SubCuenta, @Almacen, @AlmacenDestino,
@Modulo, @ID, @Mov, @MovID, @EsCargo, NULL, @AfectarCantidad, @Factor,
@FechaAfectacion, @Ejercicio, @Periodo, @AplicaMov, @AplicaMovID, 0, 0, @EsTipoSerie,
@Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID
IF @Accion IN ('RESERVARPARCIAL', 'RESERVAR', 'DESRESERVAR') OR (@Accion = 'CANCELAR' AND @MovTipo IN ('VTAS.F','VTAS.FAR','VTAS.FC', 'VTAS.FG', 'VTAS.FX','VTAS.P','VTAS.S','INV.SOL','INV.OT','INV.OI','INV.SM') AND @CantidadReservada > 0.0)
BEGIN
SELECT @AfectarRama = 'RESV'
IF @Accion = 'CANCELAR'
BEGIN
SELECT @EsCargo = 0
SELECT @AfectarCantidad = @CantidadReservada
IF @AfectarCantidad > @Cantidad SELECT @AfectarCantidad = @Cantidad
END ELSE
IF @Accion = 'DESRESERVAR' SELECT @EsCargo = 0 ELSE SELECT @EsCargo = 1
END ELSE
BEGIN
SELECT @AfectarRama = 'INV'
IF @AlmacenTipo = 'GARANTIAS' AND @EsPrestamoGarantia = 0 SELECT @AfectarRama = 'GAR' ELSE
IF @AlmacenTipo = 'ACTIVOS FIJOS' AND @AfectarConsignacion = 0 SELECT @AfectarRama = 'AF' ELSE
IF @AfectarConsignacion  = 1 SELECT @AfectarRama = 'CSG' ELSE
IF @AfectarPiezas        = 1 SELECT @AfectarRama = 'PZA' ELSE
IF @AfectarVtasMostrador = 1
BEGIN
SELECT @AfectarRama = 'VMOS'
IF @EsCargo = 1 SELECT @EsCargo = 0 ELSE SELECT @EsCargo = 1
END
END
IF @EsTransferencia = 1 SELECT @EsCargo = 0
IF @ArtTipo IN ('SERIE', 'VIN') AND @CfgSeriesLotesMayoreo = 0 SELECT @EsTipoSerie = 1
IF @EsPrestamoGarantia = 1
BEGIN
IF @AlmacenTipo = 'GARANTIAS'
SELECT @AlmGarantia = @Almacen, @AlmFisico = @AlmacenDestino, @EsCargo = 1
ELSE
BEGIN
IF @MovTipo = 'INV.R'  SELECT @AlmGarantia = @Almacen, @AlmFisico = @AlmacenDestino, @EsCargo = 1, @afectarCostos = 0
ELSE SELECT @AlmGarantia = @AlmacenDestino, @AlmFisico = @Almacen, @EsCargo = 0, @afectarCostos = 0
END
IF @AfectarCostos = 1 AND @AfectarRama IN ('INV', 'AF')
SELECT @AfectarAlmacen = @AlmFisico, @AfectarAlmacenDestino = NULL
ELSE
EXEC spSaldo @Sucursal, @Accion, @Empresa, @Usuario, @AfectarRama, @ArtMoneda, NULL, @Articulo, @SubCuenta, @AlmFisico, NULL,
@Modulo, @ID, @Mov, @MovID, @EsCargo, NULL, @AfectarCantidad, @Factor,
@FechaAfectacion, @Ejercicio, @Periodo, @AplicaMov, @AplicaMovID, 0, 0, @EsTipoSerie,
@Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID
IF @EsCargo = 1 SELECT @NoEsCargo = 0 ELSE SELECT @NoEsCargo = 1
EXEC spSaldo @Sucursal, @Accion, @Empresa, @Usuario, 'GAR', @ArtMoneda, NULL, @Articulo, @SubCuenta, @AlmGarantia, NULL,
@Modulo, @ID, @Mov, @MovID, @NoEsCargo, NULL, @AfectarCantidad, @Factor,
@FechaAfectacion, @Ejercicio, @Periodo, @AplicaMov, @AplicaMovID, 0, 0, @EsTipoSerie,
@Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID
END
ELSE BEGIN
IF @FacturarVtasMostrador = 1 OR (@Accion ='CANCELAR' AND @MovTipo IN ('VTAS.F','VTAS.FAR','VTAS.FB') AND @OrigenTipo = 'VMOS')
BEGIN
/*      IF @Accion = 'CANCELAR'
IF @EsCargo = 1 SELECT @EsCargo = 0 ELSE SELECT @EsCargo = 1*/
EXEC spSaldo @Sucursal, @Accion, @Empresa, @Usuario, 'VMOS', @ArtMoneda, NULL, @Articulo, @SubCuenta, @Almacen, @AlmacenDestino,
@Modulo, @ID, @Mov, @MovID, @EsCargo, NULL, @AfectarCantidad, @Factor,
@FechaAfectacion, @Ejercicio, @Periodo, @AplicaMov, @AplicaMovID, 0, 0, @EsTipoSerie,
@Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID
/*      IF @Accion = 'CANCELAR' RETURN*/
END
IF @AfectarCostos = 1 AND @AfectarRama IN ('INV', 'AF')
SELECT @AfectarAlmacen = @Almacen, @AfectarAlmacenDestino = @AlmacenDestino
ELSE
EXEC spSaldo @Sucursal, @Accion, @Empresa, @Usuario, @AfectarRama, @ArtMoneda, NULL, @Articulo, @SubCuenta, @Almacen, @AlmacenDestino,
@Modulo, @ID, @Mov, @MovID, @EsCargo, NULL, @AfectarCantidad, @Factor,
@FechaAfectacion, @Ejercicio, @Periodo, @AplicaMov, @AplicaMovID, 0, 0, @EsTipoSerie,
@Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID
IF @MovTipo IN('INV.T','VTAS.VCR') AND @AlmWMS = 1 AND ISNULL(@Tarima,'') <> ''
EXEC spSaldo @Sucursal, @Accion, @Empresa, @Usuario, 'WMS', @ArtMoneda, NULL, @Articulo, @SubCuenta, @Almacen, @AlmacenDestino,
@Modulo, @ID, @Mov, @MovID, @EsCargo, NULL, @AfectarCantidad, @Factor,
@FechaAfectacion, @Ejercicio, @Periodo, @AplicaMov, @AplicaMovID, 0, 0, @EsTipoSerie,
@Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID, @SubGrupo = @Tarima 
IF @MovTipo IN('VTAS.VCR') AND @Accion = 'CANCELAR' AND @AlmDWMS = 1 AND ISNULL(@Tarima,'') <> ''
EXEC spSaldo @Sucursal, @Accion, @Empresa, @Usuario, 'WMS', @ArtMoneda, NULL, @Articulo, @SubCuenta, @AlmacenDestino, NULL,
@Modulo, @ID, @Mov, @MovID, 1, NULL, @AfectarCantidad, @Factor,
@FechaAfectacion, @Ejercicio, @Periodo, @AplicaMov, @AplicaMovID, 0, 0, @EsTipoSerie,
@Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID, @SubGrupo = @Tarima 
IF @AfectarRama = 'RESV' AND @AfectarCantidad <> 0.0
BEGIN
IF @EsCargo = 1 SELECT @UltReservadoCantidad = @AfectarCantidad ELSE SELECT @UltReservadoCantidad = -@AfectarCantidad
SELECT @UltReservadoFecha = @FechaRegistro
EXEC spExtraerFecha @UltReservadoFecha OUTPUT
EXEC xpInvReservado @ID, @Accion, @Base, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @Renglon, @RenglonSub,
@EsCargo, @AfectarCantidad, @Factor, @Articulo, @SubCuenta, @FechaAfectacion,
@Ok OUTPUT, @OkRef OUTPUT
END
IF @EsTransferencia = 1 AND @AfectarConsignacion = 1 AND @OK IS NULL
EXEC spTransferirConsignacion @Empresa, @Articulo, @SubCuenta, @Almacen, @AlmacenDestino, @Cantidad,
@Ok OUTPUT
END
RETURN
END

