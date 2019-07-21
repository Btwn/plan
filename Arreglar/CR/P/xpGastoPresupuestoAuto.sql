SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpGastoPresupuestoAuto
@Empresa	char(5),
@Ejercicio	int,
@PeriodoD	int,
@PeriodoA	int,
@Usuario	char(10)
AS
BEGIN
DECLARE
@ID			int,
@Mov			char(20),
@Periodo		int,
@FechaBase		char(11),
@FechaEmision		datetime,
@AcreedorDef		char(10),
@Acreedor		char(10),
@Concepto		char(50),
@Moneda			char(10),
@Clase			char(50),
@SubClase		char(50),
@TC			float,
@Cantidad		float,
@Importe		money,
@CentroCostos		char(20),
@Impuestos		money,
@Inflacion		money,
@InflacionSubClase	money,
@Contador		int,
@Renglon		float,
@PD			float,
@Sucursal		int
CREATE TABLE #GastoPresupuestoAuto(
Clase			char(50)	COLLATE Database_Default NULL,
SubClase		char(50)	COLLATE Database_Default NULL,
Periodo			int		NULL,
Sucursal		int		NULL,
Concepto		char(50)	COLLATE Database_Default NULL,
Moneda			char(10)	COLLATE Database_Default NULL,
Cantidad		float		NULL,
Importe			money		NULL,
ContUso			char(20)	COLLATE Database_Default NULL,
Impuestos		money		NULL,
Acreedor		char(10)	COLLATE Database_Default NULL)
SELECT @AcreedorDef = 'PRESUP', @Renglon = 1024
SELECT @Mov = GastoPresupuesto
FROM EmpresaCfgMov WHERE Empresa = @Empresa
/*	IF Exists(SELECT * FROM Gasto g, MovTipo m WHERE g.Mov = m.Mov AND m.Modulo = 'GAS' AND m.Clave = 'GAS.PR'
AND g.Empresa = @Empresa AND g.Estatus in ('SINAFECTAR', 'CONCLUIDO', 'CONFIRMAR')
AND DATEPART(month, g.FechaEmision) = @Periodo AND DATEPART(year, g.FechaEmision) = @Ejercicio)
BEGIN
SELECT 'Ya Existen Presupuestos en la Empresa en el Periodo y Ejercicio'
RETURN
END
*/
BEGIN TRANSACTION
SELECT @FechaBase = '1/1/' + RTRIM(@Ejercicio)
IF NOT EXISTS(SELECT * FROM Prov WHERE Proveedor = @AcreedorDef)
INSERT INTO Prov(Proveedor, Nombre, Estatus, Tipo)
VALUES(@AcreedorDef, 'Presupuesto', 'ALTA', 'Acreedor')
INSERT INTO #GastoPresupuestoAuto(Clase, SubClase, Periodo, Sucursal, Concepto, Moneda, Cantidad, 			Importe, 		ContUso, 		Impuestos, Acreedor)
SELECT c.Clase, c.SubClase, DATEPART(month, g.FechaEmision), g.Sucursal, d.Concepto, g.Moneda, SUM(d.Cantidad*m.Factor), SUM(d.Importe*m.Factor), d.ContUso, SUM(d.Impuestos*m.Factor), @AcreedorDef
FROM Gasto g, GastoD d, MovTipo m, Concepto c
WHERE g.ID = d.ID
AND d.Concepto = c.Concepto
AND g.Mov = m.Mov AND m.Modulo = 'GAS' AND m.Clave in ('GAS.C', 'GAS.DC', 'GAS.DG', 'GAS.EST', 'GAS.CI', 'GAS.G', 'GAS.GTC')
AND g.Empresa = @Empresa AND g.Estatus = 'CONCLUIDO'
AND DATEPART(year, g.FechaEmision) = @Ejercicio - 1 AND DATEPART(month, g.FechaEmision) BETWEEN @PeriodoD AND @PeriodoA
AND c.Modulo = 'GAS' AND c.CalcularPresupuesto = 1
AND ISNULL(d.Importe,0) <> 0
GROUP BY c.Clase, c.SubClase, DATEPART(month, g.FechaEmision), g.Sucursal, d.Concepto, c.Concepto, g.Moneda, d.ContUso
SELECT @Contador = 0
DECLARE crGastoPresupuestoAuto CURSOR STATIC FOR
SELECT DISTINCT Moneda, Periodo, Sucursal, Clase, SubClase, Acreedor
FROM #GastoPresupuestoAuto
OPEN crGastoPresupuestoAuto
FETCH NEXT FROM crGastoPresupuestoAuto INTO @Moneda, @Periodo, @Sucursal, @Clase, @SubClase, @Acreedor
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
SELECT @TC = TipoCambio FROM Mon WHERE Moneda = @Moneda
INSERT INTO Gasto(Empresa, Mov, FechaEmision, Moneda, TipoCambio, Usuario, Estatus, Acreedor, Clase, SubClase, SubModulo, Sucursal)
VALUES(@Empresa, @Mov, @FechaEmision, @Moneda, @TC, @Usuario, 'CONFIRMAR', @AcreedorDef, @Clase, @SubClase, 'GAS', @Sucursal)
SELECT @ID = SCOPE_IDENTITY()
DECLARE crGastoPresupuestoAuto2 CURSOR STATIC FOR
SELECT g.Concepto, g.Cantidad, g.Importe, g.ContUso, g.Impuestos, c.InflacionPresupuesto, c.PorcentajeDeducible
FROM #GastoPresupuestoAuto g, Concepto c
WHERE g.Concepto = c.Concepto
AND g.Moneda = @Moneda
AND c.Clase = @Clase AND c.SubClase = @SubClase
AND c.Modulo = 'GAS' AND c.CalcularPresupuesto = 1
AND ISNULL(c.InflacionPresupuesto,0) >= 0
AND g.Periodo = @Periodo
AND g.Sucursal = @Sucursal
OPEN crGastoPresupuestoAuto2
FETCH NEXT FROM crGastoPresupuestoAuto2 INTO @Concepto, @Cantidad, @Importe, @CentroCostos, @Impuestos, @Inflacion, @PD
WHILE @@FETCH_STATUS = 0 AND @@ERROR = 0
BEGIN
IF ISNULL(@Inflacion,0) = 0 AND ISNULL(@SubClase,'') <> ''
BEGIN
SELECT @InflacionSubClase = InflacionPresupuesto FROM SubClase WHERE SubClase = @SubClase AND Clase = @Clase AND Modulo = 'GAS'
IF ISNULL(@InflacionSubClase,0) <> 0
SELECT @Inflacion = @InflacionSubClase
END
SELECT @Importe = @Importe*(1+(ISNULL(@Inflacion,0)/100))
SELECT @Impuestos = @Impuestos*(1+(ISNULL(@Inflacion,0)/100))
INSERT INTO GastoD(ID, Renglon, Concepto, Cantidad, Precio, Importe, Impuestos, PorcentajeDeducible, Contuso)
VALUES(@ID, @Renglon, @Concepto, @Cantidad, @Importe/@Cantidad, @Importe, @Impuestos, @PD, @CentroCostos)
SELECT @Renglon = @Renglon + 1024, @Contador = @Contador + 1
FETCH NEXT FROM crGastoPresupuestoAuto2 INTO @Concepto, @Cantidad, @Importe, @CentroCostos, @Impuestos, @Inflacion, @PD
END
CLOSE crGastoPresupuestoAuto2
DEALLOCATE crGastoPresupuestoAuto2
FETCH NEXT FROM crGastoPresupuestoAuto INTO @Moneda, @Periodo, @Sucursal, @Clase, @SubClase, @Acreedor
END
CLOSE crGastoPresupuestoAuto
DEALLOCATE crGastoPresupuestoAuto
IF @@ERROR = 0
BEGIN
COMMIT TRANSACTION
SELECT 'Proceso Concluido ' + RTRIM(@Contador) + ' Conceptos Generados'
END
ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT 'Error Durante la Ejecución del Proceso'
END
RETURN
END

