SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW vwSWCte_Embarques
AS
SELECT
Embarque.ID,
ISNULL(Embarque.Mov + ' ' + Embarque.MovID, '') As Movimiento,
Embarque.FechaEmision,
Embarque.Vehiculo,
Embarque.Agente,
Embarque.Ruta,
Embarque.Referencia,
Embarque.Concepto,
Embarque.CtaDinero,
EmbarqueMov.Cliente,
Embarque.Empresa,
Embarque.Observaciones
FROM Embarque
LEFT JOIN EmbarqueD ON EmbarqueD.ID = Embarque.ID
LEFT JOIN EmbarqueMov ON EmbarqueD.EmbarqueMov = EmbarqueMov.ID
WHERE
EmbarqueMov.Modulo = 'VTAS'

