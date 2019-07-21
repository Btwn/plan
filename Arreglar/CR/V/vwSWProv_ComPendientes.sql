SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW vwSWProv_ComPendientes
AS
SELECT
RTRIM(ID) ID,
RTRIM(Mov) Mov,
RTRIM(MovID) MovID,
(RTRIM(Mov) + ' ' + RTrim(MovID)) as Movimiento,
FechaEmision,
SubTotal,
Impuestos,
Saldo,
(SubTotal + Impuestos) AS Total,
RTRIM(Moneda) Moneda,
Referencia,
Empresa,
Proveedor,
Estatus
FROM CompraPendiente
WHERE Estatus = 'PENDIENTE'

