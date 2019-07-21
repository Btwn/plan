SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPresupuestoVentaMarca
@Ejercicio	INT

AS
BEGIN
DECLARE @ventas TABLE (
Grupo		VARCHAR(30),
Importe		MONEY,
Periodo		INT
)
DECLARE @presupuesto TABLE (
Grupo		VARCHAR(30),
Importe		MONEY,
Periodo		INT
)
INSERT INTO @ventas
SELECT a.grupo
,SUM(CASE WHEN mt.clave = 'VTAS.D' THEN (vt.SubTotal*-1)*vt.TipoCambio ELSE (vt.SubTotal*vt.TipoCambio) END ) AS 'Importe'
,vt.Periodo
FROM VentaTCalc AS vt
JOIN MovTipo AS mt ON mt.Mov = vt.Mov
JOIN Art AS a ON a.Articulo = vt.Articulo
WHERE mt.Modulo='VTAS'
AND mt.Clave IN ('VTAS.F','VTAS.D')
AND vt.Estatus='CONCLUIDO'
AND vt.Ejercicio=@Ejercicio
GROUP BY a.Grupo,vt.Periodo
INSERT INTO @presupuesto
SELECT a.grupo
,SUM(vd.cantidad*vd.precio) as 'Importe'
,v.Periodo
FROM Venta v
JOIN VentaD vd ON vd.ID=v.ID
JOIN Art a ON a.Articulo=vd.Articulo
JOIN MovTipo mt ON mt.Mov=v.Mov
WHERE mt.Modulo='VTAS'
AND mt.Clave='VTAS.PR'
AND v.Estatus='CONCLUIDO'
AND v.Ejercicio=@Ejercicio
GROUP BY a.grupo,v.Periodo
order by v.Periodo,a.Grupo
SELECT DISTINCT ISNULL(v.Grupo,p.Grupo) AS 'Grupo'
,ISNULL(v.Importe,0) AS 'ImporteVtas'
,ISNULL(p.Importe,0) AS 'ImportePresupuesto'
,ISNULL(v.Periodo,p.Periodo) AS 'Periodo'
FROM @ventas v
FULL JOIN @presupuesto p ON p.Grupo = v.Grupo AND p.Periodo = v.Periodo
END

