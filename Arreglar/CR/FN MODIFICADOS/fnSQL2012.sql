SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnSQL2012 ()
RETURNS bit

AS BEGIN
DECLARE
@Resultado bit
SELECT @Resultado = 0
IF substring(@@version, 1, 25) IN ('Microsoft SQL Server 2012', 'Microsoft SQL Server 2014', 'Microsoft SQL Server 2016')
SELECT @Resultado = 1
RETURN(@Resultado)
END

