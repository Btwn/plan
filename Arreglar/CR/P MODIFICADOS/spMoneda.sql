SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMoneda
@Accion	     char(20),
@MovMoneda	     char(10),
@MovTipoCambio    float,
@CuentaMoneda     char(10),
@CuentaFactor     float    OUTPUT,
@CuentaTipoCambio float    OUTPUT,
@Ok		     int      OUTPUT,
@Modulo	     char(5)	= NULL,
@ModuloID	     int	= NULL

AS BEGIN
DECLARE
@TipoCambioBase	float,
@ToleranciaBase	float,
@Minimo		float,
@Maximo		float
SELECT @CuentaFactor = 1.0, @CuentaTipoCambio = ISNULL(@CuentaTipoCambio, 0.0)
IF ISNULL(@MovTipoCambio, 0) = 0 SELECT @Ok = 30140 ELSE
IF @MovMoneda     IS NULL SELECT @Ok = 30040 ELSE
IF @CuentaMoneda  IS NULL SELECT @Ok = 30050
ELSE
BEGIN
IF UPPER(@MovMoneda) <> UPPER(@CuentaMoneda)
BEGIN
IF @Accion = 'CANCELAR' AND @CuentaTipoCambio <> 0.0
SELECT @CuentaTipoCambio = @CuentaTipoCambio
ELSE BEGIN
SELECT @CuentaTipoCambio = 1.0
IF EXISTS(SELECT * FROM DINERO WITH (NOLOCK) WHERE ID = @ModuloID )
SELECT @CuentaTipoCambio = ISNULL(TipoCambioDestino, 1.0) FROM DINERO WITH (NOLOCK) WHERE ID = @ModuloID
ELSE
SELECT @CuentaTipoCambio = ISNULL(TipoCambio, 1.0)
FROM Mon WITH (NOLOCK)
WHERE Moneda = @CuentaMoneda
END
SELECT @CuentaFactor = @CuentaTipoCambio / @MovTipoCambio
IF @@ERROR <> 0 SELECT @Ok = 1
END ELSE
SELECT @CuentaTipoCambio = @MovTipoCambio
IF @Accion <> 'CANCELAR'
BEGIN
SELECT @TipoCambioBase = TipoCambio,
@ToleranciaBase = Tolerancia
FROM Mon WITH (NOLOCK)
WHERE Moneda = @MovMoneda
SELECT @Minimo = @TipoCambioBase * (1 - (@ToleranciaBase/100.0)),
@Maximo = @TipoCambioBase * (1 + (@ToleranciaBase/100.0))
IF @MovTipoCambio < @Minimo SELECT @Ok = 35080 ELSE
IF @MovTipoCambio > @Maximo SELECT @Ok = 35090
END
END
RETURN
END

