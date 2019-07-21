SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSCalcDescVenta (
@ID       varchar(36)
)
RETURNS float

AS
BEGIN
DECLARE
@Resultado  float
SELECT @Resultado = -SUM(ISNULL(((Cantidad - ISNULL(CantidadObsequio,0)) * (Precio - (Precio * (ISNULL(DescuentoLinea,0)/100)))),0) * (CASE WHEN ISNULL(plv.AplicaDescGlobal, 1) = 1 THEN ISNULL(p.DescuentoGlobal,0.0) ELSE 0 END) /100)
FROM POSLVenta plv JOIN POSL p ON p.ID = plv.ID
WHERE p.ID = @ID
RETURN (@Resultado)
END

