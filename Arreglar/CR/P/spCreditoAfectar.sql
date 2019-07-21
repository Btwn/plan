SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCreditoAfectar
@ID                		int,
@Accion			char(20),
@Empresa	      		char(5),
@Modulo	      		char(5),
@Mov	  	      		char(20),
@MovID             		varchar(20)	OUTPUT,
@MovTipo     		char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision      		datetime,
@FechaAfectacion      	datetime,
@FechaConclusion		datetime,
@Proyecto	      		varchar(50),
@Usuario	      		char(10),
@Autorizacion      		char(10),
@DocFuente	      		int,
@Observaciones     		varchar(255),
@Concepto     		varchar(50),
@Referencia			varchar(50),
@Estatus           		char(15),
@EstatusNuevo	      	char(15),
@FechaRegistro     		datetime,
@Ejercicio	      		int,
@Periodo	      		int,
@MovUsuario			char(10),
@Deudor			varchar(10),
@Acreedor			varchar(10),
@Importe			money,
@LineaCreditoEsp		bit,
@LineaCredito		varchar(20),
@LineaCreditoFondeo		varchar(20),
@TipoAmortizacion		varchar(20),
@TipoTasa			varchar(20),
@TieneTasaEsp		bit,
@TasaEsp			float,
@Condicion			varchar(50),
@Vencimiento			datetime,
@Comisiones			money,
@ComisionesIVA		money,
@CtaDinero			varchar(10),
@FormaPago			varchar(50),
@OrigenTipo			varchar(10),
@Origen			varchar(20),
@OrigenID			varchar(20),
@Conexion			bit,
@SincroFinal			bit,
@Sucursal			int,
@SucursalDestino		int,
@SucursalOrigen		int,
@CfgContX			bit,
@CfgContXGenerar		char(20),
@GenerarPoliza		bit,
@Generar			bit,
@GenerarMov			char(20),
@GenerarAfectado		bit,
@IDGenerar			int	     	OUTPUT,
@GenerarMovID	  	varchar(20)	OUTPUT,
@Ok                		int          OUTPUT,
@OkRef             		varchar(255) OUTPUT

AS BEGIN
DECLARE
@Fecha			datetime,
@FechaCancelacion		datetime,
@GenerarMovTipo		char(20),
@GenerarPeriodo		int,
@GenerarEjercicio		int,
@MovDocumentoCxc		varchar(20),
@MovDocumentoCxp		varchar(20),
@MovPrestamoCxc		varchar(20),
@MovPrestamoCxp		varchar(20),
@MovComisiones		varchar(20),
@MovFondeo			varchar(20),
@MovFondeoAnticipado	varchar(20),
@MovDisposicion		varchar(20),
@MovBackToBack		varchar(20),
@MovDepositoAnticipado	varchar(20),
@CxModulo			varchar(5),
@CxID			int,
@CxMov			varchar(20),
@CxMovID			varchar(20),
@CxContacto			varchar(10),
@CxImporte			money,
@CxCondicion		varchar(50),
@CxVencimiento		datetime,
@DineroID			int,
@DineroMov			varchar(20),
@DineroMovID		varchar(20),
@TasaDiaria 		float,
@TasaTotal			float,
@Dias			int,
@Descuento			money,
@IDOrigen			int,
@GenerarLineaCreditoExpress	bit,
@GenerarLineaCredito	varchar(20)
SELECT @GenerarLineaCreditoExpress = 0,
@GenerarLineaCredito        = NULL
SELECT @MovDocumentoCxc     = CreditoDocumentoCxc,
@MovDocumentoCxp     = CreditoDocumentoCxp,
@MovPrestamoCxc      = CreditoPrestamoCxc,
@MovPrestamoCxp      = CreditoPrestamoCxp,
@MovComisiones       = CreditoComisiones,
@MovDisposicion      = CreditoDisposicion,
@MovBackToBack       = CreditoBackToBack,
@MovFondeo           = CreditoFondeo,
@MovFondeoAnticipado = CreditoFondeoAnticipado,
@MovDepositoAnticipado = CreditoDepositoAnticipado
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
IF @LineaCreditoEsp = 0
SELECT @GenerarLineaCreditoExpress = 1
ELSE
SELECT @GenerarLineaCredito = @LineaCredito
EXEC spMovConsecutivo @Sucursal, @SucursalOrigen, @SucursalDestino, @Empresa, @Usuario, @Modulo, @Ejercicio, @Periodo, @ID, @Mov, NULL, @Estatus, @Concepto, @Accion, @Conexion, @SincroFinal, @MovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR') AND @Accion <> 'CANCELAR' AND @Ok IS NULL
EXEC spMovChecarConsecutivo	@Empresa, @Modulo, @Mov, @MovID, NULL, @Ejercicio, @Periodo, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion IN ('CONSECUTIVO', 'SINCRO') AND @Ok IS NULL
BEGIN
IF @Accion = 'SINCRO' EXEC spAsignarSucursalEstatus @ID, @Modulo, @SucursalDestino, @Accion
SELECT @Ok = 80060, @OkRef = @MovID
RETURN
END
IF @OK IS NOT NULL RETURN
IF @Accion = 'GENERAR' AND @Ok IS NULL
BEGIN
EXEC spMovGenerar @Sucursal, @Empresa, @Modulo, @Ejercicio, @Periodo, @Usuario, @FechaRegistro, 'SINAFECTAR',
NULL, NULL,
@Mov, @MovID, 0,
@GenerarMov, NULL, @GenerarMovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spMovTipo @Modulo, @GenerarMov, @FechaAfectacion, @Empresa, NULL, NULL, @GenerarMovTipo OUTPUT, @GenerarPeriodo OUTPUT, @GenerarEjercicio OUTPUT, @Ok OUTPUT
IF @Ok IS NULL SELECT @Ok = 80030
RETURN
END
IF @Conexion = 0
BEGIN TRANSACTION
EXEC spMovEstatus @Modulo, 'AFECTANDO', @ID, @Generar, @IDGenerar, @GenerarAfectado, @Ok OUTPUT
IF @Accion <> 'CANCELAR'
EXEC spRegistrarMovimiento @Sucursal, @Empresa, @Modulo, @Mov, @MovID, @ID, @Ejercicio, @Periodo, @FechaRegistro, @FechaEmision,
NULL, @Proyecto, @MovMoneda, @MovTipoCambio,
@Usuario, @Autorizacion, NULL, @DocFuente, @Observaciones,
@Generar, @GenerarMov, @GenerarMovID, @IDGenerar,
@Ok OUTPUT
IF @Accion IN ('AFECTAR', 'CANCELAR')
BEGIN
IF @Accion = 'AFECTAR'
BEGIN
IF @MovTipo = 'CREDI.CES'
SELECT @CxImporte = @Importe
ELSE
BEGIN
SELECT @Dias = DATEDIFF(day, @FechaEmision, @Vencimiento)
EXEC spTipoTasa @TipoTasa, @TasaDiaria OUTPUT, @TasaTotal OUTPUT, @TieneTasaEsp, @TasaEsp
SELECT @Descuento = @Importe * (@TasaDiaria/100.0) * @Dias
SELECT @CxImporte = @Importe
IF @MovTipo IN ('CREDI.FEX', 'CREDI.FIN', 'CREDI.CES')
SELECT @CxImporte = @CxImporte - ISNULL(@Descuento, 0.0)
END
IF @MovTipo = 'CREDI.DA'
BEGIN
EXEC @DineroID = spGenerarDinero @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, 0, 0,
@FechaRegistro, @Ejercicio, @Periodo,
@FormaPago, NULL, NULL,
@Acreedor, @CtaDinero, NULL, @Importe, NULL,
NULL, NULL, NULL,
@DineroMov OUTPUT, @DineroMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'DIN', @DineroID, @DineroMov, @DineroMovID, @Ok OUTPUT
END
IF @MovTipo IN ('CREDI.FON', 'CREDI.FOA')
BEGIN
SELECT @CxModulo = 'CXP', @CxMov = CASE @MovTipo WHEN 'CREDI.FON' THEN @MovFondeo WHEN 'CREDI.FOA' THEN @MovFondeoAnticipado END, @CxMovID = NULL, @CxContacto = @Acreedor
EXEC @CxID = spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @CxModulo, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario,  @Autorizacion, @Referencia, @DocFuente, @Observaciones,
@FechaRegistro, @Ejercicio, @Periodo,
@Condicion, @Vencimiento, @CxContacto, NULL, NULL, NULL, @CtaDinero, @FormaPago,
@CxImporte, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, @CxMov,
@CxModulo, @CxMov OUTPUT, @CxMovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @ModuloEspecifico = @CxModulo, @MovIDEspecifico = @CxMovID,
@LineaCreditoExpress = @GenerarLineaCreditoExpress, @LineaCredito = @GenerarLineaCredito,
@TipoAmortizacion = @TipoAmortizacion, @TipoTasa = @TipoTasa, @TieneTasaEsp = @TieneTasaEsp, @TasaEsp = @TasaEsp
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @CxModulo, @CxID, @CxMov, @CxMovID, @Ok OUTPUT
END
IF @MovTipo IN ('CREDI.DIS', 'CREDI.BTB')
BEGIN
SELECT @CxModulo = 'CXC', @CxMov = CASE @MovTipo WHEN 'CREDI.DIS' THEN @MovDisposicion WHEN 'CREDI.BTB' THEN @MovBackToBack END, @CxMovID = NULL, @CxContacto = @Deudor
EXEC @CxID = spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @CxModulo, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario,  @Autorizacion, @Referencia, @DocFuente, @Observaciones,
@FechaRegistro, @Ejercicio, @Periodo,
@Condicion, @Vencimiento, @CxContacto, NULL, NULL, NULL, @CtaDinero, @FormaPago,
@CxImporte, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, @CxMov,
@CxModulo, @CxMov OUTPUT, @CxMovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @ModuloEspecifico = @CxModulo, @MovIDEspecifico = @CxMovID,
@LineaCreditoExpress = @GenerarLineaCreditoExpress, @LineaCredito = @GenerarLineaCredito,
@TipoAmortizacion = @TipoAmortizacion, @TipoTasa = @TipoTasa, @TieneTasaEsp = @TieneTasaEsp, @TasaEsp = @TasaEsp
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @CxModulo, @CxID, @CxMov, @CxMovID, @Ok OUTPUT
END
IF @MovTipo IN ('CREDI.FEX', 'CREDI.FIN', 'CREDI.CES')
BEGIN
SELECT @CxCondicion = @Condicion, @CxVencimiento = @Vencimiento
IF @MovTipo IN ('CREDI.FEX', 'CREDI.FIN')
SELECT @CxCondicion = '(Fecha)', @CxVencimiento = @FechaEmision
SELECT @CxModulo = 'CXP', @CxMov = @MovDocumentoCxp, @CxMovID = NULL, @CxContacto = @Acreedor
EXEC @CxID = spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @CxModulo, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario,  @Autorizacion, @Referencia, @DocFuente, @Observaciones,
@FechaRegistro, @Ejercicio, @Periodo,
@CxCondicion, @CxVencimiento, @CxContacto, NULL, NULL, NULL, NULL, NULL,
@CxImporte, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, @CxMov,
@CxModulo, @CxMov OUTPUT, @CxMovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @ModuloEspecifico = @CxModulo, @MovIDEspecifico = @CxMovID
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @CxModulo, @CxID, @CxMov, @CxMovID, @Ok OUTPUT
SELECT @CxModulo = 'CXC', @CxMov = @MovDocumentoCxc, @CxContacto = @Deudor
IF @MovTipo = 'CREDI.CES'
EXEC @CxID = spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @CxModulo, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario,  @Autorizacion, @Referencia, @DocFuente, @Observaciones,
@FechaRegistro, @Ejercicio, @Periodo,
@Condicion, @Vencimiento, @CxContacto, NULL, NULL, NULL, NULL, NULL,
@CxImporte, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, @CxMov,
@CxModulo, @CxMov OUTPUT, @CxMovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @ModuloEspecifico = @CxModulo, @MovIDEspecifico = @CxMovID
ELSE
EXEC @CxID = spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @CxModulo, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario,  @Autorizacion, @Referencia, @DocFuente, @Observaciones,
@FechaRegistro, @Ejercicio, @Periodo,
@Condicion, @Vencimiento, @CxContacto, NULL, NULL, NULL, NULL, NULL,
@CxImporte, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, @CxMov,
@CxModulo, @CxMov OUTPUT, @CxMovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @ModuloEspecifico = @CxModulo, @MovIDEspecifico = @CxMovID,
@LineaCreditoExpress = @GenerarLineaCreditoExpress, @LineaCredito = @GenerarLineaCredito,
@TipoAmortizacion = @TipoAmortizacion, @TipoTasa = @TipoTasa, @TieneTasaEsp = @TieneTasaEsp, @TasaEsp = @TasaEsp
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @CxModulo, @CxID, @CxMov, @CxMovID, @Ok OUTPUT
END
IF @MovTipo = 'CREDI.FEX'
BEGIN
SELECT @CxModulo = 'CXP', @CxMov = @MovPrestamoCxp, @CxMovID = NULL, @CxContacto = @Deudor
EXEC @CxID = spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @CxModulo, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario,  @Autorizacion, @Referencia, @DocFuente, @Observaciones,
@FechaRegistro, @Ejercicio, @Periodo,
@Condicion, @Vencimiento, @CxContacto, NULL, NULL, NULL, @CtaDinero, @FormaPago,
@CxImporte, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, @CxMov,
@CxModulo, @CxMov OUTPUT, @CxMovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @ModuloEspecifico = @CxModulo, @MovIDEspecifico = @CxMovID,
@LineaCreditoExpress = @GenerarLineaCreditoExpress, @LineaCredito = @GenerarLineaCredito,
@TipoAmortizacion = @TipoAmortizacion, @TipoTasa = @TipoTasa, @TieneTasaEsp = @TieneTasaEsp, @TasaEsp = @TasaEsp
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @CxModulo, @CxID, @CxMov, @CxMovID, @Ok OUTPUT
SELECT @CxModulo = 'CXC', @CxMov = @MovPrestamoCxc
EXEC @CxID = spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @CxModulo, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario,  @Autorizacion, @Referencia, @DocFuente, @Observaciones,
@FechaRegistro, @Ejercicio, @Periodo,
'(Fecha)', @FechaEmision, @CxContacto, NULL, NULL, NULL, @CtaDinero, @FormaPago,
@CxImporte, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, @CxMov,
@CxModulo, @CxMov OUTPUT, @CxMovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @ModuloEspecifico = @CxModulo, @MovIDEspecifico = @CxMovID
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @CxModulo, @CxID, @CxMov, @CxMovID, @Ok OUTPUT
IF NULLIF(@Comisiones, 0.0) IS NOT NULL
BEGIN
SELECT @CxModulo = 'CXC', @CxMov = @MovComisiones, @CxMovID = NULL
EXEC @CxID = spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @CxModulo, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario,  @Autorizacion, @Referencia, @DocFuente, @Observaciones,
@FechaRegistro, @Ejercicio, @Periodo,
@Condicion, @Vencimiento, @CxContacto, NULL, NULL, NULL, NULL, NULL,
@Comisiones, @ComisionesIVA, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, @CxMov,
@CxModulo, @CxMov OUTPUT, @CxMovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @ModuloEspecifico = @CxModulo, @MovIDEspecifico = @CxMovID
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @CxModulo, @CxID, @CxMov, @CxMovID, @Ok OUTPUT
END
END
END
IF @MovTipo = 'CREDI.FOA'
BEGIN
UPDATE Credito
SET @IDOrigen = ID,
Estatus = CASE WHEN @Accion = 'CANCELAR' THEN 'PENDIENTE' ELSE 'CONCLUIDO' END
WHERE Empresa = @Empresa AND Estatus = CASE WHEN @Accion = 'CANCELAR' THEN 'CONCLUIDO' ELSE 'PENDIENTE' END AND Mov = @Origen AND MovID = @OrigenID
IF @@ROWCOUNT = 0
SELECT @Ok = 20380, @OkRef = @Origen+' '+@OrigenID
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @IDOrigen, @Origen, @OrigenID, @Modulo, @ID, @Mov, @MovID, @Ok OUTPUT
END
IF @Ok IN (NULL, 80030)
BEGIN
IF @EstatusNuevo = 'CANCELADO' SELECT @FechaCancelacion = @FechaRegistro ELSE SELECT @FechaCancelacion = NULL
IF @EstatusNuevo = 'CONCLUIDO' SELECT @FechaConclusion  = @FechaEmision  ELSE IF @EstatusNuevo <> 'CANCELADO' SELECT @FechaConclusion  = NULL
IF @CfgContX = 1 AND @CfgContXGenerar <> 'NO'
BEGIN
IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @EstatusNuevo <> 'CANCELADO' SELECT @GenerarPoliza = 1 ELSE
IF @Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @EstatusNuevo =  'CANCELADO' IF @GenerarPoliza = 1 SELECT @GenerarPoliza = 0 ELSE SELECT @GenerarPoliza = 1
END
EXEC spValidarTareas @Empresa, @Modulo, @ID, @EstatusNuevo, @Ok OUTPUT, @OkRef OUTPUT
UPDATE Credito
SET FechaConclusion  = @FechaConclusion,
FechaCancelacion = @FechaCancelacion,
UltimoCambio     = CASE WHEN UltimoCambio IS NULL THEN @FechaRegistro ELSE UltimoCambio END,
Estatus          = @EstatusNuevo,
Situacion 	= CASE WHEN @Estatus<>@EstatusNuevo THEN NULL ELSE Situacion END,
GenerarPoliza    = @GenerarPoliza
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
END
END
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spMovFinal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion = 'CANCELAR' AND @EstatusNuevo = 'CANCELADO' AND @Ok IS NULL
EXEC spCancelarFlujo @Empresa, @Modulo, @ID, @Ok OUTPUT, @CancelarHijos = 1
IF @Conexion = 0
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
RETURN
END

