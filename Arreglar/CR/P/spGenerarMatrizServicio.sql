SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spGenerarMatrizServicio]
 @Estacion INT
,@ID INT
AS
BEGIN
	DECLARE
		@Ok INT
	   ,@OkRef VARCHAR(255)
	   ,@Renglon FLOAT
	   ,@RenglonID INT
	   ,@Articulo CHAR(20)
	   ,@SubCuenta VARCHAR(50)
	   ,@Precio FLOAT
	   ,@Cantidad FLOAT
	   ,@Unidad VARCHAR(50)
	   ,@ArtTipo VARCHAR(20)
	   ,@RenglonTipo CHAR(1)
	   ,@Impuesto1 FLOAT
	   ,@Impuesto2 FLOAT
	   ,@Impuesto3 MONEY
	   ,@ZonaImpuesto VARCHAR(50)
	   ,@Empresa CHAR(5)
	   ,@Sucursal INT
	   ,@Almacen CHAR(10)
	   ,@ListaPrecios VARCHAR(50)
	   ,@ListaPreciosEsp VARCHAR(50)
	   ,@ServicioTipo VARCHAR(50)
	   ,@MovMoneda CHAR(10)
	   ,@MovTipoCambio FLOAT
	   ,@FechaRequerida DATETIME
	   ,@FechaEmision DATETIME
	   ,@Contacto VARCHAR(10)
	   ,@EnviarA INT
	   ,@Mov VARCHAR(20)
	   ,@Factor FLOAT
	SELECT @Renglon = 0.0
		  ,@RenglonID = 0
	DELETE VentaD
	WHERE ID = @ID
	SELECT @Empresa = Empresa
		  ,@Sucursal = Sucursal
		  ,@Almacen = Almacen
		  ,@ListaPrecios = ListaPreciosEsp
		  ,@MovMoneda = Moneda
		  ,@MovTipoCambio = TipoCambio
		  ,@FechaRequerida = FechaRequerida
		  ,@ZonaImpuesto = ZonaImpuesto
		  ,@FechaEmision = FechaEmision
		  ,@Contacto = Cliente
		  ,@EnviarA = EnviarA
		  ,@Mov = Mov
	FROM Venta
	WHERE ID = @ID
	DECLARE
		crServicioMatriz
		CURSOR FOR
		SELECT m.Articulo
			  ,m.SubCuenta
			  ,ISNULL(NULLIF(m.Cantidad, 0.0), 1.0)
			  ,ISNULL(m.Unidad, a.Unidad)
			  ,a.Tipo
			  ,a.Impuesto1
			  ,a.Impuesto2
			  ,a.Impuesto3
			  ,NULLIF(m.PrecioEsp, 0.0)
			  ,NULLIF(RTRIM(m.ListaPreciosEsp), '')
		FROM ServicioMatriz m
			,Art a
			,ListaID l
		WHERE m.ID = l.ID
		AND l.Estacion = @Estacion
		AND a.Articulo = m.Articulo
		ORDER BY m.ID
	OPEN crServicioMatriz
	FETCH NEXT FROM crServicioMatriz INTO @Articulo, @SubCuenta, @Cantidad, @Unidad, @ArtTipo, @Impuesto1, @Impuesto2, @Impuesto3, @Precio, @ListaPreciosEsp
	WHILE @@FETCH_STATUS <> -1
	AND @Ok IS NULL
	BEGIN

	IF @@FETCH_STATUS <> -2
		AND @Ok IS NULL
	BEGIN
		SELECT @Renglon = @Renglon + 2048.0
			  ,@RenglonID = @RenglonID + 1
		EXEC spRenglonTipo @ArtTipo
						  ,@SubCuenta
						  ,@RenglonTipo OUTPUT

		IF @Precio IS NULL
		BEGIN

			IF @ListaPreciosEsp IS NOT NULL
				EXEC spPCGet @Sucursal
							,@Empresa
							,@Articulo
							,@SubCuenta
							,@Unidad
							,@MovMoneda
							,@MovTipoCambio
							,@ListaPreciosEsp
							,@Precio OUTPUT
			ELSE
				EXEC spPCGet @Sucursal
							,@Empresa
							,@Articulo
							,@SubCuenta
							,@Unidad
							,@MovMoneda
							,@MovTipoCambio
							,@ListaPrecios
							,@Precio OUTPUT

		END

		EXEC spZonaImp @ZonaImpuesto
					  ,@Impuesto1 OUTPUT
		EXEC spZonaImp @ZonaImpuesto
					  ,@Impuesto2 OUTPUT
		EXEC spZonaImp @ZonaImpuesto
					  ,@Impuesto3 OUTPUT
		EXEC spTipoImpuesto 'VTAS'
						   ,@ID
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
		SELECT @Factor = dbo.fnArtUnidadFactor(@Empresa, @Articulo, @Unidad)
		INSERT VentaD (ID, Renglon, RenglonID, RenglonTipo, Articulo, SubCuenta, Cantidad, Unidad, Precio, Almacen, FechaRequerida, Impuesto1, Impuesto2, Impuesto3)
			VALUES (@ID, @Renglon, @RenglonID, @RenglonTipo, @Articulo, @SubCuenta, @Cantidad, @Unidad, @Precio, @Almacen, @FechaRequerida, @Impuesto1, @Impuesto2, @Impuesto3 * @Factor)

		IF UPPER(@ArtTipo) = 'JUEGO'
			EXEC spInsertarJuegoOmision @Empresa
									   ,@Sucursal
									   ,@ID
									   ,@Articulo
									   ,@Cantidad
									   ,@Almacen
									   ,@FechaRequerida
									   ,@MovMoneda
									   ,@MovTipoCambio
									   ,@Renglon OUTPUT
									   ,@RenglonID OUTPUT

	END

	FETCH NEXT FROM crServicioMatriz INTO @Articulo, @SubCuenta, @Cantidad, @Unidad, @ArtTipo, @Impuesto1, @Impuesto2, @Impuesto3, @Precio, @ListaPreciosEsp
	END
	CLOSE crServicioMatriz
	DEALLOCATE crServicioMatriz
	UPDATE Venta
	SET RenglonID = @RenglonID
	WHERE ID = @ID
	DELETE ListaID
	WHERE Estacion = @Estacion
	RETURN
END

