SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnPOSRegresaFormaPagoCambio (
@FormaPago		varchar(50),
@Empresa		varchar(5)
)
RETURNS varchar(50)

AS
BEGIN
IF (SELECT PermiteCambio FROM FormaPago WITH(NOLOCK) WHERE FormaPago = (SELECT FormaPago FROM CB WITH(NOLOCK) WHERE  TipoCuenta = 'Forma Pago' AND Codigo = @FormaPago) ) = 1
SELECT @FormaPago = DefFormaPagoCambio FROM POSCfg WITH(NOLOCK) WHERE Empresa = @Empresa
ELSE
SELECT @FormaPago = DefFormaPagoCambio FROM POSCfg WITH(NOLOCK) WHERE Empresa = @Empresa
RETURN(@FormaPago)
END

