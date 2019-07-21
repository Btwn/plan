SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC SPSDIVariables
@Mov VARCHAR(25),
@MovID VARCHAR (25)

AS BEGIN
SELECT DISTINCT D.Personal,
'NombreEmpleado'=P.ApellidoPaterno+' '+P.ApellidoMaterno+' '+P.Nombre,
'F.Ingreso'=P.FechaAntiguedad,
'Depto'=P.Departamento,
'Puesto'=P.Puesto,
'IMSS'=P.Registro3,
'R.F.C.'=P.Registro2,
'Antiguedad'=  max (CASE WHEN D.Concepto='Antiguedad' then convert (varchar (10),Cantidad) else '' end),
'SD'= max (CASE WHEN D.Concepto='Sueldo Diario' then convert (varchar (10),importe) else '' end),
'FactInteg'=max (CASE WHEN D.Concepto='Factor de Integracion' then convert (varchar (10),Cantidad) else '' end),
'SDILey'=max (CASE WHEN D.Concepto='Salario Integrado de Ley' then convert (varchar (10),importe) else '' end),
'Acum Imp Bim Var IMSS'=max (CASE WHEN D.Concepto='Acum Importe Bimestral Variable IMSS' then convert (varchar (10),Importe) else '' end),
'NoDiasBim'=max (CASE WHEN D.Concepto='No Dias del Bimestre' then convert (varchar (10),Cantidad) else '' end),
'VariableDiaria'=max (CASE WHEN D.Concepto='Variable Diaria del Bimestre' then convert (varchar (10),importe) else '' end),
'SDIEstimado'= max (CASE WHEN D.Concepto='SDI Estimado' then convert (varchar (10),importe) else '' end),
'SDIAnterior'= max (CASE WHEN D.Concepto='SDI Usado para esta Nómina' then convert (varchar (10),importe) else '' end),
'CambiaSDI'= max (CASE WHEN D.Concepto='Cambia SDI' then convert (varchar (10),Cantidad) else '' end),
'Mes'=N.Periodo,
'AÑO'=N.Ejercicio
FROM NominaD D LEFT OUTER JOIN Nomina N	ON D.ID=N.ID
LEFT OUTER JOIN Personal P ON D.Personal=P.Personal
WHERE MOV=@MOV
AND N.ESTATUS='CONCLUIDO'
AND MOVID=@MOVID
AND D.PERSONAL IS NOT NULL
GROUP BY D.Personal, P.FechaAntiguedad, P.Departamento, P.Puesto, P.SueldoDiario, P.ApellidoPaterno, P.ApellidoMaterno, P.Nombre, P.Registro3, P.Registro2, N.Periodo, N.Ejercicio
ORDER BY D.Personal
END
/*
EXEC SPSDIVariables 'NOMINA','46'
*/

