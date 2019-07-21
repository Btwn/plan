SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER   PROCEDURE dbo.spNominaCalcMexicoNomina
@Empresa                         char(5) OUTPUT,
@Sucursal                        int OUTPUT,
@ID                              int OUTPUT,
@Moneda                          char(10) OUTPUT,
@TipoCambio                      float OUTPUT,
@Personal                        char(10) OUTPUT,
@FechaD                          datetime OUTPUT,
@FechaA                          datetime OUTPUT,
@PeriodoTipo                     varchar(20) OUTPUT,
@CfgAjusteMensualISR             bit OUTPUT,
@CfgISRReglamentoAguinaldo       bit OUTPUT,
@CfgISRReglamentoPTU             bit OUTPUT,
@NomTipo                         varchar(50) OUTPUT,
@EsFinMes                        bit OUTPUT,
@PrimerDiaMes                    datetime OUTPUT,
@PrimerDiaMesAnterior            datetime OUTPUT,
@UltimoDiaMesAnterior            datetime OUTPUT,
@UltimoDiaMes                    datetime OUTPUT,
@SucursalTrabajoEstado           varchar(50) OUTPUT,
@SMZ                             money OUTPUT,
@SMZTopeHorasDobles              float OUTPUT,
@SDI                             money OUTPUT,
@SueldoMensual                   money OUTPUT,
@SueldoMensualReglamento         money OUTPUT,
@DiasMes                         float OUTPUT,
@DiasAno                         float OUTPUT,
@DiasPeriodo                     float OUTPUT,
@DiasPeriodoSubsidio             float OUTPUT,
@ISR                             money OUTPUT,
@ISRAcumulado                    money OUTPUT,
@ISRBruto                        money OUTPUT,
@ISRVencimiento                  datetime OUTPUT,
@ISRCreditoAlSalarioTabla        money OUTPUT,
@ISRSubsidioAlEmpleoTabla        money OUTPUT,
@ISRSubsidioAlEmpleoAcumulado    money OUTPUT,
@ISRBase                         money OUTPUT,
@ISRBaseMes                      money OUTPUT,
@ISRBaseAcumulado                money OUTPUT,
@ISRReglamentoBase               float OUTPUT,
@ISRReglamentoFactor             float OUTPUT,
@ISRSueldoMensual                money OUTPUT,
@ISRSueldoMensualReglamento      money OUTPUT,
@IMSSBase                        money OUTPUT,
@ImpuestoEstatalBase             money OUTPUT,
@CedularBase                     money OUTPUT,
@AcreedorISR                     varchar(10) OUTPUT,
@Antiguedad                      float OUTPUT,
@PercepcionBruta                 money OUTPUT,
@IndemnizacionTope               money OUTPUT,
@Mov                             varchar(20) OUTPUT,
@NuevoImporteISR                 money OUTPUT,
@NuevoImporteCAS                 money OUTPUT,
@DiasPeriodoMes                  int OUTPUT,
@DiasTrabajadosSubsidioAcumulado float OUTPUT,
@DiasTrabajadosImporteSubsidio   money OUTPUT,
@EsISRReglamento                 bit OUTPUT,
@Ok                              int  OUTPUT,
@OkRef                           varchar(255) OUTPUT

AS BEGIN
IF @NomTipo NOT IN ('AJUSTE ANUAL','SDI','IMPUESTO ESTATAL','LIQUIDACION FONDO AHORRO','SUELDO COMPLEMENTO')
BEGIN
EXEC spNominaGrava @Empresa, @Sucursal, @ID, @Personal, @SucursalTrabajoEstado, @FechaD, @FechaA, @Moneda, @TipoCambio,
@SMZ, @SMZTopeHorasDobles, @SDI, @DiasPeriodo, @DiasMes, @DiasAno, @Antiguedad, @IndemnizacionTope,
@ISRBase OUTPUT, @IMSSBase OUTPUT, @ImpuestoEstatalBase OUTPUT, @CedularBase OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
SELECT @PercepcionBruta = 0.0
SELECT @PercepcionBruta = @PercepcionBruta + ISNULL(SUM(d.Importe), 0.0)
FROM #Nomina d
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto AND nc.Movimiento = 'Percepcion'
WHERE d.Personal = @Personal
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ISR/Base',   @Empresa, @Personal, @Importe = @ISRBase
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'IMSS/Base',   @Empresa, @Personal, @Importe = @IMSSBase
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ImpuestoEstatal/Base', @Empresa, @Personal, @Importe = @ImpuestoEstatalBase
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Cedular/Base',  @Empresa, @Personal, @Importe = @CedularBase
SELECT @EsIsrReglamento = 0
SELECT @EsIsrReglamento = isnull(EsIsrReglamento,0) FROM MovTipo WHERE  Modulo = 'NOM' AND Mov = @Mov
IF  (@CfgAjusteMensualISR = 1 AND @EsFinMes = 1)
OR @NomTipo IN ('FINIQUITO', 'LIQUIDACION', 'AGUINALDO', 'PTU', 'Prima Vacacional')
OR (@EsIsrReglamento = 1)
BEGIN
IF (@NomTipo = 'AGUINALDO' AND @CfgISRReglamentoAguinaldo = 1)
OR (@NomTipo = 'PTU' AND @CfgISRReglamentoPTU = 1)
OR (@NomTipo = 'Prima Vacacional' AND @CfgISRReglamentoAguinaldo = 1)
OR (@EsIsrReglamento = 1)
BEGIN
SELECT @SueldoMensualReglamento=0
if @MOV='BONO'
SELECT @ISRReglamentoBase = @ISRBase / 90.0 * 30.4
ELSE
SELECT @ISRReglamentoBase = @ISRBase / 365.0 * 30.4
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'ISR', @PrimerDiaMesAnterior, @UltimoDiaMesAnterior, NULL, @SueldoMensualReglamento OUTPUT, NULL
SELECT @SueldoMensualReglamento = @SueldoMensual+ @ISRReglamentoBase
EXEC spTablaImpuesto 'ISR',     NULL, 'MENSUAL', @SueldoMensual, @ISRSueldoMensual OUTPUT
SELECT @ISRSueldoMensual = @ISRSueldoMensual
EXEC spTablaImpuesto 'ISR',     NULL, 'MENSUAL', @SueldoMensualReglamento, @ISRSueldoMensualReglamento OUTPUT
SELECT @ISRReglamentoFactor = (@ISRSueldoMensualReglamento - @ISRSueldoMensual) / NULLIF(@ISRReglamentoBase, 0.0)
SELECT @ISR = @ISRBase * @ISRReglamentoFactor
END ELSE
BEGIN
IF @NomTipo IN ('AGUINALDO','PTU','Prima Vacacional')
BEGIN
EXEC spTablaImpuesto 'ISR',     NULL, 'MENSUAL', @ISRBase, @ISRSueldoMensual OUTPUT
SELECT @ISRSueldoMensual = @ISRSueldoMensual 
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ISR', @Empresa, @Personal, @Importe = @ISRSueldoMensual, @Cuenta = @AcreedorISR, @Vencimiento = @ISRVencimiento
END
IF @NomTipo NOT IN ('AGUINALDO','PTU','Prima Vacacional')
BEGIN
IF @EsFinMEs = 0
BEGIN
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'ISR/Base',             @PrimerDiaMes, @FechaA, NULL, @ISRBaseAcumulado OUTPUT, NULL
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'ISR',                  @PrimerDiaMes, @FechaA, NULL, @ISRAcumulado OUTPUT, NULL
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'ISR/SubsidioAlEmpleo', @PrimerDiaMes, @FechaA, NULL, @ISRSubsidioAlEmpleoAcumulado OUTPUT, NULL
END ELSE
BEGIN
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'ISR/Base',             @PrimerDiaMes, @UltimoDiaMes, NULL, @ISRBaseAcumulado OUTPUT, NULL
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'ISR',                  @PrimerDiaMes, @UltimoDiaMes, NULL, @ISRAcumulado OUTPUT, NULL
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'ISR/SubsidioAlEmpleo', @PrimerDiaMes, @UltimoDiaMes, NULL, @ISRSubsidioAlEmpleoAcumulado OUTPUT, NULL
END
SELECT @DiasTrabajadosSubsidioAcumulado = ISNULL(@DiasTrabajadosSubsidioAcumulado, 0)
SELECT @ISRBaseAcumulado = ISNULL(@ISRBaseAcumulado, 0)
SELECT @ISRBaseMes = @ISRBaseAcumulado + @ISRBase
IF  @NomTipo = 'H.ASIMILABLE' 
BEGIN
EXEC spNominaISRSubsidioAlEmpleoProporcional	@DiasPeriodo,	@DiasPeriodoSubsidio, @DiasMes ,@ISRBaseMes, @ISR	OUTPUT,	@ISRSubsidioAlEmpleoTabla		OUTPUT,	@ISRBruto	OUTPUT
SELECT @ISR = @ISRBruto
SELECT @ISR = ROUND(@ISR,2) 
SELECT @ISR = @ISR - @ISRAcumulado , @ISRCreditoAlSalarioTabla = 0 
END ELSE
BEGIN
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'DiasTrabajadosSubsidio', @PrimerDiaMes, @FechaA, NULL, @DiasTrabajadosImporteSubsidio OUTPUT, @DiasTrabajadosSubsidioAcumulado OUTPUT
SELECT @DiasTrabajadosSubsidioAcumulado = ISNULL(@DiasTrabajadosSubsidioAcumulado, 0)
SELECT @ISRBaseAcumulado = @ISRBaseAcumulado + @ISRBase
SELECT @DiasTrabajadosSubsidioAcumulado =  isnull(@DiasPeriodoSubsidio,0) +  isnull(@DiasTrabajadosSubsidioAcumulado ,0)
IF @Mov='PRESUPUESTO'
BEGIN
SELECT   @DIASPERIODOMES=@DiasMes,@DiasTrabajadosSubsidioAcumulado=@DiasMes
END
EXEC spNominaISRSubsidioAlEmpleoProporcional	@DIASPERIODOMES,	@DiasTrabajadosSubsidioAcumulado, @DiasMes,@ISRBaseAcumulado, @ISR	OUTPUT,	@ISRSubsidioAlEmpleoTabla	OUTPUT,	@ISRBruto	OUTPUT, @esfinmes
SELECT @ISR=ROUND(@ISR,2),@ISRSubsidioAlEmpleoTabla =ROUND(@ISRSubsidioAlEmpleoTabla,2), @ISRBruto =ROUND(@ISRBruto,2) 
END
END
END
END ELSE  
BEGIN
IF  @NomTipo = 'H.ASIMILABLE'
BEGIN
EXEC spNominaISRSubsidioAlEmpleoProporcional	@DiasPeriodo,	@DiasPeriodoSubsidio, @DiasMes ,@ISRBase, @ISR	OUTPUT,	@ISRSubsidioAlEmpleoTabla	OUTPUT,	@ISRBruto	OUTPUT
SELECT @ISR = ROUND(@ISRBruto,2)
SELECT @ISRCreditoAlSalarioTabla = 0
END ELSE
IF @PeriodoTipo = 'SEMANAL'
BEGIN
EXEC spNominaISRSubsidioAlEmpleoProporcional	@DiasPeriodo,	@DiasPeriodoSubsidio, @DiasMes ,@ISRBase, @ISR	OUTPUT,	@ISRSubsidioAlEmpleoTabla	OUTPUT,	@ISRBruto	OUTPUT
END ELSE
BEGIN
SELECT @DiasTrabajadosSubsidioAcumulado = ISNULL(@DiasTrabajadosSubsidioAcumulado, 0)
SELECT @ISRBaseAcumulado = ISNULL(@ISRBaseAcumulado, 0)
EXEC spNominaISRSubsidioAlEmpleoProporcional	@DiasPeriodo,	@DiasPeriodoSubsidio, @DiasMes ,@ISRBase, @ISR	OUTPUT,	@ISRSubsidioAlEmpleoTabla	OUTPUT,	@ISRBruto	OUTPUT
END
END
IF @ISR < 0.0
BEGIN
IF @EsFinMes = 1
BEGIN
SELECT @NuevoImporteISR = 0
SELECT @NuevoImporteISR = @ISRAcumulado * -1
IF @NuevoImporteISR <> 0
BEGIN
IF @PeriodoTipo = 'SEMANAL'
BEGIN
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ISR', @Empresa, @Personal, @Importe = @NuevoImporteISR, @Cuenta = @AcreedorISR, @Vencimiento = @ISRVencimiento
EXEC spNominaISRSubsidioAlEmpleoProporcional	@DiasMES,	@DiasTrabajadosSubsidioAcumulado, @DiasMes ,@ISRBaseMEs, @ISR	OUTPUT,	@ISRSubsidioAlEmpleoTabla	OUTPUT,	@ISRBruto	OUTPUT
END ELSE
BEGIN
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ISR', @Empresa, @Personal, @Importe = @NuevoImporteISR, @Cuenta = @AcreedorISR, @Vencimiento = @ISRVencimiento
EXEC spNominaISRSubsidioAlEmpleoProporcional	@DiasMes,	@DiasTrabajadosSubsidioAcumulado, @DiasMes ,@ISRBaseMes, @ISR	OUTPUT,	@ISRSubsidioAlEmpleoTabla	OUTPUT,	@ISRBruto	OUTPUT
END
END
SELECT @ISR = @ISR - @ISRSubsidioAlEmpleoAcumulado
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ISR/SubsidioAlEmpleo', @Empresa, @Personal, @Importe = @ISR, @Cuenta = @AcreedorISR, @Vencimiento = @ISRVencimiento
END ELSE
BEGIN
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ISR/SubsidioAlEmpleo', @Empresa, @Personal, @Importe = @ISR, @Cuenta = @AcreedorISR, @Vencimiento = @ISRVencimiento
END
END ELSE
BEGIN
IF @EsFinMes=1  AND @NomTipo <> 'Prima Vacacional' and @EsISrReglamento <>1
BEGIN
SELECT @NuevoImporteCAS=0
SELECT @NuevoImporteCAS = @ISRSubsidioAlEmpleoAcumulado * -1
IF @NuevoImporteCAS<>0
BEGIN
IF @PeriodoTipo = 'SEMANAL'
BEGIN
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ISR/SubsidioAlEmpleo', @Empresa, @Personal, @Importe = @NuevoImporteCAS, @Cuenta = @AcreedorISR, @Vencimiento = @ISRVencimiento
END ELSE
IF (@NomTipo = 'AGUINALDO' AND @CfgISRReglamentoAguinaldo = 0 ) OR (@NomTipo <> 'AGUINALDO')
BEGIN
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ISR/SubsidioAlEmpleo', @Empresa, @Personal, @Importe = @NuevoImporteCAS, @Cuenta = @AcreedorISR, @Vencimiento = @ISRVencimiento
EXEC spNominaISRSubsidioAlEmpleoProporcional	@DiasMes,	@DiasTrabajadosSubsidioAcumulado, @DiasMes ,@ISRBaseMes, @ISR	OUTPUT,	@ISRSubsidioAlEmpleoTabla	OUTPUT,	@ISRBruto	OUTPUT
END
END
IF @NuevoImporteCAS = 0
BEGIN
SELECT @NuevoImporteISR=0
SELECT @NuevoImporteISR = @ISRAcumulado
IF @NuevoImporteISR <> 0
BEGIN
SELECT @ISR = @ISR - @NuevoImporteISR
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ISR', @Empresa, @Personal, @Importe = @ISR, @Cuenta = @AcreedorISR, @Vencimiento = @ISRVencimiento
END ELSE
begin
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ISR', @Empresa, @Personal, @Importe = @ISR, @Cuenta = @AcreedorISR, @Vencimiento = @ISRVencimiento
end
END ELSE
BEGIN
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ISR', @Empresa, @Personal, @Importe = @ISR, @Cuenta = @AcreedorISR, @Vencimiento = @ISRVencimiento
END
END ELSE
BEGIN
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ISR', @Empresa, @Personal, @Importe = @ISR, @Cuenta = @AcreedorISR, @Vencimiento = @ISRVencimiento
END
END
IF  @NomTipo NOT IN ('SDI','LIQUIDACION FONDO AHORRO')
BEGIN
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ISR/Bruto',               @Empresa, @Personal, @Importe = @ISRBruto
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'ISR/SubsidioAlEmpleoTabla', @Empresa, @Personal, @Importe = @ISRSubsidioAlEmpleoTabla
END
END
END

