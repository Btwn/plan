SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpPersonalCostoEstandar
@Personal		varchar(10),
@CostoEstandar	money	OUTPUT
AS BEGIN
DECLARE @Percepciones		float,
@CargaSocial		float,
@SDI			float,
@SueldoDiario		float,
@SueldoDiarioComplemento	float,
@SueldoDiarioAsimilado	float,
@Fecha		DateTime,
@FechaAlta		DateTime,
@FechaBaja		DateTime,
@MesActual		int,
@AnioActual		int,
@MesAnterior		int,
@AnioAnterior		int,
@DiasMes		int,
@DiasLibres		int,
@FechaD		DateTime,
@FechaA		DateTime,
@FechaMenor		DateTime,
@FechaMayor		DateTime,
@Jornada		varchar(20),
@HorasPromedio	float,
@Empresa		varchar(5),
@FactorEmpresa	float
SELECT @Fecha  = GETDATE ()
SELECT @MesActual = MONTH(@Fecha),
@AnioActual = YEAR(@Fecha)
SELECT @MesAnterior = CASE WHEN @MesActual = 1 THEN 12
ELSE @MesActual -1
END,
@AnioAnterior = CASE WHEN @MesActual = 1 THEN @AnioActual -1
ELSE @AnioActual
END
EXEC spDiasMes @MesAnterior, @AnioAnterior, @DiasMes OUTPUT
EXEC spIntToDateTime 1, @MesAnterior, @AnioAnterior, @FechaD OUTPUT
EXEC spIntToDateTime @DiasMes, @MesAnterior, @AnioAnterior, @FechaA OUTPUT
SELECT @Empresa = p.Empresa,
@Jornada = p.Jornada,
@FechaAlta = p.FechaAlta,
@FechaBaja = p.FechaBaja,
@SDI = ISNULL(p.SDI, p.SueldoDiario),
@SueldoDiario = (ISNULL(p.SueldoDiario,0)),
@SueldoDiarioComplemento = (ISNULL(p.SueldoDiarioComplemento,0)),
@SueldoDiarioAsimilado = (ISNULL(p.SueldoDiarioAsimilable,0))
FROM Personal p
WHERE p.Personal = @Personal
SELECT @HorasPromedio = j.HorasPromedio
FROM Jornada j
WHERE j.Jornada = @Jornada
SELECT @FactorEmpresa = ec.PersonalCostoHoraFactor
FROM EmpresaCfg ec
WHERE ec.Empresa = @Empresa
SELECT @Percepciones = SUM(nd.Importe),
@FechaMenor = MIN(n.FechaD),
@FechaMayor = MAX(n.FechaA)
FROM Nomina n
INNER JOIN NominaD nd ON n.ID = nd.ID
AND n.Estatus = 'CONCLUIDO'
AND nd.Movimiento = 'Percepcion'
AND nd.Personal = @Personal
AND n.FechaA BETWEEN @FechaD AND @FechaA
SELECT @CargaSocial = SUM(nd.Importe)
FROM Nomina n
INNER JOIN NominaD nd ON n.ID = nd.ID
AND n.Estatus = 'CONCLUIDO'
AND nd.Movimiento = 'Estadistica'
AND nd.Concepto IN ('Impuesto Estatal',
'IMSS Patron',
'Infonavit',
'Retiro y Cesantia')
AND nd.Personal = @Personal
AND n.FechaA BETWEEN @FechaD AND @FechaA
IF @FechaAlta > @FechaMenor
SELECT @FechaMenor = @FechaAlta
IF @FechaBaja < @FechaMayor AND @FechaBaja > @FechaMenor
SELECT @FechaMayor = @FechaBaja
EXEC spJornadaDiasLibres @Jornada, @FechaMenor, @FechaMayor, @DiasLibres OUTPUT
SELECT @CostoEstandar = (((ISNULL(@Percepciones,0) + ISNULL(@CargaSocial,0)) / (DATEDIFF(dd, @FechaMenor, @FechaMayor + 1) - ISNULL(@DiasLibres, 0))) / @HorasPromedio) * ISNULL(@FactorEmpresa, 1)
IF @CostoEstandar IS NULL
SELECT @CostoEstandar = ((@SueldoDiario + @SueldoDiarioComplemento + @SueldoDiarioAsimilado) / @HorasPromedio) * ISNULL(@FactorEmpresa, 1)
END

