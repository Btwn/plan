SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spActualizarUbicaciones
@ID		   int,
@Renglon   float,
@Articulo  char(20),
@Almacen   varchar(10),
@Empresa   char(20)
 
AS
DECLARE @SerieLote			varchar(50),
@CantidadA			float,
@Existencia			float,
@ExistenciaAnterior	float,
@Unidad				varchar(50),
@PosicionDestino	varchar(10),
@Posicion			varchar(10),
@RID				int,
@CantidadDetalle	float
CREATE TABLE #invArtUbicacionesTemp
(
RID				int		NOT NULL,
ID				int		NULL,
Renglon			float NULL,
RenglonSub		int  NULL,
RenglonID		int  NULL,
Articulo		char(20)	NULL,
SubCuenta		varchar(50)	NULL,
SerieLote		varchar(50)	NULL,
Unidad			varchar(50)	NULL,
Existencia		float		NULL,
Posicion		varchar(10)	NULL,
CantidadA		float		NULL,
PosicionDestino	varchar(10)	NULL,
RenglonInvD		float      NULL,
Almacen			varchar(10) NULL
)
CREATE TABLE #InvArtUbicacionDTemp (
RID				int		NOT NULL ,
Posicion		varchar(10)	NOT NULL,
Cantidad		float		NULL,
RenglonInvD		float      NULL
)
INSERT INTO #invArtUbicacionesTemp(rid,id,Articulo,SubCuenta,SerieLote,Unidad,Existencia,Posicion,Renglon,Almacen, Renglonsub, RenglonId,CantidadA,PosicionDestino)
SELECT rid,id,Articulo,SubCuenta,SerieLote,Unidad,Existencia,Posicion,Renglon,Almacen, Renglonsub, RenglonId,CantidadA,PosicionDestino
FROM invArtUbicaciones
WHERE id=@ID AND Renglon=@Renglon AND Articulo =@Articulo AND Almacen=@Almacen
DELETE FROM invArtUbicaciones WHERE  id=@ID	AND renglon =@Renglon AND Articulo =@Articulo AND Almacen=@Almacen
INSERT INTO invArtUbicaciones(id,Articulo,SubCuenta,SerieLote,Unidad,Existencia,Posicion,Renglon,Almacen, Renglonsub, RenglonId)
SELECT id.id,el.Articulo,el.SubCuenta,el.SerieLote,el.Unidad,el.Existencia,el.Posicion,id.Renglon,el.Almacen, id.RenglonSub, id.RenglonId
FROM ExistenciaAlternaPosicionSerieLote el
inner join invd id on EL.ARTICULO=ID.ARTICULO AND ISNULL(el.SUBCUENTA,'')= ISNULL(id.subcuenta,'')
WHERE el.Articulo=@Articulo and id.id=@ID AND el.Almacen=@Almacen AND  id.Renglon=@Renglon  AND el.Empresa=@Empresa and el.Existencia>0
DECLARE crUbicaciones CURSOR FOR
SELECT RID,ID,Renglon,Articulo, SerieLote, Unidad, Existencia,Posicion,Almacen
FROM invArtUbicaciones WHERE id=@ID and renglon =@Renglon AND Articulo =@Articulo AND Almacen=@Almacen
OPEN crUbicaciones
FETCH NEXT FROM crUbicaciones INTO @RID,@ID,@Renglon,@Articulo, @SerieLote, @Unidad, @Existencia,@Posicion,@Almacen
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @CantidadA=CantidadA,@PosicionDestino=PosicionDestino,@ExistenciaAnterior= Existencia FROM  #invArtUbicacionesTemp
WHERE Articulo=@Articulo AND SerieLote=@SerieLote AND Unidad=@Unidad AND  Posicion=@Posicion AND Almacen=@Almacen
IF @Existencia>=@CantidadA
UPDATE invArtUbicaciones SET CantidadA=@CantidadA,PosicionDestino=@PosicionDestino
WHERE Articulo=@Articulo AND SerieLote=@SerieLote AND Unidad=@Unidad AND  Posicion=@Posicion AND Almacen=@Almacen
/*detalle de ubicaciones */
INSERT INTO #InvArtUbicacionDTemp(rid,Posicion,Cantidad,RenglonInvD)
SELECT rid,Posicion,Cantidad,RenglonInvD
FROM InvArtUbicacionD
WHERE rid=@RID
DELETE FROM InvArtUbicacionD WHERE rid=@RID
SELECT @CantidadDetalle =SUM(Cantidad) FROM #InvArtUbicacionDTemp WHERE  rid=@RID
IF @Existencia>@CantidadDetalle
BEGIN
INSERT INTO InvArtUbicacionD(rid,Posicion,Cantidad,RenglonInvD)
SELECT rid,Posicion,Cantidad,RenglonInvD FROM #InvArtUbicacionDTemp WHERE  rid=@RID
END
FETCH NEXT FROM crUbicaciones INTO @RID,@ID,@Renglon,@Articulo, @SerieLote, @Unidad, @Existencia,@Posicion,@Almacen
END
CLOSE crUbicaciones
DEALLOCATE crUbicaciones

