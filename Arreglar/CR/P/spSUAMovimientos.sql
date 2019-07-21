SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSUAMovimientos
@EMPRESA		CHAR(10),
@FechaD			DATETIME,
@FechaA			DATETIME

AS BEGIN
CREATE TABLE #SUAMovimiento(
RegistroPatronal CHAR(11),
IMSS CHAR(11),
TipoMovimiento CHAR(2),
FechaMovimiento CHAR(8),
FolioIncapacidad CHAR(8),
Dias CHAR(2),
SDI MONEY)
INSERT INTO #SUAMovimiento (RegistroPatronal,Imss,TipoMovimiento,FechaMovimiento,SDI,DIAS,FolioIncapacidad)
SELECT DISTINCT
CAST(RIGHT(ISNULL(REPLACE(PersonalPropValor.Valor,'-',''),''),11) AS CHAR(11)) RegistroPatronal,
CAST(RIGHT(ISNULL(Registro3,''),11) AS CHAR(11))               IMSS,
TipoMovimiento = CASE A.Mov
WHEN 'Modificaciones'		THEN '07'
WHEN 'Reingresos'			THEN '08'
WHEN 'Bajas'				THEN '02'
WHEN 'Alta Reg. Patronal'	THEN '08'
WHEN 'Baja Reg. Patronal'	THEN '02'
END,
RIGHT('0'+LTRIM(DATEPART(dd,a.FechaEmision)),2)+RIGHT('0'+LTRIM(DATEPART(mm,a.FechaEmision)),2)+LTRIM(DATEPART(yyyy,a.FechaEmision)) FechaEmision,
CEILING(ISNULL(B.SDI,0)*100) SDI, '00',''
FROM
RH A,
RHD B,
Personal,
PersonalPropValor
WHERE
A.FechaEmision BETWEEN  @FechaD AND @FechaA AND 
B.Personal=Personal.Personal  AND
A.EMPRESA= @Empresa AND
A.ID=B.ID AND
A.Estatus='Concluido' AND
A.Mov IN('Reingresos','Modificaciones','Bajas','Alta Reg. Patronal','Baja Reg. Patronal') AND
PersonalPropValor.Propiedad ='Registro Patronal' AND
A.Empresa = Personal.Empresa AND
A.Sucursal= Personal.SucursalTrabajo AND
PersonalPropValor.Cuenta = Personal.Personal
ORDER BY FechaEmision
INSERT INTO #SUAMovimiento (RegistroPatronal,Imss,TipoMovimiento,FechaMovimiento,dias,FolioIncapacidad,SDI)
SELECT
CAST(RIGHT(ISNULL(REPLACE(PersonalPropValor.Valor,'-',''),''),11) AS CHAR(11)) RegistroPatronal,
CAST(RIGHT(ISNULL(Registro3,''),11) AS CHAR(11)) IMSS,
TipoMovimiento = CASE Nomina.Mov
WHEN 'Incapacidades'	THEN '12'
WHEN 'Faltas'			THEN '11'
WHEN 'Permiso Sin Goce' THEN '11'
END,
RIGHT('0'+LTRIM(DATEPART(dd,NominaD.FechaD)),2)+RIGHT('0'+LTRIM(DATEPART(mm,NominaD.FechaD)),2)+LTRIM(DATEPART(yyyy,NominaD.FechaD)) FECHAEMISION,
LEFT('0'+LTRIM(RIGHT(Convert(CHAR, ISNULL(NominaD.Cantidad,0)),20)),2),
ISNULL(NominaD.Referencia,''),0
FROM
Nomina,
NominaD,
Personal,
PersonalPropValor,
Sucursal
WHERE
Nomina.FechaEmision BETWEEN @FechaD AND @FechaA AND
NominaD.id=Nomina.id AND
Nomina.EMPRESA= @Empresa AND 
Mov in('Incapacidades','Faltas','Permiso Sin Goce') AND
Nomina.Estatus in('PROCESAR','CONCLUIDO') AND
NominaD.Personal = Personal.Personal AND
PersonalPropValor.Propiedad ='Registro Patronal' AND
Sucursal.Sucursal=Personal.SucursalTrabajo
ORDER BY FechaEmision
SELECT
RegistroPatronal,
IMSS,
TipoMovimiento,
FechaMovimiento,
FolioIncapacidad,
Dias,
SDI
FROM
#SUAMovimiento
END

