SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCorte
@ID                 int,
@Modulo	      		char(5),
@Accion				char(20),
@Base				char(20),
@FechaRegistro		datetime,
@GenerarMov			char(20),
@Usuario			char(10),
@Conexion			bit,
@SincroFinal		bit,
@Estacion			int,
@Mov	      		char(20)		OUTPUT,
@MovID            	varchar(20)		OUTPUT,
@IDGenerar			int				OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
DECLARE @EstatusNuevo			char(15),
@Sucursal				int,
@SucursalDestino		int,
@SucursalOrigen		int,
@Empresa	      		char(5),
@FechaEmision			datetime,
@FechaAfectacion		datetime,
@FechaConclusion		datetime,
@Proyecto	      		varchar(50),
@MovUsuario			char(10),
@Autorizacion			char(10),
@Generar				bit,
@GenerarAfectado		bit,
@GenerarMovID	  		varchar(20),
@CorteFrecuencia		varchar(50),
@CorteGrupo			varchar(50),
@CorteTipo			varchar(50),
@CortePeriodo			int,
@CorteEjercicio		int,
@CorteOrigen			varchar(50),
@CorteCuentaTipo		varchar(20),
@CorteGrupoDe			varchar(10),
@CorteGrupoA			varchar(10),
@CorteSubGrupoDe		varchar(20),
@CorteSubGrupoA		varchar(20),
@CorteCuentaDe		varchar(10),
@CorteCuentaA			varchar(10),
@CorteSubCuentaDe		varchar(50),
@CorteSubCuenta2A		varchar(50),
@CorteSubCuenta2De	varchar(50),
@CorteSubCuenta3A		varchar(50),
@CorteSubCuenta3De	varchar(50),
@CorteSubCuentaA		varchar(50),
@CorteUENDe			int,
@CorteUENA			int,
@CorteProyectoDe		varchar(50),
@CorteProyectoA		varchar(50),
@CorteFechaD			datetime,
@CorteFechaA			datetime,
@CorteMoneda			varchar(10),
@Moneda				varchar(10),
@TipoCambio			float,
@CorteTitulo			varchar(100),
@CorteMensaje			varchar(100),
@CorteEstatus			varchar(15),
@CorteSucursalDe		int,
@CorteSucursalA		int,
@CorteValuacion		varchar(50),
@CorteDesglosar		varchar(20),
@CorteFiltrarFechas	bit,
@Observaciones		varchar(255),
@Estatus				char(15),
@Concepto    			varchar(50),
@Referencia 			varchar(50),
@Condicion			varchar(50),
@MovTipo   			char(20),
@SubMovTipo			varchar(20),
@Periodo				int,
@Ejercicio			int,
@EnLinea				bit,
@PuedeEditar			bit
IF @Accion = 'CANCELAR' SELECT @EstatusNuevo = 'CANCELADO' ELSE SELECT @EstatusNuevo = 'CONCLUIDO'
SELECT @Sucursal				= Sucursal,
@SucursalDestino		= SucursalDestino,
@SucursalOrigen		= SucursalOrigen,
@Empresa				= Empresa,
@MovID					= MovID,
@Mov					= Mov,
@FechaEmision			= FechaEmision,
@Proyecto				= NULLIF(RTRIM(Proyecto), ''),
@MovUsuario			= Usuario,
@Autorizacion			= Autorizacion,
@Observaciones			= Observaciones,
@Estatus				= UPPER(Estatus),
@FechaConclusion		= FechaConclusion,
@Concepto				= Concepto,
@Referencia			= Referencia,
@CorteFrecuencia		= CorteFrecuencia,
@CorteGrupo			= CorteGrupo,
@CorteTipo				= CorteTipo,
@CortePeriodo			= CortePeriodo,
@CorteEjercicio		= CorteEjercicio,
@CorteOrigen			= CorteOrigen,
@CorteCuentaTipo		= CorteCuentaTipo,
@CorteGrupoDe			= CorteGrupoDe,
@CorteGrupoA			= CorteGrupoA,
@CorteSubGrupoDe		= CorteSubGrupoDe,
@CorteSubGrupoA		= CorteSubGrupoA,
@CorteCuentaDe			= CorteCuentaDe,
@CorteCuentaA			= CorteCuentaA,
@CorteSubCuentaDe		= CorteSubCuentaDe,
@CorteSubCuenta2A		= CorteSubCuenta2A,
@CorteSubCuenta2De		= CorteSubCuenta2De,
@CorteSubCuenta3A		= CorteSubCuenta3A,
@CorteSubCuenta3De		= CorteSubCuenta3De,
@CorteSubCuentaA		= CorteSubCuentaA,
@CorteUENDe			= CorteUENDe,
@CorteUENA				= CorteUENA,
@CorteProyectoDe		= CorteProyectoDe,
@CorteProyectoA		= CorteProyectoA,
@CorteFechaD			= CorteFechaD,
@CorteFechaA			= CorteFechaA,
@CorteMoneda			= CorteMoneda,
@Moneda				= Moneda,
@TipoCambio			= TipoCambio,
@CorteTitulo			= CorteTitulo,
@CorteMensaje			= CorteMensaje,
@CorteEstatus			= CorteEstatus,
@CorteSucursalDe		= CorteSucursalDe,
@CorteSucursalA		= CorteSucursalA,
@CorteValuacion		= CorteValuacion,
@CorteDesglosar		= CorteDesglosar,
@CorteFiltrarFechas	= ISNULL(CorteFiltrarFechas, 0)
FROM Corte
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Ok IS NULL
BEGIN
IF NULLIF(RTRIM(@Usuario), '') IS NULL SELECT @Usuario = @MovUsuario
EXEC spFechaAfectacion @Empresa, @Modulo, @ID, @Accion, @FechaEmision OUTPUT, @FechaRegistro, @FechaAfectacion OUTPUT
EXEC spExtraerFecha @FechaAfectacion OUTPUT
EXEC spMovTipo @Modulo, @Mov, @FechaAfectacion, @Empresa, NULL, NULL, @MovTipo OUTPUT, @Periodo OUTPUT, @Ejercicio OUTPUT, @Ok OUTPUT
SELECT @SubMovTipo = SubClave FROM MovTipo WHERE Mov = @Mov AND Modulo = @Modulo
EXEC spMovOk @SincroFinal, @ID, @Estatus, @Sucursal, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @FechaAfectacion, @FechaRegistro, @Ejercicio, @Periodo, @Proyecto, @Ok OUTPUT, @OkRef OUTPUT
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
IF (@Accion <> 'CANCELAR' AND @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR', 'PENDIENTE', 'VIGENTE')) OR
(@Accion = 'CANCELAR'  AND @Estatus IN ('CONCLUIDO', 'PENDIENTE', 'VIGENTE'))
BEGIN
IF @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR') AND @Accion <> 'CANCELAR'
BEGIN
IF ISNULL(@SubMovTipo, '') NOT IN('CORTE.GENERACORTEIMP', 'CORTE.GENERACORTECON', 'CORTE.GENERACORTEU', 'CORTE.GENERACORTECX')
SELECT @EstatusNuevo = 'CONCLUIDO'
ELSE
SELECT @EstatusNuevo = 'VIGENTE'
END
IF (@Conexion = 0 OR @Accion = 'CANCELAR') AND @Accion NOT IN ('GENERAR', 'CONSECUTIVO'/*, 'SINCRO'*/) AND @Ok IS NULL
BEGIN
EXEC spCorteVerificar @ID, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo, @SubMovTipo, @FechaEmision, @Estatus, @EstatusNuevo,
@CorteFrecuencia, @CorteGrupo, @CorteTipo,
@CortePeriodo, @CorteEjercicio, @CorteOrigen, @CorteCuentaTipo, @CorteGrupoDe, @CorteGrupoA, @CorteSubGrupoDe, @CorteSubGrupoA,
@CorteCuentaDe, @CorteCuentaA, @CorteSubCuentaDe, @CorteSubCuenta2A, @CorteSubCuenta2De, @CorteSubCuenta3A, @CorteSubCuenta3De,
@CorteSubCuentaA, @CorteUENDe, @CorteUENA, @CorteProyectoDe, @CorteProyectoA, @CorteFechaD, @CorteFechaA, @Moneda, @TipoCambio,
@CorteTitulo, @CorteMensaje, @CorteEstatus, @CorteSucursalDe, @CorteSucursalA,
@Conexion, @SincroFinal, @Sucursal, @Estacion, @CorteFiltrarFechas, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok BETWEEN 80000 AND 89999 AND @Accion IN ('AFECTAR', 'CANCELAR') SELECT @Ok = NULL ELSE
IF @Accion = 'VERIFICAR' AND @Ok IS NULL
BEGIN
SELECT @Ok = 80000
EXEC xpOk_80000 @Empresa, @Usuario, @Accion, @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
END
END
IF @Accion IN ('AFECTAR', 'GENERAR', 'CANCELAR','CONSECUTIVO','SINCRO') AND @Ok IS NULL
EXEC spCorteAfectar @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID OUTPUT, @MovTipo, @SubMovTipo, @FechaEmision, @FechaAfectacion, @FechaConclusion,
@Proyecto, @Usuario, @Autorizacion, @Observaciones, @Concepto, @Referencia,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo, @MovUsuario, @CorteFrecuencia, @CorteGrupo, @CorteTipo,
@CortePeriodo, @CorteEjercicio, @CorteOrigen, @CorteCuentaTipo, @CorteGrupoDe, @CorteGrupoA, @CorteSubGrupoDe, @CorteSubGrupoA,
@CorteCuentaDe, @CorteCuentaA, @CorteSubCuentaDe, @CorteSubCuenta2A, @CorteSubCuenta2De, @CorteSubCuenta3A, @CorteSubCuenta3De,
@CorteSubCuentaA, @CorteUENDe, @CorteUENA, @CorteProyectoDe, @CorteProyectoA, @CorteFechaD, @CorteFechaA, @CorteMoneda, @Moneda, @TipoCambio,
@CorteTitulo, @CorteMensaje, @CorteEstatus, @CorteSucursalDe, @CorteSucursalA,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen, @Estacion, @CorteValuacion, @CorteDesglosar, @CorteFiltrarFechas,
@Generar, @GenerarMov, @GenerarAfectado, @IDGenerar OUTPUT, @GenerarMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
END ELSE
BEGIN
IF @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR') AND @Accion = 'CANCELAR' EXEC spMovCancelarSinAfectar @Modulo, @ID, @Ok OUTPUT ELSE
IF @Estatus = 'AFECTANDO' SELECT @Ok = 80020 ELSE
IF @Estatus = 'CONCLUIDO' SELECT @Ok = 80010
ELSE SELECT @Ok = 60040, @OkRef = 'Estatus: '+@Estatus
END
IF @Accion = 'SINCRO' AND @Ok = 80060
BEGIN
SELECT @Ok = NULL, @OkRef = NULL
EXEC spSucursalEnLinea @SucursalDestino, @EnLinea OUTPUT
IF @EnLinea = 1 EXEC spSincroFinalModulo @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok = 80030
SELECT @OkRef = 'Movimiento: '+RTRIM(@GenerarMov)+' '+LTRIM(Convert(Char, @GenerarMovID))
RETURN
END

