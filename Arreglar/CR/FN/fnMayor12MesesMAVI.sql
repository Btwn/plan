SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnMayor12MesesMAVI(@Condicion varchar(50))
RETURNS Int
AS
BEGIN
DECLARE
@NoMeses int,
@TipoCondicion varchar(20),
@DANumeroDocumentos int,
@Meses int,
@DiasVencimiento int
SET @NoMeses = 0
SET @DANumeroDocumentos = 0
SET @Meses = 0
SET @DiasVencimiento = 0
SELECT @TipoCondicion = TipoCondicion, @DANumeroDocumentos = DANumeroDocumentos, @Meses = Meses, @DiasVencimiento = @DiasVencimiento FROM Condicion WHERE Condicion = @Condicion
IF @TipoCondicion <> 'Contado'
BEGIN
SELECT @NoMeses = ISNULL(@DANumeroDocumentos, ISNULL(@Meses,(ISNULL(@DiasVencimiento,0)/30)))
END
ELSE
SET @NoMeses = 0
RETURN (@NoMeses)
END

