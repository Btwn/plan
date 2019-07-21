SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvInitRenglon
@Empresa			char(5),
@CfgDecimalesCantidades	int,
@CfgMultiUnidades		bit,
@CfgMultiUnidadesNivel	char(20),
@CfgCompraFactorDinamico 	bit,
@CfgInvFactorDinamico   	bit,
@CfgProdFactorDinamico  	bit,
@CfgVentaFactorDinamico 	bit,
@CfgBloquearNotasNegativas	bit,
@AlVerificar		bit,
@Matando			bit,
@Accion			char(20),
@Base			char(20),
@Modulo			char(5),
@ID				int,		
@Renglon			float,		
@RenglonSub			int,		
@Estatus			char(15),
@EstatusNuevo		char(15),
@MovTipo			char(20),
@FacturarVtasMostrador	bit,
@EsTransferencia		bit,
@AfectarConsignacion	bit,
@ExplotandoSubCuenta	bit,
@AlmacenTipo		char(15),
@AlmacenDestinoTipo		char(15),
@Articulo			char(20),
@MovUnidad			varchar(50),
@ArtUnidad			varchar(50),
@ArtTipo			varchar(20),
@RenglonTipo		char(1),
@AplicaMovTipo		varchar(20),
@CantidadOriginal		float,
@CantidadInventario		float,
@CantidadPendiente		float,
@CantidadA			float,
@DetalleTipo		varchar(20),
@Cantidad			float		OUTPUT,
@CantidadCalcularImporte	float		OUTPUT,
@CantidadReservada		float		OUTPUT,
@CantidadOrdenada		float		OUTPUT,
@EsEntrada			bit		OUTPUT,
@EsSalida			bit		OUTPUT,
@SubCuenta			varchar(50)	OUTPUT,
@AfectarPiezas		bit		OUTPUT,
@AfectarCostos		bit		OUTPUT,
@AfectarUnidades		bit		OUTPUT,
@Factor			float		OUTPUT,
@Ok				int		OUTPUT,
@OkRef			varchar(255)	OUTPUT,
@Seccion			int		= NULL

AS BEGIN
DECLARE
@CantidadNegativa		bit,
@Decimales			int,
@EsPrestamoGarantia		bit,
@EsFacturaPendiente 	bit
SELECT @Decimales = @CfgDecimalesCantidades, @CantidadNegativa = 0
IF @ArtTipo = 'ESTRUCTURA' SELECT @Ok = 20680
IF @MovTipo = 'INV.CP' AND @AlVerificar = 0 SELECT @MovTipo = 'INV.A'
SELECT @Cantidad = /*ROUND(*/@CantidadOriginal/*, 10)*/, @EsEntrada = 0, @EsSalida = 0, @AfectarUnidades = 0, @EsPrestamoGarantia = 0, @EsFacturaPendiente = 0
IF @Cantidad < 0 SELECT @CantidadNegativa = 1
IF @Modulo NOT IN ('VTAS', 'INV', 'PROD') SELECT @CantidadReservada = 0.0, @CantidadOrdenada = 0.0
IF @MovTipo = 'INV.TMA'
BEGIN
IF @Seccion IS NULL
SELECT @EsSalida = 1
ELSE
SELECT @EsEntrada = 1
END
IF @MovTipo IN ('VTAS.D', 'VTAS.DR', 'VTAS.DFC', 'COMS.F', 'COMS.FL', 'COMS.EG', 'COMS.EI', 'COMS.IG', 'COMS.CC', 'INV.E', 'INV.EP', 'INV.EI', 'INV.TIS', 'PROD.E') OR
(@MovTipo = 'INV.A' AND @Cantidad > 0.0) OR
(@MovTipo IN ('VTAS.N', 'VTAS.NO', 'VTAS.NR', 'VTAS.FM', 'VTAS.F','VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX') AND @Cantidad < 0.0)
SELECT @EsEntrada = 1
ELSE
IF @MovTipo IN ('VTAS.R', 'VTAS.SG', 'COMS.D', 'COMS.DG', 'COMS.DC', 'INV.S', 'INV.SI', 'INV.CP') OR
(@MovTipo = 'INV.A' AND @Cantidad < 0.0) OR
(@MovTipo IN ('VTAS.N', 'VTAS.NO', 'VTAS.NR', 'VTAS.FM', 'VTAS.F','VTAS.FAR', 'VTAS.FC', 'VTAS.FG'/*, 'VTAS.FX'*/) AND @Cantidad > 0.0)
SELECT @EsSalida = 1
ELSE
IF @MovTipo = 'INV.CM'
BEGIN
IF UPPER(@DetalleTipo) NOT IN ('SALIDA', 'DEVOLUCION', 'MERMA', 'DESPERDICIO') SELECT @Ok = 25390
IF UPPER(@DetalleTipo) = 'SALIDA' SELECT @EsSalida = 1 ELSE SELECT @EsEntrada = 1
END
IF @MovTipo IN ('VTAS.F','VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX') AND (@EstatusNuevo = 'PENDIENTE' OR (@Estatus = 'PENDIENTE' AND @Accion = 'CANCELAR')) SELECT @EsSalida = 0, @EsFacturaPendiente = 1
IF @Accion = 'CANCELAR'
BEGIN
IF @EsEntrada = 1 SELECT @EsEntrada = 0, @EsSalida = 1 ELSE
IF @EsSalida  = 1 SELECT @EsEntrada = 1, @EsSalida = 0
END
IF @MovTipo IN ('INV.P', 'INV.R') AND @AlmacenTipo <> @AlmacenDestinoTipo AND @AlmacenDestinoTipo IS NOT NULL AND (@AlmacenTipo IN ('NORMAL','PROCESO','GARANTIAS') OR @AlmacenDestinoTipo IN ('NORMAL','PROCESO','GARANTIAS'))
BEGIN
SELECT @EsPrestamoGarantia = 1
IF @AlmacenDestinoTipo = 'GARANTIAS' SELECT @EsSalida = 1 
END
IF @Accion = 'CANCELAR' AND @Base = 'TODO'
BEGIN
IF @Estatus = 'PENDIENTE' SELECT @Cantidad = @CantidadPendiente + @CantidadReservada
END ELSE
BEGIN
IF @ExplotandoSubCuenta = 0 AND @MovTipo <> 'INV.IF'
BEGIN
IF @Base = 'PENDIENTE'
BEGIN
SELECT @Cantidad = @CantidadPendiente
IF @Accion NOT IN ('RESERVAR', 'DESRESERVAR', 'RESERVARPARCIAL', 'ASIGNAR', 'DESASIGNAR')
SELECT @Cantidad = @Cantidad + @CantidadReservada
END ELSE
IF @Base = 'SELECCION' SELECT @Cantidad = @CantidadA ELSE
IF @Base = 'RESERVADO' SELECT @Cantidad = @CantidadReservada ELSE
IF @Base = 'ORDENADO'  SELECT @Cantidad = @CantidadOrdenada
END
END
IF @MovTipo = 'INV.CM' AND UPPER(@DetalleTipo) <> 'SALIDA' AND @Cantidad >= 0.0
BEGIN
SELECT @Ok = 25360
RETURN
END
IF (@MovTipo IN ('INV.A','VTAS.N','VTAS.NO','VTAS.NR','VTAS.FM','VTAS.F','VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX') AND @Cantidad < 0.0) OR (@MovTipo = 'INV.CM' AND UPPER(@DetalleTipo) <> 'SALIDA')
SELECT @Cantidad = @Cantidad * -1
/*IF @ArtTipo = 'DOBLE UNIDAD' AND UPPER(@SubCuenta) = 'PIEZAS'
SELECT @AfectarPiezas = 1
ELSE*/ SELECT @AfectarPiezas = 0
IF (@EsEntrada = 1 OR @EsSalida = 1 OR @MovTipo IN ('COMS.B', 'COMS.CA', 'COMS.GX', 'INV.TC'))
AND @AfectarPiezas = 0
AND @ArtTipo NOT IN ('JUEGO', 'SERVICIO')
AND @AfectarConsignacion = 0
AND @MovTipo NOT IN ('VTAS.N', 'VTAS.NO', 'VTAS.NR', 'VTAS.FM', 'COMS.OG', 'COMS.IG', 'COMS.DG')
SELECT @AfectarCostos = 1
ELSE SELECT @AfectarCostos = 0
IF (@EsEntrada = 1 OR @EsSalida = 1 OR @EsTransferencia = 1 OR @Accion IN ('RESERVARPARCIAL','RESERVAR','DESRESERVAR') OR (@Accion = 'CANCELAR' AND @CantidadReservada > 0)) AND @ArtTipo NOT IN ('JUEGO','SERVICIO')
SELECT @AfectarUnidades = 1
IF @AfectarUnidades = 0 AND @Accion IN ('RESERVAR', 'DESRESERVAR') SELECT @Cantidad = 0.0
IF @EsPrestamoGarantia = 0 AND (@AlmacenTipo='GARANTIAS' OR @AlmacenDestinoTipo='GARANTIAS') SELECT @AfectarCostos = 0
IF @AplicaMovTipo = 'VTAS.R' AND @MovTipo IN ('VTAS.F','VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX') AND @EsFacturaPendiente = 0 SELECT @AfectarUnidades = 0, @AfectarCostos = 0
IF @AplicaMovTipo = 'VTAS.R' AND @MovTipo = 'VTAS.R' SELECT @AfectarUnidades = 0
IF @MovTipo = 'VTAS.FM' AND @Estatus = 'PROCESAR' AND @Accion <> 'CANCELAR' SELECT @AfectarCostos = 1
IF @AfectarPiezas = 1 OR @ArtTipo IN ('JUEGO', 'SERVICIO') SELECT @AfectarCostos = 0
IF @MovTipo IN ('INV.CM', 'PROD.E') AND UPPER(@DetalleTipo) IN ('MERMA', 'DESPERDICIO') SELECT @AfectarCostos = 0
IF @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR') AND @Matando = 0 AND (@CfgMultiUnidades = 1 OR @ArtTipo = 'PARTIDA') AND @Ok IS NULL
BEGIN
EXEC xpUnidadFactorMov @Empresa, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @CfgCompraFactorDinamico, @CfgInvFactorDinamico, @CfgProdFactorDinamico, @CfgVentaFactorDinamico,
@Accion, @Base, @Modulo, @ID, @Renglon, @RenglonSub, @Estatus, @EstatusNuevo, @MovTipo, @EsTransferencia,
@AfectarConsignacion, @AlmacenTipo, @AlmacenDestinoTipo,
@Articulo, @SubCuenta, @MovUnidad, @ArtUnidad, @ArtTipo, @RenglonTipo, @AplicaMovTipo,
@Cantidad, @CantidadInventario,
@Factor OUTPUT, @Decimales OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @AlVerificar = 1 AND @Decimales <= 10 AND @Modulo <> 'PROD'
IF ROUND(@Cantidad, 10) <> ROUND(@Cantidad, @Decimales) SELECT @Ok = 20550
END
IF @CantidadNegativa = 1 AND @Cantidad > 0.0 AND @ArtTipo = 'SERVICIO' AND @MovTipo NOT IN ('VTAS.N','VTAS.NO','VTAS.NR','VTAS.FM')
SELECT @CantidadCalcularImporte = -@Cantidad
ELSE SELECT @CantidadCalcularImporte = @Cantidad
IF @CantidadNegativa = 1 AND @MovTipo NOT IN ('VTAS.EST', 'VTAS.N','VTAS.NO','VTAS.NR','VTAS.FM','INV.A','INV.EST') AND @ArtTipo <> 'SERVICIO' AND @FacturarVtasMostrador = 0 AND @Accion <> 'CANCELAR'
SELECT @Ok = 20010
IF @CantidadNegativa = 1 AND @CfgBloquearNotasNegativas = 1 AND @MovTipo IN ('VTAS.N','VTAS.NO','VTAS.NR','VTAS.FM') AND @Ok IS NULL
SELECT @Ok = 65070
/*
EXEC spMovTipoInstruccionBit @Modulo, @Mov, 'AfectarCostos',   @AfectarCostos   OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spMovTipoInstruccionBit @Modulo, @Mov, 'AfectarUnidades', @AfectarUnidades OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
*/
IF @MovTipo = 'COMS.GX'
IF (SELECT ISNULL(EsEstadistica, 0) FROM CompraD WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub) = 1
SELECT @AfectarUnidades = 0, @AfectarCostos = 0
EXEC xpInvInitRenglon @Empresa, @CfgDecimalesCantidades, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @CfgCompraFactorDinamico, @CfgInvFactorDinamico, @CfgProdFactorDinamico, @CfgVentaFactorDinamico, @CfgBloquearNotasNegativas,
@AlVerificar, @Matando, @Accion, @Base, @Modulo, @ID, @Renglon, @RenglonSub, @Estatus, @EstatusNuevo, @MovTipo, @FacturarVtasMostrador, @EsTransferencia, @AfectarConsignacion, @ExplotandoSubCuenta,
@AlmacenTipo, @AlmacenDestinoTipo, @Articulo, @MovUnidad, @ArtUnidad, @ArtTipo, @RenglonTipo, @AplicaMovTipo, @CantidadOriginal,@CantidadInventario, @CantidadPendiente, @CantidadA, @DetalleTipo,
@Cantidad OUTPUT, @CantidadCalcularImporte OUTPUT, @CantidadReservada OUTPUT, @CantidadOrdenada OUTPUT,
@EsEntrada OUTPUT, @EsSalida OUTPUT, @SubCuenta OUTPUT, @AfectarPiezas OUTPUT, @AfectarCostos OUTPUT, @AfectarUnidades OUTPUT, @Factor OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
RETURN
END

