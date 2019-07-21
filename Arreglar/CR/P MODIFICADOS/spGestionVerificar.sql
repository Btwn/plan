SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGestionVerificar
@ID               		int,
@Accion			char(20),
@Empresa          		char(5),
@Usuario			char(10),
@Modulo	      		char(5),
@Mov              		varchar(20),
@MovID			varchar(20),
@MovTipo	      		varchar(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision		datetime,
@Estatus			char(15),
@EstatusNuevo		char(15),
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@MovUsuario			char(10),
@IDOrigen			int,
@OrigenTipo			varchar(10),
@Origen			varchar(20),
@OrigenID			varchar(20),
@OrigenMovTipo		varchar(20),
@OrigenFechaD		datetime,
@OrigenFechaA		datetime,
@OrigenTodoElDia		bit,
@OrigenHoraD		varchar(5),
@OrigenHoraA		varchar(5),
@Estado			varchar(30),
@Avance			float,
@FechaD			datetime,
@FechaA			datetime,
@TodoElDia			bit,
@HoraD			varchar(5),
@HoraA			varchar(5),
@Motivo			varchar(255),
@Ok               		int          OUTPUT,
@OkRef            		varchar(255) OUTPUT

AS BEGIN
DECLARE
@OrigenEstatus		varchar(15),
@CfgCompletarEnAvances	bit,
@SubClave			varchar(20),
@AFArticulo			varchar(20),
@AFSerie			varchar(50)
SELECT @SubClave = SubClave FROM MovTipo WITH(NOLOCK) WHERE Mov = @Mov AND Modulo = @Modulo
SELECT @AfArticulo = ISNULL(AfArticulo,''), @AfSerie = ISNULL(AfSerie,'') FROM Gestion WHERE ID = @ID
SELECT @CfgCompletarEnAvances = ISNULL(PermiteCompletarEnAvances, 0)
FROM EmpresaCfg
WITH(NOLOCK) WHERE Empresa = @Empresa
IF @Accion = 'CANCELAR'
BEGIN
IF @Conexion = 0
IF EXISTS (SELECT * FROM MovFlujo WITH(NOLOCK) WHERE Cancelado = 0 AND Empresa = @Empresa AND DModulo = @Modulo AND DID = @ID AND OModulo <> DModulo AND OModulo <> 'PROY')
SELECT @Ok = 60070
IF @MovTipo = 'GES.MOD' SELECT @Ok = 46070
IF @MovTipo = 'GES.AV' AND @Ok IS NULL
IF EXISTS(SELECT * FROM Gestion g  WITH(NOLOCK) JOIN MovTipo mt  WITH(NOLOCK) ON mt.Modulo = @Modulo AND mt.Mov = g.Mov WHERE g.IDOrigen = @IDOrigen AND g.Estatus = 'CONCLUIDO' AND mt.Clave = 'GES.TE')
SELECT @Ok = 46160, @OkRef = @Origen + ' ' + @OrigenID
END ELSE
BEGIN
IF @MovTipo IN ('GES.SRES') AND @Estatus = 'SINAFECTAR' AND @SubClave IN ('MAF.SI') AND EXISTS(SELECT * FROM Gestion g  WITH(NOLOCK) JOIN MovTipo mt  WITH(NOLOCK) ON g.Mov = mt.Mov WHERE g.Estatus IN ('PENDIENTE') AND mt.Clave IN ('GES.SRES') AND mt.SubClave IN ('MAF.SI') AND AFArticulo = @AfArticulo AND AFSerie = @AFSerie)
SELECT @Ok = 46220
IF @MovTipo IN ('GES.SRES') AND @Estatus = 'SINAFECTAR' AND @SubClave IN ('MAF.SI') AND NOT EXISTS(SELECT * FROM GestionActivoFIndicador WITH(NOLOCK) WHERE ID = @ID)
SELECT @Ok = 46200
IF @MovTipo IN ('GES.RES') AND @Estatus = 'SINAFECTAR' AND @SubClave IN ('MAF.I') AND EXISTS(SELECT * FROM GestionActivoFIndicador WITH(NOLOCK) WHERE ID = @ID AND NULLIF(Lectura,'') IS NULL)
SELECT @Ok = 46210
IF @MovTipo IN ('GES.RES') AND @Estatus = 'SINAFECTAR' AND @SubClave IN ('MAF.I') AND @Origen IS NULL
SELECT @Ok = 46020
IF @MovTipo = 'GES.NO' AND @OrigenMovTipo = 'GES.OTAR'
SELECT @Ok = 46190
ELSE
IF @MovTipo IN ('GES.MOD', 'GES.NO', 'GES.AV', 'GES.TE')
BEGIN
IF @IDOrigen IS NULL SELECT @Ok = 46020 ELSE
IF @MovTipo = 'GES.MOD' AND NOT EXISTS(SELECT * FROM Gestion WITH(NOLOCK) WHERE ID = @IDOrigen AND Estatus IN ('PENDIENTE', 'ALTAPRIORIDAD', 'PRIORIDADBAJA')) SELECT @Ok = 46060
END ELSE
IF @MovTipo IN ('GES.SRES', 'GES.STAR', 'GES.OTAR')
BEGIN
IF NOT EXISTS(SELECT * FROM GestionPara WITH(NOLOCK) WHERE ID = @ID)
SELECT @Ok = 46010
END
IF @MovTipo IN ('GES.STAR', 'GES.OTAR')
BEGIN
IF (SELECT COUNT(*) FROM GestionPara WHERE ID = @ID) > 1
SELECT @Ok = 46180
END
IF @OrigenMovTipo IN ('GES.SRES', 'GES.REU', 'GES.STAR', 'GES.OTAR') AND @MovTipo <> 'GES.MOD' AND @Ok IS NULL AND (@Usuario <> @MovUsuario OR @MovTipo IN ('GES.RES', 'GES.TAR', 'GES.OK', 'GES.NO'))
BEGIN
IF NOT EXISTS(SELECT * FROM GestionPara WITH(NOLOCK) WHERE ID = @IDOrigen AND Usuario = @Usuario)
SELECT @Ok = 46080
ELSE
IF EXISTS(SELECT * FROM GestionPara WITH(NOLOCK) WHERE ID = @IDOrigen AND Usuario = @Usuario AND RespuestaID IS NOT NULL)
SELECT @Ok = 46085
END
IF @MovTipo = 'GES.REU' AND @Ok IS NULL
BEGIN
IF @FechaD IS NULL OR @FechaA IS NULL SELECT @Ok = 46100
END
IF @MovTipo IN ('GES.STAR', 'GES.OTAR') AND @Ok IS NULL
BEGIN
IF @FechaA IS NULL SELECT @Ok = 46100
END
IF @MovTipo = 'GES.NO' AND @Motivo IS NULL AND @Ok IS NULL
SELECT @Ok = 46110
IF @MovTipo IN ('GES.REU', 'GES.TAR', 'GES.AV') AND @CfgCompletarEnAvances = 0 AND dbo.fnTareaEstadoEnEstatus(@Estado) <> 'PENDIENTE' AND @Ok IS NULL
SELECT @Ok = 46120, @OkRef = @Origen
IF @Ok IS NULL
EXEC spGestionChecarOrigen @ID, @FechaA, @Ok OUTPUT, @OkRef OUTPUT
IF ((@MovTipo = 'GES.OK') OR (@OrigenMovTipo IN ('GES.STAR', 'GES.OTAR') AND @MovTipo = 'GES.TAR')) AND @Ok IS NULL
BEGIN
IF @FechaD <> @OrigenFechaD OR @FechaA <> @OrigenFechaA OR @TodoElDia <> @OrigenTodoElDia OR @HoraD <> @OrigenHoraD OR @HoraA <> @OrigenHoraA
SELECT @Ok = 46150, @OkRef = 'Fechas'
END
IF (@OrigenMovTipo = 'GES.REU' AND @MovTipo = 'GES.OK') AND @Ok IS NULL
BEGIN
IF (SELECT Modulo, Mov, MovID FROM GestionAgenda WITH(NOLOCK) WHERE ID = @ID FOR XML RAW) <> (SELECT Modulo, Mov, MovID FROM GestionAgenda WITH(NOLOCK) WHERE ID = @IDOrigen FOR XML RAW)
SELECT @Ok = 46150, @OkRef = 'Agenda'
END
IF @MovTipo = 'GES.MOD' AND @OrigenMovTipo IN ('GES.SRES', 'GES.REU', 'GES.STAR', 'GES.OTAR') AND @Ok IS NULL
IF EXISTS(SELECT * FROM GestionPara WITH(NOLOCK) WHERE ID = @IDOrigen AND RespuestaID IS NOT NULL) SELECT @Ok = 46170
END
IF (@Accion = 'CANCELAR' OR @MovTipo = 'GES.MOD') AND @Ok IS NULL
IF EXISTS(SELECT *
FROM Gestion g
 WITH(NOLOCK) JOIN MovTipo mt  WITH(NOLOCK) ON mt.Modulo = 'GES' AND mt.Mov = g.Mov
WHERE g.IDOrigen = @ID AND g.Estatus IN ('PENDIENTE', 'ALTAPRIORIDAD', 'PRIORIDADBAJA', 'CONCLUIDO') AND mt.Clave <> 'GES.MOD')
SELECT @Ok = 46090, @OkRef = RTRIM(@Mov)+' '+ISNULL(RTRIM(@MovID), '')
RETURN
END

