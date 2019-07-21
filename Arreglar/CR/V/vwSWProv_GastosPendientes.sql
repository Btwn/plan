SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW vwSWProv_GastosPendientes
AS
SELECT
RTRIM(id) ID,
RTRIM(Mov) Mov,
RTRIM(MovID) MovID,
(RTRIM(Mov) + ' ' + RTrim(MovID)) as Movimiento,
FechaEmision,
Saldo,
Impuestos,
Total = (Saldo + Impuestos),
RTRIM(Moneda) Moneda,
RTRIM(Situacion) Situacion,
Empresa,
Acreedor Proveedor
FROM GastoPendiente
WHERE Estatus = 'PENDIENTE'

