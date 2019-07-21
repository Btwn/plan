SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNominaSueldoComplemento
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
@SueldoDiarioComplemento FLOAT,
@Mov                    varchar(20),
@Ok										Int    OUTPUT,
@OkRef									Varchar(255)  OUTPUT

AS BEGIN
DECLARE @AnticipoDeUtilidadesImporte float,  @PrimaVacacionalPct Float, @PrimaVacacional float, @FaltasImporte Float,
@Cantidad int,
@Plaza varchar(10)
IF @NomTipo = 'Sueldo Complemento'
BEGIN
IF @Mov = 'Presupuesto'
SELECT @DiasNaturalesTrabajados = 30
IF @DiasNaturalesTrabajados > 0.0
BEGIN
IF ((@DiasNaturalesTrabajados = 14)  AND MONTH(@FechaA) = 2) or (@DiasNaturalesTrabajados = 16)
SELECT @DiasNaturalesTrabajados=15
INSERT #Nomina (
Personal,  IncidenciaID, IncidenciaRID, NominaConcepto,   Referencia,   Fecha,             Cuenta,     Vencimiento,   Cantidad,   Importe)
SELECT @Personal, d.ID,         d.RID,         d.NominaConcepto, i.Referencia, d.FechaAplicacion, i.Acreedor, i.Vencimiento, d.Cantidad, ROUND(d.Saldo*(i.TipoCambio/NULLIF(@TipoCambio, 0.0)), @RedondeoMonetarios)
FROM IncidenciaD d
JOIN Incidencia i ON i.ID = d.ID AND i.Empresa = @Empresa AND i.Personal = @Personal AND i.Estatus = 'PENDIENTE'
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto 
WHERE NULLIF(d.SALDO, 0.0) IS NOT NULL
AND nc.NominaConcepto in ( SELECT NominaConcepto FROM MovEspecificoNomina WHERE MovEspecificoNomina= 'Sueldo Complemento')
AND d.FechaAplicacion between @FechaD AND @FechaA
SELECT @Faltas = SUM(d.Cantidad), @FaltasImporte = SUM(d.Saldo)
FROM IncidenciaD d
JOIN Incidencia i ON i.ID = d.ID AND i.Empresa = @Empresa AND i.Personal = @Personal AND i.Estatus = 'PENDIENTE'
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto 
WHERE NULLIF(d.SALDO, 0.0) IS NOT NULL
AND nc.NominaConcepto in ( SELECT NominaConcepto FROM MovEspecificoNomina WHERE MovEspecificoNomina= 'Sueldo Complemento' AND NominaConcepto IN ('254 A'))
GROUP BY Personal
IF (@OtorgarDiasVacacionesAniversario = 1 OR @OtorgarPrimaVacacionalAniversario = 1) AND @EsAniversario=1
BEGIN
IF @DiasVacaciones > 0
BEGIN
SELECT @PrimaVacacionalPct = CASE WHEN dbo.fnEsNumerico(Valor)=1 THEN  CONVERT(tinyint,Valor)  ELSE NULL END FROM PersonalPropValor
WHERE Cuenta = @Empresa  AND Rama = 'EMP' AND Propiedad = '% Prima Vacacional'
IF @PrimaVacacionalPct IS NULL
EXEC spTablaNum 'Prima Vacacional', @Antiguedad, @PrimaVacacionalPct OUTPUT
END
SELECT @PrimaVacacional = @SueldoDiarioComplemento * @DiasVacaciones * (ISNULL(@PrimaVacacionalPct,0)/100.0)
END
SELECT @PrimaVacacional = ISNULL(@PrimaVacacional,0), @FaltasImporte=ISNULL(@FaltasImporte,0)
SET @AnticipoDeUtilidadesImporte=0
SELECT @AnticipoDeUtilidadesImporte = (@SueldoDiarioComplemento*@DiasNaturalesTrabajados) - ISNULL(@FaltasImporte,0)
SELECT @AnticipoDeUtilidadesImporte = ISNULL(@AnticipoDeUtilidadesImporte, 0) + ISNULL(@PrimaVacacional,0)
SELECT @AnticipoDeUtilidadesImporte = @AnticipoDeUtilidadesImporte * 0.90
SELECT @Cantidad = @DiasNaturalesTrabajados - @Faltas
SELECT @Plaza = Plaza FROM Personal WHERE Personal = @Personal
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Personal/NomSueldoComplemento',  @Empresa, @Personal, @Importe = @AnticipoDeUtilidadesImporte, @Cantidad=@Cantidad,  @Referencia = @Plaza
END
END
RETURN
END

