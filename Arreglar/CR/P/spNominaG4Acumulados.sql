SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNominaG4Acumulados
@Estacion      INT,
@Empresa       VARCHAR(5),
@Sucursal      INT,
@ID            INT,
@PeriodoTipo   VARCHAR(50),
@FechaD        DATETIME,
@FechaA        DATETIME,
@TipoNominaG4  VARCHAR(50)

AS
BEGIN
DECLARE
@Ultima           VARCHAR(2),
@FinBimestre      VARCHAR(2),
@FinAno           VARCHAR(2),
@Periodo          INT,
@Ejercicio        INT,
@Bimestre         INT,
@FechaInicioP     DATETIME,
@FechaInicioB     DATETIME,
@FechaInicioA     DATETIME,
@FechaFin         DATETIME,
@AcumuladoClave   VARCHAR(100),
@AcumuladoObjeto  VARCHAR(100),
@Concepto         VARCHAR(100),
@TipoDato         VARCHAR(20),
@Clave            VARCHAR(100),
@Mov              VARCHAR(20),
@IDNomX           INT,
@Primera          VARCHAR(2)
SELECT @Mov = Mov FROM Nomina WHERE ID = @ID
SELECT @IDNomX = ID FROM NomX WHERE NomMov = @Mov
DELETE NominaAcumuladoInicial WHERE Estacion = @Estacion
CREATE TABLE #Acumulados (Clave VARCHAR(100), AcumuladoClave VARCHAR(100), AcumuladoObjeto VARCHAR(100), AplicaCalendario VARCHAR(50), Concepto VARCHAR(100) NULL, TipoDato VARCHAR(20) NULL, FechaInicio DATETIME NULL, FechaFin DATETIME NULL, Aplica BIT DEFAULT 0)
INSERT INTO #Acumulados (Clave, AcumuladoClave, AcumuladoObjeto, AplicaCalendario)
SELECT Clave, AcumuladoClave, AcumuladoObjeto, AplicaCalendario
FROM NominaConceptoEx WHERE Tipo = 'Acumulado' AND ISNULL(LTRIM(AcumuladoClave), '') <> '' AND IDNomX = @IDNomX
UPDATE a SET a.Concepto = n.Concepto, a.TipoDato = n.TipoDato
FROM #Acumulados a join NominaConceptoEx n on a.AcumuladoClave = n.Clave AND a.AcumuladoObjeto = n.Objeto
SELECT @FechaFin = @FechaA
SELECT @Periodo = Periodo, @Ejercicio = Ejercicio, @Bimestre = Bimestre, @Ultima = Ultima, @FinBimestre = FinBimestre, @FinAno = FinAno, @Primera = Primera FROM NominaG4Calendario WHERE TipoPeriodo = @PeriodoTipo AND Tiempo = @FechaA
IF @TipoNominaG4 = 'Nomina Normal'
BEGIN
IF @Ultima = 'Si'
BEGIN
SELECT @FechaInicioP = MIN(Fin) FROM NominaG4Calendario WHERE TipoPeriodo = @PeriodoTipo AND Periodo = @Periodo AND Ejercicio = @Ejercicio
UPDATE #Acumulados SET FechaInicio = @FechaInicioP, FechaFin = @FechaFin, Aplica = 1 WHERE AplicaCalendario = 'Ultima'
END
IF @FinBimestre = 'Si'
BEGIN
SELECT @FechaInicioB = MIN(Fin) FROM NominaG4Calendario WHERE TipoPeriodo = @PeriodoTipo AND Bimestre = @Bimestre AND Ejercicio = @Ejercicio
UPDATE #Acumulados SET FechaInicio = @FechaInicioB, FechaFin = @FechaFin, Aplica = 1 WHERE AplicaCalendario = 'FinBimestre'
END
IF @FinAno = 'Si'
BEGIN
SELECT @FechaInicioA = MIN(Fin) FROM NominaG4Calendario WHERE TipoPeriodo = @PeriodoTipo AND Ejercicio = @Ejercicio
UPDATE #Acumulados SET FechaInicio = @FechaInicioA, FechaFin = @FechaFin, Aplica = 1 WHERE AplicaCalendario = 'FinAno'
END
IF @Primera = 'No'
BEGIN
SELECT @FechaInicioP = MIN(Fin) FROM NominaG4Calendario WHERE TipoPeriodo = @PeriodoTipo AND Periodo = @Periodo AND Ejercicio = @Ejercicio
UPDATE #Acumulados SET FechaInicio = @FechaInicioP, FechaFin = @FechaFin, Aplica = 1 WHERE AplicaCalendario = 'PrimeraNo'
END
END
ELSE
IF @TipoNominaG4 IN('Nomina Finiquito', 'Nomina Liquidacion')
BEGIN
IF @Ultima = 'Si'
BEGIN
SELECT @FechaInicioP = MIN(Fin) FROM NominaG4Calendario WHERE TipoPeriodo = @PeriodoTipo AND Periodo = @Periodo AND Ejercicio = @Ejercicio
UPDATE #Acumulados SET FechaInicio = @FechaInicioP, FechaFin = @FechaFin, Aplica = 1 WHERE AplicaCalendario = 'Ultima'
END
IF @FinBimestre = 'Si'
BEGIN
SELECT @FechaInicioB = MIN(Fin) FROM NominaG4Calendario WHERE TipoPeriodo = @PeriodoTipo AND Bimestre = @Bimestre AND Ejercicio = @Ejercicio
UPDATE #Acumulados SET FechaInicio = @FechaInicioB, FechaFin = @FechaFin, Aplica = 1 WHERE AplicaCalendario = 'FinBimestre'
END
IF @FinAno = 'Si'
BEGIN
SELECT @FechaInicioA = MIN(Fin) FROM NominaG4Calendario WHERE TipoPeriodo = @PeriodoTipo AND Ejercicio = @Ejercicio
UPDATE #Acumulados SET FechaInicio = @FechaInicioA, FechaFin = @FechaFin, Aplica = 1 WHERE AplicaCalendario = 'FinAno'
END
IF @Primera = 'No'
BEGIN
SELECT @FechaInicioP = MIN(Fin) FROM NominaG4Calendario WHERE TipoPeriodo = @PeriodoTipo AND Periodo = @Periodo AND Ejercicio = @Ejercicio
UPDATE #Acumulados SET FechaInicio = @FechaInicioP, FechaFin = @FechaFin, Aplica = 1 WHERE AplicaCalendario = 'PrimeraNo'
END
END
DECLARE crDatos CURSOR LOCAL FOR
SELECT Clave, AcumuladoClave, AcumuladoObjeto, Concepto, FechaInicio, FechaFin, TipoDato
FROM #Acumulados
WHERE ISNULL(LTRIM(Concepto), '') <> '' AND Aplica = 1
OPEN crDatos
FETCH NEXT FROM crDatos INTO @Clave, @AcumuladoClave, @AcumuladoObjeto, @Concepto, @FechaInicioA, @FechaFin, @TipoDato
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
INSERT INTO NominaAcumuladoInicial (Estacion, _id, Acumulado, Importe)
SELECT @Estacion, nd.Personal, @Clave, CASE WHEN @TipoDato = 'Importe' THEN SUM(nd.Importe) ELSE SUM(nd.Cantidad) END AS Importe
FROM Nomina n
JOIN MovTipo mt ON mt.Mov = n.Mov AND mt.Modulo = 'NOM'
JOIN NominaD nd ON nd.ID = n.ID
JOIN ListaSt l ON l.Clave = nd.Personal
WHERE Estatus = 'CONCLUIDO' AND Empresa = @Empresa AND mt.Clave = 'NOM.N' AND n.FechaA BETWEEN @FechaInicioA AND @FechaFin AND nd.Concepto = @Concepto AND l.Estacion = @Estacion
GROUP BY nd.Personal
FETCH NEXT FROM crDatos INTO @Clave, @AcumuladoClave, @AcumuladoObjeto, @Concepto, @FechaInicioA, @FechaFin, @TipoDato
END
END
CLOSE crDatos
DEALLOCATE crDatos
RETURN
END

