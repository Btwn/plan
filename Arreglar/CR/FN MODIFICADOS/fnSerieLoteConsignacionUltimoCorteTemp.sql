SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnSerieLoteConsignacionUltimoCorteTemp
(
@Estacion				int,
@Modulo					varchar(20),
@ModuloID				int
)
RETURNS int

AS BEGIN
DECLARE
@Resultado				int
SELECT TOP 1
@Resultado = NULLIF(CorteID,0)
FROM SerieLoteConsignacionAuxTemp WITH(NOLOCK)
WHERE ModuloID = @ModuloID
AND Modulo = @Modulo
AND Estacion = @Estacion
AND CorteID NOT IN (SELECT CorteIDAnterior FROM SerieLoteConsignacionAuxTemp WITH(NOLOCK) WHERE ModuloID = @ModuloID AND Modulo = @Modulo AND Estacion = @Estacion AND CorteID IS NOT NULL)
AND CorteID IS NOT NULL
RETURN (@Resultado)
END

