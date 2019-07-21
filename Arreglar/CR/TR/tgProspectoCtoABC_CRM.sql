SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgProspectoCtoABC_CRM ON ProspectoCto

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@ProspectoI  		varchar(10),
@ProspectoD		varchar(10),
@CRMII			varchar(36),
@CRMID			varchar(36),
@Datos			varchar(max),
@Usuario		varchar(10),
@Contrasena		varchar(32),
@Ok				int,
@OkRef			varchar(255),
@IDIS			int,
@Accion			varchar(20)
IF dbo.fnEstaSincronizandoCRM() = 1
RETURN
SELECT
@Usuario    = Usuario,
@Contrasena = Contrasena
FROM CfgCRM
SELECT @ProspectoI = Prospecto, @CRMII = CRMID FROM Inserted
SELECT @ProspectoD = Prospecto, @CRMID = CRMID FROM Deleted
IF (@CRMII IS NULL AND @CRMID IS NULL) OR (NOT EXISTS(SELECT Prospecto FROM Prospecto WHERE Prospecto = ISNULL(@ProspectoI,@ProspectoD) AND Tipo = 'Cliente'))
RETURN
IF @CRMII IS NOT NULL AND @CRMID IS NULL
SELECT @Accion = 'INSERT'
ELSE
IF @CRMII IS NOT NULL AND @CRMID IS NOT NULL
SELECT @Accion = 'UPDATE'
ELSE
IF @CRMII IS NULL AND @CRMID IS NOT NULL
SELECT @Accion = 'DELETE'
ELSE
RETURN
SELECT @Datos = '<Intelisis Sistema="IntelisisCRM" Contenido="Solicitud" Referencia="IntelisisCRM.CRM" SubReferencia="" Version="1.0">' + '<Solicitud>' + '<' + @Accion + '>'
IF @ProspectoD IS NULL OR @ProspectoD = @ProspectoI
SELECT @Datos = @Datos + (SELECT ApellidoMaterno, ApellidoPaterno, Atencion, Cargo, CRMID, eMail, Extencion, Fax, FechaNacimiento, Grupo, ID, Nombre, PedirTono, Prospecto, Sexo, Telefonos, Tipo, Tratamiento, Usuario, AccountId FROM Inserted ProspectoCto FOR XML AUTO)
ELSE
SELECT @Datos = @Datos + (SELECT ApellidoMaterno, ApellidoPaterno,  Atencion, Cargo, CRMID, eMail, Extencion, Fax, FechaNacimiento, Grupo, ID, Nombre, PedirTono, Prospecto, Sexo, Telefonos, Tipo, Tratamiento, Usuario, AccountId FROM Deleted ProspectoCto FOR XML AUTO)
SELECT @Datos = @Datos + '</' + @Accion + '></Solicitud></Intelisis>'
DELETE CteCto WHERE Cliente = ISNULL(@ProspectoI, @ProspectoD)
INSERT INTO CteCto             (Cliente, Nombre, Atencion, Tratamiento, Cargo, Grupo, FechaNacimiento, Telefonos, Extencion, eMail, Fax, PedirTono, ApellidoPaterno, ApellidoMaterno, Tipo, Sexo, Usuario)
SELECT ISNULL(@ProspectoI, @ProspectoD), Nombre, Atencion, Tratamiento, Cargo, Grupo, FechaNacimiento, Telefonos, Extencion, eMail, Fax, PedirTono, ApellidoPaterno, ApellidoMaterno, Tipo, Sexo, Usuario
FROM inserted
EXEC spIntelisisService @Usuario, @Contrasena, @Datos, NULL, @Ok OUTPUT, @OkRef OUTPUT, 1, 0, @IDIS OUTPUT
RETURN
END

