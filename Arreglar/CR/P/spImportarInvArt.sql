SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spImportarInvArt
@Estacion 	int,
@ID		int,
@Sucursal	int

AS BEGIN
SET nocount ON
DECLARE
@Empresa		char(5),
@Cliente		char(10),
@Renglon		float,
@RenglonID		int,
@Articulo		char(20),
@UltArticulo	char(20),
@ArtTipo		char(20),
@Categoria		varchar(50),
@Moneda		char(10),
@Impuesto		float,
@Descripcion	varchar(100),
@UltDescripcion	varchar(100),
@Serie		varchar(50),
@UltSerie		varchar(50),
@Ubicacion		varchar(100),
@Cantidad		float,
@EnviarA		int
SELECT @UltArticulo = NULL, @UltDescripcion = NULL, @UltSerie = NULL, @Cantidad = 0.0,  @RenglonID = 1, @Renglon = 2048, @Cantidad = 0
SELECT @Empresa = Empresa, @Cliente = Cliente
FROM Venta
WHERE ID = @ID
SELECT @Categoria = NULLIF(RTRIM(ArtExpressCategoria), ''),
@Impuesto = DefImpuesto
FROM EmpresaGral
WHERE Empresa = @Empresa
SELECT @Moneda = NULLIF(RTRIM(ContMoneda), '')
FROM EmpresaCfg
WHERE Empresa = @Empresa
BEGIN TRANSACTION
DELETE SerieLoteMov WHERE Empresa = @Empresa AND Modulo = 'VTAS' AND ID = @ID
DELETE VentaD WHERE ID = @ID
DECLARE crImportarInvArt CURSOR FOR
SELECT NULLIF(RTRIM(Articulo), ''), NULLIF(RTRIM(Descripcion), ''), NULLIF(RTRIM(Serie), ''), NULLIF(RTRIM(Ubicacion), '')
FROM ImportarInvArt
WHERE Estacion = @Estacion
OPEN crImportarInvArt
FETCH NEXT FROM crImportarInvArt INTO @Articulo, @Descripcion, @Serie, @Ubicacion
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2 AND @Articulo IS NOT NULL
BEGIN
SELECT @EnviarA = NULL, @UltArticulo = @Articulo, @UltDescripcion = @Descripcion, @UltSerie = @Serie
IF @Serie IS NOT NULL
BEGIN
IF @Ubicacion IS NOT NULL
BEGIN
IF dbo.fnEsNumerico(@Ubicacion) = 1
SELECT @EnviarA = MIN(ID) FROM CteEnviarA WHERE Cliente = @Cliente AND ID = CONVERT(int, RTRIM(@Ubicacion))
ELSE
SELECT @EnviarA = MIN(ID) FROM CteEnviarA WHERE Cliente = @Cliente AND UPPER(Nombre) LIKE '%'+UPPER(RTRIM(@Ubicacion))+'%'
IF @EnviarA IS NULL
BEGIN
SELECT @EnviarA = ISNULL(MAX(ID), 0) + 1 FROM CteEnviarA WHERE Cliente = @Cliente
INSERT CteEnviarA (Cliente, ID, Nombre) VALUES (@Cliente, @EnviarA, @Ubicacion)
END
END
INSERT SerieLoteMov (Sucursal, Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Ubicacion)
VALUES (@Sucursal, @Empresa, 'VTAS', @ID, @RenglonID, @Articulo, '', @Serie, 1, @EnviarA)
END
SELECT @Cantidad = @Cantidad + 1
END
SELECT @Articulo = NULL
FETCH NEXT FROM crImportarInvArt INTO @Articulo, @Descripcion, @Serie, @Ubicacion
IF @Articulo <> @UltArticulo AND @UltArticulo IS NOT NULL
BEGIN
IF NOT EXISTS(SELECT * FROM Art WHERE Articulo = @UltArticulo)
BEGIN
IF @UltSerie IS NULL SELECT @ArtTipo = 'Normal' ELSE SELECT @ArtTipo = 'Serie'
INSERT Art (Articulo, Descripcion1, Categoria, MonedaCosto, MonedaPrecio, Impuesto1, Estatus, Tipo)
VALUES (@UltArticulo, @UltDescripcion, @Categoria, @Moneda, @Moneda, @Impuesto, 'NORMAL', @ArtTipo)
END
INSERT VentaD (Sucursal, ID, Renglon, RenglonSub, RenglonID, Articulo, Cantidad, Impuesto1)
VALUES (@Sucursal, @ID, @Renglon, 0, @RenglonID, @UltArticulo, @Cantidad, @Impuesto)
SELECT @RenglonID = @RenglonID + 1, @Renglon = @Renglon + 2048, @Cantidad = 0
END
END
CLOSE crImportarInvArt
DEALLOCATE crImportarInvArt
COMMIT TRANSACTION
RETURN
END

