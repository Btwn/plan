SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgDIOTArt ON Art
FOR INSERT, UPDATE
AS
BEGIN
DECLARE @Articulo			varchar(20),
@EsDeducible		bit
SELECT @Articulo = Articulo, @EsDeducible = ISNULL(EsDeducible, 0) FROM Inserted
IF UPDATE(EsDeducible)
BEGIN
IF @EsDeducible = 1
BEGIN
IF NOT EXISTS(SELECT Articulo FROM DIOTArt WHERE Articulo = @Articulo)
INSERT INTO DIOTArt(Articulo) VALUES(@Articulo)
END
ELSE IF @EsDeducible = 0
DELETE DIOTArt WHERE Articulo = @Articulo
END
RETURN
END

