SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW AuxiliarUGral

AS
SELECT ID, Empresa, Rama, Mov, MovID, Modulo,
ModuloID, Moneda, TipoCambio, Grupo, SubGrupo,
Cuenta, SubCuenta, Ejercicio, Periodo, Fecha,
Cargo, Abono, CargoU, AbonoU, Aplica,
AplicaID, Acumulado, Conciliado, EsCancelacion, FechaConciliacion,
Sucursal, Renglon, RenglonSub, '' [IDWMS], IDAuxU
FROM AuxiliarU
UNION ALL
SELECT ID, Empresa, Rama, Mov, MovID,
Modulo, ModuloID, Moneda, TipoCambio, Grupo,
SubGrupo, Cuenta, SubCuenta, Ejercicio, Periodo,
Fecha, Cargo, Abono, CargoU, AbonoU,
Aplica, AplicaID, Acumulado, Conciliado, EsCancelacion,
FechaConciliacion, Sucursal, Renglon, RenglonSub, '' [IDWMS],
IDAuxU
FROM AuxiliarUWMS

