SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnFechaTrabajo
(
@Empresa				varchar(5),
@Sucursal				int
)
RETURNS datetime

AS BEGIN
DECLARE
@Resultado				datetime
SELECT @Resultado = FechaTrabajo
FROM FechaTrabajo
WHERE Empresa = @Empresa AND Sucursal = @Sucursal
IF @Resultado IS NULL
BEGIN
SELECT @Resultado = dbo.fnFechaSinHora(GETDATE())
END
RETURN (@Resultado)
END

