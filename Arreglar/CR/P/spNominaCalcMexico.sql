SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER   PROCEDURE dbo.spNominaCalcMexico
@Empresa                        char(5),
@FechaTrabajo                   datetime,
@Sucursal                       int,
@ID                             int,
@Moneda                         char(10),
@TipoCambio                     float,
@Personal                       char(10),
@FechaD                         datetime,
@FechaA                         datetime,
@PeriodoTipo                    varchar(20),
@CfgAjusteMensualISR            bit,
@CfgSueldoMinimo                varchar(20),
@CfgTablaVacaciones             varchar(50),
@CfgSubsidioIncapacidadEG       bit,
@CfgPrimaDominicalAuto          bit,
@CfgISRReglamentoAguinaldo      bit,
@CfgISRReglamentoPTU            bit,
@CfgISRLiquidacionSueldoMensual varchar(50),
@CfgFactorIntegracionAntiguedad varchar(20),
@CfgFactorIntegracionTabla      varchar(50),
@NomTipo                        varchar(50),
@NomCalcSDI                     bit,
@NomCxc                         varchar(20),
@RepartirDesde                  datetime,
@RepartirHasta                  datetime,
@RepartirIngresoTope            money,
@RepartirIngresoFactor          float,
@RepartirDiasFactor             float,
@CalendarioEsp                  bit,
@IncidenciaD                    datetime,
@IncidenciaA                    datetime,
@Estacion		                   int,
@Ok                             int  OUTPUT,
@OkRef                          varchar(255) OUTPUT

AS BEGIN
DECLARE
@RedondeoMonetarios    int,
@Dia                   int,
@Mes                   int,
@Ano                   int,
@Calc                  float,
@CalcImporte           money,
@FechaDAno             int,
@FechaAAno             int,
@DescansaDomingos      bit,
@LaboraDomingos        bit,
@EsInicioMes           bit,
@EsFinMes              bit,
@EsBimestre            bit,
@PrimerDiaMes          datetime,
@PrimerDiaMesAnterior  datetime,
@PrimerDiaBimestre     datetime,
@PrimerDiaBimestreAnterior     datetime,
@UltimoDiaBimestreAnterior  datetime,
@UltimoDiaMesAnterior  datetime,
@UltimoDiaMes          datetime,
@PersonalEstatus       varchar(15),
@PersonalCtaDinero     varchar(20),
@SucursalTrabajo       int,
@SucursalTrabajoEstado varchar(50),
@Categoria             varchar(50),
@Puesto                varchar(50),
@Cliente               varchar(10),
@Jornada               varchar(20),
@JornadaDiasLibres     int,
@JornadaHoras          float,
@PersonalDiasPeriodo   varchar(20),
@ZonaEconomica         varchar(30),
@SMZ                   money,
@SMZTopeHorasDobles    float,
@SMZPrimaAntiguedad    float,
@SMDF                  money,
@PrimerDiaAno          datetime,
@PrimerDiaAno1         datetime,
@PrimerDiaAnoAnterior  datetime,
@UltimoDiaAno          datetime,
@UltimoDiaAnoAnterior  datetime,
@FechaAlta             datetime,
@FechaBaja             datetime,
@FechaAntiguedad         datetime,
@FechaAniversario        datetime,
@FechaDAntiguedad        datetime,
@FechaAAntiguedad        datetime,
@UltimoPago              datetime,
@EsSocio                 bit,
@SDI                     money,
@SDINuevo                money,
@SueldoPeriodo           money,
@SueldoDiario            money,
@SueldoMensual           money,
@SueldoMensualReglamento money,
@DiasMes                 float,
@DiasMesTrabajados       float,
@DiasBimestre            float,
@DiasBimestreTrabajados  float,
@DiasAno                 float,
@Aguinaldo               money,
@AguinaldoPuntyAsis      money,
@AguinaldoAcumulado      money,
@DiasAguinaldo           float,
@DiasAguinaldoSiguiente  float,
@DiasAguinaldoProporcion  float,
@DiasAguinaldoSt       varchar(50),
@DiasPeriodo           float,
@DiasPeriodoSubsidio   float,
@DiasHabilesPeriodo    float,
@DiasPeriodoEstandar   float,
@DiasTrabajados        float,
@DiasTrabajadosImporte float,
@DiasNaturales         float,
@FactorAusentismo      float,
@DiasNaturalesTrabajados  float,
@DiasNaturalesOriginales  float,
@DiasNaturalesDiferencia  float,
@DiasPrimaAntiguedad   float,
@DomingosLaborados     float,
@Faltas                float,
@FaltasAcumulado       float,
@FaltasImporte         money,
@Incapacidades         float,
@IncapacidadesAcumulado float,
@IncapacidadesImporte  money,
@ISR                   money,
@ISRAcumulado          money,
@ISRBruto              money,
@ISRVencimiento        datetime,
@ISRSubsidio           money,
@ISRSubsidioAcumulado  money,
@ISRSubsidioPct        float,
@ISRSubsidioPctH       float,
@ISRCreditoAlSalarioTabla  money,
@ISRSubsidioAlEmpleoTabla  money,
@ISRCreditoAlSalarioAcumulado money,
@ISRSubsidioAlEmpleoAcumulado money,
@ISRBase               money,
@ISRBaseMes            money,
@ISRBaseAcumulado      money,
@ISRReglamentoBase     float,
@ISRReglamentoFactor   float,
@ISRSueldoMensual      money,
@ISRSueldoMensualReglamento  money,
@ISRLiquidacion        money,
@ISRLiquidacionExcento money,
@ISRLiquidacionGravable  money,
@ISRLiquidacionFactor  float,
@ISRLiquidacionBase    float,
@ISRAnual              money,
@ISRAjuste             money,
@ISRAjusteMax          money,
@ISRAjusteAnual        money,
@SubsidoSueldoMensual  money,
@SubsidoSueldoMensualReglamento money,
@IMSSBase              money,
@IMSSBaseAcumulado     money,
@IMSSBaseMes           money,
@ImpuestoEstatalBase   money,
@CedularBase           money,
@AcreedorIMSS          varchar(10),
@AcreedorRetiro        varchar(10),
@AcreedorISR           varchar(10),
@AcreedorInfonavit     varchar(10),
@AcreedorFonacot       varchar(10),
@AcreedorImpuestoEstatal  varchar(10),
@IMSSVencimiento       datetime,
@IMSSVencimientoBimestre  datetime,
@IMSSObrero            money,
@IMSSObreroCV          money,
@IMSSObreroSinCV       money,
@IMSSPatron            money,
@IMSSPatronMensual     money,
@IMSSPatronCV          money,
@IMSSPatronRetiro      money,
@IMSSPatronInfonavit   money,
@Antiguedad            float,
@AntiguedadFlotante    float,
@AntiguedadSiguiente   float,
@AntiguedadDia         int,
@AntiguedadMes         int,
@PrimaDominicalPct     float,
@PrimaDominical        money,
@PrimaVacacionalPct    float,
@Vacaciones            money,
@VacacionesTomadas     float,
@PrimaAntiguedad       money,
@PrimaVacacional       money,
@PrimaVacacionalProporcion  money,
@PrimaVacacionalTope   money,
@PrimaVacacionalExcenta money,
@DiasVacaciones        float,
@DiasVacacionesProporcion  float,
@DiasVacacionesSiguiente  float,
@DiasVacacionesAcumulado  float,
@FactorIntegracion     float,
@ImpuestoEstatal       money,
@ImpuestoEstatalPct    float,
@ImpuestoEstatalGastoOperacionPct float,
@ImpuestoEstatalVencimiento       datetime,
@InfonavitObrero          money,
@AcumuladoInfonavitObrero money,
@InfonavitSDI          float,
@InfonavitSMGDF        float,
@InfonavitImporte      float,
@SeguroRiesgoInfonavit money,
@PensionASueldoBruto   float,
@PensionASueldoBruto2  float,
@PensionASueldoBruto3  float,
@PensionASueldoNeto    float,
@PensionASueldoNeto2   float,
@PensionASueldoNeto3   float,
@PensionAAcreedor      varchar(10),
@PensionAAcreedor2     varchar(10),
@PensionAAcreedor3     varchar(10),
@PercepcionBruta       money,
@CajaAhorro            money,
@CajaAhorroDesde       datetime,
@CajaAhorroHasta       datetime,
@CajaAhorroLiquidacion datetime,
@CajaAhorroInteresTotalPct  float,
@CajaAhorroAcumulado   money,
@CajaAhorroAcumuladoDias float,
@CajaAhorroIngresosTopados money,
@CajaAhorroDiasTrabajados money,
@FondoAhorroFactorAusentismo varchar(10),
@ValesDespensaFactorAusentismo varchar(10),
@AyudaFamiliarFactorAusentismo varchar(10),
@FondoAhorroPct        float,
@FondoAhorro           money,
@FondoAhorro1           money,
@FondoAhorroAnticipoPct float,
@FondoAhorroDesde      datetime,
@FondoAhorroHasta      datetime,
@FondoAhorroLiquidacion datetime,
@FondoAhorroInteresTotal money,
@FondoAhorroInteresTotalPct float,
@FondoAhorroDiasAcumulado float,
@FondoAhorroAcumulado  money,
@FondoAhorroAcumuladoDias  float,
@FondoAhorroPatronAcumulado  money,
@FondoAhorroPatronAcumuladoDias float,
@FondoAhorroAnticipoAcumulado  money,
@FondoAhorroPrestamoAcumulado  money,
@FondoAhorroAnticipoAcumuladoDias float,
@FondoAhorroIngresosTopados  money,
@FondoAhorroDiasTrabajados  money,
@EsAniversario         bit,
@OtorgarDiasVacacionesAniversario bit,
@OtorgarPrimaVacacionalAniversario bit,
@OtorgarPrimaVacacionalAguinaldo   bit,
@TieneValesDespensa    bit,
@ValesDespensaPct      float,
@ValesDespensaImporte  money,
@ValesDespensaImportePension  money,
@ValesDespensa         money,
@PremioPuntualidadPct  float,
@AyudaTransportePct    float,
@PremioAsistenciaPct   float,
@PersonalNeto          money,
@PersonalPercepciones  money,
@PersonalDeducciones   money,
@SueldoMinimo          money,
@IndemnizacionPct      float,
@Indemnizacion         money,
@IndemnizacionTope     money,
@Indemnizacion3Meses   money,
@Indemnizacion20Dias   money,
@SueldoVariable        money,
@SueldoVariableAcumulado  money,
@SueldoVariableDias    float,
@SueldoVariablePromedio money,
@SueldoVariablePTUDesde datetime,
@SueldoVariablePTUHasta datetime,
@SueldoVariableAguinaldoDesde datetime,
@SueldoVariableAguinaldoHasta datetime,
@PTUIngresosTopados    money,
@PTUDiasTrabajados     money,
@DescuentoISRAjusteAnualPct float,
@FiniquitoNetoEnCeros  bit,
@ConSueldoMinimo       bit,
@SubsidioProporcionalFalta bit,
@BeneficiarioSueldoNeto  varchar(100),
@Contrato              varchar(100),
@MaxID                 int,
@MaxRID                float,
@IncapacidadesD        int,
@CuotaSindical         money,
@Mov                   varchar(20),
@ImporteISR            money,
@NuevoImporteISR       money,
@ImporteCAS            money,
@NuevoImporteCAS       money,
@DiasPeriodoMes        int,
@DiasMesInfonavit      int,
@MesI                  int,
@YearI                 int,
@SDIAnterior           money,
@SDIVariableDiario     money,
@SDIBruto              money,
@FhiAntiguedad         float,
@FhiAntiguedadSDI      datetime,
@AntiguedadSDI	   float,
@DiasAguinaldoSDI			 float,
@DiasAguinaldoSiguienteSDI	float,
@AntiguedadSiguienteSDI float,
@InfonavitDias         int,
@ImpuestoEstatalExento float,
@AguinaldoImporte		   money,
@SueldoDiarioComplemento money,
@ISRBaseAcumuladoSubsidioEmpleo	float,
@DiasTrabajadosSubsidioAcumulado float,
@DiasTrabajadosImporteSubsidio money,
@AyudaFamiliar                  money,
@DiasBimestreInfonavit int,
@TopeFondoAhorro       money,
@FondoAhorroTipoContrato varchar(20),
@FondoAhorroEnFiniquito  varchar(2),
@Plaza varchar(10),
@PctIncremento float,
@EsISRReglamento bit,
@PrestamoFondoAhorroDesde datetime,
@PrestamoFondoAhorroHasta datetime,
@FechaInicioDescuentoInfonavit datetime,
@DiasNaturalesInfonavit  float,
@FondoAhorroAusentismoAcumulado float,
@FondoAhorroAusentismoHorasAcumulado float,
@FechaOrigen datetime,
@SeguroAuto                 money,
@SeguroMedico               money,
@PensionSueldoNeto          money,
@DESCAUSENTISMOFONDOAHORRO  money,
@DESCAUSENTIMOAYUDAFAMILIAR	money,
@DESCAUSENTHORASFONDOAH     money,
@DESCAUSENTHORASAYUDAFAMIL  money,
@RequiereAjusteAnual        bit,
@RequiereAjuste        		varchar(5),
@SueldoMaxAjuste        	money,
@AjusteD                	datetime,
@AjusteA                	datetime,
@CalcularAjusteAnual        bit,
@Estatus                	varchar(30)
SELECT @FechaOrigen = FechaOrigen FROM Nomina WHERE ID = @ID
SELECT @Plaza = Plaza FROM Personal WHERE Personal = @Personal
SELECT @Mov = Mov FROM Nomina WHERE ID = @ID
SELECT @Mov =LTRIM(RTRIM(@Mov)  )
SELECT @EsInicioMes = 0, @EsFinMes = 0, @EsBimestre = 0, @Incapacidades = 0, @Faltas = 0, @EsAniversario = 0, @DiasNaturalesDiferencia = 0,
@ISRBase = 0.0, @IMSSBase = 0.0, @ImpuestoEstatalBase = 0.0, @CedularBase = 0.0,
@ISR = 0.0, @IMSSObrero = 0.0, @IMSSPatron = 0.0, @SueldoMinimo = 0.0, @DomingosLaborados = 0.0, @DiasAguinaldo = 0.0, @DiasAguinaldoSiguiente = 0.0,
@SueldoVariable = 0.0, @SubsidioProporcionalFalta=0
SELECT @SucursalTrabajo  = p.SucursalTrabajo,
@SucursalTrabajoEstado  = s.Estado,
@Categoria    = p.Categoria,
@Puesto   = p.Puesto,
@Cliente   = p.Cliente,
@PersonalEstatus  = p.Estatus,
@PersonalCtaDinero  = p.CtaDinero,
@SDI     = ISNULL(p.SDI, 0.0),
@SueldoDiario   = ISNULL(p.SueldoDiario, 0.0),
@FechaAlta    = p.FechaAlta,
@FechaAntiguedad  = ISNULL(p.FechaAntiguedad, p.FechaAlta),
@FechaBaja   = p.FechaBaja,
@Jornada   = p.Jornada,
@JornadaHoras   = NULLIF(j.HorasPromedio, 0.0),
@PersonalDiasPeriodo  = UPPER(p.DiasPeriodo),
@ZonaEconomica   = p.ZonaEconomica,
@UltimoPago   = p.UltimoPago,
@EsSocio   = ISNULL(p.EsSocio, 0),
@DiasPeriodoEstandar   = ISNULL(pt.DiasPeriodo, 0),
@DescansaDomingos  = ISNULL(j.Domingo, 0),
@IndemnizacionPct  = ISNULL(p.IndemnizacionPct, 100.0),
@Contrato   = UPPER(p.TipoContrato)  ,
@DiasHabilesPeriodo = ISNULL(pt.DiasHabiles, 0),
@FactorAusentismo  = ISNULL(j.FactorAusentismo, 0),
@PctIncremento    = isnull(p.Incremento,0),
@SueldoDiarioComplemento = ISNULL(SueldoDiarioComplemento,0.0) ,
@Estatus=   UPPER(p.Estatus)
FROM Personal p
LEFT OUTER JOIN PeriodoTipo pt ON pt.PeriodoTipo = p.PeriodoTipo
LEFT OUTER JOIN Jornada j ON j.Jornada = p.Jornada
LEFT OUTER JOIN Sucursal s ON s.Sucursal = p.SucursalTrabajo
WHERE p.Personal = @Personal
SELECT @Mov = Mov FROM Nomina WHERE ID = @ID
SELECT @Mov =LTRIM(RTRIM(@Mov)  )
IF @FechaA < @FechaAlta and @mov <>'Presupuesto' SELECT @Ok = 45010
IF @UltimoPago > @FechaA and @Nomtipo <> 'Impuesto Estatal' and @mov <>'Presupuesto' SELECT @Ok = 45020
IF @Ok IN (45010, 45020) AND @NomTipo = 'SDI'
SELECT @Ok = NULL
SELECT @DiasNaturalesOriginales = DATEDIFF(day, @FechaD, @FechaA) + 1
IF @Mov ='PRESUPUESTO'
BEGIN
SELECT @Diasperiodo=30, @DiasPeriodoEstandar=30, @PersonalDiasPeriodo=30, @DiasNaturalesOriginales=30, @DiasNaturales=30, @EsFinMes = 1
IF @Mov ='PRESUPUESTO'      SELECT   @EsFinMes = 1
SELECT @Antiguedad = dbo.fnAntiguedad(@FechaAntiguedad, @FechaA)
IF @Antiguedad >=1
BEGIN
SELECT @SueldoDiario = @SueldoDiario*(1+(@PctIncremento/100.0))
SELECT @SueldoDiarioComplemento = @SueldoDiarioComplemento * (1+(@PctIncremento/100.0))
end
END
IF @UltimoPago IS NULL SELECT @FechaD = @FechaAlta
IF @NomTipo IN ('FINIQUITO', 'LIQUIDACION')
BEGIN
IF @UltimoPago IS NULL SELECT @FechaD = @FechaAlta ELSE SELECT @FechaD = DATEADD(day, 1, @UltimoPago)
IF @PersonalEstatus = 'BAJA' SELECT @FechaA = ISNULL(@FechaBaja, @FechaTrabajo) ELSE SELECT @FechaA = FechaOrigen FROM Nomina WHERE ID = @ID
END
IF @CalendarioEsp = 0 SELECT @IncidenciaD = @FechaD, @IncidenciaA = @FechaA
SELECT @RedondeoMonetarios = RedondeoMonetarios FROM Version
SELECT @SMDF = SueldoMinimo FROM ZonaEconomica WHERE Zona = 'A'
SELECT @SMZ = SueldoMinimo FROM ZonaEconomica WHERE Zona = @ZonaEconomica
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '# Dias Mes',      @DiasMes OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '# Dias Ano',     @DiasAno OUTPUT
EXEC spPersonalPropValor      @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '# Dias Aguinaldo',    @DiasAguinaldoSt OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '% Subsidio Acreditable Honorarios',    @ISRSubsidioPct OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '% Subsidio Acreditable',    @ISRSubsidioPct OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '% Prima Dominical',    @PrimaDominicalPct OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '% Prima Vacacional',    @PrimaVacacionalPct OUTPUT
EXEC spPersonalPropValor      @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Acreedor SHCP',     @AcreedorISR OUTPUT
EXEC spPersonalPropValor      @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Acreedor IMSS',     @AcreedorIMSS OUTPUT
EXEC spPersonalPropValor      @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Acreedor Retiro',     @AcreedorRetiro OUTPUT
EXEC spPersonalPropValor      @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Acreedor Infonavit',    @AcreedorInfonavit OUTPUT
EXEC spPersonalPropValor      @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Acreedor Fonacot',    @AcreedorFonacot OUTPUT
EXEC spPersonalPropValor      @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Acreedor Impuesto Estatal',  @AcreedorImpuestoEstatal OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '# SMZ Prima Antiguedad',    @SMZPrimaAntiguedad OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '% Impuesto Estatal',    @ImpuestoEstatalPct OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'GastosOperacionImpuestoEstatal',  @ImpuestoEstatalGastoOperacionPct OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '% SDI Credito Infonavit',    @InfonavitSDI OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '# SMGDF Credito Infonavit',  @InfonavitSMGDF OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '$ Credito Infonavit',    @InfonavitImporte OUTPUT
EXEC spPersonalPropValor      @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Acreedor Pension Alimenticia',  @PensionAAcreedor OUTPUT
EXEC spPersonalPropValor      @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Acreedor Pension Alimenticia 2',  @PensionAAcreedor2 OUTPUT
EXEC spPersonalPropValor      @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Acreedor Pension Alimenticia 3',  @PensionAAcreedor3 OUTPUT
EXEC spPersonalPropValor      @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Ayuda Familiar Factor Ausentismo(S/N)', @AyudaFamiliarFactorAusentismo OUTPUT
EXEC spPersonalPropValorMoney @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Ayuda Familiar',     @AyudaFamiliar OUTPUT
EXEC spPersonalPropValor      @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Vales Despensa Factor Ausentismo(S/N)', @ValesDespensaFactorAusentismo OUTPUT
EXEC spPersonalPropValor      @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Fondo Ahorro Factor Ausentismo(S/N)', @FondoAhorroFactorAusentismo OUTPUT
EXEC spPersonalPropValor      @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Fondo Ahorro en el Finiquito(S/N)', @FondoAhorroEnFiniquito OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '% Pension Alimenticia Sueldo Bruto',  @PensionASueldoBruto OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '% Pension Alimenticia Sueldo Bruto 2', @PensionASueldoBruto2 OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '% Pension Alimenticia Sueldo Bruto 3', @PensionASueldoBruto3 OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '% Pension Alimenticia Sueldo Neto',  @PensionASueldoNeto OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '% Pension Alimenticia Sueldo Neto 2',  @PensionASueldoNeto2 OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '% Pension Alimenticia Sueldo Neto 3',  @PensionASueldoNeto3 OUTPUT
EXEC spPersonalPropValorMoney @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Caja de Ahorro',     @CajaAhorro OUTPUT
EXEC spPersonalPropValorDMA   @Empresa, NULL,   NULL, NULL, NULL, 'Caja de Ahorro Desde (DD/MM/AAAA)',    @CajaAhorroDesde OUTPUT
EXEC spPersonalPropValorDMA   @Empresa, NULL,   NULL, NULL, NULL, 'Caja de Ahorro Hasta (DD/MM/AAAA)',    @CajaAhorroHasta OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '% Fondo de Ahorro',    @FondoAhorroPct OUTPUT
EXEC spPersonalPropValorMoney @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Fondo de Ahorro',     @FondoAhorro OUTPUT
EXEC spPersonalPropValorMoney @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Tope Fondo de Ahorro',     @TopeFondoAhorro OUTPUT
EXEC spPersonalPropValor      @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Fondo Ahorro Tipo Contrato', @FondoAhorroTipoContrato OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '% Anticipo Fondo de Ahorro',   @FondoAhorroAnticipoPct OUTPUT
EXEC spPersonalPropValorDMA   @Empresa, NULL,   NULL, NULL, NULL, 'Fondo de Ahorro Desde (DD/MM/AAAA)',    @FondoAhorroDesde OUTPUT
EXEC spPersonalPropValorDMA   @Empresa, NULL,   NULL, NULL, NULL, 'Fondo de Ahorro Hasta (DD/MM/AAAA)',    @FondoAhorroHasta OUTPUT
EXEC spPersonalPropValorDMA   @Empresa, NULL,   NULL, NULL, NULL, 'Prestamo Fondo de Ahorro Desde (DD/MM/AAAA)',    @PrestamoFondoAhorroDesde OUTPUT
EXEC spPersonalPropValorDMA   @Empresa, NULL,   NULL, NULL, NULL, 'Prestamo Fondo de Ahorro Hasta (DD/MM/AAAA)',    @PrestamoFondoAhorroHasta OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '# SMZ Tope Horas Dobles',    @SMZTopeHorasDobles OUTPUT
EXEC spPersonalPropValorBit   @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Dias Vacaciones Aniversario (S/N)', @OtorgarDiasVacacionesAniversario OUTPUT
EXEC spPersonalPropValorBit   @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Prima Vacacional Aniversario (S/N)', @OtorgarPrimaVacacionalAniversario OUTPUT
EXEC spPersonalPropValorBit   @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Prima Vacacional Tipo Aguinaldo (S/N)', @OtorgarPrimaVacacionalAguinaldo OUTPUT
EXEC spPersonalPropValorBit   @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Vales Despensa (S/N)',   @TieneValesDespensa OUTPUT
EXEC spPersonalPropValorBit   @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'SubsidioProporcionalAusentismo(S/N)', @SubsidioProporcionalFalta OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Vales Despensa % Sueldo',   @ValesDespensaPct OUTPUT
EXEC spPersonalPropValorMoney @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Vales Despensa Importe',   @ValesDespensaImporte OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '% Premio Puntualidad',   @PremioPuntualidadPct OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '% Premio Asistencia',   @PremioAsistenciaPct OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '# Dias Prima Antiguedad',    @DiasPrimaAntiguedad OUTPUT
EXEC spPersonalPropValorDMA   @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Sueldo Variable PTU Desde (DD/MM/AAAA)',  @SueldoVariablePTUDesde OUTPUT
EXEC spPersonalPropValorDMA   @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Sueldo Variable PTU Hasta (DD/MM/AAAA)',  @SueldoVariablePTUHasta OUTPUT
EXEC spPersonalPropValorDMA   @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Sueldo Variable Aguinaldo Desde (DD/MM/AAAA)', @SueldoVariableAguinaldoDesde OUTPUT
EXEC spPersonalPropValorDMA   @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Sueldo Variable Aguinaldo Hasta (DD/MM/AAAA)', @SueldoVariableAguinaldoHasta OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '% Desc ISR Ajuste Anual (Sueldo Dias Trabajados)', @DescuentoISRAjusteAnualPct OUTPUT
EXEC spPersonalPropValorBit   @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Labora Domingos (S/N)',   @LaboraDomingos OUTPUT
EXEC spPersonalPropValorBit   @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Finiquito Neto en Ceros (S/N)',  @FiniquitoNetoEnCeros OUTPUT
EXEC spPersonalPropValor      @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Beneficiario Sueldo Neto',   @BeneficiarioSueldoNeto OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Seguro Riesgo Infonavit',  @SeguroRiesgoInfonavit OUTPUT
EXEC spPersonalPropValorDMA   @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Fecha Inicio Descuento', @FechaInicioDescuentoInfonavit OUTPUT
EXEC spPersonalPropValor   @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Requiere Ajuste Anual', @RequiereAjusteAnual OUTPUT
EXEC spNominaCalculaDiasMes  @FechaD, @FechaA, @DiasPeriodoMes OUTPUT
IF @FechaAntiguedad > @SueldoVariablePTUDesde SELECT @SueldoVariablePTUDesde = @FechaAntiguedad
IF @FechaAntiguedad > @SueldoVariableAguinaldoDesde SELECT @SueldoVariableAguinaldoDesde = @FechaAntiguedad
IF @PeriodoTipo='CONFIDENCIAL'
SELECT @PeriodoTipo = 'QUINCENAL'
SELECT @Dia = DAY(@FechaA), @Mes = MONTH(@FechaA), @Ano = YEAR(@FechaA)
EXEC spIntToDateTime 1, 1, @Ano, @PrimerDiaAno OUTPUT
EXEC spIntToDateTime 31, 12, @Ano, @UltimoDiaAno OUTPUT
EXEc SPDiasMes @Mes,@Ano,@Dia OUTPUT
SELECT @Dia = DAY(@FechaA), @Mes = MONTH(@FechaA), @Ano = YEAR(@FechaA)
EXEc SPDiasMes @Mes,@Ano,@Dia OUTPUT
EXEC spIntToDateTime @DIA, @MEs, @Ano, @UltimoDiaMes OUTPUT
SELECT @Dia = DAY(@FechaA), @Mes = MONTH(@FechaA), @Ano = YEAR(@FechaA)
SELECT @PrimerDiaAnoAnterior = DATEADD(year, -1, @PrimerDiaAno),
@UltimoDiaAnoAnterior = DATEADD(year, -1, @UltimoDiaAno)
SELECT @PrimerDiaAno1 = @PrimerDiaAno
IF @OtorgarPrimaVacacionalAguinaldo = 1
BEGIN
IF @FechaAntiguedad < @PrimerDiaAno
SELECT  @PrimerDiaAno1  = @PrimerDiaAno
ELSE
SELECT  @PrimerDiaAno1  = @FechaAntiguedad
END ELSE
SELECT @PrimerDiaAno1 = case when @FechaAntiguedad > @PrimerDiaAno then @FechaAntiguedad else @PrimerDiaAno END
IF ISNUMERIC(@DiasAguinaldoSt) = 1
SELECT @DiasAguinaldo = CONVERT(float, @DiasAguinaldoSt), @DiasAguinaldoSiguiente = CONVERT(float, @DiasAguinaldoSt),  @DiasAguinaldoSDI = CONVERT(float, @DiasAguinaldoSt), @DiasAguinaldoSiguienteSDI = CONVERT(float, @DiasAguinaldoSt)
IF @Mov <> 'Presupuesto'
BEGIN
IF @NomTipo IN ('FINIQUITO', 'LIQUIDACION')
SELECT @SueldoMinimo = 0.0
ELSE
IF @CfgSueldoMinimo = 'OFICIAL'
SELECT @SueldoMinimo = @SMDF * @DiasMes * 1.3
IF @FechaAlta > @FechaD SELECT @FechaD = @FechaAlta
SELECT @DiasNaturales = DATEDIFF(day, @FechaD, @FechaA) + 1
SELECT @DiasNaturalesDiferencia = @DiasNaturalesOriginales - @DiasNaturales
SELECT @DiasPeriodo = @DiasNaturales
END
IF @NomTipo = 'NORMAL'
BEGIN
IF @PersonalDiasPeriodo = 'DIAS PERIODO'
SELECT @DiasPeriodo = @DiasPeriodoEstandar - @DiasNaturalesDiferencia
ELSE
IF @PersonalDiasPeriodo = 'DIAS JORNADA'
BEGIN
EXEC spJornadaDiasLibres @Jornada, @FechaD, @FechaA, @JornadaDiasLibres OUTPUT
SET @JornadaDiasLibres = 0
SELECT @DiasPeriodo = dbo.fnMayor(0, @DiasNaturales - @JornadaDiasLibres)
END
END
EXEC spFechaAniversario @FechaAntiguedad, @FechaA, @FechaAniversario OUTPUT
/* Para que pague la quincena de maximo 15 dias y no de 16 */
IF @NomTipo IN ('FINIQUITO', 'LIQUIDACION') AND @PeriodoTipo IN ('QUINCENAL', 'MENSUAL','CONFIDENCIAL')
AND (SELECT dbo.fnEsFinMes(@FechaA)) = 0
SELECT @DiasPeriodo = @DiasNaturales
SELECT @DiasMes = NULLIF(@DiasMes, 0), @DiasMesTrabajados = NULLIF(@DiasMesTrabajados, 0), @DiasBimestre = NULLIF(@DiasBimestre, 0),
@DiasBimestreTrabajados = NULLIF(@DiasBimestreTrabajados, 0), @DiasAno = NULLIF(@DiasAno, 0),
@DiasPeriodo = NULLIF(@DiasPeriodo, 0), @DiasTrabajados = NULLIF(@DiasTrabajados, 0), @DiasNaturales = NULLIF(@DiasNaturales, 0),
@DiasNaturalesTrabajados = NULLIF(@DiasNaturalesTrabajados, 0), @DiasNaturalesOriginales = NULLIF(@DiasNaturalesOriginales, 0),
@DiasNaturalesDiferencia = NULLIF(@DiasNaturalesDiferencia, 0)
SELECT @Antiguedad = dbo.fnAntiguedad(@FechaAntiguedad, @FechaA)
IF @OtorgarPrimaVacacionalAguinaldo = 1
IF @NomTipo in( 'Normal', 'Prima Vacacional', 'SDI') AND YEAR(@Antiguedad) < YEAR(@FechaA) AND @OtorgarPrimaVacacionalAguinaldo = 1
SELECT @Antiguedad = YEAR(@UltimoDiaano) - YEAR(@FechaAntiguedad)
IF @OtorgarPrimaVacacionalAguinaldo = 1
IF @NomTipo in( 'Normal', 'Prima Vacacional', 'SDI') AND YEAR(@Antiguedad) = YEAR(@FechaA) AND @OtorgarPrimaVacacionalAguinaldo = 1
SELECT @Antiguedad = dbo.fnAntiguedad(@FechaAntiguedad, @UltimoDiaAno)
IF @OtorgarPrimaVacacionalAguinaldo = 1
IF @NomTipo in( 'Finiquito', 'Liquidacion') AND YEAR(@Antiguedad) < YEAR(@FechaA) AND @OtorgarPrimaVacacionalAguinaldo = 1
SELECT @Antiguedad = YEAR(@FechaA) - YEAR(@FechaAntiguedad)
IF @OtorgarPrimaVacacionalAguinaldo = 1
IF @NomTipo in( 'Finiquito', 'Liquidacion') AND YEAR(@Antiguedad) = YEAR(@FechaA) AND @OtorgarPrimaVacacionalAguinaldo = 1
SELECT @Antiguedad = dbo.fnAntiguedad(@FechaAntiguedad, @FechaA)
SELECT @AntiguedadSiguiente = dbo.fnAntiguedad(@FechaAntiguedad, @FechaA) + 1
SELECT @AntiguedadFlotante = dbo.fnAntiguedad(@FechaAntiguedad, @FechaA)
SELECT @AntiguedadDia = DAY(@FechaAntiguedad), @AntiguedadMes = MONTH(@FechaAntiguedad), @FechaDAno = YEAR(@FechaD), @FechaAAno = YEAR(@FechaA)
EXEC   spIntToDateTime @AntiguedadDia, @AntiguedadMes, @FechaDAno, @FechaDAntiguedad OUTPUT
EXEC   spIntToDateTime @AntiguedadDia, @AntiguedadMes, @FechaAAno, @FechaAAntiguedad OUTPUT
EXEC   spTablaNum @CfgTablaVacaciones, @Antiguedad, @DiasVacaciones OUTPUT
EXEC   spTablaNum @CfgTablaVacaciones, @AntiguedadSiguiente, @DiasVacacionesSiguiente OUTPUT
IF @Antiguedad > 0 AND (@FechaDAntiguedad BETWEEN @FechaD AND @FechaA OR @FechaAAntiguedad BETWEEN @FechaD AND @FechaA)
SELECT @EsAniversario = 1
IF ISNULL(@DiasPeriodo, 0) = 0  SELECT @DiasNaturales = 0, @DiasPeriodo = 0
IF ISNUMERIC(@DiasAguinaldoSt) = 0
BEGIN
EXEC spTablaNum @DiasAguinaldoSt, @Antiguedad, @DiasAguinaldo OUTPUT
EXEC spTablaNum @DiasAguinaldoSt, @AntiguedadSiguiente, @DiasAguinaldoSiguiente OUTPUT
END
SELECT @IndemnizacionTope = @SMZ * 90 * ROUND(@AntiguedadFlotante, 0)
SELECT @PrimaVacacional = @SueldoDiario * @DiasVacaciones * (@PrimaVacacionalPct/100.0)
IF @NomTipo IN ('FINIQUITO', 'LIQUIDACION')
BEGIN
IF @OtorgarPrimaVacacionalAguinaldo = 0
BEGIN
SELECT @DiasVacacionesProporcion = @DiasVacacionesSiguiente * dbo.fnAntiguedadFloat(@FechaAniversario, @FechaA)
SELECT @PrimaVacacionalProporcion = @SueldoDiario * @DiasVacacionesProporcion * (@PrimaVacacionalPct/100.0)
END
IF @OtorgarPrimaVacacionalAguinaldo = 1
BEGIN
SELECT @DiasVacacionesProporcion = @DiasVacaciones/*Siguiente*/ * dbo.fnAntiguedadFloat(@PrimerDiaAno1, @FechaA)
SELECT @PrimaVacacionalProporcion = @SueldoDiario * @DiasVacacionesProporcion * (@PrimaVacacionalPct/100.0)
END
END
IF @NomTipo = 'AGUINALDO'
BEGIN
IF @PUESTO IN('Vendedor(a)','Vendedor Viajero')
BEGIN
SELECT @SueldoVariableDias = DATEDIFF(day, @SueldoVariableAguinaldoDesde, @SueldoVariableAguinaldoHasta) + 1
EXEC spNominaSueldoVariableAcumuladoFechas @Empresa, @Personal, @SueldoVariableAguinaldoDesde, @SueldoVariableAguinaldoHasta, @SueldoVariableAcumulado OUTPUT
END ELSE
SELECT @SueldoVariableDias = 0
IF @FechaAntiguedad < @PrimerDiaAno1
SELECT @DiasAguinaldoProporcion = DATEDIFF(DAY,@PrimerDiaAno1,@UltimoDiaAno) + 1
ELSE
SELECT @DiasAguinaldoProporcion = DATEDIFF(DAY, @FechaAntiguedad,@UltimoDiaAno) + 1
SELECT @DiasAguinaldoProporcion = ISNULL((@DiasAguinaldoProporcion / @DiasAno) * (@DiasAguinaldo - ISNULL(@FaltasAcumulado,0)),0)
SELECT @SueldoVariablePromedio = @SueldoVariableAcumulado / NULLIF(@SueldoVariableDias, 0)
SELECT @Aguinaldo = ((@SueldoDiario) + ISNULL(@SueldoVariablePromedio, 0.0)) * @DiasAguinaldoProporcion
SELECT @AguinaldoPuntyAsis = ((@SueldoDiario*.20) + ISNULL(@SueldoVariablePromedio, 0.0)) * @DiasAguinaldoProporcion
SELECT @AguinaldoImporte = @Aguinaldo
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Aguinaldo', @Empresa, @Personal, @DiasAguinaldoProporcion, @Aguinaldo
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'AguinaldoComplemento', @Empresa, @Personal, @DiasAguinaldoProporcion, @AguinaldoPuntyAsis
END ELSE
IF @NomTipo IN ('FINIQUITO', 'LIQUIDACION') AND @FechaA >= @PrimerDiaAno
BEGIN
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'Aguinaldo', @PrimerDiaAno, @FechaA, NULL, @AguinaldoAcumulado OUTPUT, NULL
SELECT @DiasAguinaldoProporcion = @DiasAguinaldoSiguiente * dbo.fnAntiguedadFloat(@PrimerDiaAno1, @FechaA)
SELECT @Aguinaldo = (@SueldoDiario * @DiasAguinaldoProporcion) - @AguinaldoAcumulado
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Aguinaldo', @Empresa, @Personal, @DiasAguinaldoProporcion, @Aguinaldo
END
IF @NomTipo = 'PTU'
BEGIN
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'DiasTrabajados', @RepartirDesde, @RepartirHasta, NULL, @DiasTrabajadosImporte OUTPUT, @DiasTrabajados OUTPUT
IF @DiasTrabajados>=60
BEGIN
SELECT @PTUIngresosTopados = dbo.fnMenor(@DiasTrabajadosImporte, @RepartirIngresoTope) * @RepartirIngresoFactor
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'PTU/IngresosTopados', @Empresa, @Personal, @DiasTrabajados, @PTUIngresosTopados
SELECT @PTUDiasTrabajados = @DiasTrabajados * @RepartirDiasFactor
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'PTU/DiasTrabajados', @Empresa, @Personal, @DiasTrabajados, @PTUDiasTrabajados
SELECT @CalcImporte = @PTUIngresosTopados + @PTUDiasTrabajados
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'PTU', @Empresa, @Personal, @DiasTrabajados, @CalcImporte
END
END
IF @NomTipo = 'PRESTAMO FONDO AHORR'
BEGIN
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, 	@Personal, 'FondoAhorro',                 @PrestamoFondoAhorroDesde, @PrestamoFondoAhorroHasta, NULL, @FondoAhorroAcumulado OUTPUT, @FondoAhorroAcumuladoDias OUTPUT
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, 	@Personal, 'FondoAhorro/Patron',          @PrestamoFondoAhorroDesde, @PrestamoFondoAhorroHasta, NULL, @FondoAhorroPatronAcumulado OUTPUT, @FondoAhorroPatronAcumuladoDias OUTPUT
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, 	@Personal, 'FondoAhorro/Anticipo',        @PrestamoFondoAhorroDesde, @PrestamoFondoAhorroHasta, NULL, @FondoAhorroAnticipoAcumulado OUTPUT, @FondoAhorroAnticipoAcumuladoDias OUTPUT
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, 	@Personal, 'FondoAhorro/Prestamo',        @PrestamoFondoAhorroDesde, @PrestamoFondoAhorroHasta, NULL, @FondoAhorroPrestamoAcumulado OUTPUT, @FondoAhorroAnticipoAcumuladoDias OUTPUT
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, 	@Personal, 'FondoAhorro/Ausentismo',      @PrestamoFondoAhorroDesde, @PrestamoFondoAhorroHasta, NULL, @FondoAhorroAusentismoAcumulado OUTPUT,  NULL
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, 	@Personal, 'FondoAhorro/AusentismoHoras', @PrestamoFondoAhorroDesde, @PrestamoFondoAhorroHasta, NULL, @FondoAhorroAusentismoHorasAcumulado OUTPUT, NULL
SELECT @FondoAhorroAcumulado = ISNULL(@FondoAhorroAcumulado,0) + ISNULL(@FondoAhorroPatronAcumulado,0) - (ISNULL(@FondoAhorroAnticipoAcumulado,0) + ISNULL(@FondoAhorroPrestamoAcumulado,0)- ISNULL(@FondoAhorroAusentismoAcumulado,0)*2.0 - ISNULL(@FondoAhorroAusentismoHorasAcumulado,0)*2.0)
IF ISNULL(@FondoAhorroAnticipoPct,0.0) > 0.0
BEGIN
SELECT @FondoAhorro = @FondoAhorroAcumulado * @FondoAhorroAnticipoPct / 100.0
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'FondoAhorro/Prestamo', @Empresa, @Personal,@FondoAhorroAcumuladoDias, @FondoAhorro
END
END
IF @NomTipo in( 'LIQUIDACION FONDO AHORRO')  OR ((@NomTipo IN('FINIQUITO')) AND (@FondoAhorroEnFiniquito = 'S'))
BEGIN
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, 	@Personal, 	'DiasTrabajados',       @RepartirDesde,    @RepartirHasta,    NULL, @DiasTrabajadosImporte OUTPUT, @DiasTrabajados OUTPUT
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, 	@Personal, 	'FondoAhorro',          @FondoAhorroDesde, @FondoAhorroHasta, NULL, @FondoAhorroAcumulado OUTPUT, @FondoAhorroAcumuladoDias OUTPUT
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, 	@Personal, 	'FondoAhorro/Anticipo', @FondoAhorroDesde, @FondoAhorroHasta, NULL, @FondoAhorroAnticipoAcumulado OUTPUT, @FondoAhorroAnticipoAcumuladoDias OUTPUT
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, 	@Personal,  'FondoAhorro/Prestamo',  @FondoAhorroDesde, @FondoAhorroHasta, NULL, @FondoAhorroPrestamoAcumulado OUTPUT, @FondoAhorroAnticipoAcumuladoDias OUTPUT
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, 	@Personal, 	'FondoAhorro/Patron',   @FondoAhorroDesde, @FondoAhorroHasta, NULL, @FondoAhorroPatronAcumulado OUTPUT, @FondoAhorroPatronAcumuladoDias OUTPUT
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, 	@Personal,  'FondoAhorro/Ausentismo',      @FondoAhorroDesde, @FondoAhorroHasta, NULL, @FondoAhorroAusentismoAcumulado OUTPUT,  NULL
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, 	@Personal,  'FondoAhorro/AusentismoHoras', @FondoAhorroDesde, @FondoAhorroHasta, NULL, @FondoAhorroAusentismoHorasAcumulado OUTPUT, NULL
SELECT @FondoAhorroPatronAcumulado = @FondoAhorroPatronAcumulado  + ISNULL(@FondoAhorroAusentismoHorasAcumulado, 0) + ISNULL(@FondoAhorroAusentismoAcumulado, 0)
SELECT @FondoAhorroAcumulado       = @FondoAhorroAcumulado        + ISNULL(@FondoAhorroAusentismoHorasAcumulado, 0) + ISNULL(@FondoAhorroAusentismoAcumulado, 0)
EXEC spNominaAgregarClaveInterna 			@Ok OUTPUT, @OkRef OUTPUT,'FondoAhorro/Liquidacion',         @Empresa, @Personal, @FondoAhorroAcumuladoDias, @FondoAhorroAcumulado
EXEC spNominaAgregarClaveInterna 			@Ok OUTPUT, @OkRef OUTPUT,'FondoAhorro/Liquidacion/Patron',  @Empresa, @Personal, @FondoAhorroPatronAcumuladoDias, @FondoAhorroPatronAcumulado
SELECT @FondoAhorroAnticipoAcumulado =  (isnull(@FondoAhorroAnticipoAcumulado,0) + isnull(@FondoAhorroPrestamoAcumulado,0))
IF ISNULL(@FondoAhorroAnticipoPct,0.0) > 0.0
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'FondoAhorro/Liquidacion/Anticipo',@Empresa, @Personal, @FondoAhorroPatronAcumuladoDias, @FondoAhorroAnticipoAcumulado
SELECT @FondoAhorroIngresosTopados = dbo.fnMenor(@DiasTrabajadosImporte, @RepartirIngresoTope) * @RepartirIngresoFactor
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'FondoAhorro/IngresosTopados',     @Empresa, @Personal, @DiasTrabajados, @FondoAhorroIngresosTopados
SELECT @FondoAhorroDiasTrabajados = @DiasTrabajados * @RepartirDiasFactor
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'FondoAhorro/DiasTrabajados',      @Empresa, @Personal, @DiasTrabajados, @FondoAhorroDiasTrabajados
SELECT @CalcImporte = @FondoAhorroIngresosTopados + @FondoAhorroDiasTrabajados
IF ISNULL(@CalcImporte,0.0)> 0.0
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'FondoAhorro/Liquidacion/Interes', @Empresa, @Personal, @DiasTrabajados, @CalcImporte
END
SELECT @SueldoMensual = @SueldoDiario * @DiasMes
SELECT @PrimerDiaMes = DATEADD(day, 1-DAY(@FechaA), @FechaA)
if @NomTipo IN('FINIQUITO', 'liquidacion')
SELECT @PrimerDiaMes = DATEADD(day, 1-DAY(@FechaOrigen), @FechaOrigen)
SELECT @PrimerDiaMesAnterior = DATEADD(month, -1, @PrimerDiaMes)
SELECT @UltimoDiaMesAnterior = DATEADD(day, -1, @PrimerDiaMes)
SELECT @ISRVencimiento = DATEADD(day, 16, DATEADD(month, 1, @PrimerDiaMes))
SELECT @IMSSVencimiento = @ISRVencimiento,
@IMSSVencimientoBimestre = @ISRVencimiento,
@ImpuestoEstatalVencimiento = @ISRVencimiento
IF MONTH(@FechaA) % 2 <> 0 SELECT @IMSSVencimientoBimestre = DATEADD(month, 1, @IMSSVencimientoBimestre)
IF MONTH(@FechaA) <> MONTH(DATEADD(day, @DiasNaturalesOriginales, @FechaA))
BEGIN
IF MONTH(@FechaA)= 2 AND DAY(@FechaA) = 15 AND @PeriodoTipo = 'Quincenal'
SELECT @EsFinMes = 0
ELSE
SELECT @EsFinMes = 1
END
IF @Mov ='PRESUPUESTO'   SELECT   @EsFinMes = 1
IF (MONTH(@PrimerDiaMes) % 2) = 0
SELECT  @PrimerDiaBimestre = DATEADD(month, -1, @PrimerDiaMes)
ELSE
SELECT  @PrimerDiaBimestre =  @PrimerDiaMes
IF @EsFinMes = 1
BEGIN
IF MONTH(@FechaA) % 2 = 0
SELECT @EsBimestre = 1, @PrimerDiaBimestre = DATEADD(month, -1, @PrimerDiaMes)
SELECT @PrimerDiaBimestre = Convert(DateTime, dbo.fnMayor(Convert(FLOAT,@PrimerDiaBimestre), Convert(FLOAT,@FechaAntiguedad)))
IF MONTH(@FechaA) % 2 = 0 SELECT @EsBimestre = 1
END
IF DAY(@FechaA) = 15 AND @PeriodoTipo = 'Quincenal' SELECT @EsFinMes = 0
IF  @PeriodoTipo = 'CATORCENAL'
BEGIN
IF MONTH(@FechaA) <> MONTH(DATEADD(DAY,-3,DATEADD(day, @DiasNaturalesOriginales, @FechaA)))
SELECT @EsFinMes = 1
ELSE
SELECT @EsFinMes = 0
END
IF @CfgAjusteMensualISR = 0
SELECT @EsFinMes = 0
SELECT @DiasBimestre = ISNULL(dbo.fnDiasBimestre(@FechaA),1)
IF MONTH(@FechaA) % 2 = 0
SELECT @EsBimestre = 1
SELECT @EsFinMes = 0
IF @NomTipo in ('Finiquito', 'Liquidacion')
SELECT @EsFinMes = 1
IF @Mov ='PRESUPUESTO'      SELECT   @EsFinMes = 1
IF @NomTipo='IMPUESTO ESTATAL'
BEGIN
EXEC spNominaMexicoImpuestoEstatal @Empresa,@SucursalTrabajo,@Personal,@NomTipo, @DiasNaturales   ,@SMZ,@PrimerDiaBimestre, @PrimerDiaMes,
@SucursalTrabajoEstado,@ImpuestoEstatalExento,@ImpuestoEstatalBase,@ImpuestoEstatal,@PersonalPercepciones,@FechaA,@FechaD,@ImpuestoEstatalPct,
@ImpuestoEstatalGastoOperacionPct,@AcreedorImpuestoEstatal,@ImpuestoEstatalVencimiento,@CalcImporte,@Estacion,@ID,@Ok OUTPUT,@OkRef OUTPUT
END
IF @NomTipo='LIQUIDACION FONDO AHORRO'
BEGIN
INSERT #Nomina (
Personal,  IncidenciaID, IncidenciaRID, NominaConcepto,   Referencia,   Fecha,             Cuenta,     Vencimiento,   Cantidad,   Importe)
SELECT @Personal, d.ID,         d.RID,         d.NominaConcepto, i.Referencia, d.FechaAplicacion, i.Acreedor, i.Vencimiento, d.Cantidad, ROUND(d.Saldo*(i.TipoCambio/NULLIF(@TipoCambio, 0.0)), @RedondeoMonetarios)
FROM IncidenciaD d
JOIN Incidencia i ON i.ID = d.ID AND i.Empresa = @Empresa AND i.Personal = @Personal AND i.Estatus = 'PENDIENTE'
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto AND nc.Movimiento = 'Percepcion'
WHERE NULLIF(d.Saldo, 0.0) IS NOT NULL
INSERT #Nomina (
Personal,  IncidenciaID, IncidenciaRID, NominaConcepto,   Referencia,   Fecha,             Cuenta,     Vencimiento,   Cantidad,   Importe)
SELECT @Personal, d.ID,         d.RID,         d.NominaConcepto, i.Referencia, d.FechaAplicacion, i.Acreedor, i.Vencimiento, d.Cantidad, ROUND(d.Saldo*(i.TipoCambio/NULLIF(@TipoCambio, 0.0)), @RedondeoMonetarios)
FROM IncidenciaD d
JOIN Incidencia i ON i.ID = d.ID AND i.Empresa = @Empresa AND i.Personal = @Personal AND i.Estatus = 'PENDIENTE'
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto AND nc.Movimiento <> 'Percepcion'
WHERE NULLIF(d.Saldo, 0.0) IS NOT NULL
END
IF @NomTipo='SUELDO COMPLEMENTO'
BEGIN
IF (SELECT isnull(SueldoDiarioComplemento,0.0) FROM Personal WHERE Personal = @Personal) >1
BEGIN
SELECT @DiasNaturalesTrabajados = dbo.fnMayor(0, @DiasPeriodo - @Faltas )
SELECT @DiasTrabajados = @DiasPeriodo - @Faltas
EXEC  spNominaSueldoComplemento @Empresa, @Personal, @NomTipo, @DiasNaturalesTrabajados, @DiasVacaciones, @EsAniversario, @Faltas, @Antiguedad,
@OtorgarPrimaVacacionalAniversario, @OtorgarDiasVacacionesAniversario, @TipoCambio, @RedondeoMonetarios,
@FechaA, @FechaD,  @SueldoDiarioComplemento,@Mov, @Ok, @OkRef
END
ELSE
BEGIN
EXEC spNominaSueldoComplementoIncidencia @Empresa ,@Personal,@NomTipo ,@TipoCambio,@RedondeoMonetarios ,@FechaA  ,@FechaD  ,@Ok      OUTPUT,@OkRef     OUTPUT
END
END
IF @NomTipo='AGUINALDOCOMPLEMENTO'
BEGIN
IF @FechaAntiguedad < @PrimerDiaAno
SELECT @DiasAguinaldoProporcion = DATEDIFF(DAY,@PrimerDiaAno,@UltimoDiaAno) +1
ELSE
SELECT @DiasAguinaldoProporcion = DATEDIFF(DAY, @FechaAntiguedad,@UltimoDiaAno)+1
SELECT @DiasAguinaldoProporcion = isnull((ISNULL(@DiasAguinaldoProporcion,365) / 365.0) * (@DiasAguinaldo-ISNULL(@FaltasAcumulado,0)),0)
SELECT @Aguinaldo = (@SueldoDiarioComplemento * @DiasAguinaldoProporcion) * 1.0
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Aguinaldo/Complemento', @Empresa, @Personal, @DiasAguinaldoProporcion, @Aguinaldo
EXEC spNominaAguinaldoComplementoIncidencia @Empresa ,@Personal,@NomTipo ,@TipoCambio,@RedondeoMonetarios ,@FechaA  ,@FechaD  ,@Ok      OUTPUT,@OkRef     OUTPUT
END
EXEC spNominaCalcMexicoTipo @Empresa OUTPUT, @TipoCambio OUTPUT, @Personal OUTPUT, @FechaD OUTPUT, @FechaA OUTPUT, @CfgPrimaDominicalAuto OUTPUT, @NomTipo OUTPUT, @NomCalcSDI OUTPUT,
@CfgSubsidioIncapacidadEG OUTPUT, @CfgFactorintegracionAntiguedad OUTPUT, @CfgFactorintegracionTabla OUTPUT, @IncidenciaD OUTPUT, @IncidenciaA OUTPUT,
@RedondeoMonetarios OUTPUT, @Calc OUTPUT, @CalcImporte OUTPUT, @DescansaDomingos OUTPUT, @LaboraDomingos OUTPUT, @EsBimestre OUTPUT, @PrimerDiaMes OUTPUT,
@PrimerDiaBimestre OUTPUT, @PersonalEstatus OUTPUT, @SucursalTrabajo OUTPUT, @Categoria OUTPUT, @Puesto OUTPUT, @Cliente OUTPUT, @Jornada OUTPUT,
@SMZ OUTPUT, @SMDF OUTPUT, @PrimerDiaAno1 OUTPUT, @UltimoDiaAno OUTPUT,@FechaAlta OUTPUT, @FechaAntiguedad OUTPUT, @EsSocio OUTPUT, @SDI OUTPUT,
@SDINuevo OUTPUT, @SueldoPeriodo OUTPUT, @SueldoDiario OUTPUT, @DiasMes OUTPUT, @DiasMesTrabajados OUTPUT, @DiasBimestre OUTPUT,
@DiasBimestreTrabajados OUTPUT, @DiasAno OUTPUT, @DiasPeriodo OUTPUT, @DiasPeriodoSubsidio OUTPUT, @DiasHabilesPeriodo OUTPUT, @DiasPeriodoEstandar OUTPUT,
@DiasTrabajados OUTPUT, @DiasTrabajadosImporte OUTPUT, @DiasNaturales OUTPUT, @FactorAusentismo OUTPUT, @DiasNaturalesTrabajados OUTPUT,
@DomingosLaborados OUTPUT, @Faltas OUTPUT, @FaltasAcumulado OUTPUT, @FaltasImporte OUTPUT, @Incapacidades OUTPUT, @IncapacidadesAcumulado OUTPUT,
@IncapacidadesImporte OUTPUT, @ISRLiquidacionGravable OUTPUT, @SubsidoSueldoMensual OUTPUT, @IMSSBase OUTPUT, @IMSSBaseAcumulado OUTPUT, @IMSSBaseMes OUTPUT,
@IMSSObrero OUTPUT, @IMSSObreroCV OUTPUT, @IMSSObreroSinCV OUTPUT, @IMSSPatron OUTPUT, @IMSSPatronMensual OUTPUT, @IMSSPatronCV OUTPUT,
@IMSSPatronRetiro OUTPUT, @IMSSPatronInfonavit OUTPUT, @Antiguedad OUTPUT, @PrimaDominicalPct OUTPUT, @PrimaDominical OUTPUT, @PrimaVacacionalPct OUTPUT,
@Vacaciones OUTPUT, @VacacionesTomadas OUTPUT, @PrimaVacacional OUTPUT, @PrimaVacacionalProporcion OUTPUT, @DiasVacaciones OUTPUT,
@DiasVacacionesProporcion OUTPUT, @DiasVacacionesSiguiente OUTPUT, @DiasVacacionesAcumulado OUTPUT, @Factorintegracion OUTPUT, @CajaAhorro OUTPUT,
@CajaAhorroDesde OUTPUT, @CajaAhorroHasta OUTPUT, @FondoAhorroFactorAusentismo OUTPUT, @ValesDespensaFactorAusentismo OUTPUT,
@AyudaFamiliarFactorAusentismo OUTPUT, @FondoAhorroPct OUTPUT, @FondoAhorro OUTPUT, @FondoAhorro1 OUTPUT, @FondoAhorroAnticipoPct OUTPUT,
@FondoAhorroDesde OUTPUT, @FondoAhorroHasta OUTPUT, @EsAniversario OUTPUT, @OtorgarDiasVacacionesAniversario OUTPUT,
@OtorgarPrimaVacacionalAniversario OUTPUT, @OtorgarPrimaVacacionalAguinaldo OUTPUT, @TieneValesDespensa OUTPUT, @ValesDespensaPct OUTPUT,
@ValesDespensaImporte OUTPUT, @ValesDespensa OUTPUT, @PremioPuntualidadPct OUTPUT, @AyudaTransportePct OUTPUT, @PremioAsistenciaPct OUTPUT,
@SueldoVariable OUTPUT, @SubsidioProporcionalFalta OUTPUT, @Contrato OUTPUT, @MaxID OUTPUT, @MaxRID OUTPUT, @IncapacidadesD OUTPUT, @CuotaSindical OUTPUT,
@Mov OUTPUT, @SDIAnterior OUTPUT, @SDIVariableDiario OUTPUT, @SDIBruto OUTPUT, @FhiAntiguedad OUTPUT, @AntiguedadSDI OUTPUT, @DiasAguinaldoSDI OUTPUT,
@DiasAguinaldoSiguienteSDI OUTPUT, @AyudaFamiliar OUTPUT, @TopeFondoAhorro OUTPUT, @FondoAhorroTipoContrato OUTPUT, @Plaza OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @NomTipo = 'FINIQUITO' AND @AntiguedadFlotante >= 15.0
BEGIN
SELECT @PrimaAntiguedad = dbo.fnMenor(@SueldoDiario, @SMZ * 2.0) * 12.0 * @AntiguedadFlotante
END
IF @NomTipo = 'LIQUIDACION'
BEGIN
SELECT @Indemnizacion3Meses = @SDI * 90
IF @IndemnizacionPct = 100.0
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Indemnizacion/3Meses', @Empresa, @Personal, 90, @Indemnizacion3Meses
SELECT @Indemnizacion20Dias = @SDI * 20 * @AntiguedadFlotante
IF @IndemnizacionPct = 100.0
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Indemnizacion/20Dias', @Empresa, @Personal, @AntiguedadFlotante, @Indemnizacion20Dias
SELECT @PrimaAntiguedad = dbo.fnMenor(@SueldoDiario, @SMZ * 2.0) * 12.0 * @AntiguedadFlotante
IF @IndemnizacionPct = 100.0
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'PrimaAntiguedad', @Empresa, @Personal, @AntiguedadFlotante, @PrimaAntiguedad
SELECT @Indemnizacion = (@Indemnizacion3Meses + @Indemnizacion20Dias + @PrimaAntiguedad) * (@IndemnizacionPct/100.0)
IF @IndemnizacionPct <> 100.0
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Indemnizacion', @Empresa, @Personal, @AntiguedadFlotante, @Indemnizacion
END
DELETE #Nomina
FROM #Nomina n
JOIN NominaConcepto nc ON nc.NominaConcepto = n.NominaConcepto
WHERE nc.NominaConcepto NOT IN(SELECT MovEspecificoNomina.NominaConcepto FROM MovEspecificoNomina WHERE MovEspecificoNomina.MovEspecificoNomina = @Mov)
AND n.Personal = @Personal   and exists(select * from MovEspecificoNomina where MovEspecificoNomina.nominaconcepto= n.NominaConcepto)
IF @MOV  = 'PRESUPUESTO'
UPDATE #NOMINA SET REFERENCIA =@PLAZA WHERE NULLIF(referencia,'') IS NULL and personal=@Personal
EXEC spNominaCalcMexicoNomina @Empresa OUTPUT, @Sucursal OUTPUT, @ID OUTPUT, @Moneda OUTPUT, @TipoCambio OUTPUT, @Personal OUTPUT, @FechaD OUTPUT, @FechaA OUTPUT, @PeriodoTipo OUTPUT,
@CfgAjusteMensualISR OUTPUT, @CfgISRReglamentoAguinaldo OUTPUT, @CfgISRReglamentoPTU OUTPUT, @NomTipo OUTPUT, @EsFinMes OUTPUT, @PrimerDiaMes OUTPUT,
@PrimerDiaMesAnterior OUTPUT, @UltimoDiaMesAnterior OUTPUT, @UltimoDiaMes OUTPUT, @SucursalTrabajoEstado OUTPUT, @SMZ OUTPUT, @SMZTopeHorasDobles OUTPUT,
@SDI OUTPUT, @SueldoMensual OUTPUT, @SueldoMensualReglamento OUTPUT, @DiasMes OUTPUT, @DiasAno OUTPUT, @DiasPeriodo OUTPUT, @DiasPeriodoSubsidio OUTPUT,
@ISR OUTPUT, @ISRAcumulado OUTPUT, @ISRBruto OUTPUT, @ISRVencimiento OUTPUT, @ISRCreditoAlSalarioTabla OUTPUT, @ISRSubsidioAlEmpleoTabla OUTPUT,
@ISRSubsidioAlEmpleoAcumulado OUTPUT, @ISRBase OUTPUT, @ISRBaseMes OUTPUT, @ISRBaseAcumulado OUTPUT, @ISRReglamentoBase OUTPUT, @ISRReglamentoFactor OUTPUT,
@ISRSueldoMensual OUTPUT, @ISRSueldoMensualReglamento OUTPUT, @IMSSBase OUTPUT, @ImpuestoEstatalBase OUTPUT, @CedularBase OUTPUT, @AcreedorISR OUTPUT,
@Antiguedad OUTPUT, @PercepcionBruta OUTPUT, @IndemnizacionTope OUTPUT, @Mov OUTPUT, @NuevoImporteISR OUTPUT, @NuevoImporteCAS OUTPUT,
@DiasPeriodoMes OUTPUT, @DiasTrabajadosSubsidioAcumulado OUTPUT, @DiasTrabajadosImporteSubsidio OUTPUT, @EsISRReglamento OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @NomTipo = 'NORMAL'
BEGIN
SELECT @ISRAjuste = 0.0
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'ISR/AjusteAnual', @FechaAlta, @FechaA, NULL, @ISRAjusteAnual OUTPUT, NULL
IF @ISRAjusteAnual < 0.0 AND @ISR > 0.0   SELECT @ISRAjuste = dbo.fnMenor(ABS(@ISRAjusteAnual), @ISR)
IF @ISRAjusteAnual > 0.0
BEGIN
EXEC spPersonalPropValorMONEY @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '$ Descuento quincenal por ISR Ajuste anual',   @ISRAjusteMax OUTPUT
SELECT @ISRAjuste = dbo.fnMenor(@ISRAjusteAnual, @ISRAjusteMax) * -1.0
END
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ISR/AjusteAnual', @Empresa, @Personal, @Importe = @ISRAjuste
SELECT @CalcImporte =0
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ISR/Ajuste', @Empresa, @Personal, @Importe = @CalcImporte,@Cuenta = @AcreedorISR, @Vencimiento = @ISRVencimiento, @Mov='CXP'
END
IF @NomTipo = 'LIQUIDACION'
BEGIN
IF @CfgISRLiquidacionSueldoMensual = 'SUELDO MENSUAL'
SELECT @ISRLiquidacionBase = @SueldoMensual
ELSE
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'ISR/Base', @PrimerDiaMesAnterior, @UltimoDiaMesAnterior, NULL, @ISRLiquidacionBase OUTPUT, NULL
EXEC spNominaISRSubsidioAlEmpleoProporcional	30.4,	30.4, 30.4 ,@ISRLiquidacionBase, @ISRLiquidacion OUTPUT,	NULL,	NULL
SELECT  @ISRLiquidacion= dbo.fnMayor(0,@ISRLiquidacion)
SELECT @ISRLiquidacionFactor = @ISRLiquidacion / @ISRLiquidacionBase
EXEC spNominaTope @Indemnizacion, @IndemnizacionTope, @ISRLiquidacionExcento OUTPUT, @ISRLiquidacionGravable OUTPUT
SELECT @ISRLiquidacion = @ISRLiquidacionGravable * @ISRLiquidacionFactor
IF @ISRLiquidacion<0
SELECT @ISRLiquidacion=0
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ISR/Liquidacion', @Empresa, @Personal, @Importe = @ISRLiquidacion, @Cuenta = @AcreedorISR, @Vencimiento = @ISRVencimiento
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Indemnizacion/Exento', @Empresa, @Personal, @Importe = @ISRLiquidacionExcento
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Indemnizacion/Gravable', @Empresa, @Personal, @Importe = @ISRLiquidacionGravable
END
EXEC spNominaCalcMexicoIMSSInfonavit @Empresa OUTPUT, @Personal OUTPUT, @FechaD OUTPUT, @FechaA OUTPUT, @PeriodoTipo OUTPUT, @CfgFactorIntegracionAntiguedad OUTPUT,
@CfgFactorIntegracionTabla OUTPUT, @NomTipo OUTPUT, @NomCalcSDI OUTPUT, @CalcImporte OUTPUT, @EsBimestre OUTPUT, @PrimerDiaBimestre OUTPUT,
@PrimerDiaBimestreAnterior OUTPUT, @UltimoDiaBimestreAnterior OUTPUT, @SucursalTrabajo OUTPUT, @Categoria OUTPUT, @Puesto OUTPUT, @SMZ OUTPUT,
@SMZPrimaAntiguedad OUTPUT, @SMDF OUTPUT, @PrimerDiaAnoAnterior OUTPUT, @EsSocio OUTPUT, @SDI OUTPUT, @SDINuevo OUTPUT, @SueldoDiario OUTPUT,
@DiasBimestre OUTPUT, @DiasBimestreTrabajados OUTPUT, @DiasAno OUTPUT, @DiasAguinaldo OUTPUT, @DiasAguinaldoSiguiente OUTPUT,@DiasPeriodo OUTPUT,
@DiasTrabajados OUTPUT, @DiasNaturales OUTPUT, @DiasNaturalesTrabajados OUTPUT, @DiasPrimaAntiguedad OUTPUT, @Faltas OUTPUT, @FaltasAcumulado OUTPUT,
@Incapacidades OUTPUT, @IncapacidadesAcumulado OUTPUT, @IMSSBase OUTPUT, @IMSSBaseAcumulado OUTPUT, @IMSSBaseMes OUTPUT, @AcreedorIMSS OUTPUT,
@AcreedorRetiro OUTPUT, @AcreedorInfonavit OUTPUT, @IMSSVencimiento OUTPUT, @IMSSVencimientoBimestre OUTPUT, @IMSSObrero OUTPUT, @IMSSObreroCV OUTPUT,
@IMSSObreroSinCV OUTPUT, @IMSSPatron OUTPUT, @IMSSPatronMensual OUTPUT, @IMSSPatronCV OUTPUT, @IMSSPatronRetiro OUTPUT, @IMSSPatronInfonavit OUTPUT,
@Antiguedad OUTPUT, @PrimaVacacionalPct OUTPUT, @PrimaVacacional OUTPUT, @DiasVacaciones OUTPUT, @DiasVacacionesSiguiente OUTPUT,
@FactorIntegracion OUTPUT, @InfonavitObrero OUTPUT, @AcumuladoInfonavitObrero OUTPUT, @InfonavitSDI OUTPUT, @InfonavitSMGDF OUTPUT,
@InfonavitImporte OUTPUT, @SeguroRiesgoInfonavit OUTPUT, @PersonalPercepciones OUTPUT, @Mov OUTPUT, @DiasMesInfonavit OUTPUT, @MesI OUTPUT,
@YearI OUTPUT, @InfonavitDias OUTPUT, @DiasBimestreInfonavit OUTPUT, @FechaInicioDescuentoInfonavit OUTPUT, @DiasNaturalesInfonavit OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
IF @NomTipo = 'AJUSTE ANUAL'
BEGIN
SELECT @PersonalPercepciones = 0.0,@CalcularAjusteAnual=0
EXEC spPersonalPropValor  @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Requiere Ajuste Anual', @RequiereAjuste OUTPUT
EXEC spPersonalPropValor  @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Sueldo Maximo para Ajuste de ISR', @SueldoMaxAjuste OUTPUT
SELECT @RequiereAjuste = 'S', @SueldoMaxAjuste = 400000
SELECT @AjusteD =dateadd(day,1,dbo.fnUltimoDiaAno(dateadd(year,-2,@FechaA))),@AjusteA=dbo.fnUltimoDiaAno(dateadd(year,-1,@FechaA))
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'Personal/Percepciones', @AjusteD, @AjusteA, NULL, @PersonalPercepciones OUTPUT, NULL
IF @Estatus='Alta'
IF @RequiereAjuste='S' and @FechaAlta<=@AjusteD and @PersonalPercepciones < @SueldoMaxAjuste
set @CalcularAjusteAnual=1
IF @Estatus='Baja'
IF @RequiereAjuste='S' and @FechaAlta<=@AjusteD and @FechaBaja > = @AjusteA  and @PersonalPercepciones < @SueldoMaxAjuste
SET @CalcularAjusteAnual=1
IF @CalcularAjusteAnual=1
BEGIN
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'ISR/Base', @PrimerDiaAnoAnterior, @UltimoDiaAnoAnterior, NULL, @ISRBaseAcumulado OUTPUT, NULL
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'ISR', @PrimerDiaAnoAnterior, @UltimoDiaAnoAnterior, NULL, @ISRAcumulado OUTPUT, NULL
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'ISR/SubsidioAlEmpleoTabla', @PrimerDiaAnoAnterior, @UltimoDiaAnoAnterior, NULL, @ISRSubsidioAlEmpleoAcumulado OUTPUT, NULL
EXEC spTablaImpuesto 'ISR',     NULL, 'ANUAL', @ISRBaseAcumulado, @ISRAnual OUTPUT
SET @ISRAnual =isnull(@ISRAnual,0)
IF  @ISRAnual < @ISRSubsidioAlEmpleoAcumulado
SELECT @ISRAjusteAnual = @ISRAcumulado
ELSE IF  @ISRAnual > @ISRSubsidioAlEmpleoAcumulado
SELECT @ISRAjusteAnual = (@ISRAnual - @ISRSubsidioAlEmpleoAcumulado) - @ISRAcumulado
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ISR/BaseAcumAnual',   @Empresa, @Personal, @Importe = @ISRBaseAcumulado
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ISR/AcumAnual',   @Empresa, @Personal, @Importe = @ISRAcumulado
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ISR/SubsidioAlEmpleoAcumAnual',@Empresa, @Personal, @Importe = @ISRSubsidioAlEmpleoAcumulado
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ISR/Anual',           @Empresa, @Personal, @Importe = @ISRAnual
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ISR/AjusteAnual',   @Empresa, @Personal, @Importe = @ISRAjusteAnual
END
END	ELSE
SELECT @PercepcionBruta = 0.0
SELECT @PercepcionBruta = @PercepcionBruta + ISNULL(SUM(d.Importe), 0.0)
FROM #Nomina d
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto AND nc.Movimiento = 'Percepcion'
WHERE d.Personal = @Personal
IF ISNULL(@PensionASueldoBruto,0)<>0 OR ISNULL(@PensionASueldoNeto,0) <> 0 OR
ISNULL(@PensionASueldoBruto2,0)<>0 OR ISNULL(@PensionASueldoNeto2,0) <> 0 OR
ISNULL(@PensionASueldoBruto3,0)<>0 OR ISNULL(@PensionASueldoNeto3,0) <> 0
BEGIN
SELECT @CalcImporte = (@PensionASueldoBruto/100.0) * @PercepcionBruta
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'PensionA/SueldoBruto', @Empresa, @Personal, @Importe = @CalcImporte, @Cuenta = @PensionAAcreedor
IF @Nomtipo in('PRESTAMO FONDO AHORR')
SELECT @CalcImporte = (@PensionASueldoNeto/100.0)*(@PercepcionBruta)
ELSE
IF @Nomtipo in('LIQUIDACION FONDO AHORRO')
SELECT @CalcImporte = (@PensionASueldoNeto/100.0)*(@PercepcionBruta-ISNULL(@ISR, 0.0)  - ISNULL(@FondoAhorro,0)- isnull (@FondoAhorroPrestamoAcumulado,0))
ELSE BEGIN
/*      AQUI ESTA LO QUE LE MODIFIQUE ANGEL BC*/
SELECT @ValesDespensaImportePension = (@PensionASueldoNeto/100.0)*(case when @nomtipo in('Normal')then @ValesDespensaImporte else 0 end )
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ValesDespensaPension', @Empresa, @Personal, @Importe = @ValesDespensaImportePension
EXEC spNominaClaveInternaEstaNomina @Personal, 'DESCAUSENTISMOFONDOAHORRO',             NULL,  @DESCAUSENTISMOFONDOAHORRO OUTPUT
EXEC spNominaClaveInternaEstaNomina @Personal, 'DESCAUSENTIMOAYUDAFAMILIAR',            NULL,  @DESCAUSENTIMOAYUDAFAMILIAR OUTPUT
EXEC spNominaClaveInternaEstaNomina @Personal, 'DESCAUSENTHORASFONDOAH',                NULL,  @DESCAUSENTHORASFONDOAH OUTPUT
EXEC spNominaClaveInternaEstaNomina @Personal, 'DESCAUSENTHORASAYUDAFAMIL',             NULL,  @DESCAUSENTHORASAYUDAFAMIL OUTPUT
SELECT @CalcImporte = (@PensionASueldoNeto/100.0)* (ISNULL(@PercepcionBruta ,0.0)
- ISNULL(@ISR, 0.0)
- ISNULL(@FondoAhorro,0)
- ISNULL(@FondoAhorroPrestamoAcumulado,0)
- ISNULL(@DESCAUSENTISMOFONDOAHORRO,0)
- ISNULL(@DESCAUSENTIMOAYUDAFAMILIAR,0)
- ISNULL(@DESCAUSENTHORASFONDOAH,0)
- ISNULL(@DESCAUSENTHORASAYUDAFAMIL,0)
- ISNULL(@Faltasimporte,0) )
IF @NomTipo IN ('NORMAL')
BEGIN
SELECT @Calc = (@PensionASueldoNeto/100.0) * (@ValesDespensaImporte) * -1
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ValesDespensa', @Empresa, @Personal, @Importe = @Calc
END
END
IF 'ESTADISTICA' <> (SELECT Movimiento
FROM NominaConcepto, CfgNominaConcepto
WHERE NominaConcepto.NominaConcepto  = cfgNominaConcepto.NominaConcepto
AND Cfgnominaconcepto.Claveinterna = 'IMSS/Obrero'
)
SELECT @CalcImporte =  @CalcImporte  - ISNULL(@IMSSObrero, 0.0)
SELECT @CalcImporte =  dbo.fnMayor(0,@CalcImporte)
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'PensionA/SueldoNeto', @Empresa, @Personal, @Importe = @CalcImporte, @Cuenta = @PensionAAcreedor
SELECT @CalcImporte = (@PensionASueldoBruto2/100.0)*@PercepcionBruta
SELECT @CalcImporte =  dbo.fnMayor(0,@CalcImporte)
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'PensionA/SueldoBruto', @Empresa, @Personal, @Importe = @CalcImporte, @Cuenta = @PensionAAcreedor2
SELECT @CalcImporte = (@PensionASueldoNeto2/100.0)*(@PercepcionBruta-ISNULL(@IMSSObrero, 0.0)- ISNULL(@FondoAhorro,0))
IF 'ESTADISTICA' <> (SELECT Movimiento
FROM NominaConcepto, CfgNominaConcepto
WHERE NominaConcepto.NominaConcepto  = cfgNominaConcepto.NominaConcepto
AND Cfgnominaconcepto.Claveinterna = 'IMSS/Obrero'
)
SELECT @CalcImporte =  @CalcImporte  - ISNULL(@IMSSObrero, 0.0)
SELECT @CalcImporte =  dbo.fnMayor(0,@CalcImporte)
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'PensionA/SueldoNeto', @Empresa, @Personal, @Importe = @CalcImporte, @Cuenta = @PensionAAcreedor2
SELECT @CalcImporte = (@PensionASueldoBruto3/100.0)*@PercepcionBruta
SELECT @CalcImporte =  dbo.fnMayor(0,@CalcImporte)
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'PensionA/SueldoBruto', @Empresa, @Personal, @Importe = @CalcImporte, @Cuenta = @PensionAAcreedor3
SELECT @CalcImporte = (@PensionASueldoNeto3/100.0)*(@PercepcionBruta-ISNULL(@ISR, 0.0)- ISNULL(@FondoAhorro,0))
IF 'ESTADISTICA' <> (SELECT Movimiento
FROM NominaConcepto, CfgNominaConcepto
WHERE NominaConcepto.NominaConcepto  = cfgNominaConcepto.NominaConcepto
AND Cfgnominaconcepto.Claveinterna = 'IMSS/Obrero'
)
SELECT @CalcImporte =  dbo.fnmayor(0,@CalcImporte  - ISNULL(@IMSSObrero, 0.0))
SELECT @CalcImporte =  dbo.fnMayor(0,@CalcImporte)
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'PensionA/SueldoNeto', @Empresa, @Personal, @Importe = @CalcImporte, @Cuenta = @PensionAAcreedor3
END
DELETE #Nomina
FROM #Nomina n
JOIN NominaConcepto nc ON nc.NominaConcepto = n.NominaConcepto
WHERE nc.NominaConcepto NOT IN(SELECT MovEspecificoNomina.NominaConcepto FROM MovEspecificoNomina WHERE MovEspecificoNomina.MovEspecificoNomina = @Mov)
AND n.Personal = @Personal   and exists(select * from MovEspecificoNomina where MovEspecificoNomina.nominaconcepto= n.NominaConcepto)
IF @MOV  = 'PRESUPUESTO'
UPDATE #NOMINA SET REFERENCIA =@PLAZA WHERE NULLIF(referencia,'') IS NULL and personal=@Personal
SELECT @PersonalPercepciones = 0.0, @PersonalDeducciones = 0.0
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
IF  @NomCxc IN ('PARCIALES', 'COMPLETAS')
AND (@NomTipo NOT IN ('AJUSTE', 'AJUSTE ANUAL') OR  @PersonalEstatus = 'Baja')
AND @Ok IS NULL
BEGIN
SELECT @ConSueldoMinimo = 1
IF @NomTipo IN ('FINIQUITO', 'LIQUIDACION') AND @FiniquitoNetoEnCeros = 0 SELECT @ConSueldoMinimo = 0
IF @PersonalNeto > @SueldoMinimo OR @ConSueldoMinimo = 0
EXEC spNominaCxc @NomCxc, @NomTipo, @Empresa, @Sucursal, @ID, @Personal, @Cliente, @FechaD, @FechaA, @Moneda, @TipoCambio, @ConSueldoMinimo, @SueldoMinimo, @PersonalNeto OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
EXEC spNominaCalcMexicoFinal @Empresa OUTPUT, @Personal OUTPUT, @CalcImporte OUTPUT, @PensionAAcreedor OUTPUT, @PersonalNeto OUTPUT, @PersonalPercepciones OUTPUT, @PersonalDeducciones OUTPUT,
@BeneficiarioSueldoNeto OUTPUT, @Mov OUTPUT, @Plaza OUTPUT, @SeguroAuto OUTPUT, @SeguroMedico OUTPUT, @PensionSueldoNeto OUTPUT,    @Ok OUTPUT,    @OkRef OUTPUT
IF @Ok IS NOT NULL AND @OkRef IS NULL SELECT @OkRef = @Personal
RETURN
END

