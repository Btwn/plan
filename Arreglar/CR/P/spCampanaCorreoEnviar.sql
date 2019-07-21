SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCampanaCorreoEnviar
@ID		int,
@Pagina		varchar(20),
@Asunto		varchar(100),
@Conteo		int		OUTPUT,
@Ok		int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@CampanaTipo			varchar(50),
@ContactoTipo			varchar(20),
@Contacto				varchar(10),
@Nombre				varchar(100),
@ApellidoPaterno			varchar(30),
@ApellidoMaterno			varchar(30),
@eMail				varchar(100),
@Para				varchar(255),
@Empresa				varchar(5),
@Usuario				varchar(10),
@Perfil				varchar(50),
@PaginaTipo				varchar(20),
@HTML				varchar(max),
@Sitio				varchar(20),
@EncuestaWeb			bit,
@EncuestaEtiqueta			varchar(100),
@EncuestaPagina			varchar(20),
@CancelarSuscripcion		bit,
@CancelarSuscripcionEtiqueta	varchar(100),
@RID				int,
@EnvioCorreo			bit
SELECT @Conteo = 0
SELECT @CampanaTipo = CampanaTipo, @Empresa = Empresa, @Usuario = NULLIF(RTRIM(Usuario), '') FROM Campana WHERE ID = @ID
SELECT @Perfil = DBMailPerfil FROM EmpresaGral WHERE Empresa = @Empresa
IF @Usuario IS NOT NULL
SELECT @Perfil = ISNULL(NULLIF(RTRIM(DBMailPerfil), ''), @Perfil) FROM Usuario WHERE Usuario = @Usuario
SELECT @PaginaTipo = Tipo, @HTML = CONVERT(varchar(max), HTML) FROM WebPagina WHERE Pagina = @Pagina
SELECT @Sitio = NULLIF(RTRIM(Sitio), ''), @EncuestaWeb = ISNULL(EncuestaWeb, 0), @EncuestaEtiqueta = NULLIF(RTRIM(EncuestaEtiqueta), ''), @EncuestaPagina = NULLIF(RTRIM(EncuestaPagina), ''),
@CancelarSuscripcion = ISNULL(CancelarSuscripcion, 0), @CancelarSuscripcionEtiqueta = NULLIF(RTRIM(CancelarSuscripcionEtiqueta), '')
FROM CampanaTipo
WHERE CampanaTipo = @CampanaTipo
DECLARE crCampanaD CURSOR LOCAL FOR
SELECT d.RID, d.Contacto, d.ContactoTipo
FROM CampanaD d
WHERE d.ID = @ID AND d.RID IN (SELECT RID FROM #CampanaCorreoEnviar)
OPEN crCampanaD
FETCH NEXT FROM crCampanaD INTO @RID, @Contacto, @ContactoTipo
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @EnvioCorreo = 0
IF @ContactoTipo IN ('Cliente', 'Prospecto')
BEGIN
IF @ContactoTipo = 'Cliente'
DECLARE crCampanaCto CURSOR LOCAL FOR
SELECT c.Nombre, c.ApellidoPaterno, c.ApellidoMaterno, eMail
FROM CteCto c
JOIN CampanaTipoCargo t ON t.CampanaTipo = @CampanaTipo AND t.Cargo = c.Cargo
WHERE c.Cliente = @Contacto
ELSE
IF @ContactoTipo = 'Prospecto'
DECLARE crCampanaCto CURSOR LOCAL FOR
SELECT c.Nombre, c.ApellidoPaterno, c.ApellidoMaterno, eMail
FROM ProspectoCto c
JOIN CampanaTipoCargo t ON t.CampanaTipo = @CampanaTipo AND t.Cargo = c.Cargo
WHERE c.Prospecto = @Contacto
OPEN crCampanaCto
FETCH NEXT FROM crCampanaCto INTO @Nombre, @ApellidoPaterno, @ApellidoMaterno, @eMail
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Para = NULL
SELECT @Para = dbo.fnCorreoPara(@Nombre, @ApellidoPaterno, @ApellidoMaterno, @eMail)
IF @Para IS NOT NULL
BEGIN
EXEC spCampanaCorreoEnviarPara @ID, @Pagina, @Asunto, @Para, @Perfil, @RID, @HTML, @PaginaTipo, @Sitio, @EncuestaWeb, @EncuestaEtiqueta, @EncuestaPagina, @CancelarSuscripcion, @CancelarSuscripcionEtiqueta, @Ok OUTPUT, @OkRef OUTPUT
SELECT @Conteo = @Conteo + 1, @EnvioCorreo = 1
END
END
FETCH NEXT FROM crCampanaCto INTO @Nombre, @ApellidoPaterno, @ApellidoMaterno, @eMail
END  
CLOSE crCampanaCto
DEALLOCATE crCampanaCto
END ELSE
BEGIN
SELECT @Para = NULL
IF @ContactoTipo = 'Personal'
SELECT @Para = dbo.fnCorreoPara(Nombre, ApellidoPaterno, ApellidoMaterno, eMail)
FROM Personal
WHERE Personal = @Contacto
ELSE
IF @ContactoTipo = 'Proveedor'
SELECT @Para = dbo.fnCorreoPara(Contacto1, NULL, NULL, eMail1)
FROM Prov
WHERE Proveedor = @Contacto
ELSE
IF @ContactoTipo = 'Agente'
SELECT @Para = dbo.fnCorreoPara(Nombre, NULL, NULL, eMail)
FROM Agente
WHERE Agente = @Contacto
IF @Para IS NOT NULL
BEGIN
EXEC spCampanaCorreoEnviarPara @ID, @Pagina, @Asunto, @Para, @Perfil, @RID, @HTML, @PaginaTipo, @Sitio, @EncuestaWeb, @EncuestaEtiqueta, @EncuestaPagina, @CancelarSuscripcion, @CancelarSuscripcionEtiqueta, @Ok OUTPUT, @OkRef OUTPUT
SELECT @Conteo = @Conteo + 1, @EnvioCorreo = 1
END
END
IF @EnvioCorreo = 1
INSERT CampanaEvento (ID, RID, Tipo, Observaciones) VALUES (@ID, @RID, 'Correo', @Asunto)
END
FETCH NEXT FROM crCampanaD INTO @RID, @Contacto, @ContactoTipo
END  
CLOSE crCampanaD
DEALLOCATE crCampanaD
RETURN
END

