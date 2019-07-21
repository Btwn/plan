SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAnexosAlFacturar
@ID          		int,
@CfgMultiUnidades		bit,
@CfgMultiUnidadesNivel	char(20),
@Ok				int		OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Renglon		float,
@RenglonSub		int,
@RenglonID		int,
@Empresa		char(5),
@Sucursal		int,
@Moneda		char(10),
@TipoCambio		float,
@ZonaImpuesto	varchar(50),
@Articulo		char(20),
@Cantidad		float,
@Unidad		varchar(50),
@NuevaCantidad	float,
@CantidadInventario	float,
@Impuesto1		float,
@Impuesto2		float,
@Impuesto3		money,
@Precio		float,
@ListaPrecios	varchar(50),
@Anexo		char(20),
@AnexoSubCuenta	varchar(50),
@AnexoTipoCantidad	varchar(20),
@AnexoCantidad	float,
@AnexoUnidad	varchar(50),
@AnexoTipoPrecio	varchar(20),
@AnexoPrecio	float,
@ArtTipo		varchar(20),
@RenglonTipo	char(1),
@Almacen		char(10),
@FechaRequerida	datetime,
@FechaEmision	datetime,
@Contacto		varchar(10),
@EnviarA		int,
@Mov		varchar(20),
@Factor             float
BEGIN TRANSACTION
DELETE VentaD WHERE ID = @ID AND Anexo = 1
SELECT @Mov = Mov, @ZonaImpuesto = ZonaImpuesto, @Empresa = Empresa, @Sucursal = Sucursal, @Moneda = Moneda, @TipoCambio = TipoCambio, @ListaPrecios = ListaPreciosEsp,
@FechaEmision = FechaEmision, @Contacto = Cliente, @EnviarA = EnviarA
FROM Venta WHERE ID = @ID
IF EXISTS(SELECT d.ID FROM VentaD d, Art a WHERE d.ID = @ID AND d.Articulo = a.Articulo AND a.AnexosAlFacturar = 1)
BEGIN
DECLARE crAnexosAlFacturar CURSOR FOR
SELECT d.Renglon, d.RenglonID, d.Articulo, d.Cantidad, d.Unidad, d.Almacen, d.FechaRequerida, d.Importe/NULLIF(d.Cantidad, 0)
FROM VentaDCalc d, Art a
WHERE d.ID = @ID AND d.Articulo = a.Articulo AND a.AnexosAlFacturar = 1
OPEN crAnexosAlFacturar
FETCH NEXT FROM crAnexosAlFacturar INTO @Renglon, @RenglonID, @Articulo, @Cantidad, @Unidad, @Almacen, @FechaRequerida, @Precio
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
DECLARE crArtAnexo CURSOR LOCAL FOR
SELECT x.Anexo, x.SubCuenta, UPPER(x.TipoCantidad), x.Cantidad, x.Unidad, UPPER(x.TipoPrecio), x.Precio, a.Impuesto1, a.Impuesto2, a.Impuesto3, a.Tipo
FROM ArtAnexo x, Art a
WHERE x.Articulo = @Articulo AND a.Articulo = x.Articulo AND NULLIF(RTRIM(x.UnidadEspecifica), '') IN (NULL, @Unidad)
OPEN crArtAnexo
FETCH NEXT FROM crArtAnexo INTO @Anexo, @AnexoSubCuenta, @AnexoTipoCantidad, @AnexoCantidad, @AnexoUnidad, @AnexoTipoPrecio, @AnexoPrecio, @Impuesto1, @Impuesto2, @Impuesto3, @ArtTipo
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF NOT EXISTS(SELECT * FROM VentaD WHERE ID = @ID AND Renglon = @Renglon AND Articulo = @Anexo)
BEGIN
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto2 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto3 OUTPUT
EXEC spTipoImpuesto 'VTAS', @ID, @Mov, @FechaEmision, @Empresa, @Sucursal, @Contacto, @EnviarA, @Articulo = @Articulo, @EnSilencio = 1, @Impuesto1 = @Impuesto1 OUTPUT, @Impuesto2 = @Impuesto2 OUTPUT, @Impuesto3 = @Impuesto3 OUTPUT
EXEC spRenglonTipo @ArtTipo, @AnexoSubCuenta, @RenglonTipo OUTPUT
IF @AnexoTipoCantidad = 'MULTIPLOS'
SELECT @NuevaCantidad = @AnexoCantidad * @Cantidad
IF @AnexoTipoCantidad = '%'
SELECT @NuevaCantidad = @Cantidad * (@AnexoCantidad / 100)
IF @AnexoTipoCantidad = 'ESPECIFICA'
SELECT @NuevaCantidad = @AnexoCantidad
EXEC xpCantidadInventario @Anexo, @AnexoSubCuenta, @AnexoUnidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @NuevaCantidad, @CantidadInventario OUTPUT
SELECT @RenglonSub = ISNULL(MAX(RenglonSub), 0)+1 FROM VentaD WHERE ID = @ID AND Renglon = @Renglon
IF @AnexoTipoPrecio = 'NO'
SELECT @AnexoPrecio = NULL
IF @AnexoTipoPrecio = '%'
SELECT @AnexoPrecio = @Precio * (@AnexoPrecio / 100)
IF @AnexoTipoPrecio = 'CORRESPONDA'
EXEC spPCGet @Sucursal, @Empresa, @Anexo, @AnexoSubCuenta, @AnexoUnidad, @Moneda, @TipoCambio, @ListaPrecios, @AnexoPrecio OUTPUT
SELECT @Factor =  dbo.fnArtUnidadFactor(@Empresa, @Anexo,@AnexoUnidad)
INSERT VentaD (ID,  Renglon,  RenglonSub,  RenglonID,  RenglonTipo,  Articulo, SubCuenta,       Precio,       Cantidad,       Unidad,       CantidadInventario,  Impuesto1,  Impuesto2,  Impuesto3,          Almacen,  FechaRequerida)
VALUES (@ID, @Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @Anexo,   @AnexoSubCuenta, @AnexoPrecio, @NuevaCantidad, @AnexoUnidad, @CantidadInventario, @Impuesto1, @Impuesto2, @Impuesto3*@Factor, @Almacen, @FechaRequerida)
END
END
FETCH NEXT FROM crArtAnexo INTO @Anexo, @AnexoSubCuenta, @AnexoTipoCantidad, @AnexoCantidad, @AnexoUnidad, @AnexoTipoPrecio, @AnexoPrecio, @Impuesto1, @Impuesto2, @Impuesto3, @ArtTipo
END
CLOSE crArtAnexo
DEALLOCATE crArtAnexo
END
FETCH NEXT FROM crAnexosAlFacturar INTO @Renglon, @RenglonID, @Articulo, @Cantidad, @Unidad, @Almacen, @FechaRequerida, @Precio
END
CLOSE crAnexosAlFacturar
DEALLOCATE crAnexosAlFacturar
END
IF @OK IS NULL
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
RETURN
END

