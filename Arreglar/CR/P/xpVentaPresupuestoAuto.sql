SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpVentaPresupuestoAuto
@Empresa	char(5),
@Ejercicio	int,
@PeriodoD	int,
@PeriodoA	int,
@Usuario	char(10)
AS
BEGIN
DECLARE
@ID					int,
@Mov				char(20),
@Periodo				int,
@FechaBase				char(11),
@FechaEmision			datetime,
@Almacen				char(10),
@Articulo				char(20),
@SubCuenta				char(20),
@Moneda				char(10),
@Categoria				char(50),
@Grupo				char(50),
@TipoCambio				float,
@Cantidad				float,
@Importe				money,
@CentroCostos			char(20),
@Impuesto1				float,
@Impuesto2				float,
@Impuesto3				float,
@Inflacion				money,
@InflacionGrupo			money,
@Contador				int,
@Renglon				float,
@Sucursal				int,
@VentaPreciosImpuestoIncluido	bit
CREATE TABLE #VentaPresupuestoAuto(
Categoria		char(50)	COLLATE Database_Default NULL,
Grupo			char(50)	COLLATE Database_Default NULL,
Periodo		int		NULL,
Sucursal		int		NULL,
Almacen		char(10)	COLLATE Database_Default NULL,
Articulo		char(20)	COLLATE Database_Default NULL,
SubCuenta		char(20)	COLLATE Database_Default NULL,
Moneda		char(10)	COLLATE Database_Default NULL,
Cantidad		float		NULL,
Importe		money		NULL,
ContUso		char(20)	COLLATE Database_Default NULL,
Impuesto1		money		NULL,
Impuesto2		money		NULL,
Impuesto3		money		NULL,
Inflacion		float		NULL)
SELECT @Renglon = 1024
SELECT @Mov = VentaPresupuesto
FROM EmpresaCfgMov WHERE Empresa = @Empresa
SELECT @VentaPreciosImpuestoIncluido = VentaPreciosImpuestoIncluido
FROM EmpresaCfg
WHERE Empresa = @Empresa
/*
IF Exists(SELECT * FROM Venta e, MovTipo m WHERE e.Mov = m.Mov AND m.Modulo = 'VTAS' AND m.Clave = 'VTAS.PR'
AND e.Empresa = @Empresa AND e.Estatus in ('SINAFECTAR', 'CONCLUIDO', 'CONFIRMAR')
AND DATEPART(month, e.FechaEmision) = @Periodo AND DATEPART(year, e.FechaEmision) = @Ejercicio)
BEGIN
SELECT 'Ya Existen Presupuestos en la Empresa en el Periodo y Ejercicio'
RETURN
END
*/
BEGIN TRANSACTION
SELECT @FechaBase = '1/1/' + RTRIM(@Ejercicio)
IF NOT EXISTS(SELECT * FROM Cte WHERE Cliente = 'PRESUP')
INSERT INTO Cte(Cliente, Nombre, Estatus, Tipo)
VALUES('PRESUP', 'Presupuesto', 'ALTA', 'Provision')
INSERT INTO #VentaPresupuestoAuto(Categoria, Grupo, Periodo, Sucursal, Almacen,             Articulo,          SubCuenta,        Moneda, Cantidad, 		  Importe, 																																			ContUso, Impuesto1, Impuesto2, Impuesto3, Inflacion)
SELECT a.Categoria, a.Grupo, DATEPART(month, e.FechaEmision), e.SucursalVenta, d.Almacen, d.Articulo, ISNULL(d.SubCuenta, ''), e.Moneda, SUM(d.Cantidad*m.Factor), SUM((1-(ISNULL(e.DescuentoGlobal,0)/100))*(d.Precio*(d.Cantidad))*((1-(case d.DescuentoTipo when '$' then (ISNULL(d.DescuentoLinea, 0.0)/d.Precio)*100 else ISNULL(d.DescuentoLinea,0.0) end)/100))/(1.0+((CASE @VentaPreciosImpuestoIncluido WHEN 1 THEN d.Impuesto1 ELSE 0 END)/100.0))), d.ContUso, a.Impuesto1, a.Impuesto2, a.Impuesto3, ISNULL(a.InflacionPresupuesto, '')
FROM Venta e, VentaD d, Art a, MovTipo m
WHERE e.ID = d.ID
AND d.Articulo = a.Articulo
AND e.Mov = m.Mov AND m.Modulo = 'VTAS' AND m.Clave in ('VTAS.F','VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX', 'VTAS.D', 'VTAS.DFC')
AND e.Empresa = @Empresa
AND e.Estatus = 'CONCLUIDO'
AND DATEPART(year, e.FechaEmision) = @Ejercicio - 1 AND DATEPART(month, e.FechaEmision) BETWEEN @PeriodoD AND @PeriodoA
AND a.CalcularPresupuesto = 1
GROUP BY a.Categoria, a.Grupo, DATEPART(month, e.FechaEmision), e.SucursalVenta, d.Almacen, d.Articulo, ISNULL(d.SubCuenta, ''), e.Moneda, d.ContUso, a.Impuesto1, a.Impuesto2, a.Impuesto3, ISNULL(a.InflacionPresupuesto, '')
SELECT @Contador = 0
DECLARE crVentaPresupuestoAuto CURSOR STATIC FOR
SELECT DISTINCT Moneda, Periodo, Sucursal, Almacen, /*Categoria, */Grupo
FROM #VentaPresupuestoAuto
OPEN crVentaPresupuestoAuto
FETCH NEXT FROM crVentaPresupuestoAuto INTO @Moneda, @Periodo, @Sucursal, @Almacen, /*@Categoria, */@Grupo
WHILE @@FETCH_STATUS = 0 AND @@ERROR = 0
BEGIN
IF @Periodo = 1  SELECT @FechaEmision = Convert(datetime, @FechaBase, 103) ELSE
IF @Periodo = 2  SELECT @FechaEmision = DATEADD(month, 1,  Convert(datetime, @FechaBase, 103)) ELSE
IF @Periodo = 3  SELECT @FechaEmision = DATEADD(month, 2,  Convert(datetime, @FechaBase, 103)) ELSE
IF @Periodo = 4  SELECT @FechaEmision = DATEADD(month, 3,  Convert(datetime, @FechaBase, 103)) ELSE
IF @Periodo = 5  SELECT @FechaEmision = DATEADD(month, 4,  Convert(datetime, @FechaBase, 103)) ELSE
IF @Periodo = 6  SELECT @FechaEmision = DATEADD(month, 5,  Convert(datetime, @FechaBase, 103)) ELSE
IF @Periodo = 7  SELECT @FechaEmision = DATEADD(month, 6,  Convert(datetime, @FechaBase, 103)) ELSE
IF @Periodo = 8  SELECT @FechaEmision = DATEADD(month, 7,  Convert(datetime, @FechaBase, 103)) ELSE
IF @Periodo = 9  SELECT @FechaEmision = DATEADD(month, 8,  Convert(datetime, @FechaBase, 103)) ELSE
IF @Periodo = 10 SELECT @FechaEmision = DATEADD(month, 9,  Convert(datetime, @FechaBase, 103)) ELSE
IF @Periodo = 11 SELECT @FechaEmision = DATEADD(month, 10, Convert(datetime, @FechaBase, 103)) ELSE
IF @Periodo = 12 SELECT @FechaEmision = DATEADD(month, 11, Convert(datetime, @FechaBase, 103))
SELECT @TipoCambio = TipoCambio FROM Mon WHERE Moneda = @Moneda
INSERT INTO Venta(Empresa,  Mov,  FechaEmision,  Moneda,  TipoCambio,  Almacen, Usuario,  Estatus,     Cliente,  Referencia, 						SucursalVenta)
VALUES(@Empresa, @Mov, @FechaEmision, @Moneda, @TipoCambio, @Almacen, @Usuario, 'CONFIRMAR', 'PRESUP', 'Grupo: ' + RTRIM(@Grupo), @Sucursal)
SELECT @ID = SCOPE_IDENTITY()
DECLARE crVentaPresupuestoAuto2 CURSOR LOCAL FOR
SELECT v.Articulo, ISNULL(v.SubCuenta, ''), SUM(v.Cantidad), SUM(v.Importe), v.ContUso, v.Impuesto1, v.Impuesto2, v.Impuesto3, v.Inflacion
FROM #VentaPresupuestoAuto v
LEFT OUTER JOIN ArtGrupo g ON v.Grupo = g.Grupo
WHERE V.Moneda = @Moneda
AND v.Grupo = @Grupo
AND v.Periodo = @Periodo
AND v.Sucursal = @Sucursal
AND v.Almacen = @Almacen
GROUP BY v.Articulo, ISNULL(v.SubCuenta, ''), v.ContUso, v.Impuesto1, v.Impuesto2, v.Impuesto3, v.Inflacion
OPEN crVentaPresupuestoAuto2
FETCH NEXT FROM crVentaPresupuestoAuto2 INTO @Articulo, @SubCuenta, @Cantidad, @Importe, @CentroCostos, @Impuesto1, @Impuesto2, @Impuesto3, @Inflacion
WHILE @@FETCH_STATUS = 0 AND @@ERROR = 0
BEGIN
IF ISNULL(@Inflacion,0) = 0 AND ISNULL(@Grupo,'') <> ''
BEGIN
SELECT @InflacionGrupo = InflacionPresupuesto FROM ArtGrupo WHERE Grupo = @Grupo
IF ISNULL(@InflacionGrupo,0) <> 0
SELECT @Inflacion = @InflacionGrupo
END
SELECT @Importe = @Importe*(1+(ISNULL(@Inflacion,0)/100))
INSERT INTO VentaD(ID,  Renglon,  Almacen, Articulo, SubCuenta,               Cantidad, Precio,             Impuesto1, Impuesto2, Impuesto3, Contuso)
VALUES(@ID, @Renglon, @Almacen, @Articulo, ISNULL(@SubCuenta, ''), @Cantidad, @Importe/@Cantidad, @Impuesto1, @Impuesto2, @Impuesto3, @CentroCostos)
SELECT @Renglon = @Renglon + 1024, @Contador = @Contador + 1
FETCH NEXT FROM crVentaPresupuestoAuto2 INTO @Articulo, @SubCuenta, @Cantidad, @Importe, @CentroCostos, @Impuesto1, @Impuesto2, @Impuesto3, @Inflacion
END
CLOSE crVentaPresupuestoAuto2
DEALLOCATE crVentaPresupuestoAuto2
FETCH NEXT FROM crVentaPresupuestoAuto INTO @Moneda, @Periodo, @Sucursal, @Almacen, /*@Categoria, */@Grupo
END
CLOSE crVentaPresupuestoAuto
DEALLOCATE crVentaPresupuestoAuto
IF @@ERROR = 0
BEGIN
COMMIT TRANSACTION
SELECT 'Proceso Concluido ' + RTRIM(@Contador) + ' Artículos Generados'
END
ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT 'Error Durante la Ejecución del Proceso'
END
RETURN
END

