SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgNominaPersonalCFDI ON Nomina
FOR UPDATE
AS
BEGIN
DECLARE @ID				int,
@IDAnt			int,
@Ok				int,
@OkRef			varchar(255),
@Mov				varchar(20),
@MovID			varchar(20),
@Personal			varchar(10),
@PersonalAnt		varchar(10),
@SucursalTrabajo	int,
@Categoria		varchar(50),
@Puesto			varchar(50),
@Empresa			varchar(5),
@Valor			varchar(50),
@Version			int
SELECT @IDAnt = 0
WHILE(1=1)
BEGIN
SELECT @ID = MIN(i.ID)
FROM Inserted i
JOIN Deleted d ON i.ID = d.ID
JOIN MovTipo ON i.Mov = MovTipo.Mov AND MovTipo.Modulo = 'NOM' AND MovTipo.Clave IN('NOM.N', 'NOM.NA', 'NOM.NE', 'NOM.NC')
WHERE i.Estatus =  'CONCLUIDO'
AND d.Estatus <> 'CONCLUIDO'
AND i.ID > @IDAnt
IF @ID IS NULL BREAK
SELECT @IDAnt = @ID
SELECT @Empresa = Empresa FROM Nomina WHERE ID = @ID
SELECT @PersonalAnt = ''
WHILE(1=1)
BEGIN
SELECT @Personal = MIN(Personal)
FROM NominaD
WHERE NominaD.ID =  @ID
AND NominaD.Personal > @PersonalAnt
IF @Personal IS NULL BREAK
SELECT @PersonalAnt = @Personal
SELECT @SucursalTrabajo = SucursalTrabajo, @Categoria = Categoria, @Puesto = Puesto
FROM Personal
JOIN NominaD ON NominaD.Personal=Personal.Personal
WHERE NominaD.ID =  @ID
AND Personal.Personal = @Personal
SELECT @Valor = NULL
EXEC spCFDIPersonalPropValor @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'REGISTRO PATRONAL', @Valor OUTPUT
UPDATE NominaPersonal
SET RegistroPatronal = @Valor,
Departamento  = p.Departamento,
Puesto   = p.Puesto,
TipoContrato  = p.TipoContrato,
Jornada   = p.Jornada,
SDIEstaNomina = p.SDI
FROM NominaPersonal n
JOIN Personal p ON n.Personal = p.Personal
WHERE n.ID = @ID
AND n.Personal = @Personal
END
END
RETURN
END

