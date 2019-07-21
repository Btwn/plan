SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnSerieLoteConsignacionCorteVerificado
(
@Estacion				int,
@Modulo					varchar(20),
@ModuloID				int
)
RETURNS bit

AS BEGIN
DECLARE
@Resultado	bit
SET @Resultado = 1
IF EXISTS(SELECT slca.Empresa
FROM SerieLoteConsignacionAuxTemp slcat JOIN SerieLoteConsignacionAux slca
ON slca.RID = slcat.RIDOriginal AND slca.SerieLote = slcat.SerieLote AND ISNULL(slca.SubCuenta,'') = ISNULL(slcat.SubCuenta,'') AND slca.Articulo = slcat.Articulo AND slca.OModuloID = slcat.OModuloID AND slca.OModulo = slcat.OModulo AND slca.OModulo = slcat.OModulo
WHERE (ISNULL(slca.CorteID,0) <> ISNULL(slcat.CorteID,0) OR ISNULL(slca.CorteIDAnterior,0) <> ISNULL(slcat.CorteIDAnterior,0))
AND slcat.ModuloID = @ModuloID
AND slcat.Modulo = @Modulo
AND slcat.Estacion = @Estacion)
SET @Resultado = 0
RETURN (@Resultado)
END

