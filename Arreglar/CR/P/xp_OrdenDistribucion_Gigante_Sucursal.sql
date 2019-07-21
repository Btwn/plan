SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xp_OrdenDistribucion_Gigante_Sucursal
@Plantilla		varchar(50),
@Direccion		varchar(255),
@Empresa		char(5),
@Usuario		char(10),
@Estacion		int,
@EnviarA		int,
@Ok		int		OUTPUT,
@OkRef		varchar(255)	OUTPUT
AS BEGIN
DECLARE
@Clave 			varchar(100),
@Campo			varchar(50),
@Dato			varchar(100),
@PlantillaTipo		varchar(50),
@Encabezado			bit,
@p				int,
@ID				int,
@OrigenTipo			char(10),
@Modulo			char(5),
@Icono			int,
@Mov			varchar(20),
@Estatus			char(15),
@Prioridad			char(10),
@FechaEmision		datetime,
@FechaRequerida		datetime,
@FechaOriginal		datetime,
@FechaOrdenCompra		datetime,
@Descuento			varchar(30),
@DescuentoGlobal		float,
@Almacen			char(10),
@CtaDinero			char(10),
@Concepto			varchar(50),
@Proyecto			varchar(50),
@Moneda			char(10),
@TipoCambio			float,
@Referencia			varchar(50),
@Observaciones		varchar(100),
@OrdenCompra		varchar(50),
@Cliente			char(10),
@Agente 			char(10),
@FormaEnvio 		varchar(50),
@Condicion 			varchar(50),
@Vencimiento		datetime,
@ListaPreciosEsp		varchar(20),
@ZonaImpuesto		varchar(30),
@Atencion			varchar(50),
@Situacion			varchar(50),
@SituacionFecha		datetime,
@Departamento		int,
@ServicioTipo		varchar(50),
@ServicioArticulo		varchar(20),
@ServicioSerie		varchar(20),
@ServicioContrato		varchar(20),
@ServicioContratoID	   	int,
@ServicioContratoTipo  	varchar(50),
@ServicioGarantia	   	bit,
@ServicioDescripcion   	varchar(100),
@ServicioFecha	   	datetime,
@ServicioIdentificador 	varchar(20),
@Articulo			char(20),
@SubCuenta			varchar(20),
@Unidad			varchar(50),
@Cantidad			float,
@Factor			float,
@CantidadInventario		float,
@Precio			money,
@Costo			money,
@DescuentoLinea		money,
@DescripcionExtra		varchar(100),
@SustitutoArticulo  	varchar(20),
@SustitutoSubCuenta		varchar(20),
@Instruccion		varchar(50),
@Paquete			int,
@Veces			float,
@Renglon			float,
@RenglonID			int,
@RenglonTipo		char(1),
@ArtTipo			varchar(20),
@Impuesto1			float,
@Impuesto2			float,
@Impuesto3			money
SELECT @Encabezado 	= 1,
@Renglon    	= 0.0,
@Factor	= 1.0,
@Modulo        = 'VTAS',
@Icono		= 51,
@OrigenTipo 	= 'Excel',
@Estatus 	= 'CONFIRMAR',
@Prioridad     = 'Normal',
@FechaEmision 	= GETDATE()
EXEC spExtraerFecha @FechaEmision OUTPUT
SELECT @Mov           = Mov,
@Cliente       = Cliente,
@Almacen       = Almacen,
@PlantillaTipo = Tipo
FROM Excel
WHERE Plantilla = @Plantilla
IF @@ROWCOUNT = 0 SELECT @Ok = 72020
IF @Cliente IS NOT NULL
SELECT @Proyecto        = Proyecto,
@Agente          = Agente,
@FormaEnvio      = FormaEnvio,
@Condicion       = Condicion,
@Descuento       = Descuento,
@ListaPreciosEsp = ListaPreciosEsp,
@ZonaImpuesto    = ZonaImpuesto,
@Moneda          = DefMoneda
FROM Cte
WHERE Cliente = @Cliente
ELSE SELECT @Ok = 72030
DECLARE crListaSt CURSOR FOR
SELECT NULLIF(RTRIM(LTRIM(Clave)), '') FROM ListaSt WHERE Estacion = @Estacion
OPEN crListaSt
FETCH NEXT FROM crListaSt INTO @Clave
IF @Clave <> +'['+@Plantilla+']' SELECT @Ok = 72010
FETCH NEXT FROM crListaSt INTO @Clave
WHILE @@FETCH_STATUS <> -1 AND @Clave IS NOT NULL AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @p = CHARINDEX('=', @Clave)
IF @p > 0
BEGIN
SELECT @Campo = RTRIM(SUBSTRING(@Clave, 1, @p-1)),
@Dato  = RTRIM(SUBSTRING(@Clave, @p+1, LEN(@Clave)-@p))
IF @Encabezado = 1
EXEC xp_VentaCamposEncabezado @Campo, @Dato,
@FechaEmision OUTPUT, @FechaRequerida OUTPUT, @FechaOriginal OUTPUT, 	@FechaOrdenCompra OUTPUT, 	@SituacionFecha OUTPUT, @Vencimiento OUTPUT,
@Departamento OUTPUT, @EnviarA OUTPUT, 	@Cliente OUTPUT, 	@Moneda OUTPUT, 		@Almacen OUTPUT, 	@Agente OUTPUT,
@CtaDinero OUTPUT, 	@Prioridad OUTPUT, 	@Concepto OUTPUT, 	@Proyecto, 			@FormaEnvio OUTPUT, 	@ListaPreciosEsp OUTPUT,
@OrdenCompra OUTPUT, 	@Condicion OUTPUT, 	@Descuento OUTPUT, 	@ZonaImpuesto OUTPUT, 		@Atencion OUTPUT,
@Situacion OUTPUT, 	@Referencia OUTPUT, 	@Observaciones OUTPUT,
@ServicioTipo OUTPUT,		@ServicioArticulo OUTPUT,	@ServicioSerie OUTPUT, 		@ServicioDescripcion OUTPUT, 	@ServicioIdentificador OUTPUT,
@ServicioContrato OUTPUT, 	@ServicioContratoTipo OUTPUT, 	@ServicioContratoID OUTPUT, 	@ServicioGarantia OUTPUT, 	@ServicioFecha OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
BEGIN
IF @Campo = 'Clave Artículo'
BEGIN
EXEC xp_ValidarCodigoBarras @Dato, @Articulo OUTPUT, @SubCuenta OUTPUT, @Unidad OUTPUT, @Veces OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC xp_ValidarArticulo @Articulo, @SubCuenta, @ZonaImpuesto, @ArtTipo OUTPUT, @RenglonTipo OUTPUT, @Impuesto1 OUTPUT, @Impuesto2 OUTPUT, @Impuesto3 OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END ELSE
IF dbo.fnEsNumerico(SUBSTRING(@Campo, 1, 3)) = 1 AND CONVERT(int, SUBSTRING(@Campo, 1, 3)) = @EnviarA
SELECT @Cantidad = CONVERT(float, @Dato)
END
END ELSE
IF SUBSTRING(@Clave, 1, 1) = '[' AND SUBSTRING(@Clave, Len(@Clave), 1) = ']'
BEGIN
IF @Encabezado = 1
BEGIN
IF @EnviarA IS NOT NULL AND NOT EXISTS(SELECT * FROM CteEnviarA WHERE Cliente = @Cliente AND ID = @EnviarA) SELECT @Ok = 72060, @OkRef = LTRIM(CONVERT(char, @EnviarA))
IF @Ok IS NULL
BEGIN
SELECT @TipoCambio = TipoCambio      FROM Mon       WHERE Moneda = @Moneda
SELECT @DescuentoGlobal = Porcentaje FROM Descuento WHERE Descuento = @Descuento
SELECT @ServicioGarantia = ISNULL(@ServicioGarantia, 0)
INSERT Venta ( OrigenTipo, Empresa,  Usuario,  Estatus,  Mov,  FechaEmision,   Directo, Almacen,  Concepto,  Proyecto,  Moneda,  TipoCambio,  Referencia,  Observaciones,  Prioridad,  Cliente,  EnviarA,  Agente,  FormaEnvio,  FechaRequerida,  FechaOriginal,  FechaOrdenCompra,  OrdenCompra,  Condicion,  Vencimiento,  CtaDinero,  Descuento,  DescuentoGlobal, ServicioTipo,  ServicioArticulo,  ServicioSerie,  ServicioContrato,  ServicioContratoID,  ServicioContratoTipo,  ServicioGarantia,   ServicioDescripcion,  ServicioIdentificador,  ServicioFecha, Atencion,  Departamento,  ZonaImpuesto,  ListaPreciosEsp,  Situacion,  SituacionFecha)
VALUES (@OrigenTipo, @Empresa, @Usuario, @Estatus, @Mov, @FechaEmision,  1,       @Almacen, @Concepto, @Proyecto, @Moneda, @TipoCambio, @Referencia, @Observaciones, @Prioridad, @Cliente, @EnviarA, @Agente, @FormaEnvio, @FechaRequerida, @FechaOriginal, @FechaOrdenCompra, @OrdenCompra, @Condicion, @Vencimiento, @CtaDinero, @Descuento, @DescuentoGlobal, @ServicioTipo, @ServicioArticulo, @ServicioSerie, @ServicioContrato, @ServicioContratoID, @ServicioContratoTipo, @ServicioGarantia, @ServicioDescripcion, @ServicioIdentificador, @ServicioFecha, @Atencion, @Departamento, @ZonaImpuesto, @ListaPreciosEsp, @Situacion, @SituacionFecha)
SELECT @ID = SCOPE_IDENTITY()
INSERT AnexoMov (Rama, ID, Nombre, Direccion, Icono, Tipo)
VALUES (@Modulo, @ID, @PlantillaTipo, @Direccion, @Icono, 'Archivo')
SELECT @Encabezado = 0
END
END ELSE
BEGIN
IF @Articulo IS NOT NULL AND @Cantidad > 0
BEGIN
EXEC xp_ValidarVentaD @Articulo, @Moneda, @ListaPreciosEsp, @Veces, @Precio OUTPUT, @Renglon OUTPUT, @RenglonID OUTPUT, @Cantidad OUTPUT, @CantidadInventario OUTPUT, @Factor OUTPUT
INSERT VentaD (ID,  Renglon,  RenglonSub, RenglonID,  RenglonTipo,  Almacen,  Articulo,  SubCuenta,  Unidad,  Impuesto1,  Impuesto2,  Impuesto3,  Cantidad,   DescuentoLinea,  Precio, Costo,   FechaRequerida,  Agente,  Departamento,  DescripcionExtra,  SustitutoArticulo,  SustitutoSubCuenta,  Instruccion,  Factor,  CantidadInventario,  Paquete)
VALUES (@ID, @Renglon, 0,          @RenglonID, @RenglonTipo, @Almacen, @Articulo, @SubCuenta, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3, @Cantidad, @DescuentoLinea, @Precio, @Costo, @FechaRequerida, @Agente, @Departamento, @DescripcionExtra, @SustitutoArticulo, @SustitutoSubCuenta, @Instruccion, @Factor, @CantidadInventario, @Paquete)
END
SELECT @Articulo = NULL, @SubCuenta = NULL, @Cantidad = NULL, @CantidadInventario = NULL, @Factor = 1.0, @Precio = NULL, @Costo = NULL
END
END
END
FETCH NEXT FROM crListaSt INTO @Clave
END  
IF @Articulo IS NOT NULL AND @Cantidad > 0
BEGIN
EXEC xp_ValidarVentaD @Articulo, @Moneda, @ListaPreciosEsp, @Veces, @Precio OUTPUT, @Renglon OUTPUT, @RenglonID OUTPUT, @Cantidad OUTPUT, @CantidadInventario OUTPUT, @Factor OUTPUT
INSERT VentaD (ID,  Renglon,  RenglonSub, RenglonID,  RenglonTipo,  Almacen,  Articulo,  SubCuenta,  Unidad,  Impuesto1,  Impuesto2,  Impuesto3,  Cantidad,   DescuentoLinea,  Precio, Costo,   FechaRequerida,  Agente,  Departamento,  DescripcionExtra,  SustitutoArticulo,  SustitutoSubCuenta,  Instruccion,  Factor,  CantidadInventario,  Paquete)
VALUES (@ID, @Renglon, 0,          @RenglonID, @RenglonTipo, @Almacen, @Articulo, @SubCuenta, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3, @Cantidad, @DescuentoLinea, @Precio, @Costo, @FechaRequerida, @Agente, @Departamento, @DescripcionExtra, @SustitutoArticulo, @SustitutoSubCuenta, @Instruccion, @Factor, @CantidadInventario, @Paquete)
END
CLOSE crListaSt
DEALLOCATE crListaSt
RETURN
END

