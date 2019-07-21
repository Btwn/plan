SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProyectoVerificar
@ID              		int,
@Accion			char(20),
@Empresa          		char(5),
@Usuario			char(10),
@Modulo	      		char(5),
@Mov              		char(20),
@MovID			varchar(20),
@MovTipo	      		char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision		datetime,
@OrigenTipo                 varchar(5),
@Origen                     varchar(20),
@OrigenID                   varchar(20),
@Estatus			char(15),
@EstatusNuevo		char(15),
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@Proyecto	      		varchar(50),
@ProyectoSugerir		varchar(20),
@ProyectoReestructurar      varchar(50),
@Reestructurar              bit,
@Ok               		int          OUTPUT,
@OkRef            		varchar(255) OUTPUT

AS BEGIN
DECLARE
@ContactoTipo	varchar(20),
@Prospecto		varchar(10),
@Cliente		varchar(10),
@Proveedor		varchar(10),
@Personal		varchar(10),
@Agente		varchar(10),
@Riesgo             varchar(20),
@ProyectoRama       varchar(50),
@Supervisor		varchar(10),
@Comienzo		datetime,
@OrigenProyecto     varchar(50)
SELECT @Prospecto = NULLIF(RTRIM(Prospecto), ''), @Cliente = NULLIF(RTRIM(Cliente), ''), @Proveedor = NULLIF(RTRIM(Proveedor), ''), @Personal = NULLIF(RTRIM(Personal), ''),
@Agente = NULLIF(RTRIM(Agente), ''), @Supervisor = NULLIF(RTRIM(Supervisor), ''), @Riesgo = NULLIF(RTRIM(Riesgo), ''), @ProyectoRama = NULLIF(RTRIM(ProyectoRama), ''),
@Comienzo = Comienzo, @ContactoTipo = NULLIF(RTRIM(ContactoTipo), '')
FROM Proyecto
WHERE ID = @ID
IF @OrigenTipo IS NOT NULL AND @Origen IS NOT NULL AND @OrigenID IS NOT NULL
BEGIN
IF @OrigenTipo = 'PROY' AND NOT EXISTS (SELECT * FROM Proyecto WHERE Mov = @Origen AND MovID = @OrigenID AND Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR'))
SELECT @Ok = 20380
END
IF @Accion = 'CANCELAR'
BEGIN
IF @Conexion = 0
IF EXISTS (SELECT * FROM MovFlujo WHERE Cancelado = 0 AND Empresa = @Empresa AND DModulo = @Modulo AND DID = @ID AND OModulo <> DModulo)
SELECT @Ok = 60070
IF EXISTS (SELECT * FROM Proyecto WHERE Origen = @Mov AND OrigenID = @MovID AND OrigenTipo = @Modulo AND Estatus IN ('PENDIENTE', 'CONCLUIDO'))
SELECT @Ok = 30151
END ELSE
BEGIN
IF @Reestructurar = 0
BEGIN
IF @ProyectoSugerir = 'ABIERTO'
IF EXISTS(SELECT * FROM Proy WHERE Proyecto = @Proyecto) OR EXISTS(SELECT * FROM Proyecto WHERE Proyecto = @Proyecto AND Estatus IN ('PENDIENTE', 'CONCLUIDO'))
SELECT @Ok = 26025, @OkRef = @Proyecto
END ELSE
BEGIN
IF @ProyectoReestructurar IS NULL
SELECT @Ok = 15010, @OkRef = 'Movimiento: ' + RTRIM(@Mov)
IF NOT EXISTS (SELECT * FROM Proy WHERE Proyecto = @ProyectoReestructurar) AND NOT EXISTS (SELECT * FROM Proyecto WHERE Proyecto = @ProyectoReestructurar AND Estatus = 'PENDIENTE')
SELECT @Ok = 15012, @OkRef = @Proyecto ELSE
IF @Ok IS NOT NULL AND (SELECT Estatus FROM Proyecto WHERE Proyecto = @ProyectoReestructurar) = 'REESTRUCTURADO'
SELECT @Ok = 15015, @OkRef = @ProyectoReestructurar ELSE
IF @Ok IS NOT NULL AND (SELECT Estatus FROM Proyecto WHERE Proyecto = @ProyectoReestructurar) = 'BAJA'
SELECT @Ok = 26020, @OkRef = @ProyectoReestructurar ELSE
IF @Ok IS NOT NULL AND (SELECT Estatus FROM Proyecto WHERE Proyecto = @ProyectoReestructurar) = 'BLOQUEADO'
SELECT @Ok = 26010, @OkRef = @ProyectoReestructurar
END
IF @Ok IS NULL
BEGIN
IF @ContactoTipo IS NULL SELECT @Ok = 40001 ELSE
IF @ContactoTipo = 'PROSPECTO'  AND @Prospecto    IS NULL SELECT @Ok = 40005 ELSE
IF @ContactoTipo = 'CLIENTE'    AND @Cliente      IS NULL SELECT @Ok = 40010 ELSE
IF @ContactoTipo = 'PROVEEDOR'  AND @Proveedor    IS NULL SELECT @Ok = 40020 ELSE
IF @ContactoTipo = 'PERSONAL'   AND @Personal     IS NULL SELECT @Ok = 40025 ELSE
IF @ContactoTipo = 'AGENTE'     AND @Agente       IS NULL SELECT @Ok = 20930 ELSE
IF @ContactoTipo = 'RIESGO'     AND @Riesgo       IS NULL SELECT @Ok = 15050 ELSE
IF @ContactoTipo = 'PROYECTO'   AND @ProyectoRama IS NULL SELECT @Ok = 15014 ELSE
IF @ContactoTipo = 'PROYECTO'   AND (SELECT Tipo FROM Proy WHERE Proyecto = @ProyectoRama) = 'SubProyecto' SELECT @Ok = 15020 ELSE
IF @Comienzo   IS NULL SELECT @Ok = 41020 ELSE
IF @Supervisor IS NULL SELECT @Ok = 41010 ELSE
IF NOT EXISTS(SELECT * FROM ProyectoD WHERE ID = @ID)  SELECT @Ok = 60010
END
IF @Ok IS NULL
EXEC spProyectoDVerificar @ID, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
RETURN
END

