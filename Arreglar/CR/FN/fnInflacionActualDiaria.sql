SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnInflacionActualDiaria
(
@Empresa			varchar(5),
@Sucursal			int
)
RETURNS float

AS BEGIN
DECLARE
@Resultado				float,
@FechaTrabajo				datetime,
@FechaDiaAnterior			datetime,
@ValorUDIDiaActual		float,
@ValorUDIDiaAnterior		float,
@ACConsiderarInflacionIVA	bit,
@Moneda					varchar(10)
SELECT @ACConsiderarInflacionIVA = ISNULL(ACConsiderarInflacionIVA,0), @Moneda = NULLIF(ACMonedaCalculoInflacionIVA,'') FROM EmpresaCfg WHERE Empresa = @Empresa
IF @ACConsiderarInflacionIVA = 0 RETURN 0.0
SET @FechaTrabajo = dbo.fnFechaSinHora(dbo.fnFechaTrabajo(@Empresa, @Sucursal))
SET @FechaDiaAnterior = DATEADD(dd,-1,@FechaTrabajo)
SELECT TOP 1 @ValorUDIDiaActual = TipoCambio FROM MonHist WHERE FechaSinHora = @FechaTrabajo AND Moneda = @Moneda AND Sucursal = @Sucursal ORDER BY ID DESC
SELECT TOP 1 @ValorUDIDiaAnterior = TipoCambio FROM MonHist WHERE FechaSinHora = @FechaDiaAnterior AND Moneda = @Moneda AND Sucursal = @Sucursal ORDER BY ID DESC
IF @ValorUDIDiaActual IS NULL OR @ValorUDIDiaAnterior IS NULL
BEGIN
SET @Resultado = -1
END
ELSE
BEGIN
SET @Resultado = (@ValorUDIDiaActual / @ValorUDIDiaAnterior) - 1.0
IF @Resultado < 0.0 SET @Resultado = 0.0
END
RETURN (@Resultado)
END

