SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnFormatearFecha
(
@fecha		 datetime,
@forma		varchar(100)
)
RETURNS VARCHAR (100)
AS
BEGIN
DECLARE @d int,
@m int,
@a  int,
@dia int,
@mes int,
@año int,
@ad varchar(100),
@am varchar(100),
@aa varchar(100),
@day varchar(100),
@month varchar(100),
@year varchar(100),
@rd varchar (100),
@rm varchar (100),
@ra varchar (100),
@resultado varchar(100)
SELECT @dia = DATEPART(d, @fecha)
SELECT @mes = DATEPART(m, @fecha)
SELECT @año = DATEPART(yy, @fecha)
SELECT @d = dbo.fnContarLetras(@forma,'D')
SELECT @m = dbo.fnContarLetras(@forma,'M')
SELECT @a = dbo.fnContarLetras(@forma,'A')
SELECT @ad = dbo.fnRellenarCerosIzquierda(@dia,@d)
SELECT @am = dbo.fnRellenarCerosIzquierda(@mes,@m)
SELECT @aa = dbo.fnRellenarCerosIzquierda(@año,@a)
SELECT @day=REPLICATE('D',@d)
SELECT @month=REPLICATE('M',@m)
SELECT @year=REPLICATE('A',@a)
SELECT @rd=REPLACE(@forma, @day, @ad)
SELECT @rm=REPLACE(@rd, @month, @am)
SELECT @ra=REPLACE(@rm, @year, @aa)
SET @resultado=@ra
RETURN @resultado
END

