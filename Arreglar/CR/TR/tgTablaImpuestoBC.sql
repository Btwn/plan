SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgTablaImpuestoBC ON TablaImpuesto

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@ClaveNueva  	varchar(50),
@ClaveAnterior	varchar(50),
@PeriodoNuevo	varchar(20),
@PeriodoAnterior	varchar(20)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ClaveNueva    = TablaImpuesto, @PeriodoNuevo = PeriodoTipo FROM Inserted
SELECT @ClaveAnterior = TablaImpuesto, @PeriodoAnterior = PeriodoTipo FROM Deleted
IF @ClaveNueva IS NULL
DELETE TablaImpuestoD WHERE TablaImpuesto = @ClaveAnterior AND PeriodoTipo = @PeriodoAnterior
ELSE
UPDATE TablaImpuestoD SET TablaImpuesto = @ClaveNueva, PeriodoTipo = @PeriodoNuevo WHERE TablaImpuesto = @ClaveAnterior AND PeriodoTipo = @PeriodoAnterior
END

