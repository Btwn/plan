SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpMESMovFinal
@Empresa		    char(5),
@Sucursal		    int,
@Modulo		      char(5),
@ID			        int,
@Estatus		    char(15),
@EstatusNuevo	  char(15),
@Usuario		    char(10),
@FechaEmision	  datetime,
@FechaRegistro	datetime,
@Mov			      char(20),
@MovID		      varchar(20),
@MovTipo		    char(20),
@IDGenerar		  int,
@Ok			        int		        OUTPUT,
@OkRef		      varchar(255)	OUTPUT
AS
BEGIN
DECLARE
@Origen           varchar(20),
@OrigenID         varchar(20),
@CompraID         int,
@GastoID          int,
@InvID            int,
@IDMES            int,
@CantidadRecibo   float,
@Factor           int,
@Directo          bit,
@Articulo         varchar(20),
@Cantidad         float,
@CantidadA        float,
@CantidadInventario       float,
@Renglon          float,
@CantidadAplica   float,
@FormadePago      varchar(50),
@Almacen          varchar(10),
@IDSalida         int,
@MovSalida        varchar(20),
@Unidad           varchar(50),
@ArtTipo          varchar(20),
@RenglonTipo      varchar(1),
@CfgMultiUnidades	      	bit,
@CfgMultiUnidadesNivel		varchar(20),
/*  jsmv  Centro de Costos */
@ContUso	      varchar(20),
@ContUso2         varchar(20),
@OrigenTipo       varchar(10),
@Lanzamiento      varchar(100)
IF @Modulo = 'COMS'
BEGIN
IF @MovTipo = 'COMS.O' AND @Estatus IN ('PENDIENTE') AND @EstatusNuevo IN ('CANCELADO')
BEGIN
UPDATE CompraMes SET ModuloID = NULL, EstatusIntelIMES = 0, Cancelado = 1 WHERE ModuloID = @ID
END
ELSE
IF @MovTipo IN ('COMS.CC', 'COMS.FL', 'COMS.F', 'COMS.EG', 'COMS.EI', 'COMS.CP') AND @Estatus IN ('SINAFECTAR', 'CONCLUIDO') AND @EstatusNuevo IN ('CONCLUIDO', 'CANCELADO')
BEGIN
IF @EstatusNuevo = 'CANCELADO' OR @MovTipo = 'COMS.CP' SELECT @Factor = -1 ELSE SELECT @Factor = 1
SELECT @Directo = ISNULL(c.Directo, 0) FROM Compra c WHERE c.ID = @ID
IF @Directo = 0
BEGIN
CREATE TABLE #CompraDMesAplica(
AplicaID          int,
Articulo          varchar(20),
Cantidad          float)
INSERT INTO #CompraDMesAplica(AplicaID, Articulo, Cantidad)
SELECT c.ID, cd.Articulo, SUM(cd.Cantidad)
FROM CompraD cd
JOIN Compra c ON cd.Aplica = c.Mov AND cd.AplicaID = c.MovID
JOIN MovTipo mt ON c.Mov = mt.Mov AND mt.Modulo = 'COMS' AND mt.Clave = 'COMS.O'
WHERE cd.ID = @ID
AND NULLIF(RTRIM(cd.Aplica), '') IS NOT NULL AND NULLIF(RTRIM(cd.AplicaID), '') IS NOT NULL
GROUP BY c.ID, cd.Articulo
DECLARE crCompraDMesAplica CURSOR FOR
SELECT cda.AplicaID, cda.Articulo, cda.Cantidad
FROM #CompraDMesAplica cda
OPEN crCompraDMesAplica
FETCH next FROM crCompraDMesAplica INTO @CompraID, @Articulo, @Cantidad
WHILE @@FETCH_STATUS = 0
BEGIN
IF @EstatusNuevo = 'CANCELADO'
DECLARE crCompraDMesAplicaD CURSOR FOR
SELECT cd.ID, cd.Renglon, cd.CantidadRecibida
FROM CompraMES cm
JOIN CompraDMES cd ON cm.ID = cd.ID
WHERE cm.ModuloID = @CompraID
AND cd.Articulo = @Articulo
AND ISNULL(cd.CantidadRecibida, 0) > 0
ELSE
DECLARE crCompraDMesAplicaD CURSOR FOR
SELECT cd.ID, cd.Renglon, cd.CantidadPendiente
FROM CompraMES cm
JOIN CompraDMES cd ON cm.ID = cd.ID
WHERE cm.ModuloID = @CompraID
AND cd.Articulo = @Articulo
AND ISNULL(cd.CantidadPendiente, 0) > 0
OPEN crCompraDMesAplicaD
FETCH next FROM crCompraDMesAplicaD INTO @IDMES, @Renglon, @CantidadA
WHILE @@FETCH_STATUS = 0 AND @Cantidad > 0
BEGIN
IF @Cantidad > @CantidadA
SELECT @CantidadAplica = @CantidadA
ELSE
SELECT @CantidadAplica = @Cantidad
IF @MovTipo = 'COMS.CP'
UPDATE CompraDMes SET CantidadPendiente = ISNULL(CantidadPendiente, 0) - @CantidadAplica, EstatusIntelIMES = 2
WHERE ID = @IDMES AND Renglon = @Renglon
ELSE
UPDATE CompraDMes SET CantidadRecibida = ISNULL(CantidadRecibida, 0) + (@CantidadAplica*@Factor), CantidadPendiente = ISNULL(CantidadPendiente, 0) - (@CantidadAplica*@Factor), EstatusIntelIMES = 2
WHERE ID = @IDMES AND Renglon = @Renglon
SELECT @Cantidad = @Cantidad - @CantidadAplica
FETCH next FROM crCompraDMesAplicaD INTO @IDMES, @Renglon, @CantidadA
END
CLOSE crCompraDMesAplicaD
DEALLOCATE crCompraDMesAplicaD
UPDATE CompraMes SET Entrada = 1 WHERE ModuloID = @CompraID
FETCH next FROM crCompraDMesAplica INTO @CompraID, @Articulo, @Cantidad
END
CLOSE crCompraDMesAplica
DEALLOCATE crCompraDMesAplica
END
END
/*
IF @MovTipo = 'COMS.CP' AND @Mov = 'Recibo Maquila' AND @Estatus IN ('SINAFECTAR', 'CONCLUIDO') AND @EstatusNuevo IN ('CONCLUIDO', 'CANCELADO')
BEGIN
IF @EstatusNuevo = 'CANCELADO'
BEGIN
SELECT @GastoID = ID FROM Gasto g WHERE g.Mov = 'Gasto' AND g.OrigenTipo = 'COMS' AND g.Origen = @Mov AND g.OrigenID = @MovID AND g.Estatus = 'CONCLUIDO'
IF @GastoID IS NOT NULL
EXEC spAfectar 'GAS', @GastoID, 'CANCELAR', NULL, NULL, @Usuario, 0, 1, @Ok OUTPUT, @OkRef OUTPUT, NULL, 1
END
ELSE
BEGIN
IF NOT EXISTS(SELECT * FROM Concepto c WHERE c.Modulo = 'GAS' AND c.Concepto = 'Maquila')
INSERT INTO Concepto(Modulo, Concepto, EsDeducible, Impuestos, MonedaCosto)
VALUES('GAS', 'Maquila', 1, 16, 'Pesos')
INSERT INTO Gasto
(Empresa, Mov,       FechaEmision,   Moneda,   TipoCambio,  Usuario, Estatus,        Acreedor, Observaciones, SubModulo, Sucursal, SucursalOrigen, SucursalDestino, MesLanzamiento)
SELECT c.Empresa, 'Gasto', c.FechaEmision, c.Moneda, c.TipoCambio, @Usuario, 'SINAFECTAR', c.Proveedor, c.Referencia, 'GAS', c.Sucursal, c.SucursalOrigen, c.SucursalDestino, c.MesLanzamiento
FROM Compra c
WHERE c.ID = @ID
SELECT @GastoID = @@IDENTITY
IF @GastoID IS NULL
SELECT @Ok = 10060, @OkRef = 'No se Generó el Gasto'
ELSE
BEGIN
INSERT INTO GastoD
(ID,         Renglon,    RenglonSub, Concepto,    Fecha,          Referencia,    Cantidad, Precio,                Importe,                     Impuestos,                            Impuesto1, Sucursal, SucursalOrigen)
SELECT @GastoID, cd.Renglon, cd.RenglonSub, 'Maquila', c.FechaEmision, c.Referencia, cd.Cantidad, ap.CostoAutorizado, cd.Cantidad*ap.CostoAutorizado, cd.Cantidad*ap.CostoAutorizado*1.16, 0.16, c.Sucursal, c.SucursalOrigen
FROM Compra c
JOIN CompraD cd ON c.ID = cd.ID
JOIN ArtProv ap ON ap.Articulo = cd.Articulo AND ap.Proveedor = c.Proveedor
WHERE c.ID = @ID
EXEC spAfectar 'GAS', @GastoID, 'AFECTAR', NULL, NULL, @Usuario, 0, 1, @Ok OUTPUT, @OkRef OUTPUT, NULL, 1
IF @OK = 80010 SELECT @OK = NULL
IF @Ok = NULL
BEGIN
IF NOT EXISTS(SELECT mt.Clave FROM MovTipo mt WHERE mt.Modulo = 'INV' AND mt.Mov = 'Entrada Maquila')
INSERT INTO MovTipo
(Modulo, Mov,              Orden, Clave, SubClave, ConsecutivoModulo, ConsecutivoMov,       Factor)
VALUES('INV', 'Entrada Maquila', 100, 'INV.E', NULL,    'INV',             'Entrada Maquila', 1     )
INSERT INTO Inv
(Empresa, Mov,                 FechaEmision,   Moneda,   TipoCambio,  Usuario,   Referencia, Estatus,        Almacen, OrigenTipo, Origen, OrigenID, Sucursal,   SucursalOrigen,   SucursalDestino, MesLanzamiento)
SELECT c.Empresa, 'Entrada Maquila', c.FechaEmision, c.Moneda, c.TipoCambio, @Usuario, c.Referencia, 'SINAFECTAR', c.Almacen, 'COMS',   c.Mov,  c.MovID,  c.Sucursal, c.SucursalOrigen, c.SucursalDestino, c.MesLanzamiento
FROM Compra c
WHERE ID = @ID
SELECT @InvID = @@IDENTITY
IF @InvID IS NULL
SELECT @Ok = 10060, @OkRef = 'No se Generó la Entrada'
ELSE
BEGIN
INSERT INTO InvD
(ID,       Renglon,    RenglonSub,    RenglonID,    RenglonTipo,    Cantidad,    Unidad, Almacen,    Articulo,    Costo,    Factor,   Sucursal,   SucursalOrigen, MesLanzamiento)
SELECT @InvID, cd.Renglon, cd.RenglonSub, cd.RenglonID, cd.RenglonTipo, cd.Cantidad, cd.Unidad, c.Almacen, cd.Articulo, cd.Costo, cd.Factor, c.Sucursal, c.SucursalOrigen, c.MesLanzamiento
FROM Compra c
JOIN CompraD cd ON c.ID = cd.ID
WHERE c.ID = @ID
EXEC spAfectar 'INV', @InvID, 'AFECTAR', NULL, NULL, @Usuario, 0, 1, @Ok OUTPUT, @OkRef OUTPUT, NULL, 1
END
IF @OK = 80010 SELECT @OK = NULL
IF @Ok = NULL
BEGIN
IF NOT EXISTS(SELECT mt.Clave FROM MovTipo mt WHERE mt.Modulo = 'INV' AND mt.Mov = 'SalidaMPMaquila')
INSERT INTO MovTipo
(Modulo, Mov,              Orden, Clave, SubClave, ConsecutivoModulo, ConsecutivoMov,       Factor)
VALUES('INV', 'SalidaMPMaquila', 200, 'INV.S', NULL,    'INV',             'SalidaMPMaquila', 1     )
CREATE TABLE #MesSalidaPadre(
Articulo        varchar(20),
Cantidad        money,
Unidad          varchar(50)   NULL,
Almacen         varchar(10))
INSERT INTO #MesSalidaPadre(Articulo, Cantidad, Unidad, Almacen)
SELECT mt.Padre, mt.CantidadTotalPadre, mt.UnidMedidaAlmacen, mt.AlmacenDefecto 
FROM PrevisionesConsumoMES mt
JOIN Art a ON mt.Padre = a.Articulo
WHERE ISNULL(mt.EstatusIntelIMES, 0) = 1
AND NULLIF(RTRIM(mt.AlmacenDefecto), '') IS NOT NULL
AND ISNULL(mt.FaseConsumo, 0) = '999'
DECLARE crMesSalidaPadre CURSOR FOR
SELECT mt.Almacen
FROM #MesSalidaPadre mt
GROUP BY mt.Almacen
OPEN crMesSalidaPadre
FETCH NEXT FROM crMesSalidaPadre INTO @Almacen
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @IDSalida = NULL
INSERT INTO Inv(Empresa, Mov, FechaEmision, Moneda, TipoCambio, Usuario, Estatus, Almacen, Sucursal, MesLanzamiento)
SELECT @Empresa, 'SalidaMPMaquila', c.FechaEmision, c.Moneda, c.TipoCambio, @Usuario, 'SINAFECTAR', @Almacen, @Sucursal, c.MesLanzamiento
FROM Compra c
WHERE c.ID = @ID
SELECT @IDSalida = @@IDENTITY
IF @IDSalida IS NOT NULL
BEGIN
SELECT @Renglon = 2048
DECLARE crMesSalidaPadreD CURSOR FOR
SELECT mt.Articulo, mt.Cantidad, mt.Unidad, a.Tipo
FROM #MesSalidaPadre mt
JOIN Art a ON mt.Articulo = a.Articulo
WHERE mt.Almacen = @Almacen
OPEN crMesSalidaPadreD
FETCH next FROM crMesSalidaPadreD INTO  @Articulo, @Cantidad, @Unidad, @ArtTipo
WHILE @@FETCH_STATUS = 0
BEGIN
EXEC spRenglonTipo @ArtTipo, NULL, @RenglonTipo OUTPUT
SELECT @Renglon = @Renglon + 2048
EXEC xpCantidadInventario @Articulo, NULL, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
/*  jsmv Actualizar InvD en Espacios id de MovMes / prodserielote = lote de MES */
INSERT INTO InvD
(ID,          Renglon, RenglonSub, RenglonID,  RenglonTipo,  Cantidad,  CantidadInventario,  Almacen,  Articulo, Unidad)
VALUES(@IDSalida, @Renglon, 0,         0,          @RenglonTipo, @Cantidad, @CantidadInventario, @Almacen, @Articulo, @Unidad)
EXEC xpCantidadInventario @Articulo, NULL, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
FETCH next FROM crMesSalidaPadreD INTO  @Articulo, @Cantidad, @Unidad, @ArtTipo
END
EXEC spAfectar 'INV', @IDSalida, 'AFECTAR', NULL, NULL, @Usuario, 0, 1, @Ok OUTPUT, @OkRef OUTPUT, NULL, 1
CLOSE crMesSalidaPadreD
DEALLOCATE crMesSalidaPadreD
END
ELSE
SELECT @Ok = 10060, @OkRef = 'No se generó el movimiento'
FETCH NEXT FROM crMesSalidaPadre INTO @Almacen
END
CLOSE crMesSalidaPadre
DEALLOCATE crMesSalidaPadre
UPDATE PrevisionesConsumoMES SET EstatusIntelIMES = 2
FROM Art a
WHERE Hijo = a.Articulo
AND ISNULL(EstatusIntelIMES, 0) = 1
AND NULLIF(RTRIM(AlmacenDefecto), '') IS NOT NULL
AND ISNULL(FaseConsumo, 0) = '999'
END
END
END
END
END*/
IF @MovTipo = 'COMS.EG' AND @Mov = 'EntradaCompraMaquila' AND @Estatus IN ('SINAFECTAR', 'CONCLUIDO') AND @EstatusNuevo IN ('CONCLUIDO', 'CANCELADO')
BEGIN
IF @EstatusNuevo = 'CANCELADO'
BEGIN
SELECT @IDSalida = ID FROM Inv g WHERE g.Mov = 'SalidaMPMaquila' AND g.OrigenTipo = 'COMS' AND g.Origen = @Mov AND g.OrigenID = @MovID AND g.Estatus = 'CONCLUIDO'
IF @IDSalida IS NOT NULL
BEGIN
EXEC spAfectar 'INV', @IDSalida, 'CANCELAR', NULL, NULL, @Usuario, 0, 1, @Ok OUTPUT, @OkRef OUTPUT, NULL, 1
IF @Ok IS NULL
UPDATE MovFlujo SET Cancelado = 1 WHERE DModulo = 'INV' AND DID = @IDSalida AND Cancelado = 0
END
END
ELSE
BEGIN
SELECT @Lanzamiento = c.MesLanzamiento FROM Compra c WHERE c.ID = @ID
IF NOT EXISTS(SELECT mt.Clave FROM MovTipo mt WHERE mt.Modulo = 'INV' AND mt.Mov = 'SalidaMPMaquila')
INSERT INTO MovTipo
(Modulo, Mov,              Orden, Clave, SubClave, ConsecutivoModulo, ConsecutivoMov,       Factor)
VALUES('INV', 'SalidaMPMaquila', 200, 'INV.S', NULL,    'INV',             'SalidaMPMaquila', 1     )
CREATE TABLE #MesSalidaPadre(
Articulo        varchar(20),
Cantidad        money,
Unidad          varchar(50)   NULL,
Almacen         varchar(10))
/*        INSERT INTO #MesSalidaPadre(Articulo, Cantidad, Unidad, Almacen)
SELECT mt.Hijo, mt.CantidadTotalPadre, mt.UnidMedidaAlmacen, a.AlmMesComs
FROM PrevisionesConsumoMES mt
JOIN Art a ON mt.Hijo = a.Articulo
WHERE ISNULL(mt.EstatusIntelIMES, 0) in (0, 1, 2)
AND NULLIF(RTRIM(a.AlmMesComs), '') IS NOT NULL
AND ISNULL(mt.FaseConsumo, 0) = 'ext'
AND mt.Lanzamiento = @Lanzamiento
*/
INSERT INTO #MesSalidaPadre(Articulo, Cantidad, Unidad, Almacen)
SELECT mt.Hijo, mt.CantidadTotalHijo*mt2.CantidadTotalHijo, mt.UnidMedidaAlmacen, a.AlmacenROP 
FROM CompraD d
JOIN PrevisionesConsumoMES mt ON d.MesLanzamiento = mt.Lanzamiento AND d.Articulo = mt.Padre
JOIN PrevisionesConsumoMES mt2 ON mt.Lanzamiento = mt2.Lanzamiento AND mt.Padre = mt2.Hijo
JOIN Art a ON mt.Hijo = a.Articulo
WHERE d.ID = @ID
AND ISNULL(mt.EstatusIntelIMES, 0) in (0, 1, 2)
AND ISNULL(mt2.EstatusIntelIMES, 0) in (0, 1, 2)
AND NULLIF(RTRIM(mt.AlmacenDefecto), '') IS NOT NULL
AND ISNULL(mt.FaseConsumo, 0) = 'ext'
AND ISNULL(mt2.FaseConsumo, 0) = 'exthijo'
AND mt.Lanzamiento = @Lanzamiento
DECLARE crMesSalidaPadre CURSOR FOR
SELECT mt.Almacen
FROM #MesSalidaPadre mt
GROUP BY mt.Almacen
OPEN crMesSalidaPadre
FETCH NEXT FROM crMesSalidaPadre INTO @Almacen
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @IDSalida = NULL
INSERT INTO Inv(Empresa, Mov, FechaEmision, Moneda, TipoCambio, Referencia, Usuario, Estatus, Almacen, Sucursal, MesLanzamiento, OrigenTipo, Origen, OrigenID)
SELECT @Empresa, 'SalidaMPMaquila', c.FechaEmision, c.Moneda, c.TipoCambio, @Lanzamiento, @Usuario, 'SINAFECTAR', @Almacen, @Sucursal, c.MesLanzamiento, 'COMS', @Mov, @MovID
FROM Compra c
WHERE c.ID = @ID
SELECT @IDSalida = @@IDENTITY
IF @IDSalida IS NOT NULL
BEGIN
SELECT @Renglon = 2048
DECLARE crMesSalidaPadreD CURSOR FOR
SELECT mt.Articulo, mt.Cantidad, mt.Unidad, a.Tipo
FROM #MesSalidaPadre mt
JOIN Art a ON mt.Articulo = a.Articulo
WHERE mt.Almacen = @Almacen
OPEN crMesSalidaPadreD
FETCH next FROM crMesSalidaPadreD INTO  @Articulo, @Cantidad, @Unidad, @ArtTipo
WHILE @@FETCH_STATUS = 0
BEGIN
EXEC spRenglonTipo @ArtTipo, NULL, @RenglonTipo OUTPUT
SELECT @Renglon = @Renglon + 2048
EXEC xpCantidadInventario @Articulo, NULL, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
/*  jsmv Actualizar InvD en Espacios id de MovMes / prodserielote = lote de MES */
INSERT INTO InvD
(ID,          Renglon, RenglonSub, RenglonID,  RenglonTipo,  Cantidad,  CantidadInventario,  Almacen,  Articulo, Unidad)
VALUES(@IDSalida, @Renglon, 0,         0,          @RenglonTipo, @Cantidad, @CantidadInventario, @Almacen, @Articulo, @Unidad)
EXEC xpCantidadInventario @Articulo, NULL, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
FETCH next FROM crMesSalidaPadreD INTO  @Articulo, @Cantidad, @Unidad, @ArtTipo
END
EXEC spAfectar 'INV', @IDSalida, 'AFECTAR', NULL, NULL, @Usuario, 0, 1, @Ok OUTPUT, @OkRef OUTPUT, NULL, 1
IF @Ok IS NULL
BEGIN
SELECT @MovSalida =  i.MovID FROM Inv i WHERE i.ID = @IDSalida
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @ID, @Mov, @MovID, 'INV', @IDSalida, 'SalidaMPMaquila', @MovSalida, @Ok OUTPUT
END
CLOSE crMesSalidaPadreD
DEALLOCATE crMesSalidaPadreD
END
ELSE
SELECT @Ok = 10060, @OkRef = 'No se generó el movimiento'
FETCH NEXT FROM crMesSalidaPadre INTO @Almacen
END
CLOSE crMesSalidaPadre
DEALLOCATE crMesSalidaPadre
/*
UPDATE PrevisionesConsumoMES SET EstatusIntelIMES = 5
FROM Art a
WHERE PrevisionesConsumoMES.Hijo = a.Articulo
AND ISNULL(PrevisionesConsumoMES.EstatusIntelIMES, 0) in (0, 1, 2)
AND NULLIF(RTRIM(a.AlmMesComs), '') IS NOT NULL
AND ISNULL(PrevisionesConsumoMES.FaseConsumo, 0) = 'ext'
AND PrevisionesConsumoMES.Lanzamiento = @Lanzamiento
*/
UPDATE PrevisionesConsumoMES SET EstatusIntelIMES = 5
FROM PrevisionesConsumoMES, CompraD d, Art a, PrevisionesConsumoMES mt2
WHERE d.MesLanzamiento = PrevisionesConsumoMES.Lanzamiento AND d.Articulo = PrevisionesConsumoMES.Padre
AND d.ID = @ID
AND PrevisionesConsumoMES.Hijo = a.Articulo
AND ISNULL(PrevisionesConsumoMES.EstatusIntelIMES, 0) in (0, 1, 2)
AND ISNULL(mt2.EstatusIntelIMES, 0) in (0, 1, 2)
AND PrevisionesConsumoMES.Lanzamiento = mt2.Lanzamiento AND PrevisionesConsumoMES.Padre = mt2.Hijo
AND NULLIF(RTRIM(a.AlmMesComs), '') IS NOT NULL
AND ISNULL(PrevisionesConsumoMES.FaseConsumo, 0) = 'ext'
AND ISNULL(mt2.FaseConsumo, 0) = 'exthijo'
AND PrevisionesConsumoMES.Lanzamiento = @Lanzamiento
END
END
END 
IF @Modulo = 'VTAS' AND @MovTipo IN ('VTAS.P', 'VTAS.PR') AND ((@Estatus = 'SINAFECTAR' AND @EstatusNuevo IN ('PENDIENTE', 'CONCLUIDO')) OR @EstatusNuevo = 'CANCELADO')
BEGIN
IF @EstatusNuevo = 'CANCELADO'
UPDATE VentaMES SET Cancelado = 1 WHERE ID = @ID
ELSE
BEGIN
SELECT @FormadePago = vc.FormaPagoTipo, @Almacen = vc.Almacen FROM Venta vc WHERE vc.ID = @ID
IF (SELECT a.MES FROM Alm a WHERE a.Almacen = @Almacen) = 1
BEGIN
INSERT VentaMES
(ID, Serie, NumerodePedido, Cliente,   FechaPedido,    FechaEntrega,     SuPedido,    FormadePago, TipoDocumento, DiaPago1,   DiaPago2, DiaPago3, Moneda, Cancelado, Sucursal, Proyecto)
SELECT ID, Mov,   MovID,        v.Cliente, v.FechaEmision, v.FechaRequerida, v.Referencia, @FormadePago, v.Mov,         NULL,		NULL,     NULL,   m.Moneda, 0, @Sucursal, v.Proyecto
FROM Venta v
JOIN Cte c ON v.Cliente = c.Cliente
LEFT OUTER JOIN MonMES m on v.Moneda = m.Descripcion
WHERE v.ID = @ID
/*  jsmv  se agrego contuso 1 y 2   */
INSERT INTO VentaDMES
(ID,    Renglon, Serie, NumerodePedido, Articulo,    AlmacenSalida, FechaEntregaRequerida, FechaEntregaConfirmada, CantidadPedida, CantidadServida, CantidadPendiente,    PrecioIntroducido, PorcIVA, SuReferencia, UnidadPedida, UnidadPrecio, SubCuenta, Proyecto,SubProyecto, ContUso, ContUso2)
SELECT vd.ID, vd.Renglon, v.Mov, v.MovID,     vd.Articulo, vd.Almacen,    vd.FechaRequerida,     vd.FechaRequerida,      vd.Cantidad,       0,            vd.CantidadPendiente, vd.Precio,          vd.Impuesto1, '', um.UnidadMedida, vd.Precio, vd.SubCuenta, v.Proyecto, vd.ABC, vd.ContUso, vd.ContUso2
FROM Venta v
JOIN VentaD vd ON vd.ID = v.ID
JOIN Art a ON vd.Articulo = a.Articulo
LEFT OUTER JOIN UnidadMes um ON vd.Unidad = um.Descripcion
WHERE vd.ID = @ID
END
END
END
IF @Modulo = 'INV' AND @Mov = 'Transferencia' AND @Estatus = 'CONCLUIDO' AND @EstatusNuevo = 'CANCELADO'
BEGIN
SELECT @OrigenTipo = i.OrigenTipo, @Almacen = i.AlmacenDestino FROM Inv i WHERE i.ID = @ID
IF @OrigenTipo = 'MESTxfer'
BEGIN
UPDATE PrevisionesConsumoMES SET EstatusIntelIMES = 1, Transferido = ISNULL(Transferido, 0) - d.Cantidad
FROM InvD d
JOIN Art a ON d.Articulo = a.Articulo
WHERE d.ID = @ID
AND d.Articulo = PrevisionesConsumoMES.Hijo
AND d.MesLanzamiento = PrevisionesConsumoMES.Lanzamiento
AND a.AlmacenROP = @Almacen
END
END
/* Modulo Fiscal: Registro pMovImpuesto. */
/*
DECLARE
@OkTemp   int,
@OkRefTemp  varchar(255),
@AfectarFiscal varchar(20),
/* IETU SergioReyes 03/06/2009: Evita que el sistema registre más de una vez en el módulo Fiscal las Obligaciones Fiscales a la Emisión. El Error sucede la primera vez para los movimientos cuyo Estatus nuevo es PENDIENTE, y la segunda vez cuando pasa a Estatus nuevo CONLUIDO. */
@CtaDinero  char(10)
*/
/*
SELECT
'xpMovFinal',
Empresa = @Empresa,
Sucursal = @Sucursal,
Modulo = @Modulo,
ID = @ID,
Estatus = @Estatus,
EstatusNuevo = @EstatusNuevo,
Usuario = @Usuario,
FechaEmision = @FechaEmision,
FechaRegistro = @FechaRegistro,
Mov = @Mov,
MovID = @MovID,
MovTipo = @MovTipo,
IDGenerar = @IDGenerar,
Ok = @Ok,
OkRef = @OkRef
*/
/*
EXEC ppMovImpuestoMovFinal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
SELECT @AfectarFiscal = NULLIF(RTRIM(AfectarFiscal), '')
FROM MovTipo
WHERE Modulo = @Modulo AND Mov = @Mov
/* IETU Sergio Reyes 27/05/08: Desconozco la razón del por que filtre por @EstatusNuevo = 'CONCLUIDO', sin embargo esto provoca que los movimientos Endoso, Endoso a favor no generen en el módulo Fiscal el movimiento Endoso Acumulable o Endoso Deducible. Se sustituye la línea superior por la siguiente instrucción. */
IF @AfectarFiscal NOT IN (NULL, 'NO') AND @EstatusNuevo IN ('PENDIENTE', 'CONCLUIDO', 'CANCELADO', 'PROCESAR')
BEGIN
SELECT @OkTemp = @Ok, @OkRefTemp = @OkRef
SELECT @Ok = NULL, @OkRef = NULL
/* IETU SergioReyes 03/06/2009: Evita que el sistema registre más de una vez en el módulo Fiscal las Obligaciones Fiscales a la Emisión. El Error sucede la primera vez para los movimientos cuyo Estatus nuevo es PENDIENTE, y la segunda vez cuando pasa a Estatus nuevo CONLUIDO. */
SELECT @CtaDinero = NULL
IF @Modulo = 'DIN'
SELECT @CtaDinero = CtaDinero FROM Dinero WHERE ID = @ID
/* IETU SergioReyes 26/07/2011: Se agregó la siguiente sentencia IF para excluir que el sistema no registre la información fiscal de los movimientos en Dinero con Estatus POSFECHADO. */
IF @Estatus = 'POSFECHADO'
BEGIN
EXEC ppGenerarFiscal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @AfectarFiscal, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
SELECT @Ok = @OkTemp, @OkRef = @OkRefTemp
END
ELSE
/* IETU SergioReyes 03/06/2009: Se agregó la siguiente sentencia IF para evitar que el sistema registre más de una vez en el módulo Fiscal las Obligaciones Fiscales a la Emisión. El Error sucede la primera vez para los movimientos cuyo Estatus nuevo es PENDIENTE, y la segunda vez cuando pasa a Estatus nuevo CONLUIDO. */
IF NOT EXISTS (SELECT * FROM pFiscal WHERE Empresa = @Empresa AND Mov = @AfectarFiscal AND OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID AND ISNULL(DineroCtaDinero, '') = ISNULL(@CtaDinero, ISNULL(DineroCtaDinero, ''))) OR @EstatusNuevo = 'CANCELADO'
BEGIN
EXEC ppGenerarFiscal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @AfectarFiscal, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
SELECT @Ok = @OkTemp, @OkRef = @OkRefTemp
END
END
*/
RETURN
END

