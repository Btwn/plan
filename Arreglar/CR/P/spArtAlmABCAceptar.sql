SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spArtAlmABCAceptar]
 @Estacion INT
,@Modulo CHAR(5)
,@ID INT
AS
BEGIN
	DECLARE
		@Articulo CHAR(20)
	   ,@ArtTipo VARCHAR(20)
	   ,@Almacen CHAR(10)
	   ,@Sucursal INT
	   ,@Renglon FLOAT
	   ,@RenglonID INT
	   ,@RenglonTipo CHAR(1)
	   ,@Unidad VARCHAR(50)

	IF @Modulo = 'INV'
	BEGIN
		SELECT @Sucursal = Sucursal
			  ,@Almacen = Almacen
			  ,@RenglonID = ISNULL(RenglonID, 0)
		FROM Inv
		WHERE ID = @ID
		SELECT @Renglon = ISNULL(MAX(Renglon), 0.0)
		FROM InvD
		WHERE ID = @ID
	END

	DECLARE
		crLista
		CURSOR FOR
		SELECT Clave
		FROM ListaSt
		WHERE Estacion = @Estacion
		ORDER BY ID
	OPEN crLista
	FETCH NEXT FROM crLista INTO @Articulo
	WHILE @@FETCH_STATUS <> -1
	BEGIN

	IF @@FETCH_STATUS <> -2
	BEGIN

		IF NOT EXISTS (SELECT * FROM InvD WHERE ID = @ID AND Articulo = @Articulo)
		BEGIN
			SELECT @Renglon = @Renglon + 2048.0
				  ,@RenglonID = @RenglonID + 1
			SELECT @ArtTipo = Tipo
				  ,@Unidad = Unidad
			FROM Art
			WHERE Articulo = @Articulo
			EXEC spRenglonTipo @ArtTipo
							  ,NULL
							  ,@RenglonTipo OUTPUT

			IF @Modulo = 'INV'
				INSERT InvD (ID, Renglon, RenglonTipo, RenglonID, Articulo, Almacen, Sucursal, Unidad)
					VALUES (@ID, @Renglon, @RenglonTipo, @RenglonID, @Articulo, @Almacen, @Sucursal, @Unidad)

		END

	END

	FETCH NEXT FROM crLista INTO @Articulo
	END
	CLOSE crLista
	DEALLOCATE crLista

	IF @Modulo = 'INV'
		UPDATE Inv
		SET RenglonID = @RenglonID
		WHERE ID = @ID

	RETURN
END

