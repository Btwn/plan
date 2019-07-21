SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE mis_spUtilidadAgentes
@Empresa		char(5),
@AgenteD		char(10),
@AgenteA		char(10),
@FechaD			DateTime,
@FechaA			DateTime,
@Desglosar		Char(2)

AS BEGIN
DECLARE
@VPrecioImpInc		Bit,
@PrecioImp		money,
@PreciosinImp		money,
@Imp2Info         bit,
@Imp3Info         bit
SELECT @VPrecioImpInc = VentaPreciosImpuestoIncluido FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @Imp2Info = ISNULL(Impuesto2Info, 0), @Imp3Info = ISNULL(Impuesto3Info, 0) FROM Version
SELECT VentaUtilD.MovClave,
VentaUtilD.Agente,
Agente.Nombre,
DescuentoGlobal = (VentaUtilD.DescuentoGlobal),
Importe = VentaUtilD.TipoCambio * (CASE WHEN @VPrecioImpInc = 1 THEN ((VentaUtilD.Importe)/ (1 + (dbo.fnEvitarDivisionCero(VentaUtilD.Impuesto1) / 100))) ELSE (VentaUtilD.Importe) END),
CostoTotal = VentaUtilD.TipoCambio * (VentaUtilD.CostoTotal),
CantidadFactor = (VentaUtilD.CantidadFactor),
FactorV = (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END ),
CantidadNeta = (VentaUtilD.CantidadFactor) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0  END),
ImporteBruto = VentaUtilD.TipoCambio * (CASE WHEN @VPrecioImpInc = 1 THEN ((VentaUtilD.Importe)/ (1 + (dbo.fnEvitarDivisionCero(VentaUtilD.Impuesto1) / 100))) ELSE (VentaUtilD.Importe) END),
ImporteNeto = VentaUtilD.TipoCambio * (((CASE WHEN @VPrecioImpInc = 1 THEN ((VentaUtilD.Importe)/ (1 + (dbo.fnEvitarDivisionCero(VentaUtilD.Impuesto1) / 100))) ELSE (VentaUtilD.Importe) END) - ((CASE WHEN @VPrecioImpInc = 1 THEN ((VentaUtilD.Importe)/ (1 + (dbo.fnEvitarDivisionCero(VentaUtilD.Impuesto1) / 100))) ELSE (VentaUtilD.Importe) END) * ISNULL((VentaUtilD.DescuentoGlobal/100),0))) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END)),
CostoNeto = VentaUtilD.TipoCambio * ((VentaUtilD.CostoTotal) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END)),
ComisionNeta = VentaUtilD.TipoCambio * ((VentaUtilD.Comision) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END)),
Utilidad = VentaUtilD.TipoCambio * ((((CASE WHEN @VPrecioImpInc = 1 THEN ((VentaUtilD.Importe)/ (1 + (dbo.fnEvitarDivisionCero(VentaUtilD.Impuesto1) / 100))) ELSE (VentaUtilD.Importe) END) - ((CASE WHEN @VPrecioImpInc = 1 THEN ((VentaUtilD.Importe)/ (1 + (dbo.fnEvitarDivisionCero(VentaUtilD.Impuesto1) / 100))) ELSE (VentaUtilD.Importe) END) * ISNULL((VentaUtilD.DescuentoGlobal/100),0))) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END))  -
((VentaUtilD.CostoTotal) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END))),
UtilidadPor = VentaUtilD.TipoCambio * (Case (VentaUtilD.CostoTotal) WHEN 0 THEN 100
ELSE
((((((CASE WHEN @VPrecioImpInc = 1 THEN ((VentaUtilD.Importe)/ (1 + (dbo.fnEvitarDivisionCero(VentaUtilD.Impuesto1) / 100))) ELSE (VentaUtilD.Importe) END) - ((CASE WHEN @VPrecioImpInc = 1 THEN ((VentaUtilD.Importe)/ (1 + (dbo.fnEvitarDivisionCero(VentaUtilD.Impuesto1) / 100))) ELSE (VentaUtilD.Importe) END) * ISNULL((VentaUtilD.DescuentoGlobal/100),0))) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END) /
((dbo.fnEvitarDivisionCero(VentaUtilD.CostoTotal)) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END))))-1)  *100) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0  WHEN 'VTAS.B' THEN -1.0 ELSE 1.0 END ) END)
INTO #UtilidadAgeA
FROM VentaUtilD
JOIN Art ON VentaUtilD.Articulo=Art.Articulo
LEFT OUTER JOIN Agente ON VentaUtilD.Agente = Agente.Agente
WHERE VentaUtilD.Empresa = @Empresa
AND VentaUtilD.FechaEmision BETWEEN @FechaD AND @FechaA
AND ISNULL(VentaUtilD.Agente, '')  >= CASE @AgenteD  WHEN 'NULL' THEN ISNULL(VentaUtilD.Agente, '')  ELSE @AgenteD  END
AND ISNULL(VentaUtilD.Agente, '')  <= CASE @AgenteA  WHEN 'NULL' THEN ISNULL(VentaUtilD.Agente, '')  ELSE @AgenteA  END
ORDER BY VentaUtilD.Agente
SELECT Agente, Nombre, DescuentoGlobal = AVG(ISNULL(DescuentoGlobal,0)),
CantidadNeta = SUM(CantidadNeta), ImporteBruto = SUM(ImporteBruto),
ImporteNeto = SUM(ImporteNeto), CostoNeto = SUM(CostoNeto), ComisionNeta = SUM(ComisionNeta),
Utilidad = SUM(Utilidad), UtilidadPor = AVG(UtilidadPor)
INTO #UtilAgeA
FROM #UtilidadAgeA
GROUP BY Agente, Nombre
ORDER BY Utilidad DESC, Agente
IF @Desglosar = 'Si'
BEGIN
SELECT MovClaveD = VentaUtilD.MovClave,
AgenteD = VentaUtilD.Agente,
MovD = VentaUtilD.Mov,
MovIDD = VentaUtilD.MovID,
DescuentoGlobalD = (VentaUtilD.DescuentoGlobal),
ImporteD = VentaUtilD.TipoCambio * dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc),
CostoTotalD =  VentaUtilD.TipoCambio * (VentaUtilD.CostoTotal),
CantidadFactorD = (VentaUtilD.CantidadFactor),
NombreD = Agente.Nombre,
FactorVD = (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END ),
CantidadNetaD = (VentaUtilD.CantidadFactor) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0  END),
ImporteBrutoD = VentaUtilD.TipoCambio * dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc),
ImporteNetoD = VentaUtilD.TipoCambio * ((dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc) - (dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc) * ISNULL((VentaUtilD.DescuentoGlobal/100),0))) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END)),
CostoNetoD = VentaUtilD.TipoCambio * ((VentaUtilD.CostoTotal) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END)),
ComisionNetaD = VentaUtilD.TipoCambio * ((VentaUtilD.Comision) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END)),
UtilidadD = VentaUtilD.TipoCambio * (((dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc) - (dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc) * ISNULL((VentaUtilD.DescuentoGlobal/100),0))) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END))  -
((dbo.fnEvitarDivisionCero(VentaUtilD.CostoTotal)) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END))),
UtilidadPorD = VentaUtilD.TipoCambio * (Case (VentaUtilD.CostoTotal) WHEN 0 THEN 100
ELSE
(((((dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc) - (dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc) * ISNULL((VentaUtilD.DescuentoGlobal/100),0))) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END) /
((dbo.fnEvitarDivisionCero(VentaUtilD.CostoTotal)) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END))))-1)  *100) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0  WHEN 'VTAS.B' THEN -1.0 ELSE 1.0 END ) END)
INTO #UtilidadAgeB
FROM VentaUtilD
JOIN Art ON VentaUtilD.Articulo = Art.Articulo
LEFT OUTER JOIN Agente ON VentaUtilD.Agente = Agente.Agente
WHERE VentaUtilD.Empresa = @Empresa
AND VentaUtilD.FechaEmision BETWEEN @FechaD AND @FechaA
AND ISNULL(VentaUtilD.Agente, '')  >= CASE @AgenteD  WHEN 'NULL' THEN ISNULL(VentaUtilD.Agente, '')  ELSE @AgenteD  END
AND ISNULL(VentaUtilD.Agente, '')  <= CASE @AgenteA  WHEN 'NULL' THEN ISNULL(VentaUtilD.Agente, '')  ELSE @AgenteA  END
ORDER BY VentaUtilD.Agente
SELECT AgenteD, MovD, MovIDD, DescuentoGlobalD = AVG(ISNULL(DescuentoGlobalD,0)),
NombreD, CantidadNetaD = SUM(CantidadNetaD), ImporteBrutoD = SUM(ImporteBrutoD),
ImporteNetoD = SUM(ImporteNetoD), CostoNetoD = SUM(CostoNetoD), ComisionNetaD = SUM(ComisionNetaD),
UtilidadD = SUM(UtilidadD), UtilidadPorD = AVG(UtilidadPorD)
INTO #UtilAgeB
FROM #UtilidadAgeB
GROUP BY AgenteD, MovD, MovIDD, NombreD
ORDER BY AgenteD, UtilidadD desc
END
CREATE TABLE #UtilidadAgente (
Agente		char(10)	COLLATE Database_Default NULL,
Nombre		varchar(100)	COLLATE Database_Default NULL,
Mov		char(20)	COLLATE Database_Default NULL,
MovID		varchar(20)	COLLATE Database_Default NULL,
DescuentoGlobal	float(8)	NULL,
CantidadNeta 	float(8)	NULL,
ImporteBruto	money		NULL,
ImporteNeto	money		NULL,
CostoNeto		money		NULL,
ComisionNeta	money		NULL,
Utilidad		money		NULL,
UtilidadPor	float(8)	NULL,
DescuentoGlobalD	float(8)	NULL,
CantidadNetaD 	float(8)	NULL,
ImporteBrutoD	money		NULL,
ImporteNetoD	money		NULL,
CostoNetoD		money		NULL,
ComisionNetaD	money		NULL,
UtilidadD		money		NULL,
UtilidadPorD	float(8)	NULL
)
IF @Desglosar = 'Si'
BEGIN
INSERT #UtilidadAgente
SELECT Agente, Nombre, MovD, MovIDD, DescuentoGlobal, CantidadNeta, ImporteBruto,
ImporteNeto, CostoNeto, ComisionNeta, Utilidad, UtilidadPor,
DescuentoGlobalD, CantidadNetaD, ImporteBrutoD,
ImporteNetoD, CostoNetoD, ComisionNetaD, UtilidadD, UtilidadPorD
FROM #UtilAgeA
JOIN #UtilAgeB ON ISNULL(Agente, '') = ISNULL(AgenteD, '')
ORDER BY Utilidad desc, UtilidadD desc
END
ELSE
BEGIN
INSERT #UtilidadAgente
SELECT Agente, Nombre, NULL, NULL,DescuentoGlobal, CantidadNeta, ImporteBruto,
ImporteNeto, CostoNeto, ComisionNeta, Utilidad, UtilidadPor,
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
FROM #UtilAgeA
ORDER BY Utilidad desc
END
SELECT * FROM #UtilidadAgente
ORDER BY Utilidad DESC, Agente, UtilidadD DESC
END

