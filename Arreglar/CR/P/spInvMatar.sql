SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvMatar
@Sucursal		int,
@ID			int,
@Accion			char(20),
@Base			char(20),
@Empresa		char(5),
@Usuario		char(10),
@Modulo			char(5),
@Mov			char(20),
@MovID			varchar(20),
@MovTipo		char(20),
@Estatus		char(15),
@EstatusNuevo		char(15),
@FechaEmision		datetime,
@FechaRegistro		datetime,
@FechaAfectacion	datetime,
@Ejercicio		int,
@Periodo		int,
@AfectarConsignacion	bit,
@AlmacenTipo		char(15),
@AlmacenDestinoTipo	char(15),
@CfgVentaSurtirDemas	bit,
@CfgCompraRecibirDemas	bit,
@CfgTransferirDemas	bit,
@CfgBackOrders		bit,
@CfgContX		bit,
@CfgContXGenerar	char(20),
@CfgEmbarcar		bit,
@CfgImpInc		bit,
@CfgMultiUnidades	bit,
@CfgMultiUnidadesNivel	char(20),
@Ok 			int	     OUTPUT,
@OkRef          	varchar(255) OUTPUT,
@CfgPrecioMoneda	bit	= 0

AS BEGIN
DECLARE
@Requiere			float,
@Obtenido			float,
@ReservadoObtenido		float,
@PendienteObtenido		float,
@PendienteDif		float,
@NuevoPendiente     	float,
@Cantidad			float,
@MermaDesp			float,
@CantidadA			float,
@CantidadOriginal		float,
@CantidadInventario		float,
@CantidadReservada		float,
@CantidadPendiente		float,
@CantidadOrdenada		float,
@Renglon			float,
@RenglonSub			int,
@RenglonID			int,
@RenglonTipo		char(1),
@AlmacenOrigen		char(10),
@AlmacenBackOrders		char(10),
@Articulo			char(20),
@ArticuloOriginal		char(20),
@SubCuentaOriginal		varchar(50),
@SustitutoArticulo		varchar(20),
@SustitutoSubCuenta		varchar(50),
@ArtTipo			char(20),
@ArtUnidad			varchar(50),
@ArtMoneda			char(10),
@SubCuenta			varchar(50),
@ProdSerieLote		varchar(50),
@Espacio			varchar(10),
@Centro			varchar(10),
@CentroDestino		varchar(10),
@AplicaMov			char(20),
@AplicaMovTipo		char(20),
@AplicaTipoCambio		float,
@AplicaEstatus		char(15),
@AplicaEstatusNuevo		char(15),
@AplicaFechaConclusion	datetime,
@Llave			int,
@AplicaMovID		varchar(20),
@IDAplica			int,
@UltID			int,
@DescuentoGlobal		float,
@SobrePrecio		float,
@CantidadCalcularImporte	float,
@Precio	         	float,
@PrecioTipoCambio		float,
@DescuentoTipo	 	char(1),
@DescuentoLinea	 	float,
@Impuesto1		 	float,
@Impuesto2		 	float,
@Impuesto3		 	money,
@Impuesto5		 	money,
@Importe 			money,
@ImporteNeto		money,
@Impuestos 			money,
@ImpuestosNetos		money,
@Impuesto1Neto		money,
@Impuesto2Neto		money,
@Impuesto3Neto		money,
@Impuesto5Neto		money,
@DescuentoLineaImporte 	money,
@DescuentoGlobalImporte 	money,
@SobrePrecioImporte 	money,
@SumaImporteNeto		money,
@SumaImpuestos		money,
@SumaImpuestosNetos		money,
@SumaImpuesto1Neto		money,
@SumaImpuesto2Neto		money,
@SumaImpuesto3Neto		money,
@SumaPendiente		float,
@ImporteMatar		money,
@SucursalAlmacenOrigen	int,
@Rama			char(5),
@MovUnidad			varchar(50),
@Factor			float,
@QuedaPendiente		bit,
@SinMatar			bit,
@EsCargo			bit,
@EsEntrada			bit,
@EsSalida			bit,
@AfectarPiezas		bit,
@AfectarCostos		bit,
@AfectarUnidades		bit,
@DestinoTipo	  	varchar(10),
@Destino			varchar(20),
@DestinoID			varchar(20),
@ContratoEstatusNuevo	char(15),
@Cliente			char(10),
@DetalleTipo		varchar(20),
/*    @AplicaAplica		char(20),
@AplicaAplicaID		int,*/
@Cancelar			bit,
@Redondeo			int,
@Existe			bit,
@SinAlmacen			bit,
@Retencion1			float,
@Retencion2			float,
@Retencion3			float,
@FechaAplica		datetime,
@EjercicioAplica	int,
@PeriodoAplica		int,
@AplicaRenglon		float
SELECT @SinAlmacen = 0
SELECT @Redondeo = ISNULL(DecimalesCantidadPendiente, 2)
FROM EmpresaCfg2
WHERE Empresa = @Empresa
DECLARE @AMatar TABLE (
Llave			int		NOT NULL IDENTITY (1,1),
ID	        	int	        NULL,
MovTipo			char(20)	COLLATE Database_Default NULL,
Almacen			char(10)	COLLATE Database_Default NULL,
Articulo		char(20)	COLLATE Database_Default NULL,
SubCuenta		varchar(50)	COLLATE Database_Default NULL,
Unidad			varchar(50)	COLLATE Database_Default NULL,
Espacio			varchar(10)	COLLATE Database_Default NULL,
Centro			varchar(10)	COLLATE Database_Default NULL,
CentroDestino	varchar(10)	COLLATE Database_Default NULL,
Cliente			varchar(10)	COLLATE Database_Default NULL,
ProdSerieLote	varchar(50)	COLLATE Database_Default NULL,
Cantidad		float		NULL,
AplicaRenglon	float		NULL)
IF @@ERROR <> 0 SELECT @Ok = 1
DECLARE @MatarIndice TABLE (
ID 		 		int 		NULL,
Estatus			char(15)	COLLATE Database_Default NULL,
Mov				char(20)	COLLATE Database_Default NULL,
MovID			varchar(20)	COLLATE Database_Default NULL,
MovTipo			char(20)	COLLATE Database_Default NULL,
TipoCambio		float		NULL,
Almacen			char(10)	COLLATE Database_Default NULL,
DescuentoGlobal	float		NULL,
SobrePrecio		float		NULL,
Importe			money		NULL)
IF @@ERROR <> 0 SELECT @Ok = 1
DECLARE @MatarDetalle TABLE (
ID	        	int	        NULL,
Renglon			float		NULL,
RenglonSub		int			NULL,
Reservado		float		NULL,
Pendiente		float		NULL,
MovTipo			char(20)	COLLATE Database_Default NULL,
Almacen			char(10)	COLLATE Database_Default NULL,
Articulo		char(20)	COLLATE Database_Default NULL,
SubCuenta		varchar(50)	COLLATE Database_Default NULL,
Factor			float		NULL,
AplicaRenglon	float		NULL)
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Accion = 'CANCELAR' SELECT @Cancelar = 1 ELSE SELECT @Cancelar = 0
IF @Modulo = 'VTAS'
DECLARE crMatarMov CURSOR
FOR SELECT Venta.ID, Venta.Estatus, Venta.Mov, Venta.MovID, Venta.TipoCambio, VentaD.Almacen, Venta.DescuentoGlobal, Venta.SobrePrecio, MovTipo.Clave, sum(ISNULL(Cantidad, 0.0)), 0.0, sum(ISNULL(CantidadInventario, 0.0)), sum(ISNULL(CantidadReservada, 0.0)), sum(ISNULL(CantidadOrdenada, 0.0)), sum(ISNULL(CantidadPendiente, 0.0)), sum(ISNULL(CantidadA, 0.0)), CONVERT(char, NULL), VentaD.Articulo, NULLIF(RTRIM(Subcuenta), ''), NULLIF(RTRIM(SustitutoArticulo), ''), NULLIF(RTRIM(SustitutoSubCuenta), ''), NULLIF(RTRIM(VentaD.Unidad), ''), VentaD.Factor, NULLIF(RTRIM(UPPER(Art.Tipo)), ''), Art.Unidad, RenglonTipo, CONVERT(char, NULL), VentaD.Espacio, CONVERT(varchar, NULL), CONVERT(varchar, NULL), CONVERT(varchar, NULL), VentaD.AplicaRenglon
FROM VentaD, Venta, MovTipo, Art
WHERE VentaD.ID = @ID
AND Venta.Empresa = @Empresa
AND Venta.Mov = Aplica
AND Venta.MovID = AplicaID
AND Venta.Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR', 'CANCELADO')
AND MovTipo.Modulo = 'VTAS'
AND MovTipo.Mov = Aplica
AND Art.Articulo = VentaD.Articulo
AND Aplica IS NOT NULL
AND AplicaID IS NOT NULL
GROUP BY Venta.ID, Venta.Estatus, Venta.Mov, Venta.MovID, Venta.TipoCambio, VentaD.Almacen, Venta.DescuentoGlobal, Venta.SobrePrecio, MovTipo.Clave, VentaD.Articulo, SubCuenta, SustitutoArticulo, SustitutoSubCuenta, VentaD.Unidad, VentaD.Factor, Art.Tipo, Art.Unidad, RenglonTipo, VentaD.Espacio, VentaD.AplicaRenglon
ORDER BY Venta.ID, Venta.Estatus, Venta.Mov, Venta.MovID, Venta.TipoCambio, VentaD.Almacen, Venta.DescuentoGlobal, Venta.SobrePrecio, MovTipo.Clave, VentaD.Articulo, SubCuenta, SustitutoArticulo, SustitutoSubCuenta, VentaD.Unidad, VentaD.Factor, Art.Tipo, Art.Unidad, RenglonTipo, VentaD.Espacio, VentaD.AplicaRenglon
ELSE
IF @Modulo = 'COMS'
DECLARE crMatarMov CURSOR
FOR SELECT Compra.ID, Compra.Estatus, Compra.Mov, Compra.MovID, Compra.TipoCambio, CompraD.Almacen, Compra.DescuentoGlobal, 0.0, MovTipo.Clave, sum(ISNULL(Cantidad, 0.0)), 0.0, sum(ISNULL(CantidadInventario, 0.0)), sum(ISNULL(Cantidad, 0.0)), sum(ISNULL(Cantidad, 0.0)), sum(ISNULL(CantidadPendiente, 0.0)), sum(ISNULL(CantidadA, 0.0)), CONVERT(char, NULL), CompraD.Articulo, NULLIF(RTRIM(Subcuenta), ''), convert(char(20), NULL), convert(char(20), NULL), NULLIF(RTRIM(CompraD.Unidad), ''), CompraD.Factor, NULLIF(RTRIM(UPPER(Art.Tipo)), ''), Art.Unidad, RenglonTipo, CONVERT(char, NULL), CONVERT(varchar, NULL), CONVERT(varchar, NULL), CONVERT(varchar, NULL), CompraD.Cliente, CompraD.AplicaRenglon
FROM CompraD, Compra, MovTipo, Art
WHERE CompraD.ID = @ID
AND Compra.Empresa = @Empresa
AND Compra.Mov = Aplica
AND Compra.MovID = AplicaID
AND Compra.Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR', 'CANCELADO')
AND MovTipo.Modulo = 'COMS'
AND MovTipo.Mov = Aplica
AND Art.Articulo = CompraD.Articulo
AND Aplica IS NOT NULL
AND AplicaID IS NOT NULL
GROUP BY Compra.ID, Compra.Estatus, Compra.Mov, Compra.MovID, Compra.TipoCambio, CompraD.Almacen, Compra.DescuentoGlobal, MovTipo.Clave, CompraD.Articulo, SubCuenta, CompraD.Unidad, CompraD.Factor, Art.Tipo, Art.Unidad, RenglonTipo, CompraD.Cliente, CompraD.AplicaRenglon
ORDER BY Compra.ID, Compra.Estatus, Compra.Mov, Compra.MovID, Compra.TipoCambio, CompraD.Almacen, Compra.DescuentoGlobal, MovTipo.Clave, CompraD.Articulo, SubCuenta, CompraD.Unidad, CompraD.Factor, Art.Tipo, Art.Unidad, RenglonTipo, CompraD.Cliente, CompraD.AplicaRenglon
ELSE
IF @Modulo = 'INV'
DECLARE crMatarMov CURSOR
FOR SELECT Inv.ID, Inv.Estatus, Inv.Mov, Inv.MovID, Inv.TipoCambio, InvD.Almacen, 0.0, 0.0, MovTipo.Clave, sum(ISNULL(Cantidad, 0.0)), 0.0, sum(ISNULL(CantidadInventario, 0.0)), sum(ISNULL(CantidadReservada, 0.0)), sum(ISNULL(CantidadOrdenada, 0.0)), sum(ISNULL(CantidadPendiente, 0.0)), sum(ISNULL(CantidadA, 0.0)), NULLIF(RTRIM(ProdSerieLote), ''), InvD.Articulo, NULLIF(RTRIM(Subcuenta), ''), convert(char(20), NULL), convert(char(20), NULL), NULLIF(RTRIM(InvD.Unidad), ''), InvD.Factor, NULLIF(RTRIM(UPPER(Art.Tipo)), ''), Art.Unidad, RenglonTipo, InvD.Tipo, CONVERT(varchar, NULL), CONVERT(varchar, NULL), CONVERT(varchar, NULL), CONVERT(varchar, NULL), InvD.AplicaRenglon
FROM InvD, Inv, MovTipo, Art
WHERE InvD.ID = @ID
AND Inv.Empresa = @Empresa
AND Inv.Mov = Aplica
AND Inv.MovID = AplicaID
AND Inv.Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR', 'CANCELADO')
AND MovTipo.Modulo = 'INV'
AND MovTipo.Mov = Aplica
AND Art.Articulo = InvD.Articulo
AND Aplica IS NOT NULL
AND AplicaID IS NOT NULL
AND InvD.Seccion IS NULL
GROUP BY Inv.ID, Inv.Estatus, Inv.Mov, Inv.MovID, Inv.TipoCambio, InvD.Almacen, MovTipo.Clave, InvD.ProdSerieLote, InvD.Articulo, SubCuenta, InvD.Unidad, InvD.Factor, InvD.Tipo, Art.Tipo, Art.Unidad, RenglonTipo, InvD.AplicaRenglon
ORDER BY Inv.ID, Inv.Estatus, Inv.Mov, Inv.MovID, Inv.TipoCambio, InvD.Almacen, MovTipo.Clave, InvD.ProdSerieLote, InvD.Articulo, SubCuenta, InvD.Unidad, InvD.Factor, InvD.Tipo, Art.Tipo, Art.Unidad, RenglonTipo, InvD.AplicaRenglon
ELSE
IF @Modulo = 'PROD'
DECLARE crMatarMov CURSOR
FOR SELECT e.ID, e.Estatus, e.Mov, e.MovID, e.TipoCambio, d.Almacen, 0.0, 0.0, MovTipo.Clave, sum(ISNULL(d.Cantidad, 0.0)), sum(ISNULL(d.Merma, 0.0)+ISNULL(d.Desperdicio, 0.0)), sum(ISNULL(d.CantidadInventario, 0.0)), sum(ISNULL(d.CantidadReservada, 0.0)), sum(ISNULL(d.CantidadOrdenada, 0.0)), sum(ISNULL(d.CantidadPendiente, 0.0)), sum(ISNULL(d.CantidadA, 0.0)), NULLIF(RTRIM(d.ProdSerieLote), ''), d.Articulo, NULLIF(RTRIM(d.Subcuenta), ''), convert(char(20), NULL), convert(char(20), NULL), NULLIF(RTRIM(d.Unidad), ''), d.Factor, NULLIF(RTRIM(UPPER(Art.Tipo)), ''), Art.Unidad, d.RenglonTipo, d.Tipo, CONVERT(varchar, NULL), d.Centro, d.CentroDestino, CONVERT(varchar, NULL), d.AplicaRenglon
FROM ProdD d, Prod e, MovTipo, Art
WHERE d.ID = @ID
AND UPPER(d.Tipo) <> 'EXCEDENTE'
AND e.Empresa = @Empresa
AND e.Mov = d.Aplica
AND e.MovID = d.AplicaID
AND e.Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR', 'CANCELADO')
AND MovTipo.Modulo = 'PROD'
AND MovTipo.Mov = e.Mov
AND Art.Articulo = d.Articulo
AND Aplica IS NOT NULL
AND AplicaID IS NOT NULL
GROUP BY e.ID, e.Estatus, e.Mov, e.MovID, e.TipoCambio, d.Almacen, MovTipo.Clave, d.ProdSerieLote, d.Articulo, d.SubCuenta, d.Unidad, d.Factor, d.Tipo, Art.Tipo, Art.Unidad, RenglonTipo, d.Centro, d.CentroDestino, d.AplicaRenglon
ORDER BY e.ID, e.Estatus, e.Mov, e.MovID, e.TipoCambio, d.Almacen, MovTipo.Clave, d.ProdSerieLote, d.Articulo, d.SubCuenta, d.Unidad, d.Factor, d.Tipo, Art.Tipo, Art.Unidad, RenglonTipo, d.Centro, d.CentroDestino, d.AplicaRenglon
OPEN crMatarMov
FETCH NEXT FROM crMatarMov INTO @IDAplica, @AplicaEstatus, @AplicaMov, @AplicaMovID, @AplicaTipoCambio, @AlmacenOrigen, @DescuentoGlobal, @SobrePrecio, @AplicaMovTipo, @CantidadOriginal, @MermaDesp, @CantidadInventario, @CantidadReservada, @CantidadOrdenada, @CantidadPendiente, @CantidadA, @ProdSerieLote, @ArticuloOriginal, @SubcuentaOriginal, @SustitutoArticulo, @SustitutoSubCuenta, @MovUnidad, @Factor, @ArtTipo, @ArtUnidad, @RenglonTipo, @DetalleTipo, @Espacio, @Centro, @CentroDestino, @Cliente, @AplicaRenglon
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
EXEC spMovInfo @IDAplica, @Modulo, @FechaEmision = @FechaAplica OUTPUT, @Ejercicio = @EjercicioAplica OUTPUT, @Periodo = @PeriodoAplica OUTPUT
IF @Ok IS NULL AND @Accion <> 'CANCELAR'
EXEC spValidarFechaAplicacion @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @FechaEmision, @Ejercicio, @Periodo,
@AplicaMov, @AplicaMovID, @Modulo, @IDAplica, @FechaAplica, @EjercicioAplica, @PeriodoAplica, @Ok = @Ok OUTPUT,
@OkRef = @OkRef OUTPUT
IF @Ok IS NULL AND @Accion <> 'CANCELAR'
EXEC spEmpresaValidarFechaAplicacion @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @FechaEmision, @Ejercicio, @Periodo,
@AplicaMov, @AplicaMovID, @Modulo, @IDAplica, @FechaAplica, @EjercicioAplica, @PeriodoAplica, @Ok = @Ok OUTPUT,
@OkRef = @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
IF @MovTipo = 'PROD.E' SELECT @CantidadOriginal = @CantidadOriginal + ISNULL(@MermaDesp, 0.0)
IF @SustitutoArticulo  IS NOT NULL AND @ArticuloOriginal  <> @SustitutoArticulo  SELECT @Articulo  = @SustitutoArticulo  ELSE SELECT @Articulo  = @ArticuloOriginal
IF @SustitutoSubCuenta IS NOT NULL AND @SubCuentaOriginal <> @SustitutoSubCuenta SELECT @SubCuenta = @SustitutoSubCuenta ELSE SELECT @SubCuenta = @SubCuentaOriginal
IF (@MovTipo = 'COMS.DG' AND @AplicaMovTipo = 'COMS.IG') 
SELECT @AlmacenOrigen = MIN(d.Almacen) FROM CompraD d WHERE d.ID = @IDAplica AND d.Articulo = @Articulo AND ISNULL(d.SubCuenta, '') = ISNULL(@SubCuenta, '') AND d.Unidad = @MovUnidad AND Renglon = ISNULL(@AplicaRenglon,Renglon)
IF (@MovTipo IN ('VTAS.F','VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX') AND @AplicaMovTipo IN ('VTAS.VC', 'VTAS.VCR'))
SELECT @SinAlmacen = 1
IF @Modulo = 'VTAS' AND @MovTipo=@AplicaMovTipo
SELECT @AlmacenOrigen = MIN(d.Almacen) FROM VentaD d WHERE d.ID = @IDAplica AND d.Articulo = @Articulo AND ISNULL(d.SubCuenta, '') = ISNULL(@SubCuenta, '') AND d.Unidad = @MovUnidad AND Renglon = ISNULL(@AplicaRenglon,Renglon)
/** 28.07.2006 **/
IF (@MovTipo = 'INV.R' AND @AplicaMovTipo = 'INV.P') OR (@MovTipo = 'INV.EI')
SELECT @AlmacenOrigen = MIN(d.Almacen) FROM InvD d WHERE d.ID = @IDAplica AND d.Articulo = @Articulo AND ISNULL(d.SubCuenta, '') = ISNULL(@SubCuenta, '') AND d.Unidad = @MovUnidad AND Renglon = ISNULL(@AplicaRenglon,Renglon)
EXEC xpInvMatarAlmacenOrigen @Accion, @Modulo, @ID, @MovTipo, @IDAplica, @AplicaMovTipo, @Articulo, @SubCuenta, @MovUnidad, @AlmacenOrigen OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spInvInitRenglon @Empresa, 0, @CfgMultiUnidades, @CfgMultiUnidadesNivel, 0, 0, 0, 0, 0,
0, 1, @Accion, @Base, @Modulo, NULL, NULL, NULL, @Estatus, @EstatusNuevo, @MovTipo, 0, 0, @AfectarConsignacion, 0, @AlmacenTipo, @AlmacenDestinoTipo,
@Articulo, @MovUnidad, @ArtUnidad, @ArtTipo, @RenglonTipo,
@AplicaMovTipo, @CantidadOriginal, @CantidadInventario, @CantidadPendiente, @CantidadA, @DetalleTipo,
@Cantidad OUTPUT, @CantidadCalcularImporte OUTPUT, @CantidadReservada OUTPUT, @CantidadOrdenada OUTPUT, @EsEntrada OUTPUT, @EsSalida OUTPUT, @SubCuenta OUTPUT,
@AfectarPiezas OUTPUT, @AfectarCostos OUTPUT, @AfectarUnidades OUTPUT, @Factor,
@Ok OUTPUT, @OkRef OUTPUT
SELECT @Cantidad = @CantidadCalcularImporte
IF @@FETCH_STATUS <> -2 AND @Cantidad <> 0.0
BEGIN
IF @AplicaMovTipo NOT IN ('VTAS.C', 'VTAS.CS', 'VTAS.CO', 'VTAS.FR', 'COMS.C')
BEGIN
SELECT @Existe = 0
IF @SinAlmacen = 1
BEGIN
IF EXISTS(SELECT * FROM @AMatar WHERE ID = @IDAplica AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') AND ISNULL(Unidad, '') = ISNULL(@MovUnidad, '') AND ISNULL(ProdSerieLote, '') = ISNULL(@ProdSerieLote, '') AND ISNULL(Espacio, '') = ISNULL(@Espacio, '') AND ISNULL(Centro, '') = ISNULL(@Centro, '') AND ISNULL(CentroDestino, '') = ISNULL(@CentroDestino, '') AND ISNULL(Cliente, '') = ISNULL(@Cliente, '') AND ISNULL(AplicaRenglon,@Renglon) = @Renglon)
SELECT @Existe = 1
END ELSE
BEGIN
IF EXISTS(SELECT * FROM @AMatar WHERE ID = @IDAplica AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') AND ISNULL(Unidad, '') = ISNULL(@MovUnidad, '') AND ISNULL(ProdSerieLote, '') = ISNULL(@ProdSerieLote, '') AND ISNULL(Espacio, '') = ISNULL(@Espacio, '') AND ISNULL(Centro, '') = ISNULL(@Centro, '') AND ISNULL(CentroDestino, '') = ISNULL(@CentroDestino, '') AND ISNULL(Cliente, '') = ISNULL(@Cliente, '') AND Almacen = @AlmacenOrigen AND ISNULL(AplicaRenglon,@Renglon) = @Renglon)
SELECT @Existe = 1
END
IF @Existe = 1
BEGIN
IF @SinAlmacen = 1
UPDATE @AMatar SET Cantidad = Cantidad + @Cantidad WHERE ID = @IDAplica AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') AND ISNULL(Unidad, '') = ISNULL(@MovUnidad, '') AND ISNULL(ProdSerieLote, '') = ISNULL(@ProdSerieLote, '') AND ISNULL(Espacio, '') = ISNULL(@Espacio, '') AND ISNULL(Centro, '') = ISNULL(@Centro, '') AND ISNULL(CentroDestino, '') = ISNULL(@CentroDestino, '') AND ISNULL(Cliente, '') = ISNULL(@Cliente, '') AND ISNULL(AplicaRenglon,@Renglon) = @Renglon
ELSE
UPDATE @AMatar SET Cantidad = Cantidad + @Cantidad WHERE ID = @IDAplica AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') AND ISNULL(Unidad, '') = ISNULL(@MovUnidad, '') AND ISNULL(ProdSerieLote, '') = ISNULL(@ProdSerieLote, '') AND ISNULL(Espacio, '') = ISNULL(@Espacio, '') AND ISNULL(Centro, '') = ISNULL(@Centro, '') AND ISNULL(CentroDestino, '') = ISNULL(@CentroDestino, '') AND ISNULL(Cliente, '') = ISNULL(@Cliente, '') AND Almacen = @AlmacenOrigen AND ISNULL(AplicaRenglon,@Renglon) = @Renglon
END ELSE
BEGIN
INSERT @AMatar (ID, MovTipo, Almacen, Articulo, SubCuenta, Cantidad, Unidad, ProdSerieLote, Espacio, Centro, CentroDestino, Cliente, AplicaRenglon)
VALUES (@IDAplica, @AplicaMovTipo, @AlmacenOrigen, @Articulo, @SubCuenta, @Cantidad, @MovUnidad, @ProdSerieLote, @Espacio, @Centro, @CentroDestino, @Cliente, @AplicaRenglon)
IF @@ERROR <> 0 SELECT @Ok = 1
IF NOT EXISTS(SELECT * FROM @MatarIndice WHERE ID = @IDAplica)
BEGIN
INSERT @MatarIndice (ID,        Estatus,        Mov,        MovID,        MovTipo,        TipoCambio,        Almacen,        DescuentoGlobal,  SobrePrecio,  Importe)
VALUES (@IDAplica, @AplicaEstatus, @AplicaMov, @AplicaMovID, @AplicaMovTipo, @AplicaTipoCambio, @AlmacenOrigen, @DescuentoGlobal, @SobrePrecio, 0.0)
IF @@ERROR <> 0 SELECT @Ok = 1
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @IDAplica, @AplicaMov, @AplicaMovID, @Modulo, @ID, @Mov, @MovID, @Ok OUTPUT
END
END
END ELSE
IF @AplicaMovTipo = 'VTAS.CO'
BEGIN
SELECT @ContratoEstatusNuevo = CASE @Accion WHEN 'CANCELAR' THEN 'CONFIRMAR' ELSE 'VIGENTE' END
EXEC spValidarTareas @Empresa, @Modulo, IDAplica, @ContratoEstatusNuevo, @Ok OUTPUT, @OkRef OUTPUT
UPDATE Venta
SET ServicioContrato = Mov,
ServicioContratoID = MovID,
Estatus = @ContratoEstatusNuevo
WHERE ID = @IDAplica
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @IDAplica, @AplicaMov, @AplicaMovID, @Modulo, @ID, @Mov, @MovID, @Ok OUTPUT
IF @@ERROR <> 0 SELECT @Ok = 1
END
END
END
FETCH NEXT FROM crMatarMov INTO @IDAplica, @AplicaEstatus, @AplicaMov, @AplicaMovID, @AplicaTipoCambio, @AlmacenOrigen, @DescuentoGlobal, @SobrePrecio, @AplicaMovTipo, @CantidadOriginal, @MermaDesp, @CantidadInventario, @CantidadReservada, @CantidadOrdenada, @CantidadPendiente, @CantidadA, @ProdSerieLote, @ArticuloOriginal, @SubcuentaOriginal, @SustitutoArticulo, @SustitutoSubCuenta, @MovUnidad, @Factor, @ArtTipo, @ArtUnidad, @RenglonTipo, @DetalleTipo, @Espacio, @Centro, @CentroDestino, @Cliente, @AplicaRenglon
IF @@ERROR <> 0 SELECT @Ok = 1
END
CLOSE crMatarMov
DEALLOCATE crMatarMov
IF @Ok IS NOT NULL RETURN
IF @Modulo = 'VTAS'
DECLARE crMatarOrigen CURSOR
FOR SELECT i.ID, VentaD.Almacen, VentaD.Almacen, i.DescuentoGlobal, i.SobrePrecio, i.Mov, i.MovID, i.MovTipo, i.TipoCambio, Renglon, RenglonSub, VentaD.RenglonID, Articulo, NULLIF(RTRIM(Subcuenta), ''), ISNULL(Cantidad, 0.0) - ISNULL(CantidadCancelada, 0.0), ISNULL(CantidadReservada, 0.0), ISNULL(CantidadOrdenada, 0.0), ISNULL(CantidadPendiente, 0.0), NULLIF(RTRIM(Unidad), ''), Factor, Convert(char, NULL), ISNULL(Precio, 0.0), NULLIF(RTRIM(DescuentoTipo), ''), ISNULL(DescuentoLinea, 0.0), ISNULL(Impuesto1, 0.0), ISNULL(Impuesto2, 0.0), ISNULL(Impuesto3, 0.0), NULLIF(RTRIM(Espacio), ''), CONVERT(varchar, NULL), CONVERT(varchar, NULL), CONVERT(varchar, NULL), PrecioTipoCambio, ISNULL(Retencion1,0.0), ISNULL(Retencion2,0.0), ISNULL(Retencion3,0.0) 
FROM VentaD
JOIN @MatarIndice i ON i.ID = VentaD.ID
ORDER BY Articulo, SubCuenta DESC, CantidadReservada DESC
ELSE
IF @Modulo = 'COMS'
DECLARE crMatarOrigen CURSOR
FOR SELECT i.ID, CompraD.Almacen, CompraD.Almacen, i.DescuentoGlobal, i.SobrePrecio, i.Mov, i.MovID, i.MovTipo, i.TipoCambio, Renglon, RenglonSub, CompraD.RenglonID, Articulo, NULLIF(RTRIM(Subcuenta), ''), ISNULL(Cantidad, 0.0) - ISNULL(CantidadCancelada, 0.0), Cantidad, Cantidad, ISNULL(CantidadPendiente, 0.0), NULLIF(RTRIM(Unidad), ''), Factor, Convert(char, NULL), ISNULL(Costo, 0.0), NULLIF(RTRIM(DescuentoTipo), ''), ISNULL(DescuentoLinea, 0.0), ISNULL(Impuesto1, 0.0), ISNULL(Impuesto2, 0.0), ISNULL(Impuesto3, 0.0), CONVERT(varchar, NULL), CONVERT(varchar, NULL), CONVERT(varchar, NULL), NULLIF(RTRIM(Cliente), ''), CONVERT(float, NULL), ISNULL(Retencion1, 0.0), ISNULL(Retencion2, 0.0), ISNULL(Retencion3, 0.0)
FROM CompraD
JOIN @MatarIndice i ON i.ID = CompraD.ID
ORDER BY Articulo, SubCuenta DESC
ELSE
IF @Modulo = 'INV'
DECLARE crMatarOrigen CURSOR
FOR SELECT i.ID, InvD.Almacen, Inv.AlmacenDestino, i.DescuentoGlobal, i.SobrePrecio, i.Mov, i.MovID, i.MovTipo, i.TipoCambio, Renglon, RenglonSub, InvD.RenglonID, Articulo, NULLIF(RTRIM(Subcuenta), ''), ISNULL(Cantidad, 0.0) - ISNULL(CantidadCancelada, 0.0), ISNULL(CantidadReservada, 0.0), ISNULL(CantidadOrdenada, 0.0), ISNULL(CantidadPendiente, 0.0), NULLIF(RTRIM(Unidad), ''), Factor, NULLIF(RTRIM(ProdSerieLote), ''), Convert(money, NULL), Convert(char(1), NULL), Convert(money, NULL), Convert(float, NULL), Convert(float, NULL), Convert(money, NULL), CONVERT(varchar, NULL), CONVERT(varchar, NULL), CONVERT(varchar, NULL), CONVERT(varchar, NULL), CONVERT(float, NULL), CONVERT(float, NULL), CONVERT(float, NULL), CONVERT(float, NULL)
FROM InvD
JOIN Inv ON Inv.ID = InvD.ID
JOIN @MatarIndice i ON i.ID = InvD.ID
ORDER BY Articulo, SubCuenta DESC, CantidadReservada DESC
ELSE
IF @Modulo = 'PROD'
DECLARE crMatarOrigen CURSOR
FOR SELECT i.ID, ProdD.Almacen, ProdD.Almacen, i.DescuentoGlobal, i.SobrePrecio, i.Mov, i.MovID, i.MovTipo, i.TipoCambio, Renglon, RenglonSub, ProdD.RenglonID, Articulo, NULLIF(RTRIM(Subcuenta), ''), ISNULL(Cantidad, 0.0) - ISNULL(CantidadCancelada, 0.0), ISNULL(CantidadReservada, 0.0), ISNULL(CantidadOrdenada, 0.0), ISNULL(CantidadPendiente, 0.0), NULLIF(RTRIM(Unidad), ''), Factor, NULLIF(RTRIM(ProdSerieLote), ''), Convert(money, NULL), Convert(char(1), NULL), Convert(money, NULL), Convert(float, NULL), Convert(float, NULL), Convert(money, NULL), CONVERT(varchar, NULL), NULLIF(RTRIM(Centro), ''), NULLIF(RTRIM(CentroDestino), ''), CONVERT(varchar, NULL), CONVERT(float, NULL), CONVERT(float, NULL), CONVERT(float, NULL), CONVERT(float, NULL)
FROM ProdD
JOIN @MatarIndice i ON i.ID = ProdD.ID
ORDER BY Articulo, SubCuenta DESC, CantidadReservada DESC
SELECT @UltID = NULL
OPEN crMatarOrigen
FETCH NEXT FROM crMatarOrigen INTO @IDAplica, @AlmacenOrigen, @AlmacenBackOrders, @DescuentoGlobal, @SobrePrecio, @AplicaMov, @AplicaMovID, @AplicaMovTipo, @AplicaTipoCambio, @Renglon, @RenglonSub, @RenglonID, @Articulo, @SubCuenta, @CantidadOriginal, @CantidadReservada, @CantidadOrdenada, @CantidadPendiente, @MovUnidad, @Factor, @ProdSerieLote, @Precio, @DescuentoTipo, @DescuentoLinea, @Impuesto1, @Impuesto2, @Impuesto3, @Espacio, @Centro, @CentroDestino, @Cliente, @PrecioTipoCambio, @Retencion1, @Retencion2, @Retencion3
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Modulo = 'COMS' SELECT @CantidadReservada = 0.0, @CantidadOrdenada = 0.0
SELECT @Requiere = NULL, @ReservadoObtenido = 0.0, @PendienteObtenido = 0.0, @ArtMoneda = NULL
SELECT @ArtMoneda = MonedaCosto, @ArtTipo = UPPER(Tipo) FROM Art WHERE Articulo = @Articulo
IF @SinAlmacen = 1
SELECT @Cantidad = ISNULL(Cantidad, 0.0), @Requiere = ISNULL(Cantidad, 0.0), @Llave = Llave
FROM @AMatar
WHERE ID = @IDAplica AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') AND ISNULL(Unidad, '') = ISNULL(@MovUnidad, '') AND ISNULL(ProdSerieLote, '') = ISNULL(@ProdSerieLote, '') AND ISNULL(Espacio, '') = ISNULL(@Espacio, '') AND ISNULL(Centro, '') = ISNULL(@Centro, '') AND ISNULL(CentroDestino, '') = ISNULL(@CentroDestino, '') AND ISNULL(Cliente, '') = ISNULL(@Cliente, '') AND ISNULL(AplicaRenglon,@Renglon) = @Renglon
ELSE
SELECT @Cantidad = ISNULL(Cantidad, 0.0), @Requiere = ISNULL(Cantidad, 0.0), @Llave = Llave
FROM @AMatar
WHERE ID = @IDAplica AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') AND ISNULL(Unidad, '') = ISNULL(@MovUnidad, '') AND ISNULL(ProdSerieLote, '') = ISNULL(@ProdSerieLote, '') AND ISNULL(Espacio, '') = ISNULL(@Espacio, '') AND ISNULL(Centro, '') = ISNULL(@Centro, '') AND ISNULL(CentroDestino, '') = ISNULL(@CentroDestino, '') AND ISNULL(Cliente, '') = ISNULL(@Cliente, '') AND Almacen = @AlmacenOrigen AND ISNULL(AplicaRenglon,@Renglon) = @Renglon
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Requiere = 0.0 AND @SubCuenta IS NULL
BEGIN
IF @SinAlmacen = 1
SELECT @Requiere = SUM(ISNULL(Cantidad, 0.0)), @Llave = MIN(Llave)
FROM @AMatar
WHERE ID = @IDAplica AND Articulo = @Articulo AND ISNULL(Unidad, '') = ISNULL(@MovUnidad, '') AND ISNULL(ProdSerieLote, '') = ISNULL(@ProdSerieLote, '') AND ISNULL(Espacio, '') = ISNULL(@Espacio, '') AND ISNULL(Centro, '') = ISNULL(@Centro, '') AND ISNULL(CentroDestino, '') = ISNULL(@CentroDestino, '') AND ISNULL(Cliente, '') = ISNULL(@Cliente, '') AND ISNULL(AplicaRenglon,@Renglon) = @Renglon
ELSE
SELECT @Requiere = SUM(ISNULL(Cantidad, 0.0)), @Llave = MIN(Llave)
FROM @AMatar
WHERE ID = @IDAplica AND Articulo = @Articulo AND ISNULL(Unidad, '') = ISNULL(@MovUnidad, '') AND ISNULL(ProdSerieLote, '') = ISNULL(@ProdSerieLote, '') AND ISNULL(Espacio, '') = ISNULL(@Espacio, '') AND ISNULL(Centro, '') = ISNULL(@Centro, '') AND ISNULL(CentroDestino, '') = ISNULL(@CentroDestino, '') AND ISNULL(Cliente, '') = ISNULL(@Cliente, '') AND Almacen = @AlmacenOrigen  AND ISNULL(AplicaRenglon,@Renglon) = @Renglon
IF @@ERROR <> 0 SELECT @Ok = 1
END
IF @Requiere IS NOT NULL
BEGIN
IF @Modulo IN ('VTAS', 'INV', 'PROD') AND @Cancelar = 0 AND @ArtTipo NOT IN ('JUEGO', 'SERVICIO') AND @AlmacenOrigen IS NOT NULL
BEGIN
IF @Requiere < @CantidadReservada SELECT @ReservadoObtenido = @Requiere ELSE SELECT @ReservadoObtenido = @CantidadReservada
SELECT @Requiere = @Requiere - @ReservadoObtenido
IF @ReservadoObtenido > 0.0  
BEGIN
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @SucursalAlmacenOrigen = Sucursal FROM Alm WHERE Almacen = @AlmacenOrigen
EXEC spSaldo @SucursalAlmacenOrigen, @Accion, @Empresa, @Usuario, 'RESV', @ArtMoneda, NULL, @Articulo, @SubCuenta, @AlmacenOrigen, NULL,
@Modulo, @IDAplica, @AplicaMov, @AplicaMovID, 0, NULL, @ReservadoObtenido, @Factor,
@FechaAfectacion, @Ejercicio, @Periodo, @Mov, @MovID, 0, 0, 0,
@Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID
END
END
IF @MovTipo='VTAS.VP' AND @Accion <> 'CANCELAR'
BEGIN
SELECT @Requiere=@ReservadoObtenido+@PendienteObtenido
SELECT @ReservadoObtenido = 0, @PendienteObtenido = 0
END
IF @Requiere > 0.0
BEGIN
IF @Cancelar = 1
BEGIN
IF @Requiere <= @CantidadOriginal-@CantidadPendiente-@CantidadReservada-@CantidadOrdenada
SELECT @PendienteObtenido = @Requiere
ELSE
SELECT @PendienteObtenido = @CantidadOriginal-@CantidadPendiente-@CantidadReservada-@CantidadOrdenada
END ELSE
BEGIN
IF @Requiere <= @CantidadPendiente
SELECT @PendienteObtenido = @Requiere
ELSE
SELECT @PendienteObtenido = @CantidadPendiente
END
SELECT @Requiere = @Requiere - @PendienteObtenido
END
SELECT @Obtenido = @ReservadoObtenido + @PendienteObtenido
IF @Obtenido <> 0.0
BEGIN
IF @AplicaMovTipo = 'COMS.CC' AND @MovTipo IN ('COMS.F', 'COMS.FL', 'COMS.EG', 'COMS.EI') AND @SinAlmacen = 0
BEGIN
SELECT @EsCargo = @Cancelar
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @SucursalAlmacenOrigen = Sucursal FROM Alm WHERE Almacen = @AlmacenOrigen
EXEC spSaldo @SucursalAlmacenOrigen, @Accion, @Empresa, @Usuario, 'CSG', @ArtMoneda, NULL, @Articulo, @SubCuenta, @AlmacenOrigen, NULL,
@Modulo, @IDAplica, @AplicaMov, @AplicaMovID, @EsCargo, NULL, @Obtenido, @Factor,
@FechaAfectacion, @Ejercicio, @Periodo, @Mov, @MovID, 0, 0, 0,
@Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID
END
IF @AplicaMovTipo IN ('COMS.O', 'COMS.OP', 'COMS.OG', 'COMS.OD', 'COMS.OI', 'PROD.O', 'INV.OT', 'INV.TI') AND @CfgBackOrders = 1 AND @MovTipo NOT IN ('PROD.CO', 'COMS.CP', 'COMS.O')
BEGIN
SELECT @DestinoTipo = NULL, @Destino = NULL, @DestinoID = NULL, @Cliente = NULL/*, @AplicaAplica = NULL, @AplicaAplicaID = NULL*/
IF @Modulo = 'COMS' SELECT @Cliente = NULLIF(RTRIM(Cliente), ''), @DestinoTipo = DestinoTipo, @Destino = NULLIF(RTRIM(Destino), ''), @DestinoID = DestinoID FROM CompraD WHERE ID = @IDAplica AND Renglon = @Renglon AND RenglonSub = @RenglonSub ELSE
IF @Modulo = 'INV'  SELECT @Cliente = NULLIF(RTRIM(Cliente), ''), @DestinoTipo = DestinoTipo, @Destino = NULLIF(RTRIM(Destino), ''), @DestinoID = DestinoID FROM InvD    WHERE ID = @IDAplica AND Renglon = @Renglon AND RenglonSub = @RenglonSub ELSE
IF @Modulo = 'PROD' SELECT @Cliente = NULLIF(RTRIM(Cliente), ''), @DestinoTipo = DestinoTipo, @Destino = NULLIF(RTRIM(Destino), ''), @DestinoID = DestinoID FROM ProdD   WHERE ID = @IDAplica AND Renglon = @Renglon AND RenglonSub = @RenglonSub
/*            IF @AplicaAplica IS NOT NULL AND @AplicaAplicaID IS NOT NULL
EXEC spInvBackOrderAplica @Accion, @Empresa, @Usuario, @Modulo, @AplicaAplica, @AplicaAplicaID, @Articulo, @SubCuenta, @MovUnidad, @Obtenido, @ArtMoneda,
@AlmacenBackOrders, @FechaAfectacion, @FechaRegistro, @Ejercicio, @Periodo,
@Ok OUTPUT, @OkRef OUTPUT
ELSE*/
IF @Destino IS NOT NULL AND @DestinoID IS NOT NULL AND @DestinoTipo IN (SELECT Modulo FROM Modulo) AND @Cancelar = 0
EXEC spInvBackOrder @Sucursal, @Accion, @Estatus, 1, @Empresa, @Usuario, @Modulo, @ID, @Mov, @MovID,
@DestinoTipo, @Destino, @DestinoID, @Articulo, @SubCuenta, @MovUnidad, @Obtenido, @Factor, @ArtMoneda,
@AlmacenBackOrders, @FechaAfectacion, @FechaRegistro, @Ejercicio, @Periodo,
@Ok OUTPUT, @OkRef OUTPUT, @MovTipo = @MovTipo
END
EXEC spCalculaImporte @Accion, @Modulo, @CfgImpInc, @MovTipo, @EsEntrada, @Obtenido, @Precio, @DescuentoTipo, @DescuentoLinea, @DescuentoGlobal, @SobrePrecio, @Impuesto1, @Impuesto2, @Impuesto3, @Impuesto5,
@Importe OUTPUT, @ImporteNeto OUTPUT, @DescuentoLineaImporte OUTPUT, @DescuentoGlobalImporte OUTPUT, @SobrePrecioImporte OUTPUT,
@Impuestos OUTPUT, @ImpuestosNetos OUTPUT, @Impuesto1Neto OUTPUT, @Impuesto2Neto OUTPUT, @Impuesto3Neto OUTPUT, @Impuesto5Neto OUTPUT,
@Articulo = @Articulo, @CfgPrecioMoneda = @CfgPrecioMoneda, @MovTipoCambio = @AplicaTipoCambio, @PrecioTipoCambio = @PrecioTipoCambio,
@Retencion1 = @Retencion1, @Retencion2 = @Retencion2, @Retencion3 = @Retencion3, @ID = @ID
SELECT @ImporteMatar = @ImporteNeto + @ImpuestosNetos
UPDATE @MatarIndice SET Importe = Importe + @ImporteMatar WHERE ID = @IDAplica
IF @@ERROR <> 0 SELECT @Ok = 1
END
UPDATE @AMatar
SET Cantidad = Cantidad - @Obtenido
WHERE Llave = @Llave
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Cancelar = 1
SELECT @ReservadoObtenido = -@ReservadoObtenido, @PendienteObtenido = -@PendienteObtenido
INSERT @MatarDetalle (ID,         Renglon,  RenglonSub, Reservado,          Pendiente,          MovTipo,        Articulo,  SubCuenta,  Almacen,        Factor)
VALUES (@IDAplica, @Renglon, @RenglonSub, @ReservadoObtenido, @PendienteObtenido, @AplicaMovTipo, @Articulo, @SubCuenta, @AlmacenOrigen, @Factor)
IF @@ERROR <> 0 SELECT @Ok = 1
END
END
FETCH NEXT FROM crMatarOrigen INTO @IDAplica, @AlmacenOrigen, @AlmacenBackOrders, @DescuentoGlobal, @SobrePrecio, @AplicaMov, @AplicaMovID, @AplicaMovTipo, @AplicaTipoCambio, @Renglon, @RenglonSub, @RenglonID, @Articulo, @SubCuenta, @CantidadOriginal, @CantidadReservada, @CantidadOrdenada, @CantidadPendiente, @MovUnidad, @Factor, @ProdSerieLote, @Precio, @DescuentoTipo, @DescuentoLinea, @Impuesto1, @Impuesto2, @Impuesto3, @Espacio, @Centro, @CentroDestino, @Cliente, @PrecioTipoCambio, @Retencion1, @Retencion2, @Retencion3
IF @@ERROR <> 0 SELECT @Ok = 1
END
CLOSE crMatarOrigen
DEALLOCATE crMatarOrigen
IF @Ok IS NOT NULL RETURN
DECLARE crMatar CURSOR
FOR SELECT ID, Renglon, RenglonSub, Reservado, Pendiente, MovTipo, Articulo, SubCuenta, Almacen, Factor
FROM @MatarDetalle
OPEN crMatar
FETCH NEXT FROM crMatar INTO @IDAplica, @Renglon, @RenglonSub, @ReservadoObtenido, @PendienteObtenido, @AplicaMovTipo, @Articulo, @SubCuenta, @AlmacenOrigen, @Factor
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Modulo = 'COMS'
BEGIN
UPDATE CompraD
SET @NuevoPendiente = CantidadPendiente = NULLIF(ISNULL(CantidadPendiente, 0.0) - @PendienteObtenido, 0.0)
WHERE ID = @IDAplica AND Renglon = @Renglon AND RenglonSub = @RenglonSub
IF @NuevoPendiente IS NOT NULL AND ROUND(@NuevoPendiente, @Redondeo) = 0 UPDATE CompraD SET CantidadPendiente = NULL WHERE ID = @IDAplica AND Renglon = @Renglon AND RenglonSub = @RenglonSub
END ELSE
IF @Modulo = 'VTAS'
BEGIN
UPDATE VentaD
SET CantidadReservada = NULLIF(ISNULL(CantidadReservada, 0.0) - @ReservadoObtenido, 0.0),
@NuevoPendiente = CantidadPendiente = NULLIF(ISNULL(CantidadPendiente, 0.0) - @PendienteObtenido, 0.0)
WHERE ID = @IDAplica AND Renglon = @Renglon AND RenglonSub = @RenglonSub
IF @NuevoPendiente IS NOT NULL AND ROUND(@NuevoPendiente, @Redondeo) = 0 UPDATE VentaD SET CantidadPendiente = NULL WHERE ID = @IDAplica AND Renglon = @Renglon AND RenglonSub = @RenglonSub
END ELSE
IF @Modulo = 'INV'
BEGIN
UPDATE InvD
SET CantidadReservada = NULLIF(ISNULL(CantidadReservada, 0.0) - @ReservadoObtenido, 0.0),
@NuevoPendiente = CantidadPendiente = NULLIF(ISNULL(CantidadPendiente, 0.0) - @PendienteObtenido, 0.0)
WHERE ID = @IDAplica AND Renglon = @Renglon AND RenglonSub = @RenglonSub
IF @NuevoPendiente IS NOT NULL AND ROUND(@NuevoPendiente, @Redondeo) = 0 UPDATE InvD SET CantidadPendiente = NULL WHERE ID = @IDAplica AND Renglon = @Renglon AND RenglonSub = @RenglonSub
END ELSE
IF @Modulo = 'PROD'
BEGIN
UPDATE ProdD
SET CantidadReservada = NULLIF(ISNULL(CantidadReservada, 0.0) - @ReservadoObtenido, 0.0),
@NuevoPendiente = CantidadPendiente = NULLIF(ISNULL(CantidadPendiente, 0.0) - @PendienteObtenido, 0.0)
WHERE ID = @IDAplica AND Renglon = @Renglon AND RenglonSub = @RenglonSub
IF @NuevoPendiente IS NOT NULL AND ROUND(@NuevoPendiente, @Redondeo) = 0 UPDATE ProdD SET CantidadPendiente = NULL WHERE ID = @IDAplica AND Renglon = @Renglon AND RenglonSub = @RenglonSub
END
SELECT @PendienteDif = -@PendienteObtenido
EXEC spArtR @Empresa, @Modulo, @Articulo, @SubCuenta, @AlmacenOrigen, @AplicaMovTipo, @Factor, @PendienteDif, NULL, NULL, NULL, NULL, NULL
END
FETCH NEXT FROM crMatar INTO @IDAplica, @Renglon, @RenglonSub, @ReservadoObtenido, @PendienteObtenido, @AplicaMovTipo, @Articulo, @SubCuenta, @AlmacenOrigen, @Factor
IF @@ERROR <> 0 SELECT @Ok = 1
END
CLOSE crMatar
DEALLOCATE crMatar
IF @Ok IS NOT NULL RETURN
IF @Modulo IN ('VTAS', 'COMS')
BEGIN
DECLARE crMatarSaldos CURSOR
FOR SELECT ID, Mov, MovID, MovTipo, Importe
FROM @MatarIndice
WHERE Importe <> 0.0
OPEN crMatarSaldos
FETCH NEXT FROM crMatarSaldos INTO @IDAplica,  @AplicaMov, @AplicaMovID, @AplicaMovTipo, @ImporteMatar
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Modulo = 'VTAS' UPDATE Venta  SET Saldo = CASE @Cancelar WHEN 1 THEN NULLIF(ISNULL(Saldo, 0.0) + @ImporteMatar, 0.0) ELSE NULLIF(ISNULL(Saldo, 0.0) - @ImporteMatar, 0.0) END WHERE ID = @IDAplica ELSE
IF @Modulo = 'COMS' UPDATE Compra SET Saldo = CASE @Cancelar WHEN 1 THEN NULLIF(ISNULL(Saldo, 0.0) + @ImporteMatar, 0.0) ELSE NULLIF(ISNULL(Saldo, 0.0) - @ImporteMatar, 0.0) END WHERE ID = @IDAplica
IF @@ERROR <> 0 SELECT @Ok = 1
END
FETCH NEXT FROM crMatarSaldos INTO @IDAplica,  @AplicaMov, @AplicaMovID, @AplicaMovTipo, @ImporteMatar
IF @@ERROR <> 0 SELECT @Ok = 1
END
CLOSE crMatarSaldos
DEALLOCATE crMatarSaldos
IF @Ok IS NOT NULL RETURN
END
IF @Modulo = 'VTAS'
DECLARE crMatarPendiente CURSOR
FOR SELECT m.ID, m.Mov, m.MovID, m.MovTipo, m.Estatus, Sum(ISNULL(d.CantidadOrdenada, 0.0)) + Sum(ISNULL(d.CantidadReservada, 0.0)) + Sum(ISNULL(d.CantidadPendiente, 0.0))
FROM VentaD d, @MatarIndice m
WHERE d.ID = m.ID
GROUP BY m.ID, m.Mov, m.MovID, m.MovTipo, m.Estatus
ORDER BY m.ID, m.Mov, m.MovID, m.MovTipo, m.Estatus
ELSE
IF @Modulo = 'COMS'
DECLARE crMatarPendiente CURSOR
FOR SELECT m.ID, m.Mov, m.MovID, m.MovTipo, m.Estatus, Sum(ISNULL(d.CantidadPendiente, 0.0))
FROM CompraD d, @MatarIndice m
WHERE d.ID = m.ID
GROUP BY m.ID, m.Mov, m.MovID, m.MovTipo, m.Estatus
ORDER BY m.ID, m.Mov, m.MovID, m.MovTipo, m.Estatus
ELSE
IF @Modulo = 'INV'
DECLARE crMatarPendiente CURSOR
FOR SELECT m.ID, m.Mov, m.MovID, m.MovTipo, m.Estatus, Sum(ISNULL(d.CantidadOrdenada, 0.0)) + Sum(ISNULL(d.CantidadReservada, 0.0)) + Sum(ISNULL(d.CantidadPendiente, 0.0))
FROM InvD d, @MatarIndice m
WHERE d.ID = m.ID
GROUP BY m.ID, m.Mov, m.MovID, m.MovTipo, m.Estatus
ORDER BY m.ID, m.Mov, m.MovID, m.MovTipo, m.Estatus
ELSE
IF @Modulo = 'PROD'
DECLARE crMatarPendiente CURSOR
FOR SELECT m.ID, m.Mov, m.MovID, m.MovTipo, m.Estatus, Sum(ISNULL(d.CantidadOrdenada, 0.0)) + Sum(ISNULL(d.CantidadReservada, 0.0)) + Sum(ISNULL(d.CantidadPendiente, 0.0))
FROM ProdD d, @MatarIndice m
WHERE d.ID = m.ID
GROUP BY m.ID, m.Mov, m.MovID, m.MovTipo, m.Estatus
ORDER BY m.ID, m.Mov, m.MovID, m.MovTipo, m.Estatus
OPEN crMatarPendiente
FETCH NEXT FROM crMatarPendiente INTO @IDAplica, @AplicaMov, @AplicaMovID, @AplicaMovTipo, @AplicaEstatus, @CantidadPendiente
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF (@Accion = 'CANCELAR' AND ROUND(@CantidadPendiente, 4) > 0) OR (@Accion <> 'CANCELAR' AND ROUND(@CantidadPendiente, 4) = 0)
BEGIN
IF ROUND(@CantidadPendiente, 4) = 0
BEGIN
SELECT @AplicaEstatusNuevo = 'CONCLUIDO', @AplicaFechaConclusion = @FechaEmision
IF @AplicaMovTipo = 'PROD.O'
BEGIN
IF EXISTS(SELECT * FROM Inv WHERE Empresa = @Empresa AND Estatus = 'CONFIRMAR' AND OrigenTipo = 'PROD' AND Origen = @AplicaMov AND OrigenID = @AplicaMovID)
SELECT @Ok = 25400
IF @MovTipo = 'PROD.E'
IF EXISTS(SELECT * FROM Inv WHERE Empresa = @Empresa AND Estatus = 'PENDIENTE' AND OrigenTipo = 'PROD' AND Origen = @AplicaMov AND OrigenID = @AplicaMovID)
SELECT @Ok = 25400
END
END ELSE
SELECT @AplicaEstatusNuevo = 'PENDIENTE', @AplicaFechaConclusion = NULL
EXEC spValidarTareas @Empresa, @Modulo, @IDAplica, @AplicaEstatusNuevo, @Ok OUTPUT, @OkRef OUTPUT
IF @Modulo = 'VTAS' UPDATE Venta  SET Estatus = @AplicaEstatusNuevo, FechaConclusion = @AplicaFechaConclusion WHERE ID = @IDAplica ELSE
IF @Modulo = 'COMS' UPDATE Compra SET Estatus = @AplicaEstatusNuevo, FechaConclusion = @AplicaFechaConclusion WHERE ID = @IDAplica ELSE
IF @Modulo = 'INV'  UPDATE Inv    SET Estatus = @AplicaEstatusNuevo, FechaConclusion = @AplicaFechaConclusion WHERE ID = @IDAplica ELSE
IF @Modulo = 'PROD' UPDATE Prod   SET Estatus = @AplicaEstatusNuevo, FechaConclusion = @AplicaFechaConclusion WHERE ID = @IDAplica
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spMovFinal @Empresa, @Sucursal, @Modulo, @IDAplica, @AplicaEstatus, @AplicaEstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @AplicaMov, @AplicaMovID, @AplicaMovTipo, NULL, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000 
EXEC spMAFConcluirServicioMAF @Modulo, @AplicaEstatusNuevo, @Accion, @Empresa, @Sucursal, @Usuario, @AplicaFechaConclusion, @IDAplica, @ID, @EstatusNuevo, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Accion <> 'CANCELAR' AND ROUND(@CantidadPendiente, 4) > 0
BEGIN
IF @MovTipo = 'PROD.E'
IF EXISTS (SELECT e.ID FROM Inv e JOIN InvD d ON e.ID = d.ID WHERE e.Empresa = @Empresa AND e.Estatus = 'PENDIENTE' AND e.OrigenTipo = 'PROD' AND e.Origen = @AplicaMov AND e.OrigenID = @AplicaMovID
AND CantidadPendiente > 0 AND d.Producto IN (SELECT Articulo FROM ProdD WHERE ID = @ID)
AND CantidadPendiente > @CantidadPendiente*(SELECT ISNULL(m.Cantidad/m.CantidadP,1) FROM ProdProgramaMaterial m WHERE m.ID = @IDAplica AND m.Producto = d.Producto AND m.Lote = d.ProdSerieLote AND m.Articulo = d.Articulo  AND ISNULL(m.Subcuenta,'') = ISNULL(d.subcuenta,'')))
SELECT @Ok = 25400
IF @AplicaMovTipo = 'PROD.O'
IF EXISTS (SELECT e.ID FROM Inv e JOIN InvD d ON e.ID = d.ID WHERE e.Empresa = @Empresa AND e.Estatus = 'CONFIRMAR' AND e.OrigenTipo = 'PROD' AND e.Origen = @AplicaMov AND e.OrigenID = @AplicaMovID
AND CantidadPendiente > 0 AND d.Producto IN (SELECT Articulo FROM ProdD WHERE ID = @ID)
AND CantidadPendiente > @CantidadPendiente*(SELECT ISNULL(m.Cantidad/m.CantidadP,1) FROM ProdProgramaMaterial m WHERE m.ID = @IDAplica AND m.Producto = d.Producto AND m.Lote = d.ProdSerieLote AND m.Articulo = d.Articulo AND ISNULL(m.Subcuenta,'') = ISNULL(d.subcuenta,'')))
SELECT @Ok = 25400
END
END
FETCH NEXT FROM crMatarPendiente INTO @IDAplica, @AplicaMov, @AplicaMovID, @AplicaMovTipo, @AplicaEstatus, @CantidadPendiente
IF @@ERROR <> 0 SELECT @Ok = 1
END
CLOSE crMatarPendiente
DEALLOCATE crMatarPendiente
IF @MovTipo = 'INV.CM'
SELECT @Cantidad = Sum(ISNULL(Cantidad, 0.0)) FROM @AMatar WHERE MovTipo NOT IN ('INV.SM')
ELSE
IF @Modulo = 'VTAS' AND (@CfgVentaSurtirDemas = 1 OR @Accion = 'RESERVARPARCIAL')
SELECT @Cantidad = Sum(ISNULL(Cantidad, 0.0)) FROM @AMatar WHERE MovTipo NOT IN ('VTAS.P', 'VTAS.S')
ELSE
IF @Modulo = 'COMS' AND (@CfgCompraRecibirDemas = 1 OR @Accion = 'RESERVARPARCIAL')
SELECT @Cantidad = Sum(ISNULL(Cantidad, 0.0)) FROM @AMatar WHERE MovTipo NOT IN ('COMS.R','COMS.O', 'COMS.OP', 'COMS.OG', 'COMS.OI')
ELSE
IF @Modulo = 'INV' AND (@CfgTransferirDemas = 1 OR @Accion = 'RESERVARPARCIAL')
SELECT @Cantidad = Sum(ISNULL(Cantidad, 0.0)) FROM @AMatar WHERE MovTipo NOT IN ('INV.OI', 'INV.OT')
ELSE
SELECT @Cantidad = Sum(ISNULL(Cantidad, 0.0)) FROM @AMatar
EXEC xpInvMatar @Accion, @ID, @MovTipo, @Cantidad OUTPUT
/*
IF ROUND(@Cantidad, 4) > 0
BEGIN
SELECT @Ok = 20290, @OkRef = 'Articulo: '+ (SELECT MIN(Articulo) FROM @AMatar WHERE Cantidad > 0 )
EXEC xpOk_20290 @Empresa, @Usuario, @Accion, @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
END
*/
/* Se Comenta la validación anterior ya que cualquier catidada que se encuentre es mayor a cero ya que no permite negativos ni cero,
asi mismo se valida que la cantidad para realizar el recibo de transito sea menos a la del inventario si no marca error de exede cantidad */
IF ROUND(@Cantidad, 4) > ROUND((SELECT Convert(float, Disponible) FROM ArtDisponible  WHERE Empresa = @Empresa AND Articulo = @Articulo AND Almacen = @AlmacenOrigen), 4) 
BEGIN
SELECT @Ok = 20290, @OkRef = 'Articulo: '+ (SELECT MIN(Articulo) FROM @AMatar WHERE Cantidad > 0 )
EXEC xpOk_20290 @Empresa, @Usuario, @Accion, @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
END
RETURN
END

