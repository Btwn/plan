SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPresupuestoVentaCanales
@Ejercicio	INT

AS
BEGIN
DECLARE @ventas TABLE (
Grupo		VARCHAR(50),
CanalCte	VARCHAR(30),
Importe		MONEY,
Periodo		INT
)
DECLARE @presupuesto TABLE (
Grupo		VARCHAR(50),
CanalCte	VARCHAR(30),
Importe		MONEY,
Periodo		INT
)
DECLARE @presupuesto_tbl TABLE (
Grupo		VARCHAR(50),
CanalCte	VARCHAR(30),
Importe		MONEY,
Periodo		INT
)
INSERT INTO @ventas
SELECT a.grupo
,dbo.fn_CanalesCte(c.Categoria) AS 'CanalCte'
,SUM(CASE WHEN mt.clave='VTAS.D' THEN (vt.SubTotal*-1)*vt.TipoCambio ELSE (vt.SubTotal*vt.TipoCambio) END ) AS 'Importe'
,vt.Periodo
FROM VentaTCalc AS vt
JOIN MovTipo AS mt ON mt.Mov = vt.Mov
JOIN Art AS a ON a.Articulo = vt.Articulo
JOIN Cte c ON c.Cliente=vt.Cliente
WHERE mt.Modulo='VTAS'
AND mt.Clave IN ('VTAS.F','VTAS.D')
AND vt.Estatus='CONCLUIDO'
AND vt.Ejercicio=@Ejercicio
GROUP BY a.grupo,dbo.fn_CanalesCte(c.Categoria),vt.Periodo
INSERT INTO @presupuesto
SELECT a.grupo
,dbo.fn_CanalesCte(c.Categoria) AS 'CanalCte'
,vd.cantidad*vd.Precio as 'Importe'
,v.Periodo
FROM Venta AS v
JOIN VentaD vd ON v.ID = vd.ID
LEFT JOIN Art AS a ON a.Articulo = vd.Articulo
JOIN Cte c ON c.Cliente=v.Cliente
JOIN MovTipo mt ON mt.Mov=v.Mov
WHERE mt.Modulo='VTAS'
AND mt.Clave='VTAS.PR'
AND v.Estatus='CONCLUIDO'
AND v.Ejercicio=@Ejercicio
order by v.Periodo,CanalCte;
WITH presup_tbl
AS
(
SELECT distinct a.grupo
,dbo.fn_CanalesCte(c.Categoria) AS 'CanalCte'
,v.Periodo
FROM Venta AS v
JOIN VentaD vd ON v.ID = vd.ID
LEFT JOIN Art AS a ON a.Articulo = vd.Articulo
JOIN Cte c ON c.Cliente=v.Cliente
JOIN MovTipo mt ON mt.Mov=v.Mov
WHERE mt.Modulo='VTAS'
AND mt.Clave='VTAS.PR'
AND v.Estatus='CONCLUIDO'
AND v.Ejercicio=@Ejercicio
)
INSERT INTO @presupuesto_tbl
SELECT DISTINCT pt.grupo
,ISNULL(p.CanalCte,pt.CanalCte)
,ISNULL(p.Importe,0)
,ISNULL(p.Periodo,pt.Periodo)
FROM presup_tbl AS pt
LEFT JOIN @presupuesto AS p ON p.grupo = pt.grupo
SELECT DISTINCT ISNULL(pt.Grupo,v.grupo) as 'Grupo'
,ISNULL(pt.CanalCte,v.CanalCte) as 'CanalCte'
,ISNULL(v.Importe,0) AS 'ImporteVentas'
,ISNULL(pt.Importe,0) AS 'ImportePresupuesto'
,ISNULL(pt.Periodo,v.Periodo) as 'Periodo'
FROM @presupuesto_tbl AS pt
FULL JOIN @ventas V ON pt.Periodo = V.Periodo AND pt.Grupo = V.Grupo AND pt.CanalCte = V.CanalCte
ORDER BY CanalCte,Periodo
END

