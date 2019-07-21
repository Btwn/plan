SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSInsertarPOSLSerieLoteTemp
@Estacion           int,
@ID                 varchar(50),
@RenglonID          int

AS
BEGIN
DELETE POSLSerieLoteTemp WHERE Estacion = @Estacion
INSERT POSLSerieLoteTemp (Estacion, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad)
SELECT @Estacion, @ID, @RenglonID, Articulo, ISNULL(SubCuenta,''), SerieLote, COUNT(*)
FROM POSLSerieLote WITH (NOLOCK)
WHERE ID = @ID AND RenglonID = @RenglonID
GROUP BY Articulo, ISNULL(SubCuenta,''), SerieLote, RenglonID
END

