SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCFDVentaDCte ON VentaD

FOR UPDATE
AS BEGIN
DECLARE
@ID		int,
@Renglon	float,
@RenglonSub int,
@RenglonID int,
@Articulo varchar(20),
@Subcuenta varchar(20),
@IDN		int,
@RenglonN	float,
@RenglonSubN int,
@RenglonIDN int,
@ArticuloN varchar(20),
@SubcuentaN varchar(20)
IF NOT UPDATE(Articulo) RETURN
SELECT @ID = ID, @Renglon = Renglon, @RenglonSub = RenglonSub, @RenglonId = RenglonID, @Articulo = Articulo, @Subcuenta = Subcuenta FROM Deleted
SELECT @IDN = ID, @RenglonN = Renglon, @RenglonSubN = RenglonSub, @RenglonIdN = RenglonID, @ArticuloN = Articulo, @SubcuentaN = Subcuenta FROM inserted
IF @Articulo <> @ArticuloN
UPDATE   CFDVentaDCte SET Articulo = @ArticuloN, Cliente  = NULL WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
END

