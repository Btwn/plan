SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSAUXGenerarInv
@Modulo			varchar(5),
@ID		        int,
@Accion			varchar(20),
@Empresa        varchar(5),
@Sucursal		int,
@Usuario		varchar(10),
@Mov			varchar(20),
@MovID			varchar(20),
@Estatus		varchar(15),
@MovTipo		varchar(20),
@Almacen		varchar(10),
@FechaEmision	datetime,
@ModuloDestino	varchar(5),
@MovDestino		varchar(20),
@Ok             int           	OUTPUT,
@OkRef          varchar(255)  	OUTPUT

AS BEGIN
DECLARE
@CfgMultiUnidades		bit,
@CfgMultiUnidadesNivel	char(20),
@Moneda					varchar(10),
@TipoCambio				float,
@TipoCosteo				varchar(20),
@IDGenerar				int,
@MovIDDestino			varchar(20),
@DetalleTipo			varchar(20),
@Articulo				varchar(20),
@Material				varchar(20),
@Cantidad				float,
@ContID					int,
@Renglon				float,
@SubProducto			varchar(50),
@SubCuenta				varchar(50),
@ArtTipo	         	varchar(20),
@VolverAfectar			int,
@RenglonID				int,
@Merma					float,
@Unidad					varchar(50),
@RenglonTipo			char(1),
@Desperdicio			float,
@CantidadInventario		float,
@Costo					float,
@MovIDGenerar			varchar(20),
@IDOrigenModulo			int,
@CantidadArt			float,
@Juego					varchar	(10),
@RenglonJgo				float,
@Opcion					varchar (20),
@Origen					varchar (20),
@OrigenID				varchar (20),
@IDOrigen				int,
@EstatusOrigen			varchar(15),
@OrigenTipo				char(5),
@OrigenSAUX				varchar (20),
@OrigenIDSAUX			varchar (20),
@OrigenTipoSAUX			char(5),
@OrigenSS				varchar (20),
@OrigenIDSS				varchar (20),
@SucursalAlmacen		int,
@AlmacenSucursal		varchar(10)
SELECT @Origen = Origen,
@OrigenID = OrigenID,
@OrigenTipo = OrigenTipo
FROM SAUX
WHERE ID = @ID
SELECT @OrigenSAUX = @Origen,
@OrigenIDSAUX = @OrigenID,
@OrigenTipoSAUX = @OrigenTipo
IF @MovTipo = 'SAUX.S'
SELECT @IDOrigen = ID,
@Origen = Origen,
@OrigenID = OrigenID,
@OrigenTipo = OrigenTipo
FROM SAUX
WHERE ID = (SELECT ID FROM SAUX WHERE Mov = @Origen AND MovID = @OrigenID AND Empresa = @Empresa)
IF @OrigenTipo = 'VTAS'
SELECT @IDOrigenModulo = ID FROM Venta WHERE Mov = @Origen AND MovID = @OrigenID
IF @OrigenTipo = 'COMS'
SELECT @IDOrigenModulo = ID FROM Compra WHERE Mov = @Origen AND MovID = @OrigenID
SELECT @CfgMultiUnidades         = MultiUnidades,
@CfgMultiUnidadesNivel    = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
SELECT @Moneda = ContMoneda FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @TipoCambio = TipoCambio FROM Mon WHERE Moneda = @Moneda
SELECT @TipoCosteo = ISNULL(NULLIF(RTRIM(UPPER(TipoCosteo)), ''), 'PROMEDIO')
FROM EmpresaCfg
WHERE Empresa = @Empresa
IF @Accion = 'CANCELAR'
BEGIN
SELECT @IDGenerar = NULL
DECLARE crCancelar CURSOR FOR
SELECT ID, Mov, MovID
FROM Inv
WHERE OrigenTipo = @Modulo
AND Origen = @Mov
AND OrigenID = @MovID
AND Estatus IN ('CONCLUIDO', 'PENDIENTE')
AND Empresa = @Empresa
OPEN crCancelar
FETCH NEXT FROM crCancelar INTO @IDGenerar, @MovDestino, @MovIDDestino
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF @IDGenerar IS NOT NULL
EXEC spInv @IDGenerar, @ModuloDestino, 'CANCELAR', 'TODO', @FechaEmision, NULL, @Usuario, 1, 0, NULL,
@MovDestino, @MovIDDestino OUTPUT, @IDGenerar, @ContID,
@Ok OUTPUT, @OkRef OUTPUT, @VolverAfectar OUTPUT
END
FETCH NEXT FROM crCancelar INTO @IDGenerar, @MovDestino, @MovIDDestino
END
CLOSE crCancelar
DEALLOCATE crCancelar
RETURN
END
IF (SELECT COUNT(*) FROM ArtMaterial WHERE Articulo IN (SELECT Producto FROM SAUXD WHERE ID = @ID GROUP BY Producto) AND ISNULL(Cantidad,0) < 1) > 0 AND @Ok IS NULL
BEGIN
SELECT @Ok = 25315, @OkRef = (SELECT TOP 1 Articulo FROM ArtMaterial WHERE Articulo IN (SELECT Producto FROM SAUXD WHERE ID = @ID GROUP BY Producto) AND ISNULL(Cantidad,0) < 1) + ' - ' + (SELECT TOP 1 Material FROM ArtMaterial WHERE Articulo IN (SELECT Producto FROM SAUXD WHERE ID = @ID GROUP BY Producto) AND ISNULL(Cantidad,0) < 1)
END
IF (SELECT COUNT(*) FROM ArtMaterial WHERE Articulo IN (SELECT Producto FROM SAUXD WHERE ID = @ID GROUP BY Producto) AND ISNULL(NULLIF(LugarConsumo,''),'(Sol. Pendiente)') = '(Sol. Pendiente)') > 0
IF @MovTipo = 'SAUX.SS'
IF @Estatus = 'PENDIENTE' AND @Accion = 'AFECTAR'
SELECT @MovDestino = NULL
ELSE
RETURN
SELECT @IDOrigen = ID,
@EstatusOrigen = Estatus
FROM SAUX
WHERE Mov = (SELECT Origen FROM SAUX WHERE Mov = @Mov AND MovID = @MovID AND Empresa = @Empresa)
AND MovID = (SELECT OrigenID FROM SAUX WHERE Mov = @Mov AND MovID = @MovID AND Empresa = @Empresa)
AND Estatus IN ('CONCLUIDO', 'PENDIENTE')
AND Empresa = @Empresa
IF @EstatusOrigen = 'CONCLUIDO'
DECLARE crEncabezado CURSOR FOR
SELECT DISTINCT m.Almacen, CASE WHEN m.LugarConsumo = '(Sol. Concluida)' THEN (SELECT TOP 1 SAUXMovInvConcluida FROM MovTipo WHERE Modulo = @Modulo AND Clave = 'SAUX.SS') ELSE (SELECT Movimiento FROM SAUXServicio WHERE Servicio = m.LugarConsumo) END
FROM SAUXD d JOIN ArtMaterial m
ON d.Producto = m.Articulo JOIN Art a
ON a.Articulo = m.Articulo JOIN SAUXServicio s
ON d.Servicio = s.Servicio
WHERE m.Articulo IN (CASE WHEN @OrigenTipo = 'VTAS' THEN (SELECT d.Articulo FROM VentaD d JOIN Art a ON a.Articulo = d.Articulo WHERE ID = @IDOrigenModulo AND a.Tipo = 'Servicio' AND a.SAUX = 1)
ELSE (SELECT d.Articulo FROM CompraD d JOIN Art a ON a.Articulo = d.Articulo WHERE ID = @IDOrigenModulo AND a.Tipo = 'Servicio' AND a.SAUX = 1)END)
AND m.Material NOT IN ((SELECT Articulo FROM dbo.fnSAUXArticuloNoDisponibleSolConcluida(@Empresa, @Origen, @OrigenID, @OrigenSAUX, @OrigenIDSAUX, m.Cantidad)))
ELSE
IF @MovTipo = 'SAUX.SS'
DECLARE crEncabezado CURSOR FOR
SELECT DISTINCT m.Almacen, CASE WHEN ISNULL(NULLIF(m.LugarConsumo,''),'(Sol. Pendiente)') = '(Sol. Pendiente)' THEN (SELECT TOP 1 SAUXMovInvPendiente FROM MovTipo WHERE Modulo = @Modulo AND Clave = 'SAUX.SS') END
FROM SAUXD d JOIN ArtMaterial m
ON d.Producto = m.Articulo JOIN Art a
ON a.Articulo = m.Articulo JOIN SAUXServicio s
ON d.Servicio = s.Servicio
WHERE m.Articulo IN (CASE WHEN @OrigenTipo = 'VTAS' THEN (SELECT d.Articulo FROM VentaD d JOIN Art a ON a.Articulo = d.Articulo WHERE ID = @IDOrigenModulo AND a.Tipo = 'Servicio' AND a.SAUX = 1)
ELSE (SELECT d.Articulo FROM CompraD d JOIN Art a ON a.Articulo = d.Articulo WHERE ID = @IDOrigenModulo AND a.Tipo = 'Servicio' AND a.SAUX = 1)END)
AND ISNULL(NULLIF(m.LugarConsumo,''),'(Sol. Pendiente)') = '(Sol. Pendiente)'
ELSE
IF @MovTipo = 'SAUX.S'
DECLARE crEncabezado CURSOR FOR
SELECT DISTINCT Almacen, CASE WHEN LugarConsumo = '(Sol. Concluida)' THEN (SELECT TOP 1 SAUXMovInvConcluida FROM MovTipo WHERE Modulo = @Modulo AND Clave = 'SAUX.SS') ELSE (SELECT Movimiento FROM SAUXServicio WHERE Servicio = LugarConsumo) END
FROM ArtMaterial
WHERE Articulo IN (CASE WHEN @OrigenTipo = 'VTAS' THEN (SELECT d.Articulo FROM VentaD d JOIN Art a ON a.Articulo = d.Articulo WHERE ID = @IDOrigenModulo AND a.Tipo = 'Servicio' AND a.SAUX = 1)
ELSE (SELECT d.Articulo FROM CompraD d JOIN Art a ON a.Articulo = d.Articulo WHERE ID = @IDOrigenModulo AND a.Tipo = 'Servicio' AND a.SAUX = 1)END)
AND LugarConsumo in (
SELECT DISTINCT s.Servicio
FROM SAUXD d JOIN Art a
ON a.Articulo = d.Producto JOIN SAUXServicio s
ON d.Servicio = s.Servicio
WHERE d.Producto IN (CASE WHEN @OrigenTipo = 'VTAS' THEN (SELECT d.Articulo FROM VentaD d JOIN Art a ON a.Articulo = d.Articulo WHERE ID = @IDOrigenModulo AND a.Tipo = 'Servicio' AND a.SAUX = 1)
ELSE (SELECT d.Articulo FROM CompraD d JOIN Art a ON a.Articulo = d.Articulo WHERE ID = @IDOrigenModulo AND a.Tipo = 'Servicio' AND a.SAUX = 1)END)
AND d.ID = @ID
)
OPEN crEncabezado
FETCH NEXT FROM crEncabezado INTO @Almacen, @MovDestino
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL AND @MovDestino IS NOT NULL
BEGIN
SELECT @DetalleTipo = 'Salida', @Renglon = 0.0, @RenglonID = 0
SELECT @SucursalAlmacen = Sucursal FROM Alm WHERE Almacen = @Almacen
IF @SucursalAlmacen <> @Sucursal
SELECT @AlmacenSucursal = AlmacenPrincipal FROM Sucursal WHERE Sucursal = @Sucursal
ELSE
SELECT @AlmacenSucursal = @Almacen
IF NULLIF(@AlmacenSucursal,'') IS NULL SET @OK = 10570
IF @OrigenTipo = 'VTAS' AND @OK IS NULL
INSERT Inv (OrigenTipo, Origen, OrigenID, Empresa,  Usuario,  Estatus,      Mov,         FechaEmision,  Proyecto,   Moneda,   TipoCambio,   Referencia,   Observaciones,   Prioridad,   Almacen,          Directo, VerLote, UEN,   Concepto)
SELECT @Modulo,    @Mov,   @MovID,   @Empresa, @Usuario, 'SINAFECTAR', @MovDestino, @FechaEmision, v.Proyecto, v.Moneda, m.TipoCambio, v.Referencia, v.Observaciones, v.Prioridad, @AlmacenSucursal, 0,       1,       v.UEN, v.Concepto
FROM Venta v, Mon m
WHERE m.Moneda = v.Moneda AND v.ID = @IDOrigenModulo
ELSE
IF @OrigenTipo = 'COMS' AND @OK IS NULL
INSERT Inv (OrigenTipo, Origen, OrigenID, Empresa,  Usuario,  Estatus,      Mov,         FechaEmision,  Proyecto,   Moneda,   TipoCambio,   Referencia,   Observaciones,   Prioridad,   Almacen,          Directo, VerLote, UEN,   Concepto)
SELECT @Modulo,    @Mov,   @MovID,   @Empresa, @Usuario, 'SINAFECTAR', @MovDestino, @FechaEmision, v.Proyecto, v.Moneda, m.TipoCambio, v.Referencia, v.Observaciones, v.Prioridad, @AlmacenSucursal, 0,       1,       v.UEN, v.Concepto
FROM Compra v, Mon m
WHERE m.Moneda = v.Moneda AND v.ID = @IDOrigenModulo
SELECT @IDGenerar = @@IDENTITY
IF @OrigenTipo = 'VTAS'
DECLARE crArticulo CURSOR FOR
SELECT d.Articulo, d.SubCuenta, d.Cantidad
FROM VentaD d
JOIN Art a ON a.Articulo = d.Articulo
WHERE ID = @IDOrigenModulo
AND a.Tipo = 'Servicio'
AND a.SAUX = 1
ELSE
IF @OrigenTipo = 'COMS'
DECLARE crArticulo CURSOR FOR
SELECT d.Articulo, d.SubCuenta, d.Cantidad
FROM CompraD d
JOIN Art a ON a.Articulo = d.Articulo
WHERE ID = @IDOrigenModulo
AND a.Tipo = 'Servicio'
AND a.SAUX = 1
OPEN crArticulo
FETCH NEXT FROM crArticulo INTO @Articulo, @SubProducto, @CantidadArt
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @OrigenSS = NULL, @OrigenIDSS = NULL
SELECT @OrigenSS = Origen,
@OrigenIDSS = OrigenID
FROM SAUX
WHERE ID = @ID
IF @MovTipo = 'SAUX.SS'
DECLARE crDetalle CURSOR FOR
SELECT m.Material, m.SubCuenta, ISNULL(m.Cantidad,1) * @CantidadArt, m.Merma, m.Desperdicio, m.Unidad, m.Almacen
FROM ArtMaterial m
JOIN Art a ON a.Articulo = m.Articulo
WHERE m.Articulo = @Articulo
AND ISNULL(NULLIF(m.LugarConsumo,''), '(Sol. Pendiente)') = '(Sol. Pendiente)'
AND m.Almacen = @Almacen
ELSE
IF @EstatusOrigen = 'CONCLUIDO'
DECLARE crDetalle CURSOR FOR
SELECT m.Material, m.SubCuenta, ISNULL(m.Cantidad,1) * @CantidadArt, m.Merma, m.Desperdicio, m.Unidad, m.Almacen
FROM ArtMaterial m
JOIN Art a ON a.Articulo = m.Articulo
WHERE m.Articulo = @Articulo
AND m.Almacen = @Almacen
AND m.Material NOT IN ((SELECT Articulo FROM dbo.fnSAUXArticuloNoDisponibleServicioConcluido(@Empresa, @Origen, @OrigenID, @OrigenSAUX, @OrigenIDSAUX, @OrigenSS, @OrigenIDSS, m.Cantidad)))
ELSE
IF @MovTipo = 'SAUX.S'
DECLARE crDetalle CURSOR FOR
SELECT m.Material, m.SubCuenta, ISNULL(m.Cantidad,1) * @CantidadArt, m.Merma, m.Desperdicio, m.Unidad, m.Almacen
FROM ArtMaterial m
JOIN Art a ON a.Articulo = m.Articulo
WHERE m.Articulo = @Articulo
AND m.Almacen = @Almacen
AND m.LugarConsumo IN (SELECT Servicio FROM dbo.fnSAUXArticuloNoDisponibleServicio(@Empresa, @IDOrigen, @Origen, @OrigenID, @Articulo, @ID))
OPEN crDetalle
FETCH NEXT FROM crDetalle INTO @Material, @SubCuenta, @Cantidad, @Merma, @Desperdicio, @Unidad, @Almacen
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL AND ISNULL(@Cantidad, 0) <> 0
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
EXEC xpCantidadInventario @Material, @SubCuenta, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
SELECT @ArtTipo = Tipo
FROM Art
WHERE Articulo = @Material
EXEC spRenglonTipo @ArtTipo, @SubCuenta, @RenglonTipo OUTPUT
SELECT @Renglon = @Renglon + 2048.0, @RenglonID = @RenglonID + 1
SELECT @Costo = NULL
EXEC spVerCosto @Sucursal, @Empresa, NULL, @Material, @SubCuenta, @Unidad, @TipoCosteo, @Moneda, @TipoCambio, @Costo OUTPUT, 0
SELECT @SucursalAlmacen = Sucursal FROM Alm WHERE Almacen = @Almacen
IF @SucursalAlmacen <> @Sucursal
SELECT @AlmacenSucursal = AlmacenPrincipal FROM Sucursal WHERE Sucursal = @Sucursal
ELSE
SELECT @AlmacenSucursal = @Almacen
IF NULLIF(@AlmacenSucursal,'') IS NULL SET @OK = 10570
IF @AlmacenSucursal = '(Demanda)' SELECT @OK = 20830, @OkRef = @AlmacenSucursal + ' ' + @Material + ' ' + @SubCuenta
IF @Ok IS NULL
INSERT InvD (ID,     Renglon,  RenglonSub, RenglonID,  RenglonTipo,  Aplica, AplicaID, Almacen,         Producto,  SubProducto,  ProdSerieLote,             Articulo,  SubCuenta,  Cantidad,  Merma,  Desperdicio,  Unidad,  CantidadInventario,  Factor, Tipo,         Costo)
VALUES (@IDGenerar, @Renglon, 0,          @RenglonID, @RenglonTipo, @Mov,   @MovID,   @AlmacenSucursal, @Articulo, @SubProducto,  @Origen + ' ' + @OrigenID, @Material, @SubCuenta, @Cantidad, @Merma, @Desperdicio, @Unidad, @CantidadInventario, 1,	     @DetalleTipo, @Costo)
END
FETCH NEXT FROM crDetalle INTO @Material, @SubCuenta, @Cantidad, @Merma, @Desperdicio, @Unidad, @Almacen
END
CLOSE crDetalle
DEALLOCATE crDetalle
END
FETCH NEXT FROM crArticulo INTO @Articulo, @SubProducto, @CantidadArt
END
CLOSE crArticulo
DEALLOCATE crArticulo
IF NOT EXISTS(SELECT * FROM InvD WHERE ID = @IDGenerar)
BEGIN
DELETE InvD WHERE ID = @IDGenerar
DELETE Inv WHERE ID = @IDGenerar
END
ELSE
IF @Ok IS NULL
BEGIN
EXEC spInv @IDGenerar, @ModuloDestino, @Accion, 'TODO', @FechaEmision, NULL, @Usuario, 1, 0, NULL,
@MovDestino, @MovIDGenerar OUTPUT, NULL, NULL,
@Ok OUTPUT, @OkRef OUTPUT
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @ModuloDestino, @IDGenerar, @MovDestino, @MovIDGenerar, @Ok OUTPUT
END
END
FETCH NEXT FROM crEncabezado INTO @Almacen, @MovDestino
END
CLOSE crEncabezado
DEALLOCATE crEncabezado
END

