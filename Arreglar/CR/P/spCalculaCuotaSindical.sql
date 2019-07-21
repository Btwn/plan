SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spCalculaCuotaSindical
(
@Empresa        varchar(5),
@Personal       varchar(20),
@FechaD         datetime,
@FechaA         datetime,
@Mov            varchar(20),
@CuotaSindical  money OUTPUT
)

AS
BEGIN
DECLARE @PorcentajeCuota  float,
@DiasPeriodo      tinyint,
@Faltas           float,
@SueldoDiario     money
SELECT @PorcentajeCuota = Valor / 100.00
FROM PersonalPropValor
WHERE Cuenta=@Empresa
AND Rama = 'EMP'
AND Propiedad = '% Cuota sindical'
IF @FechaA IS NULL
SELECT @FechaD = IncidenciaD,
@FechaA = IncidenciaA
FROM MovTipoNomAutoCalendarioEsp
WHERE FechaNomina = @FechaD
AND Mov = @Mov
SELECT @Faltas = SUM(Cantidad) FROM Incidencia
JOIN NominaConcepto ON Incidencia.NominaConcepto=NominaConcepto.NominaConcepto
AND Especial IN ('Faltas','Incapacidades')
WHERE Incidencia.Estatus='PENDIENTE'
AND Incidencia.FechaEmision BETWEEN @FechaD AND @FechaA
AND Personal = @Personal
GROUP BY Personal
SELECT @SueldoDiario = SueldoDiario,
@DiasPeriodo =  PeriodoTipo.DiasPeriodo
FROM Personal
JOIN PeriodoTipo ON Personal.PeriodoTipo = PeriodoTipo.PeriodoTipo
WHERE sindicato='SI'
AND Personal.Personal = @Personal
SELECT @CuotaSindical = (@SueldoDiario * (@DiasPeriodo - COALESCE(@Faltas,0))) * @PorcentajeCuota
END

