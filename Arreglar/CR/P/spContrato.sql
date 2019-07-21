SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContrato
@ID			int,
@Modulo	      		char(5),
@Accion			char(20),
@Base			char(20),
@FechaRegistro		datetime,
@GenerarMov		char(20),
@Usuario		char(10),
@Conexion		bit,
@SincroFinal		bit,
@Mov	      		char(20)		OUTPUT,
@MovID            	varchar(20)		OUTPUT,
@IDGenerar		int			OUTPUT,
@Estacion		int,
@Ok			int			OUTPUT,
@OkRef			varchar(255)		OUTPUT

AS BEGIN
DECLARE
@Generar		bit,
@GenerarAfectado	bit,
@Sucursal		int,
@SucursalDestino	int,
@SucursalOrigen		int,
@EnLinea		bit,
@PuedeEditar		bit,
@Empresa	      	char(5),
@MovTipo   		char(20),
@FechaEmision     	datetime,
@FechaAfectacion	datetime,
@FechaConclusion	datetime,
@Proyecto	      	varchar(50),
@MovUsuario	      	char(10),
@Responsable      	char(10),
@Autorizacion     	char(10),
@DocFuente	      	int,
@Concepto    		varchar(50),
@Observaciones    	varchar(255),
@Referencia		varchar(50),
@Estatus          	char(15),
@EstatusNuevo		char(15),
@Ejercicio	      	int,
@Periodo	      	int,
@GenerarMovID		varchar(20),
@GenerarPoliza		bit,
@ReferenciaInicial	varchar(50),
@RefInicial		char(20),
@RefInicialID		char(20),
@CfgContX		bit,
@CfgContXGenerar	char(20),
@FechaActual		datetime,
@IDOrigen		int,
@RamaID			int,
@OrigenTipo		varchar(20),
@Origen			varchar(20),
@OrigenID		varchar(20),
@ContactoTipo		varchar(20),
@Cliente		varchar(10),
@Proveedor		varchar(10),
@Prospecto		varchar(10),
@Personal		varchar(10),
@Agente			varchar(10),
@ContratoRama		varchar(50),
@Desde			datetime,
@Hasta			datetime,
@Prioridad		varchar(10),
@Titulo			varchar(100),
@DDesde			datetime,
@DHasta			datetime,
@DEstatus          	char(15),
@Contrato		varchar(50),
@Moneda			varchar(10),
@TipoCambio		float
SELECT	@Generar	   = 0,
@GenerarAfectado  = 0,
@CfgContX         = 0,
@CfgContXGenerar  = 'NO'/*,
@Verificar        = 1*/
SELECT 	@Sucursal = Sucursal, @SucursalDestino = SucursalDestino, @SucursalOrigen = SucursalOrigen, @Empresa = Empresa,
@MovID = MovID, @Mov = Mov, @FechaEmision = FechaEmision, @Concepto = Concepto, @Proyecto = Proyecto,
@MovUsuario = Usuario, @Autorizacion = Autorizacion, @Referencia = Referencia, @Moneda = NULLIF(RTRIM(Moneda), ''), @TipoCambio = TipoCambio,
@DocFuente = DocFuente, @Observaciones = Observaciones, @Estatus = UPPER(Estatus),
@Prospecto = NULLIF(RTRIM(Prospecto), ''), @Cliente = NULLIF(RTRIM(Cliente), ''), @Proveedor = NULLIF(RTRIM(Proveedor), ''),
@Personal = NULLIF(RTRIM(Personal), ''), @Agente = NULLIF(RTRIM(Agente), ''), @ContratoRama = NULLIF(RTRIM(ContratoRama), ''),
@Desde = Desde, @Hasta = Hasta, @Prioridad = NULLIF(RTRIM(Prioridad), ''), /*@Comentarios = NULLIF(RTRIM(Comentarios), ''),
@Documento = NULLIF(RTRIM(Documento), ''),*/ @Titulo = NULLIF(RTRIM(Titulo), ''), @Contrato = NULLIF(RTRIM(Contrato), ''),
@IDOrigen = IDOrigen, @RamaID = RamaID, @OrigenTipo = OrigenTipo, @Origen = Origen, @OrigenID = OrigenID
FROM Contrato
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
IF @IDOrigen IS NULL AND @OrigenTipo = @Modulo AND @Origen IS NOT NULL AND @OrigenID IS NOT NULL
SELECT @IDOrigen = MIN(ID) FROM Contrato WHERE Empresa = @Empresa AND Mov = @Origen AND MovID = @OrigenID AND Estatus IN ('PENDIENTE', 'VIGENTE', 'VENCIDO', 'CONCLUIDO')
IF @IDOrigen IS NOT NULL
BEGIN
SELECT	@RamaID = ISNULL(RamaID, ID)/*,
@OrigenFechaD = FechaD,
@OrigenFechaA = FechaA,
@OrigenTodoElDia = ISNULL(TodoElDia, 0),
@OrigenHoraD = ISNULL(RTRIM(HoraD), ''),
@OrigenHoraA = ISNULL(RTRIM(HoraA), '')*/
FROM Contrato
WHERE ID = @IDOrigen
UPDATE Contrato
SET
RamaID = @RamaID,
IDOrigen = @IDOrigen
WHERE ID = @ID
END
IF NULLIF(RTRIM(@Usuario), '') IS NULL SELECT @Usuario = @MovUsuario
EXEC spFechaAfectacion @Empresa, @Modulo, @ID, @Accion, @FechaEmision OUTPUT, @FechaRegistro, @FechaAfectacion OUTPUT
EXEC spExtraerFecha @FechaAfectacion OUTPUT
EXEC spMovTipo @Modulo, @Mov, @FechaAfectacion, @Empresa, NULL, NULL, @MovTipo OUTPUT, @Periodo OUTPUT, @Ejercicio OUTPUT, @Ok OUTPUT
EXEC spMovOk @SincroFinal, @ID, @Estatus, @Sucursal, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @FechaAfectacion, @FechaRegistro, @Ejercicio, @Periodo, @Proyecto, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion = 'CANCELAR'
BEGIN
SELECT @EstatusNuevo = 'CANCELADO'
END ELSE
IF @Accion IN ('GENERAR', 'AFECTAR', 'VERIFICAR')
BEGIN
IF @MovTipo IN ('PACTO.C') AND @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'PENDIENTE', 'VIGENTE', 'VENCIDO', 'CONCLUIDO')
BEGIN
SELECT @FechaActual = GETDATE();
EXEC spExtraerFecha @FechaActual OUTPUT
IF @FechaActual < @Desde SELECT @EstatusNuevo = 'PENDIENTE' ELSE
IF @FechaActual >= @Desde AND @FechaActual <= @Hasta SELECT @EstatusNuevo = 'VIGENTE' ELSE
IF @FechaActual > @Hasta SELECT @EstatusNuevo = 'VENCIDO'
END
IF @MovTipo IN ('PACTO.C') AND @Estatus IN ('PENDIENTE', 'VIGENTE', 'VENCIDO') AND EXISTS(SELECT * FROM Contrato WHERE IDOrigen = @ID AND Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR'))
BEGIN
SELECT @DDesde = c.Desde, @DHasta = c.Hasta FROM Contrato c WHERE IDOrigen = @ID AND Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR')
IF @EstatusNuevo = 'VIGENTE'
BEGIN
IF @FechaActual >= @DDesde AND @FechaActual <= @DHasta SELECT @EstatusNuevo = 'CONCLUIDO'
END ELSE
IF @EstatusNuevo = 'VENCIDO' SELECT @EstatusNuevo = 'CONCLUIDO'
END
END
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
IF (@Accion <> 'CANCELAR' AND @Estatus IN ('SINAFECTAR', 'PENDIENTE', 'VIGENTE', 'CONFIRMAR', 'BORRADOR', 'VENCIDO', 'CONCLUIDO')) OR
(@Accion = 'CANCELAR'  AND @Estatus IN ('VENCIDO', 'PENDIENTE', 'VIGENTE', 'CONFIRMAR', 'BORRADOR'))
BEGIN
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
IF (@Conexion = 0 OR @Accion = 'CANCELAR') AND @Accion NOT IN ('GENERAR', 'CONSECUTIVO'/*, 'SINCRO'*/) AND @Ok IS NULL
BEGIN
EXEC spContratoVerificar	@ID, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo, @FechaEmision, @Estatus, @EstatusNuevo,
@ContactoTipo, @Prospecto, @Cliente, @Proveedor, @Personal, @Agente, @ContratoRama,
@Desde, @Hasta, @Prioridad, /* @Comentarios, @Documento, */ @Titulo, @Contrato,
@IDOrigen, @RamaID, @OrigenTipo, @Origen, @OrigenID,
@FechaRegistro, @Conexion, @SincroFinal, @Sucursal, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok BETWEEN 80000 AND 89999 AND @Accion IN ('AFECTAR', 'CANCELAR') SELECT @Ok = NULL ELSE
IF @Accion = 'VERIFICAR' AND @Ok IS NULL
BEGIN
SELECT @Ok = 80000
EXEC xpOk_80000 @Empresa, @Usuario, @Accion, @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
END
END
IF @Accion IN ('AFECTAR', 'GENERAR', 'CANCELAR','CONSECUTIVO','SINCRO') AND @Ok IS NULL
EXEC spContratoAfectar	@ID, @Accion, @Empresa, @Modulo, @Mov, @MovID OUTPUT, @MovTipo, @FechaEmision, @FechaAfectacion, @FechaConclusion,
@Concepto, @Proyecto, @Usuario, @Autorizacion, @DocFuente, @Observaciones,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo, @MovUsuario,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen,
@ContactoTipo, @Prospecto, @Cliente, @Proveedor, @Personal, @Agente, @ContratoRama,
@Desde, @Hasta, @Prioridad, /* @Comentarios, @Documento, */ @Titulo, @Contrato,
@IDOrigen, @RamaID, @OrigenTipo, @Origen, @OrigenID,
@Generar, @GenerarMov, @GenerarAfectado, @IDGenerar OUTPUT, @GenerarMovID OUTPUT,
@CfgContX, @CfgContXGenerar, @GenerarPoliza, @Moneda, @TipoCambio,
@Ok OUTPUT, @OkRef OUTPUT
END ELSE
BEGIN
IF @Estatus = 'SINAFECTAR' AND @Accion = 'CANCELAR' EXEC spMovCancelarSinAfectar @Modulo, @ID, @Ok OUTPUT ELSE
IF @Estatus = 'AFECTANDO' SELECT @Ok = 80020 ELSE
IF @Estatus = 'VENCIDO' SELECT @Ok = 80010
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

