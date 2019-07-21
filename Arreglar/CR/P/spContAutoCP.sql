SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContAutoCP
@Modulo		  char(5),
@ID			  int,
@Cuenta		  varchar(20),
@CuentaOmision	  char(20),
@OmitirConcepto	  bit,
@OmitirCentroCostos	  bit,
@CentroCostos	  varchar(20),
@CentroCostosSucursal  varchar(20),
@CentroCostosDestino	  varchar(20),
@CentroCostosMatriz	  varchar(20),
@CtaCtoTipo		  varchar(20),
@CtaCtoTipoAplica	  varchar(20),
@CtaClase		  char(20),
@Concepto		  varchar(50),
@Contacto		  char(10),
@ContactoTipo	  varchar(20),
@CtaDinero		  char(10),
@CtaDineroDestino	  char(10),
@FormaPago		  varchar(50),
@Orden		  int,
@Campo		  varchar(20),
@EsDebe		  bit,
@Ok			  int		OUTPUT,
@OkRef		  varchar(255)	OUTPUT,
@CfgPartidasSinImporte bit

AS BEGIN
DECLARE
@Renglon			float,
@ClavePresupuestal		varchar(50),
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
@Importe			money,
@TipoCambio			float,
@Cta			char(20),
@Monto			money,
@Debe			money,
@Haber			money,
@ContUso			char(20)
IF @Campo IS NULL RETURN
DECLARE crMovD CURSOR FOR
SELECT d.Renglon, d.ClavePresupuestal, d.Presupuesto, d.Comprometido, d.Comprometido2, d.Devengado, d.Devengado2, d.Ejercido, d.EjercidoPagado, d.Anticipos, d.RemanenteDisponible, d.Sobrante, d.Importe, c.TipoCambio
FROM CPD d
JOIN CP c ON c.ID = d.ID
WHERE d.ID = @ID
OPEN crMovD
FETCH NEXT FROM crMovD INTO @Renglon, @ClavePresupuestal, @Presupuesto, @Comprometido, @Comprometido2, @Devengado, @Devengado2, @Ejercido, @EjercidoPagado, @Anticipos, @RemanenteDisponible, @Sobrante, @Importe, @TipoCambio
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @Monto = NULL, @Cta = NULL
EXEC spContAutoGetCuenta @Modulo, @Cuenta, @CuentaOmision, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, NULL, NULL, NULL, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Cta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Cta IS NULL
EXEC xpContAutoCuentaExtra @Modulo, @ID, @Cuenta, @CuentaOmision, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, NULL, NULL, NULL, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Cta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Cta IS NOT NULL
BEGIN
IF @Campo = 'PRESUPUESTO'   	   SELECT @Monto = @Presupuesto 	ELSE
IF @Campo = 'COMPROMETIDO'   	   SELECT @Monto = @Comprometido	ELSE
IF @Campo = 'COMPROMETIDO 2'   	   SELECT @Monto = @Comprometido2	ELSE
IF @Campo = 'DEVENGADO'   	   SELECT @Monto = @Devengado		ELSE
IF @Campo = 'DEVENGADO 2'   	   SELECT @Monto = @Devengado2		ELSE
IF @Campo = 'EJERCIDO'		   SELECT @Monto = @Ejercido		ELSE
IF @Campo = 'EJERCIDO PAGADO'	   SELECT @Monto = @EjercidoPagado	ELSE
IF @Campo = 'ANTICIPOS'		   SELECT @Monto = @Anticipos		ELSE
IF @Campo = 'REMANENTE DISPONIBLE' SELECT @Monto = @RemanenteDisponible ELSE
IF @Campo = 'SOBRANTE'		   SELECT @Monto = @Sobrante		ELSE
IF @Campo = 'IMPORTE'		   SELECT @Monto = @Importe
ELSE EXEC xpContAutoCampoExtra @Modulo, @ID, @Renglon, NULL, @Campo, @Monto OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF (NULLIF(@Monto, 0) IS NOT NULL OR @CfgPartidasSinImporte = 1)
BEGIN
SELECT @Debe = NULL, @Haber = NULL
IF @OmitirConcepto     = 1 SELECT @Concepto = NULL
IF @OmitirCentroCostos = 1 SELECT @ContUso  = NULL ELSE SELECT @ContUso = CASE @CentroCostos WHEN 'Sucursal' THEN @CentroCostosSucursal WHEN 'Sucursal Destino' THEN @CentroCostosDestino WHEN 'Matriz' THEN @CentroCostosMatriz ELSE @ContUso END
IF @EsDebe = 1
SELECT @Debe = @Monto*@TipoCambio
ELSE
SELECT @Haber = @Monto*@TipoCambio
INSERT #Poliza (Renglon,  Orden,  Cuenta, SubCuenta, Concepto,  Debe,  Haber)
VALUES (@Renglon, @Orden, @Cta,   @ContUso,  @Concepto, @Debe, @Haber)
END
END
END
FETCH NEXT FROM crMovD INTO @Renglon, @ClavePresupuestal, @Presupuesto, @Comprometido, @Comprometido2, @Devengado, @Devengado2, @Ejercido, @EjercidoPagado, @Anticipos, @RemanenteDisponible, @Sobrante, @Importe, @TipoCambio
IF @@ERROR <> 0 SELECT @Ok = 1
END  
CLOSE crMovD
DEALLOCATE crMovD
RETURN
END

