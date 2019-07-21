SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarOrdenTarimaAcomodo
@Tipo			varchar(20),
@Modulo			varchar(5),
@ID               		int,
@Accion			varchar(20),
@Empresa          		varchar(5),
@Sucursal			int,
@Usuario			varchar(10),
@Mov			varchar(20),
@MovID			varchar(20),
@MovTipo			varchar(20),
@FechaEmision		datetime,
@Proyecto			varchar(50),
@Almacen			varchar(10),
@Ok               		int           	OUTPUT,
@OkRef            		varchar(255)  	OUTPUT,
@GenerarOrden		bit		= 1

AS BEGIN
DECLARE
@TMAID		int,
@TMAMov		varchar(20),
@TMAMovID		varchar(20),
@Renglon		float,
@Tarima		varchar(20),
@Posicion		varchar(20),
@PosicionDestino	varchar(20),
@Articulo		varchar(20),
@MovDestino		varchar(20),
@Zona			varchar(50),
@Unidad			varchar(50),
@CantidadUnidad	float,
@Es50			bit,
@FechaCaducidad	datetime,
@SubCuenta   varchar(50),  
@ArticuloTipo      varchar(20), 
@PosicionSubCuenta varchar(50),
@Domicilio		varchar(20),
@Pasillo		int,
@Fila			int,
@TipoEspecial	varchar(20),
@Nivel			int,
@ArtSerieLoteInfo bit, 
@WMSPorcentajeMinimoADom    float 
SELECT @WMSPorcentajeMinimoADom = ISNULL(WMSPorcentajeMinimoADom,0) FROM EmpresaCfg WHERE Empresa = @Empresa 
SELECT @MovDestino = MovDestino FROM AlmSugerirSurtidoTarima WHERE Almacen = @Almacen AND Modulo = @Modulo AND Mov = @Mov AND ModuloDestino IN('TMA', 'WMS')
SELECT @TMAID = NULL, @Renglon = 0.0
IF @Accion = 'CANCELAR'
SELECT @TMAID = MIN(ID)
FROM TMA
WITH(NOLOCK) WHERE OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
ELSE BEGIN
IF @Accion = 'RESERVARPARCIAL' SELECT @Accion = 'AFECTAR'
INSERT TMA (
Empresa,  Sucursal,  Usuario,  Mov,
FechaEmision,  Proyecto,  Estatus,       OrigenTipo, Origen, OrigenID, Almacen, Prioridad)
SELECT @Empresa, @Sucursal, @Usuario, @MovDestino,
@FechaEmision, @Proyecto, 'SINAFECTAR', @Modulo,    @Mov,   @MovID,   @Almacen, 'Alta'
FROM EmpresaCfgMov
WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @TMAID = SCOPE_IDENTITY()
SELECT @PosicionSubCuenta=NULL
IF @Modulo = 'INV'  DECLARE crTarima CURSOR LOCAL FOR SELECT DISTINCT Tarima, Articulo, SubCuenta FROM InvD    WITH(NOLOCK) WHERE ID = @ID AND NULLIF(RTRIM(Tarima), '') IS NOT NULL AND Seccion = CASE WHEN @Tipo = 'RECIBO' AND @MovTipo = 'INV.TMA' THEN 1 ELSE NULL END ELSE
IF @Modulo = 'VTAS' DECLARE crTarima CURSOR LOCAL FOR SELECT DISTINCT Tarima, Articulo, SubCuenta FROM VentaD  WITH(NOLOCK) WHERE ID = @ID AND NULLIF(RTRIM(Tarima), '') IS NOT NULL ELSE
IF @Modulo = 'COMS' DECLARE crTarima CURSOR LOCAL FOR SELECT DISTINCT Tarima, Articulo, SubCuenta FROM CompraD WITH(NOLOCK) WHERE ID = @ID AND NULLIF(RTRIM(Tarima), '') IS NOT NULL ELSE
IF @Modulo = 'PROD' DECLARE crTarima CURSOR LOCAL FOR SELECT DISTINCT Tarima, Articulo, SubCuenta FROM ProdD   WITH(NOLOCK) WHERE ID = @ID AND NULLIF(RTRIM(Tarima), '') IS NOT NULL
OPEN crTarima
FETCH NEXT FROM crTarima  INTO @Tarima, @Articulo, @SubCuenta
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @PosicionDestino = NULL
SELECT @Es50 = 0
/* SELECT @Articulo = NULL
SELECT @Articulo = Articulo FROM ArtDisponibleTarima WITH(NOLOCK) WHERE Empresa = @Empresa AND Almacen = @Almacen AND Tarima = @Tarima
*/
SELECT @ArticuloTipo=Tipo, @ArtSerieLoteInfo=SerieLoteInfo FROM Art WHERE Articulo  = @Articulo 
IF @Tipo = 'RECIBO'
BEGIN
IF NULLIF(@SubCuenta,'') IS NULL 
IF @ArticuloTipo<>'Serie' OR (@ArticuloTipo='Serie' AND @ArtSerieLoteInfo=1) 
EXEC spTMAArtDomicilioInicializar @Empresa, @Almacen, @Articulo, ''
IF EXISTS(SELECT c.*
FROM Inv d
 WITH(NOLOCK) JOIN Inv o  WITH(NOLOCK) ON o.Mov = d.Origen AND o.MovId = d.OrigenID AND d.OrigenTipo = 'INV' AND d.Empresa = o.Empresa
JOIN Compra c  WITH(NOLOCK) ON c.Mov = o.Origen AND c.MovId = o.OrigenID AND o.OrigenTipo = 'COMS' AND c.Empresa = o.Empresa
JOIN MovTipo m  WITH(NOLOCK) ON c.Mov = m.Mov AND m.Modulo = 'COMS'
WHERE d.ID = @ID
AND m.Clave IN('COMS.F', 'COMS.EG', 'COMS.EI')) AND @PosicionDestino IS NULL
BEGIN
IF EXISTS(SELECT ID
FROM InvD WITH(NOLOCK)
WHERE  ID = @ID
AND Seccion = 1
AND Tarima = @Tarima
AND Articulo = @Articulo
AND Almacen = @Almacen
GROUP BY ID, Unidad
HAVING CONVERT(NUMERIC(12,2), SUM(Cantidad)) <= dbo.fnArtUnidadCantidadTarima(@Empresa, @Articulo, Unidad)*(@WMSPorcentajeMinimoADom/100.00) 
)
BEGIN
SELECT @PosicionDestino = NULL
SELECT @PosicionDestino = dbo.fnTMADomicilioDisponible50(@Empresa, @Almacen, @Articulo, @TMAID, @Tarima),
@Es50			  = 1
END
END
IF EXISTS(SELECT oo.*
FROM Inv d
 WITH(NOLOCK) JOIN Inv o  WITH(NOLOCK) ON o.Mov = d.Origen AND o.MovId = d.OrigenID AND d.OrigenTipo = 'INV' AND d.Empresa = o.Empresa
JOIN Inv oo  WITH(NOLOCK) ON o.Origen = oo.Mov AND o.OrigenID = oo.MovID AND o.Empresa = oo.Empresa
JOIN MovTipo m  WITH(NOLOCK) ON oo.Mov = m.Mov AND m.Modulo = 'INV'
WHERE d.ID = @ID
AND m.Clave IN('INV.EI', 'INV.E', 'INV.R')) AND @PosicionDestino IS NULL
BEGIN
IF EXISTS(SELECT ID
FROM InvD WITH(NOLOCK)
WHERE  ID = @ID
AND Seccion = 1
AND Tarima = @Tarima
AND Articulo = @Articulo
AND Almacen = @Almacen
GROUP BY ID, Unidad
HAVING CONVERT(NUMERIC(12,2), SUM(Cantidad)) <= dbo.fnArtUnidadCantidadTarima(@Empresa, @Articulo, Unidad)*(@WMSPorcentajeMinimoADom/100.00) 
)
BEGIN
SELECT @PosicionDestino = NULL
SELECT @PosicionDestino = dbo.fnTMADomicilioDisponible50(@Empresa, @Almacen, @Articulo, @TMAID, @Tarima),
@Es50			  = 1
END
END
IF @PosicionDestino IS NULL AND NULLIF(@SubCuenta,'') IS NULL 
IF @ArticuloTipo<>'Serie' OR (@ArticuloTipo='Serie' AND @ArtSerieLoteInfo=1) 
SELECT @PosicionDestino = dbo.fnTMADomicilioDisponible(@Empresa, @Almacen, @Articulo, @TMAID, @Tarima)
IF ISNULL(@Es50, 0) = 0 AND @PosicionDestino IS NULL
BEGIN
SELECT @FechaCaducidad = ISNULL(FechaCaducidad, Alta) FROM Tarima WHERE Tarima = @Tarima
IF EXISTS(SELECT t.*
FROM ArtDisponibleTarima a
 WITH(NOLOCK) JOIN Tarima t  WITH(NOLOCK) ON t.Tarima = a.Tarima
JOIN AlmPos p  WITH(NOLOCK) ON p.Posicion = t.Posicion  AND p.Almacen = @Almacen
WHERE a.Articulo = @Articulo
AND p.Tipo = 'Ubicacion'
AND t.Tarima <> @Tarima
AND t.Estatus = 'ALTA' AND t.Tarima NOT LIKE '%-%'
AND ISNULL(FechaCaducidad, Alta) < @FechaCaducidad
)
BEGIN
SELECT @PosicionDestino = dbo.fnTMAUbicacionDisponible(@Empresa, @Almacen, @Articulo, @TMAID, @Tarima, @SubCuenta) 
IF NOT EXISTS (SELECT * FROM PosicionArt WITH(NOLOCK) WHERE Posicion = @PosicionDestino AND Articulo = @Articulo) AND @PosicionDestino IS NOT NULL
BEGIN
INSERT PosicionArt (Posicion,         Articulo)
SELECT @PosicionDestino,  @Articulo
END
END
END
IF @PosicionDestino IS NULL
BEGIN
SELECT @PosicionDestino = dbo.fnTMAUbicacionDisponible(@Empresa, @Almacen, @Articulo, @TMAID, @Tarima, @SubCuenta) 
IF NOT EXISTS (SELECT * FROM PosicionArt WITH(NOLOCK) WHERE Posicion = @PosicionDestino AND Articulo = @Articulo) AND @PosicionDestino IS NOT NULL
BEGIN
INSERT PosicionArt (Posicion,         Articulo)
SELECT @PosicionDestino, @Articulo
END
END
END
IF @Tipo = 'REABASTECIMIENTO'
BEGIN
IF dbo.fnTarimaEnPuntoReorden(@Empresa, @Almacen, @Tarima, @Articulo) = 1
BEGIN
SELECT @PosicionDestino = Posicion FROM Tarima WITH(NOLOCK) WHERE Tarima = @Tarima
/* Bug 4604 Inicia */
IF @PosicionDestino IS NULL
BEGIN
SELECT @PosicionDestino = PosicionWMS
FROM Inv
WITH(NOLOCK) WHERE ID = @ID
END
/* Bug 4604 Fin */
SELECT @Articulo = ArticuloEsp FROM AlmPos WITH(NOLOCK) WHERE Almacen = @Almacen AND Posicion = @PosicionDestino
SELECT @Tarima = dbo.fnReabastecerDomicilio(@Empresa, @Almacen, @Articulo, @PosicionDestino)
END ELSE SELECT @Tarima = NULL
END
IF @Tarima IS NOT NULL 
BEGIN
SELECT @Posicion = NULL
SELECT @Posicion = Posicion FROM Tarima WITH(NOLOCK) WHERE Tarima = @Tarima
/* Bug 4604 Inicia */
IF @Posicion IS NULL
BEGIN
SELECT @Posicion = PosicionWMS
FROM Inv
WITH(NOLOCK) WHERE ID = @ID
UPDATE Tarima
 WITH(ROWLOCK) SET Posicion = @Posicion
WHERE Tarima   = @Tarima
END
/* Bug 4604 Fin */
SELECT @Unidad = Unidad, @CantidadUnidad = Cantidad FROM InvD WHERE ID = @ID AND Tarima = @Tarima
SELECT @FechaCaducidad = FechaCaducidad
FROM InvD
WITH(NOLOCK) WHERE ID = @ID
SELECT @Renglon = @Renglon + 2048.0
SELECT @Zona = Zona FROM AlmPos WITH(NOLOCK) WHERE Posicion = @PosicionDestino AND Almacen = @Almacen
INSERT TMAD (
ID,     Sucursal,  Renglon,  Tarima,  Almacen,  Posicion,  PosicionDestino, Zona, CapacidadPosicion, Prioridad, EstaPendiente, Procesado, Unidad, CantidadUnidad, Es50, Articulo, SubCuenta, FechaCaducidad)
VALUES (@TMAID, @Sucursal, @Renglon, @Tarima, @Almacen, @Posicion, @PosicionDestino, @Zona, 1, 'Alta', 1, 0, @Unidad, @CantidadUnidad, ISNULL(@Es50, 0), @Articulo, @SubCuenta, @FechaCaducidad)
END
END
FETCH NEXT FROM crTarima  INTO @Tarima, @Articulo, @SubCuenta
END
CLOSE crTarima
DEALLOCATE crTarima
END
IF @TMAID IS NOT NULL
BEGIN
EXEC spAfectar 'TMA', @TMAID, @Accion, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
SELECT @TMAMov = Mov, @TMAMovID = MovID FROM TMA WHERE ID = @TMAID
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'TMA', @TMAID, @TMAMov, @TMAMovID, @Ok OUTPUT
END
RETURN
END

