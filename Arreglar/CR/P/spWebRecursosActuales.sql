SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebRecursosActuales
AS BEGIN
SELECT Recurso, Nombre
FROM Recurso
WHERE Estatus = 'ALTA'
AND Nombre Is NOT NULL AND Nombre <> ''
ORDER BY Nombre
RETURN
END

