SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgLayoutCampoBC ON LayoutCampo

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@LayoutA	varchar(50),
@LayoutN	varchar(50),
@ListaA	varchar(50),
@ListaN	varchar(50),
@CampoA	varchar(50),
@CampoN	varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @LayoutA = Layout, @ListaA = Lista, @CampoA = Campo FROM Deleted
SELECT @LayoutN = Layout, @ListaN = Lista, @CampoN = Campo FROM Inserted
IF @CampoA = @CampoN RETURN
IF @CampoN IS NULL
BEGIN
DELETE LayoutCampoValor    WHERE Layout = @LayoutA AND Lista = @ListaA AND Campo = @CampoA
DELETE LayoutSubCampo      WHERE Layout = @LayoutA AND Lista = @ListaA AND Campo = @CampoA
DELETE LayoutSubCampoValor WHERE Layout = @LayoutA AND Lista = @ListaA AND Campo = @CampoA
END ELSE
BEGIN
UPDATE LayoutCampoValor    SET Lista = @ListaN WHERE Layout = @LayoutA AND Lista = @ListaA AND Campo = @CampoA
UPDATE LayoutSubCampo      SET Lista = @ListaN WHERE Layout = @LayoutA AND Lista = @ListaA AND Campo = @CampoA
UPDATE LayoutSubCampoValor SET Lista = @ListaN WHERE Layout = @LayoutA AND Lista = @ListaA AND Campo = @CampoA
END
END

