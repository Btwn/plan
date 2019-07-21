SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNotificacionBorrar
@Estacion			int

AS BEGIN
DECLARE
@RID				int,
@Ok					int,
@OkRef				varchar(255)
DECLARE crListaID CURSOR FOR
SELECT ID
FROM ListaID
WHERE Estacion = @Estacion
OPEN crListaID
FETCH NEXT FROM crListaID INTO @RID
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
DELETE FROM UsuarioNotificacion WHERE RID = @RID
FETCH NEXT FROM crListaID INTO @RID
END
CLOSE crListaID
DEALLOCATE crListaID
DELETE FROM ListaID WHERE Estacion = @Estacion
END

