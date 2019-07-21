SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgProspectoABC_CRM ON Prospecto

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@ProspectoI  		varchar(10),
@ProspectoD			varchar(10),
@CRMII				varchar(36),
@CRMID				varchar(36),
@Datos				varchar(max),
@Usuario			varchar(10),
@Contrasena			varchar(32),
@Ok					int,
@OkRef				varchar(255),
@IDIS				int,
@Accion				varchar(20),
@TipoI				varchar(25),
@TipoD				varchar(25),
@SincronizarCRMI	bit,
@SincronizarCRMD	bit,
@EstatusI			varchar(15),
@EstatusD			varchar(15)
IF dbo.fnEstaSincronizandoCRM() = 1
RETURN
SELECT
@Usuario    = Usuario,
@Contrasena = Contrasena
FROM CfgCRM
SELECT @ProspectoI = Prospecto, @CRMII = CRMID, @TipoI = Tipo, @SincronizarCRMI = SincronizarCRM, @EstatusI = Estatus FROM Inserted
SELECT @ProspectoD = Prospecto, @CRMID = CRMID, @TipoD = ISNULL(Tipo,@TipoI), @SincronizarCRMD = SincronizarCRM, @EstatusD = Estatus FROM Deleted
IF (@CRMII IS NULL AND @CRMID IS NULL) OR (@TipoI <> 'Contacto' AND @SincronizarCRMI = 0  AND @EstatusI <> 'ALTA')
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
IF @TipoI = @TipoD and @SincronizarCRMI = 1
BEGIN
IF @ProspectoD IS NULL OR @ProspectoD = @ProspectoI
SELECT @Datos = @Datos + (SELECT AccountId, Agente, Alta, ApellidoMaterno, ApellidoPaterno, CargaRID, Categoria, CodigoPostal, Colonia, CRMID, CURP, Delegacion, Direccion, DireccionNumero, DireccionNumeroInt, eMail, EmpresaTipo, EntreCalles, Estado, Estatus, Familia, Fax, Fuente, Grupo, GrupoEmpresarial, InteresadoEn, Nombre, NombreComercial, NombreCompleto, Observaciones, Origen, PaginaWeb, Pais, PedirTono, Plano, Poblacion, Prospecto, ReferidoMail, ReferidoNombre, ReferidoRFC, ReferidoTelefono, RelacionReferencia, RFC, SIC, SincronizarCRM, Situacion, SituacionFecha, SituacionNota, SituacionUsuario, Telefonos, TelefonosLada, TemaCRM, TieneMovimientos, Tipo, UltimoCambio, Usuario, Zona FROM Inserted Contacto FOR XML AUTO)
ELSE
BEGIN
IF @SincronizarCRMI = 1 AND @SincronizarCRMD = 0
SELECT @Datos = ''
ELSE
SELECT @Datos = @Datos + (SELECT AccountId, Agente, Alta, ApellidoMaterno, ApellidoPaterno, CargaRID, Categoria, CodigoPostal, Colonia, CRMID, CURP, Delegacion, Direccion, DireccionNumero, DireccionNumeroInt, eMail, EmpresaTipo, EntreCalles, Estado, Estatus, Familia, Fax, Fuente, Grupo, GrupoEmpresarial, InteresadoEn, Nombre, NombreComercial, NombreCompleto, Observaciones, Origen, PaginaWeb, Pais, PedirTono, Plano, Poblacion, Prospecto, ReferidoMail, ReferidoNombre, ReferidoRFC, ReferidoTelefono, RelacionReferencia, RFC, SIC, SincronizarCRM, Situacion, SituacionFecha, SituacionNota, SituacionUsuario, Telefonos, TelefonosLada, TemaCRM, TieneMovimientos, Tipo, UltimoCambio, Usuario, Zona FROM Deleted Contacto FOR XML AUTO)
END
SELECT @Datos = @Datos + '</' + @Accion + '></Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario, @Contrasena, @Datos, NULL, @Ok OUTPUT, @OkRef OUTPUT, 1, 0, @IDIS OUTPUT
END
ELSE
BEGIN
IF @ProspectoD IS NULL OR @ProspectoD = @ProspectoI
SELECT @Datos = @Datos + (SELECT AccountId, Agente, Alta, ApellidoMaterno, ApellidoPaterno, CargaRID, Categoria, CodigoPostal, Colonia, CRMID, CURP, Delegacion, Direccion, DireccionNumero, DireccionNumeroInt, eMail, EmpresaTipo, EntreCalles, Estado, Estatus, Familia, Fax, Fuente, Grupo, GrupoEmpresarial, InteresadoEn, Nombre, NombreComercial, NombreCompleto, Observaciones, Origen, PaginaWeb, Pais, PedirTono, Plano, Poblacion, Prospecto, ReferidoMail, ReferidoNombre, ReferidoRFC, ReferidoTelefono, RelacionReferencia, RFC, SIC, SincronizarCRM, Situacion, SituacionFecha, SituacionNota, SituacionUsuario, Telefonos, TelefonosLada, TemaCRM, TieneMovimientos, Tipo, UltimoCambio, Usuario, Zona FROM Inserted Contacto FOR XML AUTO)
ELSE
BEGIN
IF @SincronizarCRMI = 1 AND @SincronizarCRMD = 0
SELECT @Datos = ''
ELSE
SELECT @Datos = @Datos + (SELECT AccountId, Agente, Alta, ApellidoMaterno, ApellidoPaterno, CargaRID, Categoria, CodigoPostal, Colonia, CRMID, CURP, Delegacion, Direccion, DireccionNumero, DireccionNumeroInt, eMail, EmpresaTipo, EntreCalles, Estado, Estatus, Familia, Fax, Fuente, Grupo, GrupoEmpresarial, InteresadoEn, Nombre, NombreComercial, NombreCompleto, Observaciones, Origen, PaginaWeb, Pais, PedirTono, Plano, Poblacion, Prospecto, ReferidoMail, ReferidoNombre, ReferidoRFC, ReferidoTelefono, RelacionReferencia, RFC, SIC, SincronizarCRM, Situacion, SituacionFecha, SituacionNota, SituacionUsuario, Telefonos, TelefonosLada, TemaCRM, TieneMovimientos, Tipo, UltimoCambio, Usuario, Zona FROM Deleted Contacto FOR XML AUTO)
END
SELECT @Datos = @Datos + '</' + @Accion + '></Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario, @Contrasena, @Datos, NULL, @Ok OUTPUT, @OkRef OUTPUT, 1, 0, @IDIS OUTPUT
SELECT @Datos = '<Intelisis Sistema="IntelisisCRM" Contenido="Solicitud" Referencia="IntelisisCRM.CRM" SubReferencia="" Version="1.0">' + '<Solicitud>' + '<' + @Accion + '>'
IF @ProspectoD IS NULL OR @ProspectoD = @ProspectoI
SELECT @Datos = @Datos + (SELECT AccountId, Agente, Alta, ApellidoMaterno, ApellidoPaterno, CargaRID, Categoria, CodigoPostal, Colonia, CRMID, CURP, Delegacion, Direccion, DireccionNumero, DireccionNumeroInt, eMail, EmpresaTipo, EntreCalles, Estado, Estatus, Familia, Fax, Fuente, Grupo, GrupoEmpresarial, InteresadoEn, Nombre, NombreComercial, NombreCompleto, Observaciones, Origen, PaginaWeb, Pais, PedirTono, Plano, Poblacion, Prospecto, ReferidoMail, ReferidoNombre, ReferidoRFC, ReferidoTelefono, RelacionReferencia, RFC, SIC, SincronizarCRM, Situacion, SituacionFecha, SituacionNota, SituacionUsuario, Telefonos, TelefonosLada, TemaCRM, TieneMovimientos, Tipo, UltimoCambio, Usuario, Zona FROM Inserted CuentaBorraLead FOR XML AUTO)
ELSE
BEGIN
IF @SincronizarCRMI = 1 AND @SincronizarCRMD = 0
SELECT @Datos = ''
ELSE
SELECT @Datos = @Datos + (SELECT AccountId, Agente, Alta, ApellidoMaterno, ApellidoPaterno, CargaRID, Categoria, CodigoPostal, Colonia, CRMID, CURP, Delegacion, Direccion, DireccionNumero, DireccionNumeroInt, eMail, EmpresaTipo, EntreCalles, Estado, Estatus, Familia, Fax, Fuente, Grupo, GrupoEmpresarial, InteresadoEn, Nombre, NombreComercial, NombreCompleto, Observaciones, Origen, PaginaWeb, Pais, PedirTono, Plano, Poblacion, Prospecto, ReferidoMail, ReferidoNombre, ReferidoRFC, ReferidoTelefono, RelacionReferencia, RFC, SIC, SincronizarCRM, Situacion, SituacionFecha, SituacionNota, SituacionUsuario, Telefonos, TelefonosLada, TemaCRM, TieneMovimientos, Tipo, UltimoCambio, Usuario, Zona FROM Deleted CuentaBorraLead FOR XML AUTO)
END
END
RETURN
END

