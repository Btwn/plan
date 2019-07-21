SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCompraEntradaMaquilaGenerarEntradaProd
@Accion  varchar(20),
@Empresa char(5),
@Sucursal      int,
@ID          int,
@Mov           varchar(20),
@MovID   varchar(20),
@Ok            int         OUTPUT,
@OkRef   varchar(255)      OUTPUT

AS BEGIN
DECLARE
@EPID         int,
@SID          int,
@EPMov        varchar(20),
@SPMov        varchar(20),
@SPMovID            varchar(20),
@EPMovID            varchar(20),
@EPEstatus          varchar(20),
@Articulo           varchar(20),
@SubCuenta          varchar(50),
@Cantidad           float,
@Costo        float,
@Fecha              datetime,
@Posicion           varchar(10),
@PosicionSurtido    varchar(10),
@Almacen            varchar(10),
@ConsumoID          int,
@AlmacenProv        varchar(10),
@Proveedor          varchar(10),
@Usuario            varchar(10)
SELECT @Usuario = Usuario,@Almacen = Almacen, @Proveedor = Proveedor FROM Compra WITH (NOLOCK) WHERE ID = @ID
SELECT @AlmacenProv = Almacen  FROM Prov WITH (NOLOCK) WHERE Proveedor = @Proveedor
SELECT @Fecha = dbo.fnFechaSinHora(GETDATE())
SELECT @EPMov = InvEntradaProducto, @SPMov = InvSalidaDiversa FROM EmpresaCfgMov WITH (NOLOCK) WHERE Empresa = @Empresa
IF NOT EXISTS(SELECT * FROM ArtMaterial a WITH (NOLOCK) JOIN CompraD c WITH (NOLOCK) ON a.Articulo = c.ArticuloMaquila WHERE c.ID = @ID)
SELECT @EPMov = InvEntradaDiversa FROM EmpresaCfgMov WITH (NOLOCK) WHERE Empresa = @Empresa
SELECT @Posicion = DefPosicionRecibo, @PosicionSurtido = DefPosicionSurtido from Alm WITH (NOLOCK) WHERE Almacen = @Almacen
IF @Ok IS NULL AND @Accion = 'AFECTAR'
BEGIN
INSERT Inv(Empresa, Mov,     FechaEmision, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Referencia, Estatus,      Almacen, OrigenTipo, Origen, OrigenID, Sucursal, SucursalDestino, MovMES)
SELECT     Empresa, @EPMov,  @Fecha,       Concepto, Proyecto, Moneda, TipoCambio, Usuario, Referencia, 'SINAFECTAR', Almacen, 'COMS',     Mov,    MovID,    Sucursal, Sucursal,        0
FROM Compra WITH (NOLOCK)
WHERE ID = @ID
SELECT @EPID = SCOPE_IDENTITY()
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
INSERT InvD(ID,    Renglon,   RenglonID,    RenglonTipo,                Cantidad,   Almacen,   Codigo,   Articulo,          Unidad,    Sucursal, Posicion, Costo,    CantidadInventario)
SELECT      @EPID, d.Renglon, d.RenglonID,  dbo.fnRenglonTipo(a.Tipo),  d.Cantidad, @Almacen, d.Codigo, d.ArticuloMaquila, a.Unidad,  d.Sucursal, @Posicion, d.Costo, (dbo.fnArtUnidadFactor(@Empresa, d.ArticuloMaquila,a.UnidadCompra)*d.Cantidad)
FROM CompraD d WITH (NOLOCK) JOIN Art a WITH (NOLOCK) ON d.ArticuloMaquila = a.Articulo
WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
INSERT SerieLoteMov(Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad)
SELECT              @Empresa, 'INV', @EPID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad
FROM SerieLoteMov WITH (NOLOCK) WHERE Modulo = 'COMS' AND ID = @ID AND Empresa =@Empresa
END
IF @Ok IS NULL AND EXISTS(SELECT * FROM InvD d WITH (NOLOCK) JOIN ArtMaterial a WITH (NOLOCK) ON a.Articulo = d.Articulo AND d.ID = @EPID)
EXEC @ConsumoID = spAfectar 'INV', @EPID, 'AFECTAR', 'TODO',NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
ELSE
BEGIN
INSERT Inv(Empresa, Mov,     FechaEmision, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Referencia, Estatus,      Almacen, OrigenTipo, Origen, OrigenID, Sucursal, SucursalDestino, MovMES)
SELECT     Empresa, @SPMov,  @Fecha,       Concepto, Proyecto, Moneda, TipoCambio, Usuario, Referencia, 'SINAFECTAR', @AlmacenProv, 'COMS',     Mov,    MovID,    Sucursal, Sucursal,        0
FROM Compra WITH (NOLOCK)
WHERE ID = @ID
SELECT @SID = SCOPE_IDENTITY()
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
INSERT InvD(ID,    Renglon,   RenglonID,    RenglonTipo,                Cantidad,   Almacen,     Codigo,   Articulo,          Unidad,    Sucursal,   Posicion, Costo,            CantidadInventario)
SELECT      @SID, d.Renglon, d.RenglonID,  dbo.fnRenglonTipo(a.Tipo),  d.Cantidad, @AlmacenProv, d.Codigo, d.ArticuloMaquila, a.Unidad,  d.Sucursal, @PosicionSurtido, d.Costo,  (dbo.fnArtUnidadFactor(@Empresa, d.ArticuloMaquila,a.UnidadCompra)*d.Cantidad)
FROM CompraD d WITH (NOLOCK) JOIN Art a WITH (NOLOCK) ON d.ArticuloMaquila = a.Articulo
WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
INSERT SerieLoteMov(Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad)
SELECT              @Empresa, 'INV', @SID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad
FROM SerieLoteMov WITH (NOLOCK) WHERE Modulo = 'COMS' AND ID = @ID AND Empresa =@Empresa
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
EXEC  spAfectar 'INV', @SID, 'AFECTAR', 'TODO',NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @SPMovID = MovID FROM Inv WITH (NOLOCK) WHERE ID = @SID
IF @Ok IS NULL
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa,  'COMS', @ID, @Mov, @MovID, 'INV', @SID, @SPMov, @SPMovID, @Ok OUTPUT
END
IF @Ok BETWEEN 80030 AND 81000
SET @Ok = NULL
IF @Ok BETWEEN 80030 AND 81000
SET @Ok = NULL
IF @Ok IS NULL
EXEC  spAfectar 'INV', @EPID, 'AFECTAR', 'TODO',NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @EPMov = Mov , @EPMovID = MovID FROM Inv WITH (NOLOCK) WHERE ID = @EPID
IF @Ok IS NULL
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa,  'COMS', @ID, @Mov, @MovID, 'INV', @EPID, @EPMov, @EPMovID, @Ok OUTPUT
END
IF @Ok BETWEEN 80030 AND 81000
SET @Ok = NULL
IF @Ok IS NULL
UPDATE Inv WITH (ROWLOCK) SET Almacen = @AlmacenProv WHERE ID = @ConsumoID
IF @Ok IS NULL
UPDATE InvD WITH (ROWLOCK) SET Almacen = @AlmacenProv, Posicion = @PosicionSurtido, cantidadInventario= dbo.fnArtUnidadFactor(@Empresa, Articulo,Unidad)*Cantidad   WHERE ID = @ConsumoID
IF @Ok IS NULL AND @ConsumoID IS NOT NULL
BEGIN
EXEC spAfectar 'INV', @ConsumoID, 'AFECTAR', 'TODO',NULL,@Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok BETWEEN 80030 AND 81000
SET @Ok = NULL
END
SELECT @EPMov = Mov , @EPMovID = MovID FROM Inv WITH (NOLOCK) WHERE ID = @EPID
IF @Ok IS NULL
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa,  'COMS', @ID, @Mov, @MovID, 'INV', @EPID, @EPMov, @EPMovID, @Ok OUTPUT
END
IF @Accion = 'CANCELAR'
BEGIN
SELECT @EPID = ID FROM Inv WITH (NOLOCK) WHERE Origen = @Mov AND OrigenID = @MovID AND Empresa = @Empresa AND OrigenTipo = 'COMS'
IF @EPID IS NOT NULL
BEGIN
EXEC  spAfectar 'INV', @EPID, 'CANCELAR', 'TODO', @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
EXEC spMovFlujo @Sucursal, 'CANCELAR', @Empresa,  'COMS', @ID, @Mov, @MovID, 'INV', @EPID, @EPMov, @EPMovID, @Ok OUTPUT
END
END
RETURN
END

