SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPrevencionLDAfectar
@ID                int
,@Accion		   char(20)
,@Empresa	         char(5)
,@Modulo	         char(5)
,@Mov	  	   char(20)
,@MovID            varchar(20)	OUTPUT
,@MovTipo     	   char(20)
,@MovMoneda	   char(10)
,@MovTipoCambio	   float
,@FechaEmision     datetime
,@FechaAfectacion  datetime
,@FechaConclusion  datetime
,@Proyecto	   varchar(50)
,@Usuario	         char(10)
,@Autorizacion     char(10)
,@DocFuente	   int
,@Observaciones    varchar(255)
,@Concepto         varchar(50)
,@Referencia	   varchar(50)
,@Estatus          char(15)
,@EstatusNuevo	   char(15)
,@FechaRegistro    datetime
,@Ejercicio	   int
,@Periodo	         int
,@MovUsuario       char(10)
,@Acreedor	   varchar(10)
,@Condicion	   varchar(50)
,@Vencimient       datetime
,@Conexion	   bit
,@SincroFinal	   bit
,@Sucursal	   int
,@SucursalDestino  int
,@SucursalOrigen   int
,@CfgContX	   bit
,@CfgContXGenerar char(20)
,@GenerarPoliza	   bit
,@Generar	         bit
,@GenerarMov	   char(20)
,@GenerarAfectado  bit
,@IDGenerar	   int OUTPUT
,@GenerarMovID	   varchar(20) OUTPUT
,@Ok               int OUTPUT
,@OkRef            varchar(255) OUTPUT

AS BEGIN
DECLARE
@FechaCancelacion	datetime
,@GenerarMovTipo	char(20)
,@GenerarPeriodo	int
,@GenerarEjercicio	int
,@IXPMov		varchar(20)
,@IAFMov		varchar(20)
,@CxMov		varchar(20)
,@CxMovID		varchar(20)
,@CxImporte		money
,@FiscalGenerarRetenciones bit
SELECT @IXPMov = CxpImpuestosPorPagar
,@IAFMov = CxpImpuestosFavor
FROM EmpresaCfgMov WITH(NOLOCK)
WHERE Empresa = @Empresa
SELECT @FiscalGenerarRetenciones = FiscalGenerarRetenciones
FROM EmpresaCfg2 WITH(NOLOCK)
WHERE Empresa = @Empresa
EXEC spMovConsecutivo @Sucursal, @SucursalOrigen, @SucursalDestino, @Empresa, @Usuario, @Modulo, @Ejercicio, @Periodo, @ID,
@Mov, NULL, @Estatus, @Concepto, @Accion, @Conexion, @SincroFinal, @MovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
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
IF @Ok IS NULL
BEGIN
INSERT PrevencionLDD (
Sucursal,  ID,         Renglon, Importe, OrigenModulo, OrigenModuloID, Contacto, ContactoTipo)
SELECT @Sucursal, @IDGenerar, Renglon, Importe, OrigenModulo, OrigenModuloID, Contacto, ContactoTipo
FROM PrevencionLDD WITH(NOLOCK)
WHERE ID = @ID
IF @Ok IS NULL SELECT @Ok = 80030
END
RETURN
END
ELSE
UPDATE PrevencionLDD WITH(ROWLOCK)
SET OrigenModulo = @Modulo,
OrigenModuloID = @ID
WHERE ID = @ID
IF @Conexion = 0
BEGIN TRANSACTION
EXEC spMovEstatus @Modulo, 'AFECTANDO', @ID, @Generar, @IDGenerar, @GenerarAfectado, @Ok OUTPUT
IF @Accion <> 'CANCELAR'
EXEC spRegistrarMovimiento @Sucursal, @Empresa, @Modulo, @Mov, @MovID, @ID, @Ejercicio, @Periodo
, @FechaRegistro, @FechaEmision , NULL, @Proyecto, @MovMoneda, @MovTipoCambio
, @Usuario, @Autorizacion, NULL, @DocFuente, @Observaciones, @Generar, @GenerarMov
, @GenerarMovID, @IDGenerar, @Ok OUTPUT
IF @Accion IN ('AFECTAR', 'CANCELAR')
BEGIN
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
UPDATE PrevencionLD WITH(ROWLOCK)
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
EXEC spCancelarFlujo @Empresa, @Modulo, @ID, @Ok OUTPUT, 1
IF @Conexion = 0
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
COMMIT TRANSACTION
ELSE
BEGIN
DECLARE @PolizaDescuadrada TABLE (Cuenta varchar(20) NULL, SubCuenta varchar(50) NULL, Concepto varchar(50) NULL, Debe money NULL, Haber money NULL, SucursalContable int NULL)
IF EXISTS(SELECT * FROM PolizaDescuadrada WITH(NOLOCK) WHERE Modulo = @Modulo AND ID = @ID)
INSERT @PolizaDescuadrada (Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable) SELECT Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable FROM PolizaDescuadrada WITH(NOLOCK) WHERE Modulo = @Modulo AND ID = @ID
ROLLBACK TRANSACTION
DELETE PolizaDescuadrada WHERE Modulo = @Modulo AND ID = @ID
INSERT PolizaDescuadrada (Modulo, ID, Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable) SELECT @Modulo, @ID, Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable FROM @PolizaDescuadrada
END
RETURN
END

