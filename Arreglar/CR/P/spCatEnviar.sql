SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCatEnviar
@XML  varchar(8000)

AS
BEGIN
DECLARE
@Mensaje		varchar(255),
@iXML		int,
@Catalogo		varchar(50),
@Forma		varchar(100),
@Modulo		varchar(5),
@ID			int,
@Cantidad		float,
@Pagina		varchar(20),
@Boton		varchar(5),
@Codigo		varchar(50),
@Renglon		float,
@RenglonID		int,
@RenglonTipo	varchar(1),
@Sucursal		int,
@ZonaImpuesto	varchar(30),
@Impuesto1		float,
@Impuesto2		float,
@Impuesto3		float,
@ArtTipo		varchar(20),
@SubCuenta		varchar(50),
@Precio		float,
@Empresa            varchar(5),
@Unidad             varchar(50),
@Factor             float
SELECT @Mensaje = NULL
EXEC sp_xml_preparedocument @iXML OUTPUT, @XML
SELECT @Catalogo = Catalogo, @Forma = Forma, @Modulo = Modulo, @ID = ModuloID, @Cantidad = Cantidad
FROM OPENXML (@iXML, '/Catalogo', 1)
WITH (Catalogo varchar(50), Forma varchar(100), Modulo varchar(5), ModuloID int, Cantidad float)
SELECT @Boton = MIN(Boton), @Pagina = MIN(Pagina)
FROM OPENXML (@iXML, '/Catalogo/Botones/Boton', 1)
WITH (Boton varchar(5), Pagina varchar(20))
SELECT @Codigo = Codigo
FROM CatDBoton
WHERE Catalogo = @Catalogo AND Pagina = @Pagina AND Boton = @Boton
EXEC sp_xml_removedocument @iXML
IF @Forma='VentaTouchScreen'
BEGIN
UPDATE VentaD
SET Cantidad = ISNULL(Cantidad, 0) + @Cantidad
WHERE ID = @ID AND Articulo = @Codigo
IF @@ROWCOUNT = 0
BEGIN
SELECT @Empresa = Empresa ,@Sucursal = Sucursal, @ZonaImpuesto = ZonaImpuesto FROM Venta WHERE ID = @ID
SELECT @Renglon = MAX(Renglon), @RenglonID = MAX(RenglonID) FROM VentaD WHERE ID = @ID
SELECT @Renglon = ISNULL(@Renglon, 0) + 2048.0, @RenglonID = ISNULL(@RenglonID, 0) + 1
SELECT @Impuesto1 = Impuesto1, @Impuesto2 = Impuesto2, @Impuesto3 = Impuesto3, @ArtTipo = Tipo, @Precio = PrecioLista,
@Unidad = Unidad
FROM Art
WHERE Articulo = @Codigo
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto2 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto3 OUTPUT
EXEC spRenglonTipo @ArtTipo, @SubCuenta, @RenglonTipo OUTPUT
SELECT @Factor =  dbo.fnArtUnidadFactor(@Empresa, @Codigo,@Unidad)
INSERT VentaD (
ID,  Renglon,  RenglonID,  RenglonTipo,  Articulo, Cantidad,  Precio, Unidad,   Impuesto1,  Impuesto2,  Impuesto3)
VALUES (@ID, @Renglon, @RenglonID, @RenglonTipo, @Codigo,  @Cantidad, @Precio, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3*@Factor)
END
END
SELECT 'Mensaje' = @Mensaje
RETURN
END

