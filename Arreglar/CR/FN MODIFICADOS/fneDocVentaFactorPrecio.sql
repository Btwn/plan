SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fneDocVentaFactorPrecio
(
@ID                      int,
@Renglon                 float,
@RenglonSub              int
)
RETURNS float

AS BEGIN
DECLARE
@Resultado                            float,
@PrecioOriginal                       float,
@PrecioSinImpuestos                   float,
@Empresa                              varchar(5),
@VentaPreciosImpuestoIncluido         bit,
@Impuesto1                            float,
@Impuesto2                            float,
@Impuestos                            float,
@Impuesto1Importe                     float,
@Impuesto2Importe                     float,
@Impuesto3Importe                     float,
@ImpuestosImporte                     float,
@Impuesto2BaseImpuesto1               bit,
@DescuentosLineales                   float,
@Impuesto2Info                        bit,
@Impuesto3Info                        BIT,
@ImporteSobrePrecio                          float
SELECT @Empresa = Empresa FROM Venta WITH(NOLOCK) WHERE ID = @ID
SELECT @VentaPreciosImpuestoIncluido = ISNULL(VentaPreciosImpuestoIncluido,0) FROM EmpresaCfg WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT
@Impuesto2BaseImpuesto1 = ISNULL(Impuesto2BaseImpuesto1,0),
@Impuesto2Info = ISNULL(Impuesto2Info,0),
@Impuesto3Info = ISNULL(Impuesto3Info,0)
FROM Version WITH(NOLOCK)
SELECT
@PrecioOriginal = ISNULL(Precio,0.0),
@Impuesto1 = ISNULL(Impuesto1,0.0),
@Impuesto2 = CASE WHEN @Impuesto2Info = 0 THEN ISNULL(Impuesto2,0.0) ELSE 0.0 END,
@Impuesto3Importe = CASE WHEN @Impuesto3Info = 0 THEN ISNULL(Impuesto3,0.0) ELSE 0.0 END,
@DescuentosLineales = (ISNULL(DescuentosTotales,0.0)-ISNULL(ImporteDescuentoGlobal,0.0))/ISNULL(Cantidad,0.0),
@ImporteSobrePrecio = ISNULL(ImporteSobrePrecio,0.0)/ISNULL(Cantidad,0.0)
FROM VentaTCalc
WHERE ID = @ID
AND Renglon = @Renglon
AND RenglonSub = @RenglonSub
IF @VentaPreciosImpuestoIncluido = 1
BEGIN
IF @Impuesto2BaseImpuesto1 = 1
BEGIN
SET @PrecioSinImpuestos = @PrecioOriginal - @DescuentosLineales
SET @PrecioSinImpuestos = @PrecioSinImpuestos - @Impuesto3Importe
SET @PrecioSinImpuestos = @PrecioSinImpuestos / (1 + (ISNULL(@Impuesto1,0.0)/100.0))
SET @PrecioSinImpuestos = @PrecioSinImpuestos / (1 + (ISNULL(@Impuesto2,0.0)/100.0))
SET @PrecioSinImpuestos = @PrecioSinImpuestos + @DescuentosLineales + @ImporteSobrePrecio
END ELSE
BEGIN
SET @PrecioSinImpuestos = @PrecioOriginal - @DescuentosLineales
SET @Impuestos = (@Impuesto1/100.0) + (@Impuesto2/100.0)
SET @PrecioSinImpuestos = (@PrecioSinImpuestos / ( 1 + @Impuestos) )  + @DescuentosLineales + @ImporteSobrePrecio
END
END
ELSE
BEGIN
SET @PrecioSinImpuestos = @PrecioOriginal + @ImporteSobrePrecio
END
IF ISNULL(@PrecioOriginal,0.0) = 0.0
SET @Resultado = 0.0
ELSE
SET @Resultado = ISNULL(@PrecioSinImpuestos,0.0) / ISNULL(@PrecioOriginal,0.0)
RETURN (@Resultado)
END

