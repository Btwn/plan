SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgVentaDAC ON VentaD

FOR INSERT, UPDATE
AS BEGIN
/*  IF UPDATE(SubCuenta)
UPDATE VentaD
SET nSubCuenta = ISNULL(i.SubCuenta, '')
FROM VentaD d, Inserted i
WHERE d.ID = i.ID AND d.Renglon = i.Renglon AND d.RenglonSub = i.RenglonSub AND (d.nSubCuenta IS NULL OR d.nSubCuenta <> ISNULL(i.SubCuenta, ''))
*/
/*  DELETE VentaD
FROM VentaD d
JOIN inserted i ON i.ID = d.ID AND i.Renglon = d.Renglon AND i.RenglonSub = d.RenglonSub
AND NULLIF(RTRIM(d.Articulo), '') IS NULL*/
IF dbo.fnEstaSincronizando() = 1 RETURN
IF NOT UPDATE(Articulo) RETURN
DECLARE
@ID		int,
@Renglon	float,
@RenglonSub int
SELECT @ID = MIN(ID), @Renglon = MIN(Renglon), @RenglonSub = MIN(RenglonSub) FROM Inserted WHERE NULLIF(RTRIM(Articulo), '') IS NULL
IF @ID IS NOT NULL AND @Renglon IS NOT NULL AND @RenglonSub IS NOT NULL
DELETE VentaD WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
SELECT @ID = ID FROM Inserted
IF @ID IS NOT NULL AND NOT EXISTS (SELECT ID FROM Venta WHERE ID = @ID)
BEGIN
RAISERROR('El Movimiento Ya Fue Eliminado',16,-1)
END
END

