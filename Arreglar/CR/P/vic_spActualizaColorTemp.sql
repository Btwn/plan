SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE vic_spActualizaColorTemp

AS BEGIN
DECLARE
@Estacion                   int,
@Plano                      varchar(15),
@Accion                     varchar(50),
@AplicaProm                 bit,
@Promedio                   varchar(12),
@Valor                      varchar(200),
@Color                      int,
@Leyenda                    varchar(200),
@TD                         varchar(1),
@Elemento                   varchar(200),
@xyz int
SELECT * INTO #Plano FROM vic_planotemp
DECLARE crEvaluaTemp CURSOR LOCAL STATIC
FOR
SELECT DISTINCT estacion, plano, nombre
FROM #Plano
OPEN crEvaluaTemp
FETCH NEXT FROM crEvaluaTemp INTO @Estacion, @Plano, @Accion
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @AplicaProm = ISNULL(AplicaProm, 0)
FROM vic_planoacciones
WHERE Plano = @Plano AND Nombre = @Accion
IF ISNULL(@AplicaProm,0) = 1
BEGIN
BEGIN TRY
SELECT @Promedio = CONVERT(varchar, ROUND(AVG(convert(float,ISNULL(Valor_color,0))),2))
FROM #Plano
WHERE Estacion = @Estacion AND Plano = @Plano AND Nombre = @Accion
END TRY
BEGIN CATCH
SET @Promedio=NULL
END CATCH
END
IF ISNULL(@AplicaProm,0) = 1 AND @Promedio IS NULL
BEGIN
BEGIN TRY
IF ISNULL(@AplicaProm,0) = 1
SELECT @Promedio = CONVERT(varchar, AVG(convert(money,ISNULL(Valor_color,0))))
FROM #Plano
WHERE Estacion = @Estacion AND Plano = @Plano AND Nombre = @Accion
END TRY
BEGIN CATCH
SET @Promedio='0'
END CATCH
END
DECLARE crEvaluaExpresion CURSOR LOCAL STATIC
FOR
SELECT Elemento, Valor_color
FROM #Plano
WHERE Estacion = @Estacion
AND Plano = @Plano
AND Nombre = @Accion
OPEN crEvaluaExpresion
FETCH NEXT FROM crEvaluaExpresion INTO @Elemento, @Valor
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF ISNULL(@AplicaProm,0) = 1
BEGIN
BEGIN TRY
SELECT @Valor = CONVERT(VARCHAR, CONVERT(FLOAT, ISNULL(@Valor,0)))
END TRY
BEGIN CATCH
SELECT @Valor = REPLACE(@Valor,'.', '')
SELECT @Valor = REPLACE(@Valor,',', '.')
END CATCH
SET @TD='D'
END
ELSE IF @Valor like '%'+convert(varchar, year(getdate()))+'%'
SELECT @TD='F', @Promedio=''
ELSE IF dbo.fnEsIntegro (@valor) = 1 SET @TD = 'E' ELSE SET @TD='T'
EXEC vic_spColorPlano @Plano, @Accion, @Valor, @TD, @Promedio, @Color OUTPUT, @Leyenda OUTPUT
IF @Color IS NULL AND @Leyenda IS NOT NULL
UPDATE #Plano
SET Descripcion = @Leyenda,
Color = 255,
Valor_color = @Valor
WHERE Plano = @Plano
AND Elemento = @Elemento
AND Nombre=@Accion
ELSE IF @Leyenda IS NULL AND @Color IS NOT NULL
UPDATE #Plano
SET Descripcion = 'Vacio',
Color = @Color,
Valor_color=@Valor
WHERE Plano = @Plano
AND Elemento = @Elemento
AND Nombre=@Accion
ELSE IF @Leyenda IS NULL AND @Color IS NULL
UPDATE #Plano
SET Descripcion = 'Vacio',
Color = 255,
Valor_color = @Valor
WHERE Plano = @Plano
AND Elemento = @Elemento
AND Nombre=@Accion
ELSE
UPDATE #Plano
SET Descripcion = @Leyenda,
Color = @Color,
Valor_color=@Valor
WHERE Plano = @Plano
AND Elemento = @Elemento
AND Nombre=@Accion
END
FETCH NEXT FROM crEvaluaExpresion INTO @Elemento, @Valor
END
CLOSE crEvaluaExpresion
DEALLOCATE crEvaluaExpresion
END
FETCH NEXT FROM crEvaluaTemp INTO  @Estacion, @Plano, @Accion
END
CLOSE crEvaluaTemp
DEALLOCATE crEvaluaTemp
update p
set p.Descripcion    = t.Descripcion,
p.Color          = t.Color,
p.Valor_color    = t.Valor_color
from vic_planotemp p
join #Plano t ON p.plano = t.Plano AND p.elemento = t.elemento AND p.Nombre = t.Nombre
RETURN
END

