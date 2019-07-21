SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spActivoFijo
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
@SubClave			varchar(20),
@SubClaveFiscal		int,
@MovMoneda	      		char(10),
@MovTipoCambio	   	float,
@FechaEmision     		datetime,
@FechaAfectacion		datetime,
@FechaConclusion		datetime,
@Proyecto	      		varchar(50),
@MovUsuario	      		char(10),
@Autorizacion     		char(10),
@DocFuente	      		int,
@Observaciones    		varchar(255),
@Estatus          		char(15),
@EstatusNuevo		char(15),
@FechaRegistroAnterior	datetime,
@Ejercicio	      		int,
@Periodo	      		int,
@Condicion			varchar(50),
@Vencimiento		datetime,
@Todo			bit,
@Revaluar			bit,
@ValorMercado		bit,
@Proveedor			char(10),
@Personal			char(10),
@Espacio			char(10),
@ContUso			varchar(20),
@ContUso2			varchar(20),
@ContUso3			varchar(20),
@FormaPago			varchar(50),
@Concepto			varchar(50),
@CtaDinero			char(10),
@GenerarMovID		varchar(20),
@GenerarPoliza		bit,
@CfgContX			bit,
@CfgContXGenerar		char(20),
@CfgMantenimientoPendiente 	bit,
@CfgAfectarDinero		bit,
@CfgTabla			varchar(50),/*,
@Verificar			bit*/
@AFGenerarGasto		bit,
@AFGenerarGastoCfg	varchar(20)
SELECT @CfgMantenimientoPendiente = 0,
@CfgContX         	    = 0,
@CfgContXGenerar  	    = 'NO',
@CfgAfectarDinero	    = 0,
@CfgTabla		    = NULL/*,
@Verificar		    = 1*/
IF @Accion = 'CANCELAR' SELECT @EstatusNuevo = 'CANCELADO' ELSE SELECT @EstatusNuevo = 'CONCLUIDO'
SELECT @Sucursal = Sucursal, @SucursalDestino = SucursalDestino, @SucursalOrigen = SucursalOrigen, @Empresa = Empresa, @MovID = MovID, @Mov = Mov, @FechaEmision = FechaEmision, @Proyecto = Proyecto,
@MovMoneda = Moneda, @MovTipoCambio = TipoCambio, @MovUsuario = Usuario, @Autorizacion = Autorizacion,
@DocFuente = DocFuente, @Observaciones = Observaciones, @Estatus = UPPER(Estatus),
@Condicion = Condicion, @Vencimiento = Vencimiento, @Todo = Todo, @Revaluar = Revaluar, @ValorMercado = ValorMercado,
@Proveedor = Proveedor, @FormaPago = FormaPago, @CtaDinero = CtaDinero,
@GenerarPoliza = GenerarPoliza, @FechaRegistroAnterior = FechaRegistro, @FechaConclusion = FechaConclusion,
@Personal = NULLIF(RTRIM(Personal), ''), @Espacio = NULLIF(RTRIM(Espacio), ''), @ContUso = NULLIF(RTRIM(ContUso), ''),
@ContUso2 = NULLIF(RTRIM(ContUso2), ''), @ContUso3 = NULLIF(RTRIM(ContUso3), ''),
@Concepto = Concepto
FROM ActivoFijo WITH(NOLOCK)
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
IF NULLIF(RTRIM(@Usuario), '') IS NULL SELECT @Usuario = @MovUsuario
EXEC spFechaAfectacion @Empresa, @Modulo, @ID, @Accion, @FechaEmision OUTPUT, @FechaRegistro, @FechaAfectacion OUTPUT
EXEC spExtraerFecha @FechaAfectacion OUTPUT
EXEC spMovTipo @Modulo, @Mov, @FechaAfectacion, @Empresa, @Estatus, @Concepto OUTPUT, @MovTipo OUTPUT, @Periodo OUTPUT, @Ejercicio OUTPUT, @Ok OUTPUT, @SubClave = @SubClave OUTPUT
SELECT @SubClaveFiscal = dbo.fnSubClaveFiscal(@SubClave)
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
IF (@Accion <> 'CANCELAR' AND @Estatus IN ('SINAFECTAR', 'PENDIENTE')) OR
(@Accion = 'CANCELAR'  AND @Estatus IN ('CONCLUIDO', 'PENDIENTE', 'VIGENTE'))
BEGIN
SELECT @CfgMantenimientoPendiente = AFMantenimientoPendiente,
@CfgTabla 		      = NULLIF(RTRIM(ContTablaINPC), ''),
@AFGenerarGasto		 = ISNULL(AFGenerarGasto, 0),
@AFGenerarGastoCfg	 = AFGenerarGastoCfg
FROM EmpresaCfg WITH(NOLOCK)
WHERE Empresa = @Empresa
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @CfgContX = ContX
FROM EmpresaGral WITH(NOLOCK)
WHERE Empresa = @Empresa
IF @@ERROR <> 0 SELECT @Ok = 1
IF @CfgContX = 1
SELECT @CfgContXGenerar = ContXGenerar
FROM EmpresaCfgModulo WITH(NOLOCK)
WHERE Empresa = @Empresa
AND Modulo  = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Accion = 'CANCELAR'
SELECT @EstatusNuevo = 'CANCELADO'
ELSE BEGIN
IF @MovTipo IN ('AF.RE', 'AF.MA') AND @CfgMantenimientoPendiente = 1
BEGIN
IF @Estatus = 'SINAFECTAR' SELECT @EstatusNuevo = 'PENDIENTE'
IF @Estatus = 'PENDIENTE'  SELECT @EstatusNuevo = 'CONCLUIDO'
END ELSE
IF @MovTipo IN ('AF.PM', 'AF.PS')
SELECT @EstatusNuevo = 'VIGENTE'
ELSE SELECT @EstatusNuevo = 'CONCLUIDO'
END
IF (@Conexion = 0 OR @Accion = 'CANCELAR') AND @Accion NOT IN ('GENERAR', 'CONSECUTIVO'/*, 'SINCRO'*/) AND @Ok IS NULL
BEGIN
EXEC spActivoFijoVerificar @ID, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @FechaEmision,
@Condicion, @Vencimiento, @Estatus, @EstatusNuevo, @Ejercicio, @Periodo,
@Personal, @Espacio, @ContUso, @ContUso2, @ContUso3, @Todo, @Revaluar, @ValorMercado,
@CfgTabla,
@Conexion, @SincroFinal, @Sucursal, @FormaPago, @Ok OUTPUT, @OkRef OUTPUT, @SubClave = @SubClave, @SubClaveFiscal = @SubClaveFiscal
IF @Ok BETWEEN 80000 AND 89999 AND @Accion IN ('AFECTAR', 'CANCELAR') SELECT @Ok = NULL ELSE
IF @Accion = 'VERIFICAR' AND @Ok IS NULL
BEGIN
SELECT @Ok = 80000
EXEC xpOk_80000 @Empresa, @Usuario, @Accion, @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
END
END
IF @Accion IN ('AFECTAR', 'GENERAR', 'CANCELAR','CONSECUTIVO','SINCRO') AND @Ok IS NULL
EXEC spActivoFijoAfectar @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID OUTPUT, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaEmision, @FechaAfectacion, @FechaConclusion, @Condicion, @Vencimiento,
@Proyecto, @Usuario, @Autorizacion, @DocFuente, @Observaciones, @Concepto,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo,
@Proveedor, @Personal, @Espacio, @ContUso, @ContUso2, @ContUso3, @FormaPago, @CtaDinero,
@Todo, @Revaluar, @ValorMercado, @FechaRegistroAnterior,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen,
@CfgTabla, @CfgAfectarDinero, @CfgContX, @CfgContXGenerar, @GenerarPoliza,
@GenerarMov, @IDGenerar OUTPUT, @GenerarMovID OUTPUT,
@AFGenerarGasto, @AFGenerarGastoCfg,
@Ok OUTPUT, @OkRef OUTPUT, @SubClave = @SubClave, @SubClaveFiscal = @SubClaveFiscal
END ELSE
BEGIN
IF @Estatus = 'SINAFECTAR' AND @Accion = 'CANCELAR' EXEC spMovCancelarSinAfectar @Modulo, @ID, @Ok OUTPUT ELSE
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
IF @Ok IS NOT NULL AND @OkRef IS NULL
IF @Ok = 80030
SELECT @OkRef = 'Movimiento: '+RTRIM(@GenerarMov)+' '+LTRIM(Convert(Char, @GenerarMovID))
ELSE
SELECT @OkRef = 'Movimiento: '+RTRIM(@Mov)+' '+LTRIM(Convert(Char, @MovID)), @IDGenerar = NULL
RETURN
END

