SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFAPolizas AS
SELECT
c.Empresa						'Empresa',
cuenta							'Cuenta_contable',
c.Ejercicio						'ejercicio',
c.periodo						'Periodo',
DAY(c.FechaEmision)				'Dia',
RTRIM(c.Mov) +' '+RTRIM(c.MovID)'Poliza',
CASE c.Mov WHEN 'Diario' THEN 'D' WHEN 'Egreso' THEN 'E' WHEN 'Ingreso' THEN 'I' ELSE 'D' END 'ID_poliza',
ISNULL(debe, 0)										'debe',
ISNULL(haber, 0)									'Haber',
ISNULL(c.OrigenMoneda, c.Moneda)					'Tipo_moneda',
ISNULL(c.OrigenTipoCambio, c.TipoCambio)			'Tipo_Cambio',
''													'ID_concepto',
''													'ID_recordatorio',
ISNULL(RTRIM(c.Origen) +' '+RTRIM(c.OrigenID), '')  'Referencia',
ISNULL(c.OrigenTipo, '')							'origen_modulo',
''													'Concepto'
FROM Cont c
JOIN ContD d ON c.ID = d.ID
JOIN MovTipo ON c.Mov = MovTipo.Mov AND MovTipo.Modulo = 'CONT'
WHERE d.Presupuesto = 0
AND c.Estatus = 'CONCLUIDO'
UNION ALL
SELECT
layout_polizas.Empresa			'Empresa',
cuenta_contable					'Cuenta_contable',
Ejercicio						'ejercicio',
periodo							'Periodo',
ISNULL(DAY(Fecha), 0)			'Dia',
''								'Poliza',
'D'								'ID_poliza',
ISNULL(cargos, 0)				'debe',
ISNULL(abonos, 0)				'Haber',
'1'								'Tipo_Cambio',
EmpresaCfg.ContMoneda			'Tipo_moneda',
''								'ID_concepto',
''								'ID_recordatorio',
''								'Referencia',
''								'origen_modulo',
''								'Concepto'
FROM layout_polizas
JOIN EmpresaCfg ON layout_polizas.Empresa = EmpresaCfg.Empresa
WHERE EsComplementaria = 1

