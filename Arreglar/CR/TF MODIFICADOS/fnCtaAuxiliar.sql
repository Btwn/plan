SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCtaAuxiliar (@Cuenta varchar(20))
RETURNS @Auxiliar	TABLE(Cuenta	varchar(20), Tipo varchar(15))
AS
BEGIN
DECLARE
@Rama		char(20),
@Tipo		char(15),
@CuentaAnt	varchar(20)
IF ISNULL(@Cuenta, '') = ''
INSERT INTO @Auxiliar(Cuenta, Tipo) SELECT Cuenta, Tipo FROM Cta WITH (NOLOCK) WHERE Tipo = 'AUXILIAR'
ELSE
BEGIN
SELECT @Tipo = Tipo FROM Cta WITH (NOLOCK) WHERE Cuenta = @Cuenta
IF ISNULL(@Tipo, '') <> 'AUXILIAR'
BEGIN
INSERT INTO @Auxiliar(Cuenta, Tipo) SELECT Cuenta, Tipo FROM Cta WITH (NOLOCK) WHERE Rama = @Cuenta
SELECT @CuentaAnt = ''
WHILE(1=1)
BEGIN
SELECT @Cuenta = MIN(Cta.Cuenta)
FROM @Auxiliar Cta
WHERE Cta.Cuenta		> @CuentaAnt
AND Cta.Tipo	   <> 'AUXILIAR'
IF @Cuenta IS NULL BREAK
SELECT @CuentaAnt = @Cuenta
INSERT INTO @Auxiliar(Cuenta, Tipo) SELECT Cuenta, Tipo FROM Cta WITH (NOLOCK) WHERE Rama = @Cuenta
DELETE @Auxiliar WHERE Cuenta = @Cuenta
END
END
ELSE
INSERT INTO @Auxiliar(Cuenta, Tipo) SELECT Cuenta, Tipo FROM Cta WITH (NOLOCK) WHERE Cuenta = @Cuenta
END
RETURN
END

