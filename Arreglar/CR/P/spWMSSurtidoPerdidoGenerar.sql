SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSSurtidoPerdidoGenerar
@ID					int,
@Tarima				varchar(20),
@PCK				float,
@Cantidad			float,
@Renglon			int,
@Ok					int            OUTPUT,
@OkRef				varchar(255)   OUTPUT

AS BEGIN
DECLARE
@Empresa				char(5),
@Usuario				varchar(20),
@Sucursal				int,
@IDGenerar				int,
@MovGenerar				varchar(20),
@CantidadAnterior		float,
@CantidadResurtir		float,
@IDGenerarResurtido		int,
@FechaRegistro			datetime
SELECT @Empresa			= Empresa,
@Usuario			= Usuario,
@Sucursal			= Sucursal,
@FechaRegistro		= dbo.fnFechaSinHora(GETDATE()),
@CantidadResurtir	= 0
FROM TMA
WHERE ID = @ID
IF @PCK = 0
BEGIN
SELECT @CantidadAnterior = ISNULL(NULLIF(CantidadPendiente,0), CantidadPicking) FROM TMAD WHERE ID = @ID AND Tarima = @Tarima AND Renglon = @Renglon
SELECT @CantidadResurtir = @CantidadAnterior - @Cantidad
UPDATE TMAD SET CantidadA = 1 WHERE ID = @ID AND Tarima = @Tarima AND Renglon = @Renglon
END
ELSE
IF @PCK = 1
UPDATE TMAD SET CantidadA = @Cantidad WHERE ID = @ID AND Tarima = @Tarima AND Renglon = @Renglon
SELECT @MovGenerar = TMASurtidoPerdido FROM EmpresaCfgMovWMS WHERE Empresa = @Empresa
IF @OK IS NULL
EXEC @IDGenerar = spAfectar 'TMA', @ID, 'GENERAR', 'Seleccion', @MovGenerar, @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok = 80030
SELECT @OK = NULL
IF @OK IS NULL
EXEC spAfectar 'TMA', @IDGenerar, 'AFECTAR', 'Todo', @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @OK IS NULL AND @CantidadResurtir > 0
BEGIN
EXEC @IDGenerarResurtido = spMovCopiar @Sucursal, 'TMA', @ID, @Usuario, @FechaRegistro, 1
UPDATE TMAD SET Tarima = @Tarima, CantidadPicking = @CantidadResurtir WHERE ID = @IDGenerarResurtido AND Renglon = @Renglon
EXEC spAfectar 'TMA', @IDGenerarResurtido, 'AFECTAR', 'Todo', @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
RETURN
END

