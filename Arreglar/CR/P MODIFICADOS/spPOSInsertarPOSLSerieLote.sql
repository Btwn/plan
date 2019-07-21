SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSInsertarPOSLSerieLote
@Estacion           int,
@ID                 varchar(50),
@RenglonID          int

AS
BEGIN
DECLARE
@Cantidad     float,
@CantidadS    float,
@Articulo     varchar(20),
@SubCuenta    varchar(50),
@SerieLote    varchar(50)
DELETE POSLSerieLote WHERE ID = @ID AND RenglonID = @RenglonID
DECLARE crArticulo CURSOR FOR
SELECT  Articulo, SubCuenta, SerieLote, ISNULL(Cantidad,0.0)
FROM POSLSerieLoteTemp WITH(NOLOCK)
WHERE Estacion = @Estacion AND ID = @ID AND RenglonID = @RenglonID
OPEN crArticulo
FETCH NEXT FROM crArticulo INTO @Articulo, @SubCuenta, @SerieLote, @Cantidad
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @CantidadS = @Cantidad
WHILE @CantidadS >0
BEGIN
INSERT POSLSerieLote (
ID, RenglonID,  Articulo,  SubCuenta,  SerieLote)
SELECT
@ID, @RenglonID, @Articulo, @SubCuenta, @SerieLote
SET @CantidadS = @CantidadS -1
END
FETCH NEXT FROM crArticulo INTO @Articulo, @SubCuenta, @SerieLote, @Cantidad
END
CLOSE crArticulo
DEALLOCATE crArticulo
END

