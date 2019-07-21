SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVariableGet
@Estacion	int,
@Variable	varchar(100),
@ValorChar	varchar(255)	= NULL OUTPUT,
@ValorInt	int		= NULL OUTPUT,
@ValorFloat	float		= NULL OUTPUT,
@ValorDateTime	datetime	= NULL OUTPUT,
@ValorBit	bit		= NULL OUTPUT

AS BEGIN
SELECT @ValorChar = ValorChar,
@ValorInt = ValorInt,
@ValorFloat = ValorFloat,
@ValorDateTime = ValorDateTime,
@ValorBit = ValorBit
FROM Variable
WHERE Estacion = @Estacion
AND Variable = @Variable
END

