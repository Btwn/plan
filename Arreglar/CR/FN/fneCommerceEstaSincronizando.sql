SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fneCommerceEstaSincronizando()
RETURNS bit

AS BEGIN
DECLARE
@Resultado bit
SELECT @Resultado = dbo.fnInformacionContexto('ECOMMERCE')
RETURN(@Resultado)
END

