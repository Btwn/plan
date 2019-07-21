SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebPaginaPerfilActualizarInformacionBasica
@Usuario as VARCHAR(20),
@TipoActualizacion as varchar(50),
@valor1 as  VARCHAR(100),
@valor2 as varchar(100),
@valor3 as varchar(100),
@valor4 as varchar(100),
@valor5 as varchar(100),
@valor6 as varchar(100),
@valor7 as varchar(100),
@valor8 as varchar(100),
@valor9 as varchar(100)

AS BEGIN
IF UPPER(@TipoActualizacion)='INFORMACION_BASICA'
BEGIN
UPDATE WebUsuario SET
Nombre=@valor1,Sexo=@valor6 ,FechaNacimiento=@valor2 ,
Nacionalidad=@valor3 ,NivelEstudios=@valor4,Cargo=@valor5,
UltimoCambio=getdate()
WHERE upper(ltrim(rtrim(UsuarioWeb)))=upper(ltrim(rtrim(@Usuario)))
END
IF UPPER(@TipoActualizacion)='CONTACTO'
BEGIN
UPDATE WebUsuario SET
email=@valor1,Telefono=@valor2 ,Extension=@valor3 ,Movil=@valor4,Domicilio=@valor5,
Estado=@valor6 ,CodigoPostal=@valor7,Colonia=@valor8,TelefonoLada=@valor9,
UltimoCambio=getdate()
WHERE upper(ltrim(rtrim(UsuarioWeb)))=upper(ltrim(rtrim(@Usuario)))
END
IF UPPER(@TipoActualizacion)='FOTO'
BEGIN
UPDATE WebUsuario SET
Foto=@valor1,
UltimoCambio=getdate()
WHERE upper(ltrim(rtrim(UsuarioWeb)))=upper(ltrim(rtrim(@Usuario)))
END
IF UPPER(@TipoActualizacion)='CONTRASENA'
BEGIN
UPDATE WebUsuario SET
Contrasena=@valor1,
UltimoCambio=getdate()
WHERE upper(ltrim(rtrim(UsuarioWeb)))=upper(ltrim(rtrim(@Usuario)))
END
IF UPPER(@TipoActualizacion)='PERMITIR_INFORMACION_BASICA'
BEGIN
UPDATE  WebUsuario SET
VerSexo=@valor1,
VerFechaNacimiento=@valor2,
VerNacionalidad=@valor3,
VerNivelEstudios=@valor4,
Vercargo=@valor5,
UltimoCambio=getdate()
WHERE upper(ltrim(rtrim(UsuarioWeb)))=upper(ltrim(rtrim(@Usuario)))
END
IF UPPER(@TipoActualizacion)='PERMITIR_INFORMACION_CONTACTO'
BEGIN
UPDATE  WebUsuario SET
VerMail=@valor1,
VerTelefono=@valor2,
VerMovil=@valor3,
VerDomicilio=@valor4,
VerEstado=@valor5,
VerCodigoPostal=@valor6,
VerColonia=@valor7,
VerTelefonoLada=@valor9,
UltimoCambio=getdate()
WHERE upper(ltrim(rtrim(UsuarioWeb)))=upper(ltrim(rtrim(@Usuario)))
END
END

