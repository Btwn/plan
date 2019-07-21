SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgTablaEvaluacionBC ON TablaEvaluacion

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@ClaveNueva  	varchar(20),
@ClaveAnterior	varchar(20)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ClaveNueva    = TablaEvaluacion FROM Inserted
SELECT @ClaveAnterior = TablaEvaluacion FROM Deleted
IF @ClaveNueva IS NULL
DELETE TablaEvaluacionD WHERE TablaEvaluacion = @ClaveAnterior
ELSE
UPDATE TablaEvaluacionD SET TablaEvaluacion = @ClaveNueva WHERE TablaEvaluacion = @ClaveAnterior
END

