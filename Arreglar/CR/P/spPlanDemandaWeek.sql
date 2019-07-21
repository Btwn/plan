SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPlanDemandaWeek
@Estacion		int,
@Empresa		char(5),
@Articulo		char(20),
@Almacen		char(10),
@Hoy			datetime

AS BEGIN
DECLARE
@CfgExcluirPlaneacionDetalle	bit,
@CfgPlanPlanearServicios		bit
SELECT @CfgExcluirPlaneacionDetalle = VentaExcluirPlaneacionDetalle,
@CfgPlanPlanearServicios = ISNULL(PlanPlanearServicios,0)
FROM EmpresaCfg2
WHERE Empresa = @Empresa
DELETE PlanDemanda WHERE Estacion = @Estacion
INSERT PlanDemanda (Estacion, Modulo, ModuloID, Mov, MovID, Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Estacion, 'VTAS', e.ID, e.Mov, e.MovID, @Empresa, d.Almacen, d.Articulo, ISNULL(d.SubCuenta, ''), 'PV', ISNULL(SUM(d.CantidadPendiente*d.Factor), 0.0) /*+ ISNULL(SUM(d.CantidadOrdenada*d.Factor), 0.0)*/,
CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Week, @Hoy, d.FechaRequerida), 0) END
FROM Venta e, VentaD d, MovTipo mt, Art a, Alm
WHERE e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus = 'PENDIENTE' AND e.Extra = 0
AND 0 = CASE WHEN @CfgExcluirPlaneacionDetalle = 1 THEN d.ExcluirPlaneacion ELSE e.ExcluirPlaneacion END
AND mt.Modulo = 'VTAS' AND mt.Mov = e.Mov AND mt.Clave IN ('VTAS.P', 'VTAS.S', 'VTAS.F','VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX')
AND d.Articulo = a.Articulo AND a.Articulo = ISNULL(@Articulo, a.Articulo) AND a.Estatus NOT IN ('BAJA', 'DESCONTINUADO') AND UPPER(a.Tipo) NOT IN (/*'SERVICIO',*/'JUEGO') AND NULLIF(RTRIM(a.CategoriaActivoFijo), '') IS NULL
AND d.Almacen = Alm.Almacen AND Alm.ExcluirPlaneacion = 0
AND Alm.Almacen = ISNULL(@Almacen, Alm.Almacen)
AND UPPER(A.Tipo) NOT IN (CASE WHEN @CfgPlanPlanearServicios = 0 THEN 'SERVICIO' END)
GROUP BY e.ID, e.Mov, e.MovID, d.Articulo, ISNULL(d.SubCuenta, ''), d.Almacen, CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Week, @Hoy, d.FechaRequerida), 0) END
HAVING SUM(d.CantidadPendiente*d.Factor) > 0 /*OR SUM(d.CantidadOrdenada*d.Factor) > 0*/
INSERT PlanDemanda (Estacion, Modulo, ModuloID, Mov, MovID, Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Estacion, 'VTAS', e.ID, e.Mov, e.MovID, @Empresa, d.Almacen, d.Articulo, ISNULL(d.SubCuenta, ''), 'PVE', ISNULL(SUM(d.CantidadPendiente*d.Factor), 0.0) /*+ ISNULL(SUM(d.CantidadOrdenada*d.Factor), 0.0)*/,
CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Week, @Hoy, d.FechaRequerida), 0) END
FROM Venta e, VentaD d, MovTipo mt, Art a, Alm
WHERE e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus = 'PENDIENTE' AND e.Extra = 1
AND 0 = CASE WHEN @CfgExcluirPlaneacionDetalle = 1 THEN d.ExcluirPlaneacion ELSE e.ExcluirPlaneacion END
AND mt.Modulo = 'VTAS' AND mt.Mov = e.Mov AND mt.Clave IN ('VTAS.P', 'VTAS.S', 'VTAS.F','VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX')
AND d.Articulo = a.Articulo AND a.Articulo = ISNULL(@Articulo, a.Articulo) AND a.Estatus NOT IN ('BAJA', 'DESCONTINUADO') AND UPPER(a.Tipo) NOT IN (/*'SERVICIO',*/'JUEGO') AND NULLIF(RTRIM(a.CategoriaActivoFijo), '') IS NULL
AND d.Almacen = Alm.Almacen AND Alm.ExcluirPlaneacion = 0
AND Alm.Almacen = ISNULL(@Almacen, Alm.Almacen)
AND UPPER(A.Tipo) NOT IN (CASE WHEN @CfgPlanPlanearServicios = 0 THEN 'SERVICIO' END)
GROUP BY e.ID, e.Mov, e.MovID, d.Articulo, ISNULL(d.SubCuenta, ''), d.Almacen, CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Week, @Hoy, d.FechaRequerida), 0) END
HAVING SUM(d.CantidadPendiente*d.Factor) > 0 /*OR SUM(d.CantidadOrdenada*d.Factor) > 0*/
INSERT PlanDemanda (Estacion, Modulo, ModuloID, Mov, MovID, Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Estacion, 'INV', e.ID, e.Mov, e.MovID, @Empresa, d.Almacen, d.Articulo, ISNULL(d.SubCuenta, ''), 'SOL', ISNULL(SUM(d.CantidadPendiente*d.Factor), 0.0) /*+ ISNULL(SUM(d.CantidadOrdenada*d.Factor), 0.0)*/,
CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Week, @Hoy, d.FechaRequerida), 0) END
FROM Inv e, InvD d, MovTipo mt, Art a, Alm
WHERE e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus = 'PENDIENTE'
AND mt.Modulo = 'INV' AND mt.Mov = e.Mov AND mt.Clave = 'INV.SOL'
AND d.Articulo = a.Articulo AND a.Articulo = ISNULL(@Articulo, a.Articulo) AND a.Estatus NOT IN ('BAJA', 'DESCONTINUADO') AND UPPER(a.Tipo) NOT IN (/*'SERVICIO',*/'JUEGO') AND NULLIF(RTRIM(a.CategoriaActivoFijo), '') IS NULL
AND d.Almacen = Alm.Almacen AND Alm.ExcluirPlaneacion = 0
AND Alm.Almacen = ISNULL(@Almacen, Alm.Almacen)
AND UPPER(A.Tipo) NOT IN (CASE WHEN @CfgPlanPlanearServicios = 0 THEN 'SERVICIO' END)
GROUP BY e.ID, e.Mov, e.MovID, d.Articulo, ISNULL(d.SubCuenta, ''), d.Almacen, CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Week, @Hoy, d.FechaRequerida), 0) END
HAVING SUM(d.CantidadPendiente*d.Factor) > 0 /*OR SUM(d.CantidadOrdenada*d.Factor) > 0*/
RETURN
END

