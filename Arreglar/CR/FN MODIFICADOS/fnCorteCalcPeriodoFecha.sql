SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCorteCalcPeriodoFecha
(
@Tipo					varchar(20),
@ID						varchar(50),
@Fecha					datetime,
@ParamNumeroPeriodos	varchar(100),
@ParamTipoPeriodo		varchar(100)
)
RETURNS datetime

AS BEGIN
DECLARE
@Resultado				datetime,
@FechaFinal				datetime,
@FechaInicial			datetime,
@NumeroPeriodos			int,
@PeriodoTipo			varchar(255)
SET @FechaFinal = dbo.fnFechaSinHora(DATEADD(DD,-1,@Fecha))
SET @Resultado = NULL
SELECT @NumeroPeriodos = CONVERT(int,ISNULL(CorteNoPeriodos,1)),
@PeriodoTipo = ISNULL(NULLIF(CorteTipoPeriodo,''),'DIA')
FROM Corte WITH (NOLOCK)
WHERE ID	= @ID
IF @@ERROR <> 0 SET @NumeroPeriodos = 1
IF @PeriodoTipo NOT IN ('DIA','MES','A�O') SET @PeriodoTipo = 'DIA'
IF @NumeroPeriodos >= 1 SET @NumeroPeriodos = @NumeroPeriodos -1 ELSE
IF @NumeroPeriodos < 0 SET @NumeroPeriodos = 0
IF @Tipo = 'FINAL'
BEGIN
SET @Resultado = @FechaFinal
END
ELSE IF @Tipo = 'INICIAL'
BEGIN
IF @PeriodoTipo = 'DIA'
BEGIN
SET @Resultado = DATEADD(dd,0-@NumeroPeriodos,@FechaFinal)
END ELSE
IF @PeriodoTipo = 'MES'
BEGIN
SET @FechaInicial = DATEADD(dd,0-(DAY(@FechaFinal)-1),@FechaFinal)
SET @Resultado = DATEADD(mm,0-@NumeroPeriodos,@FechaInicial)
END ELSE
IF @PeriodoTipo = 'A�O'
BEGIN
SET @FechaInicial = DATEADD(dd,0-(DAY(@FechaFinal)-1),@FechaFinal)
SET @FechaInicial = DATEADD(mm,0-(MONTH(@FechaInicial)-1),@FechaInicial)
SET @Resultado = DATEADD(yy,0-@NumeroPeriodos,@FechaInicial)
END
END
RETURN (@Resultado)
END

