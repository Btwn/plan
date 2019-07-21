SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW cCampanaD

AS
SELECT
ID,
Sucursal,
SucursalOrigen,
Contacto,
ContactoTipo,
Situacion,
Observaciones,
Calificacion,
Usuario,
EnviarA,
ListaPreciosEsp,
Instruccion,
MapaLatitud,
MapaLongitud,
MapaPrecision,
Almacen,
FechaD,
FechaA
FROM
CampanaD

