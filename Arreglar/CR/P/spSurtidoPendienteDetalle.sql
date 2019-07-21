SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSurtidoPendienteDetalle
@Estacion			int,
@Empresa			varchar(5),
@Artículo			varchar(20)

AS
BEGIN
DECLARE
@crModulo	varchar(5)	,
@crClave	varchar(20)	,
@crSubClave	varchar(20)
DECLARE @SurtidoPendienteD as Table(Mov			varchar(20),
MovID		varchar(20),
Estatus		varchar(15),
Almacen		varchar(10),
Articulo	varchar(20),
Tarima		varchar(20),
Cantidad	float)
DECLARE CrModuloMov CURSOR FOR
SELECT Modulo, Clave, Subclave FROM WMSModuloMovimiento
OPEN CrModuloMov
FETCH NEXT FROM CrModuloMov INTO @crModulo, @crClave, @crSubClave
WHILE @@FETCH_STATUS = 0
BEGIN
IF @crModulo = 'COMS'
INSERT @SurtidoPendienteD(Mov, MovID, Estatus, Almacen,
Articulo, Tarima, Cantidad)
SELECT ISNULL(D.Mov,A.Mov) Mov, ISNULL(D.MovID,A.MovID) MovID, ISNULL(D.Estatus,A.Estatus) Estatus, ISNULL(C.Almacen, E.Almacen) Almacen,
ISNULL(E.Articulo, C.Articulo) Articulo, ISNULL(E.Tarima, C.Tarima) Tarima, ISNULL(E.CantidadPendiente, C.CantidadTarima) Cantidad
FROM Compra A
JOIN MovTipo B
ON B.Modulo = @crModulo
AND A.Mov = B.Mov
AND B.Clave = @crClave
AND ISNULL(B.SubClave,'') = ISNULL(@crSubClave,'')
LEFT JOIN WMSSurtidoProcesarD C
ON C.Modulo = B.Modulo
AND C.ModuloID = A.ID
AND C.Procesado = 0
LEFT JOIN TMA D
ON D.OrigenTipo = B.Modulo
AND D.Origen = A.Mov
AND D.OrigenID = A.MovID
AND D.Estatus IN ('PENDIENTE')
LEFT JOIN TMAD E
ON E.ID = D.ID
WHERE ISNULL(C.Articulo, E.Articulo) = @Artículo
AND A.Empresa = @Empresa
IF @crModulo = 'INV'
INSERT @SurtidoPendienteD(Mov, MovID, Estatus, Almacen,
Articulo, Tarima, Cantidad)
SELECT ISNULL(D.Mov,A.Mov) Mov, ISNULL(D.MovID,A.MovID) MovID, ISNULL(D.Estatus,A.Estatus) Estatus, ISNULL(C.Almacen, E.Almacen) Almacen,
ISNULL(C.Articulo, E.Articulo) Articulo, ISNULL(C.Tarima, E.Tarima) Tarima, ISNULL(C.CantidadTarima, E.CantidadPendiente) Cantidad
FROM INV A
JOIN MovTipo B
ON B.Modulo = @crModulo
AND A.Mov = B.Mov
AND B.Clave = @crClave
AND ISNULL(B.SubClave,'') = ISNULL(@crSubClave,'')
LEFT JOIN WMSSurtidoProcesarD C
ON C.Modulo = B.Modulo
AND C.ModuloID = A.ID
AND C.Estacion = @Estacion
AND C.Procesado = 0
LEFT JOIN TMA D
ON D.OrigenTipo = B.Modulo
AND D.Origen = A.Mov
AND D.OrigenID = A.MovID
AND D.Estatus IN ('PENDIENTE')
LEFT JOIN TMAD E
ON E.ID = D.ID
WHERE ISNULL(C.Articulo, E.Articulo) = @Artículo
AND A.Empresa = @Empresa
IF @crModulo = 'VTAS'
INSERT @SurtidoPendienteD(Mov, MovID, Estatus, Almacen,
Articulo, Tarima, Cantidad)
SELECT ISNULL(D.Mov,A.Mov) Mov, ISNULL(D.MovID,A.MovID) MovID, ISNULL(D.Estatus,A.Estatus) Estatus, ISNULL(C.Almacen, E.Almacen) Almacen,
ISNULL(C.Articulo, E.Articulo) Articulo, ISNULL(C.Tarima, E.Tarima) Tarima, ISNULL(C.CantidadTarima, E.CantidadPendiente) Cantidad
FROM Venta A
JOIN MovTipo B
ON B.Modulo = @crModulo
AND A.Mov = B.Mov
AND B.Clave = @crClave
AND ISNULL(B.SubClave,'') = ISNULL(@crSubClave,'')
LEFT JOIN WMSSurtidoProcesarD C
ON C.Modulo = B.Modulo
AND C.ModuloID = A.ID
AND C.Estacion = @Estacion
AND C.Procesado = 0
LEFT JOIN TMA D
ON D.OrigenTipo = B.Modulo
AND D.Origen = A.Mov
AND D.OrigenID = A.MovID
AND D.Estatus IN ('PENDIENTE')
LEFT JOIN TMAD E
ON E.ID = D.ID
WHERE ISNULL(C.Articulo, E.Articulo) = @Artículo
AND A.Empresa = @Empresa
FETCH NEXT FROM CrModuloMov INTO @crModulo, @crClave, @crSubClave
END
CLOSE CrModuloMov
DEALLOCATE CrModuloMov
SELECT * FROM @SurtidoPendienteD
END

