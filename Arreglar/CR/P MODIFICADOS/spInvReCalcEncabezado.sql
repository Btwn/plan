SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvReCalcEncabezado
@ID          	int,
@Modulo		char(5),
@CfgImpInc		bit,
@CfgMultiUnidades	bit,
@DescuentoGlobal 	float,
@SobrePrecio 	float = NULL,
@CalcComisiones	bit = 0,
@CfgPrecioMoneda	bit = 0

AS BEGIN
DECLARE
@Empresa		    char(5),
@Usuario		    char(10),
@Sucursal		    int,
@Mov		    char(20),
@MovID		    varchar(20),
@MovTipo		    char(20),
@MovMoneda		    char(10),
@MovTipoCambio	    float,
@FechaEmision           datetime,
@FechaRegistro          datetime,
@Agente		    char(10),
@Renglon		    float,
@RenglonSub		    int,
@Articulo		    char(20),
@MovUnidad		    varchar(50),
@Cantidad		    float,
@CantidadObsequio	    float,
@CantidadPendiente	    float,
@Factor		    float,
@Precio		    float,
@PrecioTipoCambio	    float,
@Costo		    float,
@DescuentoTipo	    char(1),
@DescuentoLinea	    float,
@ImporteComision	    money,
@Peso		    float,
@Volumen		    float,
@Impuesto1		    float,
@Impuesto2		    float,
@Impuesto3		    float,
@Impuesto5		    float,
@Retencion1		    float,
@Retencion2		    float,
@Retencion3		    float,
@Importe 		    money,
@ImporteNeto	    money,
@Impuestos 		    money,
@ImpuestosNetos	    money,
@Impuesto1Neto 	    money,
@Impuesto2Neto 	    money,
@Impuesto3Neto 	    money,
@Impuesto5Neto 	    money,
@DescuentoLineaImporte  money,
@DescuentoGlobalImporte money,
@SobrePrecioImporte	    money,
@SumaImporte	    money,
@SumaImporteNeto	    money,
@SumaImpuestos	    money,
@SumaImpuestosNetos	    money,
@SumaImpuesto1Neto	    money,
@SumaImpuesto2Neto	    money,
@SumaImpuesto3Neto	    money,
@SumaImpuesto5Neto	    money,
@SumaDescuentoLinea	    money,
@SumaPrecioLinea	    money,
@SumaCostoLinea	    money,
@SumaPeso		    float,
@SumaVolumen	    float,
@SumaComision	    money,
@SumaTotal	    	    money,
@SumaSaldo	    	    money,
@Ok			    int,
@OkRef		    varchar(255),
@RedondeoMonetarios	    int,
@AnticipoFacturado bit
SELECT @RedondeoMonetarios = RedondeoMonetarios FROM Version WITH(NOLOCK)
SELECT @Ok			= NULL,
@OkRef			= NULL,
@CantidadObsequio	= NULL,
@FechaRegistro		= GETDATE(),
@SumaImporte    	= 0.0,
@SumaImporteNeto    	= 0.0,
@SumaImpuestos	    	= 0.0,
@SumaImpuestosNetos   	= 0.0,
@SumaImpuesto1Neto    	= 0.0,
@SumaImpuesto2Neto    	= 0.0,
@SumaImpuesto3Neto    	= 0.0,
@SumaDescuentoLinea	= 0.0,
@SumaComision		= 0.0,
@SumaPrecioLinea	= 0.0,
@SumaCostoLinea	= 0.0,
@SumaPeso		= 0.0,
@SumaVolumen		= 0.0,
@SumaTotal		= 0.0,
@SumaSaldo		= 0.0,
@AnticipoFacturado = 0 
IF @Modulo = 'VTAS'
BEGIN
SELECT @Empresa = e.Empresa, @Usuario = e.Usuario, @Sucursal = e.Sucursal, @Mov = e.Mov, @MovID = e.MovID, @MovTipo = mt.Clave, @MovMoneda = e.Moneda, @MovTipoCambio = e.TipoCambio, @FechaEmision = e.FechaEmision, @Agente = e.Agente
FROM Venta e WITH(NOLOCK), MovTipo mt WITH(NOLOCK)
WHERE e.ID = @ID AND mt.Modulo = @Modulo AND mt.Mov = e.Mov
DECLARE crVentaDetalleRecalc CURSOR LOCAL FOR
SELECT d.Renglon, d.RenglonSub, d.Articulo, d.Factor, NULLIF(RTRIM(d.Unidad), ''), (ISNULL(d.Cantidad, 0.0)-ISNULL(d.CantidadCancelada, 0.0)), d.CantidadObsequio, (ISNULL(d.CantidadPendiente, 0.0)+ISNULL(d.CantidadReservada, 0.0)+ISNULL(d.CantidadOrdenada, 0.0)), ISNULL(d.Costo, 0.0), ISNULL(d.Precio, 0.0), NULLIF(RTRIM(d.DescuentoTipo), ''), ISNULL(d.DescuentoLinea, 0.0), ISNULL(d.Impuesto1, 0.0), ISNULL(d.Impuesto2, 0.0), ISNULL(d.Impuesto3, 0.0), ISNULL(a.Peso, 0.0), ISNULL(a.Volumen, 0.0), d.Agente, ISNULL(d.Comision, 0.0), d.PrecioTipoCambio, d.AnticipoFacturado 
FROM VentaD d WITH(NOLOCK), Art a WITH(NOLOCK)
WHERE d.ID = @ID
AND d.Articulo = a.Articulo
OPEN crVentaDetalleRecalc
FETCH NEXT FROM crVentaDetalleRecalc INTO @Renglon, @RenglonSub, @Articulo, @Factor, @MovUnidad, @Cantidad, @CantidadObsequio, @CantidadPendiente, @Costo, @Precio, @DescuentoTipo, @DescuentoLinea, @Impuesto1, @Impuesto2, @Impuesto3, @Peso, @Volumen, @Agente, @ImporteComision, @PrecioTipoCambio, @AnticipoFacturado 
END ELSE
IF @Modulo = 'COMS'
BEGIN
SELECT @Empresa = e.Empresa, @Usuario = e.Usuario, @Sucursal = e.Sucursal, @Mov = e.Mov, @MovID = e.MovID, @MovTipo = mt.Clave, @MovMoneda = e.Moneda, @MovTipoCambio = e.TipoCambio, @FechaEmision = e.FechaEmision, @Agente = e.Agente
FROM Compra e WITH(NOLOCK), MovTipo mt WITH(NOLOCK)
WHERE e.ID = @ID AND mt.Modulo = @Modulo AND mt.Mov = e.Mov
DECLARE crCompraDetalleRecalc CURSOR LOCAL FOR
SELECT d.Renglon, d.RenglonSub, d.Articulo, d.Factor, NULLIF(RTRIM(d.Unidad), ''), (ISNULL(d.Cantidad, 0.0)-ISNULL(d.CantidadCancelada, 0.0)), (ISNULL(d.CantidadPendiente, 0.0)), ISNULL(d.Costo, 0.0), NULLIF(RTRIM(d.DescuentoTipo), ''), ISNULL(d.DescuentoLinea, 0.0), ISNULL(d.Impuesto1, 0.0), ISNULL(d.Impuesto2, 0.0), ISNULL(d.Impuesto3, 0.0), ISNULL(d.Impuesto5, 0.0), ISNULL(a.Peso, 0.0), ISNULL(a.Volumen, 0.0), d.Retencion1, d.Retencion2, d.Retencion3
FROM CompraD d WITH(NOLOCK), Art a WITH(NOLOCK)
WHERE d.ID = @ID
AND d.Articulo = a.Articulo
OPEN crCompraDetalleRecalc
FETCH NEXT FROM crCompraDetalleRecalc INTO @Renglon, @RenglonSub, @Articulo, @Factor, @MovUnidad, @Cantidad, @CantidadPendiente, @Precio, @DescuentoTipo, @DescuentoLinea, @Impuesto1, @Impuesto2, @Impuesto3, @Impuesto5, @Peso, @Volumen, @Retencion1, @Retencion2, @Retencion3
END ELSE
IF @Modulo = 'INV'
BEGIN
SELECT @Empresa = e.Empresa, @Usuario = e.Usuario, @Sucursal = e.Sucursal, @Mov = e.Mov, @MovID = e.MovID, @MovTipo = mt.Clave, @MovMoneda = e.Moneda, @MovTipoCambio = e.TipoCambio, @FechaEmision = e.FechaEmision, @Agente = e.Agente
FROM Inv e WITH(NOLOCK), MovTipo mt WITH(NOLOCK)
WHERE e.ID = @ID AND mt.Modulo = @Modulo AND mt.Mov = e.Mov
DECLARE crInvDetalleRecalc CURSOR LOCAL FOR
SELECT d.Renglon, d.RenglonSub, d.Articulo, d.Factor, NULLIF(RTRIM(d.Unidad), ''), (ISNULL(d.Cantidad, 0.0)-ISNULL(d.CantidadCancelada, 0.0)), (ISNULL(d.CantidadPendiente, 0.0)+ISNULL(d.CantidadReservada, 0.0)+ISNULL(d.CantidadOrdenada, 0.0)), ISNULL(a.Peso, 0.0), ISNULL(a.Volumen, 0.0)
FROM InvD d WITH(NOLOCK), Art a WITH(NOLOCK)
WHERE d.ID = @ID
AND d.Articulo = a.Articulo
OPEN crInvDetalleRecalc
FETCH NEXT FROM crInvDetalleRecalc INTO @Renglon, @RenglonSub, @Articulo, @Factor, @MovUnidad, @Cantidad, @CantidadPendiente, @Peso, @Volumen
END ELSE
IF @Modulo = 'PROD'
BEGIN
SELECT @Empresa = e.Empresa, @Usuario = e.Usuario, @Sucursal = e.Sucursal, @Mov = e.Mov, @MovID = e.MovID, @MovTipo = mt.Clave, @MovMoneda = e.Moneda, @MovTipoCambio = e.TipoCambio, @FechaEmision = e.FechaEmision
FROM Prod e WITH(NOLOCK), MovTipo mt WITH(NOLOCK)
WHERE e.ID = @ID AND mt.Modulo = @Modulo AND mt.Mov = e.Mov
DECLARE crProdDetalleRecalc CURSOR FOR
SELECT d.Renglon, d.RenglonSub, d.Articulo, d.Factor, NULLIF(RTRIM(d.Unidad), ''), (ISNULL(d.Cantidad, 0.0)-ISNULL(d.CantidadCancelada, 0.0)), (ISNULL(d.CantidadPendiente, 0.0)+ISNULL(d.CantidadReservada, 0.0)+ISNULL(d.CantidadOrdenada, 0.0)), ISNULL(a.Peso, 0.0), ISNULL(a.Volumen, 0.0)
FROM ProdD d WITH(NOLOCK), Art a WITH(NOLOCK)
WHERE d.ID = @ID
AND d.Articulo = a.Articulo
OPEN crProdDetalleRecalc
FETCH NEXT FROM crProdDetalleRecalc INTO @Renglon, @RenglonSub, @Articulo, @Factor, @MovUnidad, @Cantidad, @CantidadPendiente, @Peso, @Volumen
END
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2 AND @Cantidad <> 0.0
BEGIN
EXEC spCalculaImporte NULL, @Modulo, @CfgImpInc, NULL, NULL, @Cantidad, @Precio, @DescuentoTipo, @DescuentoLinea, @DescuentoGlobal, @SobrePrecio, @Impuesto1, @Impuesto2, @Impuesto3, @Impuesto5,
@Importe OUTPUT, @ImporteNeto OUTPUT, @DescuentoLineaImporte OUTPUT, @DescuentoGlobalImporte OUTPUT, @SobrePrecioImporte OUTPUT,
@Impuestos OUTPUT, @ImpuestosNetos OUTPUT, @Impuesto1Neto OUTPUT, @Impuesto2Neto OUTPUT, @Impuesto3Neto OUTPUT, @Impuesto5Neto OUTPUT,
@Articulo = @Articulo, @CantidadObsequio = @CantidadObsequio, @CfgPrecioMoneda = @CfgPrecioMoneda, @MovTipoCambio = @MovTipoCambio, @PrecioTipoCambio = @PrecioTipoCambio,
@Retencion1 = @Retencion1, @Retencion2 = @Retencion2, @Retencion3 = @Retencion3, @ID = @ID, @AnticipoFacturado = @AnticipoFacturado 
IF @CalcComisiones = 1 AND @Modulo = 'VTAS'
BEGIN
EXEC xpComisionCalcular @ID, 'AFECTAR', @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo,
@MovMoneda, @MovTipoCambio, @FechaEmision, @FechaRegistro, @FechaRegistro, @Agente, 0, 0, @Sucursal,
@Renglon, @RenglonSub, @Articulo, @Cantidad, @Importe, @ImporteNeto, @Impuestos, @ImpuestosNetos, @Costo, NULL, NULL,
@ImporteComision OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
UPDATE VentaD WITH(NOLOCK) SET Comision = @ImporteComision WHERE CURRENT OF crVentaDetalleRecalc
END
SELECT 
@SumaImporte         = @SumaImporte         + @Importe,
@SumaImporteNeto     = @SumaImporteNeto     + @ImporteNeto,
@SumaImpuestos       = @SumaImpuestos 	 + @Impuestos,
@SumaImpuestosNetos  = @SumaImpuestosNetos  + @ImpuestosNetos,
@SumaImpuesto1Neto   = @SumaImpuesto1Neto   + @Impuesto1Neto,
@SumaImpuesto2Neto   = @SumaImpuesto2Neto   + @Impuesto2Neto,
@SumaImpuesto3Neto   = @SumaImpuesto3Neto   + @Impuesto3Neto,
@SumaImpuesto5Neto   = @SumaImpuesto5Neto   + @Impuesto5Neto,
@SumaCostoLinea      = @SumaCostoLinea      + ROUND(@Costo * @Cantidad, @RedondeoMonetarios),
@SumaPrecioLinea     = @SumaPrecioLinea     + ROUND(@Precio * @Cantidad, @RedondeoMonetarios),
@SumaDescuentoLinea  = @SumaDescuentoLinea  + @DescuentoLineaImporte,
@SumaPeso	          = @SumaPeso            + (@Cantidad * @Peso * @Factor),
@SumaVolumen	  = @SumaVolumen         + (@Cantidad * @Volumen * @Factor),
@SumaComision	  = @SumaComision        + ISNULL(@ImporteComision, 0.0),
@SumaTotal           = @SumaTotal           + @Importe + ISNULL(@ImpuestosNetos,0.0),
@SumaSaldo           = @SumaSaldo           + ISNULL((@CantidadPendiente * (@Importe + @ImpuestosNetos)) / NULLIF(@Cantidad, 0), 0)
END
IF @Modulo = 'VTAS' FETCH NEXT FROM crVentaDetalleRecalc  INTO @Renglon, @RenglonSub, @Articulo, @Factor, @MovUnidad, @Cantidad, @CantidadObsequio, @CantidadPendiente, @Costo, @Precio, @DescuentoTipo, @DescuentoLinea, @Impuesto1, @Impuesto2, @Impuesto3, @Peso, @Volumen, @Agente, @ImporteComision, @PrecioTipoCambio, @AnticipoFacturado ELSE
IF @Modulo = 'COMS' FETCH NEXT FROM crCompraDetalleRecalc INTO @Renglon, @RenglonSub, @Articulo, @Factor, @MovUnidad, @Cantidad, @CantidadPendiente, @Precio, @DescuentoTipo, @DescuentoLinea, @Impuesto1, @Impuesto2, @Impuesto3, @Impuesto5, @Peso, @Volumen, @Retencion1, @Retencion2, @Retencion3 ELSE
IF @Modulo = 'INV'  FETCH NEXT FROM crInvDetalleRecalc    INTO @Renglon, @RenglonSub, @Articulo, @Factor, @MovUnidad, @Cantidad, @CantidadPendiente, @Peso, @Volumen ELSE
IF @Modulo = 'PROD' FETCH NEXT FROM crProdDetalleRecalc   INTO @Renglon, @RenglonSub, @Articulo, @Factor, @MovUnidad, @Cantidad, @CantidadPendiente, @Peso, @Volumen
END
IF @Modulo = 'VTAS'
BEGIN
SELECT @SumaTotal = ROUND(@SumaTotal, ISNULL(VentaCobroRedondeoDecimales, @RedondeoMonetarios))
FROM EmpresaCfg WITH(NOLOCK)
WHERE Empresa = @Empresa
IF @CfgImpInc = 1
SELECT @SumaImporte = @SumaImporte - (@SumaImporte + ISNULL(@SumaImpuestosNetos,0.0) - @SumaTotal)
UPDATE Venta WITH(ROWLOCK) SET Peso = @SumaPeso, Volumen = @SumaVolumen, Importe = @SumaImporte, Impuestos = @SumaImpuestosNetos, DescuentoLineal = @SumaDescuentoLinea, ComisionTotal = @SumaComision, PrecioTotal = @SumaPrecioLinea, CostoTotal = @SumaCostoLinea, IVAFiscal = CONVERT(float, @SumaImpuesto1Neto)/NULLIF(@SumaTotal, 0), IEPSFiscal = CONVERT(float, @SumaImpuesto2Neto)/NULLIF(@SumaTotal, 0), Saldo = @SumaSaldo WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
CLOSE crVentaDetalleRecalc
DEALLOCATE crVentaDetalleRecalc
END ELSE
IF @Modulo = 'COMS'
BEGIN
UPDATE Compra WITH(ROWLOCK) SET Peso = @SumaPeso, Volumen = @SumaVolumen, Importe = @SumaImporte, Impuestos = @SumaImpuestosNetos, DescuentoLineal = @SumaDescuentoLinea, IVAFiscal = CONVERT(float, @SumaImpuesto1Neto)/NULLIF(@SumaTotal, 0), IEPSFiscal = CONVERT(float, @SumaImpuesto2Neto)/NULLIF(@SumaTotal, 0), Saldo = @SumaSaldo WHERE ID = @ID
CLOSE crCompraDetalleRecalc
DEALLOCATE crCompraDetalleRecalc
END ELSE
IF @Modulo = 'INV'
BEGIN
UPDATE Inv WITH(ROWLOCK)SET Peso = @SumaPeso, Volumen = @SumaVolumen, Importe = @SumaCostoLinea WHERE ID = @ID
CLOSE crInvDetalleRecalc
DEALLOCATE crInvDetalleRecalc
END ELSE
IF @Modulo = 'PROD'
BEGIN
UPDATE Prod WITH(ROWLOCK) SET Peso = @SumaPeso, Volumen = @SumaVolumen, Importe = @SumaCostoLinea WHERE ID = @ID
CLOSE crProdDetalleRecalc
DEALLOCATE crProdDetalleRecalc
END
END

