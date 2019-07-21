SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spOportunidadOportunidadGanar
@Empresa			varchar(5),
@Usuario			varchar(10),
@FechaEmision		datetime,
@FechaRegistro		datetime,
@Sucursal			int,
@ID					int,
@Accion				varchar(20),
@OrigenTipo			varchar(5),
@Origen				varchar(20),
@OrigenID			varchar(20),
@ContactoTipo		varchar(20),
@Contacto			varchar(10),
@Propuesta			varchar(50),
@Plantilla			varchar(20),
@IDPropuesta		int,
@Mensaje			int				OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
DECLARE @GenerarMov			bit,
@Movimiento			varchar(20),
@GenerarID			int,
@Autoriza				varchar(10)
SELECT @GenerarMov = ISNULL(GenerarMov, 0),
@Movimiento = Mov
FROM OportunidadPlantilla
WHERE Plantilla = @Plantilla
IF @Accion IN('AFECTAR', 'AUTORIZAR')
BEGIN
EXEC @GenerarID = spAfectar 'VTAS', @IDPropuesta, 'GENERAR', 'Todo', @Movimiento, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF (@Ok IS NULL OR @Ok = 80030) AND NULLIF(@GenerarID, 0) IS NOT NULL
BEGIN
SELECT @Ok = NULL, @OkRef = NULL
EXEC spAfectar 'VTAS', @GenerarID, 'AFECTAR', 'Todo', NULL, @Usuario = @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @Conexion = 1
IF @Accion = 'AUTORIZAR' AND @Ok IS NOT NULL
BEGIN
UPDATE Venta SET Mensaje = @Ok WHERE ID = @GenerarID
EXEC spAfectar 'VTAS', @GenerarID, 'AUTORIZAR', 'Todo', NULL, @Usuario = @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @Conexion = 1
END
END
IF @Ok IS NULL
UPDATE Oportunidad SET IDVTAS = @GenerarID WHERE ID = @ID
ELSE
SELECT @Mensaje = Mensaje FROM Venta WHERE ID = @GenerarID
END
ELSE IF @Accion = 'CANCELAR'
BEGIN
SELECT @GenerarID = IDVTAS FROM Oportunidad WHERE ID = @ID
IF NULLIF(@GenerarID, 0) IS NOT NULL
EXEC spAfectar 'VTAS', @GenerarID, 'CANCELAR', @Usuario = @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @Conexion = 1
END
EXEC xpOportunidadOportunidadGanar @Empresa, @Usuario, @FechaEmision, @FechaRegistro, @Sucursal, @ID, @Accion, @OrigenTipo, @Origen, @OrigenID, @ContactoTipo, @Contacto, @Propuesta, @Plantilla, @IDPropuesta, @Mensaje OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

