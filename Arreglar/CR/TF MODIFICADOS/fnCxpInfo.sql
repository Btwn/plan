SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCxpInfo (@Empresa char(5), @ProveedorD char(10), @ProveedorA char(10))
RETURNS @Resultado TABLE (ID int NULL, Empresa char(5) NULL, Moneda char(10) NULL, TipoCambio float NULL, Proveedor char(10) NULL, Mov varchar(20) NULL, MovID varchar(20) NULL,
FechaEmision datetime NULL, Vencimiento datetime NULL, DiasMoratorios int NULL, Saldo money NULL, Referencia varchar(50),
Estatus varchar(15) NULL, Proyecto varchar(50) NULL, UEN int NULL)

AS BEGIN
INSERT @Resultado(ID, Empresa, Moneda, TipoCambio, Proveedor, Mov, MovID, FechaEmision, Vencimiento, DiasMoratorios, Saldo, Referencia, Estatus, Proyecto, UEN)
SELECT p.ID, p.Empresa, p.Moneda, p.TipoCambio, p.Proveedor, p.Mov, p.MovID, p.FechaEmision, p.Vencimiento, p.DiasMoratorios,
"Saldo" = CASE WHEN mt.Clave IN ('CXP.A', 'CXP.DA','CXP.NC','CXP.DAC','CXP.NCD','CXP.NCF','CXP.NCP', 'CXP.SD') THEN -p.Saldo ELSE p.Saldo END,
p.Referencia, p.Estatus, p.Proyecto, p.UEN
FROM CxpPendiente p WITH (NOLOCK)
JOIN MovTipo mt WITH (NOLOCK) ON p.Mov = mt.Mov AND mt.Modulo = 'CXP'
JOIN Version v WITH (NOLOCK) ON 1 = 1
WHERE ROUND(p.Saldo, v.RedondeoMonetarios) <> 0.0
AND p.Empresa = @Empresa AND p.Proveedor BETWEEN @ProveedorD AND @ProveedorA
INSERT @Resultado(Empresa, Moneda, TipoCambio, Proveedor, Mov, Saldo, Estatus)
SELECT p.Empresa, p.Moneda, m.TipoCambio, p.Proveedor,
CASE
WHEN Round(p.Saldo, v.RedondeoMonetarios)<=0 THEN 'Saldo a Favor'
ELSE 'Saldo en Contra' END,
p.Saldo, 'PENDIENTE'
FROM CxpEfectivo p WITH (NOLOCK)
JOIN Mon m WITH (NOLOCK) ON m.Moneda = p.Moneda
JOIN Version v WITH (NOLOCK) ON 1 = 1
WHERE ROUND(p.Saldo, v.RedondeoMonetarios) <> 0.0
AND p.Empresa = @Empresa AND p.Proveedor BETWEEN @ProveedorD AND @ProveedorA
INSERT @Resultado(Empresa, Moneda, TipoCambio, Proveedor, Mov, Saldo, Estatus)
SELECT p.Empresa, p.Moneda, m.TipoCambio, p.Proveedor, 'Redondeo', p.Saldo, 'PENDIENTE'
FROM CxpRedondeo p WITH (NOLOCK)
JOIN Mon m WITH (NOLOCK) ON m.Moneda = p.Moneda
JOIN Version v WITH (NOLOCK) ON 1 = 1
WHERE ROUND(p.Saldo, v.RedondeoMonetarios) <> 0.0
AND p.Empresa = @Empresa AND p.Proveedor BETWEEN @ProveedorD AND @ProveedorA
RETURN
END

