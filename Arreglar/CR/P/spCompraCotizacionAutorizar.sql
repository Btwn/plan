SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCompraCotizacionAutorizar
@Estacion	int,
@Empresa	varchar(5),
@Sucursal	int,
@Usuario	varchar(10),
@FechaEmision	datetime,
@Mov			varchar(20) = NULL

AS BEGIN
DECLARE
@Conteo	int,
@Ok		int,
@OkRef	varchar(255),
@ID		int,
@MovID	varchar(20),
@IDOrigen	int,
@Origen	varchar(20),
@OrigenID	varchar(20),
@Proveedor	varchar(10),
@Moneda	char(10),
@TipoCambio	float,
@UltimoCambio date,
@Prioridad varchar(10),
@RenglonID int,
@FechaRequerida date,
@Condicion varchar(50),
@Vencimiento date,
@Importe money,
@Impuestos money,
@FechaEntrega date,
@SucursalDestino int,
@Almacen	varchar(10),
@Renglon	float,
@EmpresaRef	varchar(5)
SELECT @Ok = NULL, @OkRef = NULL, @Conteo = 0
IF @Mov IS NULL
SELECT @Mov = CompraOrden FROM EmpresaCfgMov WHERE Empresa = @Empresa
SELECT @Moneda = m.Moneda, @TipoCambio = m.TipoCambio
FROM EmpresaCfg cfg, Mon m
WHERE cfg.Empresa = @Empresa AND m.Moneda = cfg.ContMoneda
BEGIN TRANSACTION
DECLARE crCotizacion CURSOR FOR
SELECT ISNULL(d.EmpresaRef, @Empresa), c.ID, c.Mov, c.MovID, c.Proveedor, c.Moneda, c.TipoCambio, c.UltimoCambio, c.Prioridad, c.RenglonID, c.FechaRequerida, c.Condicion, c.Vencimiento, c.Importe, c.Impuestos, c.FechaEntrega, c.SucursalDestino
FROM Compra c
JOIN ListaIDRenglon l ON l.Estacion = @Estacion AND l.Modulo = 'COMS' AND l.ID = c.ID
JOIN CompraD d ON d.ID = l.ID AND d.Renglon = l.Renglon AND d.RenglonSub = l.RenglonSub
GROUP BY ISNULL(d.EmpresaRef, @Empresa), c.ID, c.Mov, c.MovID, c.Proveedor, c.Moneda, c.TipoCambio, c.UltimoCambio, c.Prioridad, c.RenglonID, c.FechaRequerida, c.Condicion, c.Vencimiento, c.Importe, c.Impuestos, c.FechaEntrega, c.SucursalDestino
ORDER BY ISNULL(d.EmpresaRef, @Empresa), c.ID, c.Mov, c.MovID, c.Proveedor, c.Moneda, c.TipoCambio, c.UltimoCambio, c.Prioridad, c.RenglonID, c.FechaRequerida, c.Condicion, c.Vencimiento, c.Importe, c.Impuestos, c.FechaEntrega, c.SucursalDestino
OPEN crCotizacion
FETCH NEXT FROM crCotizacion INTO @EmpresaRef, @IDOrigen, @Origen, @OrigenID, @Proveedor, @Moneda, @TipoCambio, @UltimoCambio, @Prioridad, @RenglonID, @FechaRequerida, @Condicion, @Vencimiento, @Importe, @Impuestos, @FechaEntrega, @SucursalDestino
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Ok IS NULL
BEGIN
INSERT Compra (Sucursal,  Empresa,     Mov,   Estatus,     FechaEmision,  Moneda,  TipoCambio,  Usuario,  Proveedor,  Directo, OrigenTipo, Origen,  OrigenID, UltimoCambio,  Prioridad,  RenglonID,   FechaRequerida,   Condicion, Vencimiento,  Importe, Impuestos, FechaEntrega, SucursalDestino)
VALUES (@Sucursal, @EmpresaRef, @Mov, 'SINAFECTAR', @FechaEmision, @Moneda, @TipoCambio, @Usuario, @Proveedor, 0,       'COMS',     @Origen, @OrigenID, @UltimoCambio, @Prioridad, @RenglonID, @FechaRequerida, @Condicion, @Vencimiento, @Importe, @Impuestos, @FechaEntrega, @SucursalDestino)
SELECT @ID = SCOPE_IDENTITY()
SELECT d.* INTO #CompraDetalle
FROM cCompraD d
JOIN ListaIDRenglon l ON l.Estacion = @Estacion AND l.Modulo = 'COMS' AND l.ID = d.ID AND l.Renglon = d.Renglon AND l.RenglonSub = d.RenglonSub
WHERE d.ID = @IDOrigen 
UPDATE #CompraDetalle
SET ID = @ID
SELECT @Renglon = 0.0
UPDATE #CompraDetalle
SET @Renglon = Renglon = @Renglon + 2048.0,
RenglonSub = 0
INSERT INTO cCompraD SELECT * FROM #CompraDetalle
DROP TABLE #CompraDetalle
SELECT @Almacen = MIN(Almacen) FROM CompraD WHERE ID = @ID
UPDATE Compra SET Almacen = @Almacen WHERE ID = @ID
SELECT @Conteo = @Conteo + 1
UPDATE Compra SET Estatus = 'CONCLUIDO', FechaConclusion = GETDATE() WHERE ID = @IDOrigen
END
END
FETCH NEXT FROM crCotizacion INTO @EmpresaRef, @IDOrigen, @Origen, @OrigenID, @Proveedor, @Moneda, @TipoCambio, @UltimoCambio, @Prioridad, @RenglonID, @FechaRequerida, @Condicion, @Vencimiento, @Importe, @Impuestos, @FechaEntrega, @SucursalDestino
END 
CLOSE crCotizacion
DEALLOCATE crCotizacion
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
SELECT 'Se Generaron '+LTRIM(CONVERT(char, @Conteo))+ ' '+@Mov+' (sin Afectar)'
END ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT Descripcion+' '+ISNULL(RTRIM(@OkRef), '') FROM MensajeLista WHERE Mensaje = @Ok
END
RETURN
END

