SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSPrecio3 (
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
@Resultado						float,
@cfgImpuestoIncluido			bit,
@POSCfgPOSCFGImpuestoIncluido	bit,
@RedondeoMonetarios				int
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
SELECT @cfgImpuestoIncluido = ISNULL(VentaPreciosImpuestoIncluido,0)
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT  @POSCfgPOSCFGImpuestoIncluido  = ISNULL(ImpuestoIncluido,0)
FROM POSCfg
WHERE Empresa = @Empresa
SET @Resultado = 0.0
IF @cfgImpuestoIncluido = 1 AND @POSCfgPOSCFGImpuestoIncluido = 1
SELECT  @Resultado = @Precio
ELSE IF @cfgImpuestoIncluido = 0 AND @POSCfgPOSCFGImpuestoIncluido = 0
SELECT  @Resultado = @Precio
ELSE IF @cfgImpuestoIncluido = 1 AND @POSCfgPOSCFGImpuestoIncluido = 0
SELECT @Resultado = dbo.fnPOSPrecioSinImpuestos(@Precio,@Impuesto1,@Impuesto2,@Impuesto3)
ELSE IF @cfgImpuestoIncluido = 0 AND @POSCfgPOSCFGImpuestoIncluido = 1
SELECT @Resultado = dbo.fnPOSPrecioConImpuestos(@Precio,@Impuesto1,@Impuesto2,@Impuesto3, @Empresa)
RETURN (ROUND(@Resultado,@RedondeoMonetarios))
END

