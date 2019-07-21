SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW AcumUGral

AS
SELECT Sucursal, Empresa, Rama, Ejercicio, Periodo,
Moneda, Grupo, SubGrupo, Cuenta, SubCuenta,
Cargos, Abonos, CargosU, AbonosU, UltimoCambio
FROM AcumU
UNION ALL
SELECT Sucursal, Empresa, Rama, Ejercicio, Periodo,
Moneda, Grupo, SubGrupo, Cuenta, SubCuenta,
Cargos, Abonos, CargosU, AbonosU, UltimoCambio
FROM AcumUWMS

