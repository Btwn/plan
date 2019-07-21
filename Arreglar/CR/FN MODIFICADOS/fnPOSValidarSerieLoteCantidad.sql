SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSValidarSerieLoteCantidad (
@Sucursal   int,
@Articulo   varchar(20),
@SubCuenta  varchar(50),
@SerieLote  varchar(50),
@Cantidad   float
)
RETURNS bit

AS
BEGIN
DECLARE
@Resultado  bit
SELECT @Resultado    = 1
IF NOT EXISTS(SELECT * FROM SerieLote WITH(NOLOCK) WHERE SerieLote = @SerieLote AND Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
AND Existencia >=@Cantidad)
SELECT @Resultado = 0
RETURN (@Resultado)
END

