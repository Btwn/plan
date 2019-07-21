SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgPersonalPerfil ON dbo.Personal

FOR INSERT, UPDATE, DELETE
AS
BEGIN
DECLARE
@ClaveN		varchar(10),
@ClaveA		varchar(10),
@EsAgente		bit,
@EsRecurso		bit,
@EsWeb			bit,
@Mensaje		varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
IF UPDATE(Personal) OR UPDATE(Nombre) OR UPDATE(Direccion) OR UPDATE(Delegacion) OR UPDATE(Colonia)
OR UPDATE(ApellidoPaterno) OR UPDATE(ApellidoMaterno)
OR UPDATE(Poblacion) OR UPDATE(Estado) OR UPDATE(Pais) OR UPDATE(ZonaEconomica) OR UPDATE(CodigoPostal)
OR UPDATE(Telefono) OR UPDATE(EsRecurso) OR UPDATE(EsAgente) OR UPDATE(eMail) OR UPDATE(EsUsuarioWeb)
BEGIN
SELECT @ClaveN = Personal, @EsRecurso = EsRecurso, @EsAgente = EsAgente, @EsWeb = EsUsuarioWeb FROM Inserted
SELECT @ClaveA = Personal FROM Deleted
IF @ClaveN IS NULL
BEGIN
SELECT @EsRecurso = EsRecurso, @EsAgente = EsAgente FROM Deleted
IF @EsRecurso = 1 DELETE Recurso WHERE Recurso = @ClaveA
IF @EsAgente = 1 DELETE Agente WHERE Agente = @ClaveA
IF @EsWeb = 1 DELETE WebUsuario WHERE UsuarioWeb = @ClaveA
END
ELSE
BEGIN
IF @EsAgente = 1
BEGIN
IF EXISTS (SELECT * FROM Agente WHERE Agente = @ClaveN)
BEGIN
SELECT @Mensaje = 'El Personal Indicado: ' + @ClaveN + ' ya Esta Disponible como un Agente'
RAISERROR(@Mensaje, 16, -1)
RETURN
END
/*
JGD 26Abril2011 Ticket 4443. Se comentan estas lineas, ya que no es correcto el Susutituir la información de un Agente
UPDATE Agente
SET Nombre = i.Nombre + ' ' + i.ApellidoPaterno + ' ' + i.ApellidoMaterno,
Direccion = i.Direccion, Colonia = i.Colonia, Poblacion = i.Poblacion,
Estado = i.Estado, Pais = i.Pais, Zona = i.ZonaEconomica, CodigoPostal = i.CodigoPostal,
Telefonos = i.Telefono, email = i.eMail
FROM Agente a, Inserted i
WHERE a.Agente = @ClaveN
IF @@ROWCOUNT = 0
*/
INSERT Agente (Agente, Nombre, BeneficiarioNombre, Direccion, Colonia, Poblacion, Estado, Pais,
Zona, CodigoPostal, Telefonos, Tipo, Estatus, Alta, eMail)
SELECT Personal, Nombre + ' ' + ApellidoPaterno + ' ' + ApellidoMaterno, Nombre, Direccion,
Colonia, Poblacion, Estado, Pais, ZonaEconomica,
CodigoPostal, Telefono, 'Agente', 'ALTA', GETDATE(), eMail FROM Inserted
END
/*
JGD 26Abril2011 Ticket 4443. Se comentan estas lineas, ya que no es correcto el Eliminar la información de un Agente
ELSE
BEGIN
DELETE FROM Agente
WHERE Agente = @ClaveN
END
*/
IF @EsRecurso = 1
BEGIN
UPDATE Recurso
SET Nombre = i.Nombre + ' ' + i.ApellidoPaterno + ' ' + i.ApellidoMaterno,
Personal = i.Personal, email= i.eMail
FROM Recurso r, Inserted i
WHERE r.Recurso = @ClaveN
IF @@ROWCOUNT = 0
INSERT Recurso (Recurso, Nombre, eMail, Estatus, Personal)
SELECT Personal, Nombre + ' ' + ApellidoPaterno + ' ' + ApellidoMaterno, eMail,
'ALTA', Personal
FROM Inserted
END
ELSE
BEGIN
DELETE FROM Recurso
WHERE Recurso = @ClaveN
END
IF @EsWeb = 1
BEGIN
UPDATE WebUsuario
SET Nombre = i.Nombre + ' ' + i.ApellidoPaterno + ' ' + i.ApellidoMaterno,
email = i.eMail
FROM WebUsuario w, Inserted i
WHERE w.UsuarioWeb = @ClaveN
IF @@ROWCOUNT = 0
INSERT WebUsuario (UsuarioWeb, Nombre, eMail, Contrasena, Estatus, Empresa, Sucursal, Personal,
Agente, Recurso, UEN)
SELECT Personal, Nombre + ' ' + ApellidoPaterno + ' ' + ApellidoMaterno, eMail, 'iportal',
'ALTA', Empresa, SucursalTrabajo, Personal, Personal, Personal, UEN FROM Inserted
END
ELSE
BEGIN
DELETE FROM WebUsuario
WHERE UsuarioWeb = @ClaveN
END
END
END
END

