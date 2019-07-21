SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDINominaRecibo
@Estacion					int,
@ID							int,
@Personal					varchar(10),
@Empresa					varchar(5),
@TotalPercepciones			float		OUTPUT,
@TotalDeducciones			float		OUTPUT,
@PercepcionesTotalGravado	float		OUTPUT,
@PercepcionesTotalExcento	float		OUTPUT,
@DeduccionesTotalGravado	float		OUTPUT,
@DeduccionesTotalExcento	float		OUTPUT,
@TotalDescuento				float		OUTPUT,
@Importe					float		OUTPUT,
@TotalDeduccionesSinISR		float		OUTPUT,
@Ok							int			OUTPUT,
@OkRef						varchar(255)OUTPUT

AS
BEGIN
DECLARE @NumDiasPagados			float,
@Hoy						datetime,
@SDI						float,
@SucursalTrabajo			int,
@Categoria				varchar(50),
@Puesto					varchar(50),
@ClaveRiesgo				varchar(50),
@NominaEditarFechaPago	bit
SELECT @NominaEditarFechaPago = NominaEditarFechaPago FROM EmpresaCFD WITH (NOLOCK) WHERE Empresa = @Empresa
SELECT @SucursalTrabajo = SucursalTrabajo, @Categoria = Categoria, @Puesto = Puesto FROM Personal WITH (NOLOCK) WHERE Personal = @Personal
SELECT @Hoy = GETDATE()
SELECT @NumDiasPagados = ROUND(ISNULL(SUM(CASE co.CampoTotalizar WHEN 'Importe' THEN ISNULL(Importe, 0) WHEN 'Cantidad' THEN ISNULL(Cantidad, 0) END), 0), 2)
FROM NominaD n WITH (NOLOCK)
JOIN CFDINominaConcepto co WITH (NOLOCK) ON n.Concepto = co.Concepto
WHERE n.ID = @ID
AND n.Personal = @Personal
AND ISNULL(CfgDiasPagados, 0) = 1
SELECT @SDI = ISNULL(SUM(CASE co.CampoTotalizar WHEN 'Importe' THEN ISNULL(Importe, 0) WHEN 'Cantidad' THEN ISNULL(Cantidad, 0) END), 0)
FROM NominaD n WITH (NOLOCK)
JOIN CFDINominaConcepto co WITH (NOLOCK) ON n.Concepto = co.Concepto
WHERE n.ID = @ID
AND n.Personal = @Personal
AND ISNULL(CfgSDI, 0) = 1
SELECT @PercepcionesTotalGravado = ISNULL(SUM(CASE co.CampoTotalizar WHEN 'Importe' THEN ISNULL(Importe, 0) WHEN 'Cantidad' THEN ISNULL(Cantidad, 0) END), 0)
FROM NominaD n WITH (NOLOCK)
JOIN CFDINominaConcepto co WITH (NOLOCK) ON n.Concepto = co.Concepto
WHERE n.ID = @ID
AND n.Personal = @Personal
AND ISNULL(CfgPercepcionesGravadas, 0) = 1
SELECT @PercepcionesTotalExcento = ISNULL(SUM(CASE co.CampoTotalizar WHEN 'Importe' THEN ISNULL(Importe, 0) WHEN 'Cantidad' THEN ISNULL(Cantidad, 0) END), 0)
FROM NominaD n WITH (NOLOCK)
JOIN CFDINominaConcepto co WITH (NOLOCK) ON n.Concepto = co.Concepto
WHERE n.ID = @ID
AND n.Personal = @Personal
AND ISNULL(CfgPercepcionesExcentas, 0) = 1
SELECT @DeduccionesTotalGravado = ISNULL(SUM(CASE co.CampoTotalizar WHEN 'Importe' THEN ISNULL(Importe, 0) WHEN 'Cantidad' THEN ISNULL(Cantidad, 0) END), 0)
FROM NominaD n WITH (NOLOCK)
JOIN CFDINominaConcepto co WITH (NOLOCK) ON n.Concepto = co.Concepto
WHERE n.ID = @ID
AND n.Personal = @Personal
AND ISNULL(CfgDeduccionesGravadas, 0) = 1
SELECT @DeduccionesTotalExcento = ISNULL(SUM(CASE co.CampoTotalizar WHEN 'Importe' THEN ISNULL(Importe, 0) WHEN 'Cantidad' THEN ISNULL(Cantidad, 0) END), 0)
FROM NominaD n WITH (NOLOCK)
JOIN CFDINominaConcepto co WITH (NOLOCK) ON n.Concepto = co.Concepto
WHERE n.ID = @ID
AND n.Personal = @Personal
AND ISNULL(CfgDeduccionesExcentas, 0) = 1
SELECT @TotalDescuento = ISNULL(SUM(CASE co.CampoTotalizar WHEN 'Importe' THEN ISNULL(Importe, 0) WHEN 'Cantidad' THEN ISNULL(Cantidad, 0) END), 0)
FROM NominaD n WITH (NOLOCK)
JOIN CFDINominaConcepto co WITH (NOLOCK) ON n.Concepto = co.Concepto
WHERE n.ID = @ID
AND n.Personal = @Personal
AND ISNULL(CfgDescuento, 0) = 1
SELECT @TotalDeduccionesSinISR = ISNULL(SUM(CASE co.CampoTotalizar WHEN 'Importe' THEN ISNULL(Importe, 0) WHEN 'Cantidad' THEN ISNULL(Cantidad, 0) END), 0)
FROM NominaD n WITH (NOLOCK)
JOIN CFDINominaConcepto co WITH (NOLOCK) ON n.Concepto = co.Concepto
WHERE n.ID = @ID
AND n.Personal = @Personal
AND (ISNULL(CfgDeduccionesGravadas, 0) = 1 OR ISNULL(CfgDeduccionesExcentas, 0) = 1)
AND ISNULL(CfgDescuento, 0) = 0
SELECT @TotalDeducciones = ISNULL(@DeduccionesTotalExcento, 0)  + ISNULL(@DeduccionesTotalGravado, 0),
@TotalPercepciones= ISNULL(@PercepcionesTotalExcento, 0) + ISNULL(@PercepcionesTotalGravado, 0)
SELECT @Importe = @TotalPercepciones - @TotalDeducciones
EXEC spCFDIPersonalPropValor @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'CLAVE RIESGO', @ClaveRiesgo OUTPUT
INSERT INTO CFDINominaRecibo(
ID,   Moneda,   Personal,   Version,    RegistroPatronal,   CURP,        RFCEmisor,   RFC,          tipoRegimen,   NumSeguridadSocial,   FechaPago,    FechaInicialPago,                                              FechaFinalPago,  NumDiasPagados,    Departamento, CLABE,                                              Banco,                                           FechainicioRelLaboral, Antiguedad,                                 Puesto,    TipoContrato,    TipoJornada,   PeriodicidadPago,  SalarioBaseCotApor, RiesgoPuesto,                               SalarioDiarioIntegrado,  TotalPercepciones,  PercepcionesTotalGravado,  PercepcionesTotalExcento,  TotalDeducciones,  DeduccionesTotalGravado,  DeduccionesTotalExcento,  TotalDescuento,   TipoComprobante,  Importe,  TotalDeduccionesSinISR,    FormaPago)
SELECT @ID, n.Moneda, p.Personal, m.Version, np.RegistroPatronal, p.Registro, em.RFC,       p.Registro2, tr.Clave,       p.Registro3,          n.FechaEmision, CASE mt.Clave WHEN 'NOM.NA' THEN d.FechaD ELSE n.FechaD END, n.FechaA,         @NumDiasPagados, np.Departamento, dbo.fnRellenarCerosIzquierda(p.PersonalCuenta, 18), dbo.fnRellenarCerosIzquierda(ins.ClaveSAT, 3), p.FechaAntiguedad,       DATEDIFF(Week, p.FechaAntiguedad, @Hoy), np.Puesto, np.TipoContrato, np.Jornada,     p.PeriodoTipo,      @SDI,                ISNULL(@ClaveRiesgo, e.CFDIClaveRiesgo), np.SDIEstaNomina,          @TotalPercepciones, @PercepcionesTotalGravado, @PercepcionesTotalExcento, @TotalDeducciones, @DeduccionesTotalGravado, @DeduccionesTotalExcento, @TotalDescuento, m.TipoComprobante, @Importe, @TotalDeduccionesSinISR, np.FormaPago
FROM Personal p WITH (NOLOCK)
JOIN NominaPersonal np WITH (NOLOCK) ON p.Personal = np.Personal AND np.ID = @ID
JOIN Nomina n WITH (NOLOCK) ON np.ID = n.ID
JOIN NominaD d WITH (NOLOCK) ON n.ID = d.ID AND d.Personal = p.Personal AND d.Personal = np.Personal AND d.ID = @ID
JOIN MovTipo mt WITH (NOLOCK) ON n.Mov = mt.Mov AND mt.Modulo = 'NOM'
JOIN Empresa em WITH (NOLOCK) ON n.Empresa = em.Empresa
LEFT OUTER JOIN EmpresaCFD e WITH (NOLOCK) ON n.Empresa = e.Empresa
JOIN CFDINominaMov m WITH (NOLOCK) ON n.Mov = m.Mov
LEFT OUTER JOIN CFDINominaInstitucionFin ins WITH (NOLOCK) ON p.PersonalSucursal = ins.Institucion
LEFT OUTER JOIN CFDINominaSATTipoRegimen tr WITH (NOLOCK) ON m.tipoRegimen = tr.Nombre
WHERE P.Personal = @Personal
AND n.ID = @ID
GROUP BY n.Moneda, p.Personal, m.Version, np.RegistroPatronal, p.Registro, em.RFC, p.Registro2, tr.Clave, p.Registro3, n.FechaEmision,
mt.Clave, d.FechaD, n.FechaD, n.FechaA, np.Departamento, p.PersonalCuenta, ins.ClaveSAT, p.FechaAntiguedad, np.Puesto,
np.TipoContrato, np.Jornada, p.PeriodoTipo, e.CFDIClaveRiesgo, np.SDIEstaNomina, m.TipoComprobante, np.FormaPago
IF EXISTS (SELECT n.ID FROM NominaD n WITH (NOLOCK) JOIN CFDINominaConcepto co WITH (NOLOCK) ON n.Concepto = co.Concepto
WHERE n.Personal = @Personal  AND n.ID = @ID AND co.EsValesDespensa = 1)
UPDATE CFDINominaRecibo WITH (ROWLOCK) SET FormaPagoVales = '08' WHERE  ID = @ID AND Personal = @Personal
IF @NominaEditarFechaPago = 1
BEGIN
IF EXISTS(SELECT ID FROM CFDINominaDatosMov WHERE Estacion  = @Estacion AND ID = @ID AND NULLIF(FechaPago,'') IS NOT NULL)
UPDATE CFDINominaREcibo WITH (ROWLOCK) SET FechaPago = m.FechaPago FROM CFDINominaREcibo r
JOIN CFDINominaDatosMov m WITH (NOLOCK) ON r.ID = m.ID
WHERE m.Estacion = @Estacion AND m.ID = @ID
END
RETURN
END

