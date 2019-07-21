SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgLayoutListaBC ON LayoutLista

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@LayoutA	varchar(50),
@LayoutN	varchar(50),
@ListaA	varchar(50),
@ListaN	varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @LayoutA = Layout, @ListaA = Lista FROM Deleted
SELECT @LayoutN = Layout, @ListaN = Lista FROM Inserted
IF @ListaA = @ListaN RETURN
IF @ListaN IS NULL
BEGIN
DELETE LayoutCampo         WHERE Layout = @LayoutA AND Lista = @ListaA
DELETE LayoutCampoValor    WHERE Layout = @LayoutA AND Lista = @ListaA
DELETE LayoutSubCampo      WHERE Layout = @LayoutA AND Lista = @ListaA
DELETE LayoutSubCampoValor WHERE Layout = @LayoutA AND Lista = @ListaA
END ELSE
BEGIN
UPDATE LayoutCampo         SET Lista = @ListaN WHERE Layout = @LayoutA AND Lista = @ListaA
UPDATE LayoutCampoValor    SET Lista = @ListaN WHERE Layout = @LayoutA AND Lista = @ListaA
UPDATE LayoutSubCampo      SET Lista = @ListaN WHERE Layout = @LayoutA AND Lista = @ListaA
UPDATE LayoutSubCampoValor SET Lista = @ListaN WHERE Layout = @LayoutA AND Lista = @ListaA
END
END

