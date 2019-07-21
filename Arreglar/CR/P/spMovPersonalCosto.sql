SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovPersonalCosto
@Modulo			char(5),
@ID			int,
@TipoCambio		float,
@CostoMovPersonal	float	OUTPUT

AS BEGIN
SELECT @CostoMovPersonal = SUM(p.SueldoDiario*m.TipoCambio*mp.Cantidad/j.HorasPromedio)/@TipoCambio
FROM MovPersonal mp
JOIN Personal p ON p.Personal = mp.Personal
JOIN Jornada j ON j.Jornada = p.Jornada
JOIN Mon m ON m.Moneda = p.Moneda
WHERE mp.Modulo = @Modulo AND mp.ModuloID = @ID
RETURN
END

