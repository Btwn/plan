SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spVentaCteDComponentes]
 @Sucursal INT
,@VentaID INT
,@VentaDRenglon FLOAT
,@VentaDRenglonSub INT
,@VentaDCantidad FLOAT
,@MovTipo CHAR(20)
,@ID INT
,@Almacen CHAR(10)
,@Renglon FLOAT
,@RenglonID INT
,@CopiarAplicacion BIT = 0
,@Empresa VARCHAR(5) = NULL
,@CfgSeriesLotesAutoOrden VARCHAR(20) = NULL
AS
BEGIN
	DECLARE
		@Salir BIT
	   ,@CantidadOriginal FLOAT
	   ,@RenglonSub INT
	   ,@Cantidad FLOAT
	   ,@CantidadInventario FLOAT
	   ,@Unidad VARCHAR(50)
	   ,@RenglonTipo CHAR(1)
	   ,@RenglonD FLOAT
	   ,@RenglonDSub INT
	   ,@ArtTipo VARCHAR(20)
	   ,@Articulo VARCHAR(20)
	   ,@Subcuenta VARCHAR(50)
	   ,@Financiamiento FLOAT
	SELECT @Salir = 0
		  ,@RenglonSub = 0
	SELECT @CantidadOriginal = ISNULL(Cantidad, 0.0)
	FROM VentaD
	WHERE ID = @VentaID
	AND Renglon = @VentaDRenglon
	AND RenglonSub = @VentaDRenglonSub

	IF @CantidadOriginal = 0
		RETURN

	DECLARE
		crJuego
		CURSOR FOR
		SELECT Financiamiento
			  ,Cantidad
			  ,(@VentaDCantidad * CantidadInventario / NULLIF(@CantidadOriginal, 0.0))
			  ,Unidad
			  ,RenglonTipo
			  ,Renglon
			  ,RenglonSub
			  ,Articulo
			  ,Subcuenta
		FROM VentaD
		WHERE ID = @VentaID
		AND Renglon > @VentaDRenglon
	OPEN crJuego
	FETCH NEXT FROM crJuego INTO @Financiamiento, @Cantidad, @CantidadInventario, @Unidad, @RenglonTipo, @RenglonD, @RenglonDSub, @Articulo, @Subcuenta
	WHILE @@FETCH_STATUS <> -1
	AND @Salir = 0
	BEGIN

	IF @RenglonTipo NOT IN ('C', 'E')
		SELECT @Salir = 1

	IF @@FETCH_STATUS <> -2
		AND @Salir = 0
	BEGIN
		SELECT @ArtTipo = Tipo
		FROM ART
		WHERE Articulo = @Articulo
		SELECT @Cantidad = @VentaDCantidad * @Cantidad / @CantidadOriginal
		SELECT @RenglonSub = @RenglonSub + 1
		INSERT VentaD (Financiamiento, IDCopiaMAVI, Sucursal, ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Almacen, Articulo, Subcuenta, Cantidad, CantidadInventario, Unidad, Precio, DescuentoTipo, DescuentoLinea, Impuesto1, Impuesto2, Impuesto3,
		Costo, ContUso, Aplica, AplicaID)
			SELECT @Financiamiento
				  ,@VentaID
				  ,@Sucursal
				  ,@ID
				  ,@Renglon
				  ,@RenglonSub
				  ,@RenglonID
				  ,@RenglonTipo
				  ,@Almacen
				  ,Articulo
				  ,Subcuenta
				  ,@Cantidad
				  ,@CantidadInventario
				  ,@Unidad
				  ,Precio
				  ,DescuentoTipo
				  ,DescuentoLinea
				  ,Impuesto1
				  ,Impuesto2
				  ,Impuesto3
				  ,CASE
					   WHEN @MovTipo IN ('VTAS.D', 'VTAS.DF', 'VTAS.SD', 'VTAS.DFC') THEN Costo
					   ELSE NULL
				   END
				  ,ContUso
				  ,CASE
					   WHEN @CopiarAplicacion = 0 THEN NULL
					   ELSE Aplica
				   END
				  ,CASE
					   WHEN @CopiarAplicacion = 0 THEN NULL
					   ELSE AplicaID
				   END
			FROM VentaD
			WHERE ID = @VentaID
			AND Renglon = @RenglonD
			AND RenglonSub = @RenglonDSub

		IF @ArtTipo IN ('Serie', 'Lote')
			EXEC spVentaCteDSerieLote @Empresa
									 ,@Sucursal
									 ,@CfgSeriesLotesAutoOrden
									 ,@ID
									 ,@RenglonD
									 ,@RenglonID
									 ,@VentaID
									 ,@Articulo
									 ,@SubCuenta
									 ,@Cantidad

	END

	FETCH NEXT FROM crJuego INTO @Financiamiento, @Cantidad, @CantidadInventario, @Unidad, @RenglonTipo, @RenglonD, @RenglonDSub, @Articulo, @Subcuenta
	END
	CLOSE crJuego
	DEALLOCATE crJuego
END

