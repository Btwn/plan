SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW cPCPD

AS
SELECT
ID,
Renglon,
CatalogoTipoTipo,
CatalogoTipoRama,
CatalogoTipoDigitos,
CatalogoTipoEsAcumulativa,
CatalogoTipoValidacion,
CatalogoTipoTechoPresupuesto,
ClavePresupuestal,
ClavePresupuestalNombre,
ClavePresupuestalDescripcion,
ClavePresupuestalArticulosEsp,
ClavePresupuestalNombreA,
ClavePresupuestalDescripcionA,
ClavePresupuestalArticulosEspA,
ClavePresupuestalCat1,
ClavePresupuestalCat2,
ClavePresupuestalCat3,
ClavePresupuestalCat4,
ClavePresupuestalCat5,
ClavePresupuestalCat6,
ClavePresupuestalCat7,
ClavePresupuestalCat8,
ClavePresupuestalCat9,
ClavePresupuestalCatA,
ClavePresupuestalCatB,
ClavePresupuestalCatC,
CatalogoClave,
CatalogoTipo,
CatalogoRamaTipo,
CatalogoNombre,
CatalogoTechoPresupuesto,
CatalogoDescripcion,
CatalogoObservaciones,
CatalogoNombreAnterior,
CatalogoDescripcionAnterior,
CatalogoObservacionesAnterior,
CatalogoRID,
ReglaOrden,
ReglaMascara,
ReglaTipo,
ReglaID,
ReglaDescripcion,
ReglaOrdenAnt,
ReglaMascaraAnt,
ReglaTipoAnt,
ReglaDescripcionAnt,
Sucursal,
SucursalOrigen,
Aplica,
AplicaID,
CatalogoTechoPresupuestoAnt,
CatalogoRama,
Observaciones,
ObjetoGasto, 
ObjetoGastoAnt 
FROM
PCPD

