SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gMovBitacora
 AS
SELECT
Modulo,
ID,
RID,
Fecha,
Evento,
Tipo,
Sucursal,
Usuario,
MovEstatus,
MovSituacion,
MovSituacionFecha,
MovSituacionUsuario,
MovSituacionNota,
Duracion,
DuracionUnidad,
Agente,
Clave,
Importe,
ObsReanalisis,
TipoRespuesta,
CitaCliente,
CitaAval,
horaCita,
FechaCita
FROM MovBitacora
UNION ALL
SELECT
Modulo,
ID,
RID,
Fecha,
Evento,
Tipo,
Sucursal,
Usuario,
MovEstatus,
MovSituacion,
MovSituacionFecha,
MovSituacionUsuario,
MovSituacionNota,
Duracion,
DuracionUnidad,
Agente,
Clave,
Importe,
ObsReanalisis,
TipoRespuesta,
CitaCliente,
CitaAval,
horaCita,
FechaCita
FROM hMovBitacora
;

