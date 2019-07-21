SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSAbrir
@Empresa   varchar(5),
@Usuario   varchar(10)

AS
BEGIN
DECLARE
@Host				varchar(20),
@ID					varchar(36),
@DefCajero			varchar(10),
@DefSucursal		int
SELECT @DefCajero = DefCajero, @DefSucursal = Sucursal
FROM Usuario
WHERE Usuario = @Usuario
SELECT TOP 1 @Host = Host
FROM POSiSync
SELECT TOP 1 @ID = ID
FROM POSL
WHERE Estatus = 'PENDIENTE' AND Cajero = @DefCajero AND Sucursal = @DefSucursal
ORDER BY FechaRegistro DESC
IF @ID IS NULL
SELECT TOP 1 @ID = ID
FROM POSL
WHERE Estatus = 'SINAFECTAR' AND Cajero = @DefCajero AND Sucursal = @DefSucursal
ORDER BY FechaRegistro DESC
SELECT @ID
END

