SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionXMLDetalle
@ID					int,
@Estacion			int,
@Empresa			varchar(5),
@Sucursal			int,
@Usuario			varchar(10),
@Proveedor			varchar(10),
@ConceptoSAT		varchar(2),
@IDMov	            varchar(20),
@Version			varchar(5),
@Vista				varchar(100),
@XML				varchar(max)	OUTPUT,
@XMLDetalle			varchar(max)	OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
DECLARE @AgruparConceptoSAT   bit
CREATE TABLE #CFDIRetencionImpuestoD(
Modulo			varchar(5)	COLLATE DATABASE_DEFAULT NOT NULL,
ModuloID		int			NOT NULL,
BaseRet			float		NULL,
Impuesto		varchar(2)	COLLATE DATABASE_DEFAULT NULL,
montoRet		float		NULL,
TipoPagoRet		varchar(20) COLLATE DATABASE_DEFAULT NULL,
)
SELECT @AgruparConceptoSAT = ISNULL(AgruparConceptoSATRetenciones,0) FROM EmpresaCfg2 WHERE Empresa = @Empresa
IF @AgruparConceptoSAT = 1
BEGIN
INSERT INTO #CFDIRetencionImpuestoD(
Modulo, ModuloID, BaseRet, Impuesto,                           montoRet,                                                                      TipoPagoRet)
SELECT 'CXP', @ID,        (SUM(GastoD.Importe) * (cfdiretsatretencion.RetmontoTotGrav/100)),       CFDIRetencionImpuestoTipo.ClaveSAT, CONVERT(varchar(max), CONVERT(money, SUM(NULLIF(ISNULL(GastoD.Retencion,0.0), 0)))), 'Pago definitivo'
FROM CFDIRetencion
JOIN CFDIRetencionImpuestoTipo ON CFDIRetencionImpuestoTipo.Retencion = 'ISR'
JOIN GastoD ON CFDIRetencion.ModuloID = GastoD.id
JOIN cfdiretsatretencion ON CFDIRetencion.ConceptoSAT = cfdiretsatretencion.Clave
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND ConceptoSAT = @ConceptoSAT
AND GastoD.Concepto in(Select Concepto From CFDIRetencionConcepto Where Modulo = 'GAS' AND CFDIRetClave = @ConceptoSAT)
AND Empresa = @Empresa
AND NULLIF(GastoD.Retencion, 0) IS NOT NULL
AND MovID = @IDMov
GROUP BY CFDIRetencionImpuestoTipo.ClaveSAT,CFDIRetencion.Importe, cfdiretsatretencion.RetmontoTotGrav
INSERT INTO #CFDIRetencionImpuestoD(
Modulo, ModuloID, BaseRet, Impuesto,                           montoRet,                                                                      TipoPagoRet)
SELECT 'CXP', @ID,        (SUM(GastoD.Importe) * (cfdiretsatretencion.RetmontoTotGrav/100)),       CFDIRetencionImpuestoTipo.ClaveSAT, CONVERT(varchar(max), CONVERT(money, SUM(NULLIF(ISNULL(GastoD.Retencion2,0.0), 0)))), 'Pago definitivo'
FROM CFDIRetencion
JOIN CFDIRetencionImpuestoTipo ON CFDIRetencionImpuestoTipo.Retencion = 'IVA'
JOIN GastoD ON CFDIRetencion.ModuloID = GastoD.id
JOIN cfdiretsatretencion ON CFDIRetencion.ConceptoSAT = cfdiretsatretencion.Clave
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND ConceptoSAT = @ConceptoSAT
AND GastoD.Concepto in(Select Concepto From CFDIRetencionConcepto Where Modulo = 'GAS' AND CFDIRetClave = @ConceptoSAT)
AND Empresa = @Empresa
AND NULLIF(GastoD.Retencion2, 0) IS NOT NULL
AND MovID = @IDMov
GROUP BY CFDIRetencionImpuestoTipo.ClaveSAT,CFDIRetencion.Importe, cfdiretsatretencion.RetmontoTotGrav
INSERT INTO #CFDIRetencionImpuestoD(
Modulo, ModuloID, BaseRet, Impuesto,                           montoRet,                                                                TipoPagoRet)
SELECT 'CXP', @ID,        (SUM(GastoD.Importe) * (cfdiretsatretencion.RetmontoTotGrav/100)),       CFDIRetencionImpuestoTipo.ClaveSAT, CONVERT(varchar(max), CONVERT(money, SUM(NULLIF(ISNULL(GastoD.Retencion3,0.0), 0)))), 'Pago definitivo'
FROM CFDIRetencion
JOIN CFDIRetencionImpuestoTipo ON CFDIRetencionImpuestoTipo.Retencion = 'IEPS'
JOIN GastoD ON CFDIRetencion.ModuloID = GastoD.id
JOIN cfdiretsatretencion ON CFDIRetencion.ConceptoSAT = cfdiretsatretencion.Clave
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND ConceptoSAT = @ConceptoSAT
AND GastoD.Concepto in(Select Concepto From CFDIRetencionConcepto Where Modulo = 'GAS' AND CFDIRetClave = @ConceptoSAT)
AND Empresa = @Empresa
AND NULLIF(GastoD.Retencion3, 0) IS NOT NULL
AND MovID = @IDMov
GROUP BY CFDIRetencionImpuestoTipo.ClaveSAT,CFDIRetencion.Importe, cfdiretsatretencion.RetmontoTotGrav
END
ELSE
BEGIN
INSERT INTO #CFDIRetencionImpuestoD(
Modulo, ModuloID, BaseRet, Impuesto,                           montoRet,                                                                      TipoPagoRet)
SELECT 'CXP', @ID,        (SUM(GastoD.Importe) * (cfdiretsatretencion.RetmontoTotGrav/100)),       CFDIRetencionImpuestoTipo.ClaveSAT, CONVERT(varchar(max), CONVERT(money, SUM(NULLIF(ISNULL(GastoD.Retencion,0.0), 0)))), 'Pago definitivo'
FROM CFDIRetencion
JOIN CFDIRetencionImpuestoTipo ON CFDIRetencionImpuestoTipo.Retencion = 'ISR'
JOIN GastoD ON CFDIRetencion.ModuloID = GastoD.id
JOIN cfdiretsatretencion ON CFDIRetencion.ConceptoSAT = cfdiretsatretencion.Clave
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND ConceptoSAT = @ConceptoSAT
AND GastoD.Concepto in(Select Concepto From CFDIRetencionConcepto Where Modulo = 'GAS' AND CFDIRetClave = @ConceptoSAT)
AND Empresa = @Empresa
AND NULLIF(GastoD.Retencion, 0) IS NOT NULL
GROUP BY CFDIRetencionImpuestoTipo.ClaveSAT,CFDIRetencion.Importe, cfdiretsatretencion.RetmontoTotGrav
INSERT INTO #CFDIRetencionImpuestoD(
Modulo, ModuloID, BaseRet, Impuesto,                           montoRet,                                                                      TipoPagoRet)
SELECT 'CXP', @ID,        (SUM(GastoD.Importe) * (cfdiretsatretencion.RetmontoTotGrav/100)),       CFDIRetencionImpuestoTipo.ClaveSAT, CONVERT(varchar(max), CONVERT(money, SUM(NULLIF(ISNULL(GastoD.Retencion2,0.0), 0)))), 'Pago definitivo'
FROM CFDIRetencion
JOIN CFDIRetencionImpuestoTipo ON CFDIRetencionImpuestoTipo.Retencion = 'IVA'
JOIN GastoD ON CFDIRetencion.ModuloID = GastoD.id
JOIN cfdiretsatretencion ON CFDIRetencion.ConceptoSAT = cfdiretsatretencion.Clave
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND ConceptoSAT = @ConceptoSAT
AND GastoD.Concepto in(Select Concepto From CFDIRetencionConcepto Where Modulo = 'GAS' AND CFDIRetClave = @ConceptoSAT)
AND Empresa = @Empresa
AND NULLIF(GastoD.Retencion2, 0) IS NOT NULL
GROUP BY CFDIRetencionImpuestoTipo.ClaveSAT,CFDIRetencion.Importe, cfdiretsatretencion.RetmontoTotGrav
INSERT INTO #CFDIRetencionImpuestoD(
Modulo, ModuloID, BaseRet, Impuesto,                           montoRet,                                                                TipoPagoRet)
SELECT 'CXP', @ID,        (SUM(GastoD.Importe) * (cfdiretsatretencion.RetmontoTotGrav/100)),       CFDIRetencionImpuestoTipo.ClaveSAT, CONVERT(varchar(max), CONVERT(money, SUM(NULLIF(ISNULL(GastoD.Retencion3,0.0), 0)))), 'Pago definitivo'
FROM CFDIRetencion
JOIN CFDIRetencionImpuestoTipo ON CFDIRetencionImpuestoTipo.Retencion = 'IEPS'
JOIN GastoD ON CFDIRetencion.ModuloID = GastoD.id
JOIN cfdiretsatretencion ON CFDIRetencion.ConceptoSAT = cfdiretsatretencion.Clave
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND ConceptoSAT = @ConceptoSAT
AND GastoD.Concepto in(Select Concepto From CFDIRetencionConcepto Where Modulo = 'GAS' AND CFDIRetClave = @ConceptoSAT)
AND Empresa = @Empresa
AND NULLIF(GastoD.Retencion3, 0) IS NOT NULL
GROUP BY CFDIRetencionImpuestoTipo.ClaveSAT,CFDIRetencion.Importe, cfdiretsatretencion.RetmontoTotGrav
END
INSERT INTO CFDIRetencionImpuestoD(
Modulo, ModuloID, BaseRet,      Impuesto, montoRet,      TipoPagoRet)
SELECT Modulo, ModuloID, SUM(BaseRet), Impuesto, SUM(montoRet), TipoPagoRet
FROM #CFDIRetencionImpuestoD
GROUP BY Modulo, ModuloID, Impuesto, TipoPagoRet
SELECT @XMLDetalle = (SELECT ISNULL(CONVERT(varchar(max), CONVERT(money, SUM(NULLIF(ISNULL(BaseRet,0.0), 0)))),0.00) 'BaseRet',
Impuesto,
ISNULL(CONVERT(varchar(max), CONVERT(money, SUM(NULLIF(ISNULL(montoRet,0.0), 0)))),0.00) 'montoRet',
TipoPagoRet
FROM CFDIRetencionImpuestoD
WHERE ModuloID = @ID
AND Modulo = 'CXP'
GROUP BY Impuesto, TipoPagoRet
FOR XML RAW('ImpRetenidos'))
SELECT @XMLDetalle = REPLACE(@XMLDetalle, '<ImpRetenidos', '<retenciones:ImpRetenidos')
SELECT @XML = REPLACE(@XML, '@Detalle', ISNULL(@XMLDetalle, ''))
RETURN
END

