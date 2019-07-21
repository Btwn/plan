SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spVentaCteDAceptar]
 @Sucursal INT
,@Estacion INT
,@VentaID INT
,@MovTipo CHAR(20)
,@CopiarAplicacion BIT = 0
,@CopiaridVenta INT = 0
AS
BEGIN
	DECLARE
		@Empresa CHAR(5)
	   ,@ID INT
	   ,@Mov CHAR(20)
	   ,@MovID VARCHAR(20)
	   ,@MovReferencia VARCHAR(50)
	   ,@TieneAlgo BIT
	   ,@Directo BIT
	   ,@Cliente CHAR(10)
	   ,@Renglon FLOAT
	   ,@RenglonID INT
	   ,@VentaDRenglon FLOAT
	   ,@VentaDRenglonID INT
	   ,@VentaDRenglonSub INT
	   ,@RenglonTipo CHAR(1)
	   ,@ZonaImpuesto VARCHAR(30)
	   ,@Cantidad FLOAT
	   ,@CantidadInventario FLOAT
	   ,@Almacen CHAR(10)
	   ,@Codigo VARCHAR(50)
	   ,@Articulo CHAR(20)
	   ,@SubCuenta VARCHAR(50)
	   ,@Unidad VARCHAR(50)
	   ,@Precio FLOAT
	   ,@DescuentoTipo CHAR(1)
	   ,@DescuentoLinea FLOAT
	   ,@Impuesto1 FLOAT
	   ,@Impuesto2 FLOAT
	   ,@Impuesto3 MONEY
	   ,@DescripcionExtra VARCHAR(100)
	   ,@Costo FLOAT
	   ,@ContUso VARCHAR(20)
	   ,@Aplica CHAR(20)
	   ,@AplicaID CHAR(20)
	   ,@Agente CHAR(10)
	   ,@AgenteD CHAR(10)
	   ,@Descuento VARCHAR(30)
	   ,@DescuentoGlobal FLOAT
	   ,@FormaPagoTipo VARCHAR(50)
	   ,@SobrePrecio FLOAT
	   ,@ArtTipo VARCHAR(20)
	   ,@Departamento INT
	   ,@DepartamentoD INT
	   ,@Financiamiento FLOAT
	   ,@importeVD MONEY
	   ,@Puntos MONEY
	   ,@DescuentoImporte FLOAT
	   ,@CfgSeriesLotesAutoOrden CHAR(20)
	   ,@FechaEmision DATETIME
	   ,@EnviarA INT
	   ,@VentaMov VARCHAR(20)
	   ,@VentaMovO VARCHAR(20)
	   ,@VentaMovID VARCHAR(20)
	   ,@TipoImpuesto1 VARCHAR(10)
	   ,@TipoImpuesto2 VARCHAR(10)
	   ,@TipoImpuesto3 VARCHAR(10)
	   ,@TipoRetencion1 VARCHAR(10)
	   ,@TipoRetencion2 VARCHAR(10)
	   ,@TipoRetencion3 VARCHAR(10)
	   ,@Retencion1 FLOAT
	   ,@Retencion2 FLOAT
	   ,@Retencion3 FLOAT
	   ,@Factor FLOAT
	   ,@ContMoneda VARCHAR(10)
	   ,@MonedaOrigen VARCHAR(10)
	   ,@MonedaDestino VARCHAR(10)
	   ,@TipoCambioCont FLOAT
	   ,@TipoCambioOrigen FLOAT
	   ,@TipoCambioDestino FLOAT
	   ,@CantidadVenta FLOAT
	   ,@Clave VARCHAR(20)
	   ,@ClaveID VARCHAR(20)
	SELECT @TieneAlgo = 0
		  ,@RenglonID = 0
	SELECT @Renglon = ISNULL(MAX(Renglon), 0)
	FROM VentaD
	WHERE ID = @VentaID
	SELECT @VentaMov = Mov
		  ,@FechaEmision = FechaEmision
		  ,@Empresa = Empresa
		  ,@Cliente = Cliente
		  ,@EnviarA = EnviarA
		  ,@Directo = Directo
		  ,@RenglonID = ISNULL(RenglonID, 0)
		  ,@MonedaDestino = Moneda
		  ,@TipoCambioDestino = ISNULL(TipoCambio, 1.0)
	FROM Venta
	WHERE ID = @VentaID
	SELECT @Clave = Clave
	FROM MovTipo
	WHERE MOV = @VentaMov
	AND Modulo = 'VTAS'
	SELECT @ZonaImpuesto = ZonaImpuesto
	FROM Cte
	WHERE Cliente = @Cliente
	SELECT @CfgSeriesLotesAutoOrden = ISNULL(UPPER(RTRIM(SeriesLotesAutoOrden)), 'NO')
		  ,@ContMoneda = ContMoneda
	FROM EmpresaCfg
	WHERE Empresa = @Empresa
	BEGIN TRANSACTION
	DECLARE
		crVentaCteD
		CURSOR FOR
		SELECT d.Financiamiento
			  ,l.ID
			  ,l.CantidadA
			  ,(l.CantidadA * d.CantidadInventario / ISNULL(NULLIF(d.Cantidad, 0.0), 1.0))
			  ,d.Renglon
			  ,d.RenglonSub
			  ,d.RenglonID
			  ,RenglonTipo
			  ,d.Almacen
			  ,d.Codigo
			  ,d.Articulo
			  ,Subcuenta
			  ,Unidad
			  ,Precio
			  ,DescuentoTipo
			  ,DescuentoLinea
			  ,DescuentoImporte
			  ,Impuesto1
			  ,Impuesto2
			  ,Impuesto3
			  ,Costo
			  ,d.ContUso
			  ,Aplica
			  ,AplicaID
			  ,d.Agente
			  ,d.Departamento
				,d.Puntos
			  ,d.TipoImpuesto1
			  ,d.TipoImpuesto2
			  ,d.TipoImpuesto3
			  ,d.TipoRetencion1
			  ,d.TipoRetencion2
			  ,d.TipoRetencion3
			  ,d.Retencion1
			  ,d.Retencion2
			  ,d.Retencion3
			  ,v.Mov
			  ,v.MovID
			  ,l.cantidad
			  ,mt.Clave
		FROM VentaD d
		JOIN Venta v
			ON d.ID = v.ID
		JOIN MovTipo MT
			ON V.Mov = MT.Mov
			AND Modulo = 'VTAS'
		JOIN VentaCteDLista l
			ON d.ID = l.ID
			AND d.Renglon = l.Renglon
			AND d.RenglonSub = l.RenglonSub
		LEFT JOIN VentaDevolucion vd
			ON l.ID = vd.RID
			AND ISNULL(VD.CantidadA, 0.0) + ISNULL(VD.Cantidad, 0.00) <= ISNULL(VD.Cantidad, 0.00)
			AND d.Renglon = vd.Renglon
		WHERE l.Estacion = @Estacion
		AND ISNULL(l.CantidadA, 0.0) > 0
		AND d.Cantidad - ISNULL(VD.CantidadA, 0.0) > 0
		ORDER BY l.ID, l.Renglon, l.RenglonSUB
	OPEN crVentaCteD
	FETCH NEXT FROM crVentaCteD INTO @Financiamiento, @ID, @Cantidad, @CantidadInventario, @VentaDRenglon, @VentaDRenglonSub, @VentaDRenglonID, @RenglonTipo, @Almacen, @Codigo, @Articulo, @Subcuenta, @Unidad, @Precio, @DescuentoTipo, @DescuentoLinea, @DescuentoImporte, @Impuesto1, @Impuesto2, @Impuesto3, @Costo, @ContUso, @Aplica, @AplicaID, @AgenteD, @DepartamentoD, @Puntos, @TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoRetencion1, @TipoRetencion2, @TipoRetencion3, @Retencion1, @Retencion2, @Retencion3, @VentaMovO, @VentaMovID, @CantidadVenta, @ClaveID
	WHILE @@FETCH_STATUS = 0
	BEGIN

	IF @CantidadVenta >= @Cantidad
		AND @ClaveID <> 'VTAS.D'
	BEGIN

		IF @TieneAlgo = 0
		BEGIN
			SELECT @TieneAlgo = 1
			SELECT @Empresa = Empresa
				  ,@Mov = Mov
				  ,@MovID = MovID
				  ,@MovReferencia = NULLIF(RTRIM(Referencia), '')
				  ,@Agente = Agente
				  ,@Descuento = Descuento
				  ,@DescuentoGlobal = DescuentoGlobal
				  ,@FormaPagoTipo = FormaPagoTipo
				  ,@SobrePrecio = SobrePrecio
				  ,@Departamento = Departamento
					,@MonedaOrigen = Moneda
				  ,@TipoCambioOrigen = ISNULL(TipoCambio, 1.0)
			FROM Venta
			WHERE ID = @ID

			IF EXISTS (SELECT * FROM PoliticasMonederoAplicadasMavi WHERE Empresa = @Empresa AND Modulo = 'VTAS' AND ID = @VentaID)
				DELETE FROM PoliticasMonederoAplicadasMavi
				WHERE Empresa = @Empresa
					AND Modulo = 'VTAS'
					AND ID = @VentaID

			IF EXISTS (SELECT * FROM VentaCteDLista VL WHERE ID = @ID AND ISNULL(Vl.CantidadA, 0.0) > 0)
				INSERT PoliticasMonederoAplicadasMavi (Empresa, Modulo, ID, Renglon, Articulo, IDPolitica)
					SELECT V.EMPRESA
						  ,'VTAS'
						  ,@VentaID
						  ,D.Renglon
						  ,D.Articulo
						  ,(D.PUNTOS / D.CANTIDAD) * ISNULL(Vl.CantidadA, 0.0)
					FROM Venta V
					JOIN VentaD D
						ON V.ID = D.ID
					JOIN VentaCteDLista VL
						ON D.RENGLON = VL.RENGLON
						AND ISNULL(Vl.CantidadA, 0.0) > 0
						AND VL.ID = @ID
					WHERE V.ID = @ID

			IF EXISTS (SELECT * FROM TarjetaSerieMovMAVI WHERE Empresa = @Empresa AND Modulo = 'VTAS' AND ID = @VentaID)
				DELETE FROM TarjetaSerieMovMAVI
				WHERE Empresa = @Empresa
					AND Modulo = 'VTAS'
					AND ID = @VentaID

			IF EXISTS (SELECT * FROM TarjetaSerieMovMAVI WHERE Empresa = @Empresa AND Modulo = 'VTAS' AND ID = @ID)
				INSERT TarjetaSerieMovMAVI (Empresa, Modulo, ID, Serie, Importe, Sucursal)
					SELECT Empresa
						  ,Modulo
						  ,@VentaID
						  ,Serie
						  ,Importe
						  ,Sucursal
					FROM TarjetaSerieMovMAVI
					WHERE Empresa = @Empresa
					AND Modulo = 'VTAS'
					AND ID = @ID

		END

		SELECT @Puntos = iDpOLITICA
		FROM PoliticasMonederoAplicadasMavi
		WHERE Empresa = @Empresa
		AND Modulo = 'VTAS'
		AND ID = @VentaID
		AND RENGLON = @VentaDRenglon

		IF @MonedaOrigen <> @MonedaDestino
		BEGIN
			SELECT @Precio = (@Precio * @TipoCambioOrigen) / @TipoCambioDestino
		END
		
		EXEC spZonaImp @ZonaImpuesto
					  ,@Impuesto1 OUTPUT
		EXEC spZonaImp @ZonaImpuesto
					  ,@Impuesto2 OUTPUT
		EXEC spZonaImp @ZonaImpuesto
					  ,@Impuesto3 OUTPUT
		EXEC spTipoImpuesto 'VTAS'
						   ,@VentaID
						   ,@VentaMov
						   ,@FechaEmision
						   ,@Empresa
						   ,@Sucursal
						   ,@Cliente
						   ,@EnviarA
						   ,@Articulo = @Articulo
						   ,@EnSilencio = 1
						   ,@Impuesto1 = @Impuesto1 OUTPUT
						   ,@Impuesto2 = @Impuesto2 OUTPUT
						   ,@Impuesto3 = @Impuesto3 OUTPUT
		SELECT @Renglon = @Renglon + 2048
			  ,@RenglonID = @RenglonID + 1

		IF @MovTipo NOT IN ('VTAS.D', 'VTAS.DF', 'VTAS.SD', 'VTAS.DFC', 'VTAS.DC', 'VTAS.DCR', 'VTAS.B', 'VTAS.SD')
			SELECT @Costo = NULL

		IF @CopiarAplicacion = 0
			SELECT @Aplica = NULL
				  ,@AplicaID = NULL

		IF @Aplica IS NOT NULL
			SELECT @Directo = 0

		IF (@CopiaridVenta = 1)
		BEGIN

			IF NOT EXISTS (SELECT * FROM VentaD WHERE ID = @VentaID AND Articulo = @Articulo)
			BEGIN
				INSERT VentaD (Financiamiento, IDCopiaMAVI, Sucursal, ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Almacen, Codigo, Articulo, Subcuenta, Unidad, Cantidad, CantidadInventario, Precio, DescuentoTipo, DescuentoLinea, DescuentoImporte,
				Impuesto1, Impuesto2, Impuesto3, Costo, ContUso, Aplica, AplicaID, Agente, Departamento, Puntos)
					VALUES (@Financiamiento, @ID, @Sucursal, @VentaID, @Renglon, 0, @RenglonID, @RenglonTipo, @Almacen, @Codigo, @Articulo, @Subcuenta, @Unidad, @Cantidad, @CantidadInventario, @Precio, @DescuentoTipo, @DescuentoLinea, @DescuentoImporte, @Impuesto1, @Impuesto2, @Impuesto3, @Costo, @ContUso, @Aplica, @AplicaID, @AgenteD, @DepartamentoD, @Puntos)
			END
			ELSE
			BEGIN
				UPDATE VentaD
				SET puntos = @Puntos
				WHERE Articulo = @Articulo
				AND ID = @VentaID
			END

		END
		ELSE
		BEGIN
			INSERT VentaD (Financiamiento, IDCopiaMAVI, Sucursal, ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Almacen, Codigo, Articulo, Subcuenta, Unidad, Cantidad, CantidadInventario, Precio, DescuentoTipo, DescuentoLinea, DescuentoImporte,
			Impuesto1, Impuesto2, Impuesto3, Costo, ContUso, Aplica, AplicaID, Agente, Departamento, Puntos)
				VALUES (@Financiamiento, @ID, @Sucursal, @VentaID, @Renglon, 0, @RenglonID, @RenglonTipo, @Almacen, @Codigo, @Articulo, @Subcuenta, @Unidad, @Cantidad, @CantidadInventario, @Precio, @DescuentoTipo, @DescuentoLinea, @DescuentoImporte, @Impuesto1, @Impuesto2, @Impuesto3, @Costo, @ContUso, @Aplica, @AplicaID, @AgenteD, @DepartamentoD, @Puntos)
			IF @Clave = 'VTAS.D'
				INSERT VentaDevolucion (RID, Renglon, RenglonRID, RenglonID, Articulo, Cantidad, ID, CantidadA, Estatus)
					SELECT @ID
						  ,@VentaDRenglon
						  ,@Renglon
						  ,@VentaDRenglonID
						  ,@Articulo
						  ,@CantidadVenta
						  ,@VentaID
						  ,@Cantidad
						  ,1

		END

		EXEC spArtTipo @RenglonTipo
					  ,@ArtTipo OUTPUT

		IF @ArtTipo IN ('SERIE', 'LOTE', 'VIN', 'PARTIDA')
			EXEC spVentaCteDSerieLote @Empresa
									 ,@Sucursal
									 ,@CfgSeriesLotesAutoOrden
									 ,@ID
									 ,@VentaDRenglonID
									 ,@RenglonID
									 ,@VentaID
									 ,@Articulo
									 ,@SubCuenta
									 ,@Cantidad

		IF (@CopiaridVenta = 0)
		BEGIN

			IF @ArtTipo = 'JUEGO'
				EXEC spVentaCteDComponentes @Sucursal
										   ,@ID
										   ,@VentaDRenglon
										   ,@VentaDRenglonSub
										   ,@Cantidad
										   ,@MovTipo
										   ,@VentaID
										   ,@Almacen
										   ,@Renglon
										   ,@RenglonID
										   ,@CopiarAplicacion
										   ,@Empresa
										   ,@CfgSeriesLotesAutoOrden

		END

	END

	FETCH NEXT FROM crVentaCteD INTO @Financiamiento, @ID, @Cantidad, @CantidadInventario, @VentaDRenglon, @VentaDRenglonSub, @VentaDRenglonID, @RenglonTipo, @Almacen, @Codigo, @Articulo, @Subcuenta, @Unidad, @Precio, @DescuentoTipo, @DescuentoLinea, @DescuentoImporte, @Impuesto1, @Impuesto2, @Impuesto3, @Costo, @ContUso, @Aplica, @AplicaID, @AgenteD, @DepartamentoD, @Puntos, @TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoRetencion1, @TipoRetencion2, @TipoRetencion3, @Retencion1, @Retencion2, @Retencion3, @VentaMovO, @VentaMovID, @CantidadVenta, @ClaveID
	END
	CLOSE crVentaCteD
	DEALLOCATE crVentaCteD

	IF @TieneAlgo = 1
	BEGIN

		IF @MovReferencia IS NULL
			SELECT @MovReferencia = RTRIM(@Mov) + ' ' + RTRIM(@MovID)

		UPDATE Venta
		SET Referencia = @MovReferencia
		   ,Directo = @Directo
		   ,Agente = @Agente
		   ,Descuento = @Descuento
		   ,DescuentoGlobal = @DescuentoGlobal
		   ,FormaPagoTipo = @FormaPagoTipo
		   ,SobrePrecio = @SobrePrecio
		   ,RenglonID = @RenglonID
		   ,Departamento = @Departamento
		WHERE ID = @VentaID
	END

	DELETE VentaCteDLista
	WHERE Estacion = @Estacion
	COMMIT TRANSACTION
END

