SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnNotificacionVentasDelPeriodoIngresos
(
@Notificacion		varchar(50),
@Empresa			varchar(5),
@FechaEmision		datetime
)
RETURNS float

AS BEGIN
DECLARE
@Resultado		float,
@ImporteVTAS		float,
@ImporteCXC		float
SET @FechaEmision = dbo.fnFechaSinHora(@FechaEmision)
SELECT
@ImporteVTAS = SUM(ISNULL(Importe,0.0))
FROM Venta
WHERE Mov IN (SELECT Valor FROM dbo.fnNotificacionParamValoresEnTabla(@Notificacion,'Movs. de venta que suman'))
AND Estatus IN (SELECT Valor FROM dbo.fnNotificacionParamValoresEnTabla(@Notificacion,'Estatus de venta que suman'))
AND FechaEmision BETWEEN dbo.fnNotificacionParamCalcPeriodoFecha('INICIAL',@Notificacion,@FechaEmision,'NUMERO PERIODOS','TIPO PERIODO') AND dbo.fnNotificacionParamCalcPeriodoFecha('FINAL',@Notificacion,@FechaEmision,'NUMERO PERIODOS','TIPO PERIODO')
AND Empresa = @Empresa
SET @Resultado = ISNULL(@ImporteVTAS,0.0)
SELECT
@ImporteVTAS = SUM(ISNULL(Importe,0.0))
FROM Cxc
WHERE Mov IN (SELECT Valor FROM dbo.fnNotificacionParamValoresEnTabla(@Notificacion,'Movs. de Cxc que suman'))
AND Estatus IN (SELECT Valor FROM dbo.fnNotificacionParamValoresEnTabla(@Notificacion,'Estatus de Cxc que suman'))
AND FechaEmision BETWEEN dbo.fnNotificacionParamCalcPeriodoFecha('INICIAL',@Notificacion,@FechaEmision,'NUMERO PERIODOS','TIPO PERIODO') AND dbo.fnNotificacionParamCalcPeriodoFecha('FINAL',@Notificacion,@FechaEmision,'NUMERO PERIODOS','TIPO PERIODO')
AND Empresa = @Empresa
SET @Resultado = @Resultado + ISNULL(@ImporteVTAS,0.0)
RETURN ISNULL(@Resultado,0.0)
END

