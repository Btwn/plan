SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSVentaCobroMonedero (
@ID						varchar(36),
@FormaPago				varchar(50),
@MonederoTipoCambio		float
)
RETURNS varchar(50)
AS
BEGIN
DECLARE @Contador		int,
@TotalRegistros int,
@Monedero		varchar	(50)
DECLARE @MonederoT table (
ID			INT IDENTITY(1,1) NOT NULL,
Monedero	varchar(50)
)
IF @MonederoTipoCambio IS NOT NULL
BEGIN
INSERT INTO @MonederoT (Monedero)
SELECT Monedero FROM POSLCobro WITH(NOLOCK)
WHERE ID = @ID AND FormaPago = @FormaPago
AND MonederoTipoCambio = @MonederoTipoCambio
SET @Contador = 1
SELECT @TotalRegistros = COUNT(1) FROM POSLCobro WITH(NOLOCK)
WHERE ID = @ID AND FormaPago = @FormaPago
AND MonederoTipoCambio = @MonederoTipoCambio
SET @Monedero = ''
WHILE (@Contador <= @TotalRegistros)
BEGIN
IF @Contador > 1
SET @Monedero = @Monedero + ', '
SELECT @Monedero = @Monedero + Monedero FROM @MonederoT WHERE ID = @Contador
SET @Contador = @Contador + 1
END
END
RETURN (@Monedero)
END

