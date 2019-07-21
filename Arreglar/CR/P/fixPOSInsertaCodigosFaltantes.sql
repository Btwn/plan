SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE fixPOSInsertaCodigosFaltantes

AS
BEGIN
DECLARE
@Articulo		varchar(20),
@Unidad			varchar(50),
@Bandera		bit
DECLARE crSE1 CURSOR LOCAL FOR
SELECT RTRIM(LTRIM(Articulo)), Unidad
FROM Art with (nolock)
WHERE Estatus <> 'BAJA'
AND Tipo IN ('Normal', 'Servicio', 'Juego')
AND NULLIF(CategoriaActivoFijo,'') IS NULL
AND Articulo not in (SELECT CONVERT(VARCHAR,Orden)  FROM MovTipo WHERE Modulo = 'POS' )
OPEN crSE1
FETCH NEXT FROM crSE1 INTO @Articulo, @Unidad
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Bandera = 0
IF EXISTS (SELECT 1 FROM CB with (nolock) WHERE RTRIM(LTRIM(Codigo)) = @Articulo AND RTRIM(LTRIM(Cuenta)) <> @Articulo)
SELECT @Bandera = 1
IF @Bandera = 0
BEGIN
IF EXISTS (SELECT 1 FROM CB with (nolock) WHERE TipoCuenta = 'Articulos' AND RTRIM(LTRIM(Cuenta)) = @Articulo
AND RTRIM(LTRIM(Codigo)) = @Articulo)
UPDATE CB SET Cantidad = 1, Unidad = @Unidad WHERE TipoCuenta = 'Articulos' AND Cuenta = @Articulo AND Codigo = @Articulo
ELSE
INSERT INTO CB (
Codigo, TipoCuenta, Cuenta, Cantidad, Unidad)
VALUES (
@Articulo, 'Articulos', @Articulo, 1, @Unidad)
END
END
FETCH NEXT FROM crSE1 INTO @Articulo, @Unidad
END
CLOSE crSE1
DEALLOCATE crSE1
END

