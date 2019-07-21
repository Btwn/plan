SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAccesoOk
@Empresa		VARCHAR(5),
@Sucursal		INT,
@Usuario	    VARCHAR(10),
@FechaTrabajo	DATETIME,
@AccesoID		INT

AS BEGIN
DECLARE
@Hoy		DATETIME,
@Estacion	INT
SELECT @Hoy = dbo.fnFechaSinHora(GETDATE())
UPDATE Usuario WITH(ROWLOCK) SET UltimoAcceso = @Hoy WHERE Usuario = @Usuario
SELECT @Estacion = EstacionTrabajo FROM Acceso WITH(NOLOCK) WHERE ID = @AccesoID
UPDATE AccesoMes SET Empresa = @Empresa, Usuario = @Usuario, FechaRegistro = GETDATE() WHERE ID = @AccesoID
IF @@ROWCOUNT = 0
INSERT INTO AccesoMes(ID, Empresa, Usuario, FechaRegistro)
VALUES(@AccesoID, @Empresa, @Usuario, GETDATE())
EXEC spRepParamInicializar @Estacion, @Empresa, @Sucursal, @Usuario, @FechaTrabajo, @AccesoID
RETURN
END

