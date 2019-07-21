SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpMESSaldoU
@Sucursal		int,
@Accion		char(20),
@Empresa		char(5),
@Usuario		char(10),
@Rama		char(5),
@Moneda		char(10),
@Cuenta		char(20),
@SubCuenta		varchar(50),
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
@AcumulaEnLinea	bit,
@GeneraAuxiliar	bit,
@GeneraSaldo	        bit,
@Conciliar		bit,
@Aplica		char(20),
@AplicaID		varchar(20),
@EsTransferencia     bit,
@EsResultados	bit,
@EsTipoSerie		bit,
@InvNegativoU   	float,
@ConsignacionU	float,
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT,
@Renglon		float		= NULL,
@RenglonSub		int		= NULL,
@RenglonID		int		= NULL,
@SubGrupo		varchar(20)	= NULL
AS BEGIN
DECLARE
@eCommerce              bit,
@FechaSinHora           datetime,
@SubCuentaAcum          varchar(50),
@ImporteConciliarU      float,
@ImporteConciliar       money,
@ModuloID2              int,
@CargoAuxU              float,
@AbonoAuxU              float,
@CargoAux               money,
@AbonoAux               money,
@EsCancelacion          bit
SELECT @eCommerce = ISNULL(eCommerce,0) FROM EmpresaGral WHERE Empresa = @Empresa
IF @eCommerce = 1
BEGIN
IF NOT EXISTS(SELECT * FROM eCommerceSaldoU WHERE Articulo = @Cuenta AND SubCuenta = @SubCuenta)
INSERT eCommerceSaldoU(Articulo, SubCuenta)
SELECT                 @Cuenta, @SubCuenta
END
IF @Accion IN ('CANCELAR' ,'DESAFECTAR')
SELECT @EsCancelacion = 1
ELSE
SELECT @EsCancelacion = 0
IF @GeneraSaldo=1 AND @Ok IS NULL
BEGIN
IF @AcumulaSinDetalles = 1
SELECT @SubCuentaAcum = ''
ELSE
SELECT @SubCuentaAcum = @SubCuenta
IF @Conciliar=1
SELECT @ImporteConciliar   = @Cargo- @Abono,
@ImporteConciliarU  = @CargoU- @AbonoU
ELSE
SELECT @ImporteConciliar   = 0.0,
@ImporteConciliarU  = 0.0
IF @EsResultados=0
BEGIN
IF (SELECT a.MES FROM Alm a WHERE a.Almacen = @Grupo) = 1
BEGIN
UPDATE SaldoMESU WITH (ROWLOCK) SET Saldo          = ISNULL(Saldo ,0.0)+@Cargo- @Abono,
SaldoU         = ISNULL(SaldoU ,0.0)+@CargoU- @AbonoU,
PorConciliar   = PorConciliar+@ImporteConciliar,
PorConciliarU  = PorConciliarU+@ImporteConciliarU
WHERE  Sucursal       = @Sucursal
AND Empresa    = @Empresa
AND Rama       = @Rama
AND Moneda     = @Moneda
AND Grupo      = @Grupo
AND SubGrupo   = @SubGrupo
AND Cuenta     = @Cuenta
AND SubCuenta  = @SubCuentaAcum
IF @@ROWCOUNT=0
INSERT SaldoMESU
(Sucursal,            Empresa,           Rama,               Moneda,  Grupo,
SubGrupo,            Cuenta,            SubCuenta,          Saldo,   SaldoU,
PorConciliar,        PorConciliarU,     UltimoCambio)
VALUES
(@Sucursal,           @Empresa,          @Rama,              @Moneda, @Grupo,
@SubGrupo,          @Cuenta,           @SubCuentaAcum,     (@Cargo- @Abono),
(@CargoU- @AbonoU), @ImporteConciliar, @ImporteConciliarU, @Fecha)
END
IF @@ERROR<>0
SELECT @Ok = 1
END
END
IF @GeneraAuxiliar=1 AND @Ok IS NULL
BEGIN
IF @Accion='DESAFECTAR'
BEGIN
IF @EsResultados=0
BEGIN
SELECT @FechaSinHora = @Fecha,
@CargoAux     = NULLIF(@Cargo ,0.0),
@AbonoAux     = NULLIF(@Abono ,0.0),
@CargoAuxU    = NULLIF(@CargoU ,0.0),
@AbonoAuxU    = NULLIF(@AbonoU ,0.0)
EXEC spExtraerFecha @FechaSinHora OUTPUT
IF (SELECT a.MES FROM Alm a WHERE a.Almacen = @Grupo) = 1
DELETE AuxiliarMESU
WHERE  Sucursal = @Sucursal
AND Empresa = @Empresa
AND Rama = @Rama
AND Moneda = @Moneda
AND Grupo = @Grupo
AND SubGrupo = @SubGrupo
AND Cuenta = @Cuenta
AND SubCuenta = @SubCuenta
AND Mov = @Mov
AND MovID = @MovID
AND Ejercicio = @EjercicioAfectacion
AND Periodo = @PeriodoAfectacion
END
END
ELSE
BEGIN
IF @Modulo = 'COMS' AND (SELECT a.MES FROM Alm a WHERE a.Almacen = @Grupo) = 1
BEGIN
SELECT @ModuloID2 = c2.ID
FROM Compra c
JOIN Compra c2 ON c.Origen = c2.Mov AND c.OrigenID = c2.MovID AND c.Empresa = c2.Empresa
WHERE c.ID = @ID
END
IF (SELECT a.MES FROM Alm a WHERE a.Almacen = @Grupo) = 1
INSERT AuxiliarMESU
(Sucursal,              Empresa,            Rama,          Moneda,          Cuenta,     SubCuenta,
Ejercicio,             Periodo,            Fecha,         Grupo,           SubGrupo,   Modulo,
ModuloID,              Mov,                MovID,         Cargo,           Abono,      CargoU,
AbonoU,                Aplica,             AplicaID,      Acumulado,       Conciliado, EsCancelacion,
Renglon,               RenglonSub, EstatusIntelIMES, ModuloID2)
VALUES
(@Sucursal,             @Empresa,           @Rama,         @Moneda,         @Cuenta,    @SubCuenta,
@EjercicioAfectacion,  @PeriodoAfectacion, @FechaSinHora, @Grupo,          @SubGrupo,  @Modulo,
@ID,                   @Mov,               @MovID,        @CargoAux,       @AbonoAux,  @CargoAuxU,
@AbonoAuxU,            @Aplica,            @AplicaID,     @AcumulaEnLinea, 0,          @EsCancelacion,
@Renglon,              @RenglonSub, CASE @Mov WHEN 'Entrada Produccion' THEN 5 WHEN 'Consumo Produccion' THEN 5 ELSE NULL END, @ModuloID2)
END
END
IF @AcumulaEnLinea=1 AND @Ok IS NULL
BEGIN
IF @EsResultados=0
BEGIN
IF (SELECT a.MES FROM Alm a WHERE a.Almacen = @Grupo) = 1
BEGIN
UPDATE AcumMESU WITH (ROWLOCK) SET Cargos = ISNULL(Cargos ,0.0)+@Cargo,
Abonos        = ISNULL(Abonos ,0.0)+@Abono,
CargosU       = ISNULL(CargosU ,0.0)+@CargoU,
AbonosU       = ISNULL(AbonosU ,0.0)+@AbonoU,
UltimoCambio  = @Fecha
WHERE  Sucursal      = @Sucursal
AND Empresa   = @Empresa
AND Rama      = @Rama
AND Moneda    = @Moneda
AND Grupo     = @Grupo
AND SubGrupo  = @SubGrupo
AND Cuenta    = @Cuenta
AND SubCuenta = @SubCuentaAcum
AND Periodo   = @PeriodoAfectacion
AND Ejercicio = @EjercicioAfectacion
IF @@ROWCOUNT=0
INSERT AcumMESU
(Sucursal,  Empresa,  Rama,           Moneda,               Grupo,
SubGrupo,  Cuenta,   SubCuenta,      Ejercicio,            Periodo,
Cargos,    Abonos,   CargosU,        AbonosU,              UltimoCambio)
VALUES
(@Sucursal, @Empresa, @Rama,          @Moneda,              @Grupo,
@SubGrupo, @Cuenta,  @SubCuentaAcum, @EjercicioAfectacion, @PeriodoAfectacion,
@Cargo,    @Abono,   @CargoU,        @AbonoU,              @Fecha)
END
END
END
RETURN
END

