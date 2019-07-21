SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spECollaboration
@Empresa		char(5),
@Sucursal		int,
@Modulo		char(5),
@ID			int,
@Estatus		char(15),
@EstatusNuevo	char(15),
@Usuario		char(10),
@FechaEmision	datetime,
@FechaRegistro	datetime,
@Mov			char(20),
@MovID		varchar(20),
@MovTipo		char(20),
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Intercompania	bit,
@Contacto		varchar(10),
@VentaID		int,
@CompraID		int,
@CxcID		int,
@CxpID		int,
@Proveedor		char(10),
@MovDestino		varchar(20),
@MovReferencia	varchar(50),
@MovEmpresa		varchar(5),
@MovCliente		varchar(10),
@MovEnviarA		int,
@MovProveedor	varchar(10),
@MovAlmacen		varchar(10),
@MovAgente		varchar(10),
@AlmSucursal	int,
@ClienteN		varchar(10),
@ProveedorN		varchar(10),
@MovMismaEmp    bit
SELECT @MovReferencia = RTRIM(@Mov)+' '+RTRIM(@MovID)
SELECT @ClienteN = @Empresa, @ProveedorN = @Empresa, @MovMismaEmp = 0
IF @MovTipo IN ('COMS.O', 'COMS.OP', 'COMS.OG', 'COMS.OI', 'COMS.D', 'COMS.F') AND
@Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'AUTORIZARE') AND @EstatusNuevo IN ('CONCLUIDO', 'PENDIENTE')
BEGIN
SELECT @Contacto = m.Proveedor,
@Intercompania = ISNULL(p.Intercompania, 0)
FROM Compra m
JOIN Prov p ON p.Proveedor = m.Proveedor
WHERE m.ID = @ID
IF EXISTS(SELECT * FROM eCollaborationProvCte where Proveedor = @Contacto And ModuloOrigen = @Modulo And MovimientoOrigen = @Mov)
Select @Contacto = EmpresaProv ,@MovMismaEmp = 1 from eCollaborationProvCte where Proveedor = @Contacto And ModuloOrigen = @Modulo And MovimientoOrigen = @Mov
IF EXISTS(SELECT * FROM eCollaborationProvCte where  ModuloOrigen = @Modulo And MovimientoOrigen = @Mov)
Select @ClienteN = Cliente from eCollaborationProvCte where  ModuloOrigen = @Modulo And MovimientoOrigen = @Mov
IF @Intercompania = 1
BEGIN
IF @Empresa = @Contacto AND @MovMismaEmp = 0
SELECT @Ok = 10420
ELSE
IF NOT EXISTS(SELECT * FROM Cte WHERE Cliente = @ClienteN) OR NOT EXISTS(SELECT * FROM Empresa WHERE Empresa = @Contacto)
SELECT @Ok = 10410
ELSE BEGIN
SELECT @MovDestino = NULL
SELECT @MovDestino = NULLIF(RTRIM(MovDestino), '') FROM CfgECollaborationMov WHERE Modulo = @Modulo AND Mov = @Mov
IF @MovDestino IS NULL
BEGIN
SELECT @Ok = 10033
RETURN
END
SELECT @MovEmpresa = @Contacto, @MovCliente = @ClienteN
SELECT @MovAlmacen = m.Almacen,
@MovEnviarA = c.EnviarA,
@MovAgente  = c.Agente
FROM Compra m
JOIN Cte c ON c.Cliente = @ClienteN
WHERE m.ID = @ID
EXEC xpECollaborationGenerarPedido @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @Ok OUTPUT, @OkRef OUTPUT,
@MovEmpresa OUTPUT, @MovAlmacen OUTPUT, @MovCliente OUTPUT, @MovEnviarA OUTPUT, @MovAgente OUTPUT, @MovReferencia OUTPUT
SELECT @AlmSucursal = Sucursal FROM Alm WHERE UPPER(Almacen) = UPPER(@MovAlmacen)
INSERT Venta (
Sucursal,     SucursalDestino, OrigenTipo, Origen, OrigenID,  Estatus,   CompraID, Usuario,  Mov,         Concepto, Empresa,     FechaEmision,  Referencia,     OrdenCompra,    FechaOrdenCompra, FechaRequerida, Cliente,     EnviarA,     Agente,     Almacen,     Moneda, TipoCambio, ListaPreciosEsp, Condicion, Vencimiento, Descuento, DescuentoGlobal, Proyecto, UEN, FormaEnvio)
SELECT @AlmSucursal, @AlmSucursal,    'E/COLLAB', Mov,    MovID,   'CONFIRMAR', @ID,      @Usuario, @MovDestino, Concepto, @MovEmpresa, @FechaEmision, @MovReferencia, @MovReferencia, @FechaEmision,    FechaRequerida, @MovCliente, @MovEnviarA, @MovAgente, @MovAlmacen, Moneda, TipoCambio, ListaPreciosEsp, Condicion, Vencimiento, Descuento, DescuentoGlobal, Proyecto, UEN, FormaEnvio
FROM Compra m
WHERE m.ID = @ID
SELECT @VentaID = SCOPE_IDENTITY()
INSERT VentaD (
Sucursal,     ID,       Renglon,  RenglonID,  RenglonTipo,  Codigo, Articulo,  SubCuenta,  Cantidad,  CantidadInventario,  Factor, Unidad,  Paquete, Costo, Precio,  DescuentoTipo, DescuentoLinea, DescuentoImporte, Impuesto1,  Impuesto2,  Impuesto3,  Almacen,     FechaRequerida, DescripcionExtra, ContUso)
SELECT @AlmSucursal, @VentaID, Renglon,  RenglonID,  RenglonTipo,  Codigo, Articulo,  SubCuenta,  Cantidad,  CantidadInventario,  Factor, Unidad,  Paquete, Costo, Costo,   DescuentoTipo, DescuentoLinea, DescuentoImporte, Impuesto1,  Impuesto2,  Impuesto3,  @MovAlmacen, FechaRequerida, DescripcionExtra, ContUso
FROM CompraD
WHERE ID = @ID
IF (SELECT VentaPreciosImpuestoIncluido FROM EmpresaCfg WHERE Empresa = @Contacto) = 1
UPDATE VentaD
SET Precio = Precio * (1.0+(((100.0+ISNULL(Impuesto2, 0.0))*(1+((ISNULL(Impuesto1, 0.0)+ISNULL(Impuesto3, 0.0))/100.0))-100.0)/100.0))
WHERE ID = @VentaID
INSERT SerieLoteMov (
Sucursal,     Empresa,   Modulo, ID,       RenglonID, Articulo, SubCuenta, SerieLote, Cantidad)
SELECT @AlmSucursal, @Contacto, 'VTAS', @VentaID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad
FROM SerieLoteMov
WHERE Modulo = 'COMS' AND ID = @ID
IF (SELECT eCollaboration2Capas FROM EmpresaGral WHERE Empresa = @Empresa) = 1 AND @MovTipo <> 'COMS.D'
BEGIN
DECLARE crProv CURSOR FOR
SELECT DISTINCT NULLIF(RTRIM(ProveedorArt), '')
FROM CompraD
WHERE ID = @ID
OPEN crProv
FETCH NEXT FROM crProv INTO @Proveedor
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Proveedor IS NULL
SELECT @Ok = 10450, @OkRef = MIN(Articulo) FROM CompraD WHERE ID = @ID AND NULLIF(RTRIM(ProveedorArt), '') IS NULL
INSERT Compra (
Sucursal,  OrigenTipo, Origen, OrigenID, Estatus,     Usuario,  Mov,  Concepto,   Empresa,   FechaEmision,  Referencia,     FechaRequerida, Proveedor,  Almacen,   Moneda,   TipoCambio,   ListaPreciosEsp,   Condicion,   Descuento,   DescuentoGlobal, Proyecto,   UEN,   FormaEnvio)
SELECT @Sucursal, 'E/COLLAB', m.Mov,  m.MovID,  'CONFIRMAR', @Usuario, @Mov, m.Concepto, @Contacto, @FechaEmision, @MovReferencia, FechaRequerida, @Proveedor, m.Almacen, m.Moneda, m.TipoCambio, p.ListaPreciosEsp, p.Condicion, p.Descuento, d.Porcentaje,    m.Proyecto, m.UEN, p.FormaEnvio
FROM Compra m
JOIN Prov p ON p.Proveedor = @Proveedor
LEFT OUTER JOIN Descuento d ON d.Descuento = p.Descuento
WHERE m.ID = @ID
SELECT @CompraID = SCOPE_IDENTITY()
INSERT CompraD (
Sucursal,  ID,        Renglon,   RenglonID,   RenglonTipo,   Codigo,   Articulo,   SubCuenta,   Cantidad,   CantidadInventario,   Factor,   Unidad,   Paquete,   Costo,                            Impuesto1,   Impuesto2,   Impuesto3,   Almacen,   FechaRequerida,   DescripcionExtra,   ContUso)
SELECT @Sucursal, @CompraID, d.Renglon, d.RenglonID, d.RenglonTipo, d.Codigo, d.Articulo, d.SubCuenta, d.Cantidad, d.CantidadInventario, d.Factor, d.Unidad, d.Paquete, NULLIF(d.ProveedorArtCosto, 0.0), d.Impuesto1, d.Impuesto2, d.Impuesto3, d.Almacen, d.FechaRequerida, d.DescripcionExtra, d.ContUso
FROM CompraD d
WHERE d.ID = @ID AND d.ProveedorArt = @Proveedor
INSERT SerieLoteMov (
Sucursal,  Empresa,   Modulo, ID,        RenglonID,     Articulo,     SubCuenta,     SerieLote,     Cantidad)
SELECT @Sucursal, @Contacto, 'VTAS', @CompraID, slm.RenglonID, slm.Articulo, slm.SubCuenta, slm.SerieLote, slm.Cantidad
FROM CompraD d
JOIN SerieLoteMov slm ON slm.Empresa = @Empresa AND slm.Modulo = 'COMS' AND slm.ID = d.ID AND slm.RenglonID = d.RenglonID AND slm.Articulo = d.Articulo AND ISNULL(slm.SubCuenta, '') = ISNULL(d.SubCuenta, '')
WHERE d.ID = @ID AND d.ProveedorArt = @Proveedor
EXEC spCompraActualizarPrecios @CompraID, @UnicamenteNulos = 1
END
FETCH NEXT FROM crProv INTO @Proveedor
END
CLOSE crProv
DEALLOCATE crProv
END
END
END
END
IF @MovTipo IN ('VTAS.F','VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX') AND
@Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'AUTORIZARE') AND @EstatusNuevo IN ('CONCLUIDO', 'PENDIENTE')
BEGIN
SELECT @Contacto = m.Cliente,
@Intercompania = ISNULL(c.Intercompania, 0)
FROM Venta m
JOIN Cte c ON c.Cliente = m.Cliente
WHERE m.ID = @ID
IF EXISTS(SELECT * FROM eCollaborationProvCte where Cliente = @Contacto And ModuloOrigen = @Modulo And MovimientoOrigen = @Mov)
Select @Contacto = EmpresaCte, @MovMismaEmp = 1 from eCollaborationProvCte where Cliente = @Contacto And ModuloOrigen = @Modulo And MovimientoOrigen = @Mov
IF EXISTS(SELECT * FROM eCollaborationProvCte where  ModuloOrigen = @Modulo And MovimientoOrigen = @Mov)
Select @ProveedorN = Proveedor from eCollaborationProvCte where ModuloOrigen = @Modulo And MovimientoOrigen = @Mov
IF @Intercompania = 1
BEGIN
IF @Empresa = @Contacto AND @MovMismaEmp = 0
SELECT @Ok = 10420
ELSE
IF NOT EXISTS(SELECT * FROM Prov WHERE Proveedor = @ProveedorN) OR NOT EXISTS(SELECT * FROM Empresa WHERE Empresa = @Contacto)
SELECT @Ok = 10410
ELSE BEGIN
SELECT @MovDestino = NULL
SELECT @MovDestino = NULLIF(RTRIM(MovDestino), '') FROM CfgECollaborationMov WHERE Modulo = @Modulo AND Mov = @Mov
IF @MovDestino IS NULL
BEGIN
SELECT @Ok = 10033
RETURN
END
SELECT @MovEmpresa = @Contacto, @MovProveedor = @ProveedorN
SELECT @MovAlmacen = m.Almacen,
@MovEnviarA = m.EnviarA,
@MovAgente  = p.Agente
FROM Venta m
JOIN Prov p ON p.Proveedor = @ProveedorN
WHERE m.ID = @ID
EXEC xpECollaborationGenerarEntradaCompra @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @Ok OUTPUT, @OkRef OUTPUT,
@MovEmpresa OUTPUT, @MovAlmacen OUTPUT, @MovCliente OUTPUT, @MovEnviarA OUTPUT, @MovAgente OUTPUT, @MovReferencia OUTPUT
SELECT @AlmSucursal = Sucursal FROM Alm WHERE UPPER(Almacen) = UPPER(@MovAlmacen)
INSERT Compra (
Sucursal,     SucursalDestino, OrigenTipo, Origen, OrigenID,  Estatus,     Directo, Usuario,  Mov,         Concepto, Empresa,     FechaEmision,  Referencia,     Proveedor,     Agente,     Almacen,     Moneda, TipoCambio, ListaPreciosEsp, Condicion, Vencimiento, Descuento, DescuentoGlobal, Proyecto, UEN, FormaEnvio)
SELECT @AlmSucursal, @AlmSucursal,    'E/COLLAB', Mov,    MovID,     'CONFIRMAR', 0,       @Usuario, @MovDestino, Concepto, @MovEmpresa, @FechaEmision, @MovReferencia, @MovProveedor, @MovAgente, @MovAlmacen, Moneda, TipoCambio, ListaPreciosEsp, Condicion, Vencimiento, Descuento, DescuentoGlobal, Proyecto, UEN, FormaEnvio
FROM Venta
WHERE ID = @ID
SELECT @CompraID = SCOPE_IDENTITY()
INSERT CompraD (
Sucursal,     ID,        Aplica, AplicaID, Renglon,   RenglonID,   RenglonTipo,   Codigo,   Articulo,   SubCuenta,   Cantidad,   CantidadInventario,   Factor,   Unidad,   Paquete,   Costo,    DescuentoTipo,   DescuentoLinea,   DescuentoImporte,   Impuesto1,   Impuesto2,   Impuesto3,   Almacen,     FechaRequerida,   DescripcionExtra,   ContUso)
SELECT @AlmSucursal, @CompraID, c.Mov,  c.MovID,  d.Renglon, d.RenglonID, d.RenglonTipo, d.Codigo, d.Articulo, d.SubCuenta, d.Cantidad, d.CantidadInventario, d.Factor, d.Unidad, d.Paquete, d.Precio, d.DescuentoTipo, d.DescuentoLinea, d.DescuentoImporte, d.Impuesto1, d.Impuesto2, d.Impuesto3, @MovAlmacen, d.FechaRequerida, d.DescripcionExtra, d.ContUso
FROM VentaD d
LEFT OUTER JOIN Venta v ON v.Empresa = @Empresa AND v.Mov = d.Aplica AND v.MovID = d.AplicaID AND v.Estatus IN ('PENDIENTE', 'CONCLUIDO')
LEFT OUTER JOIN Compra c ON c.ID = v.CompraID
WHERE d.ID = @ID
INSERT SerieLoteMov (
Sucursal,     Empresa,   Modulo, ID,        RenglonID, Articulo, SubCuenta, SerieLote, Cantidad)
SELECT @AlmSucursal, @Contacto, 'COMS', @CompraID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad
FROM SerieLoteMov
WHERE Modulo = 'VTAS' AND ID = @ID
IF (SELECT VentaPreciosImpuestoIncluido FROM EmpresaCfg WHERE Empresa = @Empresa) = 1
UPDATE CompraD
SET Costo = Costo / (1.0+(((100.0+ISNULL(Impuesto2, 0.0))*(1+((ISNULL(Impuesto1, 0.0)+ISNULL(Impuesto3, 0.0))/100.0))-100.0)/100.0))
WHERE ID = @CompraID
IF NOT EXISTS(SELECT * FROM CompraD WHERE ID = @CompraID AND Aplica IS NOT NULL)
UPDATE Compra SET Directo = 1 WHERE ID = @CompraID
END
END
END
IF @Modulo = 'CXC' AND
@Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'AUTORIZARE') AND @EstatusNuevo IN ('CONCLUIDO', 'PENDIENTE')
BEGIN
SELECT @Contacto = m.Cliente,
@Intercompania = ISNULL(c.Intercompania, 0)
FROM Cxc m
JOIN Cte c ON c.Cliente = m.Cliente
WHERE m.ID = @ID
IF EXISTS(SELECT * FROM eCollaborationProvCte where Cliente = @Contacto And ModuloOrigen = @Modulo And MovimientoOrigen = @Mov)
Select @Contacto = EmpresaCte, @MovMismaEmp = 1 from eCollaborationProvCte where Cliente = @Contacto And ModuloOrigen = @Modulo And MovimientoOrigen = @Mov
IF EXISTS(SELECT * FROM eCollaborationProvCte where  ModuloOrigen = @Modulo And MovimientoOrigen = @Mov)
Select @ProveedorN = Proveedor from eCollaborationProvCte where  ModuloOrigen = @Modulo And MovimientoOrigen = @Mov
IF @Intercompania = 1
BEGIN
IF @Empresa = @Contacto AND @MovMismaEmp = 0
SELECT @Ok = 10420
ELSE
IF NOT EXISTS(SELECT * FROM Prov WHERE Proveedor = @ProveedorN) OR NOT EXISTS(SELECT * FROM Empresa WHERE Empresa = @Contacto)
SELECT @Ok = 10410
ELSE BEGIN
SELECT @MovDestino = NULL
SELECT @MovDestino = NULLIF(RTRIM(MovDestino), '') FROM CfgECollaborationMov WHERE Modulo = @Modulo AND Mov = @Mov
IF @MovDestino IS NOT NULL
BEGIN
INSERT Cxp (
OrigenTipo, Origen, OrigenID, Estatus,     Usuario,  Mov,         Concepto,   Empresa,   FechaEmision,  Referencia,     Sucursal,  Proveedor, Importe,   Impuestos,   Retencion,   Moneda,   TipoCambio,   ProveedorMoneda, ProveedorTipoCambio, AplicaManual,   Condicion,   Vencimiento,   Proyecto,   UEN)
SELECT 'E/COLLAB', m.Mov,  m.MovID,  'CONFIRMAR', @Usuario, @MovDestino, m.Concepto, @Contacto, @FechaEmision, @MovReferencia, @Sucursal, @ProveedorN,  m.Importe, m.Impuestos, m.Retencion, m.Moneda, m.TipoCambio, m.ClienteMoneda, m.ClienteTipoCambio, m.AplicaManual, m.Condicion, m.Vencimiento, m.Proyecto, m.UEN
FROM Cxc m
JOIN Prov p ON p.Proveedor = @ProveedorN
WHERE m.ID = @ID
SELECT @CxpID = SCOPE_IDENTITY()
IF EXISTS (SELECT * FROM CxcD WHERE ID = @ID)
INSERT CxpD (
ID,     Sucursal,  Renglon,   RenglonSub,   Importe,   Aplica, AplicaID)
SELECT @CxpID, @Sucursal, d.Renglon, d.RenglonSub, d.Importe, p.Mov,  p.MovID
FROM CxcD d
LEFT OUTER JOIN Cxc c ON c.Empresa = @Empresa  AND c.Estatus IN ('PENDIENTE', 'CONCLUIDO') AND c.Mov = d.Aplica AND c.MovID = d.AplicaID
LEFT OUTER JOIN Cxp p ON p.Empresa = @Contacto AND p.Estatus IN ('PENDIENTE', 'CONCLUIDO') AND RTRIM(p.Mov) + ' ' + RTRIM(p.MovID) = c.Referencia
WHERE d.ID = @ID
END
END
END
END
IF @Modulo = 'CXP' AND
@Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'AUTORIZARE') AND @EstatusNuevo IN ('CONCLUIDO', 'PENDIENTE')
BEGIN
SELECT @Contacto = m.Proveedor,
@Intercompania = ISNULL(p.Intercompania, 0)
FROM Cxp m
JOIN Prov p ON p.Proveedor = m.Proveedor
WHERE m.ID = @ID
IF EXISTS(SELECT * FROM eCollaborationProvCte where Proveedor = @Contacto And ModuloOrigen = @Modulo And MovimientoOrigen = @Mov)
Select @Contacto = EmpresaProv, @MovMismaEmp = 1 from eCollaborationProvCte where Proveedor = @Contacto And ModuloOrigen = @Modulo And MovimientoOrigen = @Mov
IF EXISTS(SELECT * FROM eCollaborationProvCte where ModuloOrigen = @Modulo And MovimientoOrigen = @Mov)
Select @ClienteN = Cliente from eCollaborationProvCte where  ModuloOrigen = @Modulo And MovimientoOrigen = @Mov
IF @Intercompania = 1
BEGIN
IF @Empresa = @Contacto AND @MovMismaEmp = 0
SELECT @Ok = 10420
ELSE
IF NOT EXISTS(SELECT * FROM Cte WHERE Cliente = @ClienteN) OR NOT EXISTS(SELECT * FROM Empresa WHERE Empresa = @Contacto)
SELECT @Ok = 10410
ELSE BEGIN
SELECT @MovDestino = NULL
SELECT @MovDestino = NULLIF(RTRIM(MovDestino), '') FROM CfgECollaborationMov WHERE Modulo = @Modulo AND Mov = @Mov
IF @MovDestino IS NOT NULL
BEGIN
INSERT Cxc (
OrigenTipo, Origen,  OrigenID, Estatus,     Usuario,  Mov,         Concepto,   Empresa,   FechaEmision,  Referencia,     Sucursal,  Cliente,  ClienteEnviarA, Importe,   Impuestos,   Retencion,   Moneda,   TipoCambio,   ClienteMoneda,     ClienteTipoCambio,     AplicaManual,   Condicion,   Vencimiento,   Proyecto,   UEN)
SELECT 'E/COLLAB', m.Mov,   m.MovID,  'CONFIRMAR', @Usuario, @MovDestino, m.Concepto, @Contacto, @FechaEmision, @MovReferencia, @Sucursal, @ClienteN, c.EnviarA,      m.Importe, m.Impuestos, m.Retencion, m.Moneda, m.TipoCambio, m.ProveedorMoneda, m.ProveedorTipoCambio, m.AplicaManual, m.Condicion, m.Vencimiento, m.Proyecto, m.UEN
FROM Cxp m
JOIN Cte c ON c.Cliente = @ClienteN
WHERE m.ID = @ID
SELECT @CxcID = SCOPE_IDENTITY()
IF EXISTS (SELECT * FROM CxpD WHERE ID = @ID)
INSERT CxcD (
ID,     Sucursal,  Renglon,   RenglonSub,   Importe,   Aplica, AplicaID)
SELECT @CxcID, @Sucursal, d.Renglon, d.RenglonSub, d.Importe, p.Mov,  p.MovID
FROM CxpD d
LEFT OUTER JOIN Cxp c ON c.Empresa = @Empresa  AND c.Estatus IN ('PENDIENTE', 'CONCLUIDO') AND c.Mov = d.Aplica AND c.MovID = d.AplicaID
LEFT OUTER JOIN Cxc p ON p.Empresa = @Contacto AND p.Estatus IN ('PENDIENTE', 'CONCLUIDO') AND RTRIM(p.Mov) + ' ' + RTRIM(p.MovID) = c.Referencia
WHERE d.ID = @ID
END
END
END
END
EXEC xpECollaboration @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @Ok OUTPUT, @OkRef OUTPUT,
@VentaID, @CompraID, @CxcID, @CxpID
RETURN
END

