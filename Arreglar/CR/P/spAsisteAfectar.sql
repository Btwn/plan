SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAsisteAfectar
@ID                		int,
@Accion					char(20),
@Empresa	      		char(5),
@Modulo	      			char(5),
@Mov	  	      		char(20),
@MovID             		varchar(20)    OUTPUT,
@MovTipo     			char(20),
@FechaEmision      		datetime,
@FechaAfectacion      	datetime,
@FechaConclusion		datetime,
@Proyecto	      		varchar(50),
@Usuario	      		char(10),
@Autorizacion      		char(10),
@DocFuente	      		int,
@Localidad				varchar(50),
@Observaciones     		varchar(255),
@Concepto     			varchar(50),
@Estatus           		char(15),
@EstatusNuevo	      	char(15),
@FechaRegistro     		datetime,
@Ejercicio	      		int,
@Periodo	      		int,
@MovFechaD				datetime,
@MovFechaA				datetime,
@OrigenTipo				char(10),
@Origen					char(20),
@OrigenID				varchar(20),
@OrigenMovTipo			char(20),
@Conexion				bit,
@SincroFinal			bit,
@Sucursal				int,
@SucursalDestino		int,
@SucursalOrigen			int,
@CfgContX				bit,
@CfgContXGenerar		char(20),
@GenerarPoliza			bit,
@GenerarMov				char(20),
@IDGenerar				int	     OUTPUT,
@GenerarMovID	  		varchar(20)  OUTPUT,
@Ok                		int          OUTPUT,
@OkRef             		varchar(255) OUTPUT

AS BEGIN
DECLARE
@Personal			char(10),
@Registro			char(10),   
@HoraRegistro		char(5),
@HoraD				char(5),
@HoraA				char(5),
@FechaD				datetime,
@FechaA				datetime,
@OrigenEstatus		char(15),
@Generar			bit,
@GenerarAfectado	bit,
@GenerarModulo		char(5),
@GenerarMovTipo		char(20),
@GenerarEstatus		char(15),
@GenerarPeriodo 	int,
@GenerarEjercicio 	int,
@FechaCancelacion	datetime,
@GenerarAccion		char(20),
@CfgRegistroEstadoAvance	bit,
@Cantidad			float,
@ProyectoD			varchar(50),
@Actividad			varchar(50),
@MovimientoRef		varchar(50),
@ActividadEstado	varchar(20),
@ActividadAvance	float,
@ProyectoID			int,
@RefID				int,
@RefModulo			varchar(5),
@IDOrigen			int,		
@cID			int,
@cMov			varchar(20),
@cMovID			varchar(20)
SELECT @Generar 		= 0,
@GenerarAfectado	= 0,
@IDGenerar		= NULL,
@GenerarModulo		= NULL,
@GenerarMovID	        = NULL,
@GenerarMovTipo        = NULL,
@GenerarEstatus 	= 'SINAFECTAR'
SELECT @CfgRegistroEstadoAvance = ISNULL(AsisteRegistroEstadoAvance, 0)
FROM EmpresaCfg
WHERE Empresa = @Empresa
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
EXEC spMovGenerar @Sucursal, @Empresa, @Modulo, @Ejercicio, @Periodo, @Usuario, @FechaRegistro, @GenerarEstatus,
NULL, NULL,
@Mov, @MovID, 0,
@GenerarMov, NULL, @GenerarMovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spMovTipo @Modulo, @GenerarMov, @FechaAfectacion, @Empresa, NULL, NULL, @GenerarMovTipo OUTPUT, @GenerarPeriodo OUTPUT, @GenerarEjercicio OUTPUT, @Ok OUTPUT
IF @@ERROR <> 0 SELECT @Ok = 1
IF @GenerarMovTipo = 'ASIS.A' AND @Ok IS NULL
BEGIN
BEGIN TRANSACTION
EXEC spAsisteGenerarAsistencia @Sucursal, @ID, @FechaEmision, @Localidad, @IDGenerar, @GenerarMovTipo, @Ok OUTPUT
IF @Ok IS NULL
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
IF @Ok IS NULL SELECT @Ok = 80030
END
RETURN
END
IF @OK IS NOT NULL RETURN
IF @Conexion = 0
BEGIN TRANSACTION
EXEC spMovEstatus @Modulo, 'AFECTANDO', @ID, @Generar, @IDGenerar, @GenerarAfectado, @Ok OUTPUT
IF @Accion = 'AFECTAR' AND @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR')
BEGIN
IF (SELECT Sincro FROM Version) = 1
EXEC sp_executesql N'UPDATE AsisteD SET Sucursal = @Sucursal, SincroC = 1 WHERE ID = @ID AND (Sucursal <> @Sucursal OR SincroC <> 1)', N'@Sucursal int, @ID int', @Sucursal, @ID
IF @MovTipo = 'ASIS.R'
UPDATE AsisteD SET Fecha = @FechaEmision WHERE ID = @ID AND Fecha <> @FechaEmision
END
IF @Accion <> 'CANCELAR'
EXEC spRegistrarMovimiento @Sucursal, @Empresa, @Modulo, @Mov, @MovID, @ID, @Ejercicio, @Periodo, @FechaRegistro, @FechaEmision,
NULL, @Proyecto, NULL, NULL,
@Usuario, @Autorizacion, NULL, @DocFuente, @Observaciones,
@Generar, @GenerarMov, @GenerarMovID, @IDGenerar,
@Ok OUTPUT
IF @Accion = 'DESAFECTAR'
EXEC spMovDesafectar @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
IF @MovTipo = 'ASIS.RA' AND @CfgRegistroEstadoAvance = 1 AND @Accion <> 'DESAFECTAR'
BEGIN
DECLARE crAsiste CURSOR
FOR SELECT NULLIF(RTRIM(Personal), ''), FechaD, Cantidad, NULLIF(RTRIM(Proyecto), ''), NULLIF(RTRIM(Actividad), ''), NULLIF(RTRIM(MovimientoRef), ''), NULLIF(RTRIM(ActividadEstado), ''), ActividadAvance
FROM AsisteD
WHERE ID = @ID
OPEN crAsiste
FETCH NEXT FROM crAsiste INTO @Personal, @FechaD, @Cantidad, @ProyectoD, @Actividad, @MovimientoRef, @ActividadEstado, @ActividadAvance
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL AND @Actividad IS NOT NULL AND @ActividadEstado IS NOT NULL
BEGIN
IF @MovimientoRef IS NOT NULL
BEGIN
SELECT @RefID = NULL
EXEC spReferenciaEnModuloID @MovimientoRef, 'ST', @RefID
IF @RefID IS NOT NULL
UPDATE Soporte
SET Estado = @ActividadEstado, Avance = @ActividadAvance
WHERE Empresa = @Empresa AND Estatus IN ('PENDIENTE', 'CONCLUIDO') AND ID = @RefID
ELSE BEGIN
EXEC spReferenciaEnModuloID @MovimientoRef, 'VTAS', @RefID
IF @RefID IS NOT NULL
UPDATE VentaDAgente
SET Estado = @ActividadEstado, Avance = @ActividadAvance
WHERE ID = @RefID AND Actividad = @Actividad
ELSE SELECT @Ok = 14055, @OkRef = @MovimientoRef
END
END
IF @ProyectoD IS NOT NULL
BEGIN
SELECT @ProyectoID = NULL
SELECT @ProyectoID = MIN(ID) FROM Proyecto WHERE Proyecto = @ProyectoD AND Estatus = 'PENDIENTE'
IF @ProyectoID IS NOT NULL
UPDATE ProyectoD
SET Estado = @ActividadEstado,
Avance = @ActividadAvance,
FechaInicio = CASE WHEN FechaInicio IS NULL AND ISNULL(@ActividadAvance, 0) > 0 THEN @FechaEmision ELSE FechaInicio END,
FechaConclusion = CASE WHEN ISNULL(@ActividadAvance, 0) = 100 THEN @FechaEmision ELSE FechaInicio END
WHERE ID = @ProyectoID AND Actividad = @Actividad
IF @@ROWCOUNT = 0 OR @ProyectoID IS NULL BEGIN
SELECT @Ok = 14050, @OkRef = @Actividad
EXEC xpOk_14050 @Empresa, @Usuario, @Accion, @Modulo, @MovTipo, @Mov, @Estatus, @Actividad, @Ok OUTPUT, @OkRef OUTPUT
END
END
IF @Ok IS NOT NULL AND @OkRef IS NULL
SELECT @OkRef = 'Persona: '+RTRIM(@Personal)
END
FETCH NEXT FROM crAsiste INTO @Personal, @FechaD, @Cantidad, @ProyectoD, @Actividad, @MovimientoRef, @ActividadEstado, @ActividadAvance
IF @@ERROR <> 0 SELECT @Ok = 1
END  
CLOSE crAsiste
DEALLOCATE crAsiste
END
/*
IF @Accion <> 'DESAFECTAR'
BEGIN
DECLARE crAsiste CURSOR
FOR SELECT NULLIF(RTRIM(Personal), ''), NULLIF(UPPER(RTRIM(Registro)), ''), NULLIF(RTRIM(HoraRegistro), ''), NULLIF(RTRIM(HoraD), ''), NULLIF(RTRIM(HoraA), ''), FechaD, FechaA
FROM AsisteD
WHERE ID = @ID
OPEN crAsiste
FETCH NEXT FROM crAsiste INTO @Personal, @Registro, @HoraRegistro, @HoraD, @HoraA, @FechaD, @FechaA
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
*/
/*
IF @MovTipo IN ('ASIS.R', 'ASIS.A')
BEGIN
SELECT @UltEntrada = NULL, @UltSalida = NULL, @UltLocalidad = NULL
SELECT @UltEntrada = MAX(Entrada) FROM PersonalAsiste WHERE Personal = @Personal
IF @UltEntrada IS NOT NULL
SELECT @UltSalida = Salida, @UltLocalidad = Localidad FROM PersonalAsiste WHERE Personal = @Personal AND Entrada = @UltEntrada
IF @MovTipo = 'ASIS.R'
BEGIN
SELECT @FechaHoraRegistro = @FechaEmision
EXEC spAgregarHora @HoraRegistro, @FechaHoraRegistro OUTPUT
IF @Registro = 'ENTRADA'
BEGIN
IF @UltEntrada IS NULL OR (@UltSalida IS NOT NULL AND @UltSalida < @FechaHoraRegistro)
INSERT PersonalAsiste (Personal, Entrada, Localidad) VALUES (@Personal, @FechaHoraRegistro, @Localidad)
ELSE SELECT @Ok = 55200
END ELSE
IF @Registro = 'SALIDA'
BEGIN
IF @UltEntrada IS NOT NULL AND @UltSalida IS NULL AND @Localidad = @UltLocalidad
UPDATE PersonalAsiste SET Salida = @FechaHoraRegistro WHERE Personal = @Personal AND Entrada = @UltEntrada
ELSE SELECT @Ok = 55210
END
END ELSE
IF @MovTipo = 'ASIS.A'
BEGIN
SELECT @FechaD = @FechaEmision, @FechaA = @FechaEmision
EXEC spAgregarHora @HoraD, @FechaD OUTPUT
EXEC spAgregarHora @HoraA, @FechaA OUTPUT
IF @FechaD < @FechaA AND @FechaD IS NOT NULL AND @FechaD > @UltEntrada
BEGIN
IF @FechaA IS NOT NULL AND @FechaA > @UltSalida
INSERT PersonalAsiste (Personal, Entrada, Salida, Localidad) VALUES (@Personal, @FechaD, @FechaA, @Localidad)
ELSE SELECT @Ok = 55210
END ELSE SELECT @Ok = 55200
END
END
*/
/*          IF @Ok IS NOT NULL AND @OkRef IS NULL
SELECT @OkRef = 'Persona: '+RTRIM(@Personal)
END
FETCH NEXT FROM crAsiste INTO @Personal, @Registro, @HoraRegistro, @HoraD, @HoraA, @FechaD, @FechaA
IF @@ERROR <> 0 SELECT @Ok = 1
END  
CLOSE crAsiste
DEALLOCATE crAsiste
END*/
IF @MovTipo = 'ASIS.C' AND @Ok IS NULL
BEGIN
IF @Accion = 'CANCELAR'
UPDATE Asiste
SET Estatus = 'PROCESAR'
FROM Asiste a, AsisteD d, MovTipo mt
WHERE a.Mov = mt.Mov
AND mt.Modulo = 'ASIS'
AND mt.Clave IN ('ASIS.A', 'ASIS.R', 'ASIS.PD', 'ASIS.PH')
AND a.ID = d.ID
AND a.Empresa = @Empresa
AND a.Estatus = 'CONCLUIDO'
AND a.FechaEmision >= @MovFechaD AND a.FechaEmision < DATEADD(day, 1, @MovFechaA)
ELSE
BEGIN
UPDATE Asiste
SET Estatus = 'CONCLUIDO'
FROM Asiste a, AsisteD d, MovTipo mt
WHERE a.Mov = mt.Mov
AND mt.Modulo = 'ASIS'
AND mt.Clave IN ('ASIS.A', 'ASIS.R', 'ASIS.PD', 'ASIS.PH')
AND a.ID = d.ID
AND a.Empresa = @Empresa
AND a.Estatus = 'PROCESAR'
AND a.FechaEmision >= @MovFechaD AND a.FechaEmision < DATEADD(day, 1, @MovFechaA)
DECLARE crRegistro CURSOR FOR
SELECT DISTINCT A.ID, A.Mov, A.MovID
FROM Asiste a, AsisteD d, MovTipo mt
WHERE a.Mov = mt.Mov
AND mt.Modulo = 'ASIS'
AND mt.Clave IN ('ASIS.A', 'ASIS.R', 'ASIS.PD', 'ASIS.PH')
AND a.ID = d.ID
AND a.Empresa = @Empresa
AND a.Estatus = 'CONCLUIDO'
AND a.FechaEmision >= @MovFechaD
AND a.FechaEmision < DATEADD(day, 1, @MovFechaA)
OPEN crRegistro
FETCH NEXT FROM crRegistro INTO	@cID, @cMov, @cMovID
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, 'ASIS', @cID, @cMov, @cMovID, @Modulo, @ID, @Mov, @MovID, @OK OUTPUT
FETCH NEXT FROM crRegistro INTO	@cID, @cMov, @cMovID
END
CLOSE crRegistro
DEALLOCATE crRegistro
END
IF @OK IS NULL
EXEC spAsisteSugerirNomina @Empresa, @Sucursal, @Usuario, @Modulo, @ID, @Mov, @MovID, @Accion, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL
BEGIN
IF @EstatusNuevo = 'CANCELADO' SELECT @FechaCancelacion = @FechaRegistro ELSE SELECT @FechaCancelacion = NULL
IF @EstatusNuevo = 'CONCLUIDO' SELECT @FechaConclusion  = @FechaEmision  ELSE IF @EstatusNuevo <> 'CANCELADO' SELECT @FechaConclusion  = NULL
IF @CfgContX = 1 AND @CfgContXGenerar <> 'NO'
BEGIN
IF @Estatus IN     ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR') AND @EstatusNuevo NOT IN ('PROCESAR', 'CANCELADO') SELECT @GenerarPoliza = 1 ELSE
IF @Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR') AND @EstatusNuevo =  'CANCELADO' IF @GenerarPoliza = 1 SELECT @GenerarPoliza = 0 ELSE SELECT @GenerarPoliza = 1
END
EXEC spValidarTareas @Empresa, @Modulo, @ID, @EstatusNuevo, @Ok OUTPUT, @OkRef OUTPUT
UPDATE Asiste
SET FechaConclusion  = @FechaConclusion,
FechaCancelacion = @FechaCancelacion,
UltimoCambio     = /*CASE WHEN UltimoCambio IS NULL THEN */@FechaRegistro /*ELSE UltimoCambio END*/,
Estatus          = @EstatusNuevo,
Situacion 	      = CASE WHEN @Estatus <> @EstatusNuevo THEN NULL ELSE Situacion END,
GenerarPoliza    = @GenerarPoliza
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
END
IF @MovTipo = 'ASIS.A' AND @EstatusNuevo <> 'CONCLUIDO' AND @OrigenMovTipo IS NOT NULL AND @Ok IS NULL
BEGIN
SELECT @OrigenEstatus = @EstatusNuevo
IF @OrigenEstatus = 'PROCESAR'  SELECT @OrigenEstatus = 'CONCLUIDO'
IF @OrigenEstatus = 'CANCELADO' SELECT @FechaCancelacion = @FechaRegistro ELSE SELECT @FechaCancelacion = NULL
IF @OrigenEstatus = 'CONCLUIDO' SELECT @FechaConclusion  = @FechaEmision  ELSE IF @OrigenEstatus <> 'CANCELADO' SELECT @FechaConclusion  = NULL
UPDATE Asiste
SET FechaConclusion  = @FechaConclusion,
FechaCancelacion = @FechaCancelacion,
Estatus          = @OrigenEstatus
WHERE Empresa = @Empresa AND Mov = @Origen AND MovID = @OrigenID AND Estatus <> 'CANCELADO'
END
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spMovFinal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion = 'CANCELAR' AND @EstatusNuevo = 'CANCELADO' AND @Ok IS NULL
EXEC spCancelarFlujo @Empresa, @Modulo, @ID, @Ok OUTPUT
/***** AGREGA A MOVFLUJO EL MOVIMIENTO DE Asistencia y Ausentes *****/
IF @OrigenTipo = 'ASIS'
BEGIN
SELECT @IDOrigen = ID
FROM Asiste
WHERE Empresa = @Empresa
AND Mov = @Origen
AND MovID = @OrigenID
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @OrigenTipo, @IDOrigen, @Origen, @OrigenID, @Modulo, @ID, @Mov, @MovID, @OK OUTPUT
END
IF @Conexion = 0
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
RETURN
END

