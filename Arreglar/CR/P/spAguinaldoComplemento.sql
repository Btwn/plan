SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spAguinaldoComplemento
@Empresa								Char(5),
@Personal								Char(10),
@NomTipo								Varchar(50),
@DiasNaturalesTrabajados				Float,
@DiasVacaciones							Float,
@EsAniversario							bit,
@Faltas									Int,
@Antiguedad								float,
@OtorgarPrimaVacacionalAniversario		Float,
@OtorgarDiasVacacionesAniversario		Float,
@TipoCambio								Float,
@RedondeoMonetarios						Float,
@FechaA									Datetime,
@FechaD									Datetime,
@Ok										Int    OUTPUT,
@OkRef									Varchar(255)  OUTPUT

AS BEGIN
DECLARE @AnticipoDeUtilidadesImporte float, @SueldoDiarioComplemento FLOAT, @PrimaVacacionalPct Float, @PrimaVacacional float, @FaltasImporte Float,
@Cantidad int
IF @NomTipo = 'AguinaldoComplemento'
BEGIN
IF @DiasNaturalesTrabajados > 0.0
BEGIN
DELETE #Nomina
SELECT @Personal, d.ID,         d.RID,         d.NominaConcepto, i.Referencia, d.FechaAplicacion, i.Acreedor, i.Vencimiento, d.Cantidad, ROUND(d.Saldo*(i.TipoCambio/NULLIF(@TipoCambio, 0.0)), @RedondeoMonetarios)
FROM IncidenciaD d
JOIN Incidencia i ON i.ID = d.ID AND i.Empresa = @Empresa AND i.Personal = @Personal AND i.Estatus = 'PENDIENTE'
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto
WHERE NULLIF(d.SALDO, 0.0) IS NOT NULL
AND nc.NominaConcepto in ( SELECT NominaConcepto FROM MovEspecificoNomina WHERE MovEspecificoNomina= 'Aguinaldo Complemento' )
INSERT #Nomina (
Personal,  IncidenciaID, IncidenciaRID, NominaConcepto,   Referencia,   Fecha,             Cuenta,     Vencimiento,   Cantidad,   Importe)
SELECT @Personal, d.ID,         d.RID,         d.NominaConcepto, i.Referencia, d.FechaAplicacion, i.Acreedor, i.Vencimiento, d.Cantidad, ROUND(d.Saldo*(i.TipoCambio/NULLIF(@TipoCambio, 0.0)), @RedondeoMonetarios)
FROM IncidenciaD d
JOIN Incidencia i ON i.ID = d.ID AND i.Empresa = @Empresa AND i.Personal = @Personal AND i.Estatus = 'PENDIENTE'
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto
WHERE NULLIF(d.saldo, 0.0) IS NOT NULL
AND nc.NominaConcepto in ( SELECT NominaConcepto FROM MovEspecificoNomina WHERE MovEspecificoNomina= 'Aguinaldo Complemento' )
SELECT @SueldoDiarioComplemento = ISNULL(SueldoDiarioComplemento,0.0) FROM Personal
WHERE Personal.Personal = @Personal
SELECT @Faltas = COUNT(Cantidad), @FaltasImporte = ISNULL(SUM(valor), 0)
FROM Incidencia
JOIN NominaConcepto ON Incidencia.NominaConcepto=NominaConcepto.NominaConcepto
AND Especial IN ('Faltas')
WHERE Incidencia.Estatus='CONCLUIDO'
AND Incidencia.FechaEmision BETWEEN @FechaD AND @FechaA
AND NominaConcepto.MovEspecificoNomina ='Sueldo Complemento'
AND TieneSubConceptos =1
AND Personal = @Personal
GROUP BY Personal
SELECT @PrimaVacacional = ISNULL(@PrimaVacacional,0), @FaltasImporte=ISNULL(@FaltasImporte,0)
SELECT @AnticipoDeUtilidadesImporte = (@SueldoDiarioComplemento*@DiasNaturalesTrabajados) - ISNULL(@FaltasImporte,0)
SELECT @AnticipoDeUtilidadesImporte = ISNULL(@AnticipoDeUtilidadesImporte, 0) + @PrimaVacacional
SELECT @AnticipoDeUtilidadesImporte = @AnticipoDeUtilidadesImporte * 0.90
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Personal/NomSueldoComplemento',  @Empresa, @Personal, @Importe = @AnticipoDeUtilidadesImporte, @Cantidad=@Cantidad
END
END
RETURN
END

