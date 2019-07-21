SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMAFGenerarSolicitudInspeccion
@Empresa		varchar(5),
@Sucursal		int,
@Accion			varchar(20),
@AFArticulo		varchar(20),
@AFSerie		varchar(50),
@Usuario		varchar(10),
@Para			varchar(10),
@FechaVencimiento	datetime,
@IDOrigen		int,
@Ok			int		OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE	@MAFSolicitudInspeccion		varchar(20),
@FechaEmision			datetime,
@IDGenerar			int,
@MovIDGenerar			varchar(20),
@Origen				varchar(20),
@OrigenID			varchar(20),
@OrigenTipo			varchar(10)
IF @Accion = 'AFECTAR' AND NOT EXISTS(SELECT * FROM Gestion g WITH (NOLOCK)  JOIN MovTipo mt WITH (NOLOCK)  ON g.Mov = mt.Mov WHERE Clave = 'GES.SRES' AND SubClave = 'MAF.SI' AND g.Estatus = 'PENDIENTE' AND g.AFArticulo = @AFArticulo AND g.AFSerie = @AFSerie)
BEGIN
SET @FechaEmision = dbo.fnFechaSinHora(GETDATE())
IF @Para IS NULL
SELECT @Para = MAFInspeccionUsuario FROM Empresacfg2 WITH (NOLOCK) 
IF @Para IS NULL SELECT @Ok = 71010, @OkRef = 'Defina el Usuario Inspección en la configuración de Mantenimiento Activo Fijo de la empresa.'
IF @Ok IS NULL
BEGIN
SELECT @MAFSolicitudInspeccion = MAFSolicitudInspeccion FROM EmpresaCfgMov WITH (NOLOCK)  WHERE Empresa = @Empresa
IF NULLIF(@MAFSolicitudInspeccion,'') IS NULL SELECT @Ok = 14055, @OkRef = 'Defina el movimiento Solicitud Inspeccion en Movimientos por omisión.'
END
IF @Ok IS NULL
BEGIN
INSERT Gestion (Empresa,  Mov,                     FechaEmision,  Usuario,  Estatus,      Sucursal,  FechaA,            Prioridad, AFArticulo,  AFSerie)
VALUES (@Empresa, @MAFSolicitudInspeccion, @FechaEmision, @Usuario, 'SINAFECTAR', @Sucursal, @FechaVencimiento, 'Normal',  @AFArticulo, @AFSerie)
SET @IDGenerar = SCOPE_IDENTITY()
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
INSERT GestionPara (ID,         Usuario, Participacion)
VALUES (@IDGenerar, @Para,   'Requerido')
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
EXEC spMAFInsertarActivoFTipoIndicador @Empresa, @IDGenerar, @AFArticulo, @AFSerie, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL
EXEC spAfectar 'GES', @IDGenerar, @Accion, 'Todo', NULL, @Usuario, @@SPID, @Conexion = 1, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL AND @IDOrigen IS NOT NULL
BEGIN
SELECT @Origen = Mov, @OrigenID = MovID FROM Venta WITH (NOLOCK)  WHERE ID = @IDOrigen
SELECT @MovIDGenerar = MovID FROM Gestion WITH (NOLOCK)  WHERE ID = @IDGenerar
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, 'VTAS', @IDOrigen, @Origen, @OrigenID, 'GES', @IDGenerar, @MAFSolicitudInspeccion, @MovIDGenerar, @Ok OUTPUT
END
END
ELSE
BEGIN
IF @Accion = 'CANCELAR'
BEGIN
SELECT
@Origen = OMov,
@OrigenID = OMovID,
@MAFSolicitudInspeccion = DMov,
@MovIDGenerar = DMovID,
@IDGenerar = DID
FROM MovFlujo WITH (NOLOCK) 
WHERE OModulo = 'VTAS'
AND OID = @IDOrigen
AND DModulo = 'GES'
IF @Ok IS NULL
EXEC spAfectar 'GES', @IDGenerar, @Accion, 'Todo', NULL, @Usuario, @@SPID, @Conexion = 1, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, 'VTAS', @IDOrigen, @Origen, @OrigenID, 'GES', @IDGenerar, @MAFSolicitudInspeccion, @MovIDGenerar, @Ok OUTPUT
END
END
END

