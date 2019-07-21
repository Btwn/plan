SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerContBalanceAnuales
@Empresa		char(5),
@EjercicioD		int,
@EjercicioA		int,
@PeriodoA		int,
@Anual		char(20),
@ConMovs		char(20) = 'NO',
@CentroCostos	char(20) = NULL,
@Sucursal		int	 = NULL,
@Moneda		char(10) = NULL,
@UEN		int	    = NULL,
@Proyecto		varchar(50) = NULL,
@CentroCostos2	varchar(50) = NULL,
@CentroCostos3	varchar(50) = NULL,
@ReExpresar     char(20) = 'NO', 
@ReExpresarTipoCambio float = NULL 

AS BEGIN
SET nocount ON
DECLARE
@ID			int,
@Lado		int,
@UltLado		int,
@Renglon		int,
@UltRenglon		int,
@UltRama		char(20),
@UltRama1		char(20),
@UltRama2		char(20),
@LadoDesc		varchar(100),
@UltLadoDesc	varchar(100),
@Rama		char(20),
@RamaDesc		varchar(100),
@Cuenta		char(20),
@Descripcion	varchar(100),
@EsAcreedora	bit,
@EsTitulo		bit,
@EsFinRama		bit,
@EsFinLado		bit,
@Saldo1    		money,
@Saldo2    		money,
@Saldo3    		money,
@Saldo4    		money,
@Saldo5    		money,
@Ejercicio1		int,
@Ejercicio2		int,
@Ejercicio3		int,
@Ejercicio4		int,
@Ejercicio5		int,
@Saldo11   		money,
@Saldo12   		money,
@Saldo13   		money,
@Saldo14   		money,
@Saldo15   		money,
@CtaActivo		char(20),
@CtaPasivo		char(20),
@CtaCapital		char(20),
@CtaResultados	char(20),
@ContMoneda		char(10),
@Numero		int,
@PeriodoX		int,
@AnioInicial	int,
@AnioFinal		int,
@EjercicioX		int,
@Cuantos		int
CREATE TABLE #BalanceA(
ID			int		IDENTITY(1,1) NOT NULL,
Renglon 		int		NULL,
EsTitulo		bit		NOT NULL DEFAULT 0,
EsFinRama		bit		NOT NULL DEFAULT 0,
EsFinLado		bit		NOT NULL DEFAULT 0,
Lado		int		NULL,
LadoDesc		char(20)	COLLATE Database_Default NULL,
Rama		char(20)	COLLATE Database_Default NULL,
RamaDesc		varchar(100)	COLLATE Database_Default NULL,
Cuenta		char(20)	COLLATE Database_Default NULL,
Descripcion	varchar(100)	COLLATE Database_Default NULL,
EsAcreedora	bit		NOT NULL DEFAULT 0,
Ejercicio1		int		NULL,
Saldo1		money		NULL,
Ejercicio2		int		NULL,
Saldo2		money		NULL,
Ejercicio3		int		NULL,
Saldo3		money		NULL,
Ejercicio4		int		NULL,
Saldo4		money		NULL,
Ejercicio5		int		NULL,
Saldo5		money		NULL,
CONSTRAINT priTempBalanceA PRIMARY KEY CLUSTERED (ID)
)
CREATE TABLE #VerBalanceA(
Renglon 		int		NULL,
Lado		int		NULL,
EsTitulo1		bit		NOT NULL DEFAULT 0,
EsFinRama1		bit		NOT NULL DEFAULT 0,
EsFinLado1		bit		NOT NULL DEFAULT 0,
LadoDesc1		char(20)	COLLATE Database_Default NULL,
Rama1		char(20)	COLLATE Database_Default NULL,
RamaDesc1		varchar(100)	COLLATE Database_Default NULL,
Cuenta1		char(20)	COLLATE Database_Default NULL,
Descripcion1	varchar(100)	COLLATE Database_Default NULL,
EsAcreedora1	bit		NOT NULL DEFAULT 0,
Saldo11		money		NULL,
Ejercicio11	int		NULL,
Saldo12		money		NULL,
Ejercicio12	int		NULL,
Saldo13		money		NULL,
Ejercicio13	int		NULL,
Saldo14		money		NULL,
Ejercicio14	int		NULL,
Saldo15		money		NULL,
Ejercicio15	int		NULL,
EsTitulo2		bit		NOT NULL DEFAULT 0,
EsFinRama2		bit		NOT NULL DEFAULT 0,
EsFinLado2		bit		NOT NULL DEFAULT 0,
LadoDesc2		char(20)	COLLATE Database_Default NULL,
Rama2		char(20)	COLLATE Database_Default NULL,
RamaDesc2		varchar(100)	COLLATE Database_Default NULL,
Cuenta2		char(20)	COLLATE Database_Default NULL,
Descripcion2	varchar(100)	COLLATE Database_Default NULL,
EsAcreedora2	bit		NOT NULL DEFAULT 0,
Saldo21		money		NULL,
Ejercicio21	int		NULL,
Saldo22		money		NULL,
Ejercicio22	int		NULL,
Saldo23		money		NULL,
Ejercicio23	int		NULL
)
SELECT @ConMovs = UPPER(@ConMovs), @CentroCostos = NULLIF(RTRIM(@CentroCostos), ''), @Moneda = NULLIF(NULLIF(RTRIM(@Moneda), ''), '0')
IF UPPER(@CentroCostos) IN ('0', 'NULL', '(TODOS)') SELECT @CentroCostos = NULL
IF @Sucursal <0 SELECT @Sucursal = NULL
IF @UEN = 0 SELECT @UEN = NULL
IF UPPER(@Proyecto)      IN ('0', 'NULL', '(TODOS)','') SELECT @Proyecto = NULL
IF UPPER(@CentroCostos2) IN ('0', 'NULL', '(TODOS)','') SELECT @CentroCostos2 = NULL
IF UPPER(@CentroCostos3) IN ('0', 'NULL', '(TODOS)','') SELECT @CentroCostos3 = NULL
SELECT @CtaActivo	  = CtaActivo,
@CtaPasivo	  = CtaPasivo,
@CtaCapital	  = CtaCapital,
@CtaResultados  = CtaResultados,
@ContMoneda	  = ContMoneda
FROM EmpresaCfg
WHERE Empresa = @Empresa
IF @Moneda IS NULL SELECT @Moneda = @ContMoneda
INSERT #BalanceA
SELECT 0,0,0,0,1,
'Activo',
E2.Cuenta,
E2.Descripcion,
Cta.Cuenta,
Cta.Descripcion,
Cta.EsAcreedora,
NULL, NULL,
NULL, NULL,
NULL, NULL,
NULL, NULL,
NULL, NULL
FROM Cta
JOIN Cta E2 ON Cta.Rama = E2.Cuenta
JOIN Cta E1 ON E2.Rama = E1.Cuenta
WHERE UPPER(Cta.Tipo) = 'MAYOR'
AND (Cta.Rama = @CtaActivo OR E1.Rama = @CtaActivo OR E2.Rama = @CtaActivo)
ORDER BY Cta.Cuenta
INSERT #BalanceA
SELECT 0,0,0,0,1,
'Pasivo',
E2.Cuenta,
E2.Descripcion,
Cta.Cuenta,
Cta.Descripcion,
Cta.EsAcreedora,
NULL, NULL,
NULL, NULL,
NULL, NULL,
NULL, NULL,
NULL, NULL
FROM Cta
JOIN Cta E2 ON Cta.Rama = E2.Cuenta
JOIN Cta E1 ON E2.Rama = E1.Cuenta
WHERE UPPER(Cta.Tipo) = 'MAYOR'
AND (Cta.Rama = @CtaPasivo OR E1.Rama = @CtaPasivo OR E2.Rama = @CtaPasivo)
ORDER BY Cta.Cuenta
INSERT #BalanceA
SELECT 0,0,0,0,1,
'Capital',
E2.Cuenta,
E2.Descripcion,
Cta.Cuenta,
Cta.Descripcion,
Cta.EsAcreedora,
NULL, NULL,
NULL, NULL,
NULL, NULL,
NULL, NULL,
NULL, NULL
FROM Cta
JOIN Cta E2 ON Cta.Rama = E2.Cuenta
JOIN Cta E1 ON E2.Rama = E1.Cuenta
WHERE UPPER(Cta.Tipo) = 'MAYOR'
AND (Cta.Rama = @CtaCapital OR E1.Rama = @CtaCapital OR E2.Rama = @CtaCapital)
ORDER BY Cta.Cuenta
INSERT #BalanceA
SELECT 0,0,0,0,1,
'Capital',
E2.Cuenta,
E2.Descripcion,
Cta.Cuenta,
Cta.Descripcion,
Cta.EsAcreedora,
NULL, NULL,
NULL, NULL,
NULL, NULL,
NULL, NULL,
NULL, NULL
FROM Cta, Cta E2
WHERE E2.Cuenta = @CtaCapital
AND Cta.Cuenta = @CtaResultados
ORDER BY Cta.Cuenta
CREATE TABLE #Ejercicios
(
Numero		int		NULL,
Ejercicio		int		NULL)
SELECT @Numero = 1, @PeriodoX = MONTH(GETDATE())
DECLARE cr_Anio CURSOR FOR
SELECT @EjercicioD, @EjercicioA
OPEN cr_Anio
FETCH NEXT FROM cr_Anio INTO @AnioInicial, @AnioFinal
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
WHILE @AnioInicial <= @AnioFinal
BEGIN
INSERT #Ejercicios (Numero, Ejercicio)
VALUES (@Numero, @AnioInicial)
SELECT @AnioInicial = @AnioInicial + 1, @Numero = @Numero + 1
END
END
FETCH NEXT FROM cr_Anio INTO @AnioInicial, @AnioFinal
END
CLOSE cr_Anio
DEALLOCATE cr_Anio
SELECT @Cuantos = COUNT(Ejercicio) FROM #Ejercicios
SELECT @UltLado = NULL, @UltRama = NULL, @UltLadoDesc = NULL, @Renglon = 0
UPDATE #BalanceA SET Ejercicio1  = (SELECT Ejercicio FROM #Ejercicios WHERE Numero = 1), Ejercicio2  = (SELECT Ejercicio FROM #Ejercicios WHERE Numero = 2),
Ejercicio3  = (SELECT Ejercicio FROM #Ejercicios WHERE Numero = 3), Ejercicio4  = (SELECT Ejercicio FROM #Ejercicios WHERE Numero = 4),
Ejercicio5  = (SELECT Ejercicio FROM #Ejercicios WHERE Numero = 5)
IF @Anual = 'Del Ejercicio'
BEGIN
DECLARE crBalance CURSOR FOR
SELECT ID, Lado, LadoDesc, Rama, RamaDesc, EsTitulo,
'Saldo1' = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Empresa = @Empresa
AND a.Rama = 'CONT'
AND a.Cuenta = b.Cuenta
AND a.Ejercicio = b.Ejercicio1
AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '')
AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0)
AND ISNULL(a.UEN, 0)        = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '')
AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '')
AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '')
AND a.Moneda = @Moneda
AND a.Periodo <= @PeriodoX),
'Saldo2' = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Empresa = @Empresa
AND a.Rama = 'CONT'
AND a.Cuenta = b.Cuenta
AND a.Ejercicio = b.Ejercicio2
AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '')
AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0)
AND ISNULL(a.UEN, 0)        = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '')
AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '')
AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '')
AND a.Moneda = @Moneda
AND a.Periodo <= @PeriodoX),
'Saldo3' = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Empresa = @Empresa
AND a.Rama = 'CONT'
AND a.Cuenta = b.Cuenta
AND a.Ejercicio = b.Ejercicio3
AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '')
AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0)
AND ISNULL(a.UEN, 0)        = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '')
AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '')
AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '')
AND a.Moneda = @Moneda
AND a.Periodo <= @PeriodoX),
'Saldo4' = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Empresa = @Empresa
AND a.Rama = 'CONT'
AND a.Cuenta = b.Cuenta
AND a.Ejercicio = b.Ejercicio4
AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '')
AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0)
AND ISNULL(a.UEN, 0)        = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '')
AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '')
AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '')
AND a.Moneda = @Moneda
AND a.Periodo <= @PeriodoX),
'Saldo5' = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Empresa = @Empresa
AND a.Rama = 'CONT'
AND a.Cuenta = b.Cuenta
AND a.Ejercicio = b.Ejercicio5
AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '')
AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0)
AND ISNULL(a.UEN, 0)        = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '')
AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '')
AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '')
AND a.Moneda = @Moneda
AND a.Periodo <= @PeriodoX)
FROM #BalanceA b
OPEN crBalance
FETCH NEXT FROM crBalance INTO @ID, @Lado, @LadoDesc, @Rama, @RamaDesc, @EsTitulo, @Saldo1, @Saldo2, @Saldo3, @Saldo4, @Saldo5
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2 AND @EsTitulo = 0
BEGIN
IF ISNULL(@Saldo1, 0.0) = 0.0 AND ISNULL(@Saldo2, 0.0) = 0.0 AND ISNULL(@Saldo3, 0.0) = 0.0 AND @ConMovs = 'SI'
DELETE FROM #BalanceA WHERE ID = @ID
ELSE
BEGIN
IF @Rama <> @UltRama
BEGIN
SELECT @Renglon = @Renglon + 1
INSERT #BalanceA (EsTitulo, EsFinRama, Renglon, Lado) VALUES (1, 1, @Renglon, @UltLado)
END
IF @UltLadoDesc<>@LadoDesc
BEGIN
SELECT @Renglon = @Renglon + 1
INSERT #BalanceA (EsTitulo, EsFinLado, Renglon, Lado) VALUES (1, 1, @Renglon, @UltLado)
END
IF @Lado <> @UltLado SELECT @Renglon = 1 ELSE SELECT @Renglon = @Renglon + 1
IF @Rama <> @UltRama
BEGIN
INSERT #BalanceA (EsTitulo, Renglon, Lado, Descripcion) VALUES (1, @Renglon, @Lado, @RamaDesc)
SELECT @Renglon = @Renglon + 1
END
UPDATE #BalanceA
SET Renglon = @Renglon,
Saldo1 = @Saldo1, Saldo2 = @Saldo2, Saldo3 = @Saldo3
WHERE ID = @ID
SELECT @UltLado = @Lado, @UltLadoDesc = @LadoDesc, @UltRama = @Rama
END
END
FETCH NEXT FROM crBalance INTO @ID, @Lado, @LadoDesc, @Rama, @RamaDesc, @EsTitulo, @Saldo1, @Saldo2, @Saldo3, @Saldo4, @Saldo5
END
SELECT @Renglon = @Renglon + 1
INSERT #BalanceA (EsTitulo, EsFinRama, Renglon, Lado) VALUES (1, 1, @Renglon, @UltLado)
SELECT @Renglon = @Renglon + 1
INSERT #BalanceA (EsTitulo, EsFinLado, Renglon, Lado) VALUES (1, 1, @Renglon, @UltLado)
CLOSE crBalance
DEALLOCATE crBalance
END
IF @Anual = 'Acumulado a'
BEGIN
DECLARE crBalance CURSOR FOR
SELECT ID, Lado, LadoDesc, Rama, RamaDesc, EsTitulo,
'Saldo1' = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Empresa = @Empresa
AND a.Rama = 'CONT'
AND a.Cuenta = b.Cuenta
AND a.Ejercicio = b.Ejercicio1
AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '')
AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0)
AND ISNULL(a.UEN, 0)        = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '')
AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '')
AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '')
AND a.Moneda = @Moneda
AND a.Periodo BETWEEN 0 AND @PeriodoA),
'Saldo2' = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Empresa = @Empresa
AND a.Rama = 'CONT'
AND a.Cuenta = b.Cuenta
AND a.Ejercicio = b.Ejercicio2
AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '')
AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0)
AND ISNULL(a.UEN, 0)        = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '')
AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '')
AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '')
AND a.Moneda = @Moneda
AND a.Periodo BETWEEN 0 AND @PeriodoA),
'Saldo3' = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Empresa = @Empresa
AND a.Rama = 'CONT'
AND a.Cuenta = b.Cuenta
AND a.Ejercicio = b.Ejercicio3
AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '')
AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0)
AND ISNULL(a.UEN, 0)        = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '')
AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '')
AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '')
AND a.Moneda = @Moneda
AND a.Periodo BETWEEN 0 AND @PeriodoA),
'Saldo4' = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Empresa = @Empresa
AND a.Rama = 'CONT'
AND a.Cuenta = b.Cuenta
AND a.Ejercicio = b.Ejercicio4
AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '')
AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0)
AND ISNULL(a.UEN, 0)        = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '')
AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '')
AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '')
AND a.Moneda = @Moneda
AND a.Periodo BETWEEN 0 AND @PeriodoA),
'Saldo5' = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Empresa = @Empresa
AND a.Rama = 'CONT'
AND a.Cuenta = b.Cuenta
AND a.Ejercicio = b.Ejercicio5
AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '')
AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0)
AND ISNULL(a.UEN, 0)        = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '')
AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '')
AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '')
AND a.Moneda = @Moneda
AND a.Periodo BETWEEN 0 AND @PeriodoA)
FROM #BalanceA b
OPEN crBalance
FETCH NEXT FROM crBalance INTO @ID, @Lado, @LadoDesc, @Rama, @RamaDesc, @EsTitulo, @Saldo1, @Saldo2, @Saldo3, @Saldo4, @Saldo5
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2 AND @EsTitulo = 0
BEGIN
IF ISNULL(@Saldo1, 0.0) = 0.0 AND ISNULL(@Saldo2, 0.0) = 0.0 AND ISNULL(@Saldo3, 0.0) = 0.0 AND ISNULL(@Saldo4, 0.0) = 0.0 AND ISNULL(@Saldo5, 0.0) = 0.0 AND @ConMovs = 'SI'
DELETE FROM #BalanceA WHERE ID = @ID
ELSE
BEGIN
IF @Rama <> @UltRama
BEGIN
SELECT @Renglon = @Renglon + 1
INSERT #BalanceA (EsTitulo, EsFinRama, Renglon, Lado) VALUES (1, 1, @Renglon, @UltLado)
END
IF @UltLadoDesc<>@LadoDesc
BEGIN
SELECT @Renglon = @Renglon + 1
INSERT #BalanceA (EsTitulo, EsFinLado, Renglon, Lado) VALUES (1, 1, @Renglon, @UltLado)
END
IF @Lado <> @UltLado SELECT @Renglon = 1 ELSE SELECT @Renglon = @Renglon + 1
IF @Rama <> @UltRama
BEGIN
INSERT #BalanceA (EsTitulo, Renglon, Lado, Descripcion) VALUES (1, @Renglon, @Lado, @RamaDesc)
SELECT @Renglon = @Renglon + 1
END
UPDATE #BalanceA
SET Renglon = @Renglon,
Saldo1 = @Saldo1, Saldo2 = @Saldo2, Saldo3 = @Saldo3, Saldo4 = @Saldo4, Saldo5 = @Saldo5
WHERE ID = @ID
SELECT @UltLado = @Lado, @UltLadoDesc = @LadoDesc, @UltRama = @Rama
END
END
FETCH NEXT FROM crBalance INTO @ID, @Lado, @LadoDesc, @Rama, @RamaDesc, @EsTitulo, @Saldo1, @Saldo2, @Saldo3, @Saldo4, @Saldo5
END
SELECT @Renglon = @Renglon + 1
INSERT #BalanceA (EsTitulo, EsFinRama, Renglon, Lado) VALUES (1, 1, @Renglon, @UltLado)
SELECT @Renglon = @Renglon + 1
INSERT #BalanceA (EsTitulo, EsFinLado, Renglon, Lado) VALUES (1, 1, @Renglon, @UltLado)
CLOSE crBalance
DEALLOCATE crBalance
END
IF @Anual = 'Del Mes'
BEGIN
DECLARE crBalance CURSOR FOR
SELECT ID, Lado, LadoDesc, Rama, RamaDesc, EsTitulo,
'Saldo1' = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Empresa = @Empresa
AND a.Rama = 'CONT'
AND a.Cuenta = b.Cuenta
AND a.Ejercicio = b.Ejercicio1
AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '')
AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0)
AND ISNULL(a.UEN, 0)        = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '')
AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '')
AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '')
AND a.Moneda = @Moneda
AND a.Periodo = @PeriodoA),
'Saldo2' = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Empresa = @Empresa
AND a.Rama = 'CONT'
AND a.Cuenta = b.Cuenta
AND a.Ejercicio = b.Ejercicio2
AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '')
AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0)
AND ISNULL(a.UEN, 0)        = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '')
AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '')
AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '')
AND a.Moneda = @Moneda
AND a.Periodo = @PeriodoA),
'Saldo3' = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Empresa = @Empresa
AND a.Rama = 'CONT'
AND a.Cuenta = b.Cuenta
AND a.Ejercicio = b.Ejercicio3
AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '')
AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0)
AND ISNULL(a.UEN, 0)        = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '')
AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '')
AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '')
AND a.Moneda = @Moneda
AND a.Periodo = @PeriodoA),
'Saldo4' = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Empresa = @Empresa
AND a.Rama = 'CONT'
AND a.Cuenta = b.Cuenta
AND a.Ejercicio = b.Ejercicio4
AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '')
AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0)
AND ISNULL(a.UEN, 0)        = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '')
AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '')
AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '')
AND a.Moneda = @Moneda
AND a.Periodo = @PeriodoA),
'Saldo5' = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Empresa = @Empresa
AND a.Rama = 'CONT'
AND a.Cuenta = b.Cuenta
AND a.Ejercicio = b.Ejercicio5
AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '')
AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0)
AND ISNULL(a.UEN, 0)        = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '')
AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '')
AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '')
AND a.Moneda = @Moneda
AND a.Periodo = @PeriodoA)
FROM #BalanceA b
OPEN crBalance
FETCH NEXT FROM crBalance INTO @ID, @Lado, @LadoDesc, @Rama, @RamaDesc, @EsTitulo, @Saldo1, @Saldo2, @Saldo3, @Saldo4, @Saldo5
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2 AND @EsTitulo = 0
BEGIN
IF ISNULL(@Saldo1, 0.0) = 0.0 AND ISNULL(@Saldo2, 0.0) = 0.0 AND ISNULL(@Saldo3, 0.0) = 0.0 AND ISNULL(@Saldo4, 0.0) = 0.0 AND ISNULL(@Saldo5, 0.0) = 0.0 AND @ConMovs = 'SI'
DELETE FROM #BalanceA WHERE ID = @ID
ELSE
BEGIN
IF @Rama <> @UltRama
BEGIN
SELECT @Renglon = @Renglon + 1
INSERT #BalanceA (EsTitulo, EsFinRama, Renglon, Lado) VALUES (1, 1, @Renglon, @UltLado)
END
IF @UltLadoDesc<>@LadoDesc
BEGIN
SELECT @Renglon = @Renglon + 1
INSERT #BalanceA (EsTitulo, EsFinLado, Renglon, Lado) VALUES (1, 1, @Renglon, @UltLado)
END
IF @Lado <> @UltLado SELECT @Renglon = 1 ELSE SELECT @Renglon = @Renglon + 1
IF @Rama <> @UltRama
BEGIN
INSERT #BalanceA (EsTitulo, Renglon, Lado, Descripcion) VALUES (1, @Renglon, @Lado, @RamaDesc)
SELECT @Renglon = @Renglon + 1
END
UPDATE #BalanceA
SET Renglon = @Renglon,
Saldo1 = @Saldo1, Saldo2 = @Saldo2, Saldo3 = @Saldo3, Saldo4 = @Saldo4, Saldo5 = @Saldo5
WHERE ID = @ID
SELECT @UltLado = @Lado, @UltLadoDesc = @LadoDesc, @UltRama = @Rama
END
END
FETCH NEXT FROM crBalance INTO @ID, @Lado, @LadoDesc, @Rama, @RamaDesc, @EsTitulo, @Saldo1, @Saldo2, @Saldo3, @Saldo4, @Saldo5
END
SELECT @Renglon = @Renglon + 1
INSERT #BalanceA (EsTitulo, EsFinRama, Renglon, Lado) VALUES (1, 1, @Renglon, @UltLado)
SELECT @Renglon = @Renglon + 1
INSERT #BalanceA (EsTitulo, EsFinLado, Renglon, Lado) VALUES (1, 1, @Renglon, @UltLado)
CLOSE crBalance
DEALLOCATE crBalance
END
SELECT @UltRenglon = NULL, @UltRama1 = NULL, @UltRama2 = NULL
DECLARE crVerBalance CURSOR FOR
SELECT EsTitulo, EsFinRama, EsFinLado, Renglon, Lado, LadoDesc, Rama, RamaDesc, Cuenta, Descripcion, EsAcreedora, Saldo1, Saldo2, Saldo3, Saldo4, Saldo5, Ejercicio1, Ejercicio2, Ejercicio3, Ejercicio4, Ejercicio5
FROM #BalanceA ORDER BY Renglon, Lado, Rama
OPEN crVerBalance
FETCH NEXT FROM crVerBalance INTO @EsTitulo, @EsFinRama, @EsFinLado, @Renglon, @Lado, @LadoDesc, @Rama, @RamaDesc, @Cuenta, @Descripcion, @EsAcreedora, @Saldo1, @Saldo2, @Saldo3, @Saldo4, @Saldo5, @Ejercicio1, @Ejercicio2, @Ejercicio3, @Ejercicio4, @Ejercicio5
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Lado = 1
BEGIN
IF @UltRenglon <> @Renglon
INSERT #VerBalanceA (Renglon,  Lado,  EsTitulo1, EsFinRama1, EsFinLado1, LadoDesc1, Rama1, RamaDesc1, Cuenta1, Descripcion1, EsAcreedora1, Saldo11, Ejercicio11, Saldo12, Ejercicio12, Saldo13, Ejercicio13, Saldo14, Ejercicio14, Saldo15, Ejercicio15)
VALUES ( @Renglon, @Lado, @EsTitulo, @EsFinRama, @EsFinLado, @LadoDesc, @Rama, @RamaDesc, @Cuenta, @Descripcion, @EsAcreedora, @Saldo1, @Ejercicio1, @Saldo2, @Ejercicio2, @Saldo3, @Ejercicio3, @Saldo4, @Ejercicio4, @Saldo5, @Ejercicio5)
ELSE
UPDATE #VerBalanceA
SET EsTitulo1 = @EsTitulo, EsFinRama1 = @EsFinRama, EsFinLado1 = @EsFinLado, LadoDesc1 = @LadoDesc, Rama1 = @Rama, RamaDesc1 = @RamaDesc, Cuenta1 = @Cuenta, Descripcion1 = @Descripcion, EsAcreedora1 = @EsAcreedora, Saldo11 = @Saldo1, Ejercicio11 = @Ejercicio1, Saldo12 = @Saldo2, Ejercicio12 = @Ejercicio2, Saldo13 = @Saldo3, Ejercicio13 = @Ejercicio3, Saldo14 = @Saldo4, Ejercicio14 = @Ejercicio4, Saldo15 = @Saldo5, Ejercicio15 = @Ejercicio5
WHERE Renglon = @Renglon
END ELSE BEGIN
IF @UltRenglon <> @Renglon
INSERT #VerBalanceA (Renglon,  Lado,  EsTitulo2, EsFinRama2, EsFinLado2, LadoDesc2, Rama2, RamaDesc2, Cuenta2, Descripcion2, EsAcreedora2, Saldo21, Ejercicio21, Saldo22, Ejercicio22, Saldo23, Ejercicio23)
VALUES (@Renglon, @Lado, @EsTitulo, @EsFinRama, @EsFinLado, @LadoDesc, @Rama, @RamaDesc, @Cuenta, @Descripcion, @EsAcreedora, @Saldo1, @Ejercicio1, @Saldo2, @Ejercicio2, @Saldo3, @Ejercicio3)
ELSE
UPDATE #VerBalanceA
SET EsTitulo2 = @EsTitulo, EsFinRama2 = @EsFinRama, EsFinLado2 = @EsFinLado, LadoDesc2 = @LadoDesc, Rama2 = @Rama, RamaDesc2 = @RamaDesc, Cuenta2 = @Cuenta, Descripcion2 = @Descripcion, EsAcreedora2 = @EsAcreedora, Saldo21 = @Saldo1, Ejercicio21 = @Ejercicio1, Saldo22 = @Saldo2, Ejercicio22 = @Ejercicio2, Saldo23 = @Saldo3, Ejercicio23 = @Ejercicio3
WHERE Renglon = @Renglon
END
SELECT @UltRenglon = @Renglon
END
FETCH NEXT FROM crVerBalance INTO @EsTitulo, @EsFinRama, @EsFinLado, @Renglon, @Lado, @LadoDesc, @Rama, @RamaDesc, @Cuenta, @Descripcion, @EsAcreedora, @Saldo1, @Saldo2, @Saldo3, @Saldo4, @Saldo5, @Ejercicio1, @Ejercicio2, @Ejercicio3, @Ejercicio4, @Ejercicio5
END
CLOSE crVerBalance
DEALLOCATE crVerBalance
IF @ReExpresar='Si'
UPDATE #VerBalanceA
SET Saldo11=Saldo11/ISNULL(@ReExpresarTipoCambio,1), Saldo12=Saldo12/ISNULL(@ReExpresarTipoCambio,1), Saldo13=Saldo13/ISNULL(@ReExpresarTipoCambio,1),
Saldo21=Saldo21/ISNULL(@ReExpresarTipoCambio,1), Saldo22=Saldo22/ISNULL(@ReExpresarTipoCambio,1), Saldo23=Saldo23/ISNULL(@ReExpresarTipoCambio,1)
SELECT * FROM #VerBalanceA WHERE EsTitulo1 = 0
END

