SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProyGenerarSolicitudInventario
@Sucursal		int,
@Empresa		char(5),
@Accion		char(20),
@Usuario		char(10),
@FechaTrabajo	datetime = NULL,
@ID			int,
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT

AS BEGIN
DECLARE
@ProyGenerarInvAlAfectar			bit,
@ProyGenerarInvPorActividad		bit,
@ProyGenerarInvTiempo			int,
@ProyGenerarInvTiempoUnidad		varchar(20),
@DiasHabiles				varchar(10),
@IDProyecto				int,
@Actividad				varchar(50),
@Comienzo				datetime,
@InvSolicitud				varchar(20),
@InvSolicitudCancelada			varchar(20),
@InvSolicitudID				varchar(20),
@FechaEmision				datetime,
@Proyecto				varchar(50),
@Moneda					char(10),
@TipoCambio				float,
@Almacen				varchar(10),
@Generar				bit,
@GenerarDespuesDe			datetime,
@DiasRestar				int,
@FechaActual				datetime,
@Articulo				varchar(20),
@SubCuenta				varchar(50),
@Cantidad				float,
@CantidadA				float,
@Unidad					varchar(50),
@EsFormula				bit,
@Renglon				float,
@RenglonID				int,
@IDSolicitud				int,
@IDSolicitudCancelada			int,
@Origen					varchar(20),
@OrigenID				varchar(20),
@Factor					float
SELECT
@ProyGenerarInvAlAfectar = ProyGenerarInvAlAfectar,
@ProyGenerarInvPorActividad = ProyGenerarInvPorActividad,
@ProyGenerarInvTiempo = ProyGenerarInvTiempo,
@ProyGenerarInvTiempoUnidad = ProyGenerarInvTiempoUnidad
FROM EmpresaCfg
WHERE Empresa = @Empresa
SET @ProyGenerarInvTiempo = 0 - @ProyGenerarInvTiempo
SELECT
@DiasHabiles = DiasHabiles
FROM EmpresaGral
WHERE Empresa = @Empresa
SELECT
@InvSolicitud = InvSolicitud,
@InvSolicitudCancelada = InvSolicitudCancelada
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
IF @FechaTrabajo IS NULL
SET @FechaActual = GETDATE()
ELSE
SET @FechaActual = @FechaTrabajo
EXEC spExtraerFecha @FechaActual OUTPUT
IF @Accion = 'AFECTAR'
BEGIN
IF @ProyGenerarInvPorActividad = 1
DECLARE crActividad CURSOR FOR
SELECT p.Proyecto, p.ID, pd.Actividad, pd.Comienzo, p.Moneda, m.TipoCambio, pdamiaa.Almacen, p.Mov, p.MovID
FROM ProyectoD pd JOIN Proyecto p
ON pd.ID = p.ID JOIN Mon m
ON m.Moneda = p.Moneda JOIN ProyectoDArtMaterialIdActAlm pdamiaa
ON pdamiaa.ID = p.ID AND pdamiaa.Actividad = pd.Actividad
WHERE p.ID = @ID
AND NOT EXISTS(SELECT * FROM ProyectoDSolicitudPendiente WHERE ProyectoID = p.ID AND Actividad = pd.Actividad)
ORDER BY p.ID, pd.Actividad
ELSE
DECLARE crActividad CURSOR FOR
SELECT p.Proyecto, p.ID, NULL, p.Comienzo, p.Moneda, m.TipoCambio, pdamia.Almacen, p.Mov, p.MovID
FROM Proyecto p JOIN Mon m
ON m.Moneda = p.Moneda JOIN ProyectoDArtMaterialIdAlm pdamia
ON pdamia.ID = p.ID
WHERE p.ID = @ID
AND NOT EXISTS(SELECT * FROM ProyectoDSolicitudPendiente WHERE ProyectoID = p.ID AND Actividad IS NULL)
OPEN crActividad
FETCH NEXT FROM crActividad INTO @Proyecto, @IDProyecto, @Actividad, @Comienzo, @Moneda, @TipoCambio, @Almacen, @Origen, @OrigenID
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SET @FechaEmision = @FechaActual
IF @ProyGenerarInvAlAfectar = 1
BEGIN
SET @Generar = 1
END ELSE
BEGIN
IF @ProyGenerarInvTiempoUnidad = 'Dia'    SET @GenerarDespuesDe = DATEADD(day,@ProyGenerarInvTiempo,@Comienzo)   ELSE
IF @ProyGenerarInvTiempoUnidad = 'Semana' SET @GenerarDespuesDe = DATEADD(week,@ProyGenerarInvTiempo,@Comienzo)  ELSE
IF @ProyGenerarInvTiempoUnidad = 'Mes'    SET @GenerarDespuesDe = DATEADD(month,@ProyGenerarInvTiempo,@Comienzo) ELSE
IF @ProyGenerarInvTiempoUnidad = 'Año'    SET @GenerarDespuesDe = DATEADD(year,@ProyGenerarInvTiempo,@Comienzo)
SET @DiasRestar = 0 - DATEDIFF(day,@GenerarDespuesDe,@Comienzo)
EXEC spCalcularDiasHabiles @Comienzo, @DiasRestar, @DiasHabiles,1, @GenerarDespuesDe OUTPUT
IF @FechaActual >= @GenerarDespuesDe SET @Generar = 1 ELSE SET @Generar = 0
END
IF NOT EXISTS(SELECT * FROM Alm WHERE Almacen = @Almacen)
BEGIN
SET @Ok = 20830
SET @OkRef = @Almacen
END
IF @Generar = 1 AND @Ok IS NULL
BEGIN
INSERT Inv (Empresa,  Mov,           MovID, FechaEmision,  UltimoCambio,  Proyecto,  Actividad,  Moneda,  TipoCambio,  Usuario,  Estatus,      Almacen)
VALUES (@Empresa, @InvSolicitud, NULL,  @FechaEmision, @FechaEmision, @Proyecto, @Actividad, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @Almacen)
IF @@ERROR <> 0 SET @Ok = 1
SET @IDSolicitud = SCOPE_IDENTITY()
IF @Ok IS NULL
BEGIN
SET @Renglon = 2048.0
SET @RenglonID = 1
IF @ProyGenerarInvPorActividad = 1
DECLARE crArtMaterial CURSOR FOR
SELECT
pdam.Material,
ISNULL(pdam.SubCuenta,''),
ISNULL(pdam.Cantidad,0.0),
pdam.Unidad,
a.EsFormula
FROM ProyectoDArtMaterialExplotado pdam JOIN Art a
ON a.Articulo = pdam.Material
WHERE pdam.ID = @ID AND pdam.Actividad = @Actividad AND pdam.Almacen = @Almacen
ELSE
DECLARE crArtMaterial CURSOR FOR
SELECT
pdam.Material,
ISNULL(pdam.SubCuenta,''),
ISNULL(pdam.Cantidad,0.0),
pdam.Unidad,
a.EsFormula
FROM ProyectoDArtMaterialExplotado pdam JOIN Art a
ON a.Articulo = pdam.Material
WHERE pdam.ID = @ID AND pdam.Almacen = @Almacen
OPEN crArtMaterial
FETCH NEXT FROM crArtMaterial INTO @Articulo, @SubCuenta, @Cantidad, @Unidad, @EsFormula
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
EXEC spUnidadFactor @Empresa, @Articulo, @SubCuenta, @Unidad, @Factor OUTPUT
INSERT InvD (ID,           Renglon,  RenglonSub,    RenglonID,  Articulo,  SubCuenta,  Cantidad,  CantidadInventario,  Unidad,  FechaRequerida, Almacen)
VALUES (@IDSolicitud, @Renglon, 0,             @RenglonID, @Articulo, @SubCuenta, @Cantidad, @Cantidad * @Factor, @Unidad, @Comienzo,      @Almacen)
IF @@ERROR <> 0 SET @Ok = 1
SET @Renglon = @Renglon + 2048.0
SET @RenglonID = @RenglonID + 1
END
FETCH NEXT FROM crArtMaterial INTO @Articulo, @SubCuenta, @Cantidad, @Unidad, @EsFormula
END
CLOSE crArtMaterial
DEALLOCATE crArtMaterial
IF @Ok IS NULL
EXEC spAfectar 'INV', @IDSolicitud, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion=@@SPID, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @InvSolicitudID = MovID FROM Inv WHERE ID = @IDSolicitud
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, 'PROY', @ID, @Origen, @OrigenID, 'INV', @IDSolicitud, @InvSolicitud, @InvSolicitudID, @Ok OUTPUT
END
END
END
END
FETCH NEXT FROM crActividad INTO @Proyecto, @IDProyecto, @Actividad, @Comienzo, @Moneda, @TipoCambio, @Almacen, @Origen, @OrigenID
END
CLOSE crActividad
DEALLOCATE crActividad
END ELSE
BEGIN
IF @Accion IN ('CANCELAR','REESTRUCTURAR')
BEGIN
IF @Accion = 'REESTRUCTURAR' SET @Accion = 'CANCELAR'
IF @ProyGenerarInvPorActividad = 1
DECLARE crActividad CURSOR FOR
SELECT
pdsp.Proyecto,
pdsp.Actividad,
pdsp.SolicitudID
FROM ProyectoDSolicitudPendiente pdsp JOIN ProyectoD pd
ON pd.ID = pdsp.ProyectoID AND pd.Actividad = pdsp.Actividad
WHERE pdsp.ProyectoID = @ID
AND pdsp.Empresa = @Empresa
AND pdsp.Estatus = 'PENDIENTE'
ELSE
DECLARE crActividad CURSOR FOR
SELECT
pdsp.Proyecto,
pdsp.Actividad,
pdsp.SolicitudID
FROM ProyectoDSolicitudPendiente pdsp JOIN Proyecto p
ON p.ID = pdsp.ProyectoID
WHERE pdsp.ProyectoID = @ID
AND pdsp.Empresa = @Empresa
AND pdsp.Estatus = 'PENDIENTE'
OPEN crActividad
FETCH NEXT FROM crActividad INTO @Proyecto, @Actividad, @IDSolicitud
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
EXEC spAfectar 'INV', @IDSolicitud, @Accion, 'Todo', NULL, @Usuario, @Estacion=@@SPID, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, 'PROY', @ID, @Origen, @OrigenID, 'INV', @IDSolicitud, @InvSolicitud, @InvSolicitudID, @Ok OUTPUT
IF @Ok IS NOT NULL
BEGIN
SET @Ok = NULL
SET @OkRef = NULL
UPDATE InvD SET CantidadA = CantidadPendiente WHERE ID = @IDSolicitud
EXEC @IDSolicitudCancelada = spAfectar 'INV', @IDSolicitud, 'GENERAR', 'Seleccion', @InvSolicitudCancelada, @Usuario, @Estacion=@@SPID, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
EXEC spAfectar 'INV', @IDSolicitudCancelada, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion=@@SPID, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
END
FETCH NEXT FROM crActividad INTO @Proyecto, @Actividad, @IDSolicitud
END
CLOSE crActividad
DEALLOCATE crActividad
END
END
END

