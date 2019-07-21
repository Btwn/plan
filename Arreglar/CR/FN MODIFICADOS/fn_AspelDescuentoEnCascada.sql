SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER function [dbo].[fn_AspelDescuentoEnCascada](
@Desc1	float(15),
@Desc2	float(15),
@Desc3	float(15)
)
RETURNS FLOAT(15)
AS
BEGIN
DECLARE
@Descuento	float(15),
@Resul1		float(15),
@Resul2		float(15),
@Resul3		float(15)
SET @Resul1 = 100 - (100 * @Desc1/100.0)
SET @Resul2 = @Resul1 - (@Resul1 * @Desc2/100.0)
SET @Resul3 = @Resul2 - (@Resul2 * @Desc3/100.0)
SET @Descuento = 100 - @Resul3
RETURN (@Descuento)
END

