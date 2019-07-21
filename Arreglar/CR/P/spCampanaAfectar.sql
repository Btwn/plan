SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCampanaAfectar
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
@CampanaTipo			varchar(50),
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
@CancelarID		int,
@FechaCancelacion	datetime,
@GenerarMovTipo	char(20),
@GenerarPeriodo	int,
@GenerarEjercicio	int,
@IDAplica		int,
@Aplica		varchar(20),
@AplicaID		varchar(20),
@RID		int,
@Clave                  varchar(20)
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
INSERT CampanaD (ID, Contacto, ContactoTipo, /*Nombre, Organizacion, Observaciones, */Sucursal)
SELECT @IDGenerar, Contacto, ContactoTipo, /*Nombre, Organizacion, Observaciones, */@Sucursal
FROM CampanaD
WHERE ID = @ID
IF @Ok IS NULL SELECT @Ok = 80030
END
RETURN
END
IF @Conexion = 0
BEGIN TRANSACTION
EXEC spMovEstatus @Modulo, 'AFECTANDO', @ID, @Generar, @IDGenerar, @GenerarAfectado, @Ok OUTPUT
IF @Accion = 'CANCELAR'
BEGIN
DECLARE crCampanaCancelar CURSOR FOR
SELECT ID
FROM Campana
WHERE OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
OPEN crCampanaCancelar
FETCH NEXT FROM crCampanaCancelar INTO @CancelarID
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
EXEC spAfectar @Modulo, @CancelarID, 'CANCELAR', @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
FETCH NEXT FROM crCampanaCancelar INTO @CancelarID
END
CLOSE crCampanaCancelar
DEALLOCATE crCampanaCancelar
END
IF @Accion <> 'CANCELAR'
EXEC spRegistrarMovimiento @Sucursal, @Empresa, @Modulo, @Mov, @MovID, @ID, @Ejercicio, @Periodo, @FechaRegistro, @FechaEmision,
NULL, @Proyecto, @MovMoneda, @MovTipoCambio,
@Usuario, @Autorizacion, NULL, @DocFuente, @Observaciones,
@Generar, @GenerarMov, @GenerarMovID, @IDGenerar,
@Ok OUTPUT
IF @Accion IN ('AFECTAR', 'CANCELAR')
BEGIN
/*
DECLARE crCampanaD CURSOR FOR
SELECT RID
FROM CampanaD
WHERE ID = @ID
OPEN crCampanaD
FETCH NEXT FROM crCampanaD INTO @RID
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
END
FETCH NEXT FROM crCampanaD INTO @RID
END
CLOSE crCampanaD
DEALLOCATE crCampanaD
*/
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
UPDATE Campana
SET FechaConclusion  = @FechaConclusion,
FechaCancelacion = @FechaCancelacion,
UltimoCambio     = CASE WHEN UltimoCambio IS NULL THEN @FechaRegistro ELSE UltimoCambio END,
Estatus          = @EstatusNuevo,
Situacion 	= CASE WHEN @Estatus<>@EstatusNuevo THEN NULL ELSE Situacion END/*,
GenerarPoliza    = @GenerarPoliza*/
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
END
END
IF @Accion = 'AFECTAR' AND @MovTipo = 'CMP.A' AND @EstatusNuevo = 'PENDIENTE' AND @Ok IS NULL
BEGIN
DECLARE cremail_cursor CURSOR FOR
SELECT d.RID
FROM Campana c
JOIN CampanaD d ON c.ID = d.ID
JOIN CampanaTipoSituacion t on c.CampanaTipo = t.CampanaTipo AND d.Situacion = t.Situacion
WHERE c.ID = @ID AND t.AccionMovil IN('Por Sincronizar')
OPEN cremail_cursor
FETCH NEXT FROM cremail_cursor INTO @RID
WHILE @@FETCH_STATUS = 0
BEGIN
EXEC dbo.spIntelisisMovilSendMail
@IDVisita = @RID,
@Ok       = @Ok OUTPUT,
@OkRef    = @OkRef OUTPUT
FETCH NEXT FROM cremail_cursor INTO @RID
END
CLOSE cremail_cursor
DEALLOCATE cremail_cursor
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

