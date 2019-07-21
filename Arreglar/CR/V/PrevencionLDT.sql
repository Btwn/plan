SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW PrevencionLDT
AS
SELECT        a.ID, a.Empresa, a.Mov, a.MovID, a.FechaEmision, a.UltimoCambio, a.Concepto, a.Proyecto, a.UEN, a.Moneda, a.TipoCambio, a.Usuario, a.Autorizacion,
a.Referencia, a.DocFuente, a.Observaciones, a.Estatus, a.Situacion, a.SituacionFecha, a.SituacionUsuario, a.SituacionNota, a.OrigenTipo, a.Origen,
a.OrigenID, a.Ejercicio, a.Periodo, a.FechaRegistro, a.FechaConclusion, a.FechaCancelacion, a.Sucursal, a.SucursalOrigen, a.SucursalDestino, a.ContID,
a.Poliza, a.PolizaID, a.GenerarPoliza, a.Vencimiento, a.Acreedor, a.Condicion, a.Cliente, a.Almacen, a.ActEconomica, b.Renglon, b.OrigenModulo,
b.OrigenModuloID, b.Aplica, b.AplicaId, b.Importe, b.ActEconimica, b.SaldoActual, b.SaldoAnterior, b.Variacion, b.Contacto, b.ContactoTipo,a.FechaPoliza,a.GenerarDinero
FROM            PrevencionLD AS a INNER JOIN
PrevencionLDD AS b ON a.ID = b.ID

