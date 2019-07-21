SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarAsisteExtra
@Empresa		char(5),
@Personal		char(10),
@Jornada		varchar(20),
@FechaInicial	datetime,
@FechaFinal		datetime,
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@FechaEntrada	datetime,
@FechaSalida	datetime,
@Entrada		datetime,
@Salida		datetime,
@EntradaReal	datetime,
@SalidaReal		datetime,
@Dias		int,
@Minutos		int,
@Nocturna		bit
SELECT @Nocturna = JornadaNocturna
FROM Jornada
WITH(NOLOCK) WHERE Jornada = @Jornada
SET @Nocturna = ISNULL(@Nocturna,0)
DECLARE crAsistenciaReal CURSOR
FOR SELECT Entrada, Salida
FROM PersonalAsiste WITH(NOLOCK)
WHERE  Empresa = @Empresa AND Personal = @Personal AND ProcesarExtra = 1
SELECT @Entrada = @FechaInicial
OPEN crAsistenciaReal
FETCH NEXT FROM crAsistenciaReal  INTO @EntradaReal, @SalidaReal
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @FechaEntrada = @EntradaReal, @FechaSalida = @SalidaReal
EXEC spExtraerFecha @FechaEntrada OUTPUT
EXEC spExtraerFecha @FechaSalida OUTPUT
IF EXISTS(SELECT * FROM JornadaTiempo WITH(NOLOCK) WHERE Jornada = @Jornada AND Fecha = @FechaEntrada)
BEGIN
SELECT @Entrada = MIN(Entrada)
FROM JornadaTiempo
WITH(NOLOCK) WHERE Jornada = @Jornada AND Fecha = @FechaEntrada AND Entrada > @EntradaReal AND Entrada < @SalidaReal
SELECT @Minutos = DATEDIFF(mi, @EntradaReal, @Entrada)
IF @Minutos > 0
INSERT PersonalAsisteDifMin (Empresa,  Personal,  FechaHoraD,   FechaHoraA, Fecha,         Extra,    Registro)
VALUES (@Empresa, @Personal, @EntradaReal, @Entrada,   @FechaEntrada, @Minutos, 'Entrada')
SELECT @Salida = MIN(Salida)
FROM JornadaTiempo
WITH(NOLOCK) WHERE Jornada = @Jornada AND Fecha = @FechaSalida AND Salida > @EntradaReal AND Salida < @SalidaReal
SELECT @Minutos = DATEDIFF(mi, @Salida, @SalidaReal)
IF @Minutos > 0
INSERT PersonalAsisteDifMin (Empresa,  Personal,  FechaHoraD, FechaHoraA,  Fecha,  Extra,    Registro)
VALUES (@Empresa, @Personal, @Salida,    @SalidaReal, @FechaSalida, @Minutos, 'Salida')
END ELSE
INSERT PersonalAsisteDifDia (Empresa, Personal, Fecha, Extra, Minutos) VALUES (@Empresa, @Personal, @FechaEntrada, 1, DATEDIFF(mi, @EntradaReal, @SalidaReal))
UPDATE PersonalAsiste  WITH(ROWLOCK) SET ProcesarExtra = 0 WHERE CURRENT OF crAsistenciaReal
END
FETCH NEXT FROM crAsistenciaReal  INTO @EntradaReal, @SalidaReal
END  
CLOSE crAsistenciaReal
DEALLOCATE crAsistenciaReal
DECLARE crAsistenciaGral CURSOR
FOR SELECT Entrada, Salida
FROM PersonalAsiste WITH(NOLOCK)
WHERE  Empresa = @Empresa AND Personal = @Personal
SELECT @Entrada = @FechaInicial
OPEN crAsistenciaGral
FETCH NEXT FROM crAsistenciaGral  INTO @EntradaReal, @SalidaReal
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @FechaEntrada = @EntradaReal
EXEC spExtraerFecha @FechaEntrada OUTPUT
SELECT @Minutos = DATEDIFF(mi, @EntradaReal, @SalidaReal)
IF @Minutos < 0 AND @Nocturna = 1
BEGIN
SET @EntradaReal =  DATEADD(dd,-1,@EntradaReal)
SELECT @Minutos = DATEDIFF(mi, @EntradaReal, @SalidaReal)
END
/* NES - Se corrige el siguiente bloque para correcci�n de entradas y salidas en diferentes días */
EXEC spExtraerFecha @EntradaReal OUTPUT
EXEC spExtraerFecha @SalidaReal OUTPUT
IF @Nocturna = 1
SET @SalidaReal = @EntradaReal
IF @Minutos >0
BEGIN
IF @SalidaReal IS NULL
INSERT PersonalAsisteDif (Empresa,  Personal,  Fecha,         Cantidad, Tipo)
SELECT @Empresa, @Personal, @EntradaReal, @Minutos, 'Minutos Asistencia'
ELSE
INSERT PersonalAsisteDif (Empresa,  Personal,  Fecha,         Cantidad, Tipo)
SELECT @Empresa, @Personal, @SalidaReal, @Minutos, 'Minutos Asistencia'
END
END
FETCH NEXT FROM crAsistenciaGral  INTO @EntradaReal, @SalidaReal
END  
CLOSE crAsistenciaGral
DEALLOCATE crAsistenciaGral
RETURN
END

