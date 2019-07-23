SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spSeriesLotesMayoreo]
 @Sucursal INT
,@SucursalAlmacen INT
,@SucursalAlmacenDestino INT
,@Empresa CHAR(5)
,@Modulo CHAR(5)
,@Accion CHAR(20)
,@AfectarCostos BIT
,@EsEntrada BIT
,@EsSalida BIT
,@EsTransferencia BIT
,@ID INT
,@RenglonID INT
,@Almacen CHAR(10)
,@AlmacenDestino CHAR(10)
,@Articulo CHAR(20)
,@SubCuenta VARCHAR(50)
,@ArtTipo CHAR(20)
,@ArtSerieLoteInfo BIT
,@ArtLotesFijos BIT
,@ArtCosto FLOAT
,@ArtCostoInv FLOAT
,@CantidadMovimiento FLOAT
,@Factor FLOAT
,@MovTipo CHAR(20)
,@AplicaMovTipo CHAR(20)
,@AlmacenTipo CHAR(20)
,@FechaEmision DATETIME
,@CfgCosteoSeries BIT
,@CfgCosteoLotes BIT
,@ArtCostoIdentificado BIT
,@CfgValidarLotesCostoDif BIT
,@CfgVINAccesorioArt BIT
,@CfgVINCostoSumaAccesorios BIT
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
,@Temp BIT = 0
,@Tarima VARCHAR(20) = NULL
AS
BEGIN
	DECLARE
		@SubCuentaNull VARCHAR(50)
	   ,@SerieLote VARCHAR(50)
	   ,@SerieLotePropiedades VARCHAR(50)
	   ,@Propiedades CHAR(20)
	   ,@Cliente VARCHAR(10)
	   ,@Localizacion VARCHAR(10)
	   ,@Cantidad FLOAT
	   ,@CantidadAlterna FLOAT
	   ,@CantidadTomada FLOAT
	   ,@ArtCostoF FLOAT
	   ,@ArtCostoInvF FLOAT
	   ,@SumaCantidad FLOAT
	   ,@SumaCantidadAlterna FLOAT
	   ,@Requiere FLOAT
	   ,@ExistenciaNueva FLOAT
	   ,@ExistenciaAnterior FLOAT
	   ,@CosteoLotes BIT
	   ,@CostoPromedio FLOAT
	   ,@UltimaEntrada DATETIME
	   ,@UltimaSalida DATETIME
	   ,@AlmacenTarima VARCHAR(20)
	   ,@AlmacenDestinoTarima VARCHAR(20)
	   ,@MovSubTipo CHAR(20)
	   ,@PedimentoExtraccion CHAR(50)
	   ,@LDIArticulo BIT
	   ,@LDI BIT
	   ,@OrigenTipo VARCHAR(10)
	   ,@WMS BIT
	   ,@TarimaOrigen VARCHAR(20)
	   ,@ArticuloTarjetasDef VARCHAR(20)
	DECLARE
		@SerieloteMovVal TABLE (
			RenglonID INT NULL
		   ,SerieLote VARCHAR(50) NULL
		   ,TarimaOrigen VARCHAR(20) NULL
		   ,Cantidad FLOAT NULL
		   ,SucursalAlmacen INT NULL
		)
	SELECT @WMS = ISNULL(WMS, 0)
	FROM Alm WITH(NOLOCK)
	WHERE Almacen = @Almacen
	SELECT @ArticuloTarjetasDef = CxcArticuloTarjetasDef
	FROM EmpresaCfg WITH(NOLOCK)
	WHERE Empresa = @Empresa
	SELECT @OrigenTipo = OrigenTipo
	FROM Venta WITH(NOLOCK)
	WHERE ID = @ID
	SELECT @LDI = ISNULL(InterfazLDI, 0)
	FROM EmpresaGral WITH(NOLOCK)
	WHERE Empresa = @Empresa
	SELECT @LDIArticulo = ISNULL(LDI, 0)
	FROM Art WITH(NOLOCK)
	WHERE Articulo = @Articulo
	SELECT @SubCuenta = ISNULL(RTRIM(@SubCuenta), '')
		  ,@SubCuentaNull = NULLIF(RTRIM(@SubCuenta), '')
		  ,@Tarima = ISNULL(RTRIM(@Tarima), '')
		  ,@UltimaEntrada = NULL
		  ,@UltimaSalida = NULL
		  ,@CosteoLotes = 0
	SELECT @MovSubTipo = NULLIF(RTRIM(mt.SubClave), '')
	FROM MovTipo mt WITH(NOLOCK)
	WHERE mt.Modulo = @Modulo
	AND mt.Clave = @MovTipo
	SELECT @AlmacenTarima = dbo.fnAlmacenTarima(@Almacen, @Tarima)
		  ,@AlmacenDestinoTarima = dbo.fnAlmacenTarima(@AlmacenDestino, @Tarima)

	IF ((@ArtTipo IN ('LOTE', 'PARTIDA') AND (@CfgCosteoLotes = 1 OR @ArtCostoIdentificado = 1)) OR (@ArtTipo IN ('SERIE', 'VIN') AND (@CfgCosteoSeries = 1 OR @ArtCostoIdentificado = 1)))
		SELECT @CosteoLotes = 1

	IF (@AplicaMovTipo = 'COMS.CC' AND @MovTipo IN ('COMS.F', 'COMS.FL', 'COMS.EG', 'COMS.EI'))
		OR (@AplicaMovTipo = 'VTAS.R' AND @MovTipo IN ('VTAS.F', 'VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX'))
		RETURN

	IF @EsEntrada = 1
		SELECT @UltimaEntrada = @FechaEmision
	ELSE

	IF @EsSalida = 1
		SELECT @UltimaSalida = @FechaEmision

	IF @EsEntrada = 1
		AND @Modulo = 'INV'
		AND @MovTipo = 'INV.EI'
		AND @MovSubTipo = 'INV.EXT'
		AND @Accion = 'AFECTAR'
	BEGIN
		SELECT @PedimentoExtraccion = NULLIF(RTRIM(i.PedimentoExtraccion), '')
		FROM Inv i WITH(NOLOCK)
		WHERE i.ID = @ID

		IF @PedimentoExtraccion IS NOT NULL
			AND (
				SELECT COUNT(*)
				FROM SerieLoteMov WITH(NOLOCK)
				WHERE Empresa = @Empresa
				AND Modulo = @Modulo
				AND ID = @ID
				AND RenglonID = @RenglonID
				AND Articulo = @Articulo
				AND NULLIF(RTRIM(SubCuenta), '') = @SubCuentaNull
			)
			> 1
			SELECT @Ok = 73070
				  ,@OkRef = 'Producto ' + RTRIM(@Articulo)

		IF @PedimentoExtraccion IS NOT NULL
			AND @Ok IS NULL
		BEGIN
			UPDATE SerieLoteMov WITH(ROWLOCK)
			SET SerieLote = @PedimentoExtraccion
			WHERE Empresa = @Empresa
			AND Modulo = @Modulo
			AND ID = @ID
			AND RenglonID = @RenglonID
			AND Articulo = @Articulo
			AND NULLIF(RTRIM(SubCuenta), '') = @SubCuentaNull
		END

	END

	SELECT @ArtCostoF = @ArtCosto / @Factor
	SELECT @SumaCantidad = 0.0
		  ,@SumaCantidadAlterna = 0.0

	IF @Temp = 1
	BEGIN
		CREATE INDEX Llave ON #SerieLoteMov (ID, RenglonID, Articulo, SubCuenta, SerieLote, Modulo, Empresa)
		DECLARE
			crSerieLoteMov
			CURSOR FOR
			SELECT NULLIF(RTRIM(SerieLote), '')
				  ,ISNULL(Cantidad, 0.0)
				  ,ISNULL(CantidadAlterna, 0.0)
				  ,NULLIF(RTRIM(Propiedades), '')
				  ,NULLIF(RTRIM(Cliente), '')
				  ,NULLIF(RTRIM(Localizacion), '')
				  ,ISNULL(NULLIF(ArtCostoInv, 0), @ArtCostoInv) / @Factor
			FROM #SerieLoteMov
			WHERE Empresa = @Empresa
			AND Modulo = @Modulo
			AND ID = @ID
			AND RenglonID = @RenglonID
			AND Articulo = @Articulo
			AND NULLIF(RTRIM(SubCuenta), '') = @SubCuentaNull
	END
	ELSE

	IF ISNULL(@AlmacenTarima, '') = ''
		DECLARE
			crSerieLoteMov
			CURSOR FOR
			SELECT NULLIF(RTRIM(SerieLote), '')
				  ,ISNULL(Cantidad, 0.0)
				  ,ISNULL(CantidadAlterna, 0.0)
				  ,NULLIF(RTRIM(Propiedades), '')
				  ,NULLIF(RTRIM(Cliente), '')
				  ,NULLIF(RTRIM(Localizacion), '')
				  ,ISNULL(NULLIF(ArtCostoInv, 0), @ArtCostoInv) / @Factor
			FROM SerieLoteMov WITH(NOLOCK)
			WHERE Empresa = @Empresa
			AND Modulo = @Modulo
			AND ID = @ID
			AND RenglonID = @RenglonID
			AND Articulo = @Articulo
			AND NULLIF(RTRIM(SubCuenta), '') = @SubCuentaNull
	ELSE
		DECLARE
			crSerieLoteMov
			CURSOR FOR
			SELECT NULLIF(RTRIM(SerieLote), '')
				  ,ISNULL(Cantidad, 0.0)
				  ,ISNULL(CantidadAlterna, 0.0)
				  ,NULLIF(RTRIM(Propiedades), '')
				  ,NULLIF(RTRIM(Cliente), '')
				  ,NULLIF(RTRIM(Localizacion), '')
				  ,ISNULL(NULLIF(ArtCostoInv, 0), @ArtCostoInv) / @Factor
			FROM SerieLoteMov WITH(NOLOCK)
			WHERE Empresa = @Empresa
			AND Modulo = @Modulo
			AND ID = @ID
			AND RenglonID = @RenglonID
			AND Articulo = @Articulo
			AND NULLIF(RTRIM(SubCuenta), '') = @SubCuentaNull

	OPEN crSerieLoteMov
	FETCH NEXT FROM crSerieLoteMov INTO @SerieLote, @Cantidad, @CantidadAlterna, @Propiedades, @Cliente, @Localizacion, @ArtCostoInvF

	IF @@ERROR <> 0
		SELECT @Ok = 1

	WHILE @@FETCH_STATUS <> -1
	AND @Ok IS NULL
	BEGIN

	IF @@FETCH_STATUS <> -2
		AND (@Cantidad <> 0.0 OR @CantidadAlterna <> 0.0)
	BEGIN
		SELECT @SumaCantidad = @SumaCantidad + @Cantidad
			  ,@SumaCantidadAlterna = @SumaCantidadAlterna + @CantidadAlterna
		SELECT @ExistenciaNueva = 0.0
			  ,@ExistenciaAnterior = 0.0
			  ,@CostoPromedio = 0.0
		SELECT @ExistenciaAnterior =
			   CASE @AlmacenTipo
				   WHEN 'ACTIVOS FIJOS' THEN ISNULL(ExistenciaActivoFijo, 0.0)
				   ELSE ISNULL(Existencia, 0.0)
			   END
			  ,@SerieLotePropiedades = NULLIF(RTRIM(Propiedades), '')
		FROM SerieLote WITH(NOLOCK)
		WHERE Sucursal = @SucursalAlmacen
		AND Empresa = @Empresa
		AND Articulo = @Articulo
		AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
		AND SerieLote = @SerieLote
		AND Almacen = @Almacen
		AND ISNULL(Tarima, '') = ISNULL(@AlmacenTarima, '')

		IF (@EsSalida = 1 OR @EsTransferencia = 1 OR @Modulo = 'VTAS')
			AND @Propiedades <> @SerieLotePropiedades
			AND @Propiedades IS NULL
		BEGIN
			SELECT @Propiedades = @SerieLotePropiedades

			IF @Temp = 1
				UPDATE #SerieLoteMov
				SET Propiedades = @Propiedades
				WHERE CURRENT OF crSerieLoteMov
			ELSE
				UPDATE SerieLoteMov WITH(ROWLOCK)
				SET Propiedades = @Propiedades
				WHERE CURRENT OF crSerieLoteMov

		END

		IF @CosteoLotes = 1
		BEGIN
			SELECT @CostoPromedio = ISNULL(SUM(ISNULL(Existencia, 0.0) * ISNULL(CostoPromedio, 0.0)) / NULLIF(SUM(Existencia), 0.0), 0.0)
			FROM SerieLote WITH(NOLOCK)
			WHERE Empresa = @Empresa
			AND Articulo = @Articulo
			AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
			AND SerieLote = @SerieLote
			AND Almacen = @Almacen
			AND ISNULL(Tarima, '') = ISNULL(@AlmacenTarima, '')
			AND Sucursal = @SucursalAlmacen

			IF (@EsSalida = 1 OR @EsTransferencia = 1)
				AND @ArtLotesFijos = 1
				AND @Accion <> 'CANCELAR'
				SELECT @ArtCostoInvF = @CostoPromedio

		END

		IF (@EsEntrada = 1 OR @ArtSerieLoteInfo = 1)
			AND @Ok IS NULL
		BEGIN

			IF @ArtSerieLoteInfo = 1
				SELECT @Cantidad = 0.0

			-- Se comenta esta seccion porque hace dos veces lo mismo, provocando que los articulos no se puedan enviar
			-- a un almacen que ya existe en SerieLote, solo pasa con el campo ExistenciaActivoFijo, el de Existencia no tieme este problema
			-- IF (@AlmacenTipo = 'ACTIVOS FIJOS' AND @Accion <> 'CANCELAR')
			-- 	UPDATE SerieLote
			-- 	SET @ExistenciaNueva = ExistenciaActivoFijo = ISNULL(ExistenciaActivoFijo, 0.0) + @Cantidad
			-- 	   ,UltimaEntrada =
			-- 		CASE
			-- 			WHEN @EsEntrada = 1
			-- 				AND @Accion <> 'CANCELAR' THEN @FechaEmision
			-- 			ELSE UltimaEntrada
			-- 		END
			-- 	   ,UltimaSalida =
			-- 		CASE
			-- 			WHEN @EsSalida = 1
			-- 				AND @Accion <> 'CANCELAR' THEN @FechaEmision
			-- 			ELSE UltimaSalida
			-- 		END
			-- 	WHERE Sucursal = @SucursalAlmacen
			-- 	AND Empresa = @Empresa
			-- 	AND Articulo = @Articulo
			-- 	AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
			-- 	AND SerieLote = @SerieLote
			-- 	AND Almacen = @Almacen
			-- 	AND ISNULL(Tarima, '') = ISNULL(@AlmacenTarima, '')
			-- ELSE

			IF @Accion = 'CANCELAR'
			BEGIN
				DECLARE
					crSerieLote
					CURSOR FOR
					SELECT slm.RenglonID
						  ,slm.SerieLote
						  ,slm.Tarima
						  ,slm.Cantidad
						  ,a.Sucursal
					FROM SerieloteMov slm WITH(NOLOCK)
					JOIN Alm a WITH(NOLOCK)
						ON slm.Sucursal = a.Sucursal
					WHERE Id = @ID
					AND Modulo = @Modulo
					AND slm.Tarima <> ''
					AND slm.Articulo = @Articulo
					AND ISNULL(slm.SubCuenta, '') = ISNULL(@SubCuenta, '')
					AND a.Almacen = @Almacen
					AND slm.Empresa = @Empresa
					AND slm.Sucursal = @Sucursal
				OPEN crSerieLote
				FETCH NEXT FROM crSerieLote INTO @RenglonID, @SerieLote, @TarimaOrigen, @Cantidad, @SucursalAlmacen
				WHILE @@FETCH_STATUS = 0
				AND @Ok IS NULL
				BEGIN

				IF EXISTS (SELECT * FROM SerieLote WITH(NOLOCK) WHERE Sucursal = @SucursalAlmacen AND Empresa = @Empresa AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') AND SerieLote = @SerieLote AND Almacen = @Almacen AND ISNULL(Tarima, '') = ISNULL(@TarimaOrigen, ''))
					UPDATE SerieLote WITH(ROWLOCK)
					SET Existencia = 0
					   ,UltimaEntrada = UltimaEntrada
					   ,UltimaSalida = UltimaSalida
					WHERE Sucursal = @SucursalAlmacen
					AND Empresa = @Empresa
					AND Articulo = @Articulo
					AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
					AND SerieLote = @SerieLote
					AND Almacen = @Almacen
					AND ISNULL(Tarima, '') = ISNULL(@TarimaOrigen, '')

				IF NOT EXISTS (SELECT * FROM @SerieloteMovVal WHERE RenglonID = @RenglonID AND SerieLote = @SerieLote AND TarimaOrigen = @TarimaOrigen AND @Cantidad = @Cantidad AND SucursalAlmacen = @SucursalAlmacen)
					UPDATE SerieLote WITH(ROWLOCK)
					SET @ExistenciaNueva = Existencia = ISNULL(Existencia, 0.0) + @Cantidad
					   ,ExistenciaAlterna = ISNULL(ExistenciaAlterna, 0.0) + @CantidadAlterna
					   ,UltimaEntrada =
						CASE
							WHEN @EsEntrada = 1
								AND @Accion <> 'CANCELAR' THEN @FechaEmision
							ELSE UltimaEntrada
						END
					   ,UltimaSalida =
						CASE
							WHEN @EsSalida = 1
								AND @Accion <> 'CANCELAR' THEN @FechaEmision
							ELSE UltimaSalida
						END
					WHERE Sucursal = @SucursalAlmacen
					AND Empresa = @Empresa
					AND Articulo = @Articulo
					AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
					AND SerieLote = @SerieLote
					AND Almacen = @Almacen
					AND ISNULL(Tarima, '') = ISNULL(@AlmacenTarima, '')

				INSERT @SerieloteMovVal (RenglonID, SerieLote, TarimaOrigen, Cantidad, SucursalAlmacen)
					SELECT @RenglonID
						  ,@SerieLote
						  ,@TarimaOrigen
						  ,@Cantidad
						  ,@SucursalAlmacen
				FETCH NEXT FROM crSerieLote INTO @RenglonID, @SerieLote, @TarimaOrigen, @Cantidad, @SucursalAlmacen
				END
				CLOSE crSerieLote
				DEALLOCATE crSerieLote
			END

			IF EXISTS (SELECT * FROM SerieLote WITH(NOLOCK) WHERE Sucursal = @SucursalAlmacen AND Empresa = @Empresa AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') AND SerieLote = @SerieLote AND Almacen = @Almacen AND ISNULL(Tarima, '') = ISNULL(@AlmacenTarima, ''))
			BEGIN

				IF @AlmacenTipo = 'ACTIVOS FIJOS'
					UPDATE SerieLote WITH(ROWLOCK)
					SET ExistenciaActivoFijo = ISNULL(ExistenciaActivoFijo, 0) + @Cantidad
					   ,UltimaEntrada = @UltimaEntrada
					   ,UltimaSalida = @UltimaSalida
					WHERE Sucursal = @SucursalAlmacen
					AND Empresa = @Empresa
					AND Articulo = @Articulo
					AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
					AND SerieLote = @SerieLote
					AND Almacen = @Almacen
					AND ISNULL(Tarima, '') = ISNULL(@AlmacenTarima, '')
				ELSE
					UPDATE SerieLote WITH(ROWLOCK)
					SET Existencia = ISNULL(Existencia, 0) + @Cantidad
					   ,UltimaEntrada = @UltimaEntrada
					   ,UltimaSalida = @UltimaSalida
					WHERE Sucursal = @SucursalAlmacen
					AND Empresa = @Empresa
					AND Articulo = @Articulo
					AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
					AND SerieLote = @SerieLote
					AND Almacen = @Almacen
					AND ISNULL(Tarima, '') = ISNULL(@AlmacenTarima, '')

			END

			IF NOT EXISTS (SELECT * FROM SerieLote WITH(NOLOCK) WHERE Sucursal = @SucursalAlmacen AND Empresa = @Empresa AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') AND SerieLote = @SerieLote AND Almacen = @Almacen AND ISNULL(Tarima, '') = ISNULL(@AlmacenTarima, ''))
			BEGIN

				IF @AlmacenTipo = 'ACTIVOS FIJOS'
					INSERT SerieLote (Sucursal, Empresa, Articulo, SubCuenta, SerieLote, Almacen, Tarima, Propiedades, Cliente, Localizacion, ExistenciaActivoFijo, UltimaEntrada, UltimaSalida)
						VALUES (@SucursalAlmacen, @Empresa, @Articulo, @SubCuenta, @SerieLote, @Almacen, @AlmacenTarima, @Propiedades, @Cliente, @Localizacion, @Cantidad, @UltimaEntrada, @UltimaSalida)
				ELSE
					INSERT SerieLote (Sucursal, Empresa, Articulo, SubCuenta, SerieLote, Almacen, Tarima, Propiedades, Cliente, Localizacion, Existencia, ExistenciaAlterna, UltimaEntrada, UltimaSalida)
						VALUES (@SucursalAlmacen, @Empresa, @Articulo, @SubCuenta, @SerieLote, @Almacen, @AlmacenTarima, @Propiedades, @Cliente, @Localizacion, @Cantidad, @CantidadAlterna, @UltimaEntrada, @UltimaSalida)

			END

			IF NOT EXISTS (SELECT Sucursal, Empresa, Articulo, SubCuenta, SerieLote, Almacen, Tarima, Propiedades, Cliente, Localizacion, Existencia, ExistenciaAlterna, UltimaEntrada, UltimaSalida FROM SerieLote WITH(NOLOCK) WHERE SerieLote = @SerieLote AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Almacen = @Almacen AND Tarima = @AlmacenTarima AND Sucursal = @SucursalAlmacen AND Empresa = @Empresa)
			BEGIN
				INSERT SerieLote (Sucursal, Empresa, Articulo, SubCuenta, SerieLote, Almacen, Tarima, Propiedades, Cliente, Localizacion, Existencia, ExistenciaAlterna, UltimaEntrada, UltimaSalida)
					VALUES (@SucursalAlmacen, @Empresa, @Articulo, @SubCuenta, @SerieLote, @Almacen, @AlmacenTarima, @Propiedades, @Cliente, @Localizacion, @Cantidad, @CantidadAlterna, @UltimaEntrada, @UltimaSalida)
			END

			IF @ArtTipo IN ('SERIE', 'VIN')
				AND @ArtSerieLoteInfo = 0
			BEGIN

				IF @AlmacenTipo = 'ACTIVOS FIJOS'
				BEGIN

					IF (
							SELECT ISNULL(SUM(ExistenciaActivoFijo), 0)
							FROM SerieLote WITH(NOLOCK)
							WHERE Empresa = @Empresa
							AND Articulo = @Articulo
							AND SerieLote = @SerieLote
						)
						<> 1.0

						IF @Accion <> 'CANCELAR'
							SELECT @Ok = 20080

				END
				ELSE
				BEGIN

					IF (
							SELECT ISNULL(SUM(Existencia), 0)
							FROM SerieLote WITH(NOLOCK)
							WHERE Empresa = @Empresa
							AND Articulo = @Articulo
							AND SerieLote = @SerieLote
						)
						<> 1.0
						AND (((
							SELECT NotasBorrador
							FROM EmpresaCFG WITH(NOLOCK)
							WHERE Empresa = @Empresa
						)
						= 0) OR @MovTipo NOT IN ('VTAS.N', 'VTAS.NR', 'VTAS.NO'))
						SELECT @Ok = 20080

				END

			END

		END
		ELSE

		IF (@EsSalida = 1 OR @EsTransferencia = 1)
			AND @ArtSerieLoteInfo = 0
			AND @Ok IS NULL

			IF @WMS = 1
			BEGIN
				EXEC spSeriesLotesMayoreoDisminuir @Sucursal
												  ,@SucursalAlmacen
												  ,@SucursalAlmacenDestino
												  ,@Empresa
												  ,@Accion
												  ,@Almacen
												  ,@AlmacenDestino
												  ,@Articulo
												  ,@SubCuentaNull
												  ,@SubCuenta
												  ,@ArtTipo
												  ,@SerieLote
												  ,@Propiedades
												  ,@Cliente
												  ,@Localizacion
												  ,@Cantidad
												  ,@EsSalida
												  ,@EsTransferencia
												  ,@AlmacenTipo
												  ,@FechaEmision
												  ,@Ok OUTPUT
												  ,@AlmacenTarima = @AlmacenTarima
												  ,@AlmacenDestinoTarima = @AlmacenDestinoTarima
												  ,@MovTipo = @MovTipo
			END
			ELSE
				EXEC spSeriesLotesMayoreoDisminuir @Sucursal
												  ,@SucursalAlmacen
												  ,@SucursalAlmacenDestino
												  ,@Empresa
												  ,@Accion
												  ,@Almacen
												  ,@AlmacenDestino
												  ,@Articulo
												  ,@SubCuentaNull
												  ,@SubCuenta
												  ,@ArtTipo
												  ,@SerieLote
												  ,@Propiedades
												  ,@Cliente
												  ,@Localizacion
												  ,@Cantidad
												  ,@EsSalida
												  ,@EsTransferencia
												  ,@AlmacenTipo
												  ,@FechaEmision
												  ,@Ok OUTPUT
												  ,@AlmacenTarima = @AlmacenTarima
												  ,@AlmacenDestinoTarima = @AlmacenDestinoTarima
												  ,@MovTipo = @MovTipo

		IF @Ok = 20090
			AND (
				SELECT NotasBorrador
				FROM EmpresaCFG WITH(NOLOCK)
				WHERE Empresa = @Empresa
			)
			= 1
			AND @ArtTipo IN ('SERIE', 'LOTE')
			SELECT @Ok = NULL

		IF @Ok IS NULL
			EXEC spSerieLoteFlujo @Sucursal
								 ,@SucursalAlmacen
								 ,@SucursalAlmacenDestino
								 ,@Accion
								 ,@Empresa
								 ,@Modulo
								 ,@ID
								 ,@Articulo
								 ,@SubCuenta
								 ,@SerieLote
								 ,@Almacen
								 ,@RenglonID
								 ,@Tarima = @AlmacenTarima

		IF @CosteoLotes = 1
			AND (@AfectarCostos = 1 OR @MovTipo = 'COMS.CC')
			AND @ArtSerieLoteInfo = 0
			AND @Ok IS NULL
		BEGIN

			IF @MovTipo IN ('COMS.B', 'COMS.CA', 'COMS.GX')
				EXEC spBonificarCostoPromedio @ExistenciaAnterior
											 ,@Accion
											 ,@MovTipo
											 ,@Cantidad
											 ,@ArtCostoInvF
											 ,@CostoPromedio OUTPUT
			ELSE
			BEGIN

				IF @CfgValidarLotesCostoDif = 1
					AND ROUND(@ArtCostoInvF, 2) <> ROUND(@CostoPromedio, 2)

					IF (@EsEntrada = 1 AND ROUND(@ExistenciaAnterior - @Cantidad, 4) > 0.0)
						OR (@EsSalida = 1 AND ROUND(@ExistenciaAnterior + @Cantidad, 4) > 0.0)
						SELECT @Ok = 20710

				IF @Ok IS NULL
					EXEC spCalcCostoPromedio @ExistenciaAnterior
											,@EsEntrada
											,@Cantidad
											,@ArtCostoInvF
											,@CostoPromedio OUTPUT

			END

			IF (@EsEntrada = 1 AND @Accion <> 'CANCELAR')
				OR (@EsSalida = 1 AND @Accion = 'CANCELAR')
				OR @MovTipo IN ('COMS.B', 'COMS.CA', 'COMS.GX')
				UPDATE SerieLote WITH(ROWLOCK)
				SET CostoPromedio = @CostoPromedio
				WHERE Empresa = @Empresa
				AND Articulo = @Articulo
				AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
				AND SerieLote = @SerieLote
				AND Almacen = @Almacen
				AND ISNULL(Tarima, '') = ISNULL(@AlmacenTarima, '')
				AND Sucursal = @SucursalAlmacen

		END

		IF @ArtTipo = 'VIN'

			IF @EsEntrada = 1
			BEGIN
				UPDATE VIN WITH(ROWLOCK)
				SET Costo = @ArtCostoF
				   ,CostoConGastos = @ArtCostoInvF
				WHERE VIN = @SerieLote

				IF @CfgVINAccesorioArt = 1
					AND @CfgVINCostoSumaAccesorios = 1

					IF ABS(@CostoPromedio - (
							SELECT ROUND(SUM(PrecioDistribuidor), 0)
							FROM VINAccesorio WITH(NOLOCK)
							WHERE VIN = @SerieLote
							AND Estatus = 'ALTA'
						)
						) > 1.0
						SELECT @Ok = 20335
							  ,@OkRef = @SerieLote

			END
			ELSE

			IF @MovTipo IN ('VTAS.F', 'VTAS.FAR', 'VTAS.FC')
				UPDATE VIN WITH(ROWLOCK)
				SET FechaFactura = @FechaEmision
				WHERE VIN = @SerieLote
				AND FechaFactura IS NULL

		IF @Ok IS NOT NULL
			SELECT @OkRef = 'Articulo: ' + RTRIM(@Articulo) + ' ' + @SubCuentaNull + ' (' + RTRIM(@SerieLote) + ')'

		IF @CosteoLotes = 1
			AND @ArtLotesFijos = 1
		BEGIN

			IF @Temp = 1
				UPDATE #SerieLoteMov
				SET ArtCostoInv = @ArtCostoInvF * @Factor
				WHERE CURRENT OF crSerieLoteMov
			ELSE
				UPDATE SerieLoteMov WITH(ROWLOCK)
				SET ArtCostoInv = @ArtCostoInvF * @Factor
				WHERE CURRENT OF crSerieLoteMov

		END

		IF @LDI = 1
			OR @OrigenTipo = 'POS'
		BEGIN

			IF @OrigenTipo = 'POS'
				AND @Articulo = @ArticuloTarjetasDef
				EXEC spValeSerieTarjeta @Empresa
									   ,@ID
									   ,@RenglonID
									   ,@MovTipo
									   ,@Accion
									   ,@Almacen
									   ,@AlmacenTipo
									   ,@Articulo
									   ,@ArtTipo
									   ,@SerieLote
									   ,@EsEntrada
									   ,@EsSalida
									   ,@FechaEmision
									   ,@Ok OUTPUT
									   ,@OkRef OUTPUT

			IF NULLIF(@OrigenTipo, '') IS NULL
				AND @Modulo = 'VTAS'
				AND EXISTS (SELECT * FROM ValeSerie WITH(NOLOCK) WHERE Serie = @SerieLote AND Articulo = @Articulo)
				AND (@LDIArticulo = 0 OR (@LDIArticulo = 1 AND @MovTipo NOT IN ('VTAS.N')))
				EXEC spValeSerieTarjeta @Empresa
									   ,@ID
									   ,@RenglonID
									   ,@MovTipo
									   ,@Accion
									   ,@Almacen
									   ,@AlmacenTipo
									   ,@Articulo
									   ,@ArtTipo
									   ,@SerieLote
									   ,@EsEntrada
									   ,@EsSalida
									   ,@FechaEmision
									   ,@Ok OUTPUT
									   ,@OkRef OUTPUT

		END
		ELSE

		IF @Modulo = 'VTAS'
			AND EXISTS (SELECT * FROM ValeSerie WITH(NOLOCK) WHERE Serie = @SerieLote AND Articulo = @Articulo)
			EXEC spValeSerieTarjeta @Empresa
								   ,@ID
								   ,@RenglonID
								   ,@MovTipo
								   ,@Accion
								   ,@Almacen
								   ,@AlmacenTipo
								   ,@Articulo
								   ,@ArtTipo
								   ,@SerieLote
								   ,@EsEntrada
								   ,@EsSalida
								   ,@FechaEmision
								   ,@Ok OUTPUT
								   ,@OkRef OUTPUT

		IF @Ok IS NULL
			EXEC spSerieLoteConsignacion @Empresa
										,@Articulo
										,@SubCuenta
										,@SerieLote
										,@Modulo
										,@ID
										,@Accion
										,@Cantidad
										,@EsEntrada
										,@EsSalida
										,@Ok OUTPUT
										,@OkRef OUTPUT

	END

	FETCH NEXT FROM crSerieLoteMov INTO @SerieLote, @Cantidad, @CantidadAlterna, @Propiedades, @Cliente, @Localizacion, @ArtCostoInvF

	IF @@ERROR <> 0
		SELECT @Ok = 1

	END
	CLOSE crSerieLoteMov
	DEALLOCATE crSerieLoteMov
	RETURN
END
GO