SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spHistMovMover
@ID     int,
@Modulo varchar(5),
@Ok     int          OUTPUT,
@OkRef  varchar(255) OUTPUT

AS BEGIN
INSERT hMov
(Empresa, Modulo, ID, Mov, MovID, Ejercicio, Periodo, FechaRegistro, FechaEmision, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Autorizacion, Referencia, DocFuente, Observaciones, Poliza, PolizaID, ContID, Sucursal, Turno, Fuera, Integradora)
SELECT Empresa, Modulo, ID, Mov, MovID, Ejercicio, Periodo, FechaRegistro, FechaEmision, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Autorizacion, Referencia, DocFuente, Observaciones, Poliza, PolizaID, ContID, Sucursal, Turno, Fuera, Integradora
FROM Mov WITH(NOLOCK)
WHERE  ID = @ID AND Modulo = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hMov'
DELETE Mov WHERE ID = @ID AND Modulo = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'Mov'
INSERT hMovBitacora
(Modulo, ID, RID, Fecha, Evento, Tipo, Sucursal, Usuario, MovEstatus, MovSituacion, MovSituacionFecha, MovSituacionUsuario, MovSituacionNota, Duracion, DuracionUnidad, Agente, Clave, Importe, ObsReanalisis, TipoRespuesta, CitaCliente, CitaAval, horaCita, FechaCita)
SELECT Modulo, ID, RID, Fecha, Evento, Tipo, Sucursal, Usuario, MovEstatus, MovSituacion, MovSituacionFecha, MovSituacionUsuario, MovSituacionNota, Duracion, DuracionUnidad, Agente, Clave, Importe, ObsReanalisis, TipoRespuesta, CitaCliente, CitaAval, horaCita, FechaCita
FROM MovBitacora WITH(NOLOCK)
WHERE  ID = @ID AND Modulo = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hMovBitacora'
DELETE MovBitacora WHERE ID = @ID AND Modulo = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'MovBitacora'
INSERT hMovDReg
(Modulo, ID, Renglon, RenglonSub, RenglonID, RenglonTipo, UEN, Concepto, Personal, Almacen, Codigo, Articulo, SubCuenta, Cantidad, Unidad, Factor, CantidadInventario, Costo, CostoInv, CostoActividad, Precio, DescuentoTipo, DescuentoLinea, DescuentoImporte, Impuesto1, Impuesto2, Impuesto3, Retencion1, Retencion2, Retencion3, DescripcionExtra, Paquete, ContUso, Comision, Aplica, AplicaID, DestinoTipo, Destino, DestinoID, Cliente, Agente, Departamento, Espacio, Estado, AFArticulo, AFSerie, CostoUEPS, CostoPEPS, UltimoCosto, PrecioLista, Posicion, DepartamentoDetallista, SerieLote, Producto, SubProducto, Merma, Desperdicio, Tipo, Ruta, Fecha, Importe, Porcentaje, Impuestos, Provision, Depreciacion, DescuentoRecargos, InteresesOrdinarios, InteresesMoratorios, FormaPago, Referencia, Proyecto, Actividad, Cuenta, CtoTipo, Contacto, ObligacionFiscal, Tasa, ABC)
SELECT Modulo, ID, Renglon, RenglonSub, RenglonID, RenglonTipo, UEN, Concepto, Personal, Almacen, Codigo, Articulo, SubCuenta, Cantidad, Unidad, Factor, CantidadInventario, Costo, CostoInv, CostoActividad, Precio, DescuentoTipo, DescuentoLinea, DescuentoImporte, Impuesto1, Impuesto2, Impuesto3, Retencion1, Retencion2, Retencion3, DescripcionExtra, Paquete, ContUso, Comision, Aplica, AplicaID, DestinoTipo, Destino, DestinoID, Cliente, Agente, Departamento, Espacio, Estado, AFArticulo, AFSerie, CostoUEPS, CostoPEPS, UltimoCosto, PrecioLista, Posicion, DepartamentoDetallista, SerieLote, Producto, SubProducto, Merma, Desperdicio, Tipo, Ruta, Fecha, Importe, Porcentaje, Impuestos, Provision, Depreciacion, DescuentoRecargos, InteresesOrdinarios, InteresesMoratorios, FormaPago, Referencia, Proyecto, Actividad, Cuenta, CtoTipo, Contacto, ObligacionFiscal, Tasa, ABC
FROM MovDReg
WITH(NOLOCK) WHERE ID = @ID AND Modulo = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hMovDReg'
DELETE MovDReg WHERE ID = @ID AND Modulo = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'MovDReg'
INSERT hMovEstatusLog
(Modulo, ModuloID, ID, Usuario, Estatus, Fecha, Sucursal)
SELECT Modulo, ModuloID, ID, Usuario, Estatus, Fecha, Sucursal
FROM MovEstatusLog WITH(NOLOCK)
WHERE  ModuloID = @ID AND Modulo = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hMovEstatusLog'
DELETE MovEstatusLog WHERE ModuloID = @ID AND Modulo = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'MovEstatusLog'
INSERT hMovGastoIndirecto
(Modulo, ModuloID, ID, Concepto, Porcentaje)
SELECT Modulo, ModuloID, ID, Concepto, Porcentaje
FROM MovGastoIndirecto WITH(NOLOCK)
WHERE  ModuloID = @ID AND Modulo = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hMovGastoIndirecto'
DELETE MovGastoIndirecto WHERE ModuloID = @ID AND Modulo = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'MovGastoIndirecto'
INSERT hMovImpuesto
(Modulo, ModuloID, ID, Impuesto1, Impuesto2, Impuesto3, Importe1, Importe2, Importe3, SubTotal, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenDeducible, OrigenFecha, SubFolio, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal, ImporteBruto, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, Impuesto5, Importe5, TipoImpuesto5, AplicaModulo, AplicaID)
SELECT Modulo, ModuloID, ID, Impuesto1, Impuesto2, Impuesto3, Importe1, Importe2, Importe3, SubTotal, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenDeducible, OrigenFecha, SubFolio, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal, ImporteBruto, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, Impuesto5, Importe5, TipoImpuesto5, AplicaModulo, AplicaID
FROM MovImpuesto
WITH(NOLOCK) WHERE ModuloID = @ID AND Modulo = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hMovImpuesto'
DELETE MovImpuesto WHERE ModuloID = @ID AND Modulo = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'MovImpuesto'
INSERT hMovPersonal
(Modulo, ModuloID, ID, Personal, Fecha, Horas, Cantidad)
SELECT Modulo, ModuloID, ID, Personal, Fecha, Horas, Cantidad
FROM MovPersonal WITH(NOLOCK)
WHERE  ModuloID = @ID AND Modulo = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hMovPersonal'
DELETE MovPersonal WHERE ModuloID = @ID AND Modulo = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'MovPersonal'
INSERT hMovPresupuesto
(Modulo, ModuloID, ID, CuentaPresupuesto, Importe)
SELECT Modulo, ModuloID, ID, CuentaPresupuesto, Importe
FROM MovPresupuesto WITH(NOLOCK)
WHERE  ModuloID = @ID AND Modulo = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hMovPresupuesto'
DELETE MovPresupuesto WHERE ModuloID = @ID AND Modulo = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'MovPresupuesto'
INSERT hMovRecibo
(Modulo, ModuloID, ID, CB, Articulo, SubCuenta, Cantidad, Unidad, Costo, Lote, Caducidad)
SELECT Modulo, ModuloID, ID, CB, Articulo, SubCuenta, Cantidad, Unidad, Costo, Lote, Caducidad
FROM MovRecibo WITH(NOLOCK)
WHERE  ModuloID = @ID AND Modulo = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hMovRecibo'
DELETE MovRecibo WHERE ModuloID = @ID AND Modulo = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'MovRecibo'
INSERT hMovReg
(Modulo, ID, Mov, MovID, Estatus, Sucursal, UEN, FechaEmision, Empresa, CtoTipo, Contacto, EnviarA, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Proyecto, Concepto, Referencia, Usuario, MovTipo, Ejercicio, Periodo, FechaCancelacion, Clase, SubClase, Causa, FormaEnvio, Condicion, ZonaImpuesto, CtaDinero, Cajero, Moneda, TipoCambio, Deudor, Acreedor, Personal, Agente)
SELECT Modulo, ID, Mov, MovID, Estatus, Sucursal, UEN, FechaEmision, Empresa, CtoTipo, Contacto, EnviarA, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Proyecto, Concepto, Referencia, Usuario, MovTipo, Ejercicio, Periodo, FechaCancelacion, Clase, SubClase, Causa, FormaEnvio, Condicion, ZonaImpuesto, CtaDinero, Cajero, Moneda, TipoCambio, Deudor, Acreedor, Personal, Agente
FROM MovReg
WITH(NOLOCK) WHERE ID = @ID AND Modulo = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hMovReg'
DELETE MovReg WHERE ID = @ID AND Modulo = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'MovReg'
INSERT hMovTarea
(Modulo, ID, RenglonID, Tarea, Problema, Solucion, Estado, Fecha, Responsable, FechaEstimada, FechaConclusion, Sucursal, Usuario, Tiempo, Logico1, Logico2, Logico3, Orden, Comentarios, SucursalOrigen)
SELECT Modulo, ID, RenglonID, Tarea, Problema, Solucion, Estado, Fecha, Responsable, FechaEstimada, FechaConclusion, Sucursal, Usuario, Tiempo, Logico1, Logico2, Logico3, Orden, Comentarios, SucursalOrigen
FROM MovTarea WITH(NOLOCK)
WHERE ID = @ID AND Modulo = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hMovTarea'
DELETE MovTarea WHERE ID = @ID AND Modulo = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'MovTarea'
INSERT hMovTiempo
(Modulo, ID, IDOrden, FechaComenzo, FechaTermino, FechaInicio, Estatus, Situacion, Sucursal, Usuario)
SELECT Modulo, ID, IDOrden, FechaComenzo, FechaTermino, FechaInicio, Estatus, Situacion, Sucursal, Usuario
FROM MovTiempo WITH(NOLOCK)
WHERE  ID = @ID AND Modulo = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hMovTiempo'
DELETE MovTiempo WHERE ID = @ID AND Modulo = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'MovTiempo'
INSERT hMovUsuario
(Modulo, ID, Orden, Usuario, Sucursal, Eliminado, Observaciones, Prioridad)
SELECT Modulo, ID, Orden, Usuario, Sucursal, Eliminado, Observaciones, Prioridad
FROM MovUsuario WITH(NOLOCK)
WHERE  ID = @ID AND Modulo = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hMovUsuario'
DELETE MovUsuario WHERE ID = @ID AND Modulo = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'MovUsuario'
RETURN
END
;

