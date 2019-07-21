SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CxpConSaldo

AS
SELECT
CxpSaldo.Empresa,
CxpSaldo.Proveedor,
CxpSaldo.Moneda,
CxpSaldo.Saldo,
Prov.Nombre,
Prov.NombreCorto,
Prov.Categoria,
Prov.Familia,
Prov.Estatus
FROM CxpSaldo
JOIN Prov ON CxpSaldo.Proveedor=Prov.Proveedor
JOIN Version ON 1 = 1
WHERE
ROUND(CxpSaldo.Saldo, Version.RedondeoMonetarios)<>0

