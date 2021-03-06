SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarCFDFlexLote
@Estacion           int,
@Empresa            varchar(5)

AS BEGIN
DECLARE
@Modulo     varchar(5),
@ID         int,
@Estatus    varchar(15) ,
@Ok         int,
@OkRef      varchar(255)
DECLARE crCFDTemp CURSOR LOCAL FOR
SELECT Empresa, Modulo, ID, Estatus
FROM CFDFlexPendiente
WHERE ID IN(SELECT ID FROM LISTAID WHERE Estacion = @Estacion)
OPEN crCFDTemp
FETCH NEXT FROM crCFDTemp INTO @Empresa, @Modulo, @ID, @Estatus
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
EXEC spCFDFlex @Estacion, @Empresa, @Modulo, @ID, @Estatus, @Ok OUTPUT, @OkRef OUTPUT
FETCH NEXT FROM crCFDTemp INTO @Empresa, @Modulo, @ID, @Estatus
END
CLOSE crCFDTemp
DEALLOCATE crCFDTemp
IF @Ok IS NOT NULL
BEGIN
SELECT @OkRef =  ISNULL(Descripcion,'') +ISNULL(@OkRef,'') FROM MensajeLista WHERE Mensaje = @Ok
SELECT @OkRef
END
ELSE
SELECT 'PROCESO CONCLUIDO EXISTOSAMENTE'
RETURN
END

