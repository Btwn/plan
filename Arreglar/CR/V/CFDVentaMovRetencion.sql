SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDVentaMovRetencion AS
SELECT
'OrdenExportacion'	= REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,MovImpuesto.ModuloID))))) + RTRIM(LTRIM(CONVERT(varchar,MovImpuesto.ModuloID))) +
REPLICATE(' ',12) +
REPLICATE(' ',7) +
REPLICATE(' ',50),
'ID'					= MovImpuesto.ModuloID,
'Impuesto'			= CONVERT(varchar(50),'ISR'),
'ImpuestoClave'		= CONVERT(varchar(50),'GST'),
'Tasa'				= ISNULL(MovImpuesto.Retencion1,0.00),
'Importe'				= SUM((ISNULL(MovImpuesto.Retencion1,0.00)/100* ISNULL(MovImpuesto.SubTotal,0.00))*ISNULL(dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN)),0.00)),
'CategoriaImpuesto'	= 'RETENIDO'
FROM MovImpuesto
JOIN Venta ON MovImpuesto.Modulo = 'VTAS' AND MovImpuesto.ModuloId = Venta.ID
JOIN EmpresaCFD ON Venta.Empresa = EmpresaCFD.Empresa
JOIN cte ON Cte.cliente = Venta.Cliente
JOIN MovTipo mt ON mt.Modulo = 'VTAS' AND mt.Mov = Venta.Mov
WHERE MovImpuesto.Modulo = 'VTAS'
AND NULLIF(MovImpuesto.Retencion1,0.0) IS NOT NULL
AND NULLIF(Venta.Retencion,0.0) IS NOT NULL
AND ISNULL(MovImpuesto.Excento1,0) <> 1
GROUP BY MovImpuesto.ModuloID, MovImpuesto.Retencion1
UNION ALL
SELECT
'OrdenExportacion'	= REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,MovImpuesto.ModuloID))))) + RTRIM(LTRIM(CONVERT(varchar,MovImpuesto.ModuloID))) +
REPLICATE(' ',12) +
REPLICATE(' ',7) +
REPLICATE(' ',50),
'ID'					= MovImpuesto.ModuloID,
'Impuesto'			= CONVERT(varchar(50),'IVA'),
'ImpuestoClave'		= CONVERT(varchar(50),'VAT'),
'Tasa'				= ISNULL(MovImpuesto.Retencion2,0.00),
'Importe'				= SUM((CASE WHEN ISNULL(v.Retencion2BaseImpuesto1,0) = 0 THEN ISNULL(MovImpuesto.SubTotal*(MovImpuesto.Retencion2/100.0), 0.0) ELSE ISNULL(MovImpuesto.Importe1*(MovImpuesto.Retencion2/100.0),0.0) END)*dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN))),
'CategoriaImpuesto'	= 'RETENIDO'
FROM MovImpuesto
JOIN Venta ON MovImpuesto.Modulo = 'VTAS' AND MovImpuesto.ModuloId = Venta.ID
JOIN EmpresaCFD ON Venta.Empresa = EmpresaCFD.Empresa
JOIN cte ON Cte.cliente = Venta.Cliente
JOIN MovTipo mt ON mt.Modulo = 'VTAS' AND mt.Mov = Venta.Mov
JOIN version v ON 1 = 1
WHERE MovImpuesto.Modulo = 'VTAS'
AND NULLIF(MovImpuesto.Retencion2,0.0) IS NOT NULL
AND NULLIF(Venta.Retencion,0.0) IS NOT NULL
AND ISNULL(MovImpuesto.Excento2,0) <> 1
GROUP BY MovImpuesto.ModuloID, MovImpuesto.Retencion2

