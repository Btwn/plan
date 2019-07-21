SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC SPNomCaratulaBorrador
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
ImportePorPagar		money NULL,
Nomina			varchar NULL,
MovID			varchar (20)NULL,
Sucursal		int Null,
PeriodoTipo	    varchar(10) NULL,
Movimiento		varchar(50) NULL,
Mov			varchar(50) NULL,
Ejercicio		int NULL,
FechaD			datetime NULL,
FechaA			datetime NULL,
Orden			int default 0)
INSERT INTO #Conceptos(Concepto, Importe, ImportePercepciones, ImporteDeducciones, ImportePorPagar, Nomina, MovID, Sucursal, PeriodoTipo, Movimiento, Mov, Ejercicio, FechaD, FechaA)
SELECT	distinct D.Concepto,
'Importe'=SUM(D.Importe),
'ImportePercepciones'= CASE WHEN D.MOVIMIENTO='PERCEPCION' THEN SUM(IMPORTE) ELSE 0 END,
'ImporteDeducciones'= CASE WHEN D.MOVIMIENTO='DEDUCCION' THEN SUM(IMPORTE) ELSE 0 END,
'ImportePorPagar'= CASE WHEN D.MOVIMIENTO='Por Pagar' THEN SUM(IMPORTE) ELSE 0 END,
'NOMINA'=MAX (CASE WHEN MOV IN ('NOMINA','Finiquito','Liquidacion','Aguinaldo','PTU','Fondo Ahorro') THEN MOVID ELSE '' END),
N.MovID,
N.Sucursal,
N.PeriodoTipo,
D.Movimiento,
N.Mov,
N.Ejercicio,
N.FechaD,
N.FechaA
FROM NominaD D LEFT OUTER JOIN Nomina N on D.ID=N.ID
WHERE	D.Movimiento IN ('Percepcion','Deduccion','por Pagar')
AND	N.ID=@ID
GROUP BY D.Concepto, N.Estatus, N.Ejercicio,N.MovID,  N.Sucursal, N.PeriodoTipo, D.Movimiento, N.FechaD, N.FechaA, N.Mov
ORDER BY  D.Movimiento desc, D.CONCEPTO
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
SELECT * FROM #Conceptos ORDER BY Movimiento Desc, Orden
END

