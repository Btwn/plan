SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE  spProyInfoPresupuesto
@Estacion		int,
@Empresa		varchar(5),
@Proyecto		varchar(50)

AS BEGIN
DECLARE @Ejercicio	int,
@Periodo	int,
@Concepto	varchar(50),
@MovMoneda	varchar(10),
@Presupuesto	float,
@GastoPendiente	float,
@GastoEjercido	float
CREATE TABLE #PresupuestoProyecto (
Estacion	int NULL ,
Empresa	varchar(5) COLLATE Database_Default NULL,
Ejercicio	int NULL,
Periodo	int NULL,
Proyecto	varchar(50) COLLATE Database_Default NULL,
Concepto	varchar(50) COLLATE Database_Default NULL,
MovMoneda	varchar(10) COLLATE Database_Default NULL,
Presupuesto	float NULL,
GastoPendiente float NULL,
GastoEjercido	 float NULL,
Disponible	float NULL)
DECLARE crGasto CURSOR LOCAL FOR
SELECT g.Ejercicio,
g.Periodo,
gd.Concepto,
g.Moneda,
Presupuesto = SUM(gd.Importe)
FROM Gasto g
INNER JOIN GastoD gd ON g.ID = gd.ID
AND gd.Proyecto = @Proyecto
INNER JOIN MovTipo mt ON mt.Modulo = 'GAS'
AND mt.Mov = g.Mov
AND mt.Clave = 'GAS.PR'
WHERE g.Empresa = @Empresa
GROUP BY g.Ejercicio,
g.Periodo,
gd.Concepto,
g.Moneda
OPEN crGasto
FETCH NEXT FROM crGasto INTO @Ejercicio, @Periodo, @Concepto, @MovMoneda, @Presupuesto
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spGastoEjercidoPresupuesto @Empresa, @Ejercicio, @Periodo, @Concepto, @MovMoneda, @Proyecto,  @GastoEjercido OUTPUT
EXEC spGastoPendientePresupuesto @Empresa, @Ejercicio, @Periodo, @Concepto, @MovMoneda, @Proyecto, @GastoPendiente OUTPUT
INSERT #PresupuestoProyecto (Estacion,  Empresa,  Ejercicio,  Periodo,  Proyecto,  Concepto,  MovMoneda,  Presupuesto,  GastoPendiente,  GastoEjercido, Disponible)
SELECT @Estacion, @Empresa, @Ejercicio, @Periodo, @Proyecto, @Concepto, @MovMoneda, @Presupuesto, @GastoPendiente, @GastoEjercido, ISNULL(@Presupuesto, 0) - ISNULL(@GastoPendiente, 0) - ISNULL(@GastoEjercido, 0)
END
FETCH NEXT FROM crGasto INTO @Ejercicio, @Periodo, @Concepto, @MovMoneda, @Presupuesto
END
CLOSE crGasto
DEALLOCATE crGasto
SELECT *
FROM #PresupuestoProyecto
WHERE Estacion = @Estacion
END

