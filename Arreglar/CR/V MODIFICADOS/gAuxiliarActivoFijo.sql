SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gAuxiliarActivoFijo
 AS
SELECT
ID,
IDMov,
Renglon,
Empresa,
Modulo,
Articulo,
Serie,
Cantidad,
ValorAdquisicion,
ImporteMov,
FactorCalculo,
Total,
FechaEmision,
FechaInicioDepreciacion,
Aplicar,
Icono
FROM AuxiliarActivoFijo WITH(NOLOCK)
UNION ALL
SELECT
ID,
IDMov,
Renglon,
Empresa,
Modulo,
Articulo,
Serie,
Cantidad,
ValorAdquisicion,
ImporteMov,
FactorCalculo,
Total,
FechaEmision,
FechaInicioDepreciacion,
Aplicar,
Icono
FROM hAuxiliarActivoFijo WITH(NOLOCK)
;

