SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCompraSugerirAceptar
@Estacion		int,
@Sucursal		int,
@Empresa		char(5),
@CompraID		int,
@Todo		bit

AS BEGIN
DECLARE
@CfgMultiUnidades		bit,
@CfgMultiUnidadesNivel	char(20),
@BackOrders			bit,
@BackOrdersNivel		char(20),
@CfgClaveDesarrollo		char(20),
@CfgCompraCostoSugerido	char(20),
@Directo			bit,
@VerDestino			bit,
@TieneDestino		bit,
@Proveedor			char(10),
@ZonaImpuesto		varchar(30),
@Renglon			float,
@RenglonID			int,
@RenglonTipo		char(1),
@Modulo			char(5),
@Mov			char(20),
@MovID			varchar(20),
@Cliente			char(10),
@Almacen			char(10),
@Articulo			char(20),
@ArtTipo			varchar(20),
@Codigo			varchar(50),
@UnidadCompra		varchar(50),
@ArtGrupo			varchar(50),
@ArtDescuentoCompra		float,
@Impuesto1			float,
@Impuesto2			float,
@Impuesto3			money,
@Retencion1			float,
@Retencion2			float,
@Retencion3			float,
@SubCuenta			varchar(50),
@ServicioArticulo		varchar(20),
@ServicioSerie		varchar(20),
@ServicioFecha		datetime,
@SucursalAlmacen		int,
@Cantidad			float,
@CantidadA			float,
@Costo			float,
@DescuentoLinea		float,
@Paquete			int,
@FechaEntrega		datetime,
@DescripcionExtra		varchar(100),
@MovMoneda			char(10),
@MovTipoCambio		float,
@CantidadInventario		float,
@FechaEmision		datetime,
@CompraMov			varchar(20),
@Factor                     float
SET nocount ON
SELECT @RenglonID = 0, @TieneDestino = 0
SELECT @Renglon = ISNULL(MAX(Renglon), 0) FROM CompraD WHERE ID = @CompraID
SELECT @BackOrders = BackOrders,
@BackOrdersNivel = ISNULL(NULLIF(RTRIM(UPPER(BackOrdersNivel)), ''), 'CLIENTE'),
@CfgCompraCostoSugerido = UPPER(CompraCostoSugerido)
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @CfgMultiUnidades       = MultiUnidades,
@CfgMultiUnidadesNivel  = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
SELECT @CfgClaveDesarrollo = UPPER(ClaveDesarrollo)
FROM EmpresaGral
WHERE Empresa = @Empresa
SELECT @Directo = Directo, @VerDestino = VerDestino, @Proveedor = Proveedor, @RenglonID = ISNULL(RenglonID, 0), @FechaEntrega = FechaEntrega, @MovMoneda = Moneda, @MovTipoCambio = TipoCambio,
@FechaEmision = FechaEmision, @CompraMov = Mov
FROM Compra
WHERE ID = @CompraID
SELECT @ZonaImpuesto = ZonaImpuesto
FROM Prov
WHERE Proveedor = @Proveedor
DECLARE crCompraSugerir CURSOR
FOR SELECT s.Cliente, s.Modulo, s.Mov, s.MovID, s.Almacen, s.Articulo, s.SubCuenta, s.UnidadCompra, s.ServicioArticulo, s.ServicioSerie, s.ServicioFecha, ISNULL(s.Cantidad, 0.0), ISNULL(s.CantidadA, 0.0), a.Impuesto1, a.Impuesto2, a.Impuesto3, a.Retencion1, a.Retencion2, a.Retencion3, a.Tipo, a.Grupo, a.DescuentoCompra, s.Paquete, a.Codigo
FROM CompraSugerir s, Art a
WHERE s.Estacion = @Estacion AND s.CompraID = @CompraID AND s.Articulo = a.Articulo
ORDER BY s.Articulo
OPEN crCompraSugerir
FETCH NEXT FROM crCompraSugerir INTO @Cliente, @Modulo, @Mov, @MovID, @Almacen, @Articulo, @SubCuenta, @UnidadCompra, @ServicioArticulo, @ServicioSerie, @ServicioFecha, @Cantidad, @CantidadA, @Impuesto1, @Impuesto2, @Impuesto3, @Retencion1, @Retencion2, @Retencion3, @ArtTipo, @ArtGrupo, @ArtDescuentoCompra, @Paquete, @Codigo
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @Todo = 1 SELECT @CantidadA = @Cantidad
IF @@FETCH_STATUS <> -2 AND @CantidadA > 0
BEGIN
IF @BackOrders = 0 OR @BackOrdersNivel <> 'MOVIMIENTO' SELECT @Modulo = NULL, @Mov = NULL, @MovID = NULL
IF @BackOrders = 0 OR @BackOrdersNivel <> 'CLIENTE'    SELECT @Cliente = NULL
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto2 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto3 OUTPUT
EXEC spTipoImpuesto 'COMS', @CompraID, @CompraMov, @FechaEmision, @Empresa, @Sucursal, @Proveedor, @Articulo = @Articulo, @EnSilencio = 1, @Impuesto1 = @Impuesto1 OUTPUT, @Impuesto2 = @Impuesto2 OUTPUT, @Impuesto3 = @Impuesto3 OUTPUT
SELECT @Factor =  dbo.fnArtUnidadFactor(@Empresa, @Articulo,@UnidadCompra)
EXEC spRenglonTipo @ArtTipo, @SubCuenta, @RenglonTipo OUTPUT
SELECT @SucursalAlmacen = Sucursal FROM Alm WHERE Almacen = @Almacen
EXEC spVerCosto @SucursalAlmacen, @Empresa, @Proveedor, @Articulo, @SubCuenta, @UnidadCompra, @CfgCompraCostoSugerido, @MovMoneda, @MovTipoCambio, @Costo OUTPUT, 0
IF @ServicioArticulo IS NOT NULL
SELECT @DescripcionExtra = @ServicioArticulo + ' - ' + @ServicioSerie + ' - ' + CONVERT(char, @ServicioFecha, 103)
ELSE SELECT @DescripcionExtra = NULL
SELECT @DescuentoLinea = @ArtDescuentoCompra
IF @CfgClaveDesarrollo='INFO' SELECT @DescuentoLinea = ISNULL(Flotante1, 0.0) FROM ArtGrupo WHERE Grupo = @ArtGrupo
SELECT @Renglon = @Renglon + 2048, @RenglonID = @RenglonID + 1
EXEC xpCantidadInventario @Articulo, @SubCuenta, @UnidadCompra, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @CantidadA, @CantidadInventario OUTPUT
INSERT CompraD (Sucursal,  ID,        Renglon,  RenglonSub, RenglonID,  RenglonTipo,  Codigo,  Articulo,  SubCuenta,  Unidad,        Cantidad,   CantidadInventario,  Almacen,  Cliente,  DestinoTipo, Destino, DestinoID, Costo,  DescuentoLinea,  DescripcionExtra,  Impuesto1,  Impuesto2,  Impuesto3,          Retencion1,  Retencion2,  Retencion3,  FechaEntrega,  Paquete)
VALUES (@Sucursal, @CompraID, @Renglon, 0,          @RenglonID, @RenglonTipo, @Codigo, @Articulo, @SubCuenta, @UnidadCompra, @CantidadA, @CantidadInventario, @Almacen, @Cliente, @Modulo,     @Mov,    @MovID,    @Costo, @DescuentoLinea, @DescripcionExtra, @Impuesto1, @Impuesto2, @Impuesto3*@Factor, @Retencion1, @Retencion2, @Retencion3, @FechaEntrega, @Paquete)
IF @TieneDestino = 0 AND @BackOrders = 1 AND @BackOrdersNivel = 'MOVIMIENTO' AND @Mov IS NOT NULL SELECT @TieneDestino = 1
END
FETCH NEXT FROM crCompraSugerir INTO @Cliente, @Modulo, @Mov, @MovID, @Almacen, @Articulo, @SubCuenta, @UnidadCompra, @ServicioArticulo, @ServicioSerie, @ServicioFecha, @Cantidad, @CantidadA, @Impuesto1, @Impuesto2, @Impuesto3, @Retencion1, @Retencion2, @Retencion3, @ArtTipo, @ArtGrupo, @ArtDescuentoCompra, @Paquete, @Codigo
END  
CLOSE crCompraSugerir
DEALLOCATE crCompraSugerir
IF @TieneDestino = 1 SELECT /*@Directo = 0, */@VerDestino = 1
UPDATE Compra SET Directo = @Directo, VerDestino = @VerDestino, RenglonID = @RenglonID WHERE ID = @CompraID
END

