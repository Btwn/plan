SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSInsertarPorReservado
@Estacion       int,
@TarimaSurtido	varchar(20),
@Usuario        varchar(10),
@Ok             int OUTPUT,
@OkRef          varchar(255)OUTPUT

AS BEGIN
DECLARE
@ID						int,
@Articulo				varchar(20),
@Cantidad				float,
@Renglon				float,
@RenglonSub				int,
@Modulo					char(5),
@Unidad					varchar(50),
@Factor					float,
@CantidadInventario		float
DECLARE crInsertarPorReservado CURSOR FOR
SELECT 'VTAS', ID, Articulo, SUM(Cantidad), Renglon, RenglonSub, Unidad, Factor
FROM #WMSVentaDR
GROUP BY ID, Articulo, Renglon, RenglonSub, Unidad, Factor
UNION
SELECT 'INV', ID, Articulo, SUM(Cantidad), Renglon, RenglonSub, Unidad, Factor
FROM #WMSInvDR
GROUP BY ID, Articulo, Renglon, RenglonSub, Unidad, Factor
UNION
SELECT 'COMS', ID, Articulo, SUM(Cantidad), Renglon, RenglonSub, Unidad, Factor
FROM #WMSComsDR
GROUP BY ID, Articulo, Renglon, RenglonSub, Unidad, Factor
OPEN crInsertarPorReservado
FETCH NEXT FROM crInsertarPorReservado INTO @Modulo, @ID, @Articulo, @Cantidad, @Renglon, @RenglonSub, @Unidad, @Factor
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @CantidadInventario = @Cantidad*@Factor
IF @Modulo = 'VTAS'
BEGIN
UPDATE #WMSVentaDR SET Cantidad = @Cantidad, CantidadA = @Cantidad, CantidadPendiente = @Cantidad, CantidadInventario = @CantidadInventario WHERE ID = @ID AND Articulo = @Articulo AND Renglon = @Renglon AND RenglonSub = @RenglonSub
INSERT INTO cVentaDWMS(ID,Renglon,RenglonSub,RenglonID,RenglonTipo,Cantidad,Almacen,EnviarA,Codigo,Articulo,SubCuenta,Precio,PrecioSugerido,DescuentoTipo,DescuentoLinea,DescuentoImporte,Impuesto1,Impuesto2,Impuesto3,DescripcionExtra,Costo,CostoActividad,Paquete,ContUso,ContUso2,ContUso3,Aplica,AplicaID,CantidadPendiente,CantidadReservada,CantidadCancelada,CantidadOrdenada,CantidadObsequio,CantidadA,Unidad,Factor,CantidadInventario,SustitutoArticulo,SustitutoSubCuenta,FechaRequerida,HoraRequerida,Instruccion,UltimoReservadoCantidad,UltimoReservadoFecha,Agente,Departamento,Sucursal,SucursalOrigen,AutoLocalidad,UEN,Espacio,CantidadAlterna,PoliticaPrecios,PrecioMoneda,PrecioTipoCambio,AFArticulo,AFSerie,ExcluirPlaneacion,Anexo,Estado,ExcluirISAN,Posicion,PresupuestoEsp,ProveedorRef,TransferirA,Tarima,ABC,TipoImpuesto1,TipoImpuesto2,TipoImpuesto3,OrdenCompra,AnticipoFacturado,AnticipoMoneda,AnticipoTipoCambio,AnticipoRetencion)
SELECT TOP 1 ID,Renglon,RenglonSub,RenglonID,RenglonTipo,Cantidad,Almacen,EnviarA,Codigo,Articulo,SubCuenta,Precio,PrecioSugerido,DescuentoTipo,DescuentoLinea,DescuentoImporte,Impuesto1,Impuesto2,Impuesto3,DescripcionExtra,Costo,CostoActividad,Paquete,ContUso,ContUso2,ContUso3,Aplica,AplicaID,CantidadPendiente,CantidadReservada,CantidadCancelada,CantidadOrdenada,CantidadObsequio,CantidadA,Unidad,Factor,CantidadInventario,SustitutoArticulo,SustitutoSubCuenta,FechaRequerida,HoraRequerida,Instruccion,UltimoReservadoCantidad,UltimoReservadoFecha,Agente,Departamento,Sucursal,SucursalOrigen,AutoLocalidad,UEN,Espacio,CantidadAlterna,PoliticaPrecios,PrecioMoneda,PrecioTipoCambio,AFArticulo,AFSerie,ExcluirPlaneacion,Anexo,Estado,ExcluirISAN,Posicion,PresupuestoEsp,ProveedorRef,TransferirA,Tarima,ABC,TipoImpuesto1,TipoImpuesto2,TipoImpuesto3,OrdenCompra,AnticipoFacturado,AnticipoMoneda,AnticipoTipoCambio,AnticipoRetencion
FROM #WMSVentaDR
WHERE ID = @ID AND Articulo = @Articulo AND Renglon = @Renglon AND Renglon = @Renglon AND RenglonSub = @RenglonSub
DELETE #WMSVentaDR WHERE ID = @ID AND Articulo = @Articulo AND Renglon = @Renglon AND Renglon = @Renglon AND RenglonSub = @RenglonSub
END
ELSE
IF @Modulo = 'INV'
BEGIN
SELECT TOP 1 @Renglon = Renglon, @RenglonSub = RenglonSub FROM #WMSInvDR WHERE ID = @ID AND Articulo = @Articulo AND Renglon = @Renglon AND RenglonSub = @RenglonSub ORDER BY Renglon, RenglonSub
UPDATE #WMSInvDR SET Cantidad = @Cantidad, CantidadA = @Cantidad, CantidadPendiente = @Cantidad, CantidadInventario = @CantidadInventario WHERE ID = @ID AND Articulo = @Articulo AND Renglon = @Renglon AND RenglonSub = @RenglonSub
INSERT INTO cInvDWMS (ID,Renglon,RenglonSub,RenglonID,RenglonTipo,Cantidad,Almacen,Codigo,Articulo,SubCuenta,ArticuloDestino,SubCuentaDestino,Costo,CostoInv,ContUso,Espacio,CantidadReservada,CantidadCancelada,CantidadOrdenada,CantidadPendiente,CantidadA,Paquete,FechaRequerida,Aplica,AplicaID,DestinoTipo,Destino,DestinoID,Cliente,Unidad,Factor,CantidadInventario,UltimoReservadoCantidad,UltimoReservadoFecha,ProdSerieLote,Merma,Desperdicio,Producto,SubProducto,Tipo,Sucursal,SucursalOrigen,Precio,DescripcionExtra,Posicion,Tarima,Seccion,FechaCaducidad)
SELECT TOP 1 ID,Renglon,RenglonSub,RenglonID,RenglonTipo,Cantidad,Almacen,Codigo,Articulo,SubCuenta,ArticuloDestino,SubCuentaDestino,Costo,CostoInv,ContUso,Espacio,CantidadReservada,CantidadCancelada,CantidadOrdenada,CantidadPendiente,CantidadA,Paquete,FechaRequerida,Aplica,AplicaID,DestinoTipo,Destino,DestinoID,Cliente,Unidad,Factor,CantidadInventario,UltimoReservadoCantidad,UltimoReservadoFecha,ProdSerieLote,Merma,Desperdicio,Producto,SubProducto,Tipo,Sucursal,SucursalOrigen,Precio,DescripcionExtra,Posicion,Tarima,Seccion,FechaCaducidad
FROM #WMSInvDR
WHERE ID = @ID AND Articulo = @Articulo AND Renglon = @Renglon AND Renglon = @Renglon AND RenglonSub = @RenglonSub
DELETE #WMSInvDR WHERE ID = @ID AND Articulo = @Articulo AND Renglon = @Renglon AND Renglon = @Renglon AND RenglonSub = @RenglonSub
END
ELSE
IF @Modulo = 'COMS'
BEGIN
SELECT TOP 1 @Renglon = Renglon, @RenglonSub = RenglonSub FROM #WMSComsDR WHERE ID = @ID AND Articulo = @Articulo AND Renglon = @Renglon AND RenglonSub = @RenglonSub ORDER BY Renglon, RenglonSub
UPDATE #WMSComsDR SET Cantidad = @Cantidad, CantidadA = @Cantidad, CantidadPendiente = @Cantidad, CantidadInventario = @CantidadInventario WHERE ID = @ID AND Articulo = @Articulo AND Renglon = @Renglon AND RenglonSub = @RenglonSub
INSERT INTO cCompraD(ID,Renglon,RenglonSub,RenglonID,RenglonTipo,Cantidad,Almacen,Codigo,Articulo,SubCuenta,FechaRequerida,FechaOrdenar,FechaEntrega,CostoConImpuesto,Costo,Impuesto1,Impuesto2,Impuesto3,Impuesto5,Retencion1,Retencion2,Retencion3,Descuento,DescuentoTipo,DescuentoLinea,DescuentoImporte,DescripcionExtra,ReferenciaExtra,ContUso,ContUso2,ContUso3,ClavePresupuestal,DestinoTipo,Destino,DestinoID,Aplica,AplicaID,CantidadPendiente,CantidadCancelada,CantidadA,CostoInv,Unidad,Factor,CantidadInventario,Cliente,ServicioArticulo,ServicioSerie,Paquete,Sucursal,SucursalOrigen,ImportacionProveedor,ImportacionReferencia,ProveedorRef,AgenteRef,FechaCaducidad,Posicion,Pais,TratadoComercial,ProgramaSectorial,ValorAduana,ImportacionImpuesto1,ImportacionImpuesto2,ID1,ID2,FormaPago,EsEstadistica,PresupuestoEsp,Tarima,EmpresaRef,Categoria,ABC,TipoImpuesto1,TipoImpuesto2,TipoImpuesto3,TipoImpuesto4,TipoImpuesto5,TipoRetencion1,TipoRetencion2,TipoRetencion3)
SELECT TOP 1 ID,Renglon,RenglonSub,RenglonID,RenglonTipo,Cantidad,Almacen,Codigo,Articulo,SubCuenta,FechaRequerida,FechaOrdenar,FechaEntrega,CostoConImpuesto,Costo,Impuesto1,Impuesto2,Impuesto3,Impuesto5,Retencion1,Retencion2,Retencion3,Descuento,DescuentoTipo,DescuentoLinea,DescuentoImporte,DescripcionExtra,ReferenciaExtra,ContUso,ContUso2,ContUso3,ClavePresupuestal,DestinoTipo,Destino,DestinoID,Aplica,AplicaID,CantidadPendiente,CantidadCancelada,CantidadA,CostoInv,Unidad,Factor,CantidadInventario,Cliente,ServicioArticulo,ServicioSerie,Paquete,Sucursal,SucursalOrigen,ImportacionProveedor,ImportacionReferencia,ProveedorRef,AgenteRef,FechaCaducidad,Posicion,Pais,TratadoComercial,ProgramaSectorial,ValorAduana,ImportacionImpuesto1,ImportacionImpuesto2,ID1,ID2,FormaPago,EsEstadistica,PresupuestoEsp,Tarima,EmpresaRef,Categoria,ABC,TipoImpuesto1,TipoImpuesto2,TipoImpuesto3,TipoImpuesto4,TipoImpuesto5,TipoRetencion1,TipoRetencion2,TipoRetencion3
FROM #WMSComsDR
WHERE ID = @ID AND Articulo = @Articulo AND Renglon = @Renglon AND Renglon = @Renglon AND RenglonSub = @RenglonSub
DELETE #WMSComsDR WHERE ID = @ID AND Articulo = @Articulo AND Renglon = @Renglon AND Renglon = @Renglon AND RenglonSub = @RenglonSub
END
IF @Ok IS NULL AND @Modulo IN ('INV', 'VTAS')
EXEC spAfectar @Modulo, @ID, 'RESERVAR', 'Seleccion', NULL, @Usuario, @Estacion, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT , @OkRef = @OkRef OUTPUT
IF @Modulo = 'VTAS'
UPDATE VentaD SET Tarima = @TarimaSurtido WHERE ID = @ID AND Articulo = @Articulo AND CantidadReservada > 0 AND Renglon = ISNULL(@Renglon,Renglon) AND NULLIF(Tarima,'') IS NULL
ELSE
IF @Modulo = 'INV'
UPDATE InvD SET Tarima = @TarimaSurtido WHERE ID = @ID AND Articulo = @Articulo AND CantidadReservada > 0 AND Renglon = ISNULL(@Renglon,Renglon) AND NULLIF(Tarima,'') IS NULL
ELSE
IF @Modulo = 'COMS'
UPDATE CompraD SET Tarima = @TarimaSurtido WHERE ID = @ID AND Articulo = @Articulo AND Renglon = ISNULL(@Renglon,Renglon) AND NULLIF(Tarima,'') IS NULL
FETCH NEXT FROM crInsertarPorReservado INTO @Modulo, @ID, @Articulo, @Cantidad, @Renglon, @RenglonSub, @Unidad, @Factor
END
CLOSE crInsertarPorReservado
DEALLOCATE crInsertarPorReservado
RETURN
END

