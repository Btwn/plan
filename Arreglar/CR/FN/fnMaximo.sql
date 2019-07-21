SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnMaximo(
@Actual                    float,
@Anterior                  float,
@AnteriorMAD               float,
@Crecimiento               float,
@DiasMes                   float,
@Factor                    float,
@TiempoEntregaB            float,
@TiempoUnidad              varchar(10),
@TiempoEntregaSegB         float,
@TiempoSegUnidad           varchar(10),
@DiasInventario            float)
RETURNS float
AS
BEGIN
DECLARE  @Maximo              float,
@DifAP               float,
@DifAP_Prc           float,
@Prc_VentaA          Float,
@VentaSI             float,
@VentaCI             float,
@Total               float,
@VentaProm           float,
@TiempoEntrega       float,
@TiempoEntregaSeg    float,
@Dias                float
SET @Maximo = 0
SET @DifAP = 0
SET @TiempoEntrega = 0
IF @Anterior > 0 SET @DifAP = ISNULL((((@AnteriorMAD / @Anterior) - 1) * 100),0)
IF @Anterior = 0 SET @DifAP_Prc = -1
SET @DifAP_Prc = (@DifAP / 100)
SET @Prc_VentaA = (@Actual * @DifAP_Prc)
IF @TiempoUnidad      = 'Dias'    SET @TiempoEntrega    = @TiempoEntregaB * 1
ELSE IF @TiempoUnidad = 'Semanas' SET @TiempoEntrega    = @TiempoEntregaB * 7
ELSE IF @TiempoUnidad = 'Meses'   SET @TiempoEntrega    = @TiempoEntregaB * 30
IF @TiempoSegUnidad      = 'Dias'    SET @TiempoEntregaSeg = @TiempoEntregaSegB * 1
ELSE IF @TiempoSegUnidad = 'Semanas' SET @TiempoEntregaSeg = @TiempoEntregaSegB * 7
ELSE IF @TiempoSegUnidad = 'Meses'   SET @TiempoEntregaSeg = @TiempoEntregaSegB * 30
IF @DiasInventario > 0 SET @Dias = @DiasInventario + ISNULL(@TiempoEntrega,0) + ISNULL(@TiempoEntregaSeg,0)
IF ISNULL(@DiasInventario,0) <= 0 SET @Dias = 0
IF @DifAP <= 0
BEGIN
SET @VentaSI = @Actual
SET @VentaCI = (@VentaSI * (@Crecimiento / 100))
SET @Total = @VentaSI + @VentaCI
SET @VentaProm = (@Total / @DiasMes)
END
ELSE
BEGIN
SET @VentaSI = @Actual + @Prc_VentaA
SET @VentaCI = (@VentaSI * (@Crecimiento / 100))
SET @Total = @VentaSI + @VentaCI
SET @VentaProm = (@Total / @DiasMes)
END
SET @Maximo = @VentaProm * @Dias
RETURN @Maximo
END

