SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spCalculaAnticipoFondoAhorro
(
@Empresa        varchar(5),
@Personal       varchar(20),
@FondoAhorro  money OUTPUT
)

AS
BEGIN
DECLARE @PorcentajeAntic  float,
@ImporteEmp       money,
@ImportePer       money,
@FondoEmp         varchar(10),
@FondoPer         varchar(10),
@FechaD           datetime,
@FechaA           datetime
SELECT @FondoEmp = '252'
SELECT @FondoPer = '253'
SELECT @PorcentajeAntic = convert(float, isnull(Valor,0)) / 100.00
FROM PersonalPropValor WITH (NOLOCK)
WHERE Cuenta=@Empresa
AND Rama = 'EMP'
AND Propiedad = '% Anticipo Fondo de Ahorro'
SELECT @FechaD = CONVERT(DATETIME,Valor,103)
FROM PersonalPropValor WITH (NOLOCK)
WHERE Cuenta=@Empresa
AND Rama = 'EMP'
AND Propiedad = 'ANTICIPO FONDO DE AHORRO FECHAD'
SELECT @FechaA = CONVERT(DATETIME,Valor,103)
FROM PersonalPropValor WITH (NOLOCK)
WHERE Cuenta=@Empresa
AND Rama = 'EMP'
AND Propiedad = 'ANTICIPO FONDO DE AHORRO FECHAA'
SELECT @ImporteEmp = SUM(isnull(importe,0))
FROM NominaD WITH (NOLOCK)
JOIN Nomina WITH (NOLOCK) ON NominaD.ID = Nomina.ID
WHERE NominaD.NominaConcepto = @FondoEmp
AND NominaD.Personal = @Personal
AND Nomina.FechaEmision BETWEEN @FechaD AND @FechaA
SELECT @ImportePer = SUM(isnull(importe,0))
FROM NominaD WITH (NOLOCK)
JOIN Nomina WITH (NOLOCK) ON NominaD.ID = Nomina.ID
WHERE NominaD.NominaConcepto = @FondoPer
AND NominaD.Personal = @Personal
AND Nomina.FechaEmision BETWEEN @FechaD AND @FechaA
SELECT @FondoAhorro = (@ImportePer + @ImporteEmp) * @PorcentajeAntic
END

