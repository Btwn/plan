SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCxpC ON Cxp

FOR UPDATE
AS BEGIN
DECLARE
@Modulo 		varchar(5),
@Mov		varchar(20),
@Sucursal		int,
@ID			int,
@FechaInicio	datetime,
@Ahora 		datetime,
@FechaAnterior	datetime,
@EstatusNuevo 	varchar(15),
@EstatusAnterior 	varchar(15),
@SituacionNueva 	varchar(50),
@SituacionAnterior 	varchar(50),
@Usuario		varchar(10),
@Mensaje		varchar(255),
@Empresa		varchar(5),
@DineroA		varchar(20),
@DineroN		varchar(20),
@DineroIDA		varchar(20),
@DineroIDN		varchar(20),
@CtaDinero		varchar(10),
@SPID				int,
@AfectacionUsuario	varchar(10)
SELECT @SPID = @@SPID
SELECT @AfectacionUsuario = Usuario FROM AfectacionUsuario WHERE SPID = @SPID
IF dbo.fnEstaSincronizando() = 1 RETURN
IF UPDATE(DineroConciliado) OR UPDATE(DineroFechaConciliacion) RETURN
SELECT @Modulo = 'CXP'
SELECT @EstatusAnterior = NULLIF(RTRIM(Estatus), ''), @SituacionAnterior = NULLIF(RTRIM(Situacion), ''), @DineroA = NULLIF(RTRIM(Dinero), ''), @DineroIDA = NULLIF(RTRIM(DineroID), '')  FROM Deleted
SELECT @EstatusNuevo    = NULLIF(RTRIM(Estatus), ''), @SituacionNueva    = NULLIF(RTRIM(Situacion), ''), @DineroN = NULLIF(RTRIM(Dinero), ''), @DineroIDN = NULLIF(RTRIM(DineroID), ''), @CtaDinero = DineroCtaDinero, @Empresa = Empresa, @Sucursal = Sucursal, @ID = ID, @Mov = NULLIF(RTRIM(Mov), ''), @Usuario = Usuario FROM Inserted
IF @DineroA <> @DineroN OR @DineroIDA <> @DineroIDN
EXEC spDineroPagado @Empresa, @Modulo, @ID, @DineroA, @DineroN, @DineroIDA, @DineroIDN, @CtaDinero, 100
IF @EstatusNuevo <> @EstatusAnterior AND
((@EstatusNuevo = 'SINAFECTAR' AND @EstatusAnterior IN ('CONFIRMAR', 'PENDIENTE', 'CONCLUIDO', 'CANCELADO') AND @EstatusAnterior NOT IN (NULL, 'AFECTANDO')) OR
(@EstatusNuevo = 'CONFIRMAR'  AND @EstatusAnterior IN ('PENDIENTE', 'CONCLUIDO', 'CANCELADO')) OR
(@EstatusNuevo IN ('PENDIENTE', 'CONCLUIDO') AND @EstatusAnterior = 'CANCELADO'))
BEGIN
SELECT @Mensaje = Descripcion FROM MensajeLista WHERE Mensaje = 60090
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
INSERT INTO MovTiempo (Modulo,  Sucursal,  ID,  Usuario,                              FechaInicio,  FechaComenzo, Estatus,       Situacion)
VALUES (@Modulo, @Sucursal, @ID, ISNULL(@AfectacionUsuario, @Usuario), @FechaInicio, @Ahora,       @EstatusNuevo, @SituacionNueva)
END
END
EXEC spMovAlActualizar @Modulo, @ID, @Mov, @EstatusNuevo, @EstatusAnterior, @SituacionNueva, @SituacionAnterior
IF @EstatusNuevo = 'CANCELADO' AND @EstatusAnterior IN ('PENDIENTE', 'CONCLUIDO') AND EXISTS(SELECT * FROM Version WHERE Sucursal = 0 AND SincroContabilidadMatriz = 1)
UPDATE Cxp SET GenerarPoliza = 1 WHERE ID = @ID AND GenerarPoliza = 0 AND ContID IS NOT NULL
END

