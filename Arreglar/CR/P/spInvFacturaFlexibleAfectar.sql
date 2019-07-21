SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvFacturaFlexibleAfectar
@Empresa		varchar(5),
@Sucursal		int,
@Usuario		varchar(10),
@Accion			varchar(20),
@Estatus		varchar(15),
@Modulo			varchar(5),
@ID			int,
@Ok			int OUTPUT,
@OkRef			varchar(255) OUTPUT

AS BEGIN
DECLARE
@MovTipo		varchar(20),
@SubMovTipo		varchar(20),
@Mov			varchar(20),
@FechaEmision		datetime,
@Concepto		varchar(50),
@Proyecto		varchar(50),
@Actividad		varchar(20),
@UEN			int,
@Moneda			varchar(10),
@TipoCambio		float,
@Cliente		varchar(10),
@EnviarA		int,
@Almacen		varchar(10),
@Agente			varchar(10),
@AgenteServicio		varchar(10),
@AgenteComision		float,
@Formaenvio		varchar(50),
@Importe		money,
@Impuestos		money,
@ComisionTotal		money,
@OrigenTipo		varchar(10),
@Origen			varchar(20),
@OrigenID		varchar(20),
@Articulo		varchar(20),
@Cantidad		float,
@Precio			float,
@Unidad			varchar(50),
@IDBonificacion		int,
@Renglon		float,
@RenglonID		int,
@OMov			varchar(20),
@DModulo		varchar(5),
@OModulo		varchar(5),
@OMovID			varchar(20),
@MovID			varchar(20),
@OID			int,
@DID			int,
@IDFactura		int,
@MovFactura		varchar(20),
@MovAplicacion		varchar(20),
@ZonaImpuesto		varchar(30),
@Impuesto1		float,
@Impuesto2		float,
@Impuesto3		float,
@SubCuenta		varchar(50),
@Tipo			varchar(20),
@RenglonTipo		varchar(1),
@IDAplicacion		int,
@Clave			varchar(20)
SELECT @MovTipo = mt.Clave,
@SubMovTipo = mt.SubClave,
@FechaEmision = v.FechaEmision,
@Concepto = v.Concepto,
@Proyecto = v.Proyecto,
@Actividad = v.Actividad,
@UEN = v.UEN,
@Moneda = v.Moneda,
@TipoCambio = v.TipoCambio,
@Cliente = v.Cliente,
@EnviarA = v.EnviarA,
@Almacen = v.Almacen,
@Agente = v.Agente,
@AgenteServicio = v.Agenteservicio,
@AgenteComision = v.Agentecomision,
@FormaEnvio = v.FormaEnvio,
@OrigenTipo = v.OrigenTipo,
@Origen = v.Origen,
@OrigenID = v.OrigenID
FROM Venta v
JOIN MovTipo mt
ON mt.Mov = v.Mov
AND mt.Modulo =  @Modulo
AND v.ID = @ID
SELECT
@MovFactura = VentaFactura,
@MovAplicacion = cxcAplicacion
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
SELECT
@Mov = VentaBonificacion
FROM EmpresaCfgMovVenta
WHERE Empresa = @Empresa
IF @Modulo = 'VTAS' AND @MovTipo = 'VTAS.F' AND @SubMovTipo = 'FF.FF' AND  @OK IS NULL
BEGIN
IF @Accion = 'AFECTAR' AND @Estatus = 'SINAFECTAR'
BEGIN
INSERT Venta (Empresa,  Mov,  FechaEmision,  Concepto,  Proyecto,  Actividad,  UEN,  Moneda,  TipoCambio,  Usuario,  Estatus,      Cliente,  EnviarA,  Almacen,  Agente,  AgenteServicio,  AgenteComision,  FormaEnvio,    Importe,  Impuestos,  ComisionTotal, OrigenTipo,  Origen,  OrigenID,  Sucursal)
VALUES (@Empresa, @Mov, @FechaEmision, @Concepto, @Proyecto, @Actividad, @UEN, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @Cliente, @EnviarA, @Almacen, @Agente, @AgenteServicio, @AgenteComision, @FormaEnvio, @Importe, @Impuestos, @ComisionTotal,@OrigenTipo, @Origen, @OrigenID, @Sucursal)
IF @@ERROR <> 0 SET @OK = 1
SELECT @IDBonificacion = SCOPE_IDENTITY()
IF @OK IS NULL
BEGIN
SET @Renglon = 2048.0
SET @RenglonID = 1
DECLARE VentaFlexibleD CURSOR FOR
SELECT Articulo, ISNULL(SUM(Cantidad), 0), Precio
FROM VentaFlexibleD
WHERE ID = @ID
GROUP BY Articulo, Precio
OPEN VentaFlexibleD
FETCH NEXT FROM VentaFlexibleD INTO @Articulo, @Cantidad, @Precio
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @ZonaImpuesto = ZonaImpuesto FROM Cte WHERE Cliente = @Cliente
SELECT @Tipo = Tipo, @Impuesto1 = Impuesto1, @Impuesto2 = Impuesto2, @Impuesto3 = Impuesto3 FROM Art WHERE Articulo = @Articulo
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto2 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto3 OUTPUT
EXEC spTipoImpuesto @Modulo, @IDBonificacion, @Mov, @FechaEmision, @Empresa, @Sucursal, @Cliente, @EnviarA, @Articulo = @Articulo, @EnSilencio = 1, @Impuesto1 = @Impuesto1 OUTPUT, @Impuesto2 = @Impuesto2 OUTPUT, @Impuesto3 = @Impuesto3 OUTPUT
EXEC spRenglonTipo @Tipo, NULL, @RenglonTipo OUTPUT
INSERT VentaD (ID,              Renglon,  RenglonID,  RenglonSub, Cantidad,  Unidad,  Almacen,  Articulo,  Precio,  Sucursal,  UEN,  Impuesto1,  Impuesto2,  Impuesto3,  RenglonTipo)
VALUES (@IDBonificacion, @Renglon, @RenglonID, 0,          @Cantidad, @Unidad, @Almacen, @Articulo, @Precio, @Sucursal, @UEN, @Impuesto1, @Impuesto2, @Impuesto3, @RenglonTipo)
IF @@ERROR <> 0 SET @Ok = 1
SET @Renglon = @Renglon + 2048.0
SET @RenglonID = @RenglonID + 1
FETCH NEXT FROM VentaFlexibleD INTO @Articulo, @Cantidad, @Precio
END
CLOSE VentaFlexibleD
DEALLOCATE VentaFlexibleD
END
IF @OK IS NULL
BEGIN
UPDATE Venta SET Importe = @Importe WHERE ID = @IDBonificacion
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
EXEC spAfectar @Modulo, @IDBonificacion, @Accion,'TODO', NULL ,@Usuario, NULL, 1, @Ok OUTPUT, @OkRef OUTPUT, @Conexion = 1
SELECT @OMov = Mov, @OMovID = MovID FROM Venta WHERE ID= @ID
SELECT @MovID = MovID FROM Venta WHERE ID = @IDBonificacion
IF @OK IS NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @OMov, @OMovID, @Modulo, @IDBonificacion, @Mov, @MovID, @OK OUTPUT
IF @OK IS NULL
BEGIN
DECLARE VentaFlexibleFactura CURSOR FOR
SELECT Cliente
FROM VentaFlexibleD
WHERE ID = @ID
GROUP BY Cliente
OPEN VentaFlexibleFactura
FETCH NEXT FROM VentaFlexibleFactura INTO @Cliente
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
INSERT Venta (Empresa,  Mov,         FechaEmision,  Concepto,  Proyecto,  Actividad,  UEN,  Moneda,  TipoCambio,  Usuario,  Estatus,      Cliente,  EnviarA,  Almacen,  Agente,  AgenteServicio,  AgenteComision,  FormaEnvio,    Importe,  Impuestos,  ComisionTotal, OrigenTipo,  Origen,  OrigenID,  Sucursal)
VALUES (@Empresa, @MovFactura, @FechaEmision, @Concepto, @Proyecto, @Actividad, @UEN, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @Cliente, @EnviarA, @Almacen, @Agente, @AgenteServicio, @AgenteComision, @FormaEnvio, @Importe, @Impuestos, @ComisionTotal,@OrigenTipo, @Origen, @OrigenID, @Sucursal)
IF @@ERROR <> 0 SET @OK = 1
SELECT @IDFactura = SCOPE_IDENTITY()
IF @OK IS NULL
BEGIN
SET @Renglon = 2048.0
SET @RenglonID = 1
DECLARE VentaFlexibleFacturaD CURSOR FOR
SELECT Articulo, ISNULL(SUM(ISNULL(Cantidad,0.0)),0.0) , ISNULL(Precio, 0.0)
FROM VentaFlexibleD
WHERE ID = @ID AND Cliente = @Cliente
GROUP BY Articulo, Precio
OPEN VentaFlexibleFacturaD
FETCH NEXT FROM VentaFlexibleFacturaD INTO @Articulo, @Cantidad, @Precio
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @ZonaImpuesto = ZonaImpuesto FROM Cte WHERE Cliente = @Cliente
SELECT @Tipo = Tipo, @Impuesto1 = Impuesto1, @Impuesto2 = Impuesto2, @Impuesto3 = Impuesto3 FROM Art WHERE Articulo = @Articulo
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto2 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto3 OUTPUT
EXEC spTipoImpuesto @Modulo, @IDFactura, @MovFactura, @FechaEmision, @Empresa, @Sucursal, @Cliente, NULL, @Articulo = @Articulo, @EnSilencio = 1, @Impuesto1 = @Impuesto1 OUTPUT, @Impuesto2 = @Impuesto2 OUTPUT, @Impuesto3 = @Impuesto3 OUTPUT
EXEC spRenglonTipo @Tipo, NULL, @RenglonTipo OUTPUT
INSERT VentaD (ID,         Renglon,  RenglonID,  RenglonSub, Cantidad,  Unidad,  Almacen,  Articulo,  Precio,  Sucursal,  UEN,   Impuesto1,   Impuesto2,   Impuesto3,  RenglonTipo)
VALUES (@IDFactura, @Renglon, @RenglonID, 0,          @Cantidad, @Unidad, @Almacen, @Articulo, @Precio, @Sucursal, @UEN,  @Impuesto1,  @Impuesto2,  @Impuesto3, @RenglonTipo)
IF @@ERROR <> 0 SET @Ok = 1
SET @Renglon = @Renglon + 2048.0
SET @RenglonID = @RenglonID + 1
FETCH NEXT FROM VentaFlexibleFacturaD INTO @Articulo, @Cantidad, @Precio
END
CLOSE VentaFlexibleFacturaD
DEALLOCATE VentaFlexibleFacturaD
END
IF @Ok IS NULL
EXEC spAfectar @Modulo, @IDFactura, @Accion,'TODO', NULL ,@Usuario, NULL, 1, @Ok OUTPUT, @OkRef OUTPUT, @Conexion = 1
IF @OK IS NULL
BEGIN
SELECT @MovID = MOVID FROM Venta WHERE ID = @IDFactura
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @OMov, @OMovID, @Modulo, @IDFactura, @MovFactura, @MovID, @OK OUTPUT
END
FETCH NEXT FROM VentaFlexibleFactura INTO @Cliente
END
CLOSE VentaFlexibleFactura
DEALLOCATE VentaFlexibleFactura
END
IF @OK IS NULL
BEGIN
SELECT @DID = mf.DID, @DModulo = mf.DModulo, @Clave = mt.Clave
FROM MovFlujo mf JOIN MovTipo mt
ON mf.DMov = mt.Mov AND mt.Modulo = mf.DModulo
WHERE mf.OID = @IDBonificacion AND mf.OModulo = 'VTAS' AND mf.DModulo = 'CXC'
IF @Clave = 'CXC.NC' AND @DModulo = 'CXC'
BEGIN
EXEC @IDAplicacion = spAfectar 'CXC', @DID, 'GENERAR', 'Todo', @MovAplicacion, @Usuario, NULL, 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @Conexion = 1
IF @Ok >= 80000 SELECT @Ok = NULL, @OkRef = NULL
SELECT @Mov = Mov, @MovID = MovID FROM Venta WHERE ID = @ID
SELECT @Importe = Importe + Impuestos FROM Venta WHERE ID = @IDBonificacion
IF @OK IS NULL
BEGIN
INSERT CxcD (ID,            Renglon, RenglonSub, Aplica, AplicaID, Importe)
VALUES (@IDAplicacion, 2048.0,  0,          @Mov,   @MovID,   @Importe)
IF @@ERROR <> 0 SET @Ok = 1
END
IF @OK IS NULL
EXEC spAfectar 'CXC', @IDAplicacion, 'AFECTAR', 'Todo', NULL, @Usuario, NULL, 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @Conexion = 1
END
END
END ELSE
IF @Accion = 'CANCELAR'  AND @Estatus = 'CONCLUIDO' AND @OK IS NULL
BEGIN
DECLARE VentaFlexibleCancelar CURSOR FOR
SELECT DID
FROM MovFlujo
WHERE OID = @ID AND DModulo = @Modulo
OPEN VentaFlexibleCancelar
FETCH NEXT FROM VentaFlexibleCancelar INTO @OID
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
EXEC spAfectar @Modulo, @OID, @Accion,'TODO', NULL ,@Usuario, NULL, 1, @Ok OUTPUT, @OkRef OUTPUT, @Conexion = 1
FETCH NEXT FROM VentaFlexibleCancelar INTO @OID
END
CLOSE VentaFlexibleCancelar
DEALLOCATE VentaFlexibleCancelar
END
END
END

