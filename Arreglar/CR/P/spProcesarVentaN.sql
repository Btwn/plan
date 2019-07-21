SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spProcesarVentaN]
 @Estacion INT
,@Empresa CHAR(5)
,@FacturaMov CHAR(20)
,@FechaEmision DATETIME
,@Usuario CHAR(10)
,@CteCNO CHAR(10) = NULL
,@EnSilencio BIT = 0
,@Ok INT = NULL OUTPUT
,@OkRef VARCHAR(255) = NULL OUTPUT
,@DevolucionMov CHAR(20) = NULL
,@Sucursal INT = NULL
AS
BEGIN
	DECLARE
		@TipoCosteo VARCHAR(20)
	   ,@VentaMultiAlmacen BIT
	   ,@FacturaID INT
	   ,@FacturaFechaEmision DATETIME
	   ,@FacturaMovID VARCHAR(20)
	   ,@NotaID INT
	   ,@AjusteID INT
	   ,@Cuantas INT
	   ,@CuantasFacturas INT
	   ,@CuantasDevoluciones INT
	   ,@Cliente CHAR(10)
	   ,@EnviarA INT
	   ,@ClienteVMOS CHAR(10)
	   ,@VentaEstatus CHAR(15)
	   ,@EstatusVMOS CHAR(15)
	   ,@AlmacenEncabezado CHAR(10)
	   ,@Almacen CHAR(10)
	   ,@Posicion CHAR(10)
	   ,@ArtTipo CHAR(20)
	   ,@Moneda CHAR(10)
	   ,@TipoCambio FLOAT
	   ,@Concepto VARCHAR(50)
	   ,@Articulo CHAR(20)
	   ,@SubCuenta VARCHAR(50)
	   ,@Unidad VARCHAR(50)
	   ,@Factor FLOAT
	   ,@Cantidad FLOAT
	   ,@CantidadInventario FLOAT
	   ,@Disponible FLOAT
	   ,@MonedaCosto CHAR(10)
	   ,@Costo FLOAT
	   ,@Precio FLOAT
	   ,@PrecioNeto FLOAT
	   ,@Proveedor CHAR(10)
	   ,@DescuentoTipo CHAR(1)
	   ,@DescuentoLinea FLOAT
	   ,@DescuentoGlobal FLOAT
	   ,@SobrePrecio FLOAT
	   ,@Impuesto1 FLOAT
	   ,@Impuesto2 FLOAT
	   ,@Impuesto3 MONEY
	   ,@Renglon FLOAT
	   ,@RenglonID INT
	   ,@FactorCosto FLOAT
	   ,@TipoCambioCosto FLOAT
	   ,@ImporteTotal MONEY
	   ,@Agente CHAR(10)
	   ,@UEN INT
	   ,@CfgCosteoNivelSubCuenta BIT
	   ,@AjusteMov CHAR(20)
	   ,@AjusteMovID VARCHAR(20)
	   ,@Condicion VARCHAR(50)
	   ,@FechaRegistro DATETIME
	   ,@LeyendaEstatus VARCHAR(50)
	   ,@CerrarSucursalAuto BIT
	   ,@CfgCosteoSeries BIT
	   ,@CfgCosteoLotes BIT
	   ,@ArtCostoIdentificado BIT
	   ,@SeriesLotesAutoOrden VARCHAR(20)
	   ,@AsignarConsecutivo BIT
	   ,@Accion CHAR(20)
	   ,@LotesFijos BIT
	   ,@Lote VARCHAR(50)
	   ,@RenglonTipo CHAR(1)
	   ,@PrecioMonedaD VARCHAR(10)
	   ,@PrecioTipoCambioD FLOAT
	   ,@CantidadObsequio FLOAT
	   ,@OfertaID INT
	   ,@PrecioSugerido FLOAT
	   ,@DescuentoImporte MONEY
	   ,@Puntos FLOAT
	   ,@Comision FLOAT
	   ,@CantidadAjusteLote FLOAT
	   ,@GenerarNCAlProcesar BIT
	   ,@DevolucionID INT
	   ,@DevolucionMovID VARCHAR(20)
	   ,@CfgAnticipoArticuloServicio VARCHAR(20)
	   ,@ArtOfertaFP VARCHAR(20)
	   ,@ArtOfertaImporte VARCHAR(20)
	   ,@CFDEmpresa VARCHAR(5)
	   ,@CFDID INT
	   ,@CFDModulo VARCHAR(5)
	   ,@CFDMov VARCHAR(20)
	   ,@CFDMovID VARCHAR(20)
	   ,@CFDEstatusNuevo VARCHAR(15)
	   ,@FacturaEstatus VARCHAR(15)
	   ,@DevolucionEstatus VARCHAR(15)
	   ,@FacturaGlobalPeriodo BIT
	   ,@FacturaFechaEmisionInicio DATETIME
	   ,@ZonaImpuesto VARCHAR(20)
	   ,@ContUso VARCHAR(20)
	   ,@ContUso2 VARCHAR(20)
	   ,@ContUso3 VARCHAR(20)
	   ,@SerieLote VARCHAR(50)
	   ,@ListaID INT
	   ,@ExisteSerieLote BIT
	   ,@ArtRedondeo VARCHAR(20)
	DECLARE
		@TablaCFD TABLE (
			Empresa VARCHAR(5)
		   ,Modulo VARCHAR(5)
		   ,Mov VARCHAR(20)
		   ,MovID VARCHAR(20)
		   ,ID INT
		   ,EstatusNuevo VARCHAR(15)
		)
	SELECT @ArtRedondeo = Articulo
	FROM Art
	WHERE Articulo = (
		SELECT RedondeoVentaCodigo
		FROM POSCfg
		WHERE Empresa = @Empresa
	)
	SET @FacturaGlobalPeriodo = 0

	IF NOT EXISTS (SELECT * FROM ListaID WHERE Estacion = @Estacion)
		OR ((
			SELECT Clave
			FROM MovTipo
			WHERE Modulo = 'VTAS'
			AND Mov = @FacturaMov
		)
		<> 'VTAS.F')
	BEGIN
		SELECT NULL
		RETURN
	END

	SELECT @ArtOfertaFP = ArtOfertaFP
		  ,@ArtOfertaImporte = ArtOfertaImporte
	FROM POSCfg
	WHERE Empresa = @Empresa
	SELECT @CfgAnticipoArticuloServicio = NULLIF(CxcAnticipoArticuloServicio, '')
	FROM EmpresaCfg2
	WHERE Empresa = @Empresa
	SELECT @EnviarA = NULL
		  ,@NotaID = NULL
		  ,@AjusteID = NULL
		  ,@ImporteTotal = 0.0
		  ,@Condicion = NULL
		  ,@FacturaMovID = NULL
		  ,@FechaRegistro = GETDATE()
		  ,@LeyendaEstatus = ''
		  ,@Agente = NULL
		  ,@UEN = NULL
		  ,@Proveedor = NULL
		  ,@CuantasFacturas = 0
	SELECT @AjusteMov = InvAjuste
	FROM EmpresaCfgMov
	WHERE Empresa = @Empresa
	SELECT @CfgCosteoNivelSubCuenta = CosteoNivelSubCuenta
		  ,@ClienteVMOS = NULLIF(RTRIM(ClienteFacturaVMOS), '')
		  ,@EstatusVMOS = ISNULL(NULLIF(RTRIM(EstatusFacturaVMOS), ''), 'BORRADOR')
		  ,@AsignarConsecutivo = ISNULL(AsignarConsecutivoFacturaVMOS, 0)
		  ,@TipoCosteo = ISNULL(NULLIF(RTRIM(UPPER(TipoCosteo)), ''), 'PROMEDIO')
		  ,@CfgCosteoSeries = ISNULL(CosteoSeries, 0)
		  ,@CfgCosteoLotes = ISNULL(CosteoLotes, 0)
		  ,@SeriesLotesAutoOrden = UPPER(SeriesLotesAutoOrden)
		  ,@GenerarNCAlProcesar = ISNULL(GenerarNCAlProcesar, 0)
	FROM EmpresaCfg
	WHERE Empresa = @Empresa
	SELECT @VentaEstatus = @EstatusVMOS

	IF @EstatusVMOS = 'CONCLUIDO'
		SELECT @VentaEstatus = 'BORRADOR'

	IF @VentaEstatus = 'BORRADOR'
		SELECT @LeyendaEstatus = ' (Borrador)'
	ELSE

	IF @VentaEstatus = 'CONFIRMAR'
		SELECT @LeyendaEstatus = ' (por Confirmar)'
	ELSE

	IF @VentaEstatus = 'SINAFECTAR'
		SELECT @LeyendaEstatus = ' (Sin Afectar)'

	SELECT @VentaMultiAlmacen = VentaMultiAlmacen
	FROM EmpresaCfg2
	WHERE Empresa = @Empresa

	IF @Sucursal IS NULL
		SELECT @Sucursal = Sucursal
		FROM UsuarioSucursal
		WHERE Usuario = @Usuario

	SELECT @CerrarSucursalAuto = CerrarSucursalAuto
	FROM EmpresaGral
	WHERE Empresa = @Empresa
	EXEC spExtraerFecha @FechaEmision OUTPUT
	DECLARE
		crLista
		CURSOR FOR
		SELECT ID
		FROM ListaID
		WHERE Estacion = @Estacion
	OPEN crLista
	FETCH NEXT FROM crLista INTO @NotaID
	CLOSE crLista
	DEALLOCATE crLista

	IF @NotaID IS NULL
	BEGIN
		SELECT @Ok = 10160

		IF @EnSilencio = 1
			RETURN

	END

	IF EXISTS (SELECT * FROM Inv WHERE Empresa = @Empresa AND Estatus = 'CONFIRMAR' AND OrigenTipo = 'VMOS' AND Sucursal = @Sucursal)
	BEGIN
		SELECT @Ok = 10170

		IF @EnSilencio = 1
			RETURN

	END

	SELECT @ImporteTotal = SUM(ISNULL(Importe, 0.0) + ISNULL(Impuestos, 0.0))
	FROM Venta v
		,ListaID l
	WHERE v.ID = l.ID
	AND l.Estacion = @Estacion

	IF @ImporteTotal < 0.0
		AND @GenerarNCAlProcesar = 0
	BEGIN
		SELECT @Ok = 10180

		IF @EnSilencio = 1
			RETURN

	END

	SELECT @AlmacenEncabezado = Almacen
		  ,@Cliente = ISNULL(@CteCNO, ISNULL(@ClienteVMOS, Cliente))
		  ,@Moneda = Moneda
		  ,@TipoCambio = TipoCambio
		  ,@Concepto = Concepto
		  ,@ZonaImpuesto = ZonaImpuesto
	FROM Venta
	WHERE ID = @NotaID

	IF @CteCNO IS NOT NULL
	BEGIN
		SELECT @Cliente = ISNULL(NULLIF(RTRIM(FacturarCte), ''), Cliente)
			  ,@EnviarA = FacturarCteEnviarA
			  ,@Condicion = Condicion
			  ,@Agente = Agente
		FROM Cte
		WHERE Cliente = @CteCNO
		SELECT @UEN = UEN
		FROM Usuario
		WHERE Usuario = @Usuario
	END

	SELECT @FacturaGlobalPeriodo = FacturaGlobalPeriodo
	FROM Empresacfg
	WHERE Empresa = @Empresa
	CREATE TABLE #Facturas (
		ID INT NULL
	   ,FechaEmision DATETIME NULL
	)
	CREATE TABLE #Devoluciones (
		ID INT NULL
	   ,FechaEmision DATETIME NULL
	)
	BEGIN TRANSACTION
	DECLARE
		crFechaEmision
		CURSOR LOCAL FOR
		SELECT DISTINCT CASE
							WHEN @FacturaGlobalPeriodo = 1 THEN (CASE
									WHEN MONTH(FechaEmision) = MONTH(GETDATE()) THEN GETDATE()
									ELSE (DATEADD(DAY, -1, LEFT(CONVERT(VARCHAR(8), DATEADD(MONTH, 1, FechaEmision), 112), 6) + '01'))
								END)
							ELSE FechaEmision
						END
					   ,Sucursal
		FROM Venta v
			,ListaID l
		WHERE l.Estacion = @Estacion
		AND v.ID = l.ID
	OPEN crFechaEmision
	FETCH NEXT FROM crFechaEmision INTO @FacturaFechaEmision, @Sucursal
	WHILE @@FETCH_STATUS = 0
	AND @Ok IS NULL
	BEGIN

	IF @FacturaGlobalPeriodo = 1
		SET @FacturaFechaEmisionInicio = CAST('01' + '/' + CAST(MONTH(@FacturaFechaEmision) AS VARCHAR) + '/' + CAST(YEAR(@FacturaFechaEmision) AS VARCHAR) AS DATETIME)
	ELSE
		SET @FacturaFechaEmisionInicio = @FacturaFechaEmision

	IF @GenerarNCAlProcesar = 0
	BEGIN
		INSERT Venta (Sucursal, SucursalOrigen, Empresa, Mov, FechaEmision, Moneda, TipoCambio, Almacen, Cliente, EnviarA, Condicion, Concepto, Usuario, Estatus, OrigenTipo, Agente, UEN, FormaPagoTipo, ZonaImpuesto)
			VALUES (@Sucursal, @Sucursal, @Empresa, @FacturaMov, @FacturaFechaEmision, @Moneda, @TipoCambio, @AlmacenEncabezado, @Cliente, @EnviarA, @Condicion, @Concepto, @Usuario, @VentaEstatus, 'VMOS', @Agente, @UEN, 'Varios', @ZonaImpuesto)
		SELECT @FacturaID = SCOPE_IDENTITY()
		SELECT @Renglon = 0
			  ,@RenglonID = 0
		DECLARE
			crNotas
			CURSOR LOCAL FOR
			SELECT d.Almacen
				  ,d.Posicion
				  ,d.Articulo
				  ,d.SubCuenta
				  ,d.RenglonTipo
				  ,d.Unidad
				  ,ISNULL(ROUND(d.Impuesto1, 4), 0.0)
				  ,ISNULL(ROUND(d.Impuesto2, 4), 0.0)
				  ,ISNULL(ROUND(d.Impuesto3, 4), 0.0)
				  ,SUM(d.Cantidad)
				  ,SUM(d.CantidadInventario)
				  ,ISNULL(d.DescuentoTipo, '')
				  ,ISNULL(d.DescuentoLinea, 0.0)
				  ,ISNULL(d.Precio, 0.0)
				  ,ISNULL(v.DescuentoGlobal, 0.0)
				  ,Art.MonedaCosto
				  ,Art.Tipo
				  ,Art.CostoIdentificado
				  ,d.PrecioMoneda
				  ,d.PrecioTipoCambio
				  ,d.CantidadObsequio
				  ,d.OfertaID
				  ,d.PrecioSugerido
				  ,d.DescuentoImporte
				  ,d.Puntos
				  ,d.Comision
			FROM Venta v
				,VentaD d
				,ListaID l
				,Art
			WHERE v.ID = d.ID
			AND d.ID = l.ID
			AND CONVERT(CHAR(10), v.FechaEmision, 121) BETWEEN CONVERT(CHAR(10), @FacturaFechaEmisionInicio, 121) AND CONVERT(CHAR(10), @FacturaFechaEmision, 121)
			AND l.Estacion = @Estacion
			AND d.Cantidad < 0.0
			AND Art.Articulo = d.Articulo
			AND d.Articulo <> @ArtRedondeo
			GROUP BY d.Almacen
					,d.Posicion
					,d.Articulo
					,Art.MonedaCosto
					,Art.Tipo
					,Art.CostoIdentificado
					,d.SubCuenta
					,d.RenglonTipo
					,d.Unidad
					,ROUND(d.Impuesto1, 4)
					,ROUND(d.Impuesto2, 4)
					,ROUND(d.Impuesto3, 4)
					,d.DescuentoTipo
					,d.DescuentoLinea
					,d.Precio
					,v.DescuentoGlobal
					,d.PrecioMoneda
					,d.PrecioTipoCambio
					,d.CantidadObsequio
					,d.OfertaID
					,d.PrecioSugerido
					,d.DescuentoImporte
					,d.Puntos
					,d.Comision
			ORDER BY d.Almacen, d.Posicion, d.Articulo, Art.MonedaCosto, Art.Tipo, Art.CostoIdentificado, d.SubCuenta, d.RenglonTipo, d.Unidad, ROUND(d.Impuesto1, 4), ROUND(d.Impuesto2, 4), ROUND(d.Impuesto3, 4), d.DescuentoTipo, d.DescuentoLinea, d.Precio, v.DescuentoGlobal, d.PrecioMoneda, d.PrecioTipoCambio, d.CantidadObsequio, d.OfertaID, d.PrecioSugerido, d.DescuentoImporte, d.Puntos, d.Comision
		OPEN crNotas
		FETCH NEXT FROM crNotas INTO @Almacen, @Posicion, @Articulo, @SubCuenta, @RenglonTipo, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3, @Cantidad, @CantidadInventario, @DescuentoTipo, @DescuentoLinea, @Precio, @DescuentoGlobal, @MonedaCosto, @ArtTipo, @ArtCostoIdentificado, @PrecioMonedaD, @PrecioTipoCambioD, @CantidadObsequio, @OfertaID, @PrecioSugerido, @DescuentoImporte, @Puntos, @Comision
		WHILE @@FETCH_STATUS <> -1
		AND @Ok IS NULL
		BEGIN

		IF @@FETCH_STATUS <> -2
		BEGIN
			IF NULLIF(@DescuentoGlobal, 0) IS NOT NULL
				SELECT @PrecioNeto = @Precio - (@Precio * (@DescuentoGlobal / 100))
			ELSE
				SELECT @PrecioNeto = @Precio

			IF @VentaMultiAlmacen = 0
				AND @Almacen <> @AlmacenEncabezado
				SELECT @Ok = 20860
					  ,@OkRef = @Almacen

			SELECT @Costo = NULL
			EXEC spVerCosto @Sucursal
						   ,@Empresa
						   ,@Proveedor
						   ,@Articulo
						   ,@SubCuenta
						   ,@Unidad
						   ,@TipoCosteo
						   ,@Moneda
						   ,@TipoCambio
						   ,@Costo OUTPUT
						   ,0
						   ,@Precio = @PrecioNeto
			SELECT @Renglon = @Renglon + 2048
				  ,@RenglonID = @RenglonID + 1
			INSERT VentaD (Sucursal, SucursalOrigen, ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Almacen, Posicion, Articulo, SubCuenta, Unidad, Impuesto1, Impuesto2, Impuesto3, Cantidad, CantidadInventario, DescuentoTipo, DescuentoLinea, Precio, Costo, UEN, Agente, PrecioMoneda, PrecioTipoCambio, CantidadObsequio, OfertaID, PrecioSugerido, DescuentoImporte, Puntos, Comision)
				VALUES (@Sucursal, @Sucursal, @FacturaID, @Renglon, 0, @RenglonID, @RenglonTipo, @Almacen, @Posicion, @Articulo, @SubCuenta, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3, @Cantidad, @CantidadInventario, @DescuentoTipo, @DescuentoLinea, @PrecioNeto, @Costo, @UEN, @Agente, @PrecioMonedaD, @PrecioTipoCambioD, @CantidadObsequio, @OfertaID, @PrecioSugerido, @DescuentoImporte, @Puntos, @Comision)

			IF (@ArtTipo IN ('SERIE', 'VIN') AND (@CfgCosteoSeries = 1 OR @ArtCostoIdentificado = 1))
				OR (@ArtTipo IN ('LOTE', 'PARTIDA') AND (@CfgCosteoLotes = 1 OR @ArtCostoIdentificado = 1))
			BEGIN
				INSERT SerieLoteMov (Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, ArtCostoInv, Cantidad, CantidadAlterna, Sucursal, Propiedades)
					SELECT @Empresa
						  ,'VTAS'
						  ,@FacturaID
						  ,@RenglonID
						  ,@Articulo
						  ,ISNULL(@SubCuenta, '')
						  ,s.SerieLote
						  ,s.ArtCostoInv
						  ,SUM(s.Cantidad)
						  ,SUM(s.CantidadAlterna)
						  ,@Sucursal
						  ,ISNULL(s.Propiedades, '')
					FROM SerieLoteMov s
						,Venta v
						,VentaD d
						,ListaID l
						,Art
					WHERE v.ID = d.ID
					AND d.ID = l.ID
					AND CONVERT(CHAR(10), v.FechaEmision, 121) BETWEEN CONVERT(CHAR(10), @FacturaFechaEmisionInicio, 121) AND CONVERT(CHAR(10), @FacturaFechaEmision, 121)
					AND l.Estacion = @Estacion
					AND d.Cantidad < 0.0
					AND Art.Articulo = d.Articulo
					AND s.Empresa = @Empresa
					AND s.Modulo = 'VTAS'
					AND s.ID = v.ID
					AND s.RenglonID = d.RenglonID
					AND s.Articulo = @Articulo
					AND ISNULL(s.SubCuenta, '') = ISNULL(@SubCuenta, '')
					AND d.Almacen = @Almacen
					AND ISNULL(d.Posicion, '') = ISNULL(@Posicion, '')
					AND d.Articulo = @Articulo
					AND Art.MonedaCosto = @MonedaCosto
					AND ISNULL(d.SubCuenta, '') = ISNULL(@SubCuenta, '')
					AND d.Unidad = @Unidad
					AND ISNULL(ROUND(d.Impuesto1, 4), 0.0) = @Impuesto1
					AND ISNULL(ROUND(d.Impuesto2, 4), 0.0) = @Impuesto2
					AND ISNULL(ROUND(d.Impuesto3, 4), 0.0) = @Impuesto3
					AND ISNULL(d.DescuentoTipo, '') = @DescuentoTipo
					AND ISNULL(d.DescuentoLinea, 0.0) = @DescuentoLinea
					AND ISNULL(d.Precio, 0.0) = @Precio
					AND ISNULL(ROUND(v.DescuentoGlobal, 10), 0.0) = ISNULL(ROUND(@DescuentoGlobal, 10), 0.0)
					AND ISNULL(ROUND(v.SobrePrecio, 10), 0.0) = ISNULL(ROUND(@SobrePrecio, 10), 0.0)
					GROUP BY s.SerieLote
							,s.ArtCostoInv
							,s.Propiedades
				SELECT @Costo = ISNULL(SUM(m.Cantidad * ISNULL(s.CostoPromedio * Mon.TipoCambio, 0.0)) / NULLIF(SUM(m.Cantidad), 0.0), 0.0) / @TipoCambio
				FROM SerieLoteMov m
					,SerieLote s
					,Art a
					,Mon
				WHERE m.Empresa = @Empresa
				AND m.Modulo = 'VTAS'
				AND m.ID = @FacturaID
				AND m.RenglonID = @RenglonID
				AND m.Articulo = @Articulo
				AND m.SubCuenta = ISNULL(@SubCuenta, '')
				AND s.Empresa = @Empresa
				AND s.Articulo = @Articulo
				AND s.SubCuenta = ISNULL(@SubCuenta, '')
				AND s.SerieLote = m.SerieLote
				AND s.Sucursal = @Sucursal
				AND s.Almacen = @Almacen
				AND a.Articulo = @Articulo
				AND Mon.Moneda = a.MonedaCosto
				UPDATE SerieLoteMov
				SET ArtCostoInv = s.CostoPromedio
				FROM SerieLoteMov m, SerieLote s
				WHERE m.Empresa = @Empresa
				AND m.Modulo = 'VTAS'
				AND m.ID = @FacturaID
				AND m.RenglonID = @RenglonID
				AND m.Articulo = @Articulo
				AND m.SubCuenta = ISNULL(@SubCuenta, '')
				AND s.Empresa = @Empresa
				AND s.Articulo = @Articulo
				AND s.SubCuenta = ISNULL(@SubCuenta, '')
				AND s.SerieLote = m.SerieLote
				AND s.Sucursal = @Sucursal
				AND s.Almacen = @Almacen
				UPDATE VentaD
				SET Costo = @Costo
				WHERE ID = @FacturaID
				AND Renglon = @Renglon
				AND RenglonSub = 0
			END

		END

		FETCH NEXT FROM crNotas INTO @Almacen, @Posicion, @Articulo, @SubCuenta, @RenglonTipo, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3, @Cantidad, @CantidadInventario, @DescuentoTipo, @DescuentoLinea, @Precio, @DescuentoGlobal, @SobrePrecio, @MonedaCosto, @ArtTipo, @ArtCostoIdentificado, @PrecioMonedaD, @PrecioTipoCambioD, @CantidadObsequio, @OfertaID, @PrecioSugerido, @DescuentoImporte, @Puntos, @Comision
		END
		CLOSE crNotas
		DEALLOCATE crNotas
		DECLARE
			crNotas
			CURSOR LOCAL FOR
			SELECT d.Almacen
				  ,d.Posicion
				  ,d.Articulo
				  ,d.SubCuenta
				  ,d.RenglonTipo
				  ,d.Unidad
				  ,ISNULL(ROUND(d.Impuesto1, 4), 0.0)
				  ,ISNULL(ROUND(d.Impuesto2, 4), 0.0)
				  ,ISNULL(ROUND(d.Impuesto3, 4), 0.0)
				  ,SUM(d.Cantidad)
				  ,SUM(d.CantidadInventario)
				  ,ISNULL(d.DescuentoTipo, '')
				  ,ISNULL(d.DescuentoLinea, 0.0)
				  ,ISNULL(d.Precio, 0.0)
				  ,ISNULL(v.DescuentoGlobal, 0.0)
				  ,Art.MonedaCosto
				  ,Art.Tipo
				  ,Art.CostoIdentificado
				  ,d.PrecioMoneda
				  ,d.PrecioTipoCambio
				  ,d.CantidadObsequio
				  ,d.OfertaID
				  ,d.PrecioSugerido
				  ,d.DescuentoImporte
				  ,d.Puntos
				  ,d.Comision
				  ,d.ContUso
				  ,d.ContUso2
				  ,d.ContUso3
				  ,l.ID
			FROM Venta v
				,VentaD d
				,ListaID l
				,Art
			WHERE v.ID = d.ID
			AND d.ID = l.ID
			AND CONVERT(CHAR(10), v.FechaEmision, 121) BETWEEN CONVERT(CHAR(10), @FacturaFechaEmisionInicio, 121) AND CONVERT(CHAR(10), @FacturaFechaEmision, 121)
			AND l.Estacion = @Estacion
			AND d.Cantidad > 0.0
			AND Art.Articulo = d.Articulo
			AND d.Articulo <> @ArtRedondeo
			GROUP BY d.Almacen
					,d.Posicion
					,d.Articulo
					,Art.MonedaCosto
					,Art.Tipo
					,Art.CostoIdentificado
					,d.SubCuenta
					,d.Unidad
					,d.RenglonTipo
					,ROUND(d.Impuesto1, 4)
					,ROUND(d.Impuesto2, 4)
					,ROUND(d.Impuesto3, 4)
					,d.DescuentoTipo
					,d.DescuentoLinea
					,d.Precio
					,v.DescuentoGlobal
					,d.PrecioMoneda
					,d.PrecioTipoCambio
					,d.CantidadObsequio
					,d.OfertaID
					,d.PrecioSugerido
					,d.DescuentoImporte
					,d.Puntos
					,d.Comision
					,d.ContUso
					,d.ContUso2
					,d.ContUso3
					,l.ID
			ORDER BY d.Almacen, d.Posicion, d.Articulo, Art.MonedaCosto, Art.Tipo, Art.CostoIdentificado, d.SubCuenta, d.Unidad, d.RenglonTipo, ROUND(d.Impuesto1, 4), ROUND(d.Impuesto2, 4), ROUND(d.Impuesto3, 4), d.DescuentoTipo, d.DescuentoLinea, d.Precio, v.DescuentoGlobal, d.PrecioMoneda, d.PrecioTipoCambio, d.CantidadObsequio, d.OfertaID, d.PrecioSugerido, d.DescuentoImporte, d.Puntos, d.Comision, d.ContUso, d.ContUso2, d.ContUso3, l.ID
		OPEN crNotas
		FETCH NEXT FROM crNotas INTO @Almacen, @Posicion, @Articulo, @SubCuenta, @RenglonTipo, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3, @Cantidad, @CantidadInventario, @DescuentoTipo, @DescuentoLinea, @Precio, @DescuentoGlobal, @MonedaCosto, @ArtTipo, @ArtCostoIdentificado, @PrecioMonedaD, @PrecioTipoCambioD, @CantidadObsequio, @OfertaID, @PrecioSugerido, @DescuentoImporte, @Puntos, @Comision, @ContUso, @ContUso2, @ContUso3, @ListaID
		WHILE @@FETCH_STATUS <> -1
		AND @Ok IS NULL
		BEGIN

		IF @@FETCH_STATUS <> -2
		BEGIN
			IF NULLIF(@DescuentoGlobal, 0) IS NOT NULL
				SELECT @PrecioNeto = @Precio - (@Precio * (@DescuentoGlobal / 100))
			ELSE
				SELECT @PrecioNeto = @Precio

			IF @VentaMultiAlmacen = 0
				AND @Almacen <> @AlmacenEncabezado
				SELECT @Ok = 20860
					  ,@OkRef = @Almacen

			SELECT @Costo = NULL
			EXEC spVerCosto @Sucursal
						   ,@Empresa
						   ,@Proveedor
						   ,@Articulo
						   ,@SubCuenta
						   ,@Unidad
						   ,@TipoCosteo
						   ,@Moneda
						   ,@TipoCambio
						   ,@Costo OUTPUT
						   ,0
						   ,@Precio = @PrecioNeto
			SELECT @Renglon = @Renglon + 2048
				  ,@RenglonID = @RenglonID + 1
			INSERT VentaD (Sucursal, SucursalOrigen, ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Almacen, Posicion, Articulo, SubCuenta, Unidad, Impuesto1, Impuesto2, Impuesto3, Cantidad, CantidadInventario, DescuentoTipo, DescuentoLinea, Precio, Costo, UEN, Agente, PrecioMoneda, PrecioTipoCambio, CantidadObsequio, OfertaID, PrecioSugerido, DescuentoImporte, Puntos, Comision, ContUso, ContUso2, ContUso3)
				VALUES (@Sucursal, @Sucursal, @FacturaID, @Renglon, 0, @RenglonID, @RenglonTipo, @Almacen, @Posicion, @Articulo, @SubCuenta, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3, @Cantidad, @CantidadInventario, @DescuentoTipo, @DescuentoLinea, @PrecioNeto, @Costo, @UEN, @Agente, @PrecioMonedaD, @PrecioTipoCambioD, @CantidadObsequio, @OfertaID, @PrecioSugerido, @DescuentoImporte, @Puntos, @Comision, @ContUso, @ContUso2, @ContUso3)

			IF (
					SELECT NotasBorrador
					FROM EmpresaCFG
					WHERE Empresa = @Empresa
				)
				= 0
			BEGIN
				SELECT @SerieLote = SerieLote
				FROM SerieLoteMov
				WHERE ID = @ListaID
				AND Empresa = @Empresa
				AND Sucursal = @Sucursal
				AND Modulo = 'VTAS'
				AND Articulo = @Articulo
				AND ISNULL(Subcuenta, '') = ISNULL(@SubCuenta, '')
				SELECT @ExisteSerieLote = 0

				IF EXISTS (SELECT SerieLote FROM SerieLote WHERE Empresa = @Empresa AND Sucursal = @Sucursal AND Almacen = @Almacen AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') AND SerieLote = @SerieLote)
					SELECT @ExisteSerieLote = 1

			END

			IF (@ArtTipo IN ('SERIE', 'VIN') AND (@CfgCosteoSeries = 1 OR @ArtCostoIdentificado = 1))
				OR (@ArtTipo IN ('LOTE', 'PARTIDA') AND (@CfgCosteoLotes = 1 OR @ArtCostoIdentificado = 1))
				OR ((
					SELECT NotasBorrador
					FROM EmpresaCFG
					WHERE Empresa = @Empresa
				)
				= 1 AND @ArtTipo IN ('SERIE', 'LOTE'))
				OR ((
					SELECT NotasBorrador
					FROM EmpresaCFG
					WHERE Empresa = @Empresa
				)
				= 0 AND @ArtTipo IN ('SERIE', 'LOTE') AND @ExisteSerieLote = 1)
				INSERT SerieLoteMov (Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, ArtCostoInv, Cantidad, CantidadAlterna, Sucursal, Propiedades)
					SELECT @Empresa
						  ,'VTAS'
						  ,@FacturaID
						  ,@RenglonID
						  ,@Articulo
						  ,ISNULL(@SubCuenta, '')
						  ,s.SerieLote
						  ,s.ArtCostoInv
						  ,SUM(s.Cantidad)
						  ,SUM(s.CantidadAlterna)
						  ,@Sucursal
						  ,ISNULL(s.Propiedades, '')
					FROM SerieLoteMov s
						,Venta v
						,VentaD d
						,ListaID l
						,Art
					WHERE v.ID = d.ID
					AND d.ID = l.ID
					AND CONVERT(CHAR(10), v.FechaEmision, 121) BETWEEN CONVERT(CHAR(10), @FacturaFechaEmisionInicio, 121) AND CONVERT(CHAR(10), @FacturaFechaEmision, 121)
					AND l.Estacion = @Estacion
					AND d.Cantidad > 0.0
					AND Art.Articulo = d.Articulo
					AND s.Empresa = @Empresa
					AND s.Modulo = 'VTAS'
					AND s.ID = v.ID
					AND s.RenglonID = d.RenglonID
					AND s.Articulo = @Articulo
					AND ISNULL(s.SubCuenta, '') = ISNULL(@SubCuenta, '')
					AND d.Almacen = @Almacen
					AND ISNULL(d.Posicion, '') = ISNULL(@Posicion, '')
					AND d.Articulo = @Articulo
					AND Art.MonedaCosto = @MonedaCosto
					AND ISNULL(d.SubCuenta, '') = ISNULL(@SubCuenta, '')
					AND d.Unidad = @Unidad
					AND ISNULL(ROUND(d.Impuesto1, 4), 0.0) = @Impuesto1
					AND ISNULL(ROUND(d.Impuesto2, 4), 0.0) = @Impuesto2
					AND ISNULL(ROUND(d.Impuesto3, 4), 0.0) = @Impuesto3
					AND ISNULL(d.DescuentoTipo, '') = @DescuentoTipo
					AND ISNULL(d.DescuentoLinea, 0.0) = @DescuentoLinea
					AND ISNULL(d.Precio, 0.0) = @Precio
					AND ISNULL(ROUND(v.DescuentoGlobal, 10), 0.0) = ISNULL(ROUND(@DescuentoGlobal, 10), 0.0)
					AND ISNULL(ROUND(v.SobrePrecio, 10), 0.0) = ISNULL(ROUND(@SobrePrecio, 10), 0.0)
					GROUP BY s.SerieLote
							,s.ArtCostoInv
							,s.Propiedades

		END

		FETCH NEXT FROM crNotas INTO @Almacen, @Posicion, @Articulo, @SubCuenta, @RenglonTipo, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3, @Cantidad, @CantidadInventario, @DescuentoTipo, @DescuentoLinea, @Precio, @DescuentoGlobal, @SobrePrecio, @MonedaCosto, @ArtTipo, @ArtCostoIdentificado, @PrecioMonedaD, @PrecioTipoCambioD, @CantidadObsequio, @OfertaID, @PrecioSugerido, @DescuentoImporte, @Puntos, @Comision, @ContUso, @ContUso2, @ContUso3, @ListaID
		END
		CLOSE crNotas
		DEALLOCATE crNotas
		INSERT VentaOrigen (ID, OrigenID, Sucursal, SucursalOrigen)
			SELECT @FacturaID
				  ,v.ID
				  ,@Sucursal
				  ,@Sucursal
			FROM Venta v
				,ListaID l
			WHERE l.Estacion = @Estacion
			AND v.ID = l.ID
			AND CONVERT(CHAR(10), v.FechaEmision, 121) BETWEEN CONVERT(CHAR(10), @FacturaFechaEmisionInicio, 121) AND CONVERT(CHAR(10), @FacturaFechaEmision, 121)
		INSERT #Facturas (ID, FechaEmision)
			VALUES (@FacturaID, @FacturaFechaEmision)
		SELECT @CuantasFacturas = @CuantasFacturas + 1
	END
	ELSE
	BEGIN

		IF EXISTS (SELECT * FROM Venta v JOIN VentaD d ON v.ID = d.ID JOIN ListaID l ON l.ID = v.ID AND l.Estacion = @Estacion WHERE v.ID = d.ID AND d.ID = l.ID AND (CONVERT(CHAR(10), v.FechaEmision, 121) BETWEEN CONVERT(CHAR(10), @FacturaFechaEmisionInicio, 121) AND CONVERT(CHAR(10), @FacturaFechaEmision, 121)) AND l.Estacion = @Estacion AND ((d.Cantidad < 0.0) AND d.Articulo NOT IN (@CfgAnticipoArticuloServicio, @ArtOfertaFP, @ArtOfertaImporte)) AND d.ProcesadoID IS NULL)
			EXEC spVentasProcesarNCredito @Estacion
										 ,@Empresa
										 ,@Sucursal
										 ,@FacturaMov
										 ,@DevolucionMov
										 ,@FechaEmision
										 ,@Usuario
										 ,@Moneda
										 ,@TipoCambio
										 ,@AlmacenEncabezado
										 ,@Cliente
										 ,@EnviarA
										 ,@Condicion
										 ,@Concepto
										 ,@Agente
										 ,@UEN
										 ,@CfgCosteoSeries
										 ,@CfgCosteoLotes
										 ,@VentaMultiAlmacen
										 ,@VentaEstatus
										 ,@CteCNO
										 ,@EnSilencio
										 ,@FacturaFechaEmision
										 ,@FacturaFechaEmisionInicio
										 ,@Ok OUTPUT
										 ,@OkRef OUTPUT

		IF EXISTS (SELECT * FROM Venta v JOIN VentaD d ON v.ID = d.ID JOIN ListaID l ON l.ID = v.ID AND l.Estacion = @Estacion WHERE v.ID = d.ID AND d.ID = l.ID AND (CONVERT(CHAR(10), v.FechaEmision, 121) BETWEEN CONVERT(CHAR(10), @FacturaFechaEmisionInicio, 121) AND CONVERT(CHAR(10), @FacturaFechaEmision, 121)) AND l.Estacion = @Estacion AND ((d.Cantidad > 0.0) OR d.Articulo IN (@CfgAnticipoArticuloServicio, @ArtOfertaFP, @ArtOfertaImporte)) AND d.ProcesadoID IS NULL)
			EXEC spVentasProcesarN2 @Estacion
								   ,@Empresa
								   ,@Sucursal
								   ,@FacturaMov
								   ,@DevolucionMov
								   ,@FechaEmision
								   ,@Usuario
								   ,@Moneda
								   ,@TipoCambio
								   ,@AlmacenEncabezado
								   ,@Cliente
								   ,@EnviarA
								   ,@Condicion
								   ,@Concepto
								   ,@Agente
								   ,@UEN
								   ,@CfgCosteoSeries
								   ,@CfgCosteoLotes
								   ,@VentaMultiAlmacen
								   ,@VentaEstatus
								   ,@CteCNO
								   ,@EnSilencio
								   ,@FacturaFechaEmision
								   ,@FacturaFechaEmisionInicio
								   ,@Ok OUTPUT
								   ,@OkRef OUTPUT

	END

	FETCH NEXT FROM crFechaEmision INTO @FacturaFechaEmision, @Sucursal
	END
	CLOSE crFechaEmision
	DEALLOCATE crFechaEmision
	CREATE TABLE #tmpAjuste (
		Id INT IDENTITY (1, 1) NOT NULL
	   ,Estacion INT NULL
	   ,Almacen VARCHAR(20) COLLATE DATABASE_DEFAULT NULL
	   ,Articulo VARCHAR(20) COLLATE DATABASE_DEFAULT NULL
	   ,Subcuenta VARCHAR(20) COLLATE DATABASE_DEFAULT NULL
	   ,Disponible FLOAT NULL
	   ,Unidad VARCHAR(50) COLLATE DATABASE_DEFAULT NULL
	   ,Lotesfijos BIT NOT NULL DEFAULT 0
	)
	INSERT INTO #tmpAjuste (Estacion, Almacen, Articulo, Subcuenta, Disponible, Unidad, lotesFijos)
		SELECT @Estacion
			  ,d.Almacen
			  ,d.Articulo
			  ,NULLIF(RTRIM(d.SubCuenta), '')
			  ,ROUND(d.Disponible, 4)
			  ,a.Unidad
			  ,ISNULL(a.LotesFijos, 0)
		FROM ArtSubDisponible d
			,Art a
			,Alm
		WHERE a.Articulo = d.Articulo
		AND ROUND(d.Disponible, 4) < 0.0
		AND d.Almacen = alm.Almacen
		AND alm.Sucursal = @Sucursal
		AND d.Empresa = @Empresa

	IF (
			SELECT NotasBorrador
			FROM EmpresaCFG
			WHERE Empresa = @Empresa
		)
		= 1
		INSERT INTO #tmpAjuste (Estacion, Almacen, Articulo, Subcuenta, Disponible, Unidad, lotesFijos)
			SELECT @Estacion
				  ,d.Almacen
				  ,d.Articulo
				  ,NULLIF(RTRIM(d.SubCuenta), '')
				  ,ROUND(SUM(ABS(s.Existencia)), 4)
				  ,a.Unidad
				  ,ISNULL(a.LotesFijos, 0)
			FROM ArtSubDisponible d
			JOIN Art a
				ON a.Articulo = d.Articulo
			JOIN Alm
				ON d.Almacen = alm.Almacen
			JOIN SerieLote s
				ON s.Articulo = a.Articulo
				AND s.Empresa = @Empresa
				AND s.Sucursal = @sucursal
			JOIN SerieLoteMov sm
				ON sm.articulo = s.Articulo
				AND sm.SerieLote = s.SerieLote
				AND sm.Empresa = s.Empresa
				AND sm.Sucursal = s.Sucursal
			JOIN ListaID l
				ON l.ID = sm.ID
				AND l.Estacion = @Estacion
			WHERE ROUND(d.Disponible, 4) >= 0.0
			AND s.Existencia < 0
			AND alm.Sucursal = @Sucursal
			AND d.Empresa = @Empresa
			AND a.Tipo IN ('SERIE', 'LOTE')
			GROUP BY d.Almacen
					,d.Articulo
					,d.Subcuenta
					,a.Unidad
					,a.lotesFijos

	SELECT @Renglon = 0
		  ,@RenglonID = 0
	DECLARE
		crRojo
		CURSOR FOR
		SELECT Almacen
			  ,Articulo
			  ,Subcuenta
			  ,Disponible
			  ,Unidad
			  ,lotesFijos
		FROM #tmpAjuste
		WHERE Estacion = @Estacion
	OPEN crRojo
	FETCH NEXT FROM crRojo INTO @Almacen, @Articulo, @SubCuenta, @Disponible, @Unidad, @LotesFijos
	WHILE @@FETCH_STATUS <> -1
	AND @Ok IS NULL
	BEGIN

	IF @@FETCH_STATUS <> -2
	BEGIN

		IF @Renglon = 0
		BEGIN
			INSERT Inv (Sucursal, SucursalOrigen, Empresa, Mov, FechaEmision, Moneda, TipoCambio, Almacen, Concepto, Usuario, Estatus, OrigenTipo, UEN)
				VALUES (@Sucursal, @Sucursal, @Empresa, @AjusteMov, @FechaEmision, @Moneda, @TipoCambio, @AlmacenEncabezado, @Concepto, @Usuario, 'CONFIRMAR', 'VMOS', @UEN)
			SELECT @AjusteID = SCOPE_IDENTITY()
		END

		SELECT @Lote = NULL
			  ,@Costo = NULL
		SELECT @Factor = ISNULL(Factor, 1)
		FROM Unidad
		WHERE Unidad = @Unidad

		IF @LotesFijos = 1
		BEGIN

			IF @SeriesLotesAutoOrden = 'ASCENDENTE'
				SELECT @Lote = (
					 SELECT TOP 1 Lote
					 FROM ArtLoteFijo
					 WHERE Articulo = @Articulo
					 ORDER BY Lote DESC
				 )
			ELSE
				SELECT @Lote = (
					 SELECT TOP 1 Lote
					 FROM ArtLoteFijo
					 WHERE Articulo = @Articulo
					 ORDER BY Lote
				 )

			SELECT @Lote = NULLIF(RTRIM(@Lote), '')

			IF @Lote IS NOT NULL
				SELECT @Costo = MIN(CostoPromedio) * @Factor
				FROM SerieLote
				WHERE Empresa = @Empresa
				AND Articulo = @Articulo
				AND SubCuenta = ISNULL(@SubCuenta, '')
				AND SerieLote = @Lote
				AND Almacen = @Almacen

		END

		IF @Costo IS NULL
			EXEC spVerCosto @Sucursal
						   ,@Empresa
						   ,@Proveedor
						   ,@Articulo
						   ,@SubCuenta
						   ,@Unidad
						   ,@TipoCosteo
						   ,@Moneda
						   ,@TipoCambio
						   ,@Costo OUTPUT
						   ,0

		SELECT @Renglon = @Renglon + 2048
			  ,@RenglonID = @RenglonID + 1
		INSERT InvD (Sucursal, SucursalOrigen, ID, Renglon, RenglonSub, RenglonID, Almacen, Articulo, SubCuenta, Unidad, Cantidad, CantidadInventario, Costo)
			VALUES (@Sucursal, @Sucursal, @AjusteID, @Renglon, 0, @RenglonID, @Almacen, @Articulo, @SubCuenta, @Unidad, -@Disponible / @Factor, -@Disponible, @Costo)

		IF @LotesFijos = 1
			AND @Lote IS NOT NULL
			INSERT SerieLoteMov (Empresa, Sucursal, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad)
				VALUES (@Empresa, @Sucursal, 'INV', @AjusteID, @RenglonID, @Articulo, ISNULL(@SubCuenta, ''), @Lote, -@Disponible / @Factor)
		ELSE

		IF (
				SELECT NotasBorrador
				FROM EmpresaCFG
				WHERE Empresa = @Empresa
			)
			= 1
			AND @ArtTipo IN ('SERIE', 'LOTE')
		BEGIN
			INSERT SerieLoteMov (Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, ArtCostoInv, Cantidad, CantidadAlterna, Sucursal, Propiedades)
				SELECT @Empresa
					  ,'INV'
					  ,@AjusteID
					  ,@RenglonID
					  ,@Articulo
					  ,ISNULL(@SubCuenta, '')
					  ,s.SerieLote
					  ,s.ArtCostoInv
					  ,SUM(ABS(sl.Existencia))
					  ,SUM(ABS(sl.Existencia))
					  ,@Sucursal
					  ,ISNULL(s.Propiedades, '')
				FROM SerieLoteMov s
				JOIN ListaID l
					ON l.ID = s.ID
					AND l.Estacion = @Estacion
				JOIN Serielote sl
					ON s.articulo = sl.Articulo
					AND s.SerieLote = sl.SerieLote
					AND s.Empresa = sl.Empresa
					AND s.Sucursal = sl.Sucursal
				WHERE s.Empresa = @Empresa
				AND s.Modulo = 'VTAS'
				AND s.Articulo = @Articulo
				AND s.Sucursal = @Sucursal
				AND sl.Existencia < 0
				GROUP BY s.SerieLote
						,s.ArtCostoInv
						,s.Propiedades

			IF EXISTS (SELECT s.ID FROM SerieLoteMov s JOIN ListaID l ON l.ID = s.ID AND l.Estacion = @Estacion JOIN Serielote sl ON s.articulo = sl.Articulo AND s.SerieLote = sl.SerieLote AND s.Empresa = sl.Empresa AND s.Sucursal = sl.Sucursal WHERE s.Empresa = @Empresa AND s.Modulo = 'VTAS' AND s.Articulo = @Articulo AND s.Sucursal = @Sucursal AND sl.Existencia < 0)
			BEGIN
				SELECT @CantidadAjusteLote = NULL
				SELECT @CantidadAjusteLote = SUM(ABS(sl.Existencia))
				FROM SerieLoteMov s
				JOIN Serielote sl
					ON s.articulo = sl.Articulo
					AND s.SerieLote = sl.SerieLote
					AND s.Empresa = sl.Empresa
					AND s.Sucursal = sl.Sucursal
				WHERE s.Empresa = @Empresa
				AND s.Modulo = 'INV'
				AND s.ID = @AjusteID
				AND s.RenglonID = @RenglonID
				AND ISNULL(s.SubCuenta, '') = ISNULL(@SubCuenta, '')
				AND s.Articulo = @Articulo
				AND s.Sucursal = @Sucursal
				AND sl.Existencia < 0
				GROUP BY s.SerieLote
						,s.ArtCostoInv
						,s.Propiedades

				IF @CantidadAjusteLote IS NOT NULL
				BEGIN

					IF NULLIF(-@Disponible / @Factor, 0.0) <> @CantidadAjusteLote
						UPDATE InvD
						SET Cantidad = @CantidadAjusteLote
						WHERE ID = @AjusteID
						AND Renglon = @Renglon
						AND RenglonID = @RenglonID
						AND Articulo = @Articulo

				END

			END

		END

	END

	FETCH NEXT FROM crRojo INTO @Almacen, @Articulo, @SubCuenta, @Disponible, @Unidad, @LotesFijos
	END
	CLOSE crRojo
	DEALLOCATE crRojo
	DELETE ListaID
	WHERE Estacion = @Estacion
	SELECT @Cuantas = @@ROWCOUNT

	IF @CerrarSucursalAuto = 1
		AND @AjusteID IS NOT NULL
		AND @Ok IS NULL
		EXEC spInv @AjusteID
				  ,'INV'
				  ,'AFECTAR'
				  ,'TODO'
				  ,@FechaRegistro
				  ,NULL
				  ,@Usuario
				  ,1
				  ,0
				  ,NULL
				  ,@AjusteMov
				  ,@AjusteMovID OUTPUT
				  ,NULL
				  ,NULL
				  ,@Ok OUTPUT
				  ,@OkRef OUTPUT
				  ,0

	IF @CerrarSucursalAuto = 1
		OR @AsignarConsecutivo = 1
		OR (@EstatusVMOS = 'CONCLUIDO' AND @AjusteID IS NULL)
		AND @Ok IS NULL
		AND EXISTS (SELECT * FROM #Devoluciones WHERE ID IS NOT NULL)
	BEGIN
		DECLARE
			crDevolucion
			CURSOR LOCAL FOR
			SELECT ID
			FROM #Devoluciones
			WHERE ID IS NOT NULL
		OPEN crDevolucion
		FETCH NEXT FROM crDevolucion INTO @DevolucionID
		WHILE @@FETCH_STATUS = 0
		AND @Ok IS NULL
		BEGIN

		IF @EstatusVMOS = 'CONCLUIDO'
			SELECT @Accion = 'AFECTAR'
		ELSE
			SELECT @Accion = 'CONSECUTIVO'

		EXEC spInv @DevolucionID
				  ,'VTAS'
				  ,@Accion
				  ,'TODO'
				  ,@FechaRegistro
				  ,NULL
				  ,@Usuario
				  ,1
				  ,0
				  ,NULL
				  ,@DevolucionMov OUTPUT
				  ,@DevolucionMovID OUTPUT
				  ,NULL
				  ,NULL
				  ,@Ok OUTPUT
				  ,@OkRef OUTPUT
				  ,0

		IF @Ok IN (80030, 80060)
			SELECT @Ok = NULL
				  ,@OkRef = NULL

		IF @Ok IS NULL
		BEGIN
			SELECT @DevolucionEstatus = Estatus
			FROM Venta
			WHERE ID = @DevolucionID
			INSERT @TablaCFD (Empresa, ID, Modulo, Mov, MovID, EstatusNuevo)
				SELECT @Empresa
					  ,@DevolucionID
					  ,'VTAS'
					  ,@DevolucionMov
					  ,@DevolucionMovID
					  ,@DevolucionEstatus
		END

		FETCH NEXT FROM crDevolucion INTO @DevolucionID
		END
		CLOSE crDevolucion
		DEALLOCATE crDevolucion
		SELECT @LeyendaEstatus = ''
	END

	IF @CerrarSucursalAuto = 1
		OR @AsignarConsecutivo = 1
		OR (@EstatusVMOS = 'CONCLUIDO' AND @AjusteID IS NULL)
		AND @Ok IS NULL
	BEGIN
		DECLARE
			crFacturas
			CURSOR LOCAL FOR
			SELECT ID
			FROM #Facturas
		OPEN crFacturas
		FETCH NEXT FROM crFacturas INTO @FacturaID
		WHILE @@FETCH_STATUS = 0
		AND @Ok IS NULL
		BEGIN

		IF @EstatusVMOS = 'CONCLUIDO'
			SELECT @Accion = 'AFECTAR'
		ELSE
			SELECT @Accion = 'CONSECUTIVO'

		EXEC spInv @FacturaID
				  ,'VTAS'
				  ,@Accion
				  ,'TODO'
				  ,@FechaRegistro
				  ,NULL
				  ,@Usuario
				  ,1
				  ,0
				  ,NULL
				  ,@FacturaMov OUTPUT
				  ,@FacturaMovID OUTPUT
				  ,NULL
				  ,NULL
				  ,@Ok OUTPUT
				  ,@OkRef OUTPUT
				  ,0

		IF @Ok IN (80030, 80060)
			SELECT @Ok = NULL
				  ,@OkRef = NULL

		IF @Ok IS NULL
		BEGIN
			SELECT @FacturaEstatus = Estatus
			FROM Venta
			WHERE ID = @FacturaID
			INSERT @TablaCFD (Empresa, ID, Modulo, Mov, MovID, EstatusNuevo)
				SELECT @Empresa
					  ,@FacturaID
					  ,'VTAS'
					  ,@FacturaMov
					  ,@FacturaMovID
					  ,@FacturaEstatus
		END

		FETCH NEXT FROM crFacturas INTO @FacturaID
		END
		CLOSE crFacturas
		DEALLOCATE crFacturas
		SELECT @LeyendaEstatus = ''
	END

	IF @GenerarNCAlProcesar = 1
	BEGIN
		SELECT TOP 1 @FacturaID = ID
		FROM #Facturas
		SELECT @FacturaMovID = MovID
		FROM Venta
		WHERE ID = @FacturaID
		SELECT TOP 1 @DevolucionID = ID
		FROM #Devoluciones
		SELECT @DevolucionMovID = MovID
		FROM Venta
		WHERE ID = @DevolucionID
	END

	IF @Ok IS NULL
	BEGIN
		COMMIT TRANSACTION

		IF @EnSilencio = 0
		BEGIN
			SELECT @OkRef = RTRIM(CONVERT(CHAR, @Cuantas)) + ' Nota(s) procesadas.'

			IF @AjusteID IS NOT NULL
				SELECT @OkRef = RTRIM(@OkRef) + '<BR>Se Genero: ' + RTRIM(@AjusteMov) + ' (por Confirmar) en Inventarios'

			IF @DevolucionID IS NOT NULL
			BEGIN
				SELECT @CuantasDevoluciones = COUNT(ID)
				FROM #Devoluciones

				IF @CuantasDevoluciones = 1
					SELECT @OkRef = RTRIM(@OkRef) + '<BR>Se Genero: ' + RTRIM(@DevolucionMov) + ' ' + ISNULL(RTRIM(@DevolucionMovID), '') + ' ' + @LeyendaEstatus
				ELSE
					SELECT @OkRef = RTRIM(@OkRef) + '<BR>Se Generaron: ' + CONVERT(VARCHAR, @CuantasDevoluciones) + ' ' + RTRIM(@DevolucionMov) + '(s) ' + @LeyendaEstatus

			END

			IF @FacturaID IS NOT NULL
			BEGIN

				IF @GenerarNCAlProcesar = 1
				BEGIN
					SELECT @CuantasFacturas = COUNT(ID)
					FROM #Facturas

					IF @CuantasFacturas = 1
						SELECT @OkRef = RTRIM(@OkRef) + '<BR>Se Genero: ' + RTRIM(@FacturaMov) + ' ' + ISNULL(RTRIM(@FacturaMovID), '') + ' ' + @LeyendaEstatus
					ELSE
						SELECT @OkRef = RTRIM(@OkRef) + '<BR>Se Generaron: ' + CONVERT(VARCHAR, @CuantasFacturas) + ' ' + RTRIM(@FacturaMov) + '(s) ' + @LeyendaEstatus

				END
				ELSE
				BEGIN

					IF @CuantasFacturas = 1
						SELECT @OkRef = RTRIM(@OkRef) + '<BR>Se Genero: ' + RTRIM(@FacturaMov) + ' ' + ISNULL(RTRIM(@FacturaMovID), '') + ' ' + @LeyendaEstatus
					ELSE
						SELECT @OkRef = RTRIM(@OkRef) + '<BR>Se Generaron: ' + CONVERT(VARCHAR, @CuantasFacturas) + ' ' + RTRIM(@FacturaMov) + '(s) ' + @LeyendaEstatus

				END

			END

			SELECT @OkRef
		END

		IF @Ok IS NULL
		BEGIN
			DECLARE
				crcfd
				CURSOR LOCAL FOR
				SELECT Empresa
					  ,ID
					  ,Modulo
					  ,Mov
					  ,MovID
					  ,EstatusNuevo
				FROM @TablaCFD
			OPEN crcfd
			FETCH NEXT FROM crcfd INTO @CFDEmpresa, @CFDID, @CFDModulo, @CFDMov, @CFDMovID, @CFDEstatusNuevo
			WHILE @@FETCH_STATUS = 0
			AND @Ok IS NULL
			BEGIN
			EXEC spCFDFlexAfectarSinMovFinal @CFDEmpresa
											,@CFDModulo
											,@CFDMov
											,@CFDMovID
											,@CFDID
											,@CFDEstatusNuevo
											,NULL
											,NULL
			FETCH NEXT FROM crcfd INTO @CFDEmpresa, @CFDID, @CFDModulo, @CFDMov, @CFDMovID, @CFDEstatusNuevo
			END
			CLOSE crcfd
			DEALLOCATE crcfd
		END

	END
	ELSE
	BEGIN
		ROLLBACK TRANSACTION

		IF @EnSilencio = 0
			SELECT Descripcion + ' ' + RTRIM(@OkRef)
			FROM MensajeLista
			WHERE Mensaje = @Ok

	END

	RETURN
END

