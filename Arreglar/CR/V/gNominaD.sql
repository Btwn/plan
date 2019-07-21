SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gNominaD
 AS
SELECT
ID,
Renglon,
Modulo,
Plaza,
Personal,
Cuenta,
Importe,
Horas,
Cantidad,
Concepto,
Referencia,
Beneficiario,
FormaPago,
Porcentaje,
Monto,
FechaD,
FechaA,
Movimiento,
ContUso,
CuentaContable,
UEN,
NominaConcepto,
IncidenciaID,
ObligacionFiscal,
Saldo,
CantidadPendiente,
Activo,
Sucursal,
Logico1,
Logico2,
Logico3,
Logico4,
Logico5,
SucursalOrigen,
CuentaContable2,
ClavePresupuestal
FROM NominaD
UNION ALL
SELECT
ID,
Renglon,
Modulo,
Plaza,
Personal,
Cuenta,
Importe,
Horas,
Cantidad,
Concepto,
Referencia,
Beneficiario,
FormaPago,
Porcentaje,
Monto,
FechaD,
FechaA,
Movimiento,
ContUso,
CuentaContable,
UEN,
NominaConcepto,
IncidenciaID,
ObligacionFiscal,
Saldo,
CantidadPendiente,
Activo,
Sucursal,
Logico1,
Logico2,
Logico3,
Logico4,
Logico5,
SucursalOrigen,
CuentaContable2,
ClavePresupuestal
FROM hNominaD
;

