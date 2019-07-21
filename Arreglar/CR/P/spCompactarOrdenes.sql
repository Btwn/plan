SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCompactarOrdenes
@Empresa	char(5),
@Usuario	char(10),
@Modulo		char(5),
@AlmacenEsp	char(10) = NULL

AS BEGIN
DECLARE
@Ok			int,
@OkRef		varchar(255),
@FechaEmision	datetime,
@FechaRegistro	datetime,
@Sucursal		int,
@Mov		char(20),
@Proyecto		varchar(50),
@Almacen		char(10),
@AlmacenDestino	char(10),
@Moneda		char(10),
@Paquete		int,
@Costo		float,
@Precio		float,
@UltSucursal	int,
@UltMov		char(20),
@UltProyecto	varchar(50),
@UltAlmacen		char(10),
@UltAlmacenDestino	char(10),
@UltMoneda		char(10),
@FechaRequerida	datetime,
@MovID		varchar(20),
@Articulo		char(20),
@SubCuenta		varchar(50),
@Cantidad		float,
@CantidadA		float,
@CantidadInventario	float,
@Factor		float,
@Unidad		varchar(50),
@Conteo		int,
@ID			int,
@Renglon		float,
@MultiAlmacen	bit,
@Mensaje		varchar(255),
@AutoReservar	bit,
@SinReservar	bit
SELECT @Ok = NULL, @OkRef = NULL, @Conteo = 0, @ID = NULL, @Renglon = 0,
@UltMov = NULL, @UltProyecto= NULL, @UltAlmacen = NULL, @UltAlmacenDestino = NULL, @UltMoneda = NULL,
@FechaEmision = GETDATE(), @FechaRegistro = GETDATE(), @AlmacenEsp = NULLIF(NULLIF(RTRIM(@AlmacenEsp), ''), '(TODOS)'),
@SinReservar = 0
EXEC spExtraerFecha @FechaEmision OUTPUT
SELECT @AutoReservar = PedidosReservar
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @MultiAlmacen = InvMultiAlmacen
FROM EmpresaCfg2
WHERE Empresa = @Empresa
EXEC xpCompactarOrdenes @Empresa, @Usuario, @Modulo, @AlmacenEsp, @SinReservar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
CREATE TABLE #Reservar (
Renglon	float	NOT NULL PRIMARY KEY,
Cantidad	float	NULL)
DECLARE crOrdenes CURSOR FOR
SELECT i.Mov, i.MovID, i.Sucursal, i.Proyecto, i.Moneda, d.Almacen, i.AlmacenDestino, d.FechaRequerida, d.Articulo, d.SubCuenta, "Cantidad" = ISNULL(CantidadPendiente, 0)+ISNULL(CantidadReservada, 0), NULLIF(CantidadReservada, 0), d.Unidad, ISNULL(d.Factor, 1.0), "Paquete" = CONVERT(int, (ISNULL(CantidadPendiente, 0)+ISNULL(CantidadReservada, 0))) / (Cantidad/NULLIF(Paquete, 0)), Costo, Precio
FROM Inv i, InvD d, MovTipo mt
WHERE i.ID = d.ID AND i.Empresa = @Empresa AND i.Estatus = 'PENDIENTE'
AND mt.Modulo = @Modulo AND mt.Mov = i.Mov AND mt.Clave IN (/*'INV.SOL', */'INV.OT', 'INV.OI')
AND ISNULL(CantidadPendiente, 0)+ISNULL(CantidadReservada, 0) > 0
AND ((mt.Clave IN ('INV.OT', 'INV.OI') AND i.AlmacenDestino = ISNULL(@AlmacenEsp, i.AlmacenDestino))
/*OR  (mt.Clave IN ('INV.SOL')          AND d.Almacen        = ISNULL(@AlmacenEsp, d.Almacen))*/)
ORDER BY i.Mov, i.Sucursal, i.Proyecto, i.Moneda, i.AlmacenDestino, i.Almacen, d.FechaRequerida, d.Articulo, d.SubCuenta
OPEN crOrdenes
FETCH NEXT FROM crOrdenes INTO @Mov, @MovID, @Sucursal, @Proyecto, @Moneda, @Almacen, @AlmacenDestino, @FechaRequerida, @Articulo, @SubCuenta, @Cantidad, @CantidadA, @Unidad, @Factor, @Paquete, @Costo, @Precio
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF @Mov <> @UltMov OR @Proyecto <> @UltProyecto OR @Moneda <> @UltMoneda OR @AlmacenDestino <> @UltAlmacenDestino OR (@Almacen <> @UltAlmacen AND @MultiAlmacen = 0)
BEGIN
IF @ID IS NOT NULL AND @Ok IS NULL
BEGIN
EXEC spInv @ID, @Modulo, 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 0, 0, NULL,
NULL, NULL, NULL, NULL,
@Ok OUTPUT, @OkRef OUTPUT, NULL
IF @SinReservar = 0 AND @AutoReservar = 0 AND EXISTS(SELECT * FROM #Reservar) AND @Ok IS NULL
BEGIN
UPDATE InvD
SET CantidadA = r.Cantidad
FROM InvD d, #Reservar r
WHERE d.ID = @ID AND d.Renglon = r.Renglon
EXEC spInv @ID, @Modulo, 'RESERVAR', 'SELECCION', @FechaRegistro, NULL, @Usuario, 0, 0, NULL,
NULL, NULL, NULL, NULL,
@Ok OUTPUT, @OkRef OUTPUT, NULL
END
TRUNCATE TABLE #Reservar
END
IF @Ok IS NULL
BEGIN
INSERT Inv (Sucursal,  Empresa,  Mov,  Proyecto,  FechaEmision,  Moneda, TipoCambio,    Almacen,  AlmacenDestino,  Usuario,  Estatus,      Directo, OrigenTipo)
SELECT @Sucursal, @Empresa, @Mov, @Proyecto, @FechaEmision, @Moneda, m.TipoCambio, @Almacen, @AlmacenDestino, @Usuario, 'SINAFECTAR', 0,       'COMPACTADA'
FROM Mon m
WHERE m.Moneda = @Moneda
SELECT @ID = SCOPE_IDENTITY()
SELECT @Renglon = 0.0, @Conteo = @Conteo + 1
END
SELECT @UltMov = @Mov, @UltProyecto = @Proyecto, @UltMoneda = @Moneda, @UltAlmacen = @Almacen, @UltAlmacenDestino = @AlmacenDestino
END
IF @ID IS NOT NULL AND @Ok IS NULL
BEGIN
SELECT @Renglon = @Renglon + 2048.0, @CantidadInventario = @Cantidad * @Factor
IF @SinReservar = 0 AND @AutoReservar = 0 AND @CantidadA IS NOT NULL
INSERT #Reservar (Renglon, Cantidad) VALUES (@Renglon, @CantidadA)
INSERT InvD (Sucursal,  ID,  Renglon,  RenglonSub, RenglonID, Aplica, AplicaID, Almacen,  Articulo,  SubCuenta,  Unidad,  Cantidad,  Factor,  CantidadInventario,  Paquete,  FechaRequerida,  Costo,  Precio)
VALUES (@Sucursal, @ID, @Renglon, 0,          0,         @Mov,   @MovID,   @Almacen, @Articulo, @SubCuenta, @Unidad, @Cantidad, @Factor, @CantidadInventario, @Paquete, @FechaRequerida, @Costo, @Precio)
END
END
FETCH NEXT FROM crOrdenes INTO @Mov, @MovID, @Sucursal, @Proyecto, @Moneda, @Almacen, @AlmacenDestino, @FechaRequerida, @Articulo, @SubCuenta, @Cantidad, @CantidadA, @Unidad, @Factor, @Paquete, @Costo, @Precio
END  
CLOSE crOrdenes
DEALLOCATE crOrdenes
END
IF @ID IS NOT NULL AND @Ok IS NULL
BEGIN
EXEC spInv @ID, @Modulo, 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 0, 0, NULL,
NULL, NULL, NULL, NULL,
@Ok OUTPUT, @OkRef OUTPUT, NULL
IF @SinReservar = 0 AND @AutoReservar = 0 AND EXISTS(SELECT * FROM #Reservar) AND @Ok IS NULL
BEGIN
UPDATE InvD
SET CantidadA = r.Cantidad
FROM InvD d, #Reservar r
WHERE d.ID = @ID AND d.Renglon = r.Renglon
EXEC spInv @ID, @Modulo, 'RESERVAR', 'SELECCION', @FechaRegistro, NULL, @Usuario, 0, 0, NULL,
NULL, NULL, NULL, NULL,
@Ok OUTPUT, @OkRef OUTPUT, NULL
END
TRUNCATE TABLE #Reservar
END
IF @Ok IS NULL
SELECT @Mensaje = LTRIM(CONVERT(char, @Conteo))+' Ordenes Realizadas.'
ELSE
SELECT @Mensaje = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Mensaje
RETURN
END

