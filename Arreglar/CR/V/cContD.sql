SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW cContD

AS
SELECT
ID,
Renglon,
RenglonSub,
Cuenta,
SubCuenta,
SubCuenta2,
SubCuenta3,
Concepto,
Debe,
Debe2,
Haber,
Haber2,
Sucursal,
SucursalOrigen,
SucursalContable,
Articulo,
DepartamentoDetallista,
Presupuesto
FROM
ContD

