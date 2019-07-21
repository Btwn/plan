SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSSurtidosXProcesar
@Estacion	int

AS
BEGIN
DECLARE
@CrID			int,
@CrModulo		varchar(5),
@CrMov			varchar(20),
@CrMovID		varchar(20),
@CrMFID			int,
@CrMFModulo		varchar(5),
@CrMFSalir		bit
DECLARE @SurtidosXProcesar AS TABLE(Estacion			int			NOT NULL,
ID					int			NOT NULL,
Modulo				varchar(5)	NOT NULL,
Mov					varchar(20)	NOT NULL,
MovID				varchar(20)	NOT NULL,
Empresa				varchar(5)	NOT NULL,
Sucursal			int			NOT NULL,
Almacen				varchar(10) NOT NULL,
Articulo			varchar(20) NOT NULL,
SubCuenta			varchar(50) NULL,
Zona				varchar(50) NULL,
CantidadPicking		float		NOT NULL,
Tarima				varchar(20)	NULL,
Posicion			varchar(10) NULL,
OrigenTipo			varchar(10) NOT NULL,
Origen				varchar(20) NOT NULL,
OrigenID			varchar(20) NOT NULL,
OrigenMovID			int			NULL
)
DELETE FROM @SurtidosXProcesar WHERE Estacion = @Estacion
/*****     VENTAS     *****/
INSERT INTO @SurtidosXProcesar(Estacion, ID, Modulo, Mov, MovID, Empresa, Sucursal, Almacen, Articulo,
SubCuenta, Zona, CantidadPicking, Tarima, Posicion, OrigenTipo, Origen, OrigenID, OrigenMovID)
SELECT DISTINCT @Estacion, A.ID, 'TMA', A.Mov, A.MovID, A.Empresa, A.Sucursal, A.Almacen, B.Articulo,
ISNULL(B.Subcuenta,''), B.Zona, B.CantidadPicking, B.Tarima, B.Posicion, A.OrigenTipo, A.Origen, E.ID, A.OrigenID
FROM TMA A
JOIN TMAD B
ON A.ID = B.ID
JOIN MovTipo C
ON C.Modulo = 'TMA'
AND A.Mov = C.Mov
JOIN Venta E
ON A.Origen = E.Mov
AND A.OrigenID = E.MovID
JOIN VentaD F
ON E.ID = F.ID
AND B.Articulo = F.Articulo
AND ISNULL(B.SubCuenta,'')=ISNULL(F.SubCuenta,'')
WHERE C.Clave IN ('TMA.OSUR','TMA.OPCKTARIMA')
AND A.Estatus = 'PENDIENTE'
AND F.Tarima IS NOT NULL
AND F.CantidadPendiente > 0
/*****     COMPRAS     *****/
INSERT INTO @SurtidosXProcesar(Estacion, ID, Modulo, Mov, MovID, Empresa, Sucursal, Almacen, Articulo,
SubCuenta, Zona, CantidadPicking, Tarima, Posicion, OrigenTipo, Origen, OrigenID, OrigenMovID)
SELECT DISTINCT @Estacion, A.ID, 'TMA', A.Mov, A.MovID, A.Empresa, A.Sucursal, A.Almacen, B.Articulo,
ISNULL(B.Subcuenta,''), B.Zona, B.CantidadPicking, B.Tarima, B.Posicion, A.OrigenTipo, A.Origen, E.ID, A.OrigenID
FROM TMA A
JOIN TMAD B
ON A.ID = B.ID
JOIN MovTipo C
ON C.Modulo = 'TMA'
AND A.Mov = C.Mov
JOIN Compra E
ON A.Origen = E.Mov
AND A.OrigenID = E.MovID
JOIN CompraD F
ON E.ID = F.ID
AND B.Articulo = F.Articulo
AND ISNULL(B.SubCuenta,'')=ISNULL(F.SubCuenta,'')
WHERE C.Clave IN ('TMA.OSUR','TMA.OPCKTARIMA')
AND A.Estatus = 'PENDIENTE'
AND F.Tarima IS NOT NULL
AND F.CantidadPendiente > 0
/*****     INVENTARIOS     *****/
INSERT INTO @SurtidosXProcesar(Estacion, ID, Modulo, Mov, MovID, Empresa, Sucursal, Almacen, Articulo,
SubCuenta, Zona, CantidadPicking, Tarima, Posicion, OrigenTipo, Origen, OrigenID, OrigenMovID)
SELECT DISTINCT @Estacion, A.ID, 'TMA', A.Mov, A.MovID, A.Empresa, A.Sucursal, A.Almacen, B.Articulo,
ISNULL(B.Subcuenta,''), B.Zona, B.CantidadPicking, B.Tarima, B.Posicion, A.OrigenTipo, A.Origen, E.ID, A.OrigenID
FROM TMA A
JOIN TMAD B
ON A.ID = B.ID
JOIN MovTipo C
ON C.Modulo = 'TMA'
AND A.Mov = C.Mov
JOIN Inv E
ON A.Origen = E.Mov
AND A.OrigenID = E.MovID
JOIN InvD F
ON E.ID = F.ID
AND B.Articulo = F.Articulo
AND ISNULL(B.SubCuenta,'')=ISNULL(F.SubCuenta,'')
WHERE C.Clave IN ('TMA.OSUR','TMA.OPCKTARIMA')
AND A.Estatus = 'PENDIENTE'
AND F.Tarima IS NOT NULL
AND F.CantidadPendiente > 0
DECLARE CrOrdenSurtido CURSOR FOR
SELECT ID, Modulo, Mov, MovID
FROM @SurtidosXProcesar
OPEN CrOrdenSurtido
FETCH NEXT FROM CrOrdenSurtido INTO @CrID, @CrModulo, @CrMov, @CrMovID
WHILE @@FETCH_STATUS = 0
BEGIN
SET @CrMFSalir = 0
DECLARE CrMovFlujo CURSOR FOR
SELECT DID, DModulo FROM MovFlujo WHERE OID = @CrID AND OModulo = @CrModulo
OPEN CrMovFlujo
FETCH NEXT FROM CrMovFlujo INTO @CrMFID, @CrMFModulo
WHILE @@FETCH_STATUS = 0 AND @CrMFSalir = 0
BEGIN
IF @CrMFModulo = 'TMA'
BEGIN
IF EXISTS(SELECT * FROM TMA WHERE ID = @CrMFID AND Estatus <> 'CANCELADO')
BEGIN
SET @CrMFSalir = 1
DELETE FROM @SurtidosXProcesar WHERE ID = @CrID
END
END
FETCH NEXT FROM CrMovFlujo INTO @CrMFID, @CrMFModulo
END
CLOSE CrMovFlujo
DEALLOCATE CrMovFlujo
FETCH NEXT FROM CrOrdenSurtido INTO @CrID, @CrModulo, @CrMov, @CrMovID
END
CLOSE CrOrdenSurtido
DEALLOCATE CrOrdenSurtido
SELECT * FROM @SurtidosXProcesar ORDER BY Articulo, ID
END

