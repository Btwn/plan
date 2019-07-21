SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerRama
@Empresa		char(5),
@Estacion		int,
@Modulo		char(5),
@Rama		char(60),
@Ejercicio		int,
@Periodo		int,
@PeriodoDe		int,
@PeriodoA		int,
@SaldoActual	bit,
@Acumulado		bit,
@Todo		bit,
@Vista		char(20)  = 'NORMAL',  
@Comparar		char(20)  = NULL,
@MonedaEspecifica	char(10)  = NULL

AS BEGIN
DECLARE
@Orden		int,
@UltCuenta		char(20),
@Cuenta		char(20),
@SubCuenta		varchar(50),
@Grupo		char(50),
@UltGrupo		char(50),
@SubGrupo		char(50),
@UltSubGrupo	char(50),
@Descripcion	varchar(100),
@Moneda		char(10),
@Signo		char(1),
@EsAcreedora	bit,
@UltEsAcreedora	bit,
@EsAcumulativa	bit,
@Tipo		char(15),
@EsLista		bit,
@EsMonetario	bit,
@EsUnidades		bit,
@EsResultados	bit,
@Inicio		money,
@Cargos		money,
@Abonos		money,
@SumaFinal		money,
@SumaFinalAcreedor	money,
@SumaCargos		money,
@SumaAbonos		money,
@GrupoCargos	money,
@GrupoAbonos	money,
@GrupoFinal		money,
@SubGrupoCargos	money,
@SubGrupoAbonos	money,
@SubGrupoFinal	money,
@Final		money,
@Comparacion	money,
@InicioU		float,
@CargosU		float,
@AbonosU		float,
@SumaFinalU		float,
@SumaCargosU	float,
@SumaAbonosU	float,
@GrupoCargosU	float,
@GrupoAbonosU	float,
@GrupoFinalU	float,
@SubGrupoCargosU	float,
@SubGrupoAbonosU	float,
@SubGrupoFinalU	float,
@FinalU		float
SELECT @Rama = NULLIF(UPPER(RTRIM(@Rama)), ''), @Vista = ISNULL(NULLIF(UPPER(RTRIM(@Vista)), ''), 'NORMAL'), @Comparar = NULLIF(UPPER(RTRIM(@Comparar)), ''),
@MonedaEspecifica = NULLIF(NULLIF(RTRIM(@MonedaEspecifica), ''), '0')
SELECT @UltCuenta = NULL, @Orden = 0
SELECT @EsAcreedora = 0, @UltEsAcreedora = 0, @EsAcumulativa = 0, @EsLista = 0, @Comparacion = NULL
IF SUBSTRING(@Rama, 1, 6) = 'LISTA=' SELECT @EsLista = 1, @Rama = RTRIM(SUBSTRING(@Rama, 7, 60))
DELETE VerRama WHERE Estacion = @Estacion
SELECT @EsMonetario  = EsMonetario,
@EsUnidades   = EsUnidades,
@EsResultados = EsResultados
FROM Rama
WHERE Rama = @Modulo
IF @EsLista = 1
BEGIN
IF @Vista = 'NORMAL'
DECLARE crRama CURSOR FOR
SELECT Cta.Cuenta, Cta.Cuenta, Cta.Descripcion, s.Moneda, NULLIF(RTRIM(ListaD.Grupo), ''), NULLIF(RTRIM(ListaD.SubGrupo), ''), ListaD.Signo
FROM Cta
LEFT OUTER JOIN Saldo s ON Cta.Cuenta = s.Cuenta AND s.Rama = @Modulo AND s.Empresa = @Empresa AND s.Moneda = ISNULL(@MonedaEspecifica, s.Moneda)
JOIN ListaD ON Cta.Cuenta = ListaD.Cuenta
LEFT OUTER JOIN ListaGrupo lg ON ListaD.Grupo = lg.Grupo
LEFT OUTER JOIN ListaGrupo lsg ON ListaD.SubGrupo = lsg.Grupo
WHERE ListaD.Lista = @Rama
GROUP BY lg.Orden, lsg.Orden, ListaD.Grupo, ListaD.SubGrupo, Cta.Cuenta, ListaD.Signo, Cta.Descripcion, s.Moneda
ORDER BY lg.Orden, lsg.Orden, ListaD.Grupo, ListaD.SubGrupo, Cta.Cuenta, ListaD.Signo, Cta.Descripcion, s.Moneda
ELSE
DECLARE crRama CURSOR FOR
SELECT Cta.Cuenta, s.SubCuenta, Cta.Descripcion, s.Moneda, NULLIF(RTRIM(ListaD.Grupo), ''), NULLIF(RTRIM(ListaD.SubGrupo), ''), ListaD.Signo
FROM Cta
LEFT OUTER JOIN Saldo s ON Cta.Cuenta = s.Cuenta AND s.Rama = @Modulo AND s.Empresa = @Empresa AND s.Moneda = ISNULL(@MonedaEspecifica, s.Moneda)
JOIN ListaD ON Cta.Cuenta = ListaD.Cuenta
LEFT OUTER JOIN ListaGrupo lg ON ListaD.Grupo = lg.Grupo
LEFT OUTER JOIN ListaGrupo lsg ON ListaD.SubGrupo = lsg.Grupo
WHERE ListaD.Lista = @Rama
GROUP BY lg.Orden, lsg.Orden, ListaD.Grupo, ListaD.SubGrupo, Cta.Cuenta, s.SubCuenta, ListaD.Signo, Cta.Descripcion, s.Moneda
ORDER BY lg.Orden, lsg.Orden, ListaD.Grupo, ListaD.SubGrupo, Cta.Cuenta, s.SubCuenta, ListaD.Signo, Cta.Descripcion, s.Moneda
END ELSE
BEGIN
IF @Modulo = 'CONT'
BEGIN
IF @Vista = 'NORMAL'
DECLARE crRama CURSOR FOR
SELECT Cta.Cuenta, Cta.Cuenta, Descripcion, s.Moneda, Cta.Cuenta, Cta.Cuenta, '+'
FROM Cta
LEFT OUTER JOIN Saldo s ON Cta.Cuenta = s.Cuenta AND s.Rama = @Modulo AND s.Empresa = @Empresa AND s.Moneda = ISNULL(@MonedaEspecifica, s.Moneda)
WHERE Cta.Rama = @Rama
GROUP BY Cta.Cuenta, Descripcion, s.Moneda
ORDER BY Cta.Cuenta, Descripcion, s.Moneda
ELSE
DECLARE crRama CURSOR FOR
SELECT Cta.Cuenta, NULLIF(RTRIM(s.SubCuenta), ''), Descripcion, s.Moneda, Cta.Cuenta, Cta.Cuenta, '+'
FROM Cta
LEFT OUTER JOIN Saldo s ON Cta.Cuenta = s.Cuenta AND s.Rama = @Modulo AND s.Empresa = @Empresa AND s.Moneda = ISNULL(@MonedaEspecifica, s.Moneda)
WHERE Cta.Rama = @Rama
GROUP BY Cta.Cuenta, s.SubCuenta, Descripcion, s.Moneda
ORDER BY Cta.Cuenta, s.SubCuenta, Descripcion, s.Moneda
END ELSE
IF @Modulo = 'CC'
BEGIN
DECLARE crRama CURSOR FOR
SELECT cc.CentroCostos, cc.CentroCostos, cc.Descripcion, s.Moneda, cc.CentroCostos, cc.CentroCostos, '+'
FROM CentroCostos cc
LEFT OUTER JOIN Saldo s ON cc.CentroCostos = s.Cuenta AND s.Rama = @Modulo AND s.Empresa = @Empresa AND s.Moneda = ISNULL(@MonedaEspecifica, s.Moneda)
WHERE cc.Rama = @Rama
GROUP BY cc.CentroCostos, cc.Descripcion, s.Moneda
ORDER BY cc.CentroCostos, cc.Descripcion, s.Moneda
END
IF @Modulo = 'CC2'
BEGIN
DECLARE crRama CURSOR FOR
SELECT cc.CentroCostos2, cc.CentroCostos2, cc.Descripcion, s.Moneda, cc.CentroCostos2, cc.CentroCostos2, '+'
FROM CentroCostos2 cc
LEFT OUTER JOIN Saldo s ON cc.CentroCostos2 = s.Cuenta AND s.Rama = @Modulo AND s.Empresa = @Empresa AND s.Moneda = ISNULL(@MonedaEspecifica, s.Moneda)
WHERE cc.Rama = @Rama
GROUP BY cc.CentroCostos2, cc.Descripcion, s.Moneda
ORDER BY cc.CentroCostos2, cc.Descripcion, s.Moneda
END
IF @Modulo = 'CC3'
BEGIN
DECLARE crRama CURSOR FOR
SELECT cc.CentroCostos3, cc.CentroCostos3, cc.Descripcion, s.Moneda, cc.CentroCostos3, cc.CentroCostos3, '+'
FROM CentroCostos3 cc
LEFT OUTER JOIN Saldo s ON cc.CentroCostos3 = s.Cuenta AND s.Rama = @Modulo AND s.Empresa = @Empresa AND s.Moneda = ISNULL(@MonedaEspecifica, s.Moneda)
WHERE cc.Rama = @Rama
GROUP BY cc.CentroCostos3, cc.Descripcion, s.Moneda
ORDER BY cc.CentroCostos3, cc.Descripcion, s.Moneda
END
END
SELECT @UltGrupo        = NULL, @UltSubGrupo     = NULL
SELECT @SumaCargos      = 0.0,  @SumaAbonos      = 0.0, @SumaFinal      = 0.0, @SumaFinalAcreedor  = 0.0,
@SumaCargosU     = 0.0,  @SumaAbonosU     = 0.0, @SumaFinalU     = 0.0,
@GrupoCargos     = 0.0,  @GrupoAbonos     = 0.0, @GrupoFinal     = 0.0,
@GrupoCargosU    = 0.0,  @GrupoAbonosU    = 0.0, @GrupoFinalU    = 0.0,
@SubGrupoCargos  = 0.0,  @SubGrupoAbonos  = 0.0, @SubGrupoFinal  = 0.0,
@SubGrupoCargosU = 0.0,  @SubGrupoAbonosU = 0.0, @SubGrupoFinalU = 0.0
OPEN crRama
FETCH NEXT FROM crRama INTO @Cuenta, @SubCuenta, @Descripcion, @Moneda, @Grupo, @SubGrupo, @Signo
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Vista = 'NORMAL' SELECT @SubCuenta = NULL
EXEC spVerRamaDesglose @Empresa, @Modulo, @Cuenta, @SubCuenta, @Moneda, NULL,
@Ejercicio, @PeriodoDe, @PeriodoA, @SaldoActual, @Acumulado, @EsUnidades, @EsResultados, @Vista,
@Inicio  OUTPUT, @Cargos  OUTPUT, @Abonos  OUTPUT, @Final  OUTPUT,
@InicioU OUTPUT, @CargosU OUTPUT, @AbonosU OUTPUT, @FinalU OUTPUT
IF @Modulo = 'CONT'
IF @Cuenta <> @UltCuenta
BEGIN
SELECT @EsAcreedora = EsAcreedora, @Tipo = Tipo
FROM Cta
WHERE Cuenta = @Cuenta
END
SELECT @EsAcumulativa = 0
IF @Comparar = 'PRESUPUESTO'
EXEC spVerPresupuesto @Empresa, @Modulo, @Cuenta, @SubCuenta, @Moneda,
@Ejercicio, @Periodo, @PeriodoDe, @PeriodoA, @SaldoActual, @Acumulado,
@Comparacion OUTPUT
ELSE
IF @Comparar = 'ANTERIOR'
EXEC spVerRamaDesglose @Empresa, @Modulo, @Cuenta, @SubCuenta, @Moneda, @Comparar,
@Ejercicio, @PeriodoDe, @PeriodoA, @SaldoActual, @Acumulado, @EsUnidades, @EsResultados, @Vista,
@Inicio, @Cargos, @Abonos, @Comparacion OUTPUT,
@InicioU, @CargosU, @AbonosU, @FinalU
IF @EsLista = 1
BEGIN
IF (@UltCuenta IS NOT NULL) AND (@Grupo <> @UltGrupo OR @SubGrupo <> @UltSubGrupo)
BEGIN
IF @Grupo <> @UltGrupo OR @SubGrupo <> @UltSubGrupo
BEGIN
IF @UltSubGrupo IS NOT NULL
BEGIN
SELECT @Orden = @Orden + 1
INSERT VerRama (Estacion,  Orden,  Rama,  Descripcion,  EsAcumulativa, EsAcreedora, Cargos,  Abonos,  Final, CargosU,  AbonosU, FinalU)
VALUES (@Estacion, @Orden, @Rama, @UltSubGrupo, 1, @UltEsAcreedora, @SubGrupoCargos, @SubGrupoAbonos, @SubGrupoFinal, @SubGrupoCargosU, @SubGrupoAbonosU, @SubGrupoFinalU)
END
SELECT @UltSubGrupo = NULL
SELECT @SubGrupoCargos  = 0.0,  @SubGrupoAbonos  = 0.0, @SubGrupoFinal  = 0.0,
@SubGrupoCargosU = 0.0,  @SubGrupoAbonosU = 0.0, @SubGrupoFinalU = 0.0
END
IF @Grupo <> @UltGrupo
BEGIN
IF @UltGrupo IS NOT NULL
BEGIN
SELECT @Orden = @Orden + 1
INSERT VerRama (Estacion,  Orden,  Rama,  Descripcion,  EsAcumulativa,  EsAcreedora, Cargos,  Abonos,  Final, CargosU,  AbonosU, FinalU)
VALUES (@Estacion, @Orden, @Rama, @UltGrupo, 1, @UltEsAcreedora, @GrupoCargos, @GrupoAbonos, @GrupoFinal, @GrupoCargosU, @GrupoAbonosU, @GrupoFinalU)
END
SELECT @UltGrupo = NULL
SELECT @GrupoCargos  = 0.0,  @GrupoAbonos  = 0.0, @GrupoFinal  = 0.0,
@GrupoCargosU = 0.0,  @GrupoAbonosU = 0.0, @GrupoFinalU = 0.0
END
END
SELECT @UltCuenta = @Cuenta, @UltEsAcreedora = @EsAcreedora, @UltGrupo = @Grupo, @UltSubGrupo = @SubGrupo
IF @Signo = '-'
BEGIN
IF @EsAcreedora = 1 SELECT @SumaFinalAcreedor = @SumaFinalAcreedor + @Final ELSE SELECT @SumaFinal = @SumaFinal - @Final
SELECT @SumaCargos      = @SumaCargos      - @Cargos,  @SumaAbonos      = @SumaAbonos      - @Abonos,
@SumaCargosU     = @SumaCargosU     - @CargosU, @SumaAbonosU     = @SumaAbonosU     - @AbonosU, @SumaFinalU     = @SumaFinalU     - @FinalU,
@GrupoCargos     = @GrupoCargos     - @Cargos,  @GrupoAbonos     = @GrupoAbonos     - @Abonos,  @GrupoFinal     = @GrupoFinal     - @Final,
@GrupoCargosU    = @GrupoCargosU    - @CargosU, @GrupoAbonosU    = @GrupoAbonosU    - @AbonosU, @GrupoFinalU    = @GrupoFinalU    - @FinalU,
@SubGrupoCargos  = @SubGrupoCargos  - @Cargos,  @SubGrupoAbonos  = @SubGrupoAbonos  - @Abonos,  @SubGrupoFinal  = @SubGrupoFinal  - @Final,
@SubGrupoCargosU = @SubGrupoCargosU - @CargosU, @SubGrupoAbonosU = @SubGrupoAbonosU - @AbonosU, @SubGrupoFinalU = @SubGrupoFinalU - @FinalU
END ELSE
BEGIN
IF @EsAcreedora = 1 SELECT @SumaFinalAcreedor = @SumaFinalAcreedor - @Final ELSE SELECT @SumaFinal = @SumaFinal + @Final
SELECT @SumaCargos      = @SumaCargos      + @Cargos,  @SumaAbonos      = @SumaAbonos      + @Abonos,
@SumaCargosU     = @SumaCargosU     + @CargosU, @SumaAbonosU     = @SumaAbonosU     + @AbonosU, @SumaFinalU     = @SumaFinalU     + @FinalU,
@GrupoCargos     = @GrupoCargos     + @Cargos,  @GrupoAbonos     = @GrupoAbonos     + @Abonos,  @GrupoFinal     = @GrupoFinal     + @Final,
@GrupoCargosU    = @GrupoCargosU    + @CargosU, @GrupoAbonosU    = @GrupoAbonosU    + @AbonosU, @GrupoFinalU    = @GrupoFinalU    + @FinalU,
@SubGrupoCargos  = @SubGrupoCargos  + @Cargos,  @SubGrupoAbonos  = @SubGrupoAbonos  + @Abonos,  @SubGrupoFinal  = @SubGrupoFinal  + @Final,
@SubGrupoCargosU = @SubGrupoCargosU + @CargosU, @SubGrupoAbonosU = @SubGrupoAbonosU + @AbonosU, @SubGrupoFinalU = @SubGrupoFinalU + @FinalU
END
END ELSE
IF @EsAcreedora = 1 SELECT @SumaFinalAcreedor = @SumaFinalAcreedor - @Final ELSE SELECT @SumaFinal = @SumaFinal + @Final
SELECT @Orden = @Orden + 1
INSERT VerRama (Estacion,  Orden,  Cuenta,  SubCuenta,  Rama,  Descripcion,  EsAcreedora,  EsAcumulativa,  Tipo,  Inicio,  Cargos,  Abonos,  Final,  Comparacion,  InicioU,  CargosU,  AbonosU,  FinalU)
VALUES (@Estacion, @Orden, @Cuenta, @SubCuenta, @Rama, @Descripcion, @EsAcreedora, @EsAcumulativa, @Tipo, @Inicio, @Cargos, @Abonos, @Final, @Comparacion, @InicioU, @CargosU, @AbonosU, @FinalU)
END
FETCH NEXT FROM crRama INTO @Cuenta, @SubCuenta, @Descripcion, @Moneda, @Grupo, @SubGrupo, @Signo
END
IF @EsLista = 1
BEGIN
IF @UltSubGrupo IS NOT NULL
BEGIN
SELECT @Orden = @Orden + 1
INSERT VerRama (Estacion,  Orden,  Rama,  Descripcion,  EsAcumulativa, EsAcreedora, Cargos,  Abonos,  Final, CargosU,  AbonosU, FinalU)
VALUES (@Estacion, @Orden, @Rama, @SubGrupo, 1, @UltEsAcreedora, @SubGrupoCargos, @SubGrupoAbonos, @SubGrupoFinal, @SubGrupoCargosU, @SubGrupoAbonosU, @SubGrupoFinalU)
END
IF @UltGrupo IS NOT NULL
BEGIN
SELECT @Orden = @Orden + 1
INSERT VerRama (Estacion,  Orden,  Rama,  Descripcion, EsAcumulativa, EsAcreedora, Cargos,  Abonos,  Final, CargosU,  AbonosU, FinalU)
VALUES (@Estacion, @Orden, @Rama, @Grupo, 1, @UltEsAcreedora, @GrupoCargos, @GrupoAbonos, @GrupoFinal, @GrupoCargosU, @GrupoAbonosU, @GrupoFinalU)
END
END
CLOSE crRama
DEALLOCATE crRama
SELECT @Orden = @Orden + 1
INSERT VerRama (Estacion,  Orden,  Rama,  Descripcion, Periodo, Cargos,  Abonos)
VALUES (@Estacion, @Orden, @Rama, 'Totales', 999, @SumaFinal, @SumaFinalAcreedor)
IF @Todo = 1
SELECT Cuenta, SubCuenta, Rama, Descripcion, EsAcreedora, EsAcumulativa, Tipo,
"Inicio"  = NULLIF(Inicio, 0.0),  "Cargos"  = NULLIF(Cargos, 0.0),  "Abonos"  = NULLIF(Abonos, 0.0),  "Final"  = NULLIF(Final, 0.0), "Comparacion" = NULLIF(Comparacion, 0.0),
"InicioU" = NULLIF(InicioU, 0.0), "CargosU" = NULLIF(CargosU, 0.0), "AbonosU" = NULLIF(AbonosU, 0.0), "FinalU" = NULLIF(FinalU, 0.0),
Periodo
FROM VerRama
WHERE Estacion = @Estacion
ELSE
SELECT Cuenta, SubCuenta, Rama, Descripcion, EsAcreedora, EsAcumulativa, Tipo,
"Inicio"  = NULLIF(Inicio, 0.0),  "Cargos"  = NULLIF(Cargos, 0.0),  "Abonos"  = NULLIF(Abonos, 0.0),  "Final"  = NULLIF(Final, 0.0), "Comparacion" = NULLIF(Comparacion, 0.0),
"InicioU" = NULLIF(InicioU, 0.0), "CargosU" = NULLIF(CargosU, 0.0), "AbonosU" = NULLIF(AbonosU, 0.0), "FinalU" = NULLIF(FinalU, 0.0),
Periodo
FROM VerRama
WHERE Estacion = @Estacion
AND (Inicio  <> 0.0 OR Cargos  <> 0.0 OR Abonos  <> 0.0 OR Final <> 0.0 OR
InicioU <> 0.0 OR CargosU <> 0.0 OR AbonosU <> 0.0 OR FinalU <> 0.0)
RETURN
END

