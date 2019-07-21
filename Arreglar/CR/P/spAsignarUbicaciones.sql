SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAsignarUbicaciones
@ID		int,
@Almacen	varchar(20),
@Articulo		varchar(20),
@Renglon  float(8),
@Empresa  varchar(15)

AS
DECLARE @AlmacenB varchar(20),
@ArticuloB varchar(20)
SELECT TOP 1 @AlmacenB = Almacen,@ArticuloB=Articulo  FROM invArtUbicaciones WHERE Articulo=@Articulo AND Renglon=@Renglon AND ID =@ID
IF @AlmacenB<>@Almacen  OR @ArticuloB<>@Articulo
DELETE FROM invArtUbicaciones WHERE Articulo=@Articulo AND Renglon=@Renglon AND ID =@ID
IF NOT EXISTS(SELECT   Articulo FROM invArtUbicaciones WHERE Articulo=@Articulo AND Renglon=@Renglon AND ID =@ID)
INSERT INTO invArtUbicaciones(id,Articulo,SubCuenta,SerieLote,Unidad,Existencia,Posicion,Renglon,Almacen, Renglonsub, RenglonId)
SELECT id.id,el.Articulo,el.SubCuenta,el.SerieLote,el.Unidad,el.Existencia,el.Posicion,id.Renglon,el.Almacen, id.RenglonSub, id.RenglonId
FROM ExistenciaAlternaPosicionSerieLote el
inner join invd id on EL.ARTICULO=ID.ARTICULO AND ISNULL(el.SUBCUENTA,'')= ISNULL(id.subcuenta,'')
WHERE el.Articulo=@Articulo and id.id=@ID AND el.Almacen=@Almacen AND  id.Renglon=@Renglon  AND el.Empresa=@Empresa and el.Existencia>0

