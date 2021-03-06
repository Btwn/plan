SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgWebArtCamposConfigurablesB ON WebArtCamposConfigurables

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
IF EXISTS (SELECT * FROM WebArtCamposConfigurablesD WHERE ID = @ID)
DELETE WebArtCamposConfigurablesD WHERE ID = @ID
FETCH NEXT FROM crActualizar INTO   @ID
END
CLOSE crActualizar
DEALLOCATE crActualizar
END
END

