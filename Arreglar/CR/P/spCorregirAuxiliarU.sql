SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCorregirAuxiliarU
@ID		int,
@CargoNuevo	money,
@AbonoNuevo	money,
@CargoUNuevo	float,
@AbonoUNuevo	float,
@Conexion	bit	= 0,
@Ok		int	= NULL	OUTPUT

AS BEGIN
SET NOCOUNT ON
DECLARE
@Empresa		char(5),
@Sucursal		int,
@Rama		char(5),
@Ejercicio		int,
@Periodo		int,
@Moneda		char(10),
@Grupo		char(10),
@SubGrupo		varchar(20),
@Cuenta		char(20),
@SubCuenta		varchar(50),
@CargoAnterior	money,
@AbonoAnterior	money,
@CargoUAnterior	float,
@AbonoUAnterior	float,
@CargoDif		money,
@AbonoDif		money,
@CargoUDif		float,
@AbonoUDif		float,
@SaldoDif		money,
@SaldoUDif		float,
@WMSAuxiliar	bit 
SELECT @WMSAuxiliar = WMSAuxiliar FROM Version 
SELECT @Empresa = NULL
SELECT @Empresa        = Empresa,
@Sucursal	     = Sucursal,
@Rama           = Rama,
@Ejercicio      = Ejercicio,
@Periodo        = Periodo,
@Moneda         = Moneda,
@Grupo          = Grupo,
@SubGrupo       = SubGrupo,
@Cuenta         = Cuenta,
@SubCuenta      = SubCuenta,
@CargoAnterior  = ISNULL(Cargo, 0.0),
@AbonoAnterior  = ISNULL(Abono, 0.0),
@CargoUAnterior = ISNULL(CargoU, 0.0),
@AbonoUAnterior = ISNULL(AbonoU, 0.0)
FROM AuxiliarU
WHERE ID = @ID
IF @Empresa IS NULL
BEGIN
IF @Conexion = 0
RAISERROR ('El "ID" No Existe!',16,-1)
ELSE SELECT @Ok = 1
RETURN
END
IF @Conexion = 0
BEGIN TRANSACTION
IF @WMSAuxiliar = 1 
BEGIN
IF @SubGrupo <> '' 
BEGIN 
UPDATE AuxiliarUWMS
SET Cargo  = @CargoNuevo,
Abono  = @AbonoNuevo,
CargoU = @CargoUNuevo,
AbonoU = @AbonoUNuevo
WHERE ID = @ID
END ELSE BEGIN 
UPDATE AuxiliarU
SET Cargo  = @CargoNuevo,
Abono  = @AbonoNuevo,
CargoU = @CargoUNuevo,
AbonoU = @AbonoUNuevo
WHERE ID = @ID
END 
END ELSE BEGIN 
EXEC dbo.sp_executesql N'
UPDATE AuxiliarU
SET Cargo  = @CargoNuevo,
Abono  = @AbonoNuevo,
CargoU = @CargoUNuevo,
AbonoU = @AbonoUNuevo
WHERE ID = @ID',
N'@CargoNuevo money, @AbonoNuevo money, @CargoUNuevo float, @AbonoUNuevo float, @ID int',
@CargoNuevo, @AbonoNuevo, @CargoUNuevo, @AbonoUNuevo, @ID
END 
IF @@ROWCOUNT <> 1 SELECT @Ok = 1
SELECT @CargoNuevo  = ISNULL(@CargoNuevo, 0.0),
@AbonoNuevo  = ISNULL(@AbonoNuevo, 0.0),
@CargoUNuevo = ISNULL(@CargoUNuevo, 0.0),
@AbonoUNuevo = ISNULL(@AbonoUNuevo, 0.0)
SELECT @CargoDif  = @CargoNuevo  - @CargoAnterior,
@AbonoDif  = @AbonoNuevo  - @AbonoAnterior,
@CargoUDif = @CargoUNuevo - @CargoUAnterior,
@AbonoUDif = @AbonoUNuevo - @AbonoUAnterior
SELECT @SaldoDif  = @CargoDif  - @AbonoDif,
@SaldoUDif = @CargoUDif - @AbonoUDif
IF @WMSAuxiliar = 1 
BEGIN
IF @SubGrupo <> '' 
BEGIN 
UPDATE AcumUWMS
SET Cargos = ISNULL(Cargos, 0.0) + @CargoDif,
Abonos = ISNULL(Abonos, 0.0) + @AbonoDif,
CargosU = ISNULL(CargosU, 0.0) + @CargoUDif,
AbonosU = ISNULL(AbonosU, 0.0) + @AbonoUDif
WHERE Empresa   = @Empresa
AND Sucursal  = @Sucursal
AND Rama      = @Rama
AND Ejercicio = @Ejercicio
AND Periodo   = @Periodo
AND Moneda    = @Moneda
AND Grupo     = @Grupo
AND SubGrupo  = @SubGrupo
AND Cuenta    = @Cuenta
AND SubCuenta = @SubCuenta
IF @@ROWCOUNT = 0
INSERT AcumUWMS (Cargos,    Abonos,    CargosU,    AbonosU,    Empresa,  Sucursal,  Rama,  Ejercicio,  Periodo,  Moneda,  Grupo,  SubGrupo,  Cuenta,  SubCuenta)
VALUES (@CargoDif, @AbonoDif, @CargoUDif, @AbonoUDif, @Empresa, @Sucursal, @Rama, @Ejercicio, @Periodo, @Moneda, @Grupo, @SubGrupo, @Cuenta, @SubCuenta)
UPDATE SaldoUWMS
SET Saldo  = ISNULL(Saldo, 0.0)  + @SaldoDif,
SaldoU = ISNULL(SaldoU, 0.0) + @SaldoUDif
WHERE Empresa   = @Empresa
AND Sucursal  = @Sucursal
AND Rama      = @Rama
AND Moneda    = @Moneda
AND Grupo     = @Grupo
AND SubGrupo  = @SubGrupo
AND Cuenta    = @Cuenta
AND SubCuenta = @SubCuenta
IF @@ROWCOUNT = 0
INSERT SaldoUWMS (Saldo,     SaldoU,     Empresa,  Sucursal,  Rama,  Moneda,  Grupo,  SubGrupo,  Cuenta,  SubCuenta)
VALUES (@SaldoDif, @SaldoUDif, @Empresa, @Sucursal, @Rama, @Moneda, @Grupo, @SubGrupo, @Cuenta, @SubCuenta)
END ELSE BEGIN 
UPDATE AcumU
SET Cargos = ISNULL(Cargos, 0.0) + @CargoDif,
Abonos = ISNULL(Abonos, 0.0) + @AbonoDif,
CargosU = ISNULL(CargosU, 0.0) + @CargoUDif,
AbonosU = ISNULL(AbonosU, 0.0) + @AbonoUDif
WHERE Empresa   = @Empresa
AND Sucursal  = @Sucursal
AND Rama      = @Rama
AND Ejercicio = @Ejercicio
AND Periodo   = @Periodo
AND Moneda    = @Moneda
AND Grupo     = @Grupo
AND SubGrupo  = @SubGrupo
AND Cuenta    = @Cuenta
AND SubCuenta = @SubCuenta
IF @@ROWCOUNT = 0
INSERT AcumU (Cargos,    Abonos,    CargosU,    AbonosU,    Empresa,  Sucursal,  Rama,  Ejercicio,  Periodo,  Moneda,  Grupo,  SubGrupo,  Cuenta,  SubCuenta)
VALUES (@CargoDif, @AbonoDif, @CargoUDif, @AbonoUDif, @Empresa, @Sucursal, @Rama, @Ejercicio, @Periodo, @Moneda, @Grupo, @SubGrupo, @Cuenta, @SubCuenta)
UPDATE SaldoU
SET Saldo  = ISNULL(Saldo, 0.0)  + @SaldoDif,
SaldoU = ISNULL(SaldoU, 0.0) + @SaldoUDif
WHERE Empresa   = @Empresa
AND Sucursal  = @Sucursal
AND Rama      = @Rama
AND Moneda    = @Moneda
AND Grupo     = @Grupo
AND SubGrupo  = @SubGrupo
AND Cuenta    = @Cuenta
AND SubCuenta = @SubCuenta
IF @@ROWCOUNT = 0
INSERT SaldoU (Saldo,     SaldoU,     Empresa,  Sucursal,  Rama,  Moneda,  Grupo,  SubGrupo,  Cuenta,  SubCuenta)
VALUES (@SaldoDif, @SaldoUDif, @Empresa, @Sucursal, @Rama, @Moneda, @Grupo, @SubGrupo, @Cuenta, @SubCuenta)
END 
END ELSE BEGIN 
EXEC dbo.sp_executesql N'
UPDATE AcumU
SET Cargos = ISNULL(Cargos, 0.0) + @CargoDif,
Abonos = ISNULL(Abonos, 0.0) + @AbonoDif,
CargosU = ISNULL(CargosU, 0.0) + @CargoUDif,
AbonosU = ISNULL(AbonosU, 0.0) + @AbonoUDif
WHERE Empresa   = @Empresa
AND Sucursal  = @Sucursal
AND Rama      = @Rama
AND Ejercicio = @Ejercicio
AND Periodo   = @Periodo
AND Moneda    = @Moneda
AND Grupo     = @Grupo
AND SubGrupo  = @SubGrupo
AND Cuenta    = @Cuenta
AND SubCuenta = @SubCuenta
IF @@ROWCOUNT = 0
INSERT AcumU (Cargos,    Abonos,    CargosU,    AbonosU,    Empresa,  Sucursal,  Rama,  Ejercicio,  Periodo,  Moneda,  Grupo,  SubGrupo,  Cuenta,  SubCuenta)
VALUES (@CargoDif, @AbonoDif, @CargoUDif, @AbonoUDif, @Empresa, @Sucursal, @Rama, @Ejercicio, @Periodo, @Moneda, @Grupo, @SubGrupo, @Cuenta, @SubCuenta)
UPDATE SaldoU
SET Saldo  = ISNULL(Saldo, 0.0)  + @SaldoDif,
SaldoU = ISNULL(SaldoU, 0.0) + @SaldoUDif
WHERE Empresa   = @Empresa
AND Sucursal  = @Sucursal
AND Rama      = @Rama
AND Moneda    = @Moneda
AND Grupo     = @Grupo
AND SubGrupo  = @SubGrupo
AND Cuenta    = @Cuenta
AND SubCuenta = @SubCuenta
IF @@ROWCOUNT = 0
INSERT SaldoU (Saldo,     SaldoU,     Empresa,  Sucursal,  Rama,  Moneda,  Grupo,  SubGrupo,  Cuenta,  SubCuenta)
VALUES (@SaldoDif, @SaldoUDif, @Empresa, @Sucursal, @Rama, @Moneda, @Grupo, @SubGrupo, @Cuenta, @SubCuenta)',
N'@CargoDif money, @AbonoDif money, @CargoUDif float, @AbonoUDif float, @Empresa varchar(5), @Sucursal int, @Rama varchar(50), @Ejercicio int, @Periodo int,
@Moneda varchar(50), @Grupo varchar(50), @SubGrupo varchar(50), @Cuenta varchar(50), @SubCuenta varchar(50), @SaldoDif money, @SaldoUDif float',
@CargoDif, @AbonoDif, @CargoUDif, @AbonoUDif, @Empresa, @Sucursal, @Rama, @Ejercicio, @Periodo, @Moneda, @Grupo, @SubGrupo, @Cuenta, @SubCuenta, @SaldoDif, @SaldoUDif
END 
IF @Conexion = 0
BEGIN
IF @OK IS NULL
BEGIN
COMMIT TRANSACTION
SELECT "Cargo Anterior"  = @CargoAnterior,  "Cargo Nuevo"  = @CargoNuevo,
"Abono Anterior"  = @AbonoAnterior,  "Abono Nuevo"  = @AbonoNuevo,
"ID" = @ID, "Empresa" = @Empresa
SELECT "CargoU Anterior" = @CargoUAnterior, "CargoU Nuevo" = @CargoUNuevo,
"AbonoU Anterior" = @AbonoUAnterior, "AbonoU Nuevo" = @AbonoUNuevo
END ELSE
BEGIN
ROLLBACK TRANSACTION
IF @Ok = 1 SELECT 'Fallo al Corregir AuxiliarU'
IF @Ok = 2 SELECT 'Fallo al Corregir AcumU'
IF @Ok = 3 SELECT 'Fallo al Corregir SaldoU'
END
END
RETURN
END

