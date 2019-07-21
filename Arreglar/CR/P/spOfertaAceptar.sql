SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOfertaAceptar
@Estacion	int,
@Modulo	char(5),
@ID		int,
@MovTipo	char(20)

AS BEGIN
DECLARE
@Sucursal			int,
@Empresa			char(5),
@Moneda			char(10),
@TipoCambio			float,
@CfgCompraCostoSugerido  	char(20),
@Mov			char(20),
@MovInserta     varchar(20),
@MovID			varchar(20),
@Renglon			float,
@RenglonID			int,
@LModulo			char(5),
@LID			int,
@LRenglon			float,
@LRenglonSub		int,
@FechaEmision		datetime,
@FechaRequerida		datetime,
@FechaEntrega		datetime,
@Articulo			char(20),
@SubCuenta			varchar(50),
@ProdRuta			varchar(20),
@RenglonTipo		char(1),
@Almacen			char(10),
@Proveedor			char(10),
@ProveedorD			char(10),
@Referencia			varchar(50),
@ReferenciaD		varchar(50),
@Cantidad			float,
@CantidadInventario		float,
@Factor			float,
@Unidad			varchar(50),
@DescripcionExtra		varchar(100),
@DescuentoTipo		char(1),
@DescuentoLinea		float,
@Impuesto1			float,
@Impuesto2			float,
@Impuesto3			money,
@Retencion1			float,
@Retencion2			float,
@Retencion3			float,
@Costo			money,
@ProdSerieLote		char(20),
@TiempoEntrega		int,
@TiempoEntregaUnidad	varchar(10),
@ListaPreciosEsp		varchar(20),
@ImportacionProveedor	varchar(10),
@ImportacionReferencia	varchar(50),
@Pais			varchar(50),
@TratadoComercial		varchar(50),
@ProgramaSectorial		varchar(50),
@ValorAduana		money,
@ID1			char(2),
@ID2			char(2),
@FormaPago			varchar(50),
@ImportacionImpuesto1	float,
@ImportacionImpuesto2	float,
@MonedaD                varchar(10),
@TipoCambioD            float,
@Destino                varchar(20),
@DestinoID              varchar(20),
@SubClave               varchar(20)
SELECT @Renglon = 0.0, @RenglonID = 0, @Proveedor = NULL, @ProdSerieLote = NULL, @ImportacionProveedor = NULL, @ImportacionReferencia = NULL
IF @Modulo = 'COMS'
BEGIN
SELECT @Sucursal = Sucursal, @Empresa = Empresa, @MovInserta = Mov, @Moneda = Moneda, @TipoCambio = TipoCambio, @Proveedor = Proveedor, @Referencia = Referencia, @FechaEmision = FechaEmision, @ListaPreciosEsp = NULLIF(RTRIM(ListaPreciosEsp), '') FROM Compra WHERE ID = @ID
SELECT @Renglon = ISNULL(MAX(Renglon), 0.0), @RenglonID = ISNULL(MAX(RenglonID), 0) FROM CompraD WHERE ID = @ID
END
BEGIN TRANSACTION
DECLARE crLista CURSOR FOR
SELECT l.Modulo, l.ID, l.Renglon, l.RenglonSub
FROM ListaIDRenglon l
WHERE l.Estacion = @Estacion
ORDER BY l.Modulo, l.ID, l.Renglon, l.RenglonSub
OPEN crLista
FETCH NEXT FROM crLista INTO @LModulo, @LID, @LRenglon, @LRenglonSub
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @DescripcionExtra = NULL
SELECT @Renglon = @Renglon + 2048.0
IF @LModulo = 'COMS'
BEGIN
SELECT @Mov = e.Mov, @MovID = e.MovID, @RenglonTipo = RenglonTipo, @Articulo = d.Articulo, @SubCuenta = d.SubCuenta, @Almacen = d.Almacen, @Cantidad = d.CantidadPendiente, @Unidad = d.Unidad, @Factor = d.Factor, @FechaRequerida = d.FechaRequerida,
@DescripcionExtra = d.DescripcionExtra, @DescuentoTipo = DescuentoTipo, @DescuentoLinea = DescuentoLinea,
@Impuesto1 = Impuesto1, @Impuesto2 = Impuesto2, @Impuesto3 = Impuesto3, @Retencion1 = Retencion1, @Retencion2 = Retencion2, @Retencion3 = Retencion3, @Costo = d.Costo,
@ProveedorD = e.Proveedor, @ReferenciaD = e.Referencia, @Pais = d.Pais, @TratadoComercial = d.TratadoComercial, @ProgramaSectorial = d.ProgramaSectorial, @ValorAduana = d.ValorAduana, @ID1 = d.ID1, @ID2 = d.ID2,
@FormaPago = d.FormaPago, @ImportacionImpuesto1 = d.ImportacionImpuesto1, @ImportacionImpuesto2 = d.ImportacionImpuesto2, @MonedaD = e.Moneda, @TipocambioD = e.TipoCambio,
@Destino=d.Destino, @DestinoID=d.DestinoID
FROM Compra e, CompraD d
WHERE e.ID = d.ID AND d.ID = @LID AND d.Renglon = @LRenglon AND d.RenglonSub = @LRenglonSub
END
SELECT @CantidadInventario = @Cantidad * @Factor
IF @Modulo = 'COMS'
BEGIN
SELECT @SubClave = SubClave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @MovInserta
IF @MovTipo = 'COMS.EI' OR @SubClave = 'COMS.EIMPO' SELECT @ImportacionProveedor = @ProveedorD, @ImportacionReferencia = @ReferenciaD
INSERT CompraD (ID, Renglon, RenglonSub, RenglonID, RenglonTipo,  Aplica,  AplicaID,  Articulo,  SubCuenta,  Almacen,  Cantidad,  Unidad,  CantidadInventario,  FechaRequerida,  Impuesto1,  Impuesto2,  Impuesto3,  Retencion1,  Retencion2,  Retencion3,  Costo,  DescripcionExtra,  DescuentoTipo,  DescuentoLinea,  ImportacionProveedor,  ImportacionReferencia,  Pais,  TratadoComercial,  ProgramaSectorial,  ValorAduana,  ID1,  ID2,  FormaPago,  ImportacionImpuesto1,  ImportacionImpuesto2, MonedaD, TipoCambioD,Destino, DestinoID)
VALUES (@ID, @Renglon, 0,        @RenglonID, @RenglonTipo, @Mov,    @MovID,    @Articulo, @SubCuenta, @Almacen, @Cantidad, @Unidad, @CantidadInventario, @FechaRequerida, @Impuesto1, @Impuesto2, @Impuesto3, @Retencion1, @Retencion2, @Retencion3, @Costo, @DescripcionExtra, @DescuentoTipo, @DescuentoLinea, @ImportacionProveedor, @ImportacionReferencia, @Pais, @TratadoComercial, @ProgramaSectorial, @ValorAduana, @ID1, @ID2, @FormaPago, @ImportacionImpuesto1, @ImportacionImpuesto2, @MonedaD, @TipoCambioD, @Destino, @DestinoID)
END
END
FETCH NEXT FROM crLista INTO @LModulo, @LID, @LRenglon, @LRenglonSub
END 
CLOSE crLista
DEALLOCATE crLista
SELECT @RenglonID = 0
IF @Modulo = 'COMS'
BEGIN
DECLARE crRenglonID CURSOR FOR
SELECT RenglonTipo
FROM CompraD
WHERE ID = @ID
ORDER BY Renglon, RenglonSub
OPEN crRenglonID
FETCH NEXT FROM crRenglonID INTO @RenglonTipo
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @RenglonTipo NOT IN ('C', 'E') SELECT @RenglonID = @RenglonID + 1
UPDATE CompraD SET RenglonID = @RenglonID WHERE CURRENT OF crRenglonID
END
FETCH NEXT FROM crRenglonID INTO @RenglonTipo
END 
CLOSE crRenglonID
DEALLOCATE crRenglonID
UPDATE Compra SET Directo = 0, RenglonID = @RenglonID WHERE ID = @ID
END
DELETE ListaIDRenglon WHERE Estacion = @Estacion
COMMIT TRANSACTION
RETURN
END

