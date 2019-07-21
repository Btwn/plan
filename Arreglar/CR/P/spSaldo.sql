SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSaldo
@Sucursal		int,
@Accion		char(20),
@Empresa		char(5),
@Usuario		char(10),
@Rama		char(5),
@Moneda		char(10),
@TipoCambio		float,
@Cuenta		char(20),
@SubCuenta		varchar(50),
@Grupo		char(10),
@GrupoDestino	char(10),
@Modulo		char(5),
@ID			int,
@Mov			char(20),
@MovID		varchar(20),
@EsCargo             bit,
@Importe		money,
@ImporteU		float,
@Factor		float,
@Fecha		datetime,
@EjercicioRegistro	int,
@PeriodoRegistro	int,
@Aplica		char(20),
@AplicaID		varchar(20),
@SinAuxiliares	bit,
@AcumulaSinDetalles	bit,
@EsTipoSerie		bit,
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT,
@Renglon		float		= NULL,
@RenglonSub		int		= NULL,
@RenglonID		int		= NULL,
@SubGrupo		varchar(50)	= NULL,
@SubCuenta2		varchar(50)	= NULL,
@SubCuenta3		varchar(50)	= NULL,
@Proyecto		varchar(50)	= NULL,
@UEN			int		= NULL

AS BEGIN
DECLARE
@Cargo               money,
@Abono               money,
@CargoU              float,
@AbonoU              float,
@AcumulaEnLinea	 bit,
@GeneraAuxiliar	 bit,
@GeneraSaldo	 bit,
@AcumulaxEjercicio	 bit,
@AcumulaxPeriodo	 bit,
@Conciliar		 bit,
@EjercicioAfectacion int,
@PeriodoAfectacion	 int,
@EsTransferencia	 bit,
@EsMonetario	 bit,
@EsUnidades		 bit,
@EsResultados	 bit,
@InvNegativoU	 float,
@ConsignacionU	 float,
@f1	 		 float,
@f2	 		 float,
@WMS		bit,
@MovTipo	varchar(20)
SELECT @WMS = ISNULL(WMS, 0) FROM Alm WHERE Almacen = @Grupo
SELECT @MovTipo = Clave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov
IF ISNULL(@Importe, 0.0) = 0.0 AND ISNULL(@ImporteU, 0.0) = 0.0 RETURN
SELECT @ImporteU = @ImporteU * ISNULL(@Factor, 1.0)
SELECT @InvNegativoU  = 0.0,
@ConsignacionU = 0.0,
@Cargo         = 0.0, @CargoU = 0.0,
@Abono         = 0.0, @AbonoU = 0.0,
@Moneda        = ISNULL(RTRIM(@Moneda), ''),
@Grupo         = ISNULL(RTRIM(@Grupo), ''),
@SubGrupo      = ISNULL(RTRIM(@SubGrupo), ''),
@SubCuenta     = ISNULL(RTRIM(@SubCuenta), ''),
@SubCuenta2    = ISNULL(RTRIM(@SubCuenta2), ''),
@SubCuenta3    = ISNULL(RTRIM(@SubCuenta3), ''),
@Proyecto      = ISNULL(RTRIM(@Proyecto), ''),
@UEN		= ISNULL(@UEN, 0)
SELECT @AcumulaEnLinea    = AcumulaEnLinea,
@GeneraAuxiliar    = GeneraAuxiliar,
@GeneraSaldo       = GeneraSaldo,
@AcumulaxEjercicio = AcumuladoxEjercicio,
@AcumulaxPeriodo   = AcumuladoxPeriodo,
@Conciliar  	    = Conciliar,
@EsMonetario	    = EsMonetario,
@EsUnidades        = EsUnidades,
@EsResultados	    = EsResultados
FROM  Rama
WHERE Rama = @Rama
IF @@ERROR <> 0 SELECT @Ok = 1
IF @SinAuxiliares     = 1 SELECT @GeneraAuxiliar = 0
IF @AcumulaxEjercicio = 1 SELECT @EjercicioAfectacion = @EjercicioRegistro ELSE SELECT @EjercicioAfectacion = NULL
IF @AcumulaxPeriodo   = 1 SELECT @PeriodoAfectacion   = @PeriodoRegistro   ELSE SELECT @PeriodoAfectacion = NULL
IF @EsMonetario = 1 AND @EsUnidades = 0
BEGIN
IF @EsCargo = 1 SELECT @Cargo = @Importe ELSE SELECT @Abono = @Importe
EXEC spSaldoM @Sucursal, @Accion, @Empresa, @Rama, @Moneda, @TipoCambio, @Cuenta, @SubCuenta, @Grupo, @Modulo, @ID, @Mov, @MovID, @Cargo, @Abono,
@Fecha, @EjercicioAfectacion, @PeriodoAfectacion,
@AcumulaSinDetalles, @AcumulaEnLinea, @GeneraAuxiliar, @GeneraSaldo, @Conciliar, @Aplica, @AplicaID,
@EsResultados, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID,
@SubCuenta2 = @SubCuenta2, @SubCuenta3 = @SubCuenta3, @Proyecto = @Proyecto, @UEN = @UEN
END ELSE
BEGIN
IF @GrupoDestino IS NOT NULL SELECT @EsTransferencia = 1 ELSE SELECT @EsTransferencia = 0
IF @EsTransferencia = 1 SELECT @AbonoU = @ImporteU ELSE
IF @EsCargo = 1 SELECT @Cargo = @Importe, @CargoU = @ImporteU ELSE SELECT @Abono = @Importe, @AbonoU = @ImporteU
EXEC spSaldoU @Sucursal, @Accion, @Empresa, @Usuario, @Rama, @Moneda, @Cuenta, @SubCuenta, @Grupo, @Modulo, @ID, @Mov, @MovID,
@Cargo, @Abono, @CargoU, @AbonoU,
@Fecha, @EjercicioAfectacion, @PeriodoAfectacion,
@AcumulaSinDetalles, @AcumulaEnLinea, @GeneraAuxiliar, @GeneraSaldo, @Conciliar, @Aplica, @AplicaID,
@EsTransferencia, @EsResultados, @EsTipoSerie,
@InvNegativoU OUTPUT, @ConsignacionU OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID, @SubGrupo = @SubGrupo
SELECT @ImporteU = @ImporteU - @ConsignacionU
IF @EsTransferencia = 1 AND @Ok IS NULL
BEGIN
IF @Rama <> 'WMS'
EXEC spSaldoU @Sucursal, @Accion, @Empresa, @Usuario, @Rama, @Moneda, @Cuenta, @SubCuenta, @GrupoDestino, @Modulo, @ID, @Mov, @MovID,
0.0, 0.0, @ImporteU, 0.0,
@Fecha, @EjercicioAfectacion, @PeriodoAfectacion,
@AcumulaSinDetalles, @AcumulaEnLinea, @GeneraAuxiliar, @GeneraSaldo, @Conciliar, @Aplica, @AplicaID,
@EsTransferencia, @EsResultados, @EsTipoSerie,
@f1, @f2, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID, @SubGrupo = @SubGrupo
IF @ConsignacionU <> 0.0 AND @Ok IS NULL
BEGIN
EXEC spTransferirConsignacion @Empresa, @Cuenta, @SubCuenta, @Grupo, @GrupoDestino, @ConsignacionU, @Ok OUTPUT
IF @Ok IS NULL
BEGIN
EXEC spSaldoU @Sucursal, @Accion, @Empresa, @Usuario, 'CSG', @Moneda, @Cuenta, @SubCuenta, @Grupo, @Modulo, @ID, @Mov, @MovID,
0.0, 0.0, 0.0, @ConsignacionU,
@Fecha, @EjercicioAfectacion, @PeriodoAfectacion,
@AcumulaSinDetalles, @AcumulaEnLinea, @GeneraAuxiliar, @GeneraSaldo, @Conciliar, @Aplica, @AplicaID,
@EsTransferencia, 0, 0,
@f1, @f2, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID, @SubGrupo = @SubGrupo
EXEC spSaldoU @Sucursal, @Accion, @Empresa, @Usuario, 'CSG', @Moneda, @Cuenta, @SubCuenta, @GrupoDestino, @Modulo, @ID, @Mov, @MovID,
0.0, 0.0, @ConsignacionU, 0.0,
@Fecha, @EjercicioAfectacion, @PeriodoAfectacion,
@AcumulaSinDetalles, @AcumulaEnLinea, @GeneraAuxiliar, @GeneraSaldo, @Conciliar, @Aplica, @AplicaID,
@EsTransferencia, 0, 0,
@f1, @f2, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID, @SubGrupo = @SubGrupo
END
END
END
IF @Rama = 'INV' AND ROUND(@InvNegativoU - @ConsignacionU, 4) > 0.0 SELECT @Ok = 20025
IF @Rama = 'WMS' AND ROUND(@InvNegativoU - @ConsignacionU, 4) > 0.0 SELECT @Ok = 20025
END
IF @Rama = 'INV' AND @Accion = 'AFECTAR' AND @Modulo = 'INV' AND @WMS = 1 AND @MovTipo = 'INV.TMA' AND @Ok = 20025
SELECT @Ok = NULL
IF @Ok IS NOT NULL AND @OkRef IS NULL
BEGIN
SELECT @OkRef = @Cuenta
IF @SubCuenta IS NOT NULL AND @SubCuenta <> '' SELECT @OkRef = @OkRef+ ' ('+@SubCuenta+')'
END
RETURN
END

