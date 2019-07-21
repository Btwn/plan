SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFAConcepto AS
SELECT
concepto_clave         = a.Articulo,
concepto_descripcion   = a.Descripcion1,
concepto_tipo          = 'Articulo'
FROM Art a
WHERE a.Estatus IN ('ALTA')
UNION ALL
SELECT
concepto_clave         = c.Concepto,
concepto_descripcion   = c.Concepto,
concepto_tipo          = 'Gastos'
FROM Concepto c
WHERE c.Modulo = 'GAS'

