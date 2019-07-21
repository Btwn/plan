SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSFacturaCreditoCobro
@ID				varchar(36)

AS
BEGIN
DECLARE
@Empresa								varchar(5),
@Condicion								varchar(50),
@CfgFacturaCobroIntegradoParcial		bit,
@FacturaCobroIntegradoParcial			bit,
@Resultado								bit
SELECT @CfgFacturaCobroIntegradoParcial = 0, @FacturaCobroIntegradoParcial = 0, @Resultado = 0
SELECT @Empresa=Empresa, @Condicion=Condicion
FROM POSL WITH (NOLOCK)
WHERE ID = @ID
SELECT @CfgFacturaCobroIntegradoParcial = FacturaCobroIntegradoParcial
FROM EmpresaCfg2 WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @FacturaCobroIntegradoParcial = FacturaCobroIntegradoParcial
FROM Condicion WITH (NOLOCK)
WHERE Condicion = @Condicion
IF @CfgFacturaCobroIntegradoParcial = 1 AND @FacturaCobroIntegradoParcial = 1
SELECT @Resultado = 1
SELECT @Resultado
END

