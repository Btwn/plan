SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgArtRenglonBC ON ArtRenglon

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@RenglonN  	varchar(50),
@RenglonA	varchar(50),
@Mensaje	varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @RenglonN = Renglon FROM Inserted
SELECT @RenglonA = Renglon FROM Deleted
IF @RenglonN = @RenglonA RETURN
IF @RenglonN IS NULL AND
EXISTS(SELECT * FROM ArtMatriz WHERE Renglon = @RenglonA)
BEGIN
SELECT @Mensaje = '"'+LTRIM(RTRIM(@RenglonA))+ '" ' + Descripcion FROM MensajeLista WHERE Mensaje = 30155
RAISERROR (@Mensaje,16,-1)
END ELSE
IF @RenglonA IS NOT NULL
UPDATE ArtMatriz SET Renglon = @RenglonN WHERE Renglon = @RenglonA
END

