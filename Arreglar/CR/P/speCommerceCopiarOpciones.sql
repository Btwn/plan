SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speCommerceCopiarOpciones
@VariacionID int,
@VariacionIDOriginal int,
@Ok int = NULL OUTPUT,
@OkRef varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@OpcionID int,
@Orden int,
@Nombre varchar(100),
@OpcionIntelisis varchar(1),
@ID int
DECLARE crOpciones CURSOR LOCAL FOR
SELECT ID, Orden, Nombre, OpcionIntelisis
FROM WebArtOpcion
WHERE VariacionID = @VariacionIDOriginal
OPEN crOpciones
FETCH NEXT FROM crOpciones INTO @OpcionID, @Orden, @Nombre, @OpcionIntelisis
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
INSERT INTO WebArtOpcion (VariacionID,  Orden,  Nombre,  OpcionIntelisis,  GUID)
VALUES					 (@VariacionID, @Orden, @Nombre, @OpcionIntelisis, NEWID())
SELECT @ID = SCOPE_IDENTITY()
EXEC speCommerceCopiarValores @ID, @OpcionID, @VariacionID, @Ok OUTPUT, @OkRef OUTPUT
FETCH NEXT FROM crOpciones INTO @OpcionID, @Orden, @Nombre, @OpcionIntelisis
END
CLOSE crOpciones
DEALLOCATE crOpciones
END

