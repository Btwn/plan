SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speCommerceHerrWebUsuario
@Estacion	        int,
@Empresa            varchar(5),
@Sucursal           int,
@Tipo               int

AS BEGIN
DECLARE @Cliente varchar(10)
DELETE WebUsuarioTemp WHERE Estacion = @Estacion
INSERT WebUsuarioTemp(Estacion,  eMail,                                           Telefono,  FechaAlta, UltimoCambio,  Empresa,  Sucursal,  Cliente, Contrasena, ContrasenaConfirmacion, Nombre, Apellido)
SELECT                @Estacion, CASE WHEN @Tipo = 1 THEN eMail1 ELSE eMail2 END, Telefonos, GETDATE(), GETDATE(),    @Empresa, @Sucursal, Cliente, Contrasena, Contrasena ,CASE WHEN @Tipo = 1 THEN dbo.fnWebSepararContacto(Contacto1,1) WHEN @Tipo = 2 THEN dbo.fnWebSepararContacto(Contacto2,1) END, CASE WHEN @Tipo = 1 THEN dbo.fnWebSepararContacto(Contacto1,2) WHEN @Tipo = 2 THEN dbo.fnWebSepararContacto(Contacto2,2) END
FROM  Cte
WHERE Cliente IN (SELECT Clave FROM ListaSt WHERE Estacion = @Estacion)
DECLARE crClientes CURSOR LOCAL FOR
SELECT Clave FROM ListaSt WHERE Estacion = @Estacion
OPEN crClientes
FETCH NEXT FROM crClientes INTO @Cliente
WHILE @@FETCH_STATUS = 0
BEGIN
IF NOT EXISTS(SELECT ID FROM CteEnviarA WHERE Cliente = @Cliente)
BEGIN
INSERT CteEnviarA(ID, GUID, Cliente,  Nombre,	Direccion,          DireccionNumeroInt,                                          Pais,     Estado,   Poblacion, CodigoPostal, Estatus, Delegacion,  DireccionNumero, Colonia,   eMail1, Telefonos)
SELECT 			  1, NEWID(), Cliente, ISNULL(NULLIF(Nombre, ''), 'N/A'), ISNULL(NULLIF(Direccion, ''), 'N/A'),          ISNULL(NULLIF(DireccionNumeroInt, ''), 'N/A'),                                          ISNULL(NULLIF(Pais, ''), 'N/A'),     ISNULL(NULLIF(Estado, ''), 'N/A'),   ISNULL(NULLIF(Poblacion, ''), 'N/A'), ISNULL(NULLIF(CodigoPostal, '00000'), 'N/A'), Estatus, ISNULL(NULLIF(Delegacion, ''), 'N/A'),  ISNULL(NULLIF(DireccionNumero, ''), 'N/A'), ISNULL(NULLIF(Colonia, ''), 'N/A'),   ISNULL(NULLIF(eMail1, ''), 'N/A'), ISNULL(NULLIF(Telefonos, ''), '00000')
FROM Cte WHERE Cliente = @Cliente
END
FETCH NEXT FROM crClientes INTO @Cliente
END
CLOSE crClientes
DEALLOCATE crClientes
RETURN
END

