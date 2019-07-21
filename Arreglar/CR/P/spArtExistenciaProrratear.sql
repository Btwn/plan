SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spArtExistenciaProrratear
@Estacion		int,
@ID			int,
@Empresa		char(5),
@Almacen		char(10),
@Importe		money

AS BEGIN
DECLARE
@CfgMultiUnidades		bit,
@CfgMultiUnidadesNivel	char(20),
@p				int,
@Renglon			float,
@RenglonID			int,
@Clave			varchar(100),
@Articulo			char(20),
@SubCuenta			varchar(50),
@Cantidad			float,
@CantidadInventario		float,
@ZonaImpuesto		varchar(30),
@RenglonTipo		char(1),
@ArtTipo			varchar(20),
@ArtUnidad			varchar(50),
@Impuesto1			float,
@Impuesto2			float,
@Impuesto3			float,
@FechaEmision		datetime,
@Proveedor			varchar(10),
@Sucursal			int,
@Mov			varchar(20),
@Factor                     float
SELECT @CfgMultiUnidades       = MultiUnidades,
@CfgMultiUnidadesNivel  = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
DECLARE crLista CURSOR FOR
SELECT Clave
FROM ListaSt
WHERE Estacion = @Estacion
ORDER BY ID
SELECT @Mov = Mov, @FechaEmision = FechaEmision, @Proveedor = Proveedor, @ZonaImpuesto = ZonaImpuesto, @Sucursal = Sucursal FROM Compra WHERE ID = @ID
DELETE CompraD WHERE ID = @ID
SELECT @Renglon = ISNULL(MAX(Renglon), 0), @RenglonID = ISNULL(MAX(RenglonID), 0) FROM CompraD WHERE ID = @ID
OPEN crLista
FETCH NEXT FROM crLista INTO @Clave
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @p = CHARINDEX(CHAR(9), @Clave)
IF @p > 0
BEGIN
SELECT @Articulo = RTRIM(SUBSTRING(@Clave, 1, @p-1)),
@SubCuenta = RTRIM(SUBSTRING(@Clave, @p+1, LEN(@Clave)))
SELECT @Cantidad = NULL
SELECT @Cantidad = SUM(Inventario)
FROM ArtSubExistenciaInv
WHERE Empresa = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Almacen = @Almacen
SELECT @Renglon = @Renglon + 2048.0, @RenglonID = @RenglonID + 1
SELECT @ArtTipo = Tipo, @ArtUnidad = Unidad, @Impuesto1 = Impuesto1, @Impuesto2 = Impuesto2, @Impuesto3 = Impuesto3 FROM Art WHERE Articulo = @Articulo
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto2 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto3 OUTPUT
EXEC spTipoImpuesto 'COMS', @ID, @Mov, @FechaEmision, @Empresa, @Sucursal, @Proveedor, @Articulo = @Articulo, @EnSilencio = 1, @Impuesto1 = @Impuesto1 OUTPUT, @Impuesto2 = @Impuesto2 OUTPUT, @Impuesto3 = @Impuesto3 OUTPUT
SELECT @Factor =  dbo.fnArtUnidadFactor(@Empresa, @Articulo,@ArtUnidad)
EXEC spRenglonTipo @ArtTipo, @SubCuenta, @RenglonTipo OUTPUT
EXEC xpCantidadInventario @Articulo, @SubCuenta, @ArtUnidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
INSERT CompraD (ID,  Renglon,  RenglonTipo,  RenglonID,  Articulo,  SubCuenta,  Almacen,  Cantidad,  Unidad,     CantidadInventario,  Impuesto1,  Impuesto2,  Impuesto3)
VALUES (@ID, @Renglon, @RenglonTipo, @RenglonID, @Articulo, @SubCuenta, @Almacen, @Cantidad, @ArtUnidad, @CantidadInventario, @Impuesto1, @Impuesto2, @Impuesto3*@Factor)
END
END
FETCH NEXT FROM crLista INTO @Clave
END 
CLOSE crLista
DEALLOCATE crLista
SELECT @Cantidad = SUM(Cantidad) FROM CompraD WHERE ID = @ID
UPDATE CompraD SET Costo = @Importe / @Cantidad WHERE ID = @ID
UPDATE Compra SET RenglonID = @RenglonID WHERE ID = @ID
DELETE ListaSt WHERE Estacion = @Estacion
END

