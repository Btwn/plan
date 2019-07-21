SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGastoProrratear
@Sucursal		int,
@ID                  int,
@Modulo	      	char(5),
@Accion		char(20),
@Empresa		char(5),
@Usuario		char(10),
@FechaRegistro	datetime,
@Mov			char(20),
@MovID		varchar(20),
@MovTipo		char(20),
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@GastoMov		char(20),
@GastoMovID		varchar(20),
@IDGasto		int,
@SucursalDestino	int,
@FechaDestino	datetime,
@ProyectoDestino                varchar(50)
IF @Accion = 'CANCELAR'
BEGIN
DECLARE crGastoID CURSOR FOR
SELECT ID, Mov, MovID
FROM Gasto WITH(NOLOCK)
WHERE  Empresa = @Empresa AND OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
OPEN crGastoID
FETCH NEXT FROM crGastoID  INTO @IDGasto, @GastoMov, @GastoMovID
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
EXEC spGasto @IDGasto, @Modulo, @Accion, 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, @GastoMov, @GastoMovID OUTPUT, @IDGasto, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @Modulo, @IDGasto, @GastoMov, @GastoMovID, @Ok OUTPUT
IF @Ok IS NOT NULL SELECT @OkRef = RTRIM(@OkRef) + ' - ' + RTRIM(@GastoMov) + ' ' + RTRIM(@GastoMovID)
END
FETCH NEXT FROM crGastoID  INTO @IDGasto, @GastoMov, @GastoMovID
END  
CLOSE crGastoID
DEALLOCATE crGastoID
END ELSE
BEGIN
SELECT @GastoMovID = NULL, @GastoMov = NULL
SELECT @GastoMov = CASE @MovTipo
WHEN 'GAS.GP'  THEN Gasto
WHEN 'GAS.CP'  THEN GastoComprobante
WHEN 'GAS.EST' THEN CASE WHEN EXISTS(SELECT * FROM MovTipo mt WITH(NOLOCK) WHERE mt.Modulo = @Modulo AND mt.Mov = @Mov AND mt.SubClave = 'GAS.EST/GP') THEN Gasto ELSE NULL END
WHEN 'GAS.DGP' THEN GastoDev
WHEN 'GAS.PRP' THEN GastoPresupuesto
END
FROM EmpresaCfgMov
WITH(NOLOCK) WHERE Empresa = @Empresa
DECLARE crSucursal CURSOR FOR
SELECT Fecha, SucursalProrrateo, Proyecto
FROM GastoDProrrateo WITH(NOLOCK)
WHERE  ID = @ID
GROUP BY Fecha, SucursalProrrateo, Proyecto
ORDER BY Fecha, SucursalProrrateo, Proyecto
OPEN crSucursal
FETCH NEXT FROM crSucursal  INTO @FechaDestino, @SucursalDestino, @ProyectoDestino
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
INSERT Gasto (UltimoCambio, Sucursal,  SucursalOrigen, SucursalDestino,  OrigenTipo,  Origen, OrigenID,  Empresa, Usuario,  Estatus,     Mov,       FechaEmision,                        Proyecto, Moneda, TipoCambio, Observaciones, Acreedor, Clase, SubClase, TieneRetencion, FechaRequerida, AnexoModulo, AnexoID, Prioridad)
SELECT GETDATE(),    @Sucursal, @Sucursal,      @SucursalDestino, @Modulo,     Mov,    MovID,     Empresa, Usuario, 'SINAFECTAR', @GastoMov, ISNULL(@FechaDestino, FechaEmision),  @ProyectoDestino, Moneda, TipoCambio, Observaciones, Acreedor, Clase, SubClase, TieneRetencion, FechaRequerida, AnexoModulo, AnexoID, 'Normal'
FROM Gasto
WITH(NOLOCK) WHERE ID = @ID
SELECT @IDGasto = SCOPE_IDENTITY()
EXEC spGastoDProrratear @ID, @IDGasto, @FechaDestino, @SucursalDestino, @ProyectoDestino
IF EXISTS(SELECT * FROM GastoD WITH(NOLOCK) WHERE ID = @IDGasto)
BEGIN
EXEC spGasto @IDGasto, @Modulo, @Accion, 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, @GastoMov, @GastoMovID OUTPUT, @IDGasto, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @Modulo, @IDGasto, @GastoMov, @GastoMovID, @Ok OUTPUT
END ELSE
DELETE Gasto WHERE ID = @IDGasto
END
FETCH NEXT FROM crSucursal INTO @FechaDestino, @SucursalDestino, @ProyectoDestino
END  
CLOSE crSucursal
DEALLOCATE crSucursal
END
END

