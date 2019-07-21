SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgVentaDB ON VentaD

FOR DELETE
AS BEGIN
DECLARE
@ID		int,
@Renglon	float,
@RenglonSub int,
@RenglonID int,
@Articulo varchar(20),
@Subcuenta varchar(20)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ID = ID, @Renglon = Renglon, @RenglonSub = RenglonSub, @RenglonId = RenglonID, @Articulo = Articulo, @Subcuenta = Subcuenta FROM Deleted
DELETE VentaDAgente WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
DELETE SerieLoteMov WHERE Modulo = 'VTAS' AND ID = @ID AND RenglonID = @RenglonID AND Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@Subcuenta,'')
END

