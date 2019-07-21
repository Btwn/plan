SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTipoImpuestoCerrarDia
(
@Fecha	 datetime,
@Ok		 int	      = NULL OUTPUT,
@OkRef	 varchar(255) = NULL OUTPUT
)

AS
BEGIN
DECLARE
@TipoImpuesto		varchar(10),
@Tasa			float,
@Concepto		varchar(50),
@Referencia		varchar(50),
@CodigoFiscal		varchar(50),
@Tipo			varchar(50)
EXEC spExtraerFecha @Fecha OUTPUT
IF @@ERROR <> 0 SET @Ok = 1
DECLARE crTipoImpuesto CURSOR FOR
SELECT ti.Tipo, ti.TipoImpuesto, ISNULL(ti.Tasa,0.0), ISNULL(ti.Referencia,''), ISNULL(ti.CodigoFiscal,''), ISNULL(ti.Concepto,'')
FROM TipoImpuesto ti JOIN TipoImpuestoD tid
ON ti.TipoImpuesto = tid.TipoImpuesto
WHERE tid.FechaD <= @Fecha
AND tid.TieneMovimientos = 0
AND tid.FechaD = (SELECT MAX(TipoImpuestoD.FechaD) FROM TipoImpuestoD WHERE TipoImpuesto = ti.TipoImpuesto AND TipoIMpuestoD.FechaD <= @Fecha)
OPEN crTipoImpuesto
FETCH NEXT FROM crTipoImpuesto INTO @Tipo, @TipoImpuesto, @Tasa, @Referencia, @CodigoFiscal, @Concepto
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF @Tipo = 'Impuesto 1'
BEGIN
UPDATE CompraD SET Impuesto1 = @tasa
FROM CompraD cd LEFT OUTER JOIN Compra c
ON cd.ID = c.ID JOIN  MovTipo mt
ON mt.Modulo = 'COMS' AND mt.Mov = c.Mov
WHERE cd.TipoImpuesto1 = @TipoImpuesto
AND c.Estatus = 'PENDIENTE'
UPDATE VentaD SET Impuesto1 = @tasa
FROM VentaD vd LEFT OUTER JOIN Venta v
ON vd.ID = v.ID JOIN  MovTipo mt
ON mt.Modulo = 'VTAS' AND mt.Mov = v.Mov
WHERE vd.TipoImpuesto1 = @TipoImpuesto
AND v.Estatus = 'PENDIENTE'
UPDATE GastoD SET Impuesto1 = @tasa
FROM GastoD gd LEFT OUTER JOIN Gasto g
ON gd.ID = g.ID JOIN  MovTipo mt
ON mt.Modulo = 'GAS' AND mt.Mov = g.Mov
WHERE gd.TipoImpuesto1 = @TipoImpuesto
AND g.Estatus = 'PENDIENTE'
END
ELSE
IF @Tipo = 'Impuesto 2'
BEGIN
UPDATE CompraD SET Impuesto2 = @tasa
FROM CompraD cd LEFT OUTER JOIN Compra c
ON cd.ID = c.ID JOIN  MovTipo mt
ON mt.Modulo = 'COMS' AND mt.Mov = c.Mov
WHERE cd.TipoImpuesto2 = @TipoImpuesto
AND c.Estatus = 'PENDIENTE'
UPDATE VentaD SET Impuesto2 = @tasa
FROM VentaD vd LEFT OUTER JOIN Venta v
ON vd.ID = v.ID JOIN  MovTipo mt
ON mt.Modulo = 'VTAS' AND mt.Mov = v.Mov
WHERE vd.TipoImpuesto2 = @TipoImpuesto
AND v.Estatus = 'PENDIENTE'
UPDATE GastoD SET Impuesto2 = @tasa
FROM GastoD gd LEFT OUTER JOIN Gasto g
ON gd.ID = g.ID JOIN  MovTipo mt
ON mt.Modulo = 'GAS' AND mt.Mov = g.Mov
WHERE gd.TipoImpuesto2 = @TipoImpuesto
AND g.Estatus = 'PENDIENTE'
END
ELSE
IF @Tipo = 'Impuesto 3'
BEGIN
UPDATE CompraD SET Impuesto3 = @tasa
FROM CompraD cd LEFT OUTER JOIN Compra c
ON cd.ID = c.ID JOIN  MovTipo mt
ON mt.Modulo = 'COMS' AND mt.Mov = c.Mov
WHERE cd.TipoImpuesto3 = @TipoImpuesto
AND c.Estatus = 'PENDIENTE'
UPDATE VentaD SET Impuesto3 = @tasa
FROM VentaD vd LEFT OUTER JOIN Venta v
ON vd.ID = v.ID JOIN  MovTipo mt
ON mt.Modulo = 'VTAS' AND mt.Mov = v.Mov
WHERE vd.TipoImpuesto3 = @TipoImpuesto
AND v.Estatus = 'PENDIENTE'
UPDATE GastoD SET Impuesto3 = @tasa
FROM GastoD gd LEFT OUTER JOIN Gasto g
ON gd.ID = g.ID JOIN  MovTipo mt
ON mt.Modulo = 'GAS' AND mt.Mov = g.Mov
WHERE gd.TipoImpuesto3 = @TipoImpuesto
AND g.Estatus = 'PENDIENTE'
END
FETCH NEXT FROM crTipoImpuesto INTO @Tipo, @TipoImpuesto, @Tasa, @Referencia, @CodigoFiscal, @Concepto
END
CLOSE crTipoImpuesto
DEALLOCATE crTipoImpuesto
IF @Ok IS NULL
BEGIN
UPDATE TipoImpuesto SET
Tasa         = tid.Tasa,
Concepto     = tid.Concepto,
Referencia   = tid.Referencia,
CodigoFiscal = tid.CodigoFiscal
FROM TipoImpuesto ti JOIN TipoImpuestoD tid
ON ti.TipoImpuesto = tid.TipoImpuesto
WHERE tid.FechaD <= @Fecha
AND tid.TieneMovimientos = 0
AND tid.FechaD = (SELECT MAX(TipoImpuestoD.FechaD) FROM TipoImpuestoD WHERE TipoImpuesto = ti.TipoImpuesto AND TipoIMpuestoD.FechaD <= @Fecha)
IF @@ERROR <> 0 SET @Ok = 1
END
END

