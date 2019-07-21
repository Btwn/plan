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
SELECT 'L�mite de Cr�dito' = CreditoLimite,
'L�mite de Cr�dito (Pedidos)' = CreditoLimitePedidos,
'Cr�dito Moneda' = CreditoMoneda,
'Cr�dito D�as' = CreditoDias,
'Cr�dito Condiciones' = CreditoCondiciones
FROM Cte WITH (NOLOCK)
WHERE Cliente = @Cliente
AND CreditoEspecial = 1
RETURN
END

