SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW NominaInfo

AS
SELECT e.ID, e.Empresa, e.Mov, e.MovID, e.FechaEmision, e.Concepto, e.Condicion, e.Estatus, e.Situacion, e.SituacionFecha, e.SituacionUsuario, e.SituacionNota, d.Renglon, d.Personal, d.Cantidad, d.Importe, d.CantidadPendiente, d.Monto, d.Porcentaje, d.FechaD, d.FechaA, d.Saldo, 'ConceptoDetalle'=d.Concepto, d.Referencia
FROM Nomina e WITH(NOLOCK)
JOIN NominaD d WITH(NOLOCK) ON e.ID=d.ID
WHERE e.Estatus in ('VIGENTE', 'PROCESAR', 'PENDIENTE') and d.Activo=1

