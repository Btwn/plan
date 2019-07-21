SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE mis_spUtilidadClientes
@Empresa		char(5),
@ClienteD		char(10),
@ClienteA		char(10),
@CteCat			varchar(50),
@CteFam			varchar(50),
@CteGrupo		varchar(50),
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
VentaUtilD.Cliente,
Cte.Nombre,
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
INTO #UtilidadCteA
FROM VentaUtilD
JOIN Art ON VentaUtilD.Articulo=Art.Articulo
JOIN Cte ON VentaUtilD.Cliente=Cte.Cliente
WHERE VentaUtilD.Empresa = @Empresa
AND VentaUtilD.FechaEmision BETWEEN @FechaD AND @FechaA
AND ISNULL(VentaUtilD.Cliente, '')  >= CASE @ClienteD  WHEN 'NULL' THEN ISNULL(VentaUtilD.Cliente, '')  ELSE @ClienteD  END
AND ISNULL(VentaUtilD.Cliente, '')  <= CASE @ClienteA  WHEN 'NULL' THEN ISNULL(VentaUtilD.Cliente, '')  ELSE @ClienteA  END
AND ISNULL(Cte.Categoria, '')  = CASE @CteCat   WHEN 'NULL' THEN ISNULL(Cte.Categoria, '')  ELSE @CteCat   END
AND ISNULL(Cte.Grupo, '')      = CASE @CteGrupo WHEN 'NULL' THEN ISNULL(Cte.Grupo, '')      ELSE @CteGrupo END
AND ISNULL(Cte.Familia, '')    = CASE @CteFam   WHEN 'NULL' THEN ISNULL(Cte.Familia, '')    ELSE @CteFam   END
ORDER BY VentaUtilD.Cliente
SELECT Cliente, Nombre, DescuentoGlobal = AVG(ISNULL(DescuentoGlobal,0)),
CantidadNeta = SUM(CantidadNeta), ImporteBruto = SUM(ImporteBruto),
ImporteNeto = SUM(ImporteNeto), CostoNeto = SUM(CostoNeto), ComisionNeta = SUM(ComisionNeta),
Utilidad = SUM(Utilidad), UtilidadPor = AVG(UtilidadPor)
INTO #UtilCteA
FROM #UtilidadCteA
GROUP BY Cliente, Nombre
ORDER BY Utilidad desc, Cliente
IF @Desglosar = 'Si'
BEGIN
SELECT MovClaveD = VentaUtilD.MovClave,
ClienteD = VentaUtilD.Cliente,
NombreD = Cte.Nombre,
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
INTO #UtilidadCteB
FROM VentaUtilD
JOIN Art ON VentaUtilD.Articulo = Art.Articulo
JOIN Cte ON VentaUtilD.Cliente=Cte.Cliente
WHERE VentaUtilD.Empresa = @Empresa
AND VentaUtilD.FechaEmision BETWEEN @FechaD AND @FechaA
AND ISNULL(VentaUtilD.Cliente, '')  >= CASE @ClienteD  WHEN 'NULL' THEN ISNULL(VentaUtilD.Cliente, '')  ELSE @ClienteD  END
AND ISNULL(VentaUtilD.Cliente, '')  <= CASE @ClienteA  WHEN 'NULL' THEN ISNULL(VentaUtilD.Cliente, '')  ELSE @ClienteA  END
AND ISNULL(Cte.Categoria, '')  = CASE @CteCat   WHEN 'NULL' THEN ISNULL(Cte.Categoria, '')  ELSE @CteCat   END
AND ISNULL(Cte.Grupo, '')      = CASE @CteGrupo WHEN 'NULL' THEN ISNULL(Cte.Grupo, '')      ELSE @CteGrupo END
AND ISNULL(Cte.Familia, '')    = CASE @CteFam   WHEN 'NULL' THEN ISNULL(Cte.Familia, '')    ELSE @CteFam   END
ORDER BY VentaUtilD.Cliente
SELECT ClienteD, MovD, MovIDD, DescuentoGlobalD = AVG(ISNULL(DescuentoGlobalD,0)),
NombreD, CantidadNetaD = SUM(CantidadNetaD), ImporteBrutoD = SUM(ImporteBrutoD),
ImporteNetoD = SUM(ImporteNetoD), CostoNetoD = SUM(CostoNetoD), ComisionNetaD = SUM(ComisionNetaD),
UtilidadD = SUM(UtilidadD), UtilidadPorD = AVG(UtilidadPorD)
INTO #UtilCteB
FROM #UtilidadCteB
GROUP BY ClienteD, MovD, MovIDD, NombreD
ORDER BY NombreD, UtilidadD desc
END
CREATE TABLE #UtilidadCte (
Cliente		char(20)	COLLATE Database_Default NULL,
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
INSERT #UtilidadCte
SELECT Cliente, Nombre, MovD, MovIDD, DescuentoGlobal, CantidadNeta, ImporteBruto,
ImporteNeto, CostoNeto, ComisionNeta, Utilidad, UtilidadPor,
DescuentoGlobalD, CantidadNetaD, ImporteBrutoD,
ImporteNetoD, CostoNetoD, ComisionNetaD, UtilidadD, UtilidadPorD
FROM #UtilCteA
JOIN #UtilCteB ON ISNULL(Cliente, '') = ISNULL(ClienteD, '')
ORDER BY Utilidad DESC, UtilidadD DESC
END
ELSE
BEGIN
INSERT #UtilidadCte
SELECT Cliente, Nombre, NULL, NULL,DescuentoGlobal, CantidadNeta, ImporteBruto,
ImporteNeto, CostoNeto, ComisionNeta, Utilidad, UtilidadPor,
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
FROM #UtilCteA
ORDER BY Utilidad DESC
END
SELECT * FROM #UtilidadCte
ORDER BY Utilidad DESC, Cliente, UtilidadD DESC
END

