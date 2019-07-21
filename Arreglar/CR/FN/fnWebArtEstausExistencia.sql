SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnWebArtEstausExistencia
(
@SKU					varchar(255),
@Sucursal				int
)
RETURNS varchar(255)

AS BEGIN
DECLARE
@WebEstatusExistencia varchar(20),
@Inventario			  float
SELECT @Inventario = SUM(wes.Inventario)
FROM WebArtExistenciaSucursal wes
JOIN Alm a ON (wes.Almacen=a.Almacen)
WHERE wes.SKU = @SKU AND a.eCommerceSincroniza=1
IF ISNULL(@Inventario, '') = '' SELECT @Inventario = 0
SELECT TOP 1 @WebEstatusExistencia = WebEstatusExistencia
FROM WebArtEstatusExistencia
WHERE Sucursal = @Sucursal
AND SKU = @SKU
AND @Inventario <= ExistenciaMenorOIgual
ORDER BY ExistenciaMenorOIgual ASC
RETURN @WebEstatusExistencia
END

