SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spTraspasarSaldosP
@Empresa            varchar( 5),
@Ejercicio          int        ,
@Procesando         bit     = 0
AS
BEGIN
DECLARE
@Ahora              datetime   ,
@EjercicioAnterior  int        ,
@Sucursal           int        ,
@Rama               varchar( 5),
@Moneda             varchar(10),
@Grupo              varchar(10),
@Cuenta             varchar(20),
@SubCuenta          varchar(50),
@Cargos             money      ,
@Abonos             money      ,
@CargoInicial       money      ,
@AbonoInicial       money      ,
@EjercicioInicio    datetime   ,
@EjercicioFinal     datetime   ,
@SeCreoEjercicio    bit        ,
@SeModificioGral    bit        ,
@Mensaje            varchar(150)
SELECT @Ahora = GETDATE(), @EjercicioAnterior = @Ejercicio - 1, @SeCreoEjercicio = 0, @SeModificioGral = 0
DECLARE crAcumPMon CURSOR FOR
SELECT Sucursal, Rama, Moneda, Grupo, Cuenta, SubCuenta, "Cargos"=ISNULL(SUM(Cargos), 0.0), "Abonos"=ISNULL(SUM(Abonos), 0.0)
FROM AcumF
WHERE Empresa = @Empresa AND Ejercicio = @EjercicioAnterior
GROUP BY Sucursal, Rama, Moneda, Grupo, Cuenta, SubCuenta
ORDER BY Sucursal, Rama, Moneda, Grupo, Cuenta, SubCuenta
OPEN crAcumPMon
FETCH NEXT FROM crAcumPMon INTO @Sucursal, @Rama, @Moneda, @Grupo, @Cuenta, @SubCuenta, @Cargos, @Abonos
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Cargos > @Abonos
SELECT @CargoInicial = @Cargos - @Abonos, @AbonoInicial = 0.0
ELSE
SELECT @CargoInicial = 0.0, @AbonoInicial = @Abonos - @Cargos
UPDATE AcumPMon
SET Cargos 	        = @CargoInicial,
Abonos           = @AbonoInicial,
UltimoCambio     = @Ahora
WHERE Sucursal         = @Sucursal
AND Rama 	          = @Rama
AND Empresa 	        = @Empresa
AND Ejercicio        = @Ejercicio
AND Periodo 	        = 0
AND Moneda 	        = @Moneda
AND Grupo 	          = @Grupo
AND Cuenta 	        = @Cuenta
AND SubCuenta        = @SubCuenta
IF @@ROWCOUNT = 0
BEGIN
SELECT @SeCreoEjercicio = 1
INSERT AcumPMon( Sucursal, Empresa, Rama, Ejercicio, Periodo, Moneda, Grupo, Cuenta, SubCuenta, Cargos      , Abonos      , UltimoCambio)
VALUES (@Sucursal,@Empresa,@Rama,@Ejercicio, 0      ,@Moneda,@Grupo,@Cuenta,@SubCuenta,@CargoInicial,@AbonoInicial, @Ahora      )
END
END
FETCH NEXT FROM crAcumPMon INTO @Sucursal, @Rama, @Moneda, @Grupo, @Cuenta, @SubCuenta, @Cargos, @Abonos
END 
CLOSE crAcumPMon
DEALLOCATE crAcumPMon
RETURN
END

