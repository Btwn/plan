SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPlanArtDay
@Empresa		char(5),
@Periodos		int,
@Articulo		char(20),
@Hoy			datetime,
@CfgPlanSinDemanda	bit,
@CfgPlanISDemanda	bit,
@CfgPlanIgnorarDemanda	bit,
@Categoria	    	varchar(50) = NULL,
@Grupo		    	varchar(50) = NULL,
@Familia	    	varchar(50) = NULL,
@Fabricante	    	varchar(50) = NULL,
@Linea		    	varchar(50) = NULL,
@Temporada	    	varchar(50) = NULL,
@ProveedorEspecifico 	char(10)    = NULL,
@Referencia		varchar(50) = NULL,
@ReferenciaModulo	varchar(5)  = NULL,
@ReferenciaActividad	varchar(50) = NULL

AS BEGIN
DECLARE
@Almacen		    		char(10),
@AlmacenROP		    		char(10),
@RutaDistribucion	    		varchar(50),
@RutaDistribucionNivelArticulo	bit,
@TiempoEntrega	    		int,
@TiempoEntregaUnidad    		varchar(10),
@TiempoEntregaSeg	    		int,
@TiempoEntregaSegUnidad 		varchar(10),
@FechaRequerida	    		datetime,
@CfgExcluirPlaneacionDetalle	bit,
@CfgPlanPlanearServicios		bit
SELECT @CfgExcluirPlaneacionDetalle = VentaExcluirPlaneacionDetalle,
@CfgPlanPlanearServicios = ISNULL(PlanPlanearServicios,0)
FROM EmpresaCfg2 WHERE Empresa = @Empresa
IF @Referencia IS NOT NULL AND @ReferenciaModulo IN('PROY', 'INV', 'VTAS')
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Empresa, d.Almacen, d.Articulo, ISNULL(d.SubCuenta, ''), 'E', ISNULL(SUM(d.Disponible), 0), -1
FROM ArtSubDisponible d, Art a, Alm
WHERE d.Empresa = @Empresa AND NULLIF(d.Almacen, '') IS NOT NULL
AND d.Articulo = a.Articulo AND a.Articulo = ISNULL(@Articulo, a.Articulo) AND a.Estatus NOT IN ('BAJA', 'DESCONTINUADO') AND UPPER(a.Tipo) NOT IN (/*'SERVICIO',*/'JUEGO') AND NULLIF(RTRIM(a.CategoriaActivoFijo), '') IS NULL
AND ISNULL(a.Categoria, '') = ISNULL(ISNULL(@Categoria, a.Categoria) , '') AND ISNULL(a.Grupo, '') = ISNULL(ISNULL(@Grupo, a.Grupo), '') AND ISNULL(a.Familia, '') = ISNULL(ISNULL(@Familia, a.Familia), '') AND ISNULL(a.Fabricante, '') = ISNULL(ISNULL(@Fabricante, a.Fabricante), '') AND ISNULL(a.Linea, '') = ISNULL(ISNULL(@Linea, a.Linea), '') AND ISNULL(a.Proveedor, '') = ISNULL(ISNULL(@ProveedorEspecifico, a.Proveedor), '') AND ISNULL(a.Temporada, '') = ISNULL(ISNULL(@Temporada, a.Temporada), '')
AND d.Almacen = Alm.Almacen AND Alm.ExcluirPlaneacion = 0
AND UPPER(A.Tipo) NOT IN (CASE WHEN @CfgPlanPlanearServicios = 0 THEN 'SERVICIO' END)
GROUP BY d.Articulo, ISNULL(d.SubCuenta, ''), d.Almacen
IF @Referencia IS NOT NULL AND @ReferenciaModulo = 'PROY' 
BEGIN
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Empresa, d.Almacen, d.Articulo, ISNULL(d.SubCuenta, ''), 'PV', ISNULL(SUM(d.CantidadPendiente*d.Factor), 0.0) /*+ ISNULL(SUM(d.CantidadOrdenada*d.Factor), 0.0)*/,
CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, d.FechaRequerida), 0) END
FROM Venta e, VentaD d, MovTipo mt, Art a, Alm
WHERE e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus = 'PENDIENTE' /*AND e.Extra = 0 */
AND 0 = CASE WHEN @CfgExcluirPlaneacionDetalle = 1 THEN d.ExcluirPlaneacion ELSE e.ExcluirPlaneacion END
AND mt.Modulo = 'VTAS' AND mt.Mov = e.Mov AND mt.Clave IN ('VTAS.P', 'VTAS.S', 'VTAS.F','VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX')
AND d.Articulo = a.Articulo AND a.Articulo = ISNULL(@Articulo, a.Articulo) AND a.Estatus NOT IN ('BAJA', 'DESCONTINUADO') AND UPPER(a.Tipo) NOT IN (/*'SERVICIO',*/'JUEGO') AND NULLIF(RTRIM(a.CategoriaActivoFijo), '') IS NULL
AND e.Proyecto = @Referencia AND ISNULL(e.Actividad,'') = ISNULL(NULLIF(RTRIM(@ReferenciaActividad),''),ISNULL(e.Actividad,''))
AND d.Almacen = Alm.Almacen AND Alm.ExcluirPlaneacion = 0
AND UPPER(A.Tipo) NOT IN (CASE WHEN @CfgPlanPlanearServicios = 0 THEN 'SERVICIO' END)
GROUP BY d.Articulo, ISNULL(d.SubCuenta, ''), d.Almacen, CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, d.FechaRequerida), 0) END
HAVING SUM(d.CantidadPendiente*d.Factor) > 0 /*OR SUM(d.CantidadOrdenada*d.Factor) > 0*/
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Empresa, d.Almacen, d.Articulo, ISNULL(d.SubCuenta, ''), 'SOL', ISNULL(SUM(d.CantidadPendiente*d.Factor), 0.0) /*+ ISNULL(SUM(d.CantidadOrdenada*d.Factor), 0.0)*/,
CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, d.FechaRequerida), 0) END
FROM Inv e, InvD d, MovTipo mt, Art a, Alm
WHERE e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus = 'PENDIENTE'
AND mt.Modulo = 'INV' AND mt.Mov = e.Mov AND mt.Clave = 'INV.SOL'
AND d.Articulo = a.Articulo AND a.Articulo = ISNULL(@Articulo, a.Articulo) AND a.Estatus NOT IN ('BAJA', 'DESCONTINUADO') AND UPPER(a.Tipo) NOT IN (/*'SERVICIO',*/'JUEGO') AND NULLIF(RTRIM(a.CategoriaActivoFijo), '') IS NULL
AND e.Proyecto = @Referencia AND ISNULL(e.Actividad,'') = ISNULL(NULLIF(RTRIM(@ReferenciaActividad),''),ISNULL(e.Actividad,''))
AND d.Almacen = Alm.Almacen AND Alm.ExcluirPlaneacion = 0
AND UPPER(A.Tipo) NOT IN (CASE WHEN @CfgPlanPlanearServicios = 0 THEN 'SERVICIO' END)
GROUP BY d.Articulo, ISNULL(d.SubCuenta, ''), d.Almacen, CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, d.FechaRequerida), 0) END
HAVING SUM(d.CantidadPendiente*d.Factor) > 0 /*OR SUM(d.CantidadOrdenada*d.Factor) > 0*/
RETURN
END
IF @Referencia IS NOT NULL AND @ReferenciaModulo = 'VTAS'
BEGIN
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Empresa, d.Almacen, d.Articulo, ISNULL(d.SubCuenta, ''), 'PV', ISNULL(SUM(d.CantidadPendiente*d.Factor), 0.0) /*+ ISNULL(SUM(d.CantidadOrdenada*d.Factor), 0.0)*/,
CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, d.FechaRequerida), 0) END
FROM Venta e, VentaD d, MovTipo mt, Art a, Alm
WHERE e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus = 'PENDIENTE' /*AND e.Extra = 0 */
AND 0 = CASE WHEN @CfgExcluirPlaneacionDetalle = 1 THEN d.ExcluirPlaneacion ELSE e.ExcluirPlaneacion END
AND mt.Modulo = 'VTAS' AND mt.Mov = e.Mov AND mt.Clave IN ('VTAS.P', 'VTAS.S', 'VTAS.F','VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX')
AND d.Articulo = a.Articulo AND a.Articulo = ISNULL(@Articulo, a.Articulo) AND a.Estatus NOT IN ('BAJA', 'DESCONTINUADO') AND UPPER(a.Tipo) NOT IN (/*'SERVICIO',*/'JUEGO') AND NULLIF(RTRIM(a.CategoriaActivoFijo), '') IS NULL
AND RTRIM(e.Mov)+' '+RTRIM(e.MovID) = @Referencia
AND d.Almacen = Alm.Almacen AND Alm.ExcluirPlaneacion = 0
AND UPPER(A.Tipo) NOT IN (CASE WHEN @CfgPlanPlanearServicios = 0 THEN 'SERVICIO' END)
GROUP BY d.Articulo, ISNULL(d.SubCuenta, ''), d.Almacen, CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, d.FechaRequerida), 0) END
HAVING SUM(d.CantidadPendiente*d.Factor) > 0 /*OR SUM(d.CantidadOrdenada*d.Factor) > 0*/
RETURN
END
IF @Referencia IS NOT NULL AND @ReferenciaModulo = 'INV'
BEGIN
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Empresa, d.Almacen, d.Articulo, ISNULL(d.SubCuenta, ''), 'SOL', ISNULL(SUM(d.CantidadPendiente*d.Factor), 0.0) /*+ ISNULL(SUM(d.CantidadOrdenada*d.Factor), 0.0)*/,
CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, d.FechaRequerida), 0) END
FROM Inv e, InvD d, MovTipo mt, Art a, Alm
WHERE e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus = 'PENDIENTE'
AND mt.Modulo = 'INV' AND mt.Mov = e.Mov AND mt.Clave = 'INV.SOL'
AND d.Articulo = a.Articulo AND a.Articulo = ISNULL(@Articulo, a.Articulo) AND a.Estatus NOT IN ('BAJA', 'DESCONTINUADO') AND UPPER(a.Tipo) NOT IN (/*'SERVICIO',*/'JUEGO') AND NULLIF(RTRIM(a.CategoriaActivoFijo), '') IS NULL
AND RTRIM(e.Mov)+' '+RTRIM(e.MovID) = @Referencia
AND d.Almacen = Alm.Almacen AND Alm.ExcluirPlaneacion = 0
AND UPPER(A.Tipo) NOT IN (CASE WHEN @CfgPlanPlanearServicios = 0 THEN 'SERVICIO' END)
GROUP BY d.Articulo, ISNULL(d.SubCuenta, ''), d.Almacen, CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, d.FechaRequerida), 0) END
HAVING SUM(d.CantidadPendiente*d.Factor) > 0 /*OR SUM(d.CantidadOrdenada*d.Factor) > 0*/
RETURN
END
SELECT @RutaDistribucion = RutaDistribucion,
@RutaDistribucionNivelArticulo = RutaDistribucionNivelArticulo
FROM EmpresaCfg2
WHERE Empresa = @Empresa
IF @CfgPlanSinDemanda = 1 OR @CfgPlanISDemanda = 0
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Empresa, aa.Almacen, aa.Articulo, ISNULL(aa.SubCuenta, ''), 'IS', aa.Minimo, -1
FROM ArtAlm aa, Art a, Alm
WHERE aa.Articulo = a.Articulo AND a.Articulo = ISNULL(@Articulo, a.Articulo) AND a.Estatus NOT IN ('BAJA', 'DESCONTINUADO') AND UPPER(a.Tipo) NOT IN (/*'SERVICIO',*/'JUEGO') AND NULLIF(RTRIM(a.CategoriaActivoFijo), '') IS NULL
AND ISNULL(a.Categoria, '') = ISNULL(ISNULL(@Categoria, a.Categoria) , '') AND ISNULL(a.Grupo, '') = ISNULL(ISNULL(@Grupo, a.Grupo), '') AND ISNULL(a.Familia, '') = ISNULL(ISNULL(@Familia, a.Familia), '') AND ISNULL(a.Fabricante, '') = ISNULL(ISNULL(@Fabricante, a.Fabricante), '') AND ISNULL(a.Linea, '') = ISNULL(ISNULL(@Linea, a.Linea), '') AND ISNULL(a.Proveedor, '') = ISNULL(ISNULL(@ProveedorEspecifico, a.Proveedor), '') AND ISNULL(a.Temporada, '') = ISNULL(ISNULL(@Temporada, a.Temporada), '')
AND ISNULL(aa.Minimo, 0) > 0
AND aa.Almacen = Alm.Almacen AND Alm.ExcluirPlaneacion = 0
AND UPPER(A.Tipo) NOT IN (CASE WHEN @CfgPlanPlanearServicios = 0 THEN 'SERVICIO' END)
IF @CfgPlanISDemanda = 1
BEGIN
DECLARE crISDemanda CURSOR FOR
SELECT ISNULL(a.TiempoEntrega, 0), a.TiempoEntregaUnidad, ISNULL(a.TiempoEntregaSeg, 0), a.TiempoEntregaSegUnidad, pa.Almacen, a.AlmacenROP, CASE WHEN @RutaDistribucionNivelArticulo = 1 THEN RutaDistribucion ELSE @RutaDistribucion END
FROM PlanArt pa, Art a
WHERE pa.Empresa = @Empresa AND pa.Articulo = a.Articulo AND Acronimo = 'IS'
OPEN crISDemanda
FETCH NEXT FROM crISDemanda INTO @TiempoEntrega, @TiempoEntregaUnidad, @TiempoEntregaSeg, @TiempoEntregaSegUnidad, @Almacen, @AlmacenROP, @RutaDistribucion
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Almacen <> '(Demanda)' AND @Almacen <> @AlmacenROP AND NULLIF(RTRIM(@RutaDistribucion), '') IS NOT NULL
BEGIN
SELECT @TiempoEntrega = 0, @TiempoEntregaSeg = 0
SELECT @TiempoEntrega       = TiempoEntrega,
@TiempoEntregaUnidad = TiempoEntregaUnidad
FROM RutaDistribucionD
WHERE Ruta = @RutaDistribucion AND AlmacenDestino = @Almacen
END
EXEC spIncTiempo @Hoy, @TiempoEntrega, @TiempoEntregaUnidad, @FechaRequerida OUTPUT
IF ISNULL(@TiempoEntregaSeg, 0) <> 0.0
EXEC spIncTiempo @FechaRequerida, @TiempoEntregaSeg, @TiempoEntregaSegUnidad, @FechaRequerida OUTPUT
UPDATE PlanArt SET Periodo = ISNULL(DATEDIFF(Day, @Hoy, @FechaRequerida), 0) WHERE CURRENT OF crISDemanda
END
FETCH NEXT FROM crISDemanda INTO @TiempoEntrega, @TiempoEntregaUnidad, @TiempoEntregaSeg, @TiempoEntregaSegUnidad, @Almacen, @AlmacenROP, @RutaDistribucion
END
CLOSE crISDemanda
DEALLOCATE crISDemanda
END
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Empresa, d.Almacen, d.Articulo, ISNULL(d.SubCuenta, ''), 'PRV', SUM(d.Cantidad*d.Factor), ISNULL(DATEDIFF(Day, @Hoy, d.FechaRequerida), 0)
FROM Venta v, VentaD d, MovTipo mt, Art a, Alm
WHERE v.ID = d.ID AND v.Empresa = @Empresa AND v.Estatus IN ('CONCLUIDO', 'PENDIENTE')
AND mt.Modulo = 'VTAS' AND mt.Mov = v.Mov AND mt.Clave = 'VTAS.PR'
AND d.Articulo = a.Articulo AND a.Articulo = ISNULL(@Articulo, a.Articulo) AND a.Estatus NOT IN ('BAJA', 'DESCONTINUADO') AND UPPER(a.Tipo) NOT IN (/*'SERVICIO',*/'JUEGO') AND NULLIF(RTRIM(a.CategoriaActivoFijo), '') IS NULL
AND ISNULL(a.Categoria, '') = ISNULL(ISNULL(@Categoria, a.Categoria) , '') AND ISNULL(a.Grupo, '') = ISNULL(ISNULL(@Grupo, a.Grupo), '') AND ISNULL(a.Familia, '') = ISNULL(ISNULL(@Familia, a.Familia), '') AND ISNULL(a.Fabricante, '') = ISNULL(ISNULL(@Fabricante, a.Fabricante), '') AND ISNULL(a.Linea, '') = ISNULL(ISNULL(@Linea, a.Linea), '') AND ISNULL(a.Proveedor, '') = ISNULL(ISNULL(@ProveedorEspecifico, a.Proveedor), '') AND ISNULL(a.Temporada, '') = ISNULL(ISNULL(@Temporada, a.Temporada), '')
AND d.FechaRequerida >= @Hoy
AND d.Almacen = Alm.Almacen AND Alm.ExcluirPlaneacion = 0
AND UPPER(A.Tipo) NOT IN (CASE WHEN @CfgPlanPlanearServicios = 0 THEN 'SERVICIO' END)
GROUP BY d.Articulo, ISNULL(d.SubCuenta, ''), d.Almacen, ISNULL(DATEDIFF(Day, @Hoy, d.FechaRequerida), 0)
HAVING SUM(d.Cantidad*d.Factor) > 0
IF @CfgPlanIgnorarDemanda = 0
BEGIN
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Empresa, d.Almacen, d.Articulo, ISNULL(d.SubCuenta, ''), 'PV', ISNULL(SUM(d.CantidadPendiente*d.Factor), 0.0) /*+ ISNULL(SUM(d.CantidadOrdenada*d.Factor), 0.0)*/,
CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, d.FechaRequerida), 0) END
FROM Venta e, VentaD d, MovTipo mt, Art a, Alm
WHERE e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus = 'PENDIENTE' AND e.Extra = 0
AND 0 = CASE WHEN @CfgExcluirPlaneacionDetalle = 1 THEN d.ExcluirPlaneacion ELSE e.ExcluirPlaneacion END
AND mt.Modulo = 'VTAS' AND mt.Mov = e.Mov AND mt.Clave IN ('VTAS.P', 'VTAS.S', 'VTAS.F','VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX')
AND d.Articulo = a.Articulo AND a.Articulo = ISNULL(@Articulo, a.Articulo) AND a.Estatus NOT IN ('BAJA', 'DESCONTINUADO') AND UPPER(a.Tipo) NOT IN (/*'SERVICIO',*/'JUEGO') AND NULLIF(RTRIM(a.CategoriaActivoFijo), '') IS NULL
AND ISNULL(a.Categoria, '') = ISNULL(ISNULL(@Categoria, a.Categoria) , '') AND ISNULL(a.Grupo, '') = ISNULL(ISNULL(@Grupo, a.Grupo), '') AND ISNULL(a.Familia, '') = ISNULL(ISNULL(@Familia, a.Familia), '') AND ISNULL(a.Fabricante, '') = ISNULL(ISNULL(@Fabricante, a.Fabricante), '') AND ISNULL(a.Linea, '') = ISNULL(ISNULL(@Linea, a.Linea), '') AND ISNULL(a.Proveedor, '') = ISNULL(ISNULL(@ProveedorEspecifico, a.Proveedor), '') AND ISNULL(a.Temporada, '') = ISNULL(ISNULL(@Temporada, a.Temporada), '')
AND d.Almacen = Alm.Almacen AND Alm.ExcluirPlaneacion = 0
AND UPPER(A.Tipo) NOT IN (CASE WHEN @CfgPlanPlanearServicios = 0 THEN 'SERVICIO' END)
GROUP BY d.Articulo, ISNULL(d.SubCuenta, ''), d.Almacen, CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, d.FechaRequerida), 0) END
HAVING SUM(d.CantidadPendiente*d.Factor) > 0 /*OR SUM(d.CantidadOrdenada*d.Factor) > 0*/
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Empresa, d.Almacen, d.Articulo, ISNULL(d.SubCuenta, ''), 'PVE', ISNULL(SUM(d.CantidadPendiente*d.Factor), 0.0) /*+ ISNULL(SUM(d.CantidadOrdenada*d.Factor), 0.0)*/,
CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, d.FechaRequerida), 0) END
FROM Venta e, VentaD d, MovTipo mt, Art a, Alm
WHERE e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus = 'PENDIENTE' AND e.Extra = 1
AND 0 = CASE WHEN @CfgExcluirPlaneacionDetalle = 1 THEN d.ExcluirPlaneacion ELSE e.ExcluirPlaneacion END
AND mt.Modulo = 'VTAS' AND mt.Mov = e.Mov AND mt.Clave IN ('VTAS.P', 'VTAS.S', 'VTAS.F','VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX')
AND d.Articulo = a.Articulo AND a.Articulo = ISNULL(@Articulo, a.Articulo) AND a.Estatus NOT IN ('BAJA', 'DESCONTINUADO') AND UPPER(a.Tipo) NOT IN (/*'SERVICIO',*/'JUEGO') AND NULLIF(RTRIM(a.CategoriaActivoFijo), '') IS NULL
AND ISNULL(a.Categoria, '') = ISNULL(ISNULL(@Categoria, a.Categoria) , '') AND ISNULL(a.Grupo, '') = ISNULL(ISNULL(@Grupo, a.Grupo), '') AND ISNULL(a.Familia, '') = ISNULL(ISNULL(@Familia, a.Familia), '') AND ISNULL(a.Fabricante, '') = ISNULL(ISNULL(@Fabricante, a.Fabricante), '') AND ISNULL(a.Linea, '') = ISNULL(ISNULL(@Linea, a.Linea), '') AND ISNULL(a.Proveedor, '') = ISNULL(ISNULL(@ProveedorEspecifico, a.Proveedor), '') AND ISNULL(a.Temporada, '') = ISNULL(ISNULL(@Temporada, a.Temporada), '')
AND d.Almacen = Alm.Almacen AND Alm.ExcluirPlaneacion = 0
AND UPPER(A.Tipo) NOT IN (CASE WHEN @CfgPlanPlanearServicios = 0 THEN 'SERVICIO' END)
GROUP BY d.Articulo, ISNULL(d.SubCuenta, ''), d.Almacen, CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, d.FechaRequerida), 0) END
HAVING SUM(d.CantidadPendiente*d.Factor) > 0 /*OR SUM(d.CantidadOrdenada*d.Factor) > 0*/
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Empresa, d.Almacen, d.Articulo, ISNULL(d.SubCuenta, ''), 'SOL', ISNULL(SUM(d.CantidadPendiente*d.Factor), 0.0) /*+ ISNULL(SUM(d.CantidadOrdenada*d.Factor), 0.0)*/,
CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, d.FechaRequerida), 0) END
FROM Inv e, InvD d, MovTipo mt, Art a, Alm
WHERE e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus = 'PENDIENTE'
AND mt.Modulo = 'INV' AND mt.Mov = e.Mov AND mt.Clave = 'INV.SOL'
AND d.Articulo = a.Articulo AND a.Articulo = ISNULL(@Articulo, a.Articulo) AND a.Estatus NOT IN ('BAJA', 'DESCONTINUADO') AND UPPER(a.Tipo) NOT IN (/*'SERVICIO',*/'JUEGO') AND NULLIF(RTRIM(a.CategoriaActivoFijo), '') IS NULL
AND ISNULL(a.Categoria, '') = ISNULL(ISNULL(@Categoria, a.Categoria) , '') AND ISNULL(a.Grupo, '') = ISNULL(ISNULL(@Grupo, a.Grupo), '') AND ISNULL(a.Familia, '') = ISNULL(ISNULL(@Familia, a.Familia), '') AND ISNULL(a.Fabricante, '') = ISNULL(ISNULL(@Fabricante, a.Fabricante), '') AND ISNULL(a.Linea, '') = ISNULL(ISNULL(@Linea, a.Linea), '') AND ISNULL(a.Proveedor, '') = ISNULL(ISNULL(@ProveedorEspecifico, a.Proveedor), '') AND ISNULL(a.Temporada, '') = ISNULL(ISNULL(@Temporada, a.Temporada), '')
AND d.Almacen = Alm.Almacen AND Alm.ExcluirPlaneacion = 0
AND UPPER(A.Tipo) NOT IN (CASE WHEN @CfgPlanPlanearServicios = 0 THEN 'SERVICIO' END)
GROUP BY d.Articulo, ISNULL(d.SubCuenta, ''), d.Almacen, CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, d.FechaRequerida), 0) END
HAVING SUM(d.CantidadPendiente*d.Factor) > 0 /*OR SUM(d.CantidadOrdenada*d.Factor) > 0*/
END
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo, OrigenPlan)
SELECT @Empresa, d.Almacen, d.Articulo, ISNULL(d.SubCuenta, ''), 'OT', ISNULL(SUM(ISNULL(d.CantidadPendiente, 0.0)*d.Factor), 0.0) /*+ ISNULL(SUM(d.CantidadOrdenada*d.Factor), 0.0)*/,
CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, d.FechaRequerida), 0) END,
CASE WHEN e.OrigenTipo = 'PLAN' THEN 1 ELSE 0 END
FROM Inv e, InvD d, MovTipo mt, Art a, Alm
WHERE e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus = 'PENDIENTE'
AND mt.Modulo = 'INV' AND mt.Mov = e.Mov AND mt.Clave = 'INV.OT'
AND d.Articulo = a.Articulo AND a.Articulo = ISNULL(@Articulo, a.Articulo) AND a.Estatus NOT IN ('BAJA', 'DESCONTINUADO') AND UPPER(a.Tipo) NOT IN (/*'SERVICIO',*/'JUEGO') AND NULLIF(RTRIM(a.CategoriaActivoFijo), '') IS NULL
AND ISNULL(a.Categoria, '') = ISNULL(ISNULL(@Categoria, a.Categoria) , '') AND ISNULL(a.Grupo, '') = ISNULL(ISNULL(@Grupo, a.Grupo), '') AND ISNULL(a.Familia, '') = ISNULL(ISNULL(@Familia, a.Familia), '') AND ISNULL(a.Fabricante, '') = ISNULL(ISNULL(@Fabricante, a.Fabricante), '') AND ISNULL(a.Linea, '') = ISNULL(ISNULL(@Linea, a.Linea), '') AND ISNULL(a.Proveedor, '') = ISNULL(ISNULL(@ProveedorEspecifico, a.Proveedor), '') AND ISNULL(a.Temporada, '') = ISNULL(ISNULL(@Temporada, a.Temporada), '')
AND d.Almacen = Alm.Almacen AND Alm.ExcluirPlaneacion = 0
AND UPPER(A.Tipo) NOT IN (CASE WHEN @CfgPlanPlanearServicios = 0 THEN 'SERVICIO' END)
GROUP BY d.Articulo, ISNULL(d.SubCuenta, ''), d.Almacen, CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, d.FechaRequerida), 0) END, CASE WHEN e.OrigenTipo = 'PLAN' THEN 1 ELSE 0 END
HAVING SUM(d.CantidadPendiente*d.Factor) > 0 /*OR SUM(d.CantidadOrdenada*d.Factor) > 0*/
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo, OrigenPlan)
SELECT @Empresa, d.Almacen, d.Articulo, ISNULL(d.SubCuenta, ''), 'OI', ISNULL(SUM(ISNULL(d.CantidadPendiente, 0.0)*d.Factor), 0.0) /*+ ISNULL(SUM(d.CantidadOrdenada*d.Factor), 0.0)*/,
CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, d.FechaRequerida), 0) END,
CASE WHEN e.OrigenTipo = 'PLAN' THEN 1 ELSE 0 END
FROM Inv e, InvD d, MovTipo mt, Art a, Alm
WHERE e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus = 'PENDIENTE'
AND mt.Modulo = 'INV' AND mt.Mov = e.Mov AND mt.Clave = 'INV.OI'
AND d.Articulo = a.Articulo AND a.Articulo = ISNULL(@Articulo, a.Articulo) AND a.Estatus NOT IN ('BAJA', 'DESCONTINUADO') AND UPPER(a.Tipo) NOT IN (/*'SERVICIO',*/'JUEGO') AND NULLIF(RTRIM(a.CategoriaActivoFijo), '') IS NULL
AND ISNULL(a.Categoria, '') = ISNULL(ISNULL(@Categoria, a.Categoria) , '') AND ISNULL(a.Grupo, '') = ISNULL(ISNULL(@Grupo, a.Grupo), '') AND ISNULL(a.Familia, '') = ISNULL(ISNULL(@Familia, a.Familia), '') AND ISNULL(a.Fabricante, '') = ISNULL(ISNULL(@Fabricante, a.Fabricante), '') AND ISNULL(a.Linea, '') = ISNULL(ISNULL(@Linea, a.Linea), '') AND ISNULL(a.Proveedor, '') = ISNULL(ISNULL(@ProveedorEspecifico, a.Proveedor), '') AND ISNULL(a.Temporada, '') = ISNULL(ISNULL(@Temporada, a.Temporada), '')
AND d.Almacen = Alm.Almacen AND Alm.ExcluirPlaneacion = 0
AND UPPER(A.Tipo) NOT IN (CASE WHEN @CfgPlanPlanearServicios = 0 THEN 'SERVICIO' END)
GROUP BY d.Articulo, ISNULL(d.SubCuenta, ''), d.Almacen, CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, d.FechaRequerida), 0) END, CASE WHEN e.OrigenTipo = 'PLAN' THEN 1 ELSE 0 END
HAVING SUM(d.CantidadPendiente*d.Factor) > 0 /*OR SUM(d.CantidadOrdenada*d.Factor) > 0*/
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Empresa, d.Almacen, d.Articulo, ISNULL(d.SubCuenta, ''), 'OC', SUM(d.CantidadPendiente*d.Factor),
CASE WHEN d.FechaEntrega < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, d.FechaEntrega), 0) END
FROM Compra e, CompraD d, MovTipo mt, Art a, Alm
WHERE e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus = 'PENDIENTE'
AND mt.Modulo = 'COMS' AND mt.Mov = e.Mov AND mt.Clave IN ('COMS.O', 'COMS.OG','COMS.OI')
AND d.Articulo = a.Articulo AND a.Articulo = ISNULL(@Articulo, a.Articulo) AND a.Estatus NOT IN ('BAJA', 'DESCONTINUADO') AND UPPER(a.Tipo) NOT IN (/*'SERVICIO',*/'JUEGO') AND NULLIF(RTRIM(a.CategoriaActivoFijo), '') IS NULL
AND ISNULL(a.Categoria, '') = ISNULL(ISNULL(@Categoria, a.Categoria) , '') AND ISNULL(a.Grupo, '') = ISNULL(ISNULL(@Grupo, a.Grupo), '') AND ISNULL(a.Familia, '') = ISNULL(ISNULL(@Familia, a.Familia), '') AND ISNULL(a.Fabricante, '') = ISNULL(ISNULL(@Fabricante, a.Fabricante), '') AND ISNULL(a.Linea, '') = ISNULL(ISNULL(@Linea, a.Linea), '') AND ISNULL(a.Proveedor, '') = ISNULL(ISNULL(@ProveedorEspecifico, a.Proveedor), '') AND ISNULL(a.Temporada, '') = ISNULL(ISNULL(@Temporada, a.Temporada), '')
AND d.Almacen = Alm.Almacen AND Alm.ExcluirPlaneacion = 0
AND UPPER(A.Tipo) NOT IN (CASE WHEN @CfgPlanPlanearServicios = 0 THEN 'SERVICIO' END)
GROUP BY d.Articulo, ISNULL(d.SubCuenta, ''), d.Almacen, CASE WHEN d.FechaEntrega < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, d.FechaEntrega), 0) END
HAVING SUM(d.CantidadPendiente*d.Factor) > 0
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Empresa, d.Almacen, d.Articulo, ISNULL(d.SubCuenta, ''), 'OP', SUM(d.CantidadPendiente*d.Factor),
CASE WHEN e.FechaEntrega < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, e.FechaEntrega), 0) END
FROM Prod e, ProdD d, MovTipo mt, Art a, Alm
WHERE e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus = 'PENDIENTE'
AND mt.Modulo = 'PROD' AND mt.Mov = e.Mov AND mt.Clave = 'PROD.O'
AND d.Articulo = a.Articulo AND a.Articulo = ISNULL(@Articulo, a.Articulo) AND a.Estatus NOT IN ('BAJA', 'DESCONTINUADO') AND UPPER(a.Tipo) NOT IN (/*'SERVICIO',*/'JUEGO') AND NULLIF(RTRIM(a.CategoriaActivoFijo), '') IS NULL
AND ISNULL(a.Categoria, '') = ISNULL(ISNULL(@Categoria, a.Categoria) , '') AND ISNULL(a.Grupo, '') = ISNULL(ISNULL(@Grupo, a.Grupo), '') AND ISNULL(a.Familia, '') = ISNULL(ISNULL(@Familia, a.Familia), '') AND ISNULL(a.Fabricante, '') = ISNULL(ISNULL(@Fabricante, a.Fabricante), '') AND ISNULL(a.Linea, '') = ISNULL(ISNULL(@Linea, a.Linea), '') AND ISNULL(a.Proveedor, '') = ISNULL(ISNULL(@ProveedorEspecifico, a.Proveedor), '') AND ISNULL(a.Temporada, '') = ISNULL(ISNULL(@Temporada, a.Temporada), '')
AND d.Almacen = Alm.Almacen AND Alm.ExcluirPlaneacion = 0
AND UPPER(A.Tipo) NOT IN (CASE WHEN @CfgPlanPlanearServicios = 0 THEN 'SERVICIO' END)
GROUP BY d.Articulo, ISNULL(d.SubCuenta, ''), d.Almacen, CASE WHEN e.FechaEntrega < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, e.FechaEntrega), 0) END
HAVING SUM(d.CantidadPendiente*d.Factor) > 0
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Empresa, e.AlmacenDestino, d.Articulo, ISNULL(d.SubCuenta, ''), 'ROT', ISNULL(SUM(ISNULL(d.CantidadPendiente, 0.0)+ISNULL(d.CantidadReservada, 0.0)*d.Factor), 0.0) /*+ ISNULL(SUM(d.CantidadOrdenada*d.Factor), 0.0)*/,
CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, d.FechaRequerida), 0) END
FROM Inv e, InvD d, MovTipo mt, Art a, Alm
WHERE e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus = 'PENDIENTE'
AND mt.Modulo = 'INV' AND mt.Mov = e.Mov AND mt.Clave = 'INV.OT'
AND d.Articulo = a.Articulo AND a.Articulo = ISNULL(@Articulo, a.Articulo) AND a.Estatus NOT IN ('BAJA', 'DESCONTINUADO') AND UPPER(a.Tipo) NOT IN (/*'SERVICIO',*/'JUEGO') AND NULLIF(RTRIM(a.CategoriaActivoFijo), '') IS NULL
AND ISNULL(a.Categoria, '') = ISNULL(ISNULL(@Categoria, a.Categoria) , '') AND ISNULL(a.Grupo, '') = ISNULL(ISNULL(@Grupo, a.Grupo), '') AND ISNULL(a.Familia, '') = ISNULL(ISNULL(@Familia, a.Familia), '') AND ISNULL(a.Fabricante, '') = ISNULL(ISNULL(@Fabricante, a.Fabricante), '') AND ISNULL(a.Linea, '') = ISNULL(ISNULL(@Linea, a.Linea), '') AND ISNULL(a.Proveedor, '') = ISNULL(ISNULL(@ProveedorEspecifico, a.Proveedor), '') AND ISNULL(a.Temporada, '') = ISNULL(ISNULL(@Temporada, a.Temporada), '')
AND e.AlmacenDestino = Alm.Almacen AND Alm.ExcluirPlaneacion = 0
AND UPPER(A.Tipo) NOT IN (CASE WHEN @CfgPlanPlanearServicios = 0 THEN 'SERVICIO' END)
GROUP BY d.Articulo, ISNULL(d.SubCuenta, ''), e.AlmacenDestino, CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, d.FechaRequerida), 0) END
HAVING SUM(d.CantidadPendiente*d.Factor) > 0 OR SUM(d.CantidadReservada*d.Factor) > 0 /*OR SUM(d.CantidadOrdenada*d.Factor) > 0*/
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Empresa, e.AlmacenDestino, d.Articulo, ISNULL(d.SubCuenta, ''), 'ROI', ISNULL(SUM(ISNULL(d.CantidadPendiente, 0.0)+ISNULL(d.CantidadReservada, 0.0)*d.Factor), 0.0) /*+ ISNULL(SUM(d.CantidadOrdenada*d.Factor), 0.0)*/,
CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, d.FechaRequerida), 0) END
FROM Inv e, InvD d, MovTipo mt, Art a, Alm
WHERE e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus = 'PENDIENTE'
AND mt.Modulo = 'INV' AND mt.Mov = e.Mov AND mt.Clave = 'INV.OI'
AND d.Articulo = a.Articulo AND a.Articulo = ISNULL(@Articulo, a.Articulo) AND a.Estatus NOT IN ('BAJA', 'DESCONTINUADO') AND UPPER(a.Tipo) NOT IN (/*'SERVICIO',*/'JUEGO') AND NULLIF(RTRIM(a.CategoriaActivoFijo), '') IS NULL
AND ISNULL(a.Categoria, '') = ISNULL(ISNULL(@Categoria, a.Categoria) , '') AND ISNULL(a.Grupo, '') = ISNULL(ISNULL(@Grupo, a.Grupo), '') AND ISNULL(a.Familia, '') = ISNULL(ISNULL(@Familia, a.Familia), '') AND ISNULL(a.Fabricante, '') = ISNULL(ISNULL(@Fabricante, a.Fabricante), '') AND ISNULL(a.Linea, '') = ISNULL(ISNULL(@Linea, a.Linea), '') AND ISNULL(a.Proveedor, '') = ISNULL(ISNULL(@ProveedorEspecifico, a.Proveedor), '') AND ISNULL(a.Temporada, '') = ISNULL(ISNULL(@Temporada, a.Temporada), '')
AND e.AlmacenDestino = Alm.Almacen AND Alm.ExcluirPlaneacion = 0
AND UPPER(A.Tipo) NOT IN (CASE WHEN @CfgPlanPlanearServicios = 0 THEN 'SERVICIO' END)
GROUP BY d.Articulo, ISNULL(d.SubCuenta, ''), e.AlmacenDestino, CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, d.FechaRequerida), 0) END
HAVING SUM(d.CantidadPendiente*d.Factor) > 0 OR SUM(d.CantidadReservada*d.Factor) > 0 /*OR SUM(d.CantidadOrdenada*d.Factor) > 0*/
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Empresa, e.AlmacenDestino, d.Articulo, ISNULL(d.SubCuenta, ''), 'RTI', ISNULL(SUM(d.CantidadPendiente*d.Factor), 0.0) /*+ ISNULL(SUM(d.CantidadOrdenada*d.Factor), 0.0)*/,
CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, d.FechaRequerida), 0) END
FROM Inv e, InvD d, MovTipo mt, Art a, Alm
WHERE e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus IN ('PENDIENTE', 'SINCRO')
AND mt.Modulo = 'INV' AND mt.Mov = e.Mov AND mt.Clave IN ('INV.TI', 'INV.T')
AND d.Articulo = a.Articulo AND a.Articulo = ISNULL(@Articulo, a.Articulo) AND a.Estatus NOT IN ('BAJA', 'DESCONTINUADO') AND UPPER(a.Tipo) NOT IN (/*'SERVICIO',*/'JUEGO') AND NULLIF(RTRIM(a.CategoriaActivoFijo), '') IS NULL
AND ISNULL(a.Categoria, '') = ISNULL(ISNULL(@Categoria, a.Categoria) , '') AND ISNULL(a.Grupo, '') = ISNULL(ISNULL(@Grupo, a.Grupo), '') AND ISNULL(a.Familia, '') = ISNULL(ISNULL(@Familia, a.Familia), '') AND ISNULL(a.Fabricante, '') = ISNULL(ISNULL(@Fabricante, a.Fabricante), '') AND ISNULL(a.Linea, '') = ISNULL(ISNULL(@Linea, a.Linea), '') AND ISNULL(a.Proveedor, '') = ISNULL(ISNULL(@ProveedorEspecifico, a.Proveedor), '') AND ISNULL(a.Temporada, '') = ISNULL(ISNULL(@Temporada, a.Temporada), '')
AND e.AlmacenDestino = Alm.Almacen AND Alm.ExcluirPlaneacion = 0
AND UPPER(A.Tipo) NOT IN (CASE WHEN @CfgPlanPlanearServicios = 0 THEN 'SERVICIO' END)
GROUP BY d.Articulo, ISNULL(d.SubCuenta, ''), e.AlmacenDestino, CASE WHEN d.FechaRequerida < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, d.FechaRequerida), 0) END
HAVING SUM(d.CantidadPendiente*d.Factor) > 0 /*OR SUM(d.CantidadOrdenada*d.Factor) > 0*/
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Empresa, d.Almacen, d.Articulo, ISNULL(d.SubCuenta, ''), 'E', ISNULL(SUM(d.Disponible), 0), -1
FROM ArtSubDisponible d, Art a, Alm
WHERE d.Empresa = @Empresa AND NULLIF(d.Almacen, '') IS NOT NULL
AND d.Articulo = a.Articulo AND a.Articulo = ISNULL(@Articulo, a.Articulo) AND a.Estatus NOT IN ('BAJA', 'DESCONTINUADO') AND UPPER(a.Tipo) NOT IN (/*'SERVICIO',*/'JUEGO') AND NULLIF(RTRIM(a.CategoriaActivoFijo), '') IS NULL
AND ISNULL(a.Categoria, '') = ISNULL(ISNULL(@Categoria, a.Categoria) , '') AND ISNULL(a.Grupo, '') = ISNULL(ISNULL(@Grupo, a.Grupo), '') AND ISNULL(a.Familia, '') = ISNULL(ISNULL(@Familia, a.Familia), '') AND ISNULL(a.Fabricante, '') = ISNULL(ISNULL(@Fabricante, a.Fabricante), '') AND ISNULL(a.Linea, '') = ISNULL(ISNULL(@Linea, a.Linea), '') AND ISNULL(a.Proveedor, '') = ISNULL(ISNULL(@ProveedorEspecifico, a.Proveedor), '') AND ISNULL(a.Temporada, '') = ISNULL(ISNULL(@Temporada, a.Temporada), '')
AND d.Almacen = Alm.Almacen AND Alm.ExcluirPlaneacion = 0
AND UPPER(A.Tipo) NOT IN (CASE WHEN @CfgPlanPlanearServicios = 0 THEN 'SERVICIO' END)
GROUP BY d.Articulo, ISNULL(d.SubCuenta, ''), d.Almacen
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Empresa, pa.Almacen, pa.Articulo, ISNULL(pa.SubCuenta, ''), 'RP', SUM(pa.Cantidad), pa.Periodo
FROM PlanArt pa, Art a, Alm
WHERE pa.Empresa = @Empresa AND pa.Acronimo IN ('OC', 'OP', 'ROT', 'ROI', 'RTI')
AND pa.Articulo = a.Articulo AND a.Articulo = ISNULL(@Articulo, a.Articulo) AND a.Estatus NOT IN ('BAJA', 'DESCONTINUADO') AND UPPER(a.Tipo) NOT IN (/*'SERVICIO',*/'JUEGO') AND NULLIF(RTRIM(a.CategoriaActivoFijo), '') IS NULL
AND ISNULL(a.Categoria, '') = ISNULL(ISNULL(@Categoria, a.Categoria) , '') AND ISNULL(a.Grupo, '') = ISNULL(ISNULL(@Grupo, a.Grupo), '') AND ISNULL(a.Familia, '') = ISNULL(ISNULL(@Familia, a.Familia), '') AND ISNULL(a.Fabricante, '') = ISNULL(ISNULL(@Fabricante, a.Fabricante), '') AND ISNULL(a.Linea, '') = ISNULL(ISNULL(@Linea, a.Linea), '') AND ISNULL(a.Proveedor, '') = ISNULL(ISNULL(@ProveedorEspecifico, a.Proveedor), '') AND ISNULL(a.Temporada, '') = ISNULL(ISNULL(@Temporada, a.Temporada), '')
AND pa.Almacen = Alm.Almacen AND Alm.ExcluirPlaneacion = 0
AND UPPER(A.Tipo) NOT IN (CASE WHEN @CfgPlanPlanearServicios = 0 THEN 'SERVICIO' END)
GROUP BY pa.Articulo, ISNULL(pa.SubCuenta, ''), pa.Almacen, pa.Periodo
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Empresa, pa.Almacen, pa.Articulo, ISNULL(pa.SubCuenta, ''), 'ROPF', SUM(pa.Cantidad),
CASE WHEN pa.FechaEntrega < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, pa.FechaEntrega), 0) END
FROM PlanArtOP pa, Art a, Alm
WHERE pa.Empresa = @Empresa AND UPPER(pa.Estado) <> 'PLAN' AND UPPER(pa.Accion) IN ('COMPRAR', 'PRODUCIR') 
AND pa.Articulo = a.Articulo AND a.Articulo = ISNULL(@Articulo, a.Articulo) AND a.Estatus NOT IN ('BAJA', 'DESCONTINUADO') AND UPPER(a.Tipo) NOT IN (/*'SERVICIO',*/'JUEGO') AND NULLIF(RTRIM(a.CategoriaActivoFijo), '') IS NULL
AND ISNULL(a.Categoria, '') = ISNULL(ISNULL(@Categoria, a.Categoria) , '') AND ISNULL(a.Grupo, '') = ISNULL(ISNULL(@Grupo, a.Grupo), '') AND ISNULL(a.Familia, '') = ISNULL(ISNULL(@Familia, a.Familia), '') AND ISNULL(a.Fabricante, '') = ISNULL(ISNULL(@Fabricante, a.Fabricante), '') AND ISNULL(a.Linea, '') = ISNULL(ISNULL(@Linea, a.Linea), '') AND ISNULL(a.Proveedor, '') = ISNULL(ISNULL(@ProveedorEspecifico, a.Proveedor), '') AND ISNULL(a.Temporada, '') = ISNULL(ISNULL(@Temporada, a.Temporada), '')
AND pa.Almacen = Alm.Almacen AND Alm.ExcluirPlaneacion = 0
AND UPPER(A.Tipo) NOT IN (CASE WHEN @CfgPlanPlanearServicios = 0 THEN 'SERVICIO' END)
GROUP BY pa.Articulo, ISNULL(pa.SubCuenta, ''), pa.Almacen, CASE WHEN pa.FechaEntrega < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, pa.FechaEntrega), 0) END
HAVING SUM(pa.Cantidad) > 0
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Empresa, pa.AlmacenDestino, pa.Articulo, ISNULL(pa.SubCuenta, ''), 'REPF', SUM(pa.Cantidad),
CASE WHEN pa.FechaEntrega < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, pa.FechaEntrega), 0) END
FROM PlanArtOP pa, Art a, Alm
WHERE pa.Empresa = @Empresa AND UPPER(pa.Estado) <> 'PLAN' AND UPPER(pa.Accion) = 'DISTRIBUIR' 
AND pa.Articulo = a.Articulo AND a.Articulo = ISNULL(@Articulo, a.Articulo) AND a.Estatus NOT IN ('BAJA', 'DESCONTINUADO') AND UPPER(a.Tipo) NOT IN (/*'SERVICIO',*/'JUEGO') AND NULLIF(RTRIM(a.CategoriaActivoFijo), '') IS NULL
AND ISNULL(a.Categoria, '') = ISNULL(ISNULL(@Categoria, a.Categoria) , '') AND ISNULL(a.Grupo, '') = ISNULL(ISNULL(@Grupo, a.Grupo), '') AND ISNULL(a.Familia, '') = ISNULL(ISNULL(@Familia, a.Familia), '') AND ISNULL(a.Fabricante, '') = ISNULL(ISNULL(@Fabricante, a.Fabricante), '') AND ISNULL(a.Linea, '') = ISNULL(ISNULL(@Linea, a.Linea), '') AND ISNULL(a.Proveedor, '') = ISNULL(ISNULL(@ProveedorEspecifico, a.Proveedor), '') AND ISNULL(a.Temporada, '') = ISNULL(ISNULL(@Temporada, a.Temporada), '')
AND pa.AlmacenDestino = Alm.Almacen AND Alm.ExcluirPlaneacion = 0
AND UPPER(A.Tipo) NOT IN (CASE WHEN @CfgPlanPlanearServicios = 0 THEN 'SERVICIO' END)
GROUP BY pa.Articulo, ISNULL(pa.SubCuenta, ''), pa.AlmacenDestino, CASE WHEN pa.FechaEntrega < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, pa.FechaEntrega), 0) END
HAVING SUM(pa.Cantidad) > 0
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Empresa, pa.Almacen, pa.Articulo, ISNULL(pa.SubCuenta, ''), 'SODF', SUM(pa.Cantidad),
CASE WHEN pa.FechaEntrega < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, pa.FechaEntrega), 0) END
FROM PlanArtOP pa, Art a, Alm
WHERE pa.Empresa = @Empresa AND UPPER(pa.Estado) <> 'PLAN' AND UPPER(pa.Accion) = 'DISTRIBUIR' 
AND pa.Articulo = a.Articulo AND a.Articulo = ISNULL(@Articulo, a.Articulo) AND a.Estatus NOT IN ('BAJA', 'DESCONTINUADO') AND UPPER(a.Tipo) NOT IN (/*'SERVICIO',*/'JUEGO') AND NULLIF(RTRIM(a.CategoriaActivoFijo), '') IS NULL
AND ISNULL(a.Categoria, '') = ISNULL(ISNULL(@Categoria, a.Categoria) , '') AND ISNULL(a.Grupo, '') = ISNULL(ISNULL(@Grupo, a.Grupo), '') AND ISNULL(a.Familia, '') = ISNULL(ISNULL(@Familia, a.Familia), '') AND ISNULL(a.Fabricante, '') = ISNULL(ISNULL(@Fabricante, a.Fabricante), '') AND ISNULL(a.Linea, '') = ISNULL(ISNULL(@Linea, a.Linea), '') AND ISNULL(a.Proveedor, '') = ISNULL(ISNULL(@ProveedorEspecifico, a.Proveedor), '') AND ISNULL(a.Temporada, '') = ISNULL(ISNULL(@Temporada, a.Temporada), '')
AND pa.Almacen = Alm.Almacen AND Alm.ExcluirPlaneacion = 0
AND UPPER(A.Tipo) NOT IN (CASE WHEN @CfgPlanPlanearServicios = 0 THEN 'SERVICIO' END)
GROUP BY pa.Articulo, ISNULL(pa.SubCuenta, ''), pa.Almacen, CASE WHEN pa.FechaEntrega < @Hoy THEN -1 ELSE ISNULL(DATEDIFF(Day, @Hoy, pa.FechaEntrega), 0) END
HAVING SUM(pa.Cantidad) > 0
RETURN
END

