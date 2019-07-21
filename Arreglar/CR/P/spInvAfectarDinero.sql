SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvAfectarDinero
@ID                	int,
@Accion		char(20),
@Base		char(20),
@Empresa	      	char(5),
@Modulo	      	char(5),
@Mov	  	      	char(20),
@MovID             	varchar(20)	OUTPUT,
@MovTipo     	char(20),
@MovMoneda	      	char(10),
@MovTipoCambio	float,
@FechaEmision	datetime,
@FechaAfectacion    	datetime,
@FechaConclusion	datetime,
@Concepto	      	varchar(50),
@Proyecto	      	varchar(50),
@Usuario	      	char(10),
@Autorizacion      	char(10),
@Referencia	      	varchar(50),
@DocFuente	      	int,
@Observaciones     	varchar(255),
@Estatus           	char(15),
@EstatusNuevo	char(15),
@FechaRegistro     	datetime,
@Ejercicio	      	int,
@Periodo	      	int,
@ClienteProv		char(10),
@EnviarA		int,
@SucursalOrigen	int,
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT,
@EsCargo        	bit		OUTPUT,
@CtaDinero		char(10)	OUTPUT,
@Cajero		char(10)	OUTPUT,
@DineroMov		char(20)	OUTPUT,
@DineroMovID		varchar(20)	OUTPUT,
@FormaPagoCambio	varchar(50)	OUTPUT,
@CobroCambio         money		OUTPUT,
@DineroImporte	money		OUTPUT,
@CobroDelEfectivo    money		OUTPUT,
@CobroSumaEfectivo	money		OUTPUT,
@Importe1		money		OUTPUT,
@Importe2		money		OUTPUT,
@Importe3		money		OUTPUT,
@Importe4		money		OUTPUT,
@Importe5		money		OUTPUT,
@ImporteCambio	money		OUTPUT,
@FormaCobro1		varchar(50)	OUTPUT,
@FormaCobro2		varchar(50)	OUTPUT,
@FormaCobro3		varchar(50)	OUTPUT,
@FormaCobro4		varchar(50)	OUTPUT,
@FormaCobro5		varchar(50)	OUTPUT,
@Referencia1		varchar(50)	OUTPUT,
@Referencia2		varchar(50)	OUTPUT,
@Referencia3		varchar(50)	OUTPUT,
@Referencia4		varchar(50)	OUTPUT,
@Referencia5		varchar(50)	OUTPUT,
@FormaMoneda		char(10)	OUTPUT,
@FormaTipoCambio	float		OUTPUT,
@FormaCobroVales	varchar(50)	OUTPUT,
@FormaCobroCambio	varchar(50) OUTPUT, 
@InterfazTC			bit,	
@TCDelEfectivo		float,	
@TCProcesado1		bit,	
@TCProcesado2		bit,	
@TCProcesado3		bit,	
@TCProcesado4		bit,	
@TCProcesado5		bit	

AS BEGIN
DECLARE @TCActivarInterfaz1		bit, 
@TCActivarInterfaz2		bit, 
@TCActivarInterfaz3		bit, 
@TCActivarInterfaz4		bit, 
@TCActivarInterfaz5		bit, 
@sDineroID				int,
@sDineroMov				varchar(20),
@sDineroMovID			varchar(20)
IF @InterfazTC = 1 
BEGIN
SELECT @TCActivarInterfaz1	= ISNULL(TCActivarInterfaz, 0) FROM FormaPago WHERE FormaPago = @FormaCobro1
SELECT @TCActivarInterfaz2	= ISNULL(TCActivarInterfaz, 0) FROM FormaPago WHERE FormaPago = @FormaCobro2
SELECT @TCActivarInterfaz3	= ISNULL(TCActivarInterfaz, 0) FROM FormaPago WHERE FormaPago = @FormaCobro3
SELECT @TCActivarInterfaz4	= ISNULL(TCActivarInterfaz, 0) FROM FormaPago WHERE FormaPago = @FormaCobro4
SELECT @TCActivarInterfaz5	= ISNULL(TCActivarInterfaz, 0) FROM FormaPago WHERE FormaPago = @FormaCobro5
IF NULLIF(@FormaCobro1, '') IS NOT NULL AND @TCActivarInterfaz1 = 1 SELECT @FormaCobro1 = NULL, @Importe1 = 0, @Referencia1 = NULL
IF NULLIF(@FormaCobro2, '') IS NOT NULL AND @TCActivarInterfaz2 = 1 SELECT @FormaCobro2 = NULL, @Importe2 = 0, @Referencia2 = NULL
IF NULLIF(@FormaCobro3, '') IS NOT NULL AND @TCActivarInterfaz3 = 1 SELECT @FormaCobro3 = NULL, @Importe3 = 0, @Referencia3 = NULL
IF NULLIF(@FormaCobro4, '') IS NOT NULL AND @TCActivarInterfaz4 = 1 SELECT @FormaCobro4 = NULL, @Importe4 = 0, @Referencia4 = NULL
IF NULLIF(@FormaCobro5, '') IS NOT NULL AND @TCActivarInterfaz5 = 1 SELECT @FormaCobro5 = NULL, @Importe5 = 0, @Referencia5 = NULL
SELECT @CobroDelEfectivo = ISNULL(@CobroDelEfectivo, 0) + ISNULL(@TCDelEfectivo, 0)
END
IF @CobroDelEfectivo <> 0.0
BEGIN
IF @MovTipo IN ('VTAS.VP', 'VTAS.SD') SELECT @EsCargo = 0 ELSE SELECT @EsCargo = 1
IF @Accion = 'CANCELAR' SELECT @EsCargo = ~@EsCargo
EXEC spSaldo @SucursalOrigen /*@Sucursal*/, @Accion, @Empresa, @Usuario, 'CEFE', @MovMoneda, @MovTipoCambio, @ClienteProv, NULL, NULL, NULL,
@Modulo, @ID, @Mov, @MovID, @EsCargo, @CobroDelEfectivo, NULL, NULL,
@FechaAfectacion, @Ejercicio, @Periodo, 'Saldo a Favor', NULL, 0, 0, 0,
@Ok OUTPUT, @OkRef OUTPUT
END
IF @DineroImporte <> 0.0
BEGIN
IF @Accion = 'CANCELAR'
BEGIN
SELECT @sDineroID = mf.DID, @sDineroMov = mf.DMov, @sDineroMovID = mf.DMovID
FROM MovFlujo mf
JOIN MovTipo mt ON mt.Modulo = 'DIN' AND mf.DMov = mt.Mov AND mt.Clave IN ('DIN.SCH','DIN.SD')
JOIN Dinero d ON mf.DID = d.ID AND Estatus = 'CONCLUIDO'
WHERE mf.Cancelado = 0
AND mf.Empresa = @Empresa
AND mf.OModulo = @Modulo
AND mf.OID     = @ID
AND mf.DModulo = 'DIN'
IF @sDineroID IS NOT NULL
SELECT @Ok = 60060, @OkRef = RTRIM(@sDineroMov)+' '+LTRIM(Convert(Char, @sDineroMovID))
END
SELECT @CobroSumaEfectivo = 0.0
IF @Importe1 <> 0.0
BEGIN
EXEC spFormaPagoMonTC @FormaCobro1, @Referencia1, @MovMoneda, @MovTipoCambio, @Importe1, @CobroSumaEfectivo OUTPUT, @FormaMoneda OUTPUT, @FormaTipoCambio OUTPUT, @Ok OUTPUT, @FormaCobroVales
/* @Sucursal, @SucursalOrigen, @SucursalDestino */
EXEC spGenerarDinero @SucursalOrigen, @SucursalOrigen, @SucursalOrigen, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @FormaMoneda, @FormaTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia1, @DocFuente, @Observaciones, 0, 0,
@FechaRegistro, @Ejercicio, @Periodo,
@FormaCobro1, NULL, NULL,
@ClienteProv, @CtaDinero, @Cajero, @Importe1, NULL,
NULL, NULL, NULL,
@DineroMov OUTPUT, @DineroMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
END
IF @Importe2 <> 0.0
BEGIN
EXEC spFormaPagoMonTC @FormaCobro2, @Referencia2, @MovMoneda, @MovTipoCambio, @Importe2, @CobroSumaEfectivo OUTPUT, @FormaMoneda OUTPUT, @FormaTipoCambio OUTPUT, @Ok OUTPUT, @FormaCobroVales
/* @Sucursal, @SucursalOrigen, @SucursalDestino */
EXEC spGenerarDinero @SucursalOrigen, @SucursalOrigen, @SucursalOrigen, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @FormaMoneda, @FormaTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia2, @DocFuente, @Observaciones, 0, 0,
@FechaRegistro, @Ejercicio, @Periodo,
@FormaCobro2, NULL, NULL,
@ClienteProv, @CtaDinero, @Cajero, @Importe2, NULL,
NULL, NULL, NULL,
@DineroMov OUTPUT, @DineroMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
END
IF @Importe3 <> 0.0
BEGIN
EXEC spFormaPagoMonTC @FormaCobro3, @Referencia3, @MovMoneda, @MovTipoCambio, @Importe3, @CobroSumaEfectivo OUTPUT, @FormaMoneda OUTPUT, @FormaTipoCambio OUTPUT, @Ok OUTPUT, @FormaCobroVales
/* @Sucursal, @SucursalOrigen, @SucursalDestino */
EXEC spGenerarDinero @SucursalOrigen, @SucursalOrigen, @SucursalOrigen, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @FormaMoneda, @FormaTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia3, @DocFuente, @Observaciones, 0, 0,
@FechaRegistro, @Ejercicio, @Periodo,
@FormaCobro3, NULL, NULL,
@ClienteProv, @CtaDinero, @Cajero, @Importe3, NULL,
NULL, NULL, NULL,
@DineroMov OUTPUT, @DineroMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
END
IF @Importe4 <> 0.0
BEGIN
EXEC spFormaPagoMonTC @FormaCobro4, @Referencia4, @MovMoneda, @MovTipoCambio, @Importe4, @CobroSumaEfectivo OUTPUT, @FormaMoneda OUTPUT, @FormaTipoCambio OUTPUT, @Ok OUTPUT, @FormaCobroVales
/* @Sucursal, @SucursalOrigen, @SucursalDestino */
EXEC spGenerarDinero @SucursalOrigen, @SucursalOrigen, @SucursalOrigen, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @FormaMoneda, @FormaTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia4, @DocFuente, @Observaciones, 0, 0,
@FechaRegistro, @Ejercicio, @Periodo,
@FormaCobro4, NULL, NULL,
@ClienteProv, @CtaDinero, @Cajero, @Importe4, NULL,
NULL, NULL, NULL,
@DineroMov OUTPUT, @DineroMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
END
IF @Importe5 <> 0.0
BEGIN
EXEC spFormaPagoMonTC @FormaCobro5, @Referencia5, @MovMoneda, @MovTipoCambio, @Importe5, @CobroSumaEfectivo OUTPUT, @FormaMoneda OUTPUT, @FormaTipoCambio OUTPUT, @Ok OUTPUT, @FormaCobroVales
/* @Sucursal, @SucursalOrigen, @SucursalDestino */
EXEC spGenerarDinero @SucursalOrigen, @SucursalOrigen, @SucursalOrigen, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @FormaMoneda, @FormaTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia5, @DocFuente, @Observaciones, 0, 0,
@FechaRegistro, @Ejercicio, @Periodo,
@FormaCobro5, NULL, NULL,
@ClienteProv, @CtaDinero, @Cajero, @Importe5, NULL,
NULL, NULL, NULL,
@DineroMov OUTPUT, @DineroMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
END
IF ROUND(@CobroCambio, 2) <> 0.0
BEGIN
IF ABS(ROUND(@CobroSumaEfectivo, 2)) < ABS(ROUND(@CobroCambio, 2)) SELECT @Ok = 30590
IF @Ok IS NULL
BEGIN
SELECT @FormaPagoCambio = ISNULL(NULLIF(@FormaCobroCambio,''),FormaPagoCambio) FROM EmpresaCfg WHERE Empresa = @Empresa 
SELECT @ImporteCambio = -@CobroCambio
EXEC spFormaPagoMonTC @FormaPagoCambio, NULL, @MovMoneda, @MovTipoCambio, @ImporteCambio, NULL, @FormaMoneda OUTPUT, @FormaTipoCambio OUTPUT, @Ok OUTPUT, @FormaCobroVales
SET @ImporteCambio = (ISNULL(@ImporteCambio,0.0) * ISNULL(@MovTipoCambio,0.0)) / ISNULL(@FormaTipoCambio,0.0) 
/* @Sucursal, @SucursalOrigen, @SucursalDestino */
EXEC spGenerarDinero @SucursalOrigen, @SucursalOrigen, @SucursalOrigen, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @FormaMoneda, @FormaTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, 'Cambio', @DocFuente, @Observaciones, 0, 0,
@FechaRegistro, @Ejercicio, @Periodo,
@FormaPagoCambio, NULL, NULL,
NULL, @CtaDinero, @Cajero, @ImporteCambio, NULL,
NULL, NULL, NULL,
@DineroMov OUTPUT, @DineroMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
END
END
END
END

