SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvUtilizarTodoDetalle
@Sucursal		int,
@Modulo		    char(5),
@Base		    char(20), 		
@OID           	int,
@OrigenMov		char(20),
@OrigenMovID		varchar(20),
@OrigenMovTipo	char(20),
@DID			    int,
@GenerarDirecto	bit,
@Ok			    int	OUTPUT,
@Empresa		    char(5)	= NULL,
@MovTipo		    varchar(20) = NULL

AS BEGIN
DECLARE
@OMov			varchar(20),
@DMov			varchar(20),
@RenglonTipo	varchar(1),
@RenglonID		int,
@Cantidad		float,
@HuboCambio		bit,
@MonedaD        varchar(10),
@TipoCambioD    float,
@CantidadP      float,
@CantidadaE     float,
@Articulo	    varchar(20),
@Subcuenta		varchar(50),
@Tarima			varchar(20),
@Almacen		varchar(10),
@cTarima		varchar(20),
@cArticulo		varchar(20),
@cSerieLote		varchar(50),
@cSubCuenta		varchar(50),
@cAlmacen		varchar(10),
@cSucursal		int,
@cEmpresa		varchar(5),
@cExistencia	float,
@cRenglonID		int,
@SubClave		varchar(20),
@Proveedor      varchar(10),
@Referencia     varchar(100)
DECLARE @SerieLoteMov as TABLE (Empresa varchar(5) null, Modulo varchar(5) null, ID int null, RenglonID int null, Articulo varchar(20) null, SubCuenta varchar(50) null,
SerieLote varchar(50) null,	Cantidad float null, CantidadAlterna float null, Propiedades varchar(20) null, Ubicacion int null, Cliente varchar(10) null,
Localizacion varchar(10) null, Sucursal int null, ArtCostoInv money null, Tarima varchar(20) null, AsignacionUbicacion bit null)
IF @Modulo = 'VTAS'
BEGIN
SELECT @OMov = Mov FROM Venta WITH(NOLOCK) WHERE ID = @OID
SELECT @DMov = Mov FROM Venta WITH(NOLOCK) WHERE ID = @DID
IF @OMov = @DMov
UPDATE VentaD WITH(ROWLOCK) SET Tarima = NULL WHERE ID = @DID
IF @GenerarDirecto = 1 SELECT @OrigenMov = NULL, @OrigenMovID = NULL
SELECT * INTO #VentaDetalle FROM cVentaD   WHERE ID = @OID
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Base IN ('TODO', 'IDENTICO') UPDATE #VentaDetalle SET ID = @DID, CantidadPendiente = NULL, CantidadCancelada = NULL, CantidadReservada = NULL, CantidadOrdenada = NULL, CantidadA = NULL, Aplica = @OrigenMov, AplicaID = @OrigenMovID, UltimoReservadoCantidad = NULL, UltimoReservadoFecha = NULL, AplicaRenglon = Renglon  ELSE
IF @Base = 'SELECCION' UPDATE #VentaDetalle SET ID = @DID, Cantidad = CantidadA, CantidadInventario = CantidadA * CantidadInventario / Cantidad, CantidadPendiente = NULL, CantidadCancelada = NULL, CantidadReservada = NULL, CantidadOrdenada = NULL, CantidadA = NULL, Aplica = @OrigenMov, AplicaID = @OrigenMovID, UltimoReservadoCantidad = NULL, UltimoReservadoFecha = NULL, AplicaRenglon = Renglon  ELSE
IF @Base = 'PENDIENTE' UPDATE #VentaDetalle SET ID = @DID, Cantidad = NULLIF(ISNULL(CantidadPendiente,0.0)/* + ISNULL(CantidadReservada, 0.0)*/, 0.0), CantidadInventario = (NULLIF(ISNULL(CantidadPendiente,0.0) + ISNULL(CantidadReservada, 0.0), 0.0)) * CantidadInventario / Cantidad, CantidadPendiente = NULL, CantidadReservada = NULL, CantidadCancelada = NULL, CantidadOrdenada = NULL, CantidadA = NULL, Aplica = @OrigenMov, AplicaID = @OrigenMovID, UltimoReservadoCantidad = NULL, UltimoReservadoFecha = NULL, AplicaRenglon = Renglon  ELSE
IF @Base = 'RESERVADO' UPDATE #VentaDetalle SET ID = @DID, Cantidad = CantidadReservada, CantidadInventario = CantidadReservada * CantidadInventario / Cantidad, CantidadPendiente = NULL, CantidadCancelada = NULL, CantidadReservada = NULL, CantidadOrdenada = NULL, CantidadA = NULL, Aplica = @OrigenMov, AplicaID = @OrigenMovID, UltimoReservadoCantidad = NULL, UltimoReservadoFecha = NULL, AplicaRenglon = Renglon
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Base = 'IDENTICO'
UPDATE #VentaDetalle SET Aplica = o.Aplica, AplicaID = o.AplicaID FROM #VentaDetalle n, VentaD o WHERE o.ID = @OID AND n.Renglon = o.Renglon AND n.RenglonSub = o.RenglonSub
ELSE
UPDATE #VentaDetalle SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, SustitutoArticulo = NULL, SustitutoSubCuenta = NULL
/*
IF @Base = 'SELECCION'
UPDATE #VentaDetalle SET Precio = Precio * Factor WHERE Factor <> 1.0
ELSE
UPDATE #VentaDetalle SET Cantidad = Cantidad / Factor, Precio = Precio * Factor WHERE Factor <> 1.0
*/
SELECT @HuboCambio = 0
DECLARE crJuegoReservado CURSOR FOR
SELECT RenglonTipo, RenglonID, Cantidad
FROM #VentaDetalle
WHERE RenglonTipo IN ('J', 'C')
OPEN crJuegoReservado
FETCH NEXT FROM crJuegoReservado INTO @RenglonTipo, @RenglonID, @Cantidad
WHILE @@FETCH_STATUS = 0
BEGIN
IF @RenglonTipo = 'J' BEGIN
IF ISNULL(@Cantidad, 0.0) = 0.0 BEGIN
IF (SELECT SUM(ISNULL(Cantidad, 0.0)) FROM #VentaDetalle WHERE RenglonTipo = 'C' AND RenglonID = @RenglonID) > 0 BEGIN
UPDATE #VentaDetalle SET Cantidad = -1 WHERE RenglonTipo = @RenglonTipo AND RenglonID = @RenglonID
SELECT @HuboCambio = 1
END
END
END
FETCH NEXT FROM crJuegoReservado INTO @RenglonTipo, @RenglonID, @Cantidad
END
CLOSE crJuegoReservado
DEALLOCATE crJuegoReservado
DELETE #VentaDetalle WHERE Cantidad IS NULL OR Cantidad = 0.0
IF @@ERROR <> 0 SELECT @Ok = 1
IF @HuboCambio = 1
UPDATE #VentaDetalle SET Cantidad = NULL WHERE Cantidad = -1
UPDATE #VentaDetalle SET DescuentoImporte = (Cantidad*Precio)*(DescuentoLinea/100.0)
IF @@ERROR <> 0 SELECT @Ok = 1
INSERT INTO cVentaD SELECT * FROM #VentaDetalle
IF @@ERROR <> 0 SELECT @Ok = 1
DROP TABLE #VentaDetalle
IF @@ERROR <> 0 SELECT @Ok = 1
END ELSE
IF @Modulo = 'PROD'
BEGIN
IF @GenerarDirecto = 1 SELECT @OrigenMov = NULL, @OrigenMovID = NULL
SELECT * INTO #ProdDetalle FROM cProdD WHERE ID = @OID
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Base = 'TODO' DELETE #ProdDetalle WHERE AutoGenerado = 1
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Base = 'TODO'      UPDATE #ProdDetalle SET ID = @DID, AutoGenerado = 0, ProdSerieLote = NULL, CantidadPendiente = NULL, CantidadCancelada = NULL, CantidadReservada = NULL, CantidadOrdenada = NULL, CantidadA = NULL, Aplica = @OrigenMov, AplicaID = @OrigenMovID, UltimoReservadoCantidad = NULL, UltimoReservadoFecha = NULL, AplicaRenglon = Renglon ELSE
IF @Base = 'SELECCION' UPDATE #ProdDetalle SET ID = @DID, AutoGenerado = 0, Cantidad = CantidadA, CantidadInventario = CantidadA * CantidadInventario / Cantidad, CantidadPendiente = NULL, CantidadCancelada = NULL, CantidadReservada = NULL, CantidadOrdenada = NULL, CantidadA = NULL, Aplica = @OrigenMov, AplicaID = @OrigenMovID, UltimoReservadoCantidad = NULL, UltimoReservadoFecha = NULL, AplicaRenglon = Renglon ELSE
IF @Base = 'PENDIENTE' UPDATE #ProdDetalle SET ID = @DID, AutoGenerado = 0, Cantidad = NULLIF(ISNULL(CantidadPendiente,0.0) + ISNULL(CantidadReservada, 0.0), 0.0), CantidadInventario = (NULLIF(ISNULL(CantidadPendiente,0.0) + ISNULL(CantidadReservada, 0.0), 0.0)) * CantidadInventario / Cantidad, CantidadPendiente = NULL, CantidadReservada = NULL, CantidadCancelada = NULL, CantidadOrdenada = NULL, CantidadA = NULL, Aplica = @OrigenMov, AplicaID = @OrigenMovID, UltimoReservadoCantidad = NULL, UltimoReservadoFecha = NULL, AplicaRenglon = Renglon ELSE
IF @Base = 'RESERVADO' UPDATE #ProdDetalle SET ID = @DID, AutoGenerado = 0, Cantidad = CantidadReservada, CantidadInventario = CantidadReservada * CantidadInventario / Cantidad, CantidadPendiente = NULL, CantidadCancelada = NULL, CantidadReservada = NULL, CantidadOrdenada = NULL, CantidadA = NULL, Aplica = @OrigenMov, AplicaID = @OrigenMovID, UltimoReservadoCantidad = NULL, UltimoReservadoFecha = NULL, AplicaRenglon = Renglon
UPDATE #ProdDetalle SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, DestinoTipo = NULL, Destino = NULL, DestinoID = NULL
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #ProdDetalle SET SustitutoArticulo = NULL, SustitutoSubCuenta = NULL
DELETE #ProdDetalle WHERE Cantidad IS NULL OR Cantidad = 0.0
IF @@ERROR <> 0 SELECT @Ok = 1
CREATE TABLE #ProdAplica(
Aplica		  char(20)	COLLATE Database_Default NULL,
AplicaID		  varchar(20)	COLLATE Database_Default NULL,
ProdSerieLote	  varchar(50)	COLLATE Database_Default NULL,
Articulo		  char(20)	COLLATE Database_Default NULL,
SubCuenta		  varchar(50)	COLLATE Database_Default NULL,
Unidad		  varchar(50)	COLLATE Database_Default NULL,
Almacen		  char(10)	COLLATE Database_Default NULL,
Centro		  char(10)	COLLATE Database_Default NULL,
Renglon		  float		NULL,
RenglonSub	  int		NULL,
Cantidad		  float		NULL,
CantidadInventario  float		NULL,
AplicaRenglon		  float		NULL)
INSERT
INTO #ProdAplica
SELECT Aplica, AplicaID, ProdSerieLote, Articulo, SubCuenta, Unidad, Almacen, Centro, Min(Renglon), Min(RenglonSub), SUM(Cantidad), SUM(CantidadInventario), AplicaRenglon
FROM #ProdDetalle
GROUP BY Aplica, AplicaID, ProdSerieLote, Articulo, SubCuenta, Unidad, Almacen, Centro, AplicaRenglon
ORDER BY Aplica, AplicaID, ProdSerieLote, Articulo, SubCuenta, Unidad, Almacen, Centro, AplicaRenglon
IF @@ERROR <> 0 SELECT @Ok = 1
INSERT INTO cProdD
SELECT d.*
FROM #ProdDetalle d, #ProdAplica a
WHERE ISNULL(d.ProdSerieLote, '') = ISNULL(a.ProdSerieLote, '')
AND ISNULL(d.Aplica,'') = ISNULL(a.Aplica, '')
AND ISNULL(d.AplicaID, '') = ISNULL(a.AplicaID, '')
AND d.Articulo = a.Articulo
AND ISNULL(d.SubCuenta,'') = ISNULL(a.SubCuenta, '')
AND d.Almacen = a.Almacen
AND ISNULL(d.Centro, '') = ISNULL(a.Centro, '')
AND d.Renglon = a.Renglon
AND d.RenglonSub = a.RenglonSub
AND d.AplicaRenglon = a.AplicaRenglon
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE ProdD WITH(ROWLOCK)
SET ProdD.Cantidad = a.Cantidad,
ProdD.CantidadInventario = a.CantidadInventario
FROM ProdD d WITH(NOLOCK), #ProdAplica a
WHERE d.ID = @DID
AND ISNULL(d.ProdSerieLote, '') = ISNULL(a.ProdSerieLote, '')
AND ISNULL(d.Aplica,'') = ISNULL(a.Aplica, '')
AND ISNULL(d.AplicaID, '') = ISNULL(a.AplicaID, '')
AND d.Articulo = a.Articulo
AND ISNULL(d.SubCuenta,'') = ISNULL(a.SubCuenta, '')
AND d.Almacen = a.Almacen
AND ISNULL(d.Centro, '') = ISNULL(a.Centro, '')
AND d.Renglon = a.Renglon
AND d.RenglonSub = a.RenglonSub
AND d.AplicaRenglon = a.AplicaRenglon
IF @@ERROR <> 0 SELECT @Ok = 1
DROP TABLE #ProdDetalle
IF @@ERROR <> 0 SELECT @Ok = 1
END ELSE
IF @Modulo = 'COMS'
BEGIN
SELECT @OMov = Mov, @MonedaD = Moneda, @TipoCambioD = TipoCambio, @Proveedor = Proveedor, @Referencia = @Referencia FROM Compra  WHERE ID = @OID
SELECT @DMov = Mov FROM Compra WHERE ID = @DID
IF @OMov = @DMov
UPDATE CompraD SET Tarima = NULL WHERE ID = @DID
SELECT @SubClave = Subclave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @DMov
SELECT * INTO #CompraDetalle FROM cCompraD  WHERE ID = @OID
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Base IN ('TODO', 'IDENTICO') UPDATE #CompraDetalle SET ID = @DID, CantidadCancelada = NULL, CantidadPendiente = NULL, CantidadA = NULL, Aplica = CASE WHEN @OrigenMovTipo <> 'COMS.C' THEN @OrigenMov ELSE Aplica END, AplicaID = CASE WHEN @OrigenMovTipo <> 'COMS.C' THEN @OrigenMovID ELSE AplicaID END, AplicaRenglon = Renglon ELSE
IF @Base = 'SELECCION' UPDATE #CompraDetalle SET ID = @DID, DestinoTipo = CASE WHEN @MovTipo IN ('COMS.CP', 'COMS.O', 'COMS.EI') THEN DestinoTipo ELSE NULL END, Destino = CASE WHEN @MovTipo IN ('COMS.CP', 'COMS.O', 'COMS.EI') THEN Destino ELSE NULL END, DestinoID = CASE WHEN @MovTipo IN ('COMS.CP', 'COMS.O', 'COMS.EI') THEN DestinoID ELSE NULL END, Cantidad = CantidadA, CantidadInventario = CantidadA * CantidadInventario / Cantidad, CantidadCancelada = NULL, CantidadPendiente = NULL, CantidadA = NULL, Aplica = CASE WHEN @OrigenMovTipo <> 'COMS.C' THEN @OrigenMov ELSE Aplica END, AplicaID = CASE WHEN @OrigenMovTipo <> 'COMS.C' THEN @OrigenMovID ELSE AplicaID END, AplicaRenglon = Renglon ELSE
IF @Base = 'PENDIENTE' UPDATE #CompraDetalle SET ID = @DID, DestinoTipo = CASE WHEN @MovTipo IN ('COMS.CP', 'COMS.O', 'COMS.EI') THEN DestinoTipo ELSE NULL END, Destino = CASE WHEN @MovTipo IN ('COMS.CP', 'COMS.O', 'COMS.EI') THEN Destino ELSE NULL END, DestinoID = CASE WHEN @MovTipo IN ('COMS.CP', 'COMS.O', 'COMS.EI') THEN DestinoID ELSE NULL END, Cantidad = CantidadPendiente, CantidadInventario = CantidadPendiente * CantidadInventario / Cantidad, CantidadCancelada = NULL, CantidadPendiente = NULL, CantidadA = NULL, Aplica = CASE WHEN @OrigenMovTipo <> 'COMS.C' THEN @OrigenMov ELSE Aplica END, AplicaID = CASE WHEN @OrigenMovTipo <> 'COMS.C' THEN @OrigenMovID ELSE AplicaID END, AplicaRenglon = Renglon
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Base <> 'IDENTICO'
UPDATE #CompraDetalle SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal
IF @MovTipo = 'COMS.EI' OR @SubClave = 'COMS.EIMPO'
UPDATE #CompraDetalle SET MonedaD = @MonedaD, TipoCambioD = @TipoCambioD, ImportacionProveedor = @Proveedor, ImportacionReferencia = @Referencia
DELETE #CompraDetalle WHERE Cantidad IS NULL OR Cantidad = 0.0
IF @@ERROR <> 0 SELECT @Ok = 1
IF @OrigenMovTipo IN ('COMS.R','COMS.O','COMS.OP','COMS.OG','COMS.OD','COMS.OI')
BEGIN
CREATE TABLE #CompraAplica(
Almacen			char(10)	COLLATE Database_Default NULL,
Aplica			char(20)	COLLATE Database_Default NULL,
AplicaID		varchar(20)	COLLATE Database_Default NULL,
Articulo		char(20)	COLLATE Database_Default NULL,
SubCuenta		varchar(50)	COLLATE Database_Default NULL,
Unidad			varchar(50)	COLLATE Database_Default NULL,
Cliente			char(10)	COLLATE Database_Default NULL,
ContUso			char(20)	COLLATE Database_Default NULL,
FechaRequerida		datetime	NULL,
Renglon			float		NULL,
RenglonSub		int		NULL,
Cantidad		float		NULL,
CantidadInventario  	float		NULL,
Costo			float		NULL,
ContUso2		char(20)	COLLATE Database_Default NULL,
ContUso3		char(20)	COLLATE Database_Default NULL,
AplicaRenglon	float NULL)
IF (SELECT CompraConcentrarEntrada FROM EmpresaCfg WHERE Empresa = @Empresa) = 1
INSERT
INTO #CompraAplica
SELECT Almacen, Aplica, AplicaID, Articulo, SubCuenta, Unidad, Cliente, ContUso, FechaRequerida, Min(Renglon), Min(RenglonSub), SUM(Cantidad), SUM(CantidadInventario), SUM(Costo*Cantidad)/SUM(Cantidad), ContUso2, ContUso3, AplicaRenglon
FROM #CompraDetalle
GROUP BY Almacen, Aplica, AplicaID, Articulo, SubCuenta, Unidad, Cliente, ContUso, FechaRequerida, ContUso2, ContUso3, AplicaRenglon
ORDER BY Almacen, Aplica, AplicaID, Articulo, SubCuenta, Unidad, Cliente, ContUso, FechaRequerida, ContUso2, ContUso3, AplicaRenglon
ELSE
INSERT
INTO #CompraAplica
SELECT Almacen, Aplica, AplicaID, Articulo, SubCuenta, Unidad, Cliente, ContUso, FechaRequerida, Renglon, RenglonSub, Cantidad, CantidadInventario, Costo, ContUso2, ContUso3, AplicaRenglon
FROM #CompraDetalle
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #CompraDetalle SET DescuentoImporte = (Cantidad*Costo)*(DescuentoLinea/100.0)
IF @@ERROR <> 0 SELECT @Ok = 1
INSERT INTO cCompraD
SELECT d.*
FROM #CompraDetalle d, #CompraAplica a
WHERE d.Almacen = a.Almacen
AND d.Aplica = a.Aplica
AND d.AplicaID = a.AplicaID
AND d.Articulo = a.Articulo
AND ISNULL(d.SubCuenta,'') = ISNULL(a.SubCuenta, '')
AND ISNULL(d.Cliente,'') = ISNULL(a.Cliente, '')
AND d.Renglon = a.Renglon
AND d.RenglonSub = a.RenglonSub
AND d.AplicaRenglon = a.AplicaRenglon
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE CompraD
SET DestinoTipo    = CASE WHEN @MovTipo IN ('COMS.CP', 'COMS.O', 'COMS.EI') THEN DestinoTipo ELSE NULL END,
Destino        = CASE WHEN @MovTipo IN ('COMS.CP', 'COMS.O', 'COMS.EI') THEN Destino     ELSE NULL END,
DestinoID      = CASE WHEN @MovTipo IN ('COMS.CP', 'COMS.O', 'COMS.EI') THEN DestinoID   ELSE NULL END,
CompraD.Cantidad = a.Cantidad,
CompraD.CantidadInventario = a.CantidadInventario,
CompraD.Costo  = a.Costo
FROM CompraD d, #CompraAplica a
WHERE d.ID = @DID
AND d.Almacen = a.Almacen
AND d.Aplica = a.Aplica
AND d.AplicaID = a.AplicaID
AND d.Articulo = a.Articulo
AND ISNULL(d.SubCuenta,'') = ISNULL(a.SubCuenta, '')
AND ISNULL(d.Cliente,'') = ISNULL(a.Cliente, '')
AND d.Renglon = a.Renglon
AND d.RenglonSub = a.RenglonSub
AND d.AplicaRenglon = a.AplicaRenglon
IF @@ERROR <> 0 SELECT @Ok = 1
END ELSE
BEGIN
UPDATE #CompraDetalle SET DescuentoImporte = (Cantidad*Costo)*(DescuentoLinea/100.0)
IF @@ERROR <> 0 SELECT @Ok = 1
INSERT INTO cCompraD SELECT * FROM #CompraDetalle
IF @@ERROR <> 0 SELECT @Ok = 1
END
DROP TABLE #CompraDetalle
IF @@ERROR <> 0 SELECT @Ok = 1
END ELSE
IF @Modulo = 'INV'
BEGIN
SELECT @OMov = Mov FROM Inv WHERE ID = @OID
SELECT @DMov = Mov FROM Inv WHERE ID = @DID
IF @OMov = @DMov
UPDATE InvD SET Tarima = NULL WHERE ID = @DID
IF @GenerarDirecto = 1 SELECT @OrigenMov = NULL, @OrigenMovID = NULL
SELECT * INTO #InvDetalle FROM cInvD   WHERE ID = @OID
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Base IN ('TODO', 'IDENTICO') UPDATE #InvDetalle SET ID = @DID, CantidadPendiente = NULL, CantidadCancelada = NULL, CantidadReservada = NULL, CantidadOrdenada = NULL, CantidadA = NULL, Aplica = @OrigenMov, AplicaID = @OrigenMovID, UltimoReservadoCantidad = NULL, UltimoReservadoFecha = NULL, AplicaRenglon = Renglon ELSE
IF @Base = 'SELECCION' UPDATE #InvDetalle SET ID = @DID, Cantidad = CantidadA, CantidadInventario = CantidadA * CantidadInventario / Cantidad, CantidadPendiente = NULL, CantidadCancelada = NULL, CantidadReservada = NULL, CantidadOrdenada = NULL, CantidadA = NULL, Aplica = @OrigenMov, AplicaID = @OrigenMovID, UltimoReservadoCantidad = NULL, UltimoReservadoFecha = NULL, AplicaRenglon = Renglon ELSE
IF @Base = 'PENDIENTE' UPDATE #InvDetalle SET ID = @DID, Cantidad = NULLIF(ISNULL(CantidadPendiente,0.0) + ISNULL(CantidadReservada, 0.0), 0.0), CantidadInventario = (NULLIF(ISNULL(CantidadPendiente,0.0) + ISNULL(CantidadReservada, 0.0), 0.0)) * CantidadInventario / Cantidad, CantidadPendiente = NULL, CantidadReservada = NULL, CantidadCancelada = NULL, CantidadOrdenada = NULL, CantidadA = NULL, Aplica = @OrigenMov, AplicaID = @OrigenMovID, UltimoReservadoCantidad = NULL, UltimoReservadoFecha = NULL, AplicaRenglon = Renglon ELSE
IF @Base = 'RESERVADO' UPDATE #InvDetalle SET ID = @DID, Cantidad = CantidadReservada, CantidadInventario = CantidadReservada * CantidadInventario / Cantidad, CantidadPendiente = NULL, CantidadCancelada = NULL, CantidadReservada = NULL, CantidadOrdenada = NULL, CantidadA = NULL, Aplica = @OrigenMov, AplicaID = @OrigenMovID, UltimoReservadoCantidad = NULL, UltimoReservadoFecha = NULL, AplicaRenglon = Renglon
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #InvDetalle SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal
DELETE #InvDetalle WHERE Cantidad IS NULL OR Cantidad = 0.0
IF @@ERROR <> 0 SELECT @Ok = 1
IF @OrigenMovTipo IN ('INV.SOL', 'INV.SM')
BEGIN
CREATE TABLE #InvAplica   (
ProdSerieLote		    varchar(50)	COLLATE Database_Default NULL,
Producto		        char(20)	COLLATE Database_Default NULL,
SubProducto		        varchar(50)	COLLATE Database_Default NULL,
Almacen			        char(10)	COLLATE Database_Default NULL,
Aplica			        char(20)	COLLATE Database_Default NULL,
AplicaID		        varchar(20)	COLLATE Database_Default NULL,
Articulo		        char(20)	COLLATE Database_Default NULL,
SubCuenta		        varchar(50)	COLLATE Database_Default NULL,
Unidad			        varchar(50)	COLLATE Database_Default NULL,
ContUso			        char(20)	COLLATE Database_Default NULL,
Renglon			        float		NULL,
RenglonSub		        int		    NULL,
RenglonID               int         NULL,
Cantidad		        float		NULL,
CantidadInventario  	float		NULL,
Merma			        float		NULL,
Desperdicio		        float		NULL,
FechaCaducidad	        datetime	NULL,
AplicaRenglon	        float		NULL
)
CREATE TABLE #SerieLoteMov(Empresa				varchar(5)  COLLATE Database_Default NULL,
Modulo				varchar(4)  COLLATE Database_Default NULL,
ID					int,
RenglonID			int,
Articulo				varchar(20) COLLATE Database_Default NULL,
SubCuenta			varchar(50) COLLATE Database_Default NULL,
SerieLote			varchar(50) COLLATE Database_Default NULL,
Cantidad				float,
CantidadAlterna		float,
Propiedades			varchar(20) COLLATE Database_Default NULL,
Ubicacion			int NULL,
Cliente				varchar(10) COLLATE Database_Default NULL,
Localizacion			varchar(10) COLLATE Database_Default NULL,
Sucursal				int NULL,
ArtCostoInv			money NULL,
Tarima				varchar(20) COLLATE Database_Default NULL,
AsignacionUbicacion	bit NULL)
DELETE SerieLoteMov WHERE Modulo = @Modulo AND ID = @DID
INSERT
INTO #InvAplica (ProdSerieLote, Producto, SubProducto, Almacen, Aplica, AplicaID, Articulo, SubCuenta, Unidad, ContUso, Renglon, RenglonSub, RenglonID, Cantidad, CantidadInventario, Merma, Desperdicio, FechaCaducidad, AplicaRenglon)
SELECT ProdSerieLote, Producto, SubProducto, Almacen, Aplica, AplicaID, Articulo, SubCuenta, Unidad, ContUso, Min(Renglon), Min(RenglonSub), Min(RenglonID), SUM(Cantidad), SUM(CantidadInventario), SUM(Merma), SUM(Desperdicio), CASE WHEN @MovTipo = 'INV.TMA' THEN FechaCaducidad END, AplicaRenglon
FROM #InvDetalle
GROUP BY ProdSerieLote, Producto, SubProducto, Almacen, Aplica, AplicaID, Articulo, SubCuenta, Unidad, ContUso, CASE WHEN @MovTipo = 'INV.TMA' THEN FechaCaducidad END, AplicaRenglon 
ORDER BY ProdSerieLote, Producto, SubProducto, Almacen, Aplica, AplicaID, Articulo, SubCuenta, Unidad, ContUso, CASE WHEN @MovTipo = 'INV.TMA' THEN FechaCaducidad END, AplicaRenglon 
INSERT #SerieLoteMov(Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, CantidadAlterna,
Propiedades, Ubicacion, Cliente, Localizacion, Sucursal, ArtCostoInv, Tarima, AsignacionUbicacion)
SELECT A.Empresa, A.Modulo, @DID, B.RenglonID, A.Articulo, A.SubCuenta, A.SerieLote, Sum(ISNULL(A.Cantidad,0)), SUM(ISNULL(A.CantidadAlterna,0)),
A.Propiedades, A.Ubicacion, A.Cliente, A.Localizacion, A.Sucursal, A.ArtCostoInv, A.Tarima, A.AsignacionUbicacion
FROM SerieLoteMov A
JOIN #InvAplica B
ON A.Articulo = B.Articulo
AND ISNULL(A.SubCuenta,'') = ISNULL(B.SubCuenta,'')
JOIN InvD C
ON A.ID = C.ID
AND A.Articulo = C.Articulo
AND ISNULL(A.SubCuenta,'') = ISNULL(C.SubCuenta,'')
AND A.RenglonID = C.RenglonID
AND ISNULL(B.FechaCaducidad,'') = ISNULL(C.FechaCaducidad,'')
WHERE A.Modulo = @Modulo
AND A.ID = @OID
GROUP BY A.Empresa, A.Modulo, A.ID, B.RenglonID, A.Articulo, A.SubCuenta, A.SerieLote, A.Propiedades,
A.Ubicacion, A.Cliente, A.Localizacion, A.Sucursal, A.ArtCostoInv, A.Tarima, A.AsignacionUbicacion,
ISNULL(C.FechaCaducidad,'')
IF EXISTS(SELECT * FROM #SerieLoteMov)
BEGIN
DELETE FROM SerieLoteMov WHERE Modulo = @Modulo AND ID = @DID
INSERT SerieLoteMov(Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, CantidadAlterna,
Propiedades, Ubicacion, Cliente, Localizacion, Sucursal, ArtCostoInv, Tarima, AsignacionUbicacion)
SELECT Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, CantidadAlterna,
Propiedades, Ubicacion, Cliente, Localizacion, Sucursal, ArtCostoInv, Tarima, AsignacionUbicacion
FROM #SerieLoteMov
END
IF @@ERROR <> 0 SELECT @Ok = 1
INSERT INTO cInvD
SELECT d.*
FROM #InvDetalle d, #InvAplica a
WHERE ISNULL(d.ProdSerieLote, '') = ISNULL(a.ProdSerieLote, '')
AND ISNULL(d.Producto, '') = ISNULL(a.Producto, '')
AND ISNULL(d.SubProducto, '') = ISNULL(a.SubProducto, '')
AND d.Almacen = a.Almacen
AND d.Aplica = a.Aplica
AND d.AplicaID = a.AplicaID
AND d.Articulo = a.Articulo
AND ISNULL(d.SubCuenta,'') = ISNULL(a.SubCuenta, '')
AND d.Renglon = a.Renglon
AND d.RenglonSub = a.RenglonSub
AND d.AplicaRenglon = a.AplicaRenglon
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE InvD
SET InvD.Cantidad = a.Cantidad,
InvD.CantidadInventario = a.CantidadInventario,
InvD.Merma = a.Merma,
InvD.Desperdicio = a.Desperdicio
FROM InvD d, #InvAplica a
WHERE d.ID = @DID
AND ISNULL(d.ProdSerieLote, '') = ISNULL(a.ProdSerieLote, '')
AND ISNULL(d.Producto, '') = ISNULL(a.Producto, '')
AND ISNULL(d.SubProducto, '') = ISNULL(a.SubProducto, '')
AND d.Almacen = a.Almacen
AND d.Aplica = a.Aplica
AND d.AplicaID = a.AplicaID
AND d.Articulo = a.Articulo
AND ISNULL(d.SubCuenta,'') = ISNULL(a.SubCuenta, '')
AND d.Renglon = a.Renglon
AND d.RenglonSub = a.RenglonSub
AND d.AplicaRenglon = a.AplicaRenglon
IF @@ERROR <> 0 SELECT @Ok = 1
END ELSE
BEGIN
INSERT INTO cInvD SELECT * FROM #InvDetalle
IF @@ERROR <> 0 SELECT @Ok = 1
END
DROP TABLE #InvDetalle
IF @@ERROR <> 0 SELECT @Ok = 1
END
/*  IF @Modulo = 'TMA'
BEGIN
IF @GenerarDirecto = 1 SELECT @OrigenMov = NULL, @OrigenMovID = NULL
SELECT * INTO #TMADetalle FROM cTMAD WHERE ID = @OID
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Base = 'TODO'      UPDATE #InvDetalle SET ID = @DID, CantidadPendiente = NULL, CantidadA = NULL, Aplica = @OrigenMov, AplicaID = @OrigenMovID  ELSE
IF @Base = 'SELECCION' UPDATE #InvDetalle SET ID = @DID, Cantidad = CantidadA, CantidadPendiente = NULL, CantidadA = NULL, Aplica = @OrigenMov, AplicaID = @OrigenMovID  ELSE
IF @Base = 'PENDIENTE' UPDATE #InvDetalle SET ID = @DID, Cantidad = CantidadPendiente, CantidadPendiente = NULL, CantidadA = NULL, Aplica = @OrigenMov, AplicaID = @OrigenMovID
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #TMADetalle SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal
DELETE #TMADetalle WHERE Cantidad IS NULL OR Cantidad = 0.0
IF @@ERROR <> 0 SELECT @Ok = 1
END */
IF @Modulo = 'TMA'
BEGIN
SELECT @OMov = Mov FROM TMA WHERE ID = @OID
SELECT @DMov = Mov FROM TMA WHERE ID = @DID
IF @OMov = @DMov
UPDATE TMAD SET Tarima = NULL WHERE ID = @DID
END
IF @Modulo = 'SAUX'
BEGIN
IF @GenerarDirecto = 1 SELECT @OrigenMov = NULL, @OrigenMovID = NULL
SELECT * INTO #SAUXDetalle FROM cSAUXD WHERE ID = @OID
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Base = 'TODO'      UPDATE #SAUXDetalle SET ID = @DID, CantidadPendeiente = NULL, CantidadA = NULL ELSE
IF @Base = 'SELECCION' UPDATE #SAUXDetalle SET ID = @DID, Cantidad = CantidadA, CantidadPendeiente = NULL, CantidadA = NULL ELSE
IF @Base = 'PENDIENTE' UPDATE #SAUXDetalle SET ID = @DID, Cantidad = CantidadPendeiente, CantidadPendeiente = NULL, CantidadA = NULL
IF @@ERROR <> 0 SELECT @Ok = 1
DELETE #SAUXDetalle WHERE Cantidad IS NULL OR Cantidad = 0.0
IF @@ERROR <> 0 SELECT @Ok = 1
INSERT INTO cSAUXD SELECT * FROM #SAUXDetalle
IF @@ERROR <> 0 SELECT @Ok = 1
DROP TABLE #SAUXDetalle
IF @@ERROR <> 0 SELECT @Ok = 1
END
EXEC spInvUtilizarTodoDetalleWMS @Modulo, @OID, @DID 
EXEC xpInvUtilizarTodoDetalle @Sucursal, @Modulo, @Base, @OID, @OrigenMov, @OrigenMovID, @OrigenMovTipo, @DID, @GenerarDirecto, @Ok OUTPUT
/*********************************************************     BUG 7029     *********************************************************************/
IF @Modulo = 'INV'
SELECT @SubClave = B.SubClave FROM Inv A JOIN MovTipo B ON B.Modulo = @Modulo AND A.Mov = B.Mov WHERE A.ID = @OID
IF @Modulo = 'INV' AND @MovTipo = 'INV.T' 
BEGIN
DECLARE crArticuloTarima CURSOR FOR
SELECT Articulo, isnull(Subcuenta,''), Tarima, Almacen, SUM(Cantidad), RenglonID  FROM InvD WHERE ID = @OID GROUP BY Articulo, SubCuenta, Tarima, Almacen, RenglonID
OPEN crArticuloTarima
FETCH NEXT FROM crArticuloTarima INTO @Articulo, @Subcuenta, @Tarima, @Almacen, @CantidadP, @cRenglonID
WHILE @@FETCH_STATUS = 0 AND @CantidadP > 0
BEGIN
DECLARE crTarimaSerie CURSOR FOR
SELECT Tarima, Articulo, SerieLote, SubCuenta, Almacen, Sucursal, Empresa, Existencia
FROM SerieLote
WHERE Tarima = @Tarima
AND Articulo = @Articulo
AND SubCuenta = @Subcuenta
AND Almacen = @Almacen
AND Sucursal = @Sucursal
AND Empresa = @Empresa
AND Existencia > 0
OPEN crTarimaSerie
FETCH NEXT FROM crTarimaSerie INTO @cTarima, @cArticulo, @cSerieLote, @cSubCuenta, @cAlmacen, @cSucursal, @cEmpresa, @cExistencia
WHILE @@FETCH_STATUS = 0 AND @CantidadP > 0
BEGIN
IF @cExistencia >= @CantidadP
BEGIN
INSERT @SerieLoteMov(Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Sucursal, Tarima, AsignacionUbicacion)
SELECT @Empresa, @Modulo, @DID, @cRenglonID, @cArticulo, @cSubCuenta, @cSerieLote, @CantidadP, @Sucursal, @cTarima, 0
SET @CantidadP = 0
END
IF @cExistencia < @CantidadP
BEGIN
INSERT @SerieLoteMov(Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Sucursal, Tarima, AsignacionUbicacion)
SELECT @Empresa, @Modulo, @DID, @cRenglonID, @cArticulo, @cSubCuenta, @cSerieLote, @cExistencia, @Sucursal, @cTarima, 0
SET @CantidadP = @CantidadP - @cExistencia
END
FETCH NEXT FROM crTarimaSerie INTO @cTarima, @cArticulo, @cSerieLote, @cSubCuenta,	@cAlmacen, @cSucursal, @cEmpresa, @cExistencia
END
CLOSE crTarimaSerie
DEALLOCATE crTarimaSerie
FETCH NEXT FROM crArticuloTarima INTO @Articulo, @Subcuenta, @Tarima, @Almacen, @CantidadP, @cRenglonID
END
CLOSE crArticuloTarima
DEALLOCATE crArticuloTarima
IF EXISTS(SELECT * FROM @SerieLoteMov)
BEGIN
DELETE FROM SERIELOTEMOV WHERE Modulo = @Modulo AND ID = @DID
INSERT INTO SerieLoteMov(Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Sucursal, Tarima, AsignacionUbicacion)
SELECT Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Sucursal, Tarima, AsignacionUbicacion
FROM @SerieLoteMov
END
END
IF @MovTipo IN ('VTAS.F','INV.OT','INV.OI','COMS.OD')
BEGIN
IF @Modulo = 'VTAS'
BEGIN
DECLARE crArticuloTarima CURSOR FOR
SELECT Articulo, isnull(Subcuenta,''), Tarima, Almacen, SUM(Cantidad), RenglonID FROM VentaD WHERE ID = @DID GROUP BY Articulo, SubCuenta , Tarima, Almacen, RenglonID
END
IF @Modulo = 'INV'
BEGIN
DELETE FROM SerieLoteMOV WHERE ID = @DID AND Modulo = @Modulo
DECLARE crArticuloTarima CURSOR FOR
SELECT Articulo, isnull(Subcuenta,''), Tarima, Almacen, SUM(Cantidad), RenglonID  FROM InvD WHERE ID = @DID GROUP BY Articulo, SubCuenta, Tarima, Almacen, RenglonID
END
IF @Modulo = 'COMS'
DECLARE crArticuloTarima CURSOR FOR
SELECT Articulo, isnull(Subcuenta,''), Tarima, Almacen, SUM(Cantidad), RenglonID  FROM CompraD WHERE ID = @DID GROUP BY Articulo, SubCuenta, Tarima, Almacen, RenglonID
OPEN crArticuloTarima
FETCH NEXT FROM crArticuloTarima INTO @Articulo, @Subcuenta, @Tarima, @Almacen, @CantidadP, @cRenglonID
WHILE @@FETCH_STATUS = 0 AND @CantidadP > 0
BEGIN
DECLARE crTarimaSerie CURSOR FOR
SELECT Tarima, Articulo, SerieLote, SubCuenta, Almacen, Sucursal, Empresa, Existencia
FROM SerieLote
WHERE Tarima = @Tarima
AND Articulo = @Articulo
AND SubCuenta = @Subcuenta
AND Almacen = @Almacen
AND Sucursal = @Sucursal
AND Empresa = @Empresa
AND Existencia > 0
OPEN crTarimaSerie
FETCH NEXT FROM crTarimaSerie INTO @cTarima, @cArticulo, @cSerieLote, @cSubCuenta, @cAlmacen, @cSucursal, @cEmpresa, @cExistencia
WHILE @@FETCH_STATUS = 0 AND @CantidadP > 0
BEGIN
IF @cExistencia >= @CantidadP
BEGIN
INSERT @SerieLoteMov(Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Sucursal, Tarima, AsignacionUbicacion)
SELECT @Empresa, @Modulo, @DID, @cRenglonID, @cArticulo, @cSubCuenta, @cSerieLote, @CantidadP, @Sucursal, @cTarima, 0
SET @CantidadP = 0
END
IF @cExistencia < @CantidadP
BEGIN
INSERT @SerieLoteMov(Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Sucursal, Tarima, AsignacionUbicacion)
SELECT @Empresa, @Modulo, @DID, @cRenglonID, @cArticulo, @cSubCuenta, @cSerieLote, @cExistencia, @Sucursal, @cTarima, 0
SET @CantidadP = @CantidadP - @cExistencia
END
FETCH NEXT FROM crTarimaSerie INTO @cTarima, @cArticulo, @cSerieLote, @cSubCuenta,	@cAlmacen, @cSucursal, @cEmpresa, @cExistencia
END
CLOSE crTarimaSerie
DEALLOCATE crTarimaSerie
FETCH NEXT FROM crArticuloTarima INTO @Articulo, @Subcuenta, @Tarima, @Almacen, @CantidadP, @cRenglonID
END
CLOSE crArticuloTarima
DEALLOCATE crArticuloTarima
IF EXISTS(SELECT * FROM @SerieLoteMov)
BEGIN
DELETE FROM SERIELOTEMOV WHERE Modulo = @Modulo AND ID = @DID
INSERT INTO SerieLoteMov(Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Sucursal, Tarima, AsignacionUbicacion)
SELECT Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Sucursal, Tarima, AsignacionUbicacion
FROM @SerieLoteMov
END
END
RETURN
END

