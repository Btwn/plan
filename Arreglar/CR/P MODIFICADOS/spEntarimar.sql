SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEntarimar
@Estacion	int,
@Empresa	varchar(5),
@Modulo		varchar(5),
@ModuloID	int,
@Mov		varchar(20),
@MovID		varchar(20),
@Accion		varchar(20),
@Tarima		varchar(20)	= NULL,
@ID		    int		= NULL,
@Conexion	bit		= 0

AS BEGIN
DECLARE
@Renglon					float,
@UltRenglon					float,
@RenglonSub					int,
@RenglonSubN				int,
@UltRenglonSub				int,
@Almacen					varchar(10),
@Articulo					varchar(20),
@SubCuenta					varchar(50),
@Posicion					varchar(10),
@Cantidad					float,
@Unidad						varchar(50),
@CantidadA					float,
@RenglonID					int,
@MAXRenglonID				int,
@MovTipo					varchar(20),
@CfgSeriesLotesMayoreo	    bit,
@CfgSeriesLotesAutoOrden	varchar(20),
@Sucursal					int,
@AlmTipo					varchar(20),
@ArtTipo					varchar(20),
@Factor						float,
@SerieLote					varchar(50),
@SeriesLotesAutoOrden	    varchar(50),
@Ok							int,
@OkRef						varchar(255), 
@NivelFactorMultiUnidad		varchar(20), 
@SerieLoteAnterior			varchar(50), 
@ArtUnidadN					varchar(50),
@Propiedades				varchar(20),
@TipoOpcion				    varchar(20), 
@Origen                     varchar(20),
@OrigenID                   varchar(20),
@OrigenO                    varchar(20),
@OrigenIDO                  varchar(20)
IF @Modulo NOT IN ('VTAS', 'COMS', 'INV', 'PROD') RETURN
SELECT @Ok = NULL, @OkRef = NULL
SELECT @Accion = UPPER(@Accion), @Tarima = NULLIF(RTRIM(@Tarima), ''), @ID = NULLIF(@ID, 0)
SELECT @MovTipo = Clave FROM MovTipo WITH(NOLOCK) WHERE Modulo = @Modulo AND Mov = @Mov
SELECT @CfgSeriesLotesMayoreo = SeriesLotesMayoreo FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @CfgSeriesLotesAutoOrden = ISNULL(UPPER(RTRIM(SeriesLotesAutoOrden)), 'NO')
FROM EmpresaCfg
WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @NivelFactorMultiUnidad = NivelFactorMultiUnidad
FROM EmpresaCfg2
WHERE Empresa = @Empresa
IF @Conexion = 0
BEGIN TRANSACTION
IF @Accion = 'SELECCIONAR/TODO'
BEGIN
UPDATE EntarimarMov
 WITH(ROWLOCK) SET CantidadA = Cantidad
WHERE Estacion = @Estacion
UPDATE EntarimarMovSerieLote
 WITH(ROWLOCK) SET CantidadA = Cantidad
WHERE Estacion = @Estacion
END ELSE
IF @Accion = 'SUGERIR'
BEGIN
DELETE EntarimarMov             WHERE Estacion = @Estacion
DELETE EntarimarMovSerieLote    WHERE Estacion = @Estacion
DELETE EntarimarTarima          WHERE Estacion = @Estacion
DELETE EntarimarTarimaSerieLote WHERE Estacion = @Estacion
IF @Modulo = 'VTAS'
BEGIN
INSERT EntarimarMov (
Estacion,  Renglon, RenglonSub, RenglonID, Almacen, Tarima, Articulo, SubCuenta, Cantidad, Unidad)
SELECT @Estacion, Renglon, RenglonSub, RenglonID, Almacen, Tarima, Articulo, SubCuenta, Cantidad, Unidad
FROM VentaD
WITH(NOLOCK) WHERE ID = @ModuloID
INSERT EntarimarMovSerieLote (
Estacion,  RenglonID,     Articulo,     SubCuenta,     SerieLote,     Cantidad, Propiedades)
SELECT @Estacion, slm.RenglonID, slm.Articulo, slm.SubCuenta, slm.SerieLote, slm.Cantidad, slm.Propiedades
FROM SerieLoteMov slm
 WITH(NOLOCK) JOIN VentaD d  WITH(NOLOCK) ON d.ID = slm.ID AND d.RenglonID = slm.RenglonID AND d.Articulo = slm.Articulo AND ISNULL(d.SubCuenta, '') = slm.SubCuenta
JOIN Art a  WITH(NOLOCK) ON a.Articulo=d.Articulo
WHERE slm.Modulo = @Modulo AND slm.ID = @ModuloID
AND a.SerieLoteInfo=0 
DECLARE crEntarimar CURSOR LOCAL FOR
SELECT Sucursal, RenglonID, Almacen, Tarima, Articulo, SubCuenta, Cantidad, Factor
FROM VentaD WITH(NOLOCK)
WHERE  ID = @ModuloID
END ELSE
IF @Modulo = 'INV'
BEGIN
INSERT EntarimarMov (
Estacion,  Renglon, RenglonSub, RenglonID, Almacen, Tarima, Articulo, SubCuenta, Cantidad, Unidad)
SELECT @Estacion, Renglon, RenglonSub, RenglonID, Almacen, Tarima, Articulo, SubCuenta, CASE WHEN ISNULL(CantidadInventario,0) = 0 THEN Cantidad ELSE CantidadInventario END, Unidad 
FROM InvD
WITH(NOLOCK) WHERE ID = @ModuloID AND Seccion IS NULL
INSERT EntarimarMovSerieLote (
Estacion,  RenglonID,     Articulo,     SubCuenta,     SerieLote,     Cantidad, Propiedades)
SELECT @Estacion, slm.RenglonID, slm.Articulo, slm.SubCuenta, slm.SerieLote, slm.Cantidad, slm.Propiedades
FROM SerieLoteMov slm
 WITH(NOLOCK) JOIN InvD d  WITH(NOLOCK) ON d.ID = slm.ID AND d.RenglonID = slm.RenglonID AND d.Articulo = slm.Articulo AND ISNULL(d.SubCuenta, '') = slm.SubCuenta
JOIN Art a  WITH(NOLOCK) ON a.Articulo=d.Articulo
WHERE slm.Modulo = @Modulo AND slm.ID = @ModuloID AND Seccion IS NULL
AND a.SerieLoteInfo=0 
DECLARE crEntarimar CURSOR LOCAL FOR
SELECT Sucursal, RenglonID, Almacen, Tarima, Articulo, SubCuenta, CASE WHEN ISNULL(CantidadInventario,0) = 0 THEN Cantidad ELSE CantidadInventario END, Factor 
FROM InvD
WITH(NOLOCK) WHERE ID = @ModuloID AND Seccion = NULL
END ELSE
IF @Modulo = 'COMS'
BEGIN
INSERT EntarimarMov (
Estacion,  Renglon, RenglonSub, RenglonID, Almacen, Tarima, Articulo, SubCuenta, Cantidad, Unidad)
SELECT @Estacion, Renglon, RenglonSub, RenglonID, Almacen, Tarima, Articulo, SubCuenta, CASE WHEN ISNULL(CantidadInventario,0) = 0 THEN Cantidad ELSE CantidadInventario END, Unidad 
FROM CompraD
WITH(NOLOCK) WHERE ID = @ModuloID
INSERT EntarimarMovSerieLote (
Estacion,  RenglonID,     Articulo,     SubCuenta,     SerieLote,     Cantidad, Propiedades)
SELECT @Estacion, slm.RenglonID, slm.Articulo, slm.SubCuenta, slm.SerieLote, slm.Cantidad, slm.Propiedades
FROM SerieLoteMov slm
 WITH(NOLOCK) JOIN CompraD d  WITH(NOLOCK) ON d.ID = slm.ID AND d.RenglonID = slm.RenglonID AND d.Articulo = slm.Articulo AND ISNULL(d.SubCuenta, '') = slm.SubCuenta
JOIN Art a  WITH(NOLOCK) ON a.Articulo=d.Articulo
WHERE slm.Modulo = @Modulo AND slm.ID = @ModuloID
AND a.SerieLoteInfo=0 
DECLARE crEntarimar CURSOR LOCAL FOR
SELECT Sucursal, RenglonID, Almacen, Tarima, Articulo, SubCuenta, Cantidad, Factor
FROM CompraD WITH(NOLOCK)
WHERE  ID = @ModuloID
END ELSE
IF @Modulo = 'PROD'
BEGIN
INSERT EntarimarMov (
Estacion,  Renglon, RenglonSub, RenglonID, Almacen, Tarima, Articulo, SubCuenta, Cantidad, Unidad)
SELECT @Estacion, Renglon, RenglonSub, RenglonID, Almacen, Tarima, Articulo, SubCuenta, Cantidad, Unidad
FROM ProdD
WITH(NOLOCK) WHERE ID = @ModuloID
INSERT EntarimarMovSerieLote (
Estacion,  RenglonID,     Articulo,     SubCuenta,     SerieLote,     Cantidad, Propiedades)
SELECT @Estacion, slm.RenglonID, slm.Articulo, slm.SubCuenta, slm.SerieLote, slm.Cantidad, slm.Propiedades
FROM SerieLoteMov slm
 WITH(NOLOCK) JOIN ProdD d  WITH(NOLOCK) ON d.ID = slm.ID AND d.RenglonID = slm.RenglonID AND d.Articulo = slm.Articulo AND ISNULL(d.SubCuenta, '') = slm.SubCuenta
JOIN Art a  WITH(NOLOCK) ON a.Articulo=d.Articulo
WHERE slm.Modulo = @Modulo AND slm.ID = @ModuloID
AND a.SerieLoteInfo=0 
DECLARE crEntarimar CURSOR LOCAL FOR
SELECT Sucursal, RenglonID, Almacen, Tarima, Articulo, SubCuenta, Cantidad, Factor
FROM ProdD WITH(NOLOCK)
WHERE  ID = @ModuloID
END
OPEN crEntarimar
FETCH NEXT FROM crEntarimar  INTO @Sucursal, @RenglonID, @Almacen, @Tarima, @Articulo, @SubCuenta, @Cantidad, @Factor
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @AlmTipo = UPPER(Tipo)
FROM Alm
WITH(NOLOCK) WHERE Almacen = @Almacen
SELECT @ArtTipo = UPPER(Tipo),
@SeriesLotesAutoOrden = ISNULL(NULLIF(NULLIF(RTRIM(UPPER(SeriesLotesAutoOrden)), ''), '(EMPRESA)'), @CfgSeriesLotesAutoOrden)
FROM Art
WITH(NOLOCK) WHERE Articulo = @Articulo
IF @ArtTipo IN ('SERIE', 'LOTE', 'VIN', 'PARTIDA') AND @CfgSeriesLotesMayoreo = 1
EXEC spSeriesLotesSurtidoAuto @Sucursal, @Empresa, @Modulo, 1, 0,
@ModuloID,  @RenglonID, @Almacen, @Articulo, @SubCuenta, @Cantidad, @Factor,
@AlmTipo, @SeriesLotesAutoOrden,
@Ok OUTPUT, @OkRef OUTPUT, @Tarima = @Tarima
END
FETCH NEXT FROM crEntarimar  INTO @Sucursal, @RenglonID, @Almacen, @Tarima, @Articulo, @SubCuenta, @Cantidad, @Factor
END
CLOSE crEntarimar
DEALLOCATE crEntarimar
END ELSE
IF @Accion = 'ENTARIMAR' AND @Tarima IS NOT NULL
BEGIN
DECLARE crEntarimar CURSOR LOCAL FOR
SELECT e.Renglon, e.RenglonSub, e.RenglonID, e.Almacen, e.Articulo, e.SubCuenta, e.Cantidad, e.Unidad, CASE WHEN @NivelFactorMultiUnidad = 'Articulo' THEN ISNULL((SELECT e.CantidadA / ISNULL(a.Factor,1) FROM ArtUnidad a WHERE a.Articulo = e.Articulo AND a.Unidad = e.Unidad), e.CantidadA) ELSE ISNULL((SELECT e.CantidadA / ISNULL(u.Factor,1) FROM Unidad u WHERE u.Unidad = e.Unidad), e.CantidadA) END
FROM EntarimarMov e
WITH(NOLOCK) WHERE e.Estacion = @Estacion AND ISNULL(e.CantidadA, 0.0) > 0.0
OPEN crEntarimar
FETCH NEXT FROM crEntarimar  INTO @Renglon, @RenglonSub, @RenglonID, @Almacen, @Articulo, @SubCuenta, @Cantidad, @Unidad, @CantidadA
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2 AND ISNULL(@CantidadA, 0.0) <= ISNULL(@Cantidad, 0.0) 
BEGIN
UPDATE EntarimarTarima
 WITH(ROWLOCK) SET Cantidad = ISNULL(Cantidad, 0.0) + @CantidadA
WHERE Estacion = @Estacion AND Almacen = @Almacen AND Tarima = @Tarima AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') AND ISNULL(Unidad, '') = ISNULL(@Unidad, '')
IF @@ROWCOUNT = 0
IF CONVERT(NUMERIC(12,3), @CantidadA)>0 
INSERT EntarimarTarima (
Estacion,  Renglon,  RenglonSub,  RenglonID,  Almacen,  Tarima,  Articulo,  SubCuenta,  Cantidad,   Unidad)
VALUES (@Estacion, @Renglon, @RenglonSub, @RenglonID, @Almacen, @Tarima, @Articulo, @SubCuenta, @CantidadA, @Unidad)
UPDATE EntarimarMov
 WITH(ROWLOCK) SET Cantidad = NULLIF(ISNULL(Cantidad, 0.0) - @CantidadA, 0.0), CantidadA = NULL
WHERE CURRENT OF crEntarimar
IF EXISTS(SELECT * FROM EntarimarMovSerieLote WHERE Estacion = @Estacion AND RenglonID = @RenglonID AND Articulo = @Articulo AND SubCuenta = ISNULL(@SubCuenta, '')) AND
(SELECT NULLIF(SUM(CantidadA), 0.0) FROM EntarimarMovSerieLote WHERE Estacion = @Estacion AND RenglonID = @RenglonID AND Articulo = @Articulo AND SubCuenta = ISNULL(@SubCuenta, '')) IS NULL
BEGIN
DECLARE crEntarimarSerieLote CURSOR LOCAL FOR
SELECT Cantidad
FROM EntarimarMovSerieLote WITH(NOLOCK)
WHERE  Estacion = @Estacion AND RenglonID = @RenglonID AND Articulo = @Articulo AND SubCuenta = ISNULL(@SubCuenta, '')
AND NULLIF(Cantidad, 0.0) IS NOT NULL
OPEN crEntarimarSerieLote
FETCH NEXT FROM crEntarimarSerieLote  INTO @Cantidad
WHILE @@FETCH_STATUS <> -1 AND @CantidadA > 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @ArtTipo = UPPER(Tipo) FROM Art WHERE Articulo = @Articulo
IF @Cantidad < @CantidadA AND @ArtTipo IN ('SERIE', 'LOTE')
BEGIN
UPDATE EntarimarMov
 WITH(ROWLOCK) SET Cantidad = ISNULL(Cantidad,0.00) + (@CantidadA - @Cantidad)
WHERE Estacion = @Estacion AND Articulo = @Articulo AND Renglon = @Renglon
SELECT @CantidadA = @Cantidad
END
IF @Cantidad <= @CantidadA
BEGIN
UPDATE EntarimarMovSerieLote  WITH(ROWLOCK) SET CantidadA = @Cantidad WHERE CURRENT OF crEntarimarSerieLote
SELECT @CantidadA = @CantidadA - @Cantidad
END ELSE
BEGIN
UPDATE EntarimarMovSerieLote  WITH(ROWLOCK) SET CantidadA = @CantidadA WHERE CURRENT OF crEntarimarSerieLote
SELECT @CantidadA = 0
END
END
FETCH NEXT FROM crEntarimarSerieLote  INTO @Cantidad
END
CLOSE crEntarimarSerieLote
DEALLOCATE crEntarimarSerieLote
END
END
FETCH NEXT FROM crEntarimar  INTO @Renglon, @RenglonSub, @RenglonID, @Almacen, @Articulo, @SubCuenta, @Cantidad, @Unidad, @CantidadA
END
CLOSE crEntarimar
DEALLOCATE crEntarimar
DECLARE crEntarimarSerieLote CURSOR LOCAL FOR
SELECT RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, CantidadA, Propiedades
FROM EntarimarMovSerieLote WITH(NOLOCK)
WHERE  Estacion = @Estacion AND ISNULL(CantidadA, 0.0) > 0.0 AND ISNULL(CantidadA, 0.0) <= ISNULL(Cantidad, 0.0)
OPEN crEntarimarSerieLote
FETCH NEXT FROM crEntarimarSerieLote  INTO @RenglonID, @Articulo, @SubCuenta, @SerieLote, @Cantidad, @CantidadA, @Propiedades
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
UPDATE EntarimarTarimaSerieLote
 WITH(ROWLOCK) SET Cantidad = ISNULL(Cantidad, 0.0) + @CantidadA
WHERE Estacion = @Estacion AND Tarima = @Tarima AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') AND SerieLote = @SerieLote
IF @@ROWCOUNT = 0
IF @CantidadA>0 
INSERT EntarimarTarimaSerieLote (
Estacion,  RenglonID,  Tarima,  Articulo,  SubCuenta,  SerieLote,  Cantidad, Propiedades)
VALUES (@Estacion, @RenglonID, @Tarima, @Articulo, @SubCuenta, @SerieLote, @CantidadA, @Propiedades)
SELECT @ArtTipo = UPPER(Tipo) FROM Art WHERE Articulo = @Articulo
IF  @ArtTipo IN ('SERIE', 'LOTE')
UPDATE EntarimarTarima
 WITH(ROWLOCK) SET Cantidad = @CantidadA
WHERE Estacion = @Estacion
AND Tarima = @Tarima
UPDATE EntarimarMovSerieLote
 WITH(ROWLOCK) SET Cantidad = NULLIF(ISNULL(Cantidad, 0.0) - @CantidadA, 0.0), CantidadA = NULL
WHERE CURRENT OF crEntarimarSerieLote
END
FETCH NEXT FROM crEntarimarSerieLote  INTO @RenglonID, @Articulo, @SubCuenta, @SerieLote, @Cantidad, @CantidadA, @Propiedades
END
CLOSE crEntarimarSerieLote
DEALLOCATE crEntarimarSerieLote
END ELSE
IF @Accion = 'ELIMINAR' AND @ID IS NOT NULL
BEGIN
SELECT @CantidadA = NULL
SELECT @Tarima = Tarima, @Renglon = Renglon, @RenglonSub = RenglonSub, @RenglonID = RenglonID, @CantidadA = Cantidad
FROM EntarimarTarima
WITH(NOLOCK) WHERE Estacion = @Estacion AND ID = @ID
IF NULLIF(@CantidadA, 0.0) IS NOT NULL
BEGIN
UPDATE EntarimarMov
 WITH(ROWLOCK) SET Cantidad = ISNULL(Cantidad, 0.0) + @CantidadA
WHERE Estacion = @Estacion AND Renglon = @Renglon AND RenglonSub = @RenglonSub AND RenglonID = @RenglonID
DELETE EntarimarTarima
WHERE Estacion = @Estacion AND ID = @ID
END
DECLARE crEntarimarSerieLote CURSOR LOCAL FOR
SELECT SerieLote
FROM EntarimarTarimaSerieLote WITH(NOLOCK)
WHERE  Estacion = @Estacion AND RenglonID = @RenglonID AND Tarima = @Tarima
OPEN crEntarimarSerieLote
FETCH NEXT FROM crEntarimarSerieLote  INTO @SerieLote
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @CantidadA = NULL
SELECT @CantidadA = Cantidad
FROM EntarimarTarimaSerieLote
WITH(NOLOCK) WHERE Estacion = @Estacion AND RenglonID = @RenglonID AND Tarima = @Tarima AND SerieLote = @SerieLote
IF NULLIF(@CantidadA, 0.0) IS NOT NULL
BEGIN
UPDATE EntarimarMovSerieLote
 WITH(ROWLOCK) SET Cantidad = ISNULL(Cantidad, 0.0) + @CantidadA
WHERE Estacion = @Estacion AND RenglonID = @RenglonID
DELETE EntarimarTarimaSerieLote
WHERE CURRENT OF crEntarimarSerieLote
END
END
FETCH NEXT FROM crEntarimarSerieLote  INTO @SerieLote
END
CLOSE crEntarimarSerieLote
DEALLOCATE crEntarimarSerieLote
END ELSE
IF @Accion = 'ACEPTAR' AND @Modulo = 'INV' AND @MovTipo = 'INV.TMA'
BEGIN
DELETE SerieLoteMov
FROM InvD d
 WITH(NOLOCK) JOIN SerieLoteMov slm  WITH(NOLOCK) ON slm.Empresa = @Empresa AND slm.Modulo = @Modulo AND slm.ID = d.ID AND slm.RenglonID = d.RenglonID AND slm.Articulo = d.Articulo AND slm.SubCuenta = ISNULL(d.SubCuenta, '')
WHERE d.ID = @ModuloID AND d.Seccion = 1
DELETE InvD WHERE ID = @ModuloID AND Seccion = 1
END
IF @Accion = 'ACEPTAR' AND EXISTS(SELECT * FROM EntarimarTarima WHERE Estacion = @Estacion)
BEGIN
SELECT @MAXRenglonID = 0
IF @Modulo = 'VTAS'
BEGIN
SELECT @MAXRenglonID = ISNULL(MAX(RenglonID), 0) FROM VentaD WHERE ID = @ModuloID
UPDATE VentaD  WITH(ROWLOCK) SET Factor = CantidadInventario/ISNULL(Cantidad, 1.0) WHERE ID = @ModuloID AND NULLIF(CantidadInventario, 0.0) IS NOT NULL
UPDATE VentaD  WITH(ROWLOCK) SET Cantidad = NULLIF(m.Cantidad, 0.0) FROM VentaD d  WITH(NOLOCK) JOIN EntarimarMov m  WITH(NOLOCK) ON m.Estacion = @Estacion AND m.Renglon = d.Renglon AND m.RenglonSub = d.RenglonSub WHERE d.ID = @ModuloID
END ELSE
IF @Modulo = 'INV'
BEGIN
SELECT @MAXRenglonID = ISNULL(MAX(RenglonID), 0) FROM InvD WHERE ID = @ModuloID
UPDATE InvD  WITH(ROWLOCK) SET Factor = CantidadInventario/ISNULL(Cantidad, 1.0) WHERE ID = @ModuloID AND NULLIF(CantidadInventario, 0.0) IS NOT NULL
IF @MovTipo <> 'INV.TMA'
UPDATE InvD  WITH(ROWLOCK) SET Cantidad = NULLIF(m.Cantidad, 0.0) FROM InvD d  WITH(NOLOCK) JOIN EntarimarMov m  WITH(NOLOCK) ON m.Estacion = @Estacion AND m.Renglon = d.Renglon AND m.RenglonSub = d.RenglonSub WHERE d.ID = @ModuloID
END ELSE
IF @Modulo = 'COMS'
BEGIN
SELECT @MAXRenglonID = ISNULL(MAX(RenglonID), 0) FROM CompraD WHERE ID = @ModuloID
UPDATE CompraD  WITH(ROWLOCK) SET Factor = CantidadInventario/ISNULL(Cantidad, 1.0) WHERE ID = @ModuloID AND NULLIF(CantidadInventario, 0.0) IS NOT NULL
UPDATE CompraD  WITH(ROWLOCK) SET Cantidad = NULLIF(m.Cantidad, 0.0) FROM CompraD d  WITH(NOLOCK) JOIN EntarimarMov m  WITH(NOLOCK) ON m.Estacion = @Estacion AND m.Renglon = d.Renglon AND m.RenglonSub = d.RenglonSub WHERE d.ID = @ModuloID
END ELSE
IF @Modulo = 'PROD'
BEGIN
SELECT @MAXRenglonID = ISNULL(MAX(RenglonID), 0) FROM ProdD WHERE ID = @ModuloID
UPDATE ProdD  WITH(ROWLOCK) SET Factor = CantidadInventario/ISNULL(Cantidad, 1.0) WHERE ID = @ModuloID AND NULLIF(CantidadInventario, 0.0) IS NOT NULL
UPDATE ProdD  WITH(ROWLOCK) SET Cantidad = NULLIF(m.Cantidad, 0.0) FROM ProdD d  WITH(NOLOCK) JOIN EntarimarMov m  WITH(NOLOCK) ON m.Estacion = @Estacion AND m.Renglon = d.Renglon AND m.RenglonSub = d.RenglonSub WHERE d.ID = @ModuloID
END
SELECT @UltRenglon = NULL, @UltRenglonSub = NULL
DECLARE crEntarimar CURSOR LOCAL FOR
SELECT Renglon, RenglonSub, NULLIF(Cantidad, 0.0), Tarima, Almacen, Articulo, SubCuenta 
FROM EntarimarTarima
WITH(NOLOCK) WHERE Estacion = @Estacion AND NULLIF(RTRIM(Tarima), '') IS NOT NULL
ORDER BY Renglon, RenglonSub, ID
OPEN crEntarimar
FETCH NEXT FROM crEntarimar  INTO @Renglon, @RenglonSub, @Cantidad, @Tarima, @Almacen, @Articulo, @SubCuenta
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2 AND @Cantidad IS NOT NULL
BEGIN
IF @Modulo = 'INV'
SELECT @Posicion = PosicionWMS FROM Inv WITH(NOLOCK) WHERE ID = @ModuloID
ELSE
IF @Modulo = 'COMS'
SELECT @Posicion = PosicionWMS FROM Compra WITH(NOLOCK) WHERE ID = @ModuloID
ELSE
IF @Modulo = 'VTAS'
SELECT @Posicion = PosicionWMS FROM Venta WITH(NOLOCK) WHERE ID = @ModuloID
IF @Modulo = 'INV' AND @MovTipo = 'INV.TMA' /* Genero Entarimado de una Orden de Entarimado Manual */
BEGIN
IF @Modulo = 'INV'
BEGIN
SELECT @Origen = Origen, @OrigenId = OrigenId FROM Inv WHERE ID = @ModuloID
IF ISNULL(@Origen,'') <> '' AND ISNULL(@OrigenId,'') <> ''
SELECT @OrigenO = Origen, @OrigenIDO = OrigenId FROM Inv WHERE Mov = @Origen AND MovID = @OrigenId
END
IF ISNULL(@OrigenO,'') = '' AND ISNULL(@OrigenIDO,'') = '' /* La Orden de Entarimado Manual no tiene origen y se obtiene la posic�n de Recibo */
BEGIN
SELECT @Posicion = DefPosicionRecibo FROM Alm WITH(NOLOCK) WHERE Almacen = @Almacen
END
END
UPDATE Tarima
 WITH(ROWLOCK) SET Almacen = @Almacen,
Posicion = @Posicion,
Estatus = 'ALTA',
Alta = GETDATE()
WHERE Tarima = @Tarima
IF @@ROWCOUNT = 0
INSERT Tarima (
Tarima,  Almacen,  Posicion,  Estatus, Alta, Articulo, SubCuenta)
SELECT @Tarima, @Almacen, @Posicion, 'ALTA', GETDATE(), @Articulo, @SubCuenta 
IF @Modulo = 'VTAS'
BEGIN
IF (@UltRenglon = @Renglon AND @UltRenglonSub = @RenglonSub) OR EXISTS(SELECT * FROM VentaD WHERE ID = @ModuloID AND Renglon = @Renglon AND RenglonSub = @RenglonSub AND Cantidad IS NOT NULL)
BEGIN
SELECT @RenglonSubN = 0
SELECT @RenglonSubN = MAX(RenglonSub) FROM VentaD WHERE ID = @ModuloID AND Renglon = @Renglon
SELECT @RenglonSubN = ISNULL(@RenglonSubN, 0) + 1, @MAXRenglonID = ISNULL(@MAXRenglonID, 0) + 1
SELECT * INTO #VentaDetalle FROM cVentaD WHERE ID = @ModuloID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
UPDATE #VentaDetalle SET Cantidad = @Cantidad, Tarima = @Tarima, RenglonSub = @RenglonSubN, RenglonID = @MAXRenglonID
INSERT INTO cVentaD SELECT * FROM #VentaDetalle
DROP TABLE #VentaDetalle
INSERT SerieLoteMov  (
Empresa,  Modulo,  ID,        RenglonID,     Articulo, SubCuenta, SerieLote, Cantidad, Tarima, Propiedades) 
SELECT @Empresa, @Modulo, @ModuloID, @MAXRenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Tarima, Propiedades  
FROM EntarimarTarimaSerieLote
WITH(NOLOCK) WHERE Estacion = @Estacion AND Tarima = @Tarima
END ELSE
UPDATE VentaD
 WITH(ROWLOCK) SET Cantidad = @Cantidad, Tarima = @Tarima
WHERE ID = @ModuloID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
END ELSE
IF @Modulo = 'INV'
BEGIN
IF (@MovTipo = 'INV.TMA') OR (@UltRenglon = @Renglon AND @UltRenglonSub = @RenglonSub) OR EXISTS(SELECT * FROM InvD WHERE ID = @ModuloID AND Renglon = @Renglon AND RenglonSub = @RenglonSub AND Cantidad IS NOT NULL)
BEGIN
SELECT @RenglonSubN = 0
SELECT @RenglonSubN = MAX(RenglonSub) FROM InvD WHERE ID = @ModuloID AND Renglon = @Renglon
SELECT @RenglonSubN = ISNULL(@RenglonSubN, 0) + 1, @MAXRenglonID = ISNULL(@MAXRenglonID, 0) + 1
SELECT * INTO #InvDetalle FROM cInvD WHERE ID = @ModuloID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
UPDATE #InvDetalle SET Cantidad = @Cantidad, Tarima = @Tarima, RenglonSub = @RenglonSubN, RenglonID = @MAXRenglonID
IF @MovTipo = 'INV.TMA'
BEGIN
UPDATE #InvDetalle SET Seccion = 1
END
INSERT INTO cInvD SELECT * FROM #InvDetalle
DROP TABLE #InvDetalle
INSERT SerieLoteMov  (
Empresa,  Modulo,  ID,        RenglonID,     Articulo, SubCuenta, SerieLote, Cantidad, Tarima, Propiedades) 
SELECT @Empresa, @Modulo, @ModuloID, @MAXRenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Tarima, Propiedades  
FROM EntarimarTarimaSerieLote
WITH(NOLOCK) WHERE Estacion = @Estacion AND Tarima = @Tarima
END ELSE
UPDATE InvD
 WITH(ROWLOCK) SET Cantidad = @Cantidad, Tarima = @Tarima
WHERE ID = @ModuloID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
END ELSE
IF @Modulo = 'COMS'
BEGIN
IF (@UltRenglon = @Renglon AND @UltRenglonSub = @RenglonSub) OR EXISTS(SELECT * FROM CompraD WHERE ID = @ModuloID AND Renglon = @Renglon AND RenglonSub = @RenglonSub AND Cantidad IS NOT NULL)
BEGIN
SELECT @RenglonSubN = 0
SELECT @RenglonSubN = MAX(RenglonSub) FROM CompraD WHERE ID = @ModuloID AND Renglon = @Renglon
SELECT @RenglonSubN = ISNULL(@RenglonSubN, 0) + 1, @MAXRenglonID = ISNULL(@MAXRenglonID, 0) + 1
SELECT * INTO #CompraDetalle FROM cCompraD WHERE ID = @ModuloID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
UPDATE #CompraDetalle SET Cantidad = @Cantidad, Tarima = @Tarima, RenglonSub = @RenglonSubN, RenglonID = @MAXRenglonID
INSERT INTO cCompraD SELECT * FROM #CompraDetalle
DROP TABLE #CompraDetalle
INSERT SerieLoteMov  (
Empresa,  Modulo,  ID,        RenglonID,     Articulo, SubCuenta, SerieLote, Cantidad, Tarima, Propiedades) 
SELECT @Empresa, @Modulo, @ModuloID, @MAXRenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Tarima, Propiedades  
FROM EntarimarTarimaSerieLote
WITH(NOLOCK) WHERE Estacion = @Estacion AND Tarima = @Tarima
END ELSE
UPDATE CompraD
 WITH(ROWLOCK) SET Cantidad = @Cantidad, Tarima = @Tarima
WHERE ID = @ModuloID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
END ELSE
IF @Modulo = 'PROD'
BEGIN
IF (@UltRenglon = @Renglon AND @UltRenglonSub = @RenglonSub) OR EXISTS(SELECT * FROM ProdD WHERE ID = @ModuloID AND Renglon = @Renglon AND RenglonSub = @RenglonSub AND Cantidad IS NOT NULL)
BEGIN
SELECT @RenglonSubN = 0
SELECT @RenglonSubN = MAX(RenglonSub) FROM ProdD WHERE ID = @ModuloID AND Renglon = @Renglon
SELECT @RenglonSubN = ISNULL(@RenglonSubN, 0) + 1, @MAXRenglonID = ISNULL(@MAXRenglonID, 0) + 1
SELECT * INTO #ProdDetalle FROM cProdD WHERE ID = @ModuloID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
UPDATE #ProdDetalle SET Cantidad = @Cantidad, Tarima = @Tarima, RenglonSub = @RenglonSubN, RenglonID = @MAXRenglonID
INSERT INTO cProdD SELECT * FROM #ProdDetalle
DROP TABLE #ProdDetalle
INSERT SerieLoteMov  (
Empresa,  Modulo,  ID,        RenglonID,     Articulo, SubCuenta, SerieLote, Cantidad, Tarima, Propiedades) 
SELECT @Empresa, @Modulo, @ModuloID, @MAXRenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Tarima, Propiedades  
FROM EntarimarTarimaSerieLote
WITH(NOLOCK) WHERE Estacion = @Estacion AND Tarima = @Tarima
END ELSE
UPDATE ProdD
 WITH(ROWLOCK) SET Cantidad = @Cantidad, Tarima = @Tarima
WHERE ID = @ModuloID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
END
SELECT @UltRenglon = @Renglon, @UltRenglonSub = @RenglonSub
END
FETCH NEXT FROM crEntarimar  INTO @Renglon, @RenglonSub, @Cantidad, @Tarima, @Almacen, @Articulo, @SubCuenta
END
CLOSE crEntarimar
DEALLOCATE crEntarimar
IF @Modulo = 'VTAS'
BEGIN
UPDATE Venta  WITH(ROWLOCK) SET RenglonID = @MAXRenglonID WHERE ID = @ModuloID
DELETE VentaD WHERE ID = @ModuloID AND Cantidad IS NULL
UPDATE VentaD  WITH(ROWLOCK) SET CantidadInventario = Cantidad*Factor WHERE ID = @ModuloID AND Factor IS NOT NULL
UPDATE VentaD
 WITH(ROWLOCK) SET VentaD.Costo = (ArtCosto.CostoPromedio*ISNULL(VentaD.Factor, 1))/Venta.TipoCambio
FROM Venta
 WITH(NOLOCK) JOIN VentaD  WITH(NOLOCK) ON Venta.ID = VentaD.ID
LEFT OUTER JOIN ArtCosto  WITH(NOLOCK) ON ArtCosto.Empresa = Venta.Empresa AND ArtCosto.Sucursal = Venta.Sucursal AND ArtCosto.Articulo = VentaD.Articulo
WHERE Venta.ID = @ModuloID
END ELSE
IF @Modulo = 'INV'
BEGIN
UPDATE Inv  WITH(ROWLOCK) SET RenglonID = @MAXRenglonID WHERE ID = @ModuloID
IF @MovTipo <> 'INV.TMA'
DELETE InvD WHERE ID = @ModuloID AND Cantidad IS NULL
UPDATE InvD
 WITH(ROWLOCK) SET CantidadInventario = Cantidad,
Unidad = ISNULL(dbo.fnArtUnidadMinima(@Empresa,Articulo),Unidad)
WHERE ID = @ModuloID AND Seccion IS NOT NULL
SELECT @TipoOpcion = TipoOpcion
FROM Art
WITH(NOLOCK) WHERE Articulo = @Articulo
IF @TipoOpcion <> 'Si' OR @TipoOpcion IS NULL 
UPDATE InvD
 WITH(ROWLOCK) SET InvD.Costo = (ArtCosto.CostoPromedio*ISNULL(InvD.Factor, 1))/Inv.TipoCambio
FROM Inv
 WITH(NOLOCK) JOIN InvD  WITH(NOLOCK) ON Inv.ID = InvD.ID
LEFT OUTER JOIN ArtCosto  WITH(NOLOCK) ON ArtCosto.Empresa = Inv.Empresa AND ArtCosto.Sucursal = Inv.Sucursal AND ArtCosto.Articulo = InvD.Articulo
WHERE Inv.ID = @ModuloID
END ELSE
IF @Modulo = 'COMS'
BEGIN
UPDATE Compra  WITH(ROWLOCK) SET RenglonID = @MAXRenglonID WHERE ID = @ModuloID
DELETE CompraD WHERE ID = @ModuloID AND Cantidad IS NULL
UPDATE CompraD  WITH(ROWLOCK) SET CantidadInventario = Cantidad*Factor WHERE ID = @ModuloID AND Factor IS NOT NULL
UPDATE CompraD
 WITH(ROWLOCK) SET CompraD.Costo = (ArtCosto.CostoPromedio*ISNULL(CompraD.Factor, 1))/Compra.TipoCambio
FROM Compra
 WITH(NOLOCK) JOIN CompraD  WITH(NOLOCK) ON Compra.ID = CompraD.ID
LEFT OUTER JOIN ArtCosto  WITH(NOLOCK) ON ArtCosto.Empresa = Compra.Empresa AND ArtCosto.Sucursal = Compra.Sucursal AND ArtCosto.Articulo = CompraD.Articulo
WHERE Compra.ID = @ModuloID
END ELSE
IF @Modulo = 'PROD'
BEGIN
UPDATE Prod  WITH(ROWLOCK) SET RenglonID = @MAXRenglonID WHERE ID = @ModuloID
DELETE ProdD WHERE ID = @ModuloID AND Cantidad IS NULL
UPDATE ProdD  WITH(ROWLOCK) SET CantidadInventario = Cantidad*Factor WHERE ID = @ModuloID AND Factor IS NOT NULL
UPDATE ProdD
 WITH(ROWLOCK) SET ProdD.Costo = (ArtCosto.CostoPromedio*ISNULL(ProdD.Factor, 1))/Prod.TipoCambio
FROM Prod
 WITH(NOLOCK) JOIN ProdD  WITH(NOLOCK) ON Prod.ID = ProdD.ID
LEFT OUTER JOIN ArtCosto  WITH(NOLOCK) ON ArtCosto.Empresa = Prod.Empresa AND ArtCosto.Sucursal = Prod.Sucursal AND ArtCosto.Articulo = ProdD.Articulo
WHERE Prod.ID = @ModuloID
END
END
IF @Conexion = 0
COMMIT TRANSACTION
RETURN
END

