SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCalcularVIN_ISAN

AS BEGIN
DECLARE
@Articulo		char(20),
@PrecioSinISAN	float,
@LimiteInferior	money,
@LimiteSuperior	money,
@Cuota		money,
@Porcentaje		float,
@ISAN		money,
@Cuantos		int,
@Ok			int,
@OkRef		varchar(255)
SELECT @Cuantos = 0, @Ok = NULL, @OkRef = NULL
BEGIN TRANSACTION
DECLARE crArt CURSOR FOR
SELECT Articulo, Precio2
FROM Art
WHERE Tipo = 'VIN' AND ISNULL(Precio2, 0) IS NOT NULL
OPEN crArt
FETCH NEXT FROM crArt INTO @Articulo, @PrecioSinISAN
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @LimiteInferior = ISNULL(LimiteInferior, 0),
@LimiteSuperior = ISNULL(LimiteSuperior, 0),
@Cuota          = ISNULL(Cuota, 0),
@Porcentaje     = ISNULL(Porcentaje, 0)
FROM TablaImpuestoD
WHERE TablaImpuesto = 'ISAN' AND PeriodoTipo = '(sin Periodo)'
AND @PrecioSinISAN BETWEEN LimiteInferior AND LimiteSuperior
IF @@ROWCOUNT = 0 SELECT @Ok = 1
SELECT @ISAN = ((@PrecioSinISAN-@LimiteInferior)*(@Porcentaje/100.0))+@Cuota
SELECT @LimiteInferior = ISNULL(LimiteInferior, 0),
@LimiteSuperior = ISNULL(LimiteSuperior, 0),
@Cuota          = ISNULL(Cuota, 0),
@Porcentaje     = ISNULL(Porcentaje, 0)
FROM TablaImpuestoD
WHERE TablaImpuesto = 'ISAN (Lujo)' AND PeriodoTipo = '(sin Periodo)'
AND @PrecioSinISAN BETWEEN LimiteInferior AND LimiteSuperior
IF @@ROWCOUNT > 0
SELECT @ISAN = @ISAN - ((@PrecioSinISAN-@LimiteInferior)*(@Porcentaje/100.0))+@Cuota
UPDATE Art
SET Precio3     = @ISAN,
PrecioLista = @PrecioSinISAN + @ISAN
WHERE CURRENT of crArt
SELECT @Cuantos = @Cuantos + 1
END
FETCH NEXT FROM crArt INTO @Articulo, @PrecioSinISAN
END  
CLOSE crArt
DEALLOCATE crArt
IF @Ok IS NULL
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
IF @Ok IS NULL SELECT @OkRef = RTRIM(Convert(char, @Cuantos))+' Precios Calculados.' ELSE
IF @Ok = 1     SELECT @OkRef = 'No Esta Correctamente Definida la Tabla de Impuestos: ISAN'
SELECT @OkRef
RETURN
END

