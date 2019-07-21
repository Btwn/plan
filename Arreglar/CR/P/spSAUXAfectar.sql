SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSAUXAfectar
@ID                		int,
@Accion					char(20),
@Base					char(20),
@Empresa	      			char(5),
@Modulo	      			char(5),
@Mov	  	      			char(20),
@MovID             		varchar(20)	OUTPUT,
@MovTipo     			char(20),
@MovMoneda				char(10),
@MovTipoCambio			float,
@FechaEmision      		datetime,
@FechaAfectacion      	datetime,
@FechaConclusion			datetime,
@Proyecto	      		varchar(50),
@Usuario	      			char(10),
@Autorizacion      		char(10),
@DocFuente	      		int,
@Observaciones     		varchar(255),
@Concepto     			varchar(50),
@Referencia				varchar(50),
@Estatus           		char(15),
@EstatusNuevo	      	char(15),
@FechaRegistro     		datetime,
@Ejercicio	      		int,
@Periodo	      			int,
@MovUsuario				char(10),
@Conexion				bit,
@SincroFinal				bit,
@Sucursal				int,
@SucursalDestino			int,
@SucursalOrigen			int,
@CfgContX				bit,
@CfgContXGenerar			char(20),
@GenerarPoliza			bit,
@Generar					bit,
@GenerarMov				char(20),
@GenerarAfectado			bit,
@IDGenerar				int	     	OUTPUT,
@GenerarMovID	  		varchar(20)	OUTPUT,
@Almacen					char(10),
@Agente					varchar(10),
@Ok                		int          OUTPUT,
@OkRef             		varchar(255) OUTPUT

AS BEGIN
DECLARE
@CancelarID			int,
@FechaCancelacion	datetime,
@GenerarMovTipo		char(20),
@GenerarPeriodo		int,
@GenerarEjercicio	int,
@ServicioEstatus	char(15),
@Posicion			varchar(10),
@PosicionDestino	varchar(10),
@AlmacenDetalle		varchar(10),
@Renglon			int,
@Producto			varchar(20),
@SubProducto		varchar(20),
@Servicio			varchar(20),
@Cantidad			int,
@CantidadPendeiente	int,
@CantidadCancelada	int,
@Estado				varchar(15),
@ModuloDestino		char(5),
@MovDestino			varchar(20),
@EstatusGenerar		char(15),
@MovGenerar			varchar(20),
@OrigenTipo			char(5),
@Origen				varchar(20),
@OrigenID			varchar(20),
@IDOrigen			int,
@EtapaDestino		varchar(20)
IF @FechaRegistro IS NULL SELECT @FechaRegistro = GETDATE()
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
BEGIN
IF @Base = 'PENDIENTE'
INSERT SAUXD (
ID,         Renglon, Producto, SubProducto, Servicio, Codigo, Cantidad,			 CantidadPendeiente, CantidadCancelada, CantidadA, FechaRequerida, FechaInicio, FechaFin, FechaEntrega, Estado,       Observaciones, Prioridad)
SELECT @IDGenerar, Renglon, Producto, SubProducto, Servicio, Codigo, CantidadPendeiente, CantidadPendeiente, CantidadCancelada, CantidadA, FechaRequerida, FechaInicio, FechaFin, FechaEntrega, 'SINAFECTAR', Observaciones, Prioridad
FROM SAUXD
WHERE ID = @ID AND Estado IN ('PENDIENTE')
ELSE
INSERT SAUXD (
ID,         Renglon, Producto, SubProducto, Servicio, Codigo, Cantidad,	CantidadPendeiente, CantidadCancelada, CantidadA, FechaRequerida, FechaInicio, FechaFin, FechaEntrega, Estado, Observaciones, Prioridad)
SELECT @IDGenerar, Renglon, Producto, SubProducto, Servicio, Codigo, CantidadA, CantidadPendeiente, CantidadCancelada, 0,		  FechaRequerida, FechaInicio, FechaFin, FechaEntrega, 'SINAFECTAR', Observaciones, Prioridad
FROM SAUXD
WHERE ID = @ID AND Estado IN ('PENDIENTE') AND CantidadA > 0
IF @Base = 'PENDIENTE'
UPDATE SAUXD SET CantidadA = 0 WHERE ID = @ID
INSERT INTO SAUXDIndicador (ID, Renglon, Producto, Servicio, Indicador)
SELECT d.ID, d.Renglon, d.Producto, d.Servicio, isnull(i.Indicador, '')
FROM SAUXD d
JOIN SAUXServIndicador s ON d.Servicio = s.Servicio
JOIN SAUXIndicador i ON s.Indicador = i.Indicador
WHERE ID = @IDGenerar
IF @Ok IS NULL SELECT @Ok = 80030
END
RETURN
END
IF @Conexion = 0
BEGIN TRANSACTION
EXEC spMovEstatus @Modulo, 'AFECTANDO', @ID, @Generar, @IDGenerar, @GenerarAfectado, @Ok OUTPUT
IF @Accion = 'CANCELAR'
BEGIN
DECLARE crSAUXCancelar CURSOR FOR
SELECT ID
FROM SAUX
WHERE OrigenTipo = @Modulo
AND Origen = @Mov
AND OrigenID = @MovID
AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
AND Empresa = @Empresa
OPEN crSAUXCancelar
FETCH NEXT FROM crSAUXCancelar INTO @CancelarID
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
EXEC spAfectar @Modulo, @CancelarID, 'CANCELAR', @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
FETCH NEXT FROM crSAUXCancelar INTO @CancelarID
END
CLOSE crSAUXCancelar
DEALLOCATE crSAUXCancelar
END
IF @Accion <> 'CANCELAR'
EXEC spRegistrarMovimiento @Sucursal, @Empresa, @Modulo, @Mov, @MovID, @ID, @Ejercicio, @Periodo, @FechaRegistro, @FechaEmision,
NULL, @Proyecto, @MovMoneda, @MovTipoCambio,
@Usuario, @Autorizacion, NULL, @DocFuente, @Observaciones,
@Generar, @GenerarMov, @GenerarMovID, @IDGenerar, @Ok OUTPUT
IF @Accion IN ('AFECTAR', 'CANCELAR')
BEGIN
DECLARE crAfectarSAUXD CURSOR LOCAL FOR
SELECT Renglon, ISNULL(RTRIM(d.Producto), ''), ISNULL(RTRIM(d.SubProducto), ''), ISNULL(RTRIM(d.Servicio), ''), ISNULL(d.Cantidad, 0) /*CASE WHEN ISNULL(d.CantidadA, 0) <= 0 THEN ISNULL(d.Cantidad, 0) ELSE ISNULL(d.CantidadA, 0) END*/, ISNULL(d.CantidadPendeiente, 0), ISNULL(d.CantidadCancelada, 0), ISNULL(d.Estado, 0), ISNULL(RTRIM(o.ID), ''), ISNULL(RTRIM(o.Mov), ''), ISNULL(RTRIM(o.MovID), '')
FROM SAUXD d
JOIN SAUX s ON d.ID = s.ID
JOIN SAUX o ON s.Origen = o.Mov AND s.OrigenID = o.MovID
WHERE d.ID = @ID
OPEN crAfectarSAUXD
FETCH NEXT FROM crAfectarSAUXD INTO @Renglon, @Producto, @SubProducto, @Servicio, @Cantidad, @CantidadPendeiente, @CantidadCancelada, @Estado, @IDOrigen, @Origen, @OrigenID
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF @CantidadPendeiente - @Cantidad < 1 AND @Accion = 'AFECTAR'
UPDATE SAUXD
SET Estado = 'CONCLUIDO'
WHERE ID = @ID
AND Producto =  @Producto
AND ISNULL(SubProducto,'') = @SubProducto
AND Servicio = @Servicio
IF @Accion = 'AFECTAR' AND @EstatusNuevo = 'CONCLUIDO'
BEGIN
UPDATE SAUXD SET CantidadPendeiente = ISNULL(CantidadPendeiente,0) - @Cantidad, CantidadA = 0
WHERE ID = @IDOrigen
AND Estado = 'PENDIENTE'
AND Producto =  @Producto
AND ISNULL(SubProducto,'') = @SubProducto
AND Servicio = @Servicio
UPDATE SAUXD
SET Estado = 'CONCLUIDO'
WHERE ID = @IDOrigen
AND Estado = 'PENDIENTE'
AND Producto =  @Producto
AND ISNULL(SubProducto,'') = @SubProducto
AND Servicio = @Servicio
AND ISNULL(CantidadPendeiente, 0) = 0
END
IF @Accion = 'CANCELAR' AND @Estatus = 'CONCLUIDO'
BEGIN
UPDATE SAUXD
SET Estado = @EstatusNuevo,
CantidadA = 0
WHERE ID = @ID
AND Producto =  @Producto
AND ISNULL(SubProducto,'') = @SubProducto
AND Servicio = @Servicio
UPDATE SAUXD
SET Estado = 'PENDIENTE',
CantidadPendeiente = ISNULL(CantidadPendeiente,0) + @Cantidad,
CantidadA = 0
WHERE ID = @IDOrigen
AND Producto =  @Producto
AND ISNULL(SubProducto,'') = @SubProducto
AND Servicio = @Servicio
END
IF @Ok IS NOT NULL AND @OkRef IS NULL SELECT @OkRef = @Servicio
END
FETCH NEXT FROM crAfectarSAUXD INTO @Renglon, @Producto, @SubProducto, @Servicio, @Cantidad, @CantidadPendeiente, @CantidadCancelada, @Estado, @IDOrigen, @Origen, @OrigenID
END
CLOSE crAfectarSAUXD
DEALLOCATE crAfectarSAUXD
IF @Ok IN (NULL, 80030)
BEGIN
IF @EstatusNuevo = 'CANCELADO' SELECT @FechaCancelacion = @FechaRegistro ELSE SELECT @FechaCancelacion = NULL
IF @EstatusNuevo = 'CONCLUIDO' SELECT @FechaConclusion  = @FechaEmision  ELSE IF @EstatusNuevo <> 'CANCELADO' SELECT @FechaConclusion  = NULL
IF @CfgContX = 1 AND @CfgContXGenerar <> 'NO'
BEGIN
IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @EstatusNuevo <> 'CANCELADO' SELECT @GenerarPoliza = 1 ELSE
IF @Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @EstatusNuevo =  'CANCELADO' IF @GenerarPoliza = 1 SELECT @GenerarPoliza = 0 ELSE SELECT @GenerarPoliza = 1
END
EXEC spValidarTareas @Empresa, @Modulo, @ID, @EstatusNuevo, @Ok OUTPUT, @OkRef OUTPUT
UPDATE SAUX
SET FechaConclusion  = @FechaConclusion,
FechaEntrega     = @FechaConclusion,
FechaCancelacion = @FechaCancelacion,
UltimoCambio     = CASE WHEN UltimoCambio IS NULL THEN @FechaRegistro ELSE UltimoCambio END,
Estatus          = @EstatusNuevo,
Situacion 	= CASE WHEN @Estatus<>@EstatusNuevo THEN NULL ELSE Situacion END
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
END
END
IF @MovTipo = 'SAUX.SS' AND @Estatus = 'SINAFECTAR'
BEGIN
SELECT @OrigenTipo = OrigenTipo, @Origen = Origen, @OrigenID = OrigenID FROM SAUX WHERE ID = @ID
IF @OrigenTipo = 'VTAS'
SELECT @IDOrigen = ID FROM Venta WHERE Mov = @Origen AND MovID = @OrigenID AND Empresa = @Empresa
ELSE
IF @OrigenTipo = 'COMS'
SELECT @IDOrigen = ID FROM Compra WHERE Mov = @Origen AND MovID = @OrigenID AND Empresa = @Empresa
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @OrigenTipo, @IDOrigen, @Origen, @OrigenID, 'SAUX', @ID, @Mov, @MovID, @Ok OUTPUT
END
IF @MovTipo IN ('SAUX.S') AND @Accion = 'AFECTAR' AND @Estatus = 'SINAFECTAR' AND @Ok IS NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, 'SAUX', @IDOrigen, @Origen, @OrigenID, 'SAUX', @ID, @Mov, @MovID, @Ok OUTPUT
IF @MovTipo IN ('SAUX.S') AND @Accion = 'AFECTAR' AND @EstatusNuevo = 'CONCLUIDO' AND @Ok IS NULL
BEGIN
SELECT @FechaConclusion  = GETDATE()
IF (SELECT COUNT(0) FROM SAUXD WHERE ID = @IDOrigen AND Estado <> 'CONCLUIDO') = 0
UPDATE SAUX
SET FechaConclusion  = @FechaConclusion,
FechaEntrega     = @FechaConclusion,
UltimoCambio     = CASE WHEN UltimoCambio IS NULL THEN GETDATE() ELSE UltimoCambio END,
Estatus          = 'CONCLUIDO',
Situacion 	    = CASE WHEN @Estatus<>@EstatusNuevo THEN NULL ELSE Situacion END
WHERE ID = @IDOrigen
END
IF @MovTipo IN ('SAUX.S') AND @Accion = 'CANCELAR' AND @Ok IS NULL
BEGIN
SELECT @FechaConclusion  = GETDATE()
IF EXISTS (SELECT * FROM SAUXD WHERE ID = @IDOrigen AND Estado = 'PENDIENTE')
UPDATE SAUX
SET FechaConclusion  = @FechaConclusion,
FechaEntrega     = @FechaConclusion,
UltimoCambio     = CASE WHEN UltimoCambio IS NULL THEN GETDATE() ELSE UltimoCambio END,
Estatus          = 'PENDIENTE',
Situacion 	    = CASE WHEN @Estatus<>@EstatusNuevo THEN NULL ELSE Situacion END
WHERE ID = @IDOrigen
END
UPDATE SAUXD
SET Estado = @EstatusNuevo
WHERE ID = @ID
IF @EstatusNuevo = 'CONCLUIDO'
BEGIN
UPDATE SAUXD
SET FechaEntrega = @FechaConclusion
WHERE ID = @IDOrigen
AND Estado = @EstatusNuevo
AND FechaEntrega IS NULL
UPDATE SAUX SET FechaEntrega = @FechaConclusion WHERE ID IN(@ID, @IDOrigen)
UPDATE SAUXD SET FechaEntrega = @FechaConclusion WHERE ID = @ID
END
IF @EstatusNuevo = 'CANCELADO'
BEGIN
UPDATE SAUXD
SET FechaEntrega = NULL
WHERE ID = @IDOrigen
AND Estado <> 'CONCLUIDO'
AND FechaEntrega IS NOT NULL
UPDATE SAUX SET FechaEntrega = NULL WHERE ID IN(@ID, @IDOrigen)
UPDATE SAUXD SET FechaEntrega = NULL WHERE ID = @ID
IF (SELECT Estatus FROM  SAUX WHERE ID = @IDOrigen) = 'PENDIENTE'
UPDATE SAUX SET FechaEntrega = (SELECT TOP 1 FechaEntrega FROM SAUXD WHERE ID = @IDOrigen AND FechaEntrega IS NOT NULL ORDER BY FechaEntrega DESC) WHERE ID = @IDOrigen
END
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spMovFinal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion = 'CANCELAR' AND @EstatusNuevo = 'CANCELADO' AND @Ok IS NULL
EXEC spCancelarFlujo @Empresa, @Modulo, @ID, @Ok OUTPUT
IF @Ok IS NULL
EXEC spSAUXGenerarInv @Modulo, @ID, @Accion, @Empresa, @Sucursal, @Usuario, @Mov, @MovID, @EstatusNuevo, @MovTipo, @Almacen, @FechaEmision, 'INV', @MovDestino, @Ok OUTPUT, @OkRef OUTPUT
/*
SELECT * FROM  SAUX WHERE ID = @ID
SELECT * FROM  SAUXD WHERE ID = @ID
SELECT * FROM  SAUX WHERE ID = @IDOrigen
SELECT * FROM  SAUXD WHERE ID = @IDOrigen
*/
IF @Conexion = 0
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
RETURN
END

