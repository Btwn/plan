SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgWebArtAtributosCatB ON WebArtAtributosCat

FOR DELETE
AS BEGIN
DECLARE
@Tipo Varchar(50),
@eCommerceEmpresa     bit,
@Empresa		varchar(5),
@ID                  int
SELECT @ID = dbo.fnAccesoID(@@SPID)
SELECT @Empresa = Empresa FROM Acceso WHERE ID = @ID
SELECT @eCommerceEmpresa = ISNULL(eCommerce,0) FROM EmpresaGral WHERE Empresa = @Empresa
IF dbo.fnEstaSincronizando() = 1 RETURN
IF ISNULL(@eCommerceEmpresa,0) = 0 RETURN
SELECT @Tipo = Tipo FROM DELETED
DELETE WebArtAtributosCatD WHERE Tipo = @Tipo
END

