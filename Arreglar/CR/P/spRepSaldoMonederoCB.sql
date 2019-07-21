SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRepSaldoMonederoCB
@MonederoCB	varchar(20),
@Empresa	varchar(5)

AS
BEGIN
SELECT 'MONEDEROCB'	= Cuenta,
'SALDOMCB'	= ISNULL(Saldo,0),
'MONEDAMCB'	= Moneda
FROM SaldoPMon
WHERE Empresa = @Empresa
AND Rama = 'MONEL'
AND Grupo = 'ME'
AND Cuenta = @MonederoCB
END

