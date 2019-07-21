SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgArtColumnaBC ON ArtColumna

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@ColumnaN  	varchar(50),
@ColumnaA	varchar(50),
@Mensaje	varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ColumnaN = Columna FROM Inserted
SELECT @ColumnaA = Columna FROM Deleted
IF @ColumnaN = @ColumnaA RETURN
IF @ColumnaN IS NULL AND
EXISTS(SELECT * FROM ArtMatriz WHERE Columna = @ColumnaA)
BEGIN
SELECT @Mensaje = '"'+LTRIM(RTRIM(@ColumnaA))+ '" ' + Descripcion FROM MensajeLista WHERE Mensaje = 30155
RAISERROR (@Mensaje,16,-1)
END ELSE
IF @ColumnaA IS NOT NULL
UPDATE ArtMatriz SET Columna = @ColumnaN WHERE Columna = @ColumnaA
END

