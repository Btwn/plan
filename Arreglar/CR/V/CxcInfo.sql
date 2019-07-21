SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CxcInfo

AS
SELECT p.ID, p.Empresa, p.Moneda, p.Cliente, p.ClienteEnviarA, p.Mov, p.MovID, p.FechaEmision, p.Vencimiento, p.DiasMoratorios, /*p.ProntoPago, p.FechaProntoPago, p.DescuentoProntoPago,*/
"Saldo" = CASE WHEN mt.Clave IN ('CXC.A', 'CXC.AR', 'CXC.DA','CXC.NC','CXC.DAC','CXC.NCD','CXC.NCF', 'CXC.DV', 'CXC.NCP', 'CXC.SCH') THEN -p.Saldo ELSE p.Saldo END,
p.Concepto, p.Referencia, p.Estatus, p.Situacion, p.SituacionFecha, p.SituacionUsuario, p.SituacionNota, p.Proyecto, p.UEN
FROM CxcAplica p
JOIN MovTipo mt ON p.Mov = mt.Mov AND mt.Modulo = 'CXC'
JOIN Version v ON 1 = 1
WHERE ROUND(p.Saldo, v.RedondeoMonetarios) <> 0.0 AND p.Estatus = 'PENDIENTE'
UNION
SELECT NULL, Empresa, Moneda, Cliente, NULL,
"Mov" = CASE
WHEN Round(Saldo, v.RedondeoMonetarios)<=0 THEN "Saldo a Favor"
ELSE "Saldo en Contra" END,
"MovID"= NULL, "FechaEmision"=NULL, "Vencimiento"=NULL, "DiasMoratorios"=NULL, /*"ProntoPago"=NULL, "FechaProntoPago"=NULL, "DescuentoProntoPago"=NULL, */Saldo, "Concepto"=NULL, "Referencia"=NULL, Estatus='PENDIENTE',
"Situacion" = NULL, SituacionFecha = NULL, SituacionUsuario = NULL, SituacionNota = NULL, Proyecto = NULL, UEN = NULL
FROM CxcEfectivo p
JOIN Version v ON 1 = 1
WHERE ROUND(Saldo, v.RedondeoMonetarios) <> 0.0
UNION
SELECT NULL, Empresa, Moneda, Cliente, NULL,
"Mov" = "Consumos por Facturar", "MovID"= NULL,
"FechaEmision"=NULL, "Vencimiento"=NULL, "DiasMoratorios"=NULL, /*"ProntoPago"=NULL, "FechaProntoPago"=NULL, "DescuentoProntoPago"=NULL, */Saldo, "Concepto"=NULL, "Referencia"=NULL, Estatus='PENDIENTE',
"Situacion" = NULL, SituacionFecha = NULL, SituacionUsuario = NULL, SituacionNota = NULL, Proyecto = NULL, UEN = NULL
FROM CxcConsumo p
JOIN Version v ON 1 = 1
WHERE ROUND(Saldo, v.RedondeoMonetarios) <> 0.0
UNION
SELECT NULL, Empresa, Moneda, Cliente, NULL,
"Mov" = "Vales en Circulacion", "MovID"= NULL,
"FechaEmision"=NULL, "Vencimiento"=NULL, "DiasMoratorios"=NULL, /*"ProntoPago"=NULL, "FechaProntoPago"=NULL, "DescuentoProntoPago"=NULL, */Saldo, "Concepto"=NULL, "Referencia"=NULL, Estatus='PENDIENTE',
"Situacion" = NULL, SituacionFecha = NULL, SituacionUsuario = NULL, SituacionNota = NULL, Proyecto = NULL, UEN = NULL
FROM CxcVale p
JOIN Version v ON 1 = 1
WHERE ROUND(Saldo, v.RedondeoMonetarios) <> 0.0
UNION
SELECT NULL, Empresa, Moneda, Cliente, NULL,
"Mov" = "Redondeo", "MovID"= NULL,
"FechaEmision"=NULL, "Vencimiento"=NULL, "DiasMoratorios"=NULL, /*"ProntoPago"=NULL, "FechaProntoPago"=NULL, "DescuentoProntoPago"=NULL, */Saldo, "Concepto"=NULL, "Referencia"=NULL, Estatus='PENDIENTE',
"Situacion" = NULL, SituacionFecha = NULL, SituacionUsuario = NULL, SituacionNota = NULL, Proyecto = NULL, UEN = NULL
FROM CxcRedondeo p
JOIN Version v ON 1 = 1
WHERE ROUND(Saldo,     v.RedondeoMonetarios) <> 0.0

