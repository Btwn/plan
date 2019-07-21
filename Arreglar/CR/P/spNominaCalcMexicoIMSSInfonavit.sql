SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER   PROCEDURE dbo.spNominaCalcMexicoIMSSInfonavit
@Empresa                        char(5) OUTPUT,
@Personal                       char(10) OUTPUT,
@FechaD                         datetime OUTPUT,
@FechaA                         datetime OUTPUT,
@PeriodoTipo                    varchar(20) OUTPUT,
@CfgFactorIntegracionAntiguedad varchar(20) OUTPUT,
@CfgFactorIntegracionTabla      varchar(50) OUTPUT,
@NomTipo                        varchar(50) OUTPUT,
@NomCalcSDI                     bit OUTPUT,
@CalcImporte                    money OUTPUT,
@EsBimestre                     bit OUTPUT,
@PrimerDiaBimestre              datetime OUTPUT,
@PrimerDiaBimestreAnterior      datetime OUTPUT,
@UltimoDiaBimestreAnterior      datetime OUTPUT,
@SucursalTrabajo                int OUTPUT,
@Categoria                      varchar(50) OUTPUT,
@Puesto                         varchar(50) OUTPUT,
@SMZ                            money OUTPUT,
@SMZPrimaAntiguedad             float OUTPUT,
@SMDF                           money OUTPUT,
@PrimerDiaAnoAnterior           datetime OUTPUT,
@EsSocio                        bit OUTPUT,
@SDI                            money OUTPUT,
@SDINuevo                       money OUTPUT,
@SueldoDiario                   money OUTPUT,
@DiasBimestre                   float OUTPUT,
@DiasBimestreTrabajados         float OUTPUT,
@DiasAno                        float OUTPUT,
@DiasAguinaldo                  float OUTPUT,
@DiasAguinaldoSiguiente         float OUTPUT,
@DiasPeriodo                    float OUTPUT,
@DiasTrabajados                 float OUTPUT,
@DiasNaturales                  float OUTPUT,
@DiasNaturalesTrabajados        float OUTPUT,
@DiasPrimaAntiguedad            float OUTPUT,
@Faltas                         float OUTPUT,
@FaltasAcumulado                float OUTPUT,
@Incapacidades                  float OUTPUT,
@IncapacidadesAcumulado         float OUTPUT,
@IMSSBase                       money OUTPUT,
@IMSSBaseAcumulado              money OUTPUT,
@IMSSBaseMes                    money OUTPUT,
@AcreedorIMSS                   varchar(10) OUTPUT,
@AcreedorRetiro                 varchar(10) OUTPUT,
@AcreedorInfonavit              varchar(10) OUTPUT,
@IMSSVencimiento                datetime OUTPUT,
@IMSSVencimientoBimestre        datetime OUTPUT,
@IMSSObrero                     money OUTPUT,
@IMSSObreroCV                   money OUTPUT,
@IMSSObreroSinCV                money OUTPUT,
@IMSSPatron                     money OUTPUT,
@IMSSPatronMensual              money OUTPUT,
@IMSSPatronCV                   money OUTPUT,
@IMSSPatronRetiro               money OUTPUT,
@IMSSPatronInfonavit            money OUTPUT,
@Antiguedad                     float OUTPUT,
@PrimaVacacionalPct             float OUTPUT,
@PrimaVacacional                money OUTPUT,
@DiasVacaciones                 float OUTPUT,
@DiasVacacionesSiguiente        float OUTPUT,
@FactorIntegracion              float OUTPUT,
@InfonavitObrero                money OUTPUT,
@AcumuladoInfonavitObrero       money OUTPUT,
@InfonavitSDI                   float OUTPUT,
@InfonavitSMGDF                 float OUTPUT,
@InfonavitImporte               float OUTPUT,
@SeguroRiesgoInfonavit          money OUTPUT,
@PersonalPercepciones           money OUTPUT,
@Mov                            varchar(20) OUTPUT,
@DiasMesInfonavit               int OUTPUT,
@MesI                           int OUTPUT,
@YearI                          int OUTPUT,
@InfonavitDias                  int OUTPUT,
@DiasBimestreInfonavit          int OUTPUT,
@FechaInicioDescuentoInfonavit  datetime OUTPUT,
@DiasNaturalesInfonavit         float OUTPUT,
@Ok                             int  OUTPUT,
@OkRef                          varchar(255) OUTPUT

AS BEGIN
IF @NomTipo IN ('NORMAL', 'AJUSTE', 'FINIQUITO', 'LIQUIDACION')
BEGIN
IF @EsSocio = 0
BEGIN
EXEC spNominaIMSS @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, @SDI, @DiasNaturales, @Incapacidades, @Faltas, @SMDF, 1,
@IMSSObrero OUTPUT, @IMSSObreroCV OUTPUT,
@IMSSPatron OUTPUT, @IMSSPatronMensual OUTPUT, @IMSSPatronCV OUTPUT, @IMSSPatronRetiro OUTPUT, @IMSSPatronInfonavit OUTPUT
SELECT @IMSSObreroSinCV = @IMSSObrero-@IMSSObreroCV
IF @EsBimestre = 1 AND @NomCalcSDI = 1
BEGIN
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'IMSS/Base',      @PrimerDiaBimestre, @FechaA, NULL, @IMSSBaseAcumulado OUTPUT, NULL
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'Faltas',         @PrimerDiaBimestre, @FechaA, NULL, NULL, @FaltasAcumulado OUTPUT
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'Incapacidades',  @PrimerDiaBimestre, @FechaA, NULL, NULL, @IncapacidadesAcumulado OUTPUT
SELECT @IMSSBaseMes = @IMSSBaseAcumulado + @IMSSBase
SELECT @FactorIntegracion = NULL
IF @CfgFactorIntegracionAntiguedad = 'SIGUIENTE'
SELECT @FactorIntegracion = 1+((@DiasAguinaldoSiguiente+((@PrimaVacacionalPct/100.0)*@DiasVacacionesSiguiente))/@DiasAno)
ELSE
IF @CfgFactorIntegracionAntiguedad = 'ACTUAL'
SELECT @FactorIntegracion = 1+((@DiasAguinaldo+((@PrimaVacacionalPct/100.0)*@DiasVacaciones))/@DiasAno)
ELSE
IF @CfgFactorIntegracionAntiguedad = 'TABLA'
EXEC spTablaNum @CfgFactorIntegracionTabla, @Antiguedad, @FactorIntegracion OUTPUT
SELECT @DiasBimestre = DATEDIFF(day, @PrimerDiaBimestre, @FechaA) + 1
SELECT @DiasBimestreTrabajados = dbo.fnmenor(@DiasBimestre, @DiasBimestre - ISNULL(@FaltasAcumulado, 0.0) - ISNULL(@IncapacidadesAcumulado, 0.0) - @Faltas - @Incapacidades)
SELECT @SDINuevo = dbo.fnMayor(dbo.fnMenor(@SueldoDiario * @FactorIntegracion + (@IMSSBaseMes / @DiasBimestreTrabajados), 25*@SMDF),@SMDF*1.0452)
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'SDI', @Empresa, @Personal, @DiasBimestreTrabajados, @SDINuevo
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'SDI/Factor', @Empresa, @Personal, @FactorIntegracion
END
IF @NomTipo <> 'H.ASIMILABLE'
BEGIN
IF ISNULL(@DiasTrabajados,0) <> 0  or @Mov='Presupuesto'
BEGIN
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'IMSS/Obrero', @Empresa, @Personal, @DiasTrabajados, @IMSSObrero, @Vencimiento = @IMSSVencimiento, @Cuenta = @AcreedorIMSS
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'IMSS/ObreroCV', @Empresa, @Personal, @Importe = @IMSSObreroCV, @Cuenta = @AcreedorIMSS, @Vencimiento = @IMSSVencimientoBimestre
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'IMSS/ObreroSinCV', @Empresa, @Personal, @Importe = @IMSSObreroSinCV, @Cuenta = @AcreedorIMSS, @Vencimiento = @IMSSVencimiento
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'IMSS/Patron', @Empresa, @Personal, @Importe = @IMSSPatron,   @Cuenta = @AcreedorIMSS, @Vencimiento = @IMSSVencimiento
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'IMSS/PatronCV', @Empresa, @Personal, @Importe = @IMSSPatronCV, @Cuenta = @AcreedorIMSS, @Vencimiento = @IMSSVencimientoBimestre
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Retiro/Patron', @Empresa, @Personal, @Importe = @IMSSPatronRetiro,  @Cuenta = @AcreedorRetiro, @Vencimiento = @IMSSVencimientoBimestre
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Infonavit/Patron', @Empresa, @Personal, @Importe = @IMSSPatronInfonavit, @Cuenta = @AcreedorInfonavit, @Vencimiento = @IMSSVencimientoBimestre
END
END
END
SELECT @MesI  = DATEPART(MONTH, @FechaD)
SELECT @YearI = DATEPART(YEAR, @FechaD)
EXEC  spDiasMes @MesI, @YearI,@DiasMesInfonavit output
SELECT @InfonavitObrero = NULL
SELECT @InfonavitDias = ISNULL(@DiasPeriodo,0)- isnull(@Incapacidades,0)- isnull(@Faltas,0)
IF @NomTipo = 'Ajuste'
BEGIN
SELECT @PersonalPercepciones = ISNULL(SUM(d.Importe), 0.0)
FROM #Nomina d
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto AND nc.Movimiento = 'Percepcion'
WHERE d.Personal = @Personal
SELECT @InfonavitObrero = (@InfonavitSDI/100.0) * @PersonalPercepciones
END ELSE
BEGIN
SELECT @DiasNaturalesInfonavit =  dbo.FnMenor(ABS(datediff (day, @FechaInicioDescuentoInfonavit,@FechaA))+1, @DiasNaturalesTrabajados)
SELECT  @AcumuladoInfonavitObrero =NULL
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'Infonavit/Obrero',  @PrimerDiaAnoAnterior, @Fechaa, NULL,  @AcumuladoInfonavitObrero OUTPUT, NULL
/*select @PrimerDiaAnoAnterior
select * from nominad where nominaconcepto='208' and personal ='0730'
select * from cfgnominaconcepto where claveinterna='Infonavit/Obrero'
select * from nominaconcepto where nominaconcepto='208'*/
IF NULLIF(@AcumuladoInfonavitObrero,0) = NULL
SELECT @DiasNaturalesInfonavit = datediff (day,  @FechaInicioDescuentoInfonavit,@FechaA)+1
SELECT @AcumuladoInfonavitObrero = 0
IF NULLIF(@InfonavitSDI, 0.0) IS NOT NULL
BEGIN
IF @PeriodoTipo = 'Catorcenal'
BEGIN
EXEC spNominaBuscarDiasBimestre  @FechaA ,'Catorcenal', 4, @FechaD    ,  @FechaA    ,  @DiasBimestreInfonavit  output
select @DiasBimestreInfonavit=70.0 
SELECT @UltimoDiaBimestreAnterior = DATEADD(day, -1, @PrimerDiaBimestre)
SELECT @PrimerDiaBimestreAnterior = DATEADD(month, -2, @UltimoDiaBimestreAnterior)
WHILE isnull(day(@PrimerDiaBimestreAnterior),1) <> 1
SELECT @PrimerDiaBimestreAnterior =DATEADD(day,1,@PrimerDiaBimestreAnterior)
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'Infonavit/Obrero',  @PrimerDiaBimestreAnterior, @UltimoDiaBimestreAnterior, NULL,  @AcumuladoInfonavitObrero OUTPUT, NULL, 'NOMINA'
SELECT @InfonavitObrero =  ((((@InfonavitSDI/100.0) * @SDI * @DiasBimestreInfonavit) - @AcumuladoInfonavitObrero) / @DiasBimestreInfonavit) * @DiasNaturalesInfonavit 
END ELSE
BEGIN
SELECT @InfonavitObrero = (@InfonavitSDI/100.0) * @SDI * @DiasNaturalesInfonavit 
END
END
ELSE BEGIN
IF @InfonavitDias > 0
BEGIN
IF @PeriodoTipo = 'Catorcenal'
BEGIN
EXEC spNominaBuscarDiasBimestre  @FechaA ,'Catorcenal', 4, @FechaD    ,  @FechaA    ,  @DiasBimestreInfonavit  output
SELECT @DiasBimestreInfonavit = 70.0
SELECT @InfonavitObrero = ISNULL(@InfonavitObrero,0.0) + (((@InfonavitSMGDF*@SMDF)*2)/ISNULL(@DiasBimestreInfonavit, 1)) * @DiasNaturalesInfonavit
END
ELSE
IF NULLIF(@InfonavitSMGDF, 0.0) IS NOT NULL
SELECT @InfonavitObrero = ISNULL(@InfonavitObrero,0.0) + (((@InfonavitSMGDF*@SMDF)*2)/ISNULL(dbo.fnDiasBimestre(@FechaA),1)) * @DiasNaturalesInfonavit
SELECT @InfonavitObrero = ISNULL(@InfonavitObrero,0.0)
END ELSE
IF NULLIF(@InfonavitSMGDF, 0.0) IS NOT NULL
SELECT @InfonavitObrero = 0
END
IF NULLIF(@InfonavitImporte, 0.0) IS NOT NULL
SELECT @InfonavitObrero = ISNULL(@InfonavitObrero,0) + @InfonavitImporte
IF @PeriodoTipo = 'QUINCENAL'
SELECT @SeguroRiesgoInfonavit = ISNULL(@SeguroRiesgoInfonavit,0)/4
ELSE IF @PeriodoTipo = 'MENSUAL'
SELECT @SeguroRiesgoInfonavit = ISNULL(@SeguroRiesgoInfonavit,0)/2
ELSE IF @PeriodoTipo = 'SEMANAL'
SELECT @SeguroRiesgoInfonavit = ISNULL(@SeguroRiesgoInfonavit,0)/16
ELSE IF @PeriodoTipo = 'Catorcenal'
SELECT @SeguroRiesgoInfonavit = (ISNULL(@SeguroRiesgoInfonavit,0)/ @DiasBimestreInfonavit) *  @DiasNaturalesInfonavit 
IF ISNULL(@InfonavitObrero,0) <> 0
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'SeguroRiesgoInfonavit', @Empresa, @Personal, @Importe = @SeguroRiesgoInfonavit
END
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Infonavit/Obrero', @Empresa, @Personal, @Importe = @InfonavitObrero
IF @NomTipo IN ('NORMAL', 'AJUSTE')
BEGIN
SELECT @CalcImporte = @PrimaVacacional/@DiasAno*@DiasNaturales
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Provision/Vacaciones', @Empresa, @Personal, @Importe = @CalcImporte,@cantidad=@diasvacaciones
SELECT @CalcImporte = (@DiasAguinaldo*@SueldoDiario/@DiasAno)*@DiasNaturales
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Provision/Aguinaldo', @Empresa, @Personal, @Importe = @CalcImporte
IF (@SMZ*@SMZPrimaAntiguedad) < @SueldoDiario
SELECT @CalcImporte = (@DiasPrimaAntiguedad*@SMZ*@SMZPrimaAntiguedad*@Antiguedad)/@DiasAno*@DiasNaturales
ELSE
SELECT @CalcImporte =(@DiasPrimaAntiguedad*@SueldoDiario*@Antiguedad)/@DiasAno*@DiasNaturales
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Provision/Antiguedad', @Empresa, @Personal, @Importe = @CalcImporte
END
END
END

