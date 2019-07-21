SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerPVPrecioJuego
@Empresa          char(5),
@Sucursal         int,
@ListaPrecios     char(20),
@Articulo         char(20),
@Juego            char(10),
@Componente       char(20),
@MovMoneda        char(10),
@MovTipoCambio    float

AS
BEGIN
DECLARE
@PrecioIndependiente    bit,
@ListaPreciosEsp        char(20),
@Precio                 money,
@Tipo		    varchar(20)
SELECT @Componente = NULLIF(RTRIM(@Componente), ''), @Tipo = NULL
IF @Componente IS NULL BEGIN
EXEC spPCGet @Sucursal, @Empresa, @Articulo, NULL, NULL, @MovMoneda, @MovTipoCambio,
@ListaPreciosEsp, @Precio OUTPUT, 0
END ELSE BEGIN
SELECT @Tipo = Tipo
FROM Art a
WHERE a.Articulo = @Componente
SELECT @PrecioIndependiente = ISNULL(aj.PrecioIndependiente, 0),
@ListaPreciosEsp = NULLIF(RTRIM(aj.ListaPreciosEsp), '')
FROM Art a
JOIN ArtJuego aj ON a.Articulo = aj.Articulo
JOIN ArtJuegoD ajd ON aj.Articulo = ajd.Articulo AND aj.Juego = ajd.Juego
WHERE a.Articulo = @Articulo
AND aj.Juego = @Juego
AND ajd.Opcion = @Componente
IF @PrecioIndependiente = 1 BEGIN
IF @ListaPreciosEsp IS NULL
SELECT @ListaPreciosEsp = @ListaPrecios
EXEC spPCGet @Sucursal, @Empresa, @Componente, NULL, NULL, @MovMoneda, @MovTipoCambio,
@ListaPreciosEsp, @Precio OUTPUT, 0
END ELSE
SELECT @Precio = 0
END
SELECT "Precio" = @Precio, "Tipo" = @Tipo
RETURN
END

