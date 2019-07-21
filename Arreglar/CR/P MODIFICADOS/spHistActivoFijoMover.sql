SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spHistActivoFijoMover
@ID     int,
@Ok     int          OUTPUT,
@OkRef  varchar(255) OUTPUT

AS BEGIN
INSERT hActivoFijo
(ID, Empresa, Mov, MovID, FechaEmision, UltimoCambio, Proyecto, UEN, Usuario, Autorizacion, Concepto, Referencia, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Moneda, TipoCambio, Condicion, Vencimiento, Proveedor, Importe, Impuestos, FormaPago, CtaDinero, Todo, Revaluar, ValorMercado, OrigenTipo, Origen, OrigenID, Poliza, PolizaID, GenerarPoliza, ContID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, Sucursal, Personal, Espacio, ContUso, Logico1, Logico2, Logico3, Logico4, Logico5, Logico6, Logico7, Logico8, Logico9, SucursalOrigen, SucursalDestino, ContUso2, ContUso3)
SELECT ID, Empresa, Mov, MovID, FechaEmision, UltimoCambio, Proyecto, UEN, Usuario, Autorizacion, Concepto, Referencia, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Moneda, TipoCambio, Condicion, Vencimiento, Proveedor, Importe, Impuestos, FormaPago, CtaDinero, Todo, Revaluar, ValorMercado, OrigenTipo, Origen, OrigenID, Poliza, PolizaID, GenerarPoliza, ContID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, Sucursal, Personal, Espacio, ContUso, Logico1, Logico2, Logico3, Logico4, Logico5, Logico6, Logico7, Logico8, Logico9, SucursalOrigen, SucursalDestino, ContUso2, ContUso3
FROM ActivoFijo
WITH(NOLOCK) WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hActivoFijo'
DELETE ActivoFijo WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'ActivoFijo'
INSERT hActivoFijoD
(ID, Renglon, RenglonSub, Articulo, Serie, Importe, Impuestos, Horas, MesesDepreciados, Depreciacion, DepreciacionPorcentaje, NuevoValor, Inflacion, ActualizacionCapital, ActualizacionGastos, ActualizacionDepreciacion, Observaciones, ValorAnterior, DepreciacionAnterior, RevaluacionAnterior, ReparacionAnterior, MantenimientoAnterior, MantenimientoSiguienteAnterior, PolizaMantenimientoAnterior, PolizaSeguroAnterior, Sucursal, SucursalOrigen, UltimoKmServicio, UltimoTipoServicio, AumentoKmServicio, UnidadKm, AnteriorTipoServicio)
SELECT ID, Renglon, RenglonSub, Articulo, Serie, Importe, Impuestos, Horas, MesesDepreciados, Depreciacion, DepreciacionPorcentaje, NuevoValor, Inflacion, ActualizacionCapital, ActualizacionGastos, ActualizacionDepreciacion, Observaciones, ValorAnterior, DepreciacionAnterior, RevaluacionAnterior, ReparacionAnterior, MantenimientoAnterior, MantenimientoSiguienteAnterior, PolizaMantenimientoAnterior, PolizaSeguroAnterior, Sucursal, SucursalOrigen, UltimoKmServicio, UltimoTipoServicio, AumentoKmServicio, UnidadKm, AnteriorTipoServicio
FROM ActivoFijoD
WITH(NOLOCK) WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hActivoFijoD'
DELETE ActivoFijoD WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'ActivoFijoD'
INSERT hActivoFijoSugerir
(Estacion, ID, Categoria, Sugerir)
SELECT Estacion, ID, Categoria, Sugerir
FROM ActivoFijoSugerir WITH(NOLOCK)
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hActivoFijoSugerir'
DELETE ActivoFijoSugerir WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'ActivoFijoSugerir'
INSERT hAuxiliarActivoFijo
(ID, IDMov, Renglon, Empresa, Modulo, Articulo, Serie, Cantidad, ValorAdquisicion, ImporteMov, FactorCalculo, Total, FechaEmision, FechaInicioDepreciacion, Aplicar, Icono)
SELECT ID, IDMov, Renglon, Empresa, Modulo, Articulo, Serie, Cantidad, ValorAdquisicion, ImporteMov, FactorCalculo, Total, FechaEmision, FechaInicioDepreciacion, Aplicar, Icono
FROM AuxiliarActivoFijo WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hAuxiliarActivoFijo'
DELETE AuxiliarActivoFijo WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'AuxiliarActivoFijo'
RETURN
END
;

