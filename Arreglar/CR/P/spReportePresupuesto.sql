SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spReportePresupuesto
@periodo	INT,
@ejercicio	INT

AS BEGIN
DECLARE @Gastos_tbl TABLE (
Concepto	VARCHAR(100),
Importe		MONEY,
Ejercido1	MONEY,
Pendiente	MONEY,
Periodo		INT,
Indicador	VARCHAR(20)
)
DECLARE @fechaa DATETIME =(SELECT MAX(Fecha) FROM Tiempo WHERE Mes=@periodo AND Anio=@Ejercicio),
@fechad DATETIME=(SELECT MIN(Fecha) FROM Tiempo  WHERE Mes=@periodo AND Anio=@Ejercicio);
INSERT INTO @Gastos_tbl
Select DISTINCT b.Concepto
,CASE
WHEN mt.Clave IN ('GAS.PR') THEN SUM(b.Importe*a.tipocambio)
WHEN mt.Clave IN ('GAS.DG') THEN SUM(b.Importe*a.tipocambio)
WHEN mt.Clave IN ('GAS.G') THEN 0
END AS 'Importe'
, ISNULL(dbo.fnCalcPrepEjercido(a.Empresa,b.concepto,@Fechad,@Fechaa,'Ejercido'),0) as 'Ejercido1'
, ISNULL(dbo.fnCalcPrepEjercido(a.Empresa,b.concepto,@Fechad,@Fechaa,'Pendiente'),0) as 'Pendiente'
,a.Periodo
,mt.Clave
From Gasto a
JOIN  gastod b  ON a.id=b.id
JOIN MovTipo mt ON mt.Mov=a.Mov
Where  mt.Modulo='GAS'
AND mt.Clave IN ('GAS.PR','GAS.G','GAS.DG')
AND a.estatus='CONCLUIDO'
AND a.Ejercicio=@ejercicio
AND a.Periodo=@periodo
Group by b.concepto,a.Empresa,a.periodo,mt.Clave;
WITH contabilidad_tbl
AS
(
SELECT c.Concepto,SUM(c.Haber) AS 'Haber'
FROM ContAux c
WHERE c.Ejercicio=@ejercicio
AND c.Periodo=@periodo
AND c.Concepto IS NOT NULL
AND c.Referencia LIKE 'Gasto%'
GROUP BY c.Concepto
)
SELECT DISTINCT gt.Concepto,SUM(gt.Importe) AS 'Importe',ISNULL(gt.Ejercido1,0) AS 'Ejercido1',gt.Pendiente,gt.Periodo
FROM @Gastos_tbl AS gt
LEFT JOIN contabilidad_tbl AS ct ON ct.Concepto = gt.Concepto
GROUP BY gt.Concepto,gt.Pendiente,gt.Periodo,gt.Ejercido1,ct.Haber
END

