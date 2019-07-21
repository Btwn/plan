SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gConciliacionCompensacion
 AS
SELECT
ID,
RID,
ConciliacionD,
Manual,
Sucursal,
SucursalOrigen
FROM ConciliacionCompensacion WITH(NOLOCK)
UNION ALL
SELECT
ID,
RID,
ConciliacionD,
Manual,
Sucursal,
SucursalOrigen
FROM hConciliacionCompensacion WITH(NOLOCK)
;

