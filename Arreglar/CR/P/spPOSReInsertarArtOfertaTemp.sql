SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSReInsertarArtOfertaTemp
@Estacion           int,
@ID                 varchar(36)

AS
BEGIN
DECLARE
@Renglon            float,
@Renglon2           float,
@RenglonID2         int,
@Articulo           varchar(20),
@IDR                varchar(36),
@CantidadO          float,
@CantidadM          float,
@Cantidad           float,
@Ok                 int
IF EXISTS(SELECT * FROM POSOfertaTempD WHERE CantidadM <> CantidadO AND Estacion = @Estacion
AND IDR = @ID AND ID IN (SELECT ID FROM ListaID  WHERE Estacion = @Estacion))
BEGIN
DECLARE crVenta CURSOR FOR
SELECT Renglon, Articulo, IDR , CantidadO,ISNULL(CantidadM,0.0)
FROM POSOfertaTempD
WHERE CantidadM <> CantidadO
AND Estacion = @Estacion
AND IDR = @ID
AND ID IN (SELECT ID FROM ListaID  WHERE Estacion = @Estacion)
OPEN crVenta
FETCH NEXT FROM crVenta INTO  @Renglon, @Articulo, @IDR, @CantidadO, @CantidadM
WHILE @@FETCH_STATUS <> -1
BEGIN
SELECT @Cantidad = (ISNULL(@CantidadO,0.0)-ISNULL(@CantidadM,0.0))
IF ISNULL(@Cantidad,0.0) > 0
BEGIN
SELECT @Renglon2 = MAX(Renglon), @RenglonID2 = MAX(RenglonID)
FROM POSLVenta
WHERE ID = @ID
SELECT @Renglon2 = @Renglon2 + 2048.0
SELECT @RenglonID2 = @RenglonID2 + 1
INSERT POSLVenta (
ID, Renglon, RenglonID, RenglonTipo, Cantidad, Articulo, SubCuenta, Precio, DescuentoLinea, Impuesto1, Impuesto2, Impuesto3,
Unidad, Factor, CantidadInventario, LDIServicio, PrecioImpuestoInc, Codigo)
SELECT
ID, @Renglon2, @RenglonID2, RenglonTipo, @Cantidad, Articulo, SubCuenta, Precio, DescuentoLinea, Impuesto1, Impuesto2, Impuesto3,
Unidad, Factor, @Cantidad, LDIServicio, PrecioImpuestoInc, Codigo
FROM POSLVenta
WHERE ID = @ID AND Articulo = @Articulo AND Renglon = @Renglon
IF @@ERROR <> 0
SET @OK = 1
UPDATE POSLVenta
SET Cantidad = @CantidadM, CantidadInventario = @CantidadM
WHERE ID = @ID AND Articulo = @Articulo AND Renglon = @Renglon
IF @@ERROR <> 0
SET @OK = 1
END
SELECT @Cantidad = NULL,@Renglon2 = NULL,@RenglonID2 = NULL
FETCH NEXT FROM crVenta INTO @Renglon, @Articulo, @IDR, @CantidadO, @CantidadM
END
CLOSE crVenta
DEALLOCATE crVenta
END
EXEC spPOSAplicarOfertaTemp @Estacion, @ID
EXEC spPOSOfertaPuntosAplicar @ID, NULL, 1, @Estacion
EXEC spPOSOfertaPuntosInsertarTemp @ID, NULL, 1, @Estacion
END

