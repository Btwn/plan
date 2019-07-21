SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSGeneraAjuste
@Empresa		varchar(5),
@Sucursal		int,
@ID				int,
@Moneda			varchar(10),
@FechaEmision	datetime,
@TipoCambio		float,
@Almacen		varchar(10),
@Usuario		varchar(10),
@Ok				int = NULL			OUTPUT,
@OkRef			varchar(255) = NULL	OUTPUT

AS
BEGIN
DECLARE
@AjusteMov				varchar(20),
@AjusteID				int,
@Estacion				int,
@Renglon				float,
@RenglonID				int,
@UEN					int,
@Lote					varchar(50),
@Costo					float,
@Factor					float,
@TipoCosteo				varchar(20),
@SeriesLotesAutoOrden	varchar(20),
@Articulo				varchar(20),
@SubCuenta				varchar(50),
@Unidad					varchar(50),
@Disponible				float,
@LotesFijos				bit,
@Proveedor				varchar(10),
@ArtTipo				varchar(20),
@CantidadAjusteLote     float,
@Observaciones			varchar(100),
@Concepto				varchar(50)
IF EXISTS (SELECT * FROM Venta WITH (NOLOCK)
WHERE ID = @ID AND Sucursal = @Sucursal AND Almacen = @Almacen AND Usuario = @Usuario AND Estatus = 'SINAFECTAR' AND UPPER(Mov) IN ('NOTA', 'FACTURA'))
BEGIN
SELECT @Usuario = AutoAjusteUsuario, @Concepto = AutoAjusteConcepto
FROM POSCfg WITH(NOLOCK)
WHERE Empresa = @Empresa
SELECT @Proveedor = NULL, @Costo = NULL
SELECT @UEN = UEN
FROM Usuario WITH(NOLOCK)
WHERE Usuario = @Usuario
SELECT @AjusteMov = InvAjuste
FROM EmpresaCfgMov WITH(NOLOCK)
WHERE Empresa = @Empresa
SELECT @Observaciones = 'POS ' + Mov + ' ' + MovID + ' ID : ' + CONVERT(VARCHAR,ID)
FROM Venta WITH(NOLOCK)
WHERE ID = @ID
SELECT
@TipoCosteo	= ISNULL(NULLIF(RTRIM(UPPER(TipoCosteo)), ''), 'PROMEDIO'),
@SeriesLotesAutoOrden = UPPER(SeriesLotesAutoOrden)
FROM EmpresaCfg WITH(NOLOCK)
WHERE Empresa = @Empresa
SELECT @Estacion = @@SPID
DELETE ListaID WHERE Estacion = @Estacion
INSERT INTO ListaID (Estacion, ID) VALUES (@Estacion, @ID)
CREATE TABLE #tmpAjuste1 (
Id         int identity(1,1) NOT NULL,
Estacion   int               NULL,
Almacen    varchar(20)       COLLATE DATABASE_DEFAULT NULL,
Articulo   varchar(20)       COLLATE DATABASE_DEFAULT NULL,
Subcuenta  varchar(20)       COLLATE DATABASE_DEFAULT NULL,
Disponible float             NULL,
Unidad     varchar(50)       COLLATE DATABASE_DEFAULT NULL,
Lotesfijos bit               NOT NULL DEFAULT 0)
INSERT INTO #tmpAjuste1 (
Estacion, Almacen, Articulo, Subcuenta, Disponible, Unidad, lotesFijos)
SELECT
@Estacion, d.Almacen,	d.Articulo, NULLIF(RTRIM(d.SubCuenta), ''), ROUND(d.Disponible-vd.Cantidad, 4), a.Unidad, ISNULL(a.LotesFijos, 0)
FROM ArtSubDisponible d WITH(NOLOCK)
JOIN Art a WITH(NOLOCK) ON d.Articulo = a.Articulo
JOIN Alm	WITH(NOLOCK) ON d.Almacen = Alm.Almacen
JOIN VentaD vd WITH(NOLOCK) ON d.Articulo = vd.Articulo
JOIN ListaID l WITH(NOLOCK) ON l.ID = vd.ID AND l.Estacion = @Estacion
WHERE a.Articulo = d.Articulo AND (ROUND(d.Disponible, 4) - ROUND(vd.Cantidad,4)) < 0.0
AND d.Almacen = @Almacen  AND alm.Sucursal = @Sucursal AND d.Empresa = @Empresa
DELETE FROM #tmpAjuste1 WHERE Articulo NOT IN (SELECT Articulo FROM VentaD WHERE ID = @ID)
SELECT @Renglon = 0, @RenglonID = 0
DECLARE crRojo CURSOR FOR
SELECT t.Almacen, t.Articulo, t.Subcuenta, t.Disponible, t.Unidad, t.lotesFijos, a.Tipo
FROM #tmpAjuste1 t
JOIN Art a WITH(NOLOCK) ON t.Articulo = a.Articulo
WHERE Estacion = @Estacion
OPEN crRojo
FETCH NEXT FROM crRojo INTO @Almacen, @Articulo, @SubCuenta, @Disponible, @Unidad, @LotesFijos, @ArtTipo
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Renglon = 0
BEGIN
INSERT Inv (
Sucursal, SucursalOrigen, Empresa, Mov, FechaEmision, Moneda, TipoCambio, Almacen, Concepto, Usuario, Estatus,
OrigenTipo, UEN, Referencia, Observaciones)
VALUES (
@Sucursal, @Sucursal, @Empresa, @AjusteMov,  @FechaEmision, @Moneda, @TipoCambio, @Almacen, @Concepto, @Usuario, 'CONFIRMAR',
NULL, @UEN,	'mercancia con existencia fisica POS', @Observaciones)
SELECT @AjusteID = SCOPE_IDENTITY()
END
SELECT @Lote = NULL, @Costo = NULL
SELECT @Factor = ISNULL(Factor, 1) FROM Unidad WITH(NOLOCK) WHERE Unidad = @Unidad
IF @LotesFijos = 1
BEGIN
IF @SeriesLotesAutoOrden = 'ASCENDENTE'
SELECT @Lote = (SELECT TOP 1 Lote FROM ArtLoteFijo WITH(NOLOCK) WHERE Articulo = @Articulo ORDER BY Lote DESC)
ELSE
SELECT @Lote = (SELECT TOP 1 Lote FROM ArtLoteFijo WITH(NOLOCK) WHERE Articulo = @Articulo ORDER BY Lote)
SELECT @Lote = NULLIF(RTRIM(@Lote), '')
IF @Lote IS NOT NULL
SELECT @Costo = MIN(CostoPromedio)*@Factor
FROM SerieLote WITH(NOLOCK)
WHERE Empresa = @Empresa AND Articulo = @Articulo AND SubCuenta = ISNULL(@SubCuenta, '')
AND SerieLote = @Lote AND Almacen = @Almacen
END
IF @Costo IS NULL
EXEC spVerCosto @Sucursal, @Empresa, @Proveedor, @Articulo, @SubCuenta, @Unidad, @TipoCosteo, @Moneda, @TipoCambio, @Costo OUTPUT, 0
SELECT @Renglon = @Renglon + 2048, @RenglonID = @RenglonID + 1
INSERT InvD (
Sucursal, SucursalOrigen, ID, Renglon, RenglonSub, RenglonID, Almacen, Articulo, SubCuenta, Unidad, Cantidad,
CantidadInventario, Costo)
VALUES (
@Sucursal, @Sucursal, @AjusteID, @Renglon, 0, @RenglonID, @Almacen, @Articulo, @SubCuenta, @Unidad, -@Disponible/@Factor,
-@Disponible, @Costo)
IF @LotesFijos = 1 AND @Lote IS NOT NULL
INSERT SerieLoteMov (
Empresa, Sucursal, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad)
VALUES (
@Empresa, @Sucursal, 'INV', @AjusteID, @RenglonID, @Articulo, ISNULL(@SubCuenta, ''), @Lote, -@Disponible/@Factor)
ELSE
IF (SELECT NotasBorrador FROM EmpresaCFG WITH(NOLOCK) WHERE Empresa = @Empresa) = 1 AND @ArtTipo IN ('SERIE','LOTE')
BEGIN
INSERT SerieLoteMov (
Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, ArtCostoInv, Cantidad,
CantidadAlterna, Sucursal,Propiedades)
SELECT
@Empresa, 'INV', @AjusteID, @RenglonID, @Articulo, ISNULL(@SubCuenta, ''), s.SerieLote, s.ArtCostoInv, SUM(ABS(sl.Existencia)),
SUM(ABS(sl.Existencia)), @Sucursal,ISNULL(s.Propiedades, '')
FROM SerieLoteMov s WITH(NOLOCK)
JOIN ListaID l WITH(NOLOCK) ON l.ID = s.ID AND l.Estacion = @Estacion
JOIN Serielote sl WITH(NOLOCK) ON s.articulo = sl.Articulo AND s.SerieLote = sl.SerieLote AND s.Empresa = sl.Empresa AND s.Sucursal = sl.Sucursal
WHERE s.Empresa = @Empresa AND s.Modulo = 'VTAS'
AND s.Articulo = @Articulo AND s.Sucursal = @Sucursal AND sl.Existencia < 0
GROUP BY s.SerieLote, s.ArtCostoInv, s.Propiedades
IF EXISTS (SELECT s.ID FROM SerieLoteMov s WITH(NOLOCK)
JOIN ListaID l WITH(NOLOCK) ON l.ID = s.ID AND l.Estacion = @Estacion
JOIN Serielote sl WITH(NOLOCK) ON s.articulo = sl.Articulo AND s.SerieLote = sl.SerieLote
AND s.Empresa = sl.Empresa AND s.Sucursal = sl.Sucursal
WHERE s.Empresa = @Empresa AND s.Modulo = 'VTAS' AND s.Articulo = @Articulo
AND s.Sucursal = @Sucursal AND sl.Existencia < 0)
BEGIN
SELECT @CantidadAjusteLote = NULL
SELECT @CantidadAjusteLote = SUM(ABS(sl.Existencia))
FROM SerieLoteMov s WITH(NOLOCK)
JOIN Serielote sl WITH(NOLOCK) ON s.articulo = sl.Articulo AND s.SerieLote = sl.SerieLote AND s.Empresa = sl.Empresa AND s.Sucursal = sl.Sucursal
WHERE s.Empresa = @Empresa AND s.Modulo = 'INV' AND s.ID = @AjusteID
AND s.RenglonID = @RenglonID AND ISNULL(s.SubCuenta, '') = ISNULL(@SubCuenta, '')
AND s.Articulo = @Articulo
AND s.Sucursal = @Sucursal
AND sl.Existencia < 0
GROUP BY s.SerieLote, s.ArtCostoInv, s.Propiedades
IF @CantidadAjusteLote IS NOT NULL
BEGIN
IF NULLIF(-@Disponible/@Factor,0.0) <> @CantidadAjusteLote
UPDATE InvD WITH(ROWLOCK) SET Cantidad = @CantidadAjusteLote
WHERE ID = @AjusteID AND Renglon = @Renglon AND RenglonID = @RenglonID AND Articulo = @Articulo
END
END
END
END
FETCH NEXT FROM crRojo INTO @Almacen, @Articulo, @SubCuenta, @Disponible, @Unidad, @LotesFijos, @ArtTipo
END
CLOSE crRojo
DEALLOCATE crRojo
DELETE ListaID WHERE Estacion = @Estacion
IF EXISTS (SELECT * FROM INV WITH(NOLOCK) WHERE ID = @AjusteID)
EXEC spAfectar 'INV', @AjusteID, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NOT NULL
BEGIN
DELETE FROM Inv WHERE ID = @AjusteID
DELETE FROM InvD WHERE ID = @AjusteID
END
SELECT @Ok = NULL, @OkRef = NULL
END
RETURN
END

