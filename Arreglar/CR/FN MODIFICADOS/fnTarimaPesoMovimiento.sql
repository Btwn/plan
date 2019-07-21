SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnTarimaPesoMovimiento(
@ID			int,
@Tarima		varchar(20)
)
RETURNS float
AS
BEGIN
DECLARE @Peso		float
SELECT @Peso = SUM(td.CantidadUnidad*ISNULL(a.Peso,1))
FROM ArtDisponibleTarima adt JOIN TMAD td WITH(NOLOCK) ON adt.Almacen = td.Almacen AND adt.Tarima = td.Tarima
JOIN TMA t WITH(NOLOCK) ON td.ID = t.ID JOIN Art a WITH(NOLOCK) ON adt.Articulo = a.Articulo
WHERE adt.Empresa = t.Empresa AND td.Tarima = @Tarima AND t.Estatus <> 'CANCELADO' AND t.ID = @ID
RETURN ISNULL(@Peso, 0)
END

