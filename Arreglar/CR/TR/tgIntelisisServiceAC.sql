SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgIntelisisServiceAC ON IntelisisService

FOR INSERT, UPDATE
AS BEGIN
DECLARE
@ID			int,
@EstatusN  		varchar(15),
@EstatusA  		varchar(15),
@FechaEstatusN	datetime,
@FechaEstatusA	datetime
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @EstatusN = Estatus, @FechaEstatusN = FechaEstatus, @ID = ID FROM Inserted
SELECT @EstatusA = Estatus, @FechaEstatusA = FechaEstatus FROM Deleted
IF @EstatusN <> @EstatusA
IF NOT EXISTS(SELECT * FROM IntelisisServiceLog WHERE ID = @ID AND Estatus = @EstatusN)
INSERT IntelisisServiceLog (ID, Estatus, FechaEstatus) VALUES (@ID, @EstatusN, @FechaEstatusN)
ELSE
UPDATE IntelisisServiceLog SET FechaEstatus = @FechaEstatusN WHERE ID = @ID AND Estatus = @EstatusN
END

