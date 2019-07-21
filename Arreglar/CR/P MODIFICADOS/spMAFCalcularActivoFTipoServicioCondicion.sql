SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMAFCalcularActivoFTipoServicioCondicion
@AFArticulo		varchar(20),
@AFSerie		varchar(50),
@Indicador		varchar(50),
@Servicio		varchar(50),
@Lectura		varchar(100),
@Resultado		bit		OUTPUT,
@Operador		varchar(1)	OUTPUT,
@Automatico		bit,
@MAFCiclo			int		OUTPUT, 
@Ok			int		OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE	@Tipo		varchar(50),
@TipoDato	varchar(20),
@Condicion	varchar(20),
@Valor1		varchar(100),
@Valor2		varchar(100),
@Texto1		varchar(100),
@Texto2		varchar(100),
@Numerico1	float,
@Numerico2	float,
@Fecha1		datetime,
@Fecha2		datetime,
@Logico		bit,
@TextoL		varchar(100),
@NumericoL	float,
@FechaL		datetime,
@LogicoL	bit,
@FechaLimite	datetime
SET @MAFCiclo = NULL
SELECT @Tipo = Tipo FROM ActivoF WITH (NOLOCK)  WHERE Articulo = @AFArticulo AND Serie = @AFSerie
SELECT @TipoDato = TipoDato FROM ActivoFTipoIndicador  WITH (NOLOCK) WHERE Tipo = @Tipo AND Indicador = @Indicador
IF @Automatico = 1 AND @TipoDato = 'FECHA'
BEGIN
SET @Lectura = CONVERT(varchar,GETDATE())
END ELSE
BEGIN
IF @Automatico = 1 AND @TipoDato <> 'FECHA'
BEGIN
SET @Resultado = 0
SELECT @Operador = ISNULL(Operador,'') FROM ActivoFTipoServicioCondicion WITH (NOLOCK)  WHERE Tipo = @Tipo AND Servicio = @Servicio AND Indicador = @Indicador
RETURN
END
END
SELECT @Operador = ISNULL(Operador,''), @Condicion = Condicion, @Valor1 = Valor, @Valor2 = Valor2 FROM ActivoFTipoServicioCondicion  WITH (NOLOCK) WHERE Tipo = @Tipo AND Servicio = @Servicio AND Indicador = @Indicador
SELECT UPPER(RTRIM(LTRIM(Valor))) Valor INTO #ActivoFTipoIndicadorLista FROM ActivoFTipoIndicadorLista WITH (NOLOCK)  WHERE Tipo = @Tipo AND Indicador = @Indicador
IF UPPER(RTRIM(LTRIM(@Lectura))) NOT IN (SELECT Valor FROM #ActivoFTipoIndicadorLista) AND EXISTS(SELECT * FROM #ActivoFTipoIndicadorLista)
SELECT @Ok = 10060, @OkRef = 'Lectura incorrecta en el indicador ' + RTRIM(@Indicador) + '. Lectura:' + @Lectura
IF UPPER(RTRIM(LTRIM(@Valor1))) NOT IN (SELECT Valor FROM #ActivoFTipoIndicadorLista) AND EXISTS(SELECT * FROM #ActivoFTipoIndicadorLista) AND @Ok IS NULL
SELECT @Ok = 10060, @OkRef = 'Parámetro incorrecto en el indicador ' + RTRIM(@Indicador) + '. Parámetro:' + @Valor1
IF UPPER(RTRIM(LTRIM(@Valor2))) NOT IN (SELECT Valor FROM #ActivoFTipoIndicadorLista) AND EXISTS(SELECT * FROM #ActivoFTipoIndicadorLista) AND @Ok IS NULL
SELECT @Ok = 10060, @OkRef = 'Parámetro incorrecto en el indicador ' + RTRIM(@Indicador) + '. Parámetro:' + @Valor2
IF RTRIM(@TipoDato) = 'TEXTO' AND @Ok IS NULL
BEGIN
SET @Texto1 = LTRIM(RTRIM(UPPER(@Valor1)))
SET @Texto2 = LTRIM(RTRIM(UPPER(@Valor2)))
SET @TextoL = LTRIM(RTRIM(UPPER(@Lectura)))
IF @Condicion NOT IN ('IGUAL QUE','ENTRE','DIFERENTE QUE','MAYOR QUE','MENOR QUE','MAYOR O IGUAL QUE','MENOR O IGUAL QUE') AND @Ok IS NULL SELECT @Ok = 10060, @OkRef = 'Condición incorrecta en el indicador ' + RTRIM(@Indicador) + '. Condición:' + @Condicion
IF @Condicion = 'IGUAL QUE' AND @Ok IS NULL
BEGIN
IF @TextoL = @Texto1 SET @Resultado = 1 ELSE SET @Resultado = 0
END
IF @Condicion = 'ENTRE' AND @Ok IS NULL
BEGIN
IF @TextoL >= @Texto1 AND @TextoL <= @Texto2 SET @Resultado = 1 ELSE SET @Resultado = 0
END
IF @Condicion = 'DIFERENTE QUE' AND @Ok IS NULL
BEGIN
IF @TextoL <> @Texto1 SET @Resultado = 1 ELSE SET @Resultado = 0
END
IF @Condicion = 'MAYOR QUE' AND @Ok IS NULL
BEGIN
IF @TextoL > @Texto1 SET @Resultado = 1 ELSE SET @Resultado = 0
END
IF @Condicion = 'MENOR QUE' AND @Ok IS NULL
BEGIN
IF @TextoL < @Texto1 SET @Resultado = 1 ELSE SET @Resultado = 0
END
IF @Condicion = 'MAYOR O IGUAL QUE' AND @Ok IS NULL
BEGIN
IF @TextoL >= @Texto1 SET @Resultado = 1 ELSE SET @Resultado = 0
END
IF @Condicion = 'MENOR O IGUAL QUE' AND @Ok IS NULL
BEGIN
IF @TextoL <= @Texto1 SET @Resultado = 1 ELSE SET @Resultado = 0
END
END
IF RTRIM(@TipoDato) = 'NUMERICO' AND @Ok IS NULL
BEGIN
SET @Numerico1 = CONVERT(float,@Valor1)
IF @@ERROR <> 0 SELECT @Ok = 10060, @OkRef = 'Parámetro incorrecto en el indicador ' + RTRIM(@Indicador) + '. Parámetro:' + @Valor1
SET @Numerico2 = CONVERT(float,@Valor2)
IF @@ERROR <> 0 SELECT @Ok = 10060, @OkRef = 'Parámetro incorrecto en el indicador ' + RTRIM(@Indicador) + '. Parámetro:' + @Valor2
SET @NumericoL = CONVERT(float,@Lectura)
IF @@ERROR <> 0 SELECT @Ok = 10060, @OkRef = 'Lectura incorrecta en el indicador ' + RTRIM(@Indicador) + '. Lectura:' + @Lectura
IF @Condicion NOT IN ('IGUAL QUE','ENTRE','CADA','DIFERENTE QUE','MAYOR QUE','MENOR QUE','MAYOR O IGUAL QUE','MENOR O IGUAL QUE') AND @Ok IS NULL SELECT @Ok = 10060, @OkRef = 'Condición incorrecta en el indicador ' + RTRIM(@Indicador) + '. Condición:' + @Condicion  
IF @Condicion = 'IGUAL QUE' AND @Ok IS NULL
BEGIN
IF @NumericoL = @Numerico1 SET @Resultado = 1 ELSE SET @Resultado = 0
END
IF @Condicion = 'ENTRE' AND @Ok IS NULL
BEGIN
IF @NumericoL >= @Numerico1 AND @NumericoL <= @Numerico2 SET @Resultado = 1 ELSE SET @Resultado = 0
END
IF @Condicion = 'CADA' AND @Ok IS NULL 
BEGIN
IF (CONVERT(int,@NumericoL) % CONVERT(int,@Numerico1)) <= (CONVERT(int,@Numerico2) - CONVERT(int,@Numerico1)) AND (CONVERT(int,@NumericoL) / CONVERT(int,@Numerico1) > 0)
BEGIN
SET @Resultado = 1
SET @MAFCiclo = CONVERT(int,@NumericoL) / CONVERT(int,@Numerico1)
END
ELSE
SET @Resultado = 0
END
IF @Condicion = 'DIFERENTE QUE' AND @Ok IS NULL
BEGIN
IF @NumericoL <> @Numerico1 SET @Resultado = 1 ELSE SET @Resultado = 0
END
IF @Condicion = 'MAYOR QUE' AND @Ok IS NULL
BEGIN
IF @NumericoL > @Numerico1 SET @Resultado = 1 ELSE SET @Resultado = 0
END
IF @Condicion = 'MENOR QUE' AND @Ok IS NULL
BEGIN
IF @NumericoL < @Numerico1 SET @Resultado = 1 ELSE SET @Resultado = 0
END
IF @Condicion = 'MAYOR O IGUAL QUE' AND @Ok IS NULL
BEGIN
IF @NumericoL >= @Numerico1 SET @Resultado = 1 ELSE SET @Resultado = 0
END
IF @Condicion = 'MENOR O IGUAL QUE' AND @Ok IS NULL
BEGIN
IF @NumericoL <= @Numerico1 SET @Resultado = 1 ELSE SET @Resultado = 0
END
END
IF RTRIM(@TipoDato) = 'FECHA' AND @Ok IS NULL
BEGIN
SET @Fecha1 = CONVERT(datetime,RTRIM(@Valor1))
IF @@ERROR <> 0 SELECT @Ok = 10060, @OkRef = 'Parámetro incorrecto en el Indicador ' + RTRIM(@Indicador) + '. Parámetro:' + @Valor1
SET @Fecha2 = CONVERT(datetime,RTRIM(@Valor2))
IF @@ERROR <> 0 SELECT @Ok = 10060, @OkRef = 'Parámetro incorrecto en el indicador ' + RTRIM(@Indicador) + '. Parámetro:' + @Valor2
SET @FechaL = CONVERT(datetime,RTRIM(@Lectura))
IF @@ERROR <> 0 SELECT @Ok = 10060, @OkRef = 'Lectura incorrecta en el indicador ' + RTRIM(@Indicador) + '. Lectura:' + @Lectura
IF @Condicion NOT IN ('IGUAL QUE','ENTRE','DIFERENTE QUE','MAYOR QUE','MENOR QUE','MAYOR O IGUAL QUE','MENOR O IGUAL QUE') AND @Ok IS NULL SELECT @Ok = 10060, @OkRef = 'Condición incorrecta en el indicador ' + RTRIM(@Indicador) + '. Condición:' + @Condicion
IF @Condicion = 'IGUAL QUE' AND @Ok IS NULL
BEGIN
IF @FechaL = @Fecha1 SET @Resultado = 1 ELSE SET @Resultado = 0
END
IF @Condicion = 'ENTRE' AND @Ok IS NULL
BEGIN
IF @FechaL >= @Fecha1 AND @FechaL <= @Fecha2 SET @Resultado = 1 ELSE SET @Resultado = 0
END
IF @Condicion = 'DIFERENTE QUE' AND @Ok IS NULL
BEGIN
IF @FechaL <> @Fecha1 SET @Resultado = 1 ELSE SET @Resultado = 0
END
IF @Condicion = 'MAYOR QUE' AND @Ok IS NULL
BEGIN
IF @FechaL > @Fecha1 SET @Resultado = 1 ELSE SET @Resultado = 0
END
IF @Condicion = 'MENOR QUE' AND @Ok IS NULL
BEGIN
IF @FechaL < @Fecha1 SET @Resultado = 1 ELSE SET @Resultado = 0
END
IF @Condicion = 'MAYOR O IGUAL QUE' AND @Ok IS NULL
BEGIN
IF @FechaL >= @Fecha1 SET @Resultado = 1 ELSE SET @Resultado = 0
END
IF @Condicion = 'MENOR O IGUAL QUE' AND @Ok IS NULL
BEGIN
IF @FechaL <= @Fecha1 SET @Resultado = 1 ELSE SET @Resultado = 0
END
END
IF RTRIM(@TipoDato) = 'VENCIMIENTO' AND @Ok IS NULL
BEGIN
SET @Numerico1 = CONVERT(int,RTRIM(@Valor1))
IF @@ERROR <> 0 SELECT @Ok = 10060, @OkRef = 'Parámetro incorrecto en el indicador ' + RTRIM(@Indicador) + '. Parámetro:' + @Valor1
SET @Texto2 = UPPER(LTRIM(RTRIM(@Valor2)))
SET @FechaL = CONVERT(datetime,RTRIM(@Lectura))
IF @@ERROR <> 0 SELECT @Ok = 10060, @OkRef = 'Lectura incorrecta en el indicador ' + RTRIM(@Indicador) + '. Lectura:' + @Lectura
IF @Texto2 NOT IN ('DIAS','SEMANAS','MESES','AÑOS') AND @Ok IS NULL SELECT @Ok = 10060, @OkRef = 'Parámetro incorrecto en el indicador ' + RTRIM(@Indicador) + '. Parámetro:' + @Valor2
IF @Condicion NOT IN ('FALTAN MENOS DE','PASARON MAS DE') AND @Ok IS NULL SELECT @Ok = 10060, @OkRef = 'Condición incorrecta en el indicador ' + RTRIM(@Indicador) + '. Condición:' + @Condicion
IF @Condicion = 'FALTAN MENOS DE' AND @Ok IS NULL
BEGIN
IF @Texto2 = 'DIAS' SET @FechaLimite = DATEADD(dd,0-@Numerico1,@FechaL)
IF @Texto2 = 'SEMANAS' SET @FechaLimite = DATEADD(ww,0-@Numerico1,@FechaL)
IF @Texto2 = 'MESES' SET @FechaLimite = DATEADD(mm,0-@Numerico1,@FechaL)
IF @Texto2 = 'AÑOS' SET @FechaLimite = DATEADD(mm,0-@Numerico1,@FechaL)
IF GETDATE() >= @FechaLimite SET @Resultado = 1 ELSE SET @Resultado = 0
END
IF @Condicion = 'PASARON MAS DE' AND @Ok IS NULL
BEGIN
IF @Texto2 = 'DIAS' SET @FechaLimite = DATEADD(dd,@Numerico1,@FechaL)
IF @Texto2 = 'SEMANAS' SET @FechaLimite = DATEADD(ww,@Numerico1,@FechaL)
IF @Texto2 = 'MESES' SET @FechaLimite = DATEADD(mm,@Numerico1,@FechaL)
IF @Texto2 = 'AÑOS' SET @FechaLimite = DATEADD(mm,@Numerico1,@FechaL)
IF GETDATE() >= @FechaLimite SET @Resultado = 1 ELSE SET @Resultado = 0
END
END
IF RTRIM(@TipoDato) = 'LOGICO' AND @Ok IS NULL
BEGIN
SET @Logico = CONVERT(bit,@Valor1)
IF @@ERROR <> 0 SELECT @Ok = 10060, @OkRef = 'Parámetro incorrecto en el indicador ' + RTRIM(@Indicador) + '. Parámetro:' + @Valor1
SET @LogicoL = CONVERT(bit,@Lectura)
IF @@ERROR <> 0 SELECT @Ok = 10060, @OkRef = 'Lectura incorrecta en el indicador ' + RTRIM(@Indicador) + '. Lectura:' + @Lectura
IF @Condicion NOT IN ('IGUAL QUE') AND @Ok IS NULL SELECT @Ok = 10060, @OkRef = 'Condición incorrecta en el indicador ' + RTRIM(@Indicador) + '. Condición:' + @Condicion
IF @Condicion = 'IGUAL QUE' AND @Ok IS NULL
BEGIN
IF @LogicoL = @Logico SET @Resultado = 1 ELSE SET @Resultado = 0
END
END
END

