SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spHistConciliacionMover
@ID     int,
@Ok     int          OUTPUT,
@OkRef  varchar(255) OUTPUT

AS BEGIN
INSERT hConciliacion
(ID, Empresa, Mov, MovID, FechaEmision, UltimoCambio, Concepto, Proyecto, UEN, Usuario, Autorizacion, Referencia, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, OrigenTipo, Origen, OrigenID, Poliza, PolizaID, GenerarPoliza, ContID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, Sucursal, Moneda, TipoCambio, CtaDinero, FechaD, FechaA, SaldoBanco, SaldoConciliado, SaldoLibros, SucursalOrigen, SucursalDestino)
SELECT ID, Empresa, Mov, MovID, FechaEmision, UltimoCambio, Concepto, Proyecto, UEN, Usuario, Autorizacion, Referencia, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, OrigenTipo, Origen, OrigenID, Poliza, PolizaID, GenerarPoliza, ContID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, Sucursal, Moneda, TipoCambio, CtaDinero, FechaD, FechaA, SaldoBanco, SaldoConciliado, SaldoLibros, SucursalOrigen, SucursalDestino
FROM Conciliacion
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hConciliacion'
DELETE Conciliacion WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'Conciliacion'
INSERT hConciliacionCompensacion
(ID, RID, ConciliacionD, Manual, Sucursal, SucursalOrigen)
SELECT ID, RID, ConciliacionD, Manual, Sucursal, SucursalOrigen
FROM ConciliacionCompensacion
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hConciliacionCompensacion'
DELETE ConciliacionCompensacion WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'ConciliacionCompensacion'
INSERT hConciliacionD
(ID, RID, Fecha, Concepto, Referencia, Cargo, Abono, Observaciones, Manual, TipoMovimiento, Auxiliar, ContD, ConceptoGasto, Acreedor, ObligacionFiscal, Seccion, Sucursal, SucursalOrigen, Tasa, TipoImporte, ObligacionFiscal2)
SELECT ID, RID, Fecha, Concepto, Referencia, Cargo, Abono, Observaciones, Manual, TipoMovimiento, Auxiliar, ContD, ConceptoGasto, Acreedor, ObligacionFiscal, Seccion, Sucursal, SucursalOrigen, Tasa, TipoImporte, ObligacionFiscal2
FROM ConciliacionD
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hConciliacionD'
DELETE ConciliacionD WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'ConciliacionD'
RETURN
END
;

