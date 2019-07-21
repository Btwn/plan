SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tginvArtUbicaciond ON invArtUbicaciond

FOR INSERT, UPDATE
AS BEGIN
DECLARE
@Almacen		varchar(10),
@Posicion		varchar(10),
@Mensaje		varchar(80)	,
@RID			int
SELECT  @Posicion = posicion,@RID=RID FROM Inserted
SELECT @Almacen=Almacen  FROM invArtUbicaciones WHERE  RID=@RID
IF UPDATE(Posicion)
IF NOT EXISTS(SELECT Posicion FROM AlmPos WHERE Posicion = @Posicion  AND Almacen =@Almacen )
BEGIN
SELECT @Mensaje='La Posición capturada no existe dentro del Almacén'
RAISERROR (@Mensaje,16,-1)
END
END

