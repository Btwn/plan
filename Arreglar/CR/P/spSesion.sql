SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSesion
@Accion			varchar(20),		
@Sesion			int		OUTPUT,
@Empresa		char(5),
@Sucursal		int,
@Usuario		varchar(10),
@FechaTrabajo		datetime,
@EstacionTrabajo	int		= NULL,
@IP			varchar(20)	= NULL

AS BEGIN
IF @Accion = 'LOGIN'
BEGIN
INSERT Sesion (
Empresa,  Sucursal,  Usuario,  FechaTrabajo,  EstacionTrabajo,  IP,  Estatus)
VALUES (@Empresa, @Sucursal, @Usuario, @FechaTrabajo, @EstacionTrabajo, @IP, 'ALTA')
SELECT @Sesion = SCOPE_IDENTITY()
END ELSE
IF @Accion = 'LOGOUT'
UPDATE Sesion SET Estatus = 'BAJA' WHERE Sesion = @Sesion
ELSE
IF @Accion = 'BLOQUEAR'
UPDATE Sesion SET Estatus = 'BLOQUEADO' WHERE Sesion = @Sesion
END

