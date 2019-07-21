SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPuedeEditarMovMatrizSucursal
@Sucursal		int,
@SucursalOrigen 	int,  
@ID			int,
@Modulo			char(5),
@Empresa		char(5),
@Usuario		char(10),
@Mov			char(20),
@Estatus		char(15),
@EnSilencio		bit = 0,
@PuedeEditar		bit = 0 OUTPUT,
@Aplicando		bit = 0

AS BEGIN
DECLARE
@SincroID		timestamp,
@SincroIDPaquete	timestamp,
@SincroC		int,
@SucursalPrincipal 	int,
@SucursalUsuario	int,
@Seguimiento	char(20),
@ChecarSincronizado	bit
SELECT @PuedeEditar = 1, @Seguimiento = NULL, @ChecarSincronizado = 0
IF (SELECT Sincro FROM Version) = 1
BEGIN
IF (NULLIF(RTRIM(@Mov), '') IS NOT NULL)
BEGIN
SELECT @PuedeEditar = 0
SELECT @SucursalPrincipal = Sucursal FROM Version
SELECT @SucursalUsuario = Sucursal FROM UsuarioSucursal WHERE Usuario = @Usuario
IF @Estatus = 'SINCRO'
BEGIN
IF @SucursalOrigen = @SucursalUsuario
SELECT @ChecarSincronizado = 1
END ELSE
BEGIN
IF @Modulo = 'CONT'
BEGIN
IF @SucursalPrincipal = 0
SELECT @PuedeEditar = 1
ELSE
SELECT @ChecarSincronizado = 1
END ELSE BEGIN
EXEC spSucursalMovSeguimiento @Sucursal, @Modulo, @Mov, @Seguimiento OUTPUT
IF @Seguimiento IS NOT NULL
BEGIN
IF (@Seguimiento = 'MATRIZ' AND @SucursalPrincipal = 0)
BEGIN
EXEC spSincroMovRegistro @Modulo, @ID
SELECT @PuedeEditar = 1
END ELSE SELECT @ChecarSincronizado = 1
END ELSE
IF @Sucursal = @SucursalUsuario
BEGIN
EXEC spSincroMovRegistro @Modulo, @ID
SELECT @PuedeEditar = 1
END
END
END
END
IF @Modulo <> 'CONT' AND @PuedeEditar = 0 AND @Seguimiento IS NULL AND (SELECT AfectarOtrasSucursalesEnLinea FROM Usuario WHERE Usuario = @Usuario) = 1
EXEC spSucursalEnLinea @Sucursal, @PuedeEditar OUTPUT
IF @PuedeEditar = 0 AND @ChecarSincronizado = 1
BEGIN
IF @Aplicando = 0 AND (SELECT Sincronizando FROM Version) = 0
BEGIN
EXEC spMovSincro @ID, @Modulo, @SincroID OUTPUT, @SincroC OUTPUT
IF @SincroC = 1
BEGIN
EXEC sp_executesql N'SELECT @SincroIDPaquete = ISNULL(MAX(SincroID), 0) FROM SincroPaquete WHERE Sucursal = @SucursalPrincipal',
N'@SincroIDPaquete timestamp OUTPUT, @SucursalPrincipal int',
@SincroIDPaquete = @SincroIDPaquete OUTPUT, @SucursalPrincipal = @SucursalPrincipal
IF @SincroID > (@SincroIDPaquete) SELECT @PuedeEditar = 1
END
END
END
END ELSE IF (SELECT SincroIS FROM Version) = 1
BEGIN
IF (NULLIF(RTRIM(@Mov), '') IS NOT NULL)
BEGIN
SELECT @PuedeEditar = 0
SELECT @SucursalPrincipal = Sucursal FROM Version
SELECT @SucursalUsuario = Sucursal FROM UsuarioSucursal WHERE Usuario = @Usuario
IF @Estatus = 'SINCRO'
BEGIN
IF @SucursalOrigen = @SucursalUsuario
SELECT @ChecarSincronizado = 1
END ELSE
BEGIN
IF @Modulo = 'CONT'
BEGIN
IF @SucursalPrincipal = 0
SELECT @PuedeEditar = 1
ELSE
SELECT @ChecarSincronizado = 1
END ELSE BEGIN
EXEC spSucursalMovSeguimiento @Sucursal, @Modulo, @Mov, @Seguimiento OUTPUT
IF @Seguimiento IS NOT NULL
BEGIN
IF (@Seguimiento = 'MATRIZ' AND @SucursalPrincipal = 0)
BEGIN
EXEC spSincroMovRegistro @Modulo, @ID
SELECT @PuedeEditar = 1
END ELSE SELECT @ChecarSincronizado = 1
END ELSE
IF @Sucursal = @SucursalUsuario
BEGIN
EXEC spSincroMovRegistro @Modulo, @ID
SELECT @PuedeEditar = 1
END
END
END
END
IF @Modulo <> 'CONT' AND @PuedeEditar = 0 AND @Seguimiento IS NULL AND (SELECT AfectarOtrasSucursalesEnLinea FROM Usuario WHERE Usuario = @Usuario) = 1
EXEC spSucursalEnLinea @Sucursal, @PuedeEditar OUTPUT
IF @PuedeEditar = 0 AND @ChecarSincronizado = 1
BEGIN
IF @Aplicando = 0 AND dbo.fnEstaSincronizando() = 0
BEGIN
EXEC spMovSincro @ID, @Modulo, @SincroID OUTPUT, @SincroC OUTPUT
EXEC sp_executesql N'SELECT @SincroIDPaquete = ISNULL(MAX(SincroID), 0) FROM SincroISControl WHERE SucursalOrigen = @SucursalPrincipal',
N'@SincroIDPaquete timestamp OUTPUT, @SucursalPrincipal int',
@SincroIDPaquete = @SincroIDPaquete OUTPUT, @SucursalPrincipal = @SucursalPrincipal
IF @SincroID > (@SincroIDPaquete) SELECT @PuedeEditar = 1
END
END
END
IF @EnSilencio = 0 SELECT "PuedeEditar" = @PuedeEditar
RETURN
END

