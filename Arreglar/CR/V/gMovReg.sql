SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gMovReg
 AS
SELECT
Modulo,
ID,
Mov,
MovID,
Estatus,
Sucursal,
UEN,
FechaEmision,
Empresa,
CtoTipo,
Contacto,
EnviarA,
Situacion,
SituacionFecha,
SituacionUsuario,
SituacionNota,
Proyecto,
Concepto,
Referencia,
Usuario,
MovTipo,
Ejercicio,
Periodo,
FechaCancelacion,
Clase,
SubClase,
Causa,
FormaEnvio,
Condicion,
ZonaImpuesto,
CtaDinero,
Cajero,
Moneda,
TipoCambio,
Deudor,
Acreedor,
Personal,
Agente
FROM MovReg
UNION ALL
SELECT
Modulo,
ID,
Mov,
MovID,
Estatus,
Sucursal,
UEN,
FechaEmision,
Empresa,
CtoTipo,
Contacto,
EnviarA,
Situacion,
SituacionFecha,
SituacionUsuario,
SituacionNota,
Proyecto,
Concepto,
Referencia,
Usuario,
MovTipo,
Ejercicio,
Periodo,
FechaCancelacion,
Clase,
SubClase,
Causa,
FormaEnvio,
Condicion,
ZonaImpuesto,
CtaDinero,
Cajero,
Moneda,
TipoCambio,
Deudor,
Acreedor,
Personal,
Agente
FROM hMovReg
;

