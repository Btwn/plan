SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProyectoAfectar
@ID                		int,
@Accion				char(20),
@Base				char(20),
@Empresa	      		char(5),
@Modulo	      			char(5),
@Mov	  	      		char(20),
@MovID             		varchar(20)		OUTPUT,
@MovTipo     			char(20),
@MovMoneda			char(10),
@MovTipoCambio			float,
@FechaEmision      		datetime,
@FechaAfectacion      		datetime,
@FechaConclusion		datetime,
@Proyecto	      		varchar(50),
@ProyectoSugerir		varchar(20),
@ProyectoReestructurar          varchar(50),
@Reestructurar                  bit,
@Usuario	      		char(10),
@Autorizacion      		char(10),
@DocFuente	      		int,
@Observaciones     		varchar(255),
@Concepto     			varchar(50),
@Referencia			varchar(50),
@Estatus           		char(15),
@EstatusNuevo	      		char(15),
@FechaRegistro     		datetime,
@Ejercicio	      		int,
@Periodo	      		int,
@MovUsuario			char(10),
@OrigenTipo                     varchar(5),
@Origen                         varchar(20),
@OrigenID                       varchar(20),
@Conexion			bit,
@SincroFinal			bit,
@Sucursal			int,
@SucursalDestino		int,
@SucursalOrigen			int,
@CfgContX			bit,
@CfgContXGenerar		char(20),
@GenerarPoliza			bit,
@Generar			bit,
@GenerarMov			char(20),
@GenerarAfectado		bit,
@IDGenerar			int	     	OUTPUT,
@GenerarMovID	  		varchar(20)	OUTPUT,
@Ok                		int             OUTPUT,
@OkRef             		varchar(255)    OUTPUT,
@Estacion			int

AS BEGIN
DECLARE
@CancelarID			int,
@FechaCancelacion		datetime,
@GenerarMovTipo		char(20),
@GenerarPeriodo		int,
@GenerarEjercicio		int,
@Comienzo                   datetime,
@Fin                        datetime,
@p                          int,
@Max                        int,
@ProyectoMaster             varchar(50),
@IDOrigen                   int,
@OrigenEstatus              varchar(15),
@ProyectoReestructurarID    int,
@MovIDMaster                varchar(20),
@ContactoTipo               varchar(20),
@Prospecto		        varchar(10),
@Cliente		        varchar(10),
@Proveedor		        varchar(10),
@Personal		        varchar(10),
@Agente		        varchar(10),
@Riesgo                     varchar(20),
@ProyectoRama               varchar(50),
@ProyectoTipo               varchar(20),
@Descripcion		varchar(100),
@MovOrigen          varchar(20),
@ClaveOrigen        varchar(20)
SELECT @Comienzo = Comienzo, @Fin = Fin FROM Proyecto WHERE ID = @ID
SELECT @IDOrigen = ID, @OrigenEstatus = Estatus FROM Proyecto WHERE Mov = @Origen AND MovID = @OrigenID AND Empresa = @Empresa AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR', 'CANCELADO')
SELECT @MovOrigen = Mov
FROM Proyecto
WHERE ID = @IDOrigen
SELECT @ClaveOrigen = Clave
FROM MovTipo
WHERE Modulo = @Modulo
AND Mov = @MovOrigen
SELECT @Prospecto = NULLIF(RTRIM(Prospecto), ''), @Cliente = NULLIF(RTRIM(Cliente), ''), @Proveedor = NULLIF(RTRIM(Proveedor), ''), @Personal = NULLIF(RTRIM(Personal), ''),
@Agente = NULLIF(RTRIM(Agente), ''), @Riesgo = NULLIF(RTRIM(Riesgo), ''), @ProyectoRama = NULLIF(RTRIM(ProyectoRama), ''),
@ContactoTipo = NULLIF(RTRIM(ContactoTipo), ''), @ProyectoTipo = CASE WHEN @ContactoTipo = 'Proyecto' THEN 'SubProyecto' ELSE 'Proyecto' END,
@Descripcion = Descripcion
FROM Proyecto
WHERE ID = @ID
EXEC spMovConsecutivo @Sucursal, @SucursalOrigen, @SucursalDestino, @Empresa, @Usuario, @Modulo, @Ejercicio, @Periodo, @ID, @Mov, NULL, @Estatus, @Concepto, @Accion, @Conexion, @SincroFinal, @MovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR') AND @Accion <> 'CANCELAR' AND @Ok IS NULL
EXEC spMovChecarConsecutivo	@Empresa, @Modulo, @Mov, @MovID, NULL, @Ejercicio, @Periodo, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion IN ('CONSECUTIVO', 'SINCRO') AND @Ok IS NULL
BEGIN
IF @Accion = 'SINCRO' EXEC spAsignarSucursalEstatus @ID, @Modulo, @SucursalDestino, @Accion
SELECT @Ok = 80060, @OkRef = @MovID
RETURN
END
IF @OK IS NOT NULL RETURN
IF @Accion = 'GENERAR' AND @Ok IS NULL
BEGIN
EXEC spMovGenerar @Sucursal, @Empresa, @Modulo, @Ejercicio, @Periodo, @Usuario, @FechaRegistro, 'SINAFECTAR',
NULL, NULL,
@Mov, @MovID, 0,
@GenerarMov, NULL, @GenerarMovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spMovTipo @Modulo, @GenerarMov, @FechaAfectacion, @Empresa, NULL, NULL, @GenerarMovTipo OUTPUT, @GenerarPeriodo OUTPUT, @GenerarEjercicio OUTPUT, @Ok OUTPUT
IF @Ok IS NULL
SELECT @Ok = 80030, @OkRef = @GenerarMov
IF @MovTipo = 'PROY.P' AND @GenerarMovTipo = 'PROY.R'
EXEC spMovCopiarDetalle @Sucursal, @Modulo, @ID, @IDGenerar, @Usuario
EXEC spMovCopiarDetalle @Sucursal, @Modulo, @ID, @IDGenerar, @Usuario
EXEC spMovCopiarFormaAnexa @Modulo, @ID, @IDGenerar
EXEC spMovCopiarProyecto @Empresa, @Sucursal, @ID, @IDGenerar
IF @Mov = @GenerarMov
BEGIN
SELECT @p = CHARINDEX('-', @MovID)
IF @p > 0
SELECT @MovIDMaster = SUBSTRING(@MovID, 1, @p-1)
ELSE
SELECT @MovIDMaster = @MovID
SELECT @Max = ISNULL(MAX(CONVERT(int, SUBSTRING(MovID, LEN(@MovIDMaster)+2, 20))), 0)
FROM Proyecto
WHERE MovID LIKE RTRIM(@MovIDMaster)+'-%'
AND Mov = @GenerarMov
AND Empresa = @Empresa
AND Estatus IN ('PENDIENTE', 'CONCLUIDO', 'CANCELADO')
SELECT @GenerarMovID = RTRIM(@MovIDMaster)+'-'+CONVERT(varchar, @Max+1)
END ELSE
SELECT @GenerarMovID = NULL
IF @MovID IS NOT NULL
UPDATE Proyecto SET MovID = @GenerarMovID, Proyecto = @Proyecto, Reestructurar = 1, ProyectoReestructurar = @Proyecto WHERE ID = @IDGenerar
UPDATE ProyectoD SET EsNuevo = 0 WHERE ID = @IDGenerar
RETURN
END
IF @Reestructurar = 0 AND (@ProyectoSugerir = 'MOVIMIENTO' OR (@ProyectoSugerir = 'ABIERTO' AND @Proyecto IS NULL))
SELECT @Proyecto = RTRIM(@Mov)+' '+RTRIM(@MovID)
IF @Conexion = 0
BEGIN TRANSACTION
EXEC spMovEstatus @Modulo, 'AFECTANDO', @ID, @Generar, @IDGenerar, @GenerarAfectado, @Ok OUTPUT
IF @Accion = 'CANCELAR'
BEGIN
DECLARE crProyectoCancelar CURSOR LOCAL FOR
SELECT ID
FROM Proyecto
WHERE OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
OPEN crProyectoCancelar
FETCH NEXT FROM crProyectoCancelar INTO @CancelarID
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
EXEC spAfectar @Modulo, @CancelarID, 'CANCELAR', @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
FETCH NEXT FROM crProyectoCancelar INTO @CancelarID
END
CLOSE crProyectoCancelar
DEALLOCATE crProyectoCancelar
END
IF @Accion <> 'CANCELAR'
EXEC spRegistrarMovimiento @Sucursal, @Empresa, @Modulo, @Mov, @MovID, @ID, @Ejercicio, @Periodo, @FechaRegistro, @FechaEmision,
NULL, @Proyecto, @MovMoneda, @MovTipoCambio,
@Usuario, @Autorizacion, NULL, @DocFuente, @Observaciones,
@Generar, @GenerarMov, @GenerarMovID, @IDGenerar,
@Ok OUTPUT
IF @Accion IN ('AFECTAR', 'CANCELAR') AND @Ok IS NULL
BEGIN
IF @Accion = 'CANCELAR'
BEGIN
SELECT @EstatusNuevo = 'CANCELADO'
UPDATE Proy  SET Estatus = 'BAJA' WHERE ProyectoID = @ID
UPDATE ProyD SET Estatus = 'BAJA' WHERE ID IN (SELECT ID FROM Proy WHERE ProyectoID = @ID)
IF @Origen IS NOT NULL AND @OrigenID IS NOT NULL AND @OrigenTipo = 'PROY'
BEGIN
SELECT @IDOrigen = ID FROM Proyecto WHERE Mov = @Origen AND MovID = @OrigenID AND Empresa = @Empresa AND Estatus = 'CONCLUIDO'
IF @IDOrigen IS NULL
SELECT @Ok = 60400, @OkRef = 'Movimiento: ' + RTRIM(@Mov) + ' ' + RTRIM(@MovID)
IF @Ok IS NULL
BEGIN
UPDATE Proyecto SET Estatus = 'PENDIENTE', FechaConclusion = NULL WHERE ID = @IDOrigen
UPDATE Proy  SET Estatus = 'ALTA' WHERE Proyecto = @ProyectoReestructurar
UPDATE ProyD SET Estatus = 'ALTA' WHERE ID IN (SELECT ID FROM Proy WHERE Proyecto = @ProyectoReestructurar)
IF @@ERROR <> 0 SELECT @Ok = 1
END
IF @Ok IS NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, 'PROY', @IDOrigen, @Origen, @OrigenID, 'PROY', @ID, @Mov, @MovID, @Ok OUTPUT
END
END ELSE
BEGIN
SELECT @EstatusNuevo = 'PENDIENTE'
IF NOT EXISTS (SELECT * FROM ProyCat WHERE Categoria = @Mov) INSERT ProyCat (Categoria) VALUES (@Mov)
IF @Reestructurar = 1
BEGIN
/* JH 15/05/2008
SELECT @p = CHARINDEX('-', @ProyectoReestructurar)
IF @p > 0
SELECT @ProyectoMaster = SUBSTRING(@ProyectoReestructurar, 1, @p-1)
ELSE
SELECT @ProyectoMaster = @ProyectoReestructurar
SELECT @Max = ISNULL(MAX(CONVERT(int, SUBSTRING(Proyecto, LEN(@ProyectoMaster)+2, 20))), 0)
FROM Proy
WHERE Proyecto LIKE RTRIM(@ProyectoMaster)+'-%'
SELECT @Proyecto = RTRIM(@ProyectoMaster)+'-'+CONVERT(varchar, @Max+1)*/
SELECT @Proyecto = @ProyectoReestructurar
END
IF @Proyecto IS NULL
SELECT @Ok = 15010, @OkRef = 'Movimiento: ' + RTRIM(@Mov) + ' ' + RTRIM(@MovID)
IF @Ok IS NULL AND @Reestructurar = 0  
BEGIN
IF @ProyectoSugerir <> 'CATALOGO'
IF EXISTS (SELECT * FROM Proy WHERE Proyecto = @Proyecto) OR EXISTS (SELECT * FROM Proyecto WHERE Proyecto = @Proyecto AND Estatus IN ('PENDIENTE', 'CONCLUIDO'))
SELECT @Ok = 26025, @OkRef = @Proyecto
IF @ProyectoSugerir <> 'CATALOGO'
IF EXISTS (SELECT * FROM Proyecto WHERE Proyecto = @Proyecto AND Estatus IN ('PENDIENTE', 'CONCLUIDO'))
SELECT @Ok = 26025, @OkRef = @Proyecto
END
IF @Ok IS NULL
BEGIN
UPDATE Proy
SET ProyectoID = @ID, Categoria = @Mov, Estatus = 'ALTA', FechaInicio = @Comienzo, FechaFin = @Fin, ContactoTipo = @ContactoTipo,
Cliente = @Cliente, Proveedor = @Proveedor, Prospecto = @Prospecto, Personal = @Personal, Agente = @Agente, ProyectoRama = @ProyectoRama, Riesgo = @Riesgo,
Tipo = @ProyectoTipo
WHERE Proyecto = @Proyecto
IF @@ROWCOUNT = 0
INSERT Proy (Proyecto,  Descripcion,  ProyectoID, Categoria, Estatus, FechaInicio, FechaFin,  ContactoTipo,  Proveedor,  Cliente,  Agente,  Personal,  Prospecto,  Riesgo,  ProyectoRama, Tipo)
VALUES (@Proyecto, @Descripcion, @ID,        @Mov,      'ALTA',  @Comienzo,   @Fin,     @ContactoTipo, @Proveedor, @Cliente, @Agente, @Personal, @Prospecto, @Riesgo, @ProyectoRama, @ProyectoTipo)
DELETE ProyD WHERE Proyecto = @Proyecto
INSERT ProyD (
Proyecto,  Personal,   Cliente,   Proveedor,   Agente,   Nombre,   Estatus,    FechaInicio, FechaFin)
SELECT @Proyecto, r.Personal, r.Cliente, r.Proveedor, r.Agente, r.Nombre, pr.Estatus, pr.Comienzo, pr.Fin
FROM ProyectoRecurso pr
JOIN Recurso r ON r.Recurso = pr.Recurso
WHERE pr.ID = @ID
END
IF @Ok IS NULL
BEGIN
UPDATE ProyectoD SET Proyecto = @Proyecto, Orden = dbo.fnEstructuraEnOrden(Actividad, 5) WHERE ID = @ID
UPDATE ProyectoRecurso SET TieneMovimientos = 1 WHERE ID = @ID
UPDATE Recurso SET TieneMovimientos = 1 WHERE TieneMovimientos = 0 AND Recurso IN (SELECT DISTINCT Recurso FROM ProyectoDRecurso WHERE ID = @ID)
EXEC spProyectoDLiberar @ID, NULL
END
/*        IF @ContactoTipo = 'Riesgo' AND @Riesgo IS NOT NULL
INSERT RiesgoProyecto ( Riesgo, ProyectoID) VALUES (@Riesgo, @ID)*/
IF @OrigenTipo = 'PROY' AND @Origen IS NOT NULL AND @OrigenID IS NOT NULL
BEGIN
IF @OrigenEstatus = 'REESTRUCTURADO' AND @Estatus = 'PENDIENTE' AND @Origen = 'Proyecto Servicio'
SET @OrigenEstatus = 'PENDIENTE'
IF @OrigenEstatus <> 'PENDIENTE' OR @OrigenEstatus IS NULL
SELECT @Ok = 20385, @OkRef = 'Movimiento: ' + RTRIM(@Mov) + ' ' + RTRIM(@MovID)
IF @Ok IS NULL AND @CLaveOrigen = 'PROY.P'
BEGIN
/* JH 15/05/2008*/
UPDATE Proyecto SET Estatus = 'REESTRUCTURADO', @FechaConclusion = GETDATE() WHERE ID = @IDOrigen
/*UPDATE Proy  SET Estatus = 'REESTRUCTURADO' WHERE Proyecto = @ProyectoReestructurar
UPDATE ProyD SET Estatus = 'BAJA' WHERE Proyecto = @ProyectoReestructurar
*/
EXEC spProyGenerarSolicitudInventario @Sucursal, @Empresa, 'REESTRUCTURAR', @Usuario, NULL, @IDOrigen, @Ok OUTPUT, @OkRef OUTPUT
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, 'PROY', @IDOrigen, @Origen, @OrigenID, 'PROY', @ID, @Mov, @MovID, @Ok OUTPUT
END
IF @Ok IS NULL AND @CLaveOrigen = 'PROY.PR'
BEGIN
UPDATE Proyecto SET Estatus = 'CONCLUIDO', @FechaConclusion = GETDATE() WHERE ID = @IDOrigen
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, 'PROY', @IDOrigen, @Origen, @OrigenID, 'PROY', @ID, @Mov, @MovID, @Ok OUTPUT
END
IF @Ok IS NULL AND @CLaveOrigen = 'PROY.P' AND @Estatus = 'PENDIENTE' AND @Origen = 'Proyecto Servicio'
BEGIN
UPDATE Proyecto SET Estatus = 'CONCLUIDO', @FechaConclusion = GETDATE() WHERE ID = @ID
SELECT @EstatusNuevo = 'CONCLUIDO'
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, 'PROY', @IDOrigen, @Origen, @OrigenID, 'PROY', @ID, @Mov, @MovID, @Ok OUTPUT
END
END
END
IF @Ok IN (NULL, 80030)
BEGIN
IF @EstatusNuevo = 'CANCELADO' SELECT @FechaCancelacion = @FechaRegistro ELSE SELECT @FechaCancelacion = NULL
IF @EstatusNuevo = 'CONCLUIDO' SELECT @FechaConclusion  = @FechaEmision  ELSE IF @EstatusNuevo <> 'CANCELADO' SELECT @FechaConclusion  = NULL
IF @CfgContX = 1 AND @CfgContXGenerar <> 'NO'
BEGIN
IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @EstatusNuevo <> 'CANCELADO' SELECT @GenerarPoliza = 1 ELSE
IF @Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @EstatusNuevo =  'CANCELADO' IF @GenerarPoliza = 1 SELECT @GenerarPoliza = 0 ELSE SELECT @GenerarPoliza = 1
END
UPDATE Proyecto
SET FechaConclusion  = @FechaConclusion,
FechaCancelacion = @FechaCancelacion,
Proyecto         = @Proyecto,
UltimoCambio     = CASE WHEN UltimoCambio IS NULL THEN @FechaRegistro ELSE UltimoCambio END,
Estatus          = @EstatusNuevo,
Situacion 	= CASE WHEN @Estatus<>@EstatusNuevo THEN NULL ELSE Situacion END/*,
GenerarPoliza    = @GenerarPoliza*/
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
END
END
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000) AND @Accion IN ('AFECTAR','CANCELAR') AND @MovTipo = 'PROY.P'
EXEC spProyGenerarSolicitudInventario @Sucursal, @Empresa, @Accion, @Usuario, NULL, @ID, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spMovFinal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion = 'CANCELAR' AND @EstatusNuevo = 'CANCELADO' AND @Ok IS NULL
EXEC spCancelarFlujo @Empresa, @Modulo, @ID, @Ok OUTPUT
IF @Conexion = 0
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
RETURN
END

