SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebArtReGenerarCombinaciones
@ID        int

AS BEGIN
DECLARE
@IDArt          int,
@Ok             int
BEGIN TRANSACTION
IF EXISTS(SELECT * FROM WebArt WHERE VariacionID = @ID)
BEGIN
DECLARE crArticulo CURSOR FAST_FORWARD FOR
SELECT VariacionID
FROM WebArt
WHERE  VariacionID = @ID
OPEN  crArticulo
FETCH NEXT FROM  crArticulo INTO  @IDArt
WHILE @@FETCH_STATUS = 0
BEGIN
EXEC spWebArtGenerarCombinaciones @IDArt, @ID, @Ok OUTPUT
FETCH NEXT FROM  crArticulo INTO @IDArt
END
CLOSE  crArticulo
DEALLOCATE  crArticulo
END
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
SELECT 'Proceso Concluido con Exito'
END
ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT 'No Se Pudieron generar Las Combinaciones'
END
RETURN
END

