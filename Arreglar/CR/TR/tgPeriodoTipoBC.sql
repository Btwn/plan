SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgPeriodoTipoBC ON PeriodoTipo

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@ClaveNueva  	varchar(50),
@ClaveAnterior	varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ClaveNueva    = PeriodoTipo FROM Inserted
SELECT @ClaveAnterior = PeriodoTipo FROM Deleted
IF @ClaveNueva IS NULL
BEGIN
DELETE PeriodoTipoD          WHERE PeriodoTipo = @ClaveAnterior
DELETE PeriodoTipoMov        WHERE PeriodoTipo = @ClaveAnterior
DELETE PeriodoTipoCalendario WHERE PeriodoTipo = @ClaveAnterior
END ELSE
BEGIN
UPDATE PeriodoTipoD          SET PeriodoTipo = @ClaveNueva WHERE PeriodoTipo = @ClaveAnterior
UPDATE PeriodoTipoMov        SET PeriodoTipo = @ClaveNueva WHERE PeriodoTipo = @ClaveAnterior
UPDATE PeriodoTipoCalendario SET PeriodoTipo = @ClaveNueva WHERE PeriodoTipo = @ClaveAnterior
END
END

