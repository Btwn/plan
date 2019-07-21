SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSPrecio (
@Empresa        varchar(5),
@Precio         float,
@Impuesto1		float,
@Impuesto2      float,
@Impuesto3      float
)
RETURNS float

AS
BEGIN
DECLARE
@Resultado                  float,
@cfgImpuestoIncluido        bit,
@RedondeoMonetarios         int
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
SELECT @cfgImpuestoIncluido = ISNULL(VentaPreciosImpuestoIncluido,0) FROM EmpresaCfg WITH(NOLOCK) WHERE Empresa = @Empresa
SET @Resultado = 0.0
IF @cfgImpuestoIncluido = 1
SELECT @Resultado = (@Precio-ISNULL(@Impuesto3,0.0))/ (1.0 + (ISNULL(@Impuesto2, 0.0)/100) + ((ISNULL(@Impuesto1,0.0)/100) * (1+(ISNULL(@Impuesto2, 0.0)/100))))
ELSE
SELECT  @Resultado = @Precio
RETURN (@Resultado)
END

