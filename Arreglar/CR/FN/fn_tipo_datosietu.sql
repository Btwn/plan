SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fn_tipo_datosietu (@tipo_aplicacion varchar(50))
RETURNS smallint
AS BEGIN
RETURN
CASE LOWER(@tipo_aplicacion)
WHEN 'cobro'	THEN 1
WHEN 'pago'	THEN 2
ELSE NULL
END
END

