SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSVentaCobroReferencia (
@ID						varchar(36),
@FormaPago				varchar(50),
@TipoCambio				float,
@MonederoTipoCambio		float
)
RETURNS varchar(50)
AS
BEGIN
DECLARE @Contador			int,
@TotalRegistros		int,
@Referencia			varchar	(50)
DECLARE @ReferenciaT table (
ID			INT IDENTITY(1,1) NOT NULL,
Referencia	varchar(50)
)
INSERT INTO @ReferenciaT (Referencia)
SELECT Referencia FROM POSLCobro WITH(NOLOCK)
WHERE ID = @ID AND FormaPago = @FormaPago
AND TipoCambio = @TipoCambio AND MonederoTipoCambio = @MonederoTipoCambio
SET @Contador = 1
SELECT @TotalRegistros = COUNT(1) FROM POSLCobro WITH(NOLOCK)
WHERE ID = @ID AND FormaPago = @FormaPago
AND TipoCambio = @TipoCambio AND MonederoTipoCambio = @MonederoTipoCambio
SET @Referencia = ''
WHILE (@Contador <= @TotalRegistros)
BEGIN
IF @Contador > 1
SET @Referencia = @Referencia + ', '
SELECT @Referencia = @Referencia + Referencia FROM @ReferenciaT WHERE ID = @Contador
SET @Contador = @Contador + 1
END
RETURN (@Referencia)
END

