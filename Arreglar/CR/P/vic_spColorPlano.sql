SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE vic_spColorPlano
@Plano                          varchar(15),
@Accion                         varchar(50),
@Valor                          varchar(200),
@TD                             char(1), 
@Prom                           varchar(50) = null,
@Color1                         int OUTPUT,
@Leyenda1                       varchar(200) OUTPUT

AS BEGIN
DECLARE
@Orden                      int,
@Color                      int,
@Leyenda                    varchar(200),
@Expresion                  varchar(1000),
@Bandera                    bit,
@query                      varchar(max),
@FechaValor                 datetime,
@FechaProm                  datetime,
@FechaV                     varchar(15),
@FechaP                     varchar(15),
@Plano_Temp                 varchar(15),
@Nombre_Temp                varchar(50),
@AplicaProm                 bit
CREATE TABLE #ColorTemp (
Color                       int,
Leyenda                     varchar(200)
)
SELECT @TD = UPPER(@TD)
DECLARE crEvaluaExpresion CURSOR LOCAL STATIC
FOR
SELECT pad.Orden,
pad.Color,
pad.LeyendaColor,
Expresion = UPPER(pad.Expresion)
FROM vic_PlanoAcciones pa
JOIN vic_PlanoAccionesDef pad ON pa.Plano = pa.Plano
AND pa.Nombre = pad.Nombre
WHERE pa.Plano = @Plano
AND pa.Plano = pad.Plano
AND pa.Nombre = @Accion ORDER BY Orden
OPEN crEvaluaExpresion
FETCH NEXT FROM crEvaluaExpresion INTO @Orden, @Color, @Leyenda, @Expresion
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Prom =ISNULL(@Prom,'')
IF @TD = 'E' OR @TD = 'D'
BEGIN
BEGIN TRY
SELECT @Expresion = REPLACE(@Expresion, 'VALOR', @Valor)
SELECT @Expresion = REPLACE(@Expresion, 'PROM', @Prom)
SELECT @query = 'BEGIN TRY IF('+ISNULL(@Expresion,'')+')   ' +
'INSERT INTO #ColorTemp (Color, Leyenda) VALUES ('+convert(varchar,@Color)+','+''''+ISNULL(@Leyenda,'')+''') END TRY BEGIN CATCH END CATCH'
EXEC(@query)
END TRY
BEGIN CATCH
END CATCH
END
IF @TD = 'F'
BEGIN
BEGIN TRY
SELECT @FechaValor = convert(datetime, @Valor)
IF ISNULL(@Prom,'') <> ''  SELECT @FechaProm = convert(datetime, @Prom)
SELECT @FechaV = CONVERT(VARCHAR, @FechaValor, 103)
SELECT @FechaP = CONVERT(VARCHAR, @FechaProm, 103)
SELECT @Expresion = REPLACE(@Expresion, 'VALOR', ''''+@FechaV+'''')
SELECT @Expresion = REPLACE(@Expresion, 'PROM', ''''+@FechaP+'''')
SELECT @query = 'BEGIN TRY IF('+ISNULL(@Expresion,'')+')   ' +
'INSERT INTO #ColorTemp (Color, Leyenda) VALUES ('+convert(varchar,@Color)+','+''''+ISNULL(@Leyenda,'')+''') END TRY BEGIN CATCH END CATCH'
EXEC(@query)
END TRY
BEGIN CATCH
END CATCH
END
IF @TD = 'T'
BEGIN
BEGIN TRY
SELECT @Expresion = REPLACE(@Expresion, 'VALOR', ''''+UPPER(@Valor)+'''')
IF @Prom IS NOT NULL SELECT @Expresion = REPLACE(@Expresion, 'PROM', ''''+@Prom+'''')
SELECT @query = 'BEGIN TRY  IF('+ISNULL(@Expresion,'')+')   ' +
'INSERT INTO #ColorTemp (Color, Leyenda) VALUES ('+convert(varchar,@Color)+','+''''+ISNULL(@Leyenda,'')+''') END TRY BEGIN CATCH END CATCH'
EXEC(@query)
END TRY
BEGIN CATCH
END CATCH
END
END
FETCH NEXT FROM crEvaluaExpresion INTO @Orden, @Color, @Leyenda, @Expresion
END
CLOSE crEvaluaExpresion
DEALLOCATE crEvaluaExpresion
SET @Color1 = (SELECT Top 1 Color FROM #ColorTemp)
SET @Leyenda1 = (SELECT Top 1 Leyenda FROM #ColorTemp)
RETURN
END

