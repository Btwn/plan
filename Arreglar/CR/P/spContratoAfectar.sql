SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spContratoAfectar
@ID				int,
@Accion				char(20),
@Empresa			char(5),
@Modulo				char(5),
@Mov				char(20),
@MovID				varchar(20)	OUTPUT,
@MovTipo			char(20),
@FechaEmision			datetime,
@FechaAfectacion		datetime,
@FechaConclusion		datetime,
@Concepto			varchar(50),
@Proyecto			varchar(50),
@Usuario			char(10),
@Autorizacion			char(10),
@DocFuente			int,
@Observaciones			varchar(255),
@Estatus			char(15),
@EstatusNuevo			char(15),
@FechaRegistro			datetime,
@Ejercicio			int,
@Periodo			int,
@MovUsuario			char(10),
@Conexion			bit,
@SincroFinal			bit,
@Sucursal			int,
@SucursalDestino		int,
@SucursalOrigen			int,
@ContactoTipo			varchar(20),
@Prospecto			varchar(10),
@Cliente			varchar(10),
@Proveedor			varchar(10),
@Personal			varchar(10),
@Agente				varchar(10),
@ContratoRama			varchar(50),
@Desde				datetime,
@Hasta				datetime,
@Prioridad			varchar(10),
@Titulo				varchar(100),
@Contrato			varchar(50),
@IDOrigen			int,
@RamaID				int,
@OrigenTipo			varchar(20),
@Origen				varchar(20),
@OrigenID			varchar(20),
@Generar			bit,
@GenerarMov			char(20),
@GenerarAfectado		bit,
@IDGenerar			int	     	OUTPUT,
@GenerarMovID			varchar(20)	OUTPUT,
@CfgContX			bit,
@CfgContXGenerar		char(20),
@GenerarPoliza			bit,
@Moneda				varchar(10),
@TipoCambio			float,
@Ok				int          	OUTPUT,
@OkRef				varchar(255) 	OUTPUT

AS BEGIN
DECLARE
@FechaCancelacion		datetime,
@GenerarMovTipo			char(20),
@GenerarPeriodo			int,
@GenerarEjercicio		int,
@Renglon			float,
@AvanceID			int,
@Destino			varchar(50),
@DesdeS				datetime,
@HastaS				datetime,
@Anos				int,
@Meses				int,
@Dias				int,
@PrimerDiaMes			datetime,
@UltimoDiaMes			datetime,
@p					int,
@MasterMovID		varchar(20),
@Max				int,
@MovIDMaster        varchar(20),
@OrigenMovID		varchar(20)
EXEC spMovConsecutivo @Sucursal, @SucursalOrigen, @SucursalDestino, @Empresa, @Usuario, @Modulo, @Ejercicio, @Periodo, @ID, @Mov, NULL,
@Estatus, @Concepto, @Accion, @Conexion, @SincroFinal, @MovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
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
EXEC spMovGenerar 	@Sucursal, @Empresa, @Modulo, @Ejercicio, @Periodo, @Usuario, @FechaRegistro, 'SINAFECTAR',
NULL, NULL, @Mov, @MovID, 0, @GenerarMov, NULL, @GenerarMovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @MovTipo = 'PACTO.C'
BEGIN
BEGIN TRANSACTION
BEGIN TRY
SELECT @Anos = datediff(yy, @Desde, @Hasta)
IF DATEADD(yy, @Anos, @Desde) > @Hasta SELECT @Anos = @Anos - 1
SELECT @DesdeS = DATEADD(yy, @Anos, @Desde)
SELECT @Meses = DATEDIFF(mm, @DesdeS, @Hasta)
IF DATEADD(mm, @Meses, @DesdeS) > @Hasta SELECT @Meses = @Meses - 1
SELECT @DesdeS = DATEADD(mm, @Meses, @DesdeS)
SELECT @Dias = datediff(dd, @DesdeS, @Hasta)
SELECT @DesdeS = dateadd(dd, @Dias, @DesdeS)
SELECT @HastaS = DATEADD(yyyy, @Anos, @Hasta)
SELECT @HastaS = DATEADD(mm, @Meses, @HastaS)
SELECT @HastaS = DATEADD(dd, @Dias + 1, @HastaS)
SELECT @DesdeS = @Hasta + 1
SELECT @PrimerDiaMes = @Desde, @UltimoDiaMes = dbo.fnUltimoDiaMes(@Hasta)
EXEC spPrimerDiaMes @PrimerDiaMes OUTPUT
IF @PrimerDiaMes = @Desde AND @Hasta = @UltimoDiaMes
BEGIN
SELECT @PrimerDiaMes = @HastaS, @UltimoDiaMes = dbo.fnUltimoDiaMes(@HastaS)
EXEC spPrimerDiaMes @PrimerDiaMes OUTPUT
IF @UltimoDiaMes <> @HastaS
SELECT @HastaS = @PrimerDiaMes - 1
IF DATEDIFF(mm, @Desde, @Hasta) <> DATEDIFF(mm, @DesdeS, @HastaS)
SELECT @HastaS = @UltimoDiaMes
END 
SELECT @p = CHARINDEX('-', @MovID)
IF @p > 0
SELECT @MovIDMaster = SUBSTRING(@MovID, 1, @p-1)
ELSE
SELECT @MovIDMaster = @MovID
SELECT @Max = ISNULL(MAX(CONVERT(int, SUBSTRING(MovID, LEN(@MovIDMaster)+2, 20))), 0)
FROM Contrato
WHERE MovID LIKE RTRIM(@MovIDMaster)+'-%'
AND Mov = @GenerarMov
AND Empresa = @Empresa
AND Estatus IN ('PENDIENTE', 'CONCLUIDO', 'CANCELADO', 'VIGENTTE')
SELECT @GenerarMovID = RTRIM(@MovIDMaster)+'-'+CONVERT(varchar, @Max+1)
IF @MovID IS NOT NULL
UPDATE Contrato SET MovID = @GenerarMovID WHERE ID = @IDGenerar
UPDATE Contrato SET Desde = @DesdeS, Hasta = @HastaS WHERE ID = @IDGenerar
END TRY
BEGIN CATCH
SELECT @Ok = 1
END CATCH
IF @Ok IS NULL
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
END
EXEC spMovTipo @Modulo, @GenerarMov, @FechaAfectacion, @Empresa, NULL, NULL, @GenerarMovTipo OUTPUT, @GenerarPeriodo OUTPUT, @GenerarEjercicio OUTPUT, @Ok OUTPUT
IF @Ok IS NULL
SELECT @Ok = 80030
END
IF @Conexion = 0
BEGIN TRANSACTION
EXEC spMovEstatus @Modulo, 'AFECTANDO', @ID, @Generar, @IDGenerar, @GenerarAfectado, @Ok OUTPUT
IF @Accion = 'AFECTAR'
BEGIN
IF @Ok IS NULL AND @MovTipo IN ('PACTO.C') AND @Contrato IS NULL AND @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @EstatusNuevo IN ('PENDIENTE', 'VIGENTE', 'VENCIDO')
BEGIN
IF EXISTS(SELECT * FROM Contrato WHERE UPPER(RTRIM(Contrato)) = UPPER(RTRIM(LTRIM(@Mov)) + ' ' + RTRIM(LTRIM(@MovID))) AND Estatus IN ('PENDIENTE', 'VIGENTE', 'VENCIDO') AND Empresa = @Empresa)
SELECT @Ok = 73060, @OkRef = 'Contrato'
ELSE
UPDATE Contrato SET Contrato = RTRIM(LTRIM(@Mov)) + ' ' + RTRIM(LTRIM(@MovID)) WHERE ID = @ID
END
IF @IDOrigen IS NOT NULL AND (SELECT Estatus FROM Contrato WHERE ID = @IDOrigen) IN (/*'PENDIENTE',*/ 'VIGENTE', 'VENCIDO')
EXEC spAfectar 'PACTO', @IDOrigen, @EnSilencio = 1, @Ok = @Ok OUTPUT, @Conexion = 1, @OkRef = @OkRef OUTPUT
END
IF @Accion <> 'CANCELAR'
EXEC spRegistrarMovimiento @Sucursal, @Empresa, @Modulo, @Mov, @MovID, @ID, @Ejercicio, @Periodo, @FechaRegistro, @FechaEmision,
NULL, @Proyecto, @Moneda, @TipoCambio,
@Usuario, @Autorizacion, NULL, @DocFuente, @Observaciones,
@Generar, @GenerarMov, @GenerarMovID, @IDGenerar,
@Ok OUTPUT
IF @Ok IS NULL
BEGIN
IF @EstatusNuevo = 'CANCELADO' SELECT @FechaCancelacion = @FechaRegistro ELSE SELECT @FechaCancelacion = NULL
IF @EstatusNuevo = 'VENCIDO' SELECT @FechaConclusion  = @FechaRegistro ELSE IF @EstatusNuevo <> 'CANCELADO' SELECT @FechaConclusion  = NULL
IF @CfgContX = 1 AND @CfgContXGenerar <> 'NO'
BEGIN
IF @Estatus =  'SINAFECTAR' AND @EstatusNuevo <> 'CANCELADO' SELECT @GenerarPoliza = 1 ELSE
IF @Estatus <> 'SINAFECTAR' AND @EstatusNuevo =  'CANCELADO' IF @GenerarPoliza = 1 SELECT @GenerarPoliza = 0 ELSE SELECT @GenerarPoliza = 1
END
EXEC spValidarTareas @Empresa, @Modulo, @ID, @EstatusNuevo, @Ok OUTPUT, @OkRef OUTPUT
UPDATE Contrato
SET
FechaConclusion  = @FechaConclusion,
FechaCancelacion = @FechaCancelacion,
UltimoCambio     = /*CASE WHEN UltimoCambio IS NULL THEN */@FechaRegistro /*ELSE UltimoCambio END*/,
Estatus          = @EstatusNuevo,
Situacion 	 = CASE WHEN @Estatus <> @EstatusNuevo THEN NULL ELSE Situacion END/*,
GenerarPoliza    = @GenerarPoliza*/
WHERE ID = @ID
END
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spMovFinal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion = 'AFECTAR'
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @OrigenTipo, @IDOrigen, @Origen, @OrigenID, @Modulo, @ID, @Mov, @MovID, @Ok OUTPUT
IF @Accion = 'CANCELAR' AND @EstatusNuevo = 'CANCELADO' AND @Ok IS NULL
EXEC spCancelarFlujo @Empresa, @Modulo, @ID, @Ok OUTPUT
/*IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC vic_spContratoAfectar @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @FechaEmision, @FechaAfectacion, @FechaConclusion, @Estatus, @Usuario, @Ok OUTPUT, @OkRef OUTPUT*/
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC xpContratoAfectar @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @FechaEmision, @FechaAfectacion, @FechaConclusion, @Estatus, @EstatusNuevo, @IDGenerar OUTPUT, @Usuario, @Ok OUTPUT, @OkRef OUTPUT
IF @Conexion = 0
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
RETURN
END

