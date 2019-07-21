SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDINominaVerificar
@Estacion					int,
@ID							int,
@Empresa					varchar(5),
@Mov						varchar(20),
@MovID						varchar(20),
@Version					varchar(5),
@Personal					varchar(10),
@XML						varchar(max),
@Ok							int				OUTPUT,
@OkRef						varchar(255)	OUTPUT

AS
BEGIN
DECLARE @RegistroPatronal			varchar(20),
@CURP						varchar(30),
@TipoComprobante			varchar(20),
@tipoRegimen				int,
@NumSeguridadSocial		varchar(30),
@FechaPago				datetime,
@FechaInicialPago			datetime,
@FechaFinalPago			datetime,
@NumDiasPagados			float,
@Departamento				varchar(50),
@CLABE					varchar(18),
@Banco					varchar(5),
@FechainicioRelLaboral	datetime,
@Antiguedad				int,
@Puesto					varchar(50),
@TipoContrato				varchar(50),
@TipoJornada				varchar(20),
@PeriodicidadPago			varchar(20),
@SalarioBaseCotApor		varchar(20),
@RiesgoPuesto				varchar(20),
@SalarioDiarioIntegrado	float
SELECT @RegistroPatronal			= RegistroPatronal,
@CURP						= CURP,
@TipoComprobante			= TipoComprobante,
@tipoRegimen				= tipoRegimen,
@NumSeguridadSocial		= NumSeguridadSocial,
@FechaPago					= FechaPago,
@FechaInicialPago			= FechaInicialPago,
@FechaFinalPago			= FechaFinalPago,
@NumDiasPagados			= NumDiasPagados,
@Departamento				= Departamento,
@CLABE						= CLABE,
@Banco						= Banco,
@FechainicioRelLaboral		= FechainicioRelLaboral,
@Antiguedad				= Antiguedad,
@Puesto					= Puesto,
@TipoContrato				= TipoContrato,
@TipoJornada				= TipoJornada,
@PeriodicidadPago			= PeriodicidadPago,
@SalarioBaseCotApor		= SalarioBaseCotApor,
@RiesgoPuesto				= RiesgoPuesto,
@SalarioDiarioIntegrado	= SalarioDiarioIntegrado
FROM CFDINominaRecibo
WHERE ID = @ID
AND Personal = @Personal
IF @Ok IS NULL AND @Version IS NULL
SELECT @Ok = 10060, @OkRef = 'Version'
IF @Ok IS NULL AND @Personal IS NULL
SELECT @Ok = 10060, @OkRef = 'Personal'
IF @Ok IS NULL AND @CURP IS NULL
SELECT @Ok = 10060, @OkRef = 'CURP'
IF @Ok IS NULL AND @TipoRegimen IS NULL
SELECT @Ok = 10060, @OkRef = 'Tipo Régimen'
IF @Ok IS NULL AND @FechaPago IS NULL
SELECT @Ok = 10060, @OkRef = 'Fecha Pago'
IF @Ok IS NULL AND @FechaInicialPago IS NULL
SELECT @Ok = 10060, @OkRef = 'Fecha Inicial Pago'
IF @Ok IS NULL AND @FechaFinalPago IS NULL
SELECT @Ok = 10060, @OkRef = 'Fecha Final Pago'
IF @Ok IS NULL AND @NumDiasPagados IS NULL
SELECT @Ok = 10060, @OkRef = 'Número Días Pagados'
IF @Ok IS NULL AND @PeriodicidadPago IS NULL
SELECT @Ok = 10060, @OkRef = 'Periodicidad de Pago'
IF @Ok IS NULL AND EXISTS(SELECT RID FROM CFDINominaPercepcionDeduccion WHERE ID = @ID AND Personal = @Personal AND TipoSAT IS NULL)
SELECT @Ok = 10060, @OkRef = 'Tipo Percepción / Deducción '+Concepto FROM CFDINominaPercepcionDeduccion WHERE ID = @ID AND Personal = @Personal AND TipoSAT IS NULL
IF @Ok IS NULL AND EXISTS(SELECT RID FROM CFDINominaPercepcionDeduccion WHERE ID = @ID AND Personal = @Personal AND ClaveSAT IS NULL)
SELECT @Ok = 10060, @OkRef = 'Clave Percepción / Deducción '+Concepto FROM CFDINominaPercepcionDeduccion WHERE ID = @ID AND Personal = @Personal AND ClaveSAT IS NULL
IF @Ok IS NULL AND EXISTS(SELECT RID FROM CFDINominaIncapacidad WHERE ID = @ID AND Personal = @Personal AND Dias IS NULL)
SELECT @Ok = 10060, @OkRef = 'Días Incapacidad'
IF @Ok IS NULL AND EXISTS(SELECT RID FROM CFDINominaIncapacidad WHERE ID = @ID AND Personal = @Personal AND TipoIncapacidad IS NULL)
SELECT @Ok = 10060, @OkRef = 'Tipo de Incapacidad'
IF @Ok IS NULL AND EXISTS(SELECT RID FROM CFDINominaIncapacidad WHERE ID = @ID AND Personal = @Personal AND Descuento IS NULL)
SELECT @Ok = 10060, @OkRef = 'Descuento Incapacidad'
IF @Ok IS NULL AND EXISTS(SELECT RID FROM CFDINominaHoraExtra WHERE ID = @ID AND Personal = @Personal AND Dias IS NULL)
SELECT @Ok = 10060, @OkRef = 'Días Hora Extra'
IF @Ok IS NULL AND EXISTS(SELECT RID FROM CFDINominaHoraExtra WHERE ID = @ID AND Personal = @Personal AND TipoHoras IS NULL)
SELECT @Ok = 10060, @OkRef = 'Tipo de Hora Extra'
IF @Ok IS NULL AND EXISTS(SELECT RID FROM CFDINominaHoraExtra WHERE ID = @ID AND Personal = @Personal AND HorasExtra IS NULL)
SELECT @Ok = 10060, @OkRef = 'Horas Extra'
IF @Ok IS NULL AND EXISTS(SELECT RID FROM CFDINominaHoraExtra WHERE ID = @ID AND Personal = @Personal AND ImportePagado IS NULL)
SELECT @Ok = 10060, @OkRef = 'Importe Horas Extra'
RETURN
END

