SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNomina
@ID               	int,
@Modulo	      		char(5),
@Accion			char(20),
@Base			char(20),
@FechaRegistro		datetime,
@GenerarMov			char(20),
@Usuario			char(10),
@Conexion			bit,
@SincroFinal			bit,
@Mov	      			char(20)	OUTPUT,
@MovID            		varchar(20)	OUTPUT,
@IDGenerar			int		OUTPUT,
@Ok				int		OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Sucursal			int,
@SucursalDestino		int,
@SucursalOrigen		int,
@EnLinea			bit,
@PuedeEditar		bit,
@Empresa	      		char(5),
@MovTipo   			char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision     		datetime,
@FechaOrigen		datetime,
@FechaAfectacion		datetime,
@FechaConclusion		datetime,
@Proyecto	      		varchar(50),
@Condicion			varchar(50),
@UsaImporte			bit,
@UsaCantidad		bit,
@UsaPorcentaje		bit,
@UsaMonto			bit,
@UsaFechas			bit,
@MovUsuario	      		char(10),
@Autorizacion     		char(10),
@DocFuente	      		int,
@Observaciones    		varchar(255),
@Estatus          		char(15),
@EstatusNuevo		char(15),
@PeriodoTipo		varchar(50),
@MovFechaD			datetime,
@MovFechaA			datetime,
@Ejercicio	      		int,
@Periodo	      		int,
@GenerarMovID		varchar(20),
@GenerarPoliza		bit,
@Concepto			varchar(50),
@SugerirAumentoVacaciones  	bit,
@CfgAfectarAumentoVacaciones  bit,
@CfgConceptoAumentoVacaciones varchar(50),
@SugerirDisminucionVacaciones  	bit,
@CfgAfectarDisminucionVacaciones  	bit,
@CfgConceptoDisminucionVacaciones varchar(50),
@CfgValidarReferencias	bit,
@MovIncapacidades		varchar(20),
@MovAplicacionNomina	varchar(20),
@SugerirSDI			bit,
@CfgConceptoSDI		varchar(50),
@CfgContX			bit,
@CfgContXGenerar		char(20)/*,
@Verificar			bit*/
SELECT @CfgContX        = 0,
@CfgContXGenerar = 'NO',
@UsaImporte	  = 0,
@UsaCantidad     = 0,
@UsaPorcentaje	  = 0,
@UsaMonto	  = 0,
@UsaFechas	  = 0/*,
@Verificar	  = 1*/
SELECT @Sucursal = Sucursal,
@SucursalDestino = SucursalDestino,
@SucursalOrigen = SucursalOrigen,
@Empresa = Empresa,
@MovID = MovID,
@Mov = Mov,
@FechaEmision = FechaEmision,
@FechaOrigen = FechaOrigen,
@Proyecto = Proyecto,
@MovUsuario = Usuario,
@Autorizacion = Autorizacion,
@MovMoneda = Moneda,
@MovTipoCambio = TipoCambio,
@Condicion = NULLIF(RTRIM(Condicion), ''),
@PeriodoTipo = NULLIF(RTRIM(PeriodoTipo), ''),
@MovFechaD = FechaD,
@MovFechaA = FechaA,
@DocFuente = DocFuente,
@Observaciones = Observaciones,
@Estatus = UPPER(Estatus),
@GenerarPoliza = GenerarPoliza,
@FechaConclusion = FechaConclusion,
@Concepto = NULLIF(RTRIM(Concepto), '')
FROM Nomina
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
IF NULLIF(RTRIM(@Usuario), '') IS NULL
SELECT @Usuario = @MovUsuario
EXEC spExtraerFecha @MovFechaD OUTPUT
EXEC spExtraerFecha @MovFechaA OUTPUT
EXEC spFechaAfectacion @Empresa, @Modulo, @ID, @Accion, @FechaEmision OUTPUT, @FechaRegistro, @FechaAfectacion OUTPUT
EXEC spExtraerFecha @FechaAfectacion OUTPUT
EXEC spMovTipo @Modulo, @Mov, @FechaAfectacion, @Empresa, @Estatus, @Concepto OUTPUT, @MovTipo OUTPUT, @Periodo OUTPUT, @Ejercicio OUTPUT, @Ok OUTPUT
EXEC spMovOk @SincroFinal, @ID, @Estatus, @Sucursal, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @FechaAfectacion, @FechaRegistro, @Ejercicio, @Periodo, @Proyecto, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
IF @SucursalDestino IS NOT NULL AND @SucursalDestino <> @Sucursal AND @Accion = 'AFECTAR'
BEGIN
EXEC spSucursalEnLinea @SucursalDestino, @EnLinea OUTPUT
IF @EnLinea = 1
BEGIN
EXEC spMovConsecutivo @Sucursal, @SucursalOrigen, @SucursalDestino, @Empresa, @Usuario, @Modulo, @Ejercicio, @Periodo, @ID, @Mov, NULL, @Estatus, @Concepto, @Accion, @Conexion, @SincroFinal, @MovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spAsignarSucursalEstatus @ID, @Modulo, @SucursalDestino, NULL
SELECT @Sucursal = @SucursalDestino
END ELSE
SELECT @Accion = 'SINCRO'
END
IF @Estatus = 'SINCRO' AND @Accion = 'CANCELAR'
BEGIN
EXEC spPuedeEditarMovMatrizSucursal @Sucursal, @SucursalOrigen, @ID, @Modulo, @Empresa, @Usuario, @Mov, @Estatus, 1, @PuedeEditar OUTPUT
IF @PuedeEditar = 0
SELECT @Ok = 60300
ELSE BEGIN
SELECT @Estatus = 'SINAFECTAR'/*, @Verificar = 0*/
EXEC spAsignarSucursalEstatus @ID, @Modulo, @Sucursal, @Estatus
END
END
END
IF (@Accion <> 'CANCELAR' AND @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'PENDIENTE', 'PROCESAR', 'VIGENTE')) OR
(@Accion =  'CANCELAR' AND @Estatus IN ('CONCLUIDO', 'PENDIENTE', 'PROCESAR', 'VIGENTE'))
BEGIN
SELECT @SugerirSDI                   = NomSugerirSDI,
@CfgConceptoSDI               = NULLIF(RTRIM(NomConceptoSDI), ''),
@SugerirAumentoVacaciones	   = NomSugerirAumentoVacaciones,
@CfgAfectarAumentoVacaciones  = NomAfectarAumentoVacaciones,
@CfgConceptoAumentoVacaciones = NomConceptoAumentoVacaciones,
@CfgValidarReferencias        = NomValidarReferencias,
@SugerirDisminucionVacaciones      = NomSugerirDisminuirVacaciones,
@CfgAfectarDisminucionVacaciones   = NomAfectarDisminuirVacaciones,
@CfgConceptoDisminucionVacaciones  = NomConceptoDisminuirVacaciones
FROM EmpresaCfg
WHERE Empresa = @Empresa
IF @@ERROR <> 0 SELECT @Ok = 1
IF @MovTipo <> 'NOM.N'
SELECT  @SugerirAumentoVacaciones = 0
SELECT @MovIncapacidades = NomIncapacidades,
@MovAplicacionNomina = CxcAplicacionNomina
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @CfgContX = ContX
FROM EmpresaGral
WHERE Empresa = @Empresa
IF @@ERROR <> 0 SELECT @Ok = 1
IF @CfgContX = 1
SELECT @CfgContXGenerar = ContXGenerar
FROM EmpresaCfgModulo
WHERE Empresa = @Empresa
AND Modulo  = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Accion = 'DESAFECTAR'
SELECT @EstatusNuevo = 'SINAFECTAR'
ELSE
IF @Accion = 'CANCELAR'
SELECT @EstatusNuevo = 'CANCELADO'
ELSE BEGIN
SELECT @EstatusNuevo = 'CONCLUIDO'
IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR')
BEGIN
IF @MovTipo = 'NOM.CA' SELECT @EstatusNuevo = 'PENDIENTE'
IF @MovTipo IN ('NOM.C', 'NOM.CH', 'NOM.CD', 'NOM.CDH', 'NOM.VT')
SELECT @EstatusNuevo = 'PROCESAR', @UsaCantidad = 1
ELSE
IF @MovTipo IN ('NOM.P', 'NOM.PD', 'NOM.PI', 'NOM.D')
BEGIN
SELECT @UsaImporte = 1
IF @Condicion IS NULL OR UPPER(@Condicion) = 'UNA VEZ'
SELECT @EstatusNuevo = 'PROCESAR'
ELSE BEGIN
SELECT @EstatusNuevo = 'VIGENTE'
IF UPPER(@Condicion) IN ('REPETIR', 'PRORRATEAR') SELECT @UsaCantidad = 1 ELSE
IF UPPER(@Condicion) = 'REPETIR FECHAS' SELECT @UsaFechas = 1 ELSE
IF UPPER(@Condicion) IN ('PRORRATEAR %', '% SUELDO') SELECT @UsaPorcentaje = 1 ELSE
IF UPPER(@Condicion) IN ('PRORRATEAR $', 'CON ENGANCHE') SELECT @UsaMonto = 1
IF UPPER(@Condicion) = '% SUELDO' SELECT @UsaImporte = 0
END
END
END
END
IF (@Conexion = 0 OR @Accion = 'CANCELAR') AND @Accion NOT IN ('GENERAR', 'CONSECUTIVO'/*, 'SINCRO'*/) AND @Ok IS NULL
BEGIN
EXEC spNominaVerificar @ID, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@Condicion, @PeriodoTipo, @MovFechaD, @MovFechaA, @FechaEmision, @Estatus,
@UsaImporte, @UsaCantidad, @UsaPorcentaje, @UsaMonto, @UsaFechas,
@CfgValidarReferencias, @MovIncapacidades,
@Conexion, @SincroFinal, @Sucursal,
@CfgContX, @CfgContXGenerar, @GenerarPoliza,
@Ok OUTPUT, @OkRef OUTPUT
IF @Ok BETWEEN 80000 AND 89999 AND @Accion IN ('AFECTAR', 'CANCELAR') SELECT @Ok = NULL ELSE
IF @Accion = 'VERIFICAR' AND @Ok IS NULL SELECT @Ok = 80000
END
IF @Accion IN ('AFECTAR', 'DESAFECTAR', 'GENERAR', 'CANCELAR','CONSECUTIVO','SINCRO') AND @Ok IS NULL
EXEC spNominaAfectar @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID OUTPUT, @MovTipo, @MovMoneda, @MovTipoCambio,
@Condicion, @PeriodoTipo, @MovFechaD, @MovFechaA, @FechaEmision, @FechaOrigen, @FechaAfectacion, @FechaConclusion,
@Proyecto, @Concepto, @Usuario, @Autorizacion, @DocFuente, @Observaciones,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo,
@UsaImporte, @UsaCantidad, @UsaPorcentaje, @UsaMonto, @UsaFechas,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen,
@SugerirAumentoVacaciones, @CfgAfectarAumentoVacaciones, @CfgConceptoAumentoVacaciones,
@SugerirDisminucionVacaciones,@CfgAfectarDisminucionVacaciones,@CfgConceptoDisminucionVacaciones,
@SugerirSDI, @CfgConceptoSDI,
@MovAplicacionNomina,
@CfgContX, @CfgContXGenerar, @GenerarPoliza,
@GenerarMov, @IDGenerar OUTPUT, @GenerarMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
/*IF @Accion = 'CANCELAR' AND @Ok IS NULL
EXEC spNominaCancelar @ID, @Mov, @MovID, @Usuario, @FechaRegistro, @Ok OUTPUT, @OkRef OUTPUT*/
END ELSE
BEGIN
IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @Accion = 'CANCELAR' EXEC spMovCancelarSinAfectar @Modulo, @ID, @Ok OUTPUT ELSE
IF @Estatus = 'AFECTANDO' SELECT @Ok = 80020 ELSE
IF @Estatus = 'CONCLUIDO' SELECT @Ok = 80010
END
IF @Accion = 'SINCRO' AND @Ok = 80060
BEGIN
SELECT @Ok = NULL, @OkRef = NULL
EXEC spSucursalEnLinea @SucursalDestino, @EnLinea OUTPUT
IF @EnLinea = 1 EXEC spSincroFinalModulo @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NOT NULL AND @OkRef IS NULL
IF @Ok = 80030
SELECT @OkRef = 'Movimiento: '+RTRIM(@GenerarMov)+' '+LTRIM(Convert(Char, @GenerarMovID))
ELSE
SELECT @OkRef = 'Movimiento: '+RTRIM(@Mov)+' '+LTRIM(Convert(Char, @MovID)), @IDGenerar = NULL
RETURN
END

