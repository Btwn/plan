SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvAfectarDineroPOS
@ID                	int,
@Accion				char(20),
@Base				char(20),
@Empresa	      	char(5),
@Modulo	      		char(5),
@Mov	  	      	char(20),
@MovID             	varchar(20)		OUTPUT,
@MovTipo     		char(20),
@MovMoneda	      	char(10),
@MovTipoCambio		float,
@FechaEmision		datetime,
@FechaAfectacion    datetime,
@FechaConclusion	datetime,
@Concepto	      	varchar(50),
@Proyecto	      	varchar(50),
@Usuario	      	char(10),
@Autorizacion      	char(10),
@Referencia	      	varchar(50),
@DocFuente	      	int,
@Observaciones     	varchar(255),
@Estatus           	char(15),
@EstatusNuevo		char(15),
@FechaRegistro     	datetime,
@Ejercicio	      	int,
@Periodo	      	int,
@ClienteProv		char(10),
@EnviarA			int,
@SucursalOrigen		int,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT,
@EsCargo        	bit				OUTPUT,
@CtaDinero			char(10)		OUTPUT,
@Cajero				char(10)		OUTPUT,
@DineroMov			char(20)		OUTPUT,
@DineroMovID		varchar(20)		OUTPUT,
@FormaPagoCambio	varchar(50)		OUTPUT,
@CobroCambio        money			OUTPUT,
@DineroImporte		money			OUTPUT,
@CobroDelEfectivo	money			OUTPUT,
@CobroSumaEfectivo	money			OUTPUT,
@Importe1			money			OUTPUT,
@Importe2			money			OUTPUT,
@Importe3			money			OUTPUT,
@Importe4			money			OUTPUT,
@Importe5			money			OUTPUT,
@ImporteCambio		money			OUTPUT,
@FormaCobro1		varchar(50)		OUTPUT,
@FormaCobro2		varchar(50)		OUTPUT,
@FormaCobro3		varchar(50)		OUTPUT,
@FormaCobro4		varchar(50)		OUTPUT,
@FormaCobro5		varchar(50)		OUTPUT,
@Referencia1		varchar(50)		OUTPUT,
@Referencia2		varchar(50)		OUTPUT,
@Referencia3		varchar(50)		OUTPUT,
@Referencia4		varchar(50)		OUTPUT,
@Referencia5		varchar(50)		OUTPUT,
@FormaMoneda		char(10)		OUTPUT,
@FormaTipoCambio	float			OUTPUT,
@FormaCobroVales	varchar(50)		OUTPUT,
@TipoCambio1		float           OUTPUT,
@TipoCambio2		float           OUTPUT,
@TipoCambio3		float           OUTPUT,
@TipoCambio4		float           OUTPUT,
@TipoCambio5		float           OUTPUT

AS
BEGIN
DECLARE
@MovMonedaD	      	varchar(10),
@POSMonedaAct		bit
SELECT @POSMonedaAct = POSMonedaAct
FROM POSCfg
WHERE Empresa = @Empresa
IF @CobroDelEfectivo <> 0.0
BEGIN
IF @MovTipo IN ('VTAS.VP', 'VTAS.SD')
SELECT @EsCargo = 0
ELSE
SELECT @EsCargo = 1
IF @Accion = 'CANCELAR' SELECT @EsCargo = ~@EsCargo
EXEC spSaldo @SucursalOrigen, @Accion, @Empresa, @Usuario, 'CEFE', @MovMoneda, @MovTipoCambio, @ClienteProv, NULL, NULL, NULL,
@Modulo, @ID, @Mov, @MovID, @EsCargo, @CobroDelEfectivo, NULL, NULL,
@FechaAfectacion, @Ejercicio, @Periodo, 'Saldo a Favor', NULL, 0, 0, 0,
@Ok OUTPUT, @OkRef OUTPUT
END
IF @DineroImporte <> 0.0
BEGIN
SELECT @CobroSumaEfectivo = 0.0
IF @Importe1 <> 0.0
BEGIN
SELECT @MovMonedaD = CASE WHEN @POSMonedaAct = 0
THEN NULLIF(RTRIM(Moneda), '')
ELSE NULLIF(RTRIM(POSMoneda), '')
END
FROM FormaPago
WHERE FormaPago = @FormaCobro1
SELECT @MovMonedaD = ISNULL(@MovMonedaD,@MovMoneda)
EXEC spFormaPagoMonTCPOS @FormaCobro1, @Referencia1, @MovMonedaD, @TipoCambio1, @Importe1,
@CobroSumaEfectivo OUTPUT, @FormaMoneda OUTPUT, @FormaTipoCambio OUTPUT, @Ok OUTPUT, @FormaCobroVales, @Empresa
EXEC spGenerarDinero @SucursalOrigen, @SucursalOrigen, @SucursalOrigen, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID,
@MovTipo, @FormaMoneda, @FormaTipoCambio, @FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia1,
@DocFuente, @Observaciones, 0, 0, @FechaRegistro, @Ejercicio, @Periodo, @FormaCobro1, NULL, NULL,
@ClienteProv, @CtaDinero, @Cajero, @Importe1, NULL, NULL, NULL, NULL, @DineroMov OUTPUT, @DineroMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
END
IF @Importe2 <> 0.0
BEGIN
SELECT @MovMonedaD = CASE WHEN @POSMonedaAct = 0
THEN NULLIF(RTRIM(Moneda), '')
ELSE NULLIF(RTRIM(POSMoneda), '')
END
FROM FormaPago
WHERE FormaPago = @FormaCobro2
EXEC spFormaPagoMonTCPOS @FormaCobro2, @Referencia2, @MovMonedaD, @TipoCambio2, @Importe2,
@CobroSumaEfectivo OUTPUT, @FormaMoneda OUTPUT, @FormaTipoCambio OUTPUT, @Ok OUTPUT, @FormaCobroVales, @Empresa
EXEC spGenerarDinero @SucursalOrigen, @SucursalOrigen, @SucursalOrigen, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID,
@MovTipo, @FormaMoneda, @FormaTipoCambio, @FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia2,
@DocFuente, @Observaciones, 0, 0, @FechaRegistro, @Ejercicio, @Periodo, @FormaCobro2, NULL, NULL,
@ClienteProv, @CtaDinero, @Cajero, @Importe2, NULL, NULL, NULL, NULL,
@DineroMov OUTPUT, @DineroMovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Importe3 <> 0.0
BEGIN
SELECT @MovMonedaD = CASE WHEN @POSMonedaAct = 0
THEN NULLIF(RTRIM(Moneda), '')
ELSE NULLIF(RTRIM(POSMoneda), '')
END
FROM FormaPago
WHERE FormaPago = @FormaCobro3
EXEC spFormaPagoMonTCPOS @FormaCobro3, @Referencia3, @MovMonedaD, @TipoCambio3, @Importe3,
@CobroSumaEfectivo OUTPUT, @FormaMoneda OUTPUT, @FormaTipoCambio OUTPUT, @Ok OUTPUT, @FormaCobroVales, @Empresa
EXEC spGenerarDinero @SucursalOrigen, @SucursalOrigen, @SucursalOrigen, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo,
@FormaMoneda, @FormaTipoCambio, @FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia3, @DocFuente,
@Observaciones, 0, 0, @FechaRegistro, @Ejercicio, @Periodo, @FormaCobro3, NULL, NULL,
@ClienteProv, @CtaDinero, @Cajero, @Importe3, NULL, NULL, NULL, NULL,
@DineroMov OUTPUT, @DineroMovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Importe4 <> 0.0
BEGIN
SELECT @MovMonedaD = CASE WHEN @POSMonedaAct = 0
THEN NULLIF(RTRIM(Moneda), '')
ELSE NULLIF(RTRIM(POSMoneda), '')
END
FROM FormaPago
WHERE FormaPago = @FormaCobro4
EXEC spFormaPagoMonTCPOS @FormaCobro4, @Referencia4, @MovMonedaD, @TipoCambio4, @Importe4,
@CobroSumaEfectivo OUTPUT, @FormaMoneda OUTPUT, @FormaTipoCambio OUTPUT, @Ok OUTPUT, @FormaCobroVales, @Empresa
EXEC spGenerarDinero @SucursalOrigen, @SucursalOrigen, @SucursalOrigen, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo,
@FormaMoneda, @FormaTipoCambio, @FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia4, @DocFuente,
@Observaciones, 0, 0, @FechaRegistro, @Ejercicio, @Periodo, @FormaCobro4, NULL, NULL,
@ClienteProv, @CtaDinero, @Cajero, @Importe4, NULL, NULL, NULL, NULL,
@DineroMov OUTPUT, @DineroMovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Importe5 <> 0.0
BEGIN
SELECT @MovMonedaD = CASE WHEN @POSMonedaAct = 0
THEN NULLIF(RTRIM(Moneda), '')
ELSE NULLIF(RTRIM(POSMoneda), '')
END
FROM FormaPago
WHERE FormaPago = @FormaCobro5
EXEC spFormaPagoMonTCPOS @FormaCobro5, @Referencia5, @MovMonedaD, @TipoCambio5, @Importe5,
@CobroSumaEfectivo OUTPUT, @FormaMoneda OUTPUT, @FormaTipoCambio OUTPUT, @Ok OUTPUT, @FormaCobroVales, @Empresa
EXEC spGenerarDinero @SucursalOrigen, @SucursalOrigen, @SucursalOrigen, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo,
@FormaMoneda, @FormaTipoCambio, @FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia5, @DocFuente,
@Observaciones, 0, 0, @FechaRegistro, @Ejercicio, @Periodo, @FormaCobro5, NULL, NULL,
@ClienteProv, @CtaDinero, @Cajero, @Importe5, NULL, NULL, NULL, NULL,
@DineroMov OUTPUT, @DineroMovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
END
END

