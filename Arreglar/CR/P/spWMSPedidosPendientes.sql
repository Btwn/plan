SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSPedidosPendientes
@Estacion	int,
@Empresa	varchar(5)

AS
BEGIN
DECLARE
@CrID			int,
@CrModulo		varchar(5),
@CrMov			varchar(20),
@CrMovID		varchar(20),
@CrArticulo		varchar(20),
@CrRenglonID	int
DECLARE @Pedidos AS TABLE(Estacion			int				NOT NULL,
Empresa			varchar(5)		NOT NULL,
Modulo			varchar(5)		NOT NULL,
ID				int				NOT NULL,
Mov				varchar(20)		NOT NULL,
MovID				varchar(20)		NOT NULL,
RenglonID			int				NOT NULL,
Sucursal			int				NOT NULL,
Almacen			varchar(10)		NOT NULL,
Articulo			varchar(20)		NOT NULL,
SubCuenta			varchar(50)		NOT NULL,
CantidadPicking	float			NOT NULL,
Tarima			varchar(20)		NOT NULL)
INSERT @Pedidos(Estacion, Empresa, Modulo, ID, Mov, MovID, RenglonID, Sucursal,
Almacen, Articulo, SubCuenta, CantidadPicking, Tarima)
SELECT @Estacion, A.Empresa, 'VTAS' Modulo, A.ID, A.Mov, A.MovID, B.RenglonID, A.Sucursal,
A.Almacen, B.Articulo, ISNULL(B.Subcuenta,''), B.CantidadPendiente, B.Tarima
FROM Venta A
JOIN VentaD B
ON A.ID = B.ID
JOIN Alm C
ON A.Almacen = C.Almacen
AND C.WMS = 1
JOIN Art D
ON B.Articulo = D.Articulo
JOIN MovTipo E
ON E.Modulo = 'VTAS'
AND A.Mov = E.Mov
WHERE A.Estatus = 'PENDIENTE'
AND A.Empresa = @Empresa
AND B.Tarima IS NOT NULL
AND E.Clave NOT IN ('VTAS.VCR')
INSERT @Pedidos(Estacion, Modulo, ID,  Mov, MovID, RenglonID, Empresa, Sucursal,
Almacen, Articulo, SubCuenta, CantidadPicking, Tarima)
SELECT @Estacion, 'COMS' Modulo, A.ID, A.Mov, A.MovID, B.RenglonID, A.Empresa, A.Sucursal,
A.Almacen, B.Articulo, ISNULL(B.Subcuenta,''), B.CantidadPendiente, B.Tarima
FROM Compra A
JOIN CompraD B
ON A.ID = B.ID
JOIN Alm C
ON A.Almacen = C.Almacen
AND C.WMS = 1
JOIN Art D
ON B.Articulo = D.Articulo
WHERE A.Estatus = 'PENDIENTE'
AND A.Empresa = @Empresa
AND B.Tarima IS NOT NULL
INSERT @Pedidos(Estacion, Modulo, ID,  Mov, MovID, RenglonID, Empresa, Sucursal,
Almacen, Articulo, SubCuenta, CantidadPicking, Tarima)
SELECT @Estacion, 'INV' Modulo, A.ID, A.Mov, A.MovID, B.RenglonID, A.Empresa, A.Sucursal,
A.Almacen, B.Articulo, ISNULL(B.Subcuenta,''), B.CantidadPendiente, B.Tarima
FROM Inv A
JOIN InvD B
ON A.ID = B.ID
JOIN Alm C
ON A.Almacen = C.Almacen
AND C.WMS = 1
JOIN Art D
ON B.Articulo = D.Articulo
JOIN MovTipo E
ON E.Modulo = 'INV'
AND A.Mov = E.Mov
WHERE A.Estatus = 'PENDIENTE'
AND A.Empresa = @Empresa
AND B.Tarima IS NOT NULL
AND E.Clave NOT IN ('INV.TI')
DECLARE CrPedidos CURSOR FOR
SELECT ID, Modulo, Mov, MovID, Articulo, RenglonID
FROM @Pedidos
OPEN CrPedidos
FETCH NEXT FROM CrPedidos INTO @CrID, @CrModulo, @CrMov, @CrMovID, @CrArticulo, @CrRenglonID
WHILE @@FETCH_STATUS = 0
BEGIN
IF EXISTS(SELECT *
FROM TMA A
JOIN TMAD B ON A.ID = B.ID
WHERE A.OrigenTipo = @CrModulo
AND A.Origen = @CrMov
AND A.OrigenID = @CrMovID
AND B.Articulo = @CrArticulo
AND A.Estatus <> 'CANCELADO')
DELETE FROM @Pedidos WHERE ID = @CrID AND Articulo = @CrArticulo
FETCH NEXT FROM CrPedidos INTO @CrID, @CrModulo, @CrMov, @CrMovID, @CrArticulo, @CrRenglonID
END
CLOSE CrPedidos
DEALLOCATE CrPedidos
DELETE FROM WMSPedidosSinSurtir WHERE Estacion = @Estacion
INSERT WMSPedidosSinSurtir(Estacion, Empresa, Modulo, ModuloID, Mov, MovID, RenglonID, Sucursal,
Almacen, Articulo, SubCuenta, Tarima, Cantidad)
SELECT Estacion, Empresa, Modulo, ID, Mov, MovID, RenglonID,  Sucursal,
Almacen, Articulo, SubCuenta, Tarima, CantidadPicking
FROM @Pedidos
END

