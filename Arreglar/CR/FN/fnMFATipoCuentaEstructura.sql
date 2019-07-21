SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnMFATipoCuentaEstructura (@Cuenta varchar(20))
RETURNS varchar(50)

AS BEGIN
DECLARE
@Tipo					varchar(20),
@Resultado			varchar(50),
@Rama					varchar(20)
SELECT @Tipo = ISNULL(RTRIM(Tipo), ''), @Rama = ISNULL(RTRIM(Rama), '') FROM Cta WHERE Cuenta = @Cuenta
IF NOT EXISTS(SELECT Cuenta FROM Cta WHERE Cuenta = @Rama) AND @Rama <> ''
SET @Resultado = NULL
ELSE
SET @Resultado = dbo.fnMFATipoCuenta(dbo.fnMFACuentaEstructura(@Cuenta))
RETURN @Resultado
END

