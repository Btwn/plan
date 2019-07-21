SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spBPlanGenerarPresupuesto
@Empresa		char(5),
@Modulo			char(10),
@Ejercicio		int,
@Usuario		char(10),
@Moneda			char(10)

AS BEGIN
DECLARE
@Mov				varchar(20),
@Sucursal			int,
@UEN				int,
@TipoCambio			float,
@Periodo			int,
@ID				int,
@FechaEmision			datetime,
@Fecha				varchar(11),
@Almacen			char(10),
@Clase				varchar(50),
@SubClase			varchar(50),
@VentaPreciosImpuestoIncluido	bit
SET DATEFORMAT dmy
SELECT @TipoCambio = TipoCambio FROM Mon WHERE Moneda = @Moneda
IF @Modulo = 'VTAS'
BEGIN
IF Exists(SELECT * FROM Sucursal WHERE Estatus = 'ALTA' AND NULLIF(RTRIM(AlmacenPrincipal),'') is null)
BEGIN
SELECT 'Existen Sucursales que no tienen asignado Almacén por Omisión'
RETURN
END
IF NOT EXISTS(SELECT * FROM Cte WHERE Cliente = 'PRESUP')
INSERT INTO Cte(Cliente, Nombre, Estatus)
VALUES('PRESUP', 'Presupuesto', 'ALTA')
SELECT @Mov = VentaPresupuesto
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
DECLARE crBPlanGenerarPresupuesto CURSOR LOCAL FOR
SELECT DISTINCT Sucursal, UEN
FROM BPlan
WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio AND Moneda = @Moneda
ORDER BY Sucursal, UEN
OPEN crBPlanGenerarPresupuesto
FETCH NEXT FROM crBPlanGenerarPresupuesto INTO @Sucursal, @UEN
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Almacen = AlmacenPrincipal FROM Sucursal WHERE Sucursal = @Sucursal
SELECT @Periodo = 1
WHILE @Periodo <= 12
BEGIN
SELECT @Fecha = '1' + '/' + RTRIM(Convert(char(2),@Periodo)) + '/' + Convert(char(4), @Ejercicio)
SELECT @FechaEmision = Convert(datetime, @Fecha, 103)
INSERT INTO Venta(Empresa, Mov, FechaEmision, Moneda, TipoCambio, Usuario, Estatus, Directo, Cliente, Almacen, Sucursal, UEN)
VALUES(@Empresa, @Mov, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'CONFIRMAR', 1, 'PRESUP', @Almacen, @Sucursal, @UEN)
SELECT @ID = SCOPE_IDENTITY()
EXEC spBPlanGenerarPresupuestoD @Empresa, @Modulo, @Ejercicio, @Moneda, @ID, @Periodo, @Sucursal, @UEN
SELECT @Periodo = @Periodo + 1
IF NOT Exists(SELECT * FROM VentaD WHERE ID = @ID)
DELETE Venta WHERE ID = @ID
END
FETCH NEXT FROM crBPlanGenerarPresupuesto INTO @Sucursal, @UEN
END
CLOSE crBPlanGenerarPresupuesto
DEALLOCATE crBPlanGenerarPresupuesto
END
ELSE
IF @Modulo = 'COMS'
BEGIN
IF Exists(SELECT * FROM Sucursal WHERE Estatus = 'ALTA' AND NULLIF(RTRIM(AlmacenPrincipal),'') is null)
BEGIN
SELECT 'Existen Sucursales que no tienen asignado Almacén por Omisión'
RETURN
END
IF NOT EXISTS(SELECT * FROM Prov WHERE Proveedor = 'PRESUP')
INSERT INTO Prov(Proveedor, Nombre, Estatus)
VALUES('PRESUP', 'Presupuesto', 'ALTA')
SELECT @Mov = 'Presupuesto'
DECLARE crBPlanGenerarPresupuesto CURSOR LOCAL FOR
SELECT DISTINCT Sucursal, UEN
FROM BPlan
WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio AND Moneda = @Moneda
ORDER BY Sucursal, UEN
OPEN crBPlanGenerarPresupuesto
FETCH NEXT FROM crBPlanGenerarPresupuesto INTO @Sucursal, @UEN
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Almacen = AlmacenPrincipal FROM Sucursal WHERE Sucursal = @Sucursal
SELECT @Periodo = 1
WHILE @Periodo <= 12
BEGIN
SELECT @Fecha = '1' + '/' + RTRIM(Convert(char(2),@Periodo)) + '/' + Convert(char(4), @Ejercicio)
SELECT @FechaEmision = Convert(datetime, @Fecha, 103)
INSERT INTO Compra(Empresa, Mov, FechaEmision, Moneda, TipoCambio, Usuario, Estatus, Directo, Proveedor, Almacen, Sucursal, UEN)
VALUES(@Empresa, @Mov, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'CONFIRMAR', 1, 'PRESUP', @Almacen, @Sucursal, @UEN)
SELECT @ID = SCOPE_IDENTITY()
EXEC spBPlanGenerarPresupuestoD @Empresa, @Modulo, @Ejercicio, @Moneda, @ID, @Periodo, @Sucursal, @UEN
SELECT @Periodo = @Periodo + 1
IF NOT Exists(SELECT * FROM CompraD WHERE ID = @ID)
DELETE Compra WHERE ID = @ID
END
FETCH NEXT FROM crBPlanGenerarPresupuesto INTO @Sucursal, @UEN
END
CLOSE crBPlanGenerarPresupuesto
DEALLOCATE crBPlanGenerarPresupuesto
END
ELSE
IF @Modulo = 'GAS'
BEGIN
IF NOT EXISTS(SELECT * FROM Prov WHERE Proveedor = 'PRESUP')
INSERT INTO Prov(Proveedor, Nombre, Estatus)
VALUES('PRESUP', 'Presupuesto', 'ALTA')
SELECT @Mov = GastoPresupuesto
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
DECLARE crBPlanGenerarPresupuesto CURSOR LOCAL FOR
SELECT DISTINCT Sucursal, UEN, Clase, SubClase
FROM BPlan
WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio AND Moneda = @Moneda
ORDER BY Sucursal, UEN, Clase, SubClase
OPEN crBPlanGenerarPresupuesto
FETCH NEXT FROM crBPlanGenerarPresupuesto INTO @Sucursal, @UEN, @Clase, @SubClase
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Periodo = 1
WHILE @Periodo <= 12
BEGIN
SELECT @Fecha = '1' + '/' + RTRIM(Convert(char(2),@Periodo)) + '/' + Convert(char(4), @Ejercicio)
SELECT @FechaEmision = Convert(datetime, @Fecha, 103)
INSERT INTO Gasto(Empresa, Mov, FechaEmision, Moneda, TipoCambio, Usuario, Estatus, Acreedor, Clase, SubClase, Sucursal, UEN)
VALUES(@Empresa, @Mov, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'CONFIRMAR', 'PRESUP', @Clase, @SubClase, @Sucursal, @UEN)
SELECT @ID = SCOPE_IDENTITY()
EXEC spBPlanGenerarPresupuestoD @Empresa, @Modulo, @Ejercicio, @Moneda, @ID, @Periodo, @Sucursal, @UEN
SELECT @Periodo = @Periodo + 1
IF NOT Exists(SELECT * FROM GastoD WHERE ID = @ID)
DELETE Gasto WHERE ID = @ID
END
FETCH NEXT FROM crBPlanGenerarPresupuesto INTO @Sucursal, @UEN, @Clase, @SubClase
END
CLOSE crBPlanGenerarPresupuesto
DEALLOCATE crBPlanGenerarPresupuesto
END
ELSE
IF @Modulo = 'NOM'
BEGIN
IF NOT EXISTS(SELECT * FROM MovTipo WHERE Modulo = 'NOM' AND Mov = 'Presupuesto')
INSERT INTO MovTipo(Modulo, Mov, Clave, ConsecutivoModulo, ConsecutivoMov, Factor)
VALUES('NOM', 'Presupuesto', 'NOM.PR', 'NOM', 'Presupuesto', 1)
SELECT @Mov = 'Presupuesto'
DECLARE crBPlanGenerarPresupuesto CURSOR LOCAL FOR
SELECT DISTINCT Sucursal, UEN
FROM BPlan
WHERE Modulo = @Modulo AND Empresa = @Empresa AND Ejercicio = @Ejercicio AND Moneda = @Moneda
ORDER BY Sucursal, UEN
OPEN crBPlanGenerarPresupuesto
FETCH NEXT FROM crBPlanGenerarPresupuesto INTO @Sucursal, @UEN
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Periodo = 1
WHILE @Periodo <= 12
BEGIN
SELECT @Fecha = '1' + '/' + RTRIM(Convert(char(2),@Periodo)) + '/' + Convert(char(4), @Ejercicio)
SELECT @FechaEmision = Convert(datetime, @Fecha, 103)
INSERT INTO Nomina(Empresa, Mov, FechaEmision, Moneda, TipoCambio, Usuario, Estatus, Sucursal, UEN)
VALUES(@Empresa, @Mov, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'CONFIRMAR', @Sucursal, @UEN)
SELECT @ID = SCOPE_IDENTITY()
EXEC spBPlanGenerarPresupuestoD @Empresa, @Modulo, @Ejercicio, @Moneda, @ID, @Periodo, @Sucursal, @UEN
SELECT @Periodo = @Periodo + 1
IF NOT Exists(SELECT * FROM NominaD WHERE ID = @ID)
DELETE Nomina WHERE ID = @ID
END
FETCH NEXT FROM crBPlanGenerarPresupuesto INTO @Sucursal, @UEN
END
CLOSE crBPlanGenerarPresupuesto
DEALLOCATE crBPlanGenerarPresupuesto
END
SELECT 'Proceso Concluido'
RETURN
END

