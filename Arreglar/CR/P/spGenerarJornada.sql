SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarJornada
@Jornada	varchar(20),
@FechaD	datetime,
@FechaA	datetime

AS BEGIN
DECLARE
@Ok			 int,
@Domingo 		 bit,
@Lunes   		 bit,
@Martes  		 bit,
@Miercoles		 bit,
@Jueves		 bit,
@Viernes		 bit,
@Sabado		 bit,
@DescansoRompeRutina bit,
@DescansaFestivos	 bit,
@FestivoRompeRutina	 bit,
@Dia		 int,
@UltDia		 int,
@HoraEntrada	 char(5),
@HoraSalida		 char(5),
@DiaSemana		 int,
@NoLabora		 bit,
@EsFestivoGeneral    bit,
@EsFestivoJornada    bit,
@Entrada		 datetime,
@Salida		 datetime,
@Fecha		 datetime,
@BrincaDia		 int,
@RompeRutina	 int,
@Nocturna		 bit
SET DATEFIRST 7
EXEC spExtraerFecha @FechaD OUTPUT
EXEC spExtraerFecha @FechaA OUTPUT
SELECT @FechaA = DATEADD(day, 1, @FechaA)
IF NOT EXISTS(SELECT * FROM Jornada WHERE Jornada = @Jornada) RETURN
SELECT @Ok = NULL
SELECT @Domingo   		= Domingo,
@Lunes     		= Lunes,
@Martes    		= Martes,
@Miercoles 		= Miercoles,
@Jueves    		= Jueves,
@Viernes   		= Viernes,
@Sabado    		= Sabado,
@DescansoRompeRutina	= DescansoRompeRutina,
@DescansaFestivos	= DescansaFestivos,
@FestivoRompeRutina	= FestivoRompeRutina
FROM Jornada
WHERE Jornada = @Jornada
BEGIN TRANSACTION
DELETE JornadaTiempo WHERE Jornada = @Jornada AND Entrada >= @FechaD
SELECT @Entrada = @FechaD
WHILE @Entrada < @FechaA
BEGIN
DECLARE crRutina CURSOR
FOR SELECT d.Dia, d.Entrada, d.Salida,j.JornadaNocturna
FROM JornadaD d
JOIN Jornada j ON d.Jornada = j.Jornada
WHERE d.Jornada = @Jornada
ORDER BY d.Dia, CASE WHEN ISNULL(j.JornadaNocturna,0)=1 THEN d.Salida ELSE d.Entrada END
OPEN crRutina
FETCH NEXT FROM crRutina INTO @Dia, @HoraEntrada, @HoraSalida,@Nocturna
SELECT @UltDia = @Dia, @RompeRutina = 0, @BrincaDia = 0
WHILE @@FETCH_STATUS <> -1 AND @Entrada < @FechaA AND @RompeRutina = 0 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @BrincaDia = 0 AND @Ok IS NULL
BEGIN
SELECT @NoLabora = 0, @EsFestivoGeneral = 0, @EsFestivoJornada = 0, @Fecha = @Entrada
EXEC spExtraerFecha @Fecha OUTPUT
SELECT @DiaSemana = DATEPART(weekday, @Fecha)
IF (@DiaSemana = 1 AND @Domingo   = 1) OR (@DiaSemana = 2 AND @Lunes  = 1) OR (@DiaSemana = 3 AND @Martes  = 1) OR
(@DiaSemana = 4 AND @Miercoles = 1) OR (@DiaSemana = 5 AND @Jueves = 1) OR (@DiaSemana = 6 AND @Viernes = 1) OR
(@DiaSemana = 7 AND @Sabado    = 1)
SELECT @NoLabora = 1
IF @NoLabora = 0
BEGIN
IF @Fecha IN (SELECT Fecha FROM DiaFestivo WHERE EsLaborable = 0)
SELECT @EsFestivoGeneral = 1
IF @Fecha IN (SELECT Fecha FROM JornadaDiaFestivo WHERE Jornada = @Jornada AND EsLaborable = 0)
SELECT @EsFestivoJornada = 1
IF @EsFestivoJornada = 1 OR (@EsFestivoGeneral = 1 AND @DescansaFestivos = 1)
BEGIN
SELECT @BrincaDia = 1
IF @FestivoRompeRutina = 1 SELECT @RompeRutina = 1
END ELSE
BEGIN
SELECT @Entrada = @Fecha
EXEC spAgregarHora @HoraEntrada, @Entrada OUTPUT
SELECT @Salida = @Fecha
EXEC spAgregarHora @HoraSalida, @Salida OUTPUT
IF @Salida < @Entrada AND @Nocturna = 0  SELECT @Salida = DATEADD(day, 1, @Salida)
INSERT JornadaTiempo (Jornada,  Entrada,  Salida)
VALUES (@Jornada, @Entrada, @Salida)
END
END ELSE
BEGIN
SELECT @BrincaDia = 1
IF @DescansoRompeRutina = 1 SELECT @RompeRutina = 1
END
END
FETCH NEXT FROM crRutina INTO @Dia, @HoraEntrada, @HoraSalida,@Nocturna
IF @Dia = @UltDia SELECT @Entrada = @Fecha
IF @Dia <> @UltDia OR @RompeRutina = 1 OR @@FETCH_STATUS = -1 SELECT @Entrada = DATEADD(day, 1, @Fecha), @UltDia = @Dia, @BrincaDia = 0
END  
CLOSE crRutina
DEALLOCATE crRutina
END 
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
SELECT "Se Genero con Exito la Jornada Laboral de Periodo Indicado"
END ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT "Error al Generar la Jornada Laboral"
END
RETURN
END

