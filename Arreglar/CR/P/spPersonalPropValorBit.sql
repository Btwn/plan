SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPersonalPropValorBit
@Empresa	char(5),
@Sucursal	int,
@Categoria	varchar(50),
@Puesto		varchar(50),
@Personal	char(10),
@Propiedad	varchar(50),
@Valor		bit 	OUTPUT,
@SinError	bit	= 0

AS BEGIN
DECLARE
@ValorSt	varchar(50)
EXEC spPersonalPropValor @Empresa, @Sucursal, @Categoria, @Puesto, @Personal, @Propiedad, @ValorSt OUTPUT, @SinError
SELECT @Valor = 0
IF UPPER(SUBSTRING(@ValorSt, 1, 1)) IN ('S', 'Y')
SELECT @Valor = 1
END

