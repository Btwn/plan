SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRepReciboNomina
@Estacion		int

AS BEGIN
DECLARE
@Empresa			char(5),
@Mov				varchar(20),
@MovID				varchar(20),
@PersonaEspecifica		varchar(10),
@FormaPago			varchar(50),
@Departamento			varchar(50),
@Puesto				varchar(50),
@Categoria			varchar(50),
@Grupo				varchar(50),
@Personal			varchar(10),
@ID				int,
@Sueldo				money,
@OtrasPercepciones		money,
@ISR				money,
@IMSS				money,
@OtrasDeducciones		money,
@TotalEstadisticos		money,
@TotalPercepciones		money,
@TotalDeducciones		money,
@PrimaVacacional		money,
@Vales				money,
@FondoAhorro			money,
@DiasTrabajados			float
SELECT @Empresa = rp.InfoEmpresa,
@Mov = rp.InfoMov,
@MovID = rp.InfoMovID,
@PersonaEspecifica = rp.InfoPersonal,
@FormaPago = rp.InfoFormaPago,
@Departamento = rp.InfoDepartamento,
@Puesto = rp.InfoPuesto,
@Categoria = rp.InfoCatPersonal,
@Grupo = rp.InfoGrupoPersonal
FROM RepParam rp
WHERE rp.Estacion = @Estacion
IF @PersonaEspecifica IN ('','NULL','(Todos)','(Todas)') SELECT @PersonaEspecifica = NULL
IF @FormaPago IN ('','NULL','(Todos)','(Todas)') SELECT @FormaPago = NULL
IF @Departamento IN ('','NULL','(Todos)','(Todas)') SELECT @Departamento = NULL
IF @Puesto IN ('','NULL','(Todos)','(Todas)') SELECT @Puesto = NULL
IF @Categoria IN ('','NULL','(Todos)','(Todas)') SELECT @Categoria = NULL
IF @Grupo IN ('','NULL','(Todos)','(Todas)') SELECT @Grupo = NULL
CREATE TABLE #Nomina(
ID				int,
Personal			varchar(10)  COLLATE Database_Default NULL,
DiasTrabajados			float,
Sueldo				money,
PrimaVacacional			money,
Vales				money,
OtrasPercepciones		money,
TotalPercepciones		money,
IMSS				money,
ISR				money,
FondoAhorro			money,
OtrasDeducciones		money,
TotalDeducciones		money,
NetoPagado			money)
INSERT INTO #Nomina (ID, Personal)
SELECT n.ID,
d.Personal
FROM Nomina n
JOIN NominaD d ON n.ID = d.ID
JOIN MovTipo mt ON mt.Modulo = 'NOM'
AND mt.Mov = n.Mov
JOIN Personal p ON d.Personal = p.Personal
WHERE n.Estatus = 'CONCLUIDO'
AND (mt.Clave NOT IN ('NOM.N', 'NOM.NA', 'NOM.NE', 'NOM.NC') OR d.Movimiento IN ('Estadistica','Percepcion', 'Deduccion'))
AND n.Empresa = @Empresa
AND n.Mov = @Mov
AND n.MovID = @MovID
AND ISNULL(d.Personal, '') = ISNULL(ISNULL(@PersonaEspecifica, d.Personal),'')
AND ISNULL(p.Categoria, '') = ISNULL(ISNULL(@Categoria, p.Categoria),'')
AND ISNULL(p.Grupo, '') = ISNULL(ISNULL(@Grupo, p.Grupo),'')
AND ISNULL(p.Puesto, '') = ISNULL(ISNULL(@Puesto, p.Puesto),'')
AND ISNULL(p.Departamento, '') = ISNULL(ISNULL(@Departamento, p.Departamento),'')
GROUP BY d.Personal, n.ID
DECLARE crNomina CURSOR LOCAL FOR
SELECT ID,
Personal
FROM #Nomina
GROUP BY Personal, ID
OPEN crNomina
FETCH NEXT FROM crNomina INTO @ID, @Personal
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @DiasTrabajados = Cantidad FROM NominaD  WHERE ID = @ID AND Personal = @Personal AND Concepto = 'Sueldo'
SELECT @Sueldo = SUM(Importe) FROM NominaD  WHERE ID = @ID AND Personal = @Personal AND Concepto = 'Sueldo'
SELECT @PrimaVacacional = SUM(Importe) FROM NominaD  WHERE ID = @ID AND Personal = @Personal AND Concepto = 'Prima Vacacional'
SELECT @Vales = SUM(Importe) FROM NominaD  WHERE ID = @ID AND Personal = @Personal AND Concepto = 'Vales Despensa'
SELECT @OtrasPercepciones = SUM(ISNULL(Importe, 0)) FROM NominaD  WHERE ID = @ID AND Personal = @Personal AND Movimiento = 'Percepcion' AND Concepto NOT IN('Sueldo', 'Prima Vacacional','Vales Despensa')
SELECT @TotalPercepciones = ISNULL(@Sueldo, 0) + ISNULL(@PrimaVacacional, 0) + ISNULL(@Vales, 0) + ISNULL(@OtrasPercepciones, 0)
SELECT @ISR = SUM(Importe) FROM NominaD  WHERE ID = @ID AND Personal = @Personal AND Concepto = 'ISR'
SELECT @IMSS = SUM(Importe) FROM NominaD  WHERE ID = @ID AND Personal = @Personal AND Concepto = 'IMSS'
SELECT @FondoAhorro = SUM(Importe) FROM NominaD  WHERE ID = @ID AND Personal = @Personal AND Concepto = 'Fondo Ahorro Compañia'
SELECT @OtrasDeducciones = SUM(ISNULL(Importe, 0)) FROM NominaD  WHERE ID = @ID AND Personal = @Personal AND Movimiento = 'Deduccion' AND Concepto NOT IN ('ISR','IMSS','Fondo Ahorro Compañia')
SELECT @TotalDeducciones = ISNULL(@ISR, 0) + ISNULL(@IMSS, 0) + ISNULL(@FondoAhorro, 0) + ISNULL(@OtrasDeducciones, 0)
UPDATE #Nomina SET DiasTrabajados = @DiasTrabajados,
Sueldo = ISNULL(@Sueldo, 0),
PrimaVacacional = ISNULL(@PrimaVacacional, 0),
Vales = ISNULL(@Vales, 0),
OtrasPercepciones = ISNULL(@OtrasPercepciones, 0),
ISR = ISNULL(@ISR, 0),
IMSS = ISNULL(@IMSS, 0),
FondoAhorro = ISNULL(@FondoAhorro, 0),
OtrasDeducciones = ISNULL(@OtrasDeducciones, 0),
TotalPercepciones = @TotalPercepciones,
TotalDeducciones = @TotalDeducciones,
NetoPagado = ISNULL(@TotalPercepciones, 0) - ISNULL(@TotalDeducciones, 0)
WHERE ID = @ID
AND Personal = @Personal
END
FETCH NEXT FROM crNomina INTO @ID, @Personal
END
CLOSE crNomina
DEALLOCATE crNomina
SELECT n.ID,
Movimiento = n.Mov + ' ' + n.MovID,
nt.Personal,
Nombre = p.ApellidoPaterno + ' ' + p.ApellidoMaterno + ' ' + p.Nombre,
nt.DiasTrabajados,
nt.Sueldo,
nt.PrimaVacacional,
nt.Vales,
nt.OtrasPercepciones,
nt.TotalPercepciones,
nt.NetoPagado,
nt.IMSS,
nt.ISR,
nt.FondoAhorro,
nt.OtrasDeducciones,
nt.TotalDeducciones,
NSS = p.Registro3,
RFC = p.Registro2,
CURP = p.Registro,
Departamento = p.Departamento,
Puesto = p.Puesto,
NombreEmpresa = e.Nombre,
PeriodoPago = n.Observaciones
FROM #Nomina nt
JOIN Nomina n ON nt.ID = n.ID
JOIN Personal p ON nt.Personal = p.Personal
JOIN Empresa e ON n.Empresa = e.Empresa
END

