SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSaldoU
@Sucursal    int,
@Accion		char(20),
@Empresa		char(5),
@Usuario		char(10),
@Rama		char(5),
@Moneda		char(10),
@Cuenta		char(20),
@SubCuenta   varchar(50),
@Grupo		char(10),
@Modulo		char(5),
@ID			int,
@Mov			char(20),
@MovID		varchar(20),
@Cargo		money,
@Abono		money,
@CargoU		float,
@AbonoU		float,
@Fecha		datetime,
@EjercicioAfectacion int,
@PeriodoAfectacion   int,
@AcumulaSinDetalles	bit,
@AcumulaEnLinea	    bit,
@GeneraAuxiliar	    bit,
@GeneraSaldo	        bit,
@Conciliar		    bit,
@Aplica		        char(20),
@AplicaID		    varchar(20),
@EsTransferencia bit,
@EsResultados	bit,
@EsTipoSerie		bit,
@InvNegativoU   	float 		OUTPUT,
@ConsignacionU	float   	OUTPUT,
@Ok			    int		OUTPUT,
@OkRef		    varchar(255)	OUTPUT,
@Renglon		    float		= NULL,
@RenglonSub		int		= NULL,
@RenglonID		int		= NULL,
@SubGrupo		varchar(20)	= NULL

AS BEGIN
DECLARE
@FechaSinHora       datetime,
@SubCuentaAcum	varchar(50),
@ImporteConciliarU	float,
@TempU	   	float,
@CargoAuxU		float,
@AbonoAuxU		float,
@SaldoAnteriorU 	float,
@ImporteConciliar	money,
@Temp	   	money,
@CargoAux		money,
@AbonoAux		money,
@SaldoAnterior 	money,
@EsCancelacion 	bit,
@CantidadU		float,
@INV		float,
@RESV		float,
@VMOS		float,
@GAR		float,
@CSG		float,
@AF			float,
@PZA		float,
@TMACargoU		float,
@TMAAbonoU		float,
@IDGenerar		int, 
@WMS			bit,
@MovTipo		varchar(20),
@IDAplica		varchar(20),
@Aplica2		varchar(20),
@AplicaID2		varchar(20),
@IDAplica2		varchar(20),
@Articulo		varchar(20),
@AlmPosTipo		varchar(20),
@EsCEDIS		bit,
@OrigenMovtipo	varchar(20),
@WMSAuxiliar	bit, 
@OrigenMovTipoc varchar(20)
SELECT @WMSAuxiliar = WMSAuxiliar FROM Version 
SELECT @SubGrupo = ISNULL(RTRIM(@SubGrupo), '')
IF @Rama IN('INV','WMS') AND  @SubGrupo <> ''
SELECT @SubGrupo = ISNULL(dbo.fnAlmacenTarima(@Grupo, @SubGrupo), '')
ELSE SELECT @SubGrupo = ''
SELECT @WMS = WMS FROM Alm WHERE Almacen = @Grupo
SELECT @MovTipo = Clave FROM MovTipo WHERE Modulo = 'INV' AND Mov = @Mov
IF @WMS = 1 AND @MovTipo = 'INV.TMA' AND ISNULL(@SubGrupo,'') = ''
BEGIN
SELECT @IDAplica = ID FROM Inv WHERE Mov = @Aplica AND MovID = @AplicaID AND Empresa = @Empresa
SELECT @Aplica2 = Origen, @AplicaID2 = OrigenID FROM Inv WHERE ID = @IDAplica
SELECT @IDAplica2 = ID FROM Inv WHERE Mov = @Aplica2 AND MovID = @AplicaID2 AND Empresa = @Empresa
END
SELECT @Cargo  = ISNULL(@Cargo, 0.0),
@Abono  = ISNULL(@Abono, 0.0),
@CargoU = ISNULL(@CargoU, 0.0),
@Abonou = ISNULL(@AbonoU, 0.0),
@SaldoAnterior  = 0.0,
@SaldoAnteriorU = 0.0,
@InvNegativoU   = 0.0,
@ConsignacionU  = 0.0
IF @Accion IN ('CANCELAR', 'DESAFECTAR')
BEGIN
SELECT @EsCancelacion = 1, @Temp = @Cargo, @TempU = @CargoU
SELECT @Cargo  = -@Abono,  @Abono = - @Temp,
@CargoU = -@AbonoU, @AbonoU = -@TempU
END ELSE SELECT @EsCancelacion = 0
IF @Modulo = 'INV'
SELECT @OrigenMovTipo = Clave
FROM MovTipo
JOIN Inv ON MovTipo.Modulo = 'INV' AND MovTipo.Mov = Inv.Origen
WHERE Inv.ID = @ID
IF @WMS = 1 AND @Rama IN('INV','WMS') /*AND @Modulo = 'INV' */AND @Accion = 'AFECTAR' 
BEGIN
IF ISNULL(RTRIM(@SubGrupo), '') <> ''
BEGIN
SELECT @AlmPosTipo = Tipo
FROM AlmPos
JOIN Tarima ON AlmPos.Posicion = Tarima.Posicion
WHERE Tarima.Tarima = @SubGrupo
AND AlmPos.Almacen = @Grupo
END
END
IF @GeneraSaldo = 1 AND @Ok IS NULL
BEGIN
IF @AcumulaSinDetalles = 1 SELECT @SubCuentaAcum = '' ELSE SELECT @SubCuentaAcum = @SubCuenta
IF @Conciliar = 1
SELECT @ImporteConciliar  = @Cargo  - @Abono,
@ImporteConciliarU = @CargoU - @AbonoU
ELSE
SELECT @ImporteConciliar  = 0.0,
@ImporteConciliarU = 0.0
IF @EsResultados = 0
SELECT @SaldoAnterior  = ISNULL(SUM(Saldo), 0.0), @SaldoAnteriorU = ISNULL(SUM(SaldoU), 0.0)
FROM SaldoUGral WITH (ROWLOCK)
WHERE /*Sucursal = @Sucursal AND */Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND SubGrupo = @SubGrupo AND Cuenta = @Cuenta AND SubCuenta = @SubCuentaAcum
ELSE
SELECT @SaldoAnterior  = ISNULL(SUM(Saldo), 0.0), @SaldoAnteriorU = ISNULL(SUM(SaldoU), 0.0)
FROM SaldoRU WITH (ROWLOCK)
WHERE /*Sucursal = @Sucursal AND */Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta AND SubCuenta = @SubCuentaAcum
IF @WMS = 1
BEGIN
IF @EsResultados = 0
SELECT @SaldoAnterior  = @SaldoAnterior - ISNULL(SUM(Saldo), 0.0), @SaldoAnteriorU = @SaldoAnteriorU - ISNULL(SUM(SaldoU), 0.0)
FROM SaldoU WITH (ROWLOCK)
WHERE /*Sucursal = @Sucursal AND */Empresa = @Empresa AND Rama = 'RESV' AND Moneda = @Moneda AND Grupo = @Grupo AND SubGrupo = @SubGrupo AND Cuenta = @Cuenta AND SubCuenta = @SubCuentaAcum
ELSE
SELECT @SaldoAnterior  = @SaldoAnterior - ISNULL(SUM(Saldo), 0.0), @SaldoAnteriorU = @SaldoAnteriorU - ISNULL(SUM(SaldoU), 0.0)
FROM SaldoRU WITH (ROWLOCK)
WHERE /*Sucursal = @Sucursal AND */Empresa = @Empresa AND Rama = 'RESV' AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta AND SubCuenta = @SubCuentaAcum
END
IF @@ERROR <> 0 SELECT @Ok = 1
IF @EsTipoSerie = 1 AND @Rama IN('INV','WMS') AND @SubCuentaAcum <> '' AND (@SaldoAnteriorU + @CargoU - @AbonoU > 1.0 ) AND @Ok IS NULL
BEGIN
SELECT @Ok = 20080, @OkRef = 'Articulo: '+RTRIM(@Cuenta)+ ' ('+@SubCuentaAcum+')'
RETURN
END
IF @Rama IN('INV','WMS') AND (@CargoU < 0.0 OR @AbonoU > 0.0) AND (@SaldoAnteriorU + @CargoU - @AbonoU < 0.0 )
SELECT @InvNegativoU = (@SaldoAnteriorU + @CargoU - @AbonoU) * -1
SELECT @OrigenMovTipoc = Clave
FROM MovTipo
JOIN Inv ON MovTipo.Modulo = 'INV'
AND MovTipo.Mov = Inv.Mov
WHERE Inv.ID = @ID
IF @InvNegativoU <> 0.0 AND @Rama IN('INV','WMS') AND @OrigenMovTipoc <> 'INV.A'
BEGIN
SELECT @ConsignacionU = ISNULL(SUM(SaldoU), 0.0)
FROM SaldoU WITH (ROWLOCK)
WHERE Rama = 'CSG' AND Sucursal = @Sucursal AND Empresa = @Empresa AND SubGrupo = @SubGrupo AND Cuenta = @Cuenta
IF @@ERROR <> 0 SELECT @Ok = 1
IF @ConsignacionU <> 0.0 AND @InvNegativoU < @ConsignacionU
SELECT @ConsignacionU = @InvNegativoU
IF @EsTransferencia = 1 AND @ConsignacionU <> 0.0
IF @CargoU < 0.0 SELECT @CargoU = @CargoU + @ConsignacionU ELSE SELECT @AbonoU = @AbonoU - @ConsignacionU
IF @EsTransferencia = 0 AND @ConsignacionU <> 0.0 AND @Accion NOT IN ('CANCELAR', 'DESAFECTAR') AND @Modulo <> 'COMS'
EXEC spComprarConsignacion @Sucursal, @Empresa, @Usuario, @Cuenta, @SubCuenta, @Grupo, @SubGrupo, @ConsignacionU, @Modulo, @Mov, @MovID,
@Fecha, @EjercicioAfectacion, @PeriodoAfectacion,
@Ok OUTPUT, @OkRef OUTPUT
END
IF @EsResultados = 0
BEGIN
IF @WMSAuxiliar = 1 
BEGIN
IF @SubGrupo <> ''
BEGIN
UPDATE SaldoUWMS  WITH (ROWLOCK)
SET Saldo         = ISNULL(Saldo, 0.0), SaldoU        = ISNULL(SaldoU, 0.0) + @CargoU - @AbonoU,
PorConciliar  = PorConciliar  + @ImporteConciliar,      PorConciliarU = PorConciliarU + @ImporteConciliarU
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND SubGrupo = @SubGrupo AND Cuenta = @Cuenta AND SubCuenta = @SubCuentaAcum
IF @@ROWCOUNT = 0
INSERT SaldoUWMS WITH (ROWLOCK)(Sucursal,  Empresa,  Rama,  Moneda,  Grupo,  SubGrupo,  Cuenta,  SubCuenta,      Saldo,              SaldoU,             PorConciliar,      PorConciliarU,      UltimoCambio)
VALUES (@Sucursal, @Empresa, @Rama, @Moneda, @Grupo, @SubGrupo, @Cuenta, @SubCuentaAcum, 0, (@CargoU - @AbonoU), @ImporteConciliar, @ImporteConciliarU, @Fecha)
END ELSE BEGIN 
UPDATE SaldoU WITH (ROWLOCK)
SET Saldo         = ISNULL(Saldo, 0.0)  + @Cargo  - @Abono, SaldoU        = ISNULL(SaldoU, 0.0) + @CargoU - @AbonoU,
PorConciliar  = PorConciliar  + @ImporteConciliar,      PorConciliarU = PorConciliarU + @ImporteConciliarU
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND SubGrupo = @SubGrupo AND Cuenta = @Cuenta AND SubCuenta = @SubCuentaAcum
IF @@ROWCOUNT = 0
INSERT SaldoU WITH (ROWLOCK)(Sucursal,  Empresa,  Rama,  Moneda,  Grupo,  SubGrupo,  Cuenta,  SubCuenta,      Saldo,              SaldoU,             PorConciliar,      PorConciliarU,      UltimoCambio)
VALUES (@Sucursal, @Empresa, @Rama, @Moneda, @Grupo, @SubGrupo, @Cuenta, @SubCuentaAcum, (@Cargo - @Abono), (@CargoU - @AbonoU), @ImporteConciliar, @ImporteConciliarU, @Fecha)
END
END ELSE BEGIN 
EXEC dbo.sp_executesql N'UPDATE SaldoU WITH (ROWLOCK)
SET Saldo         = ISNULL(Saldo, 0.0)  + @Cargo  - @Abono, SaldoU        = ISNULL(SaldoU, 0.0) + @CargoU - @AbonoU,
PorConciliar  = PorConciliar  + @ImporteConciliar,      PorConciliarU = PorConciliarU + @ImporteConciliarU
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND SubGrupo = @SubGrupo AND Cuenta = @Cuenta AND SubCuenta = @SubCuentaAcum
IF @@ROWCOUNT = 0
INSERT SaldoU (Sucursal,  Empresa,  Rama,  Moneda,  Grupo,  SubGrupo,  Cuenta,  SubCuenta,      Saldo,              SaldoU,             PorConciliar,      PorConciliarU,      UltimoCambio)
VALUES (@Sucursal, @Empresa, @Rama, @Moneda, @Grupo, @SubGrupo, @Cuenta, @SubCuentaAcum, (@Cargo - @Abono), (@CargoU - @AbonoU), @ImporteConciliar, @ImporteConciliarU, @Fecha)',
N'@Sucursal int, @Empresa varchar(5), @Rama varchar(50), @Moneda varchar(50), @Grupo varchar(50), @SubGrupo varchar(50), @Cuenta varchar(50), @SubCuentaAcum varchar(50),
@Cargo money, @Abono money, @CargoU float, @AbonoU float, @ImporteConciliar money, @ImporteConciliarU money, @Fecha datetime',
@Sucursal, @Empresa, @Rama, @Moneda, @Grupo, @SubGrupo, @Cuenta, @SubCuentaAcum, @Cargo, @Abono, @CargoU, @AbonoU, @ImporteConciliar, @ImporteConciliarU, @Fecha
END 
IF @@ERROR <> 0 SELECT @Ok = 1
END ELSE BEGIN
UPDATE SaldoRU WITH (ROWLOCK)
SET Saldo         = ISNULL(Saldo, 0.0)  + @Cargo  - @Abono, SaldoU        = ISNULL(SaldoU, 0.0) + @CargoU - @AbonoU,
PorConciliar  = PorConciliar  + @ImporteConciliar,      PorConciliarU = PorConciliarU + @ImporteConciliarU
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta AND SubCuenta = @SubCuentaAcum
IF @@ROWCOUNT = 0
INSERT SaldoRU (Sucursal,  Empresa,  Rama,  Moneda,  Grupo,  Cuenta,  SubCuenta,      Saldo,              SaldoU,             PorConciliar,      PorConciliarU,      UltimoCambio)
VALUES (@Sucursal, @Empresa, @Rama, @Moneda, @Grupo, @Cuenta, @SubCuentaAcum, (@Cargo - @Abono), (@CargoU - @AbonoU), @ImporteConciliar, @ImporteConciliarU, @Fecha)
IF @@ERROR <> 0 SELECT @Ok = 1
END  
END
IF @GeneraAuxiliar = 1 AND @Ok IS NULL
BEGIN
IF @Accion = 'DESAFECTAR'
BEGIN
IF (SELECT Sucursal FROM Version) <> 0
SELECT @Ok = 60290
IF @EsResultados = 0
BEGIN
IF @WMSAuxiliar = 1 
BEGIN
IF @SubGrupo <> '' 
BEGIN
DELETE AuxiliarUWMS
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND SubGrupo = @SubGrupo AND Cuenta = @Cuenta
AND SubCuenta = @SubCuenta AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @EjercicioAfectacion AND Periodo = @PeriodoAfectacion
END ELSE BEGIN 
DELETE AuxiliarU
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND SubGrupo = @SubGrupo AND Cuenta = @Cuenta
AND SubCuenta = @SubCuenta AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @EjercicioAfectacion AND Periodo = @PeriodoAfectacion
END
END ELSE 
EXEC dbo.sp_executesql N'
DELETE AuxiliarU
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND SubGrupo = @SubGrupo AND Cuenta = @Cuenta
AND SubCuenta = @SubCuenta AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @EjercicioAfectacion AND Periodo = @PeriodoAfectacion',
N'@Sucursal int, @Empresa varchar(5), @Rama varchar(5), @Moneda varchar(20), @Grupo varchar(10), @SubGrupo varchar(20), @Cuenta varchar(20), @SubCuenta varchar(50),
@Mov varchar(20), @MovID varchar(20), @EjercicioAfectacion int, @PeriodoAfectacion int,',
@Sucursal, @Empresa, @Rama, @Moneda, @Grupo, @SubGrupo, @Cuenta, @SubCuenta, @Mov, @MovID, @EjercicioAfectacion, @PeriodoAfectacion
END ELSE
DELETE AuxiliarRU
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta
AND SubCuenta = @SubCuenta AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @EjercicioAfectacion AND Periodo = @PeriodoAfectacion
IF @@ROWCOUNT = 0 SELECT @Ok = 60100, @OkRef = 'Movimiento: '+RTRIM(@Mov) + ' ' +LTRIM(Convert(Char, @MovID))
END ELSE
BEGIN
SELECT @FechaSinHora = @Fecha,
@CargoAux  = NULLIF(@Cargo, 0.0),  @AbonoAux  = NULLIF(@Abono, 0.0),
@CargoAuxU = NULLIF(@CargoU, 0.0), @AbonoAuxU = NULLIF(@AbonoU, 0.0)
EXEC spExtraerFecha @FechaSinHora OUTPUT
IF @EsResultados = 0
BEGIN
IF @WMSAuxiliar = 1 
BEGIN
IF @SubGrupo <> '' 
BEGIN
INSERT AuxiliarUWMS (Sucursal, Empresa, Rama, Moneda, Cuenta, SubCuenta, Ejercicio, Periodo, Fecha,
Grupo, SubGrupo, Modulo, ModuloID, Mov, MovID, Cargo, Abono, CargoU, AbonoU, Aplica, AplicaID, Acumulado, Conciliado, EsCancelacion,
Renglon, RenglonSub)
VALUES (@Sucursal, @Empresa, @Rama, @Moneda, @Cuenta, @SubCuenta, @EjercicioAfectacion, @PeriodoAfectacion, @FechaSinHora,
@Grupo, @SubGrupo, @Modulo, @ID, @Mov, @MovID, @CargoAux, @AbonoAux, @CargoAuxU, @AbonoAuxU, @Aplica, @AplicaID, @AcumulaEnLinea, 0, @EsCancelacion,
@Renglon, @RenglonSub)
END ELSE BEGIN  
INSERT AuxiliarU (Sucursal, Empresa, Rama, Moneda, Cuenta, SubCuenta, Ejercicio, Periodo, Fecha,
Grupo, SubGrupo, Modulo, ModuloID, Mov, MovID, Cargo, Abono, CargoU, AbonoU, Aplica, AplicaID, Acumulado, Conciliado, EsCancelacion,
Renglon, RenglonSub)
VALUES (@Sucursal, @Empresa, @Rama, @Moneda, @Cuenta, @SubCuenta, @EjercicioAfectacion, @PeriodoAfectacion, @FechaSinHora,
@Grupo, @SubGrupo, @Modulo, @ID, @Mov, @MovID, @CargoAux, @AbonoAux, @CargoAuxU, @AbonoAuxU, @Aplica, @AplicaID, @AcumulaEnLinea, 0, @EsCancelacion,
@Renglon, @RenglonSub)
END
END ELSE BEGIN 
EXEC dbo.sp_executesql N'
INSERT AuxiliarU (Sucursal, Empresa, Rama, Moneda, Cuenta, SubCuenta, Ejercicio, Periodo, Fecha,
Grupo, SubGrupo, Modulo, ModuloID, Mov, MovID, Cargo, Abono, CargoU, AbonoU, Aplica, AplicaID, Acumulado, Conciliado, EsCancelacion,
Renglon, RenglonSub)
VALUES (@Sucursal, @Empresa, @Rama, @Moneda, @Cuenta, @SubCuenta, @EjercicioAfectacion, @PeriodoAfectacion, @FechaSinHora,
@Grupo, @SubGrupo, @Modulo, @ID, @Mov, @MovID, @CargoAux, @AbonoAux, @CargoAuxU, @AbonoAuxU, @Aplica, @AplicaID, @AcumulaEnLinea, 0, @EsCancelacion,
@Renglon, @RenglonSub)',
N'@Sucursal int, @Empresa varchar(5), @Rama varchar(5), @Moneda varchar(20), @Cuenta varchar(20), @SubCuenta varchar(50), @EjercicioAfectacion int, @PeriodoAfectacion int,
@FechaSinHora datetime, @Grupo varchar(10), @SubGrupo varchar(20), @Modulo varchar(5), @ID int, @Mov varchar(20), @MovID varchar(20), @CargoAux money, @AbonoAux money,
@CargoAuxU float, @AbonoAuxU float, @Aplica varchar(20), @AplicaID varchar(20), @AcumulaEnLinea bit, @EsCancelacion bit, @Renglon float, @RenglonSub int',
@Sucursal, @Empresa, @Rama, @Moneda, @Cuenta, @SubCuenta, @EjercicioAfectacion, @PeriodoAfectacion, @FechaSinHora, @Grupo, @SubGrupo, @Modulo, @ID, @Mov, @MovID,
@CargoAux, @AbonoAux, @CargoAuxU, @AbonoAuxU, @Aplica, @AplicaID, @AcumulaEnLinea, @EsCancelacion, @Renglon, @RenglonSub
END 
END
SET @IDGenerar = SCOPE_IDENTITY()
INSERT AuxiliarRU (Sucursal, Empresa, Rama, Moneda, Cuenta, SubCuenta, Ejercicio, Periodo, Fecha,
Grupo, Modulo, ModuloID, Mov, MovID, Cargo, Abono, CargoU, AbonoU, Aplica, AplicaID, Acumulado, Conciliado, EsCancelacion,
Renglon, RenglonSub)
VALUES (@Sucursal, @Empresa, @Rama, @Moneda, @Cuenta, @SubCuenta, @EjercicioAfectacion, @PeriodoAfectacion, @FechaSinHora,
@Grupo, @Modulo, @ID, @Mov, @MovID, @CargoAux, @AbonoAux, @CargoAuxU, @AbonoAuxU, @Aplica, @AplicaID, @AcumulaEnLinea, 0, @EsCancelacion,
@Renglon, @RenglonSub)
IF @Mov = 'Redondeo'
BEGIN
UPDATE INV SET OrigenTipo = 'I:MES', MovMES = 1 WHERE ID = @ID
END
ELSE
BEGIN
EXEC spInforSaldoU @Sucursal, @Accion, @Empresa, @Usuario, @Rama, @Moneda, @Cuenta, @SubCuenta, @Grupo,
@Modulo, @ID, @Mov, @MovID, @Cargo, @Abono, @CargoU, @AbonoU, @Fecha,
@EjercicioAfectacion, @PeriodoAfectacion, @AcumulaSinDetalles, @AcumulaEnLinea, @GeneraAuxiliar,
@GeneraSaldo, @Conciliar, @Aplica, @AplicaID, @EsTransferencia, @EsResultados, @EsTipoSerie,
@InvNegativoU, @ConsignacionU,@IDGenerar, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub,
@RenglonID = @RenglonID, @SubGrupo = @SubGrupo
END
IF @@ERROR <> 0 SELECT @Ok = 1
END
END
IF @AcumulaEnLinea = 1 AND @Ok IS NULL
BEGIN
IF @AcumulaSinDetalles = 1 SELECT @SubCuentaAcum = '' ELSE SELECT @SubCuentaAcum = @SubCuenta
IF @EsResultados = 0
BEGIN
IF @WMSAuxiliar = 1 
BEGIN
IF @SubGrupo <> '' 
BEGIN
UPDATE AcumUWMS WITH (ROWLOCK)
SET Cargos  = ISNULL(Cargos, 0.0)  + @Cargo,  Abonos  = ISNULL(Abonos, 0.0)  + @Abono,
CargosU = ISNULL(CargosU, 0.0) + @CargoU, AbonosU = ISNULL(AbonosU, 0.0) + @AbonoU,
UltimoCambio = @Fecha
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND SubGrupo = @SubGrupo AND Cuenta = @Cuenta
AND SubCuenta = @SubCuentaAcum AND Periodo = @PeriodoAfectacion AND Ejercicio = @EjercicioAfectacion
IF @@ROWCOUNT = 0
INSERT AcumUWMS (Sucursal,  Empresa,  Rama,  Moneda,  Grupo,  SubGrupo,  Cuenta,  SubCuenta,      Ejercicio,            Periodo,            Cargos, Abonos, CargosU, AbonosU, UltimoCambio)
VALUES (@Sucursal, @Empresa, @Rama, @Moneda, @Grupo, @SubGrupo, @Cuenta, @SubCuentaAcum, @EjercicioAfectacion, @PeriodoAfectacion, @Cargo, @Abono, @CargoU, @AbonoU, @Fecha)
END ELSE BEGIN 
UPDATE AcumU WITH (ROWLOCK)
SET Cargos  = ISNULL(Cargos, 0.0)  + @Cargo,  Abonos  = ISNULL(Abonos, 0.0)  + @Abono,
CargosU = ISNULL(CargosU, 0.0) + @CargoU, AbonosU = ISNULL(AbonosU, 0.0) + @AbonoU,
UltimoCambio = @Fecha
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND SubGrupo = @SubGrupo AND Cuenta = @Cuenta
AND SubCuenta = @SubCuentaAcum AND Periodo = @PeriodoAfectacion AND Ejercicio = @EjercicioAfectacion
IF @@ROWCOUNT = 0
INSERT AcumU (Sucursal,  Empresa,  Rama,  Moneda,  Grupo,  SubGrupo,  Cuenta,  SubCuenta,      Ejercicio,            Periodo,            Cargos, Abonos, CargosU, AbonosU, UltimoCambio)
VALUES (@Sucursal, @Empresa, @Rama, @Moneda, @Grupo, @SubGrupo, @Cuenta, @SubCuentaAcum, @EjercicioAfectacion, @PeriodoAfectacion, @Cargo, @Abono, @CargoU, @AbonoU, @Fecha)
END
END ELSE BEGIN 
EXEC dbo.sp_executesql N'
UPDATE AcumU WITH (ROWLOCK)
SET Cargos  = ISNULL(Cargos, 0.0)  + @Cargo,  Abonos  = ISNULL(Abonos, 0.0)  + @Abono,
CargosU = ISNULL(CargosU, 0.0) + @CargoU, AbonosU = ISNULL(AbonosU, 0.0) + @AbonoU,
UltimoCambio = @Fecha
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND SubGrupo = @SubGrupo AND Cuenta = @Cuenta
AND SubCuenta = @SubCuentaAcum AND Periodo = @PeriodoAfectacion AND Ejercicio = @EjercicioAfectacion
IF @@ROWCOUNT = 0
INSERT AcumU (Sucursal,  Empresa,  Rama,  Moneda,  Grupo,  SubGrupo,  Cuenta,  SubCuenta,      Ejercicio,            Periodo,            Cargos, Abonos, CargosU, AbonosU, UltimoCambio)
VALUES (@Sucursal, @Empresa, @Rama, @Moneda, @Grupo, @SubGrupo, @Cuenta, @SubCuentaAcum, @EjercicioAfectacion, @PeriodoAfectacion, @Cargo, @Abono, @CargoU, @AbonoU, @Fecha)',
N'@Sucursal int, @Empresa varchar(5), @Rama varchar(5), @Moneda varchar(20), @Grupo varchar(10), @SubGrupo varchar(20), @Cuenta varchar(20), @SubCuentaAcum varchar(50),
@EjercicioAfectacion int, @PeriodoAfectacion int, @Cargo money, @Abono money, @CargoU float, @AbonoU float, @Fecha datetime',
@Sucursal, @Empresa, @Rama, @Moneda, @Grupo, @SubGrupo, @Cuenta, @SubCuentaAcum, @EjercicioAfectacion, @PeriodoAfectacion, @Cargo, @Abono, @CargoU, @AbonoU, @Fecha
END 
IF @@ERROR <> 0 SELECT @Ok = 1
END ELSE
BEGIN
UPDATE AcumRU WITH (ROWLOCK)
SET Cargos  = ISNULL(Cargos, 0.0)  + @Cargo,  Abonos  = ISNULL(Abonos, 0.0)  + @Abono,
CargosU = ISNULL(CargosU, 0.0) + @CargoU, AbonosU = ISNULL(AbonosU, 0.0) + @AbonoU,
UltimoCambio = @Fecha
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta
AND SubCuenta = @SubCuentaAcum AND Periodo = @PeriodoAfectacion AND Ejercicio = @EjercicioAfectacion
IF @@ROWCOUNT = 0
INSERT AcumRU (Sucursal,  Empresa,  Rama,  Moneda,  Grupo,  Cuenta,  SubCuenta,      Ejercicio,            Periodo,            Cargos, Abonos, CargosU, AbonosU, UltimoCambio)
VALUES (@Sucursal, @Empresa, @Rama, @Moneda, @Grupo, @Cuenta, @SubCuentaAcum, @EjercicioAfectacion, @PeriodoAfectacion, @Cargo, @Abono, @CargoU, @AbonoU, @Fecha)
IF @@ERROR <> 0 SELECT @Ok = 1
END
END
/*  SELECT @CantidadU = @CargoU - @AbonoU
IF @Rama IN ('INV', 'RESV', 'VMOS', 'CSG', 'GAR', 'AF', 'PZA') AND NULLIF(RTRIM(@Grupo), '') IS NOT NULL AND @CantidadU <> 0.0  AND @Ok IS NULL
BEGIN
SELECT @INV = 0.0, @RESV = 0.0, @VMOS = 0.0, @GAR = 0.0, @CSG = 0.0, @AF = 0.0, @PZA = 0.0
IF @Rama = 'INV'  SELECT @INV  = @CantidadU ELSE
IF @Rama = 'RESV' SELECT @RESV = @CantidadU ELSE
IF @Rama = 'VMOS' SELECT @VMOS = @CantidadU ELSE
IF @Rama = 'CSG'  SELECT @CSG  = @CantidadU ELSE
IF @Rama = 'GAR'  SELECT @GAR  = @CantidadU ELSE
IF @Rama = 'AF'   SELECT @AF   = @CantidadU ELSE
IF @Rama = 'PZA'  SELECT @PZA  = @CantidadU
UPDATE ArtR
SET INV  = ISNULL(INV,  0.0) + @INV,
RESV = ISNULL(RESV, 0.0) + @RESV,
VMOS = ISNULL(VMOS, 0.0) + @VMOS,
CSG  = ISNULL(CSG,  0.0) + @CSG,
GAR  = ISNULL(GAR,  0.0) + @GAR,
AF   = ISNULL(AF,   0.0) + @AF,
PZA  = ISNULL(PZA,  0.0) + @PZA,
TieneMovimientos = 1
WHERE Empresa = @Empresa
AND Articulo = @Cuenta
AND SubCuenta = ISNULL(@SubCuenta, '')
AND Almacen = @Grupo
IF @@ROWCOUNT = 0
INSERT ArtR (Empresa,  Articulo,  SubCuenta,              Almacen,  INV,  RESV,  VMOS,  GAR,  CSG,  AF,  PZA, TieneMovimientos)
VALUES (@Empresa, @Cuenta,   ISNULL(@SubCuenta, ''), @Grupo,  @INV, @RESV, @VMOS, @GAR, @CSG, @AF, @PZA, 1)
END
*/
/*
IF @Rama = 'INV' AND @SubGrupo <> ''
BEGIN
IF (SELECT WMSInventarioTarimas FROM EmpresaCfg WHERE Empresa = @Empresa) = 1
BEGIN
SELECT @TMACargoU = 0.0, @TMAAbonoU = 0.0
IF @CargoU > 0.0 SELECT @TMACargoU = 1.0 ELSE IF @CargoU < 0.0 SELECT @TMACargoU = -1.0
IF @AbonoU > 0.0 SELECT @TMAAbonoU = 1.0 ELSE IF @AbonoU < 0.0 SELECT @TMAAbonoU = -1.0
EXEC spSaldoU @Sucursal, @Accion, @Empresa, @Usuario, 'TMA', @Moneda, @SubGrupo, '', @Grupo,
@Modulo, @ID, @Mov, @MovID, NULL, NULL, @TMACargoU, @TMAAbonoU, @Fecha,
@EjercicioAfectacion, @PeriodoAfectacion, 0, 1, 1,
1, @Conciliar, @Aplica, @AplicaID, 0, 0, 0,
NULL, NULL, @Ok OUTPUT, @OkRef OUTPUT, @Renglon, @RenglonSub, @RenglonID, NULL
END
END*/
IF (SELECT IntelMESInterfase FROM EmpresaCfg WHERE Empresa = @Empresa) = 1
EXEC xpMESSaldoU @Sucursal, @Accion, @Empresa, @Usuario, @Rama, @Moneda, @Cuenta, @SubCuenta, @Grupo,
@Modulo, @ID, @Mov, @MovID, @Cargo, @Abono, @CargoU, @AbonoU, @Fecha,
@EjercicioAfectacion, @PeriodoAfectacion, @AcumulaSinDetalles, @AcumulaEnLinea, @GeneraAuxiliar,
@GeneraSaldo, @Conciliar, @Aplica, @AplicaID, @EsTransferencia, @EsResultados, @EsTipoSerie,
@InvNegativoU, @ConsignacionU, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID, @SubGrupo = @SubGrupo
IF @Ok IS NULL
EXEC xpSaldoU @Sucursal, @Accion, @Empresa, @Usuario, @Rama, @Moneda, @Cuenta, @SubCuenta, @Grupo,
@Modulo, @ID, @Mov, @MovID, @Cargo, @Abono, @CargoU, @AbonoU, @Fecha,
@EjercicioAfectacion, @PeriodoAfectacion, @AcumulaSinDetalles, @AcumulaEnLinea, @GeneraAuxiliar,
@GeneraSaldo, @Conciliar, @Aplica, @AplicaID, @EsTransferencia, @EsResultados, @EsTipoSerie,
@InvNegativoU, @ConsignacionU, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID, @SubGrupo = @SubGrupo
RETURN
END

