SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpImportarPDA_ML
@Empresa char(5),
@Usuario char(10),
@IDPDA    int,
@Output int OUTPUT
AS
BEGIN
DECLARE
@ID              int,
@Modulo          char(10),
@Movimiento      char(20),
@Concepto        char(50),
@Aplica          char(20),
@AplicaID        char(20),
@Articulo        char(20),
@Cliente         char(10),
@Almacen         char(10),
@Moneda          char(10),
@TC              float,
@Cantidad        float,
@Inventario      float,
@Precio          float,
@Impuesto        money,
@Descuento       money,
@Fecha           datetime,
@TipoPago        char(50),   
@Total           money,  
@Condicion       char(50),
@Importe         money,
@FormaPago1      char(50),
@Importe1        money,
@Referencia1     char(50),
@FormaPago2      char(50),
@Importe2        money,
@Referencia2     char(50),
@FormaPago3      char(50),
@Importe3        money,
@Referencia3     char(50),
@Agente          char(10),
@DiasEntrega     int,
@TipoDias        char(20),
@DiasHabiles     char(20),
@FechaRequerida  datetime,
@Sucursal        int,
@Renglon         float,
@Unidad          char(10),
@MonedaPrecio    char(10),
@TCMonedaPrecio  float,
@DiasCondicion   int,
@MesesCondicion  int,
@Caja            char(10),
@Costo           money,
@CostoDevolucion char(50),
@Vencimiento     datetime,
@Factor          int,
@CantidadFactor  float,
@Descuento_Global      char(50),
@Descuento_Global_Cant money
SELECT TOP 1 @Modulo = Modulo
FROM MovimientosPDA
WHERE Usuario = @Usuario AND ID = @IDPDA
DECLARE crMovimientosPDA CURSOR FOR
SELECT Concepto, Aplica, AplicaID, Articulo, Cliente, Cantidad, Inventario, Precio, Impuesto, Descuento, Total
FROM MovimientosPDA
WHERE Usuario = @Usuario AND ID = @IDPDA
AND Movimiento not in ('Contado', 'Cobro')
SELECT @Renglon = 0
IF @Modulo = 'VTAS'
BEGIN
SELECT TOP 1 @Cliente = Cliente, @Modulo = Modulo, @Movimiento = Movimiento, @Condicion = Tipo_Pago,
@Fecha= convert(Smalldatetime,Fecha,102), @Descuento_Global = Descuento_Global, 
@Descuento_Global_Cant = Descuento_Global_Cant, @Inventario = Inventario,
@importe = Total, @impuesto = Impuesto 
FROM MovimientosPDA
WHERE Usuario = @Usuario AND ID = @IDPDA
AND Movimiento <> 'Contado'
SELECT @Moneda = DefMoneda FROM Cte WHERE Cliente = @Cliente
SELECT @TC = TipoCambio FROM Mon WHERE Moneda = @Moneda
SELECT @Agente = DefAgente, @Almacen = DefAlmacen, @Sucursal = Sucursal FROM Usuario WHERE Usuario = @Usuario
IF @Movimiento = 'Pedido'
BEGIN
SELECT @DiasEntrega = VentaTEEstandar, @TipoDias = VentaTEEstandarTipoDias
FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @DiasHabiles = DiasHabiles FROM EmpresaGral WHERE Empresa = @Empresa
EXEC spAgregarDias @Fecha, @DiasEntrega, @DiasHabiles, @TipoDias, 0, @FechaRequerida OUTPUT, 0
END
INSERT INTO Venta(Empresa, Mov,  FechaEmision, Moneda, TipoCambio, Usuario, Estatus, Directo, Cliente, Almacen, Condicion, Agente, FechaRequerida, Sucursal, SucursalOrigen, OrigenTipo, Referencia, Descuento, DescuentoGlobal, Importe, Impuestos, Concepto)
VALUES (@Empresa, @Movimiento, @Fecha, @Moneda, @TC, @Usuario, 'SINAFECTAR', 1, @Cliente, @Almacen, @Condicion, @Agente, @FechaRequerida, @Sucursal, @Sucursal, 'PDA', @IDPDA, @Descuento_Global, @Descuento_Global_Cant, @Importe, @impuesto, 'Rutas')
SELECT @ID = SCOPE_IDENTITY()
IF EXISTS(SELECT * FROM MovimientosPDA WHERE Usuario = @Usuario AND ID = @IDPDA AND Movimiento = 'Contado')
BEGIN
SELECT @FormaPago1 = RTRIM(NULLIF(Forma1,'')),
@Importe1 = ISNULL(Importe1,0),
@Referencia1 = NULLIF(Referencia1,''),
@FormaPago2 = RTRIM(NULLIF(Forma2,'')),
@Importe2 = ISNULL(Importe2,0),
@Referencia2 = NULLIF(Referencia2,''),
@FormaPago3 = RTRIM(NULLIF(Forma3,'')),
@Importe3 = ISNULL(Importe3,0),
@Referencia3 = NULLIF(Referencia3,'')
FROM MovimientosPDA
WHERE Usuario = @Usuario AND ID = @IDPDA AND Movimiento = 'Contado'
SELECT @Caja = DefCtaDinero FROM Usuario WHERE Usuario = @Usuario
INSERT INTO VentaCobro(ID, Importe1, Importe2, Importe3, FormaCobro1, FormaCobro2, FormaCobro3, Referencia1, Referencia2, Referencia3, CtaDinero, Cajero)
VALUES(@ID, @Importe1, @Importe2, @Importe3, @FormaPago1, @FormaPago2, @FormaPago3, @Referencia1, @Referencia2, @Referencia3, @Caja, @Agente)
END
ELSE
BEGIN
EXEC spCalcularVencimiento 'CXC', @Empresa, @Cliente, @Condicion, @Fecha, @Vencimiento OUTPUT, NULL, NULL          
UPDATE Venta SET Vencimiento = @Vencimiento WHERE ID = @ID
END
END
IF @Modulo = 'CXC'
BEGIN
SELECT TOP 1 @Cliente = Cliente, @Modulo = Modulo, @Movimiento = Movimiento, @Condicion = Tipo_Pago,
@Fecha= convert(Smalldatetime,Fecha,102), @Importe = Total, @Inventario = Inventario,  
@FormaPago1 = NULLIF(Forma1,''), @Importe1 = ISNULL(Importe1,0), @Referencia1 = NULLIF(Referencia1,''),
@FormaPago2 = NULLIF(Forma2,''), @Importe2 = ISNULL(Importe2,0), @Referencia2 = NULLIF(Referencia2,''),
@FormaPago3 = NULLIF(Forma3,''), @Importe3 = ISNULL(Importe3,0), @Referencia3 = NULLIF(Referencia3,'')
FROM MovimientosPDA
WHERE Usuario = @Usuario AND ID = @IDPDA
AND Movimiento = 'Cobro'
SELECT @Moneda = DefMoneda FROM Cte WHERE Cliente = @Cliente
SELECT @TC = TipoCambio FROM Mon WHERE Moneda = @Moneda
SELECT @Agente = DefAgente, @Almacen = DefAlmacen, @Sucursal = Sucursal, @Caja = DefCtaDinero
FROM Usuario WHERE Usuario = @Usuario
INSERT INTO Cxc(Empresa, Mov, FechaEmision, Moneda, TipoCambio, Usuario, Estatus, Cliente, ClienteMoneda, ClienteTipoCambio, CtaDinero, Importe, AplicaManual, ConDesglose, FormaCobro1, FormaCobro2, FormaCobro3, Importe1, Importe2, Importe3, Referencia1, Referencia2, Referencia3, Agente, Sucursal, Sucursalorigen)
VALUES(@Empresa, @Movimiento, @Fecha, @Moneda, @TC, @usuario, 'SINAFECTAR', @Cliente, @Moneda, @TC, @Caja, @Importe, 1, 1, @FormaPago1, @FormaPago2, @FormaPago3, @Importe1, @Importe2, @Importe3, @Referencia1, @Referencia2, @Referencia3, @Agente, @Sucursal, @Sucursal)
SELECT @ID = SCOPE_IDENTITY()
END
OPEN crMovimientosPDA
FETCH NEXT FROM crMovimientosPDA INTO @Concepto, @Aplica, @AplicaID, @Articulo, @Cliente, @Cantidad, @Inventario, @Precio, @Impuesto, @Descuento, @Total
WHILE @@FETCH_STATUS = 0
BEGIN
IF @Modulo = 'VTAS'
BEGIN
SELECT @Renglon = @Renglon + 2048
SELECT @Unidad = Unidad, @MonedaPrecio = MonedaPrecio, @Impuesto = Impuesto1
FROM Art
WHERE Articulo = @Articulo
SELECT @TCMonedaPrecio = TipoCambio FROM Mon WHERE Moneda = @MonedaPrecio
IF @Movimiento = 'Devolucion Venta'
BEGIN
SELECT @CostoDevolucion = SugerirCostoDev FROM EmpresaCfg WHERE Empresa = @Empresa
EXEC spVerCosto @Sucursal, @Empresa, NULL, @Articulo, '0', @Unidad, @CostoDevolucion, @Moneda, @TC, @Costo OUTPUT, 0
END
SELECT @CantidadFactor = @Cantidad
SELECT @Factor = VentaFactorDinamico FROM EmpresaCfg2 WHERE (Empresa=@Empresa)
IF @Factor = 1
BEGIN
SELECT @CantidadFactor = ArtUnidad.Factor
FROM Art, ArtUnidad ArtUnidad
WHERE Art.Articulo = ArtUnidad.Articulo
AND Art.Unidad = ArtUnidad.Unidad
AND ((Art.Articulo=@Articulo) AND (Art.Estatus='Alta'))
END
INSERT INTO  VentaD(ID, Renglon, RenglonID, RenglonTipo, Cantidad, Almacen, Articulo, Precio, Impuesto1, Unidad, Factor, CantidadInventario, FechaRequerida, Agente, Sucursal, SucursalOrigen, PrecioMoneda, PrecioTipoCambio, Costo, DescuentoLinea)
VALUES(@ID, @Renglon, 1, 'N', @Cantidad, @Almacen, @Articulo, @Precio, @Impuesto,                        @Unidad, @Inventario, @Cantidad, @FechaRequerida, @Agente, @Sucursal, @Sucursal, @MonedaPrecio, @TCMonedaPrecio, @Costo, @Descuento)
END
IF @Modulo = 'CXC'
BEGIN
SELECT @Renglon = @Renglon + 2048
INSERT INTO CxcD(ID, Renglon, Importe, Aplica, AplicaID)
VALUES(@ID, @Renglon, @Total, @Aplica, @AplicaID)
END
FETCH NEXT FROM crMovimientosPDA INTO @Concepto, @Aplica, @AplicaID, @Articulo, @Cliente, @Cantidad, @Inventario, @Precio, @Impuesto, @Descuento, @Total
END
CLOSE crMovimientosPDA
DEALLOCATE crMovimientosPDA
IF @ID is null  set @ID=0
SET @Output=@ID
RETURN
END

