SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPresupuestoVentaCanal
@Ejercicio	INT

AS
BEGIN
DECLARE @ventas TABLE (
CanalCte	VARCHAR(30),
Importe		MONEY,
Periodo		INT
)
DECLARE @presupuesto TABLE (
CanalCte	VARCHAR(30),
Importe		MONEY,
Periodo		INT
)
INSERT INTO @ventas
SELECT dbo.fn_CanalesCte(c.Categoria) AS 'CanalCte'
,SUM(CASE WHEN mt.clave = 'VTAS.D' THEN (vt.SubTotal*-1)*vt.TipoCambio ELSE (vt.SubTotal*vt.TipoCambio) END ) AS 'Importe'
,vt.Periodo
FROM VentaTCalc AS vt
JOIN MovTipo AS mt ON mt.Mov = vt.Mov
JOIN Art AS a ON a.Articulo = vt.Articulo
JOIN Cte c ON c.Cliente=vt.Cliente
WHERE mt.Modulo='VTAS'
AND mt.Clave IN ('VTAS.F','VTAS.D')
AND vt.Estatus='CONCLUIDO'
AND vt.Ejercicio=@Ejercicio
GROUP BY dbo.fn_CanalesCte(c.Categoria),vt.Periodo
INSERT INTO @presupuesto
SELECT DISTINCT dbo.fn_CanalesCte(c.Categoria) AS 'CanalCte'
,v.Importe as 'Importe'
,v.Periodo
FROM Venta v
JOIN VentaD vd ON vd.ID=v.ID
JOIN Cte c ON c.Cliente=v.Cliente
JOIN MovTipo mt ON mt.Mov=v.Mov
WHERE mt.Modulo='VTAS'
AND mt.Clave='VTAS.PR'
AND v.Estatus='CONCLUIDO'
AND v.Ejercicio=@Ejercicio
order by v.Periodo,CanalCte
SELECT DISTINCT ISNULL(p.CanalCte,v.CanalCte) as 'CanalCte'
,ISNULL(P.Importe,0) as 'ImportePresupuesto'
,ISNULL(v.Importe,0) as 'ImporteVtas'
,ISNULL(v.Periodo,p.Periodo) as 'Periodo'
FROM @presupuesto P
FULL JOIN @ventas v ON v.CanalCte=p.CanalCte AND v.Periodo=p.Periodo
ORDER BY Periodo
END

