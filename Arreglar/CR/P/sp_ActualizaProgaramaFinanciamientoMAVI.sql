SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sp_ActualizaProgaramaFinanciamientoMAVI
@CxcID  int

AS BEGIN
DECLARE
@ContRegistros   int,
@Cont            int,
@ID              int,
@Ejercicio       int,
@Periodo         int,
@Anterior        money,
@Exigible        money,
@AnteriorTmp     money,
@ExigiblePagado  money,
@Adelantado      money,
@PagoFinanciamiento money,
@PagoNeto        money,
@Arrastre        money,
@Cobertura       money,
@ArrastreTmp     money
SET @ContRegistros = 0
SET @Cont = 0
SET @ID = 0
SET @Ejercicio = 0
SET @Periodo = 0
SET @Anterior = 0.0
SET @Exigible = 0.0
SET @AnteriorTmp = 0.0
SET @ExigiblePagado = 0.0
SET @Adelantado = 0.0
SET @PagoFinanciamiento = 0.0
SET @PagoNeto = 0.0
SET @Arrastre = 0.0
SET @Cobertura = 0.0
SET @ArrastreTmp = 0.0
SELECT @ContRegistros = Count(ID) FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID
DECLARE RecuperacionCredilanasPP CURSOR FOR SELECT R.ID, R.Ejercicio, R.Periodo, R.Exigible, R.PagoFinanciamiento, R.Arrastre, R.Cobertura FROM RecuperacionCredilanasPPMAVI R WHERE ID = @CxcID ORDER BY R.ID, R.Ejercicio, R.Periodo
OPEN RecuperacionCredilanasPP
WHILE @Cont < @ContRegistros 
BEGIN
FETCH NEXT FROM RecuperacionCredilanasPP
INTO @ID, @Ejercicio, @Periodo, @Exigible, @PagoFinanciamiento, @Arrastre, @Cobertura    
IF @Cont = 0
BEGIN
SELECT @Arrastre = 0.0, @Cobertura = 0.0
END
SET @Cobertura = 0.0
SELECT @Arrastre = ISNULL(@ArrastreTmp, 0.0)  
IF  @Arrastre > 0.0
BEGIN
IF @Arrastre >= ISNULL(@Exigible, 0.0)
BEGIN
SELECT @Cobertura = ISNULL(@Exigible, 0.0)
SELECT @Arrastre = @Arrastre - ISNULL(@Exigible, 0.0)
END
ELSE
BEGIN
SELECT @Cobertura = ISNULL(@Arrastre, 0.0)
SET @Arrastre = 0.0
END
END   
SELECT @PagoFinanciamiento = ISNULL(@PagoFinanciamiento, 0.0) + ISNULL(@Cobertura, 0.0) 
IF @PagoFinanciamiento > @Anterior 
BEGIN
SELECT @PagoNeto = (ISNULL(@PagoFinanciamiento,0.0) - ISNULL(@Anterior, 0.0))
SELECT @AnteriorTmp = @Anterior
SELECT @Anterior = 0.0
IF @PagoNeto > @Exigible
BEGIN
SELECT @ExigiblePagado = ISNULL(@Exigible, 0.0)
SELECT @Adelantado = (@PagoNeto - ISNULL(@Exigible, 0.0))
SELECT @Arrastre = ISNULL(@Arrastre, 0.0) + ISNULL(@Adelantado, 0.0)  
END
ELSE
BEGIN
SELECT @ExigiblePagado = @PagoNeto
SELECT @Adelantado = 0.0
SELECT @AnteriorTmp = @Anterior
SELECT @Anterior = (@Anterior+(@Exigible - @ExigiblePagado))
END
END
ELSE
BEGIN
SELECT @AnteriorTmp = @Anterior
SELECT @Anterior = @Anterior - @PagoFinanciamiento
SELECT @Anterior = @Anterior+ISNULL(@Exigible, 0.0)
SELECT @ExigiblePagado = 0.0, @Adelantado = 0.0
END      
SELECT @ArrastreTmp = ISNULL(@Arrastre, 0.0)
UPDATE RecuperacionCredilanasPPMAVI SET Anterior = @AnteriorTmp, ExigiblePagado = @ExigiblePagado, Adelantado = @Adelantado, Arrastre = @Arrastre, Cobertura = @Cobertura WHERE ID = @ID AND Ejercicio = @Ejercicio AND Periodo = @Periodo
SET @Cont= @Cont + 1
SET @ExigiblePagado = 0.0
END 
CLOSE RecuperacionCredilanasPP
DEALLOCATE RecuperacionCredilanasPP
RETURN
END

