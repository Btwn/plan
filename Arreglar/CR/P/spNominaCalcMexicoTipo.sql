SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER   PROCEDURE dbo.spNominaCalcMexicoTipo
@Empresa                           char(5) OUTPUT,
@TipoCambio                        float OUTPUT,
@Personal                          char(10) OUTPUT,
@FechaD                            datetime OUTPUT,
@FechaA                            datetime OUTPUT,
@CfgPrimaDominicalAuto             bit OUTPUT,
@NomTipo                           varchar(50) OUTPUT,
@NomCalcSDI                        bit OUTPUT,
@CfgSubsidioIncapacidadEG          bit OUTPUT,
@CfgFactorintegracionAntiguedad    varchar(20) OUTPUT,
@CfgFactorintegracionTabla         varchar(50) OUTPUT,
@IncidenciaD                       datetime OUTPUT,
@IncidenciaA                       datetime OUTPUT,
@RedondeoMonetarios                int OUTPUT,
@Calc                              float OUTPUT,
@CalcImporte                       money OUTPUT,
@DescansaDomingos                  bit OUTPUT,
@LaboraDomingos                    bit OUTPUT,
@EsBimestre                        bit OUTPUT,
@PrimerDiaMes                      datetime OUTPUT,
@PrimerDiaBimestre                 datetime OUTPUT,
@PersonalEstatus                   varchar(15) OUTPUT,
@SucursalTrabajo                   int OUTPUT,
@Categoria                         varchar(50) OUTPUT,
@Puesto                            varchar(50) OUTPUT,
@Cliente                           varchar(10) OUTPUT,
@Jornada                           varchar(20) OUTPUT,
@SMZ                               money OUTPUT,
@SMDF                              money OUTPUT,
@PrimerDiaAno1                     datetime OUTPUT,
@UltimoDiaAno                      datetime OUTPUT,
@FechaAlta                         datetime OUTPUT,
@FechaAntiguedad                   datetime OUTPUT,
@EsSocio                           bit OUTPUT,
@SDI                               money OUTPUT,
@SDINuevo                          money OUTPUT,
@SueldoPeriodo                     money OUTPUT,
@SueldoDiario                      money OUTPUT,
@DiasMes                           float OUTPUT,
@DiasMesTrabajados                 float OUTPUT,
@DiasBimestre                      float OUTPUT,
@DiasBimestreTrabajados            float OUTPUT,
@DiasAno                           float OUTPUT,
@DiasPeriodo                       float OUTPUT,
@DiasPeriodoSubsidio               float OUTPUT,
@DiasHabilesPeriodo                float OUTPUT,
@DiasPeriodoEstandar               float OUTPUT,
@DiasTrabajados                    float OUTPUT,
@DiasTrabajadosImporte             float OUTPUT,
@DiasNaturales                     float OUTPUT,
@FactorAusentismo                  float OUTPUT,
@DiasNaturalesTrabajados           float OUTPUT,
@DomingosLaborados                 float OUTPUT,
@Faltas                            float OUTPUT,
@FaltasAcumulado                   float OUTPUT,
@FaltasImporte                     money OUTPUT,
@Incapacidades                     float OUTPUT,
@IncapacidadesAcumulado            float OUTPUT,
@IncapacidadesImporte              money OUTPUT,
@ISRLiquidacionGravable            money OUTPUT,
@SubsidoSueldoMensual              money OUTPUT,
@IMSSBase                          money OUTPUT,
@IMSSBaseAcumulado                 money OUTPUT,
@IMSSBaseMes                       money OUTPUT,
@IMSSObrero                        money OUTPUT,
@IMSSObreroCV                      money OUTPUT,
@IMSSObreroSinCV                   money OUTPUT,
@IMSSPatron                        money OUTPUT,
@IMSSPatronMensual                 money OUTPUT,
@IMSSPatronCV                      money OUTPUT,
@IMSSPatronRetiro                  money OUTPUT,
@IMSSPatronInfonavit               money OUTPUT,
@Antiguedad                        float OUTPUT,
@PrimaDominicalPct                 float OUTPUT,
@PrimaDominical                    money OUTPUT,
@PrimaVacacionalPct                float OUTPUT,
@Vacaciones                        money OUTPUT,
@VacacionesTomadas                 float OUTPUT,
@PrimaVacacional                   money OUTPUT,
@PrimaVacacionalProporcion         money OUTPUT,
@DiasVacaciones                    float OUTPUT,
@DiasVacacionesProporcion          float OUTPUT,
@DiasVacacionesSiguiente           float OUTPUT,
@DiasVacacionesAcumulado           float OUTPUT,
@Factorintegracion                 float OUTPUT,
@CajaAhorro                        money OUTPUT,
@CajaAhorroDesde                   datetime OUTPUT,
@CajaAhorroHasta                   datetime OUTPUT,
@FondoAhorroFactorAusentismo       varchar(10) OUTPUT,
@ValesDespensaFactorAusentismo     varchar(10) OUTPUT,
@AyudaFamiliarFactorAusentismo     varchar(10) OUTPUT,
@FondoAhorroPct                    float OUTPUT,
@FondoAhorro                       money OUTPUT,
@FondoAhorro1                      money OUTPUT,
@FondoAhorroAnticipoPct            float OUTPUT,
@FondoAhorroDesde                  datetime OUTPUT,
@FondoAhorroHasta                  datetime OUTPUT,
@EsAniversario                     bit OUTPUT,
@OtorgarDiasVacacionesAniversario  bit OUTPUT,
@OtorgarPrimaVacacionalAniversario bit OUTPUT,
@OtorgarPrimaVacacionalAguinaldo   bit OUTPUT,
@TieneValesDespensa                bit OUTPUT,
@ValesDespensaPct                  float OUTPUT,
@ValesDespensaImporte              money OUTPUT,
@ValesDespensa                     money OUTPUT,
@PremioPuntualidadPct              float OUTPUT,
@AyudaTransportePct	              float OUTPUT,
@PremioAsistenciaPct               float OUTPUT,
@SueldoVariable                    money OUTPUT,
@SubsidioProporcionalFalta         bit OUTPUT,
@Contrato                          varchar(100) OUTPUT,
@MaxID                             int OUTPUT,
@MaxRID                            float OUTPUT,
@IncapacidadesD                    int OUTPUT,
@CuotaSindical                     money OUTPUT,
@Mov                               varchar(20) OUTPUT,
@SDIAnterior                       money OUTPUT,
@SDIVariableDiario                 money OUTPUT,
@SDIBruto                          money OUTPUT,
@FhiAntiguedad                     float OUTPUT,
@AntiguedadSDI	                  float OUTPUT,
@DiasAguinaldoSDI			      float OUTPUT,
@DiasAguinaldoSiguienteSDI	      float OUTPUT,
@AyudaFamiliar                     money OUTPUT,
@TopeFondoAhorro                   money OUTPUT,
@FondoAhorroTipoContrato           varchar(20) OUTPUT,
@Plaza                             varchar(10) OUTPUT,
@Ok                                int  OUTPUT,
@OkRef                             varchar(255) OUTPUT

AS BEGIN
IF @NomTipo IN ('SDI', 'NORMAL', 'AJUSTE', 'FINIQUITO', 'LIQUIDACION', 'H.ASIMILABLE', 'PRIMA VACACIONAL','Prestamo Fondo Ahorr','Liquidacion Fondo Ahorro','Liquidacion Caja Ahorro','Aguinaldo')
BEGIN
IF @NomTipo NOT IN ('LIQUIDACION FONDO AHORRO')
EXEC spNominaAgregarHorasExtras @NomTipo, @Empresa, @Personal, @FechaD, @FechaA, @IncidenciaD, @IncidenciaA, @TipoCambio, @Ok OUTPUT, @OkRef OUTPUT
IF @NomTipo IN ('FINIQUITO', 'LIQUIDACION', 'Liquidacion Caja Ahorro')
BEGIN
INSERT #Nomina (
Personal,  IncidenciaID, IncidenciaRID, NominaConcepto,   Referencia,   Fecha,             Cuenta,     Vencimiento,   Cantidad,   Importe)
SELECT @Personal, d.ID,         d.RID,         d.NominaConcepto, i.Referencia, d.FechaAplicacion, i.Acreedor, i.Vencimiento, d.Cantidad, ROUND(d.Saldo*(i.TipoCambio/NULLIF(@TipoCambio, 0.0)), @RedondeoMonetarios)
FROM IncidenciaD d
JOIN Incidencia i ON i.ID = d.ID AND i.Empresa = @Empresa AND i.Personal = @Personal
AND i.Estatus = 'PENDIENTE'
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto AND nc.Movimiento = 'Percepcion'
WHERE NULLIF(d.Saldo, 0.0) IS NOT NULL
INSERT #Nomina (
Personal,  IncidenciaID, IncidenciaRID, NominaConcepto,   Referencia,   Fecha,             Cuenta,     Vencimiento,   Cantidad,   Importe)
SELECT @Personal, d.ID,         d.RID,         d.NominaConcepto, i.Referencia, d.FechaAplicacion, i.Acreedor, i.Vencimiento, d.Cantidad, ROUND(d.Saldo*(i.TipoCambio/NULLIF(@TipoCambio, 0.0)), @RedondeoMonetarios)
FROM IncidenciaD d
JOIN Incidencia i ON i.ID = d.ID AND i.Empresa = @Empresa AND i.Personal = @Personal
AND i.Estatus = 'PENDIENTE'
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto  AND nc.Movimiento <> 'Percepcion'
WHERE NULLIF(d.Saldo, 0.0) IS NOT NULL
END ELSE  IF @NomTipo NOT IN ('FINIQUITO', 'LIQUIDACION', 'Aguinaldo', 'Liquidacion Caja Ahorro')
INSERT #Nomina (
Personal,  IncidenciaID, IncidenciaRID, NominaConcepto,   Referencia,   Fecha,             Cuenta,     Vencimiento,   Cantidad,   Importe)
SELECT @Personal, d.ID,         d.RID,         d.NominaConcepto, i.Referencia, d.FechaAplicacion, i.Acreedor, i.Vencimiento, d.Cantidad, ROUND(d.Saldo*(i.TipoCambio/NULLIF(@TipoCambio, 0.0)), @RedondeoMonetarios)
FROM IncidenciaD d
JOIN Incidencia i ON i.ID = d.ID AND i.Empresa = @Empresa AND i.Personal = @Personal AND i.Estatus = 'PENDIENTE'
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto
AND( RequiereDiasTrabajados  = 0  OR ( RequiereDiasTrabajados  = 1 AND @NomTipo ='AJUSTE' AND nc.Movimiento <> 'Deduccion'))
WHERE NULLIF(d.Saldo, 0.0) IS NOT NULL  AND d.FechaAplicacion <= @IncidenciaA
DELETE #Nomina
FROM #Nomina n
JOIN NominaConcepto nc ON nc.NominaConcepto = n.NominaConcepto
WHERE nc.NominaConcepto NOT IN(SELECT MovEspecificoNomina.NominaConcepto FROM MovEspecificoNomina WHERE MovEspecificoNomina.MovEspecificoNomina = @Mov)
AND n.Personal = @Personal   and exists(select * from MovEspecificoNomina where MovEspecificoNomina.nominaconcepto= n.NominaConcepto)
EXEC xpNominaCalcIncidencia @NomTipo, @Empresa, @Personal, @FechaD, @FechaA, @IncidenciaD, @IncidenciaA, @TipoCambio, @Ok OUTPUT, @OkRef OUTPUT
SELECT @Faltas = ISNULL(SUM(d.Cantidad), 0), @FaltasImporte = ISNULL(SUM(d.Importe), 0)
FROM #Nomina d
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto AND ISNULL(nc.Especial,'') = 'Faltas'
WHERE d.Personal = @Personal
IF @NomTipo IN ('NORMAL', 'AJUSTE', 'FINIQUITO', 'LIQUIDACION')
BEGIN
EXEC spCalculaAyudaFamiliar @Empresa, @Personal, @AyudaFamiliar OUTPUT
IF ISNULL(@AyudaFamiliar,0) <>0
BEGIN
IF ISNULL(@AyudaFamiliarFactorAusentismo,'N') ='S'
SELECT  @AyudaFamiliar= @AyudaFamiliar / @DiasPeriodo * (@DiasPeriodo -(ISNULL(@Faltas,0) * @FactorAusentismo))
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'AyudaFamiliar', @Empresa, @Personal,@DiasPeriodo, @AyudaFamiliar
END
END
IF @NomTipo IN ('NORMAL', 'FINIQUITO', 'LIQUIDACION','H.ASIMILABLE','Prima Vacacional')
BEGIN
EXEC spNominaClaveInternaEstaNomina @Personal, 'Vacaciones', @VacacionesTomadas OUTPUT
SELECT @VacacionesTomadas = isnull(@VacacionesTomadas,0)
SELECT @DiasPeriodo = @DiasPeriodo -  @VacacionesTomadas
SELECT @SueldoPeriodo = @SueldoDiario * @DiasPeriodo
SELECT @Plaza = Plaza from personal where personal = @Personal
IF @mov = 'presupuesto'
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Sueldo', @Empresa, @Personal, @DiasPeriodo, @SueldoPeriodo , @referencia =@Plaza
ELSE
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Sueldo', @Empresa, @Personal, @DiasPeriodo, @SueldoPeriodo
EXEC spCalculaValesDespensa @Empresa, @Personal, @ValesDespensa OUTPUT
IF ISNULL(@ValesDespensa,0) <> 0
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ValesDespensa', @Empresa, @Personal, @DiasPeriodo, @ValesDespensa
EXEC spCalculaCuotaSindical  @Empresa, @Personal, @FechaD, @FechaA, @Mov, @CuotaSindical OUTPUT
IF  ISNULL(@CuotaSindical ,0)<>0.0
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'CuotaSindical', @Empresa, @Personal, @DiasPeriodo, @CuotaSindical
SELECT @DiasPeriodo = @DiasPeriodo +  @VacacionesTomadas
END
SELECT @Incapacidades = ISNULL(SUM(d.Cantidad), 0), @IncapacidadesImporte = ISNULL(SUM(d.Importe), 0)
FROM #Nomina d
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto AND ISNULL(nc.Especial,'') = 'Incapacidades'
WHERE d.Personal = @Personal
WHILE @Incapacidades > @DiasPeriodo AND @Incapacidades > 0 AND @PersonalEstatus='ALTA'
BEGIN
SELECT @MaxID = ISNULL(MAX (IncidenciaID), 0), @MaxRID= ISNULL(MAX (IncidenciaRID), 0)
FROM #Nomina d
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto AND ISNULL(nc.Especial,'') = 'Incapacidades'
WHERE d.Personal = @Personal
DELETE #Nomina WHERE IncidenciaID = @Maxid AND IncidenciaRID=@MaxRid
SELECT @Incapacidades = ISNULL(SUM(d.Cantidad), 0), @IncapacidadesImporte = ISNULL(SUM(d.Importe), 0)
FROM #Nomina d
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto AND ISNULL(nc.Especial,'') = 'Incapacidades'
WHERE d.Personal = @Personal
END
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'Incapacidades', @FechaD, @FechaA, NULL, NULL, @IncapacidadesD OUTPUT
WHILE (@Incapacidades+@IncapacidadesD) > @DiasPeriodo and (@Incapacidades+@IncapacidadesD) > 0  and (@IncapacidadesD <= @DiasPeriodo) AND @PersonalEstatus='ALTA'
BEGIN
SELECT @MaxID = ISNULL(MAX (IncidenciaID), 0), @MaxRID= ISNULL(MAX (IncidenciaRID), 0)
FROM #Nomina d
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto AND ISNULL(nc.Especial,'') = 'Incapacidades'
WHERE d.Personal = @Personal
DELETE #Nomina WHERE IncidenciaID = @Maxid AND IncidenciaRID=@MaxRid
SELECT @Incapacidades = ISNULL(SUM(d.Cantidad), 0), @IncapacidadesImporte = ISNULL(SUM(d.Importe), 0)
FROM #Nomina d
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto AND ISNULL(nc.Especial,'') = 'Incapacidades'
WHERE d.Personal = @Personal
END
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Faltas', @Empresa, @Personal, @Faltas, @FaltasImporte
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Incapacidades', @Empresa, @Personal, @Incapacidades, @IncapacidadesImporte
IF @SubsidioProporcionalFalta = 1
SELECT @DiasPeriodoSubsidio = (@DiasPeriodo - @Incapacidades) - (@Faltas * ( @DiasPeriodo/@DiasHabilesPeriodo ))
ELSE
SELECT @DiasPeriodoSubsidio = (@DiasPeriodo - @Incapacidades) - @Faltas
SELECT @SueldoVariable = ISNULL(SUM(d.Importe), 0)
FROM #Nomina d
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto AND nc.SueldoVariable = 1
WHERE d.Personal = @Personal
IF @NomTipo = 'AJUSTE'
BEGIN
EXEC spNominaClaveInternaEstaNomina @Personal, 'Sueldo', @DiasNaturales OUTPUT
SELECT @DiasPeriodo = @DiasNaturales
END
EXEC spNominaClaveInternaEstaNomina @Personal, 'Vacaciones', @VacacionesTomadas OUTPUT
SELECT @Calc = -@VacacionesTomadas
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'DiasVacaciones', @Empresa, @Personal, @Calc
SELECT @DiasNaturalesTrabajados = dbo.fnMayor(0, @DiasNaturales - @Faltas - @Incapacidades)
SELECT @DiasTrabajados = @DiasPeriodo - @Incapacidades - @Faltas
IF @NomTipo NOT IN ('AJUSTE','LIQUIDACION FONDO AHORRO') AND @DiasTrabajados<0.0 SELECT @DiasTrabajados = 0.0
SELECT @DiasTrabajadosImporte = (@SueldoDiario*@DiasPeriodo) + @SueldoVariable - @FaltasImporte - @IncapacidadesImporte
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'DiasPeriodo',   @Empresa, @Personal, @DiasPeriodo
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'DiasNaturales',   @Empresa, @Personal, @DiasNaturales
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'DiasTrabajados',   @Empresa, @Personal, @DiasTrabajados, @DiasTrabajadosImporte
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'DiasTrabajadosSubsidio',   @Empresa, @Personal, @DiasPeriodoSubsidio, 0
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Personal/SDI',   @Empresa, @Personal, @Importe = @SDI
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Personal/SueldoDiario',  @Empresa, @Personal, @Importe = @SueldoDiario
IF @DiasTrabajados > 0
BEGIN
IF @NomTipo NOT IN ('FINIQUITO', 'LIQUIDACION', 'AJUSTE', 'SDI', 'LIQUIDACION FONDO AHORRO', 'AGUINALDO') 
BEGIN
INSERT #Nomina (
Personal,  IncidenciaID, IncidenciaRID, NominaConcepto,   Referencia,   Cuenta,     Vencimiento,   Cantidad,   Importe)
SELECT @Personal, d.ID,         d.RID,         d.NominaConcepto, i.Referencia, i.Acreedor, i.Vencimiento, d.Cantidad, ROUND(d.Saldo*(i.TipoCambio/NULLIF(@TipoCambio, 0.0)), @RedondeoMonetarios)
FROM IncidenciaD d
JOIN Incidencia i ON i.ID = d.ID AND i.Empresa = @Empresa AND i.Personal = @Personal AND i.Estatus = 'PENDIENTE'
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto AND RequiereDiasTrabajados = 1
WHERE NULLIF(d.Saldo, 0.0) IS NOT NULL AND d.FechaAplicacion <= @IncidenciaA
END
IF @NomTipo  IN ('AJUSTE')
INSERT #Nomina (
Personal,  IncidenciaID, IncidenciaRID, NominaConcepto,   Referencia,   Cuenta,     Vencimiento,   Cantidad,   Importe)
SELECT @Personal, d.ID,         d.RID,         d.NominaConcepto, i.Referencia, i.Acreedor, i.Vencimiento, d.Cantidad, ROUND(d.Saldo*(i.TipoCambio/NULLIF(@TipoCambio, 0.0)), @RedondeoMonetarios)
FROM IncidenciaD d
JOIN Incidencia i ON i.ID = d.ID AND i.Empresa = @Empresa AND i.Personal = @Personal AND i.Estatus = 'PENDIENTE'
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto AND  RequiereDiasTrabajados  = 1 AND nc.Movimiento = 'Deduccion'
WHERE NULLIF(d.Saldo, 0.0) IS NOT NULL AND d.FechaAplicacion <= @IncidenciaA
END
IF @CfgPrimaDominicalAuto = 1 AND (@DescansaDomingos = 1 OR @LaboraDomingos = 1) AND @NomTipo = 'NORMAL'
BEGIN
IF @FechaAlta <= @IncidenciaA
BEGIN
EXEC spNominaDomingosLaborados @Empresa, @Personal, @FechaD, @FechaA, @IncidenciaD, @IncidenciaA, @DomingosLaborados OUTPUT
SELECT @PrimaDominical = Round(@DomingosLaborados * Round((@SueldoDiario * Round( (@PrimaDominicalPct/100.0) ,2)),2),2)
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'PrimaDominical', @Empresa, @Personal, @DomingosLaborados, @PrimaDominical
END
END
IF @NomTipo in('NORMAL', 'PRIMA VACACIONAL','SDI')
BEGIN 
IF @OtorgarDiasVacacionesAniversario = 0 AND @OtorgarPrimaVacacionalAniversario = 0
BEGIN
EXEC spNominaClaveInternaEstaNomina @Personal, 'Vacaciones', @DiasVacaciones OUTPUT
IF @DiasVacaciones > 0
BEGIN
SELECT @PrimaVacacionalPct = CASE WHEN ISNUMERIC(Valor)=1 THEN
CONVERT(tinyint,Valor)  ELSE NULL END
FROM PersonalPropValor
WHERE Cuenta = @Empresa
AND Rama = 'EMP'
AND Propiedad = '% Prima Vacacional'
IF @PrimaVacacionalPct IS NULL
EXEC spTablaNum 'PRIMA VACACIONAL', @Antiguedad, @PrimaVacacionalPct OUTPUT
END
IF @OtorgarDiasVacacionesAniversario = 0
IF  @OtorgarPrimaVacacionalAguinaldo = 1 AND ISNULL(@DiasVacaciones,0) = 0
BEGIN
IF ISNULL(@DiasVacaciones,0) = 0
EXEC spTablaNum 'VACACIONES', @Antiguedad, @DiasVacaciones OUTPUT
IF YEAR(@FechaA) = YEAR(@FechaAntiguedad)
BEGIN
SELECT @DiasVacaciones = 0.0 + @DiasVacaciones * (DATEDIFF(day, @PrimerDiaAno1, @UltimoDiaAno)+1.0)/@DiasAno
SELECT @DiasAguinaldoSiguienteSDI = 0.0+ @DiasAguinaldoSiguienteSDI* (( DATEDIFF(day, @FechaAntiguedad, @UltimoDiaAno)+1.0)/ (DATEDIFF(day, @PrimerDiaAno1, @UltimoDiaAno)+1.0))
SELECT @DiasAguinaldoSDI = @DiasAguinaldoSDI * (( DATEDIFF(day, @FechaAntiguedad, @UltimoDiaAno)+1.0) / (DATEDIFF(day, @PrimerDiaAno1, @UltimoDiaAno)+1.0))
END
END
SELECT @PrimaVacacional = @SueldoDiario * @DiasVacaciones * (@PrimaVacacionalPct / 100.0)
END
IF (@OtorgarPrimaVacacionalAguinaldo = 1 AND @NomTipo='PRIMA VACACIONAL')
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'PrimaVacacional', @Empresa, @Personal, @DiasVacaciones, @PrimaVacacional
END
EXEC spNominaMexicoCalcSdi @Empresa,@SucursalTrabajo, @Categoria, @Puesto, @Personal, @NomTipo, @EsSocio, @SDI, @DiasNaturales,@Incapacidades, @Faltas, @SMDF,
@EsBimestre, @NomCalcSDI, @PrimerDiaBimestre, @FechaA, @DiasAguinaldoSiguienteSDI, @DiasAguinaldoSDI, @PrimaVacacionalPct, @DiasVacacionesSiguiente, @DiasAno,
@DiasVacaciones, @AntiguedadSDI, @DiasBimestre, @DiasBimestreTrabajados, @SueldoDiario, @SDIAnterior, @SDIVariableDiario, @SDINuevo, @FechaAntiguedad, @SDIBruto,
@FhiAntiguedad, @ISRLiquidacionGravable, @CfgFactorIntegracionAntiguedad, @FaltasAcumulado OUTPUT, @IncapacidadesAcumulado	OUTPUT, @FactorIntegracion	OUTPUT,
@IMSSObrero	OUTPUT,  @IMSSObreroCV	OUTPUT, @IMSSPatron	OUTPUT, @IMSSPatronMensual	OUTPUT, @IMSSPatronCV	OUTPUT, @IMSSPatronRetiro	OUTPUT,
@IMSSPatronInfonavit	OUTPUT, @IMSSBase	OUTPUT,  @IMSSBaseMes	OUTPUT, @IMSSBaseAcumulado	OUTPUT, @IMSSObreroSinCV	OUTPUT, @Ok	OUTPUT, @CfgFactorIntegracionTabla	OUTPUT, @OkRef	OUTPUT
IF @NomTipo = 'NORMAL' AND @EsAniversario = 1
BEGIN
IF @OtorgarDiasVacacionesAniversario = 1
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'DiasVacaciones', @Empresa, @Personal, @DiasVacaciones
IF @OtorgarPrimaVacacionalAniversario = 1
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'PrimaVacacional', @Empresa, @Personal, @DiasVacaciones, @PrimaVacacional
END ELSE
IF @NomTipo IN ('FINIQUITO', 'LIQUIDACION')
BEGIN
IF @OtorgarPrimaVacacionalAguinaldo = 0
BEGIN
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'DiasVacaciones', @FechaAntiguedad, @FechaA, NULL, NULL, @DiasVacacionesAcumulado OUTPUT
SELECT @Calc = -@DiasVacacionesAcumulado
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'DiasVacaciones', @Empresa, @Personal, @Calc
SELECT @Vacaciones = @SueldoDiario * (@DiasVacacionesProporcion + @DiasVacacionesAcumulado)
Select @DiasVacacionesProporcion= @DiasVacacionesProporcion + @DiasVacacionesAcumulado
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Vacaciones', @Empresa, @Personal, @DiasVacacionesProporcion, @Vacaciones
SELECT @DiasVacacionesProporcion =  @DiasVacacionesProporcion - @DiasVacacionesAcumulado
SELECT @PrimaVacacionalProporcion = @SueldoDiario * @DiasVacacionesProporcion * (@PrimaVacacionalPct/100.0)
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'PrimaVacacional', @Empresa, @Personal, @DiasVacacionesProporcion, @PrimaVacacionalProporcion
END ELSE
BEGIN
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'DiasVacaciones', @FechaAntiguedad, @FechaA, NULL, NULL, @DiasVacacionesAcumulado OUTPUT
SELECT @Calc = -@DiasVacacionesAcumulado
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'DiasVacaciones', @Empresa, @Personal, @Calc
SELECT @Vacaciones = @SueldoDiario * (@DiasVacacionesProporcion + @DiasVacacionesAcumulado)
SELECT @DiasVacacionesProporcion= @DiasVacacionesProporcion + @DiasVacacionesAcumulado
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Vacaciones', @Empresa, @Personal, @DiasVacacionesProporcion, @Vacaciones
SELECT @DiasVacacionesProporcion =  @DiasVacacionesProporcion - @DiasVacacionesAcumulado
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'PrimaVacacional', @Empresa, @Personal, @DiasVacacionesProporcion, @PrimaVacacionalProporcion
END
END
IF @TieneValesDespensa = 1  AND @NomTipo IN ('NORMAL', 'FINIQUITO', 'LIQUIDACION')  
BEGIN
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'Faltas', @PrimerDiaMes, @FechaA, NULL, NULL, @FaltasAcumulado OUTPUT
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'Incapacidades', @PrimerDiaMes, @FechaA, NULL, NULL, @IncapacidadesAcumulado OUTPUT
SELECT @DiasMesTrabajados = dbo.fnMayor(0, @DiasMes - @Faltas - @FaltasAcumulado - @Incapacidades - @IncapacidadesAcumulado)
SELECT @ValesDespensaImporte = @ValesDespensaImporte + (@SueldoDiario*@DiasMesTrabajados*(@ValesDespensaPct/100.0))
IF ISNULL(@ValesDespensaImporte,0) <>0
BEGIN
IF ISNULL(@ValesDespensaFactorAusentismo,'NO') = 'S'
SELECT @ValesDespensaImporte = @ValesDespensaImporte / @DiasPeriodo * ( @DiasPeriodo -(@Faltas * @FactorAusentismo))
IF @NomTipo IN ('NORMAL')
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ValesDespensa', @Empresa, @Personal, @Importe = @ValesDespensaImporte
END
END
IF @PremioPuntualidadPct > 0.0 AND @NomTipo IN ('NORMAL', 'FINIQUITO', 'LIQUIDACION')
BEGIN
SELECT @CalcImporte = @DiasTrabajados*@SueldoDiario*(@PremioPuntualidadPct/100.0)
IF @Jornada in('Horario Completo')
SELECT @CalcImporte =@CalcImporte
IF @Contrato in ('TIEMPO DETERMINADO','TIEMPO INDETERMINADO')
IF @mov='presupuesto'
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'PremioPuntualidad', @Empresa, @Personal, @DiasTrabajados, @CalcImporte, @referencia=@Plaza
ELSE
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'PremioPuntualidad', @Empresa, @Personal, @DiasTrabajados, @CalcImporte
END
IF @PremioAsistenciaPct > 0.0 AND @NomTipo IN ('NORMAL', 'FINIQUITO', 'LIQUIDACION')
BEGIN
SELECT @CalcImporte = @DiasTrabajados*@SueldoDiario*(@PremioAsistenciaPct/100.0)
IF @Mov='Presupuesto'
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'PremioAsistencia', @Empresa, @Personal, @DiasTrabajados, @CalcImporte , @referencia=@Plaza
ELSE
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'PremioAsistencia', @Empresa, @Personal, @DiasTrabajados, @CalcImporte
END
IF @NomTipo IN ('NORMAL')
BEGIN
IF NULLIF(@CajaAhorro, 0.0) IS NOT NULL AND ((@FechaD BETWEEN @CajaAhorroDesde AND @CajaAhorroHasta) OR (@FechaA BETWEEN @CajaAhorroDesde AND @CajaAhorroHasta))
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'CajaAhorro', @Empresa, @Personal, @Importe = @CajaAhorro
END
IF @NomTipo IN ('NORMAL', 'AJUSTE') AND ABS(@DiasTrabajados) > 0
BEGIN
SELECT @FondoAhorro1 = ISNULL(@FondoAhorro, 0.0) + ((@FondoAhorroPct/100)*@SueldoDiario*@DiasPeriodo+1)
IF  @FondoAhorro1 < (@SMZ * 10.0 * @DiasPeriodoEstandar * 0.13)
BEGIN
IF @FondoAhorroFactorAusentismo = 'S'
SELECT @FondoAhorro = ISNULL(@FondoAhorro, 0.0) + ((@FondoAhorroPct/100)* @SueldoDiario * (@DiasPeriodo - (@Faltas * @FactorAusentismo)) )
ELSE
SELECT @FondoAhorro = ISNULL(@FondoAhorro, 0.0) + ((@FondoAhorroPct/100)* @SueldoDiario * @DiasPeriodo )
END ELSE
IF @FondoAhorroFactorAusentismo = 'S'
SELECT @FondoAhorro =  (@SMZ * 10.0 * @DiasPeriodoEstandar * 0.13 ) / @Diasperiodo *(@DiasPeriodo - (@Faltas * @FactorAusentismo))
ELSE
SELECT @FondoAhorro =  (@SMZ * 10.0 * @DiasPeriodoEstandar * 0.13 ) / @Diasperiodo *(@DiasPeriodo /*- (@Faltas)*/)
IF NULLIF(@FondoAhorro, 0.0) IS NOT NULL AND ((@FechaD BETWEEN @FondoAhorroDesde AND @FondoAhorroHasta) OR (@FechaA BETWEEN @FondoAhorroDesde AND @FondoAhorroHasta))
BEGIN
IF ISNULL(NULLIF(@TopeFondoAhorro, 0), 0) > 0
IF @FondoAhorro > @TopeFondoAhorro
SELECT @FondoAhorro = @TopeFondoAhorro
IF RTRIM(@FondoAhorroTipoContrato) <> ''
IF @Contrato <> @FondoAhorroTipoContrato
SELECT @FondoAhorro = 0
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'FondoAhorro',      @Empresa, @Personal, @DiasPeriodo, @FondoAhorro
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'FondoAhorro/Patron',          @Empresa, @Personal, @DiasPeriodo, @Importe = @FondoAhorro
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'FondoAhorro/PatronPercepcion', @Empresa, @Personal, @DiasPeriodo, @Importe = @FondoAhorro
SELECT @CalcImporte = (@FondoAhorro*2)*(@FondoAhorroAnticipoPct/100.0)
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'FondoAhorro/Anticipo', @Empresa, @Personal, @Importe = @CalcImporte
END
END
IF @CfgSubsidioIncapacidadEG = 1 AND @NomTipo IN ('NORMAL', 'FINIQUITO', 'LIQUIDACION')
IF @Contrato='PERMANENTE'
EXEC spNominaSubsidioIncapacidadEG @Empresa, @Personal, @SueldoDiario, @SDI, @Ok OUTPUT, @OkRef OUTPUT
END
END

