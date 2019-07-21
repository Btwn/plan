SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gMov
 AS
SELECT
Empresa,
Modulo,
ID,
Mov,
MovID,
Ejercicio,
Periodo,
FechaRegistro,
FechaEmision,
Concepto,
Proyecto,
Moneda,
TipoCambio,
Usuario,
Autorizacion,
Referencia,
DocFuente,
Observaciones,
Poliza,
PolizaID,
ContID,
Sucursal,
Turno,
Fuera,
Integradora
FROM Mov
UNION ALL
SELECT
Empresa,
Modulo,
ID,
Mov,
MovID,
Ejercicio,
Periodo,
FechaRegistro,
FechaEmision,
Concepto,
Proyecto,
Moneda,
TipoCambio,
Usuario,
Autorizacion,
Referencia,
DocFuente,
Observaciones,
Poliza,
PolizaID,
ContID,
Sucursal,
Turno,
Fuera,
Integradora
FROM hMov
;

