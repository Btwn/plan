SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spReconstruirRama @Rama char(5)

AS BEGIN
SET NOCOUNT ON
DECLARE
@Conciliar		bit,
@GeneraSaldo	bit,
@EsMonetario	bit,
@EsUnidades		bit,
@EsResultados	bit,
@Fecha		datetime
SELECT @Fecha = GETDATE()
SELECT @GeneraSaldo       = GeneraSaldo,
@Conciliar  	    = Conciliar,
@EsMonetario	    = EsMonetario,
@EsUnidades        = EsUnidades,
@EsResultados	    = EsResultados
FROM Rama
WHERE Rama = @Rama
IF @EsMonetario = 1 AND @EsUnidades  = 0 AND @EsResultados = 0 EXEC spReconstruirAuxiliar   @Rama, @GeneraSaldo, @Conciliar, @Fecha ELSE
IF @EsMonetario = 1 AND @EsUnidades  = 0 AND @EsResultados = 1 EXEC spReconstruirAuxiliarR  @Rama, @GeneraSaldo, @Conciliar, @Fecha ELSE
IF @EsMonetario = 1 AND @EsUnidades  = 1 AND @EsResultados = 0 EXEC spReconstruirAuxiliarU  @Rama, @GeneraSaldo, @Conciliar, @Fecha ELSE
IF @EsMonetario = 1 AND @EsUnidades  = 1 AND @EsResultados = 1 EXEC spReconstruirAuxiliarRU @Rama, @GeneraSaldo, @Conciliar, @Fecha
RETURN
END

