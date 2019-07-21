SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW DineroPosfechado

AS
SELECT
b.ID,
b.Empresa,
b.Mov,
b.MovID,
b.Moneda,
b.Referencia,
b.CtaDinero,
b.Beneficiario,
b.BeneficiarioNombre,
b.Importe,
b.FechaEmision,
b.FechaProgramada,
b.Estatus,
"Dias"  = datediff(day, GETDATE(), b.FechaProgramada),
"MovTipo" = mt.Clave,
"Cargo" = CASE WHEN mt.Clave IN ('DIN.I', 'DIN.SD', 'DIN.D',  'DIN.DE')   THEN b.Importe ELSE CONVERT(money, NULL) END,
"Abono" = CASE WHEN mt.Clave IN ('DIN.E', 'DIN.SCH', 'DIN.CH', 'DIN.CHE') THEN b.Importe ELSE CONVERT(money, NULL) END
FROM Dinero b
JOIN MovTipo mt ON b.Mov = mt.Mov AND mt.Modulo = 'DIN'
WHERE
b.Estatus = 'POSFECHADO'

