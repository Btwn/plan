SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gMovPersonal
 AS
SELECT
Modulo,
ModuloID,
ID,
Personal,
Fecha,
Horas,
Cantidad
FROM MovPersonal
UNION ALL
SELECT
Modulo,
ModuloID,
ID,
Personal,
Fecha,
Horas,
Cantidad
FROM hMovPersonal
;

