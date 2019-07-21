SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CxpInfo

AS
SELECT p.ID, p.Empresa, p.Moneda, p.Proveedor, p.Mov, p.MovID, p.FechaEmision, p.Vencimiento, p.DiasMoratorios, /*p.ProntoPago, p.FechaProntoPago, p.DescuentoProntoPago,*/
"Saldo" = CASE WHEN mt.Clave IN ('CXP.A', 'CXP.DA','CXP.NC','CXP.DAC','CXP.NCD','CXP.NCF','CXP.NCP', 'CXP.SD') THEN -p.Saldo ELSE p.Saldo END,
p.Referencia, p.Estatus, p.Proyecto, p.UEN
FROM CxpAplica p
JOIN MovTipo mt ON p.Mov = mt.Mov AND mt.Modulo = 'CXP'
JOIN Version v ON 1 = 1
WHERE ROUND(p.Saldo, v.RedondeoMonetarios) <> 0.0 AND p.Estatus = 'PENDIENTE'
UNION ALL
SELECT NULL, Empresa, Moneda, Proveedor,
"Mov" = CASE
WHEN Round(Saldo, v.RedondeoMonetarios)<=0 THEN "Saldo a Favor"
ELSE "Saldo en Contra" END,
"MovID"=NULL, "FechaEmision"=NULL, "Vencimiento"=NULL, "DiasMoratorios"=NULL, /*"ProntoPago"=NULL, "FechaProntoPago"=NULL, "DescuentoProntoPago"=NULL, */Saldo, "Referencia"=NULL, "Estatus"='PENDIENTE', Proyecto = NULL, UEN = NULL
FROM CxpEfectivo
JOIN Version v ON 1 = 1
WHERE ROUND(Saldo, v.RedondeoMonetarios) <> 0.0
UNION ALL
SELECT NULL, Empresa, Moneda, Proveedor,
"Mov" = "Redondeo", "MovID"= NULL,
"FechaEmision"=NULL, "Vencimiento"=NULL, "DiasMoratorios"=NULL, /*"ProntoPago"=NULL, "FechaProntoPago"=NULL, "DescuentoProntoPago"=NULL, */Saldo, "Referencia"=NULL, Estatus='PENDIENTE', Proyecto = NULL, UEN = NULL
FROM CxpRedondeo p
JOIN Version v ON 1 = 1
WHERE ROUND(Saldo, v.RedondeoMonetarios) <> 0.0

