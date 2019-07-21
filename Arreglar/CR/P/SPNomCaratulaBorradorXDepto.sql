SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC SPNomCaratulaBorradorXDepto
@ID INT

AS BEGIN
DECLARE
@Concepto		varchar(50),
@Movi			varchar(20),
@Orden			int
CREATE TABLE #Conceptos(
Concepto		varchar(50) NULL,
Importe			money NULL,
ImportePercepciones	money NULL,
ImporteDeducciones	money NULL,
Nomina			int NULL,
Movimiento		varchar(50) NULL,
Mov			varchar(50) NULL,
Departamento		varchar(50) NULL,
FechaD			datetime NULL,
FechaA			datetime NULL,
Orden			int default 0)
INSERT INTO #Conceptos(Concepto, Importe, ImportePercepciones, ImporteDeducciones, Nomina, Movimiento, Mov, FechaD, FechaA, Departamento)
SELECT DISTINCT D.Concepto,
'Importe' = SUM(D.Importe),
'ImportePercepciones' = CASE WHEN D.Movimiento = 'PERCEPCION' THEN SUM(Importe) ELSE 0 END,
'ImporteDeducciones' = CASE WHEN D.Movimiento = 'DEDUCCION' THEN SUM(Importe) ELSE 0 END,
'NOMINA' = MAX (CASE WHEN Mov IN ('NOMINA','Finiquito','Liquidacion','Aguinaldo','PTU','Fondo de Ahorro') THEN MovID ELSE '' END),
D.Movimiento,
N.Mov,
N.FechaD,
N.FechaA,
P.Departamento
FROM Nomina N JOIN NominaD D ON N.ID=D.ID
JOIN Personal P ON D.Personal=P.Personal
WHERE D.Movimiento IN ('Percepcion','Deduccion')
AND N.ID=@ID
GROUP BY P.Departamento, D.Concepto, D.Movimiento, N.Estatus, D.Movimiento, N.FechaD, N.FechaA, N.Mov
ORDER BY P.Departamento, D.Movimiento desc, D.CONCEPTO
DECLARE crnom CURSOR FOR
SELECT t.Concepto, t.Mov, p.Orden
FROM #Conceptos t
JOIN NomXPersonal p	ON	p.Concepto	=	t.Concepto
JOIN NomX x		ON	X.ID		=	p.ID
AND	X.NomMov	=	t.Mov
OPEN crnom
FETCH NEXT FROM crnom INTO @Concepto, @Movi, @Orden
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
UPDATE #Conceptos SET Orden=@Orden WHERE Concepto=@Concepto AND Mov=@Movi
END
FETCH NEXT FROM crnom INTO @Concepto, @Movi, @Orden
END
CLOSE crnom
DEALLOCATE crnom
SELECT * FROM #Conceptos ORDER BY Departamento, Movimiento Desc, Orden
END

