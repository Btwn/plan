SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVariablePut
@Estacion	int,
@Variable	varchar(100),
@ValorChar	varchar(255)	= NULL,
@ValorInt	int		= NULL,
@ValorFloat	float		= NULL,
@ValorDateTime	datetime	= NULL,
@ValorBit	bit		= NULL,
@Inc		bit		= 0

AS BEGIN
UPDATE Variable
SET ValorChar     = @ValorChar,
ValorInt      = CASE WHEN @Inc = 1 THEN NULLIF(ISNULL(ValorInt, 0.0) + @ValorInt, 0.0) ELSE @ValorInt END,
ValorFloat    = CASE WHEN @Inc = 1 THEN NULLIF(ISNULL(ValorFloat, 0.0) + @ValorFloat, 0.0) ELSE @ValorFloat END,
ValorDateTime = @ValorDateTime,
ValorBit = @ValorBit
WHERE Estacion = @Estacion
AND Variable = @Variable
IF @@ROWCOUNT = 0
INSERT Variable
(Estacion,  Variable,  ValorChar,  ValorInt,  ValorFloat,  ValorDateTime,  ValorBit)
VALUES (@Estacion, @Variable, @ValorChar, @ValorInt, @ValorFloat, @ValorDateTime, @ValorBit)
END

