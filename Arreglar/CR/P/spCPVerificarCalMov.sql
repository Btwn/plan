SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCPVerificarCalMov
@Modulo		char(5),
@ID			int,
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@ClavePresupuestal	varchar(50),
@Importe		money,
@Importe2		money,
@ImporteTotal	money
SELECT @ImporteTotal = 0.0
IF @Modulo = 'COMS'
DECLARE crCPVerificarCalMov CURSOR LOCAL FOR
SELECT ClavePresupuestal, SUM(Importe)
FROM CPCompra
WHERE ID = @ID
GROUP BY ClavePresupuestal
ORDER BY ClavePresupuestal
ELSE
IF @Modulo = 'GAS'
DECLARE crCPVerificarCalMov CURSOR LOCAL FOR
SELECT ClavePresupuestal, SUM(Importe)
FROM CPGasto
WHERE ID = @ID
GROUP BY ClavePresupuestal
ORDER BY ClavePresupuestal
ELSE
DECLARE crCPVerificarCalMov CURSOR LOCAL FOR
SELECT ClavePresupuestal, SUM(Importe)
FROM CPMovImpuesto
WHERE Modulo = @Modulo AND ModuloID = @ID
GROUP BY ClavePresupuestal
ORDER BY ClavePresupuestal
OPEN crCPVerificarCalMov
FETCH NEXT FROM crCPVerificarCalMov INTO @ClavePresupuestal, @Importe
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND NULLIF(RTRIM(@ClavePresupuestal), '') IS NOT NULL
BEGIN
SELECT @Importe2 = 0.0, @ImporteTotal = @ImporteTotal + @Importe
SELECT @Importe2 = ISNULL(SUM(Importe), 0.0)
FROM CPCalMov
WHERE Modulo = @Modulo AND ModuloID = @ID AND ClavePresupuestal = @ClavePresupuestal
IF ROUND(@Importe, 0) <> ROUND(@Importe2, 0)
SELECT @Ok = 25620, @OkRef = @ClavePresupuestal+'<BR>Diferencia '+CONVERT(varchar, @Importe-@Importe2)
END
FETCH NEXT FROM crCPVerificarCalMov INTO @ClavePresupuestal, @Importe
END
CLOSE crCPVerificarCalMov
DEALLOCATE crCPVerificarCalMov
IF @Ok IS NULL
BEGIN
SELECT @Importe2 = 0.0
SELECT @Importe2 = ISNULL(SUM(Importe), 0.0) FROM CPCalMov WHERE Modulo = @Modulo AND ModuloID = @ID
IF ROUND(@ImporteTotal, 0) <> ROUND(@Importe2, 0)
SELECT @Ok = 25630, @OkRef = 'Diferencia '+CONVERT(varchar, @ImporteTotal-@Importe2)
END
RETURN
END

