SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CxpAplica

AS
SELECT
ID,
Empresa,
Mov,
MovID,
Proveedor,
"Moneda" = ProveedorMoneda,
"TipoCambio" = ProveedorTipoCambio,
FechaEmision,
Vencimiento,
"DiasCredito" = DATEDIFF(day, FechaEmision, Vencimiento),
"ImporteTotal" = ISNULL(Importe, 0.0) + ISNULL(Impuestos,0.0) - ISNULL(Retencion, 0.0) - ISNULL(Retencion2, 0.0) - ISNULL(Retencion3, 0.0),
Saldo,
Referencia,
Concepto,
Estatus,
"DiasMoratorios"  = datediff(day, Vencimiento, GETDATE()),
"FechaProntoPago" = FechaProntoPago,
DescuentoProntoPago,
"ProntoPago"      = CONVERT(money, CASE WHEN GETDATE()<DATEADD(day, 1, FechaProntoPago) THEN (ISNULL(Importe, 0)+ISNULL(Impuestos,0))*(DescuentoProntoPago/100) END),
IVAFiscal,
IEPSFiscal,
Sucursal,
OrigenTipo,
Origen,
OrigenID,
Proyecto,
UEN,
"MovMoneda" = Moneda,
"MovTipoCambio" = TipoCambio,
LineaCredito,
Amortizaciones,
InteresesOrdinarios,
InteresesFijos,
InteresesMoratorios,
SaldoInteresesOrdinarios,
SaldoInteresesOrdinariosIVA, 
SaldoInteresesMoratorios,
SaldoInteresesMoratoriosIVA, 
"SaldoTotal" = ISNULL(Saldo, 0.0)+ISNULL(SaldoInteresesOrdinarios, 0.0)+ISNULL(SaldoInteresesOrdinariosIVA, 0.0)+ISNULL(SaldoInteresesMoratorios, 0.0)+ISNULL(SaldoInteresesMoratoriosIVA, 0.0), 
RamaID
FROM
Cxp WITH (NOLOCK)
WHERE
UPPER(Estatus) NOT IN ('SINAFECTAR', 'CANCELADO')

