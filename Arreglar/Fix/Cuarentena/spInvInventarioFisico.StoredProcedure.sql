SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spInvInventarioFisico]
 @Sucursal INT
,@ID INT
,@Empresa CHAR(5)
,@Almacen CHAR(10)
,@IDGenerar INT
,@Base CHAR(20)
,@CfgSeriesLotesMayoreo BIT
,@Estatus CHAR(15)
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
,@Modulo VARCHAR(5) = 'INV'
,@Proveedor VARCHAR(10) = NULL
AS
BEGIN
	DECLARE
		@ZonaImpuesto VARCHAR(30)
	   ,@Impuesto1 FLOAT
	   ,@Impuesto2 FLOAT
	   ,@Impuesto3 MONEY
	   ,@SucursalAlmacen INT
	   ,@RegistrarPrecios BIT
	   ,@MovAlmacen CHAR(10)
	   ,@Tarima VARCHAR(20)
	   ,@Moneda CHAR(10)
	   ,@TipoCambio FLOAT
	   ,@Articulo CHAR(20)
	   ,@ArtTipo CHAR(20)
	   ,@Renglon FLOAT
	   ,@RenglonID INT
	   ,@RenglonTipo CHAR(1)
	   ,@SubCuenta VARCHAR(50)
	   ,@Unidad VARCHAR(50)
	   ,@Cantidad FLOAT
	   ,@CantidadABS FLOAT
	   ,@CantidadA FLOAT
	   ,@Existencia FLOAT
	   ,@Factor FLOAT
	   ,@FormaCosteo VARCHAR(20)
	   ,@TipoCosteo VARCHAR(20)
	   ,@Costo FLOAT
	   ,@Precio FLOAT
	   ,@Decimales INT
	   ,@CfgMultiUnidades BIT
	   ,@CfgMultiUnidadesNivel CHAR(20)
	   ,@SeriesLotesAutoOrden VARCHAR(20)
	   ,@LotesFijos BIT
	   ,@Lote VARCHAR(50)
	   ,@Contacto VARCHAR(10)
	   ,@EnviarA INT
	   ,@FechaEmision DATETIME
	   ,@Mov VARCHAR(20)
	   ,@ContUso VARCHAR(20)
	   ,@WMSSugerirEntarimado BIT
	   ,@PosicionActual VARCHAR(10)
	   ,@PosicionReal VARCHAR(10)
	   ,@WMS BIT
	   ,@Departamento VARCHAR(50)
	   ,@Familia VARCHAR(50)
	   ,@SubFamilia VARCHAR(50)
	   ,@UEN INT
	   ,@UENTipo VARCHAR(50)
	   ,@InvFisico INT
	   ,@ArticuloBlanco VARCHAR(20)
	   ,@TarimaBlanco VARCHAR(20)
	   ,@MonedaBlanco VARCHAR(10)
	   ,@Movx VARCHAR(20)
	SELECT @ArticuloBlanco = Articulo
		  ,@TarimaBlanco = Tarima
	FROM WMSInventarioFisicoArtBlanco WITH(NOLOCK)
	SELECT @MonedaBlanco = MonedaCosto
	FROM Art WITH(NOLOCK)
	WHERE Articulo = @ArticuloBlanco
	SELECT @WMS = ISNULL(WMS, 0)
	FROM Alm WITH(NOLOCK)
	WHERE Almacen = @Almacen
	SELECT @Renglon = 0
		  ,@RenglonID = 0
		  ,@Precio = NULL
		  ,@Contacto = NULL
		  ,@EnviarA = NULL
		  ,@FechaEmision = NULL
	SELECT @SeriesLotesAutoOrden = UPPER(SeriesLotesAutoOrden)
		  ,@FormaCosteo = UPPER(FormaCosteo)
		  ,@TipoCosteo = ISNULL(NULLIF(RTRIM(UPPER(TipoCosteo)), ''), 'PROMEDIO')
		  ,@WMSSugerirEntarimado = WMSSugerirEntarimado
	FROM EmpresaCfg WITH(NOLOCK)
	WHERE Empresa = @Empresa
	SELECT @CfgMultiUnidades = MultiUnidades
		  ,@CfgMultiUnidadesNivel = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD')
		  ,@RegistrarPrecios = InvRegistrarPrecios
	FROM EmpresaCfg2 WITH(NOLOCK)
	WHERE Empresa = @Empresa
	SELECT @Moneda = Moneda
		  ,@TipoCambio = TipoCambio
	FROM Inv WITH(NOLOCK)
	WHERE ID = @IDGenerar
	SELECT @SucursalAlmacen = Sucursal
	FROM Alm WITH(NOLOCK)
	WHERE Almacen = @Almacen

	IF @WMS = 1
		AND ISNULL(@ArticuloBlanco, '') <> ''
	BEGIN
		SELECT @Base = 'TODO'

		IF NOT EXISTS (SELECT * FROM SaldoUWMS WITH(NOLOCK) WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = 'INV' AND Grupo = @Almacen AND Cuenta = @ArticuloBlanco AND SubCuenta = '' AND SubGrupo = @TarimaBlanco)
			INSERT INTO SaldoUWMS (Sucursal, Empresa, Rama, Moneda, Grupo, SubGrupo, Cuenta, SubCuenta, Saldo, SaldoU, PorConciliar, PorConciliarU, UltimoCambio)
				SELECT @Sucursal
					  ,@Empresa
					  ,'INV'
					  ,@MonedaBlanco
					  ,@Almacen
					  ,@TarimaBlanco
					  ,@ArticuloBlanco
					  ,''
					  ,0
					  ,0
					  ,0
					  ,0
					  ,GETDATE()

	END

	IF @WMS = 1
		EXEC spWMSInvInventarioFisicoSerieLote @ID
											  ,@Base
											  ,@Modulo
											  ,@Almacen
											  ,@IDGenerar
											  ,@Ok OUTPUT
											  ,@OkRef OUTPUT

	IF @Ok IS NOT NULL
		RETURN

	IF @Modulo = 'COMS'
		SELECT @Mov = Mov
			  ,@ZonaImpuesto = ZonaImpuesto
			  ,@Contacto = Proveedor
			  ,@FechaEmision = FechaEmision
		FROM Compra WITH(NOLOCK)
		WHERE ID = @IDGenerar
	ELSE
	BEGIN
		SELECT @Mov = Mov
		FROM Inv WITH(NOLOCK)
		WHERE ID = @IDGenerar
		CREATE TABLE #ExistenciaFisica (
			Articulo VARCHAR(20) COLLATE Database_Default NOT NULL
		   ,SubCuenta VARCHAR(50) COLLATE Database_Default NULL
		   ,Cantidad FLOAT NULL
		   ,CantidadA FLOAT NULL
		   ,Costo FLOAT NULL
		   ,ArtTipo VARCHAR(20) COLLATE Database_Default NULL
		   ,Unidad VARCHAR(50) COLLATE Database_Default NULL
		   ,Almacen VARCHAR(10) COLLATE Database_Default NULL
		   ,Tarima VARCHAR(20) COLLATE Database_Default NULL
		   ,ContUso VARCHAR(20) COLLATE Database_Default NULL
		   ,PosicionActual VARCHAR(10) COLLATE Database_Default NULL
		   ,PosicionReal VARCHAR(10) COLLATE Database_Default NULL
		)
		INSERT #ExistenciaFisica (Articulo, SubCuenta, Almacen, Cantidad, CantidadA, ArtTipo, Costo, ContUso, PosicionActual, PosicionReal, Tarima)
			SELECT d.Articulo
				  ,d.SubCuenta
				  ,d.Almacen
				  ,SUM(ISNULL(d.Cantidad, 0.0) * ISNULL(d.Factor, 1.0))
				  ,SUM(ISNULL(d.CantidadA, 0.0) * ISNULL(d.Factor, 1.0))
				  ,NULLIF(RTRIM(a.Tipo), '')
				  ,ac.CostoPromedio
				  ,NULLIF(d.ContUso, '')
				  ,ISNULL(d.PosicionActual, '')
				  ,ISNULL(d.PosicionReal, '')
				  ,Tarima
			FROM InvD d WITH(NOLOCK)
				,Art a WITH(NOLOCK)
				,ArtCostoSucursal ac WITH(NOLOCK)
				,Alm al WITH(NOLOCK)
			WHERE d.ID = @ID
			AND d.Articulo = a.Articulo
			AND UPPER(a.Tipo) NOT IN ('JUEGO', 'SERVICIO')
			AND ac.Articulo = a.Articulo
			AND ac.Empresa = @Empresa
			AND ac.Sucursal = @Sucursal
			AND d.Almacen = al.Almacen
			AND d.Almacen = @Almacen
			AND al.Tipo <> 'Activos Fijos'
			GROUP BY d.Articulo
					,d.SubCuenta
					,a.Tipo
					,d.Almacen
					,ac.CostoPromedio
					,NULLIF(d.ContUso, '')
					,ISNULL(d.PosicionActual, '')
					,ISNULL(d.PosicionReal, '')
					,Tarima
			ORDER BY d.Articulo, d.SubCuenta, a.Tipo, d.Almacen, ac.CostoPromedio
		INSERT #ExistenciaFisica (Articulo, SubCuenta, Almacen, Cantidad, CantidadA, ArtTipo, Costo, ContUso, PosicionActual, PosicionReal, Tarima)
			SELECT d.Articulo
				  ,d.SubCuenta
				  ,d.Almacen
				  ,SUM(ISNULL(d.Cantidad, 0.0) * ISNULL(d.Factor, 1.0))
				  ,SUM(ISNULL(d.CantidadA, 0.0) * ISNULL(d.Factor, 1.0))
				  ,NULLIF(RTRIM(a.Tipo), '')
				  ,NULL
				  ,NULLIF(d.ContUso, '')
				  ,ISNULL(d.PosicionActual, '')
				  ,ISNULL(d.PosicionReal, '')
				  ,Tarima
			FROM InvD d WITH(NOLOCK)
				,Art a WITH(NOLOCK)
			WHERE d.ID = @ID
			AND d.Articulo = a.Articulo
			AND UPPER(a.Tipo) NOT IN ('JUEGO', 'SERVICIO')
			AND a.Articulo NOT IN (SELECT Articulo FROM #ExistenciaFisica)
			GROUP BY d.Articulo
					,d.SubCuenta
					,a.Tipo
					,d.Almacen
					,NULLIF(d.ContUso, '')
					,ISNULL(d.PosicionActual, '')
					,ISNULL(d.PosicionReal, '')
					,Tarima
			ORDER BY d.Articulo, d.SubCuenta, a.Tipo, d.Almacen
	END

	CREATE INDEX idx_ArtExistenciaFisica ON #ExistenciaFisica (Articulo, Subcuenta, Almacen)

	IF @Modulo = 'COMS'
		DECLARE
			crExistencia
			CURSOR FOR
			SELECT e.Articulo
				  ,NULLIF(RTRIM(e.SubCuenta), '')
				  ,ISNULL(e.Disponible, 0.0)
				  ,NULLIF(RTRIM(Art.Tipo), '')
				  ,Art.Unidad
				  ,e.Almacen
				  ,NULLIF(RTRIM(e.Tarima), '')
				  ,Art.ContUso
			FROM ArtSubDisponibleTarima e WITH(NOLOCK)
			JOIN Art WITH(NOLOCK)
				ON Art.Articulo = e.Articulo
			WHERE e.Empresa = @Empresa
			AND e.Almacen = ISNULL(@Almacen, e.Almacen)
			AND e.Disponible > 0
			AND Art.Proveedor = @Proveedor
			OR EXISTS (SELECT * FROM ArtProv ap WHERE ap.Articulo = e.Articulo AND ap.SubCuenta = ISNULL(RTRIM(e.SubCuenta), '') AND ap.Proveedor = @Proveedor)
	ELSE

	IF @Base = 'DISPONIBLE'
		DECLARE
			crExistencia
			CURSOR FOR
			SELECT e.Articulo
				  ,NULLIF(RTRIM(e.SubCuenta), '')
				  ,ISNULL(e.Disponible, 0.0)
				  ,NULLIF(RTRIM(Art.Tipo), '')
				  ,Art.Unidad
				  ,e.Almacen
				  ,NULLIF(RTRIM(e.Tarima), '')
				  ,Art.ContUso
			FROM ArtSubDisponibleTarima e WITH(NOLOCK)
				,Art WITH(NOLOCK)
			WHERE e.Articulo = Art.Articulo
			AND e.Empresa = @Empresa
			AND e.Almacen = ISNULL(@Almacen, e.Almacen)
			AND e.Disponible > 0
	ELSE

	IF @Base = 'TODO'
		DECLARE
			crExistencia
			CURSOR FOR
			SELECT e.Articulo
				  ,NULLIF(RTRIM(e.SubCuenta), '')
				  ,ISNULL(e.Existencia, 0.0)
				  ,NULLIF(RTRIM(Art.Tipo), '')
				  ,Art.Unidad
				  ,e.Almacen
				  ,NULLIF(RTRIM(e.Tarima), '')
				  ,Art.ContUso
			FROM ArtSubExistenciaConsigAFTarima e WITH(NOLOCK)
				,Art WITH(NOLOCK)
			WHERE e.Articulo = Art.Articulo
			AND e.Empresa = @Empresa
			AND e.Almacen = ISNULL(@Almacen, e.Almacen)
			AND e.Existencia > 0
			AND UPPER(Art.Tipo) NOT IN ('JUEGO', 'SERVICIO')
	ELSE
		DECLARE
			crExistencia
			CURSOR FOR
			SELECT e.Articulo
				  ,NULLIF(RTRIM(e.SubCuenta), '')
				  ,ISNULL(e.Existencia, 0.0)
				  ,NULLIF(RTRIM(Art.Tipo), '')
				  ,Art.Unidad
				  ,e.Almacen
				  ,NULLIF(RTRIM(e.Tarima), '')
				  ,Art.ContUso
			FROM ArtSubExistenciaConsigAFTarima2 e WITH(NOLOCK)
				,Art WITH(NOLOCK)
				,InvD d WITH(NOLOCK)
			WHERE e.Articulo = Art.Articulo
			AND e.Empresa = @Empresa
			AND e.Almacen = ISNULL(@Almacen, e.Almacen)
			AND e.Existencia > 0
			AND d.ID = @ID
			AND d.Articulo = e.Articulo
			AND ISNULL(d.SubCuenta, '') = ISNULL(e.SubCuenta, '')
			AND UPPER(Art.Tipo) NOT IN ('JUEGO', 'SERVICIO')

	OPEN crExistencia
	FETCH NEXT FROM crExistencia INTO @Articulo, @SubCuenta, @Existencia, @ArtTipo, @Unidad, @MovAlmacen, @Tarima, @ContUso

	IF @@ERROR <> 0
		SELECT @Ok = 1

	WHILE @@FETCH_STATUS <> -1
	AND @Ok IS NULL
	BEGIN

	IF @@FETCH_STATUS <> -2
	BEGIN
		SELECT @PosicionActual = NULL
			  ,@PosicionReal = NULL
		SELECT @PosicionActual = Posicion
			  ,@PosicionReal = Posicion
		FROM Tarima WITH(NOLOCK)
		WHERE Tarima = @Tarima
		UPDATE #ExistenciaFisica
		SET Cantidad = Cantidad - @Existencia
		   ,CantidadA = CantidadA - @Existencia
		WHERE Articulo = @Articulo
		AND SubCuenta = @SubCuenta
		AND Almacen = @Almacen
		AND
		CASE
			WHEN @WMSSugerirEntarimado = 1 THEN Tarima
			ELSE NULLIF(RTRIM(Tarima), '')
		END = @Tarima
		AND ContUso = @ContUso

		IF @@ROWCOUNT = 0
			INSERT #ExistenciaFisica (Articulo, SubCuenta, Cantidad, CantidadA, Costo, ArtTipo, Almacen, Tarima, ContUso)
				VALUES (@Articulo, @SubCuenta, -@Existencia, -@Existencia, NULL, @ArtTipo, @MovAlmacen, @Tarima, @ContUso)

		IF @@ERROR <> 0
			SELECT @Ok = 1

	END

	FETCH NEXT FROM crExistencia INTO @Articulo, @SubCuenta, @Existencia, @ArtTipo, @Unidad, @MovAlmacen, @Tarima, @ContUso

	IF @@ERROR <> 0
		SELECT @Ok = 1

	END
	CLOSE crExistencia
	DEALLOCATE crExistencia

	IF @Base <> 'DISPONIBLE'
		AND @Modulo = 'INV'
		INSERT #ExistenciaFisica (Articulo, SubCuenta, Cantidad, CantidadA, Costo, ArtTipo, Almacen, Tarima, ContUso, PosicionActual, PosicionReal)
			SELECT d.Articulo
				  ,d.SubCuenta
				  ,d.Cantidad
				  ,d.Cantidad
				  ,NULL
				  ,a.Tipo
				  ,@Almacen
				  ,d.Tarima
				  ,a.ContUso
				  ,d.PosicionActual
				  ,d.PosicionReal
			FROM InvD d WITH(NOLOCK)
				,Art a WITH(NOLOCK)
			WHERE d.ID = @ID
			AND d.Articulo = a.Articulo
			AND d.Articulo NOT IN (SELECT Articulo FROM #ExistenciaFisica)

	EXEC spWMSInvInventarioFisico @ID
								 ,@Base
								 ,@Modulo
								 ,@Almacen
								 ,@IDGenerar
	DELETE #ExistenciaFisica
	WHERE PosicionReal = NULL
	DECLARE
		crAjuste
		CURSOR FOR
		SELECT Articulo
			  ,SubCuenta
			  ,ISNULL(Cantidad, 0.0)
			  ,ISNULL(CantidadA, 0.0)
			  ,ISNULL(Costo, 0.0)
			  ,Almacen
			  ,Tarima
			  ,ArtTipo
			  ,ContUso
			  ,PosicionActual
			  ,PosicionReal
		FROM #ExistenciaFisica
	OPEN crAjuste
	FETCH NEXT FROM crAjuste INTO @Articulo, @SubCuenta, @Cantidad, @CantidadA, @Costo, @MovAlmacen, @Tarima, @ArtTipo, @ContUso, @PosicionActual, @PosicionReal

	IF @@ERROR <> 0
		SELECT @Ok = 1

	WHILE @@FETCH_STATUS <> -1
	AND @Ok IS NULL
	BEGIN
	SELECT @Unidad = Unidad
		  ,@LotesFijos = ISNULL(LotesFijos, 0)
	FROM Art WITH(NOLOCK)
	WHERE Articulo = @Articulo

	IF @CfgMultiUnidadesNivel = 'ARTICULO'
		EXEC xpArtUnidadFactor @Articulo
							  ,@SubCuenta
							  ,@Unidad
							  ,@Factor OUTPUT
							  ,@Decimales OUTPUT
							  ,@Ok OUTPUT
	ELSE
		EXEC xpUnidadFactor @Articulo
						   ,@SubCuenta
						   ,@Unidad
						   ,@Factor OUTPUT
						   ,@Decimales OUTPUT

	SELECT @Factor = ISNULL(NULLIF(@Factor, 0), 1)

	IF @FormaCosteo = 'ARTICULO'
		SELECT @TipoCosteo = TipoCosteo
		FROM Art WITH(NOLOCK)
		WHERE Articulo = @Articulo

	EXEC spVerCosto @Sucursal
				   ,@Empresa
				   ,NULL
				   ,@Articulo
				   ,@SubCuenta
				   ,@Unidad
				   ,@TipoCosteo
				   ,@Moneda
				   ,@TipoCambio
				   ,@Costo OUTPUT
				   ,0

	IF @Estatus = 'PENDIENTE'
		SELECT @Cantidad = @CantidadA

	SELECT @CantidadABS = ISNULL(@Cantidad, 0.0)

	IF @Base = 'DISPONIBLE'
		SELECT @CantidadABS = -@CantidadABS

	IF @@FETCH_STATUS <> -2
		AND ISNULL(@CantidadABS, 0.0) <> 0.0
	BEGIN
		SELECT @Renglon = @Renglon + 2048
			  ,@RenglonID = @RenglonID + 1
			  ,@Lote = NULL

		IF @CantidadABS < 0.0
			SELECT @Costo = NULL

		EXEC spRenglonTipo @ArtTipo
						  ,@SubCuenta
						  ,@RenglonTipo OUTPUT

		IF @RegistrarPrecios = 1
			EXEC spPrecioEsp '(Precio Lista)'
							,@Moneda
							,@Articulo
							,@SubCuenta
							,@Precio OUTPUT

		IF @LotesFijos = 1
		BEGIN

			IF @SeriesLotesAutoOrden = 'ASCENDENTE'
				SELECT @Lote = (
					 SELECT TOP 1 Lote
					 FROM ArtLoteFijo WITH(NOLOCK)
					 WHERE Articulo = @Articulo
					 ORDER BY Lote DESC
				 )
			ELSE
				SELECT @Lote = (
					 SELECT TOP 1 Lote
					 FROM ArtLoteFijo WITH(NOLOCK)
					 WHERE Articulo = @Articulo
					 ORDER BY Lote
				 )

			SELECT @Lote = NULLIF(RTRIM(@Lote), '')

			IF @Lote IS NOT NULL
				SELECT @Costo = MIN(CostoPromedio) * @Factor
				FROM SerieLote WITH(NOLOCK)
				WHERE Empresa = @Empresa
				AND Articulo = @Articulo
				AND SubCuenta = ISNULL(@SubCuenta, '')
				AND SerieLote = @Lote
				AND Almacen = @MovAlmacen
				AND Tarima = @Tarima

		END

		IF @Modulo = 'COMS'
		BEGIN
			SELECT @Impuesto1 = Impuesto1
				  ,@Impuesto2 = Impuesto2
				  ,@Impuesto3 = Impuesto3
			FROM Art WITH(NOLOCK)
			WHERE Articulo = @Articulo
			EXEC spZonaImp @ZonaImpuesto
						  ,@Impuesto1 OUTPUT
			EXEC spZonaImp @ZonaImpuesto
						  ,@Impuesto2 OUTPUT
			EXEC spZonaImp @ZonaImpuesto
						  ,@Impuesto3 OUTPUT
			EXEC spTipoImpuesto @Modulo
							   ,@IDGenerar
							   ,@Mov
							   ,@FechaEmision
							   ,@Empresa
							   ,@Sucursal
							   ,@Contacto
							   ,@EnviarA
							   ,@Articulo = @Articulo
							   ,@EnSilencio = 1
							   ,@Impuesto1 = @Impuesto1 OUTPUT
							   ,@Impuesto2 = @Impuesto2 OUTPUT
							   ,@Impuesto3 = @Impuesto3 OUTPUT
			INSERT INTO CompraD (Sucursal, ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Articulo, SubCuenta, Cantidad, CantidadInventario, Unidad, Costo, Almacen, Tarima, Impuesto1, Impuesto2, Impuesto3)
				VALUES (@Sucursal, @IDGenerar, @Renglon, 0, @RenglonID, @RenglonTipo, @Articulo, @SubCuenta, @CantidadABS / @Factor, @CantidadABS, @Unidad, @Costo, @MovAlmacen, @Tarima, @Impuesto1, @Impuesto2, @Impuesto3)
		END
		ELSE
			INSERT INTO InvD (Sucursal, ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Articulo, SubCuenta, Cantidad, CantidadInventario, Unidad, Costo, Precio, Almacen, Tarima, ContUso, PosicionActual, PosicionReal)
				VALUES (@Sucursal, @IDGenerar, @Renglon, 0, @RenglonID, @RenglonTipo, @Articulo, @SubCuenta, @CantidadABS / @Factor, @CantidadABS, @Unidad, @Costo, @Precio, @MovAlmacen, @Tarima, @ContUso, @PosicionActual, @PosicionReal)

		IF @@ERROR <> 0
			SELECT @Ok = 1

		IF @LotesFijos = 1
			AND @Lote IS NOT NULL
			AND @CantidadABS > 0
			INSERT SerieLoteMov (Empresa, Sucursal, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad)
				VALUES (@Empresa, @Sucursal, @Modulo, @IDGenerar, @RenglonID, @Articulo, ISNULL(@SubCuenta, ''), @Lote, @CantidadABS)
		ELSE

		IF UPPER(@ArtTipo) IN ('SERIE', 'LOTE', 'VIN', 'PARTIDA')
			AND @Cantidad < 0
		BEGIN
			INSERT INTO SerieLoteMov (Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Tarima)
				SELECT @Empresa
					  ,@Modulo
					  ,@IDGenerar
					  ,@RenglonID
					  ,@Articulo
					  ,ISNULL(@SubCuenta, '')
					  ,sl.SerieLote
					  ,CASE
						   WHEN UPPER(@ArtTipo) = 'LOTE' THEN ABS(ISNULL(sl.Existencia, 0.0) - ISNULL(slm.Cantidad, 0.0))
						   ELSE ISNULL(@Existencia, 0.0)
					   END
					  ,@Tarima
				FROM SerieLote sl WITH(NOLOCK)
				LEFT OUTER JOIN SerieLoteMov slm WITH(NOLOCK)
					ON slm.Empresa = @Empresa
					AND slm.Modulo = @Modulo
					AND slm.ID = @ID
					AND slm.Articulo = @Articulo
					AND slm.SubCuenta = ISNULL(@SubCuenta, '')
					AND slm.SerieLote = sl.SerieLote
				WHERE sl.Sucursal = @Sucursal
				AND sl.Empresa = @Empresa
				AND sl.Articulo = @Articulo
				AND sl.SubCuenta = ISNULL(@SubCuenta, '')
				AND sl.Almacen = @Almacen
				AND sl.Tarima = @Tarima
				AND ISNULL(sl.Existencia, 0.0) <> ISNULL(slm.Cantidad, 0.0)
		END

	END

	FETCH NEXT FROM crAjuste INTO @Articulo, @SubCuenta, @Cantidad, @CantidadA, @Costo, @MovAlmacen, @Tarima, @ArtTipo, @ContUso, @PosicionActual, @PosicionReal

	IF @@ERROR <> 0
		SELECT @Ok = 1

	END
	CLOSE crAjuste
	DEALLOCATE crAjuste

	IF @WMS = 1
		EXEC spWMSInventarioFisicoCambioArticulo @Sucursal
												,@ID
												,@Empresa
												,@Almacen
												,@IDGenerar
												,@Base
												,@CfgSeriesLotesMayoreo
												,@Estatus
												,@Ok OUTPUT
												,@OkRef OUTPUT

	IF @Modulo = 'COMS'
	BEGIN
		UPDATE Compra WITH(ROWLOCK)
		SET RenglonID = @RenglonID + 1
		WHERE ID = @IDGenerar
		DELETE CompraD
		WHERE ID = @IDGenerar
			AND NULLIF(ROUND(Cantidad, 10), 0) IS NULL
	END
	ELSE
	BEGIN
		UPDATE Inv WITH(ROWLOCK)
		SET RenglonID = @RenglonID + 1
		WHERE ID = @IDGenerar
		DELETE InvD
		WHERE ID = @IDGenerar
			AND NULLIF(ROUND(Cantidad, 10), 0) IS NULL
	END

	IF @@ERROR <> 0
		SELECT @Ok = 1

	IF NOT EXISTS (SELECT * FROM InvD WITH(NOLOCK) WHERE ID = @IDGenerar)
	BEGIN

		IF @Modulo = 'COMS'
			DELETE Compra
			WHERE ID = @IDGenerar
		ELSE
			DELETE Inv
			WHERE ID = @IDGenerar

		SELECT @Ok = 80070
	END

	EXEC xpInvInventarioFisico @Sucursal
							  ,@ID
							  ,@Empresa
							  ,@Almacen
							  ,@IDGenerar
							  ,@Base
							  ,@CfgSeriesLotesMayoreo
							  ,@Estatus
							  ,@Ok OUTPUT
							  ,@OkRef OUTPUT
							  ,@Modulo
							  ,@Proveedor
	RETURN
END
GO