SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDINominaReciboD
@Estacion		int,
@ID				int,
@Personal		varchar(10),
@Ok				int			OUTPUT,
@OkRef			varchar(255)OUTPUT

AS
BEGIN
DECLARE @DiasHorasDobles		float,
@DiasHorasTriples		float
SELECT @DiasHorasDobles = ISNULL(SUM(CASE co.CampoTotalizar WHEN 'Importe' THEN ISNULL(Importe, 0) WHEN 'Cantidad' THEN ISNULL(Cantidad, 0) END), 0)
FROM NominaD n WITH (NOLOCK)
JOIN CFDINominaConcepto co ON n.Concepto = co.Concepto
WHERE n.ID = @ID
AND n.Personal = @Personal
AND ISNULL(CfgDiasHorasDobles, 0) = 1
SELECT @DiasHorasTriples = ISNULL(SUM(CASE co.CampoTotalizar WHEN 'Importe' THEN ISNULL(Importe, 0) WHEN 'Cantidad' THEN ISNULL(Cantidad, 0) END), 0)
FROM NominaD n WITH (NOLOCK)
JOIN CFDINominaConcepto co ON n.Concepto = co.Concepto
WHERE n.ID = @ID
AND n.Personal = @Personal
AND ISNULL(CfgDiasHorasTriples, 0) = 1
INSERT INTO CFDINominaPercepcionDeduccion(
ID,   Personal, Movimiento,   TipoSAT,                   ClaveSAT,   Concepto, ImporteGravado)
SELECT @ID, p.Personal, 'Percepcion', CONVERT(int, c.TipoSAT), c.ClaveSAT, c.Concepto, ISNULL(CASE c.CampoTotalizar WHEN 'Importe' THEN ISNULL(Importe, 0) WHEN 'Cantidad' THEN ISNULL(Cantidad, 0) END, 0)
FROM Personal p WITH (NOLOCK)
JOIN NominaD d WITH (NOLOCK) ON p.Personal = d.Personal
JOIN Nomina  n WITH (NOLOCK) ON n.ID = d.ID
JOIN CFDINominaConcepto c WITH (NOLOCK) ON d.Concepto = c.Concepto
WHERE P.Personal = @Personal
AND n.ID = @ID
AND ISNULL(CfgPercepcionesGravadas, 0) = 1
INSERT INTO CFDINominaPercepcionDeduccion(
ID,   Personal, Movimiento,   TipoSAT,                   ClaveSAT,   Concepto, ImporteExcento)
SELECT @ID, p.Personal, 'Percepcion', CONVERT(int, c.TipoSAT), c.ClaveSAT, c.Concepto, ISNULL(CASE c.CampoTotalizar WHEN 'Importe' THEN ISNULL(Importe, 0) WHEN 'Cantidad' THEN ISNULL(Cantidad, 0) END, 0)
FROM Personal p WITH (NOLOCK)
JOIN NominaD d WITH (NOLOCK) ON p.Personal = d.Personal
JOIN Nomina  n WITH (NOLOCK) ON n.ID = d.ID
JOIN CFDINominaConcepto c WITH (NOLOCK) ON d.Concepto = c.Concepto
WHERE P.Personal = @Personal
AND n.ID = @ID
AND ISNULL(CfgPercepcionesExcentas, 0) = 1
INSERT INTO CFDINominaPercepcionDeduccion(
ID,   Personal, Movimiento,  TipoSAT,                            ClaveSAT,   Concepto, ImporteGravado)
SELECT @ID, p.Personal, 'Deduccion', CONVERT(int, c.TipoDeduccionSAT), c.ClaveSAT, c.Concepto, ISNULL(CASE c.CampoTotalizar WHEN 'Importe' THEN ISNULL(Importe, 0) WHEN 'Cantidad' THEN ISNULL(Cantidad, 0) END, 0)
FROM Personal p WITH (NOLOCK)
JOIN NominaD d WITH (NOLOCK) ON p.Personal = d.Personal
JOIN Nomina  n WITH (NOLOCK) ON n.ID = d.ID
JOIN CFDINominaConcepto c WITH (NOLOCK) ON d.Concepto = c.Concepto
WHERE P.Personal = @Personal
AND n.ID = @ID
AND ISNULL(CfgDeduccionesGravadas, 0) = 1
INSERT INTO CFDINominaPercepcionDeduccion(
ID,   Personal, Movimiento,  TipoSAT,                            ClaveSAT,   Concepto, ImporteExcento)
SELECT @ID, p.Personal, 'Deduccion', CONVERT(int, c.TipoDeduccionSAT), c.ClaveSAT, c.Concepto, ISNULL(CASE c.CampoTotalizar WHEN 'Importe' THEN ISNULL(Importe, 0) WHEN 'Cantidad' THEN ISNULL(Cantidad, 0) END, 0)
FROM Personal p WITH (NOLOCK)
JOIN NominaD d WITH (NOLOCK) ON p.Personal = d.Personal
JOIN Nomina  n WITH (NOLOCK) ON n.ID = d.ID
JOIN CFDINominaConcepto c WITH (NOLOCK) ON d.Concepto = c.Concepto
WHERE P.Personal = @Personal
AND n.ID = @ID
AND ISNULL(CfgDeduccionesExcentas, 0) = 1
INSERT INTO CFDINominaHoraExtra(
ID,   Personal,   TipoHoras,        HorasExtra,                                       ImportePagado,           Dias)
SELECT @ID, p.Personal, c.CfgTipoHoraExtra, CONVERT(int, ROUND(SUM(ISNULL(Cantidad, 0)), 0)), SUM(ISNULL(Importe, 0)), CASE c.CfgTipoHoraExtra WHEN 'Dobles' THEN CONVERT(int, ROUND(@DiasHorasDobles, 0)) WHEN 'Triples' THEN CONVERT(int, ROUND(@DiasHorasTriples, 0)) END
FROM Personal p WITH (NOLOCK)
JOIN NominaD d WITH (NOLOCK) ON p.Personal = d.Personal
JOIN Nomina  n WITH (NOLOCK) ON n.ID = d.ID
JOIN CFDINominaConcepto c WITH (NOLOCK) ON d.Concepto = c.Concepto
WHERE P.Personal = @Personal
AND n.ID = @ID
AND ISNULL(CfgHoraExtra, 0) = 1
AND ISNULL(Cantidad, 0) <> 0
GROUP BY p.Personal, c.CfgTipoHoraExtra
INSERT INTO CFDINominaIncapacidad(
ID,   Personal, Dias,     TipoIncapacidad,                                                                                                         Descuento)
SELECT @ID, p.Personal, Cantidad, CASE c.CfgTipoIncapacidad WHEN 'Enfermedad General' THEN 2 WHEN 'Maternidad' THEN 3 WHEN 'Riesgo de Trabajo' THEN 1 END, ISNULL(Importe, 0)
FROM Personal p WITH (NOLOCK)
JOIN NominaD d WITH (NOLOCK) ON p.Personal = d.Personal
JOIN Nomina  n WITH (NOLOCK) ON n.ID = d.ID
JOIN CFDINominaConcepto c WITH (NOLOCK) ON d.Concepto = c.Concepto
WHERE P.Personal = @Personal
AND n.ID = @ID
AND ISNULL(CfgIncapacidad, 0) = 1
INSERT INTO CFDINominaRetencion(
ID,   Personal, Concepto,             Importe)
SELECT @ID, p.Personal, 'ISR',/*d.Concepto, */ISNULL(Importe, 0)
FROM Personal p WITH (NOLOCK)
JOIN NominaD d WITH (NOLOCK) ON p.Personal = d.Personal
JOIN Nomina  n WITH (NOLOCK) ON n.ID = d.ID
JOIN CFDINominaConcepto c WITH (NOLOCK) ON d.Concepto = c.Concepto
WHERE P.Personal = @Personal
AND n.ID = @ID
AND ISNULL(CfgDescuento, 0) = 1
RETURN
END

