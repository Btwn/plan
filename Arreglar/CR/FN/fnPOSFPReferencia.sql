SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSFPReferencia (
@Codigo			varchar(30),
@Referencia		varchar(50)
)
RETURNS bit

AS
BEGIN
DECLARE
@Resultado            bit,
@RequiereReferencia   bit,
@FormaPago            varchar(50)
SELECT @FormaPago = FormaPago
FROM CB
WHERE CB.Codigo = @Codigo
SELECT @RequiereReferencia = ISNULL(RequiereReferencia,0)
FROM FormaPago
WHERE FormaPago = @FormaPago
SELECT @Resultado    = 0
IF @RequiereReferencia = 1 AND NULLIF(@Referencia,'') IS NULL
SELECT @Resultado = 1
RETURN (@Resultado)
END

