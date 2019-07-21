SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnMFATipoCuenta (@Cuenta varchar(20))
RETURNS varchar(50)

AS BEGIN
DECLARE @tipo_cuenta varchar(50)
SELECT @tipo_cuenta = tipo FROM MFACtaEstructuraTipo WITH(NOLOCK) WHERE Cuenta = @Cuenta
RETURN @tipo_cuenta
END

