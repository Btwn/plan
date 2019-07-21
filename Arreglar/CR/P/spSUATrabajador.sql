SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spSUATrabajador
@EMPRESA  VARCHAR(20),
@FECHAD   DATETIME,
@FECHAA   DATETIME

AS BEGIN
SELECT
PersonalPropValor.Valor RegistroPatronal,
SucursalTrabajo,
Registro3             IMSS,
Registro2             RFC,
Registro              CURP,
ApellidoPaterno+'$'+ApellidoMaterno+'$'+Personal.Nombre Nombre,
TipoTrabajador = CASE TipoContrato
WHEN 'Construccion' THEN '3'
WHEN 'Eventual'     THEN '2'
ELSE '1'
END,
Jornada = Case Jornada WHEN 'Horario Completo' THEN '0' END,
Right('0'+ltrim(DATEPART(dd,FechaAlta)),2)+right('0'+ltrim(DATEPART(mm,FechaAlta)),2)+LTRIM(DATEPART(yyyy,FechaAlta)) FechaAlta,
SDI * 100 SDI,
Personal
FROM
Personal JOIN Sucursal ON Personal.SucursalTrabajo=Sucursal.Sucursal JOIN
PersonalPropValor ON Sucursal.Sucursal=PersonalPropValor.Cuenta
WHERE
Personal.Estatus = 'ALTA' AND
Personal.Empresa = @EMPRESA AND
PersonalPropValor.Propiedad = 'Registro Patronal' AND
PersonalPropValor.Cuenta = Personal.SucursalTrabajo AND
Sucursal.Sucursal = Personal.SucursalTrabajo AND
Personal.FechaAntiguedad BETWEEN @FECHAD AND @FECHAA
END
/*
EXEC    spSUATrabajador  'INT', '01/01/2014' ,'30/09/2014'
*/

