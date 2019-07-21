SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fneDocCompilar
(
@Modulo				varchar(5),
@eDoc				varchar(50)
)
RETURNS bit

AS BEGIN
DECLARE
@Resultado					bit,
@UltimoCambio				datetime,
@UltimaCompilacion			datetime
SELECT @UltimoCambio = UltimoCambio, @UltimaCompilacion = UltimaCompilacion FROM eDoc WHERE Modulo = @Modulo AND eDoc = @eDoc
IF @UltimoCambio = @UltimaCompilacion
SET @Resultado = 0
ELSE
SET @Resultado = 1
IF (SELECT ISNULL(COUNT(1),0) FROM eDocCompilacion WHERE Modulo = @Modulo AND eDoc = @eDoc) = 0 SET @Resultado = 1 
RETURN (@Resultado)
END

