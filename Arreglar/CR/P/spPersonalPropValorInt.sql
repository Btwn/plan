SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPersonalPropValorInt
@Empresa	char(5),
@Sucursal	int,
@Categoria	varchar(50),
@Puesto		varchar(50),
@Personal	char(10),
@Propiedad	varchar(50),
@Valor		int 	OUTPUT,
@SinError	bit	= 0

AS BEGIN
DECLARE
@ValorSt	varchar(50)
EXEC spPersonalPropValor @Empresa, @Sucursal, @Categoria, @Puesto, @Personal, @Propiedad, @ValorSt OUTPUT, @SinError
SELECT @Valor = 0
IF dbo.fnEsNumerico(@ValorSt) = 1
SELECT @Valor = ISNULL(CONVERT(int, @ValorSt), 0)
END

