SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProcesarVentaNConsumo
@Estacion		int,
@Empresa		char(5),
@FacturaMov		char(20),
@FechaEmision	datetime,
@Usuario		char(10),
@CteCNO		char(10) 	= NULL,
@EnSilencio		bit	 	= 0,
@Ok			int	 	= NULL	OUTPUT,
@OkRef		varchar(255)	= NULL	OUTPUT,
@Sugerir		bit		= 0

AS BEGIN
DECLARE
@TipoCosteo			varchar(20),
@VentaMultiAlmacen		bit,
@OrigenID			int,
@VentaID			int,
@FacturaID			int,
@FacturaAseguradoraID	int,
@FacturaFechaEmision	datetime,
@FacturaMovID		varchar(20),
@NotaID			int,
@AjusteID			int,
@Cuantas			int,
@CuantasFacturas		int,
@Cliente			char(10),
@Aseguradora		char(10),
@EnviarA			int,
@ClienteVMOS		char(10),
@VentaEstatus		char(15),
@EstatusVMOS		char(15),
@AlmacenEncabezado		char(10),
@Almacen			char(10),
@Posicion			char(10),
@ArtTipo			char(20),
@Moneda			char(10),
@TipoCambio			float,
@Concepto			varchar(50),
@Articulo			char(20),
@SubCuenta			varchar(50),
@Unidad			varchar(50),
@Factor			float,
@Cantidad			float,
@CantidadInventario		float,
@Disponible			float,
@MonedaCosto		char(10),
@Costo			float,
@Precio        		float,
@PrecioNeto        		float,
@Importe			money,
@ImporteLinea		money,
@Proveedor			char(10),
@DescuentoTipo		char(1),
@DescuentoLinea		float,
@DescuentoGlobal		float,
@SobrePrecio		float,
@Impuesto1			float,
@Impuesto2			float,
@Impuesto3			money,
@Renglon			float,
@RenglonID			int,
@FactorCosto		float,
@TipoCambioCosto		float,
@ImporteTotal		money,
@Agente			char(10),
@UEN			int,
@CfgCosteoNivelSubCuenta 	bit,
@Sucursal			int,
@AjusteMov			char(20),
@AjusteMovID		varchar(20),
@Condicion			varchar(50),
@FechaRegistro		datetime,
@LeyendaEstatus		varchar(50),
@CfgCosteoSeries		bit,
@CfgCosteoLotes		bit,
@ArtCostoIdentificado	bit,
@SeriesLotesAutoOrden	varchar(50),
@AsignarConsecutivo		bit,
@Accion			char(20),
@LotesFijos			bit,
@Lote			varchar(50),
@RenglonTipo		char(1),
@Dif			money
IF @Sugerir = 1
DELETE SugerirFacturaNConsumo WHERE Estacion = @Estacion
IF NOT EXISTS(SELECT * FROM ListaID WHERE Estacion = @Estacion) OR ((SELECT Clave FROM MovTipo WHERE Modulo = 'VTAS' AND Mov = @FacturaMov) <> 'VTAS.F')
BEGIN
IF @EnSilencio = 0 AND @Sugerir = 0
SELECT NULL
RETURN
END
SELECT @EnviarA = NULL, @NotaID = NULL, @AjusteID = NULL, @ImporteTotal = 0.0, @Condicion = NULL, @FacturaMovID = NULL,
@FechaRegistro = GETDATE(), @LeyendaEstatus = '', @Agente = NULL, @UEN = NULL, @Proveedor = NULL, @CuantasFacturas = 0,
@FacturaID = NULL, @FacturaAseguradoraID = NULL
SELECT @AjusteMov = InvAjuste
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
SELECT @CfgCosteoNivelSubCuenta = CosteoNivelSubCuenta,
@ClienteVMOS             = NULLIF(RTRIM(ClienteFacturaVMOS), ''),
@EstatusVMOS             = ISNULL(NULLIF(RTRIM(EstatusFacturaVMOS), ''), 'BORRADOR'),
@AsignarConsecutivo      = ISNULL(AsignarConsecutivoFacturaVMOS, 0),
@TipoCosteo		  = ISNULL(NULLIF(RTRIM(UPPER(TipoCosteo)), ''), 'PROMEDIO'),
@CfgCosteoSeries	  = ISNULL(CosteoSeries, 0),
@CfgCosteoLotes	  = ISNULL(CosteoLotes, 0),
@SeriesLotesAutoOrden    = UPPER(SeriesLotesAutoOrden)
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @VentaEstatus = @EstatusVMOS
IF @EstatusVMOS = 'CONCLUIDO'  SELECT @VentaEstatus = 'BORRADOR'
IF @VentaEstatus = 'BORRADOR'   SELECT @LeyendaEstatus = ' (Borrador)'      ELSE
IF @VentaEstatus = 'CONFIRMAR'  SELECT @LeyendaEstatus = ' (por Confirmar)' ELSE
IF @VentaEstatus = 'SINAFECTAR' SELECT @LeyendaEstatus = ' (Sin Afectar)'
SELECT @VentaMultiAlmacen = VentaMultiAlmacen
FROM EmpresaCfg2
WHERE Empresa = @Empresa
SELECT @Sucursal = Sucursal FROM UsuarioSucursal WHERE Usuario = @Usuario
EXEC spExtraerFecha @FechaEmision OUTPUT
DECLARE crLista CURSOR
FOR SELECT ID FROM ListaID WHERE Estacion = @Estacion
OPEN crLista
FETCH NEXT FROM crLista INTO @NotaID
CLOSE crLista
DEALLOCATE crLista
IF @NotaID IS NULL
SELECT @Ok = 10160
IF EXISTS(SELECT * FROM Inv WHERE Empresa = @Empresa AND Estatus = 'CONFIRMAR' AND OrigenTipo = 'VMOS' AND Sucursal = @Sucursal)
SELECT @Ok = 10170
SELECT @ImporteTotal = SUM(ISNULL(Importe, 0.0) + ISNULL(Impuestos, 0.0))
FROM Venta v, ListaID l
WHERE v.ID = l.ID
AND l.Estacion = @Estacion
IF @ImporteTotal < 0.0
SELECT @Ok = 10180
IF @Ok IS NOT NULL AND @EnSilencio = 1 RETURN
SELECT @AlmacenEncabezado = Almacen,
@Cliente = ISNULL(@CteCNO, ISNULL(@ClienteVMOS, Cliente)),
@Moneda = Moneda,
@TipoCambio = TipoCambio,
@Concepto = Concepto
FROM Venta
WHERE ID = @NotaID
IF @CteCNO IS NOT NULL
BEGIN
SELECT @Cliente = ISNULL(NULLIF(RTRIM(FacturarCte), ''), Cliente),
@Aseguradora = NULLIF(RTRIM(Aseguradora), ''),
@EnviarA = FacturarCteEnviarA,
@Condicion = Condicion,
@Agente = Agente
FROM Cte
WHERE Cliente = @CteCNO
SELECT @UEN = UEN FROM Usuario WHERE Usuario = @Usuario
END
CREATE TABLE #Facturas (ID int NULL, FechaEmision datetime NULL)
BEGIN TRANSACTION
SELECT @FacturaFechaEmision = @FechaEmision 			/* Una Sola Factura sin Importar los Dias que esta Procesando */
IF @Sugerir = 0
BEGIN
INSERT Venta (
Sucursal,  SucursalOrigen, Empresa,  Mov,         FechaEmision,         Moneda,  TipoCambio,  Almacen,            Cliente,   EnviarA,   Condicion,   Concepto,  Usuario,  Estatus,       OrigenTipo, Agente,   UEN)
SELECT @Sucursal, @Sucursal,      @Empresa, @FacturaMov, @FacturaFechaEmision, @Moneda, @TipoCambio, @AlmacenEncabezado, c.Cliente, c.EnviarA, c.Condicion, @Concepto, @Usuario, @VentaEstatus, 'VMOS',     c.Agente, @UEN
FROM Cte c
WHERE c.Cliente = @Cliente
SELECT @FacturaID = SCOPE_IDENTITY()
IF @Aseguradora IS NOT NULL
BEGIN
INSERT Venta (
Sucursal,  SucursalOrigen, Empresa,  Mov,         FechaEmision,         Moneda,  TipoCambio,  Almacen,            Cliente,   EnviarA,   Condicion,   Concepto,  Usuario,  Estatus,       OrigenTipo, Agente,   UEN)
SELECT @Sucursal, @Sucursal,      @Empresa, @FacturaMov, @FacturaFechaEmision, @Moneda, @TipoCambio, @AlmacenEncabezado, c.Cliente, c.EnviarA, c.Condicion, @Concepto, @Usuario, @VentaEstatus, 'VMOS',     c.Agente, @UEN
FROM Cte c
WHERE c.Cliente = @Aseguradora
SELECT @FacturaAseguradoraID = SCOPE_IDENTITY()
END
END
SELECT @Renglon = 0, @RenglonID = 0
DECLARE crNotas CURSOR LOCAL
FOR SELECT d.Almacen, d.Posicion, d.Articulo, d.SubCuenta, d.RenglonTipo, d.Unidad, ROUND(d.Impuesto1, 4), ROUND(d.Impuesto2, 4), ROUND(d.Impuesto3, 4), SUM(d.Cantidad), SUM(d.CantidadInventario), d.DescuentoTipo, d.DescuentoLinea, d.Precio, SUM(d.ImporteTotal), v.DescuentoGlobal, v.SobrePrecio, Art.MonedaCosto, Art.Tipo, Art.CostoIdentificado
FROM Venta v, VentaTCalc d, ListaID l, Art
WHERE v.ID = d.ID AND d.ID = l.ID
AND l.Estacion = @Estacion
AND Art.Articulo = d.Articulo
GROUP BY d.Almacen, d.Posicion, d.Articulo, Art.MonedaCosto, Art.Tipo, Art.CostoIdentificado, d.SubCuenta, d.Unidad, d.RenglonTipo, ROUND(d.Impuesto1, 4), ROUND(d.Impuesto2, 4), ROUND(d.Impuesto3, 4), d.DescuentoTipo, d.DescuentoLinea, d.Precio, v.DescuentoGlobal, v.SobrePrecio
ORDER BY d.Almacen, d.Posicion, d.Articulo, Art.MonedaCosto, Art.Tipo, Art.CostoIdentificado, d.SubCuenta, d.Unidad, d.RenglonTipo, ROUND(d.Impuesto1, 4), ROUND(d.Impuesto2, 4), ROUND(d.Impuesto3, 4), d.DescuentoTipo, d.DescuentoLinea, d.Precio, v.DescuentoGlobal, v.SobrePrecio
OPEN crNotas
FETCH NEXT FROM crNotas INTO @Almacen, @Posicion, @Articulo, @SubCuenta, @RenglonTipo, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3, @Cantidad, @CantidadInventario, @DescuentoTipo, @DescuentoLinea, @Precio, @ImporteLinea, @DescuentoGlobal, @SobrePrecio, @MonedaCosto, @ArtTipo, @ArtCostoIdentificado
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @PrecioNeto = dbo.fnSubTotal(@Precio, @DescuentoGlobal, @SobrePrecio)
SELECT @Importe = @Cantidad * @PrecioNeto
IF NULLIF(@DescuentoLinea, 0.0) IS NOT NULL
BEGIN
IF ISNULL(@DescuentoTipo, '') <> '$'
SELECT @Importe = @Importe * (1-(@DescuentoLinea/100.0))
SELECT @Importe = @Importe - @DescuentoLinea
END
SELECT @Renglon = @Renglon + 2048, @RenglonID = @RenglonID + 1
IF @Sugerir = 1
INSERT SugerirFacturaNConsumo (Estacion, Renglon, RenglonID, Articulo, SubCuenta, Cantidad, Unidad, Importe) VALUES (@Estacion, @Renglon, @RenglonID, @Articulo, @SubCuenta, @Cantidad, @Unidad, @ImporteLinea)
ELSE BEGIN
IF @VentaMultiAlmacen = 0 AND @Almacen <> @AlmacenEncabezado SELECT @Ok = 20860, @OkRef = @Almacen
IF @Aseguradora IS NOT NULL AND EXISTS(SELECT * FROM SugerirFacturaNConsumo WHERE Estacion = @Estacion AND Renglon = @Renglon AND RenglonID = @RenglonID AND Articulo = @Articulo AND EstaCubierto = 1)
SELECT @VentaID = @FacturaAseguradoraID
ELSE
SELECT @VentaID = @FacturaID
SELECT @Costo = NULL
EXEC spVerCosto @Sucursal, @Empresa, @Proveedor, @Articulo, @SubCuenta, @Unidad, @TipoCosteo, @Moneda, @TipoCambio, @Costo OUTPUT, 0, @Precio = @PrecioNeto
INSERT VentaD (Sucursal,  SucursalOrigen, ID,       Renglon,  RenglonSub, RenglonID,  RenglonTipo,  Almacen,  Posicion,  Articulo,  SubCuenta,  Unidad,  Impuesto1,  Impuesto2,  Impuesto3,  Cantidad,  CantidadInventario,  DescuentoTipo,  DescuentoLinea,  Precio,      Costo,  UEN,  Agente)
VALUES (@Sucursal, @Sucursal,      @VentaID, @Renglon,          0, @RenglonID, @RenglonTipo, @Almacen, @Posicion, @Articulo, @SubCuenta, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3, @Cantidad, @CantidadInventario, @DescuentoTipo, @DescuentoLinea, @PrecioNeto, @Costo, @UEN, @Agente)
IF (@ArtTipo IN ('SERIE', 'VIN') AND (@CfgCosteoSeries = 1 OR @ArtCostoIdentificado = 1)) OR (@ArtTipo IN ('LOTE', 'PARTIDA') AND (@CfgCosteoLotes = 1 OR @ArtCostoIdentificado = 1))
INSERT SerieLoteMov (Empresa,  Modulo, ID,       RenglonID,  Articulo,  SubCuenta,              SerieLote,   ArtCostoInv,  Cantidad,        CantidadAlterna,        Sucursal)
SELECT @Empresa, 'VTAS', @VentaID, @RenglonID, @Articulo, ISNULL(@SubCuenta, ''), s.SerieLote, s.ArtCostoInv, SUM(s.Cantidad), SUM(s.CantidadAlterna), @Sucursal
FROM SerieLoteMov s, Venta v, VentaD d, ListaID l, Art
WHERE v.ID = d.ID AND d.ID = l.ID
AND l.Estacion = @Estacion
AND Art.Articulo = d.Articulo
AND s.Empresa = @Empresa AND s.Modulo = 'VTAS' AND s.ID = v.ID AND s.RenglonID = d.RenglonID AND s.Articulo = @Articulo AND ISNULL(s.SubCuenta, '') = ISNULL(@SubCuenta, '')
AND d.Almacen = @Almacen AND ISNULL(d.Posicion, '') = ISNULL(@Posicion, '') AND d.Articulo = @Articulo AND Art.MonedaCosto = @MonedaCosto AND ISNULL(d.SubCuenta, '') = ISNULL(@SubCuenta, '') AND d.Unidad = @Unidad AND ROUND(d.Impuesto1, 4) = @Impuesto1 AND ROUND(d.Impuesto2, 4) = @Impuesto2 AND ROUND(d.Impuesto3, 4) = @Impuesto3 AND d.DescuentoTipo = @DescuentoTipo AND d.DescuentoLinea = @DescuentoLinea AND d.Precio = @Precio AND ROUND(v.DescuentoGlobal, 10) = ROUND(@DescuentoGlobal, 10) AND ROUND(v.SobrePrecio, 10) = ROUND(@SobrePrecio, 10)
GROUP BY s.SerieLote, s.ArtCostoInv
END
END
FETCH NEXT FROM crNotas INTO @Almacen, @Posicion, @Articulo, @SubCuenta, @RenglonTipo, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3, @Cantidad, @CantidadInventario, @DescuentoTipo, @DescuentoLinea, @Precio, @ImporteLinea, @DescuentoGlobal, @SobrePrecio, @MonedaCosto, @ArtTipo, @ArtCostoIdentificado
END 
CLOSE crNotas
DEALLOCATE crNotas
IF @Sugerir = 1
EXEC spSugerirFacturaNConsumo @Estacion, @Empresa, @CteCNO, @Moneda, @TipoCambio, @Renglon, @RenglonID, @Ok OUTPUT, @OkRef OUTPUT
IF @Sugerir = 0
BEGIN
INSERT #Facturas (ID, FechaEmision) VALUES (@FacturaID, @FacturaFechaEmision)
SELECT @CuantasFacturas = @CuantasFacturas + 1
IF @Aseguradora IS NOT NULL
BEGIN
INSERT VentaD (
Sucursal,  SucursalOrigen, ID,         Renglon,  RenglonSub, RenglonID, RenglonTipo, Almacen,            Articulo, Unidad, Cantidad, CantidadInventario, Precio,                           UEN,  Agente)
SELECT @Sucursal, @Sucursal,      @FacturaID, Renglon,           0, RenglonID, 'N',         @AlmacenEncabezado, Articulo, Unidad, Cantidad, Cantidad,           Importe/NULLIF(ABS(Cantidad), 0), @UEN, @Agente
FROM SugerirFacturaNConsumo
WHERE Estacion = @Estacion AND Extra = 1
INSERT VentaD (
Sucursal,  SucursalOrigen, ID,                    Renglon,  RenglonSub, RenglonID, RenglonTipo, Almacen,            Articulo, Unidad, Cantidad,  CantidadInventario, Precio,                           UEN,  Agente)
SELECT @Sucursal, @Sucursal,      @FacturaAseguradoraID, Renglon,           0, RenglonID, 'N',         @AlmacenEncabezado, Articulo, Unidad, -Cantidad, -Cantidad,          Importe/NULLIF(ABS(Cantidad), 0), @UEN, @Agente
FROM SugerirFacturaNConsumo
WHERE Estacion = @Estacion AND Extra = 1
IF NOT EXISTS(SELECT * FROM VentaD WHERE ID = @FacturaAseguradoraID)
DELETE Venta WHERE ID = @FacturaAseguradoraID
ELSE BEGIN
INSERT #Facturas (ID, FechaEmision) VALUES (@FacturaAseguradoraID, @FacturaFechaEmision)
SELECT @CuantasFacturas = @CuantasFacturas + 1
END
END
END
IF @Sugerir = 0
BEGIN
IF @FacturaAseguradoraID IS NOT NULL
BEGIN
IF NOT EXISTS(SELECT * FROM VentaD WHERE ID = @FacturaAseguradoraID)
BEGIN
DELETE Venta  WHERE ID = @FacturaAseguradoraID
DELETE VentaD WHERE ID = @FacturaAseguradoraID
SELECT @OrigenID = @FacturaAseguradoraID
END
END
IF NOT EXISTS(SELECT * FROM VentaD WHERE ID = @FacturaID)
BEGIN
DELETE Venta  WHERE ID = @FacturaID
DELETE VentaD WHERE ID = @FacturaID
SELECT @OrigenID = @FacturaAseguradoraID
SELECT @FacturaID = NULL
END ELSE
SELECT @OrigenID = @FacturaID
INSERT VentaOrigen (ID, OrigenID, Sucursal, SucursalOrigen)
SELECT @OrigenID, v.ID, @Sucursal, @Sucursal
FROM Venta v, ListaID l
WHERE l.Estacion = @Estacion AND v.ID = l.ID 
DELETE ListaID WHERE Estacion = @Estacion
SELECT @Cuantas = @@ROWCOUNT
END
IF @Sugerir = 0 AND @Ok IS NULL AND (@AsignarConsecutivo = 1 OR (@EstatusVMOS = 'CONCLUIDO' AND @AjusteID IS NULL))
BEGIN
DECLARE crFacturas CURSOR LOCAL FOR
SELECT v.ID
FROM #Facturas t
JOIN Venta v ON v.ID = t.ID
OPEN crFacturas
FETCH NEXT FROM crFacturas INTO @FacturaID
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF @EstatusVMOS = 'CONCLUIDO' SELECT @Accion = 'AFECTAR' ELSE SELECT @Accion = 'CONSECUTIVO'
BEGIN
EXEC spAfectar 'VTAS', @FacturaID, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
SELECT @FacturaMovID = MovID FROM Venta WHERE ID = @FacturaID
END
IF @Ok IN (80030, 80060) SELECT @Ok = NULL, @OkRef = NULL
FETCH NEXT FROM crFacturas INTO @FacturaID
END
CLOSE crFacturas
DEALLOCATE crFacturas
SELECT @LeyendaEstatus = ''
END
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
IF @EnSilencio = 0 AND @Sugerir = 0
BEGIN
SELECT @OkRef = RTRIM(Convert(char, @Cuantas))+' Nota(s) procesadas.'
IF @AjusteID IS NOT NULL SELECT @OkRef = RTRIM(@OkRef)  + '<BR>Se Genero: '+RTRIM(@AjusteMov)+' (por Confirmar) en Inventarios'
IF @FacturaID IS NOT NULL
BEGIN
IF @CuantasFacturas = 1
SELECT @OkRef = RTRIM(@OkRef) + '<BR>Se Genero: '+RTRIM(@FacturaMov)+' '+ISNULL(RTRIM(@FacturaMovID), '')+' '+@LeyendaEstatus
ELSE
SELECT @OkRef = RTRIM(@OkRef) + '<BR>Se Generaron: '+CONVERT(varchar, @CuantasFacturas)+' '+RTRIM(@FacturaMov)+'(s) '+@LeyendaEstatus
END
SELECT @OkRef
END
END ELSE
BEGIN
ROLLBACK TRANSACTION
IF @EnSilencio = 0 AND @Sugerir = 0
SELECT Descripcion+' '+RTRIM(@OkRef)
FROM MensajeLista
WHERE Mensaje = @Ok
END
RETURN
END

