SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSSeparadorCodigoExtendido
@Caracter			varchar(1),
@Mascara			varchar(50),
@CodigoExtendido	varchar(50),
@Decimales			int,
@Codigo				varchar(50) OUTPUT

AS
BEGIN
DECLARE
@MascaraReverso		varchar(50),
@CodigoReverso		varchar(50),
@LargoMascara		int,
@PrimerCaracter		int,
@UltimoCaracter		int
IF NULLIF(@Decimales,0) IS NULL
SELECT @Decimales = 0
SELECT @MascaraReverso = REVERSE(@Mascara),
@LargoMascara = LEN(@Mascara)
SELECT @PrimerCaracter = CHARINDEX(@Caracter, @Mascara)
SELECT @UltimoCaracter = @LargoMascara - CHARINDEX(@Caracter, @MascaraReverso)
SELECT @Codigo = SUBSTRING(@CodigoExtendido, @PrimerCaracter, @UltimoCaracter + 2 - @PrimerCaracter)
IF @Decimales >=1
BEGIN
SELECT @CodigoReverso = REVERSE(@Codigo)
SELECT @Codigo = SUBSTRING(@CodigoReverso, 1, @Decimales) + '.' + SUBSTRING(@CodigoReverso, @Decimales + 1, LEN(@CodigoReverso))
SELECT @Codigo = REVERSE(@Codigo)
END
END

