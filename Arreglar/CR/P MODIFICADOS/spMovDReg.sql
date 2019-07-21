SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovDReg
@Modulo			char(5),
@ID			int,
@Renglon 		float,
@RenglonSub 		int,
@UnicamenteActualizar	bit = 0

AS BEGIN
DECLARE
@Existe			bit,
@RenglonID 			int,
@RenglonTipo 		char(1),
@UEN			int,
@Almacen 			char(10),
@Codigo 			varchar(30),
@Articulo 			varchar(20),
@SubCuenta 			varchar(50),
@Concepto			varchar(50),
@Personal			varchar(10),
@Cantidad 			float,
@Unidad 			varchar(50),
@Factor 			float,
@CantidadInventario 	float,
@Costo 			float,
@CostoInv 			float,
@CostoActividad 		float,
@Precio 			float,
@DescuentoTipo 		char(1),
@DescuentoLinea 		float,
@DescuentoImporte 		money,
@Impuesto1 			float,
@Impuesto2 			float,
@Impuesto3 			float,
@Retencion1 		float,
@Retencion2 		float,
@Retencion3 		float,
@DescripcionExtra 		varchar(100),
@Paquete 			int,
@ContUso 			varchar(20),
@Comision 			money,
@Aplica 			varchar(20),
@AplicaID 			varchar(20),
@DestinoTipo		varchar(10),
@Destino 			varchar(20),
@DestinoID 			varchar(20),
@Cliente			varchar(10),
@Agente 			varchar(10),
@Departamento 		int,
@Espacio 			varchar(10),
@Estado 			varchar(30),
@AFArticulo 		varchar(20),
@AFSerie			varchar(50),	
@CostoUEPS 			float,
@CostoPEPS 			float,
@UltimoCosto 		float,
@PrecioLista 		float,
@Posicion 			varchar(10),
@DepartamentoDetallista 	int,
@SerieLote			varchar(50),
@Producto			varchar(20),
@SubProducto		varchar(50),
@Merma			float,
@Desperdicio		float,
@Tipo			varchar(20),
@Ruta			varchar(20),
@Fecha			datetime,
@Importe			money,
@Impuestos			money,
@Provision			money,
@Depreciacion		money,
@DescuentoRecargos		money,
@InteresesOrdinarios	money,
@InteresesMoratorios	money,
@Porcentaje			float,
@FormaPago			varchar(50),
@Referencia			varchar(50),
@Proyecto			varchar(50),
@Actividad			varchar(50),
@Cuenta			varchar(20),
@CtoTipo			varchar(20),
@Contacto			varchar(10),
@ObligacionFiscal		varchar(50),
@Tasa			float,
@ABC			varchar(50),
@Base			money
SELECT @Existe = 0, @RenglonSub = ISNULL(@RenglonSub, 0)
IF EXISTS(SELECT * FROM MovDReg WITH(NOLOCK) WHERE Modulo = @Modulo AND ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub)
SELECT @Existe = 1
EXEC spMovDRegDatos @Modulo, @ID, @Renglon, @RenglonSub,
@RenglonID OUTPUT, @RenglonTipo OUTPUT, @UEN OUTPUT,@Almacen OUTPUT, @Codigo OUTPUT,
@Articulo OUTPUT, @SubCuenta OUTPUT, @Concepto OUTPUT, @Personal OUTPUT, @Cantidad OUTPUT, @Unidad OUTPUT, @Factor OUTPUT, @CantidadInventario OUTPUT,
@Costo OUTPUT, @CostoInv OUTPUT, @CostoActividad OUTPUT, @Precio OUTPUT, @DescuentoTipo OUTPUT, @DescuentoLinea OUTPUT, @DescuentoImporte OUTPUT,
@Impuesto1 OUTPUT, @Impuesto2 OUTPUT, @Impuesto3 OUTPUT, @Retencion1 OUTPUT, @Retencion2 OUTPUT,@Retencion3 OUTPUT,
@DescripcionExtra OUTPUT, @Paquete OUTPUT, @ContUso OUTPUT, @Comision OUTPUT, @Aplica OUTPUT, @AplicaID OUTPUT,
@DestinoTipo OUTPUT, @Destino OUTPUT, @DestinoID OUTPUT, @Cliente OUTPUT, @Agente OUTPUT, @Departamento OUTPUT, @Espacio OUTPUT,
@Estado OUTPUT,  @AFArticulo OUTPUT, @AFSerie OUTPUT, @CostoUEPS OUTPUT, @CostoPEPS OUTPUT, @UltimoCosto OUTPUT, @PrecioLista OUTPUT,
@Posicion OUTPUT,  @DepartamentoDetallista OUTPUT, @SerieLote OUTPUT, @Producto OUTPUT, @SubProducto OUTPUT, @Merma OUTPUT, @Desperdicio OUTPUT,
@Tipo OUTPUT, @Ruta OUTPUT, @Fecha OUTPUT, @Importe OUTPUT, @Impuestos OUTPUT, @Provision OUTPUT, @Depreciacion OUTPUT, @DescuentoRecargos OUTPUT,
@InteresesOrdinarios OUTPUT, @InteresesMoratorios OUTPUT, @Porcentaje OUTPUT, @FormaPago OUTPUT, @Referencia OUTPUT, @Proyecto OUTPUT,
@Actividad OUTPUT,  @Cuenta OUTPUT, @CtoTipo OUTPUT, @Contacto OUTPUT, @ObligacionFiscal OUTPUT, @Tasa OUTPUT, @Base OUTPUT, @ABC OUTPUT
IF @Existe = 0 AND @UnicamenteActualizar = 0
INSERT MovDReg (
Modulo,  ID,  Renglon,  RenglonSub,  RenglonID,  RenglonTipo,  UEN,  Concepto,  Personal,  Almacen,  Codigo,  Articulo,  SubCuenta,  Cantidad,  Unidad,  Factor,  CantidadInventario,  Costo,  CostoInv,  CostoActividad,  Precio,  DescuentoTipo,  DescuentoLinea,  DescuentoImporte,  Impuesto1,  Impuesto2,  Impuesto3,  Retencion1,  Retencion2,  Retencion3,  DescripcionExtra,  Paquete,  ContUso,  Comision,  Aplica,  AplicaID,  DestinoTipo,  Destino,  DestinoID,  Cliente,  Agente,  Departamento,  Espacio,  Estado,  AFArticulo,  AFSerie,  CostoUEPS,  CostoPEPS,  UltimoCosto,  PrecioLista,  Posicion,  DepartamentoDetallista,  SerieLote,  Producto,  SubProducto,  Merma,  Desperdicio,  Tipo,  Ruta,  Fecha,  Importe,  Porcentaje,  Impuestos,  Provision,  Depreciacion,  DescuentoRecargos,  InteresesOrdinarios,  InteresesMoratorios,  FormaPago,  Referencia,  Proyecto,  Actividad,  Cuenta,  CtoTipo,  Contacto,  ObligacionFiscal,  Tasa,  ABC)
VALUES (@Modulo, @ID, @Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @UEN, @Concepto, @Personal, @Almacen, @Codigo, @Articulo, @SubCuenta, @Cantidad, @Unidad, @Factor, @CantidadInventario, @Costo, @CostoInv, @CostoActividad, @Precio, @DescuentoTipo, @DescuentoLinea, @DescuentoImporte, @Impuesto1, @Impuesto2, @Impuesto3, @Retencion1, @Retencion2, @Retencion3, @DescripcionExtra, @Paquete, @ContUso, @Comision, @Aplica, @AplicaID, @DestinoTipo, @Destino, @DestinoID, @Cliente, @Agente, @Departamento, @Espacio, @Estado, @AFArticulo, @AFSerie, @CostoUEPS, @CostoPEPS, @UltimoCosto, @PrecioLista, @Posicion, @DepartamentoDetallista, @SerieLote, @Producto, @SubProducto, @Merma, @Desperdicio, @Tipo, @Ruta, @Fecha, @Importe, @Porcentaje, @Impuestos, @Provision, @Depreciacion, @DescuentoRecargos, @InteresesOrdinarios, @InteresesMoratorios, @FormaPago, @Referencia, @Proyecto, @Actividad, @Cuenta, @CtoTipo, @Contacto, @ObligacionFiscal, @Tasa, @ABC)
IF @Existe = 1 AND @UnicamenteActualizar = 1
UPDATE MovDReg WITH(ROWLOCK)
SET RenglonID = @RenglonID,  RenglonTipo = @RenglonTipo,  UEN = @UEN,  Concepto = @Concepto,  Personal = @Personal,  Almacen = @Almacen,  Codigo = @Codigo,
Articulo = @Articulo,  SubCuenta = @SubCuenta,  Cantidad = @Cantidad,  Unidad = @Unidad,  Factor = @Factor,  CantidadInventario = @CantidadInventario,  Costo = @Costo,  CostoInv = @CostoInv,  CostoActividad = @CostoActividad,
Precio = @Precio,  DescuentoTipo = @DescuentoTipo,  DescuentoLinea = @DescuentoLinea,  DescuentoImporte = @DescuentoImporte,  Impuesto1 = @Impuesto1,  Impuesto2 = @Impuesto2,  Impuesto3 = @Impuesto3,
Retencion1 = @Retencion1,  Retencion2 = @Retencion2,  Retencion3 = @Retencion3,  DescripcionExtra = @DescripcionExtra,  Paquete = @Paquete,  ContUso = @ContUso,  Comision = @Comision,
Aplica = @Aplica,  AplicaID = @AplicaID,  DestinoTipo = @DestinoTipo,  Destino = @Destino,  DestinoID = @DestinoID,  Cliente = @Cliente,  Agente = @Agente,
Departamento = @Departamento,  Espacio = @Espacio,  Estado = @Estado,  AFArticulo = @AFArticulo,  AFSerie = @AFSerie,  CostoUEPS = @CostoUEPS,  CostoPEPS = @CostoPEPS,  UltimoCosto = @UltimoCosto,  PrecioLista = @PrecioLista,  Posicion = @Posicion,
DepartamentoDetallista = @DepartamentoDetallista,  SerieLote = @SerieLote,  Producto = @Producto,  SubProducto = @SubProducto,  Merma = @Merma,  Desperdicio = @Desperdicio,  Tipo = @Tipo,  Ruta = @Ruta,
Fecha = @Fecha,  Importe = @Importe,  Porcentaje = @Porcentaje,  Impuestos = @Impuestos,  Provision = @Provision,  Depreciacion = @Depreciacion,
DescuentoRecargos = @DescuentoRecargos,  InteresesOrdinarios = @InteresesOrdinarios,  InteresesMoratorios = @InteresesMoratorios,
FormaPago = @FormaPago,  Referencia = @Referencia,  Proyecto = @Proyecto,  Actividad = @Actividad,  Cuenta = @Cuenta,
CtoTipo = @CtoTipo, Contacto = @Contacto, ObligacionFiscal = @ObligacionFiscal, Tasa = @Tasa, ABC = @ABC
WHERE Modulo = @Modulo AND ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
RETURN
END

