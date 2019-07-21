SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgRepABC ON Rep

FOR INSERT, UPDATE
AS BEGIN
DECLARE
@Reporte		varchar(20),
@EstatusA		varchar(15),
@EstatusN		varchar(15),
@SituacionA		varchar(50),
@SituacionN		varchar(50),
@Responsable	varchar(10),
@Ahora 		datetime,
@FechaInicio	datetime,
@FechaAnterior	datetime
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @EstatusA = Estatus, @SituacionA = Situacion FROM Deleted
SELECT @EstatusN = Estatus, @SituacionN = Situacion, @Reporte = Reporte, @Responsable = Responsable FROM Inserted
IF ISNULL(@EstatusA, '') <> ISNULL(@EstatusN, '') OR ISNULL(@SituacionA, '') <> ISNULL(@SituacionN, '')
BEGIN
SELECT @Ahora = GETDATE(), @FechaInicio = NULL
SELECT @FechaInicio = MIN(FechaInicio), @FechaAnterior = MAX(FechaComenzo) FROM CtaTiempo WHERE Rama = 'REP' AND Cuenta = @Reporte
IF @FechaAnterior IS NOT NULL
UPDATE CtaTiempo SET FechaTermino = @Ahora WHERE Rama = 'REP' AND Cuenta = @Reporte AND FechaComenzo = @FechaAnterior
INSERT INTO CtaTiempo (Rama,  Cuenta,   Usuario,      FechaInicio,  FechaComenzo, Estatus,   Situacion)
VALUES ('REP', @Reporte, @Responsable, @FechaInicio, @Ahora,       @EstatusN, @SituacionN)
END
END

