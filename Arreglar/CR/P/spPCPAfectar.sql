SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPCPAfectar
@ID								int,
@Accion							char(20),
@Empresa						char(5),
@Modulo							char(5),
@Mov	  	      				char(20),
@MovID             				varchar(20)	OUTPUT,
@MovTipo						char(20),
@MovMoneda						char(10),
@MovTipoCambio					float,
@FechaEmision      				datetime,
@FechaAfectacion      	  	  	datetime,
@FechaConclusion				datetime,
@Proyecto	      				varchar(50),
@Usuario	      				char(10),
@Autorizacion      				char(10),
@DocFuente	      				int,
@Observaciones     				varchar(255),
@Concepto     					varchar(50),
@Referencia						varchar(50),
@Estatus           				char(15),
@EstatusNuevo	      	  	  	char(15),
@FechaRegistro     				datetime,
@Ejercicio	      				int,
@Periodo	      				int,
@MovUsuario						char(10),
@Agente							varchar(10),
@Personal						varchar(10),
@Comentarios					text,
@FechaInicio					datetime,
@FechaFin						datetime,
@Categoria						varchar(1),
@Tipo							varchar(15),
@ClavePresupuestalMascara		varchar(50),
@ProyectoDescripcion			varchar(100),
@Conexion						bit,
@SincroFinal					bit,
@Sucursal						int,
@SucursalDestino				int,
@SucursalOrigen					int,
@CfgContX						bit,
@CfgContXGenerar				char(20),
@GenerarPoliza					bit,
@Generar						bit,
@GenerarMov						char(20),
@GenerarAfectado				bit,
@OrigenTipo						varchar(10),
@Origen							varchar(20),
@OrigenID						varchar(20),
@IDOrigen						int,
@IDGenerar						int	     	OUTPUT,
@GenerarMovID					varchar(20)	OUTPUT,
@Ok                				int          OUTPUT,
@OkRef             				varchar(255) OUTPUT

AS BEGIN
DECLARE
@FechaCancelacion	datetime,
@GenerarMovTipo		char(20),
@GenerarPeriodo		int,
@GenerarEjercicio	int
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
IF @MovTipo IN ('PCP.E') AND @GenerarMOvTipo IN ('PCP.EA') AND @Ok IS NULL
BEGIN
INSERT PCPD (ID,         Renglon,    CatalogoTipoTipo,    Aplica,   AplicaID)
SELECT  @IDGenerar, pd.Renglon, pd.CatalogoTipoTipo, p.Mov,    p.MovID
FROM PCPD pd JOIN PCP p
ON p.ID = pd.ID
WHERE p.ID = @ID
AND pd.Estatus = 'PENDIENTE'
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL SELECT @Ok = 80030
RETURN
END
IF @Conexion = 0
BEGIN TRANSACTION
EXEC spMovEstatus @Modulo, 'AFECTANDO', @ID, @Generar, @IDGenerar, @GenerarAfectado, @Ok OUTPUT
IF @Accion <> 'CANCELAR'
EXEC spRegistrarMovimiento @Sucursal, @Empresa, @Modulo, @Mov, @MovID, @ID, @Ejercicio, @Periodo, @FechaRegistro, @FechaEmision,
NULL, @Proyecto, @MovMoneda, @MovTipoCambio,
@Usuario, @Autorizacion, NULL, @DocFuente, @Observaciones,
@Generar, @GenerarMov, @GenerarMovID, @IDGenerar,
@Ok OUTPUT
IF @Accion IN ('AFECTAR', 'CANCELAR')
BEGIN
IF @Accion = 'AFECTAR' AND @MovTipo IN ('PCP.PP')
BEGIN
INSERT Proy (Proyecto,  Estatus, Tipo,       ClavePresupuestalMascara,  FechaInicio,  FechaFin,  Descripcion)
VALUES (@Proyecto, 'ALTA',  'Proyecto', @ClavePresupuestalMascara, @FechaInicio, @FechaFin, @ProyectoDescripcion)
IF @@ERROR <> 0 SET @Ok = 1
END ELSE IF @Accion = 'CANCELAR' AND @MovTipo IN ('PCP.PP')
BEGIN
UPDATE PROY SET Estatus = 'BAJA' WHERE Proyecto = @Proyecto
IF @@ERROR <> 0 SET @Ok = 1
END
IF @MovTipo IN ('PCP.E') AND ((@Accion IN ('AFECTAR') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR')) OR (@Accion IN ('CANCELAR') AND @Estatus IN ('PENDIENTE'))) AND @Ok IS NULL
EXEC spPCPAfectarCatalogoTipo @Accion, @id, @Proyecto, @Categoria, @Ok OUTPUT, @OkRef OUTPUT
IF (@MovTipo IN ('PCP.CAT','PCP.EC','PCP.MC') AND @Accion IN ('AFECTAR') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR')) OR (@MovTipo IN ('PCP.CAT','PCP.EC','PCP.MC') AND @Accion IN ('CANCELAR') AND @Estatus IN ('CONCLUIDO'))
EXEC spPCPAfectarCatalogo @Accion, @MovTipo, @ID, @Proyecto, @Categoria, @Ok OUTPUT, @OkRef OUTPUT
IF @MovTipo IN ('PCP.EA') AND ((@Accion IN ('AFECTAR') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR')) OR (@Accion IN ('CANCELAR') AND @Estatus IN ('CONCLUIDO'))) AND @Ok IS NULL
EXEC spPCPAplicarEstructura @Empresa, @Accion, @ID, @Ok OUTPUT, @OkRef OUTPUT
IF @MovTipo IN ('PCP.CP','PCP.ECP') AND ((@Accion IN ('AFECTAR') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR')) OR (@Accion IN ('CANCELAR') AND @Estatus IN ('CONCLUIDO'))) AND @Ok IS NULL
EXEC spPCPAfectarClavePresupuestal @Accion, @Usuario, @FechaRegistro, @MovTipo, @ID, @Proyecto, @Categoria, @Ok OUTPUT, @OkRef OUTPUT
IF @MovTipo IN ('PCP.R','PCP.ER') AND ((@Accion IN ('AFECTAR') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR')) OR (@Accion IN ('CANCELAR') AND @Estatus IN ('CONCLUIDO'))) AND @Ok IS NULL
EXEC spPCPAfectarRegla @Accion, @Usuario, @FechaRegistro, @MovTipo, @ID, @Proyecto, @Categoria, @Ok OUTPUT, @OkRef OUTPUT
IF @MovTipo IN ('PCP.P') AND ((@Accion IN ('AFECTAR') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR')) OR (@Accion IN ('CANCELAR') AND @Estatus IN ('VIGENTE'))) AND @Ok IS NULL
EXEC spPCPAfectarPresupuesto @Empresa, @Modulo, @Accion, @Usuario, @FechaRegistro, @MovTipo, @ID, @Proyecto, @Categoria, @Ok OUTPUT, @OkRef OUTPUT
IF @MovTipo IN ('PCP.PC') AND ((@Accion IN ('AFECTAR') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR')) OR (@Accion IN ('CANCELAR') AND @Estatus IN ('CONCLUIDO'))) AND @Ok IS NULL
EXEC spPCPAfectarConcluirPresupuesto @Empresa, @Modulo, @Accion, @Usuario, @FechaRegistro, @MovTipo, @ID, @Proyecto, @Categoria, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IN (NULL, 80030)
BEGIN
IF @EstatusNuevo = 'CANCELADO' SELECT @FechaCancelacion = @FechaRegistro ELSE SELECT @FechaCancelacion = NULL
IF @EstatusNuevo = 'CONCLUIDO' SELECT @FechaConclusion  = @FechaEmision  ELSE IF @EstatusNuevo <> 'CANCELADO' SELECT @FechaConclusion  = NULL
IF @CfgContX = 1 AND @CfgContXGenerar <> 'NO'
BEGIN
IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR','VIGENTE','PENDIENTE') AND @EstatusNuevo <> 'CANCELADO' SELECT @GenerarPoliza = 1 ELSE
IF @Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR','VIGENTE','PENDIENTE') AND @EstatusNuevo =  'CANCELADO' IF @GenerarPoliza = 1 SELECT @GenerarPoliza = 0 ELSE SELECT @GenerarPoliza = 1
END
EXEC spValidarTareas @Empresa, @Modulo, @ID, @EstatusNuevo, @Ok OUTPUT, @OkRef OUTPUT
UPDATE PCP
SET FechaConclusion  = @FechaConclusion,
FechaCancelacion = @FechaCancelacion,
UltimoCambio     = CASE WHEN UltimoCambio IS NULL THEN @FechaRegistro ELSE UltimoCambio END,
Estatus          = @EstatusNuevo,
Situacion 	= CASE WHEN @Estatus<>@EstatusNuevo THEN NULL ELSE Situacion END,
GenerarPoliza    = @GenerarPoliza
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
END
END
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spMovFinal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
IF @IDOrigen IS NOT NULL AND @Accion IN ('AFECTAR') AND @Ok IS NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @OrigenTipo, @IDOrigen, @Origen, @OrigenID, @Modulo, @ID, @Mov, @MovID, @Ok OUTPUT
IF @Accion = 'CANCELAR' AND @EstatusNuevo = 'CANCELADO' AND @Ok IS NULL
EXEC spCancelarFlujo @Empresa, @Modulo, @ID, @Ok OUTPUT, 0
IF @Conexion = 0
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
COMMIT TRANSACTION
ELSE
BEGIN
DECLARE @PolizaDescuadrada TABLE (Cuenta varchar(20) NULL, SubCuenta varchar(50) NULL, Concepto varchar(50) NULL, Debe money NULL, Haber money NULL, SucursalContable int NULL)
IF EXISTS(SELECT * FROM PolizaDescuadrada WHERE Modulo = @Modulo AND ID = @ID)
INSERT @PolizaDescuadrada (Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable) SELECT Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable FROM PolizaDescuadrada WHERE Modulo = @Modulo AND ID = @ID
ROLLBACK TRANSACTION
DELETE PolizaDescuadrada WHERE Modulo = @Modulo AND ID = @ID
INSERT PolizaDescuadrada (Modulo, ID, Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable) SELECT @Modulo, @ID, Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable FROM @PolizaDescuadrada
END
RETURN
END

