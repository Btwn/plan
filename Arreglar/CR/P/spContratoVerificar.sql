SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContratoVerificar
@ID				int,
@Accion				char(20),
@Empresa			char(5),
@Usuario			char(10),
@Modulo				char(5),
@Mov				char(20),
@MovID				varchar(20),
@MovTipo			char(20),
@FechaEmision			datetime,
@Estatus			char(15),
@EstatusNuevo			char(15),
@ContactoTipo			varchar(20),
@Prospecto			varchar(10),
@Cliente			varchar(10),
@Proveedor			varchar(10),
@Personal			varchar(10),
@Agente				varchar(10),
@ContratoRama			varchar(50),
@Desde				datetime,
@Hasta				datetime,
@Prioridad			varchar(10),
@Titulo				varchar(100),
@Contrato			varchar(50),
@IDOrigen			int,
@RamaID				int,
@OrigenTipo			varchar(20),
@Origen				varchar(20),
@OrigenID			varchar(20),
@FechaRegistro			datetime,
@Conexion			bit,
@SincroFinal			bit,
@Sucursal			int,
@Ok				int		OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS BEGIN
DECLARE
@ODesde			datetime,
@OHasta			datetime
IF @Desde IS NULL SELECT @Ok = 55240, @OkRef = 'Desde'
IF @Ok IS NULL AND @Hasta IS NULL SELECT @Ok = 55240, @OkRef = 'Hasta'
IF @Ok IS NULL AND @Desde > @Hasta SELECT @Ok = 51010, @OkRef = 'Hasta'
IF @Ok IS NULL AND @OrigenTipo = 'PACTO' AND @Origen IS NOT NULL AND @OrigenID IS NOT NULL
BEGIN
SELECT @ODesde = Desde, @OHasta = Hasta FROM Contrato WHERE ID = @IDOrigen
EXEC spExtraerFecha @ODesde OUTPUT
EXEC spExtraerFecha @OHasta OUTPUT
EXEC spExtraerFecha @Desde OUTPUT
EXEC spExtraerFecha @Hasta OUTPUT
IF @Desde < @ODesde SELECT @Ok = 55090, @OkRef = 'Desde' 
IF @Hasta < @OHasta SELECT @Ok = 55090, @OkRef = 'Hasta'
END
IF @Ok IS NULL AND @Contrato IS NOT NULL AND @Accion IN ('AFECTAR', 'VERIFICAR') AND @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @EstatusNuevo IN ('PENDIENTE', 'VIGENTE', 'VENCIDO')
IF EXISTS(SELECT * FROM Contrato WHERE UPPER(RTRIM(Contrato)) = UPPER(@Contrato) AND Estatus IN ('PENDIENTE', 'VIGENTE', 'VENCIDO'))
SELECT @Ok = 28030, @OkRef = 'Contrato'
IF @Ok IS NULL AND (SELECT Estatus FROM Contrato WHERE Mov = @Origen AND MovID = @OrigenID) = 'CANCELADO' AND @Accion IN ('AFECTAR', 'GENERAR')
SELECT @Ok = 60040, @OkRef = 'Origen Cancelado'
IF @Ok IS NULL AND @Accion = 'CANCELAR' AND @Estatus IN ('PENDIENTE', 'VIGENTE', 'VENCIDO') AND @EstatusNuevo = 'CANCELADO' AND @MovTipo = 'PACTO.C'
BEGIN
IF EXISTS(SELECT * FROM Contrato c WHERE c.Origen = @Mov AND c.OrigenID = @MovID AND c.Estatus IN ('PENDIENTE', 'VIGENTE', 'VENCIDO'))
SELECT @Ok = 30151
END
IF @Ok IS NULL AND @Accion IN ('AFECTAR', 'VERIFICAR') AND @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR')  AND @Origen IS NOT NULL AND @OrigenID IS NOT NULL
IF EXISTS(SELECT * FROM Contrato c WHERE c.Estatus IN ('PENDIENTE', 'VIGENTE', 'VENCIDO') AND c.Origen = @Origen AND c.OrigenID = @OrigenID )
SELECT @Ok = 73050
IF @Ok IS NULL
EXEC xpContratoVerificar	@ID, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo, @FechaEmision, @Estatus, @EstatusNuevo,
@ContactoTipo, @Prospecto, @Cliente, @Proveedor, @Personal, @Agente, @ContratoRama,
@Desde, @Hasta, @Prioridad, /* @Comentarios, @Documento, */ @Titulo, @Contrato,
@IDOrigen, @RamaID, @OrigenTipo, @Origen, @OrigenID,
@FechaRegistro, @Conexion, @SincroFinal, @Sucursal, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

