SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPrecioReal (@Precio money, @Imp1 float, @Imp2 float, @Imp3 money, @Imp2Info bit, @Imp3Info bit, @ImpIncluido bit)
RETURNS money

AS BEGIN
DECLARE @Prec money
SELECT @Imp1 = ISNULL(@Imp1, 0), @Imp2 = ISNULL(@Imp2, 0), @Imp3 = ISNULL(@Imp3, 0), @Imp2Info = ISNULL(@Imp2Info, 0), @Imp3Info = ISNULL(@Imp3Info, 0)
SELECT @Prec = @Precio
IF @ImpIncluido = 1 BEGIN
IF @Imp3Info = 1 BEGIN
SELECT @Prec = @Precio / (1+(@Imp1/100))
IF @Imp2Info = 0
SELECT @Prec = @PREC / (1+(@Imp2/100))
END ELSE BEGIN
SELECT @Prec = (@Precio - @Imp3) / (1+(@Imp1/100))
IF @Imp2Info = 0
SELECT @Prec = @Prec / (1+(@Imp2/100))
END
END
RETURN @Prec
END

