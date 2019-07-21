SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPresupuestoVentaGral
@Ejercicio	INT

AS
BEGIN
DECLARE @ventas TABLE (
Grupo		VARCHAR(30),
CanalCte	VARCHAR(30),
Importe		MONEY,
Periodo		INT
)
DECLARE @presupuesto TABLE (
Grupo		VARCHAR(30),
CanalCte	VARCHAR(30),
Importe		MONEY,
Periodo		INT
)
INSERT INTO @ventas
SELECT a.grupo
,dbo.fn_CanalesCte(c.Categoria) AS 'CanalCte'
,SUM(v.Importe*v.TipoCambio) as 'Importe'
,v.Periodo
FROM Venta v
JOIN VentaD vd ON vd.ID=v.ID
JOIN Cte c ON c.Cliente=v.Cliente
RIGHT JOIN Art a ON a.Articulo=vd.Articulo
JOIN MovTipo mt ON mt.Mov=v.Mov
WHERE mt.Modulo='VTAS'
AND mt.Clave IN ('VTAS.F','VTAS.D')
AND v.Estatus='CONCLUIDO'
AND a.Grupo <> 'Servicios'
AND v.Ejercicio=@Ejercicio
GROUP BY a.Grupo,dbo.fn_CanalesCte(c.Categoria),v.Periodo
order by v.Periodo,a.Grupo,CanalCte
INSERT INTO @presupuesto
SELECT DISTINCT a.grupo,
dbo.fn_CanalesCte(c.Nombre) AS 'CanalCte'
,v.Importe as 'Importe'
,v.Periodo
FROM Venta v
JOIN VentaD vd ON vd.ID=v.ID
JOIN Cte c ON c.Cliente=v.Cliente
JOIN Art a ON a.Articulo=vd.Articulo
JOIN MovTipo mt ON mt.Mov=v.Mov
WHERE mt.Modulo='VTAS'
AND mt.Clave='VTAS.PR'
AND v.Estatus='CONCLUIDO'
AND v.Ejercicio=2016
order by v.Periodo,a.Grupo,CanalCte
SELECT ISNULL(v.Grupo,p.Grupo) as 'Grupo'
,ISNULL(v.CanalCte,p.CanalCte) as 'Grupo'
,ISNULL(p.Importe,0) AS 'ImportePresupuesto'
,ISNULL(v.Importe,0) AS 'ImporteVentas'
,ISNULL(v.Periodo,p.Periodo) as 'Periodo'
FROM @presupuesto p
FULL JOIN @ventas  v ON v.Grupo = p.Grupo AND v.Periodo = p.Periodo AND v.CanalCte=p.CanalCte
ORDER BY p.Periodo
END

