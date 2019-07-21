SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgWebArtVariacionB ON WebArtVariacion

FOR DELETE
AS BEGIN
DECLARE
@VariacionID          int,
@Nombre				 varchar(100),
@TieneWebArt			 bit,
@Usuario				 varchar(10),
@Msg					 varchar(255),
@Ok					 int
SELECT @Ok = 0
SELECT @Usuario = Usuario FROM Acceso WHERE SPID = dbo.fnAccesoID(@@SPID)
IF EXISTS(SELECT * FROM DELETED)
BEGIN
DECLARE crActualizar CURSOR local FOR
SELECT ID, Nombre, TieneWebArt
FROM Deleted
OPEN crActualizar
FETCH NEXT FROM crActualizar INTO  @VariacionID, @Nombre, @TieneWebArt
WHILE @@FETCH_STATUS = 0 AND @Ok = 0
BEGIN
IF (@TieneWebArt = 1)
BEGIN
SELECT @Msg = dbo.fnIdiomaTraducir(@Usuario, 'No se puede eliminar la Variacion porque tiene Articulos Web asignados') + ('. ('+@Nombre+')')
RAISERROR(@Msg, 16, -1)
SELECT @Ok = 1
ROLLBACK
END
IF @Ok = 0 AND EXISTS (SELECT * FROM WebArtOpcion WHERE VariacionID = @VariacionID)
DELETE WebArtOpcion WHERE VariacionID = @VariacionID
IF @Ok = 0 AND EXISTS (SELECT * FROM WebArtOpcionValor WHERE VariacionID = @VariacionID)
DELETE WebArtOpcionValor WHERE VariacionID = @VariacionID
FETCH NEXT FROM crActualizar INTO  @VariacionID, @Nombre, @TieneWebArt
END
CLOSE crActualizar
DEALLOCATE crActualizar
END
END

