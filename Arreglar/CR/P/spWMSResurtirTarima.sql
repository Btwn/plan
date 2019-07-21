SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSResurtirTarima
@Tarima				varchar(20),
@Ok					int	= NULL	OUTPUT,
@OkRef				varchar(255) = NULL	OUTPUT

AS BEGIN
DECLARE
@Articulo				varchar(20),
@CantidadACancelar		int
DECLARE crResurtirTarima CURSOR LOCAL FOR
SELECT Articulo, Cantidad
FROM dbo.fnWMSEnSurtidoACancelarPorArticulo(@Tarima)
OPEN crResurtirTarima
FETCH NEXT FROM crResurtirTarima INTO @Articulo, @CantidadACancelar
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
EXEC spWMSResurtidoArticulo @Tarima, @Articulo, @CantidadACancelar, @Ok OUTPUT, @OkRef OUTPUT
FETCH NEXT FROM crResurtirTarima INTO @Articulo, @CantidadACancelar
END
CLOSE crResurtirTarima
DEALLOCATE crResurtirTarima
RETURN
END

