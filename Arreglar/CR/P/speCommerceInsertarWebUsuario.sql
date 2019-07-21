SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speCommerceInsertarWebUsuario
@Estacion	        int

AS BEGIN
DECLARE @Cliente varchar(10)
INSERT WebUsuarios(  eMail, eMail2,  Telefono,  FechaAlta, UltimoCambio,  Empresa,  Sucursal,  Cliente, Contrasena, ContrasenaConfirmacion,  Nombre, Apellido, GUID)
SELECT               eMail, eMail2,  Telefono, FechaAlta, UltimoCambio,  Empresa,  Sucursal,  Cliente, Contrasena, ContrasenaConfirmacion , Nombre, Apellido, NEWID()
FROM  WebUsuarioTemp
WHERE Estacion = @Estacion
DECLARE crClientes CURSOR LOCAL FOR
SELECT Cliente FROM WebUsuarioTemp WHERE Estacion = @Estacion
OPEN crClientes
FETCH NEXT FROM crClientes INTO @Cliente
WHILE @@FETCH_STATUS = 0
BEGIN
EXEC speCommerceWebUsuarioNuevaDireccion @Cliente
FETCH NEXT FROM crClientes INTO @Cliente
END
CLOSE crClientes
DEALLOCATE crClientes
DELETE  WebUsuarioTemp WHERE Estacion = @Estacion
SELECT 'Se Generaron los Registros'
RETURN
END

