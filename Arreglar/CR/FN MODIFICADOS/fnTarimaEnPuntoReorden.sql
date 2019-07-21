SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnTarimaEnPuntoReorden (@Empresa varchar(5), @Almacen varchar(10), @Tarima varchar(20), @Articulo varchar(20))
RETURNS bit

AS BEGIN
DECLARE
@Resultado		bit,
@MinimoTarima	float,
@Existencia		float,
@Posicion		varchar(10),
@PosicionTipo	varchar(20)
SELECT @Resultado = 0
SELECT @Posicion = t.Posicion,
@PosicionTipo = ap.Tipo
FROM Tarima t WITH(NOLOCK)
JOIN AlmPos ap WITH(NOLOCK) ON ap.Almacen = @Almacen AND ap.Posicion = t.Posicion
WHERE t.Tarima = @Tarima
IF UPPER(@PosicionTipo) = 'DOMICILIO'
BEGIN
SELECT @MinimoTarima = NULL
SELECT @MinimoTarima = NULLIF(MinimoTarima, 0.0) FROM ArtAlm WITH(NOLOCK) WHERE Articulo = @Articulo AND Almacen = @Almacen
IF @MinimoTarima IS NULL
SELECT @MinimoTarima = MinimoTarima FROM Art WITH(NOLOCK) WHERE Articulo = @Articulo
SELECT @Existencia = dbo.fnExistenciaDeTarima(@Empresa, @Almacen, @Tarima, @Articulo)
IF ISNULL(@Existencia, 0.0) = 0.0 OR (ISNULL(@Existencia, 0.0) < ISNULL(@MinimoTarima, 0.0)) SELECT @Resultado = 1
END
RETURN(@Resultado)
END

