SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spOportunidadPropuestaConcluir
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
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
DECLARE @IDVTAS			int,
@IDVTASAnt		int
SELECT @IDVTASAnt = 0
WHILE(1=1)
BEGIN
SELECT @IDVTAS = MIN(ID)
FROM Venta
WHERE IDOPORT = @ID
AND Empresa = @Empresa
AND ID <> @IDPropuesta
AND Estatus = 'CONFIRMAR'
AND ID > @IDVTASAnt
IF @IDVTAS IS NULL BREAK
SELECT @IDVTASAnt = @IDVTAS
EXEC spAfectar 'VTAS', @IDVTAS, 'AFECTAR', 'Todo', NULL, @Usuario = @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @Conexion = 1
END
RETURN
END

