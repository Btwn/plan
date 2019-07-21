SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAFGenerarGastoD
@Empresa				varchar(5),
@Mov					varchar(20),
@ID						int,
@GastoID				int,
@MovTipo				varchar(20),
@Concepto				varchar(50),
@GastoFactor			float,
@AFGenerarGastoCfg		varchar(20),
@AFMovGenerarGastoCfg	varchar(20),
@Ok						int			OUTPUT,
@OkRef					varchar(255)OUTPUT

AS BEGIN
IF (@AFGenerarGastoCfg = 'Empresa') OR(@AFGenerarGastoCfg = 'Movimiento' AND @AFMovGenerarGastoCfg = 'Especifico')
BEGIN
IF @MovTipo IN('AF.DP', 'AF.DT')
INSERT INTO #GastoD(
ID,       Concepto,  Cantidad, Precio,              Importe,             Impuestos,        PorcentajeDeducible, UEN,    Proyecto)
SELECT @GastoID, @Concepto, 1,        SUM(d.Depreciacion), SUM(d.Depreciacion), SUM(d.Impuestos), PorcentajeDeducible, af.UEN, af.Proyecto
FROM ActivoFijoD d WITH(NOLOCK)
JOIN ActivoFijo af WITH(NOLOCK) ON d.ID = af.ID
JOIN Concepto WITH(NOLOCK) ON Concepto.Concepto = @Concepto AND Modulo = 'GAS'
WHERE d.ID = @ID
GROUP BY PorcentajeDeducible, af.UEN, af.Proyecto, af.ContUso, af.ContUso2, af.ContUso3
ELSE
INSERT INTO #GastoD(
ID,       Concepto,  Cantidad, Precio,         Importe,        Impuestos,        PorcentajeDeducible, UEN,    Proyecto)
SELECT @GastoID, @Concepto, 1,        SUM(d.Importe), SUM(d.Importe), SUM(d.Impuestos), PorcentajeDeducible, af.UEN, af.Proyecto
FROM ActivoFijoD d WITH(NOLOCK)
JOIN ActivoFijo af WITH(NOLOCK) ON d.ID = af.ID
JOIN Concepto WITH(NOLOCK) ON Concepto.Concepto = @Concepto AND Modulo = 'GAS'
WHERE d.ID = @ID
GROUP BY PorcentajeDeducible, af.UEN, af.Proyecto, af.ContUso, af.ContUso2, af.ContUso3
UPDATE Gasto WITH(ROWLOCK) SET AF = 0, AFArticulo = NULL, AFSerie = NULL WHERE ID = @GastoID 
END
ELSE IF @AFGenerarGastoCfg = 'Movimiento' AND @AFMovGenerarGastoCfg = 'Categoria'
BEGIN
IF @MovTipo IN('AF.DP', 'AF.DT')
INSERT INTO #GastoD(
ID,       Categoria,   Concepto,   Cantidad, Precio,			     Importe,             Impuestos,        PorcentajeDeducible,   UEN,    Proyecto)
SELECT @GastoID, a.Categoria, m.Concepto, 1,        SUM(d.Depreciacion), SUM(d.Depreciacion), SUM(d.Impuestos), c.PorcentajeDeducible, af.UEN, af.Proyecto
FROM ActivoFijoD d WITH(NOLOCK)
JOIN ActivoFijo af WITH(NOLOCK) ON d.ID = af.ID
JOIN ActivoF a WITH(NOLOCK) ON d.Articulo = a.Articulo AND d.Serie = a.Serie
LEFT OUTER JOIN MovTipoAFConceptoGAS m WITH(NOLOCK) ON a.Categoria = m.Categoria AND m.Mov = @Mov
LEFT OUTER JOIN Concepto c WITH(NOLOCK) ON m.Concepto = c.Concepto AND Modulo = 'GAS'
WHERE d.ID  = @ID
GROUP BY a.Categoria, m.Concepto, c.PorcentajeDeducible, af.UEN, af.Proyecto
ELSE
INSERT INTO #GastoD(
ID,       Categoria,   Concepto,   Cantidad, Precio,         Importe,        Impuestos,        PorcentajeDeducible,   UEN,    Proyecto)
SELECT @GastoID, a.Categoria, m.Concepto, 1,        SUM(d.Importe), SUM(d.Importe), SUM(d.Impuestos), c.PorcentajeDeducible, af.UEN, af.Proyecto
FROM ActivoFijoD d WITH(NOLOCK)
JOIN ActivoFijo af WITH(NOLOCK) ON d.ID = af.ID
JOIN ActivoF a WITH(NOLOCK) ON d.Articulo = a.Articulo AND d.Serie = a.Serie
LEFT OUTER JOIN MovTipoAFConceptoGAS m WITH(NOLOCK) ON a.Categoria = m.Categoria AND m.Mov = @Mov
LEFT OUTER JOIN Concepto c WITH(NOLOCK) ON m.Concepto = c.Concepto AND Modulo = 'GAS'
WHERE d.ID  = @ID
GROUP BY a.Categoria, m.Concepto, c.PorcentajeDeducible, af.UEN, af.Proyecto
UPDATE Gasto WITH(ROWLOCK) SET AF = 0, AFArticulo = NULL, AFSerie = NULL WHERE ID = @GastoID 
IF EXISTS(SELECT ID FROM #GastoD WHERE Concepto IS NULL)
SELECT @Ok = 10115, @OkRef = Categoria FROM #GastoD WHERE Concepto IS NULL
END
ELSE IF @AFGenerarGastoCfg = 'Movimiento' AND @AFMovGenerarGastoCfg = 'Activo Fijo'
BEGIN
IF @MovTipo IN('AF.DP', 'AF.DT')
INSERT INTO #GastoD(
ID,       Articulo,   Serie,   Concepto,   Cantidad, Precio,              Importe,             Impuestos,        PorcentajeDeducible,   UEN,    Proyecto,    ContUso,        ContUso2,   ContUso3,   Impuesto1,     Impuesto2,     Impuesto3,     Retencion,     Retencion2,     Retencion3)
SELECT @GastoID, a.Articulo, a.Serie, m.Concepto, 1,        SUM(d.Depreciacion), SUM(d.Depreciacion), SUM(d.Impuestos), c.PorcentajeDeducible, af.UEN, af.Proyecto, a.CentroCostos, a.ContUso2, a.ContUso3, Art.Impuesto1, Art.Impuesto2, Art.Impuesto3, Art.Retencion1, Art.Retencion2, Art.Retencion3
FROM ActivoFijoD d WITH(NOLOCK)
JOIN ActivoFijo af WITH(NOLOCK) ON d.ID = af.ID
JOIN ActivoF a WITH(NOLOCK) ON d.Articulo = a.Articulo AND d.Serie = a.Serie
JOIN Art WITH(NOLOCK) ON a.Articulo = Art.Articulo
LEFT OUTER JOIN MovTipoAFConceptoGAS m WITH(NOLOCK) ON a.Articulo = m.Articulo AND a.Serie = m.Serie AND m.Mov = @Mov
LEFT OUTER JOIN Concepto c WITH(NOLOCK) ON m.Concepto = c.Concepto AND Modulo = 'GAS'
WHERE d.ID  = @ID
GROUP BY a.Articulo, a.Serie, m.Concepto, c.PorcentajeDeducible, af.UEN, af.Proyecto, a.CentroCostos, a.ContUso2, a.ContUso3, Art.Impuesto1, Art.Impuesto2, Art.Impuesto3, Art.Retencion1, Art.Retencion2, Art.Retencion3
ELSE
INSERT INTO #GastoD(
ID,       Articulo,   Serie,   Concepto,   Cantidad, Precio,         Importe,        Impuestos,        PorcentajeDeducible,   UEN,    Proyecto,    ContUso,        ContUso2,   ContUso3,   Impuesto1,     Impuesto2,     Impuesto3,     Retencion,     Retencion2,     Retencion3)
SELECT @GastoID, a.Articulo, a.Serie, m.Concepto, 1,        SUM(d.Importe), SUM(d.Importe), SUM(d.Impuestos), c.PorcentajeDeducible, af.UEN, af.Proyecto, a.CentroCostos, a.ContUso2, a.ContUso3, Art.Impuesto1, Art.Impuesto2, Art.Impuesto3, Art.Retencion1, Art.Retencion2, Art.Retencion3
FROM ActivoFijoD d WITH(NOLOCK)
JOIN ActivoFijo af WITH(NOLOCK) ON d.ID = af.ID
JOIN ActivoF a WITH(NOLOCK) ON d.Articulo = a.Articulo AND d.Serie = a.Serie
JOIN Art WITH(NOLOCK) ON a.Articulo = Art.Articulo
LEFT OUTER JOIN MovTipoAFConceptoGAS m WITH(NOLOCK) ON a.Articulo = m.Articulo AND a.Serie = m.Serie AND m.Mov = @Mov
LEFT OUTER JOIN Concepto c WITH(NOLOCK) ON m.Concepto = c.Concepto AND Modulo = 'GAS'
WHERE d.ID  = @ID
GROUP BY a.Articulo, a.Serie, m.Concepto, c.PorcentajeDeducible, af.UEN, af.Proyecto, a.CentroCostos, a.ContUso2, a.ContUso3, Art.Impuesto1, Art.Impuesto2, Art.Impuesto3, Art.Retencion1, Art.Retencion2, Art.Retencion3
UPDATE Gasto WITH(ROWLOCK)
SET Gasto.AF = 1, Gasto.AFArticulo = #GastoD.Articulo, Gasto.AFSerie = #GastoD.Serie
FROM #GastoD
WHERE Gasto.ID = @GastoID
IF EXISTS(SELECT ID FROM #GastoD WHERE Concepto IS NULL)
SELECT @Ok = 10115, @OkRef = RTRIM(Articulo) + ' - ' + RTRIM(Serie) FROM #GastoD WHERE Concepto IS NULL
END
END

