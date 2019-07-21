SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgLayoutSubCampoBC ON LayoutSubCampo

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@LayoutA	varchar(50),
@LayoutN	varchar(50),
@ListaA	varchar(50),
@ListaN	varchar(50),
@CampoA	varchar(50),
@CampoN	varchar(50),
@SubCampoA	varchar(50),
@SubCampoN	varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @LayoutA = Layout, @ListaA = Lista, @CampoA = Campo, @SubCampoA = SubCampo FROM Deleted
SELECT @LayoutN = Layout, @ListaN = Lista, @CampoN = Campo, @SubCampoN = SubCampo FROM Inserted
IF @SubCampoA = @SubCampoN RETURN
IF @SubCampoN IS NULL
BEGIN
DELETE LayoutSubCampoValor WHERE Layout = @LayoutA AND Lista = @ListaA AND Campo = @CampoA AND SubCampo = @SubCampoA
END ELSE
BEGIN
UPDATE LayoutSubCampoValor SET Lista = @ListaN WHERE Layout = @LayoutA AND Lista = @ListaA AND Campo = @CampoA AND SubCampo = @SubCampoA
END
END

