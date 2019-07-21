SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInfoGeneralReciboNomina
@Origen			varchar(max),
@Personal		varchar(20)
AS BEGIN
DECLARE @Empresa		VARCHAR(5)
SELECT @Empresa = Empresa FROM Personal WITH(NOLOCK) WHERE Personal = @Personal
DECLARE
@RfcEmpresa		VARCHAR(255),	
@NombreEmpresa	VARCHAR(255),	
@Direccion		VARCHAR(255)	
SELECT @RfcEmpresa    = ISNULL(RFC,''),
@NombreEmpresa = ISNULL(Nombre,''),
@Direccion     = ISNULL(Direccion,'') + ' ' + ISNULL(DireccionNumero,'') + ' ' + ISNULL(DireccionNumeroInt,'') + ' ' + ISNULL(Colonia,'') + ' ' + ISNULL(Poblacion,'') + ' ' + ISNULL(CodigoPostal,'')
FROM Empresa
WITH(NOLOCK) WHERE Empresa = @Empresa
ORDER BY RFC, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, Colonia, Poblacion, CodigoPostal
DECLARE
@NombreEmpleado	VARCHAR(255),	
@RfcEmpleado	VARCHAR(255),	
@CurpEmpleado	VARCHAR(255),	
@NssEmpleado	VARCHAR(255)	
SELECT @NombreEmpleado = ISNULL(Nombre,'') + ' ' + ISNULL(ApellidoPaterno,'') + ' ' + isnull(ApellidoMaterno,''),
@RfcEmpleado    = ISNULL(Registro2,''),
@CurpEmpleado   = ISNULL(Registro,''),
@NssEmpleado    = ISNULL(Registro3,'')
FROM Personal
WITH(NOLOCK) WHERE Personal = ISNULL(@Personal,'')
GROUP BY Nombre, ApellidoPaterno, ApellidoMaterno, Registro2, Registro, Registro3
DECLARE @Percepcion    MONEY
SELECT @Percepcion = SUM(Importe)
FROM NominaD ND
 WITH(NOLOCK) JOIN Nomina N  WITH(NOLOCK) ON N.ID = ND.ID
WHERE ND.Movimiento = 'Percepcion'
AND N.Mov         = 'Nomina'
AND ND.Personal   = ISNULL(@Personal,'')
AND N.id          = @Origen
AND N.Estatus     = 'CONCLUIDO'
DECLARE @Deducciones    MONEY
SELECT @Deducciones = SUM(Importe)
FROM NominaD ND
 WITH(NOLOCK) JOIN Nomina N  WITH(NOLOCK) ON N.ID = ND.ID
WHERE ND.Movimiento = 'Deduccion'
AND N.Mov         = 'Nomina'
AND ND.Personal   = ISNULL(@Personal,'')
AND N.id          = @Origen
AND N.Estatus     = 'CONCLUIDO'
SELECT ISNULL(NP.RegistroPatronal,'') as RegistroPatronal,
NP.Personal as NumeroEmpleado,
ISNULL(P.Departamento,'') as Departamento,
ISNULL(P.Puesto,'') as Puesto,
ISNULL(P.TipoContrato,'') as TipoContrato,
ISNULL(P.Jornada,'') as TipoJornada,
dbo.fnCalculaAntiguedad(P.FechaAntiguedad,GETDATE()) as Antiguedad,
ISNULL(CONVERT(VARCHAR(10),P.FechaAntiguedad,105),'') as InicioRelacionLaboral,
ISNULL(P.PeriodoTipo,'') PeriodoPago,
dbo.fnFormatoMonedaDec(CONVERT(DECIMAL(30,10),P.SDI),2) as SDI,
ISNULL(CONVERT(VARCHAR(10),N.FechaEmision,105),'') as FechaPago,
ISNULL(CONVERT(VARCHAR(10),N.FechaD,105),'') as FechaInicialPago,
ISNULL(CONVERT(VARCHAR(10),N.FechaA,105),'') as FechaFinalPago,
ISNULL(P.PersonalSucursal,'') as Banco,
CONVERT(DECIMAL(30,10),ND.importe) as NetoPagar,
@RfcEmpresa as RfcEmpresa,
@NombreEmpresa as NombreEmpresa,
@Direccion as DireccionEmpresa,
@NombreEmpleado as NombreEmpleado,
@RfcEmpleado as RfcEmpleado,
@CurpEmpleado as CurpEmpleado,
@NssEmpleado as NssEmpleado,
@Percepcion as TotalPercepciones,
@Deducciones as TotalDeducciones
FROM Personal P
 WITH(NOLOCK) JOIN NominaD ND  WITH(NOLOCK) ON ND.Personal = P.Personal
JOIN Nomina N  WITH(NOLOCK) ON N.ID = ND.ID
JOIN NominaPersonal NP  WITH(NOLOCK) ON NP.Personal = ND.Personal AND NP.ID = N.ID
JOIN CFDNomina CFD  WITH(NOLOCK) ON NP.ID = CFD.ModuloID AND NP.Personal = CFD.Personal
WHERE NP.Personal = ISNULL(@Personal,'')
AND NP.ID = @Origen
AND ND.Concepto = 'Nomina'
GROUP BY NP.RegistroPatronal, NP.Personal, P.Departamento, P.Puesto, P.TipoContrato, P.Jornada, P.FechaAntiguedad, P.PeriodoTipo, P.SDI, N.FechaEmision,
N.FechaD, N.FechaA, P.PersonalSucursal, ND.importe
ORDER BY CONVERT(DATETIME,N.FechaD) DESC
RETURN
END

