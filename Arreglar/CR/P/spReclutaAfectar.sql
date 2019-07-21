SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spReclutaAfectar
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
@Personal			varchar(10),
@Puesto			varchar(50),
@OrigenTipo			varchar(10),
@Origen			varchar(20),
@OrigenID			varchar(20),
@OrigenEstatus		varchar(15),
@OrigenMovTipo		varchar(20),
@IDOrigen			int,
@OrigenPersonal		varchar(10),
@OrigenPuesto		varchar(50),
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
@FechaCancelacion	datetime,
@GenerarMovTipo	char(20),
@GenerarPeriodo	int,
@GenerarEjercicio	int,
@PlazasPendientes	int
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
IF @Ok IS NULL
BEGIN
IF @GenerarMovTipo IN ('RE.SCO', 'RE.AP', 'RE.RCO', 'RE.CO')
BEGIN
IF @GenerarMovTipo IN ('RE.AP')
INSERT ReclutaPlaza (
Sucursal,  ID,         Plaza)
SELECT @Sucursal, @IDGenerar, rp.Plaza
FROM ReclutaPlaza rp
JOIN Plaza p ON p.Plaza = rp.Plaza AND p.Estatus LIKE 'AUTORIZA%'
WHERE rp.ID = @ID AND rp.EstaPendiente = 1
ELSE
IF @OrigenMovTipo = 'RE.SCO'
INSERT ReclutaPlaza (
Sucursal,  ID,         Plaza)
SELECT TOP(1) @Sucursal, @IDGenerar, Plaza
FROM ReclutaPlaza
WHERE ID = @IDOrigen AND EstaPendiente = 1
ELSE
IF @MovTipo = 'RE.SCO'
INSERT ReclutaPlaza (
Sucursal,  ID,         Plaza)
SELECT @Sucursal, @IDGenerar, Plaza
FROM ReclutaPlaza
WHERE ID = @ID AND EstaPendiente = 1
END
INSERT ReclutaD (
Sucursal,  ID,         Renglon, Competencia, Resultado, Valor, ValorMinimo, Peso, Observaciones)
SELECT @Sucursal, @IDGenerar, Renglon, Competencia, Resultado, Valor, ValorMinimo, Peso, Observaciones
FROM ReclutaD
WHERE ID = @ID
IF @IDOrigen IS NOT NULL
UPDATE Recluta
SET OrigenTipo = @OrigenTipo,
Origen = @Origen,
OrigenID = @OrigenID
WHERE ID = @IDGenerar
IF @Ok IS NULL SELECT @Ok = 80030
END
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
IF @MovTipo = 'RE.SCO'
UPDATE ReclutaPlaza
SET EstaPendiente = CASE WHEN @Accion = 'CANCELAR' THEN 0 ELSE 1 END
WHERE ID = @ID
IF @MovTipo IN('RE.CO', 'RE.RCO') AND @OrigenMovTipo = 'RE.SCO'
UPDATE ReclutaPlaza
SET EstaPendiente = CASE WHEN @Accion = 'CANCELAR' THEN 1 ELSE 0 END
WHERE ID = @IDOrigen
AND Plaza IN (SELECT Plaza FROM ReclutaPlaza WHERE ID = @ID)
IF @MovTipo IN ('RE.CO', 'RE.EV')
BEGIN
IF @Accion = 'AFECTAR'
BEGIN
DELETE ReclutaDA
WHERE ID = @ID
INSERT ReclutaDA (
ID,  Renglon,                                        Competencia, Peso, Resultado, Valor, ValorMinimo, Observaciones)
SELECT @ID, ROW_NUMBER() OVER(ORDER BY Competencia)*2048.0, Competencia, Peso, Resultado, Valor, ValorMinimo, Observaciones
FROM PersonalCompetencia
WHERE Personal = @Personal
DELETE PersonalCompetencia
WHERE Personal = @Personal
INSERT PersonalCompetencia (
Personal,  Competencia, Peso, Resultado, Valor, ValorMinimo, Observaciones)
SELECT @Personal, Competencia, Peso, Resultado, Valor, ValorMinimo, Observaciones
FROM ReclutaD
WHERE ID = @ID
END ELSE
IF @Accion = 'CANCELAR'
BEGIN
DELETE PersonalCompetencia
WHERE Personal = @Personal
INSERT PersonalCompetencia (
Personal,  Competencia, Peso, Resultado, Valor, ValorMinimo, Observaciones)
SELECT @Personal, Competencia, Peso, Resultado, Valor, ValorMinimo, Observaciones
FROM ReclutaDA
WHERE ID = @ID
END
END
IF @MovTipo = 'RE.AP'
UPDATE Plaza
SET Estatus = CASE WHEN @Accion = 'AFECTAR' THEN 'ALTA' ELSE 'AUTORIZARE' END
WHERE Plaza = (SELECT Plaza FROM ReclutaPlaza WHERE ID = @ID)
SELECT @PlazasPendientes = NULL
IF @OrigenMovTipo = 'RE.SCO'
SELECT @PlazasPendientes = dbo.fnReclutaPlazasPendientes(@IDOrigen)
IF (@OrigenMovTipo = 'RE.SCO' AND @MovTipo IN ('RE.CO', 'RE.RCO')) OR (@OrigenMovTipo = 'RE.SEV' AND @MovTipo = 'RE.EV')
BEGIN
UPDATE Recluta
SET Estatus =
CASE WHEN @MovTipo IN ('RE.CO', 'RE.RCO', 'RE.EV') AND @Accion = 'AFECTAR'  AND ISNULL(@PlazasPendientes, 0) = 0 THEN 'CONCLUIDO'
WHEN @MovTipo IN ('RE.CO', 'RE.RCO', 'RE.EV') AND @Accion = 'CANCELAR' THEN 'PENDIENTE'
ELSE Estatus
END,
FechaConclusion =
CASE WHEN @MovTipo IN ('RE.CO', 'RE.RCO', 'RE.EV') AND @Accion = 'AFECTAR'  AND ISNULL(@PlazasPendientes, 0) = 0 THEN @FechaRegistro
WHEN @MovTipo IN ('RE.CO', 'RE.RCO', 'RE.EV') AND @Accion = 'CANCELAR' THEN NULL
ELSE FechaConclusion
END
WHERE ID = @IDOrigen
END
/*      IF @OrigenMovTipo IN ('RE.SCO', 'RE.SEV')
BEGIN
UPDATE Recluta
SET Personal = @Personal
WHERE ID = @IDOrigen
DELETE ReclutaD
WHERE ID = @IDOrigen
INSERT ReclutaD (
ID,        Renglon, Competencia, Peso, Opcion, Valor, Observaciones)
SELECT @IDOrigen, Renglon, Competencia, Peso, Opcion, Valor, Observaciones
FROM ReclutaD
WHERE ID = @ID
END*/
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
UPDATE Recluta
SET FechaConclusion  = @FechaConclusion,
FechaCancelacion = @FechaCancelacion,
UltimoCambio     = CASE WHEN UltimoCambio IS NULL THEN @FechaRegistro ELSE UltimoCambio END,
Estatus          = @EstatusNuevo,
Situacion 	= CASE WHEN @Estatus<>@EstatusNuevo THEN NULL ELSE Situacion END,
GenerarPoliza    = @GenerarPoliza,
IDOrigen         = @IDOrigen
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
END
END
IF @OrigenMovTipo IS NOT NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @OrigenTipo, @IDOrigen, @Origen, @OrigenID, @Modulo, @ID, @Mov, @MovID, @Ok OUTPUT
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

