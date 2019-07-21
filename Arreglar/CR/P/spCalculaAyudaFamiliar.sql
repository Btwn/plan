SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spCalculaAyudaFamiliar
(
@Empresa        varchar(5),
@Personal       varchar(20),
@AyudaFamiliar  money OUTPUT
)

AS
BEGIN
DECLARE @PorcentajeCuota      float,
@DiasPeriodo          tinyint,
@SueldoDiario         money,
@AyudaFamiliarImporte money
SELECT @PorcentajeCuota = Valor / 100.00
FROM PersonalPropValor
WHERE Cuenta=@Empresa
AND Rama = 'EMP'
AND Propiedad = '% Ayuda Familiar'
SELECT @AyudaFamiliarImporte = convert(money,Valor)
FROM PersonalPropValor
WHERE Cuenta    = @Personal
AND Rama      = 'PER'
AND Propiedad = 'Ayuda Familiar'
SELECT @SueldoDiario = SueldoDiario,
@DiasPeriodo =  PeriodoTipo.DiasPeriodo
FROM Personal
JOIN PeriodoTipo ON Personal.PeriodoTipo = PeriodoTipo.PeriodoTipo
WHERE Personal.Personal = @Personal
SELECT @AyudaFamiliarImporte = (@SueldoDiario * @DiasPeriodo) * ISNULL(@PorcentajeCuota, 0) + ISNULL(@AyudaFamiliarImporte, 0)
END

