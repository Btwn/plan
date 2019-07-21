SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fgetMONTO_RECACUMULABLE(	@MontoRec as Float,
@CantReinv as Float,
@CantRedimPas as Float,
@FechaInversion as Datetime,
@FechaObtRec as Datetime,
@prorroga as bit)
RETURNS Float
AS
BEGIN
DECLARE	@Monto as Float,
@_prorroga as int,
@MesesDif as int
SET @Monto = 0;
SET @_prorroga = CAST(@prorroga AS INT);
SET @MesesDif = DATEDIFF(MONTH, @FechaObtRec,@FechaInversion);
IF @MontoRec > (@CantReinv+@CantRedimPas) AND @MesesDif <12 AND @_prorroga=0
BEGIN
SET @Monto = @MontoRec - (@CantReinv+@CantRedimPas);
END
IF @MontoRec > (@CantReinv+@CantRedimPas) AND @MesesDif <24 AND @_prorroga=1
BEGIN
SET @Monto = @MontoRec - (@CantReinv+@CantRedimPas);
END
RETURN @Monto
END

