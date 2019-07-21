SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW PCPPendiente

AS
SELECT
p.ID,
p.Empresa,
p.Sucursal,
ISNULL(p.Mov,'') + ' ' + ISNULL(p.MovID,'') Movimiento,
p.Mov,
p.MovID,
p.FechaEmision,
p.UEN,
p.Concepto,
p.Proyecto,
p.Usuario,
p.Estatus,
p.Moneda,
p.TipoCambio,
p.OrigenTipo,
p.Origen,
p.OrigenID,
p.ClavePresupuestalMascara,
p.Categoria,
p.Tipo,
p.Ejercicio,
p.Periodo,
mt.Clave MovTipo
FROM PCP p JOIN MovTipo mt
ON mt.Mov = p.Mov AND mt.Modulo = 'PCP'
WHERE p.Estatus IN ('PENDIENTE','VIGENTE')

