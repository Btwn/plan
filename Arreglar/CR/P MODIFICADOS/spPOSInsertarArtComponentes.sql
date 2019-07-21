SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSInsertarArtComponentes
@Estacion		int,
@ID				varchar(36),
@Empresa		char(5),
@Sucursal		int,
@RenglonId		int,
@Articulo		char(20),
@Cantidad		float,
@CantidadJ		float = 1

AS
BEGIN
DECLARE
@Almacen					char(10),
@FechaRequerida				datetime,
@MovMoneda					char(10),
@MovTipoCambio				float,
@Renglon					float,
@AutoLocalidad				char(5) ,
@Opcion						varchar(20),
@CantidadD					float,
@CantidadInventario         float,
@PrecioIndependiente		bit,
@ListaPreciosEsp 			varchar(50),
@Unidad						varchar(50),
@Precio						float,
@CfgMultiUnidades	        bit,
@CfgMultiUnidadesNivel      char(20),
@CfgInvRegistrarPrecios		bit,
@ZonaImpuesto				varchar(50),
@Impuesto1					float,
@Impuesto2					float,
@Impuesto3					money,
@FechaEmision				datetime,
@Contacto					varchar(10),
@EnviarA					int,
@Mov						varchar(20),
@Juego                      varchar(10),
@SubCuenta                  varchar(50),
@CantidadTotal              float,
@Recalcular                 bit,
@EsDevolucion               bit,
@PrecioImpuestoInc          float,
@ArTipo						varchar(20),
@IDDevolucionP				varchar(36),
@Contador					int,
@Orden						int
CREATE TABLE #OrdenTemporal (IDPos varchar(36), Orden int)
SELECT @ZonaImpuesto = NULL
SELECT @Mov = pl.Mov, @ZonaImpuesto = ISNULL(u.DefZonaImpuesto,c.ZonaImpuesto), @FechaEmision = pl.FechaEmision, @Contacto = pl.Cliente, @EnviarA = pl.EnviarA
FROM POSL pl WITH(NOLOCK) JOIN Usuario u WITH(NOLOCK) ON pl.Usuario = u.Usuario JOIN Cte c ON pl.Cliente = c.Cliente
WHERE pl.ID = @ID
SELECT @Cantidad = Cantidad FROM POSLVenta WITH(NOLOCK) WHERE ID = @ID AND Articulo = @Articulo AND RenglonID = @RenglonId AND RenglonTipo = 'J'
SELECT
@CfgMultiUnidades = MultiUnidades,
@CfgMultiUnidadesNivel  = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD'),
@CfgInvRegistrarPrecios = ISNULL(InvRegistrarPrecios, 0)
FROM EmpresaCfg2 WITH(NOLOCK)
WHERE Empresa = @Empresa
SELECT
@Almacen = Almacen,
@FechaRequerida = FechaEmision,
@MovMoneda = Moneda,
@MovTipoCambio	= TipoCambio
FROM POSL WITH(NOLOCK)
WHERE ID = @ID
DECLARE crJuegoOmision CURSOR FOR
SELECT p.Opcion, ABS(p.CantidadComponente), CONVERT(bit, j.PrecioIndependiente), NULLIF(RTRIM(j.ListaPreciosEsp), ''), a.Unidad,
a.Impuesto1, a.Impuesto2, a.Impuesto3, p.Juego, p.SubCuenta, ISNULL(p.Recalcular,0), ISNULL(p.EsDevolucion,0), a.Tipo
FROM Art a WITH(NOLOCK) JOIN POSArtJuegoComponente p WITH(NOLOCK) ON a.Articulo = p.Opcion
JOIN ArtJuego j WITH(NOLOCK) ON p.Articulo = j.Articulo AND p.Juego = j.Juego
WHERE p.RID = @ID AND p.Estacion = @Estacion
OPEN crJuegoOmision
FETCH NEXT FROM crJuegoOmision INTO @Opcion, @CantidadD, @PrecioIndependiente, @ListaPreciosEsp, @Unidad,
@Impuesto1, @Impuesto2, @Impuesto3, @Juego, @SubCuenta, @Recalcular, @EsDevolucion, @ArTipo
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @EsDevolucion = 1
SET @CantidadD = (@CantidadD * -1)
SELECT @Renglon = MAX(Renglon)
FROM POSLVenta
WHERE ID = @ID
SELECT @Renglon = @Renglon + 2048.0, @Precio = NULL
IF @PrecioIndependiente = 1
EXEC spPCGet @Sucursal, @Empresa, @Opcion, NULL, @Unidad, @MovMoneda, @MovTipoCambio, @ListaPreciosEsp, @Precio OUTPUT
ELSE
SELECT @Precio = 0.0
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto2 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto3 OUTPUT
EXEC spTipoImpuesto 'POS', NULL, @Mov, @FechaEmision, @Empresa, @Sucursal, @Contacto, @EnviarA, @Articulo = @Articulo, @EnSilencio = 1,
@Impuesto1 = @Impuesto1 OUTPUT, @Impuesto2 = @Impuesto2 OUTPUT, @Impuesto3 = @Impuesto3 OUTPUT
EXEC xpCantidadInventario @Articulo, NULL, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @CantidadD, @CantidadInventario OUTPUT
SELECT @Precio = dbo.fnPOSPrecio(@Empresa,@Precio,@Impuesto1,@Impuesto2,@Impuesto3)
SELECT @PrecioImpuestoInc = dbo.fnPOSPrecioConImpuestos(@Precio,@Impuesto1,@Impuesto2,@Impuesto3, @Empresa)
IF NOT EXISTS (SELECT * FROM POSLVenta WHERE ID = @ID AND Articulo = @Opcion AND SubCuenta = @SubCuenta
AND RenglonID = @RenglonId AND RenglonTipo = 'C' AND Juego = @Juego)
INSERT POSLVenta (
ID, Renglon, RenglonID, RenglonTipo, Articulo, Cantidad, CantidadInventario, Unidad, Impuesto1, Impuesto2, Impuesto3, Precio, Juego,
SubCuenta, PrecioImpuestoInc, Almacen)
SELECT
@ID, @Renglon, @RenglonID, 'C', @Opcion, CASE WHEN @Recalcular = 1
THEN (@Cantidad* @CantidadD)*@CantidadJ
ELSE @CantidadD*@CantidadJ
END, @CantidadInventario*@CantidadJ, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3, @Precio, @Juego,
@SubCuenta, @PrecioImpuestoInc, @Almacen
ELSE
UPDATE  POSLVenta WITH(ROWLOCK) SET Cantidad = Cantidad+@CantidadD, CantidadInventario = CantidadInventario +@CantidadD
WHERE ID = @ID AND Articulo = @Opcion AND SubCuenta = @SubCuenta AND RenglonID = @RenglonId AND Juego = @Juego
IF @EsDevolucion = 1 and @ArTipo in ('Serie', 'Lote')
BEGIN
SELECT @IDDevolucionP = NULLIF(IDDevolucionP,'') FROM POSL WHERE ID = @ID
IF @IDDevolucionP IS NOT NULL
BEGIN
DELETE FROM #OrdenTemporal
SET @Contador = 1
WHILE (@Contador <= ABS(@CantidadD))
BEGIN
SET @Orden = NULL
SELECT TOP 1 @Orden = Orden
FROM POSLSerieLote WITH(NOLOCK)
WHERE ID = @IDDevolucionP
AND Articulo = @Opcion
AND SubCuenta = ISNULL(@SubCuenta,'')
AND Orden NOT IN (SELECT Orden FROM #OrdenTemporal WHERE IDPos = @IDDevolucionP )
AND Orden NOT IN (SELECT OrdenDPRef FROM POSLSerieLote WITH(NOLOCK) WHERE ID = @ID)
IF @Orden IS NOT NULL
BEGIN
INSERT INTO #OrdenTemporal (IDPos, Orden) VALUES (@IDDevolucionP, @Orden)
INSERT INTO POSLSerieLote(ID,  RenglonID, Articulo, SubCuenta,	SerieLote, OrdenDPRef)
SELECT					  @ID, @RenglonId, Articulo, SubCuenta,	SerieLote, Orden
FROM POSLSerieLote WITH(NOLOCK)
WHERE ID = @IDDevolucionP
AND Orden = @Orden
END
SET @Contador = @Contador + 1
END
END
END
FETCH NEXT FROM crJuegoOmision INTO @Opcion, @CantidadD, @PrecioIndependiente, @ListaPreciosEsp, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3, @Juego,
@SubCuenta, @Recalcular,  @EsDevolucion, @ArTipo
END
CLOSE crJuegoOmision
DEALLOCATE crJuegoOmision
RETURN
END

