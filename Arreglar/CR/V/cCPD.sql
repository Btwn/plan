SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW cCPD

AS
SELECT
ID,
Renglon,
ClavePresupuestal,
Tipo,
Importe,
Presupuesto,
Comprometido,
Comprometido2,
Devengado,
Devengado2,
Ejercido,
EjercidoPagado,
RemanenteDisponible,
Anticipos,
Sobrante,
Sucursal,
SucursalOrigen
FROM
CPD

