SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGestionAfectar
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
@UEN				int,
@Usuario	      		char(10),
@Autorizacion      		char(10),
@FechaAutorizacion		datetime,
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
@IDOrigen			int,
@OrigenTipo			varchar(10),
@Origen			varchar(20),
@OrigenID			varchar(20),
@OrigenMovTipo		varchar(20),
@Estado			varchar(30),
@EstadoAnterior		varchar(30),
@Avance				float,
@AvanceAnterior		float,
@Esfuerzo			float,
@EsfuerzoAnterior	float,
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
@OPORT						bit,
@ProyEnviarTareaGestion      bit,
@IDGenerar			int	     	OUTPUT,
@GenerarMovID	  	varchar(20)	OUTPUT,
@Ok                		int          OUTPUT,
@OkRef             		varchar(255) OUTPUT

AS BEGIN
DECLARE
@CancelarID			int,
@FechaCancelacion		datetime,
@GenerarMovTipo		char(20),
@GenerarPeriodo		int,
@GenerarEjercicio		int,
@OrigenEstatus		varchar(15),
@GastoAnexoTotalPesos	money,
@RID			int,
@EstatusD			varchar(15),
@SubClave			varchar(20),
@AFArticulo			varchar(20),
@AFSerie			varchar(50)
SELECT @GastoAnexoTotalPesos  = NULL
SELECT @SubClave = SubClave FROM MovTipo WITH(NOLOCK) WHERE Mov = @Mov AND Modulo = @Modulo
EXEC spMovConsecutivo @Sucursal, @SucursalOrigen, @SucursalDestino, @Empresa, @Usuario, @Modulo, @Ejercicio, @Periodo, @ID, @Mov, NULL, @Estatus, @Concepto, @Accion, @Conexion, @SincroFinal, @MovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR') AND @Accion <> 'CANCELAR' AND @Ok IS NULL
EXEC spMovChecarConsecutivo	@Empresa, @Modulo, @Mov, @MovID, NULL, @Ejercicio, @Periodo, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion IN ('CONSECUTIVO', 'SINCRO') AND @Ok IS NULL
BEGIN
IF @Accion = 'SINCRO' EXEC spAsignarSucursalEstatus @ID, @Modulo, @SucursalDestino, @Accion
SELECT @Ok = 80060, @OkRef = @MovID
RETURN
END
IF @EstatusNuevo = 'AUTORIZAR' AND @Ok IS NULL
BEGIN
EXEC spAsignarSucursalEstatus @ID, @Modulo, @SucursalDestino, @EstatusNuevo
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
IF ((@MovTipo NOT IN ('GES.REU')) OR (@GenerarMovTipo NOT IN ('GES.STAR', 'GES.OTAR'))) BEGIN
INSERT GestionPara (
ID,         Usuario, Participacion, Sucursal)
SELECT @IDGenerar, Usuario, Participacion, @Sucursal
FROM GestionPara
WITH(NOLOCK) WHERE ID = @ID
END
INSERT GestionAgenda (
ID,         Modulo, Mov, MovID, Orden, Sucursal)
SELECT @IDGenerar, Modulo, Mov, MovID, Orden, @Sucursal
FROM GestionAgenda
WITH(NOLOCK) WHERE ID = @ID
IF @SubClave IN ('MAF.SI') AND @GenerarMovTipo IN ('GES.RES') 
BEGIN
INSERT GestionActivoFIndicador (
ID,         Tipo, Indicador, Referencia, LecturaAnterior, Lectura)
SELECT @IDGenerar, Tipo, Indicador, Referencia, LecturaAnterior, Lectura
FROM GestionActivoFIndicador
WITH(NOLOCK) WHERE ID = @ID
END
IF @Ok IS NULL SELECT @Ok = 80030
END
RETURN
END
IF @Conexion = 0
BEGIN TRANSACTION
EXEC spMovEstatus @Modulo, 'AFECTANDO', @ID, @Generar, @IDGenerar, @GenerarAfectado, @Ok OUTPUT
/*    IF @Accion = 'CANCELAR'
BEGIN
DECLARE crGestionCancelar CURSOR FOR
SELECT ID
FROM Gestion WITH(NOLOCK)
WHERE  OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
OPEN crGestionCancelar
FETCH NEXT FROM crGestionCancelar  INTO @CancelarID
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
EXEC spAfectar @Modulo, @CancelarID, 'CANCELAR', @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
FETCH NEXT FROM crGestionCancelar  INTO @CancelarID
END
CLOSE crGestionCancelar
DEALLOCATE crGestionCancelar
END*/
IF @Accion <> 'CANCELAR'
EXEC spRegistrarMovimiento @Sucursal, @Empresa, @Modulo, @Mov, @MovID, @ID, @Ejercicio, @Periodo, @FechaRegistro, @FechaEmision,
NULL, @Proyecto, @MovMoneda, @MovTipoCambio,
@Usuario, @Autorizacion, NULL, @DocFuente, @Observaciones,
@Generar, @GenerarMov, @GenerarMovID, @IDGenerar,
@Ok OUTPUT
IF @Accion IN ('AFECTAR', 'CANCELAR')
BEGIN
IF @OrigenMovTipo IN ('GES.SRES', 'GES.REU', 'GES.STAR', 'GES.OTAR')  AND @MovTipo NOT IN ('GES.MOD', 'GES.AV', 'GES.TE')
UPDATE GestionPara
 WITH(ROWLOCK) SET RespuestaID = CASE WHEN @Accion = 'CANCELAR' THEN NULL ELSE @ID END
WHERE ID = @IDOrigen AND Usuario = @Usuario
IF @MovTipo = 'GES.MOD'
BEGIN
UPDATE Gestion
 WITH(ROWLOCK) SET Proyecto = n.Proyecto, UEN = n.UEN, Prioridad = n.Prioridad, Concepto = n.Concepto, Referencia = n.Referencia, Observaciones = n.Observaciones, Comentarios = n.Comentarios,
Asunto = n.Asunto, Espacio = n.Espacio, FechaD = n.FechaD, FechaA = n.FechaA, TodoElDia = n.TodoElDia, HoraD = n.HoraD, HoraA = n.HoraA,
Estado = n.Estado, Avance = n.Avance, Duracion = n.Duracion
FROM Gestion
JOIN Gestion n ON n.ID = @ID
WHERE Gestion.ID = @IDOrigen
DELETE GestionPara WHERE ID = @IDOrigen
INSERT GestionPara (
ID,        Usuario, Participacion, Sucursal)
SELECT @IDOrigen, Usuario, Participacion, Sucursal
FROM GestionPara
WITH(NOLOCK) WHERE ID = @ID
DELETE GestionAgenda WHERE ID = @IDOrigen
INSERT GestionAgenda (
ID,        Modulo, Mov, MovID, Orden, Sucursal)
SELECT @IDOrigen, Modulo, Mov, MovID, Orden, Sucursal
FROM GestionAgenda
WITH(NOLOCK) WHERE ID = @ID
END
IF @MovTipo NOT IN ('GES.SRES', 'GES.REU', 'GES.STAR', 'GES.OTAR', 'GES.MOD')
DELETE GestionPara WHERE ID = @ID
IF @MovTipo NOT IN ('GES.REU', 'GES.MOD', 'GES.AV', 'GES.TE')
DELETE GestionAgenda WHERE ID = @ID
IF @OrigenMovTipo = 'GES.REU' AND @MovTipo NOT IN ('GES.MOD', 'GES.AV', 'GES.TE', 'GES.OK', 'GES.NO')
EXEC spGestionAgendaAgregarMov @Empresa, @Sucursal, @Modulo, @ID, @Origen, @OrigenID, @IDOrigen
IF @MovTipo IN ('GES.AV', 'GES.TE')
BEGIN
IF @Accion = 'CANCELAR'
UPDATE Gestion  WITH(ROWLOCK) SET Estado = @EstadoAnterior, Avance = @AvanceAnterior, Esfuerzo = @EsfuerzoAnterior WHERE ID = @IDOrigen
ELSE BEGIN
SELECT @EstadoAnterior = Estado, @AvanceAnterior = Avance, @EsfuerzoAnterior = Esfuerzo FROM Gestion WITH(NOLOCK) WHERE ID = @IDOrigen
IF @MovTipo = 'GES.TE' SELECT @Estado = 'Completada', @Avance = 100.0
UPDATE Gestion  WITH(ROWLOCK) SET Estado = @Estado, Avance = @Avance, Esfuerzo = @Esfuerzo WHERE ID = @IDOrigen
END
END
IF @OPORT = 1
BEGIN
IF @Accion = 'CANCELAR'
EXEC spGestionOportunidadActualizar @ID, @FechaEmision, @IDOrigen, @Accion, @Empresa, @Modulo, @Mov, @MovID, @AvanceAnterior, @EstadoAnterior, @Usuario, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
ELSE
EXEC spGestionOportunidadActualizar @ID, @FechaEmision, @IDOrigen, @Accion, @Empresa, @Modulo, @Mov, @MovID, @Avance, @Estado, @Usuario, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
IF @ProyEnviarTareaGestion = 1
BEGIN
IF @Accion = 'CANCELAR'
EXEC spGestionProyectoActualizar @ID, @FechaEmision, @IDOrigen, @Accion, @Empresa, @Modulo, @Mov, @MovID, @AvanceAnterior, @EsfuerzoAnterior, @EstadoAnterior, @Usuario, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
ELSE
EXEC spGestionProyectoActualizar @ID, @FechaEmision, @IDOrigen, @Accion, @Empresa, @Modulo, @Mov, @MovID, @Avance, @Esfuerzo, @Estado, @Usuario, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
IF @Accion = 'CANCELAR'
UPDATE Gestion
 WITH(ROWLOCK) SET Estatus = 'CANCELADO', FechaCancelacion = @FechaRegistro
FROM Gestion g JOIN MovTipo mt  WITH(NOLOCK) ON mt.Modulo = 'GES' AND mt.Mov = g.Mov
WHERE g.IDOrigen = @ID AND g.Estatus = 'CONCLUIDO' AND mt.Clave = 'GES.MOD'
IF EXISTS(SELECT * FROM Gasto WITH(NOLOCK) WHERE AnexoModulo = @Modulo AND AnexoID = @ID) AND @Ok IS NULL
BEGIN
EXEC spGastoAnexo @Empresa, @Modulo, @ID, @Accion, @FechaRegistro, @Usuario, @GastoAnexoTotalPesos OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spGastoAnexoEliminar @Empresa, @Modulo, @ID
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
UPDATE Gestion
 WITH(ROWLOCK) SET Estado           = @Estado,
EstadoAnterior   = CASE WHEN @MovTipo IN ('GES.AV', 'GES.TE') AND @Accion <> 'CANCELAR' THEN @EstadoAnterior ELSE NULL END,
Avance		= @Avance,
AvanceAnterior   = CASE WHEN @MovTipo IN ('GES.AV', 'GES.TE') AND @Accion <> 'CANCELAR' THEN @AvanceAnterior ELSE NULL END,
Esfuerzo			= @Esfuerzo,
EsfuerzoAnterior   = CASE WHEN @MovTipo IN ('GES.AV', 'GES.TE') AND @Accion <> 'CANCELAR' THEN @EsfuerzoAnterior ELSE NULL END,
FechaConclusion  = @FechaConclusion,
FechaCancelacion = @FechaCancelacion,
UltimoCambio     = CASE WHEN UltimoCambio IS NULL THEN @FechaRegistro ELSE UltimoCambio END,
Estatus          = @EstatusNuevo,
Situacion 	= CASE WHEN @Estatus<>@EstatusNuevo THEN NULL ELSE Situacion END,
Autorizacion     = @Autorizacion,
FechaAutorizacion= @FechaAutorizacion,
Gastos           = NULLIF(@GastoAnexoTotalPesos, 0.0)
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
END
IF @Accion = 'AFECTAR' AND @MovTipo = 'GES.RES' AND @EstatusNuevo = 'CONCLUIDO' AND @Ok IS NULL 
BEGIN
EXEC spMAFActualizarIndicadorAF @ID, @FechaConclusion, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @AFArticulo = AFarticulo, @AFSerie = AFSerie FROM Gestion WITH(NOLOCK) WHERE ID = @ID
EXEC spMAFGenerarServicios @Empresa, @Sucursal, @Accion, @Usuario, @ID, @AFArticulo, @AFSerie, 0, @Ok OUTPUT, @OkRef OUTPUT
END
END
IF @Ok IN (NULL, 80030) AND @IDOrigen IS NOT NULL
BEGIN
EXEC spGestionChecarEstatus @IDOrigen, @FechaEmision, @ID, @MovTipo, @Ok OUTPUT, @OkRef OUTPUT
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @OrigenTipo, @IDOrigen, @Origen, @OrigenID, @Modulo, @ID, @Mov, @MovID, @Ok OUTPUT
END
END
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spMovFinal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion = 'CANCELAR' AND @EstatusNuevo = 'CANCELADO' AND @Ok IS NULL
EXEC spCancelarFlujo @Empresa, @Modulo, @ID, @Ok OUTPUT
IF @Conexion = 0
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
RETURN
END

