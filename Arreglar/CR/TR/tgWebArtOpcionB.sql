SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgWebArtOpcionB ON WebArtOpcion

FOR DELETE
AS BEGIN
DECLARE
@ID                   int,
@VariacionID          int,
@Nombre				 varchar(100),
@Usuario				 varchar(10),
@Msg					 varchar(255),
@Ok					 int,
@Regenerando          bit
SELECT @Ok = 0
SELECT @Usuario = Usuario FROM Acceso WHERE SPID = dbo.fnAccesoID(@@SPID)
SELECT @Regenerando = Regenerando
FROM eCommerceRegenerar
SET @Regenerando = ISNULL(@Regenerando,0)
IF EXISTS(SELECT * FROM DELETED)
BEGIN
DECLARE crActualizar CURSOR local FOR
SELECT ID, VariacionID, Nombre
FROM Deleted
OPEN crActualizar
FETCH NEXT FROM crActualizar INTO @ID, @VariacionID, @Nombre
WHILE @@FETCH_STATUS = 0 AND @Ok = 0
BEGIN
IF ((SELECT TieneWebArt FROM WebArtVariacion WHERE ID = @VariacionID) = 1) AND @Regenerando = 0
BEGIN
SELECT @Msg = dbo.fnIdiomaTraducir(@Usuario, 'No se puede eliminar la Opcion porque la Variación a la que pertenece tiene Articulos Web asignados') + ('. ('+@Nombre+')')
RAISERROR(@Msg, 16, -1)
SELECT @Ok = 1
ROLLBACK
END
IF @Ok = 0 AND EXISTS (SELECT * FROM WebArtOpcionValor WHERE VariacionID = @VariacionID AND OpcionID = @ID)
DELETE WebArtOpcionValor WHERE VariacionID = @VariacionID  AND OpcionID = @ID
FETCH NEXT FROM crActualizar INTO   @ID, @VariacionID, @Nombre
END
CLOSE crActualizar
DEALLOCATE crActualizar
END
END

