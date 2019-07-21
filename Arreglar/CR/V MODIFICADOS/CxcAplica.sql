SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CxcAplica

AS
SELECT
Cxc.ID,
Cxc.Empresa,
Cxc.Mov,
Cxc.MovID,
Cxc.Cliente,
Cxc.ClienteEnviarA,
"Moneda" = Cxc.ClienteMoneda,
"TipoCambio" = Cxc.ClienteTipoCambio,
Cxc.FechaEmision,
Cxc.Vencimiento,
"DiasCredito" = DATEDIFF(day, FechaEmision, Vencimiento),
Cxc.Importe,
Cxc.Impuestos,
"ImporteTotal" = ISNULL(Cxc.Importe, 0.0) + ISNULL(Cxc.Impuestos,0.0) - ISNULL(Cxc.Retencion, 0.0) - ISNULL(Cxc.Retencion2, 0.0) - ISNULL(Cxc.Retencion3, 0.0),
Cxc.Saldo,
Cxc.Referencia,
Cxc.Concepto,
Cxc.Estatus,
"DiasMoratorios"  = datediff(day, Cxc.Vencimiento, GETDATE()),
"FechaProntoPago" = Cxc.FechaProntoPago,
Cxc.DescuentoProntoPago,
"ProntoPago" = CASE WHEN Cte.DescuentoRecargos = 1 AND Cfg.CxcDescContado = 1 AND GETDATE()<DATEADD(day, cfg.CxcDescContadoDias, Cxc.FechaEmision) THEN Cxc.Saldo*cfg.CxcDescContadoPorcentaje/100 ELSE CONVERT(money, CASE WHEN GETDATE()<DATEADD(day, 1, Cxc.FechaProntoPago) THEN (ISNULL(Cxc.Importe, 0)+ISNULL(Cxc.Impuestos,0))*(Cxc.DescuentoProntoPago/100) END) END,
Cxc.IVAFiscal,
Cxc.IEPSFiscal,
Cxc.Retencion,
Cxc.Retencion2,
Cxc.Retencion3,
Cxc.Situacion,
Cxc.SituacionFecha,
Cxc.SituacionUsuario,
Cxc.SituacionNota,
Cxc.Sucursal,
Cxc.OrigenTipo,
Cxc.Origen,
Cxc.OrigenID,
Cxc.Proyecto,
Cxc.UEN,
Cxc.LineaCredito,
Cxc.TipoAmortizacion,
Cxc.TipoTasa,
Cxc.TasaDiaria,
Cxc.Amortizaciones,
Cxc.InteresesOrdinarios,
Cxc.InteresesFijos,
Cxc.InteresesMoratorios,
Cxc.SaldoInteresesOrdinarios,
Cxc.SaldoInteresesOrdinariosIVA, 
Cxc.SaldoInteresesMoratorios,
Cxc.SaldoInteresesMoratoriosIVA, 
"SaldoTotal" = ISNULL(Saldo, 0.0)+ISNULL(SaldoInteresesOrdinarios, 0.0)+ISNULL(SaldoInteresesOrdinariosIVA, 0.0)+ISNULL(SaldoInteresesMoratorios, 0.0)+ISNULL(SaldoInteresesMoratoriosIVA, 0.0), 
"MovMoneda" = Moneda,
"MovTipoCambio" = TipoCambio,
Cxc.RamaID,
Cxc.PadreMAVI,
Cxc.PadreIDMAVI,
Cxc.IDPadreMAVI
FROM Cxc WITH (NOLOCK)
JOIN Cte WITH (NOLOCK) ON Cte.Cliente = Cxc.Cliente
JOIN EmpresaCfg Cfg WITH (NOLOCK) ON Cfg.Empresa = Cxc.Empresa
WHERE  UPPER(Cxc.Estatus) NOT IN ('SINAFECTAR', 'CANCELADO')

