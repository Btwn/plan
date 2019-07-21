SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgWebArtB ON WebArt

FOR DELETE
AS BEGIN
DECLARE
@ID                   int,
@eCommerceEmpresa     bit,
@Empresa		varchar(5)
SELECT @ID = dbo.fnAccesoID(@@SPID)
SELECT @Empresa = Empresa FROM Acceso WHERE ID = @ID
SELECT @eCommerceEmpresa = ISNULL(eCommerce,0) FROM EmpresaGral WHERE Empresa = @Empresa
IF dbo.fnEstaSincronizando() = 1 RETURN
IF ISNULL(@eCommerceEmpresa,0) = 0 RETURN
IF EXISTS(SELECT * FROM DELETED)
BEGIN
DECLARE crActualizar CURSOR local FOR
SELECT ID
FROM Deleted
OPEN crActualizar
FETCH NEXT FROM crActualizar INTO @ID
WHILE @@FETCH_STATUS = 0
BEGIN
IF EXISTS (SELECT * FROM WebArtAtributos WHERE IDArt = @ID)
DELETE WebArtAtributos WHERE IDArt = @ID
IF EXISTS (SELECT * FROM WebArtCamposConfigurablesD d JOIN WebArtCamposConfigurables c ON c.ID = d.ID WHERE c.IDArt = @ID)
DELETE  WebArtCamposConfigurablesD WHERE ID IN(SELECT ID FROM WebArtCamposConfigurables WHERE IDArt = @ID)
IF EXISTS (SELECT * FROM WebArtCamposConfigurables WHERE IDArt = @ID)
DELETE WebArtCamposConfigurables WHERE IDArt = @ID
IF EXISTS (SELECT * FROM WebArtImagen WHERE IDArt = @ID)
DELETE WebArtImagen WHERE IDArt = @ID
IF EXISTS (SELECT * FROM WebArtVideo WHERE IDArt = @ID)
DELETE WebArtVideo WHERE IDArt = @ID
IF EXISTS (SELECT * FROM WebArtVariacionCombinacion WHERE IDArt = @ID)
DELETE WebArtVariacionCombinacion WHERE IDArt = @ID
IF EXISTS (SELECT * FROM WebArtVariacionCombinacionD WHERE IDArt = @ID)
DELETE WebArtVariacionCombinacionD WHERE IDArt = @ID
IF EXISTS (SELECT * FROM WebCatArt_Art WHERE IDWebArt = @ID)
DELETE WebCatArt_Art WHERE IDWebArt = @ID
IF EXISTS (SELECT * FROM WebArtDescripcion WHERE ID = @ID)
DELETE WebArtDescripcion WHERE ID = @ID
IF EXISTS (SELECT * FROM WebArtEnvoltura WHERE IDArt = @ID)
DELETE WebArtEnvoltura WHERE IDArt = @ID
FETCH NEXT FROM crActualizar INTO   @ID
END
CLOSE crActualizar
DEALLOCATE crActualizar
END
END

