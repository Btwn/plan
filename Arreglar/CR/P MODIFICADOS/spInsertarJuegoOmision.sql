SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInsertarJuegoOmision
@Empresa		char(5),
@Sucursal		int,
@ID			int,
@Articulo		char(20),
@Cantidad		float,
@Almacen		char(10),
@FechaRequerida		datetime,
@MovMoneda		char(10),
@MovTipoCambio		float,
@Renglon		float	OUTPUT,
@RenglonID		float	OUTPUT,
@AutoLocalidad		char(5) = NULL,
@Modulo			char(5) = 'VTAS',
@IDPOS			varchar(50) = NULL,
@Estacion               int = NULL

AS BEGIN
DECLARE
@Opcion			varchar(20),
@CantidadD			float,
@CantidadInventario         float,
@PrecioIndependiente	bit,
@ListaPreciosEsp 		varchar(50),
@Unidad			varchar(50),
@Precio			float,
@CfgMultiUnidades	        bit,
@CfgMultiUnidadesNivel      char(20),
@CfgInvRegistrarPrecios     bit,
@ZonaImpuesto		varchar(50),
@Impuesto1			float,
@Impuesto2			float,
@Impuesto3			money,
@FechaEmision		datetime,
@Contacto			varchar(10),
@EnviarA			int,
@Mov			varchar(20),
@Juego                      varchar(10),
@SubCuenta                  varchar(50),
@Factor                     float
SELECT @ZonaImpuesto = NULL
IF @Modulo = 'VTAS' SELECT @Mov = Mov, @ZonaImpuesto = ZonaImpuesto, @FechaEmision = FechaEmision, @Contacto = Cliente, @EnviarA = EnviarA FROM Venta with(nolock) WHERE ID = @ID ELSE
IF @Modulo = 'POS' SELECT @Mov = pl.Mov, @ZonaImpuesto = ISNULL(u.DefZonaImpuesto,c.ZonaImpuesto), @FechaEmision = pl.FechaEmision, @Contacto = pl.Cliente, @EnviarA = pl.EnviarA
FROM POSL pl  WITH(NOLOCK) JOIN Usuario u   WITH(NOLOCK) ON pl.Usuario = u.Usuario JOIN Cte c  WITH(NOLOCK) ON pl.Cliente = c.Cliente
WHERE pl.ID = @IDPOS ELSE
IF @Modulo = 'COMS' SELECT @Mov = Mov, @ZonaImpuesto = ZonaImpuesto, @FechaEmision = FechaEmision, @Contacto = Proveedor FROM Compra WHERE ID = @ID
SELECT @CfgMultiUnidades       = MultiUnidades,
@CfgMultiUnidadesNivel  = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD'),
@CfgInvRegistrarPrecios = ISNULL(InvRegistrarPrecios, 0)
FROM EmpresaCfg2
WHERE Empresa = @Empresa
DECLARE crJuegoOmision CURSOR FOR
SELECT j.Opcion, j.Cantidad*@Cantidad, CONVERT(bit, j.PrecioIndependiente), NULLIF(RTRIM(j.ListaPreciosEsp), ''), a.Unidad, a.Impuesto1, a.Impuesto2, a.Impuesto3, j.Juego, j.SubCuenta
FROM Art a, ArtJuegoOmision j
WITH(NOLOCK) WHERE j.Articulo = @Articulo AND j.Opcion = a.Articulo
OPEN crJuegoOmision
FETCH NEXT FROM crJuegoOmision  INTO @Opcion, @CantidadD, @PrecioIndependiente, @ListaPreciosEsp, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3, @Juego, @SubCuenta
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Renglon   = @Renglon + 2048.0,
@Precio    = NULL
IF @Modulo IN ('COMS', 'VTAS','POS')
BEGIN
IF @PrecioIndependiente = 1
EXEC spPCGet @Sucursal, @Empresa, @Opcion, NULL, @Unidad, @MovMoneda, @MovTipoCambio, @ListaPreciosEsp, @Precio OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto2 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto3 OUTPUT
EXEC spTipoImpuesto @Modulo, @ID, @Mov, @FechaEmision, @Empresa, @Sucursal, @Contacto, @EnviarA, @Articulo = @Articulo, @EnSilencio = 1, @Impuesto1 = @Impuesto1 OUTPUT, @Impuesto2 = @Impuesto2 OUTPUT, @Impuesto3 = @Impuesto3 OUTPUT
SELECT @Factor =  dbo.fnArtUnidadFactor(@Empresa, @Articulo,@Unidad)
END
EXEC xpCantidadInventario @Articulo, NULL, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @CantidadD, @CantidadInventario OUTPUT
IF @Modulo = 'VTAS'
INSERT VentaD (ID,  Renglon,  RenglonID,  RenglonTipo,  Articulo, Cantidad,   CantidadInventario,  Unidad,  Impuesto1,  Impuesto2,  Impuesto3,          Precio,  AutoLocalidad,  Almacen,  FechaRequerida)
VALUES (@ID, @Renglon, @RenglonID, 'C',          @Opcion,  @CantidadD, @CantidadInventario, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3*@Factor, @Precio, @AutoLocalidad, @Almacen, @FechaRequerida)
ELSE
IF @Modulo = 'INV'
BEGIN
IF @CfgInvRegistrarPrecios = 0 SELECT @Precio = NULL
INSERT InvD (ID,  Renglon,  RenglonID,  RenglonTipo,  Articulo, Cantidad,   CantidadInventario,  Unidad,  Almacen,  FechaRequerida, Precio)
VALUES (@ID, @Renglon, @RenglonID, 'C',          @Opcion,  @CantidadD, @CantidadInventario, @Unidad, @Almacen, @FechaRequerida, @Precio)
END ELSE
IF @Modulo = 'COMS'
INSERT CompraD (ID,  Renglon,  RenglonID,  RenglonTipo,  Articulo, Cantidad,   CantidadInventario,  Unidad,  Impuesto1,  Impuesto2,  Impuesto3,          Almacen,  FechaRequerida)
VALUES (@ID, @Renglon, @RenglonID, 'C',          @Opcion,  @CantidadD, @CantidadInventario, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3*@Factor, @Almacen, @FechaRequerida)
ELSE
IF @Modulo = 'PROD'
INSERT ProdD (ID,  Renglon,  RenglonID,  RenglonTipo,  Articulo, Cantidad,   CantidadInventario,  Unidad,  Almacen)
VALUES (@ID, @Renglon, @RenglonID, 'C',          @Opcion,  @CantidadD, @CantidadInventario, @Unidad, @Almacen)
ELSE
IF @Modulo = 'POS'
BEGIN
INSERT POSArtJuegoComponente(Estacion,  RID, RenglonID,  Articulo,  ArtSubCuenta,   Juego,   Componente,    Opcion,     SubCuenta, Opcional, Cantidad, Recalcular, CantidadComponente)
SELECT                       @Estacion, @IDPOS, @RenglonID, @Articulo,  CASE WHEN NULLIF(@SubCuenta,'') IS NOT NULL THEN @Opcion+' ('+@SubCuenta+')' ELSE @Opcion END , @Juego, j.Descripcion, @Opcion, @SubCuenta, ISNULL(j.Opcional,0), @Cantidad, 0,@CantidadD
FROM ArtJuego j   WITH(NOLOCK) JOIN ArtJuegoD d  WITH(NOLOCK) ON j.Articulo = d.Articulo AND j.Juego = d.Juego
WHERE  j.Articulo = @Articulo AND j.Juego = @Juego AND  d.Opcion = @Opcion
GROUP BY   j.Descripcion, j.Opcional
IF EXISTS(SELECT * FROM POSLVenta WHERE ID = @IDPOS AND Articulo = @Articulo)
BEGIN
SELECT @RenglonID = RenglonID FROM POSLVenta WITH(NOLOCK) WHERE ID = @IDPOS AND Articulo = @Articulo
UPDATE POSArtJuegoComponente  WITH(ROWLOCK) SET RenglonID = @RenglonID WHERE Estacion = @Estacion AND Articulo = @Articulo
END
END
END
FETCH NEXT FROM crJuegoOmision  INTO @Opcion, @CantidadD, @PrecioIndependiente, @ListaPreciosEsp, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3, @Juego, @SubCuenta
END
CLOSE crJuegoOmision
DEALLOCATE crJuegoOmision
RETURN
END

