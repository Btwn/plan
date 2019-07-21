SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speCommerceWebUsuarioCliente
@ID                     int,
@iSolicitud             int,
@Solicitud              varchar(max),
@Version                float,
@Resultado              varchar(max) = NULL OUTPUT,
@Ok                     int = NULL OUTPUT,
@OkRef                  varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa       varchar(5),
@Sucursal      int,
@ReferenciaIS  varchar(100),
@SubReferencia varchar(100),
@Cliente       varchar(10),
@IDUsuario     int,
@Tipo          varchar(20),
@Usuario       varchar(10),
@RFC           varchar(15),
@eMail         varchar(250),
@GUID          varchar(50),
@Categoria     varchar(50),
@RequiereFactura	smallint
DECLARE @Tabla table(Nombre varchar(100), Apellidos varchar(100),eMail varchar(250),Contrasena varchar(50),Telefono varchar(50),RFC varchar(20), Compania varchar(250), GUID          varchar(50) )
DECLARE @Direccion table(Direccion1 varchar(255),
Direccion2 varchar(255),
Ciudad varchar(100),
Pais varchar(100),
Estado varchar(100),
CP varchar(30),
Delegacion varchar(50),
Colonia    varchar(50),
NoExterior varchar(50))
BEGIN TRANSACTION
IF @Ok IS NULL
BEGIN
SELECT @Usuario = WebUsuario
FROM WebVersion
SELECT @Empresa = Empresa, @Sucursal = Sucursal FROM openxml (@iSolicitud,'/Intelisis/Solicitud')
WITH (Empresa varchar(5), Sucursal int)
SELECT @RFC = RFC , @eMail = eMail, @RequiereFactura = RequiereFactura, @GUID = GUID FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Usuario')
WITH (RFC varchar(15),eMail varchar(250), RequiereFactura smallint, GUID varchar(50))
IF NULLIF(@GUID,'') IS NULL
SELECT @Ok = 71020
IF @Ok IS NULL
SELECT @ReferenciaIS = Referencia, @SubReferencia = SubReferencia
FROM IntelisisService WITH(NOLOCK)
 WHERE ID = @ID
SELECT @Categoria = NULLIF(eCommerceCteCat,'') FROM Sucursal WHERE Sucursal = @Sucursal
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
INSERT @Tabla(Nombre , Apellidos,        eMail, Contrasena , Telefono, RFC ,Compania, GUID )
SELECT         Nombre , Apellidos,        eMail, Contrasena , Telefono, RFC ,Compania ,GUID
FROM OPENXML (@iSolicitud, '/Intelisis/Solicitud/Usuario',1)
WITH (Nombre varchar(100), Apellidos varchar(100),eMail varchar(250),Contrasena varchar(50),Telefono varchar(50),RFC varchar(20), Compania varchar(250),GUID varchar(50) )
EXEC sp_xml_removedocument @iSolicitud
IF @@ERROR<>0 SET @Ok = 1
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
INSERT @Direccion(Direccion1 , Direccion2, Ciudad, Pais , Estado, CP, Colonia, Delegacion, NoExterior )
SELECT            Direccion1 , Direccion2, Ciudad, Pais , Estado, CP, Colonia, Delegacion, NumeroExterior
FROM OPENXML (@iSolicitud, '/Intelisis/Solicitud/Usuario/Direccion',1)
WITH (Direccion1 varchar(255), Direccion2 varchar(255),Ciudad varchar(100),Pais varchar(100),Estado varchar(100),CP varchar(30), Colonia varchar(50), Delegacion varchar(50), NumeroExterior varchar(50))
EXEC sp_xml_removedocument @iSolicitud
IF @@ERROR<>0 SET @Ok = 1
SELECT @Tipo = eCommerceTipoConsecutivo FROM Sucursal WHERE Sucursal = @Sucursal
IF NULLIF(@Tipo,'') IS NULL SET @Ok = 53040
IF(ISNULL(@Ok, '') = '' AND ISNULL(@RequiereFactura, 0) = 1)
BEGIN
SELECT @Tipo = eCommerceTipoConsecutivoFact FROM Sucursal WHERE Sucursal = @Sucursal
IF NULLIF(@Tipo,'') IS NULL SET @Ok = 53040
END
IF @Ok IS NULL
IF NOT EXISTS(SELECT * FROM WebUsuarios WHERE GUID = @GUID)
BEGIN
IF EXISTS(SELECT * FROM WebUsuario WHERE eMail = @eMail)
SELECT @Ok = 3, @OkRef= 'Ya Existe Un Usuario Con EL Mismo Correo'
EXEC spConsecutivo @Tipo, @Sucursal, @Cliente OUTPUT
IF @Cliente IS NULL SET @Ok = 26060
IF ISNULL(@RFC, '') != '' AND EXISTS(SELECT RFC FROM Cte WITH(NOLOCK) WHERE RFC = @RFC AND Cliente <> @Cliente)
UPDATE @Tabla SET RFC =  'XAXX010101000'
IF @Cliente IS NOT NULL AND @Ok IS NULL AND EXISTS (SELECT * FROM @Direccion)
INSERT Cte(Cliente,  Nombre,   eMail1,   Telefonos,  Contacto1,                           RFC,   Direccion, DireccionNumeroInt,                                        Pais,     Estado,   Poblacion, CodigoPostal, Estatus, Delegacion, DireccionNumero, Colonia, Categoria)
SELECT     @Cliente, a.Nombre+' '+ISNULL(a.Apellidos,''), a.eMail,  a.Telefono, a.Nombre+' '+ISNULL(a.Apellidos,''), a.RFC, ISNULL(d.Direccion1,''),ISNULL(d.Direccion2,''),  d.Pais, d.Estado, d.Ciudad,  d.CP,         'ALTA',  d.Delegacion, d.NoExterior, d.Colonia, @Categoria
FROM @Tabla a JOIN @Direccion d ON 1=1
/*JOIN WebPais p  WITH(NOLOCK) ON d.Pais = p.ID
JOIN WebPaisEstado e  WITH(NOLOCK) ON  e.IDPais = p.ID AND e.ID = d.Estado*/
ELSE IF @Cliente IS NOT NULL AND @Ok IS NULL AND NOT EXISTS (SELECT * FROM @Direccion)
BEGIN
INSERT Cte(Cliente,  Nombre,							  eMail1,   Telefonos,  Contacto1,                           RFC,   Estatus, Categoria)
SELECT     @Cliente, a.Nombre+' '+ISNULL(a.Apellidos,''), a.eMail,  a.Telefono, a.Nombre+' '+ISNULL(a.Apellidos,''), a.RFC, 'ALTA', @Categoria
FROM @Tabla a
END
IF @@ERROR<>0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
INSERT WebUsuarios(eMail, eMail2,  Telefono,  FechaAlta, UltimoCambio,  Empresa,  Sucursal,  Cliente, Contrasena, ContrasenaConfirmacion, Nombre, Apellido, GUID)
SELECT            eMail1, eMail2, Telefonos, GETDATE(), GETDATE(),    @Empresa, @Sucursal, Cliente, Contrasena, Contrasena ,dbo.fnWebSepararContacto(Contacto1,1),  dbo.fnWebSepararContacto(Contacto1,2),@GUID
FROM  Cte
WITH(NOLOCK) WHERE Cliente = @Cliente
IF @@ERROR<>0 SET @Ok = 1
SELECT @IDUsuario = SCOPE_IDENTITY()
END
UPDATE Cte  WITH(ROWLOCK) SET Nombre = Nombre WHERE Cliente = @Cliente
END
ELSE
IF @Ok IS NULL AND  EXISTS(SELECT * FROM WebUsuarios WHERE GUID = @GUID)
BEGIN
SELECT @Cliente = Cliente,@IDUsuario = ID FROM WebUsuarios WHERE GUID = @GUID
IF ISNULL(@RFC, '') != '' AND EXISTS(SELECT * FROM Cte WHERE RFC = @RFC AND Cliente <> @Cliente)
UPDATE @Tabla SET RFC =  'XAXX010101000'
UPDATE Cte  WITH(ROWLOCK) SET   Telefonos =ISNULL(a.Telefono,''), RFC = ISNULL(NULLIF(a.RFC,''),c.RFC),
Contacto1 = CASE
WHEN ISNULL(Contacto1, '') = '' THEN a.Nombre+' '+ISNULL(a.Apellidos,'')
ELSE Contacto1 END,
eMail1 = CASE
WHEN ISNULL(eMail1, '') = '' THEN a.eMail
ELSE eMail1 END
FROM Cte c  WITH(NOLOCK) JOIN @Tabla a ON c.Cliente = @Cliente
WHERE   c.Cliente = @Cliente
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
UPDATE WebUsuarios  WITH(ROWLOCK) SET eMail = t.eMail, Telefono = t.Telefono,  UltimoCambio = GETDATE(),   Contrasena = t.Contrasena, ContrasenaConfirmacion = t.Contrasena, Nombre = t.Nombre , Apellido = t.Apellidos
FROM @Tabla t JOIN WebUsuarios w  WITH(NOLOCK) ON t.GUID = w.GUID
WHERE w.GUID = @GUID
IF @@ERROR <> 0 SET @Ok = 1
END
END
END
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT @OkRef = 'ERROR: ' + CONVERT(varchar,@Ok) + (SELECT Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok) +'. ' + ISNULL(@OkRef,'')
END
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '>    <Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + ' Cliente=' + CHAR(34) + ISNULL(@Cliente,'') + CHAR(34) + ' WebUsuarioID='+ CHAR(34) +ISNULL(CONVERT(varchar,@IDUsuario),'')+ CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/></Intelisis>'
END

