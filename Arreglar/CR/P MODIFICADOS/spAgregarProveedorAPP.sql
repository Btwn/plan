SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAgregarProveedorAPP
@Clave		varchar(20),
@Nombre	     	varchar(100),
@Direccion 		varchar(100),
@Delegacion		varchar(50),
@Colonia 		varchar(30),
@Ruta		varchar(50),
@Poblacion 		varchar(30),
@Estado 		varchar(30),
@Pais 		varchar(30),
@CodigoPostal 	varchar(15),
@RFC 		varchar(15),
@Telefonos		varchar(100),
@Contacto		varchar(50),
@eMail		varchar(50),
@Categoria		varchar(50),
@Familia		varchar(50),
@Agente		varchar(10),
@Tipo		varchar(20),
@Moneda		varchar(10),
@Condicion		varchar(50),
@CPID		int	    = NULL,
@Empresa		varchar(5)     = NULL,
@Proveedor   varchar(10) OUTPUT

AS BEGIN
DECLARE
@Ok			 int,
@OkRef		 varchar(255),
@Mensaje		 varchar(255),
@NombreCorto	 char(20),
@Pos		 int,
@Consecutivo	 int,
@PrefijoSucursal	 char(5),
@ConsecutivoGral	 bit,
@UsarPrefijoSucursal bit,
@OkRegistro bit,
@Prefijo		varchar(5),
@PrefijoLike		char(10),
@Digitos		int
SELECT
@Clave 	= UPPER(RTRIM(NULLIF(@Clave,'0'))),
@Nombre 	= RTRIM(NULLIF(@Nombre,'0')),
@Direccion 	= RTRIM(NULLIF(@Direccion,'0')),
@Delegacion 	= RTRIM(NULLIF(@Delegacion,'0')),
@Colonia 	= RTRIM(NULLIF(@Colonia,'0')),
@Ruta	        = RTRIM(NULLIF(@Ruta, '0')),
@Poblacion 	= RTRIM(NULLIF(@Poblacion,'0')),
@Estado 	= RTRIM(NULLIF(@Estado,'0')),
@Pais 		= RTRIM(NULLIF(@Pais,'0')),
@CodigoPostal 	= RTRIM(NULLIF(@CodigoPostal,'0')),
@RFC 		= RTRIM(NULLIF(@RFC,'0')),
@Telefonos 	= RTRIM(NULLIF(@Telefonos,'0')),
@Contacto	= RTRIM(NULLIF(@Contacto,'0')),
@eMail		= RTRIM(NULLIF(@eMail,'0')),
@Categoria	= RTRIM(NULLIF(@Categoria,'0')),
@Familia	= RTRIM(NULLIF(@Familia,'0')),
@Agente	= RTRIM(NULLIF(@Agente,'0')),
@Tipo		= RTRIM(NULLIF(@Tipo,'0')),
@Prefijo 	= RTRIM(NULLIF(@Prefijo,'0')),
@PrefijoLike 	= RTRIM(NULLIF(@PrefijoLike,'0')),
@Condicion 	= RTRIM(NULLIF(@Condicion,'0')),
@CPID	        = NULLIF(@CPID, 0),
@Empresa 	= RTRIM(NULLIF(@Empresa,'0'))
SELECT @PrefijoSucursal = NULL, @Ok = NULL, @OkRef = NULL, @UsarPrefijoSucursal = 0
SELECT @UsarPrefijoSucursal = ProvExpressUsarPrefijoSucursal,
@Condicion = ProvExpressCondicion,
@ConsecutivoGral = SugerirConsecCentralizado,
@Prefijo = ProvExpressPrefijo,
@Digitos = ProvExpressDigitos
FROM EmpresaGral WITH(NOLOCK)
WHERE Empresa = @Empresa
SELECT @PrefijoLike = RTRIM(LTRIM(ISNULL(@Prefijo,' ')))+'[0-9]%'
IF @UsarPrefijoSucursal = 1
SELECT @PrefijoSucursal = NULLIF(RTRIM(Prefijo), '') FROM Sucursal s WITH(NOLOCK), Version v WITH(NOLOCK) WHERE s.Sucursal = v.Sucursal
IF @CPID IS NOT NULL
SELECT @CodigoPostal = CodigoPostal, @Colonia = Colonia, @Delegacion = Delegacion, @Ruta = Ruta,
@Estado = Estado, @Pais = 'Mexico'
FROM CodigoPostal WITH(NOLOCK)
WHERE ID = @CPID
IF @PrefijoSucursal IS NOT NULL SELECT @Prefijo = @PrefijoSucursal, @PrefijoLike = RTRIM(@PrefijoSucursal)+'[0-9]%'
IF @Tipo IS NULL SELECT @Tipo = 'Acreedor'
IF @Clave = '(RFC)'
BEGIN
IF NOT EXISTS(SELECT * FROM Prov WITH(NOLOCK) WHERE UPPER(RTRIM(LTRIM(RFC)))=UPPER(RTRIM(LTRIM(@RFC))))
SELECT @Clave = RTRIM(LTRIM(@RFC))
ELSE
SELECT @Clave = '(CONSECUTIVO)'
END
IF @Clave = '(TELEFONO)'
BEGIN
SELECT @Clave = SUBSTRING(@Telefonos, 1, 10)
SELECT @Pos = PATINDEX('% %', @Clave)
IF @Pos > 1 SELECT @Clave = SUBSTRING(RTRIM(LTRIM(@Clave)), 1, @Pos-1)
END
IF @Clave IN ('(CONSECUTIVO)', NULL)
BEGIN
IF @ConsecutivoGral = 1
EXEC spConsecutivo 'Proveedores', 0, @Clave OUTPUT
ELSE BEGIN
SELECT @Clave = MAX(RTRIM(LTRIM(Proveedor))) FROM Prov WITH(NOLOCK) WHERE Proveedor LIKE RTRIM(@PrefijoLike)
IF @Clave IS NULL
SELECT @Consecutivo = 1
ELSE SELECT @Consecutivo = Convert(int, STUFF(@Clave, 1, LEN(RTRIM(@Prefijo)), NULL)) + 1
EXEC spLlenarCeros @Consecutivo, @Digitos, @Clave OUTPUT
SELECT @Clave = RTRIM(@Prefijo) + RTRIM(LTRIM(@Clave))
END
END
SELECT @Clave = NULLIF(RTRIM(LTRIM(@Clave)), '')
BEGIN TRANSACTION
IF NOT EXISTS(SELECT * FROM Prov WITH(NOLOCK) WHERE RTRIM(LTRIM(Proveedor)) = RTRIM(LTRIM(@Clave)))
BEGIN
IF EXISTS(SELECT * FROM Prov WITH(NOLOCK) WHERE UPPER(Nombre) = UPPER(@Nombre) AND UPPER(RTRIM(LTRIM(RFC)))=UPPER(RTRIM(LTRIM(@RFC))))
BEGIN
SELECT @Clave = Proveedor FROM Prov WITH(NOLOCK) WHERE UPPER(Nombre) = UPPER(@Nombre) AND UPPER(RTRIM(LTRIM(RFC)))=UPPER(RTRIM(LTRIM(@RFC)))
SELECT @Ok = 1
END
ELSE BEGIN
SELECT @NombreCorto = LEFT(@Nombre, 20)
INSERT Prov (Proveedor,        Tipo,  Nombre,  NombreCorto,  Direccion,  Delegacion,  Colonia,  Estado,  Pais,  Ruta,  Poblacion,  CodigoPostal,  RFC,  Telefonos,  Contacto1, eMail1, Categoria,  Familia,  DefMoneda, Condicion,  Agente,  Estatus, Alta)
VALUES (LEFT(RTRIM(LTRIM(@Clave)), 10), @Tipo, @Nombre, @NombreCorto, @Direccion, @Delegacion, @Colonia, @Estado, @Pais, @Ruta, @Poblacion, @CodigoPostal, RTRIM(LTRIM(@RFC)), @Telefonos, @Contacto, @eMail, @Categoria, @Familia, @Moneda,   @Condicion, @Agente, 'ALTA',  GETDATE())
END
END
IF @Ok IS NULL
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
IF @Ok = 10060
BEGIN
SELECT @Mensaje = '"'+LTRIM(RTRIM(ISNULL(@OkRef, '')))+ '" ' + Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
RAISERROR (@Mensaje,16,-1)
END
ELSE IF @Ok IS NULL AND EXISTS (SELECT * FROM Prov WITH(NOLOCK) WHERE RTRIM(LTRIM(Proveedor)) = RTRIM(LTRIM(@Clave)) AND RTRIM(LTRIM(RFC)) = RTRIM(LTRIM(@RFC)))
BEGIN
SELECT @Proveedor = RTRIM(LTRIM(@Clave))
RETURN
END
ELSE IF @Ok IS NOT NULL
BEGIN
SELECT @Proveedor = RTRIM(LTRIM(@Clave))
RETURN
END
ELSE
SELECT @Proveedor = RTRIM(LTRIM(@Clave))
RETURN
END

