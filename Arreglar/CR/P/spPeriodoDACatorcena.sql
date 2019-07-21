SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPeriodoDACatorcena
@Fecha datetime,
@FechaA	datetime	OUTPUT

AS
BEGIN
DECLARE @Salida int,
@SemanaIF bit,
@UltimoDia	int,
@DiaNombre varchar(10),
@Dia int,
@Mes		int,
@Ano		int,
@Dias int
SELECT @UltimoDia = @@DATEFIRST
SET DATEFIRST 7
SELECT @Dia = DATEPART(day, @Fecha),
@Mes = DATEPART(month, @Fecha),
@Ano = DATEPART(year, @Fecha)
EXEC spISOweek @Fecha, @Salida OUTPUT
SELECT @SemanaIF = @Salida%2
IF @SemanaIF = 1
BEGIN
SELECT @DiaNombre = dbo.fnDiaSemanaEspanol (@Fecha)
IF @DiaNombre = 'Lunes' SELECT @Dia = 1 
IF @DiaNombre = 'Martes' SELECT @Dia = 2
IF @DiaNombre = 'Miercoles' SELECT @Dia = 3
IF @DiaNombre = 'Jueves' SELECT @Dia = 4
IF @DiaNombre = 'Viernes' SELECT @Dia = 5
IF @DiaNombre = 'Sabado' SELECT @Dia = 6
IF @DiaNombre = 'Domingo' SELECT @Dia = 7
SELECT @Dia = 14 - @Dia
SELECT @FechaA = DATEADD(day,@Dia,@Fecha)
END
IF @SemanaIF = 0
BEGIN
SELECT @DiaNombre = dbo.fnDiaSemanaEspanol (@Fecha)
IF @DiaNombre = 'Lunes' SELECT @Dia = 8 
IF @DiaNombre = 'Martes' SELECT @Dia = 9
IF @DiaNombre = 'Miercoles' SELECT @Dia = 10
IF @DiaNombre = 'Jueves' SELECT @Dia = 11
IF @DiaNombre = 'Viernes' SELECT @Dia = 12
IF @DiaNombre = 'Sabado' SELECT @Dia = 13
IF @DiaNombre = 'Domingo' SELECT @Dia = 14
SELECT @Dia = 14 - @Dia
SELECT @FechaA = DATEADD(day,@Dia,@Fecha)
END
SET DATEFIRST @UltimoDia
RETURN
END

