SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCalculaImporte
@Accion			char(20),
@Modulo			char(5),
@CfgImpInc			bit,
@MovTipo			char(20),
@EsEntrada			bit,
@Cantidad			float,
@Precio	  		float,
@DescuentoTipo		char(1),
@DescuentoLinea 		float,
@DescuentoGlobal		float,
@SobrePrecio			float,
@Impuesto1			float,
@Impuesto2			float,
@Impuesto3			float,
@Impuesto5			float,
@Importe			float	OUTPUT,
@ImporteNeto			float	OUTPUT,
@DescuentoLineaImporte	float	OUTPUT,
@DescuentoGlobalImporte	float   OUTPUT,
@SobrePrecioImporte		float   OUTPUT,
@Impuestos			float   OUTPUT,
@ImpuestosNetos		float   OUTPUT,
@Impuesto1Neto		float	 = NULL OUTPUT,
@Impuesto2Neto		float	 = NULL OUTPUT,
@Impuesto3Neto		float	 = NULL OUTPUT,
@Impuesto5Neto		float	 = NULL OUTPUT,
@Articulo 			char(20) = NULL,
@CantidadObsequio		float	 = NULL,
@CfgPrecioMoneda		bit	 = 0,
@MovTipoCambio		float	 = NULL,
@PrecioTipoCambio		float	 = NULL,
@Retencion1			float	 = NULL,
@Retencion2			float	 = NULL,
@Retencion3			float	 = NULL,
@ID					int		 = NULL,
@AnticipoFacturado	bit		 = NULL, 
@Retencion1Neto		float	 = NULL OUTPUT,
@Retencion2Neto		float	 = NULL OUTPUT,
@Retencion3Neto		float	 = NULL OUTPUT,
@RetencionesNeto		float    = NULL OUTPUT

AS BEGIN
DECLARE
@PorDescLinea		float,
@PorDescGlobal		float,
@PorSobrePrecio		float,
@JuntarImpuestos		float,
@SubImpuesto1		float,
@SubImpuestoNeto1		float,
@SubImpuesto2		float,
@SubImpuestoNeto2		float,
@SubImpuesto3		float,
@SubImpuestoNeto3		float,
@RedondeoMonetarios		int,
@Impuesto2Info		bit,
@Impuesto3Info		bit,
@Impuesto2BaseImpuesto1	bit,
@Retencion2BaseImpuesto1	bit,
@SubImpuesto5		float,
@SubImpuestoNeto5		float,
@SubMovTipo				varchar(20),
@Mov					varchar(20)
IF NULLIF(@ID,0) IS NOT NULL
BEGIN
IF @Modulo = 'VTAS' SELECT @Mov = Mov FROM Venta WHERE ID = @ID ELSE
IF @Modulo = 'COMS' SELECT @Mov = Mov FROM Compra WHERE ID = @ID ELSE
IF @Modulo = 'PROD' SELECT @Mov = Mov FROM Prod WHERE ID = @ID ELSE
IF @Modulo = 'INV' SELECT @Mov = Mov FROM Inv WHERE ID = @ID
SELECT @SubMovTipo = SubClave FROM MovTipo WHERE Mov = @Mov AND Modulo = @Modulo
END
SELECT @RedondeoMonetarios = RedondeoMonetarios, @Impuesto2Info = ISNULL(Impuesto2Info, 0), @Impuesto3Info = ISNULL(Impuesto3Info, 0), @Impuesto2BaseImpuesto1 = ISNULL(Impuesto2BaseImpuesto1, 0), @Retencion2BaseImpuesto1 = ISNULL(Retencion2BaseImpuesto1, 0) FROM Version
SELECT @Cantidad        = ISNULL(@Cantidad, 0.0) - ISNULL(@CantidadObsequio, 0.0),
@Precio   	  = ISNULL(@Precio, 0.0),
@DescuentoTipo   = ISNULL(@DescuentoTipo, '%'),
@DescuentoLinea  = ISNULL(@DescuentoLinea, 0.0),
@DescuentoGlobal = ISNULL(@DescuentoGlobal, 0.0),
@SobrePrecio     = ISNULL(@SobrePrecio, 0.0),
@Impuesto1	  = ISNULL(@Impuesto1, 0.0),
@Impuesto2	  = ISNULL(@Impuesto2, 0.0),
@Impuesto3	  = ISNULL(@Impuesto3, 0.0),
@Impuesto5	  = ISNULL(@Impuesto5, 0.0),
@Retencion1	  = ISNULL(@Retencion1, 0.0),
@Retencion2	  = ISNULL(@Retencion2, 0.0),
@Retencion3	  = ISNULL(@Retencion3, 0.0)
IF @Impuesto2Info = 1 SELECT @Impuesto2 = 0.0
IF @Impuesto3Info = 1 SELECT @Impuesto3 = 0.0
IF @MovTipo IN ('VTAS.N','VTAS.NO','VTAS.NR','VTAS.FM')
IF (@Accion <> 'CANCELAR' AND @EsEntrada = 1) OR
(@Accion = 'CANCELAR' AND @EsEntrada = 0) SELECT @Cantidad = -@Cantidad
/*IF @CfgImpInc = 1 AND ISNULL(@Impuesto3, 0) = 0 AND @Articulo IS NOT NULL
SELECT @Imp3 = ISNULL(Impuesto3, 0) FROM Art WHERE Articulo = @Articulo
ELSE
SELECT @Imp3 = @Impuesto3*/
SELECT @JuntarImpuestos = CASE WHEN @Impuesto2BaseImpuesto1 = 1 THEN ((100.0+@Impuesto2)*(1+((@Impuesto1/*+@Imp3*/)/100.0))-100.0) ELSE @Impuesto1+@Impuesto2 END,
@PorDescLinea    = CONVERT(float, @DescuentoLinea/100.0),
@PorDescGlobal   = CONVERT(float, @DescuentoGlobal/100.0),
@PorSobrePrecio  = CONVERT(float, @SobrePrecio/100.0)
IF @Modulo = 'VTAS' AND @CfgImpInc = 1
SELECT @Precio = (@Precio-@Impuesto3)/(1+(@JuntarImpuestos/100.0))
IF @Modulo = 'VTAS' AND @CfgPrecioMoneda = 1
SELECT @Precio = (@Precio * @PrecioTipoCambio) / @MovTipoCambio
SELECT @Importe                = @Cantidad * @Precio,
@DescuentoGlobalImporte = 0.0,
@SobrePrecioImporte	 = 0.0,
@Impuestos              = 0.0
EXEC xpCalculaImporte1 @RedondeoMonetarios, @Importe OUTPUT
IF @DescuentoTipo <> '$'
SELECT @DescuentoLineaImporte  = @DescuentoLinea * @Cantidad
ELSE SELECT @DescuentoLineaImporte  = @DescuentoLinea
IF @DescuentoLinea <> 0.0
BEGIN
IF @DescuentoTipo <> '$'
SELECT @DescuentoLineaImporte = @Importe * @PorDescLinea
SELECT @Importe = @Importe - @DescuentoLineaImporte
END
IF @DescuentoGlobal <> 0.0 AND ISNULL(@AnticipoFacturado,0) = 0
SELECT @DescuentoGlobalImporte = ROUND(@Importe * @PorDescGlobal, @RedondeoMonetarios)
IF @SobrePrecio <> 0.0
SELECT @SobrePrecioImporte = ROUND(@Importe * @PorSobrePrecio, @RedondeoMonetarios)
SELECT @ImporteNeto = @Importe - @DescuentoGlobalImporte + @SobrePrecioImporte
IF @ID IS NOT NULL AND (@MovTipo = 'GAS.G' AND @SubMovTipo = 'GAS.GE/GT') SELECT @ImporteNeto = @ImporteNeto * (1-(@Retencion3/100.0))
SELECT @SubImpuesto2 = @Importe * (@Impuesto2/100.0)
IF @Impuesto2BaseImpuesto1 = 1
SELECT @SubImpuesto1 = (@Importe + @SubImpuesto2) * ((@Impuesto1/*+@Impuesto3*/)/100.0)
ELSE
SELECT @SubImpuesto1 = @Importe * (@Impuesto1/100.0)
SELECT @Impuestos    = @SubImpuesto1 + @SubImpuesto2
SELECT @SubImpuestoNeto2 = @ImporteNeto * (@Impuesto2/100.0)
SELECT @SubImpuestoNeto3 = @Cantidad * @Impuesto3
SELECT @SubImpuestoNeto5 = @Impuesto5
SELECT @SubImpuestoNeto1 = (@ImporteNeto + CASE WHEN @Impuesto2BaseImpuesto1 = 1 THEN @SubImpuestoNeto2 ELSE 0.0 END) * ((@Impuesto1/*+@Impuesto3*/)/100.0)
SELECT @ImpuestosNetos  = @SubImpuestoNeto1 + @SubImpuestoNeto2 + @SubImpuestoNeto3 + @SubImpuestoNeto5,
@Impuesto1Neto   = @SubImpuestoNeto1 /*- (@ImporteNeto * (@Impuesto3/100.0))*/,
@Impuesto2Neto   = @SubImpuestoNeto2,
@Impuesto3Neto   = @SubImpuestoNeto3,
@Impuesto5Neto   = @SubImpuestoNeto5
SELECT @Retencion1Neto = @ImporteNeto * (@Retencion1/100.0)
SELECT @Retencion2Neto = (CASE WHEN @Retencion2BaseImpuesto1 = 1 THEN @SubImpuestoNeto1 ELSE @ImporteNeto END) * (@Retencion2/100.0)
SELECT @Retencion3Neto = @ImporteNeto * (@Retencion3/100.0)
SELECT @RetencionesNeto = @Retencion1Neto + @Retencion2Neto + @Retencion3Neto
EXEC xpCalculaImporte2 @RedondeoMonetarios, @Importe OUTPUT, @ImporteNeto OUTPUT, @DescuentoLineaImporte OUTPUT, @DescuentoGlobalImporte OUTPUT, @SobrePrecioImporte OUTPUT, @Impuestos OUTPUT, @ImpuestosNetos OUTPUT, @Impuesto1Neto OUTPUT, @Impuesto2Neto OUTPUT, @Impuesto3Neto OUTPUT, @Impuesto5Neto OUTPUT
RETURN
END

