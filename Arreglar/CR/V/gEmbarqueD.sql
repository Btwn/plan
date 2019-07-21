SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gEmbarqueD
 AS
SELECT
ID,
Orden,
EmbarqueMov,
Paquetes,
Estado,
FechaHora,
Persona,
PersonaID,
Forma,
Importe,
Referencia,
Observaciones,
Causa,
Sucursal,
Logico1,
Logico2,
Logico3,
Logico4,
Logico5,
MovPorcentaje,
DesembarqueParcial,
SucursalOrigen,
ParaComisionChoferMAVI
FROM EmbarqueD
UNION ALL
SELECT
ID,
Orden,
EmbarqueMov,
Paquetes,
Estado,
FechaHora,
Persona,
PersonaID,
Forma,
Importe,
Referencia,
Observaciones,
Causa,
Sucursal,
Logico1,
Logico2,
Logico3,
Logico4,
Logico5,
MovPorcentaje,
DesembarqueParcial,
SucursalOrigen,
ParaComisionChoferMAVI
FROM hEmbarqueD
;

