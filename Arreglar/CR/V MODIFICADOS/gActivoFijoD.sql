SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gActivoFijoD
 AS
SELECT
ID,
Renglon,
RenglonSub,
Articulo,
Serie,
Importe,
Impuestos,
Horas,
MesesDepreciados,
Depreciacion,
DepreciacionPorcentaje,
NuevoValor,
Inflacion,
ActualizacionCapital,
ActualizacionGastos,
ActualizacionDepreciacion,
Observaciones,
ValorAnterior,
DepreciacionAnterior,
RevaluacionAnterior,
ReparacionAnterior,
MantenimientoAnterior,
MantenimientoSiguienteAnterior,
PolizaMantenimientoAnterior,
PolizaSeguroAnterior,
Sucursal,
SucursalOrigen,
UltimoKmServicio,
UltimoTipoServicio,
AumentoKmServicio,
UnidadKm,
AnteriorTipoServicio
FROM ActivoFijoD WITH(NOLOCK)
UNION ALL
SELECT
ID,
Renglon,
RenglonSub,
Articulo,
Serie,
Importe,
Impuestos,
Horas,
MesesDepreciados,
Depreciacion,
DepreciacionPorcentaje,
NuevoValor,
Inflacion,
ActualizacionCapital,
ActualizacionGastos,
ActualizacionDepreciacion,
Observaciones,
ValorAnterior,
DepreciacionAnterior,
RevaluacionAnterior,
ReparacionAnterior,
MantenimientoAnterior,
MantenimientoSiguienteAnterior,
PolizaMantenimientoAnterior,
PolizaSeguroAnterior,
Sucursal,
SucursalOrigen,
UltimoKmServicio,
UltimoTipoServicio,
AumentoKmServicio,
UnidadKm,
AnteriorTipoServicio
FROM hActivoFijoD WITH(NOLOCK)
;

