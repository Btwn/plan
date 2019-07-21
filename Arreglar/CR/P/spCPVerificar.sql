SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCPVerificar
@ID               		int,
@Accion			char(20),
@Empresa          		char(5),
@Usuario			char(10),
@Modulo	      		char(5),
@Mov              		char(20),
@MovID			varchar(20),
@MovTipo	      		char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision		datetime,
@Estatus			char(15),
@EstatusNuevo		char(15),
@FechaRegistro     		datetime,
@Proyecto	      		varchar(50),
@Ejercicio			int,
@Periodo			int,
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@Ok               		int          OUTPUT,
@OkRef            		varchar(255) OUTPUT

AS BEGIN
DECLARE
@p				int,
@Articulo			varchar(20),
@ClavePresupuestal		varchar(50),
@SumaImporte		money,
@Importe			money,
@Tipo			varchar(20),
@Presupuesto		money,
@Comprometido		money,
@Comprometido2		money,
@Devengado			money,
@Devengado2			money,
@Ejercido			money,
@EjercidoPagado		money,
@Anticipos			money,
@RemanenteDisponible	money,
@Sobrante			money,
@Disponible			money,
@SaldoPresupuesto		money,
@SaldoComprometido		money,
@SaldoComprometido2		money,
@SaldoDevengado		money,
@SaldoDevengado2		money,
@SaldoEjercido		money,
@SaldoEjercidoPagado	money,
@SaldoAnticipos		money,
@SaldoRemanenteDisponible	money,
@SaldoSobrante		money,
@SaldoDisponible		money,
@FlujoAlPeriodo		money,
@TotalEjercido		money,
@Reservado			money,
@TieneArticulosEsp		bit,
@PeriodoD			int,
@TieneDetalle		bit,
@PCP				bit
SELECT @PCP = PCP FROM EmpresaGral WHERE Empresa = @Empresa
IF @Accion = 'CANCELAR'
BEGIN
IF @Conexion = 0
IF EXISTS (SELECT * FROM MovFlujo WHERE Cancelado = 0 AND Empresa = @Empresa AND DModulo = @Modulo AND DID = @ID AND OModulo <> DModulo)
SELECT @Ok = 60070
END ELSE
IF @Accion IN ('AFECTAR', 'VERIFICAR')
BEGIN
UPDATE CPCal SET EnMov = NULL WHERE ID = @ID AND EnMov IS NOT NULL
UPDATE CPArt SET EnMov = NULL WHERE ID = @ID AND EnMov IS NOT NULL
IF @Proyecto IS NULL SELECT @Ok = 15010
SELECT @TieneDetalle = 0
DECLARE crCPVerificar CURSOR LOCAL FOR
SELECT d.ClavePresupuestal, cp.TieneArticulosEsp, UPPER(d.Tipo), ISNULL(SUM(d.Importe), 0.0), ISNULL(SUM(d.Presupuesto), 0.0), ISNULL(SUM(d.Comprometido), 0.0), ISNULL(SUM(d.Comprometido2), 0.0), ISNULL(SUM(d.Devengado), 0.0), ISNULL(SUM(d.Devengado2), 0.0), ISNULL(SUM(d.Ejercido), 0.0), ISNULL(SUM(d.EjercidoPagado), 0.0), ISNULL(SUM(d.Anticipos), 0.0), ISNULL(SUM(d.RemanenteDisponible), 0.0), ISNULL(SUM(d.Sobrante), 0.0), ISNULL(SUM(d.Disponible), 0.0)
FROM CPD d
JOIN ClavePresupuestal cp ON cp.ClavePresupuestal = d.ClavePresupuestal
WHERE d.ID = @ID
GROUP BY d.ClavePresupuestal, cp.TieneArticulosEsp, d.Tipo
ORDER BY d.ClavePresupuestal, cp.TieneArticulosEsp, d.Tipo
OPEN crCPVerificar
FETCH NEXT FROM crCPVerificar INTO @ClavePresupuestal, @TieneArticulosEsp, @Tipo, @Importe, @Presupuesto, @Comprometido, @Comprometido2, @Devengado, @Devengado2, @Ejercido, @EjercidoPagado, @Anticipos, @RemanenteDisponible, @Sobrante, @Disponible
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @TieneDetalle = 1
IF NULLIF(RTRIM(@ClavePresupuestal), '') IS NULL SELECT @Ok = 25640
UPDATE CPCal SET EnMov = 1 WHERE ID = @ID AND ClavePresupuestal = @ClavePresupuestal AND Tipo = @Tipo
UPDATE CPArt SET EnMov = 1 WHERE ID = @ID AND ClavePresupuestal = @ClavePresupuestal AND Tipo = @Tipo
IF @MovTipo IN ('CP.AS', 'CP.TA', 'CP.TR', 'CP.RF') AND @Ok IS NULL AND @PCP = 1
BEGIN
IF dbo.fnPCPValidarReglas(@Proyecto, @FechaEmision, @ClavePresupuestal) = 0 SELECT @Ok = 73840, @OkRef = @ClavePresupuestal
END
IF @MovTipo IN ('CP.AS', 'CP.TA', 'CP.TR', 'CP.RF') AND @Ok IS NULL
BEGIN
SELECT @SumaImporte = 0.0
SELECT @SumaImporte = ISNULL(SUM(Importe), 0.0) FROM CPCal WHERE ID = @ID AND ClavePresupuestal = @ClavePresupuestal AND Tipo = @Tipo
IF @Importe <> @SumaImporte
BEGIN
IF ROUND(@Importe, 2) = ROUND(@SumaImporte, 2)
BEGIN
SELECT @p = MAX(Periodo)
FROM CPCal
WHERE ID = @ID AND ClavePresupuestal = @ClavePresupuestal AND Tipo = @Tipo
UPDATE CPCal
SET Importe = Importe + (@Importe - @SumaImporte)
WHERE ID = @ID AND ClavePresupuestal = @ClavePresupuestal AND Tipo = @Tipo AND Periodo = @p
SELECT @SumaImporte = ISNULL(SUM(Importe), 0.0) FROM CPCal WHERE ID = @ID AND ClavePresupuestal = @ClavePresupuestal AND Tipo = @Tipo
END
IF @Importe <> @SumaImporte
SELECT @Ok = 25520
END
IF @TieneArticulosEsp = 1 AND @MovTipo NOT IN ('CP.RF')
BEGIN
IF NOT EXISTS(SELECT * FROM CPArt WHERE ID = @ID AND ClavePresupuestal = @ClavePresupuestal AND Tipo = @Tipo)
SELECT @Ok = 25550
SELECT @SumaImporte = 0.0
SELECT @SumaImporte = ISNULL(SUM(Cantidad*Precio), 0.0) FROM CPArt WHERE ID = @ID AND ClavePresupuestal = @ClavePresupuestal AND Tipo = @Tipo
IF @Importe <> @SumaImporte
SELECT @Ok = 25525
IF @Tipo = 'REDUCCION'
EXEC spCPVerificarReduccion @ID, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio, @FechaEmision, @Estatus, @EstatusNuevo, @FechaRegistro,
@Proyecto, @Ejercicio, @Periodo,
@ClavePresupuestal, @Tipo,
@Conexion, @SincroFinal, @Sucursal, @Ok OUTPUT, @OkRef OUTPUT
END
END
SELECT @SaldoPresupuesto	 = 0.0,
@SaldoComprometido	 = 0.0,
@SaldoComprometido2	 = 0.0,
@SaldoDevengado		 = 0.0,
@SaldoDevengado2		 = 0.0,
@SaldoEjercido		 = 0.0,
@SaldoEjercidoPagado	 = 0.0,
@SaldoAnticipos           = 0.0,
@SaldoRemanenteDisponible = 0.0,
@SaldoSobrante		 = 0.0,
@SaldoDisponible		 = 0.0
SELECT @SaldoPresupuesto	 = Presupuesto,
@SaldoComprometido	 = Comprometido,
@SaldoComprometido2	 = Comprometido2,
@SaldoDevengado		 = Devengado,
@SaldoDevengado2		 = Devengado2,
@SaldoEjercido		 = Ejercido,
@SaldoEjercidoPagado	 = EjercidoPagado,
@SaldoAnticipos           = Anticipos,
@SaldoRemanenteDisponible = RemanenteDisponible,
@SaldoSobrante		 = Sobrante,
@SaldoDisponible		 = Disponible
FROM CPNeto
WHERE Empresa = @Empresa AND Proyecto = @Proyecto AND ClavePresupuestal = @ClavePresupuestal
IF @MovTipo IN ('CP.AS', 'CP.TA', 'CP.TR') AND @Tipo = 'REDUCCION' AND @Importe > @SaldoDisponible AND @Ok IS NULL
SELECT @Ok = 20902
IF @MovTipo = 'CP.OP' AND @Ok IS NULL
BEGIN
IF (ROUND(@SaldoPresupuesto		+ @Presupuesto, 2)   < 0.0)
OR (ROUND(@SaldoComprometido		+ @Comprometido, 2)  < 0.0)
OR (ROUND(@SaldoComprometido2		+ @Comprometido2, 2) < 0.0)
OR (ROUND(@SaldoDevengado		+ @Devengado + @SaldoAnticipos, 2)     < 0.0)
OR (ROUND(@SaldoDevengado2		+ @Devengado2, 2)    < 0.0)
OR (ROUND(@SaldoEjercido		+ @Ejercido, 2)      < 0.0)
OR (ROUND(@SaldoEjercidoPagado	+ @EjercidoPagado, 2)< 0.0)
OR (ROUND(@SaldoAnticipos		+ @Anticipos, 2) < 0.0)
OR (ROUND(@SaldoRemanenteDisponible	+ @RemanenteDisponible, 2) < 0.0)
OR (ROUND(@SaldoSobrante		+ @Sobrante, 2)      < 0.0)
OR (ROUND(@SaldoDisponible		+ @Disponible, 2)    < 0.0)
SELECT @Ok = 20902
END
SELECT @TotalEjercido = @SaldoEjercido + @Ejercido + @SaldoEjercidoPagado + @EjercidoPagado
IF @MovTipo = 'CP.OP' AND @Ejercido > 0.0 AND @Ok IS NULL
BEGIN
SELECT @FlujoAlPeriodo = 0.0
SELECT @FlujoAlPeriodo = ISNULL(SUM(Presupuesto), 0.0)
FROM CPCalDisponible
WHERE Empresa = @Empresa AND Proyecto = @Proyecto AND ClavePresupuestal = @ClavePresupuestal AND Ejercicio = @Ejercicio AND Periodo <= @Periodo
IF ROUND(@TotalEjercido, 0) > ROUND(@FlujoAlPeriodo, 0)
SELECT @Ok = 25530, @OkRef = RTRIM(@Mov)+'<BR>'+'Excedente: '+CONVERT(varchar, @TotalEjercido - @FlujoAlPeriodo)+ '<BR>'+@ClavePresupuestal
END
IF @MovTipo IN ('CP.RF', 'CP.TA', 'CP.TR') AND @Ok IS NULL
BEGIN
DECLARE crCPVerificarRF CURSOR LOCAL FOR
SELECT Periodo, Importe * CASE WHEN @Tipo = 'REDUCCION' THEN -1.0 ELSE 1.0 END
FROM CPCal
WHERE ID = @ID AND ClavePresupuestal = @ClavePresupuestal AND Tipo = @Tipo
OPEN crCPVerificarRF
FETCH NEXT FROM crCPVerificarRF INTO @PeriodoD, @Reservado
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @MovTipo <> 'CP.RF' SELECT @Reservado = -@Reservado
SELECT @FlujoAlPeriodo = 0.0
SELECT @FlujoAlPeriodo = ISNULL(SUM(Presupuesto), 0.0)
FROM CPCalDisponible
WHERE Empresa = @Empresa AND Proyecto = @Proyecto AND ClavePresupuestal = @ClavePresupuestal AND Ejercicio = @Ejercicio AND Periodo <= @PeriodoD
IF ROUND(@TotalEjercido, 0) + ROUND(@Reservado, 0) > ROUND(@FlujoAlPeriodo, 0)
SELECT @Ok = 25530, @OkRef = RTRIM(@Mov)+'<BR>'+'Excedente: '+CONVERT(varchar, @TotalEjercido + @Reservado - @FlujoAlPeriodo)+ '<BR>'+@ClavePresupuestal+' '+@Tipo
END
FETCH NEXT FROM crCPVerificarRF INTO @PeriodoD, @Reservado
END
CLOSE crCPVerificarRF
DEALLOCATE crCPVerificarRF
END
IF @Tipo = 'REDUCCION'
SELECT @SumaImporte = @SumaImporte - ISNULL(@Importe, 0.0)
ELSE
SELECT @SumaImporte = @SumaImporte + ISNULL(@Importe, 0.0)
IF @Ok IS NOT NULL AND @OkRef IS NULL SELECT @OkRef = RTRIM(@Mov)+'<BR>'+@ClavePresupuestal
END
FETCH NEXT FROM crCPVerificar INTO @ClavePresupuestal, @TieneArticulosEsp, @Tipo, @Importe, @Presupuesto, @Comprometido, @Comprometido2, @Devengado, @Devengado2, @Ejercido, @EjercidoPagado, @Anticipos, @RemanenteDisponible, @Sobrante, @Disponible
END
CLOSE crCPVerificar
DEALLOCATE crCPVerificar
IF @MovTipo IN ('CP.TA', 'CP.TR') AND @Ok IS NULL
BEGIN
SELECT @SumaImporte = 0.0
SELECT @SumaImporte = ISNULL(SUM(CASE WHEN UPPER(Tipo) = 'REDUCCION' THEN -Importe ELSE Importe END), 0)
FROM CPD
WHERE ID = @ID
IF @SumaImporte <> 0.0
SELECT @Ok = 25540
END
IF @Ok IS NULL
BEGIN
DELETE CPCal WHERE ID = @ID AND EnMov IS NULL
DELETE CPArt WHERE ID = @ID AND EnMov IS NULL
END
END
RETURN
END

