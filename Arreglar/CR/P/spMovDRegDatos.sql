SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovDRegDatos
@Modulo			char(5),
@ID			int,
@Renglon 		float,
@RenglonSub 		int,
@RenglonID 		int		OUTPUT,
@RenglonTipo 		char(1)		OUTPUT,
@UEN			int		OUTPUT,
@Almacen 		char(10)	OUTPUT,
@Codigo 		varchar(30)	OUTPUT,
@Articulo 		varchar(20)	OUTPUT,
@SubCuenta 		varchar(50)	OUTPUT,
@Concepto		varchar(50)	OUTPUT,
@Personal		varchar(10)	OUTPUT,
@Cantidad 		float		OUTPUT,
@Unidad 		varchar(50)	OUTPUT,
@Factor 		float		OUTPUT,
@CantidadInventario 	float		OUTPUT,
@Costo 			float		OUTPUT,
@CostoInv 		float		OUTPUT,
@CostoActividad 	float		OUTPUT,
@Precio 		float		OUTPUT,
@DescuentoTipo 		char(1)		OUTPUT,
@DescuentoLinea 	float		OUTPUT,
@DescuentoImporte 	money		OUTPUT,
@Impuesto1 		float		OUTPUT,
@Impuesto2 		float		OUTPUT,
@Impuesto3 		float		OUTPUT,
@Retencion1 		float		OUTPUT,
@Retencion2 		float		OUTPUT,
@Retencion3 		float		OUTPUT,
@DescripcionExtra 	varchar(100)	OUTPUT,
@Paquete 		int		OUTPUT,
@ContUso 		varchar(20)	OUTPUT,
@Comision 		money		OUTPUT,
@Aplica 		varchar(20)	OUTPUT,
@AplicaID 		varchar(20)	OUTPUT,
@DestinoTipo		varchar(10)	OUTPUT,
@Destino 		varchar(20)	OUTPUT,
@DestinoID 		varchar(20)	OUTPUT,
@Cliente		varchar(10)	OUTPUT,
@Agente 		varchar(10)	OUTPUT,
@Departamento 		int		OUTPUT,
@Espacio 		varchar(10)	OUTPUT,
@Estado 		varchar(30)	OUTPUT,
@AFArticulo 		varchar(20)	OUTPUT,
@AFSerie 		varchar(50)	OUTPUT, 
@CostoUEPS 		money		OUTPUT,
@CostoPEPS 		money		OUTPUT,
@UltimoCosto 		money		OUTPUT,
@PrecioLista 		money		OUTPUT,
@Posicion 		varchar(10)	OUTPUT,
@DepartamentoDetallista int		OUTPUT,
@SerieLote		varchar(50)	OUTPUT,
@Producto		varchar(20)	OUTPUT,
@SubProducto		varchar(50)	OUTPUT,
@Merma			float		OUTPUT,
@Desperdicio		float		OUTPUT,
@Tipo			varchar(20)	OUTPUT,
@Ruta			varchar(20)	OUTPUT,
@Fecha			datetime	OUTPUT,
@Importe		money		OUTPUT,
@Impuestos		money		OUTPUT,
@Provision		money		OUTPUT,
@Depreciacion		money		OUTPUT,
@DescuentoRecargos	money		OUTPUT,
@InteresesOrdinarios	money		OUTPUT,
@InteresesMoratorios	money		OUTPUT,
@Porcentaje		float		OUTPUT,
@FormaPago		varchar(50)	OUTPUT,
@Referencia		varchar(50)	OUTPUT,
@Proyecto		varchar(50)	OUTPUT,
@Actividad		varchar(50)	OUTPUT,
@Cuenta			varchar(20)	OUTPUT,
@CtoTipo		varchar(20)	OUTPUT,
@Contacto		varchar(10)	OUTPUT,
@ObligacionFiscal	varchar(50)	OUTPUT,
@Tasa			float		OUTPUT,
@Base			money		OUTPUT,
@ABC			varchar(50)	= NULL OUTPUT

AS BEGIN
SELECT @RenglonSub = ISNULL(@RenglonSub, 0)
IF @Modulo = 'VTAS'  SELECT @RenglonID = RenglonID, @RenglonTipo = RenglonTipo, @UEN = UEN, @Almacen = Almacen, @Codigo = Codigo, @Articulo = Articulo, @SubCuenta = SubCuenta, @Cantidad = Cantidad, @Unidad = Unidad, @Factor = Factor, @CantidadInventario = CantidadInventario, @Costo = Costo, @CostoActividad = CostoActividad, @Precio = Precio,  @DescuentoTipo = DescuentoTipo,  @DescuentoLinea = DescuentoLinea,  @DescuentoImporte = DescuentoImporte, @Impuesto1 = Impuesto1,  @Impuesto2 = Impuesto2,  @Impuesto3 = Impuesto3, @Retencion1 = Retencion1, @Retencion2 = Retencion2, @Retencion3 = Retencion3,  @DescripcionExtra = DescripcionExtra, @Paquete = Paquete, @ContUso = ContUso, @Comision = Comision, @Aplica = Aplica, @AplicaID = AplicaID, @Agente = Agente, @Departamento = Departamento, @Espacio = Espacio, @Estado = Estado, @AFArticulo = AFArticulo, @AFSerie = AFSerie, @CostoUEPS = CostoUEPS, @CostoPEPS = CostoPEPS, @UltimoCosto = UltimoCosto, @PrecioLista = PrecioLista, @Posicion = Posicion, @DepartamentoDetallista = DepartamentoDetallista, @ABC = ABC FROM VentaD WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub ELSE 
IF @Modulo = 'CXC'   SELECT @Importe = Importe, @Aplica = Aplica, @AplicaID = AplicaID, @Fecha = Fecha, @Comision = Comision, @DescuentoRecargos = DescuentoRecargos, @InteresesOrdinarios = InteresesOrdinarios, @InteresesMoratorios = InteresesMoratorios FROM CxcD WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub ELSE
IF @Modulo = 'CXP'   SELECT @Importe = Importe, @Aplica = Aplica, @AplicaID = AplicaID, @Fecha = Fecha, @DescuentoRecargos = DescuentoRecargos, @InteresesOrdinarios = InteresesOrdinarios, @InteresesMoratorios = InteresesMoratorios FROM CxpD WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub ELSE
IF @Modulo = 'FIS'   SELECT @ObligacionFiscal = ObligacionFiscal, @Importe = Importe, @Tasa = Tasa, @CtoTipo = ContactoTipo, @Contacto = Contacto, @AFArticulo = AFArticulo, @AFSerie = AFSerie FROM FiscalD WHERE ID = @ID AND Renglon = @Renglon ELSE
IF @Modulo = 'ST'    SELECT @Aplica = Aplica, @AplicaID = AplicaID FROM SoporteD WHERE ID = @ID AND Renglon = @Renglon ELSE
IF @Modulo = 'COMS'  SELECT @RenglonID = RenglonID, @RenglonTipo = RenglonTipo, @Almacen = Almacen, @Codigo = Codigo, @Articulo = Articulo, @SubCuenta = SubCuenta, @Cantidad = Cantidad, @Unidad = Unidad, @Factor = Factor, @CantidadInventario = CantidadInventario, @Costo = Costo, @CostoInv = CostoInv, @DescuentoTipo = DescuentoTipo, @DescuentoLinea = DescuentoLinea, @DescuentoImporte = DescuentoImporte, @Impuesto1 = Impuesto1, @Impuesto2 = Impuesto2, @Impuesto3 = Impuesto3, @Retencion1 = Retencion1, @Retencion2 = Retencion2, @Retencion3 = Retencion3, @DescripcionExtra = DescripcionExtra, @Paquete = Paquete, @ContUso = ContUso, @Aplica = Aplica, @AplicaID = AplicaID, @DestinoTipo = DestinoTipo, @Destino = Destino, @DestinoID = DestinoID, @Cliente = Cliente, @CostoUEPS = CostoUEPS, @CostoPEPS = CostoPEPS, @UltimoCosto = UltimoCosto, @PrecioLista = PrecioLista, @Posicion = Posicion, @DepartamentoDetallista = DepartamentoDetallista, @ABC = ABC FROM CompraD WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub ELSE
IF @Modulo = 'AGENT' SELECT @Importe = Importe, @Aplica = Aplica, @AplicaID = AplicaID FROM AgentD WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub ELSE
IF @Modulo = 'GAS'   SELECT @Concepto = Concepto, @Fecha = Fecha, @Referencia = Referencia, @Cantidad = Cantidad, @Precio = Precio, @Importe = Importe, @Retencion1 = Retencion, @Retencion2 = Retencion2, @Retencion3 = Retencion3, @Impuestos = Impuestos, @ContUso = ContUso, @Espacio = Espacio, @Actividad = Actividad, @Proyecto = Proyecto, @UEN = UEN, @SerieLote = VIN, @DescripcionExtra = DescripcionExtra, @AFArticulo = AFArticulo, @AFSerie = AFSerie, @Porcentaje = PorcentajeDeducible, @Provision = Provision, @Personal = Personal, @ABC = ABC FROM GastoD WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub ELSE
IF @Modulo = 'DIN'   SELECT @Importe = Importe, @FormaPago = FormaPago, @Referencia = Referencia, @Aplica = Aplica, @AplicaID = AplicaID FROM DineroD WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub ELSE
IF @Modulo = 'AF'    SELECT @Articulo = Articulo, @SerieLote = Serie, @Importe = Importe, @Impuestos = Impuestos, @Depreciacion = Depreciacion FROM ActivoFijoD WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub ELSE
/*  IF @Modulo = 'VALE'
IF @Modulo = 'CR'
IF @Modulo = 'CAM'
IF @Modulo = 'CAP'
IF @Modulo = 'INC'
IF @Modulo = 'TMA'
IF @Modulo = 'RSS'
IF @Modulo = 'CMP'
IF @Modulo = 'PROY'
IF @Modulo = 'CONT'
IF @Modulo = 'RH'
IF @Modulo = 'ASIS'
IF @Modulo = 'EMB'   */
IF @Modulo = 'PROD'  SELECT @RenglonID = RenglonID, @RenglonTipo = RenglonTipo, @Almacen = Almacen, @Codigo = Codigo, @Articulo = Articulo, @SubCuenta = SubCuenta, @Cantidad = Cantidad, @Unidad = Unidad, @Factor = Factor, @CantidadInventario = CantidadInventario, @Costo = Costo, @SerieLote = ProdSerieLote, @Paquete = Paquete, @DestinoTipo = DestinoTipo, @Destino = Destino, @DestinoID = DestinoID, @Aplica = Aplica, @AplicaID = AplicaID, @Cliente = Cliente, @Ruta = Ruta, @DescripcionExtra = DescripcionExtra, @Tipo = Tipo, @Comision = Comision, @Personal = Personal, @CostoUEPS = CostoUEPS, @CostoPEPS = CostoPEPS, @UltimoCosto = UltimoCosto, @PrecioLista = PrecioLista, @Posicion = Posicion, @DepartamentoDetallista = DepartamentoDetallista FROM ProdD WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub ELSE
IF @Modulo = 'INV'   SELECT @RenglonID = RenglonID, @RenglonTipo = RenglonTipo, @Cantidad = Cantidad, @Almacen = Almacen, @Codigo = Codigo, @Articulo = Articulo, @SubCuenta = SubCuenta, @Costo = Costo, @CostoInv = CostoInv, @ContUso = ContUso, @Espacio = Espacio, @Paquete = Paquete, @Aplica = Aplica, @AplicaID = AplicaID, @DestinoTipo = DestinoTipo, @Destino = Destino, @DestinoID = DestinoID, @Cliente = Cliente, @Unidad = Unidad, @Factor = Factor, @CantidadInventario = CantidadInventario, @SerieLote = ProdSerieLote, @Merma = Merma, @Desperdicio = Desperdicio, @Producto = Producto, @SubProducto = SubProducto, @Tipo = Tipo, @Precio = Precio, @DescripcionExtra = DescripcionExtra, @CostoUEPS = CostoUEPS, @CostoPEPS = CostoPEPS, @UltimoCosto = UltimoCosto, @PrecioLista = PrecioLista, @Posicion = Posicion, @DepartamentoDetallista = DepartamentoDetallista FROM InvD WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub ELSE
IF @Modulo = 'NOM'   SELECT @Personal = Personal, @Cuenta = Cuenta, @Importe = Importe, @Cantidad = Cantidad, @Concepto = Concepto, @Referencia = Referencia, @FormaPago = FormaPago, @Porcentaje = Porcentaje, @ContUso = ContUso FROM NominaD WHERE ID = @ID AND Renglon = @Renglon ELSE
IF @Modulo = 'PC'    SELECT @Articulo = Articulo, @SubCuenta = SubCuenta, @Precio = Nuevo FROM PCD WHERE ID = @ID AND Renglon = @Renglon
RETURN
END

