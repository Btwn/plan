SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNominaGenerar
@Estacion	    int,
@ID		        int,
@FechaD		    datetime,
@FechaA		    datetime,
@PeriodoTipo	varchar(20),
@FechaTrabajo	datetime    = NULL,
@NomTipo	    varchar(50) = NULL

AS BEGIN
DECLARE
@Empresa				                    char(5),
@RedondeoMonetarios 		            int,
@CfgAjusteMensualISR		            bit,
@CfgSueldoMinimo			              varchar(20),
@CfgTablaVacaciones			            varchar(50),
@CfgSubsidioIncapacidadEG		        bit,
@CfgPrimaDominicalAuto		          bit,
@CfgISRReglamentoAguinaldo		      bit,
@CfgISRReglamentoPTU      		      bit,
@CfgISRLiquidacionSueldoMensual	    varchar(50),
@CfgFactorIntegracionAntiguedad	    varchar(20),
@CfgFactorIntegracionTabla	        varchar(50),
@CfgFondoAhorroRepartirInteres      varchar(20),
@CfgCajaAhorroRepartirInteres	      varchar(20),
@Sucursal			                  	  int,
@Mov				                        varchar(20),
@NomCalcSDI		                      bit,
@NomCxc 			                  	  varchar(20),
@Moneda				                      char(10),
@TipoCambio		                  		float,
@Personal			                  	  char(10),
@ClaveInterna	                  		varchar(10),
@Conteo				                      int,
@RepartirDesde			                datetime,
@RepartirHasta			                datetime,
@RepartirImporte			              money,
@RepartirIngresoTope		            money,
@RepartirIngresoTotal		            money,
@RepartirTotalDias			            float,
@RepartirIngresoFactor	            float,
@RepartirDiasFactor			            float,
@Renglon				                    float,
@CalendarioEsp		                  bit,
@IncidenciaD			                  datetime,
@IncidenciaA			                  datetime,
@IDMAX       			                  int,
@Ok					                        int,
@OkRef				                      varchar(255),
@Pais                               varchar(30),
@ImpuestoEstatalGastoOperacionTotal money,
@ImpuestoEstatalGastoOperacionSuma  money,
@SueldoDiario			                  money ,
@Valor                              varchar(50),
@UEN                                int,
@UEN0                               int,
@ID1                                int
CREATE TABLE #Nomina (
ID		         int		  NOT NULL IDENTITY(1,1) PRIMARY KEY,
IncidenciaID	 int		  NULL,
IncidenciaRID	 int		  NULL,
Fecha		       datetime	NULL,
Personal	     varchar(10)  COLLATE Database_Default NULL,
Semana		     int		  NULL,
NominaConcepto varchar(10)	COLLATE Database_Default NULL,
Movimiento	   varchar(20)	COLLATE Database_Default NULL,
Referencia	   varchar(50)	COLLATE Database_Default NULL,
Cantidad	     float		NULL,
Importe		     money		NULL,
Cuenta	 	     varchar(10) 	COLLATE Database_Default NULL,
Vencimiento  	 datetime NULL,
Beneficiario	 varchar(100)	COLLATE Database_Default NULL,
UEN            int      NULL)
CREATE INDEX Consulta       ON #Nomina (Personal, IncidenciaID, IncidenciaRID, NominaConcepto, Referencia, Cuenta, Vencimiento, Beneficiario)
CREATE INDEX Referencia     ON #Nomina (Referencia)
CREATE INDEX Personal 	ON #Nomina (Personal, NominaConcepto)
CREATE INDEX IncidenciaID 	ON #Nomina (Personal, IncidenciaID)
CREATE INDEX IncidenciaRID 	ON #Nomina (Personal, IncidenciaRID)
CREATE INDEX IndiceCursor   ON #Nomina (Personal, Cuenta, Vencimiento)
CREATE INDEX NominaConcepto ON #Nomina (NominaConcepto, Personal, IncidenciaID, IncidenciaRID, Referencia, Cuenta, Vencimiento, Beneficiario, Importe, Cantidad)
CREATE TABLE #Nomina2 (
ID		          int		    NOT NULL IDENTITY(1,1) PRIMARY KEY,
IncidenciaID	  int		    NULL,
IncidenciaRID	  int		    NULL,
Fecha		        datetime	NULL,
Personal	      varchar(10)	COLLATE Database_Default  NULL,
NominaConcepto	varchar(10)	COLLATE Database_Default  NULL,
Movimiento	    varchar(20)	COLLATE Database_Default  NULL,
Referencia	    varchar(50)	COLLATE Database_Default  NULL,
Cantidad	      float		  NULL,
Importe		      money		  NULL,
Cuenta	 	      varchar(10) COLLATE Database_Default  	NULL,
Vencimiento  	  datetime 	NULL,
Beneficiario	  varchar(100) COLLATE Database_Default  	NULL,
UEN             int       NULL)
CREATE INDEX NominaConcepto ON #Nomina2(NominaConcepto, ID, IncidenciaRID, Referencia, Cuenta, Vencimiento, Beneficiario, Cantidad, Personal, Importe)
DELETE  ImpuestoEstatalGastoOperacion WHERE ID = @ID
SELECT @Empresa = Empresa from nomina where id=@ID
SELECT @Pais = Pais from Empresa where empresa=@Empresa
SELECT @Pais = ISNULL(@Pais,'')
SELECT @RedondeoMonetarios = RedondeoMonetarios FROM Version
SELECT @IncidenciaD = @FechaD, @IncidenciaA = @FechaA
IF @FechaTrabajo IS NULL
BEGIN
SELECT @FechaTrabajo = GETDATE()
EXEC spExtraerFecha @FechaTrabajo OUTPUT
END
SELECT @Conteo = 0, @Ok = NULL, @OkRef = NULL
SELECT @Empresa = n.Empresa, @Sucursal = n.Sucursal, @Mov = n.Mov, @Moneda = n.Moneda, @TipoCambio = n.TipoCambio,
@NomTipo = ISNULL(@NomTipo,ISNULL(NULLIF(RTRIM(UPPER(mt.NomAutoTipo)), ''), 'NORMAL')),
@NomCalcSDI = ISNULL(mt.NomAutoCalcSDI, 0),
@NomCxc  = UPPER(mt.NomAutoCxc)
FROM Nomina n
JOIN MovTipo mt ON mt.Modulo = 'NOM' AND mt.Mov = n.Mov
WHERE n.ID = @ID
SELECT @CalendarioEsp = NomAutoCalendarioEsp FROM MovTipo WHERE Modulo = 'NOM' AND Mov = @Mov
IF @CalendarioEsp = 1
SELECT @IncidenciaD = IncidenciaD, @IncidenciaA = IncidenciaA
FROM MovTipoNomAutoCalendarioEsp
WHERE Modulo = 'NOM' AND Mov = @Mov AND FechaNomina = @FechaA
SELECT @CfgTablaVacaciones = TablaVacaciones
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @CfgAjusteMensualISR      = AjusteMensualISR,
@CfgSueldoMinimo          = UPPER(SueldoMinimo),
@CfgSubsidioIncapacidadEG = ISNULL(SubsidioIncapacidadEG, 0),
@CfgPrimaDominicalAuto    = ISNULL(PrimaDominicalAuto, 0),
@CfgISRReglamentoAguinaldo= ISNULL(ISRReglamentoAguinaldo, 0),
@CfgISRReglamentoPTU      = ISNULL(ISRReglamentoPTU, 0),
@CfgISRLiquidacionSueldoMensual = UPPER(ISRLiquidacionSueldoMensual),
@CfgFactorIntegracionAntiguedad = UPPER(FactorIntegracionAntiguedad),
@CfgFactorIntegracionTabla      = FactorIntegracionTabla,
@CfgFondoAhorroRepartirInteres  = FondoAhorroRepartirInteres,
@CfgCajaAhorroRepartirInteres   = CajaAhorroRepartirInteres
FROM EmpresaCfgNomAuto
WHERE Empresa = @Empresa
IF @NomTipo IN ('PTU', 'LIQUIDACION FONDO AHORRO', 'LIQUIDACION CAJA AHORRO')
BEGIN
IF @NomTipo = 'PTU'
BEGIN
EXEC spPersonalPropValorDMA   @Empresa, NULL, NULL, NULL, NULL, 'PTU Desde (DD/MM/AAAA)', @RepartirDesde OUTPUT
EXEC spPersonalPropValorDMA   @Empresa, NULL, NULL, NULL, NULL, 'PTU Hasta (DD/MM/AAAA)', @RepartirHasta OUTPUT
EXEC spPersonalPropValorMoney @Empresa, NULL, NULL, NULL, NULL, 'PTU Importe a Repartir', @RepartirImporte OUTPUT
EXEC spPersonalPropValorMoney @Empresa, NULL, NULL, NULL, NULL, 'PTU Ingreso Tope',       @RepartirIngresoTope OUTPUT
EXEC spNominaClaveInternaAcumuladoFechasTotal @Empresa, 'DiasTrabajados', @RepartirDesde, @RepartirHasta, @RepartirIngresoTope, @RepartirIngresoTotal OUTPUT, @RepartirTotalDias OUTPUT
SELECT @RepartirIngresoFactor = (@RepartirImporte/2.0)/NULLIF(@RepartirIngresoTotal, 0.0),
@RepartirDiasFactor    = (@RepartirImporte/2.0)/NULLIF(@RepartirTotalDias, 0.0)
END ELSE
IF @NomTipo = 'LIQUIDACION FONDO AHORRO'
BEGIN
EXEC spPersonalPropValorDMA   @Empresa, NULL, NULL, NULL, NULL, 'Fondo de Ahorro Desde (DD/MM/AAAA)', @RepartirDesde OUTPUT
EXEC spPersonalPropValorDMA   @Empresa, NULL, NULL, NULL, NULL, 'Fondo de Ahorro Hasta (DD/MM/AAAA)', @RepartirHasta OUTPUT
EXEC spPersonalPropValorMoney @Empresa, NULL, NULL, NULL, NULL, 'Fondo de Ahorro Interes a Repartir', @RepartirImporte OUTPUT
EXEC spPersonalPropValorMoney @Empresa, NULL, NULL, NULL, NULL, 'Fondo de Ahorro Ingreso Tope',       @RepartirIngresoTope OUTPUT
EXEC spNominaClaveInternaAcumuladoFechasTotal @Empresa, 'FondoAhorro', @RepartirDesde, @RepartirHasta, @RepartirIngresoTope, @RepartirIngresoTotal OUTPUT, @RepartirTotalDias OUTPUT
IF @CfgFondoAhorroRepartirInteres = 'PTU'
SELECT @RepartirIngresoFactor = (@RepartirImporte/2.0)/NULLIF(@RepartirIngresoTotal, 0.0),
@RepartirDiasFactor    = (@RepartirImporte/2.0)/NULLIF(@RepartirTotalDias, 0.0)
ELSE
SELECT @RepartirIngresoFactor = @RepartirImporte/NULLIF(@RepartirIngresoTotal, 0.0),
@RepartirDiasFactor    = NULL
END ELSE
IF @NomTipo = 'LIQUIDACION CAJA AHORRO'
BEGIN
EXEC spPersonalPropValorDMA   @Empresa, NULL, NULL, NULL, NULL, 'Caja de Ahorro Desde (DD/MM/AAAA)', @RepartirDesde OUTPUT
EXEC spPersonalPropValorDMA   @Empresa, NULL, NULL, NULL, NULL, 'Caja de Ahorro Hasta (DD/MM/AAAA)', @RepartirHasta OUTPUT
EXEC spPersonalPropValorMoney @Empresa, NULL, NULL, NULL, NULL, 'Caja de Ahorro Interes a Repartir', @RepartirImporte OUTPUT
EXEC spPersonalPropValorMoney @Empresa, NULL, NULL, NULL, NULL, 'Caja de Ahorro Ingreso Tope',       @RepartirIngresoTope OUTPUT
EXEC spNominaClaveInternaAcumuladoFechasTotal @Empresa, 'CajaAhorro', @RepartirDesde, @RepartirHasta, @RepartirIngresoTope, @RepartirIngresoTotal OUTPUT, @RepartirTotalDias OUTPUT
IF @CfgCajaAhorroRepartirInteres = 'PTU'
SELECT @RepartirIngresoFactor = (@RepartirImporte/2.0)/NULLIF(@RepartirIngresoTotal, 0.0),
@RepartirDiasFactor    = (@RepartirImporte/2.0)/NULLIF(@RepartirTotalDias, 0.0)
ELSE
SELECT @RepartirIngresoFactor = @RepartirImporte/NULLIF(@RepartirIngresoTotal, 0.0), @RepartirDiasFactor    = NULL
END
END
SELECT @ClaveInterna = NULL
IF EXISTS (SELECT * from version  where version < 3000)
BEGIN
SELECT  @Pais ='Mexico'
SELECT @ClaveInterna = MIN(cfg.ClaveInterna)
FROM CfgNominaConcepto cfg
LEFT OUTER JOIN NominaConcepto nc ON nc.NominaConcepto = cfg.NominaConcepto
WHERE nc.NominaConcepto IS NULL
END
ELSE BEGIN
IF EXISTS(SELECT * FROM Version WHERE Version >= 3000)
SELECT @ClaveInterna = MIN(cfg.ClaveInterna)
FROM CfgNominaConcepto cfg
LEFT OUTER JOIN NominaConcepto nc ON nc.NominaConcepto = cfg.NominaConcepto
WHERE nc.NominaConcepto IS NULL
AND nc.Pais  = cfg.Pais
AND cfg.Pais = @Pais
ELSE
SELECT @ClaveInterna = MIN(cfg.ClaveInterna)
FROM CfgNominaConcepto cfg
LEFT OUTER JOIN NominaConcepto nc ON nc.NominaConcepto = cfg.NominaConcepto
WHERE nc.NominaConcepto IS NULL
END
IF @ClaveInterna IS NOT NULL
SELECT @Ok = 10034, @OkRef = @ClaveInterna
IF isnull(@Pais,'')='' SELECT @Pais ='Mexico'
/*IF @Pais = 'Mexico' AND @NomTipo IN('Impuesto Estatal')
EXEC spFideNominaImpuestoEstatal @ID, @FechaD, @FechaA,  @Ok OUTPUT, @OkRef   OUTPUT
ELSE*/
IF @Pais ='Mexico'
BEGIN
IF @MOV = 'PRESUPUESTO'
EXEC spNominaPresupuestoPlazaIntelisis
DECLARE crLista CURSOR FOR
SELECT Clave FROM ListaSt WHERE Estacion = @Estacion ORDER BY ID
OPEN crLista
FETCH NEXT FROM crLista INTO @Personal
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF @MOV = 'PRESUPUESTO'  EXEC spNominaPresupuestoPlazaIntelisis2  @Personal, @FechaD
SELECT @SueldoDiario = isnull(SueldoDiario,0) FROM Personal where personal = @Personal
SELECT @SueldoDiario = isnull(@SueldoDiario,0)
IF (@SueldoDiario > 11  AND @NomTipo NOT IN ('Sueldo Complemento','AguinaldoComplemento'))
or (@NomTipo IN('Liquidacion Caja ahorro','SDI','Finiquito','Liquidacion','Ajuste','Impuesto Estatal'))
EXEC spNominaCalcMexico @Empresa, @FechaTrabajo, @Sucursal, @ID, @Moneda, @TipoCambio, @Personal, @FechaD, @FechaA, @PeriodoTipo,
@CfgAjusteMensualISR, @CfgSueldoMinimo, @CfgTablaVacaciones, @CfgSubsidioIncapacidadEG, @CfgPrimaDominicalAuto,
@CfgISRReglamentoAguinaldo, @CfgISRReglamentoPTU, @CfgISRLiquidacionSueldoMensual, @CfgFactorIntegracionAntiguedad, @CfgFactorIntegracionTabla,
@NomTipo, @NomCalcSDI, @NomCxc,@RepartirDesde, @RepartirHasta, @RepartirIngresoTope, @RepartirIngresoFactor, @RepartirDiasFactor,
@CalendarioEsp, @IncidenciaD, @IncidenciaA,@Estacion,
@Ok OUTPUT, @OkRef OUTPUT
IF  @NomTipo IN ('Sueldo Complemento','AguinaldoComplemento')
BEGIN
SELECT @SueldoDiario = isnull(SueldoDiarioComplemento,0) from personal where personal=@Personal
SELECT @SueldoDiario = isnull(@SueldoDiario,0)
IF @Mov = 'Presupuesto' SELECT @SueldoDiario = @SueldoDiario * (1+(isnull(Incremento,0)/100.0)) FROM Personal WHERE Personal = @Personal
IF @SueldoDiario >1
EXEC spNominaCalcMexico @Empresa, @FechaTrabajo, @Sucursal, @ID, @Moneda, @TipoCambio, @Personal, @FechaD, @FechaA, @PeriodoTipo,
@CfgAjusteMensualISR, @CfgSueldoMinimo, @CfgTablaVacaciones, @CfgSubsidioIncapacidadEG, @CfgPrimaDominicalAuto,
@CfgISRReglamentoAguinaldo, @CfgISRReglamentoPTU, @CfgISRLiquidacionSueldoMensual, @CfgFactorIntegracionAntiguedad, @CfgFactorIntegracionTabla,
@NomTipo, @NomCalcSDI, @NomCxc,@RepartirDesde, @RepartirHasta, @RepartirIngresoTope, @RepartirIngresoFactor, @RepartirDiasFactor,
@CalendarioEsp, @IncidenciaD, @IncidenciaA,@Estacion,
@Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL SELECT @Conteo = @Conteo + 1
END
FETCH NEXT FROM crLista INTO @Personal
END
CLOSE crLista
DEALLOCATE crLista
END ELSE
IF @Pais ='El Salvador'
BEGIN
DECLARE crLista CURSOR FOR
SELECT Clave FROM ListaSt WHERE Estacion = @Estacion ORDER BY ID
OPEN crLista
FETCH NEXT FROM crLista INTO @Personal
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
EXEC spNominaCalcElSalvador @Empresa, @FechaTrabajo, @Sucursal, @ID, @Moneda, @TipoCambio, @Personal, @FechaD, @FechaA, @PeriodoTipo,
@CfgAjusteMensualISR, @CfgSueldoMinimo, @CfgTablaVacaciones, @CfgSubsidioIncapacidadEG, @CfgPrimaDominicalAuto,
@CfgISRReglamentoAguinaldo, @CfgISRReglamentoPTU, @CfgISRLiquidacionSueldoMensual, @CfgFactorIntegracionAntiguedad, @CfgFactorIntegracionTabla,
@NomTipo, @NomCalcSDI, @NomCxc,@RepartirDesde, @RepartirHasta, @RepartirIngresoTope, @RepartirIngresoFactor, @RepartirDiasFactor,
@CalendarioEsp, @IncidenciaD, @IncidenciaA,
@Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL SELECT @Conteo = @Conteo + 1
END
FETCH NEXT FROM crLista INTO @Personal
END
CLOSE crLista
DEALLOCATE crLista
END
ELSE IF @Pais ='Panama'
BEGIN
IF @NomTipo='VACACIONES'
EXEC spNominaGenerarVacacionesPanama @Estacion, @ID,@FechaD,@FechaA,@PeriodoTipo,	@FechaTrabajo
ELSE BEGIN
DECLARE crLista CURSOR FOR
SELECT Clave FROM ListaSt WHERE Estacion = @Estacion ORDER BY ID
OPEN crLista
FETCH NEXT FROM crLista INTO @Personal
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
EXEC spNominaCalcPanama @Empresa, @FechaTrabajo, @Sucursal, @ID, @Moneda, @TipoCambio, @Personal, @FechaD, @FechaA, @PeriodoTipo,
@CfgAjusteMensualISR, @CfgSueldoMinimo, @CfgTablaVacaciones, @CfgSubsidioIncapacidadEG, @CfgPrimaDominicalAuto,
@CfgISRReglamentoAguinaldo, @CfgISRReglamentoPTU, @CfgISRLiquidacionSueldoMensual, @CfgFactorIntegracionAntiguedad, @CfgFactorIntegracionTabla,
@NomTipo, @NomCalcSDI, @NomCxc,@RepartirDesde, @RepartirHasta, @RepartirIngresoTope, @RepartirIngresoFactor, @RepartirDiasFactor,
@CalendarioEsp, @IncidenciaD, @IncidenciaA,
@Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL SELECT @Conteo = @Conteo + 1
END
FETCH NEXT FROM crLista INTO @Personal
END
CLOSE crLista
DEALLOCATE crLista
END
END
IF @Ok IS NULL
BEGIN
SELECT  SucursalTrabajo, ImpuestoEstatalGastoOperacionSuma = SUM(ISNULL(Importe,0))
into #ImpuestoEstatalGastoOperacion
FROM #Nomina
JOIN cfgNominaConcepto  ON #Nomina.NominaConcepto = cfgNominaConcepto.Nominaconcepto
JOIN Personal ON   #Nomina.Personal = Personal.Personal
WHERE ClaveInterna ='ImpuestoEstatal/GastoOperacion'
GROUP BY Personal.SucursalTrabajo
UPDATE #ImpuestoEstatalGastoOperacion
SET ImpuestoEstatalGastoOperacionSuma = (
SELECT  GastoOperacion- ImpuestoEstatalGastoOperacionSuma
FROM ImpuestoEstatalGastoOperacion
JOIN #ImpuestoEstatalGastoOperacion on ImpuestoEstatalGastoOperacion.Sucursal=#ImpuestoEstatalGastoOperacion.SucursalTrabajo
WHERE ImpuestoEstatalGastoOperacion.ID = @ID )
UPDATE #Nomina SET Importe = Importe + ImpuestoEstatalGastoOperacionSuma
FROM #Nomina
JOIN PERSONAL on #Nomina.Personal = Personal.Personal
JOIN #ImpuestoEstatalGastoOperacion ON Personal.SucursalTrabajo = #ImpuestoEstatalGastoOperacion.SucursalTrabajo
JOIN cfgNominaConcepto ON #Nomina.NominaConcepto = cfgNominaConcepto.Nominaconcepto AND ClaveInterna ='ImpuestoEstatal/GastoOperacion'
WHERE #Nomina.ID in (SELECT MAX(#Nomina.ID)FROM #Nomina
JOIN PERSONAL on #Nomina.Personal = Personal.Personal  AND Personal.SucursalTrabajo = #ImpuestoEstatalGastoOperacion.SucursalTrabajo
JOIN #ImpuestoEstatalGastoOperacion ON Personal.SucursalTrabajo = #ImpuestoEstatalGastoOperacion.SucursalTrabajo )
EXEC spNominaImpuestoEstatalEspecial @Empresa,@Ok OUTPUT, @OkRef OUTPUT
DELETE NominaD WHERE ID = @ID
INSERT #Nomina2 (Personal,   IncidenciaID,   IncidenciaRID,   NominaConcepto,   Referencia,   Cuenta,   Vencimiento,   Beneficiario,   Importe,        Cantidad, UEN)
SELECT d.Personal, d.IncidenciaID, d.IncidenciaRID, d.NominaConcepto, d.Referencia, d.Cuenta, d.Vencimiento, d.Beneficiario, SUM(d.Importe), SUM(d.Cantidad), D.UEN
FROM #Nomina d
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto
WHERE NULLIF(d.Importe, 0.0) IS NOT NULL OR NULLIF(d.Cantidad, 0.0) IS NOT NULL
GROUP BY nc.Modulo,      d.Personal, d.IncidenciaID, d.IncidenciaRID, d.NominaConcepto, nc.Movimiento, nc.Concepto, d.Referencia, d.Cuenta, d.Vencimiento, d.Beneficiario,D.UEN
ORDER BY nc.Modulo DESC, d.Personal, d.IncidenciaID, d.IncidenciaRID, d.NominaConcepto, nc.Movimiento, nc.Concepto, d.Referencia, d.Cuenta, d.Vencimiento, d.Beneficiario, D.UEN
SELECT @UEN = NULL , @UEN0 = NULL, @Valor='N'
EXEC spPersonalPropValor   @Empresa, NULL, NULL, NULL, NULL, 'Separa Nominas Por UEN', @Valor OUTPUT
IF LEFT(ISNULL(rtrim(@Valor),''),1) ='S'
BEGIN
SELECT @UEN0 = @UEN,  @ID1 = @ID
DECLARE crNominaSeparaUEN CURSOR local FOR SELECT DISTINCT UEN FROM #Nomina2 ORDER by UEN
OPEN crNominaSeparaUEN
FETCH NEXT FROM crNominaSeparaUEN INTO @UEN
SELECT @UEN0 = @UEN
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
UPDATE Nomina  SET UEN = @UEN  WHERE ID = @ID1
INSERT NominaD (
ID,  Sucursal,   Renglon, Modulo,    Personal,   IncidenciaID,    NominaConcepto,   Movimiento,    Concepto,    Referencia,   Cuenta,   FechaA,        Beneficiario,   Importe,                               Cantidad,   CuentaContable, ContUso, CuentaContable2, UEN)
SELECT @ID1, @Sucursal, d.ID,    nc.Modulo, d.Personal, d.IncidenciaRID, d.NominaConcepto, nc.Movimiento, nc.Concepto, d.Referencia, d.Cuenta, d.Vencimiento, d.Beneficiario, ROUND(d.Importe, @RedondeoMonetarios), d.Cantidad, dbo.fnNominaCuentaContable (nc.CuentaBase, nc.Cuenta, d.Personal, d.NominaConcepto, d.Cuenta, @Empresa),(SELECT CentroCostos FROM Personal WHERE Personal.Personal = d.Personal), dbo.fnNominaCuentaContable (nc.CuentaBase2, nc.Cuenta2, d.Personal, d.NominaConcepto, d.Cuenta, @Empresa), D.UEN
FROM #Nomina2 d
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto
JOIN Personal on d.Personal = Personal.Personal
WHERE d.UEN = @UEN order by d.personal
END
SELECT @UEN0 = @UEN
FETCH NEXT FROM crNominaSeparaUEN INTO @UEN
IF  @UEN0 <> ISNULL(@UEN, @UEN0) AND @@FETCH_STATUS = 0
BEGIN
UPDATE Nomina SET  RamaID = @ID WHERE ID = @ID
INSERT Nomina( ramaid, Empresa, Mov,  FechaEmision, UltimoCambio, Proyecto, UEN, Concepto, Moneda, TipoCambio, Usuario, Autorizacion, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, OrigenTipo, Origen, OrigenID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, Condicion, PeriodoTipo, FechaD, FechaA, Sucursal, Percepciones, Deducciones, FechaOrigen, FechaRegistroNomXD, FechaRegistroNomXA, SucursalOrigen,SucursalDestino)
SELECT         ramaid, Empresa, Mov,  FechaEmision, UltimoCambio, Proyecto, UEN, Concepto, Moneda, TipoCambio, Usuario, Autorizacion, DocFuente, Observaciones, 'BORRADOR', Situacion, SituacionFecha, SituacionUsuario, SituacionNota, OrigenTipo, Origen, OrigenID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, Condicion, PeriodoTipo, @FechaD, @FechaA, Sucursal, Percepciones, Deducciones, FechaOrigen, FechaRegistroNomXD, FechaRegistroNomXA, SucursalOrigen,SucursalDestino
FROM Nomina WHERE ID = @ID
SELECT @ID1 = SCOPE_IDENTITY()
END
END
CLOSE crNominaSeparaUEN
DEALLOCATE crNominaSeparaUEN
END ELSE
BEGIN
INSERT NominaD (
ID,  Sucursal,  Renglon, Modulo,    Personal,   IncidenciaID,    NominaConcepto,   Movimiento,    Concepto,    Referencia,   Cuenta,   FechaA,        Beneficiario,   Importe,                               Cantidad,   CuentaContable, ContUso, CuentaContable2,UEN)
SELECT @ID, @Sucursal, d.ID,    nc.Modulo, d.Personal, d.IncidenciaRID, d.NominaConcepto, nc.Movimiento, nc.Concepto, d.Referencia, d.Cuenta, d.Vencimiento, d.Beneficiario, ROUND(d.Importe, @RedondeoMonetarios), d.Cantidad, dbo.fnNominaCuentaContable (nc.CuentaBase, nc.Cuenta, d.Personal, d.NominaConcepto, d.Cuenta, @Empresa),(SELECT CentroCostos FROM Personal WHERE Personal.Personal = d.Personal), dbo.fnNominaCuentaContable (nc.CuentaBase2, nc.Cuenta2, d.Personal, d.NominaConcepto, d.Cuenta, @Empresa), D.UEN
FROM #Nomina2 d
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto
JOIN Personal on d.Personal = Personal.Personal
SELECT @IDMAX = MAX(ID) from #nomina2
END
INSERT NominaD (
ID,  Sucursal,  Renglon, Modulo,    Personal,       NominaConcepto,   Movimiento,    Concepto,
Referencia,   Cuenta,   FechaA,        Beneficiario,   Importe,                               Cantidad,   CuentaContable )
SELECT @ID, @Sucursal, d.ID + @idmax + 1,    'CXP', d.Personal, d.NominaConcepto, 'Estadistica', nc.Concepto,
d.Referencia, nc.AcreedorDef, d.Vencimiento, d.Beneficiario, ROUND(d.Importe, @RedondeoMonetarios), d.Cantidad, NULL
FROM #Nomina2 d
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto WHERE nc.Modulo = 'CXC'
AND isnull(nc.GenerarEstadisticaCxp,0) <> 0
UPDATE NominaD SET MODULO = 'NOM', REFERENCIA = 'DEVOLUCION' WHERE ID = @ID AND Modulo = 'CXC' AND IMPORTE < 0.0
UPDATE Nomina SET PeriodoTipo = @PeriodoTipo, FechaD = @FechaD, FechaA = @FechaA, Estatus = 'BORRADOR' WHERE ID = @ID
EXEC xpNominaGenerar @Estacion, @ID, @FechaD, @FechaA, @PeriodoTipo
SELECT CONVERT(varchar, @Conteo)+ ' Personas Procesadas'
END ELSE
BEGIN
SELECT Descripcion+' '+ISNULL(RTRIM(@OkRef), '') FROM MensajeLista WHERE Mensaje = @Ok
END
RETURN
END

