SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CxpCompraNeta

AS
SELECT
Cxp.Empresa,
Cxp.FechaEmision,
Cxp.Proveedor,
Cxp.Proyecto,
Cxp.UEN,
Cxp.Mov,
Cxp.Sucursal,
Cxp.Condicion,
'MovTipo'  = MovTipo.Clave,
'Moneda'   = Cxp.ProveedorMoneda,
'Importe'  = CASE WHEN MovTipo.Clave IN ('CXP.NC', 'CXP.DAC', 'CXP.NCD','CXP.NCF', 'CXP.NCP') THEN -Cxp.Importe   ELSE Cxp.Importe   END,
'Impuestos'= CASE WHEN MovTipo.Clave IN ('CXP.NC', 'CXP.DAC', 'CXP.NCD','CXP.NCF', 'CXP.NCP') THEN -Cxp.Impuestos ELSE Cxp.Impuestos END
FROM Cxp WITH (NOLOCK)
JOIN MovTipo WITH (NOLOCK) ON Cxp.Mov = MovTipo.Mov AND MovTipo.Modulo = 'CXP'
WHERE
MovTipo.Clave IN ('CXP.F', 'CXP.ESF', 'CXP.CA', 'CXP.CAD', 'CXP.AF', 'CXP.CAP', 'CXP.NC', 'CXP.DAC', 'CXP.NCD','CXP.NCF', 'CXP.NCP') AND
Cxp.Estatus IN ('PENDIENTE','CONCLUIDO')

