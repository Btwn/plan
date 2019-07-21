SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgWebArtOpcionValorABC ON WebArtOpcionValor

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@VariacionID		int,
@Valor		varchar(100),
@Usuario		varchar(10),
@Msg			varchar(255),
@Ok			int,
@Inserted		bit,
@Deleted		bit,
@eCommerceEmpresa    bit,
@Empresa		varchar(5),
@ID                  int,
@Regenerando         bit
IF(dbo.fneCommerceEstaSincronizando() = 1) RETURN
SELECT @ID = dbo.fnAccesoID(@@SPID)
SELECT @Empresa = Empresa FROM Acceso WHERE ID = @ID
SELECT @eCommerceEmpresa = ISNULL(eCommerce,0) FROM EmpresaGral WHERE Empresa = @Empresa
IF dbo.fnEstaSincronizando() = 1 RETURN
IF ISNULL(@eCommerceEmpresa,0) = 0 RETURN
SELECT @Regenerando = Regenerando
FROM eCommerceRegenerar
SET @Regenerando = ISNULL(@Regenerando,0)
SELECT @Ok = 0
SELECT @Usuario = Usuario FROM Acceso WHERE SPID = dbo.fnAccesoID(@@SPID)
IF EXISTS(SELECT * FROM INSERTED) SELECT @Inserted = 1
IF EXISTS(SELECT * FROM DELETED) SELECT @Deleted = 1
IF @Inserted = 1
DECLARE crActualizar CURSOR local FOR
SELECT VariacionID, Valor
FROM INSERTED
IF @Deleted = 1 AND ISNULL(@Inserted, 0) = 0
DECLARE crActualizar CURSOR local FOR
SELECT VariacionID, Valor
FROM DELETED
IF @Inserted = 1 OR @Deleted = 1
BEGIN
OPEN crActualizar
FETCH NEXT FROM crActualizar INTO @VariacionID, @Valor
WHILE @@FETCH_STATUS = 0 AND @Ok = 0
BEGIN
IF ((SELECT TieneWebArt FROM WebArtVariacion WHERE ID = @VariacionID) = 1) AND @Regenerando = 0
BEGIN
SELECT @Msg = 'No se puede'
IF @Inserted = 1 AND ISNULL(@Deleted, 0) = 0 SELECT @Msg = dbo.fnIdiomaTraducir(@Usuario, 'No se puede crear el Valor porque la Variación a la que pertenece tiene Articulos Web asignados') + ('. ('+@Valor+')')
IF @Inserted = 1 AND @Deleted = 1 SELECT @Msg = dbo.fnIdiomaTraducir(@Usuario, 'No se puede editar el Valor porque la Variación a la que pertenece tiene Articulos Web asignados') + ('. ('+@Valor+')')
IF ISNULL(@Inserted, 0) = 0 AND @Deleted = 1 SELECT @Msg = dbo.fnIdiomaTraducir(@Usuario, 'No se puede eliminar el Valor porque la Variación a la que pertenece tiene Articulos Web asignados') + ('. ('+@Valor+')')
RAISERROR(@Msg, 16, -1)
SELECT @Ok = 1
ROLLBACK
END
FETCH NEXT FROM crActualizar INTO @VariacionID, @Valor
END
CLOSE crActualizar
DEALLOCATE crActualizar
END
END

