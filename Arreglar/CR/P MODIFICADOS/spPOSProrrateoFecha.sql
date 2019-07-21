SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSProrrateoFecha
@Estacion		int,
@Total			float,
@Fecha			datetime,
@Periodicidad	char(20),
@Veces			int

AS
BEGIN
DECLARE
@Cantidad				float,
@Dia					int,
@PrimerVencimiento		datetime,
@EsQuince				int
SELECT @Dia = DATEPART(dd, @Fecha)
IF @Dia <= 15
SELECT @EsQuince = 1, @Fecha = DATEADD(dd, 15 - @Dia, @Fecha)
ELSE
SELECT @EsQuince = 0, @Fecha = DATEADD(dd, -DATEPART(dd, @Fecha), DATEADD(mm, 1, @Fecha))
IF NULLIF(@Veces, 0) IS NULL OR @Veces > 300
RETURN
DELETE ProrrateoFecha WHERE Estacion = @Estacion
SELECT @Cantidad = @Total/NULLIF(@Veces, 0)
WHILE ROUND(@Total, 10) > 0
BEGIN
INSERT ProrrateoFecha (Estacion, Cantidad, Fecha) VALUES (@Estacion, @Cantidad, @Fecha)
SELECT @Total = @Total - @Cantidad
IF @Periodicidad = 'QUINCENAL'
EXEC spCalcularPeriodicidad @Fecha, @Periodicidad, @Fecha OUTPUT, NULL, NULL,0
BEGIN
IF DATEPART(dd, @Fecha) = 01
SELECT @Fecha = DATEADD(dd, 14, @Fecha)
IF DATEPART(dd, @Fecha) = 16
SELECT @Fecha = DATEADD(dd, DATEDIFF(DD, @Fecha, CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@Fecha))),DATEADD(mm,1,@Fecha)))), @Fecha)
END
END
RETURN
END

