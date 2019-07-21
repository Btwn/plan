SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgLayoutBC ON Layout

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@LayoutA	varchar(50),
@LayoutN	varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @LayoutA = Layout FROM Deleted
SELECT @LayoutN = Layout FROM Inserted
IF @LayoutA = @LayoutN RETURN
IF @LayoutN IS NULL
BEGIN
DELETE LayoutLista         WHERE Layout = @LayoutA
DELETE LayoutCampo         WHERE Layout = @LayoutA
DELETE LayoutCampoValor    WHERE Layout = @LayoutA
DELETE LayoutSubCampo      WHERE Layout = @LayoutA
DELETE LayoutSubCampoValor WHERE Layout = @LayoutA
END ELSE
BEGIN
UPDATE LayoutLista         SET Layout = @LayoutN WHERE Layout = @LayoutA
UPDATE LayoutCampo         SET Layout = @LayoutN WHERE Layout = @LayoutA
UPDATE LayoutCampoValor    SET Layout = @LayoutN WHERE Layout = @LayoutA
UPDATE LayoutSubCampo      SET Layout = @LayoutN WHERE Layout = @LayoutA
UPDATE LayoutSubCampoValor SET Layout = @LayoutN WHERE Layout = @LayoutA
END
END

