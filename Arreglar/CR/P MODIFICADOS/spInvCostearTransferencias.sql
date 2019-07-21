SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvCostearTransferencias
@Modulo		varchar(5),
@ID			int,
@MovTipo	varchar(20)

AS BEGIN
IF @MovTipo <> 'INV.T' RETURN
DECLARE
@AuxiliarID	  int,
@Empresa	  char(5),
@Rama		  char(5),
@Moneda		  char(10),
@Grupo		  char(10),
@Cuenta		  char(20),
@SubCuenta	  varchar(50),
@Ejercicio	  int,
@Periodo	  int,
@CargoU		  float,
@AbonoU		  float,
@Sucursal	  int,
@SubGrupo	  varchar(20),
@Costo		  float,
@WMSAuxiliar  bit 
SELECT @WMSAuxiliar = WMSAuxiliar FROM Version WITH(NOLOCK)
DECLARE crInvCostearTransferencias CURSOR FOR
SELECT u.ID, u.Empresa, u.Rama, u.Moneda, u.Grupo, u.Cuenta, ISNULL(u.SubCuenta, ''), u.Ejercicio, u.Periodo, ISNULL(u.CargoU, 0), ISNULL(u.AbonoU, 0), u.Sucursal, ISNULL(u.SubGrupo, ''), ISNULL(d.Costo/d.Factor, 0)
FROM InvD d WITH(NOLOCK)
JOIN AuxiliarU u WITH(NOLOCK) ON u.Modulo = @Modulo AND u.ModuloID = d.ID AND u.Renglon = d.Renglon AND u.RenglonSub = d.RenglonSub
WHERE d.ID = @ID AND ((u.CargoU IS NOT NULL AND u.Cargo IS NULL) OR (u.AbonoU IS NOT NULL AND u.Abono IS NULL))
OPEN crInvCostearTransferencias
FETCH NEXT FROM crInvCostearTransferencias INTO @AuxiliarID, @Empresa, @Rama, @Moneda, @Grupo, @Cuenta, @SubCuenta, @Ejercicio, @Periodo, @CargoU, @AbonoU, @Sucursal, @SubGrupo, @Costo
WHILE @@FETCH_STATUS = 0
BEGIN
IF @CargoU <> 0
BEGIN
IF @WMSAuxiliar = 1 
BEGIN
IF @SubGrupo <> '' 
BEGIN 
UPDATE SaldoUWMS WITH (ROWLOCK) SET Saldo = ISNULL(Saldo,0.0) + (@CargoU*@Costo)
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta AND ISNULL(SubCuenta, '') = @SubCuenta AND ISNULL(SubGrupo, '') = @SubGrupo
UPDATE AcumUWMS WITH (ROWLOCK) SET Cargos = ISNULL(Cargos,0.0) + (@CargoU*@Costo)
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta AND ISNULL(SubCuenta, '') = @SubCuenta AND ISNULL(SubGrupo, '') = @SubGrupo
UPDATE AuxiliarUWMS WITH (ROWLOCK) SET Cargo = @CargoU*@Costo
WHERE ID = @AuxiliarID
END ELSE BEGIN 
UPDATE SaldoU WITH (ROWLOCK) SET Saldo = ISNULL(Saldo,0.0) + (@CargoU*@Costo)
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta AND ISNULL(SubCuenta, '') = @SubCuenta AND ISNULL(SubGrupo, '') = @SubGrupo
UPDATE AcumU WITH (ROWLOCK) SET Cargos = ISNULL(Cargos,0.0) + (@CargoU*@Costo)
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta AND ISNULL(SubCuenta, '') = @SubCuenta AND ISNULL(SubGrupo, '') = @SubGrupo
UPDATE AuxiliarU WITH (ROWLOCK) SET Cargo = @CargoU*@Costo
WHERE ID = @AuxiliarID
END 
END ELSE BEGIN 
EXEC dbo.sp_executesql N'
UPDATE SaldoU WITH (ROWLOCK) SET Saldo = ISNULL(Saldo,0.0) + (@CargoU*@Costo)
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta AND ISNULL(SubCuenta, '') = @SubCuenta AND ISNULL(SubGrupo, '') = @SubGrupo
UPDATE AcumU WITH (ROWLOCK) SET Cargos = ISNULL(Cargos,0.0) + (@CargoU*@Costo)
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta AND ISNULL(SubCuenta, '') = @SubCuenta AND ISNULL(SubGrupo, '') = @SubGrupo
UPDATE AuxiliarU WITH (ROWLOCK) SET Cargo = @CargoU*@Costo
WHERE ID = @AuxiliarID',
N'@CargoU float, @Costo float, @Sucursal int, @Empresa varchar(5), @Rama varchar(5), @Moneda varchar(20), @Grupo varchar(20), @Cuenta varchar(20), @SubCuenta varchar(50),
@SubGrupo varchar(20), @Ejercicio int, @Periodo int, @AuxiliarID int',
@CargoU, @Costo, @Sucursal, @Empresa, @Rama, @Moneda, @Grupo, @Cuenta, @SubCuenta, @SubGrupo, @Ejercicio, @Periodo, @AuxiliarID
END 
END
IF @AbonoU <> 0
BEGIN
IF @WMSAuxiliar = 1 
BEGIN
IF @SubGrupo <> '' 
BEGIN 
UPDATE SaldoUWMS WITH (ROWLOCK) SET Saldo = ISNULL(Saldo,0.0) - (@AbonoU*@Costo)
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta AND ISNULL(SubCuenta, '') = @SubCuenta AND ISNULL(SubGrupo, '') = @SubGrupo
UPDATE AcumUWMS WITH (ROWLOCK)SET Abonos = ISNULL(Abonos,0.0) + (@AbonoU*@Costo)
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta AND ISNULL(SubCuenta, '') = @SubCuenta AND ISNULL(SubGrupo, '') = @SubGrupo
UPDATE AuxiliarUWMS WITH (ROWLOCK) SET Abono = @AbonoU*@Costo
WHERE ID = @AuxiliarID
END ELSE BEGIN 
UPDATE SaldoU WITH (ROWLOCK) SET Saldo = ISNULL(Saldo,0.0) - (@AbonoU*@Costo)
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta AND ISNULL(SubCuenta, '') = @SubCuenta AND ISNULL(SubGrupo, '') = @SubGrupo
UPDATE AcumU WITH (ROWLOCK)SET Abonos = ISNULL(Abonos,0.0) + (@AbonoU*@Costo)
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta AND ISNULL(SubCuenta, '') = @SubCuenta AND ISNULL(SubGrupo, '') = @SubGrupo
UPDATE AuxiliarU WITH (ROWLOCK) SET Abono = @AbonoU*@Costo
WHERE ID = @AuxiliarID
END 
END ELSE BEGIN 
EXEC dbo.sp_executesql N'
UPDATE SaldoU WITH (ROWLOCK) SET Saldo = ISNULL(Saldo,0.0) - (@AbonoU*@Costo)
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta AND ISNULL(SubCuenta, '') = @SubCuenta AND ISNULL(SubGrupo, '') = @SubGrupo
UPDATE AcumU  WITH (ROWLOCK)SET Abonos = ISNULL(Abonos,0.0) + (@AbonoU*@Costo)
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta AND ISNULL(SubCuenta, '') = @SubCuenta AND ISNULL(SubGrupo, '') = @SubGrupo
UPDATE AuxiliarU WITH (ROWLOCK) SET Abono = @AbonoU*@Costo
WHERE ID = @AuxiliarID',
N'@AbonoU float, @Costo float, @Sucursal int, @Empresa varchar(5), @Rama varchar(5), @Moneda varchar(20), @Grupo varchar(20), @Cuenta varchar(20), @SubCuenta varchar(50),
@SubGrupo varchar(20), @Ejercicio int, @Periodo int, @AuxiliarID int',
@AbonoU, @Costo, @Sucursal, @Empresa, @Rama, @Moneda, @Grupo, @Cuenta, @SubCuenta, @SubGrupo, @Ejercicio, @Periodo, @AuxiliarID
END 
END
FETCH NEXT FROM crInvCostearTransferencias INTO @AuxiliarID, @Empresa, @Rama, @Moneda, @Grupo, @Cuenta, @SubCuenta, @Ejercicio, @Periodo, @CargoU, @AbonoU, @Sucursal, @SubGrupo, @Costo
END
CLOSE crInvCostearTransferencias
DEALLOCATE crInvCostearTransferencias
RETURN
END

