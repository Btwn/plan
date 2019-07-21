SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarCompraLoteLista
@Estacion		int,
@Empresa			char(5),
@Modulo			char(5),
@Accion			char(20),
@Base			char(20),
@GenerarMov		char(20),
@Usuario			char(10),
@FacturarLote	varchar(20) 	= 'Movimiento',
@Conexion		bit				= 0,
@Afectar			bit				= 0,
@IDConsecutivo   int             = NULL	OUTPUT,
@Ok				int	 	        = NULL	OUTPUT,
@OkRef			varchar(255)	= NULL	OUTPUT

AS BEGIN
DECLARE
@Elimino			int,
@ID				int,
@IDGenerar		int,
@Mensaje			varchar(255),
@MovTipo			varchar(20),
@GenerarMovTipo	varchar(20),
@Continuar		bit,
@Sucursal			int,
@Proveedor		char(10),
@Condicion		varchar(50),
@Vencimiento		datetime,
@DescuentoGlobal	float,
@Renglon			float,
@OrigenTipo		varchar(5),
@Origen			varchar(20),
@OrigenID			varchar(20),
@StrSQL             nvarchar(max)
SELECT @GenerarMovTipo = Clave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @GenerarMov
DELETE ListaIDOk WHERE Estacion = @Estacion
SELECT v.OrigenTipo, v.Origen, v.OrigenID
INTO #Origen
FROM ListaID l, Compra v, MovTipo mt
WHERE l.Estacion = @Estacion AND v.ID = l.ID AND v.Empresa = @Empresa AND mt.Modulo = @Modulo AND mt.Mov = v.Mov
GROUP BY v.OrigenTipo, v.Origen, v.OrigenID
IF(SELECT COUNT(*) FROM #Origen) > 1
BEGIN
SELECT 'Los Movimientos seleccionados provienen de distintas Ordenes de Compra'
RETURN
END
SELECT @OrigenTipo = OrigenTipo, @Origen = Origen, @OrigenID = OrigenID FROM #Origen
IF @FacturarLote = 'Proveedor'
BEGIN
DECLARE crListaProv CURSOR FOR
SELECT mt.Clave, v.Sucursal, v.Proveedor, v.Condicion, v.DescuentoGlobal, MIN(l.ID)
FROM ListaID l, Compra v, MovTipo mt
WHERE l.Estacion = @Estacion AND v.ID = l.ID AND v.Empresa = @Empresa AND mt.Modulo = @Modulo AND mt.Mov = v.Mov
GROUP BY mt.Clave, v.Sucursal, v.Proveedor, v.Condicion, v.DescuentoGlobal
ORDER BY mt.Clave, v.Sucursal, v.Proveedor, v.Condicion, v.DescuentoGlobal
OPEN crListaProv
FETCH NEXT FROM crListaProv INTO @MovTipo, @Sucursal, @Proveedor, @Condicion, @DescuentoGlobal, @ID
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Continuar = 1
IF @GenerarMovTipo = 'COMS.F'
IF (SELECT mt.Clave FROM Compra v, MovTipo mt WHERE v.ID = @ID AND mt.Modulo = 'COMS' AND mt.Mov = v.Mov) NOT IN ('COMS.O')
SELECT @Continuar = 0
IF @Continuar = 1
BEGIN
SELECT @IDGenerar = NULL
EXEC @IDGenerar = spAfectar @Modulo, @ID, @Accion, @Base, @GenerarMov, @Usuario, 0, 1, @Ok OUTPUT, @OkRef OUTPUT
UPDATE Compra SET OrigenTipo = @OrigenTipo, Origen = @Origen, OrigenID = @OrigenID WHERE ID = @IDGenerar
IF @Ok = 80030
BEGIN
SELECT @Renglon = ISNULL(MAX(Renglon), 0) FROM CompraD WHERE ID = @IDGenerar
SELECT * INTO #CompraDetalleLote FROM cCompraD WHERE ID IN (SELECT l.ID FROM ListaID l, Compra v WHERE l.Estacion = @Estacion AND v.ID <> @ID AND v.ID = l.ID AND v.Empresa = @Empresa AND v.Sucursal = @Sucursal AND v.Proveedor = @Proveedor AND v.Condicion = @Condicion AND v.DescuentoGlobal = @DescuentoGlobal)
IF EXISTS(SELECT * FROM #CompraDetalleLote)
BEGIN
UPDATE #CompraDetalleLote SET @Renglon = Renglon = @Renglon + 2048.0, Aplica = v.Mov, AplicaID = v.MovID FROM #CompraDetalleLote d, Compra v WHERE v.ID = d.ID
IF @Base = 'TODO'      UPDATE #CompraDetalleLote SET ID = @IDGenerar, CantidadPendiente = NULL, CantidadCancelada = NULL, CantidadA = NULL ELSE
IF @Base = 'SELECCION' UPDATE #CompraDetalleLote SET ID = @IDGenerar, Cantidad = CantidadA, CantidadInventario = CantidadA * CantidadInventario / Cantidad, CantidadPendiente = NULL, CantidadCancelada = NULL, CantidadA = NULL ELSE
IF @Base = 'PENDIENTE' UPDATE #CompraDetalleLote SET ID = @IDGenerar, Cantidad = NULLIF(ISNULL(CantidadPendiente,0.0), 0.0), CantidadInventario = (NULLIF(ISNULL(CantidadPendiente,0.0), 0.0)) * CantidadInventario / Cantidad, CantidadPendiente = NULL, CantidadCancelada = NULL, CantidadA = NULL
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #CompraDetalleLote SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal
IF @@ERROR <> 0 SELECT @Ok = 1
DELETE #CompraDetalleLote WHERE Cantidad IS NULL OR Cantidad = 0.0
IF @@ERROR <> 0 SELECT @Ok = 1
INSERT INTO cCompraD SELECT * FROM #CompraDetalleLote
IF @@ERROR <> 0 SELECT @Ok = 1
END
DROP TABLE #CompraDetalleLote
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Ok IN (NULL, 80030) 
EXEC spAfectar @Modulo, @IDGenerar, 'CONSECUTIVO', 'TODO', NULL, @Usuario, @Conexion, 1, @Ok OUTPUT, @OkRef OUTPUT
SELECT @Elimino = 0
IF @Ok NOT IN (NULL, 80030, 80060)
EXEC @Elimino = spEliminarMov @Modulo, @IDGenerar
IF @Elimino = 0 SELECT @ID = @IDGenerar
END
INSERT ListaIDOK (Estacion, ID, Empresa, Modulo, Ok, OkRef) VALUES (@Estacion, @ID, @Empresa, @Modulo, @Ok, @OkRef)
END
END
FETCH NEXT FROM crListaProv INTO @MovTipo, @Sucursal, @Proveedor, @Condicion, @DescuentoGlobal, @ID
END
CLOSE crListaProv
DEALLOCATE crListaProv
END
IF @Ok IN (NULL, 80030, 80060) 
BEGIN
SELECT @Mensaje = CONVERT(varchar(max), @IDGenerar)
SET @IDConsecutivo=@IDGenerar
END
ELSE
SELECT @Mensaje = Descripcion+' '+RTRIM(@OkRef)
FROM MensajeLista
WHERE Mensaje = @Ok
IF @Afectar=0
SELECT @Mensaje
RETURN
END

