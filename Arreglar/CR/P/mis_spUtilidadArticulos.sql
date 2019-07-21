SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE mis_spUtilidadArticulos
@Empresa		char(5),
@ArticuloD		char(20),
@ArticuloA		char(20),
@ArtCat			varchar(50),
@ArtFam			varchar(50),
@ArtGrupo		varchar(50),
@ArtLinea		varchar(50),
@Fabricante		varchar(50),
@FechaD			DateTime,
@FechaA			DateTime,
@Desglosar		Char(2)

AS BEGIN
DECLARE
@VPrecioImpInc    bit,
@PrecioImp        money,
@PreciosinImp     money,
@Imp2Info         bit,
@Imp3Info         bit
SELECT @VPrecioImpInc = VentaPreciosImpuestoIncluido FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @Imp2Info = ISNULL(Impuesto2Info, 0), @Imp3Info = ISNULL(Impuesto3Info, 0) FROM Version
SELECT VentaUtilD.MovClave,
VentaUtilD.Articulo,
Art.Descripcion1,
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
ImporteNeto = VentaUtilD.TipoCambio * (((dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc)) - ((dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc)) * ISNULL((VentaUtilD.DescuentoGlobal/100),0))) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END)),
CostoNeto = VentaUtilD.TipoCambio * ((VentaUtilD.CostoTotal) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END)),
ComisionNeta = VentaUtilD.TipoCambio * ((VentaUtilD.Comision) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END)),
Utilidad = VentaUtilD.TipoCambio * ((((dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc)) - ((dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc)) * ISNULL((VentaUtilD.DescuentoGlobal/100),0))) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END))  -
((VentaUtilD.CostoTotal) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END))),
UtilidadPor = VentaUtilD.TipoCambio * (Case (VentaUtilD.CostoTotal) WHEN 0 THEN 100
ELSE
((((((dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc)) - ((dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc)) * ISNULL((VentaUtilD.DescuentoGlobal/100),0))) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END) /
((VentaUtilD.CostoTotal) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END))))-1)  *100) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0  WHEN 'VTAS.B' THEN -1.0 ELSE 1.0 END ) END)
INTO #UtilidadArtA
FROM VentaUtilD
JOIN Art ON VentaUtilD.Articulo=Art.Articulo
WHERE VentaUtilD.Empresa = @Empresa
AND VentaUtilD.FechaEmision BETWEEN @FechaD AND @FechaA
AND ISNULL(VentaUtilD.Articulo, '')  >= CASE @ArticuloD  WHEN 'NULL' THEN ISNULL(VentaUtilD.Articulo, '')  ELSE @ArticuloD  END
AND ISNULL(VentaUtilD.Articulo, '')  <= CASE @ArticuloA  WHEN 'NULL' THEN ISNULL(VentaUtilD.Articulo, '')  ELSE @ArticuloA  END
AND ISNULL(Art.Categoria, '')  = CASE @ArtCat     WHEN 'NULL' THEN ISNULL(Art.Categoria, '')  ELSE @ArtCat     END
AND ISNULL(Art.Grupo, '')      = CASE @ArtGrupo   WHEN 'NULL' THEN ISNULL(Art.Grupo, '')      ELSE @ArtGrupo   END
AND ISNULL(Art.Familia, '')    = CASE @ArtFam     WHEN 'NULL' THEN ISNULL(Art.Familia, '')    ELSE @ArtFam     END
AND ISNULL(Art.Linea, '')      = CASE @ArtLinea   WHEN 'NULL' THEN ISNULL(Art.Linea, '')      ELSE @ArtFam     END
AND ISNULL(Art.Fabricante, '') = CASE @Fabricante WHEN 'NULL' THEN ISNULL(Art.Fabricante, '') ELSE @Fabricante END
ORDER BY VentaUtilD.Articulo
SELECT Articulo, Descripcion1, DescuentoGlobal = AVG(ISNULL(DescuentoGlobal,0)),
CantidadNeta = SUM(CantidadNeta), ImporteBruto = SUM(ImporteBruto),
ImporteNeto = SUM(ImporteNeto), CostoNeto = SUM(CostoNeto), ComisionNeta = SUM(ComisionNeta),
Utilidad = SUM(Utilidad), UtilidadPor = AVG(UtilidadPor)
INTO #UtilArtA
FROM #UtilidadArtA
GROUP BY Articulo, Descripcion1
ORDER BY Utilidad desc, Articulo
IF @Desglosar = 'Si'
BEGIN
SELECT MovClaveD = VentaUtilD.MovClave,
ArticuloD = VentaUtilD.Articulo,
MovD = VentaUtilD.Mov,
MovIDD = VentaUtilD.MovID,
DescuentoGlobalD = (VentaUtilD.DescuentoGlobal),
ImporteD = VentaUtilD.TipoCambio * (dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc)),
CostoTotalD =  VentaUtilD.TipoCambio * (VentaUtilD.CostoTotal),
CantidadFactorD = (VentaUtilD.CantidadFactor),
Descripcion1D = Art.Descripcion1,
FactorVD = (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END ),
CantidadNetaD = (VentaUtilD.CantidadFactor) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0  END),
ImporteBrutoD = VentaUtilD.TipoCambio * (dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc)),
ImporteNetoD = VentaUtilD.TipoCambio * (((dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc)) - ((dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc)) * ISNULL((VentaUtilD.DescuentoGlobal/100),0))) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END)),
CostoNetoD = VentaUtilD.TipoCambio * ((VentaUtilD.CostoTotal) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END)),
ComisionNetaD = VentaUtilD.TipoCambio * ((VentaUtilD.Comision) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END)),
UtilidadD = VentaUtilD.TipoCambio * ((((dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc)) - ((dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc)) * ISNULL((VentaUtilD.DescuentoGlobal/100),0))) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END))  -
((VentaUtilD.CostoTotal) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END))),
UtilidadPorD = VentaUtilD.TipoCambio * (Case (VentaUtilD.CostoTotal) WHEN 0 THEN 100
ELSE
((((((dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc)) - ((dbo.fnPrecioReal(VentaUtilD.Importe, VentaUtilD.Impuesto1, VentaUtilD.Impuesto2, VentaUtilD.Impuesto3, @Imp2Info, @Imp3Info, @VPrecioImpInc)) * ISNULL((VentaUtilD.DescuentoGlobal/100),0))) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END) /
((VentaUtilD.CostoTotal) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0
WHEN 'VTAS.B' THEN -1.0
ELSE 1.0 END))))-1)  *100) * (Case VentaUtilD.MovClave WHEN 'VTAS.D' THEN -1.0  WHEN 'VTAS.B' THEN -1.0 ELSE 1.0 END ) END)
INTO #UtilidadArtB
FROM VentaUtilD
JOIN Art ON VentaUtilD.Articulo = Art.Articulo
WHERE VentaUtilD.Empresa = @Empresa
AND VentaUtilD.FechaEmision BETWEEN @FechaD AND @FechaA
AND ISNULL(VentaUtilD.Articulo, '')  >= CASE @ArticuloD  WHEN 'NULL' THEN ISNULL(VentaUtilD.Articulo, '')  ELSE @ArticuloD  END
AND ISNULL(VentaUtilD.Articulo, '')  <= CASE @ArticuloA  WHEN 'NULL' THEN ISNULL(VentaUtilD.Articulo, '')  ELSE @ArticuloA  END
AND ISNULL(Art.Categoria, '')  = CASE @ArtCat     WHEN 'NULL' THEN ISNULL(Art.Categoria, '')  ELSE @ArtCat     END
AND ISNULL(Art.Grupo, '')      = CASE @ArtGrupo   WHEN 'NULL' THEN ISNULL(Art.Grupo, '')      ELSE @ArtGrupo   END
AND ISNULL(Art.Familia, '')    = CASE @ArtFam     WHEN 'NULL' THEN ISNULL(Art.Familia, '')    ELSE @ArtFam     END
AND ISNULL(Art.Linea, '')      = CASE @ArtLinea   WHEN 'NULL' THEN ISNULL(Art.Linea, '')      ELSE @ArtFam     END
AND ISNULL(Art.Fabricante, '') = CASE @Fabricante WHEN 'NULL' THEN ISNULL(Art.Fabricante, '') ELSE @Fabricante END
ORDER BY VentaUtilD.Articulo
SELECT ArticuloD, MovD, MovIDD, DescuentoGlobalD = AVG(ISNULL(DescuentoGlobalD,0)),
Descripcion1D, CantidadNetaD = SUM(CantidadNetaD), ImporteBrutoD = SUM(ImporteBrutoD),
ImporteNetoD = SUM(ImporteNetoD), CostoNetoD = SUM(CostoNetoD), ComisionNetaD = SUM(ComisionNetaD),
UtilidadD = SUM(UtilidadD), UtilidadPorD = AVG(UtilidadPorD)
INTO #UtilArtB
FROM #UtilidadArtB
GROUP BY ArticuloD, MovD, MovIDD, Descripcion1D
ORDER BY ArticuloD, UtilidadD desc
END
CREATE TABLE #UtilidadArt (
Articulo		char(20)	COLLATE Database_Default NULL,
Descripcion1	varchar(100)	COLLATE Database_Default NULL,
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
INSERT #UtilidadArt
SELECT Articulo, Descripcion1, MovD, MovIDD, DescuentoGlobal, CantidadNeta, ImporteBruto,
ImporteNeto, CostoNeto, ComisionNeta, Utilidad, UtilidadPor,
DescuentoGlobalD, CantidadNetaD, ImporteBrutoD,
ImporteNetoD, CostoNetoD, ComisionNetaD, UtilidadD, UtilidadPorD
FROM #UtilArtA
JOIN #UtilArtB ON Articulo = ArticuloD
ORDER BY Utilidad desc, UtilidadD desc
END
ELSE
BEGIN
INSERT #UtilidadArt
SELECT Articulo, Descripcion1, NULL, NULL,DescuentoGlobal, CantidadNeta, ImporteBruto,
ImporteNeto, CostoNeto, ComisionNeta, Utilidad, UtilidadPor,
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
FROM #UtilArtA
ORDER BY Utilidad desc
END
SELECT * FROM #UtilidadArt
ORDER BY Utilidad DESC, Articulo, UtilidadD DESC
END

