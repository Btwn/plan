SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOportunidadAfectar
@ID                		int,
@Accion			char(20),
@Base			char(20),
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
@NivelInteres		varchar(50),
@Plantilla			varchar(20),
@ContactoTipo		varchar(20),
@Contacto			varchar(10),
@ImporteOportunidad	float,
@PorcentajeCierre	float,
@ImportePonderado	float,
@ProbCierre			float,
@Competidor			varchar(50),
@Motivo				varchar(100),
@Propuesta			varchar(50),
@Intermediario		varchar(10),
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
@OrigenTipo			varchar(5),
@Origen				varchar(20),
@OrigenID			varchar(20),
@IDGenerar			int	     	OUTPUT,
@GenerarMovID	  	varchar(20)	OUTPUT,
@Mensaje                	int          OUTPUT,
@Ok                		int          OUTPUT,
@OkRef             		varchar(255) OUTPUT

AS BEGIN
DECLARE
@FechaCancelacion	datetime,
@GenerarMovTipo	char(20),
@GenerarPeriodo	int,
@GenerarEjercicio	int,
@IDOrigen			int
SELECT @IDOrigen = ID FROM Oportunidad WHERE Empresa = @Empresa AND Mov = @Origen AND MovID = @OrigenID AND Estatus = 'PENDIENTE'
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
EXEC spOportunidadGenerar @ID, @Base, @Sucursal, @Empresa, @Modulo, @Ejercicio, @Periodo, @Usuario, @FechaRegistro, 'SINAFECTAR',
NULL, NULL,
@Mov, @MovID, 0,
@GenerarMov, NULL, @ContactoTipo, @GenerarMovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
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
IF @Accion IN ('AFECTAR', 'CANCELAR', 'AUTORIZAR')
BEGIN
IF @MovTipo IN ('OPORT.O') AND @Ok IS NULL
BEGIN
EXEC spOportunidadOAfectar @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio, @FechaEmision, @FechaAfectacion, @FechaConclusion, @Proyecto,
@Usuario, @Autorizacion, @DocFuente, @Observaciones, @Concepto, @Referencia, @Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo,
@MovUsuario, @NivelInteres, @Plantilla, @ContactoTipo, @Contacto, @ImporteOportunidad, @PorcentajeCierre, @ImportePonderado, @ProbCierre, @Competidor,
@Motivo, @Propuesta, @Intermediario, @Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen, @CfgContX, @CfgContXGenerar, @GenerarPoliza,
@Generar, @GenerarMov, @GenerarAfectado, @OrigenTipo, @Origen, @OrigenID, @IDGenerar OUTPUT, @GenerarMovID OUTPUT, @Mensaje OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @MovTipo IN ('OPORT.G') AND @Ok IS NULL
BEGIN
EXEC spOportunidadGAfectar @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio, @FechaEmision, @FechaAfectacion, @FechaConclusion, @Proyecto,
@Usuario, @Autorizacion, @DocFuente, @Observaciones, @Concepto, @Referencia, @Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo,
@MovUsuario, @NivelInteres, @Plantilla, @ContactoTipo, @Contacto, @ImporteOportunidad, @PorcentajeCierre, @ImportePonderado, @ProbCierre, @Competidor,
@Motivo, @Propuesta, @Intermediario, @Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen, @CfgContX, @CfgContXGenerar, @GenerarPoliza,
@Generar, @GenerarMov, @GenerarAfectado, @IDGenerar OUTPUT, @GenerarMovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @MovTipo IN ('OPORT.SD') AND @Ok IS NULL
BEGIN
EXEC spOportunidadOAfectar @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio, @FechaEmision, @FechaAfectacion, @FechaConclusion, @Proyecto,
@Usuario, @Autorizacion, @DocFuente, @Observaciones, @Concepto, @Referencia, @Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo,
@MovUsuario, @NivelInteres, @Plantilla, @ContactoTipo, @Contacto, @ImporteOportunidad, @PorcentajeCierre, @ImportePonderado, @ProbCierre, @Competidor,
@Motivo, @Propuesta, @Intermediario, @Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen, @CfgContX, @CfgContXGenerar, @GenerarPoliza,
@Generar, @GenerarMov, @GenerarAfectado, @OrigenTipo, @Origen, @OrigenID, @IDGenerar OUTPUT, @GenerarMovID OUTPUT, @Mensaje OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
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
UPDATE Oportunidad
SET FechaConclusion  = @FechaConclusion,
FechaCancelacion = @FechaCancelacion,
UltimoCambio     = CASE WHEN UltimoCambio IS NULL THEN @FechaRegistro ELSE UltimoCambio END,
Estatus          = @EstatusNuevo,
Situacion 	    = CASE WHEN @Estatus<>@EstatusNuevo THEN NULL ELSE Situacion END,
GenerarPoliza    = @GenerarPoliza
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
END
END
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @OrigenTipo, @IDOrigen, @Origen, @OrigenID, 'OPORT', @ID, @Mov, @MovID, @Ok OUTPUT
EXEC xpOportunidadAfectar @ID, @Accion, @Base, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio, @FechaEmision, @FechaAfectacion, @FechaConclusion, @Proyecto,
@Usuario, @Autorizacion, @DocFuente, @Observaciones, @Concepto, @Referencia, @Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo,
@MovUsuario, @NivelInteres, @Plantilla, @ContactoTipo, @Contacto, @ImporteOportunidad, @PorcentajeCierre, @ImportePonderado, @ProbCierre, @Competidor,
@Motivo, @Propuesta, @Intermediario, @Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen, @CfgContX, @CfgContXGenerar, @GenerarPoliza,
@Generar, @GenerarMov, @GenerarAfectado, @OrigenTipo, @Origen, @OrigenID,
@IDGenerar OUTPUT, @GenerarMovID OUTPUT, @Mensaje OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spMovFinal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion = 'CANCELAR' AND @EstatusNuevo = 'CANCELADO' AND @Ok IS NULL
EXEC spCancelarFlujo @Empresa, @Modulo, @ID, @Ok OUTPUT, 1
IF @Conexion = 0
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
COMMIT TRANSACTION
ELSE
BEGIN
DECLARE @PolizaDescuadrada TABLE (Cuenta varchar(20) NULL, SubCuenta varchar(50) NULL, Concepto varchar(50) NULL, Debe money NULL, Haber money NULL, SucursalContable int NULL)
IF EXISTS(SELECT * FROM PolizaDescuadrada WHERE Modulo = @Modulo AND ID = @ID)
INSERT @PolizaDescuadrada (Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable) SELECT Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable FROM PolizaDescuadrada WHERE Modulo = @Modulo AND ID = @ID
ROLLBACK TRANSACTION
DELETE PolizaDescuadrada WHERE Modulo = @Modulo AND ID = @ID
INSERT PolizaDescuadrada (Modulo, ID, Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable) SELECT @Modulo, @ID, Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable FROM @PolizaDescuadrada
END
RETURN
END

