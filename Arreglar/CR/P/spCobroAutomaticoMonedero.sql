SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spCobroAutomaticoMonedero
@ID                int,
@Puntos			   Money
AS
BEGIN
DECLARE
@Articulo		Varchar(20),
@Precio			Money,
@Renglon		float,
@RenglonID		int
DECLARE crAplicaMonAut CURSOR LOCAL FOR
SELECT   Articulo, Precio, Renglon, RenglonID FROM VentaD WHERE ID = @ID
OPEN crAplicaMonAut
FETCH NEXT FROM crAplicaMonAut INTO @Articulo, @Precio, @Renglon, @RenglonID
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Puntos = @Puntos - @Precio
IF @Puntos < 0 SELECT  @Puntos = @Precio
UPDATE VentaD SET DescuentoImporte =  @Precio
WHERE   Articulo =  @Articulo AND  Renglon = @Renglon AND RenglonID = @RenglonID
END
FETCH NEXT FROM crAplicaMonAut INTO @Articulo, @Precio, @Renglon, @RenglonID
END
CLOSE crAplicaMonAut
DEALLOCATE crAplicaMonAut
RETURN
END

