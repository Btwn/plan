SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgWebArtCamposConfigurablesCatDB ON WebArtCamposConfigurablesCatD

FOR DELETE
AS BEGIN
DECLARE
@Tipo                 varchar(50),
@Nombre               varchar(255),
@eCommerceEmpresa     bit,
@Empresa		varchar(5),
@ID                  int
SELECT @ID = dbo.fnAccesoID(@@SPID)
SELECT @Empresa = Empresa FROM Acceso WHERE ID = @ID
SELECT @eCommerceEmpresa = ISNULL(eCommerce,0) FROM EmpresaGral WHERE Empresa = @Empresa
IF dbo.fnEstaSincronizando() = 1 RETURN
IF ISNULL(@eCommerceEmpresa,0) = 0 RETURN
SELECT @Tipo = Tipo, @Nombre = Nombre FROM DELETED
DELETE WebArtCamposConfigurablesCatDD WHERE Tipo = @Tipo  AND Nombre = @Nombre
END

