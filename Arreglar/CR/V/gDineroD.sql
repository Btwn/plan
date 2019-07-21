SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gDineroD
 AS
SELECT
ID,
Renglon,
RenglonSub,
Importe,
FormaPago,
Referencia,
Aplica,
AplicaID,
Sucursal,
ContUso,
Institucion,
SucursalOrigen,
BeneficiarioNombre,
CtaBeneficiario,
NumeroCheque,
RFCReceptor,
ContUso2,
ContUso3,
CtaDinero,
Moneda,
CtaDineroDestino,
TipoCambio
FROM DineroD
UNION ALL
SELECT
ID,
Renglon,
RenglonSub,
Importe,
FormaPago,
Referencia,
Aplica,
AplicaID,
Sucursal,
ContUso,
Institucion,
SucursalOrigen,
BeneficiarioNombre,
CtaBeneficiario,
NumeroCheque,
RFCReceptor,
ContUso2,
ContUso3,
CtaDinero,
Moneda,
CtaDineroDestino,
TipoCambio
FROM hDineroD
;

