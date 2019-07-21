SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tg_aroProcedimientoBC ON aroProcedimiento

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@ProcedimientoN  	varchar(20),
@ProcedimientoA	varchar(20)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ProcedimientoN = Procedimiento FROM Inserted
SELECT @ProcedimientoA = Procedimiento FROM Deleted
IF @ProcedimientoN = @ProcedimientoA RETURN
IF @ProcedimientoN IS NULL
BEGIN
DELETE aroProcedimientoArt WHERE Procedimiento = @ProcedimientoA
END ELSE
IF @ProcedimientoA IS NOT NULL
BEGIN
UPDATE aroProcedimientoArt SET Procedimiento = @ProcedimientoN WHERE Procedimiento = @ProcedimientoA
END
END

