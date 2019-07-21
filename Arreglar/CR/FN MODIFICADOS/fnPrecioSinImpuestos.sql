SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnPrecioSinImpuestos (@Empresa char(5), @Articulo char(20), @Precio float)
RETURNS float

AS BEGIN
DECLARE
@Impuesto1		float,
@Impuesto2		float,
@Impuesto3		float,
@Impuesto2Info	bit,
@Impuesto3Info	bit
IF (SELECT VentaPreciosImpuestoIncluido FROM EmpresaCfg WITH(NOLOCK) WHERE Empresa = @Empresa) =1
BEGIN
SELECT @Impuesto2Info = ISNULL(Impuesto2Info, 0), @Impuesto3Info = ISNULL(Impuesto3Info, 0)
FROM Version WITH(NOLOCK)
SELECT @Impuesto1 = Impuesto1, @Impuesto2 = Impuesto2, @Impuesto3 = Impuesto3
FROM Art WITH(NOLOCK)
WHERE Articulo = @Articulo
IF @Impuesto2Info = 1 SELECT @Impuesto2 = 0.0
IF @Impuesto3Info = 1 SELECT @Impuesto3 = 0.0
SELECT @Precio = @Precio / (1.0+(((100.0+ISNULL(@Impuesto2, 0.0))*(1+((ISNULL(@Impuesto1, 0.0)/*+ISNULL(Impuesto3, 0.0)*/)/100.0))-100.0)/100.0))
END
RETURN (@Precio)
END

