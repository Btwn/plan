SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCFDVentaDprovBorrar ON VentaD

FOR DELETE
AS BEGIN
DECLARE
@ID		int,
@Renglon	float,
@RenglonSub int,
@RenglonID int,
@Articulo varchar(20),
@Subcuenta varchar(20)
SELECT @ID = ID, @Renglon = Renglon, @RenglonSub = RenglonSub, @RenglonId = RenglonID, @Articulo = Articulo, @Subcuenta = Subcuenta FROM Deleted
DELETE CFDVentaDProv WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub AND Articulo = @Articulo
END

