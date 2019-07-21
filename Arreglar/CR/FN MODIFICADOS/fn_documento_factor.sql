SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fn_documento_factor (@origen_modulo varchar(50), @tipo_documento varchar(50))
RETURNS float
AS BEGIN
DECLARE
@resultado float
IF (LOWER(@tipo_documento) IN ('nota_credito', /*'anticipo',*/ 'devolucion') and @origen_modulo IN('CXC', 'VTAS') OR (LOWER(@tipo_documento) IN ('nota_credito') and @origen_modulo IN('CXP')))
SELECT @resultado = -1.0
ELSE
SELECT @resultado = 1.0
RETURN @resultado
END

