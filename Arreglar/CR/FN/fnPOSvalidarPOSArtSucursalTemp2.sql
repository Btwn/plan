SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSvalidarPOSArtSucursalTemp2 (
@Estacion   int
)
RETURNS bit

AS
BEGIN
DECLARE
@Resultado  bit
SET @Resultado = 1
IF EXISTS(SELECT * FROM POSArtSucursalTemp p JOIN Sucursal s ON p.Sucursal = s.Sucursal  WHERE p.Estacion = 1 AND s.HOST IS NULL)
SELECT @Resultado = 0
RETURN (@Resultado)
END

