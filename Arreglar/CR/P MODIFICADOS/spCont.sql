SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCont
@ID                  	int,
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
@GenerarID			int		OUTPUT,
@Ok				int		OUTPUT,
@OkRef			varchar(255)	OUTPUT,
@EmpresaControladora		bit 	= 0,
@ContAuto			bit 	= 0,
@ModuloInicial       char(5) = NULL

AS BEGIN
DECLARE
@CopiarID			int,
@CopiarMov			varchar(20),
@Sucursal			int,
@SucursalDestino		int,
@SucursalOrigen		int,
@EnLinea			bit,
@PuedeEditar		bit,
@Empresa	      		char(5),
@MovUsuario			char(10),
@MovTipo   			char(20),
@FechaEmision     		datetime,
@FechaContable		datetime,
@Concepto	      		varchar(50),
@Proyecto	      		varchar(50),
@MovMoneda	      		char(10),
@MovTipoCambio	   	float,
@Autorizacion     		char(10),
@Referencia	      		varchar(50),
@UEN	      		int,
@Observaciones    		varchar(255),
@Estatus          		char(15),
@Ejercicio	      		int,
@Periodo	      		int,
@OrigenTipo			char(10),
@Origen			char(20),
@OrigenID			varchar(20),
@Moneda2			varchar(10),
@TipoCambio2		float,
@Intercompania		bit,
@SucursalPrincipal		int,
@AfectarPresupuesto		varchar(30),
@OrigenEmpresa		varchar(5),
@ContMoneda		        char(10),
@ContMoneda2	        char(10),
@CfgMoneda2Auto		bit,
@ContTipoCambio		float,
@CfgVerificarIVA		bit,
@CfgToleraciaRedondeo	float,
@CfgCentrosCostos		bit,
@CfgMultiSucursal		bit,
@CfgConsolidacion		bit,
@CfgRegistro		bit,
@CfgContabilizarMesesFuturos bit,
@CtaContabilidad		char(20),
@CtaOrden			char(20),
@ContX 			bit,
@ContXAfectar 		bit,
@EstatusNuevo	      	char(15)/*,
@Verificar			bit*/
IF @Accion = 'CANCELAR'   SELECT @EstatusNuevo = 'CANCELADO' ELSE
IF @Accion = 'DESAFECTAR' SELECT @EstatusNuevo = 'SINAFECTAR' ELSE
SELECT @EstatusNuevo = 'CONCLUIDO'
EXEC xpContAntes @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal, @Mov, @MovID, @GenerarID, @Ok OUTPUT, @OkRef OUTPUT
SELECT @Sucursal = Sucursal, @SucursalDestino = SucursalDestino, @SucursalOrigen = SucursalOrigen, @Empresa = Empresa, @MovID = MovID, @Mov = Mov, @FechaEmision = FechaEmision, @FechaContable = FechaContable, @Concepto = Concepto, @Proyecto = Proyecto,
@MovUsuario = Usuario, @MovMoneda = Moneda, @MovTipoCambio = TipoCambio, @Autorizacion = Autorizacion, @Referencia = Referencia,
@UEN = UEN, @Observaciones = Observaciones, @Estatus = UPPER(Estatus), @OrigenTipo = NULLIF(RTRIM(OrigenTipo), ''), @Origen = Origen, @OrigenID = OrigenID,
@Moneda2 = Moneda2, @TipoCambio2 = TipoCambio2, @Intercompania = ISNULL(Intercompania, 0), @AfectarPresupuesto = ISNULL(NULLIF(RTRIM(UPPER(AfectarPresupuesto)), ''), 'NO'), @OrigenEmpresa = NULLIF(RTRIM(OrigenEmpresa), '')
FROM Cont WITH (NOLOCK)
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @CfgConsolidacion = ISNULL(ConsolidacionEmpresas, 0),
@CfgContabilizarMesesFuturos = ISNULL(ContabilizarMesesFuturos, 0),
@CfgRegistro = ISNULL(Registro, 0),
@ContX = ISNULL(ContX, 0),
@ContXAfectar = ContXAfectar
FROM EmpresaGral WITH (NOLOCK)
WHERE Empresa = @Empresa
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @ContMoneda          = NULLIF(RTRIM(ContMoneda), ''),
@ContMoneda2         = NULLIF(RTRIM(ContMoneda2), ''),
@CfgMoneda2Auto      = ISNULL(ContMoneda2Auto, 0),
@CtaContabilidad     = NULLIF(RTRIM(CtaContabilidad), ''),
@CtaOrden            = NULLIF(RTRIM(CtaOrden), ''),
@CfgVerificarIVA	  = ContVerificarIVA,
@CfgCentrosCostos    = ContCentrosCostos,
@CfgMultiSucursal    = ISNULL(ContMultiSucursal, 0),
@CfgToleraciaRedondeo= ISNULL(ContToleraciaRedondeo, 0.0)
FROM EmpresaCfg WITH (NOLOCK)
WHERE Empresa = @Empresa
IF @@ERROR <> 0 SELECT @Ok = 1
IF @ContX = 1 AND @ContXAfectar = 1 AND @@TRANCOUNT > 1
SELECT @Conexion = 1
SELECT @ContTipoCambio = 1.0
EXEC spExtraerFecha @FechaEmision OUTPUT
EXEC spExtraerFecha @FechaContable OUTPUT
IF NULLIF(RTRIM(@Usuario), '') IS NULL SELECT @Usuario = @MovUsuario
EXEC spMovTipo @Modulo, @Mov, @FechaContable, @Empresa, @Estatus, @Concepto OUTPUT, @MovTipo OUTPUT, @Periodo OUTPUT, @Ejercicio OUTPUT, @Ok OUTPUT
IF @MovTipo = 'CONT.C' SELECT @Periodo = 13
EXEC spMovOk @SincroFinal, @ID, @Estatus, @Sucursal, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @FechaContable, @FechaRegistro, @Ejercicio, @Periodo, @Proyecto, @Ok OUTPUT, @OkRef OUTPUT
EXEC xpOk_60110 @Empresa, @Usuario, @Accion, @Modulo, @ID, @ModuloInicial, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
IF @Accion = 'AFECTAR'
BEGIN
SELECT @SucursalPrincipal = ISNULL(Sucursal, 0) FROM Version WITH (NOLOCK)
IF @SucursalPrincipal > 0
IF (SELECT ISNULL(EnLinea, 0) FROM Sucursal WITH (NOLOCK) WHERE Sucursal = @SucursalPrincipal) = 0
SELECT @Accion = 'SINCRO'
END
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
EXEC spContVerificar @ID, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo,
@MovMoneda, @MovTipoCambio, @ContMoneda, @Estatus, @AfectarPresupuesto,
@FechaContable, @CfgVerificarIVA, @CfgCentrosCostos, @CfgToleraciaRedondeo, @CfgRegistro,
@Ejercicio, @Periodo, @Conexion, @SincroFinal, @Sucursal,
@Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @Estatus = 'SINAFECTAR'/*, @Verificar = 0*/
EXEC spAsignarSucursalEstatus @ID, @Modulo, @Sucursal, @Estatus
END
END
END
END
IF (@Accion NOT IN ('CANCELAR','DESAFECTAR') AND @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR')) OR
(@Accion IN ('CANCELAR','DESAFECTAR')     AND @Estatus = 'CONCLUIDO')
BEGIN
IF @MovTipo IN ('CONT.P', 'CONT.C') AND /*(@Conexion = 0 OR @Accion IN ('CANCELAR', 'DESAFECTAR')) AND */@Accion NOT IN ('GENERAR', 'CONSECUTIVO'/*, 'SINCRO'*/) AND @Ok IS NULL
BEGIN
EXEC spContVerificar @ID, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo,
@MovMoneda, @MovTipoCambio, @ContMoneda, @Estatus, @AfectarPresupuesto,
@FechaContable, @CfgVerificarIVA, @CfgCentrosCostos, @CfgToleraciaRedondeo, @CfgRegistro,
@Ejercicio, @Periodo, @Conexion, @SincroFinal, @Sucursal,
@Ok OUTPUT, @OkRef OUTPUT
IF @Ok BETWEEN 80000 AND 89999 AND @Accion IN ('AFECTAR', 'GENERAR', 'CANCELAR', 'DESAFECTAR') SELECT @Ok = NULL ELSE
IF @Accion = 'VERIFICAR' AND @Ok IS NULL
BEGIN
SELECT @Ok = 80000
EXEC xpOk_80000 @Empresa, @Usuario, @Accion, @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
END
END
IF @CfgContabilizarMesesFuturos = 0 AND @Accion = 'AFECTAR' AND @Ok IS NULL
BEGIN
IF (MONTH(@FechaContable) > MONTH(@FechaRegistro) AND YEAR(@FechaContable) >= YEAR(@FechaRegistro)) OR
(MONTH(@FechaContable) = MONTH(@FechaRegistro) AND YEAR(@FechaContable) > YEAR(@FechaRegistro))
BEGIN
UPDATE Cont WITH (ROWLOCK) SET Estatus = 'BORRADOR' WHERE ID = @ID AND Estatus <> 'BORRADOR'
SELECT @Accion = 'VERIFICAR'
END
END
IF @Accion IN ('AFECTAR', 'CANCELAR', 'DESAFECTAR','CONSECUTIVO','SINCRO') AND @Ok IS NULL
BEGIN
IF @MovTipo IN ('CONT.P', 'CONT.C') AND @EmpresaControladora = 0
EXEC spContSocio @ID, @Empresa, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spContAfectar @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID OUTPUT, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaEmision, @FechaContable, @Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia, @UEN, @Observaciones, @AfectarPresupuesto,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo,
@ContMoneda, @ContTipoCambio, @CtaContabilidad, @CtaOrden,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen,
@CfgMoneda2Auto, @CfgMultiSucursal, @CfgRegistro,
@OrigenTipo, @Origen, @OrigenID,
@GenerarID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT,
@Base = @Base, @GenerarMov = @GenerarMov, @CfgConsolidacion = @CfgConsolidacion, @OrigenEmpresa = @OrigenEmpresa, @Intercompania = @Intercompania 
IF ISNULL(@ContMoneda2, '(No)') <> '(No)' AND @Ok IS NULL AND @Accion <> 'CONSECUTIVO'
BEGIN
IF @Accion = 'AFECTAR'
BEGIN
SELECT @TipoCambio2 = NULL
SELECT @Moneda2 = Moneda, @TipoCambio2 = TipoCambio FROM Mon WITH (NOLOCK) WHERE Moneda = @ContMoneda2
EXEC xpContMoneda2 @ID, @Moneda2 OUTPUT, @TipoCambio2 OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @TipoCambio2 IS NOT NULL
BEGIN
EXEC spContAfectar @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID OUTPUT, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaEmision, @FechaContable, @Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia, @UEN, @Observaciones, @AfectarPresupuesto,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo,
@Moneda2, @TipoCambio2, @CtaContabilidad, @CtaOrden,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen,
@CfgMoneda2Auto, @CfgMultiSucursal, @CfgRegistro,
@OrigenTipo, @Origen, @OrigenID,
@GenerarID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT,
@AfectarMoneda2 = 1,
@Base = @Base, @GenerarMov = @GenerarMov, @CfgConsolidacion = @CfgConsolidacion, @OrigenEmpresa = @OrigenEmpresa, @Intercompania = @Intercompania 
IF @Ok IS NULL AND @Accion = 'AFECTAR'
UPDATE Cont WITH (ROWLOCK) SET Moneda2 = @Moneda2, TipoCambio2 = @TipoCambio2 WHERE ID = @ID
END
END
END
END ELSE
IF @Ok IN (NULL, 80030, 80060)
BEGIN
IF @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR') AND @Accion = 'CANCELAR' EXEC spMovCancelarSinAfectar @Modulo, @ID, @Ok OUTPUT ELSE
IF @Estatus = 'AFECTANDO' SELECT @Ok = 80020 ELSE
IF @Estatus = 'CONCLUIDO' SELECT @Ok = 80010
ELSE SELECT @Ok = 60040
END
IF @Accion = 'SINCRO' AND @Ok = 80060
BEGIN
SELECT @Ok = NULL, @OkRef = NULL
/*EXEC spSucursalEnLinea @SucursalDestino, @EnLinea OUTPUT
IF @EnLinea = 1 EXEC spSincroFinalModulo @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT*/
END
IF @Ok IS NOT NULL AND @OkRef IS NULL
SELECT @OkRef = 'Movimiento: '+RTRIM(@Mov)+' '+RTRIM(@MovID), @GenerarID = NULL
IF @Conexion = 0 AND @ContX = 1 /*AND @CfgRegistro = 1*/ AND @Ok IS NOT NULL AND @ContAuto = 0 AND @Ok <> 50010
IF EXISTS (SELECT ID FROM ContX WITH (NOLOCK) WHERE Mov = @Origen AND Modulo = @OrigenTipo AND Empresa IN(@Empresa, NULL, '', '(Todas)'))
EXEC spOk_RAISERROR @Ok, @OkRef
RETURN
END

