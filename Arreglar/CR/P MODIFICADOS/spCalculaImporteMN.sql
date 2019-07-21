SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCalculaImporteMN
@CfgImpInc			bit,
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
@TipoCambio			float,
@ImporteMN			float	OUTPUT,
@DescuentoMN			float	OUTPUT,
@Impuesto1MN			float	= NULL OUTPUT,
@Impuesto2MN			float	= NULL OUTPUT,
@Impuesto3MN			float	= NULL OUTPUT,
@Impuesto5MN			float	= NULL OUTPUT,
@ImporteTotalMN		float	= NULL OUTPUT,
@CantidadObsequio		float	= NULL,
@CfgPrecioMoneda		bit	= 0,
@MovTipoCambio		float	= NULL,
@PrecioTipoCambio		float	= NULL

AS BEGIN
EXEC spCalculaImporte @CfgImpInc, @Cantidad, @Precio, @DescuentoTipo, @DescuentoLinea, @DescuentoGlobal, @SobrePrecio, @Impuesto1, @Impuesto2, @Impuesto3, @Impuesto5,
@ImporteMN OUTPUT, @DescuentoMN OUTPUT, @Impuesto1MN OUTPUT, @Impuesto2MN OUTPUT, @Impuesto3MN OUTPUT, @Impuesto5MN OUTPUT,
@CantidadObsequio = @CantidadObsequio, @CfgPrecioMoneda = @CfgPrecioMoneda, @MovTipoCambio = @MovTipoCambio, @PrecioTipoCambio = @PrecioTipoCambio
SELECT @ImporteMN = @ImporteMN * @TipoCambio,
@DescuentoMN = @DescuentoMN * @TipoCambio,
@Impuesto1MN = @Impuesto1MN * @TipoCambio,
@Impuesto2MN = @Impuesto2MN * @TipoCambio,
@Impuesto3MN = @Impuesto3MN * @TipoCambio,
@Impuesto5MN = @Impuesto5MN * @TipoCambio
SELECT @ImporteTotalMN = ISNULL(@ImporteMN, 0.0) + ISNULL(@Impuesto1MN, 0.0) + ISNULL(@Impuesto2MN, 0.0) + ISNULL(@Impuesto3MN, 0.0) + ISNULL(@Impuesto5MN, 0.0)
RETURN
END

