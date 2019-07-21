SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE mis_spUtilidadSucursal
@Empresa		char(5),
@FechaD			DateTime,
@FechaA			DateTime,
@Sucursal		int,
@Desglosar		Char(2)

AS BEGIN
DECLARE
@VPrecioImpInc		Bit,
@PrecioImp		money,
@PreciosinImp		money,
@Imp2Info         bit,
@Imp3Info         bit
SELECT @VPrecioImpInc = VentaPreciosImpuestoIncluido FROM EmpresaCfg WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @Imp2Info = ISNULL(Impuesto2Info, 0), @Imp3Info = ISNULL(Impuesto3Info, 0) FROM Version WITH(NOLOCK)
SELECT VentaUtilD.MovClave,
VentaUtilD.Sucursal,
DescuentoGlobal = (VentaUtilD.DescuentoGlobal),
Importe = VentaUtilD.TipoCambio * dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc),
CostoTotal = VentaUtilD.TipoCambio * (VentaUtilD.CostoTotal),
CantidadFactor = (VentaUtilD.CantidadFactor),
FactorV = (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END ),
CantidadNeta = (VentaUtilD.CantidadFactor) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0  END),
ImporteBruto = VentaUtilD.TipoCambio * dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc),
ImporteNeto = VentaUtilD.TipoCambio * ((dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc) - (dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc) * ISNULL((VentaUtilD.DescuentoGlobal/100),0))) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END)),
CostoNeto = VentaUtilD.TipoCambio * ((VentaUtilD.CostoTotal) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END)),
ComisionNeta = VentaUtilD.TipoCambio * ((VentaUtilD.Comision) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END)),
Utilidad = VentaUtilD.TipoCambio * (((dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc) - (dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc) * ISNULL((VentaUtilD.DescuentoGlobal/100),0))) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END))  -
((VentaUtilD.CostoTotal) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END))),
UtilidadPor = VentaUtilD.TipoCambio * (Case (VentaUtilD.CostoTotal) WHEN 0 THEN 100
ELSE
(((((dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc) - (dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc) * ISNULL((VentaUtilD.DescuentoGlobal/100),0))) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END) /
((dbo.fnEvitarDivisionCero(VentaUtilD.CostoTotal)) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END))))-1)  *100) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0  WHEN 'VTAS.B' THEN -1.0 ELSE 1.0 END ) END)
INTO #UtilidadSucA
FROM VentaUtilD WITH(NOLOCK)
JOIN Art WITH(NOLOCK) ON VentaUtilD.Articulo=Art.Articulo
WHERE VentaUtilD.Empresa = @Empresa
AND VentaUtilD.FechaEmision BETWEEN @FechaD AND @FechaA
AND VentaUtilD.Sucursal = CASE ISNULL(convert(char(10), @Sucursal), ' ') WHEN ' ' THEN VentaUtilD.Sucursal ELSE @Sucursal END
ORDER BY VentaUtilD.Sucursal
SELECT Sucursal, DescuentoGlobal = AVG(ISNULL(DescuentoGlobal,0)),
CantidadNeta = SUM(CantidadNeta), ImporteBruto = SUM(ImporteBruto),
ImporteNeto = SUM(ImporteNeto), CostoNeto = SUM(CostoNeto), ComisionNeta = SUM(ComisionNeta),
Utilidad = SUM(Utilidad), UtilidadPor = AVG(UtilidadPor)
INTO #UtilSucA
FROM #UtilidadSucA
GROUP BY Sucursal
ORDER BY Utilidad DESC, Sucursal
IF @Desglosar = 'Si'
BEGIN
SELECT MovClaveD = VentaUtilD.MovClave,
SucursalD = VentaUtilD.Sucursal,
MovD = VentaUtilD.Mov,
MovIDD = VentaUtilD.MovID,
DescuentoGlobalD = (VentaUtilD.DescuentoGlobal),
ImporteD = VentaUtilD.TipoCambio * dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc),
CostoTotalD =  VentaUtilD.TipoCambio * (VentaUtilD.CostoTotal),
CantidadFactorD = (VentaUtilD.CantidadFactor),
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
INTO #UtilidadSucB
FROM VentaUtilD WITH(NOLOCK)
JOIN Art WITH(NOLOCK) ON VentaUtilD.Articulo = Art.Articulo
WHERE VentaUtilD.Empresa = @Empresa
AND VentaUtilD.FechaEmision BETWEEN @FechaD AND @FechaA
AND VentaUtilD.Sucursal = CASE ISNULL(convert(char(10), @Sucursal), ' ') WHEN ' ' THEN VentaUtilD.Sucursal ELSE @Sucursal END
ORDER BY VentaUtilD.Sucursal
SELECT SucursalD, MovD, MovIDD, DescuentoGlobalD = AVG(ISNULL(DescuentoGlobalD,0)),
CantidadNetaD = SUM(CantidadNetaD), ImporteBrutoD = SUM(ImporteBrutoD),
ImporteNetoD = SUM(ImporteNetoD), CostoNetoD = SUM(CostoNetoD), ComisionNetaD = SUM(ComisionNetaD),
UtilidadD = SUM(UtilidadD), UtilidadPorD = AVG(UtilidadPorD)
INTO #UtilSucB
FROM #UtilidadSucB
GROUP BY SucursalD, MovD, MovIDD
ORDER BY SucursalD, UtilidadD DESC
END
CREATE TABLE #UtilidadSuc (
Sucursalx		int		NULL,
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
INSERT #UtilidadSuc
SELECT Sucursal, MovD, MovIDD, DescuentoGlobal, CantidadNeta, ImporteBruto,
ImporteNeto, CostoNeto, ComisionNeta, Utilidad, UtilidadPor,
DescuentoGlobalD, CantidadNetaD, ImporteBrutoD,
ImporteNetoD, CostoNetoD, ComisionNetaD, UtilidadD, UtilidadPorD
FROM #UtilSucA
JOIN #UtilSucB ON Sucursal = SucursalD
ORDER BY Utilidad DESC, UtilidadD DESC
END
ELSE
BEGIN
INSERT #UtilidadSuc
SELECT Sucursal, NULL, NULL,DescuentoGlobal, CantidadNeta, ImporteBruto,
ImporteNeto, CostoNeto, ComisionNeta, Utilidad, UtilidadPor,
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
FROM #UtilSucA
ORDER BY Utilidad DESC
END
SELECT * FROM #UtilidadSuc
ORDER BY Utilidad DESC, Sucursalx, UtilidadD DESC
END

