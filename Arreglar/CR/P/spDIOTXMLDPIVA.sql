SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDIOTXMLDPIVA
@Estacion		int,
@Bandera		int,
@FechaD			datetime,
@FechaA			datetime,
@BanderaOk		int,
@Ok				int

AS
BEGIN
DECLARE
@Xml			as Varchar(max),
@XmlXsd			as xml(DPIVA),
@Totales		as Varchar(max),
@ProvNacional	as Varchar(max),
@ProvExtranjero	as Varchar(max),
@ProvGlobal		as Varchar(max),
@Version		as Varchar(4),
@Ejercicio		as int,
@TipoPeriodo	varchar(2),
@Periodo		varchar(2),
@DPIVA			as bit,
@TipoDec		as int,
@FolioAnt		as varchar(14),
@FechPresAnt	as varchar(10),
@Empresa		as varchar(5)
SELECT @Empresa = Empresa FROM DIOTD WHERE EstacionTrabajo = @Estacion
IF @Bandera = 1
BEGIN
DELETE FROM DIOTParamXML WHERE Estacion = @Estacion
INSERT INTO DIOTParamXML(Estacion, Ejercicio, TipoPeriodo, Periodo)
SELECT @Estacion, DATEPART(YEAR,CAST(@FechaD AS DATETIME)),ClavePeriodicidad, ClavePeriodo
FROM DIOTCatPeriodo
WHERE CAST(@FechaD AS DATETIME) >= CAST((FechaInicio+CAST(DATEPART(YEAR,CAST(@FechaD AS DATETIME)) AS VARCHAR(10))) AS DATETIME)
AND CAST(@FechaA AS DATETIME) <= CAST((FechaFin+CAST(DATEPART(YEAR,CAST(@FechaA AS DATETIME)) AS VARCHAR(10))) AS DATETIME)
AND ClavePeriodicidad = CASE DATEDIFF(mm,CAST(@FechaD AS DATETIME), CAST(@FechaA AS DATETIME))
WHEN 0 THEN '01'
WHEN 1 THEN '02'
WHEN 2 THEN '03'
WHEN 3 THEN '04'
WHEN 4 THEN '05'
WHEN 6 THEN '06'
ELSE '06'
END
RETURN
END
SELECT @Version = '1.0',
@Ejercicio = Ejercicio,
@TipoPeriodo = TipoPeriodo,
@Periodo = Periodo,
@DPIVA = DPIVA,
@TipoDec = CASE TipoDec WHEN 1 THEN 2 ELSE 1 END,
@FolioAnt = FolioAnt,
@FechPresAnt = REPLACE(CONVERT(VARCHAR(10),FechaAnt,102),'.','-')
FROM DIOTParamXML
WHERE Estacion = @Estacion
/*********************************     VALIDACIONES     ******************************************/
DECLARE @Mensaje TABLE(Mensaje varchar(255))
IF EXISTS(SELECT * FROM DIOTD WHERE ISNULL(RFC,'') = '' AND EstacionTrabajo = @Estacion) AND @Ok = 0
BEGIN
INSERT INTO @Mensaje(Mensaje) VALUES('Existen errores en la información')
INSERT INTO @Mensaje(Mensaje)
SELECT TOP 10 'El Proveedor: '+Proveedor+' No tiene RFC'
FROM DIOTD
WHERE ISNULL(RFC,'') = ''
AND EstacionTrabajo = @Estacion
AND TipoTercero = 'Nacional'
EXCEPT
SELECT Mensaje FROM @Mensaje
SET @Ok = 1
END
IF NOT EXISTS(SELECT * FROM DIOTD A JOIN DIOTProvTipoOperacion B ON A.Proveedor = B.Proveedor) AND @Ok = 0
BEGIN
INSERT INTO @Mensaje(Mensaje)
SELECT 'Falta configurar el Tipo de Operación de los proveedores'
SET @Ok = 1
END
IF EXISTS(SELECT * FROM DIOTD A LEFT JOIN DIOTProvTipoOperacion B ON A.Proveedor = B.Proveedor WHERE B.Proveedor IS NULL) AND @Ok = 0
BEGIN
INSERT INTO @Mensaje(Mensaje)
SELECT TOP 5 'Falta configurar el Tipo de Operación del proveedor: ' +A.Proveedor
FROM DIOTD A
LEFT JOIN DIOTProvTipoOperacion B
ON A.Proveedor = B.Proveedor
WHERE B.Proveedor IS NULL
EXCEPT
SELECT Mensaje FROM @Mensaje
SET @Ok = 1
END
/*************************************************************************************************/
IF @DPIVA = 1 AND @BanderaOk = 1 AND @Ok = 0
BEGIN
SELECT @ProvNacional = CAST((
SELECT	CASE B.TipoOperacion WHEN 'Otros' THEN '85'
WHEN 'Arrendamiento Inmuebles' THEN '06'
WHEN 'Prestacion Servicios' THEN '03'
ELSE ''
END								as "@TipoOperac",
A.RFC							as "@RFCProv",
CAST(SUM(CASE A.TipoOperacion WHEN 1 THEN ((A.Importe+A.IVA)/A.DineroImporte)*A.DineroImporte
ELSE 0
END) AS MONEY)		as "@ValActPagTas15o16IVA",
0								as "@ValActPagTas15IVA",
CAST(SUM(CASE A.TipoOperacion WHEN 1 THEN (A.IVA/A.DineroImporte)*A.DineroImporte
ELSE 0
END) AS MONEY)		as "@MonIVAPagNoAcrTas15o16",
0.0								as "@ValActPagTas10u11IVA",
0.0								as "@ValActPagTas10IVA",
0.0								as "@MonIVAPagNoAcrTas10u11",
CAST(SUM(CASE A.TipoOperacion WHEN 4 THEN ((A.Importe+A.IVA)/A.DineroImporte)*A.DineroImporte
ELSE 0
END) AS MONEY)		as "@ValActPagTas0IVA",
CAST(SUM(CASE A.TipoOperacion WHEN 3 THEN ((A.Importe+A.IVA)/A.DineroImporte)*A.DineroImporte
ELSE 0
END) AS MONEY)		as "@ValActPagNoIVA",
CAST(SUM(CASE A.TipoOperacion WHEN 3 THEN A.Retencion2
ELSE 0
END) AS MONEY)		as "@IVARetCont",
CAST(SUM(CASE A.TipoOperacion WHEN 7 THEN (A.IVA/A.DineroImporte)*A.DineroImporte
ELSE 0
END) AS MONEY)		as "@IVADevDescyBonifComp"
FROM	DIOTD A
JOIN	DIOTProvTipoOperacion B ON A.Proveedor = B.Proveedor
WHERE	A.EstacionTrabajo = @Estacion
AND	A.TipoTercero = 'Nacional'
AND	A.RFC IS NOT NULL
GROUP BY	B.TipoOperacion, A.RFC
FOR XML PATH ('ProvNacional')
) AS VARCHAR(max))
SELECT @ProvExtranjero = CAST((
SELECT	CASE B.TipoOperacion WHEN 'Otros' THEN '85'
WHEN 'Prestacion Servicios' THEN '03'
ELSE ''
END								as "@TipoOperac",
''								as "@RFCProv",
A.ImportadorRegistro			as "@NumIDFiscal",
A.Nombre						as "@NombExtranjero",
C.Clave							as "@PaisResidencia",
A.Nacionalidad					as "@Nacionalidad",
0.0								as "@ValActPagTas15o16IVA",
0.0								as "@MonIVAPagNoAcrTas15o16",
0.0								as "@ValActPagTas10u11IVA",
0.0								as "@ValActPagTas10IVA",
0.0								as "@MonIVAPagNoAcrTas10u11",
CAST(SUM(CASE A.TipoOperacion WHEN 2 THEN (((A.Importe+A.IVA)/A.DineroImporte)*A.DineroImporte)
*((100-PorcentajeDeducible)/100.0)
ELSE 0
END) AS MONEY)		as "@ValActPagImpBySTas15o16IVA",
CAST(SUM(CASE A.TipoOperacion WHEN 2 THEN ((A.IVA/A.DineroImporte)*A.DineroImporte)
*((100-PorcentajeDeducible)/100.0)
ELSE 0
END) AS MONEY)		as "@MonIVAPagNoAcrImpTas15o16",
0.0								as "@ValActPagImpBySTas10u11IVA",
0.0								as "@MonIVAPagNoAcrImpTas10u11",
CAST(SUM(CASE A.TipoOperacion WHEN 3 THEN (((A.Importe+A.IVA)/A.DineroImporte)*A.DineroImporte)
*((100-PorcentajeDeducible)/100.0)
ELSE 0
END) AS MONEY)		as "@ValActPagImpBySNoIVA",
CAST(SUM(CASE A.TipoOperacion WHEN 4 THEN (((A.Importe+A.IVA)/A.DineroImporte)*A.DineroImporte)
*((100-PorcentajeDeducible)/100.0)
ELSE 0
END) AS MONEY)		as "@ValActPagTas0IVA",
0.0								as "@ValActPagNoIVA",
0.0								as "@IVARetCont",
0.0								as "@IVADevDescyBonifComp"
FROM	DIOTD A
JOIN	DIOTProvTipoOperacion B ON A.Proveedor = B.Proveedor
JOIN	DIOTPais C ON A.Pais = C.Pais
WHERE	A.EstacionTrabajo = @Estacion
AND	A.TipoTercero = 'Extranjero'
GROUP BY B.TipoOperacion, A.RFC, A.ImportadorRegistro, A.Nombre, C.Clave, A.Nacionalidad
FOR XML PATH ('ProvExtranjero')
) AS VARCHAR(max))
SELECT @ProvGlobal = CAST((
SELECT	CASE B.TipoOperacion WHEN 'Otros' THEN '85'
WHEN 'Arrendamiento Inmuebles' THEN '06'
WHEN 'Prestacion Servicios' THEN '03'
ELSE ''
END								as "@TipoOperac",
CAST(SUM(CASE A.TipoOperacion WHEN 1 THEN ((A.Importe+A.IVA)/A.DineroImporte)*A.DineroImporte
ELSE 0
END) AS MONEY)		as "@ValActPagTas15o16IVA",
0								as "@ValActPagTas15IVA",
CAST(SUM(CASE A.TipoOperacion WHEN 1 THEN (A.IVA/A.DineroImporte)*A.DineroImporte
ELSE 0
END) AS MONEY)		as "@MonIVAPagNoAcrTas15o16",
0.0								as "@ValActPagTas10u11IVA",
0.0								as "@ValActPagTas10IVA",
0.0								as "@MonIVAPagNoAcrTas10u11",
CAST(SUM(CASE A.TipoOperacion WHEN 2 THEN (((A.Importe+A.IVA)/A.DineroImporte)*A.DineroImporte)
*((100-PorcentajeDeducible)/100.0)
ELSE 0
END) AS MONEY)		as "@ValActPagImpBySTas15o16IVA",
CAST(SUM(CASE A.TipoOperacion WHEN 2 THEN ((A.IVA/A.DineroImporte)*A.DineroImporte)
*((100-PorcentajeDeducible)/100.0)
ELSE 0
END) AS MONEY)		as "@MonIVAPagNoAcrImpTas15o16",
0.0								as "@ValActPagImpBySTas10u11IVA",
0.0								as "@MonIVAPagNoAcrImpTas10u11",
CAST(SUM(CASE A.TipoOperacion WHEN 3 THEN (((A.Importe+A.IVA)/A.DineroImporte)*A.DineroImporte)
*((100-PorcentajeDeducible)/100.0)
ELSE 0
END) AS MONEY)		as "@ValActPagImpBySNoIVA",
CAST(SUM(CASE A.TipoOperacion WHEN 4 THEN ((A.Importe+A.IVA)/A.DineroImporte)*A.DineroImporte
ELSE 0
END) AS MONEY)		as "@ValActPagTas0IVA",
CAST(SUM(CASE A.TipoOperacion WHEN 3 THEN ((A.Importe+A.IVA)/A.DineroImporte)*A.DineroImporte
ELSE 0
END) AS MONEY)		as "@ValActPagNoIVA",
CAST(SUM(CASE A.TipoOperacion WHEN 3 THEN A.Retencion2
ELSE 0
END) AS MONEY)		as "@IVARetCont",
CAST(SUM(CASE A.TipoOperacion WHEN 7 THEN (A.IVA/A.DineroImporte)*A.DineroImporte
ELSE 0
END) AS MONEY)		as "@IVADevDescyBonifComp"
FROM	DIOTD A
JOIN	DIOTProvTipoOperacion B ON A.Proveedor = B.Proveedor
WHERE	A.EstacionTrabajo = @Estacion
AND	A.TipoTercero NOT IN ('Nacional','Extranjero')
GROUP BY B.TipoOperacion, A.RFC
FOR XML PATH ('ProvNacional')
) AS VARCHAR(max))
SELECT @Totales = CAST((
SELECT	COUNT(*) as "@TotOperac",
CAST(SUM(CASE A.TipoOperacion WHEN 1 THEN ((A.Importe+A.IVA)/A.DineroImporte)*A.DineroImporte
ELSE 0
END) AS MONEY)		as "@TotActPagTas15o16IVA",
0								as "@TotActPagTas15IVA",
CAST(SUM(CASE A.TipoOperacion WHEN 1 THEN (A.IVA/A.DineroImporte)*A.DineroImporte
ELSE 0
END) AS MONEY)		as "@TotIVAPagNoAcrTas15o16",
0.0								as "@TotActPagTas10u11IVA",
0.0								as "@TotActPagTas10IVA",
0.0								as "@TotIVAPagNoAcrTas10u11",
CAST(SUM(CASE A.TipoOperacion WHEN 2 THEN (((A.Importe+A.IVA)/A.DineroImporte)*A.DineroImporte)
*((100-PorcentajeDeducible)/100.0)
ELSE 0
END) AS MONEY)		as "@TotActPagImpBySTas15o16IVA",
CAST(SUM(CASE A.TipoOperacion WHEN 2 THEN ((A.IVA/A.DineroImporte)*A.DineroImporte)
*((100-PorcentajeDeducible)/100.0)
ELSE 0
END) AS MONEY)		as "@TotIVAPagNoAcrImpTas15o16",
0.0								as "@TotActPagImpBySTas10u11IVA",
0.0								as "@TotIVAPagNoAcrImpTas10u11",
CAST(SUM(CASE A.TipoOperacion WHEN 3 THEN ((A.DineroImporte/(A.Importe+A.IVA))*A.Importe)
*((100-PorcentajeDeducible)/100.0)
ELSE 0
END) AS MONEY)		as "@TotActPagImpBySNoPagIVA",
CAST(SUM(CASE A.TipoOperacion WHEN 4 THEN (A.DineroImporte/(A.Importe+A.IVA))*A.Importe
ELSE 0
END) AS MONEY)		as "@TotDemActPagTas0IVA",
CAST(SUM(CASE A.TipoOperacion WHEN 3 THEN (A.DineroImporte/(A.Importe+A.IVA))*A.Importe
ELSE 0
END) AS MONEY)		as "@TotActPagNoPagIVA",
CAST(SUM(CASE A.TipoOperacion WHEN 3 THEN A.Retencion2
ELSE 0
END) AS MONEY)		as "@TotIVARetCont",
CAST(SUM(CASE A.TipoOperacion WHEN 7 THEN (A.IVA/A.DineroImporte)*A.DineroImporte
ELSE 0
END) AS MONEY)		as "@TotIVADevDescyBonifComp",
CAST(SUM(CASE A.TipoOperacion WHEN 1 THEN (A.IVA/A.DineroImporte)*A.DineroImporte
ELSE 0
END) AS MONEY)		as "@TotIVATraslContExcImpByS",
0.0								as "@TotIVAPagImpByS"
FROM	DIOTD A
JOIN	DIOTProvTipoOperacion B ON A.Proveedor = B.Proveedor
WHERE	A.EstacionTrabajo = @Estacion
FOR XML PATH ('Totales')
) AS VARCHAR(max))
END
IF @DPIVA = 0 AND @Ok = 0
BEGIN
SELECT @Totales = CAST((SELECT	 0   as "@TotOperac",
0.0	 as "@TotActPagTas15o16IVA",
0.0  as "@TotActPagTas15IVA",
0.0  as "@TotIVAPagNoAcrTas15o16",
0.0	 as "@TotActPagTas10u11IVA",
0.0	 as "@TotActPagTas10IVA",
0.0  as "@TotIVAPagNoAcrTas10u11",
0.0  as "@TotActPagImpBySTas15o16IVA",
0.0  as "@TotIVAPagNoAcrImpTas15o16",
0.0  as "@TotActPagImpBySTas10u11IVA",
0.0  as "@TotIVAPagNoAcrImpTas10u11",
0.0  as "@TotActPagImpBySNoPagIVA",
0.0  as "@TotDemActPagTas0IVA",
0.0  as "@TotActPagNoPagIVA",
0.0  as "@TotIVARetCont",
0.0  as "@TotIVADevDescyBonifComp",
0.0  as "@TotIVATraslContExcImpByS",
0.0  as "@TotIVAPagImpByS"
FOR XML PATH ('Totales')
) AS VARCHAR(max))
END
IF @TipoDec = 2
BEGIN
SELECT @Xml = CAST(( SELECT	@Version		as "@Version",
@Ejercicio		as "@Ejercicio",
@TipoPeriodo	as "@TipoPerid", 
@Periodo		as "@Periodo",	 
@DPIVA			as "@DPIVA",
@TipoDec		as "@TipoDec",
@FolioAnt		as "@FolioAnt",  
@FechPresAnt	as "@FechPresAnt",
CAST(@Totales as Xml),
CAST(@ProvNacional as XML),
CAST(@ProvExtranjero as XML),
CAST(@ProvGlobal as XML)
FOR XML PATH ('DPIVA')) as Varchar(max))
END
IF @TipoDec = 1
BEGIN
SELECT @Xml = CAST((SELECT	@Version		as "@Version",
@Ejercicio		as "@Ejercicio",
@TipoPeriodo	as "@TipoPerid", 
@Periodo		as "@Periodo",	 
@DPIVA			as "@DPIVA",
@TipoDec		as "@TipoDec",
CAST(@Totales as Xml),
CAST(@ProvNacional as XML),
CAST(@ProvExtranjero as XML),
CAST(@ProvGlobal as XML)
FOR XML PATH ('DPIVA')) as Varchar(max))
END
SELECT @Xml = '<?xml version="1.0" encoding="UTF-8"?>
<DD:DoctoDigital xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:DD="http://esquemas.clouda.sat.gob.mx/archivos/DoctosDigitales/1"
xmlns:DPIVA="http://esquemas.clouda.sat.gob.mx/archivos/DoctosDigitales/TipoDPIVA/1"
xsi:schemaLocation="http://esquemas.clouda.sat.gob.mx/archivos/DoctosDigitales/1
http://esquemas.clouda.sat.gob.mx/archivos/DoctosDigitales/1/DoctoDigital.xsd
http://esquemas.clouda.sat.gob.mx/archivos/DoctosDigitales/TipoDPIVA/1
http://esquemas.clouda.sat.gob.mx/archivos/DoctosDigitales/TipoDPIVA/1/DPIVA.xsd"> <DD:TipoDoctoDigital>'+@Xml
SELECT @Xml = REPLACE(@Xml,'<DPIVA ','<DPIVA:DPIVA ')
SELECT @Xml = REPLACE(@Xml,'/DPIVA>', '/DPIVA:DPIVA></DD:TipoDoctoDigital></DD:DoctoDigital>')
IF @BanderaOk = 0
BEGIN
SELECT CAST(@Ok AS VARCHAR(1))
RETURN
END
IF @BanderaOk = 1
BEGIN
IF @Ok = 1
BEGIN
SELECT Mensaje FROM @Mensaje
END
IF @Ok = 0
BEGIN
BEGIN TRY
INSERT DIOTHistArchivos(Empresa, RFC, Ejercicio, TipoPeriodo, Periodo, TipoDeclaracion, FechaEmision)
SELECT Empresa, RFC, @Ejercicio, @TipoPeriodo, @Periodo, CASE @TipoDec WHEN 1 THEN 'N' ELSE 'C' END, GETDATE()
FROM Empresa
WHERE	Empresa = @Empresa
EXCEPT
SELECT Empresa, RFC, Ejercicio, TipoPeriodo, Periodo, TipoDeclaracion, FechaEmision
FROM DIOTHistArchivos
SELECT @Xml
END TRY
BEGIN CATCH
RETURN @@ERROR
END CATCH
END
END
END

