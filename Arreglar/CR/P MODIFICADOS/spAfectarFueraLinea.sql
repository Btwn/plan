SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAfectarFueraLinea
@ID                  	int,
@Modulo	      		char(5),
@Accion			char(20),
@Base			char(20),
@FechaRegistro		datetime,
@GenerarMov			char(20),
@Usuario			char(10),
@Conexion			bit,
@SincroFinal			bit,
@Mov	      			char(20)	OUTPUT,
@MovID            		varchar(20)	OUTPUT,
@IDGenerar			int		OUTPUT,
@Ok				int		OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Sucursal	int,
@Estatus	varchar(15),
@FueraLinea	bit
SELECT @FueraLinea = ISNULL(FueraLinea, 0) FROM Version WITH(NOLOCK)
IF @MovID IS NULL AND @Ok IS NULL
BEGIN
EXEC spMovInfo @ID, @Modulo, @Sucursal = @Sucursal OUTPUT, @Estatus = @Estatus OUTPUT
IF @Accion = 'CANCELAR' AND @Estatus <> 'FUERALINEA' SELECT @Ok = 13
IF @Ok IS NULL
EXEC spConsecutivo 'Fuera Linea', @Sucursal, @MovID OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
IF @Accion = 'AFECTAR'
SELECT @Estatus = 'FUERALINEA'
ELSE
SELECT @Estatus = 'CANCELADO'
EXEC spAsignarSucursalEstatusEncabezado @ID, @Modulo, @Sucursal, @Estatus, @MovID
END
END
IF @FueraLinea = 0 AND @Ok IS NULL
SELECT @Ok = 12
RETURN
END

