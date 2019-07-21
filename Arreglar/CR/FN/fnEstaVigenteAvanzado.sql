SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnEstaVigenteAvanzado (@FechaHora datetime, @Desde datetime, @Hasta datetime, @HoraD varchar(5), @HoraA varchar(5), @DiasEsp varchar(50))
RETURNS bit

AS BEGIN
DECLARE
@Resultado	bit,
@Fecha      datetime,
@Hora	varchar(5)
SELECT @Resultado = 0, @HoraD = NULLIF(RTRIM(@HoraD), ''), @HoraA = NULLIF(RTRIM(@HoraA), ''), @DiasEsp = NULLIF(RTRIM(@DiasEsp), '')
SELECT @Fecha = dbo.fnFechaSinHora(@FechaHora)
IF @Fecha BETWEEN ISNULL(@Desde, @Fecha) AND ISNULL(@Hasta, @Fecha)
BEGIN
SELECT @Hora = dbo.fnExtraerHora(@FechaHora)
IF @Hora BETWEEN ISNULL(@HoraD, @Hora) AND ISNULL(@HoraA, @Hora)
BEGIN
IF @DiasEsp IS NULL OR EXISTS(SELECT * FROM DiasEspD WHERE DiasEsp = @DiasEsp AND Dia = dbo.fnDiaSemanaEspanol(@FechaHora))
SELECT @Resultado = 1
IF @DiasEsp IS NULL OR EXISTS(SELECT * FROM DiasEspD WHERE DiasEsp = @DiasEsp AND ISNUMERIC(Dia) = 1 AND CASE WHEN ISNUMERIC(Dia) = 1 THEN Dia ELSE 0 END = DATEPART(dd,@FechaHora))
SELECT @Resultado = 1
END
END
RETURN (@Resultado)
END

