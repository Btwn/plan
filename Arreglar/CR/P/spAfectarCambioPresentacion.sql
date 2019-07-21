SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAfectarCambioPresentacion
@Sucursal			int,
@ID  			int,
@Empresa			char(5),
@MovMoneda			char(10),
@MovTipoCambio		float,
@CfgMultiUnidades		bit,
@CfgMultiUnidadesNivel	char(20),
@CfgFormaCosteo    		char(20),
@CfgTipoCosteo     		char(20),
@Ok 				int		OUTPUT,
@OkRef 			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Articulo		char(20),
@SubCuenta		varchar(50),
@ArtMoneda		char(10),
@ArtFactor		float,
@ArtTipoCambio	float,
@ArtTipoCosteo	char(20),
@ArtCostoEstandar	float,
@ArtCostoReposicion	float,
@TipoCosteo		char(20),
@Cantidad		float,
@NuevaCantidad	float,
@MovUnidad		varchar(50),
@ArticuloDestino	char(20),
@SubCuentaDestino	varchar(50),
@Almacen		char(10),
@Renglon		float,
@RenglonID		int,
@UltRenglonID	int,
@Costo		float,
@NuevoCosto		float,
@Factor 		float,
@CPSobrante		float,
@CPCantidad		float,
@CantidadInventario	float,
@Unidad		varchar(50),
@UnidadFactor	float,
@Decimales		int,
@SerieLote          varchar(50),
@Propiedades        varchar(50)
SELECT @UltRenglonID = ISNULL(MAX(RenglonID), 0) FROM InvD WHERE ID = @ID
DECLARE crGenerarCambioPresentacion CURSOR FOR
SELECT Renglon, RenglonID, Articulo, SubCuenta, ISNULL(Cantidad, 0.0), ISNULL(CantidadInventario, Cantidad), NULLIF(UPPER(RTRIM(ArticuloDestino)), ''), NULLIF(RTRIM(SubCuentaDestino), ''), Unidad, Almacen
FROM InvD
WHERE ID = @ID
OPEN crGenerarCambioPresentacion
FETCH NEXT FROM crGenerarCambioPresentacion INTO @Renglon, @RenglonID, @Articulo, @SubCuenta, @Cantidad, @CantidadInventario, @ArticuloDestino, @SubCuentaDestino, @MovUnidad, @Almacen
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Articulo IS NOT NULL AND @Cantidad > 0.0 AND @ArticuloDestino IS NOT NULL
BEGIN
SELECT @Factor = 1.0, @Costo = NULL
SELECT @UnidadFactor = 1.0
IF @Cantidad <> @CantidadInventario
SELECT @UnidadFactor = @CantidadInventario / @Cantidad
ELSE
IF @CfgMultiUnidades = 1
BEGIN
IF @CfgMultiUnidadesNivel = 'ARTICULO'
EXEC xpArtUnidadFactor @Articulo, @SubCuenta, @MovUnidad, @UnidadFactor OUTPUT, @Decimales OUTPUT, NULL
ELSE
EXEC xpUnidadFactor @Articulo, @SubCuenta, @MovUnidad, @UnidadFactor OUTPUT, @Decimales OUTPUT
END
SELECT @Factor             = ISNULL(p.Factor, 1.0),
@ArtMoneda	         = NULLIF(RTRIM(a.MonedaCosto), ''),
@ArtTipoCosteo      = ISNULL(NULLIF(RTRIM(a.TipoCosteo), ''), @CfgTipoCosteo),
@ArtCostoEstandar   = a.CostoEstandar,
@ArtCostoReposicion = a.CostoReposicion
FROM ArtPresenta p, Art a
WHERE p.Articulo      = @Articulo
AND p.Presentacion  = @ArticuloDestino
AND a.Articulo      = @Articulo
IF @@ROWCOUNT = 0 SELECT @Ok = 20250, @OkRef = @ArticuloDestino
IF @@ERROR <> 0 SELECT @Ok = 1
IF @CfgFormaCosteo = 'EMPRESA' SELECT @TipoCosteo = @CfgTipoCosteo ELSE SELECT @TipoCosteo = @ArtTipoCosteo
EXEC spVerCosto @Sucursal, @Empresa, NULL, @Articulo, @SubCuenta, @MovUnidad, @TipoCosteo, @MovMoneda, @MovTipoCambio, @NuevoCosto OUTPUT, 0
IF @Ok IS NULL
EXEC spMoneda NULL, @MovMoneda, @MovTipoCambio, @ArtMoneda, @ArtFactor OUTPUT, @ArtTipoCambio OUTPUT, @Ok OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @CPSobrante = ISNULL(Convert(int, @Cantidad) % NULLIF(Convert(int, 1/@Factor), 0), 0)
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @CPCantidad = ISNULL((@Cantidad - @CPSobrante) * @Factor, 0)
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE InvD SET Cantidad = -(@Cantidad - @CPSobrante), Costo = NULL, ArticuloDestino = NULL WHERE CURRENT OF crGenerarCambioPresentacion
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @Renglon = @Renglon + 1
SELECT @NuevoCosto = @NuevoCosto / @Factor, @CantidadInventario = @CantidadInventario * @Factor
IF @@ERROR <> 0 SELECT @Ok = 1
EXEC xpCambioPresentacionUnidad @ArticuloDestino, @MovUnidad OUTPUT
SELECT @UltRenglonID = @UltRenglonID + 1
INSERT INTO InvD (Sucursal,  ID,  Renglon,  RenglonID,     Articulo,         SubCuenta,         Cantidad,    CantidadInventario,  Costo,       Unidad,     Almacen)
VALUES (@Sucursal, @ID, @Renglon, @UltRenglonID, @ArticuloDestino, @SubCuentaDestino, @CPCantidad, @CantidadInventario, @NuevoCosto, @MovUnidad, @Almacen)
DECLARE crSerieLote CURSOR LOCAL FOR
SELECT SerieLote
FROM SerieLoteMov
WHERE Empresa = @Empresa AND Modulo = 'INV' AND ID = @ID AND RenglonID = @RenglonID AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
OPEN crSerieLote
FETCH NEXT FROM crSerieLote INTO @SerieLote
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
SELECT  @Propiedades = NULLIF(RTRIM(Propiedades), '')
FROM SerieLote
WHERE Sucursal  = @Sucursal
AND Empresa   = @Empresa
AND Articulo  = @Articulo
AND SubCuenta = ISNULL(@SubCuenta,'')
AND SerieLote = @SerieLote
UPDATE SerieLoteMov SET Propiedades = @Propiedades
WHERE Empresa = @Empresa AND Modulo = 'INV' AND ID = @ID AND RenglonID = @RenglonID AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
FETCH NEXT FROM crSerieLote INTO @SerieLote
END
CLOSE crSerieLote
DEALLOCATE crSerieLote
INSERT SerieLoteMov (Empresa, Modulo, ID,  RenglonID,     Articulo,         SubCuenta,                     SerieLote, Propiedades, ArtCostoInv, Cantidad,         CantidadAlterna,         Sucursal)
SELECT Empresa,  'INV',  @ID, @UltRenglonID, @ArticuloDestino, ISNULL(@SubCuentaDestino, ''), SerieLote, Propiedades, ArtCostoInv, Cantidad*@Factor, CantidadAlterna*@Factor, Sucursal
FROM SerieLoteMov
WHERE Empresa = @Empresa AND Modulo = 'INV' AND ID = @ID AND RenglonID = @RenglonID AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
IF @@ERROR <> 0 SELECT @Ok = 1
END
END
FETCH NEXT FROM crGenerarCambioPresentacion INTO @Renglon, @RenglonID, @Articulo, @SubCuenta, @Cantidad, @CantidadInventario, @ArticuloDestino, @SubCuentaDestino, @MovUnidad, @Almacen
IF @@ERROR <> 0 SELECT @Ok = 1
END
CLOSE crGenerarCambioPresentacion
DEALLOCATE crGenerarCambioPresentacion
IF @Ok IS NULL
UPDATE Inv SET RenglonID = @UltRenglonID WHERE ID = @ID
RETURN
END

