SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE mis_spVentaParticProdGrupo
@Fecha		DateTime,
@ArticuloD	char(20),
@ArticuloA	char(20),
@Grupo		varchar(50),
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
CREATE TABLE #ParticipaGrupo
(
Grupox		char(50)	COLLATE Database_Default NULL,
Articulox		varchar(20)	COLLATE Database_Default NULL,
SubCuentax		varchar(50)	COLLATE Database_Default NULL,
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
Grupo
INTO #Arti
FROM mis_VentaUtilX WITH(NOLOCK)
WHERE mis_VentaUtilX.MovClave IN('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.B', 'VTAS.EST')
AND ((mis_VentaUtilX.Ejercicio = @EjercicioAnt
AND mis_VentaUtilX.FechaEmision <= @FechaAnt)
OR (mis_VentaUtilX.Ejercicio = @Ejercicio
AND mis_VentaUtilX.FechaEmision <= @Fecha))
AND ISNULL(Grupo, '')  = CASE @Grupo  WHEN 'NULL' THEN ISNULL(Grupo, '')  ELSE @Grupo  END
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Empresa = @Empresa
GROUP BY Grupo, Articulo, SubCuenta
ORDER BY Grupo, Articulo, SubCuenta
SELECT Articulo, SubCuenta, Grupo,
'Cantid1' = SUM(CantidadFactor),
'Import1' = SUM(ImporteX)
INTO #AAct
FROM mis_VentaUtilX WITH(NOLOCK)
WHERE YEAR(FechaEmision) = @AnoAct
AND MONTH(FechaEmision) = @MesAct
AND DAY(FechaEmision) <= @DiaAct
AND MovClave IN('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.B', 'VTAS.EST')
AND ISNULL(Grupo, '')  = CASE @Grupo  WHEN 'NULL' THEN ISNULL(Grupo, '')  ELSE @Grupo  END
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Empresa = @Empresa
GROUP BY Articulo, SubCuenta, Grupo
ORDER BY Articulo, SubCuenta, Grupo
SELECT Grupo, Articulo,
'SumaCan1' = SUM(CantidadFactor)
INTO #BAct
FROM mis_VentaUtilX WITH(NOLOCK)
WHERE YEAR(FechaEmision) = @AnoAct
AND MONTH(FechaEmision) = @MesAct
AND DAY(FechaEmision) <= @DiaAct
AND MovClave IN('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.B', 'VTAS.EST')
AND ISNULL(Grupo, '') = CASE @Grupo WHEN 'NULL' THEN ISNULL(Grupo, '') ELSE @Grupo END
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Empresa = @Empresa
GROUP BY Grupo, Articulo
ORDER BY Grupo, Articulo
SELECT Grupo,
'SumaTot1' = SUM(CantidadFactor)
INTO #ZAct
FROM mis_VentaUtilX WITH(NOLOCK)
WHERE YEAR(FechaEmision) = @AnoAct
AND MONTH(FechaEmision) = @MesAct
AND DAY(FechaEmision) <= @DiaAct
AND MovClave IN('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.B', 'VTAS.EST')
AND ISNULL(Grupo, '') = CASE @Grupo WHEN 'NULL' THEN ISNULL(Grupo, '') ELSE @Grupo END
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Empresa = @Empresa
GROUP BY Grupo
ORDER BY Grupo
SELECT a.Grupo, a.Articulo, a.SubCuenta, a.Cantid1, a.Import1, b.SumaCan1, c.SumaTot1
INTO #CAct
FROM #AAct a
JOIN #BAct b ON a.Articulo = b.Articulo AND a.Grupo = b.Grupo
JOIN #ZAct c ON a.Grupo = c.Grupo
SELECT Grupo,
Articulo, SubCuenta,
'Cantid2' = SUM(CantidadFactor),
'Import2' = SUM(ImporteX),
'Costo2'  = SUM(CostoTotal),
'Util2'   = SUM(ImporteX - CostoTotal)
INTO #AActAcum 
FROM mis_VentaUtilX WITH(NOLOCK)
WHERE YEAR(FechaEmision) = @AnoAct
AND FechaEmision <= @Fecha
AND MovClave IN('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.B', 'VTAS.EST')
AND ISNULL(Grupo, '') = CASE @Grupo WHEN 'NULL' THEN ISNULL(Grupo, '') ELSE @Grupo END
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Empresa = @Empresa
GROUP BY Grupo, Articulo, SubCuenta
ORDER BY Grupo, Articulo, SubCuenta
SELECT Grupo, Articulo,
'SumaCan2'  = SUM(CantidadFactor),
'SumaUtil2' = SUM(ImporteX - CostoTotal)
INTO #BActAcum
FROM mis_VentaUtilX WITH(NOLOCK)
WHERE YEAR(FechaEmision) = @AnoAct
AND FechaEmision <= @Fecha
AND MovClave IN('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.B', 'VTAS.EST')
AND ISNULL(Grupo, '') = CASE @Grupo WHEN 'NULL' THEN ISNULL(Grupo, '') ELSE @Grupo END
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Empresa = @Empresa
GROUP BY Grupo, Articulo
ORDER BY Grupo, Articulo
SELECT Grupo,
'SumaTot2' = SUM(CantidadFactor)
INTO #ZActAcum
FROM mis_VentaUtilX WITH(NOLOCK)
WHERE YEAR(FechaEmision) = @AnoAct
AND FechaEmision <= @Fecha
AND MovClave IN('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.B', 'VTAS.EST')
AND ISNULL(Grupo, '') = CASE @Grupo WHEN 'NULL' THEN ISNULL(Grupo, '') ELSE @Grupo END
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Empresa = @Empresa
GROUP BY Grupo
ORDER BY Grupo
SELECT a.Grupo, a.Articulo, a.SubCuenta, Cantid2, Import2, Costo2, Util2, SumaCan2, SumaUtil2, SumaTot2
INTO #CActAcum
FROM #AActAcum a
JOIN #BActAcum b ON a.Articulo = b.Articulo AND a.Grupo = b.Grupo
JOIN #ZActAcum c ON a.Grupo = c.Grupo
SELECT Grupo,
Articulo, SubCuenta,
'Cantid3' = SUM(CantidadFactor),
'Import3' = SUM(ImporteX)
INTO #AAnt
FROM mis_VentaUtilX WITH(NOLOCK)
WHERE YEAR(FechaEmision) = @AnoAnt
AND MONTH(FechaEmision) = @MesAnt
AND DAY(FechaEmision) <= @DiaAnt
AND MovClave IN('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.B', 'VTAS.EST')
AND ISNULL(Grupo, '') = CASE @Grupo WHEN 'NULL' THEN ISNULL(Grupo, '') ELSE @Grupo END
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Empresa = @Empresa
GROUP BY Grupo, Articulo, SubCuenta
ORDER BY Grupo, Articulo, SubCuenta
SELECT Grupo, Articulo,
'SumaCan3' = SUM(CantidadFactor)
INTO #BAnt
FROM mis_VentaUtilX WITH(NOLOCK)
WHERE YEAR(FechaEmision) = @AnoAnt
AND MONTH(FechaEmision) = @MesAnt
AND DAY(FechaEmision) <= @DiaAnt
AND MovClave IN('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.B', 'VTAS.EST')
AND ISNULL(Grupo, '') = CASE @Grupo WHEN 'NULL' THEN ISNULL(Grupo, '') ELSE @Grupo END
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Empresa = @Empresa
GROUP BY Grupo, Articulo
ORDER BY Grupo, Articulo
SELECT Grupo,
'SumaTot3' = SUM(CantidadFactor)
INTO #ZAnt
FROM mis_VentaUtilX WITH(NOLOCK)
WHERE YEAR(FechaEmision) = @AnoAnt
AND MONTH(FechaEmision) = @MesAnt
AND DAY(FechaEmision) <= @DiaAnt
AND MovClave IN('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.B', 'VTAS.EST')
AND ISNULL(Grupo, '') = CASE @Grupo WHEN 'NULL' THEN ISNULL(Grupo, '') ELSE @Grupo END
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Empresa = @Empresa
GROUP BY Grupo
ORDER BY Grupo
SELECT a.Grupo, a.Articulo, a.SubCuenta, Cantid3, Import3, SumaCan3, SumaTot3
INTO #CAnt
FROM #AAnt a
JOIN #BAnt b ON a.Articulo = b.Articulo AND a.Grupo = b.Grupo
JOIN #ZAnt c ON a.Grupo = c.Grupo
SELECT Grupo,
Articulo, SubCuenta,
'Cantid4' = Sum(CantidadFactor),
'Import4' = SUM(ImporteX)
INTO #AAntAcum
FROM mis_VentaUtilX WITH(NOLOCK)
WHERE YEAR(FechaEmision) = @AnoAnt
AND FechaEmision <= @FechaAnt
AND MovClave IN('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.B', 'VTAS.EST')
AND ISNULL(Grupo, '') = CASE @Grupo WHEN 'NULL' THEN ISNULL(Grupo, '') ELSE @Grupo END
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Empresa = @Empresa
GROUP BY Grupo, Articulo, SubCuenta
ORDER BY Grupo, Articulo, SubCuenta
SELECT Grupo, Articulo,
'SumaCan4' = SUM(CantidadFactor)
INTO #BAntAcum
FROM mis_VentaUtilX WITH(NOLOCK)
WHERE YEAR(FechaEmision) = @AnoAnt
AND FechaEmision <= @FechaAnt
AND MovClave IN('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.B', 'VTAS.EST')
AND ISNULL(Grupo, '') = CASE @Grupo WHEN 'NULL' THEN ISNULL(Grupo, '') ELSE @Grupo END
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Empresa = @Empresa
GROUP BY Grupo, Articulo
ORDER BY Grupo, Articulo
SELECT Grupo,
'SumaTot4' = SUM(CantidadFactor)
INTO #ZAntAcum
FROM mis_VentaUtilX WITH(NOLOCK)
WHERE YEAR(FechaEmision) = @AnoAnt
AND FechaEmision <= @FechaAnt
AND MovClave IN('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.B', 'VTAS.EST')
AND ISNULL(Grupo, '') = CASE @Grupo WHEN 'NULL' THEN ISNULL(Grupo, '') ELSE @Grupo END
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Empresa = @Empresa
GROUP BY Grupo
ORDER BY Grupo
SELECT a.Grupo, a.Articulo, a.SubCuenta, Cantid4, Import4, SumaCan4, SumaTot4
INTO #CAntAcum
FROM #AAntAcum a
JOIN #BAntAcum b ON a.Articulo = b.Articulo AND a.Grupo = b.Grupo
JOIN #ZAntAcum c ON a.Grupo = c.Grupo
INSERT #ParticipaGrupo
SELECT Grupo, Articulo, Subcuenta, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
NULL, NULL, NULL
FROM #Arti
UPDATE #ParticipaGrupo
SET Cantid1 = a.Cantid1 , Import1 = a.Import1, SumaCan1 = a.SumaCan1, SumaTot1 = a.SumaTot1
FROM #ParticipaGrupo x
LEFT OUTER JOIN #CAct a ON x.Grupox = a.Grupo
AND x.Articulox = a.Articulo
AND x.SubCuentax = a.SubCuenta
UPDATE #ParticipaGrupo
SET Cantid1 = a.Cantid1 , Import1 = a.Import1, SumaCan1 = a.SumaCan1, SumaTot1 = a.SumaTot1
FROM #ParticipaGrupo x
LEFT OUTER JOIN #CAct a ON x.Grupox = a.Grupo
AND x.Articulox = a.Articulo
AND ISNULL(x.Subcuentax,'') = ''
UPDATE #ParticipaGrupo
SET Cantid2 = a.Cantid2, Import2 = a.Import2, Costo2 = a.Costo2, Util2 = a.Util2, SumaCan2 = a.SumaCan2, SumaTot2 = a.SumaTot2
FROM #ParticipaGrupo x
LEFT OUTER JOIN #CActAcum a ON x.Grupox = a.Grupo
AND x.Articulox = a.Articulo
AND x.SubCuentax = a.SubCuenta
UPDATE #ParticipaGrupo
SET Cantid2 = a.Cantid2, Import2 = a.Import2, Costo2 = a.Costo2, Util2 = a.Util2, SumaCan2 = a.SumaCan2, SumaTot2 = a.SumaTot2
FROM #ParticipaGrupo x
LEFT OUTER JOIN #CActAcum a ON x.Grupox = a.Grupo
AND x.Articulox = a.Articulo
AND ISNULL(x.Subcuentax,'') = ''
UPDATE #ParticipaGrupo
SET Cantid3 = a.Cantid3 , Import3 = a.Import3, SumaCan3 = a.SumaCan3, SumaTot3 = a.SumaTot3
FROM #ParticipaGrupo x
LEFT OUTER JOIN #CAnt a ON x.Grupox = a.Grupo
AND x.Articulox = a.Articulo
AND x.SubCuentax = a.SubCuenta
UPDATE #ParticipaGrupo
SET Cantid3 = a.Cantid3 , Import3 = a.Import3, SumaCan3 = a.SumaCan3, SumaTot3 = a.SumaTot3
FROM #ParticipaGrupo x
LEFT OUTER JOIN #CAnt a ON x.Grupox = a.Grupo
AND x.Articulox = a.Articulo
AND ISNULL(x.Subcuentax,'') = ''
UPDATE #ParticipaGrupo
SET Cantid4 = a.Cantid4 , Import4 = a.Import4, SumaCan4 = a.SumaCan4, SumaTot4 = a.SumaTot4
FROM #ParticipaGrupo x
LEFT OUTER JOIN #CAntAcum a ON x.Grupox = a.Grupo
AND x.Articulox = a.Articulo
AND x.SubCuentax = a.SubCuenta
UPDATE #ParticipaGrupo
SET Cantid4 = a.Cantid4 , Import4 = a.Import4, SumaCan4 = a.SumaCan4, SumaTot4 = a.SumaTot4
FROM #ParticipaGrupo x
LEFT OUTER JOIN #CAntAcum a ON x.Grupox = a.Grupo
AND x.Articulox = a.Articulo
AND ISNULL(x.Subcuentax,'') = ''
SELECT * FROM #PARTICIPAGRUPO
ORDER BY Grupox, Articulox, SubCuentax
END

