SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ProyectoDSolicitudPendiente
AS
SELECT
mf.Empresa Empresa,
mf.OID ProyectoID,
mf.OMov ProyectoMov,
mf.OMovID ProyectoMovID,
i.ID SolicitudID,
i.Mov SolicitudMov,
i.MovID SolicitudMovID,
i.Proyecto Proyecto,
i.Actividad Actividad,
i.Estatus Estatus
FROM MovFlujo mf JOIN Inv i
ON i.ID = mf.DID JOIN MovTipo mt
ON mt.Mov = i.Mov AND mt.Modulo = 'INV' JOIN EmpresaCfgMov ecm
ON ecm.InvSolicitud = mt.Mov AND mf.Empresa = ecm.Empresa
WHERE mf.DModulo = 'INV'
AND mf.OModulo = 'PROY'
AND i.Estatus IN ('PENDIENTE','CONCLUIDO')
AND mt.Clave = 'INV.SOL'

