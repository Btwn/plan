SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CxcConSaldo

AS
SELECT
CxcSaldo.Empresa,
CxcSaldo.Cliente,
CxcSaldo.Moneda,
CxcSaldo.Saldo,
Cte.Nombre,
Cte.NombreCorto,
Cte.Numero,
Cte.Categoria,
Cte.Familia,
Cte.Grupo,
Cte.Estatus
FROM CxcSaldo WITH (NOLOCK)
JOIN Cte WITH (NOLOCK) ON CxcSaldo.Cliente=Cte.Cliente
JOIN Version WITH (NOLOCK) ON 1 = 1
WHERE
ROUND(CxcSaldo.Saldo, Version.RedondeoMonetarios)<>0

