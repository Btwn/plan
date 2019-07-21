SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISActualizar

AS BEGIN
DECLARE
@Tabla	varchar(100),
@Activar	bit
IF EXISTS(SELECT * FROM Version WHERE SincroSSB = 1 AND SincroIS = 1)
BEGIN
RAISERROR ('No se puede Activar Sincro SSB y Sincro IS Simultaneamente',16,-1)
RETURN
END
EXEC spSetInformacionContexto 'SINCROIS', 1
UPDATE Version SET validarsincrosemilla = 0
EXEC spSetInformacionContexto 'SINCROIS', 0
SELECT @Activar = SincroIS FROM Version
IF @Activar = 1
UPDATE SysTabla WITH (ROWLOCK) SET Tipo = 'N/A' WHERE SysTabla IN ('SincroLog','SincroLogAdvertencia','SincroLogError','SincroMovRegistro','SincroPaquete')
DECLARE crSincroISActualizar CURSOR LOCAL FOR
SELECT SysTabla
FROM SysTabla
WHERE UPPER(NULLIF(RTRIM(dbo.fnSincroISTablaTipo(SysTabla)), '')) NOT IN (NULL, 'N/A')
OPEN crSincroISActualizar
FETCH NEXT FROM crSincroISActualizar INTO @Tabla
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2 AND dbo.fnTablaExiste(@Tabla) = 1
BEGIN
EXEC spSincroISActivarTabla @Tabla, @Activar
END
FETCH NEXT FROM crSincroISActualizar INTO @Tabla
END
CLOSE crSincroISActualizar
DEALLOCATE crSincroISActualizar
RETURN
END

