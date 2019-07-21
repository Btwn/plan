SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER  PROCEDURE dbo.spNominaGrava
@Empresa			          char(5),
@Sucursal			          int,
@ID				              int,
@Personal			          char(10),
@SucursalTrabajoEstado	varchar(50),
@FechaD				          datetime,
@FechaA				          datetime,
@Moneda				          char(10),
@TipoCambio			        float,
@SMZ 				            money,
@SMZTopeHorasDobles		  float,
@SDI 				            money,
@DiasPeriodo 			      float,
@DiasMes			          float,
@DiasAno			          float,
@Antiguedad			        float,
@IndemnizacionTope		  money,
@ISRBase			          money		OUTPUT,
@IMSSBase			          money		OUTPUT,
@ImpuestoEstatalBase		money		OUTPUT,
@CedularBase			      money		OUTPUT,
@Ok				              int		OUTPUT,
@OkRef				          varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Semana				            int,
@Movimiento				        varchar(20),
@Factor				            float,
@Cantidad 				        float,
@Importe 				          money,
@Tope				              money,
@Exento				            money,
@ExentoF				          money,
@Gravable				          money,
@GravableF				        money,
@ClaveInterna			        varchar(50),
@ClaveInternaPrefijo	    varchar(50),
@GravaISR				          varchar(50),
@GravaIMSS				        varchar(50),
@GravaImpuestoEstatal	    varchar(50),
@GravaCedular			        varchar(50),
@TopeHorasDoblesSemanal	  money,
@TopePrimaDominical			  money,
@TopePrimaVacacional		  money,
@TopeAguinaldo			      money,
@TopePTU				          money,
@TopePremioPuntualidad	  money,
@TopePremioAsistencia		  money,
@TopeValesDespensaISR		  money,
@TopeValesDespensaIMSS	  money,
@ImporteHorasExtrasDobles	money,
@NominaConcepto			      varchar(10)
IF @Ok IS NOT NULL RETURN
SELECT @TopePrimaVacacional    = @SMZ * 15,
@TopeAguinaldo          = @SMZ * 30,
@TopePTU                = @SMZ * 15,
@TopePremioPuntualidad  = (@DiasMes * @SDI * 0.1) / @DiasMes * @DiasPeriodo,
@TopePremioAsistencia   = (@DiasMes * @SDI * 0.1) / @DiasMes * @DiasPeriodo,
@TopeValesDespensaIMSS  = @SMZ *  @DiasPeriodo * 0.4,
@TopeValesDespensaISR   = @SMZ * (@DiasAno / 12.0),
@TopeHorasDoblesSemanal = @SMZTopeHorasDobles * @SMZ
DECLARE crNominaGrava CURSOR FOR
SELECT nc.NominaConcepto, nc.Movimiento, d.Semana, SUM(d.Cantidad), SUM(d.Importe), ISNULL(NULLIF(RTRIM(UPPER(nc.GravaISR)), ''), 'NO'), ISNULL(NULLIF(RTRIM(UPPER(nc.GravaIMSS)), ''), 'NO'), ISNULL(NULLIF(RTRIM(UPPER(nc.GravaImpuestoEstatal)), ''), 'NO'), ISNULL(NULLIF(RTRIM(UPPER(nc.GravaCedular)), ''), 'NO')
FROM #Nomina d
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto
WHERE d.Personal = @Personal AND nc.Movimiento IN ('Percepcion', 'Deduccion', 'Estadistica')
GROUP BY nc.NominaConcepto, nc.Movimiento, nc.GravaISR, nc.GravaIMSS, nc.GravaImpuestoEstatal, nc.GravaCedular, d.Semana
ORDER BY nc.NominaConcepto, nc.Movimiento, nc.GravaISR, nc.GravaIMSS, nc.GravaImpuestoEstatal, nc.GravaCedular, d.Semana
OPEN crNominaGrava
FETCH NEXT FROM crNominaGrava INTO @NominaConcepto, @Movimiento, @Semana, @Cantidad, @Importe, @GravaISR, @GravaIMSS, @GravaImpuestoEstatal, @GravaCedular
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @GravaImpuestoEstatal = 'POR ESTADO'
BEGIN
SELECT @GravaImpuestoEstatal = 'NO'
SELECT @GravaImpuestoEstatal = GravaImpuestoEstatal FROM NominaConceptoEstado WHERE NominaConcepto = @NominaConcepto AND Estado = @SucursalTrabajoEstado
END
IF @Movimiento = 'Deduccion' SELECT @Factor = -1.0 ELSE SELECT @Factor = 1.0
SELECT @TopePrimaDominical = abs(@Cantidad)*@SMZ
IF @GravaISR <> 'NO'
BEGIN
SELECT @Tope = 0.0, @ClaveInternaPrefijo = NULL
IF @GravaISR = 'HORAS EXTRAS DOBLES'
BEGIN
SELECT @ImporteHorasExtrasDobles = (@Importe/2.0)
EXEC spNominaTope @ImporteHorasExtrasDobles, @TopeHorasDoblesSemanal, @Exento OUTPUT, @Gravable OUTPUT
SELECT @Gravable = (@Importe/2.0) + @Gravable, @ClaveInternaPrefijo = 'HorasExtras/Dobles'
END ELSE
BEGIN
IF @GravaISR = 'PRIMA DOMINICAL'  SELECT @ClaveInternaPrefijo = 'PrimaDominical',  @Tope = @TopePrimaDominical   ELSE
IF @GravaISR = 'PRIMA VACACIONAL' SELECT @ClaveInternaPrefijo = 'PrimaVacacional', @Tope = @TopePrimaVacacional  ELSE
IF @GravaISR = 'VALES DESPENSA'   SELECT @ClaveInternaPrefijo = 'ValesDespensa',   @Tope = @TopeValesDespensaISR ELSE
IF @GravaISR = 'AGUINALDO'        SELECT @ClaveInternaPrefijo = 'Aguinaldo', 	     @Tope = @TopeAguinaldo        ELSE
IF @GravaISR = 'PTU'        		  SELECT @ClaveInternaPrefijo = 'PTU', 	 	         @Tope = @TopePTU              ELSE
IF @GravaISR = 'ISR LIQUIDACION'  SELECT @ClaveInternaPrefijo = 'Indemnizacion',   @Tope = @IndemnizacionTope
IF @Importe < 0
BEGIN
SELECT @Importe= @Importe * -1
EXEC spNominaTope @Importe, @Tope, @Exento OUTPUT, @Gravable OUTPUT
SELECT @Exento= @Exento * -1
SELECT @Gravable= @Gravable * -1
SELECT @Importe= @Importe * -1
END ELSE
EXEC spNominaTope @Importe, @Tope, @Exento OUTPUT, @Gravable OUTPUT
END
SELECT @GravableF = @Gravable * @Factor, @ExentoF = @Exento * @Factor
IF ISNULL(@GravaISR,'') <> 'ISR LIQUIDACION'
SELECT @ISRBase = @ISRBase + @GravableF
IF @ClaveInternaPrefijo IS NOT NULL
BEGIN
SELECT @ClaveInterna = @ClaveInternaPrefijo + '/Exento'
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, @ClaveInterna, @Empresa, @Personal, @Importe = @ExentoF
SELECT @ClaveInterna = @ClaveInternaPrefijo + '/Gravable'
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, @ClaveInterna, @Empresa, @Personal, @Importe = @GravableF
END
END
IF @GravaIMSS <> 'NO'
BEGIN
SELECT @Tope = 0.0
IF @GravaIMSS = 'PREMIO PUNTUALIDAD'  SELECT @Tope = @TopePremioPuntualidad  ELSE
IF @GravaIMSS = 'PREMIO ASISTENCIA'   SELECT @Tope = @TopePremioAsistencia   ELSE
IF @GravaIMSS = 'VALES DESPENSA'      SELECT @Tope = @TopeValesDespensaIMSS
IF @Importe < 0
BEGIN
SELECT @Importe = @Importe * -1
EXEC   spNominaTope @Importe, @Tope, @Exento OUTPUT, @Gravable OUTPUT
SELECT @Exento= @Exento * -1
SELECT @Gravable= @Gravable * -1
SELECT @Importe= @Importe * -1
END ELSE
EXEC spNominaTope @Importe, @Tope, @Exento OUTPUT, @Gravable OUTPUT
SELECT @GravableF = @Gravable * @Factor, @ExentoF = @Exento * @Factor
SELECT @IMSSBase = @IMSSBase + @GravableF
END
IF @GravaImpuestoEstatal <> 'NO'
BEGIN
SELECT @Tope = 0.0
EXEC spNominaTope @Importe, @Tope, @Exento OUTPUT, @Gravable OUTPUT
SELECT @GravableF = @Gravable * @Factor, @ExentoF = @Exento * @Factor
SELECT @ImpuestoEstatalBase = @ImpuestoEstatalBase + @GravableF
END
IF @GravaCedular <> 'NO'
BEGIN
SELECT @Tope = 0.0
EXEC spNominaTope @Importe, @Tope, @Exento OUTPUT, @Gravable OUTPUT
SELECT @GravableF = @Gravable * @Factor, @ExentoF = @Exento * @Factor
SELECT @CedularBase = @CedularBase + @GravableF
END
END
FETCH NEXT FROM crNominaGrava INTO @NominaConcepto, @Movimiento, @Semana, @Cantidad, @Importe, @GravaISR, @GravaIMSS, @GravaImpuestoEstatal, @GravaCedular
END
CLOSE crNominaGrava
DEALLOCATE crNominaGrava
RETURN
END

