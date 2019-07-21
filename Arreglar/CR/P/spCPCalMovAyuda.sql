SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCPCalMovAyuda
@Estacion	int,
@Modulo	varchar(5),
@ID         int

AS BEGIN
DECLARE
@Empresa	varchar(5)
DELETE CPCalMovPreAyuda WHERE Estacion = @Estacion
IF @Modulo = 'COMS'
BEGIN
INSERT CPCalMovPreAyuda (
Estacion,  ClavePresupuestal,   Importe)
SELECT @Estacion, t.ClavePresupuestal, t.ImporteTotal
FROM CompraTCalc t
JOIN Art a ON a.Articulo = t.Articulo
WHERE t.ID = @ID AND NULLIF(t.ClavePresupuestal, '') IS NOT NULL
AND NULLIF(RTRIM(a.ClavePresupuestalImpuesto1), '') IS NULL
INSERT CPCalMovPreAyuda (
Estacion,  ClavePresupuestal,   Importe)
SELECT @Estacion, t.ClavePresupuestal, t.SubTotal
FROM CompraTCalc t
JOIN Art a ON a.Articulo = t.Articulo
WHERE t.ID = @ID AND NULLIF(t.ClavePresupuestal, '') IS NOT NULL
AND NULLIF(RTRIM(a.ClavePresupuestalImpuesto1), '') IS NOT NULL
INSERT CPCalMovPreAyuda (
Estacion,  ClavePresupuestal,            Importe)
SELECT @Estacion, a.ClavePresupuestalImpuesto1, t.Impuesto1Total
FROM CompraTCalc t
JOIN Art a ON a.Articulo = t.Articulo
WHERE t.ID = @ID AND NULLIF(t.ClavePresupuestal, '') IS NOT NULL
AND NULLIF(RTRIM(a.ClavePresupuestalImpuesto1), '') IS NOT NULL
END ELSE
IF @Modulo = 'GAS'
BEGIN
INSERT CPCalMovPreAyuda (
Estacion,  ClavePresupuestal,   Importe)
SELECT @Estacion, t.ClavePresupuestal, t.TotalLinea+ISNULL(t.RetencionLinea, 0)
FROM GastoT t
JOIN Concepto c ON c.Modulo = @Modulo AND c.Concepto = t.Concepto
WHERE t.ID = @ID AND NULLIF(t.ClavePresupuestal, '') IS NOT NULL
AND NULLIF(RTRIM(c.ClavePresupuestalImpuesto1), '') IS NULL
INSERT CPCalMovPreAyuda (
Estacion,  ClavePresupuestal,   Importe)
SELECT @Estacion, t.ClavePresupuestal, t.ImporteLinea
FROM GastoT t
JOIN Concepto c ON c.Modulo = @Modulo AND c.Concepto = t.Concepto
WHERE t.ID = @ID AND NULLIF(t.ClavePresupuestal, '') IS NOT NULL
AND NULLIF(RTRIM(c.ClavePresupuestalImpuesto1), '') IS NOT NULL
INSERT CPCalMovPreAyuda (
Estacion,  ClavePresupuestal,            Importe)
SELECT @Estacion, c.ClavePresupuestalImpuesto1, t.ImpuestosLinea
FROM GastoT t
JOIN Concepto c ON c.Modulo = @Modulo AND c.Concepto = t.Concepto
WHERE t.ID = @ID AND NULLIF(t.ClavePresupuestal, '') IS NOT NULL
AND NULLIF(RTRIM(c.ClavePresupuestalImpuesto1), '') IS NOT NULL
END ELSE
IF @Modulo = 'CXP'
BEGIN
/* para sacar el saldo hay que sacar un factor del saldo de cxpa contra el importe */
SELECT @Empresa = Empresa
FROM Cxp
WHERE ID = @ID
INSERT CPCalMovPreAyuda (
Estacion,  ClavePresupuestal,    Importe)
SELECT @Estacion, mi.ClavePresupuestal, ISNULL(mi.SubTotal, 0.0)+ISNULL(mi.Importe1, 0.0)
FROM CxpD d
JOIN Cxp a ON a.Empresa = @Empresa AND a.Mov = d.Aplica AND a.MovID = d.AplicaID AND a.Estatus IN ('PENDIENTE', 'CONCLUIDO')
JOIN MovImpuesto mi ON mi.Modulo = @Modulo AND mi.ModuloID = a.ID
WHERE d.ID = @ID AND NULLIF(mi.ClavePresupuestal, '') IS NOT NULL AND NULLIF(mi.ClavePresupuestalImpuesto1, '') IS NULL
INSERT CPCalMovPreAyuda (
Estacion,  ClavePresupuestal,    Importe)
SELECT @Estacion, mi.ClavePresupuestal, ISNULL(mi.SubTotal, 0.0)
FROM CxpD d
JOIN Cxp a ON a.Empresa = @Empresa AND a.Mov = d.Aplica AND a.MovID = d.AplicaID AND a.Estatus IN ('PENDIENTE', 'CONCLUIDO')
JOIN MovImpuesto mi ON mi.Modulo = @Modulo AND mi.ModuloID = a.ID
WHERE d.ID = @ID AND NULLIF(mi.ClavePresupuestal, '') IS NOT NULL AND NULLIF(mi.ClavePresupuestalImpuesto1, '') IS NOT NULL
INSERT CPCalMovPreAyuda (
Estacion,  ClavePresupuestal,             Importe)
SELECT @Estacion, mi.ClavePresupuestalImpuesto1, ISNULL(mi.Importe1, 0.0)
FROM CxpD d
JOIN Cxp a ON a.Empresa = @Empresa AND a.Mov = d.Aplica AND a.MovID = d.AplicaID AND a.Estatus IN ('PENDIENTE', 'CONCLUIDO')
JOIN MovImpuesto mi ON mi.Modulo = @Modulo AND mi.ModuloID = a.ID
WHERE d.ID = @ID AND NULLIF(mi.ClavePresupuestalImpuesto1, '') IS NOT NULL
END
ELSE
IF @Modulo = 'DIN'
BEGIN
SELECT @Empresa = Empresa
FROM Dinero
WHERE ID = @ID
INSERT CPCalMovPreAyuda (
Estacion,  ClavePresupuestal,    Importe)
SELECT @Estacion, mi.ClavePresupuestal, ISNULL(mi.SubTotal, 0.0)+ISNULL(mi.Importe1, 0.0)
FROM DineroD d
JOIN Dinero a ON a.Empresa = @Empresa AND a.Mov = d.Aplica AND a.MovID = d.AplicaID AND a.Estatus IN ('PENDIENTE', 'CONCLUIDO')
JOIN MovImpuesto mi ON mi.Modulo = @Modulo AND mi.ModuloID = a.ID
WHERE d.ID = @ID AND NULLIF(mi.ClavePresupuestal, '') IS NOT NULL AND NULLIF(mi.ClavePresupuestalImpuesto1, '') IS NULL
INSERT CPCalMovPreAyuda (
Estacion,  ClavePresupuestal,    Importe)
SELECT @Estacion, mi.ClavePresupuestal, ISNULL(mi.SubTotal, 0.0)
FROM DineroD d
JOIN Dinero a ON a.Empresa = @Empresa AND a.Mov = d.Aplica AND a.MovID = d.AplicaID AND a.Estatus IN ('PENDIENTE', 'CONCLUIDO')
JOIN MovImpuesto mi ON mi.Modulo = @Modulo AND mi.ModuloID = a.ID
WHERE d.ID = @ID AND NULLIF(mi.ClavePresupuestal, '') IS NOT NULL AND NULLIF(mi.ClavePresupuestalImpuesto1, '') IS NOT NULL
INSERT CPCalMovPreAyuda (
Estacion,  ClavePresupuestal,             Importe)
SELECT @Estacion, mi.ClavePresupuestalImpuesto1, ISNULL(mi.Importe1, 0.0)
FROM DineroD d
JOIN Dinero a ON a.Empresa = @Empresa AND a.Mov = d.Aplica AND a.MovID = d.AplicaID AND a.Estatus IN ('PENDIENTE', 'CONCLUIDO')
JOIN MovImpuesto mi ON mi.Modulo = @Modulo AND mi.ModuloID = a.ID
WHERE d.ID = @ID AND NULLIF(mi.ClavePresupuestalImpuesto1, '') IS NOT NULL
END
RETURN
END

