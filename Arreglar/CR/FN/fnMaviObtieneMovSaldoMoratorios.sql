SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnMaviObtieneMovSaldoMoratorios
(
@Mov		varchar(20),
@Flujo	varchar(20),
@UEN		int
)
RETURNS varchar(20)
AS
BEGIN
DECLARE @SaldoMov	varchar(20),
@Hijo		int,
@Cont		int,
@ID			int
IF NOT EXISTS (SELECT DISTINCT Mov FROM MaviMovimientosFlujo WHERE Mov = @Mov AND Flujo = @Flujo AND UEN = @UEN)
BEGIN
SELECT @SaldoMov = NULL
RETURN @SaldoMov
END
SELECT @Cont = 1,@Hijo = 1
SELECT @ID = ID,@Hijo = Hijo,@SaldoMov = Mov FROM MaviMovimientosFlujo WHERE Mov = @Mov AND Flujo = @Flujo AND UEN = @UEN
WHILE (@Hijo = 1)
BEGIN
IF(SELECT Hijo FROM MaviMovimientosFlujo WHERE ID = @ID AND Flujo = @Flujo AND UEN = @UEN) = 0
BEGIN
SELECT @SaldoMov = Mov FROM MaviMovimientosFlujo WHERE ID = @ID  AND Flujo = @Flujo AND UEN = @UEN
SELECT @Hijo = Hijo FROM MaviMovimientosFlujo WHERE ID = @ID  AND Flujo = @Flujo AND UEN = @UEN
END
ELSE IF (SELECT Hijo FROM MaviMovimientosFlujo WHERE Padre = @ID AND Flujo = @Flujo AND UEN = @UEN) = 0
BEGIN
SELECT @SaldoMov = Mov FROM MaviMovimientosFlujo WHERE Padre = @ID AND Flujo = @Flujo AND UEN = @UEN
SELECT @Hijo = Hijo FROM MaviMovimientosFlujo WHERE Padre = @ID  AND Flujo = @Flujo AND UEN = @UEN
END
ELSE
BEGIN
SELECT @ID = ID FROM MaviMovimientosFlujo WHERE Padre = @ID AND Flujo = @Flujo AND UEN = @UEN
SELECT @Hijo = Hijo FROM MaviMovimientosFlujo WHERE Padre = @ID AND Flujo = @Flujo AND UEN = @UEN
IF @Hijo = 0
SELECT @SaldoMov = Mov FROM MaviMovimientosFlujo WHERE Padre = @ID AND Flujo = @Flujo AND UEN = @UEN
END
END
RETURN @SaldoMov
END

