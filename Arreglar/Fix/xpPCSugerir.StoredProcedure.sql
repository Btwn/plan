SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[xpPCSugerir]
@ID INT
AS
BEGIN
	DECLARE
		@Sucursal INT
	   ,@Empresa CHAR(5)
	   ,@Articulo CHAR(20)
	   ,@SubCuenta VARCHAR(50)
	   ,@Unidad VARCHAR(50)
	   ,@Moneda CHAR(10)
	   ,@TipoCambio FLOAT
	   ,@Lista VARCHAR(20)
	   ,@Precio MONEY
	   ,@Nuevo MONEY
	   ,@Anterior MONEY
	   ,@Renglon FLOAT
	   ,@MovTipo CHAR(20)
	   ,@PrecioNivelUnidad BIT
	SELECT @Sucursal = pc.Sucursal
		  ,@Empresa = pc.Empresa
		  ,@Lista = pc.ListaModificar
		  ,@Moneda = pc.Moneda
		  ,@TipoCambio = pc.TipoCambio
		  ,@MovTipo = mt.Clave
	FROM PC WITH(NOLOCK)
		,MovTipo mt
	WHERE pc.ID = @ID
	AND mt.Modulo = 'PC'
	AND mt.Mov = pc.Mov
	SELECT @PrecioNivelUnidad = ISNULL(PrecioNivelUnidad, 0)
	FROM EmpresaCfg2 WITH(NOLOCK)
	WHERE Empresa = @Empresa
	DELETE PCD
	WHERE ID = @ID
	SELECT @Renglon = 0

	IF @PrecioNivelUnidad = 1
	BEGIN

		IF EXISTS (SELECT * FROM ListaPreciosSubUnidad WITH(NOLOCK) WHERE Lista = @Lista AND Moneda = @Moneda)
			DECLARE
				crPCSugerir
				CURSOR FOR
				SELECT Articulo
					  ,SubCuenta
					  ,Unidad
					  ,MIN(Precio)
				FROM ListaPreciosSubUnidad WITH(NOLOCK)
				WHERE Lista = @Lista
				AND Moneda = @Moneda
				AND ISNULL(Precio, 0.0) > 0.0
				GROUP BY Articulo
						,SubCuenta
						,Unidad
				ORDER BY Articulo, SubCuenta, Unidad
		ELSE
			DECLARE
				crPCSugerir
				CURSOR FOR
				SELECT Articulo
					  ,CONVERT(VARCHAR, NULL)
					  ,Unidad
					  ,MIN(Precio)
				FROM ListaPreciosDUnidad WITH(NOLOCK)
				WHERE Lista = @Lista
				AND Moneda = @Moneda
				AND ISNULL(Precio, 0.0) > 0.0
				GROUP BY Articulo
						,Unidad
				ORDER BY Articulo, Unidad

	END
	ELSE
	BEGIN

		IF EXISTS (SELECT * FROM ListaPreciosSub WITH(NOLOCK) WHERE Lista = @Lista AND Moneda = @Moneda)
			DECLARE
				crPCSugerir
				CURSOR FOR
				SELECT Articulo
					  ,SubCuenta
					  ,CONVERT(VARCHAR, NULL)
					  ,MIN(Precio)
				FROM ListaPreciosSub WITH(NOLOCK)
				WHERE Lista = @Lista
				AND Moneda = @Moneda
				AND ISNULL(Precio, 0.0) > 0.0
				GROUP BY Articulo
						,SubCuenta
				ORDER BY Articulo, SubCuenta
		ELSE
			DECLARE
				crPCSugerir
				CURSOR FOR
				SELECT Articulo
					  ,CONVERT(VARCHAR, NULL)
					  ,CONVERT(VARCHAR, NULL)
					  ,MIN(Precio)
				FROM ListaPreciosD WITH(NOLOCK)
				WHERE Lista = @Lista
				AND Moneda = @Moneda
				AND ISNULL(Precio, 0.0) > 0.0
				GROUP BY Articulo
				ORDER BY Articulo

	END

	OPEN crPCSugerir
	FETCH NEXT FROM crPCSugerir INTO @Articulo, @SubCuenta, @Unidad, @Precio
	WHILE @@FETCH_STATUS <> -1
	AND @@Error = 0
	BEGIN

	IF @@FETCH_STATUS <> -2
	BEGIN
		SELECT @Renglon = @Renglon + 2048.0
			  ,@Nuevo = @Precio
		EXEC spPCGet @Sucursal
					,@Empresa
					,@Articulo
					,@SubCuenta
					,@Unidad
					,@Moneda
					,@TipoCambio
					,@Lista
					,@Anterior OUTPUT
					,0

		IF @Nuevo <> @Anterior
		BEGIN

			IF @MovTipo = 'PC.C'
				INSERT PCD (ID, Renglon, Articulo, SubCuenta, Unidad, Nuevo, Anterior, Sucursal)
					VALUES (@ID, @Renglon, @Articulo, @SubCuenta, @Unidad, @Anterior, @Nuevo, @Sucursal)
			ELSE
				INSERT PCD (ID, Renglon, Articulo, SubCuenta, Unidad, Nuevo, Anterior, Sucursal)
					VALUES (@ID, @Renglon, @Articulo, @SubCuenta, @Unidad, @Nuevo, @Anterior, @Sucursal)

		END

		FETCH NEXT FROM crPCSugerir INTO @Articulo, @SubCuenta, @Unidad, @Precio
	END

	END
	CLOSE crPCSugerir
	DEALLOCATE crPCSugerir
	RETURN
END
GO