SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gCxcD
 AS
SELECT
ID,
Renglon,
RenglonSub,
Importe,
Aplica,
AplicaID,
Fecha,
FechaAnterior,
Comision,
InteresesOrdinarios,
InteresesOrdinariosQuita,
InteresesMoratorios,
InteresesMoratoriosQuita,
ImpuestoAdicional,
OtrosCargos,
Retencion,
Ligado,
Sucursal,
LigadoDR,
EsReferencia,
Logico1,
DescuentoRecargos,
SucursalOrigen,
Retencion2,
Retencion3,
InteresesOrdinariosIVA,
InteresesOrdinariosTasaDia,
InteresesOrdinariosTasaRealDia,
InteresesMoratoriosIVA,
InteresesMoratoriosTasaDia,
InteresesMoratoriosTasaRealDia,
InteresesOrdinariosIVADescInfl
FROM CxcD WITH(NOLOCK)
UNION ALL
SELECT
ID,
Renglon,
RenglonSub,
Importe,
Aplica,
AplicaID,
Fecha,
FechaAnterior,
Comision,
InteresesOrdinarios,
InteresesOrdinariosQuita,
InteresesMoratorios,
InteresesMoratoriosQuita,
ImpuestoAdicional,
OtrosCargos,
Retencion,
Ligado,
Sucursal,
LigadoDR,
EsReferencia,
Logico1,
DescuentoRecargos,
SucursalOrigen,
Retencion2,
Retencion3,
InteresesOrdinariosIVA,
InteresesOrdinariosTasaDia,
InteresesOrdinariosTasaRealDia,
InteresesMoratoriosIVA,
InteresesMoratoriosTasaDia,
InteresesMoratoriosTasaRealDia,
InteresesOrdinariosIVADescInfl
FROM hCxcD WITH(NOLOCK)
;

