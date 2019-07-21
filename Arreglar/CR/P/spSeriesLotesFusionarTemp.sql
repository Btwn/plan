SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSeriesLotesFusionarTemp
@Ok 				int		OUTPUT,
@OkRef 			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Empresa		char(5),
@Modulo		char(5),
@ID			int,
@RenglonID		int,
@Articulo		varchar(20),
@SubCuentaNull	varchar(50),
@SerieLote		varchar(50),
@Cantidad		float,
@CantidadAlterna	float,
@Propiedades	varchar(20),
@Sucursal		int,
@ArtCostoInv	float
DECLARE crSerieLoteMovTemp CURSOR FOR
SELECT Empresa, Modulo, ID, RenglonID, Articulo, NULLIF(RTRIM(SubCuenta), ''), SerieLote, Cantidad, CantidadAlterna, Propiedades, Sucursal, ArtCostoInv
FROM #SerieLoteMov
OPEN crSerieLoteMovTemp
FETCH NEXT FROM crSerieLoteMovTemp INTO @Empresa, @Modulo, @ID, @RenglonID, @Articulo, @SubCuentaNull, @SerieLote, @Cantidad, @CantidadAlterna, @Propiedades, @Sucursal, @ArtCostoInv
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND (@Cantidad <> 0.0 OR @CantidadAlterna <> 0.0)
BEGIN
UPDATE SerieLoteMov
SET Cantidad = ISNULL(Cantidad, 0.0) + @Cantidad,
CantidadAlterna = ISNULL(CantidadAlterna, 0.0) + @CantidadAlterna
WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID AND RenglonID = @RenglonID AND Articulo = @Articulo AND NULLIF(RTRIM(SubCuenta), '') = @SubCuentaNull
IF @@ROWCOUNT = 0
INSERT SerieLoteMov (Empresa,  Modulo,  ID,  RenglonID,  Articulo,  SubCuenta,                  SerieLote,  Cantidad,  CantidadAlterna,  Propiedades,  Sucursal,  ArtCostoInv)
VALUES (@Empresa, @Modulo, @ID, @RenglonID, @Articulo, ISNULL(@SubCuentaNull, ''), @SerieLote, @Cantidad, @CantidadAlterna, @Propiedades, @Sucursal, @ArtCostoInv)
END
FETCH NEXT FROM crSerieLoteMovTemp INTO @Empresa, @Modulo, @ID, @RenglonID, @Articulo, @SubCuentaNull, @SerieLote, @Cantidad, @CantidadAlterna, @Propiedades, @Sucursal, @ArtCostoInv
END
CLOSE crSerieLoteMovTemp
DEALLOCATE crSerieLoteMovTemp
RETURN
END

