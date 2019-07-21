SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovPos
@Estacion		int,
@MovModulo		varchar(5),
@MovModuloID	int

AS BEGIN
DELETE FROM MovPos WHERE Estacion = @Estacion AND Modulo = @MovModulo
EXEC spMovPosAscendencia @Estacion, @MovModulo, @MovModulo, @MovModuloID, 0
EXEC spMovPosDescendencia @Estacion, @MovModulo, @MovModulo, @MovModuloID, 0
END

