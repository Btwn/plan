SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSVentaCobroMonederoImporte (
@ID						varchar(36),
@FormaPago				varchar(50),
@MonederoTipoCambio		float
)
RETURNS float
AS
BEGIN
DECLARE @Contador			int,
@TotalRegistros		int,
@MonederoImporte	float
IF @MonederoTipoCambio IS NOT NULL
SELECT @MonederoImporte = SUM(ISNULL(MonederoImporte,0)) FROM POSLCobro
WHERE ID = @ID AND FormaPago = @FormaPago AND MonederoTipoCambio = @MonederoTipoCambio
RETURN (@MonederoImporte)
END

