SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spReabastecer
@SucursalOrigen	int,
@Empresa	char(5),
@Usuario	char(10),
@Desde		datetime,
@Hasta		datetime

AS BEGIN
DECLARE
@Sucursal		int,
@InvID		int,
@FechaEmision	datetime,
@Moneda		char(10),
@TipoCambio		float,
@AlmacenOrigen	char(10),
@Almacen		char(10),
@UltAlmacen		char(10),
@Articulo		char(20),
@SubCuenta		varchar(50),
@Unidad		varchar(50),
@Cantidad		float,
@CantidadInventario	float,
@RutaDistribucion	varchar(50),
@OrdenTransferencia	char(20),
@OrdenTraspaso	char(20),
@InvMov		char(20),
@Renglon		float,
@RenglonID		int,
@Conteo		int,
@Ok			int,
@OkRef		varchar(255)
SELECT @FechaEmision = GETDATE(), @UltAlmacen = NULL, @Ok = NULL, @OkRef = NULL, @Conteo = 0, @InvID = NULL
EXEC spExtraerFecha @FechaEmision OUTPUT
SELECT @Moneda = m.Moneda, @TipoCambio = m.TipoCambio
FROM EmpresaCfg cfg, Mon m
WHERE m.Moneda = cfg.ContMoneda AND cfg.Empresa = @Empresa
SELECT @RutaDistribucion = RutaDistribucion
FROM EmpresaCfg2
WHERE Empresa = @Empresa
SELECT @OrdenTransferencia = InvOrdenTransferencia,
@OrdenTraspaso      = InvOrdenTraspaso
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
BEGIN TRANSACTION
DECLARE crReabastecer CURSOR FOR
SELECT Almacen, Articulo, SubCuenta, Unidad, SUM(Cantidad), SUM(CantidadInventario)
FROM Reabastecer
WHERE Empresa = @Empresa AND FechaRegistro BETWEEN @Desde AND @Hasta
GROUP BY Almacen, Articulo, SubCuenta, Unidad
ORDER BY Almacen, Articulo, SubCuenta, Unidad
OPEN crReabastecer
FETCH NEXT FROM crReabastecer INTO @Almacen, @Articulo, @SubCuenta, @Unidad, @Cantidad, @CantidadInventario
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF @Almacen <> @UltAlmacen
BEGIN
IF @InvID IS NOT NULL UPDATE Inv SET RenglonID = @RenglonID WHERE ID = @InvID
SELECT @AlmacenOrigen = NULL
SELECT @AlmacenOrigen = NULLIF(RTRIM(AlmacenOrigen), '')
FROM RutaDistribucionD
WHERE Ruta = @RutaDistribucion AND AlmacenDestino = @Almacen
IF @AlmacenOrigen IS NULL SELECT @Ok = 20395, @OkRef = @Almacen
IF @Ok IS NULL
BEGIN
SELECT @Sucursal = @SucursalOrigen
SELECT @Sucursal = ISNULL(Sucursal, @SucursalOrigen) FROM Alm WHERE Almacen = @AlmacenOrigen
IF @Sucursal <> (SELECT Sucursal FROM Alm WHERE Almacen = @Almacen)
SELECT @InvMov = @OrdenTraspaso
ELSE
SELECT @InvMov = @OrdenTransferencia
INSERT Inv (Sucursal, SucursalOrigen,  Empresa,  Usuario,  Estatus,     Mov,     FechaEmision,  FechaRequerida, Almacen,        AlmacenDestino, Moneda,  TipoCambio)
SELECT @Sucursal, @SucursalOrigen, @Empresa, @Usuario, 'CONFIRMAR', @InvMov, @FechaEmision, @FechaEmision,  @AlmacenOrigen, @Almacen,       @Moneda, @TipoCambio
SELECT @InvID = SCOPE_IDENTITY()
SELECT @Renglon = 0.0, @RenglonID = 0, @Conteo = @Conteo + 1
END
END
IF @Ok IS NULL AND @InvID IS NOT NULL
BEGIN
SELECT @Renglon = @Renglon + 2048.0, @RenglonID = @RenglonID + 1
INSERT InvD (ID,     Renglon,  RenglonSub,  RenglonID,  Almacen,        Articulo,  SubCuenta,  Unidad,  Cantidad,  CantidadInventario,  FechaRequerida)
VALUES (@InvID, @Renglon, 0,           @RenglonID, @AlmacenOrigen, @Articulo, @SubCuenta, @Unidad, @Cantidad, @CantidadInventario, @FechaEmision)
END
END
FETCH NEXT FROM crReabastecer INTO @Almacen, @Articulo, @SubCuenta, @Unidad, @Cantidad, @CantidadInventario
END 
CLOSE crReabastecer
DEALLOCATE crReabastecer
IF @InvID IS NOT NULL UPDATE Inv SET RenglonID = @RenglonID WHERE ID = @InvID
IF @Ok IS NULL
BEGIN
UPDATE Venta SET Reabastecido = 1 WHERE Empresa = @Empresa AND FechaRegistro BETWEEN @Desde AND @Hasta AND Reabastecido = 0
UPDATE Inv   SET Reabastecido = 1 WHERE Empresa = @Empresa AND FechaRegistro BETWEEN @Desde AND @Hasta AND Reabastecido = 0
UPDATE EmpresaGral SET ReabastecidoHasta = @Hasta WHERE Empresa = @Empresa
COMMIT TRANSACTION
SELECT 'Se Generaron '+LTRIM(CONVERT(char, @Conteo))+ ' Ordenes (por Confirmar)'
END ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT Descripcion+' '+ISNULL(RTRIM(@OkRef), '') FROM MensajeLista WHERE Mensaje = @Ok
END
RETURN
END

