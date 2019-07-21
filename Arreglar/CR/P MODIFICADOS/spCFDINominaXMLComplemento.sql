SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDINominaXMLComplemento
@Estacion					int,
@ID							int,
@Personal					varchar(10),
@TotalPercepciones			float,
@TotalDeducciones			float,
@PercepcionesTotalGravado	float,
@PercepcionesTotalExcento	float,
@DeduccionesTotalGravado	float,
@DeduccionesTotalExcento	float,
@XMLComplemento				varchar(max) OUTPUT,
@XML						varchar(max) OUTPUT,
@Ok							int			 OUTPUT,
@OkRef						varchar(255) OUTPUT

AS
BEGIN
DECLARE @XMLNomina			varchar(max),
@XMLPercepciones		varchar(max),
@XMLDeducciones		varchar(max),
@XMLIncapacidades		varchar(max),
@XMLHorasExtra		varchar(max),
@XMLRetenciones		varchar(max)
SELECT @XMLNomina = (
SELECT 
'1.1' 'Version',
NULLIF(RTRIM(Nomina.RegistroPatronal), '') 'RegistroPatronal',
Nomina.Personal 'NumEmpleado',
NULLIF(RTRIM(Nomina.CURP), '') 'CURP',
NULLIF(RTRIM(Nomina.TipoRegimen), '') 'TipoRegimen',
NULLIF(RTRIM(Nomina.NumSeguridadSocial), '') 'NumSeguridadSocial',
CONVERT(varchar(19), Nomina.FechaPago, 126) 'FechaPago',
CONVERT(varchar(19), Nomina.FechaInicialPago, 126) 'FechaInicialPago',
CONVERT(varchar(19), Nomina.FechaFinalPago, 126) 'FechaFinalPago',
CONVERT(varchar(max), ISNULL(Nomina.NumDiasPagados, 0)) 'NumDiasPagados',
NULLIF(RTRIM(Nomina.Departamento), '') 'Departamento',
NULLIF(RTRIM(Nomina.CLABE), '') 'CLABE',
CASE ISNULL(Nomina.Banco, 0) WHEN 0 THEN NULL ELSE dbo.fnRellenarCerosIzquierda(CONVERT(int, Nomina.Banco), 3) END 'Banco',
CONVERT(varchar(19), Nomina.FechaInicioRelLaboral, 126) 'FechaInicioRelLaboral',
Nomina.Antiguedad,
NULLIF(RTRIM(Nomina.Puesto), '') 'Puesto',
NULLIF(RTRIM(Nomina.TipoContrato), '') 'TipoContrato' ,
NULLIF(RTRIM(Nomina.TipoJornada), '') 'TipoJornada',
NULLIF(RTRIM(Nomina.PeriodicidadPago), '') 'PeriodicidadPago',
CONVERT(varchar(max), CONVERT(money, ISNULL(ROUND(SalarioBaseCotApor,2), 0))) 'SalarioBaseCotApor',
NULLIF(RTRIM(Nomina.RiesgoPuesto), '') 'RiesgoPuesto',
CONVERT(varchar(max), CONVERT(money, ISNULL(SalarioDiarioIntegrado, 0))) 'SalarioDiarioIntegrado'
FROM CFDINominaRecibo Nomina WITH (NOLOCK)
WHERE Nomina.ID = @ID
AND Nomina.Personal = @Personal
FOR XML RAW('Nomina')
)
SELECT @XMLNomina = REPLACE(REPLACE(@XMLNomina, '/>', '>'), '<Nomina', '<nomina:Nomina')
IF NOT EXISTS(SELECT * FROM CFDINominaPercepcionDeduccion WITH (NOLOCK) WHERE ID = @ID AND Personal = @Personal AND Movimiento = 'Percepcion')
SELECT @XMLPercepciones = ''
ELSE
BEGIN
SELECT @XMLPercepciones = '<Percepciones TotalGravado="' + CONVERT(varchar(max), CONVERT(money, ISNULL(@PercepcionesTotalGravado, 0))) + '" TotalExento="' + CONVERT(varchar(max), CONVERT(money, ISNULL(@PercepcionesTotalExcento, 0))) + '">'
SELECT @XMLPercepciones = @XMLPercepciones + (
SELECT dbo.fnRellenarCerosIzquierda(ISNULL(TipoSAT, ''), 3)  'TipoPercepcion',
ISNULL(ClaveSAT, '') 'Clave',
ISNULL(Concepto, '') 'Concepto',
CONVERT(varchar(max), CONVERT(money, ISNULL(ImporteGravado, 0))) 'ImporteGravado',
CONVERT(varchar(max), CONVERT(money, ISNULL(ImporteExcento, 0))) 'ImporteExento'
FROM CFDINominaPercepcionDeduccion Percepcion WITH (NOLOCK)
WHERE ID = @ID
AND Personal = @Personal
AND Movimiento = 'Percepcion'
FOR XML AUTO
)
SELECT @XMLPercepciones = REPLACE(REPLACE(@XMLPercepciones, '<Percepciones', '<nomina:Percepciones'), '<Percepcion', '<nomina:Percepcion') + '</nomina:Percepciones>'
END
IF NOT EXISTS(SELECT * FROM CFDINominaPercepcionDeduccion WITH (NOLOCK) WHERE ID = @ID AND Personal = @Personal AND Movimiento = 'Deduccion')
SELECT @XMLDeducciones = ''
ELSE
BEGIN
SELECT @XMLDeducciones = '<Deducciones TotalGravado="' + CONVERT(varchar(max), CONVERT(money, ISNULL(@DeduccionesTotalGravado, 0))) + '" TotalExento="' + CONVERT(varchar(max), CONVERT(money, ISNULL(@DeduccionesTotalExcento, 0))) + '">'
SELECT @XMLDeducciones = @XMLDeducciones + (
SELECT dbo.fnRellenarCerosIzquierda(ISNULL(TipoSAT, ''), 3) 'TipoDeduccion',
ISNULL(ClaveSAT, '') 'Clave',
ISNULL(Concepto, '') 'Concepto',
CONVERT(varchar(max), CONVERT(money, ISNULL(ImporteGravado, 0))) 'ImporteGravado',
CONVERT(varchar(max), CONVERT(money, ISNULL(ImporteExcento, 0))) 'ImporteExento'
FROM CFDINominaPercepcionDeduccion Deduccion WITH (NOLOCK)
WHERE ID = @ID
AND Personal = @Personal
AND Movimiento = 'Deduccion'
FOR XML AUTO
)
SELECT @XMLDeducciones = REPLACE(REPLACE(@XMLDeducciones, '<Deducciones', '<nomina:Deducciones'), '<Deduccion', '<nomina:Deduccion') + '</nomina:Deducciones>'
END
IF NOT EXISTS(SELECT * FROM CFDINominaIncapacidad WITH (NOLOCK) WHERE ID = @ID AND Personal = @Personal)
SELECT @XMLIncapacidades = ''
ELSE
BEGIN
SELECT @XMLIncapacidades = (
SELECT Dias 'DiasIncapacidad', TipoIncapacidad, CONVERT(varchar(max), CONVERT(money, ISNULL(Descuento, 0))) 'Descuento'
FROM CFDINominaIncapacidad Incapacidad WITH (NOLOCK)
WHERE ID = @ID
AND Personal = @Personal
FOR XML AUTO
)
SELECT @XMLIncapacidades = '<nomina:Incapacidades>' + REPLACE(@XMLIncapacidades, '<Incapacidad', '<nomina:Incapacidad') + '</nomina:Incapacidades>'
END
IF NOT EXISTS(SELECT * FROM CFDINominaHoraExtra WITH (NOLOCK) WHERE ID = @ID AND Personal = @Personal)
SELECT @XMLHorasExtra = ''
ELSE
BEGIN
SELECT @XMLHorasExtra = (
SELECT Dias, TipoHoras, CONVERT(varchar(max), ISNULL(HorasExtra, 0)) 'HorasExtra', CONVERT(varchar(max), CONVERT(money, ISNULL(ImportePagado, 0))) 'ImportePagado'
FROM CFDINominaHoraExtra HorasExtra WITH (NOLOCK)
WHERE ID = @ID
AND Personal = @Personal
FOR XML AUTO
)
SELECT @XMLHorasExtra = '<nomina:HorasExtras>' + REPLACE(@XMLHorasExtra, '<HorasExtra', '<nomina:HorasExtra') + '</nomina:HorasExtras>'
END
IF NOT EXISTS(SELECT * FROM CFDINominaRetencion WITH (NOLOCK) WHERE ID = @ID AND Personal = @Personal)
SELECT @XMLRetenciones = ''
ELSE
BEGIN
SELECT @XMLRetenciones = (
SELECT Concepto 'impuesto', CONVERT(varchar(max), CONVERT(money, ISNULL(Importe, 0))) 'importe'
FROM CFDINominaRetencion Retencion WITH (NOLOCK)
WHERE ID = @ID
AND Personal = @Personal
FOR XML AUTO
)
SELECT @XMLRetenciones = REPLACE(@XMLRetenciones, '<Retencion', '<cfdi:Retencion')
END
SELECT @XMLComplemento = ISNULL(@XMLNomina, '') + ISNULL(@XMLPercepciones, '') + ISNULL(@XMLDeducciones, '') + ISNULL(@XMLIncapacidades, '') + ISNULL(@XMLHorasExtra, '') + '</nomina:Nomina>'
SELECT @XML = REPLACE(@XML, '@Complemento', ISNULL(@XMLComplemento, ''))
SELECT @XML = REPLACE(@XML, '@Retenciones', ISNULL(@XMLRetenciones, ''))
IF ISNULL(@XMLRetenciones, '') = ''
BEGIN
SELECT @XML = REPLACE(@XML, '<cfdi:Retenciones>', '')
SELECT @XML = REPLACE(@XML, '</cfdi:Retenciones>', '')
END
RETURN
END

