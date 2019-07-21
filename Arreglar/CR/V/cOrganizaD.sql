SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW cOrganizaD

AS
SELECT
ID,
Renglon,
Sucursal,
SucursalOrigen,
Organizacion,
Posicion,
Entidad,
Rol,
ContactoTipo,
TipoRelacion,
Prospecto,
Cliente,
Proveedor,
Agente,
Personal,
Espacio,
Recurso,
VIN,
EntidadDestino,
Usuario,
Observaciones
FROM
OrganizaD

