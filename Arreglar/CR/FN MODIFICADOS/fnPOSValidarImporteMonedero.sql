SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSValidarImporteMonedero (
@ID				varchar(36),
@Estacion		int,
@Disponible		float
)
RETURNS varchar(100)

AS
BEGIN
DECLARE
@Resultado  varchar(100),
@Puntos     float
SELECT @Puntos = SUM(Puntos)
FROM POSOfertaTemp WITH(NOLOCK)
WHERE IDR = @ID AND Estacion = @Estacion AND ID IN(SELECT ID FROM ListaID WITH(NOLOCK) WHERE Estacion = @Estacion)
IF @Puntos > @Disponible
SELECT @Resultado = 'La Cantidad  a Aplicar es Mayor Al Saldo Disponible '
ELSE
SELECT @Resultado = NULL
RETURN (@Resultado)
END

