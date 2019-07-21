SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ContResumen

AS
SELECT
e.Empresa,
e.Controladora,
d.Ejercicio,
d.Periodo,
Cont.Mov,
d.Cuenta,
d.SubCuenta,
sum(d.Debe) Debe,
sum(d.Haber) Haber,
Cta.Descripcion
FROM Cont WITH (NOLOCK)
JOIN ContD d WITH (NOLOCK) ON Cont.ID = d.ID
JOIN Cta WITH (NOLOCK) ON d.Cuenta = Cta.Cuenta
JOIN Empresa e WITH (NOLOCK) ON Cont.Empresa = e.Empresa
WHERE
Cont.Estatus = 'CONCLUIDO'
GROUP BY
e.Empresa, e.Controladora, d.Ejercicio, d.Periodo, Cont.Mov, d.Cuenta, Cta.Descripcion, d.SubCuenta

