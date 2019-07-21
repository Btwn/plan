SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spHistCompraMover
@ID     int,
@Ok     int          OUTPUT,
@OkRef  varchar(255) OUTPUT

AS BEGIN
INSERT hCompra
(ID, Empresa, Mov, MovID, FechaEmision, UltimoCambio, Concepto, Proyecto, Actividad, UEN, Moneda, TipoCambio, Usuario, Autorizacion, Referencia, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Directo, VerDestino, Prioridad, RenglonID, Proveedor, FormaEnvio, FechaRequerida, Almacen, Condicion, Vencimiento, Manejo, Fletes, ActivoFijo, Instruccion, Agente, Descuento, DescuentoGlobal, Importe, Impuestos, Saldo, DescuentoLineal, OrigenTipo, Origen, OrigenID, Poliza, PolizaID, GenerarPoliza, ContID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, Peso, Volumen, Conciliado, Causa, Atencion, FechaEntrega, EmbarqueEstado, Sucursal, ZonaImpuesto, Paquetes, Idioma, IVAFiscal, IEPSFiscal, ListaPreciosEsp, EstaImpreso, Mensaje, Logico1, Logico2, Logico3, Logico4, Logico5, Logico6, Logico7, Pagado, ProrrateoAplicaID, FormaEntrega, CancelarPendiente, LineaCredito, TipoAmortizacion, TipoTasa, Comisiones, ComisionesIVA, OperacionRelevante, VIN, SubModulo, AutoCargos, TieneTasaEsp, TasaEsp, Cliente, SucursalOrigen, SucursalDestino, Planeador, ContUso, ContUso2, ContUso3, ContratoID, ContratoMov, ContratoMovID, Entidad, CFDFlexEstatus, Retencion, ReferenciaMES, MovIntelisisMES, PosicionWMS, Posicion, CrossDocking, MesLanzamiento, CFDRetencionTimbrado)
SELECT ID, Empresa, Mov, MovID, FechaEmision, UltimoCambio, Concepto, Proyecto, Actividad, UEN, Moneda, TipoCambio, Usuario, Autorizacion, Referencia, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Directo, VerDestino, Prioridad, RenglonID, Proveedor, FormaEnvio, FechaRequerida, Almacen, Condicion, Vencimiento, Manejo, Fletes, ActivoFijo, Instruccion, Agente, Descuento, DescuentoGlobal, Importe, Impuestos, Saldo, DescuentoLineal, OrigenTipo, Origen, OrigenID, Poliza, PolizaID, GenerarPoliza, ContID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, Peso, Volumen, Conciliado, Causa, Atencion, FechaEntrega, EmbarqueEstado, Sucursal, ZonaImpuesto, Paquetes, Idioma, IVAFiscal, IEPSFiscal, ListaPreciosEsp, EstaImpreso, Mensaje, Logico1, Logico2, Logico3, Logico4, Logico5, Logico6, Logico7, Pagado, ProrrateoAplicaID, FormaEntrega, CancelarPendiente, LineaCredito, TipoAmortizacion, TipoTasa, Comisiones, ComisionesIVA, OperacionRelevante, VIN, SubModulo, AutoCargos, TieneTasaEsp, TasaEsp, Cliente, SucursalOrigen, SucursalDestino, Planeador, ContUso, ContUso2, ContUso3, ContratoID, ContratoMov, ContratoMovID, Entidad, CFDFlexEstatus, Retencion, ReferenciaMES, MovIntelisisMES, PosicionWMS, Posicion, CrossDocking, MesLanzamiento, CFDRetencionTimbrado
FROM Compra
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hCompra'
DELETE Compra WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'Compra'
INSERT hCompraCB
(ID, RenglonID, Codigo, Cantidad, Articulo, SubCuenta, Sucursal, SucursalOrigen)
SELECT ID, RenglonID, Codigo, Cantidad, Articulo, SubCuenta, Sucursal, SucursalOrigen
FROM CompraCB
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hCompraCB'
DELETE CompraCB WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'CompraCB'
INSERT hCompraD
(ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Cantidad, Almacen, Codigo, Articulo, SubCuenta, FechaRequerida, FechaOrdenar, FechaEntrega, Costo, Impuesto1, Impuesto2, Impuesto3, Retencion1, Retencion2, Retencion3, Descuento, DescuentoTipo, DescuentoLinea, DescuentoImporte, DescripcionExtra, ReferenciaExtra, ContUso, DestinoTipo, Destino, DestinoID, Aplica, AplicaID, CantidadPendiente, CantidadCancelada, CantidadA, CostoInv, Unidad, Factor, CantidadInventario, Cliente, ServicioArticulo, ServicioSerie, Paquete, Sucursal, ImportacionProveedor, ImportacionReferencia, ProveedorRef, AgenteRef, EstadoRef, FechaCaducidad, ProveedorArt, ProveedorArtCosto, AjusteCosteo, CostoUEPS, CostoPEPS, UltimoCosto, PrecioLista, Posicion, DepartamentoDetallista, Pais, TratadoComercial, ProgramaSectorial, ValorAduana, ImportacionImpuesto1, ImportacionImpuesto2, ID1, ID2, FormaPago, EsEstadistica, PresupuestoEsp, SucursalOrigen, IDCopiaMAVI, PorcentajeDescCompra, AreaMotora, ContUso2, ContUso3, Tarima, EmpresaRef, Categoria, Estado, CostoEstandar, ABC, PaqueteCantidad, CantidadEmbarcada, ClavePresupuestal, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoImpuesto4, TipoImpuesto5, TipoRetencion1, TipoRetencion2, TipoRetencion3, CostoConImpuesto, CostoPromedio, CostoReposicion, Impuesto5, CambioImpuesto, EmidaFechaRecarga, EmidaURL, EmidaProveedorCelular, ArticuloMaquila, PosicionActual, PosicionReal, AplicaRenglon, MonedaD, TipoCambioD, MesLanzamiento)
SELECT ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Cantidad, Almacen, Codigo, Articulo, SubCuenta, FechaRequerida, FechaOrdenar, FechaEntrega, Costo, Impuesto1, Impuesto2, Impuesto3, Retencion1, Retencion2, Retencion3, Descuento, DescuentoTipo, DescuentoLinea, DescuentoImporte, DescripcionExtra, ReferenciaExtra, ContUso, DestinoTipo, Destino, DestinoID, Aplica, AplicaID, CantidadPendiente, CantidadCancelada, CantidadA, CostoInv, Unidad, Factor, CantidadInventario, Cliente, ServicioArticulo, ServicioSerie, Paquete, Sucursal, ImportacionProveedor, ImportacionReferencia, ProveedorRef, AgenteRef, EstadoRef, FechaCaducidad, ProveedorArt, ProveedorArtCosto, AjusteCosteo, CostoUEPS, CostoPEPS, UltimoCosto, PrecioLista, Posicion, DepartamentoDetallista, Pais, TratadoComercial, ProgramaSectorial, ValorAduana, ImportacionImpuesto1, ImportacionImpuesto2, ID1, ID2, FormaPago, EsEstadistica, PresupuestoEsp, SucursalOrigen, IDCopiaMAVI, PorcentajeDescCompra, AreaMotora, ContUso2, ContUso3, Tarima, EmpresaRef, Categoria, Estado, CostoEstandar, ABC, PaqueteCantidad, CantidadEmbarcada, ClavePresupuestal, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoImpuesto4, TipoImpuesto5, TipoRetencion1, TipoRetencion2, TipoRetencion3, CostoConImpuesto, CostoPromedio, CostoReposicion, Impuesto5, CambioImpuesto, EmidaFechaRecarga, EmidaURL, EmidaProveedorCelular, ArticuloMaquila, PosicionActual, PosicionReal, AplicaRenglon, MonedaD, TipoCambioD, MesLanzamiento
FROM CompraD
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hCompraD'
DELETE CompraD WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'CompraD'
INSERT hCompraDPresupuestoEsp
(ID, Renglon, RenglonSub, CuentaPresupuesto, Importe, Sucursal, SucursalOrigen)
SELECT ID, Renglon, RenglonSub, CuentaPresupuesto, Importe, Sucursal, SucursalOrigen
FROM CompraDPresupuestoEsp
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hCompraDPresupuestoEsp'
DELETE CompraDPresupuestoEsp WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'CompraDPresupuestoEsp'
INSERT hCompraDProrrateo
(ID, IDRenglon, RenglonID, Articulo, SubCuenta, Almacen, Cantidad, Sucursal, SucursalOrigen)
SELECT ID, IDRenglon, RenglonID, Articulo, SubCuenta, Almacen, Cantidad, Sucursal, SucursalOrigen
FROM CompraDProrrateo
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hCompraDProrrateo'
DELETE CompraDProrrateo WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'CompraDProrrateo'
INSERT hCompraGastoDiverso
(ID, Concepto, Acreedor, RenglonID, Importe, PorcentajeImpuestos, Moneda, TipoCambio, Prorrateo, FechaEmision, Condicion, Vencimiento, Referencia, Retencion, Retencion2, Retencion3, Impuestos, Multiple, Sucursal, PedimentoEspecifico, SucursalOrigen, ProrrateoNivel)
SELECT ID, Concepto, Acreedor, RenglonID, Importe, PorcentajeImpuestos, Moneda, TipoCambio, Prorrateo, FechaEmision, Condicion, Vencimiento, Referencia, Retencion, Retencion2, Retencion3, Impuestos, Multiple, Sucursal, PedimentoEspecifico, SucursalOrigen, ProrrateoNivel
FROM CompraGastoDiverso
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hCompraGastoDiverso'
DELETE CompraGastoDiverso WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'CompraGastoDiverso'
INSERT hCompraGastoDiversoArt
(ID, Concepto, Articulo)
SELECT ID, Concepto, Articulo
FROM CompraGastoDiversoArt
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hCompraGastoDiversoArt'
DELETE CompraGastoDiversoArt WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'CompraGastoDiversoArt'
INSERT hCompraGastoDiversoD
(ID, RenglonID, Concepto, Acreedor, ConceptoD, Importe, Retencion, Retencion2, Retencion3, Impuestos, Referencia, Sucursal, SucursalOrigen)
SELECT ID, RenglonID, Concepto, Acreedor, ConceptoD, Importe, Retencion, Retencion2, Retencion3, Impuestos, Referencia, Sucursal, SucursalOrigen
FROM CompraGastoDiversoD
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hCompraGastoDiversoD'
DELETE CompraGastoDiversoD WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'CompraGastoDiversoD'
INSERT hCompraGastoDiversoProv
(ID, Concepto, Proveedor)
SELECT ID, Concepto, Proveedor
FROM CompraGastoDiversoProv
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hCompraGastoDiversoProv'
DELETE CompraGastoDiversoProv WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'CompraGastoDiversoProv'
INSERT hCompraGastoDiversoRef
(ID, Concepto, Referencia)
SELECT ID, Concepto, Referencia
FROM CompraGastoDiversoRef
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hCompraGastoDiversoRef'
DELETE CompraGastoDiversoRef WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'CompraGastoDiversoRef'
INSERT hCompraGastoProrrateo
(ID, Renglon, RenglonSub, Articulo, IDRenglon, Concepto, ValorAlmacen, ValorAduana)
SELECT ID, Renglon, RenglonSub, Articulo, IDRenglon, Concepto, ValorAlmacen, ValorAduana
FROM CompraGastoProrrateo
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hCompraGastoProrrateo'
DELETE CompraGastoProrrateo WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'CompraGastoProrrateo'
INSERT hCompraImportacion
(ID, RenglonID, Documento, FechaDocumento, GuiaEntrega, FechaGuia, Convenio, PuertoCarga, FechaCarga, PuertoDestino, FechaDestino, Paquetes)
SELECT ID, RenglonID, Documento, FechaDocumento, GuiaEntrega, FechaGuia, Convenio, PuertoCarga, FechaCarga, PuertoDestino, FechaDestino, Paquetes
FROM CompraImportacion
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hCompraImportacion'
DELETE CompraImportacion WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'CompraImportacion'
INSERT hCompraSugerir
(Estacion, CompraID, ID, Modulo, ModuloID, Mov, MovID, FechaEmision, FechaRequerida, Referencia, Cliente, Almacen, Articulo, SubCuenta, Precio, Descuento, ServicioArticulo, ServicioSerie, ServicioFecha, ClaveProveedor, UnidadCompra, CantidadMinima, Multiplos, MultiplosUnidad, Cantidad, CantidadA, FactorDemanda, Paquete)
SELECT Estacion, CompraID, ID, Modulo, ModuloID, Mov, MovID, FechaEmision, FechaRequerida, Referencia, Cliente, Almacen, Articulo, SubCuenta, Precio, Descuento, ServicioArticulo, ServicioSerie, ServicioFecha, ClaveProveedor, UnidadCompra, CantidadMinima, Multiplos, MultiplosUnidad, Cantidad, CantidadA, FactorDemanda, Paquete
FROM CompraSugerir
WHERE ModuloID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hCompraSugerir'
DELETE CompraSugerir WHERE ModuloID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'CompraSugerir'
INSERT hVentaDPresupuestoEsp
(ID, Renglon, RenglonSub, CuentaPresupuesto, Importe, Sucursal, SucursalOrigen)
SELECT ID, Renglon, RenglonSub, CuentaPresupuesto, Importe, Sucursal, SucursalOrigen
FROM VentaDPresupuestoEsp
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hVentaDPresupuestoEsp'
DELETE VentaDPresupuestoEsp WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'VentaDPresupuestoEsp'
RETURN
END
;

