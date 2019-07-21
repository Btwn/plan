SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spLotesFijos
@Empresa		char(5),
@Sucursal		int,
@FechaEmision		datetime,
@Contacto		varchar(10),
@EnviarA		int,
@Modulo 		char(5),
@ID 			int,
@Mov			char(20),
@MovID			varchar(20),
@MovTipo		char(20),
@Renglon		float,
@RenglonSub		int,
@RenglonID 		int,
@ArtTipo		char(20),
@Articulo		char(20),
@SubCuenta		varchar(50),
@Almacen		char(10),
@ZonaImpuesto		varchar(50),
@Cantidad		float,
@Factor			float,
@CfgImpInc		bit,
@EsEntrada		bit,
@Precio			float,
@DescuentoTipo		char(1),
@DescuentoLinea		float,
@DescuentoGlobal	float,
@SobrePrecio		float,
@TipoImpuesto1		varchar(10),
@TipoImpuesto2		varchar(10),
@TipoImpuesto3		varchar(10),
@TipoImpuesto5		varchar(10),
@Impuesto1		float 		OUTPUT,
@Impuesto2		float 		OUTPUT,
@Impuesto3		float 		OUTPUT,
@Impuesto5		float 		OUTPUT,
@Ok			int		OUTPUT,
@OkRef			varchar(255)	OUTPUT,
@CfgPrecioMoneda	bit = 0,
@MovTipoCambio		float = NULL,
@PrecioTipoCambio	float = NULL,
@ContUso		varchar(20),
@ContUso2		varchar(20),
@ContUso3		varchar(20),
@ClavePresupuestal	    varchar(50),
@ClavePresupuestalImpuesto1 varchar(50),
@Retencion1		float,
@Retencion2		float,
@Retencion3		float

AS BEGIN
DECLARE
@LoteFijo			varchar(50),
@LoteCantidad		float,
@SumaCantidad		float,
@LoteImpuesto1		float,
@LoteImpuesto2		float,
@LoteImpuesto3		float,
@LoteImpuesto5		float,
@TotalImpuesto1		float,
@TotalImpuesto2		float,
@TotalImpuesto3		float,
@TotalImpuesto5		float,
@SubTotal			money,
@Importe 			money,
@ImporteNeto 		money,
@DescuentoLineaImporte	money,
@DescuentoGlobalImporte	money,
@SobrePrecioImporte		money,
@Impuestos 			money,
@ImpuestosNetos 		money,
@Impuesto1Neto 		money,
@Impuesto2Neto 		money,
@Impuesto3Neto 		money,
@Impuesto5Neto 		money,
@ArtExcento1		bit,
@ArtExcento2		bit,
@ArtExcento3		bit,
@AplicaMov							varchar(20),	
@AplicaMovID						int,			
@VentaMovImpuestoDesdeRemision		bit,			
@ArrastrarMovImpuestoRemision		bit,			
@AplicaConcepto						varchar(50),	
@AplicaFechaEmision					datetime,		
@MovImpuestoAplicaID				int				
SELECT @VentaMovImpuestoDesdeRemision = VentaMovImpuestoDesdeRemision FROM EmpresaCfg WITH(NOLOCK) WHERE Empresa = @Empresa 
SELECT @SubCuenta = ISNULL(RTRIM(@SubCuenta), ''), @Cantidad = NULLIF(@Cantidad, 0)
DELETE SerieLoteMov FROM SerieLoteMov WITH(NOLOCK) WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID AND RenglonID = @RenglonID AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = @SubCuenta AND NULLIF(Cantidad, 0) IS NULL
SELECT @ArtExcento1 = ISNULL(Impuesto1Excento, 0), @ArtExcento2 = ISNULL(Excento2, 0), @ArtExcento3 = ISNULL(Excento3, 0)
FROM Art WITH(NOLOCK)
WHERE Articulo = @Articulo
SELECT @TotalImpuesto1 = 0.0, @TotalImpuesto2 = 0.0, @TotalImpuesto3 = 0.0, @TotalImpuesto5 = 0.0, @SubTotal = 0.0, @SumaCantidad = 0.0
DECLARE crLote CURSOR FOR
SELECT f.Lote, s.Cantidad/@Factor, ISNULL(f.Impuesto1, 0), ISNULL(f.Impuesto2, 0), ISNULL(f.Impuesto3, 0), ISNULL(f.Impuesto5, 0)
FROM SerieLoteMov s WITH(NOLOCK), LoteFijo f WITH(NOLOCK)
WHERE s.Empresa = @Empresa AND s.Modulo = @Modulo AND s.ID = @ID AND s.RenglonID = @RenglonID AND s.Articulo = @Articulo AND ISNULL(s.SubCuenta, '') = @SubCuenta AND s.SerieLote = f.Lote
OPEN crLote
FETCH NEXT FROM crLote INTO @LoteFijo, @LoteCantidad, @LoteImpuesto1, @LoteImpuesto2, @LoteImpuesto3, @LoteImpuesto5
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spZonaImp @ZonaImpuesto, @LoteImpuesto1 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @LoteImpuesto2 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @LoteImpuesto3 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @LoteImpuesto5 OUTPUT
IF @Cantidad<0.0 SELECT @LoteCantidad = -@LoteCantidad
EXEC spCalculaImporte 'AFECTAR', @Modulo, @CfgImpInc, @MovTipo, @EsEntrada, @LoteCantidad, @Precio, @DescuentoTipo, @DescuentoLinea, @DescuentoGlobal, @SobrePrecio, @LoteImpuesto1, @LoteImpuesto2, @LoteImpuesto3, @LoteImpuesto5,
@Importe OUTPUT, @ImporteNeto OUTPUT, @DescuentoLineaImporte OUTPUT, @DescuentoGlobalImporte OUTPUT, @SobrePrecioImporte OUTPUT,
@Impuestos OUTPUT, @ImpuestosNetos OUTPUT, @Impuesto1Neto OUTPUT, @Impuesto2Neto OUTPUT, @Impuesto3Neto OUTPUT, @Impuesto5Neto OUTPUT,
@Articulo = @Articulo, @CfgPrecioMoneda = @CfgPrecioMoneda, @MovTipoCambio = @MovTipoCambio, @PrecioTipoCambio = @PrecioTipoCambio,
@Retencion1 = @Retencion1, @Retencion2 = @Retencion2, @Retencion3 = @Retencion3, @ID = @ID
IF @Modulo = 'VTAS' AND @VentaMovImpuestoDesdeRemision = 1 
BEGIN
SELECT @AplicaMov = Aplica, @AplicaMovID = AplicaID FROM VentaD WITH(NOLOCK) WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
IF EXISTS(SELECT * FROM Venta v WITH(NOLOCK) JOIN MovTipo mt WITH(NOLOCK) ON v.Mov = mt.Mov AND mt.Modulo = @Modulo WHERE v.Empresa = @Empresa AND v.Mov = @AplicaMov AND v.MovID = @AplicaMovID AND mt.Clave = 'VTAS.VCR') AND @VentaMovImpuestoDesdeRemision = 1 AND @MovTipo IN ('VTAS.F')
BEGIN
SELECT @ArrastrarMovImpuestoRemision = 1
SELECT @MovImpuestoAplicaID = ID, @AplicaConcepto = Concepto, @AplicaFechaEmision = FechaEmision FROM Venta WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @AplicaMov AND MovID = @AplicaMovID
END ELSE
BEGIN
SELECT @ArrastrarMovImpuestoRemision = 0, @MovImpuestoAplicaID = NULL, @AplicaConcepto = NULL, @AplicaFechaEmision = NULL
END
END
IF @ArrastrarMovImpuestoRemision = 0 
BEGIN
INSERT #MovImpuesto (Renglon,  RenglonSub,  Excento1,     Excento2,     Excento3,     TipoImpuesto1,  TipoImpuesto2,  TipoImpuesto3,  TipoImpuesto5,  Impuesto1,      Impuesto2,      Impuesto3,      Impuesto5,      Importe1,       Importe2,       Importe3,       Importe5,       SubTotal,     LoteFijo,  ContUso,  ContUso2,  ContUso3,  ClavePresupuestal,  ClavePresupuestalImpuesto1,  DescuentoGlobal,  ImporteBruto)
VALUES (@Renglon, @RenglonSub, @ArtExcento1, @ArtExcento2, @ArtExcento3, @TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoImpuesto5, @LoteImpuesto1, @LoteImpuesto2, @LoteImpuesto3, @LoteImpuesto5, @Impuesto1Neto, @Impuesto2Neto, @Impuesto3Neto, @Impuesto5Neto, @ImporteNeto, @LoteFijo, @ContUso, @ContUso2, @ContUso3, @ClavePresupuestal, @ClavePresupuestalImpuesto1, @DescuentoGlobal, @Importe)
END ELSE
BEGIN
IF @ArrastrarMovImpuestoRemision = 1 
BEGIN
INSERT #MovImpuesto (OrigenModulo, OrigenModuloID,       OrigenConcepto,  OrigenFecha,         Renglon,  RenglonSub,  Excento1,     Excento2,     Excento3,     TipoImpuesto1,  TipoImpuesto2,  TipoImpuesto3,  TipoImpuesto5,  Impuesto1,      Impuesto2,      Impuesto3,      Impuesto5,      Importe1,       Importe2,       Importe3,       Importe5,       SubTotal,     LoteFijo,  ContUso,  ContUso2,  ContUso3,  ClavePresupuestal,  ClavePresupuestalImpuesto1,  DescuentoGlobal,  ImporteBruto)
VALUES ('VTAS',       @MovImpuestoAplicaID, @AplicaConcepto, @AplicaFechaEmision, @Renglon, @RenglonSub, @ArtExcento1, @ArtExcento2, @ArtExcento3, @TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoImpuesto5, @LoteImpuesto1, @LoteImpuesto2, @LoteImpuesto3, @LoteImpuesto5, @Impuesto1Neto, @Impuesto2Neto, @Impuesto3Neto, @Impuesto5Neto, @ImporteNeto, @LoteFijo, @ContUso, @ContUso2, @ContUso3, @ClavePresupuestal, @ClavePresupuestalImpuesto1, @DescuentoGlobal, @Importe)
END
END
SELECT @TotalImpuesto1 = @TotalImpuesto1 + @Impuesto1Neto,
@TotalImpuesto2 = @TotalImpuesto2 + @Impuesto2Neto,
@TotalImpuesto3 = @TotalImpuesto3 + @Impuesto3Neto,
@TotalImpuesto5 = @TotalImpuesto5 + @Impuesto5Neto,
@SubTotal       = @SubTotal + @ImporteNeto,
@SumaCantidad   = @SumaCantidad + @LoteCantidad
END
FETCH NEXT FROM crLote INTO @LoteFijo, @LoteCantidad, @LoteImpuesto1, @LoteImpuesto2, @LoteImpuesto3, @LoteImpuesto5
END
CLOSE crLote
DEALLOCATE crLote
SELECT @Impuesto1 = (@TotalImpuesto1 / NULLIF(@SubTotal + @TotalImpuesto2, 0)) * 100,
@Impuesto2 = (@TotalImpuesto2 / NULLIF(@SubTotal, 0)) * 100,
@Impuesto3 = (@TotalImpuesto3 / NULLIF(@SubTotal + @TotalImpuesto2, 0)) * 100,
@Impuesto5 = (@TotalImpuesto5 / NULLIF(@SubTotal + @TotalImpuesto2, 0)) * 100
IF ROUND(@Cantidad, 0) <> ROUND(@SumaCantidad, 0) SELECT @Ok = 20330
/*  SELECT @SubCuenta = ISNULL(RTRIM(@SubCuenta), ''), @Cantidad = NULLIF(@Cantidad, 0)
DELETE SerieLoteMov FROM SerieLoteMov WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID AND RenglonID = @RenglonID AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = @SubCuenta AND NULLIF(Cantidad, 0) IS NULL
SELECT @Impuesto1 = SUM(s.Cantidad*ISNULL(f.Impuesto1, @Impuesto1)) / @Cantidad FROM SerieLoteMov s, LoteFijo f WHERE s.Empresa = @Empresa AND s.Modulo = @Modulo AND s.ID = @ID AND s.RenglonID = @RenglonID AND s.Articulo = @Articulo AND ISNULL(s.SubCuenta, '') = @SubCuenta AND s.SerieLote = f.Lote
SELECT @Impuesto2 = SUM(s.Cantidad*ISNULL(f.Impuesto2, @Impuesto2)) / @Cantidad FROM SerieLoteMov s, LoteFijo f WHERE s.Empresa = @Empresa AND s.Modulo = @Modulo AND s.ID = @ID AND s.RenglonID = @RenglonID AND s.Articulo = @Articulo AND ISNULL(s.SubCuenta, '') = @SubCuenta AND s.SerieLote = f.Lote
SELECT @Impuesto3 = SUM(s.Cantidad*ISNULL(f.Impuesto3, @Impuesto3)) / @Cantidad FROM SerieLoteMov s, LoteFijo f WHERE s.Empresa = @Empresa AND s.Modulo = @Modulo AND s.ID = @ID AND s.RenglonID = @RenglonID AND s.Articulo = @Articulo AND ISNULL(s.SubCuenta, '') = @SubCuenta AND s.SerieLote = f.Lote
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto2 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto3 OUTPUT*/
RETURN
END

