SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnNotificacionVentasDelPeriodoTotal
(
@Notificacion		varchar(50),
@Empresa			varchar(5),
@FechaEmision		datetime
)
RETURNS float

AS BEGIN
DECLARE
@Resultado		float,
@ImporteIngresos	float,
@ImporteEgresos	float
SET @FechaEmision = dbo.fnFechaSinHora(@FechaEmision)
SET @ImporteIngresos = dbo.fnNotificacionVentasDelPeriodoIngresos(@Notificacion,@Empresa,@FechaEmision)
SET @ImporteEgresos = dbo.fnNotificacionVentasDelPeriodoEgresos(@Notificacion,@Empresa,@FechaEmision)
SET @Resultado = ISNULL(@ImporteIngresos,0.0) - ISNULL(@ImporteEgresos,0.0)
RETURN ISNULL(@Resultado,0.0)
END

