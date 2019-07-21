SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnPOSImporte(
@Cantidad			float,
@CantidadObsequio	float,
@Precio				float,
@DescuentoLinea		float,
@DescuentoGlobal	float,
@Articulo			varchar(20),
@Empresa			varchar(5)
)
RETURNS float

AS
BEGIN
DECLARE
@Importe			float,
@CodigoRedondeo		varchar(50),
@ArticuloRedondeo	varchar(20)
SELECT @CodigoRedondeo = pc.RedondeoVentaCodigo
FROM POSCfg pc WITH(NOLOCK)
WHERE pc.Empresa = @Empresa
SELECT @ArticuloRedondeo = Cuenta
FROM CB WITH(NOLOCK)
WHERE Codigo = @CodigoRedondeo
AND TipoCuenta = 'Articulos'
IF @Articulo = @ArticuloRedondeo
SELECT @DescuentoGlobal = 0
SELECT @Importe = (ISNULL(@Cantidad,0) - ISNULL(@CantidadObsequio,0)) * ISNULL(@Precio,0)
SELECT @Importe = @Importe - (@Importe * (ISNULL(@DescuentoLinea,0)/100))
SELECT @Importe = @Importe - (@Importe * (ISNULL(@DescuentoGlobal,0)/100))
RETURN(@Importe)
END

