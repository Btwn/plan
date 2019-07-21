SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC pNetLogRecibosNomina
AS BEGIN
SELECT '(Todas)' Descripcion
UNION ALL
SELECT DISTINCT Descripcion
FROM LogRecibosNomina WITH(NOLOCK)
ORDER BY Descripcion
RETURN
END

