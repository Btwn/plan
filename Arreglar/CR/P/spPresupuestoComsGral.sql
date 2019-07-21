SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPresupuestoComsGral
@Ejercicio	INT

AS
BEGIN
DECLARE @compras TABLE (
Articulo	VARCHAR(30),
Grupo		VARCHAR(30),
Importe		MONEY,
Periodo		INT
)
DECLARE @OrdenCompra_tbl TABLE(
MovID		INT,
Grupo		VARCHAR(30),
Articulo	VARCHAR(30),
Importe		MONEY,
Periodo		INT
)
DECLARE @CompraPerdida_tbl TABLE(
MovID		INT,
Articulo	VARCHAR(30),
Importe		MONEY
)
DECLARE @presupuesto TABLE (
Grupo		VARCHAR(30),
Importe		MONEY,
Periodo		INT
)
INSERT INTO @OrdenCompra_tbl
SELECT c.MovID
,a.Grupo
,cd.Articulo
,cd.Cantidad*(cd.costo*c.TipoCambio) AS 'Importe'
,c.Periodo
FROM Compra c
JOIN CompraD cd ON cd.ID=c.ID
RIGHT JOIN Art a ON a.Articulo=cd.Articulo
JOIN MovTipo mt ON mt.Mov=c.Mov
WHERE mt.Modulo='COMS'
AND mt.Orden=25
AND c.Estatus IN ('CONCLUIDO','PENDIENTE')
AND c.Ejercicio=@Ejercicio
order by c.MovID,c.periodo,a.Grupo
INSERT INTO @CompraPerdida_tbl
SELECT c.OrigenID
,cd.Articulo
,(cd.Cantidad*(cd.Costo*c.TipoCambio)) as 'Importe'
FROM Compra c
JOIN CompraD cd ON cd.ID=C.ID
JOIN Art a ON a.Articulo=cd.Articulo
JOIN MovTipo mt ON c.Mov=mt.Mov
WHERE mt.Modulo='COMS'
AND mt.Clave='COMS.CP'
AND c.Origen='Orden Compra'
AND c.Estatus='CONCLUIDO'
and c.Ejercicio=@Ejercicio
INSERT INTO @compras
SELECT oc.Articulo
,oc.Grupo
,ISNULL(oc.Importe,0)-ISNULL(cp.Importe,0) as 'TotalNeto'
,oc.Periodo
FROM @OrdenCompra_tbl oc
LEFT JOIN @CompraPerdida_tbl cp ON oc.MovID=cp.MovID AND oc.Articulo=cp.Articulo
INSERT INTO @presupuesto
SELECT a.Grupo
,SUM(cd.cantidad*cd.costo) AS 'Importe'
,c.Periodo
FROM Compra c
JOIN CompraD AS cd ON cd.ID=c.ID
JOIN Art a ON a.Articulo=cd.Articulo
JOIN MovTipo mt ON mt.Mov=c.Mov
WHERE mt.Modulo='COMS'
AND mt.Clave='COMS.PR'
AND c.Estatus='CONCLUIDO'
AND c.Ejercicio=@Ejercicio
GROUP BY a.Grupo,c.Periodo
order by a.Grupo,c.Periodo
SELECT ISNULL(p.Grupo,c.Grupo) AS 'Grupo'
,ISNULL(p.Importe,0) AS 'ImportePresupuesto'
,ISNULL(SUM(c.Importe),0) AS 'ImporteCompras'
,ISNULL(p.Periodo,c.Periodo) AS 'Periodo'
FROM @presupuesto p
FULL JOIN @compras c ON c.Grupo = p.Grupo AND c.Periodo = p.Periodo
GROUP BY P.Grupo,p.Importe,p.Periodo,c.Grupo,c.Importe,c.Periodo
ORDER BY p.Periodo
END

