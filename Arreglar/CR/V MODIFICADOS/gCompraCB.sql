SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gCompraCB
 AS
SELECT
ID,
RenglonID,
Codigo,
Cantidad,
Articulo,
SubCuenta,
Sucursal,
SucursalOrigen
FROM CompraCB WITH(NOLOCK)
UNION ALL
SELECT
ID,
RenglonID,
Codigo,
Cantidad,
Articulo,
SubCuenta,
Sucursal,
SucursalOrigen
FROM hCompraCB WITH(NOLOCK)
;

