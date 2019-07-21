SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnContactoDireccion
(
@ContactoTipo				varchar(20),
@Contacto					varchar(10),
@IncluirNombre				bit,
@IncluirContacto			bit,
@IncluirRFC					bit,
@IncluirTelefono			bit
)
RETURNS @Resultado TABLE
(
ID				int,
ContactoTipo	varchar(20) COLLATE DATABASE_DEFAULT NULL,
Contacto		varchar(10) COLLATE DATABASE_DEFAULT NULL,
Direccion		varchar(255) COLLATE DATABASE_DEFAULT NULL
)

AS BEGIN
DECLARE
@Direccion						varchar(100),
@DireccionNumero				varchar(20),
@DireccionNumeroInt				varchar(20),
@EntreCalles					varchar(100),
@Colonia						varchar(100),
@Delegacion						varchar(100),
@Poblacion						varchar(100),
@Estado							varchar(30),
@Pais							varchar(30),
@CodigoPostal					varchar(15),
@RFC							varchar(15),
@Telefonos						varchar(100),
@Espacio						char(1),
@Coma							char(1),
@Contador						int,
@ContactoCursor					varchar(10),
@ContactoRegistro				varchar(50),
@Nombre							varchar(255)
SELECT @Espacio = ' ', @Coma = ',', @Contacto = NULLIF(@Contacto,'')
IF @ContactoTipo = 'Cliente'   DECLARE crContacto CURSOR FOR SELECT Cliente,   NULLIF(RTRIM(Nombre),''),                                                                                         NULLIF(ISNULL(RTRIM(Contacto1),RTRIM(Contacto2)),''),   NULLIF(RTRIM(Direccion),''), NULLIF(RTRIM(DireccionNumero),''), NULLIF(RTRIM(DireccionNumeroInt),''), NULLIF(RTRIM(EntreCalles),''), NULLIF(RTRIM(Delegacion),''), NULLIF(RTRIM(Colonia),''), NULLIF(RTRIM(Poblacion),''), NULLIF(RTRIM(Estado),''), NULLIF(RTRIM(Pais),''), NULLIF(RTRIM(CodigoPostal),''), NULLIF(RTRIM(RFC),''),      NULLIF(RTRIM(Telefonos),'') FROM Cte      WHERE Cliente   = ISNULL(@Contacto,Cliente)   ELSE
IF @ContactoTipo = 'Proveedor' DECLARE crContacto CURSOR FOR SELECT Proveedor, NULLIF(RTRIM(Nombre),''),                                                                                         NULLIF(ISNULL(RTRIM(Contacto1),RTRIM(Contacto2)),''), NULLIF(RTRIM(Direccion),''), NULLIF(RTRIM(DireccionNumero),''), NULLIF(RTRIM(DireccionNumeroInt),''), NULLIF(RTRIM(EntreCalles),''), NULLIF(RTRIM(Delegacion),''), NULLIF(RTRIM(Colonia),''), NULLIF(RTRIM(Poblacion),''), NULLIF(RTRIM(Estado),''), NULLIF(RTRIM(Pais),''), NULLIF(RTRIM(CodigoPostal),''), NULLIF(RTRIM(RFC),''),      NULLIF(RTRIM(Telefonos),'') FROM Prov     WHERE Proveedor = ISNULL(@Contacto,Proveedor) ELSE
IF @ContactoTipo = 'Personal'  DECLARE crContacto CURSOR FOR SELECT Personal,  NULLIF(LTRIM(RTRIM(ISNULL(Nombre,'') + ' ' + ISNULL(ApellidoPaterno,'') + ' ' + ISNULL(ApellidoMaterno,''))),''), NULL,                                                 NULLIF(RTRIM(Direccion),''), NULLIF(RTRIM(DireccionNumero),''), NULLIF(RTRIM(DireccionNumeroInt),''), NULLIF(RTRIM(EntreCalles),''), NULLIF(RTRIM(Delegacion),''), NULLIF(RTRIM(Colonia),''), NULLIF(RTRIM(Poblacion),''), NULLIF(RTRIM(Estado),''), NULLIF(RTRIM(Pais),''), NULLIF(RTRIM(CodigoPostal),''), NULLIF(RTRIM(Registro),''), NULLIF(RTRIM(Telefono),'')  FROM Personal WHERE Personal  = ISNULL(@Contacto, Personal)
OPEN crContacto
FETCH NEXT FROM crContacto INTO @ContactoCursor, @Nombre, @ContactoRegistro, @Direccion, @DireccionNumero, @DireccionNumeroInt, @EntreCalles, @Colonia, @Delegacion, @Poblacion, @Estado, @Pais, @CodigoPostal, @RFC, @Telefonos
WHILE @@FETCH_STATUS = 0
BEGIN
SET @Contador = 0
IF @Nombre IS NOT NULL AND @IncluirNombre = 1
BEGIN
SET @Contador = @Contador + 1
INSERT @Resultado (ID,        ContactoTipo,  Contacto,        Direccion)
SELECT  @Contador, @ContactoTipo, @ContactoCursor, ISNULL(@Nombre,'')
END
IF @ContactoRegistro IS NOT NULL AND @IncluirContacto = 1
BEGIN
SET @Contador = @Contador + 1
INSERT @Resultado (ID,        ContactoTipo,  Contacto,        Direccion)
SELECT  @Contador, @ContactoTipo, @ContactoCursor, ISNULL(@ContactoRegistro,'')
END
IF @Direccion IS NOT NULL OR @DireccionNumero IS NOT NULL OR @DireccionNumeroInt IS NOT NULL
BEGIN
SET @Contador = @Contador + 1
INSERT @Resultado (ID,        ContactoTipo,  Contacto,        Direccion)
SELECT  @Contador, @ContactoTipo, @ContactoCursor, ISNULL(@Direccion,'') + @Espacio + ISNULL(@DireccionNumero,'') + @Espacio + ISNULL(@DireccionNumeroInt,'')
END
IF @EntreCalles IS NOT NULL
BEGIN
SET @Contador = @Contador + 1
INSERT @Resultado (ID,        ContactoTipo,  Contacto,        Direccion)
SELECT  @Contador, @ContactoTipo, @ContactoCursor, ISNULL(@EntreCalles,'')
END
IF @Colonia IS NOT NULL OR @Delegacion IS NOT NULL
BEGIN
SET @Contador = @Contador + 1
INSERT @Resultado (ID,        ContactoTipo,  Contacto,        Direccion)
SELECT  @Contador, @ContactoTipo, @ContactoCursor, ISNULL(@Colonia,'') + CASE WHEN @Colonia + @Delegacion IS NOT NULL THEN @Coma + @Espacio ELSE '' END + ISNULL(@Delegacion,'')
END
IF @Poblacion IS NOT NULL OR @Estado IS NOT NULL
BEGIN
SET @Contador = @Contador + 1
INSERT @Resultado (ID,        ContactoTipo,  Contacto,        Direccion)
SELECT  @Contador, @ContactoTipo, @ContactoCursor, ISNULL(@Poblacion,'') + CASE WHEN @Poblacion + @Estado IS NOT NULL THEN @Coma + @Espacio ELSE '' END + ISNULL(@Estado,'')
END
IF @Pais IS NOT NULL OR @CodigoPostal IS NOT NULL
BEGIN
SET @Contador = @Contador + 1
INSERT @Resultado (ID,        ContactoTipo,  Contacto,        Direccion)
SELECT  @Contador, @ContactoTipo, @ContactoCursor, ISNULL(@Pais,'') + CASE WHEN @Pais + @CodigoPostal IS NOT NULL  THEN @Coma + @Espacio ELSE '' END + ISNULL(@CodigoPostal,'')
END
IF @RFC IS NOT NULL AND @IncluirRFC = 1
BEGIN
SET @Contador = @Contador + 1
INSERT @Resultado (ID,        ContactoTipo,  Contacto,        Direccion)
SELECT  @Contador, @ContactoTipo, @ContactoCursor, ISNULL(@RFC,'')
END
IF @Telefonos IS NOT NULL AND @IncluirTelefono = 1
BEGIN
SET @Contador = @Contador + 1
INSERT @Resultado (ID,        ContactoTipo,  Contacto,        Direccion)
SELECT  @Contador, @ContactoTipo, @ContactoCursor, ISNULL(@Telefonos,'')
END
FETCH NEXT FROM crContacto INTO @ContactoCursor, @Nombre, @ContactoRegistro, @Direccion, @DireccionNumero, @DireccionNumeroInt, @EntreCalles, @Colonia, @Delegacion, @Poblacion, @Estado, @Pais, @CodigoPostal, @RFC, @Telefonos
END
CLOSE crContacto
DEALLOCATE crContacto
RETURN
END

