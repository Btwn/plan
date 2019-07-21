SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spModificarAlmacenPedidos]
 @ID INT
,@Almacen CHAR(10)
,@Reservar CHAR(2) = 'NO'
AS
BEGIN
	DECLARE
		@Renglon FLOAT
	   ,@RenglonSub INT
	   ,@AlmacenTipo CHAR(20)
	SELECT @Almacen = Almacen
		  ,@AlmacenTipo = Tipo
	FROM Alm
	WHERE UPPER(Almacen) = UPPER(@Almacen)

	IF @Almacen IS NULL
		RETURN

	IF (EXISTS (SELECT Id FROM VentaD WHERE ID = @ID AND (ISNULL(CantidadReservada, 0) > 0 OR ISNULL(CantidadOrdenada, 0) > 0))
		)
	BEGIN
		RAISERROR ('Tiene Articulos Reservados y/o Ordenados, No se puede cambiar el Almacen', 16, -1)
		RETURN
	END

	IF @AlmacenTipo <> (
			SELECT Alm.Tipo
			FROM Venta
				,Alm
			WHERE Venta.ID = @ID
			AND Alm.Almacen = Venta.Almacen
		)
	BEGIN
		RAISERROR ('Los Almacenes deben de ser del Mismo Tipo', 16, -1)
		RETURN
	END

	BEGIN TRANSACTION
	UPDATE Venta
	SET Almacen = @Almacen
	WHERE ID = @ID
	UPDATE Venta
	SET SucursalDestino = (
		SELECT TOP 1 Sucursal
		FROM ALM
		WHERE almacen LIKE 'v%'
		AND Almacen = @Almacen
	)
	WHERE ID = @ID
	DECLARE
		crVentaD
		CURSOR FOR
		SELECT Renglon
			  ,RenglonSub
		FROM VentaD
		WHERE ID = @ID
	OPEN crVentaD
	FETCH NEXT FROM crVentaD INTO @Renglon, @RenglonSub
	WHILE @@FETCH_STATUS <> -1
	BEGIN

	IF @@FETCH_STATUS <> -2
	BEGIN
		UPDATE VentaD
		SET Almacen = @Almacen
		WHERE ID = @ID
		AND Renglon = @Renglon
		AND RenglonSub = @RenglonSub
	END

	FETCH NEXT FROM crVentaD INTO @Renglon, @RenglonSub
	END
	CLOSE crVentaD
	DEALLOCATE crVentaD
	COMMIT TRANSACTION

	IF UPPER(@Reservar) <> 'NO'
		EXEC spAfectar 'VTAS'
					  ,@ID
					  ,'RESERVARPARCIAL'
					  ,'PENDIENTE'
					  ,NULL
	ELSE
		SELECT NULL
			  ,NULL
			  ,NULL
			  ,NULL
			  ,NULL

	RETURN
END

