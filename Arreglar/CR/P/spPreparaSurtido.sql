SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spPreparaSurtido]
@Estacion       int,
@Empresa        char(5),
@EnSilencio     bit = 0

AS
BEGIN
SET NOCOUNT ON
DECLARE @Modulo				    varchar(5),
@ID					    int,
@Articulo			    varchar(20),
@Almacen			    varchar(10),
@Cantidad		        float,
@Tarima				    varchar(20),
@FechaCaducidad			datetime,
@Disponible			    float,
@Posicion			    varchar(10),
@PosicionTipo           varchar(20),
@Zona				    varchar(50),
@Ok					    int,
@OkRef				    varchar(255),
@Desde				    int,
@Hasta				    int,
@ControlArticulo	    varchar(20),
@Referencia			    varchar(50),
@Unidad				    varchar(50),
@CantidadUnidad		    float,
@Factor				    float,
@SucursalDestino	    int,
@IDAux				    int,
@CantidadFaltante	    float,
@Renglon				float,
@RenglonID              int,
@SerieLote              varchar(50),
@SubCuenta              varchar(50),
@ArtSerieLoteInfo       bit,
@MovTipo                varchar(20),
@Sucursal               int,
@WMSPCKUbicacion        int,
@TipoArt                varchar(20),
@Tipo                   varchar(20),
@IDPrepDatosSur			int,
@MovID	                varchar(20),
@Mov                    varchar(20)
CREATE TABLE #CualesID (ID int NULL)
CREATE TABLE #Anden (Anden int NULL)
DECLARE @Asignado AS TABLE(Empresa		varchar(20) NULL,
Articulo		varchar(20) NULL,
Subcuenta	varchar(50) NULL,
Almacen		varchar(10) NULL,
Sucursal		int NULL,
SerieLote	varchar(50) NULL,
Tarima		varchar(20) NULL,
Asignado		float NULL)
DECLARE @PreparaDatosSurtir AS TABLE(
ID					int identity(1,1) NOT NULL,
Modulo             varchar(5)   NULL,
Mov                varchar(20)  NULL,
Moduloid           int          NULL,
Cantidad			float	     NULL,
Pocicion			varchar(10)  NULL,
Articulo			varchar(20)  NULL,
SubCuenta          varchar(20)  NULL,
Almacen			varchar(10)  NULL,
Unidad				varchar(50)  NULL,
CantidadUnidad		float	     NULL,
Factor				float	     NULL,
RenglonID          int          NULL,
SerieLote          varchar(50)  NULL,
Tarima				varchar(20)  NULL
)
SELECT @WMSPCKUbicacion = ISNULL(WMSPCKUbicacion, 0) FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @Ok = NULL
DELETE WMSLista WHERE Estacion = @Estacion
DELETE WMSSurtidoProcesarD WHERE Estacion = @Estacion AND Procesado = 0
DELETE WMSSurtidoPendiente WHERE Estacion = @Estacion
SELECT TOP 1 @Desde = ID FROM WMSModuloTarima ORDER BY ID DESC
DECLARE crInicial CURSOR LOCAL STATIC FOR
SELECT Modulo, ID
FROM ListaModuloID
WHERE Estacion = @Estacion
ORDER BY Modulo, ID
OPEN crInicial
FETCH NEXT FROM crInicial INTO @Modulo, @ID
WHILE @@FETCH_STATUS = 0
BEGIN
DELETE WMSModuloTarima WHERE Modulo = @Modulo AND IDModulo = @ID
/*************************     VENTAS     *****************************/
IF @Modulo = 'VTAS'
INSERT WMSModuloTarima (IDModulo, Modulo,  Renglon,    RenglonSub,
Cantidad, PosicionDestino, Articulo, Almacen,Utilizar, AlmacenDestino, Unidad,
CantidadUnidad, SubCuenta)
SELECT v.ID,     @Modulo, vd.Renglon, vd.RenglonSub,
CASE g.NivelFactorMultiUnidad WHEN 'Unidad'
THEN CASE WHEN (ISNULL( u.Factor, 1) * ISNULL(vd.CantidadPendiente,0)) - SUM(ISNULL(w.Cantidad,0)) <0
THEN (ISNULL( u.Factor, 1) * ISNULL(vd.CantidadPendiente,0)) - SUM(ISNULL(w.Cantidad,0)) + SUM(ISNULL(w.Cantidad,0))
WHEN (ISNULL( u.Factor, 1) * ISNULL(vd.CantidadPendiente,0)) - SUM(ISNULL(w.Cantidad,0)) = 0
THEN ISNULL(vd.Cantidad,0)
ELSE (ISNULL( u.Factor, 1) * ISNULL(vd.CantidadPendiente,0)) - SUM(ISNULL(w.Cantidad,0))
END
ELSE CASE WHEN (ISNULL( au.Factor, 1) * ISNULL(vd.CantidadPendiente,0)) - SUM(ISNULL(w.Cantidad,0)) < 0
THEN (ISNULL( au.Factor, 1) * ISNULL(vd.CantidadPendiente,0)) - SUM(ISNULL(w.Cantidad,0)) + SUM(ISNULL(w.Cantidad,0))
WHEN (ISNULL( au.Factor, 1) * ISNULL(vd.CantidadPendiente,0)) - SUM(ISNULL(w.Cantidad,0)) = 0
THEN (ISNULL( au.Factor, 1) * ISNULL(vd.Cantidad,0))
ELSE (ISNULL( au.Factor, 1) * ISNULL(vd.CantidadPendiente,0)) - SUM(ISNULL(w.Cantidad,0))
END
END,
ISNULL(v.PosicionWMS, a.DefPosicionSurtido), vd.Articulo, vd.Almacen, 1, vd.Almacen, vd.Unidad,
vd.Cantidad,
vd.SubCuenta
FROM Venta v
JOIN VentaD vd ON v.ID = vd.ID
JOIN Cte c ON v.Cliente = c.Cliente
LEFT JOIN CteEnviarA ca ON c.Cliente = ca.Cliente AND vd.EnviarA = ca.ID
JOIN Alm a ON vd.Almacen = a.Almacen
LEFT OUTER JOIN WMSModuloTarima w ON w.IDModulo = v.ID AND w.Modulo = @Modulo AND w.IDTMA IS NOT NULL AND Utilizar = 1
LEFT OUTER JOIN TMA t ON t.ID = w.IDTMA AND t.Estatus <> 'CANCELADO'
LEFT OUTER JOIN EmpresaCfg2 g ON v.Empresa = g.Empresa
LEFT OUTER JOIN Unidad u ON vd.Unidad = u.Unidad
LEFT OUTER JOIN ArtUnidad au ON vd.Articulo = au.Articulo AND vd.Unidad = au.Unidad
WHERE v.ID = @ID
AND v.Mov IN(SELECT Movimiento FROM WMSModuloMovimiento WHERE Modulo = @Modulo)
AND v.Estatus = (SELECT Estatus FROM WMSModuloMovimiento WHERE Modulo = @Modulo AND Movimiento = v.Mov)
AND NULLIF(vd.Tarima,'') IS NULL
AND Isnull(vd.CantidadPendiente, '') > 0
GROUP BY v.ID, vd.Renglon, vd.RenglonSub,
ISNULL(vd.CantidadPendiente,0),
ISNULL(v.PosicionWMS, a.DefPosicionSurtido),
vd.Articulo, vd.Almacen, vd.Cantidad, g.NivelFactorMultiUnidad,
ISNULL( u.Factor, 1), ISNULL( au.Factor, 1), vd.Unidad, vd.SubCuenta
/*************************     COMPRAS     *****************************/
IF @Modulo = 'COMS'
INSERT WMSModuloTarima (IDModulo, Modulo,  Renglon,    RenglonSub,    Cantidad,
PosicionDestino, Articulo, Almacen, Utilizar, AlmacenDestino,
Unidad, CantidadUnidad, SubCuenta)
SELECT v.ID,     @Modulo, vd.Renglon, vd.RenglonSub,
CASE g.NivelFactorMultiUnidad WHEN 'Unidad'
THEN CASE WHEN (ISNULL( u.Factor, 1) * ISNULL(vd.Cantidad, 0)) - SUM(ISNULL(w.Cantidad,0)) < 0
THEN (ISNULL( u.Factor, 1) * ISNULL(vd.Cantidad, 0)) - SUM(ISNULL(w.Cantidad,0)) + SUM(ISNULL(w.Cantidad,0))
ELSE (ISNULL( u.Factor, 1) * ISNULL(vd.Cantidad, 0)) - SUM(ISNULL(w.Cantidad,0))
END
ELSE
CASE WHEN (ISNULL( au.Factor, 1) * ISNULL(vd.Cantidad, 0)) - SUM(ISNULL(w.Cantidad,0)) < 0
THEN (ISNULL( au.Factor, 1) * ISNULL(vd.Cantidad, 0)) - SUM(ISNULL(w.Cantidad,0)) + SUM(ISNULL(w.Cantidad,0))
ELSE (ISNULL( au.Factor, 1) * ISNULL(vd.Cantidad, 0)) - SUM(ISNULL(w.Cantidad,0))
END
END,
ISNULL(ISNULL(c.DefPosicionSurtido, v.PosicionWMS), a.DefPosicionSurtido),
vd.Articulo, vd.Almacen, 1, vd.Almacen, vd.Unidad, vd.Cantidad, vd.SubCuenta
FROM Compra v
JOIN CompraD vd ON v.ID = vd.ID
JOIN Prov c ON v.Proveedor = c.Proveedor
JOIN Alm a ON vd.Almacen = a.Almacen
LEFT OUTER JOIN WMSModuloTarima w ON w.IDModulo = v.ID AND w.Modulo = @Modulo AND w.IDTMA IS NOT NULL AND Utilizar = 1
LEFT OUTER JOIN TMA t ON t.ID = w.IDTMA AND t.Estatus <> 'CANCELADO'
LEFT OUTER JOIN EmpresaCfg2 g ON v.Empresa = g.Empresa
LEFT OUTER JOIN Unidad u ON vd.Unidad = u.Unidad
LEFT OUTER JOIN ArtUnidad au ON vd.Articulo = au.Articulo AND vd.Unidad = au.Unidad
WHERE v.ID = @ID
AND v.Mov IN(SELECT Movimiento FROM WMSModuloMovimiento WHERE Modulo = @Modulo)
AND v.Estatus = (SELECT Estatus FROM WMSModuloMovimiento WHERE Modulo = @Modulo AND Movimiento = v.Mov)
AND NULLIF(vd.Tarima,'') IS NULL
GROUP BY v.ID, vd.Renglon, vd.RenglonSub, ISNULL(vd.Cantidad, 0), ISNULL(ISNULL(c.DefPosicionSurtido, v.PosicionWMS), a.DefPosicionSurtido), vd.Articulo, vd.Almacen, g.NivelFactorMultiUnidad, ISNULL( u.Factor, 1), ISNULL( au.Factor, 1), vd.Cantidad, vd.Unidad, vd.SubCuenta
/*************************     INVENTARIOS     *****************************/
IF @Modulo = 'INV'
INSERT WMSModuloTarima (IDModulo, Modulo,  Renglon,    RenglonSub,    Cantidad,
PosicionDestino, Articulo, Almacen, Utilizar, AlmacenDestino, Unidad, CantidadUnidad, SubCuenta)
SELECT v.ID,     @Modulo, vd.Renglon, vd.RenglonSub,
CASE g.NivelFactorMultiUnidad WHEN 'Unidad'
THEN CASE WHEN (ISNULL( u.Factor, 1) * ISNULL(vd.CantidadPendiente,0)) - SUM(ISNULL(w.Cantidad,0)) <0
THEN (ISNULL( u.Factor, 1) * ISNULL(vd.CantidadPendiente,0)) - SUM(ISNULL(w.Cantidad,0)) + SUM(ISNULL(w.Cantidad,0))
WHEN (ISNULL( u.Factor, 1) * ISNULL(vd.CantidadPendiente,0)) - SUM(ISNULL(w.Cantidad,0)) = 0
THEN ISNULL(vd.Cantidad,0)
ELSE (ISNULL( u.Factor, 1) * ISNULL(vd.CantidadPendiente,0)) - SUM(ISNULL(w.Cantidad,0))
END
ELSE
CASE WHEN (ISNULL( au.Factor, 1) * ISNULL(vd.CantidadPendiente,0)) - SUM(ISNULL(w.Cantidad,0)) < 0
THEN (ISNULL( au.Factor, 1) * ISNULL(vd.CantidadPendiente,0)) - SUM(ISNULL(w.Cantidad,0)) + SUM(ISNULL(w.Cantidad,0))
WHEN (ISNULL( au.Factor, 1) * ISNULL(vd.CantidadPendiente,0)) - SUM(ISNULL(w.Cantidad,0)) = 0
THEN (ISNULL( au.Factor, 1) * ISNULL(vd.Cantidad,0))
ELSE (ISNULL( au.Factor, 1) * ISNULL(vd.CantidadPendiente,0)) - SUM(ISNULL(w.Cantidad,0))
END
END,
ISNULL(v.PosicionWMS, a.DefPosicionSurtido), vd.Articulo, vd.Almacen, 1, v.AlmacenDestino, vd.Unidad,
vd.Cantidad, vd.SubCuenta
FROM Inv v
JOIN InvD vd ON v.ID = vd.ID
JOIN Alm a ON vd.Almacen = a.Almacen
LEFT OUTER JOIN WMSModuloTarima w ON w.IDModulo = v.ID AND w.Modulo = @Modulo AND w.IDTMA IS NOT NULL AND Utilizar = 1
LEFT OUTER JOIN TMA t ON t.ID = w.IDTMA AND t.Estatus <> 'CANCELADO'
LEFT OUTER JOIN EmpresaCfg2 g ON v.Empresa = g.Empresa
LEFT OUTER JOIN Unidad u ON vd.Unidad = u.Unidad
LEFT OUTER JOIN ArtUnidad au ON vd.Articulo = au.Articulo AND vd.Unidad = au.Unidad
WHERE v.ID = @ID
AND v.Mov IN(SELECT Movimiento FROM WMSModuloMovimiento WHERE Modulo = @Modulo)
AND v.Estatus = (SELECT Estatus FROM WMSModuloMovimiento WHERE Modulo = @Modulo AND Movimiento = v.Mov)
AND NULLIF(vd.Tarima,'') IS NULL
AND Isnull(vd.CantidadPendiente, '') > 0
AND ISNULL(v.OrigenTipo,'') <> 'EXTVT'
GROUP BY v.ID, vd.Renglon, vd.RenglonSub, ISNULL(vd.CantidadPendiente,0) , ISNULL(v.PosicionWMS, a.DefPosicionSurtido), vd.Articulo, vd.Almacen, vd.Cantidad, g.NivelFactorMultiUnidad, ISNULL( u.Factor, 1), ISNULL( au.Factor, 1), v.AlmacenDestino, vd.Unidad, vd.SubCuenta
INSERT #CualesID VALUES (@@IDENTITY)
DELETE WMSModuloTarima
WHERE ID IN((SELECT s.ID
FROM WMSModuloTarima w
JOIN WMSModuloTarima s
ON w.IDModulo = s.IDModulo
AND w.Modulo = s.Modulo
AND w.Articulo = s.Articulo
AND w.Renglon = s.Renglon
AND s.TarimaSurtido = NULL
AND s.IDTMA = NULL
AND w.RenglonSub = s.RenglonSub
WHERE w.ID IN (SELECT ID FROM #CualesID)
AND s.ID NOT IN (SELECT ID FROM #CualesID)))
/*************************     VENTAS     *****************************/
IF @Modulo = 'VTAS'
INSERT WMSLista  (Estacion, Modulo, IDModulo, Articulo, Cantidad, Unidad, CantidadUnidad, SubCuenta)
SELECT @Estacion, @Modulo, @ID, vd.Articulo, CASE g.NivelFactorMultiUnidad WHEN 'Unidad' THEN ISNULL( u.Factor, 1) * vd.CantidadPendiente ELSE ISNULL( au.Factor, 1) * vd.CantidadPendiente END, vd.unidad, vd.Cantidad, vd.SubCuenta
FROM VentaD vd
JOIN Venta v
ON vd.ID = v.ID
LEFT OUTER JOIN EmpresaCfg2 g
ON v.Empresa = g.Empresa
LEFT OUTER JOIN Unidad u
ON vd.Unidad = u.Unidad
LEFT OUTER JOIN ArtUnidad au
ON vd.Articulo = au.Articulo AND vd.Unidad = au.Unidad
WHERE vd.ID = @ID
AND NULLIF(vd.Tarima,'') IS NULL
AND Isnull(vd.CantidadPendiente, '') > 0
/*************************     COMPRAS     *****************************/
IF @Modulo = 'COMS'
INSERT WMSLista(Estacion, Modulo, IDModulo, Articulo, Cantidad, Unidad, CantidadUnidad, SubCuenta)
SELECT @Estacion, @Modulo, @ID, vd.Articulo, CASE g.NivelFactorMultiUnidad WHEN 'Unidad' THEN ISNULL( u.Factor, 1) * ISNULL(vd.CantidadPendiente, vd.Cantidad) ELSE ISNULL( au.Factor, 1) * ISNULL(vd.CantidadPendiente, vd.Cantidad) END, vd.unidad, vd.Cantidad, vd.SubCuenta
FROM CompraD vd
JOIN Compra v
ON vd.ID = v.ID
LEFT OUTER JOIN EmpresaCfg2 g
ON v.Empresa = g.Empresa
LEFT OUTER JOIN Unidad u
ON vd.Unidad = u.Unidad
LEFT OUTER JOIN ArtUnidad au
ON vd.Articulo = au.Articulo AND vd.Unidad = au.Unidad
WHERE vd.ID = @ID
AND NULLIF(vd.Tarima,'') IS NULL
/*************************     INVENTARIOS     *****************************/
IF @Modulo = 'INV'
INSERT WMSLista(Estacion, Modulo, IDModulo, Articulo, Cantidad, Unidad, CantidadUnidad, SubCuenta)
SELECT @Estacion, @Modulo, @ID, vd.Articulo, CASE g.NivelFactorMultiUnidad WHEN 'Unidad' THEN ISNULL( u.Factor, 1) * vd.CantidadPendiente ELSE ISNULL( au.Factor, 1) * vd.CantidadPendiente END, vd.unidad, vd.Cantidad, vd.SubCuenta
FROM InvD  vd
JOIN INV v ON vd.ID = v.ID
LEFT OUTER JOIN EmpresaCfg2 g ON v.Empresa = g.Empresa
LEFT OUTER JOIN Unidad u ON vd.Unidad = u.Unidad
LEFT OUTER JOIN ArtUnidad au ON vd.Articulo = au.Articulo AND vd.Unidad = au.Unidad
WHERE vd.ID = @ID
AND NULLIF(vd.Tarima,'') IS NULL
AND Isnull(vd.CantidadPendiente, '') > 0
AND ISNULL(v.OrigenTipo,'') <> 'EXTVT'
FETCH NEXT FROM crInicial INTO @Modulo, @ID
END
CLOSE crInicial
DEALLOCATE crInicial
SELECT TOP 1 @Hasta = ID
FROM #CualesID
ORDER BY ID DESC
TRUNCATE TABLE #CualesID
SELECT @Desde = @Desde + 1
WHILE @Desde <= @Hasta
BEGIN
INSERT #CualesID SELECT @Desde
SELECT @Desde = @Desde + 1
END
INSERT #Anden SELECT COUNT(DISTINCT PosicionDestino) FROM WMSModuloTarima WHERE ID IN(SELECT ID FROM #CualesID) GROUP BY PosicionDestino
IF @Modulo IS NULL
BEGIN
IF @EnSilencio = 0
SELECT 'Favor de Seleccionar un Movimiento'
RETURN
END
DECLARE crSugerir CURSOR LOCAL STATIC FOR
SELECT Modulo, IDModulo
FROM WMSLista
WHERE Estacion = @Estacion
GROUP BY Modulo, IDModulo
ORDER BY Modulo,IDModulo
OPEN crSugerir
FETCH NEXT FROM crSugerir INTO @Modulo, @IDAux
WHILE @@FETCH_STATUS = 0
BEGIN
IF @Modulo = 'VTAS'
BEGIN
DELETE SerieLoteMov WHERE Modulo = @Modulo AND ID = @IDAux AND Tarima NOT IN(SELECT Tarima FROM VentaD WHERE ID = @IDAux)
DECLARE crubicacion CURSOR LOCAL STATIC FOR
SELECT SUM(vd.CantidadPendiente) AS Cantidad,
vd.Articulo,
vd.SubCuenta,
vd.Almacen,
vd.Renglon,
vd.RenglonID,
mt.Clave,
v.Sucursal,
ar.ControlArticulo,
ar.Tipo,
v.MovID
FROM Venta v
JOIN MovTipo mt ON v.Mov = mt.Mov AND mt.Modulo = @Modulo
JOIN VentaD vd ON v.ID = vd.ID
JOIN Art ar ON vd.Articulo = ar.Articulo
LEFT JOIN SerieLoteMov slm ON vd.ID = slm.ID
AND vd.RenglonID = slm.RenglonID
AND vd.Articulo = slm.Articulo
AND ISNULL(vd.SubCuenta,'') = ISNULL(slm.SubCuenta,ISNULL(vd.SubCuenta,''))
AND slm.Modulo = @Modulo AND v.Empresa = slm.Empresa
LEFT JOIN WMSModuloTarima w ON w.IDModulo = v.ID
AND w.Modulo = @Modulo
AND w.IDTMA IS NOT NULL
AND Utilizar = 1
WHERE v.ID = @IDAux
AND NULLIF(vd.Tarima,'') IS NULL
AND Isnull(vd.CantidadPendiente, '') > 0
AND slm.SerieLote IS NULL
GROUP BY v.ID, vd.Articulo, vd.SubCuenta, vd.Almacen, vd.Renglon, vd.RenglonID,
mt.Clave, mt.Clave, v.Sucursal, w.Tarima, ar.ControlArticulo, ar.Tipo, v.MovID
END
ELSE
IF @Modulo = 'COMS'
BEGIN
DELETE SerieLoteMov WHERE Modulo = @Modulo AND ID = @IDAux AND Tarima NOT IN(SELECT Tarima FROM CompraD WHERE ID = @IDAux)
DECLARE crubicacion CURSOR local static FOR
SELECT SUM(vd.CantidadPendiente) AS Cantidad,
vd.Articulo,
vd.SubCuenta,
vd.Almacen,
vd.Renglon,
vd.RenglonID,
mt.Clave,
v.Sucursal,
ar.ControlArticulo,
ar.Tipo,
v.MovID
FROM Compra v
JOIN MovTipo mt ON v.Mov = mt.Mov AND mt.Modulo = @Modulo
JOIN CompraD vd ON v.ID = vd.ID
JOIN Art ar ON vd.Articulo = ar.Articulo
LEFT JOIN SerieLoteMov slm ON vd.ID = slm.ID AND vd.RenglonID = slm.RenglonID AND vd.Articulo = slm.Articulo AND ISNULL(vd.SubCuenta,'') = ISNULL(slm.SubCuenta,ISNULL(vd.SubCuenta,'')) AND slm.Modulo = @Modulo AND v.Empresa = slm.Empresa
LEFT JOIN WMSModuloTarima w ON w.IDModulo = v.ID AND w.Modulo = @Modulo AND w.IDTMA IS NOT NULL AND Utilizar = 1
WHERE v.ID = @IDAux
AND NULLIF(vd.Tarima,'') IS NULL
AND Isnull(vd.CantidadPendiente, '') > 0
AND slm.SerieLote IS NULL
GROUP BY v.ID, vd.Articulo, vd.SubCuenta, vd.Almacen, vd.Renglon, vd.RenglonID,
mt.Clave, mt.Clave, v.Sucursal, w.Tarima, ar.ControlArticulo, ar.Tipo, v.MovID
END
ELSE
IF @Modulo = 'INV'
BEGIN
DELETE SerieLoteMov WHERE Modulo = @Modulo AND ID = @IDAux AND Tarima NOT IN(SELECT Tarima FROM InvD WHERE ID = @IDAux)
DECLARE crUbicacion CURSOR LOCAL STATIC FOR
SELECT SUM(vd.CantidadPendiente) AS Cantidad,
vd.Articulo,
vd.SubCuenta,
vd.Almacen,
vd.Renglon,
vd.RenglonID,
mt.Clave,
v.Sucursal,
ar.ControlArticulo,
ar.Tipo,
v.MovID
FROM Inv v
JOIN MovTipo mt ON v.Mov = mt.Mov AND mt.Modulo = @Modulo
JOIN InvD vd ON v.ID = vd.ID
JOIN Art ar ON vd.Articulo = ar.Articulo
LEFT JOIN SerieLoteMov slm ON vd.ID = slm.ID AND vd.RenglonID = slm.RenglonID AND vd.Articulo = slm.Articulo AND ISNULL(vd.SubCuenta,'') = ISNULL(slm.SubCuenta,ISNULL(vd.SubCuenta,'')) AND slm.Modulo = @Modulo AND v.Empresa = slm.Empresa
LEFT JOIN WMSModuloTarima w ON w.IDModulo = v.ID AND w.Modulo = @Modulo AND w.IDTMA IS NOT NULL AND Utilizar = 1
WHERE v.ID = @IDAux
AND NULLIF(vd.Tarima,'') IS NULL
AND Isnull(vd.CantidadPendiente, '') > 0
AND slm.SerieLote IS NULL
AND ISNULL(v.OrigenTipo,'') <> 'EXTVT'
GROUP BY v.ID, vd.Articulo, vd.SubCuenta, vd.Almacen, vd.Renglon, vd.RenglonID,
mt.Clave, mt.Clave, v.Sucursal, w.Tarima, ar.ControlArticulo, ar.Tipo, v.MovID
END
OPEN crUbicacion
FETCH NEXT FROM crUbicacion INTO @Cantidad, @Articulo, @SubCuenta, @Almacen, @Renglon, @RenglonID, @MovTipo, @Sucursal, @ControlArticulo, @Tipo, @MovID
WHILE @@FETCH_STATUS = 0
BEGIN
SET @CantidadFaltante = @Cantidad
DECLARE crSerieLoteU CURSOR LOCAL STATIC FOR
SELECT t.Tarima,
'',
ISNULL(adt.Disponible,0) - ISNULL(adt.Apartado,0) - ISNULL(asg.Asignado,0) AS Disponible,
ap.Posicion,
ap.Tipo,
t.FechaCaducidad
FROM ArtDisponibleTarima adt
JOIN Tarima t ON adt.Almacen = t.Almacen AND adt.Tarima = t.Tarima AND t.tarima NOT LIKE '%CC%'
JOIN AlmPos ap ON t.Almacen=ap.Almacen AND t.Posicion=ap.Posicion
LEFT JOIN @Asignado asg ON adt.Empresa = asg.Empresa AND adt.Articulo = asg.Articulo AND adt.Almacen = asg.Almacen AND adt.Tarima = asg.Tarima
WHERE adt.Empresa = @Empresa
AND adt.Articulo = @Articulo
AND adt.Almacen = @Almacen
AND ISNULL(adt.Disponible,0) - ISNULL(adt.Apartado,0) - ISNULL(asg.Asignado,0) > 0
AND t.Estatus = 'ALTA'
AND ap.Tipo <> 'Surtido'
ORDER BY
CASE @ControlArticulo WHEN 'Fecha Entrada' THEN T.Alta
WHEN 'Caducidad'     THEN T.FechaCaducidad
WHEN 'Posición'
THEN CASE WHEN ap.Tipo = 'Cross Docking' THEN 0
WHEN ap.Tipo = 'Ubicacion' AND (adt.Disponible - ISNULL(adt.Apartado,0) - ISNULL(asg.Asignado,0)) <= @Cantidad THEN 1
WHEN ap.Tipo = 'Domicilio' THEN 2
WHEN ap.Tipo = 'Ubicacion' AND (adt.Disponible - ISNULL(adt.Apartado,0) - ISNULL(asg.Asignado,0)) > @Cantidad AND @WMSPCKUbicacion = 1 THEN 3
END
END,
CASE WHEN ap.Tipo = 'Cross Docking' THEN 0
WHEN ap.Tipo = 'Ubicacion' AND (ISNULL(adt.Apartado,0) - ISNULL(asg.Asignado,0)) <= @Cantidad THEN 1
WHEN ap.Tipo = 'Domicilio' THEN 2
WHEN ap.Tipo = 'Ubicacion' AND (ISNULL(adt.Apartado,0) - ISNULL(asg.Asignado,0)) > @Cantidad THEN 3
END
OPEN crSerieLoteU
FETCH NEXT FROM crSerieLoteU INTO @Tarima, @SerieLote, @Disponible, @Posicion, @PosicionTipo, @FechaCaducidad
WHILE @@FETCH_STATUS = 0 AND @Cantidad > 0
BEGIN
EXEC spTMAArtDomicilioInicializar @Empresa, @Almacen, @Articulo, NULL
SELECT @SucursalDestino = Sucursal,
@Referencia = 'Sucursal Destino ' + CONVERT(varchar(max), Sucursal)
FROM Alm
JOIN WMSModuloTarima ON Alm.Almacen = ISNULL(WMSModuloTarima.AlmacenDestino,WMSModuloTarima.Almacen)
WHERE WMSModuloTarima.Modulo = @Modulo
AND WMSModuloTarima.IDModulo = @IDAux
SELECT @ControlArticulo = ControlArticulo,
@ArtSerieLoteInfo = SerieLoteInfo,
@TipoArt = Tipo
FROM Art
WHERE Articulo  = @Articulo
SELECT TOP 1 @Zona = Zona FROM ArtZona WHERE Articulo = @Articulo ORDER BY Orden
IF @ControlArticulo IS NULL OR @ControlArticulo = ''
BEGIN
SELECT @OK = 10036, @OkRef = @Articulo
IF @OK IS NOT NULL
BREAK
END
SET @CantidadFaltante = @Cantidad
/********     CROSS DOCKING     ********/
IF @PosicionTipo = 'Cross Docking' AND @Cantidad > 0
BEGIN
IF @Disponible >= @CantidadFaltante AND @Disponible > 0 AND @CantidadFaltante > 0
BEGIN
IF EXISTS(SELECT *
FROM @Asignado
WHERE Empresa = @Empresa
AND Articulo = @Articulo
AND ISNULL(Subcuenta,'') = ISNULL(@SubCuenta,'')
AND Almacen = @Almacen
AND Sucursal = @Sucursal
AND ISNULL(SerieLote,'') =  ISNULL(@SerieLote,'')
AND Tarima = @Tarima)
UPDATE @Asignado SET Asignado = ISNULL(Asignado,0) + @Cantidad
WHERE Empresa = @Empresa
AND Articulo = @Articulo
AND ISNULL(Subcuenta,'') = ISNULL(@SubCuenta,'')
AND Almacen = @Almacen
AND Sucursal = @Sucursal
AND ISNULL(SerieLote,'') =  ISNULL(@SerieLote,'')
AND Tarima = @Tarima
ELSE
INSERT @Asignado(Empresa, Articulo, Subcuenta, Almacen, Sucursal, SerieLote, Tarima, Asignado)
SELECT @Empresa, @Articulo, ISNULL(@SubCuenta,''), @Almacen, @Sucursal, @SerieLote, @Tarima, @Cantidad
IF @SerieLote <> ''
BEGIN
IF EXISTS (SELECT *
FROM SerieLoteMov
WHERE ID = @IDAux
AND RenglonID = @RenglonID
AND Articulo = @Articulo
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
AND SerieLote = @SerieLote
AND Modulo = @Modulo
AND Empresa = @Empresa
AND Tarima = @Tarima)
UPDATE SerieLoteMov SET Cantidad = Cantidad + @Cantidad
WHERE ID = @IDAux
AND RenglonID = @RenglonID
AND Articulo = @Articulo
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
AND SerieLote = @SerieLote
AND Modulo = @Modulo
AND Empresa = @Empresa
AND Tarima = @Tarima
ELSE
INSERT SerieLoteMov (Empresa,  Sucursal,  Modulo,  ID,  RenglonID,  Articulo,
SubCuenta,  SerieLote, Cantidad, Tarima)
VALUES (@Empresa, @Sucursal, @Modulo, @IDAux, @RenglonID, @Articulo,
ISNULL(@SubCuenta,''), @SerieLote, @Cantidad, @Tarima)
END
INSERT @PreparaDatosSurtir (Modulo, Mov, Moduloid, Cantidad, Pocicion, Articulo, SubCuenta, Almacen, Unidad, CantidadUnidad, Factor, RenglonID, SerieLote, Tarima)
EXEC spPreparaDatosSurtir @Modulo, @IDAux, @Articulo, @Renglon, @RenglonID, @Empresa, @Tarima, @SerieLote
SET @IDPrepDatosSur = @@IDENTITY
INSERT WMSSurtidoProcesarD (Estacion, Modulo, Mov, ModuloID, Procesado, Articulo, Tarima, PosicionDestino,
CantidadTarima, PosicionOrigen, Tipo, Zona, Almacen, Referencia, Unidad, CantidadUnidad,
SucursalFiltro, SubCuenta, TarimaFechaCaducidad, SerieLote, PCKUbicacion, MovID)
SELECT @Estacion, Modulo, Mov, Moduloid, 0, Articulo, Tarima, Pocicion,
CASE WHEN ISNULL(SerieLote,'') <> '' THEN Cantidad ELSE @Cantidad END,
@Posicion, @PosicionTipo, @Zona, Almacen, @Referencia, Unidad,
CASE WHEN ISNULL(SerieLote,'') <> '' THEN Cantidad ELSE @Cantidad END,
0, SubCuenta, @FechaCaducidad, SerieLote, 0, @MovID
FROM @PreparaDatosSurtir
WHERE ID = @IDPrepDatosSur
/***     NO CAMBIAR EL ORDEN DE LAS RESTAS     ***/
SET @CantidadFaltante = @CantidadFaltante - @Cantidad
SET @Disponible = @Disponible - @Cantidad
SET @Cantidad = @Cantidad - @Cantidad
/*************************************************/
END
IF @Disponible < @Cantidad AND @Disponible > 0 AND @CantidadFaltante > 0
BEGIN
IF EXISTS(SELECT *
FROM @Asignado
WHERE Empresa = @Empresa
AND Articulo = @Articulo
AND ISNULL(Subcuenta,'') = ISNULL(@SubCuenta,'')
AND Almacen = @Almacen
AND Sucursal = @Sucursal
AND ISNULL(SerieLote,'') =  ISNULL(@SerieLote,'')
AND Tarima = @Tarima)
UPDATE @Asignado SET Asignado = ISNULL(Asignado,0) + @Disponible
WHERE Empresa = @Empresa
AND Articulo = @Articulo
AND ISNULL(Subcuenta,'') = ISNULL(@SubCuenta,'')
AND Almacen = @Almacen
AND Sucursal = @Sucursal
AND ISNULL(SerieLote,'') =  ISNULL(@SerieLote,'')
AND Tarima = @Tarima
ELSE
INSERT @Asignado(Empresa, Articulo, Subcuenta, Almacen, Sucursal, SerieLote, Tarima, Asignado)
SELECT @Empresa, @Articulo, ISNULL(@SubCuenta,''), @Almacen, @Sucursal, @SerieLote, @Tarima, @Disponible
INSERT @PreparaDatosSurtir (Modulo, Mov, Moduloid, Cantidad, Pocicion, Articulo, SubCuenta, Almacen, Unidad, CantidadUnidad, Factor, RenglonID, SerieLote, Tarima)
EXEC spPreparaDatosSurtir @Modulo, @IDAux, @Articulo, @Renglon, @RenglonID, @Empresa, @Tarima, @SerieLote
SET @IDPrepDatosSur = @@IDENTITY
INSERT WMSSurtidoProcesarD (Estacion, Modulo, Mov, ModuloID, Procesado, Articulo, Tarima, PosicionDestino,
CantidadTarima, PosicionOrigen, Tipo, Zona, Almacen, Referencia, Unidad, CantidadUnidad,
SucursalFiltro, SubCuenta, TarimaFechaCaducidad, SerieLote, PCKUbicacion, MovID)
SELECT @Estacion, Modulo, Mov, Moduloid, 0, Articulo, Tarima, Pocicion,
CASE WHEN ISNULL(SerieLote,'') <> '' THEN Cantidad ELSE @Disponible END,
@Posicion, @PosicionTipo, @Zona, Almacen, @Referencia, Unidad,
CASE WHEN ISNULL(SerieLote,'') <> '' THEN Cantidad ELSE @Disponible END,
0, SubCuenta, @FechaCaducidad, SerieLote, 0, @MovID
FROM @PreparaDatosSurtir
WHERE ID = @IDPrepDatosSur
/***     NO CAMBIAR EL ORDEN DE LAS RESTAS     ***/
SET @Cantidad = @Cantidad - @Disponible
SET @CantidadFaltante = @CantidadFaltante - @Disponible
SET @Disponible = @Disponible - @Disponible
/*************************************************/
END
END
/********     UBICACION (Tarima Completa)     ********/
IF @PosicionTipo = 'Ubicacion' AND @Disponible <= @CantidadFaltante AND @CantidadFaltante > 0
BEGIN
IF @Disponible >= @Cantidad AND @Disponible > 0 AND @CantidadFaltante > 0
BEGIN
IF EXISTS(SELECT *
FROM @Asignado
WHERE Empresa = @Empresa
AND Articulo = @Articulo
AND ISNULL(Subcuenta,'') = ISNULL(@SubCuenta,'')
AND Almacen = @Almacen
AND Sucursal = @Sucursal
AND ISNULL(SerieLote,'') =  ISNULL(@SerieLote,'')
AND Tarima = @Tarima)
UPDATE @Asignado SET Asignado = ISNULL(Asignado,0) + @Cantidad
WHERE Empresa = @Empresa
AND Articulo = @Articulo
AND ISNULL(Subcuenta,'') = ISNULL(@SubCuenta,'')
AND Almacen = @Almacen
AND Sucursal = @Sucursal
AND ISNULL(SerieLote,'') =  ISNULL(@SerieLote,'')
AND Tarima = @Tarima
ELSE
INSERT @Asignado(Empresa, Articulo, Subcuenta, Almacen, Sucursal, SerieLote, Tarima, Asignado)
SELECT @Empresa, @Articulo, ISNULL(@SubCuenta,''), @Almacen, @Sucursal, @SerieLote, @Tarima, @Cantidad
INSERT @PreparaDatosSurtir (Modulo, Mov, Moduloid, Cantidad, Pocicion, Articulo, SubCuenta, Almacen, Unidad, CantidadUnidad, Factor, RenglonID, SerieLote, Tarima)
EXEC spPreparaDatosSurtir @Modulo, @IDAux, @Articulo, @Renglon, @RenglonID, @Empresa, @Tarima, @SerieLote
SET @IDPrepDatosSur = @@IDENTITY
INSERT WMSSurtidoProcesarD (Estacion, Modulo, Mov, ModuloID, Procesado, Articulo, Tarima, PosicionDestino,
CantidadTarima, PosicionOrigen, Tipo, Zona, Almacen, Referencia, Unidad, CantidadUnidad,
SucursalFiltro, SubCuenta, TarimaFechaCaducidad, SerieLote, PCKUbicacion, MovID)
SELECT @Estacion, Modulo, Mov, Moduloid, 0, Articulo, Tarima, Pocicion,
CASE WHEN ISNULL(SerieLote,'') <> '' THEN Cantidad ELSE @Cantidad END,
@Posicion, @PosicionTipo, @Zona, Almacen, @Referencia, Unidad,
CASE WHEN ISNULL(SerieLote,'') <> '' THEN Cantidad ELSE @Cantidad END,
0, SubCuenta, @FechaCaducidad, SerieLote, 0, @MovID
FROM @PreparaDatosSurtir
WHERE ID = @IDPrepDatosSur
/***     NO CAMBIAR EL ORDEN DE LAS RESTAS     ***/
SET @CantidadFaltante = @CantidadFaltante - @Cantidad
SET @Disponible = @Disponible - @Cantidad
SET @Cantidad = @Cantidad - @Cantidad
/*************************************************/
END
IF @Disponible < @Cantidad AND @Disponible > 0 AND @CantidadFaltante > 0
BEGIN
IF EXISTS(SELECT *
FROM @Asignado
WHERE Empresa = @Empresa
AND Articulo = @Articulo
AND ISNULL(Subcuenta,'') = ISNULL(@SubCuenta,'')
AND Almacen = @Almacen
AND Sucursal = @Sucursal
AND ISNULL(SerieLote,'') =  ISNULL(@SerieLote,'')
AND Tarima = @Tarima)
UPDATE @Asignado SET Asignado = ISNULL(Asignado,0) + @Disponible
WHERE Empresa = @Empresa
AND Articulo = @Articulo
AND ISNULL(Subcuenta,'') = ISNULL(@SubCuenta,'')
AND Almacen = @Almacen
AND Sucursal = @Sucursal
AND ISNULL(SerieLote,'') =  ISNULL(@SerieLote,'')
AND Tarima = @Tarima
ELSE
INSERT @Asignado(Empresa, Articulo, Subcuenta, Almacen, Sucursal, SerieLote, Tarima, Asignado)
SELECT @Empresa, @Articulo, ISNULL(@SubCuenta,''), @Almacen, @Sucursal, @SerieLote, @Tarima, @Disponible
INSERT @PreparaDatosSurtir (Modulo, Mov, Moduloid, Cantidad, Pocicion, Articulo, SubCuenta, Almacen, Unidad, CantidadUnidad, Factor, RenglonID, SerieLote, Tarima)
EXEC spPreparaDatosSurtir @Modulo, @IDAux, @Articulo, @Renglon, @RenglonID, @Empresa, @Tarima, @SerieLote
SET @IDPrepDatosSur = @@IDENTITY
INSERT WMSSurtidoProcesarD (Estacion, Modulo, Mov, ModuloID, Procesado, Articulo, Tarima, PosicionDestino,
CantidadTarima, PosicionOrigen, Tipo, Zona, Almacen, Referencia, Unidad, CantidadUnidad,
SucursalFiltro, SubCuenta, TarimaFechaCaducidad, SerieLote, PCKUbicacion, MovID)
SELECT @Estacion, Modulo, Mov, Moduloid, 0, Articulo, Tarima, Pocicion,
CASE WHEN ISNULL(SerieLote,'') <> '' THEN Cantidad ELSE @Disponible END,
@Posicion, @PosicionTipo, @Zona, Almacen, @Referencia, Unidad,
CASE WHEN ISNULL(SerieLote,'') <> '' THEN Cantidad ELSE @Disponible END,
0, SubCuenta, @FechaCaducidad, SerieLote, 0, @MovID
FROM @PreparaDatosSurtir
WHERE ID = @IDPrepDatosSur
/***     NO CAMBIAR EL ORDEN DE LAS RESTAS     ***/
SET @Cantidad = @Cantidad - @Disponible
SET @CantidadFaltante = @CantidadFaltante - @Disponible
SET @Disponible = @Disponible - @Disponible
/*************************************************/
END
END
/********     DOMICILIO     ********/
IF @PosicionTipo = 'Domicilio'
BEGIN
IF @Disponible >= @Cantidad AND @Disponible > 0 AND @CantidadFaltante > 0
BEGIN
IF EXISTS(SELECT *
FROM @Asignado
WHERE Empresa = @Empresa
AND Articulo = @Articulo
AND ISNULL(Subcuenta,'') = ISNULL(@SubCuenta,'')
AND Almacen = @Almacen
AND Sucursal = @Sucursal
AND ISNULL(SerieLote,'') =  ISNULL(@SerieLote,'')
AND Tarima = @Tarima)
UPDATE @Asignado SET Asignado = ISNULL(Asignado,0) + @Cantidad
WHERE Empresa = @Empresa
AND Articulo = @Articulo
AND ISNULL(Subcuenta,'') = ISNULL(@SubCuenta,'')
AND Almacen = @Almacen
AND Sucursal = @Sucursal
AND ISNULL(SerieLote,'') =  ISNULL(@SerieLote,'')
AND Tarima = @Tarima
ELSE
INSERT @Asignado(Empresa, Articulo, Subcuenta, Almacen, Sucursal, SerieLote, Tarima, Asignado)
SELECT @Empresa, @Articulo, ISNULL(@SubCuenta,''), @Almacen, @Sucursal, @SerieLote, @Tarima, @Cantidad
INSERT @PreparaDatosSurtir (Modulo, Mov, Moduloid, Cantidad, Pocicion, Articulo, SubCuenta, Almacen, Unidad, CantidadUnidad, Factor, RenglonID, SerieLote, Tarima)
EXEC spPreparaDatosSurtir @Modulo, @IDAux, @Articulo, @Renglon, @RenglonID, @Empresa, @Tarima, @SerieLote
SET @IDPrepDatosSur = @@IDENTITY
INSERT WMSSurtidoProcesarD (Estacion, Modulo, Mov, ModuloID, Procesado, Articulo, Tarima, PosicionDestino,
CantidadTarima, PosicionOrigen, Tipo, Zona, Almacen, Referencia, Unidad, CantidadUnidad,
SucursalFiltro, SubCuenta, TarimaFechaCaducidad, SerieLote, PCKUbicacion, MovID)
SELECT @Estacion, Modulo, Mov, Moduloid, 0, Articulo, Tarima, Pocicion,
CASE WHEN ISNULL(SerieLote,'') <> '' THEN Cantidad ELSE @Cantidad END,
@Posicion, @PosicionTipo, @Zona, Almacen, @Referencia, Unidad,
CASE WHEN ISNULL(SerieLote,'') <> '' THEN Cantidad ELSE @Cantidad END,
0, SubCuenta, @FechaCaducidad, SerieLote, 0, @MovID
FROM @PreparaDatosSurtir
WHERE ID = @IDPrepDatosSur
/***     NO CAMBIAR EL ORDEN DE LAS RESTAS     ***/
SET @CantidadFaltante = @CantidadFaltante - @Cantidad
SET @Disponible = @Disponible - @Cantidad
SET @Cantidad = @Cantidad - @Cantidad
/*************************************************/
END
IF @Disponible < @Cantidad AND @Disponible > 0 AND @CantidadFaltante > 0
BEGIN
IF EXISTS(SELECT *
FROM @Asignado
WHERE Empresa = @Empresa
AND Articulo = @Articulo
AND ISNULL(Subcuenta,'') = ISNULL(@SubCuenta,'')
AND Almacen = @Almacen
AND Sucursal = @Sucursal
AND ISNULL(SerieLote,'') =  ISNULL(@SerieLote,'')
AND Tarima = @Tarima)
UPDATE @Asignado SET Asignado = ISNULL(Asignado,0) + @Disponible
WHERE Empresa = @Empresa
AND Articulo = @Articulo
AND ISNULL(Subcuenta,'') = ISNULL(@SubCuenta,'')
AND Almacen = @Almacen
AND Sucursal = @Sucursal
AND ISNULL(SerieLote,'') =  ISNULL(@SerieLote,'')
AND Tarima = @Tarima
ELSE
INSERT @Asignado(Empresa, Articulo, Subcuenta, Almacen, Sucursal, SerieLote, Tarima, Asignado)
SELECT @Empresa, @Articulo, ISNULL(@SubCuenta,''), @Almacen, @Sucursal, @SerieLote, @Tarima, @Disponible
INSERT @PreparaDatosSurtir (Modulo, Mov, Moduloid, Cantidad, Pocicion, Articulo, SubCuenta, Almacen, Unidad, CantidadUnidad, Factor, RenglonID, SerieLote, Tarima)
EXEC spPreparaDatosSurtir @Modulo, @IDAux, @Articulo, @Renglon, @RenglonID, @Empresa, @Tarima, @SerieLote
SET @IDPrepDatosSur = @@IDENTITY
INSERT WMSSurtidoProcesarD (Estacion, Modulo, Mov, ModuloID, Procesado, Articulo, Tarima, PosicionDestino,
CantidadTarima, PosicionOrigen, Tipo, Zona, Almacen, Referencia, Unidad, CantidadUnidad,
SucursalFiltro, SubCuenta, TarimaFechaCaducidad, SerieLote, PCKUbicacion, MovID)
SELECT @Estacion, Modulo, Mov, Moduloid, 0, Articulo, Tarima, Pocicion,
CASE WHEN ISNULL(SerieLote,'') <> '' THEN Cantidad ELSE @Disponible END,
@Posicion, @PosicionTipo, @Zona, Almacen, @Referencia, Unidad,
CASE WHEN ISNULL(SerieLote,'') <> '' THEN Cantidad ELSE @Disponible END,
0, SubCuenta, @FechaCaducidad, SerieLote, 0, @MovID
FROM @PreparaDatosSurtir
WHERE ID = @IDPrepDatosSur
/***     NO CAMBIAR EL ORDEN DE LAS RESTAS     ***/
SET @Cantidad = @Cantidad - @Disponible
SET @CantidadFaltante = @CantidadFaltante - @Disponible
SET @Disponible = @Disponible - @Disponible
/*************************************************/
END
END
IF @PosicionTipo = 'Ubicacion' AND @Disponible > @Cantidad AND @CantidadFaltante > 0 AND @WMSPCKUbicacion = 1
BEGIN
IF @Disponible >= @Cantidad AND @Disponible > 0 AND @CantidadFaltante > 0
BEGIN
IF EXISTS(SELECT *
FROM @Asignado
WHERE Empresa = @Empresa
AND Articulo = @Articulo
AND ISNULL(Subcuenta,'') = ISNULL(@SubCuenta,'')
AND Almacen = @Almacen
AND Sucursal = @Sucursal
AND ISNULL(SerieLote,'') =  ISNULL(@SerieLote,'')
AND Tarima = @Tarima)
UPDATE @Asignado SET Asignado = ISNULL(Asignado,0) + @Cantidad
WHERE Empresa = @Empresa
AND Articulo = @Articulo
AND ISNULL(Subcuenta,'') = ISNULL(@SubCuenta,'')
AND Almacen = @Almacen
AND Sucursal = @Sucursal
AND ISNULL(SerieLote,'') =  ISNULL(@SerieLote,'')
AND Tarima = @Tarima
ELSE
INSERT @Asignado(Empresa, Articulo, Subcuenta, Almacen, Sucursal, SerieLote, Tarima, Asignado)
SELECT @Empresa, @Articulo, ISNULL(@SubCuenta,''), @Almacen, @Sucursal, @SerieLote, @Tarima, @Cantidad
INSERT @PreparaDatosSurtir (Modulo, Mov, Moduloid, Cantidad, Pocicion, Articulo, SubCuenta, Almacen, Unidad, CantidadUnidad, Factor, RenglonID, SerieLote, Tarima)
EXEC spPreparaDatosSurtir @Modulo, @IDAux, @Articulo, @Renglon, @RenglonID, @Empresa, @Tarima, @SerieLote
SET @IDPrepDatosSur = @@IDENTITY
INSERT WMSSurtidoProcesarD (Estacion, Modulo, Mov, ModuloID, Procesado, Articulo, Tarima, PosicionDestino,
CantidadTarima, PosicionOrigen, Tipo, Zona, Almacen, Referencia, Unidad, CantidadUnidad,
SucursalFiltro, SubCuenta, TarimaFechaCaducidad, SerieLote, PCKUbicacion, MovID)
SELECT @Estacion, Modulo, Mov, Moduloid, 0, Articulo, Tarima, Pocicion,
CASE WHEN ISNULL(SerieLote,'') <> '' THEN Cantidad ELSE @Cantidad END,
@Posicion, @PosicionTipo, @Zona, Almacen, @Referencia, Unidad,
CASE WHEN ISNULL(SerieLote,'') <> '' THEN Cantidad ELSE @Cantidad END,
0, SubCuenta, @FechaCaducidad, SerieLote, 1, @MovID
FROM @PreparaDatosSurtir
WHERE ID = @IDPrepDatosSur
/***     NO CAMBIAR EL ORDEN DE LAS RESTAS     ***/
SET @CantidadFaltante = @CantidadFaltante - @Cantidad
SET @Disponible = @Disponible - @Cantidad
SET @Cantidad = @Cantidad - @Cantidad
/*************************************************/
END
IF @Disponible < @Cantidad AND @Disponible > 0 AND @CantidadFaltante > 0
BEGIN
IF EXISTS(SELECT *
FROM @Asignado
WHERE Empresa = @Empresa
AND Articulo = @Articulo
AND ISNULL(Subcuenta,'') = ISNULL(@SubCuenta,'')
AND Almacen = @Almacen
AND Sucursal = @Sucursal
AND ISNULL(SerieLote,'') =  ISNULL(@SerieLote,'')
AND Tarima = @Tarima)
UPDATE @Asignado SET Asignado = ISNULL(Asignado,0) + @Disponible
WHERE Empresa = @Empresa
AND Articulo = @Articulo
AND ISNULL(Subcuenta,'') = ISNULL(@SubCuenta,'')
AND Almacen = @Almacen
AND Sucursal = @Sucursal
AND ISNULL(SerieLote,'') =  ISNULL(@SerieLote,'')
AND Tarima = @Tarima
ELSE
INSERT @Asignado(Empresa, Articulo, Subcuenta, Almacen, Sucursal, SerieLote, Tarima, Asignado)
SELECT @Empresa, @Articulo, ISNULL(@SubCuenta,''), @Almacen, @Sucursal, @SerieLote, @Tarima, @Disponible
INSERT @PreparaDatosSurtir (Modulo, Mov, Moduloid, Cantidad, Pocicion, Articulo, SubCuenta, Almacen, Unidad, CantidadUnidad, Factor, RenglonID, SerieLote, Tarima)
EXEC spPreparaDatosSurtir @Modulo, @IDAux, @Articulo, @Renglon, @RenglonID, @Empresa, @Tarima, @SerieLote
SET @IDPrepDatosSur = @@IDENTITY
INSERT WMSSurtidoProcesarD (Estacion, Modulo, Mov, ModuloID, Procesado, Articulo, Tarima, PosicionDestino,
CantidadTarima, PosicionOrigen, Tipo, Zona, Almacen, Referencia, Unidad, CantidadUnidad,
SucursalFiltro, SubCuenta, TarimaFechaCaducidad, SerieLote, PCKUbicacion, MovID)
SELECT @Estacion, Modulo, Mov, Moduloid, 0, Articulo, Tarima, Pocicion,
CASE WHEN ISNULL(SerieLote,'') <> '' THEN Cantidad ELSE @Disponible END,
@Posicion, @PosicionTipo, @Zona, Almacen, @Referencia, Unidad,
CASE WHEN ISNULL(SerieLote,'') <> '' THEN Cantidad ELSE @Disponible END,
0, SubCuenta, @FechaCaducidad, SerieLote, 1, @MovID
FROM @PreparaDatosSurtir
WHERE ID = @IDPrepDatosSur
/***     NO CAMBIAR EL ORDEN DE LAS RESTAS     ***/
SET @Cantidad = @Cantidad - @Disponible
SET @CantidadFaltante = @CantidadFaltante - @Disponible
SET @Disponible = @Disponible - @Disponible
/*************************************************/
END
END
FETCH NEXT FROM crSerieLoteU INTO @Tarima, @SerieLote, @Disponible, @Posicion, @PosicionTipo, @FechaCaducidad
END
CLOSE crSerieLoteU
DEALLOCATE crSerieLoteU
IF @CantidadFaltante > 0
BEGIN
IF NOT EXISTS(SELECT *
FROM WMSSurtidoPendiente
WHERE Estacion = @Estacion
AND Articulo = @Articulo
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
AND Almacen = @Almacen)
INSERT WMSSurtidoPendiente (Estacion, Articulo, Almacen, Cantidad, SubCuenta, ID, Modulo, MovID)
SELECT  @Estacion, @Articulo, @Almacen, @CantidadFaltante, @SubCuenta, @IDAux, @Modulo, @MovID
ELSE
UPDATE WMSSurtidoPendiente
SET Cantidad = ISNULL(Cantidad,0) + @CantidadFaltante
WHERE Estacion = @Estacion
AND Articulo = @Articulo
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
AND Almacen = @Almacen
END
FETCH NEXT FROM crUbicacion INTO @Cantidad, @Articulo, @SubCuenta, @Almacen, @Renglon, @RenglonID, @MovTipo, @Sucursal, @ControlArticulo, @Tipo, @MovID
END
CLOSE crUbicacion
DEALLOCATE crUbicacion
IF @Ok IS NOT NULL
BREAK
FETCH NEXT FROM crSugerir INTO @Modulo, @IDAux
END
CLOSE crSugerir
DEALLOCATE crSugerir
UPDATE WMSModuloTarima SET Utilizar = 0 WHERE ID IN(SELECT ID FROM #CualesID)
DECLARE crSurtidoPendiente CURSOR FOR
SELECT ID, Modulo
FROM WMSSurtidoPendiente
WHERE Estacion = @Estacion
GROUP BY ID, Modulo
OPEN crSurtidoPendiente
FETCH NEXT FROM crSurtidoPendiente INTO @ID, @Modulo
WHILE @@FETCH_STATUS = 0
BEGIN
IF @Modulo = 'VTAS'
SELECT @Mov = Mov FROM Venta WHERE ID = @ID
IF @Modulo = 'COMS'
SELECT @Mov = Mov FROM Compra WHERE ID = @ID
IF @Modulo = 'INV'
SELECT @Mov = Mov FROM Inv WHERE ID = @ID
UPDATE WMSSurtidoPendiente
SET Mov = @Mov
WHERE ID     = @ID
AND Modulo = @Modulo
FETCH NEXT FROM crSurtidoPendiente INTO @ID, @Modulo
END
CLOSE crSurtidoPendiente
DEALLOCATE crSurtidoPendiente
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000 OR @Ok = 80010
BEGIN
IF EXISTS (SELECT * FROM WMSSurtidoPendiente WHERE Estacion = @Estacion)
BEGIN
IF @EnSilencio = 0
SELECT 'Los movimientos seleccionados no podrán ser surtidos en su Totalidad.'
END
ELSE
BEGIN
IF @EnSilencio = 0
SELECT 'Procesadas Con Exito'
END
END
ELSE
BEGIN
IF @OK = 10036
IF @EnSilencio = 0
SELECT Descripcion + ' ' + ISNULL(@OkRef,'')  FROM MensajeLista WHERE Mensaje = @Ok
ELSE
IF @EnSilencio = 0
SELECT Descripcion + ' Articulo ' + ISNULL(@OkRef,'')  FROM MensajeLista WHERE Mensaje = @Ok
DELETE WMSSurtidoProcesarD WHERE Estacion = @Estacion AND Procesado = 0
END
END

