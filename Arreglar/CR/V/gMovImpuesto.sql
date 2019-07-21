SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gMovImpuesto
 AS
SELECT
Modulo,
ModuloID,
ID,
Impuesto1,
Impuesto2,
Impuesto3,
Importe1,
Importe2,
Importe3,
SubTotal,
LoteFijo,
Retencion1,
Retencion2,
Retencion3,
Excento1,
Excento2,
Excento3,
OrigenModulo,
OrigenModuloID,
OrigenConcepto,
OrigenDeducible,
OrigenFecha,
SubFolio,
ContUso,
ContUso2,
ContUso3,
ClavePresupuestal,
ClavePresupuestalImpuesto1,
DescuentoGlobal,
ImporteBruto,
TipoImpuesto1,
TipoImpuesto2,
TipoImpuesto3,
TipoRetencion1,
TipoRetencion2,
TipoRetencion3,
Impuesto5,
Importe5,
TipoImpuesto5,
AplicaModulo,
AplicaID
FROM MovImpuesto
UNION ALL
SELECT
Modulo,
ModuloID,
ID,
Impuesto1,
Impuesto2,
Impuesto3,
Importe1,
Importe2,
Importe3,
SubTotal,
LoteFijo,
Retencion1,
Retencion2,
Retencion3,
Excento1,
Excento2,
Excento3,
OrigenModulo,
OrigenModuloID,
OrigenConcepto,
OrigenDeducible,
OrigenFecha,
SubFolio,
ContUso,
ContUso2,
ContUso3,
ClavePresupuestal,
ClavePresupuestalImpuesto1,
DescuentoGlobal,
ImporteBruto,
TipoImpuesto1,
TipoImpuesto2,
TipoImpuesto3,
TipoRetencion1,
TipoRetencion2,
TipoRetencion3,
Impuesto5,
Importe5,
TipoImpuesto5,
AplicaModulo,
AplicaID
FROM hMovImpuesto
;

