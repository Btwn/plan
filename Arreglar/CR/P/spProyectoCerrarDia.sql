SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProyectoCerrarDia
@Sucursal		int,
@Empresa		char(5),
@Usuario		char(10),
@FechaTrabajo	datetime,
@Fecha		datetime,
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT

AS BEGIN
DECLARE
@ID		int
DECLARE crProyecto CURSOR FOR
SELECT p.ID
FROM Proyecto p
WHERE p.Estatus = 'PENDIENTE' AND EXISTS(SELECT * FROM ProyectoDArtMaterial pdam WHERE pdam.ID = p.ID)
OPEN crProyecto
FETCH NEXT FROM crProyecto INTO @ID
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
EXEC spProyGenerarSolicitudInventario @Sucursal, @Empresa, 'AFECTAR', @Usuario, @FechaTrabajo, @ID, @Ok OUTPUT, @OkRef OUTPUT
END
FETCH NEXT FROM crProyecto INTO @ID
END
CLOSE crProyecto
DEALLOCATE crProyecto
END

