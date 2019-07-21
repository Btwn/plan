SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gCxpD
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
Ligado,
Sucursal,
LigadoDR,
Logico1,
DescuentoRecargos,
InteresesOrdinarios,
InteresesOrdinariosQuita,
InteresesMoratorios,
InteresesMoratoriosQuita,
Retencion,
SucursalOrigen,
InteresesOrdinariosIVA,
InteresesOrdinariosTasaDia,
InteresesOrdinariosTasaRealDia,
InteresesMoratoriosIVA,
InteresesMoratoriosTasaDia,
InteresesMoratoriosTasaRealDia,
InteresesOrdinariosIVADescInfl
FROM CxpD
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
Ligado,
Sucursal,
LigadoDR,
Logico1,
DescuentoRecargos,
InteresesOrdinarios,
InteresesOrdinariosQuita,
InteresesMoratorios,
InteresesMoratoriosQuita,
Retencion,
SucursalOrigen,
InteresesOrdinariosIVA,
InteresesOrdinariosTasaDia,
InteresesOrdinariosTasaRealDia,
InteresesMoratoriosIVA,
InteresesMoratoriosTasaDia,
InteresesMoratoriosTasaRealDia,
InteresesOrdinariosIVADescInfl
FROM hCxpD
;

