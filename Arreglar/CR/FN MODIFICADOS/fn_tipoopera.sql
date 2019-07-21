SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fn_tipoopera (@origen_modulo varchar(50), @iva_excento bit, @iva_tasa float, @entidad_tipo_tercero varchar(50), @concepto_es_importacion float, @tipo_documento varchar(50))
RETURNS smallint
AS BEGIN
DECLARE
@resultado smallint
IF @entidad_tipo_tercero = 'extranjero' AND ISNULL(@concepto_es_importacion, 0) = 1 AND ROUND(ISNULL(@iva_tasa, 0), 2)  = 16
SELECT @resultado = 1
ELSE IF @entidad_tipo_tercero = 'extranjero' AND ISNULL(@concepto_es_importacion, 0) = 1 AND ROUND(ISNULL(@iva_tasa, 0), 2)  = 11
SELECT @resultado = 9
ELSE IF @entidad_tipo_tercero = 'extranjero' AND ISNULL(@concepto_es_importacion, 0) = 1 AND ROUND(ISNULL(@iva_tasa, 0), 2)  = 0
SELECT @resultado = 10
ELSE
BEGIN
IF ISNULL(@iva_excento, 0) = 1
SELECT @resultado = 3 
ELSE
IF @tipo_documento IN('nota_credito', 'devolucion') AND @origen_modulo IN('COMS', 'CXP', 'GAS')
SELECT @resultado = 8
ELSE
SELECT @resultado =
CASE ROUND(ISNULL(@iva_tasa, 0), 2)
WHEN 16.0 THEN 6
WHEN 11.0 THEN 7
WHEN 0.0  THEN 2
ELSE 4 
END
END
RETURN @resultado
END

