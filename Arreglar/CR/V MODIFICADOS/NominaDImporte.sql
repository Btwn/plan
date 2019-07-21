SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW NominaDImporte
AS
SELECT
nd.ID,
cd.NumeroCta,
cd.BancoSucursal,
cd.CtaDinero,
SUM(CASE nd.Movimiento WHEN 'Percepcion' THEN nd.Importe ELSE 0.0 END) - SUM(CASE nd.Movimiento WHEN 'Deduccion' THEN nd.Importe ELSE 0.0 END) AS Importe
FROM NominaD nd WITH(NOLOCK) JOIN Personal p WITH(NOLOCK)
ON p.Personal = nd.Personal
JOIN CtaDinero cd WITH(NOLOCK)
ON p.CtaDinero=cd.CtaDinero
WHERE nd.Personal IS NOT NULL
GROUP BY nd.ID, p.CtaDinero,cd.NumeroCta,cd.BancoSucursal,cd.CtaDinero

