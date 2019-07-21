SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spNomAniversario
@Personal varchar(10),
@PeriodoTipo varchar(20),
@FechaD datetime,
@FechaA datetime

AS
BEGIN
DECLARE
@FechaAlta DATETIME,
@EsAniversario INT,
@FechaVar datetime,
@DiaRango int,
@MesRango int,
@AmoRango int,
@DiaAniv int,
@MesAniv int,
@AmoAniv int
SELECT @FechaAlta=FechaAntiguedad FROM personal WHERE Personal=@Personal and PeriodoTipo=@PeriodoTipo
SELECT @EsAniversario =0
SET @FechaVar=@FechaD
SELECT @DiaAniv=datepart(day,@FechaAlta),@MesAniv=datepart(month,@FechaAlta),@AmoAniv=datepart(year,@FechaAlta)
IF @DiaAniv=29 AND @MesAniv=2
SET @DiaAniv=28
WHILE  @FechaVar<=@FechaA
BEGIN
SELECT @DiaRango=datepart(day,@FechaVar),@MesRango=datepart(month,@FechaVar),@AmoRango=datepart(year,@FechaVar)
IF @DiaRango=@DiaAniv and @MesRango=@MesAniv AND @AmoAniv<>@AmoRango
SELECT @EsAniversario =1
SELECT @FechaVar=dateadd(day,1,@FechaVar)
END
SELECT @EsAniversario 'Aniversario'
END

