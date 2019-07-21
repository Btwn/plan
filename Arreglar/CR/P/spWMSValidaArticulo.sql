SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSValidaArticulo
@ID            int

AS BEGIN
DECLARE
@Articulo             varchar(20),
@CantidadCamaTarima   float,
@CamasTarima          float
DECLARE @TablaArt TABLE (
Articulo             varchar(20)
)
DECLARE crArticuloVal CURSOR FOR
SELECT Articulo
FROM INVD
WHERE ID = @ID
OPEN crArticuloVal
FETCH NEXT FROM crArticuloVal INTO @Articulo
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @CantidadCamaTarima = CantidadCamaTarima,
@CamasTarima        = CamasTarima
FROM Art
WHERE Articulo = @Articulo
IF @CantidadCamaTarima IS NULL AND @CamasTarima IS NULL
INSERT @TablaArt SELECT @Articulo
FETCH NEXT FROM crArticuloVal INTO @Articulo
END
CLOSE crArticuloVal
DEALLOCATE crArticuloVal
IF EXISTS (SELECT * FROM @TablaArt)
BEGIN
SELECT TOP 1 Articulo FROM @TablaArt
END
ELSE
BEGIN
SELECT '0'
END
END

