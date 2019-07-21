SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNominaCalcMexicoFinal
@Empresa                        char(5) OUTPUT,
@Personal                       char(10) OUTPUT,
@CalcImporte                    money OUTPUT,
@PensionAAcreedor               varchar(10) OUTPUT,
@PersonalNeto                   money OUTPUT,
@PersonalPercepciones           money OUTPUT,
@PersonalDeducciones            money OUTPUT,
@BeneficiarioSueldoNeto         varchar(100) OUTPUT,
@Mov                            varchar(20) OUTPUT,
@Plaza                          varchar(10) OUTPUT,
@SeguroAuto                     money OUTPUT,
@SeguroMedico                   money OUTPUT,
@PensionSueldoNeto              money OUTPUT,
@Ok                             int OUTPUT,
@OkRef                          varchar(255) OUTPUT

AS BEGIN
DELETE #Nomina
FROM #Nomina n
JOIN NominaConcepto nc ON nc.NominaConcepto = n.NominaConcepto
WHERE nc.NominaConcepto NOT IN(SELECT MovEspecificoNomina.NominaConcepto FROM MovEspecificoNomina WHERE MovEspecificoNomina.MovEspecificoNomina = @Mov)
AND n.Personal = @Personal   and exists(select * from MovEspecificoNomina where MovEspecificoNomina.nominaconcepto= n.NominaConcepto)
SELECT @PersonalPercepciones = 0.0, @PersonalDeducciones = 0.0
IF @MOV  = 'PRESUPUESTO'
UPDATE #NOMINA SET REFERENCIA =@PLAZA WHERE NULLIF(referencia,'') IS NULL and personal=@Personal
IF @MOV  = 'PRESUPUESTO'
BEGIN
SELECT @PersonalPercepciones = ISNULL(SUM(d.Importe), 0.0)
FROM #Nomina d
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto AND nc.Movimiento = 'Percepcion'
WHERE d.Personal = @Personal And isnull(Referencia,'')=isnull(@Plaza,'')
SELECT @PersonalDeducciones = ISNULL(SUM(d.Importe), 0.0)
FROM #Nomina d
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto AND nc.Movimiento = 'Deduccion'
WHERE d.Personal = @Personal And isnull(Referencia,'')=isnull(@Plaza,'')
END
ELSE
BEGIN
SELECT @PersonalPercepciones = ISNULL(SUM(d.Importe), 0.0)
FROM #Nomina d
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto AND nc.Movimiento = 'Percepcion'
WHERE d.Personal = @Personal
SELECT @PersonalDeducciones = ISNULL(SUM(d.Importe), 0.0)
FROM #Nomina d
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto AND nc.Movimiento = 'Deduccion'
WHERE d.Personal = @Personal
END
SELECT @PersonalNeto = @PersonalPercepciones - @PersonalDeducciones
SELECT @PersonalDeducciones = @PersonalPercepciones - @PersonalNeto
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Personal/Percepciones', @Empresa, @Personal, @Importe = @PersonalPercepciones
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Personal/Deducciones', @Empresa, @Personal, @Importe = @PersonalDeducciones
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Personal/Neto', @Empresa, @Personal, @Importe = @PersonalNeto, @Beneficiario = @BeneficiarioSueldoNeto
EXEC spNominaClaveInternaEstaNomina @Personal, 'SEGURODEAUTO',                NULL,  @SeguroAuto OUTPUT
EXEC spNominaClaveInternaEstaNomina @Personal, 'SEGURODEGASTOSMEDICOSMAYORES', NULL, @SeguroMedico OUTPUT
EXEC spNominaClaveInternaEstaNomina @Personal, 'PensionA/SueldoNeto', NULL, @PensionSueldoNeto OUTPUT
SELECT @CalcImporte = @PensionSueldoNeto + @SeguroAuto + @SeguroMedico
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'SumaSegurosyPensionesalim', @Empresa, @Personal, @Importe = @CalcImporte, @Cuenta = @PensionAAcreedor
DELETE #Nomina
FROM #Nomina n
JOIN NominaConcepto nc ON nc.NominaConcepto = n.NominaConcepto
WHERE nc.NominaConcepto NOT IN(SELECT MovEspecificoNomina.NominaConcepto FROM MovEspecificoNomina WHERE MovEspecificoNomina.MovEspecificoNomina = @Mov)
AND n.Personal = @Personal   and exists(select * from MovEspecificoNomina where MovEspecificoNomina.nominaconcepto= n.NominaConcepto)
END

