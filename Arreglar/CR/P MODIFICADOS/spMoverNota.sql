SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMoverNota
@ID		int,
@Accion		varchar(20) = 'MOVER'

AS BEGIN
IF @Accion = 'MOVER'
BEGIN
IF EXISTS(SELECT * FROM Venta WITH(NOLOCK) WHERE ID = @ID) AND
NOT EXISTS(SELECT * FROM Nota WITH(NOLOCK) WHERE ID = @ID)
BEGIN
INSERT NotaCobroD (
ID,RenglonID,Importe,Moneda,TipoCambio,FormaCobro,Referencia,Sucursal,SucursalOrigen)
SELECT ID,RenglonID,Importe,Moneda,TipoCambio,FormaCobro,Referencia,Sucursal,SucursalOrigen
FROM VentaCobroD WITH(NOLOCK)
WHERE ID = @ID
INSERT NotaCobro (
ID,Importe1,Importe2,Importe3,Importe4,Importe5,FormaCobro1,FormaCobro2,FormaCobro3,FormaCobro4,FormaCobro5,Referencia1,Referencia2,Referencia3,Referencia4,Referencia5,Observaciones1,Observaciones2,Observaciones3,Observaciones4,Observaciones5,Cambio,Redondeo,DelEfectivo,Sucursal,CtaDinero,Cajero,Condicion,Vencimiento,Actualizado,SucursalOrigen)
SELECT ID,Importe1,Importe2,Importe3,Importe4,Importe5,FormaCobro1,FormaCobro2,FormaCobro3,FormaCobro4,FormaCobro5,Referencia1,Referencia2,Referencia3,Referencia4,Referencia5,Observaciones1,Observaciones2,Observaciones3,Observaciones4,Observaciones5,Cambio,Redondeo,DelEfectivo,Sucursal,CtaDinero,Cajero,Condicion,Vencimiento,Actualizado,SucursalOrigen
FROM VentaCobro WITH(NOLOCK)
WHERE ID = @ID
INSERT NotaDAgente (
ID,Renglon,RenglonSub,RID,Agente,Fecha,HoraD,HoraA,Minutos,Actividad,Estado,Comentarios,CantidadEstandar,FechaConclusion,CostoActividad,Avance,Sucursal,SucursalOrigen)
SELECT ID,Renglon,RenglonSub,RID,Agente,Fecha,HoraD,HoraA,Minutos,Actividad,Estado,Comentarios,CantidadEstandar,FechaConclusion,CostoActividad,Avance,Sucursal,SucursalOrigen
FROM VentaDAgente WITH(NOLOCK)
WHERE ID = @ID
INSERT NotaD (
ID,Renglon,RenglonSub,RenglonID,RenglonTipo,Cantidad,Almacen,EnviarA,Codigo,Articulo,SubCuenta,Precio,PrecioSugerido,DescuentoTipo,DescuentoLinea,DescuentoImporte,Impuesto1,Impuesto2,Impuesto3,DescripcionExtra,Costo,CostoActividad,Paquete,ContUso,Comision,Aplica,AplicaID,CantidadPendiente,CantidadReservada,CantidadCancelada,CantidadOrdenada,CantidadEmbarcada,CantidadA,Unidad,Factor,CantidadInventario,SustitutoArticulo,SustitutoSubCuenta,FechaRequerida,HoraRequerida,Instruccion,Agente,Departamento,UltimoReservadoCantidad,UltimoReservadoFecha,Sucursal,PoliticaPrecios,SucursalOrigen,AutoLocalidad,UEN,Espacio,CantidadAlterna,PrecioMoneda,PrecioTipoCambio,Estado,ServicioNumero,AgentesAsignados,AFArticulo,AFSerie,ExcluirPlaneacion,Anexo,AjusteCosteo,CostoUEPS,CostoPEPS,UltimoCosto,PrecioLista,DepartamentoDetallista,PresupuestoEsp,Posicion,Puntos,CantidadObsequio,OfertaID,ProveedorRef,TransferirA,ArtEstatus,ArtSituacion,Tarima,ContUso2,ContUso3,CostoEstandar,ABC,TipoImpuesto1,TipoImpuesto2,TipoImpuesto3)
SELECT ID,Renglon,RenglonSub,RenglonID,RenglonTipo,Cantidad,Almacen,EnviarA,Codigo,Articulo,SubCuenta,Precio,PrecioSugerido,DescuentoTipo,DescuentoLinea,DescuentoImporte,Impuesto1,Impuesto2,Impuesto3,DescripcionExtra,Costo,CostoActividad,Paquete,ContUso,Comision,Aplica,AplicaID,CantidadPendiente,CantidadReservada,CantidadCancelada,CantidadOrdenada,CantidadEmbarcada,CantidadA,Unidad,Factor,CantidadInventario,SustitutoArticulo,SustitutoSubCuenta,FechaRequerida,HoraRequerida,Instruccion,Agente,Departamento,UltimoReservadoCantidad,UltimoReservadoFecha,Sucursal,PoliticaPrecios,SucursalOrigen,AutoLocalidad,UEN,Espacio,CantidadAlterna,PrecioMoneda,PrecioTipoCambio,Estado,ServicioNumero,AgentesAsignados,AFArticulo,AFSerie,ExcluirPlaneacion,Anexo,AjusteCosteo,CostoUEPS,CostoPEPS,UltimoCosto,PrecioLista,DepartamentoDetallista,PresupuestoEsp,Posicion,Puntos,CantidadObsequio,OfertaID,ProveedorRef,TransferirA,ArtEstatus,ArtSituacion,Tarima,ContUso2,ContUso3,CostoEstandar,ABC,TipoImpuesto1,TipoImpuesto2,TipoImpuesto3
FROM VentaD WITH(NOLOCK)
WHERE ID = @ID
INSERT Nota (
ID,Empresa,Mov,MovID,FechaEmision,UltimoCambio,Concepto,Proyecto,UEN,Moneda,TipoCambio,Usuario,Autorizacion,Referencia,DocFuente,Observaciones,Estatus,Situacion,SituacionFecha,SituacionUsuario,SituacionNota,Directo,Prioridad,RenglonID,FechaOriginal,
Codigo,Cliente,EnviarA,Almacen,AlmacenDestino,Agente,AgenteServicio,AgenteComision,FormaEnvio,FechaRequerida,HoraRequerida,FechaProgramadaEnvio,
FechaOrdenCompra,ReferenciaOrdenCompra,OrdenCompra,Condicion,Vencimiento,CtaDinero,Descuento,DescuentoGlobal,Importe,Impuestos,Saldo,AnticiposFacturados,AnticiposImpuestos,Retencion,DescuentoLineal,ComisionTotal,CostoTotal,PrecioTotal,Paquetes,
ServicioTipo,ServicioArticulo,ServicioSerie,ServicioContrato,ServicioContratoID,ServicioContratoTipo,ServicioGarantia,ServicioDescripcion,ServicioFecha,ServicioFlotilla,ServicioRampa,ServicioIdentificador,ServicioPlacas,ServicioKms,ServicioTipoOrden,
ServicioTipoOperacion,ServicioSiniestro,ServicioExpress,ServicioDemerito,ServicioDeducible,ServicioDeducibleImporte,ServicioNumero,ServicioNumeroEconomico,ServicioAseguradora,ServicioPuntual,ServicioPoliza,
OrigenTipo,Origen,OrigenID,Poliza,PolizaID,GenerarPoliza,ContID,Ejercicio,Periodo,FechaRegistro,FechaConclusion,FechaCancelacion,FechaEntrega,EmbarqueEstado,EmbarqueGastos,Peso,Volumen,Causa,Atencion,AtencionTelefono,ListaPreciosEsp,ZonaImpuesto,
Extra,CancelacionID,Mensaje,Departamento,Sucursal,GenerarOP,DesglosarImpuestos,DesglosarImpuesto2,ExcluirPlaneacion,ConVigencia,VigenciaDesde,VigenciaHasta,Enganche,Bonificacion,IVAFiscal,IEPSFiscal,EstaImpreso,Periodicidad,SubModulo,ContUso,
Espacio,AutoCorrida,AutoCorridaHora,AutoCorridaServicio,AutoCorridaRol,AutoCorridaOrigen,AutoCorridaDestino,AutoCorridaKms,AutoCorridaLts,AutoCorridaRuta,AutoOperador2,AutoBoleto,AutoKms,AutoKmsActuales,AutoBomba,AutoBombaContador,
DifCredito,EspacioResultado,Clase,Subclase,GastoAcreedor,GastoConcepto,Comentarios,Pagado,GenerarDinero,Dinero,DineroID,DineroCtaDinero,DineroConciliado,DineroFechaConciliacion,Extra1,Extra2,Extra3,Reabastecido,SucursalVenta,AF,AFArticulo,AFSerie,
ContratoTipo,ContratoDescripcion,ContratoSerie,ContratoValor,ContratoValorMoneda,ContratoSeguro,ContratoVencimiento,ContratoResponsable,Incentivo,IncentivoConcepto,EndosarA,InteresTasa,InteresIVA,AnexoID,FordVisitoOASIS,LineaCredito,TipoAmortizacion,TipoTasa,
Comisiones,ComisionesIVA,CompraID,OperacionRelevante,TieneTasaEsp,TasaEsp,FormaPagoTipo,SobrePrecio,ContUso2,ContUso3,Actividad,ContratoID,ContratoMov,ContratoMovID
)
SELECT
ID,Empresa,Mov,MovID,FechaEmision,UltimoCambio,Concepto,Proyecto,UEN,Moneda,TipoCambio,Usuario,Autorizacion,Referencia,DocFuente,Observaciones,Estatus,Situacion,SituacionFecha,SituacionUsuario,SituacionNota,Directo,Prioridad,RenglonID,FechaOriginal,
Codigo,Cliente,EnviarA,Almacen,AlmacenDestino,Agente,AgenteServicio,AgenteComision,FormaEnvio,FechaRequerida,HoraRequerida,FechaProgramadaEnvio,
FechaOrdenCompra,ReferenciaOrdenCompra,OrdenCompra,Condicion,Vencimiento,CtaDinero,Descuento,DescuentoGlobal,Importe,Impuestos,Saldo,AnticiposFacturados,AnticiposImpuestos,Retencion,DescuentoLineal,ComisionTotal,CostoTotal,PrecioTotal,Paquetes,
ServicioTipo,ServicioArticulo,ServicioSerie,ServicioContrato,ServicioContratoID,ServicioContratoTipo,ServicioGarantia,ServicioDescripcion,ServicioFecha,ServicioFlotilla,ServicioRampa,ServicioIdentificador,ServicioPlacas,ServicioKms,ServicioTipoOrden,
ServicioTipoOperacion,ServicioSiniestro,ServicioExpress,ServicioDemerito,ServicioDeducible,ServicioDeducibleImporte,ServicioNumero,ServicioNumeroEconomico,ServicioAseguradora,ServicioPuntual,ServicioPoliza,
OrigenTipo,Origen,OrigenID,Poliza,PolizaID,GenerarPoliza,ContID,Ejercicio,Periodo,FechaRegistro,FechaConclusion,FechaCancelacion,FechaEntrega,EmbarqueEstado,EmbarqueGastos,Peso,Volumen,Causa,Atencion,AtencionTelefono,ListaPreciosEsp,ZonaImpuesto,
Extra,CancelacionID,Mensaje,Departamento,Sucursal,GenerarOP,DesglosarImpuestos,DesglosarImpuesto2,ExcluirPlaneacion,ConVigencia,VigenciaDesde,VigenciaHasta,Enganche,Bonificacion,IVAFiscal,IEPSFiscal,EstaImpreso,Periodicidad,SubModulo,ContUso,
Espacio,AutoCorrida,AutoCorridaHora,AutoCorridaServicio,AutoCorridaRol,AutoCorridaOrigen,AutoCorridaDestino,AutoCorridaKms,AutoCorridaLts,AutoCorridaRuta,AutoOperador2,AutoBoleto,AutoKms,AutoKmsActuales,AutoBomba,AutoBombaContador,
DifCredito,EspacioResultado,Clase,Subclase,GastoAcreedor,GastoConcepto,Comentarios,Pagado,GenerarDinero,Dinero,DineroID,DineroCtaDinero,DineroConciliado,DineroFechaConciliacion,Extra1,Extra2,Extra3,Reabastecido,SucursalVenta,AF,AFArticulo,AFSerie,
ContratoTipo,ContratoDescripcion,ContratoSerie,ContratoValor,ContratoValorMoneda,ContratoSeguro,ContratoVencimiento,ContratoResponsable,Incentivo,IncentivoConcepto,EndosarA,InteresTasa,InteresIVA,AnexoID,FordVisitoOASIS,LineaCredito,TipoAmortizacion,TipoTasa,
Comisiones,ComisionesIVA,CompraID,OperacionRelevante,TieneTasaEsp,TasaEsp,FormaPagoTipo,SobrePrecio,ContUso2,ContUso3,Actividad,ContratoID,ContratoMov,ContratoMovID
FROM Venta WITH(NOLOCK)
WHERE ID = @ID
DELETE VentaCobroD  WHERE ID = @ID
DELETE VentaCobro   WHERE ID = @ID
DELETE VentaDAgente WHERE ID = @ID
DELETE VentaD	  WHERE ID = @ID
DELETE Venta        WHERE ID = @ID
END
END ELSE
IF @Accion = 'REGRESAR'
BEGIN
IF EXISTS(SELECT * FROM Nota WITH(NOLOCK) WHERE ID = @ID) AND
NOT EXISTS(SELECT * FROM Venta WITH(NOLOCK) WHERE ID = @ID)
BEGIN
SET IDENTITY_INSERT Venta ON;
INSERT Venta (
ID,Empresa,Mov,MovID,FechaEmision,UltimoCambio,Concepto,Proyecto,UEN,Moneda,TipoCambio,Usuario,Autorizacion,Referencia,DocFuente,Observaciones,Estatus,Situacion,SituacionFecha,SituacionUsuario,SituacionNota,Directo,Prioridad,RenglonID,FechaOriginal,
Codigo,Cliente,EnviarA,Almacen,AlmacenDestino,Agente,AgenteServicio,AgenteComision,FormaEnvio,FechaRequerida,HoraRequerida,FechaProgramadaEnvio,
FechaOrdenCompra,ReferenciaOrdenCompra,OrdenCompra,Condicion,Vencimiento,CtaDinero,Descuento,DescuentoGlobal,Importe,Impuestos,Saldo,AnticiposFacturados,AnticiposImpuestos,Retencion,DescuentoLineal,ComisionTotal,CostoTotal,PrecioTotal,Paquetes,
ServicioTipo,ServicioArticulo,ServicioSerie,ServicioContrato,ServicioContratoID,ServicioContratoTipo,ServicioGarantia,ServicioDescripcion,ServicioFecha,ServicioFlotilla,ServicioRampa,ServicioIdentificador,ServicioPlacas,ServicioKms,ServicioTipoOrden,
ServicioTipoOperacion,ServicioSiniestro,ServicioExpress,ServicioDemerito,ServicioDeducible,ServicioDeducibleImporte,ServicioNumero,ServicioNumeroEconomico,ServicioAseguradora,ServicioPuntual,ServicioPoliza,
OrigenTipo,Origen,OrigenID,Poliza,PolizaID,GenerarPoliza,ContID,Ejercicio,Periodo,FechaRegistro,FechaConclusion,FechaCancelacion,FechaEntrega,EmbarqueEstado,EmbarqueGastos,Peso,Volumen,Causa,Atencion,AtencionTelefono,ListaPreciosEsp,ZonaImpuesto,
Extra,CancelacionID,Mensaje,Departamento,Sucursal,GenerarOP,DesglosarImpuestos,DesglosarImpuesto2,ExcluirPlaneacion,ConVigencia,VigenciaDesde,VigenciaHasta,Enganche,Bonificacion,IVAFiscal,IEPSFiscal,EstaImpreso,Periodicidad,SubModulo,ContUso,
Espacio,AutoCorrida,AutoCorridaHora,AutoCorridaServicio,AutoCorridaRol,AutoCorridaOrigen,AutoCorridaDestino,AutoCorridaKms,AutoCorridaLts,AutoCorridaRuta,AutoOperador2,AutoBoleto,AutoKms,AutoKmsActuales,AutoBomba,AutoBombaContador,
DifCredito,EspacioResultado,Clase,Subclase,GastoAcreedor,GastoConcepto,Comentarios,Pagado,GenerarDinero,Dinero,DineroID,DineroCtaDinero,DineroConciliado,DineroFechaConciliacion,Extra1,Extra2,Extra3,Reabastecido,SucursalVenta,AF,AFArticulo,AFSerie,
ContratoTipo,ContratoDescripcion,ContratoSerie,ContratoValor,ContratoValorMoneda,ContratoSeguro,ContratoVencimiento,ContratoResponsable,Incentivo,IncentivoConcepto,EndosarA,InteresTasa,InteresIVA,AnexoID,FordVisitoOASIS,LineaCredito,TipoAmortizacion,TipoTasa,
Comisiones,ComisionesIVA,CompraID,OperacionRelevante,TieneTasaEsp,TasaEsp,FormaPagoTipo,SobrePrecio,ContUso2,ContUso3,Actividad,ContratoID,ContratoMov,ContratoMovID
)
SELECT
ID,Empresa,Mov,MovID,FechaEmision,UltimoCambio,Concepto,Proyecto,UEN,Moneda,TipoCambio,Usuario,Autorizacion,Referencia,DocFuente,Observaciones,Estatus,Situacion,SituacionFecha,SituacionUsuario,SituacionNota,Directo,Prioridad,RenglonID,FechaOriginal,
Codigo,Cliente,EnviarA,Almacen,AlmacenDestino,Agente,AgenteServicio,AgenteComision,FormaEnvio,FechaRequerida,HoraRequerida,FechaProgramadaEnvio,
FechaOrdenCompra,ReferenciaOrdenCompra,OrdenCompra,Condicion,Vencimiento,CtaDinero,Descuento,DescuentoGlobal,Importe,Impuestos,Saldo,AnticiposFacturados,AnticiposImpuestos,Retencion,DescuentoLineal,ComisionTotal,CostoTotal,PrecioTotal,Paquetes,
ServicioTipo,ServicioArticulo,ServicioSerie,ServicioContrato,ServicioContratoID,ServicioContratoTipo,ServicioGarantia,ServicioDescripcion,ServicioFecha,ServicioFlotilla,ServicioRampa,ServicioIdentificador,ServicioPlacas,ServicioKms,ServicioTipoOrden,
ServicioTipoOperacion,ServicioSiniestro,ServicioExpress,ServicioDemerito,ServicioDeducible,ServicioDeducibleImporte,ServicioNumero,ServicioNumeroEconomico,ServicioAseguradora,ServicioPuntual,ServicioPoliza,
OrigenTipo,Origen,OrigenID,Poliza,PolizaID,GenerarPoliza,ContID,Ejercicio,Periodo,FechaRegistro,FechaConclusion,FechaCancelacion,FechaEntrega,EmbarqueEstado,EmbarqueGastos,Peso,Volumen,Causa,Atencion,AtencionTelefono,ListaPreciosEsp,ZonaImpuesto,
Extra,CancelacionID,Mensaje,Departamento,Sucursal,GenerarOP,DesglosarImpuestos,DesglosarImpuesto2,ExcluirPlaneacion,ConVigencia,VigenciaDesde,VigenciaHasta,Enganche,Bonificacion,IVAFiscal,IEPSFiscal,EstaImpreso,Periodicidad,SubModulo,ContUso,
Espacio,AutoCorrida,AutoCorridaHora,AutoCorridaServicio,AutoCorridaRol,AutoCorridaOrigen,AutoCorridaDestino,AutoCorridaKms,AutoCorridaLts,AutoCorridaRuta,AutoOperador2,AutoBoleto,AutoKms,AutoKmsActuales,AutoBomba,AutoBombaContador,
DifCredito,EspacioResultado,Clase,Subclase,GastoAcreedor,GastoConcepto,Comentarios,Pagado,GenerarDinero,Dinero,DineroID,DineroCtaDinero,DineroConciliado,DineroFechaConciliacion,Extra1,Extra2,Extra3,Reabastecido,SucursalVenta,AF,AFArticulo,AFSerie,
ContratoTipo,ContratoDescripcion,ContratoSerie,ContratoValor,ContratoValorMoneda,ContratoSeguro,ContratoVencimiento,ContratoResponsable,Incentivo,IncentivoConcepto,EndosarA,InteresTasa,InteresIVA,AnexoID,FordVisitoOASIS,LineaCredito,TipoAmortizacion,TipoTasa,
Comisiones,ComisionesIVA,CompraID,OperacionRelevante,TieneTasaEsp,TasaEsp,FormaPagoTipo,SobrePrecio,ContUso2,ContUso3,Actividad,ContratoID,ContratoMov,ContratoMovID
FROM Nota WITH(NOLOCK)
WHERE ID = @ID
SET IDENTITY_INSERT Venta OFF;
INSERT VentaD (
ID,Renglon,RenglonSub,RenglonID,RenglonTipo,Cantidad,Almacen,EnviarA,Codigo,Articulo,SubCuenta,Precio,PrecioSugerido,DescuentoTipo,DescuentoLinea,DescuentoImporte,Impuesto1,Impuesto2,Impuesto3,DescripcionExtra,Costo,CostoActividad,Paquete,ContUso,Comision,Aplica,AplicaID,CantidadPendiente,CantidadReservada,CantidadCancelada,CantidadOrdenada,CantidadEmbarcada,CantidadA,Unidad,Factor,CantidadInventario,SustitutoArticulo,SustitutoSubCuenta,FechaRequerida,HoraRequerida,Instruccion,Agente,Departamento,UltimoReservadoCantidad,UltimoReservadoFecha,Sucursal,PoliticaPrecios,SucursalOrigen,AutoLocalidad,UEN,Espacio,CantidadAlterna,PrecioMoneda,PrecioTipoCambio,Estado,ServicioNumero,AgentesAsignados,AFArticulo,AFSerie,ExcluirPlaneacion,Anexo,AjusteCosteo,CostoUEPS,CostoPEPS,UltimoCosto,PrecioLista,DepartamentoDetallista,PresupuestoEsp,Posicion,Puntos,CantidadObsequio,OfertaID,ProveedorRef,TransferirA,ArtEstatus,ArtSituacion,Tarima,ContUso2,ContUso3,CostoEstandar,ABC,TipoImpuesto1,TipoImpuesto2,TipoImpuesto3)
SELECT ID,Renglon,RenglonSub,RenglonID,RenglonTipo,Cantidad,Almacen,EnviarA,Codigo,Articulo,SubCuenta,Precio,PrecioSugerido,DescuentoTipo,DescuentoLinea,DescuentoImporte,Impuesto1,Impuesto2,Impuesto3,DescripcionExtra,Costo,CostoActividad,Paquete,ContUso,Comision,Aplica,AplicaID,CantidadPendiente,CantidadReservada,CantidadCancelada,CantidadOrdenada,CantidadEmbarcada,CantidadA,Unidad,Factor,CantidadInventario,SustitutoArticulo,SustitutoSubCuenta,FechaRequerida,HoraRequerida,Instruccion,Agente,Departamento,UltimoReservadoCantidad,UltimoReservadoFecha,Sucursal,PoliticaPrecios,SucursalOrigen,AutoLocalidad,UEN,Espacio,CantidadAlterna,PrecioMoneda,PrecioTipoCambio,Estado,ServicioNumero,AgentesAsignados,AFArticulo,AFSerie,ExcluirPlaneacion,Anexo,AjusteCosteo,CostoUEPS,CostoPEPS,UltimoCosto,PrecioLista,DepartamentoDetallista,PresupuestoEsp,Posicion,Puntos,CantidadObsequio,OfertaID,ProveedorRef,TransferirA,ArtEstatus,ArtSituacion,Tarima,ContUso2,ContUso3,CostoEstandar,ABC,TipoImpuesto1,TipoImpuesto2,TipoImpuesto3
FROM NotaD WITH(NOLOCK)
WHERE ID = @ID
SET IDENTITY_INSERT VentaDAgente ON;
INSERT VentaDAgente (
ID,Renglon,RenglonSub,RID,Agente,Fecha,HoraD,HoraA,Minutos,Actividad,Estado,Comentarios,CantidadEstandar,FechaConclusion,CostoActividad,Avance,Sucursal,SucursalOrigen)
SELECT ID,Renglon,RenglonSub,RID,Agente,Fecha,HoraD,HoraA,Minutos,Actividad,Estado,Comentarios,CantidadEstandar,FechaConclusion,CostoActividad,Avance,Sucursal,SucursalOrigen
FROM NotaDAgente WITH(NOLOCK)
WHERE ID = @ID
SET IDENTITY_INSERT VentaDAgente OFF;
INSERT VentaCobro (
ID,Importe1,Importe2,Importe3,Importe4,Importe5,FormaCobro1,FormaCobro2,FormaCobro3,FormaCobro4,FormaCobro5,Referencia1,Referencia2,Referencia3,Referencia4,Referencia5,Observaciones1,Observaciones2,Observaciones3,Observaciones4,Observaciones5,Cambio,Redondeo,DelEfectivo,Sucursal,CtaDinero,Cajero,Condicion,Vencimiento,Actualizado,SucursalOrigen)
SELECT ID,Importe1,Importe2,Importe3,Importe4,Importe5,FormaCobro1,FormaCobro2,FormaCobro3,FormaCobro4,FormaCobro5,Referencia1,Referencia2,Referencia3,Referencia4,Referencia5,Observaciones1,Observaciones2,Observaciones3,Observaciones4,Observaciones5,Cambio,Redondeo,DelEfectivo,Sucursal,CtaDinero,Cajero,Condicion,Vencimiento,Actualizado,SucursalOrigen
FROM NotaCobro WITH(NOLOCK)
WHERE ID = @ID
SET IDENTITY_INSERT VentaCobroD ON;
INSERT VentaCobroD (
ID,RenglonID,Importe,Moneda,TipoCambio,FormaCobro,Referencia,Sucursal,SucursalOrigen)
SELECT ID,RenglonID,Importe,Moneda,TipoCambio,FormaCobro,Referencia,Sucursal,SucursalOrigen
FROM NotaCobroD WITH(NOLOCK)
WHERE ID = @ID
SET IDENTITY_INSERT VentaCobroD OFF;
DELETE NotaCobroD  WHERE ID = @ID
DELETE NotaCobro   WHERE ID = @ID
DELETE NotaDAgente WHERE ID = @ID
DELETE NotaD	 WHERE ID = @ID
DELETE Nota        WHERE ID = @ID
END
END
RETURN
END

