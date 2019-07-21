SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnDiasBimestre (@Fecha Datetime)
RETURNS int

AS BEGIN
DECLARE
@DiasBimestre int,
@Mes		  int,
@Ano		  int,
@Dias		  int,
@Fh			  datetime
SELECT @Ano = DATEPART(YEAR,@Fecha)
SELECT @Mes = DATEPART(MONTH,@Fecha)
IF @Mes IN (1,2)
BEGIN
SELECT @DiasBimestre = dbo.fnDiasMes(1,@Ano)+dbo.fnDiasMes(2,@Ano)
END
ELSE IF @Mes IN (3,4)
BEGIN
SELECT @DiasBimestre = dbo.fnDiasMes(3,@Ano)+dbo.fnDiasMes(4,@Ano)
END
ELSE IF @Mes IN (5,6)
BEGIN
SELECT @DiasBimestre = dbo.fnDiasMes(5,@Ano)+dbo.fnDiasMes(6,@Ano)
END
ELSE IF @Mes IN (7,8)
BEGIN
SELECT @DiasBimestre = dbo.fnDiasMes(7,@Ano)+dbo.fnDiasMes(8,@Ano)
END
ELSE IF @Mes IN (9,10)
BEGIN
SELECT @DiasBimestre = dbo.fnDiasMes(9,@Ano)+dbo.fnDiasMes(10,@Ano)
END
ELSE IF @Mes IN (11,12)
BEGIN
SELECT @DiasBimestre = dbo.fnDiasMes(11,@Ano)+dbo.fnDiasMes(12,@Ano)
END
RETURN (@DiasBimestre)
END

