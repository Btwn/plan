SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEcuadorCedulaDigitoVerificador
@RUC            varchar(20),
@Digito         char(2) OUTPUT

AS BEGIN
DECLARE
@Coeficiente varchar(20),
@Largo       int,
@Ciclo       int,
@Modulo      int,
@Total       int,
@Valor       int,
@Residuo     int
SELECT @Digito = '0'
IF SUBSTRING(@RUC, 3,1) IN('5','4','3','2','1','0')
BEGIN
SELECT @Largo = 10, @Coeficiente='212121212', @Modulo =10
END ELSE
SELECT @Digito=NULL
IF @Digito <> NULL
BEGIN
SELECT @Ciclo = 1, @Total = 0
WHILE @Ciclo < @Largo
BEGIN
SELECT @Valor = CONVERT(int,SUBSTRING(@Ruc,@Ciclo,1)) * CONVERT(int, SUBSTRING(@Coeficiente,@Ciclo,1))
SELECT @Total =@Total  +   CASE WHEN @Valor  > 9	 AND @Modulo	= 10 THEN ((@Valor % 10) + (@Valor / 10)) ELSE @Valor END
SELECT @Ciclo=@Ciclo+1
END
SELECT @Residuo =	 (@Total % @Modulo)
IF @Residuo = 0 
SELECT @Digito = 0
ELSE
SELECT @Digito = CONVERT(varchar,(@Modulo -  @Residuo))
IF @Digito = substring(@ruc,@largo,1) SELECT @Digito = 1 ELSE  SELECT @Digito=NULL
END
END

