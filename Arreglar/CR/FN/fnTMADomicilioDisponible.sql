SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnTMADomicilioDisponible (@Empresa varchar(5), @Almacen varchar(10), @Articulo varchar(20), @TMAID int, @Tarima varchar(20))
RETURNS varchar(20)

AS BEGIN
DECLARE
@Resultado		varchar(20),
@Posicion		varchar(20)
SELECT @Resultado = NULL
SELECT @Resultado = MIN(ap.Posicion)
FROM AlmPos ap
WHERE ap.Almacen = @Almacen AND ap.ArticuloEsp = @Articulo AND UPPER(ap.Tipo) = 'DOMICILIO' AND ap.Estatus = 'ALTA'
AND ap.Posicion NOT IN (SELECT PosicionDestino FROM TMAD WHERE ID = @TMAID)
AND dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, ap.Posicion, @Articulo, @TMAID, 0) = 1
/*
IF @Resultado IS NULL
BEGIN
SELECT @Resultado = MIN(ap.Posicion)
FROM AlmPos ap
JOIN Tarima t ON t.Almacen = ap.Almacen AND t.Posicion = ap.Posicion AND t.Estatus = 'ALTA'
WHERE ap.Almacen = @Almacen AND ap.ArticuloEsp = @Articulo AND UPPER(ap.Tipo) = 'DOMICILIO' AND ap.Estatus = 'ALTA'
AND ap.Posicion NOT IN (SELECT PosicionDestino FROM TMAD WHERE ID = @TMAID)
AND ISNULL(ap.TipoTarimaEsp, '') = ISNULL(ISNULL(@TipoEspecial, ap.TipoTarimaEsp), '')
AND dbo.fnTarimaEnPuntoReorden(@Empresa, @Almacen, t.Tarima, @Articulo) = 1
END
*/
RETURN(@Resultado)
END

