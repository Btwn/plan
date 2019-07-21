SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spBPlanGenerarBase
@Empresa		char(5),
@Usuario		char(10),
@Modulo			char(10),
@Ejercicio		int,
@Moneda			char(10)

AS BEGIN
DECLARE
@Sucursal			int,
@UEN				int,
@Ejercicio2			int,
@Periodo			int,
@Articulo			char(20),
@Cantidad			float,
@Personal			char(10),
@Plaza				varchar(20),
@Importe			money,
@Clase				varchar(50),
@SubClase			varchar(50),
@Concepto			varchar(50),
@CentroCostos			varchar(20),
@AlmacenSuc			char(10),
@Inf				money,
@CantidadBase1			float,
@CantidadBase2			float,
@CantidadBase3			float,
@CantidadBase4			float,
@CantidadBase5			float,
@CantidadBase6			float,
@CantidadBase7			float,
@CantidadBase8			float,
@CantidadBase9			float,
@CantidadBase10			float,
@CantidadBase11			float,
@CantidadBase12			float,
@PrecioBase1			money,
@PrecioBase2			money,
@PrecioBase3			money,
@PrecioBase4			money,
@PrecioBase5			money,
@PrecioBase6			money,
@PrecioBase7			money,
@PrecioBase8			money,
@PrecioBase9			money,
@PrecioBase10			money,
@PrecioBase11			money,
@PrecioBase12			money,
@VentaPreciosImpuestoIncluido	bit
SELECT @Ejercicio2 = @Ejercicio + 1
DELETE BPlan WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2
IF @Modulo = 'VTAS'
BEGIN
SELECT @VentaPreciosImpuestoIncluido = VentaPreciosImpuestoIncluido
FROM EmpresaCfg
WHERE Empresa = @Empresa
DECLARE crBPlanGenerarBase CURSOR LOCAL FOR
SELECT e.Sucursal, e.UEN, NULLIF(d.ContUso, ''), DATEPART(month, e.FechaEmision), NULLIF(RTRIM(d.Articulo), ''), SUM(d.Cantidad*mt.Factor),
SUM((1-(ISNULL(e.DescuentoGlobal,0)/100))*(d.Precio*(ISNULL(d.Cantidad,0)*mt.Factor ))*((1-(case d.DescuentoTipo when '$' then (ISNULL(d.DescuentoLinea, 0.0)/d.Precio)*100 else ISNULL(d.DescuentoLinea,0.0) end)/100))/(1.0+((CASE @VentaPreciosImpuestoIncluido WHEN 1 THEN d.Impuesto1 ELSE 0 END)/100.0)))
FROM Venta e, VentaD d, MovTipo mt
WHERE e.ID = d.ID
AND mt.Modulo = 'VTAS' AND mt.Mov = e.Mov
AND mt.Clave IN ('VTAS.F','VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX', 'VTAS.D', 'VTAS.DFC', 'VTAS.EST') AND DATEPART(year, e.FechaEmision) = @Ejercicio
AND e.Empresa = @Empresa AND e.Estatus = 'CONCLUIDO'
AND e.Moneda = @Moneda
GROUP BY e.Sucursal, e.UEN, NULLIF(d.ContUso, ''), DATEPART(month, e.FechaEmision), NULLIF(RTRIM(d.Articulo), '')
ORDER BY e.Sucursal, e.UEN, NULLIF(d.ContUso, ''), DATEPART(month, e.FechaEmision), NULLIF(RTRIM(d.Articulo), '')
OPEN crBPlanGenerarBase
FETCH NEXT FROM crBPlanGenerarBase INTO @Sucursal, @UEN, @CentroCostos, @Periodo, @Articulo, @Cantidad, @Importe
WHILE @@FETCH_STATUS = 0
BEGIN
IF @Periodo = 1  UPDATE BPlan SET CantidadBase1  = ISNULL(CantidadBase1,0)  + @Cantidad, PrecioBase1  = ISNULL(PrecioBase1,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Articulo = @Articulo AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 2  UPDATE BPlan SET CantidadBase2  = ISNULL(CantidadBase2,0)  + @Cantidad, PrecioBase2  = ISNULL(PrecioBase2,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Articulo = @Articulo AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 3  UPDATE BPlan SET CantidadBase3  = ISNULL(CantidadBase3,0)  + @Cantidad, PrecioBase3  = ISNULL(PrecioBase3,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Articulo = @Articulo AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 4  UPDATE BPlan SET CantidadBase4  = ISNULL(CantidadBase4,0)  + @Cantidad, PrecioBase4  = ISNULL(PrecioBase4,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Articulo = @Articulo AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 5  UPDATE BPlan SET CantidadBase5  = ISNULL(CantidadBase5,0)  + @Cantidad, PrecioBase5  = ISNULL(PrecioBase5,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Articulo = @Articulo AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 6  UPDATE BPlan SET CantidadBase6  = ISNULL(CantidadBase6,0)  + @Cantidad, PrecioBase6  = ISNULL(PrecioBase6,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Articulo = @Articulo AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 7  UPDATE BPlan SET CantidadBase7  = ISNULL(CantidadBase7,0)  + @Cantidad, PrecioBase7  = ISNULL(PrecioBase7,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Articulo = @Articulo AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 8  UPDATE BPlan SET CantidadBase8  = ISNULL(CantidadBase8,0)  + @Cantidad, PrecioBase8  = ISNULL(PrecioBase8,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Articulo = @Articulo AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 9  UPDATE BPlan SET CantidadBase9  = ISNULL(CantidadBase9,0)  + @Cantidad, PrecioBase9  = ISNULL(PrecioBase9,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Articulo = @Articulo AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 10 UPDATE BPlan SET CantidadBase10 = ISNULL(CantidadBase10,0) + @Cantidad, PrecioBase10 = ISNULL(PrecioBase10,0) + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Articulo = @Articulo AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 11 UPDATE BPlan SET CantidadBase11 = ISNULL(CantidadBase11,0) + @Cantidad, PrecioBase11 = ISNULL(PrecioBase11,0) + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Articulo = @Articulo AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 12 UPDATE BPlan SET CantidadBase12 = ISNULL(CantidadBase12,0) + @Cantidad, PrecioBase12 = ISNULL(PrecioBase12,0) + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Articulo = @Articulo AND CentroCostos = @CentroCostos
IF @@ROWCOUNT = 0
BEGIN
IF @Periodo = 1  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Articulo, CentroCostos, Usuario, CantidadBase1,  PrecioBase1)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Articulo, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad) ELSE
IF @Periodo = 2  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Articulo, CentroCostos, Usuario, CantidadBase2,  PrecioBase2)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Articulo, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad) ELSE
IF @Periodo = 3  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Articulo, CentroCostos, Usuario, CantidadBase3,  PrecioBase3)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Articulo, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad) ELSE
IF @Periodo = 4  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Articulo, CentroCostos, Usuario, CantidadBase4,  PrecioBase4)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Articulo, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad) ELSE
IF @Periodo = 5  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Articulo, CentroCostos, Usuario, CantidadBase5,  PrecioBase5)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Articulo, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad) ELSE
IF @Periodo = 6  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Articulo, CentroCostos, Usuario, CantidadBase6,  PrecioBase6)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Articulo, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad) ELSE
IF @Periodo = 7  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Articulo, CentroCostos, Usuario, CantidadBase7,  PrecioBase7)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Articulo, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad) ELSE
IF @Periodo = 8  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Articulo, CentroCostos, Usuario, CantidadBase8,  PrecioBase8)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Articulo, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad) ELSE
IF @Periodo = 9  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Articulo, CentroCostos, Usuario, CantidadBase9,  PrecioBase9)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Articulo, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad) ELSE
IF @Periodo = 10 INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Articulo, CentroCostos, Usuario, CantidadBase10, PrecioBase10) VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Articulo, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad) ELSE
IF @Periodo = 11 INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Articulo, CentroCostos, Usuario, CantidadBase11, PrecioBase11) VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Articulo, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad) ELSE
IF @Periodo = 12 INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Articulo, CentroCostos, Usuario, CantidadBase12, PrecioBase12) VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Articulo, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad)
END
FETCH NEXT FROM crBPlanGenerarBase INTO @Sucursal, @UEN, @CentroCostos, @Periodo, @Articulo, @Cantidad, @Importe
END
CLOSE crBPlanGenerarBase
DEALLOCATE crBPlanGenerarBase
SELECT 'Base del ' + Convert(varchar(4), @Ejercicio) + ' del Módulo de Ventas Generada.'
END
ELSE
IF @Modulo = 'COMS'
BEGIN
DECLARE crBPlanGenerarBase CURSOR LOCAL FOR
SELECT e.Sucursal, e.UEN, NULLIF(d.ContUso, ''), DATEPART(month, e.FechaEmision), NULLIF(RTRIM(d.Articulo), ''), SUM(d.Cantidad*mt.Factor),
SUM((1-(ISNULL(e.DescuentoGlobal,0)/100))*(d.Costo*(ISNULL(d.Cantidad,0)*mt.Factor ))*((1-(case d.DescuentoTipo when '$' then (ISNULL(d.DescuentoLinea, 0.0)/d.Costo)*100 else ISNULL(d.DescuentoLinea,0.0) end)/100)))
FROM Compra e, CompraD d, MovTipo mt
WHERE e.ID = d.ID
AND mt.Modulo = 'COMS' AND mt.Mov = e.Mov
AND mt.Clave IN ('COMS.FL', 'COMS.D', 'COMS.F', 'COMS.EG', 'COMS.EI', 'COMS.EST') AND DATEPART(year, e.FechaEmision) = @Ejercicio
AND e.Empresa = @Empresa AND e.Estatus = 'CONCLUIDO'
AND e.Moneda = @Moneda
GROUP BY e.Sucursal, e.UEN, NULLIF(d.ContUso, ''), DATEPART(month, e.FechaEmision), NULLIF(RTRIM(d.Articulo), '')
ORDER BY e.Sucursal, e.UEN, NULLIF(d.ContUso, ''), DATEPART(month, e.FechaEmision), NULLIF(RTRIM(d.Articulo), '')
OPEN crBPlanGenerarBase
FETCH NEXT FROM crBPlanGenerarBase INTO @Sucursal, @UEN, @CentroCostos, @Periodo, @Articulo, @Cantidad, @Importe
WHILE @@FETCH_STATUS = 0
BEGIN
IF @Periodo = 1  UPDATE BPlan SET CantidadBase1  = ISNULL(CantidadBase1,0)  + @Cantidad, PrecioBase1  = ISNULL(PrecioBase1,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Articulo = @Articulo AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 2  UPDATE BPlan SET CantidadBase2  = ISNULL(CantidadBase2,0)  + @Cantidad, PrecioBase2  = ISNULL(PrecioBase2,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Articulo = @Articulo AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 3  UPDATE BPlan SET CantidadBase3  = ISNULL(CantidadBase3,0)  + @Cantidad, PrecioBase3  = ISNULL(PrecioBase3,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Articulo = @Articulo AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 4  UPDATE BPlan SET CantidadBase4  = ISNULL(CantidadBase4,0)  + @Cantidad, PrecioBase4  = ISNULL(PrecioBase4,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Articulo = @Articulo AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 5  UPDATE BPlan SET CantidadBase5  = ISNULL(CantidadBase5,0)  + @Cantidad, PrecioBase5  = ISNULL(PrecioBase5,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Articulo = @Articulo AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 6  UPDATE BPlan SET CantidadBase6  = ISNULL(CantidadBase6,0)  + @Cantidad, PrecioBase6  = ISNULL(PrecioBase6,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Articulo = @Articulo AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 7  UPDATE BPlan SET CantidadBase7  = ISNULL(CantidadBase7,0)  + @Cantidad, PrecioBase7  = ISNULL(PrecioBase7,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Articulo = @Articulo AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 8  UPDATE BPlan SET CantidadBase8  = ISNULL(CantidadBase8,0)  + @Cantidad, PrecioBase8  = ISNULL(PrecioBase8,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Articulo = @Articulo AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 9  UPDATE BPlan SET CantidadBase9  = ISNULL(CantidadBase9,0)  + @Cantidad, PrecioBase9  = ISNULL(PrecioBase9,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Articulo = @Articulo AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 10 UPDATE BPlan SET CantidadBase10 = ISNULL(CantidadBase10,0) + @Cantidad, PrecioBase10 = ISNULL(PrecioBase10,0) + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Articulo = @Articulo AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 11 UPDATE BPlan SET CantidadBase11 = ISNULL(CantidadBase11,0) + @Cantidad, PrecioBase11 = ISNULL(PrecioBase11,0) + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Articulo = @Articulo AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 12 UPDATE BPlan SET CantidadBase12 = ISNULL(CantidadBase12,0) + @Cantidad, PrecioBase12 = ISNULL(PrecioBase12,0) + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Articulo = @Articulo AND CentroCostos = @CentroCostos
IF @@ROWCOUNT = 0
BEGIN
IF @Periodo = 1  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Articulo, CentroCostos, Usuario, CantidadBase1,  PrecioBase1)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Articulo, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad) ELSE
IF @Periodo = 2  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Articulo, CentroCostos, Usuario, CantidadBase2,  PrecioBase2)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Articulo, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad) ELSE
IF @Periodo = 3  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Articulo, CentroCostos, Usuario, CantidadBase3,  PrecioBase3)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Articulo, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad) ELSE
IF @Periodo = 4  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Articulo, CentroCostos, Usuario, CantidadBase4,  PrecioBase4)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Articulo, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad) ELSE
IF @Periodo = 5  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Articulo, CentroCostos, Usuario, CantidadBase5,  PrecioBase5)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Articulo, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad) ELSE
IF @Periodo = 6  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Articulo, CentroCostos, Usuario, CantidadBase6,  PrecioBase6)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Articulo, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad) ELSE
IF @Periodo = 7  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Articulo, CentroCostos, Usuario, CantidadBase7,  PrecioBase7)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Articulo, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad) ELSE
IF @Periodo = 8  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Articulo, CentroCostos, Usuario, CantidadBase8,  PrecioBase8)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Articulo, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad) ELSE
IF @Periodo = 9  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Articulo, CentroCostos, Usuario, CantidadBase9,  PrecioBase9)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Articulo, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad) ELSE
IF @Periodo = 10 INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Articulo, CentroCostos, Usuario, CantidadBase10, PrecioBase10) VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Articulo, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad) ELSE
IF @Periodo = 11 INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Articulo, CentroCostos, Usuario, CantidadBase11, PrecioBase11) VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Articulo, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad) ELSE
IF @Periodo = 12 INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Articulo, CentroCostos, Usuario, CantidadBase12, PrecioBase12) VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Articulo, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad)
END
FETCH NEXT FROM crBPlanGenerarBase INTO @Sucursal, @UEN, @CentroCostos, @Periodo, @Articulo, @Cantidad, @Importe
END
CLOSE crBPlanGenerarBase
DEALLOCATE crBPlanGenerarBase
SELECT 'Base del ' + Convert(varchar(4), @Ejercicio) + ' del Módulo de Compras Generada.'
END
ELSE
IF @Modulo = 'GAS'
BEGIN
DECLARE crBPlanGenerarBase CURSOR LOCAL FOR
SELECT g.Sucursal, g.UEN, DATEPART(month, g.FechaEmision), c.Clase, c.SubClase, d.Concepto, NULLIF(RTRIM(d.ContUso),''), ISNULL(InflacionPresupuesto,0), SUM(d.Cantidad*m.Factor), SUM(d.Importe*m.Factor)
FROM Gasto g, GastoD d, MovTipo m, Concepto c
WHERE g.ID = d.ID
AND d.Concepto = c.Concepto
AND g.Mov = m.Mov AND m.Modulo = 'GAS' AND m.Clave in ('GAS.C', 'GAS.DC', 'GAS.DG', 'GAS.EST', 'GAS.CI', 'GAS.G', 'GAS.GTC')
AND g.Empresa = @Empresa AND g.Estatus = 'CONCLUIDO'
AND DATEPART(year, g.FechaEmision) = @Ejercicio
AND c.Modulo = 'GAS' 
AND ISNULL(d.Importe,0) <> 0
AND g.Moneda = @Moneda
GROUP BY g.Sucursal, g.UEN, DATEPART(month, g.FechaEmision), c.Clase, c.SubClase, d.Concepto, NULLIF(RTRIM(d.ContUso),''), ISNULL(InflacionPresupuesto,0)
ORDER BY g.Sucursal, g.UEN, c.Clase, c.SubClase, d.Concepto, NULLIF(RTRIM(d.ContUso),'')
OPEN crBPlanGenerarBase
FETCH NEXT FROM crBPlanGenerarBase INTO @Sucursal, @UEN, @Periodo, @Clase, @SubClase, @Concepto, @CentroCostos, @Inf, @Cantidad, @Importe
WHILE @@FETCH_STATUS = 0
BEGIN
IF @Periodo = 1  UPDATE BPlan SET CantidadBase1  = ISNULL(CantidadBase1,0)  + @Cantidad, PrecioBase1  = ISNULL(PrecioBase1,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Clase = @Clase AND SubClase = @SubClase AND Concepto = @Concepto AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 2  UPDATE BPlan SET CantidadBase2  = ISNULL(CantidadBase2,0)  + @Cantidad, PrecioBase2  = ISNULL(PrecioBase2,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Clase = @Clase AND SubClase = @SubClase AND Concepto = @Concepto AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 3  UPDATE BPlan SET CantidadBase3  = ISNULL(CantidadBase3,0)  + @Cantidad, PrecioBase3  = ISNULL(PrecioBase3,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Clase = @Clase AND SubClase = @SubClase AND Concepto = @Concepto AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 4  UPDATE BPlan SET CantidadBase4  = ISNULL(CantidadBase4,0)  + @Cantidad, PrecioBase4  = ISNULL(PrecioBase4,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Clase = @Clase AND SubClase = @SubClase AND Concepto = @Concepto AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 5  UPDATE BPlan SET CantidadBase5  = ISNULL(CantidadBase5,0)  + @Cantidad, PrecioBase5  = ISNULL(PrecioBase5,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Clase = @Clase AND SubClase = @SubClase AND Concepto = @Concepto AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 6  UPDATE BPlan SET CantidadBase6  = ISNULL(CantidadBase6,0)  + @Cantidad, PrecioBase6  = ISNULL(PrecioBase6,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Clase = @Clase AND SubClase = @SubClase AND Concepto = @Concepto AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 7  UPDATE BPlan SET CantidadBase7  = ISNULL(CantidadBase7,0)  + @Cantidad, PrecioBase7  = ISNULL(PrecioBase7,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Clase = @Clase AND SubClase = @SubClase AND Concepto = @Concepto AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 8  UPDATE BPlan SET CantidadBase8  = ISNULL(CantidadBase8,0)  + @Cantidad, PrecioBase8  = ISNULL(PrecioBase8,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Clase = @Clase AND SubClase = @SubClase AND Concepto = @Concepto AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 9  UPDATE BPlan SET CantidadBase9  = ISNULL(CantidadBase9,0)  + @Cantidad, PrecioBase9  = ISNULL(PrecioBase9,0)  + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Clase = @Clase AND SubClase = @SubClase AND Concepto = @Concepto AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 10 UPDATE BPlan SET CantidadBase10 = ISNULL(CantidadBase10,0) + @Cantidad, PrecioBase10 = ISNULL(PrecioBase10,0) + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Clase = @Clase AND SubClase = @SubClase AND Concepto = @Concepto AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 11 UPDATE BPlan SET CantidadBase11 = ISNULL(CantidadBase11,0) + @Cantidad, PrecioBase11 = ISNULL(PrecioBase11,0) + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Clase = @Clase AND SubClase = @SubClase AND Concepto = @Concepto AND CentroCostos = @CentroCostos ELSE
IF @Periodo = 12 UPDATE BPlan SET CantidadBase12 = ISNULL(CantidadBase12,0) + @Cantidad, PrecioBase12 = ISNULL(PrecioBase12,0) + @Importe/@Cantidad WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Clase = @Clase AND SubClase = @SubClase AND Concepto = @Concepto AND CentroCostos = @CentroCostos
IF @@ROWCOUNT = 0
BEGIN
IF @Periodo = 1  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Clase, SubClase, Concepto, CentroCostos, Usuario, CantidadBase1,  PrecioBase1,  Inf) VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Clase, @SubClase, @Concepto, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad, @Inf) ELSE
IF @Periodo = 2  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Clase, SubClase, Concepto, CentroCostos, Usuario, CantidadBase2,  PrecioBase2,  Inf) VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Clase, @SubClase, @Concepto, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad, @Inf) ELSE
IF @Periodo = 3  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Clase, SubClase, Concepto, CentroCostos, Usuario, CantidadBase3,  PrecioBase3,  Inf) VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Clase, @SubClase, @Concepto, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad, @Inf) ELSE
IF @Periodo = 4  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Clase, SubClase, Concepto, CentroCostos, Usuario, CantidadBase4,  PrecioBase4,  Inf) VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Clase, @SubClase, @Concepto, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad, @Inf) ELSE
IF @Periodo = 5  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Clase, SubClase, Concepto, CentroCostos, Usuario, CantidadBase5,  PrecioBase5,  Inf) VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Clase, @SubClase, @Concepto, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad, @Inf) ELSE
IF @Periodo = 6  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Clase, SubClase, Concepto, CentroCostos, Usuario, CantidadBase6,  PrecioBase6,  Inf) VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Clase, @SubClase, @Concepto, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad, @Inf) ELSE
IF @Periodo = 7  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Clase, SubClase, Concepto, CentroCostos, Usuario, CantidadBase7,  PrecioBase7,  Inf) VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Clase, @SubClase, @Concepto, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad, @Inf) ELSE
IF @Periodo = 8  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Clase, SubClase, Concepto, CentroCostos, Usuario, CantidadBase8,  PrecioBase8,  Inf) VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Clase, @SubClase, @Concepto, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad, @Inf) ELSE
IF @Periodo = 9  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Clase, SubClase, Concepto, CentroCostos, Usuario, CantidadBase9,  PrecioBase9,  Inf) VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Clase, @SubClase, @Concepto, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad, @Inf) ELSE
IF @Periodo = 10 INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Clase, SubClase, Concepto, CentroCostos, Usuario, CantidadBase10, PrecioBase10, Inf) VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Clase, @SubClase, @Concepto, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad, @Inf) ELSE
IF @Periodo = 11 INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Clase, SubClase, Concepto, CentroCostos, Usuario, CantidadBase11, PrecioBase11, Inf) VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Clase, @SubClase, @Concepto, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad, @Inf) ELSE
IF @Periodo = 12 INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Clase, SubClase, Concepto, CentroCostos, Usuario, CantidadBase12, PrecioBase12, Inf) VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Clase, @SubClase, @Concepto, @CentroCostos, @Usuario, @Cantidad, @Importe/@Cantidad, @Inf)
END
FETCH NEXT FROM crBPlanGenerarBase INTO @Sucursal, @UEN, @Periodo, @Clase, @SubClase, @Concepto, @CentroCostos, @Inf, @Cantidad, @Importe
END
CLOSE crBPlanGenerarBase
DEALLOCATE crBPlanGenerarBase
SELECT 'Base del ' + Convert(varchar(4), @Ejercicio) + ' del Módulo de Gastos Generada.'
END
ELSE
IF @Modulo = 'NOM'
BEGIN
DECLARE crBPlanGenerarBase CURSOR LOCAL FOR
SELECT p.SucursalTrabajo, p.UEN, DATEPART(month, n.FechaEmision), NULLIF(p.Plaza,''), p.Personal, d.Concepto, 'Importe' = SUM(CASE d.Movimiento WHEN 'Deduccion' THEN -d.Importe ELSE d.Importe END)
FROM Nomina n, NominaD d, MovTipo m, Personal p
WHERE n.ID = d.ID
AND n.Mov = m.Mov AND m.Modulo = 'NOM' AND m.Clave = 'NOM.N'
AND d.Personal = p.Personal
AND n.Empresa = @Empresa
AND DATEPART(year, n.FechaEmision) = @Ejercicio
AND n.Estatus = 'CONCLUIDO'
AND d.Movimiento in ('Percepcion', 'Deduccion')
AND n.Moneda = @Moneda
GROUP BY p.SucursalTrabajo, p.UEN, DATEPART(month, n.FechaEmision), NULLIF(p.Plaza,''), p.Personal, d.Concepto
ORDER BY p.SucursalTrabajo, NULLIF(p.Plaza,''), p.Personal, d.Concepto
OPEN crBPlanGenerarBase
FETCH NEXT FROM crBPlanGenerarBase INTO @Sucursal, @UEN, @Periodo, @Plaza, @Personal, @Concepto, @Importe
WHILE @@FETCH_STATUS = 0
BEGIN
IF @Periodo = 1   UPDATE BPlan SET CantidadBase1  = 1,  PrecioBase1  = ISNULL(PrecioBase1,0)  + @Importe WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Plaza = @Plaza AND Personal = @Personal AND Concepto = @Concepto ELSE
IF @Periodo = 2   UPDATE BPlan SET CantidadBase2  = 1,  PrecioBase2  = ISNULL(PrecioBase2,0)  + @Importe WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Plaza = @Plaza AND Personal = @Personal AND Concepto = @Concepto ELSE
IF @Periodo = 3   UPDATE BPlan SET CantidadBase3  = 1,  PrecioBase3  = ISNULL(PrecioBase3,0)  + @Importe WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Plaza = @Plaza AND Personal = @Personal AND Concepto = @Concepto ELSE
IF @Periodo = 4   UPDATE BPlan SET CantidadBase4  = 1,  PrecioBase4  = ISNULL(PrecioBase4,0)  + @Importe WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Plaza = @Plaza AND Personal = @Personal AND Concepto = @Concepto ELSE
IF @Periodo = 5   UPDATE BPlan SET CantidadBase5  = 1,  PrecioBase5  = ISNULL(PrecioBase5,0)  + @Importe WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Plaza = @Plaza AND Personal = @Personal AND Concepto = @Concepto ELSE
IF @Periodo = 6   UPDATE BPlan SET CantidadBase6  = 1,  PrecioBase6  = ISNULL(PrecioBase6,0)  + @Importe WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Plaza = @Plaza AND Personal = @Personal AND Concepto = @Concepto ELSE
IF @Periodo = 7   UPDATE BPlan SET CantidadBase7  = 1,  PrecioBase7  = ISNULL(PrecioBase7,0)  + @Importe WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Plaza = @Plaza AND Personal = @Personal AND Concepto = @Concepto ELSE
IF @Periodo = 8   UPDATE BPlan SET CantidadBase8  = 1,  PrecioBase8  = ISNULL(PrecioBase8,0)  + @Importe WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Plaza = @Plaza AND Personal = @Personal AND Concepto = @Concepto ELSE
IF @Periodo = 9   UPDATE BPlan SET CantidadBase9  = 1,  PrecioBase9  = ISNULL(PrecioBase9,0)  + @Importe WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Plaza = @Plaza AND Personal = @Personal AND Concepto = @Concepto ELSE
IF @Periodo = 10  UPDATE BPlan SET CantidadBase10 = 1, PrecioBase10 = ISNULL(PrecioBase10,0) + @Importe WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Plaza = @Plaza AND Personal = @Personal AND Concepto = @Concepto ELSE
IF @Periodo = 11  UPDATE BPlan SET CantidadBase11 = 1, PrecioBase11 = ISNULL(PrecioBase11,0) + @Importe WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Plaza = @Plaza AND Personal = @Personal AND Concepto = @Concepto ELSE
IF @Periodo = 12  UPDATE BPlan SET CantidadBase12 = 1, PrecioBase12 = ISNULL(PrecioBase12,0) + @Importe WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio2 AND Sucursal = @Sucursal AND UEN = @UEN AND Moneda = @Moneda AND Plaza = @Plaza AND Personal = @Personal AND Concepto = @Concepto
IF @@ROWCOUNT = 0
BEGIN
IF @Periodo = 1   INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Plaza, Personal, Concepto, Usuario, CantidadBase1,  PrecioBase1)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Plaza, @Personal, @Concepto, @Usuario, 1, @Importe) ELSE
IF @Periodo = 2   INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Plaza, Personal, Concepto, Usuario, CantidadBase2,  PrecioBase2)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Plaza, @Personal, @Concepto, @Usuario, 1, @Importe) ELSE
IF @Periodo = 3   INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Plaza, Personal, Concepto, Usuario, CantidadBase3,  PrecioBase3)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Plaza, @Personal, @Concepto, @Usuario, 1, @Importe) ELSE
IF @Periodo = 4   INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Plaza, Personal, Concepto, Usuario, CantidadBase4,  PrecioBase4)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Plaza, @Personal, @Concepto, @Usuario, 1, @Importe) ELSE
IF @Periodo = 5   INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Plaza, Personal, Concepto, Usuario, CantidadBase5,  PrecioBase5)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Plaza, @Personal, @Concepto, @Usuario, 1, @Importe) ELSE
IF @Periodo = 6   INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Plaza, Personal, Concepto, Usuario, CantidadBase6,  PrecioBase6)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Plaza, @Personal, @Concepto, @Usuario, 1, @Importe) ELSE
IF @Periodo = 7   INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Plaza, Personal, Concepto, Usuario, CantidadBase7,  PrecioBase7)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Plaza, @Personal, @Concepto, @Usuario, 1, @Importe) ELSE
IF @Periodo = 8   INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Plaza, Personal, Concepto, Usuario, CantidadBase8,  PrecioBase8)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Plaza, @Personal, @Concepto, @Usuario, 1, @Importe) ELSE
IF @Periodo = 9   INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Plaza, Personal, Concepto, Usuario, CantidadBase9,  PrecioBase9)  VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Plaza, @Personal, @Concepto, @Usuario, 1, @Importe) ELSE
IF @Periodo = 10  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Plaza, Personal, Concepto, Usuario, CantidadBase10, PrecioBase10) VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Plaza, @Personal, @Concepto, @Usuario, 1, @Importe) ELSE
IF @Periodo = 11  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Plaza, Personal, Concepto, Usuario, CantidadBase11, PrecioBase11) VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Plaza, @Personal, @Concepto, @Usuario, 1, @Importe) ELSE
IF @Periodo = 12  INSERT INTO BPlan(Modulo, Empresa, Ejercicio, Sucursal, UEN, Moneda, Plaza, Personal, Concepto, Usuario, CantidadBase12, PrecioBase12) VALUES(@Modulo, @Empresa, @Ejercicio2, @Sucursal, @UEN, @Moneda, @Plaza, @Personal, @Concepto, @Usuario, 1, @Importe)
END
FETCH NEXT FROM crBPlanGenerarBase INTO @Sucursal, @UEN, @Periodo, @Plaza, @Personal, @Concepto, @Importe
END
CLOSE crBPlanGenerarBase
DEALLOCATE crBPlanGenerarBase
SELECT 'Base del ' + Convert(varchar(4), @Ejercicio) + ' del Módulo de Nomina Generada.'
END
RETURN
END

