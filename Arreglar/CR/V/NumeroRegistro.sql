SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW NumeroRegistro
AS
SELECT
nd.ID,
COUNT(DISTINCT(nd.Personal)) NumReg,
p.CtaDinero,
cd.NumeroCta,
cd.BancoSucursal
FROM NominaD nd JOIN Personal p
ON p.Personal = nd.Personal JOIN CtaDinero cd
ON p.CtaDinero = cd.CtaDinero
WHERE nd.Personal IS NOT NULL
GROUP BY nd.ID, p.CtaDinero, cd.NumeroCta, cd.BancoSucursal

