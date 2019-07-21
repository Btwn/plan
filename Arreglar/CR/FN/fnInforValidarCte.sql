SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnInforValidarCte
(
@NombreCorto                                                  varchar(20)
)
RETURNS varchar(100)

AS BEGIN
DECLARE
@Resultado   varchar(100)
SET @Resultado = NULL
IF NULLIF(@NombreCorto,'') IS NULL
SELECT @Resultado = 'El campo Nombre Corto debe tener valor'
RETURN (@Resultado)
END

