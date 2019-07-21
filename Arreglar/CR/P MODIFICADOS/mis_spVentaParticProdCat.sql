SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE mis_spVentaParticProdCat
@Fecha		DateTime,
@ArticuloD	char(20),
@ArticuloA	char(20),
@Categoria	varchar(50),
@Empresa	char(5)

AS BEGIN
DECLARE
@Ejercicio		int,
@EjercicioAnt	int,
@FechaAnt		datetime,
@DiaAct		int,
@DiaAnt		int,
@MesAct		int,
@MesAnt		int,
@AnoAct		int,
@AnoAnt		int
SELECT @Ejercicio = YEAR(@Fecha)
SELECT @FechaAnt = @Fecha - 365
SELECT @EjercicioAnt = @Ejercicio - 1
SELECT @DiaAct = DAY(@Fecha)
SELECT @DiaAnt = DAY(@FechaAnt)
SELECT @MesAct = MONTH(@Fecha)
SELECT @MesAnt = MONTH(@FechaAnt)
SELECT @AnoAct = YEAR(@Fecha)
SELECT @AnoAnt = YEAR(@FechaAnt)
CREATE TABLE #ParticipaCat
(
Categoriax		char(50)	COLLATE Database_Default NULL,
Articulox		varchar(20)	COLLATE Database_Default NULL,
SubCuentax		char(10)	COLLATE Database_Default NULL,
Cantid1		float(8)	NULL,
Import1		money		NULL,
SumaCan1		float(8)	NULL,
Cantid2		float(8)	NULL,
Import2		money		NULL,
Costo2		money		NULL,
Util2		money		NULL,
SumaCan2		float(8)	NULL,
SumaUtil2		money		NULL,
Cantid3		float(8)	NULL,
Import3		money		NULL,
SumaCan3		float(8)	NULL,
Cantid4		float(8)	NULL,
Import4		money		NULL,
SumaCan4		float(8)	NULL,
SumaTot1		float(8)	NULL,
SumaTot2		float(8)  	NULL,
SumaTot3		float(8)  	NULL,
SumaTot4           float(8)	NULL
)
SELECT Articulo, SubCuenta,
Categoria
INTO #Arti
FROM mis_VentaUtilX WITH(NOLOCK)
WHERE mis_VentaUtilX.MovClave IN('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.B', 'VTAS.EST')
AND ((mis_VentaUtilX.Ejercicio = @EjercicioAnt
AND mis_VentaUtilX.FechaEmision <= @FechaAnt)
OR (mis_VentaUtilX.Ejercicio = @Ejercicio
AND mis_VentaUtilX.FechaEmision <= @Fecha))
AND ISNULL(Categoria, '')  = CASE @Categoria  WHEN 'NULL' THEN ISNULL(Categoria, '')  ELSE @Categoria  END
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Empresa = @Empresa
GROUP BY Categoria, Articulo, Subcuenta
ORDER BY Categoria, Articulo, Subcuenta
SELECT Articulo, Subcuenta, Categoria,
'Cantid1' = SUM(CantidadFactor),
'Import1' = SUM(ImporteX)
INTO #AAct
FROM mis_VentaUtilX WITH(NOLOCK)
WHERE YEAR(FechaEmision) = @AnoAct
AND MONTH(FechaEmision) = @MesAct
AND DAY(FechaEmision) <= @DiaAct
AND MovClave IN('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.B', 'VTAS.EST')
AND ISNULL(Categoria, '')  = CASE @Categoria  WHEN 'NULL' THEN ISNULL(Categoria, '')  ELSE @Categoria  END
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Empresa = @Empresa
GROUP BY Articulo, Subcuenta, Categoria
ORDER BY Articulo, Subcuenta, Categoria
SELECT Categoria, Articulo,
'SumaCan1' = SUM(CantidadFactor)
INTO #BAct
FROM mis_VentaUtilX WITH(NOLOCK)
WHERE YEAR(FechaEmision) = @AnoAct
AND MONTH(FechaEmision) = @MesAct
AND DAY(FechaEmision) <= @DiaAct
AND MovClave IN('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.B', 'VTAS.EST')
AND ISNULL(Categoria, '') = CASE @Categoria WHEN 'NULL' THEN ISNULL(Categoria, '') ELSE @Categoria END
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Empresa = @Empresa
GROUP BY Categoria, Articulo
ORDER BY Categoria, Articulo
SELECT Categoria,
'SumaTot1' = SUM(CantidadFactor)
INTO #ZAct
FROM mis_VentaUtilX WITH(NOLOCK)
WHERE YEAR(FechaEmision) = @AnoAct
AND MONTH(FechaEmision) = @MesAct
AND DAY(FechaEmision) <= @DiaAct
AND MovClave IN('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.B', 'VTAS.EST')
AND ISNULL(Categoria, '') = CASE @Categoria WHEN 'NULL' THEN ISNULL(Categoria, '') ELSE @Categoria END
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Empresa = @Empresa
GROUP BY Categoria
ORDER BY Categoria
SELECT a.Categoria, a.Articulo, a.Subcuenta, a.Cantid1, a.Import1, b.SumaCan1, c.SumaTot1
INTO #CAct
FROM #AAct a
LEFT OUTER JOIN #BAct b ON a.Articulo = b.Articulo AND ISNULL(a.Categoria, '') = ISNULL(b.Categoria, '')
LEFT OUTER JOIN #ZAct c ON ISNULL(a.Categoria, '') = ISNULL(c.Categoria, '')
SELECT Categoria,
Articulo, Subcuenta,
'Cantid2' = SUM(CantidadFactor),
'Import2' = SUM(ImporteX),
'Costo2'  = SUM(CostoTotal),
'Util2'   = SUM(ImporteX - CostoTotal)
INTO #AActAcum
FROM mis_VentaUtilX WITH(NOLOCK)
WHERE YEAR(FechaEmision) = @AnoAct
AND FechaEmision <= @Fecha
AND MovClave IN('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.B', 'VTAS.EST')
AND ISNULL(Categoria, '') = CASE @Categoria WHEN 'NULL' THEN ISNULL(Categoria, '') ELSE @Categoria END
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Empresa = @Empresa
GROUP BY Categoria, Articulo, Subcuenta
ORDER BY Categoria, Articulo, Subcuenta
SELECT Categoria, Articulo,
'SumaCan2'  = SUM(CantidadFactor),
'SumaUtil2' = SUM(ImporteX - CostoTotal)
INTO #BActAcum
FROM mis_VentaUtilX WITH(NOLOCK)
WHERE YEAR(FechaEmision) = @AnoAct
AND FechaEmision <= @Fecha
AND MovClave IN('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.B', 'VTAS.EST')
AND ISNULL(Categoria, '') = CASE @Categoria WHEN 'NULL' THEN ISNULL(Categoria, '') ELSE @Categoria END
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Empresa = @Empresa
GROUP BY Categoria, Articulo
ORDER BY Categoria, Articulo
SELECT Categoria,
'SumaTot2' = SUM(CantidadFactor)
INTO #ZActAcum
FROM mis_VentaUtilX WITH(NOLOCK)
WHERE YEAR(FechaEmision) = @AnoAct
AND FechaEmision <= @Fecha
AND MovClave IN('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.B', 'VTAS.EST')
AND ISNULL(Categoria, '') = CASE @Categoria WHEN 'NULL' THEN ISNULL(Categoria, '') ELSE @Categoria END
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Empresa = @Empresa
GROUP BY Categoria
ORDER BY Categoria
SELECT a.Categoria, a.Articulo, a.Subcuenta, Cantid2, Import2, Costo2, Util2, SumaCan2, SumaUtil2, SumaTot2
INTO #CActAcum
FROM #AActAcum a
LEFT OUTER JOIN #BActAcum b ON a.Articulo = b.Articulo AND ISNULL(a.Categoria, '') = ISNULL(b.Categoria, '')
LEFT OUTER JOIN #ZActAcum c ON ISNULL(a.Categoria, '') = ISNULL(c.Categoria, '')
SELECT Categoria,
Articulo, Subcuenta,
'Cantid3' = SUM(CantidadFactor),
'Import3' = SUM(ImporteX)
INTO #AAnt
FROM mis_VentaUtilX WITH(NOLOCK)
WHERE YEAR(FechaEmision) = @AnoAnt
AND MONTH(FechaEmision) = @MesAnt
AND DAY(FechaEmision) <= @DiaAnt
AND MovClave IN('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.B', 'VTAS.EST')
AND ISNULL(Categoria, '') = CASE @Categoria WHEN 'NULL' THEN ISNULL(Categoria, '') ELSE @Categoria END
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Empresa = @Empresa
GROUP BY Categoria, Articulo, Subcuenta
ORDER BY Categoria, Articulo, Subcuenta
SELECT Categoria, Articulo,
'SumaCan3' = SUM(CantidadFactor)
INTO #BAnt
FROM mis_VentaUtilX WITH(NOLOCK)
WHERE YEAR(FechaEmision) = @AnoAnt
AND MONTH(FechaEmision) = @MesAnt
AND DAY(FechaEmision) <= @DiaAnt
AND MovClave IN('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.B', 'VTAS.EST')
AND ISNULL(Categoria, '') = CASE @Categoria WHEN 'NULL' THEN ISNULL(Categoria, '') ELSE @Categoria END
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Empresa = @Empresa
GROUP BY Categoria, Articulo
ORDER BY Categoria, Articulo
SELECT Categoria,
'SumaTot3' = SUM(CantidadFactor)
INTO #ZAnt
FROM mis_VentaUtilX WITH(NOLOCK)
WHERE YEAR(FechaEmision) = @AnoAnt
AND MONTH(FechaEmision) = @MesAnt
AND DAY(FechaEmision) <= @DiaAnt
AND MovClave IN('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.B', 'VTAS.EST')
AND ISNULL(Categoria, '') = CASE @Categoria WHEN 'NULL' THEN ISNULL(Categoria, '') ELSE @Categoria END
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Empresa = @Empresa
GROUP BY Categoria
ORDER BY Categoria
SELECT a.Categoria, a.Articulo, a.Subcuenta, Cantid3, Import3, SumaCan3, SumaTot3
INTO #CAnt
FROM #AAnt a
LEFT OUTER JOIN #BAnt b ON a.Articulo = b.Articulo AND ISNULL(a.Categoria, '') = ISNULL(b.Categoria, '')
LEFT OUTER JOIN #ZAnt c ON ISNULL(a.Categoria, '') = ISNULL(c.Categoria, '')
SELECT Categoria,
Articulo, Subcuenta,
'Cantid4' = Sum(CantidadFactor),
'Import4' = SUM(ImporteX)
INTO #AAntAcum
FROM mis_VentaUtilX WITH(NOLOCK)
WHERE YEAR(FechaEmision) = @AnoAnt
AND FechaEmision <= @FechaAnt
AND MovClave IN('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.B', 'VTAS.EST')
AND ISNULL(Categoria, '') = CASE @Categoria WHEN 'NULL' THEN ISNULL(Categoria, '') ELSE @Categoria END
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Empresa = @Empresa
GROUP BY Categoria, Articulo, Subcuenta
ORDER BY Categoria, Articulo, Subcuenta
SELECT Categoria, Articulo,
'SumaCan4' = SUM(CantidadFactor)
INTO #BAntAcum
FROM mis_VentaUtilX WITH(NOLOCK)
WHERE YEAR(FechaEmision) = @AnoAnt
AND FechaEmision <= @FechaAnt
AND MovClave IN('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.B', 'VTAS.EST')
AND ISNULL(Categoria, '') = CASE @Categoria WHEN 'NULL' THEN ISNULL(Categoria, '') ELSE @Categoria END
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Empresa = @Empresa
GROUP BY Categoria, Articulo
ORDER BY Categoria, Articulo
SELECT Categoria,
'SumaTot4' = SUM(CantidadFactor)
INTO #ZAntAcum
FROM mis_VentaUtilX WITH(NOLOCK)
WHERE YEAR(FechaEmision) = @AnoAnt
AND FechaEmision <= @FechaAnt
AND MovClave IN('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.B', 'VTAS.EST')
AND ISNULL(Categoria, '') = CASE @Categoria WHEN 'NULL' THEN ISNULL(Categoria, '') ELSE @Categoria END
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Empresa = @Empresa
GROUP BY Categoria
ORDER BY Categoria
SELECT a.Categoria, a.Articulo, a.Subcuenta, Cantid4, Import4, SumaCan4, SumaTot4
INTO #CAntAcum
FROM #AAntAcum a
LEFT OUTER JOIN #BAntAcum b ON a.Articulo = b.Articulo AND ISNULL(a.Categoria, '') = ISNULL(b.Categoria, '')
LEFT OUTER JOIN #ZAntAcum c ON ISNULL(a.Categoria, '') = ISNULL(c.Categoria, '')
INSERT #ParticipaCat
SELECT Categoria, Articulo, Subcuenta, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
NULL, NULL, NULL
FROM #Arti
UPDATE #ParticipaCat
SET Cantid1 = a.Cantid1 , Import1 = a.Import1, SumaCan1 = a.SumaCan1, SumaTot1 = a.SumaTot1
FROM #ParticipaCat x
LEFT OUTER JOIN #CAct a ON ISNULL(x.Categoriax, '') = ISNULL(a.Categoria, '')
AND x.Articulox = a.Articulo
AND x.SubCuentax = a.SubCuenta
UPDATE #ParticipaCat
SET Cantid1 = a.Cantid1 , Import1 = a.Import1, SumaCan1 = a.SumaCan1, SumaTot1 = a.SumaTot1
FROM #ParticipaCat x
RIGHT OUTER JOIN #CAct a ON ISNULL(x.Categoriax, '') = ISNULL(a.Categoria, '')
AND x.Articulox = a.Articulo
AND ISNULL(x.Subcuentax,'') = ''
UPDATE #ParticipaCat
SET Cantid2 = a.Cantid2, Import2 = a.Import2, Costo2 = a.Costo2, Util2 = a.Util2, SumaCan2 = a.SumaCan2, SumaTot2 = a.SumaTot2
FROM #ParticipaCat x
LEFT OUTER JOIN #CActAcum a ON ISNULL(x.Categoriax, '') = ISNULL(a.Categoria, '')
AND x.Articulox = a.Articulo
AND x.SubCuentax = a.SubCuenta
UPDATE #ParticipaCat
SET Cantid2 = a.Cantid2, Import2 = a.Import2, Costo2 = a.Costo2, Util2 = a.Util2, SumaCan2 = a.SumaCan2, SumaTot2 = a.SumaTot2
FROM #ParticipaCat x
RIGHT OUTER JOIN #CActAcum a ON ISNULL(x.Categoriax, '') = ISNULL(a.Categoria, '')
AND x.Articulox = a.Articulo
AND ISNULL(x.Subcuentax,'') = ''
UPDATE #ParticipaCat
SET Cantid3 = a.Cantid3 , Import3 = a.Import3, SumaCan3 = a.SumaCan3, SumaTot3 = a.SumaTot3
FROM #ParticipaCat x
LEFT OUTER JOIN #CAnt a ON ISNULL(x.Categoriax, '') = ISNULL(a.Categoria, '')
AND x.Articulox = a.Articulo
AND x.SubCuentax = a.SubCuenta
UPDATE #ParticipaCat
SET Cantid3 = a.Cantid3 , Import3 = a.Import3, SumaCan3 = a.SumaCan3, SumaTot3 = a.SumaTot3
FROM #ParticipaCat x
RIGHT OUTER JOIN #CAnt a ON ISNULL(x.Categoriax, '') = ISNULL(a.Categoria, '')
AND x.Articulox = a.Articulo
AND ISNULL(x.Subcuentax,'') = ''
UPDATE #ParticipaCat
SET Cantid4 = a.Cantid4 , Import4 = a.Import4, SumaCan4 = a.SumaCan4, SumaTot4 = a.SumaTot4
FROM #ParticipaCat x
LEFT OUTER JOIN #CAntAcum a ON ISNULL(x.Categoriax, '') = ISNULL(a.Categoria, '')
AND x.Articulox = a.Articulo
AND x.SubCuentax = a.SubCuenta
UPDATE #ParticipaCat
SET Cantid4 = a.Cantid4 , Import4 = a.Import4, SumaCan4 = a.SumaCan4, SumaTot4 = a.SumaTot4
FROM #ParticipaCat x
RIGHT OUTER JOIN #CAntAcum a ON ISNULL(x.Categoriax, '') = ISNULL(a.Categoria, '')
AND x.Articulox = a.Articulo
AND ISNULL(x.Subcuentax,'') = ''
SELECT * FROM #ParticipaCat
ORDER BY Categoriax, Articulox, SubCuentax
END

