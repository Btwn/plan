SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCampanaDABC ON CampanaD

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@IDN		int,
@IDA		int,
@RIDN		int,
@RIDA		int,
@Mov		varchar(20),
@MovID		varchar(20),
@SituacionN		varchar(50),
@SituacionA		varchar(50),
@Empresa		varchar(5),
@Sucursal		int,
@CampanaID		int,
@CampanaRID		int,
@CampanaTipo	varchar(50),
@Pagina		varchar(20),
@Asunto		varchar(100),
@Accion		varchar(50),
@ProyectoMov	varchar(20),
@ProyectoPlantilla	varchar(50),
@CampanaMov		varchar(20),
@CampanaMovID	varchar(20),
@ContactoTipo	varchar(20),
@Contacto		varchar(10),
@Usuario		varchar(10),
@Hoy		datetime,
@Ok			int,
@OkRef		varchar(255),
@Cliente		varchar(10),
@Proveedor		varchar(10),
@Personal		varchar(10),
@Agente		varchar(10),
@Almacen		varchar(10),
@Moneda		varchar(10),
@TipoCambio		float,
@Tipo		varchar(20),
@OportunidadID	int,
@OportunidadMov	varchar(20),
@OportunidadMovID	varchar(20),
@GestionMov		varchar(20),
@GestionAsunto	varchar(255),
@GestionPara	varchar(10)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @Ok = NULL, @OkRef = NULL
SELECT @IDN = ID, @RIDN = RID, @SituacionN = Situacion, @Contacto = Contacto, @ContactoTipo = ContactoTipo, @Usuario = Usuario FROM Inserted
SELECT @IDA = ID, @RIDA = RID, @SituacionA = Situacion FROM Deleted
IF @IDN IS NULL
BEGIN
DELETE CampanaTarea    WHERE ID = @IDA AND RID = @RIDA
DELETE CampanaEvento   WHERE ID = @IDA AND RID = @RIDA
DELETE CampanaEncuesta WHERE ID = @IDA AND RID = @RIDA
END ELSE
IF @SituacionN <> @SituacionA
BEGIN
SELECT @Hoy = dbo.fnFechaSinHora(GETDATE())
SELECT @Mov = Mov, @MovID = MovID, @Empresa = Empresa, @Sucursal = Sucursal, @CampanaTipo = CampanaTipo, @Agente = Agente FROM Campana WHERE ID = @IDN
SELECT @Almacen = MIN(Almacen) FROM Alm WHERE Sucursal = @Sucursal AND Estatus = 'ALTA'
SELECT @Moneda = m.Moneda, @TipoCambio = m.TipoCambio
FROM EmpresaCfg cfg, Mon m
WHERE cfg.Empresa = @Empresa AND m.Moneda = cfg.ContMoneda
INSERT CampanaTarea  (ID, RID, Situacion, Asunto, Estado, Inicio, Vencimiento)
SELECT @IDN, @RIDN, @SituacionN, Tarea, 'No comenzada', @Hoy, DATEADD(day, Dias, @Hoy)
FROM CampanaTipoSituacionTarea
WHERE CampanaTipo = @CampanaTipo AND Situacion = @SituacionN
AND Tarea NOT IN (SELECT Asunto FROM CampanaTarea WHERE ID = @IDN AND RID = @RIDN)
ORDER BY Orden
DECLARE crCampanaCfgSituacion CURSOR LOCAL FOR
SELECT UPPER(Accion), Pagina, Asunto, ProyectoMov, ProyectoPlantilla, CampanaMov, CampanaMovID, OportunidadMov, NULLIF(RTRIM(GestionMov), ''), NULLIF(RTRIM(GestionAsunto), ''), NULLIF(RTRIM(GestionPara), '')
FROM CampanaCfgSituacion
WHERE ID = @IDN AND Situacion = @SituacionN AND Estatus = 'ALTA'
OPEN crCampanaCfgSituacion
FETCH NEXT FROM crCampanaCfgSituacion INTO @Accion, @Pagina, @Asunto, @ProyectoMov, @ProyectoPlantilla, @CampanaMov, @CampanaMovID, @OportunidadMov, @GestionMov, @GestionAsunto, @GestionPara
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Accion = 'ENVIAR CORREO'
BEGIN
CREATE TABLE #CampanaCorreoEnviar (RID int PRIMARY KEY NOT NULL)
INSERT #CampanaCorreoEnviar(RID) VALUES (@RIDN)
EXEC spCampanaCorreoEnviar @IDN, @Pagina, @Asunto, NULL, @Ok OUTPUT, @OkRef OUTPUT
DROP TABLE #CampanaCorreoEnviar
END ELSE
IF @Accion = 'GENERAR PROYECTO'
EXEC spCampanaGenerarProyecto @IDN, @RIDN, @ProyectoMov, @ProyectoPlantilla
ELSE
IF @Accion = 'GENERAR GESTION'
EXEC spCampanaGenerarGestion @IDN, @RIDN, @GestionMov, @GestionAsunto, @GestionPara
ELSE
IF @Accion IN ('COPIAR CONTACTO', 'MOVER CONTACTO', 'ELIMINAR CONTACTO')
BEGIN
IF @Accion IN ('COPIAR CONTACTO', 'MOVER CONTACTO')
BEGIN
SELECT @CampanaID = NULL
SELECT @CampanaID = MIN(ID)
FROM Campana
WHERE Empresa = @Empresa AND Estatus = 'PENDIENTE' AND Mov = @CampanaMov AND MovID = @CampanaMovID
IF @CampanaID IS NOT NULL
BEGIN
IF NOT EXISTS(SELECT * FROM CampanaD WHERE ID = @CampanaID AND Contacto = @Contacto AND ContactoTipo = @ContactoTipo)
BEGIN
INSERT CampanaD (
ID, Contacto, ContactoTipo, Situacion, Usuario)
SELECT @CampanaID, @Contacto, @ContactoTipo, dbo.fnCampanaSituacionPorOmision(@IDN), @Usuario
SELECT @CampanaRID = SCOPE_IDENTITY()
INSERT CampanaEvento (
ID,         RID,         FechaHora, Tipo, Situacion, SituacionFecha, Observaciones, Sucursal, SucursalOrigen, Comentarios)
SELECT @CampanaID, @CampanaRID, FechaHora, Tipo, Situacion, SituacionFecha, Observaciones, Sucursal, SucursalOrigen, Comentarios
FROM CampanaEvento
WHERE ID = @IDN AND RID = @RIDN
END
END
END
IF (@Accion = 'MOVER CONTACTO' AND @CampanaID IS NOT NULL) OR (@Accion = 'ELIMINAR CONTACTO')
BEGIN
DELETE CampanaD      WHERE ID = @IDN AND RID = @RIDN
DELETE CampanaEvento WHERE ID = @IDN AND RID = @RIDN
DELETE CampanaTarea  WHERE ID = @IDN AND RID = @RIDN
END
END ELSE
IF UPPER(@ContactoTipo) = 'PROSPECTO'
BEGIN
IF @Accion IN ('GENERAR CLIENTE', 'GENERAR OPORTUNIDAD')
BEGIN
IF @Accion = 'GENERAR OPORTUNIDAD' SELECT @Tipo = 'Oportunidad' ELSE SELECT @Tipo = 'Cliente'
EXEC spConsecutivo 'Cte', @Sucursal, @Cliente OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @AutoGenerar = 1
INSERT Cte (
Cliente,  Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Plano, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, Zona, CodigoPostal, RFC, CURP, Telefonos, TelefonosLada, Fax, PedirTono, /*PaginaWeb, */Comentarios, Categoria, Grupo, Familia, SIC, Tipo,  Agente, Estatus, Usuario,  Alta)
SELECT @Cliente, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Plano, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, Zona, CodigoPostal, RFC, CURP, Telefonos, TelefonosLada, Fax, PedirTono, /*PaginaWeb, */Comentarios, Categoria, Grupo, Familia, SIC, @Tipo, Agente, 'ALTA',  @Usuario, GETDATE()
FROM Prospecto
WHERE Prospecto = @Contacto
SET IDENTITY_INSERT CteCto ON;
INSERT CteCto (
Cliente,  ID, Nombre, ApellidoPaterno, ApellidoMaterno, Atencion, Tratamiento, Cargo, Grupo, FechaNacimiento, Telefonos, Extencion, eMail, Fax, PedirTono, Tipo, Sexo, Usuario)
SELECT @Cliente, ID, Nombre, ApellidoPaterno, ApellidoMaterno, Atencion, Tratamiento, Cargo, Grupo, FechaNacimiento, Telefonos, Extencion, eMail, Fax, PedirTono, Tipo, Sexo, Usuario
FROM ProspectoCto
WHERE Prospecto = @Contacto
SET IDENTITY_INSERT CteCto OFF;
UPDATE Prospecto
SET Tipo = @Tipo
WHERE Prospecto = @Contacto
INSERT FormaExtraValor (
FormaTipo, Aplica,    AplicaClave, Campo, Valor)
SELECT FormaTipo, 'Cliente', @Cliente,    Campo, Valor
FROM FormaExtraValor
WHERE Aplica = 'Prospecto' AND AplicaClave = @Contacto
INSERT CtaBitacora (Modulo, Cuenta,   Fecha,     Evento,    Usuario)
SELECT DISTINCT     'CXC',  @Cliente, FechaHora, Situacion, @Usuario
FROM CampanaEvento
WHERE ID = @IDN AND RID = @RIDN
END ELSE
IF @Accion = 'GENERAR PROVEEDOR'
BEGIN
EXEC spConsecutivo 'Prov', @Sucursal, @Proveedor OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @AutoGenerar = 1
INSERT Prov (
Proveedor,  Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Plano, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, Zona, CodigoPostal, RFC, CURP, Telefonos, /*TelefonosLada, */Fax, PedirTono, /*PaginaWeb, *//*Comentarios, */Categoria, /*Grupo, */Familia, Tipo,        Agente, Estatus, /*Usuario,  */Alta)
SELECT @Proveedor, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Plano, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, Zona, CodigoPostal, RFC, CURP, Telefonos, /*TelefonosLada, */Fax, PedirTono, /*PaginaWeb, *//*Comentarios, */Categoria, /*Grupo, */Familia, 'Proveedor', Agente, 'ALTA',  /*@Usuario, */GETDATE()
FROM Prospecto
WHERE Prospecto = @Contacto
UPDATE Prospecto
SET Tipo = 'Proveedor'
WHERE Prospecto = @Contacto
INSERT FormaExtraValor (
FormaTipo, Aplica,      AplicaClave, Campo, Valor)
SELECT FormaTipo, 'Proveedor', @Proveedor,  Campo, Valor
FROM FormaExtraValor
WHERE Aplica = 'Prospecto' AND AplicaClave = @Contacto
INSERT CtaBitacora (Modulo, Cuenta,     Fecha,     Evento,    Usuario)
SELECT DISTINCT     'CXP',  @Proveedor, FechaHora, Situacion, @Usuario
FROM CampanaEvento
WHERE ID = @IDN AND RID = @RIDN
END ELSE
IF @Accion = 'GENERAR AGENTE'
BEGIN
EXEC spConsecutivo 'Agente', @Sucursal, @Agente OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @AutoGenerar = 1
INSERT Agente (
Agente,  Nombre, Direccion, /*DireccionNumero, DireccionNumeroInt, EntreCalles, Plano, Observaciones, Delegacion, */Colonia, Poblacion, Estado, Pais, Zona, CodigoPostal, RFC, CURP, Telefonos, /*TelefonosLada, Fax, PedirTono, *//*PaginaWeb, *//*Comentarios, */Categoria, /*Grupo, */Familia, Tipo,     /*Agente, */Estatus, /*Usuario,  */Alta)
SELECT @Agente, Nombre, Direccion, /*DireccionNumero, DireccionNumeroInt, EntreCalles, Plano, Observaciones, Delegacion, */Colonia, Poblacion, Estado, Pais, Zona, CodigoPostal, RFC, CURP, Telefonos, /*TelefonosLada, Fax, PedirTono, *//*PaginaWeb, *//*Comentarios, */Categoria, /*Grupo, */Familia, 'Agente', /*Agente, */'ALTA',  /*@Usuario, */GETDATE()
FROM Prospecto
WHERE Prospecto = @Contacto
UPDATE Prospecto
SET Tipo = 'Agente'
WHERE Prospecto = @Contacto
INSERT FormaExtraValor (
FormaTipo, Aplica,   AplicaClave, Campo, Valor)
SELECT FormaTipo, 'Agente', @Agente,     Campo, Valor
FROM FormaExtraValor
WHERE Aplica = 'Prospecto' AND AplicaClave = @Contacto
INSERT CtaBitacora (Modulo,   Cuenta,  Fecha,     Evento,    Usuario)
SELECT DISTINCT     'AGENT',  @Agente, FechaHora, Situacion, @Usuario
FROM CampanaEvento
WHERE ID = @IDN AND RID = @RIDN
END ELSE
IF @Accion = 'GENERAR PERSONAL'
BEGIN
EXEC spConsecutivo 'Personal', @Sucursal, @Personal OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @AutoGenerar = 1
INSERT Personal (
Personal,  Nombre, Direccion, DireccionNumero, DireccionNumeroInt, /*EntreCalles, Plano, Observaciones, */Delegacion, Colonia, Poblacion, Estado, Pais, /*Zona, */CodigoPostal, Registro, Registro2, Telefono,  /*TelefonosLada, Fax, PedirTono, *//*PaginaWeb, *//*Comentarios, */Categoria, Grupo, /*Familia, */Tipo,       /*Agente, */Estatus, /*Usuario,  */FechaAlta)
SELECT @Personal, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, /*EntreCalles, Plano, Observaciones, */Delegacion, Colonia, Poblacion, Estado, Pais, /*Zona, */CodigoPostal, RFC,      CURP,      Telefonos, /*TelefonosLada, Fax, PedirTono, *//*PaginaWeb, *//*Comentarios, */Categoria, Grupo, /*Familia, */'Empleado', /*Agente, */'ALTA',  /*@Usuario, */GETDATE()
FROM Prospecto
WHERE Prospecto = @Contacto
UPDATE Prospecto
SET Tipo = 'Personal'
WHERE Prospecto = @Contacto
INSERT FormaExtraValor (
FormaTipo, Aplica,     AplicaClave, Campo, Valor)
SELECT FormaTipo, 'Personal', @Personal,   Campo, Valor
FROM FormaExtraValor
WHERE Aplica = 'Prospecto' AND AplicaClave = @Contacto
INSERT CtaBitacora (Modulo, Cuenta,    Fecha,     Evento,    Usuario)
SELECT DISTINCT     'RH',   @Personal, FechaHora, Situacion, @Usuario
FROM CampanaEvento
WHERE ID = @IDN AND RID = @RIDN
END
IF @Accion = 'GENERAR OPORTUNIDAD' AND UPPER(@ContactoTipo) IN ('PROSPECTO', 'CLIENTE') AND NULLIF(RTRIM(@OportunidadMov), '') IS NOT NULL
BEGIN
IF UPPER(@ContactoTipo) = 'CLIENTE' SELECT @Cliente = @Contacto
INSERT Venta (
Empresa,  Cliente,  Mov,             FechaEmision, Usuario,  Moneda,  TipoCambio,  Agente,  Estatus,      Almacen)
VALUES (@Empresa, @Cliente, @OportunidadMov, @Hoy,         @Usuario, @Moneda, @TipoCambio, @Agente, 'SINAFECTAR', @Almacen)
SELECT @OportunidadID = SCOPE_IDENTITY()
EXEC spAfectar 'VTAS', @OportunidadID, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @OportunidadMovID = MovID FROM Venta WHERE ID = @OportunidadID
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, 'CMP', @IDN, @Mov, @MovID, 'VTAS', @OportunidadID, @OportunidadMov, @OportunidadMovID, @Ok OUTPUT
END
END
IF @Accion = 'ACTUALIZAR SITUACION CONTACTO'
EXEC spCampanaActualizarSituacion @IDN, @RIDN
END
FETCH NEXT FROM crCampanaCfgSituacion INTO @Accion, @Pagina, @Asunto, @ProyectoMov, @ProyectoPlantilla, @CampanaMov, @CampanaMovID, @OportunidadMov, @GestionMov, @GestionAsunto, @GestionPara
END  
CLOSE crCampanaCfgSituacion
DEALLOCATE crCampanaCfgSituacion
END
EXEC spOk_RAISERROR @Ok, @OkRef
END

