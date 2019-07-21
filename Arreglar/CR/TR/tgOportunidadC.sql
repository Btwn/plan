SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgOportunidadC ON Oportunidad

FOR UPDATE
AS BEGIN
DECLARE
@Ok			int,
@Modulo		varchar(5),
@Mov		varchar(20),
@MovIDN		varchar(20),
@MovIDA		varchar(20),
@Empresa		varchar(5),
@Sucursal		int,
@ID			int,
@FechaInicio	datetime,
@Ahora 		datetime,
@FechaAnterior	datetime,
@EstatusNuevo 	varchar(15),
@EstatusAnterior 	varchar(15),
@SituacionNueva 	varchar(50),
@SituacionAnterior 	varchar(50),
@UsuarioA		varchar(10),
@UsuarioN		varchar(10),
@Mensaje		varchar(255),
@SPID				int,
@AfectacionUsuario	varchar(10)
SELECT @SPID = @@SPID
SELECT @AfectacionUsuario = Usuario FROM AfectacionUsuario WHERE SPID = @SPID
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @Modulo = 'OPORT', @Ok = NULL
SELECT @EstatusAnterior = NULLIF(RTRIM(Estatus), ''), @SituacionAnterior = NULLIF(RTRIM(Situacion), ''), @UsuarioA = Usuario, @MovIDA = NULLIF(RTRIM(MovID), '') FROM Deleted
SELECT @EstatusNuevo    = NULLIF(RTRIM(Estatus), ''), @SituacionNueva    = NULLIF(RTRIM(Situacion), ''), @Empresa = Empresa, @Sucursal = Sucursal, @ID = ID, @Mov = NULLIF(RTRIM(Mov), ''), @MovIDN = NULLIF(RTRIM(MovID), ''), @UsuarioN = Usuario FROM Inserted
IF @MovIDN IS NULL AND @MovIDA IS NOT NULL AND @UsuarioN <> @UsuarioA
SELECT @Ok = 30015
IF @EstatusNuevo <> @EstatusAnterior AND
((@EstatusNuevo = 'SINAFECTAR' AND @EstatusAnterior IN ('CONFIRMAR', 'PROCESAR', 'PENDIENTE', 'CONCLUIDO', 'CANCELADO') AND @EstatusAnterior NOT IN (NULL, 'AFECTANDO')) OR
(@EstatusNuevo = 'CONFIRMAR'  AND @EstatusAnterior IN ('PROCESAR', 'PENDIENTE', 'CONCLUIDO', 'CANCELADO')) OR
(@EstatusNuevo IN ('PROCESAR', 'PENDIENTE', 'CONCLUIDO') AND @EstatusAnterior = 'CANCELADO'))
SELECT @Ok = 60090
IF @Ok IS NOT NULL
BEGIN
SELECT @Mensaje = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Mensaje = RTRIM(@Mensaje) + ' '+RTRIM(@Mov)+' '+RTRIM(@MovIDN)
RAISERROR (@Mensaje,16,-1)
END
ELSE BEGIN
IF @EstatusNuevo NOT IN (NULL, 'AFECTANDO') AND (@EstatusAnterior <> @EstatusNuevo OR @SituacionAnterior <> @SituacionNueva)
BEGIN
IF @EstatusAnterior <> @EstatusNuevo AND (@EstatusAnterior <> 'AFECTANDO' OR @SituacionAnterior IS NULL OR @SituacionNueva IS NULL)
BEGIN
EXEC spMovSituacionNueva @Modulo, @Mov, @EstatusNuevo, @EstatusAnterior, @SituacionNueva OUTPUT, @ID = @ID
END
SELECT @Ahora = GETDATE(), @FechaInicio = NULL
SELECT @FechaInicio = MIN(FechaInicio), @FechaAnterior = MAX(FechaComenzo) FROM MovTiempo WHERE Modulo = @Modulo AND ID = @ID
IF @FechaInicio IS NOT NULL AND @FechaAnterior IS NOT NULL
UPDATE MovTiempo SET FechaTermino = @Ahora WHERE Modulo = @Modulo AND ID = @ID AND FechaComenzo = @FechaAnterior
IF @FechaInicio IS NULL SELECT @FechaInicio = @Ahora
INSERT INTO MovTiempo (Modulo,  Sucursal,  ID,  Usuario,                               FechaInicio,  FechaComenzo, Estatus,       Situacion)
VALUES (@Modulo, @Sucursal, @ID, ISNULL(@AfectacionUsuario, @UsuarioN), @FechaInicio, @Ahora,       @EstatusNuevo, @SituacionNueva)
END
END
EXEC spMovAlActualizar @Modulo, @ID, @Mov, @EstatusNuevo, @EstatusAnterior, @SituacionNueva, @SituacionAnterior
END

