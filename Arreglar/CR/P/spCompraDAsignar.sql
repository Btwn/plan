SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spCompraDAsignar]
 @Estacion INT
,@ID INT
AS
BEGIN
	DECLARE
		@Mov CHAR(20)
	   ,@MovID VARCHAR(20)
	   ,@Renglon FLOAT
	   ,@RenglonID INT
	   ,@LModulo CHAR(5)
	   ,@LID INT
	   ,@LRenglon FLOAT
	   ,@LRenglonSub INT
	   ,@FechaEmision DATETIME
	   ,@FechaRequerida DATETIME
	   ,@FechaEntrega DATETIME
	   ,@Articulo CHAR(20)
	   ,@SubCuenta VARCHAR(50)
	   ,@Costo FLOAT
	   ,@ContUso CHAR(20)
	   ,@DescuentoTipo CHAR(1)
	   ,@DescuentoLinea FLOAT
	   ,@DescuentoImporte FLOAT
	   ,@Paquete INT
	   ,@RenglonTipo CHAR(1)
	   ,@Almacen CHAR(10)
	   ,@Proveedor CHAR(10)
	   ,@Cantidad FLOAT
	   ,@CantidadInventario FLOAT
	   ,@Unidad VARCHAR(50)
	   ,@DescripcionExtra VARCHAR(100)
	   ,@Impuesto1 FLOAT
	   ,@Impuesto2 FLOAT
	   ,@Impuesto3 MONEY
	   ,@Retencion1 FLOAT
	   ,@Retencion2 FLOAT
	   ,@Retencion3 FLOAT
	SELECT @Renglon = 0.0
		  ,@RenglonID = 0
		  ,@Proveedor = NULL
		  ,@Mov = NULL
		  ,@MovID = NULL
	SELECT @Renglon = ISNULL(MAX(Renglon), 0.0)
		  ,@RenglonID = ISNULL(MAX(RenglonID), 0)
	FROM VentaD
	WHERE ID = @ID
	BEGIN TRANSACTION
	DECLARE
		crLista
		CURSOR FOR
		SELECT Modulo
			  ,ID
			  ,Renglon
			  ,RenglonSub
		FROM ListaIDRenglon
		WHERE Estacion = @Estacion
		ORDER BY IDInterno
	OPEN crLista
	FETCH NEXT FROM crLista INTO @LModulo, @LID, @LRenglon, @LRenglonSub
	WHILE @@FETCH_STATUS <> -1
	BEGIN

	IF @@FETCH_STATUS <> -2
	BEGIN

		IF @Mov IS NULL
			SELECT @Mov = Mov
				  ,@MovID = MovID
			FROM Compra
			WHERE ID = @LID

		SELECT @DescripcionExtra = NULL
		SELECT @RenglonTipo = RenglonTipo
			  ,@Articulo = d.Articulo
			  ,@SubCuenta = d.SubCuenta
			  ,@Almacen = d.Almacen
			  ,@Cantidad = ISNULL(d.Cantidad, 0.0) - ISNULL(d.CantidadCancelada, 0.0)
			  ,@Unidad = d.Unidad
			  ,@FechaRequerida = d.FechaRequerida
			  ,@DescripcionExtra = d.DescripcionExtra
			  ,@Costo = d.Costo
			  ,@DescuentoTipo = d.DescuentoTipo
			  ,@DescuentoLinea = d.DescuentoLinea
			  ,@DescuentoImporte = d.DescuentoImporte
			  ,@Impuesto1 = d.Impuesto1
			  ,@Impuesto2 = d.Impuesto2
			  ,@Impuesto3 = d.Impuesto3
			  ,@Retencion1 = d.Retencion1
			  ,@Retencion2 = d.Retencion2
			  ,@Retencion3 = d.Retencion3
			  ,@CantidadInventario = d.CantidadInventario
			  ,@Paquete = d.Paquete
			  ,@ContUso = ContUso
		FROM CompraD d
		WHERE d.ID = @LID
		AND d.Renglon = @LRenglon
		AND d.RenglonSub = @LRenglonSub
		SELECT @Renglon = @Renglon + 2048.0
			  ,@RenglonID = @RenglonID + 1
		INSERT CompraD (ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Articulo, SubCuenta, Almacen, Cantidad, Unidad, FechaRequerida, Impuesto1, Impuesto2, Impuesto3, Retencion1, Retencion2, Retencion3, DescripcionExtra, Costo, DescuentoTipo, DescuentoLinea, DescuentoImporte, Paquete, CantidadInventario, ContUso, IDCopiaMAVI)
			VALUES (@ID, @Renglon, 0, @RenglonID, @RenglonTipo, @Articulo, @SubCuenta, @Almacen, @Cantidad, @Unidad, @FechaRequerida, @Impuesto1, @Impuesto2, @Impuesto3, @Retencion1, @Retencion2, @Retencion3, @DescripcionExtra, @Costo, @DescuentoTipo, @DescuentoLinea, @DescuentoImporte, @Paquete, @CantidadInventario, @ContUso, @LID)
	END

	FETCH NEXT FROM crLista INTO @LModulo, @LID, @LRenglon, @LRenglonSub
	END
	CLOSE crLista
	DEALLOCATE crLista
	UPDATE Compra
	SET Referencia = RTRIM(@Mov) + ' ' + RTRIM(@MovID)
	WHERE ID = @ID
	AND NULLIF(RTRIM(Referencia), '') IS NULL
	DELETE ListaIDRenglon
	WHERE Estacion = @Estacion
	COMMIT TRANSACTION
	RETURN
END

