SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnMovOpcionEncabezado
(
@Opcion			varchar(1)
)
RETURNS varchar(100)

AS BEGIN
DECLARE
@Resultado		varchar(100)
SET @Resultado = ''
SELECT @Resultado = ISNULL(DescripcionCorta,'Opci�n ' + @Opcion) FROM Opcion WITH(NOLOCK) WHERE Opcion = @Opcion
RETURN @Resultado
END

