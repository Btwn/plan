SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spTraspasarSaldos]
@Empresa	char(5),
@Ejercicio	int,
@Procesando bit = 0

AS BEGIN
DECLARE
@Ahora		datetime,
@EjercicioAnterior	int,
@Sucursal		int,
@Rama		char(5),
@Moneda		char(10),
@Grupo		char(10),
@SubGrupo		varchar(10),
@Cuenta		char(20),
@SubCuenta		varchar(50),
@Cargos		money,
@Abonos		money,
@CargoInicial	money,
@AbonoInicial	money,
@CargosU		float,
@AbonosU		float,
@CargoInicialU	float,
@AbonoInicialU	float,
@EjercicioInicio	datetime,
@EjercicioFinal	datetime,
@SeCreoEjercicio	bit,
@SeModificioGral	bit,
@Mensaje		char(150),
@WMSAuxiliar	   bit 
SELECT @Ahora = GETDATE(), @EjercicioAnterior = @Ejercicio - 1, @SeCreoEjercicio = 0, @SeModificioGral = 0
BEGIN TRANSACTION
/* Acum */
DECLARE crAcum CURSOR FOR
SELECT Sucursal, Rama, Moneda, Grupo, Cuenta, SubCuenta, "Cargos"=ISNULL(SUM(Cargos), 0.0), "Abonos"=ISNULL(SUM(Abonos), 0.0)
FROM Acum
WHERE Empresa = @Empresa AND Ejercicio = @EjercicioAnterior
GROUP BY Sucursal, Rama, Moneda, Grupo, Cuenta, SubCuenta
ORDER BY Sucursal, Rama, Moneda, Grupo, Cuenta, SubCuenta
OPEN crAcum
FETCH NEXT FROM crAcum INTO @Sucursal, @Rama, @Moneda, @Grupo, @Cuenta, @SubCuenta, @Cargos, @Abonos
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Cargos > @Abonos
SELECT @CargoInicial = @Cargos - @Abonos, @AbonoInicial = 0.0
ELSE
SELECT @CargoInicial = 0.0, @AbonoInicial = @Abonos - @Cargos
UPDATE Acum
SET Cargos 	    = @CargoInicial, Abonos = @AbonoInicial,
UltimoCambio = @Ahora
WHERE Sucursal  = @Sucursal
AND Rama 	 = @Rama
AND Empresa 	 = @Empresa
AND Ejercicio = @Ejercicio
AND Periodo 	 = 0
AND Moneda 	 = @Moneda
AND Grupo 	 = @Grupo
AND Cuenta 	 = @Cuenta
AND SubCuenta = @SubCuenta
IF @@ROWCOUNT = 0
BEGIN
SELECT @SeCreoEjercicio = 1
INSERT Acum (Sucursal, Empresa, Rama, Ejercicio, Periodo, Moneda, Grupo, Cuenta, SubCuenta, Cargos, Abonos, UltimoCambio)
VALUES (@Sucursal, @Empresa, @Rama, @Ejercicio, 0, @Moneda, @Grupo, @Cuenta, @SubCuenta, @CargoInicial, @AbonoInicial, @Ahora)
END
END
FETCH NEXT FROM crAcum INTO @Sucursal, @Rama, @Moneda, @Grupo, @Cuenta, @SubCuenta, @Cargos, @Abonos
END 
CLOSE crAcum
DEALLOCATE crAcum
/* AcumU */
DECLARE crAcumU CURSOR FOR
SELECT Sucursal, Rama, Moneda, Grupo, SubGrupo, Cuenta, SubCuenta, "Cargos"=ISNULL(SUM(Cargos), 0.0), "Abonos"=ISNULL(SUM(Abonos), 0.0), "CargosU"=ISNULL(SUM(CargosU), 0.0), "AbonosU"=ISNULL(SUM(AbonosU), 0.0)
FROM AcumU
WHERE Empresa = @Empresa AND Ejercicio = @EjercicioAnterior
GROUP BY Sucursal, Rama, Moneda, Grupo, SubGrupo, Cuenta, SubCuenta
ORDER BY Sucursal, Rama, Moneda, Grupo, SubGrupo, Cuenta, SubCuenta
OPEN crAcumU
FETCH NEXT FROM crAcumU INTO @Sucursal, @Rama, @Moneda, @Grupo, @SubGrupo, @Cuenta, @SubCuenta, @Cargos, @Abonos, @CargosU, @AbonosU
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Cargos > @Abonos
SELECT @CargoInicial = @Cargos - @Abonos, @AbonoInicial = 0.0
ELSE
SELECT @CargoInicial = 0.0, @AbonoInicial = @Abonos - @Cargos
IF @CargosU > @AbonosU
SELECT @CargoInicialU = @CargosU - @AbonosU, @AbonoInicialU = 0.0
ELSE
SELECT @CargoInicialU = 0.0, @AbonoInicialU = @AbonosU - @CargosU
IF @WMSAuxiliar = 1 
BEGIN
IF @SubGrupo <> '' 
BEGIN
UPDATE AcumUWMS
SET Cargos 	    = @CargoInicial,  Abonos  = @AbonoInicial,
CargosU	    = @CargoInicialU, AbonosU = @AbonoInicialU,
UltimoCambio = @Ahora
WHERE Sucursal  = @Sucursal
AND Rama 	 = @Rama
AND Empresa   = @Empresa
AND Ejercicio = @Ejercicio
AND Periodo   = 0
AND Moneda    = @Moneda
AND Grupo     = @Grupo
AND SubGrupo  = @SubGrupo
AND Cuenta    = @Cuenta
AND SubCuenta = @SubCuenta
IF @@ROWCOUNT = 0
BEGIN
SELECT @SeCreoEjercicio = 1
INSERT AcumUWMS (Sucursal, Empresa, Rama, Ejercicio, Periodo, Moneda, Grupo,  SubGrupo, Cuenta, SubCuenta, Cargos, Abonos, CargosU, AbonosU, UltimoCambio)
VALUES (@Sucursal, @Empresa, @Rama, @Ejercicio, 0, @Moneda, @Grupo,  @SubGrupo, @Cuenta, @SubCuenta, @CargoInicial, @AbonoInicial, @CargoInicialU, @AbonoInicialU, @Ahora)
END
END ELSE BEGIN 
UPDATE AcumU
SET Cargos 	    = @CargoInicial,  Abonos  = @AbonoInicial,
CargosU	    = @CargoInicialU, AbonosU = @AbonoInicialU,
UltimoCambio = @Ahora
WHERE Sucursal  = @Sucursal
AND Rama 	 = @Rama
AND Empresa   = @Empresa
AND Ejercicio = @Ejercicio
AND Periodo   = 0
AND Moneda    = @Moneda
AND Grupo     = @Grupo
AND SubGrupo  = @SubGrupo
AND Cuenta    = @Cuenta
AND SubCuenta = @SubCuenta
IF @@ROWCOUNT = 0
BEGIN
SELECT @SeCreoEjercicio = 1
INSERT AcumU (Sucursal, Empresa, Rama, Ejercicio, Periodo, Moneda, Grupo,  SubGrupo, Cuenta, SubCuenta, Cargos, Abonos, CargosU, AbonosU, UltimoCambio)
VALUES (@Sucursal, @Empresa, @Rama, @Ejercicio, 0, @Moneda, @Grupo,  @SubGrupo, @Cuenta, @SubCuenta, @CargoInicial, @AbonoInicial, @CargoInicialU, @AbonoInicialU, @Ahora)
END
END 
END ELSE BEGIN 
EXEC dbo.sp_executesql N'
UPDATE AcumU
SET Cargos 	    = @CargoInicial,  Abonos  = @AbonoInicial,
CargosU	    = @CargoInicialU, AbonosU = @AbonoInicialU,
UltimoCambio = @Ahora
WHERE Sucursal  = @Sucursal
AND Rama 	 = @Rama
AND Empresa   = @Empresa
AND Ejercicio = @Ejercicio
AND Periodo   = 0
AND Moneda    = @Moneda
AND Grupo 	 = @Grupo
AND SubGrupo  = @SubGrupo
AND Cuenta    = @Cuenta
AND SubCuenta = @SubCuenta
IF @@ROWCOUNT = 0
BEGIN
SELECT @SeCreoEjercicio = 1
INSERT AcumU (Sucursal, Empresa, Rama, Ejercicio, Periodo, Moneda, Grupo, SubGrupo, Cuenta, SubCuenta, Cargos, Abonos, CargosU, AbonosU, UltimoCambio)
VALUES (@Sucursal, @Empresa, @Rama, @Ejercicio, 0, @Moneda, @Grupo, @SubGrupo, @Cuenta, @SubCuenta, @CargoInicial, @AbonoInicial, @CargoInicialU, @AbonoInicialU, @Ahora)
END',
N'@Sucursal int, @Empresa varchar(5), @Rama varchar(5), @Ejercicio int, @Moneda varchar(20), @Grupo varchar(10), @SubGrupo varchar(20), @Cuenta varchar(20),
@SubCuenta varchar(50), @CargoInicial money, @AbonoInicial money, @CargoInicialU float, @AbonoInicialU float, @Ahora datetime, @SeCreoEjercicio bit',
@Sucursal, @Empresa, @Rama, @Ejercicio, @Moneda, @Grupo, @SubGrupo, @Cuenta, @SubCuenta, @CargoInicial, @AbonoInicial, @CargoInicialU, @AbonoInicialU, @Ahora, @SeCreoEjercicio
END 
END
FETCH NEXT FROM crAcumU INTO @Sucursal, @Rama, @Moneda, @Grupo, @SubGrupo, @Cuenta, @SubCuenta, @Cargos, @Abonos, @CargosU, @AbonosU
END 
CLOSE crAcumU
DEALLOCATE crAcumU
IF @Procesando = 0
BEGIN
SELECT @EjercicioInicio = EjercicioInicio, @EjercicioFinal = EjercicioFinal
FROM EmpresaGral
WHERE Empresa = @Empresa
IF (DATEPART(yy, @EjercicioInicio) = @EjercicioAnterior) OR (DATEPART(yy, @EjercicioFinal) = @EjercicioAnterior)
BEGIN
SELECT @SeModificioGral = 1
SELECT @EjercicioInicio = DATEADD(yy, 1, @EjercicioInicio), @EjercicioFinal = DATEADD(yy, 1, @EjercicioFinal)
UPDATE EmpresaGral
SET EjercicioInicio = @EjercicioInicio, EjercicioFinal = @EjercicioFinal
WHERE Empresa = @Empresa
END
END
COMMIT TRANSACTION
IF @Procesando = 0
BEGIN
SELECT @Mensaje = "Proceso Concluido."
IF @SeCreoEjercicio = 1 SELECT @Mensaje = RTRIM(@Mensaje) + '<BR><BR>Se Creo el Ejercicio: '+LTRIM(Convert(char, @Ejercicio))
IF @SeModificioGral = 1 SELECT @Mensaje = RTRIM(@Mensaje) + '<BR><BR>Inicia: '+RTRIM(Convert(char, @EjercicioInicio, 103))
IF @SeModificioGral = 1 SELECT @Mensaje = RTRIM(@Mensaje) + '<BR>Termina: '+RTRIM(Convert(char, @EjercicioFinal, 103))
SELECT @Mensaje
END
RETURN
END

