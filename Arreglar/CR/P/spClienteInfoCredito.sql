SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spClienteInfoCredito
@Cliente	char(10),
@Empresa	varchar(5) = NULL,
@Sucursal	int = NULL

AS BEGIN
SELECT 'Límite de Crédito' = CreditoLimite,
'Límite de Crédito (Pedidos)' = CreditoLimitePedidos,
'Crédito Moneda' = CreditoMoneda,
'Crédito Días' = CreditoDias,
'Crédito Condiciones' = CreditoCondiciones
FROM Cte
WHERE Cliente = @Cliente
AND CreditoEspecial = 1
RETURN
END

