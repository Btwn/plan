SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spActualizaPOSJobError
@Sucursal		int

AS
BEGIN
DECLARE
@ID				int,
@IDPos			varchar(36),
@Estatus		varchar(15)
DECLARE crSE1 CURSOR LOCAL FOR
SELECT ID, IDPos
FROM POSJobErrores
WHERE /*Sucursal = @Sucursal
AND*/ Atendido = 0
OPEN crSE1
FETCH NEXT FROM crSE1 INTO @ID, @IDPos
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SET @Estatus = NULL
SELECT @Estatus = Estatus
FROM POSL WITH (NOLOCK)
WHERE ID = @IDPos
IF @Estatus <> 'CONCLUIDO'
UPDATE POSJobErrores SET Atendido = 1 WHERE ID = @ID
END
FETCH NEXT FROM crSE1 INTO @ID, @IDPos
END
CLOSE crSE1
DEALLOCATE crSE1
DELETE FROM POSJobErrores
WHERE /*Sucursal = @Sucursal
AND*/ Atendido = 1
SELECT '****** ACTUALIZADO ******'
END

