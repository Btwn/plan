SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW Movil_Cobro AS
SELECT
ISNULL((SELECT TOP 1 FormaPago FROM MovilFormaPago WHERE Empresa = m.Empresa),'') AS Cobro_Forma,
0.00 AS Cobro_Importe,
ISNULL((SELECT TOP 1 Moneda FROM MovilMoneda WHERE Empresa = m.Empresa),'') AS Cobro_Moneda,
ISNULL((SELECT TOP 1 Concepto FROM Concepto WHERE Modulo = 'CXC'),'') AS Cobro_Concepto,
'' AS Cobro_Referencia,
'' AS Cobro_Observaciones,
0 AS Cobro_AutoAplicar
FROM MovilUsuarioCfg m

