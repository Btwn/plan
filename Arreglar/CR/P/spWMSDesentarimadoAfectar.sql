SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSDesentarimadoAfectar
@IDGenerar			int,
@Ok					int          OUTPUT,
@OkRef				varchar(255) OUTPUT

AS BEGIN
DECLARE
@Empresa			char(5),
@Usuario			varchar(20),
@Almacen			varchar(20),
@Sucursal			int,
@MovOrigen			varchar(20),
@MovIDOrigen		varchar(20),
@IDOrdenEntarimado	int,
@MovEntarimado		varchar(20),
@IDEntarimado		int,
@IDSolAcomodo		int
SELECT @Empresa  =  Empresa,
@Usuario  =  Usuario,
@Almacen  =  Almacen,
@Sucursal =  Sucursal
FROM Inv
WHERE ID = @IDGenerar
IF @Ok IS NULL AND @IDGenerar IS NOT NULL
EXEC spAfectar 'INV', @IDGenerar, 'AFECTAR', 'Todo', @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @MovOrigen		= Mov,
@MovIDOrigen	= MovID
FROM Inv
WHERE ID = @IDGenerar
SELECT @IDOrdenEntarimado = ID FROM  Inv WHERE Origen = @MovOrigen AND OrigenID = @MovIDOrigen AND Empresa = @Empresa
SELECT @MovEntarimado = InvEntarimado FROM EmpresaCfgMov WHERE Empresa = @Empresa
IF @Ok IS NULL AND @IDOrdenEntarimado IS NOT NULL AND @MovEntarimado IS NOT NULL
EXEC @IDEntarimado = spAfectar 'INV', @IDOrdenEntarimado, 'GENERAR', 'Pendiente', @MovEntarimado, @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
UPDATE SerieLoteMov SET RenglonID = RenglonID + 1 WHERE Modulo = 'INV' AND ID = @IDEntarimado AND Empresa = @Empresa
IF @Ok IN(NULL, 80030) AND @IDEntarimado IS NOT NULL
EXEC spAfectar 'INV', @IDEntarimado, 'AFECTAR', 'Todo', @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @MovOrigen		= Mov,
@MovIDOrigen	= MovID
FROM Inv
WHERE ID = @IDEntarimado
SELECT @IDSolAcomodo = ID FROM TMA WHERE Origen = @MovOrigen AND OrigenID = @MovIDOrigen AND Empresa = @Empresa
RETURN
END

