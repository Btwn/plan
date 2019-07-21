SET DATEFIRST 7    
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnNotificacionComprasDelPeriodoEgresos
(
@Notificacion		varchar(50),
@Empresa			varchar(5),
@FechaEmision		datetime
)
RETURNS float

AS BEGIN
DECLARE
@Resultado		float,
@ImporteCOMS		float,
@ImporteCXP		float
SET @FechaEmision = dbo.fnFechaSinHora(@FechaEmision)
SELECT
@ImporteCOMS = SUM(ISNULL(Importe,0.0))
FROM Compra WITH(NOLOCK)
WHERE Mov IN (SELECT Valor FROM dbo.fnNotificacionParamValoresEnTabla(@Notificacion,'Movs. de compra que suman'))
AND Estatus IN (SELECT Valor FROM dbo.fnNotificacionParamValoresEnTabla(@Notificacion,'Estatus de compra que suman'))
AND FechaEmision BETWEEN dbo.fnNotificacionParamCalcPeriodoFecha('INICIAL',@Notificacion,@FechaEmision,'NUMERO PERIODOS','TIPO PERIODO') AND dbo.fnNotificacionParamCalcPeriodoFecha('FINAL',@Notificacion,@FechaEmision,'NUMERO PERIODOS','TIPO PERIODO')
AND Empresa = @Empresa
SET @Resultado = ISNULL(@ImporteCOMS,0.0)
SELECT
@ImporteCOMS = SUM(ISNULL(Importe,0.0))
FROM Cxp WITH(NOLOCK)
WHERE Mov IN (SELECT Valor FROM dbo.fnNotificacionParamValoresEnTabla(@Notificacion,'Movs. de Cxp que suman'))
AND Estatus IN (SELECT Valor FROM dbo.fnNotificacionParamValoresEnTabla(@Notificacion,'Estatus de Cxp que suman'))
AND FechaEmision BETWEEN dbo.fnNotificacionParamCalcPeriodoFecha('INICIAL',@Notificacion,@FechaEmision,'NUMERO PERIODOS','TIPO PERIODO') AND dbo.fnNotificacionParamCalcPeriodoFecha('FINAL',@Notificacion,@FechaEmision,'NUMERO PERIODOS','TIPO PERIODO')
AND Empresa = @Empresa
SET @Resultado = @Resultado + ISNULL(@ImporteCOMS,0.0)
RETURN ISNULL(@Resultado,0.0)
END

