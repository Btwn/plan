SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarCRArt
@Empresa	char(5),
@Sucursal	int,
@MovMoneda	char(10),
@MovTipoCambio	float

AS BEGIN
SELECT '<?xml version="1.0" encoding="UTF-8" ?>'
SELECT '<crArt>'
SELECT "Articulo" = RTRIM(a.Articulo),
"Nombre" = a.Descripcion1,
"Precio" = dbo.fnPrecioSucursal(@Empresa, @Sucursal, @MovMoneda, @MovTipoCambio, a.Articulo, NULL, NULL),
"Estatus" = RTRIM(a.Estatus),
"Tipo" = RTRIM(a.Tipo),
"Rama" = NULLIF(RTRIM(a.Rama), ''),
"Categoria" = NULLIF(RTRIM(a.Categoria), ''),
"Grupo" = NULLIF(RTRIM(a.Grupo), ''),
"Familia" = NULLIF(RTRIM(a.Familia), ''),
"Linea" = NULLIF(RTRIM(a.Linea), ''),
"Fabricante" = NULLIF(RTRIM(a.Fabricante), ''),
"Presentacion" = NULLIF(RTRIM(a.Presentacion), ''),
"Impuesto1" = NULLIF(a.Impuesto1, 0.0),
"Impuesto2" = NULLIF(a.Impuesto2, 0.0),
"Impuesto3" = NULLIF(a.Impuesto3, 0.0),
"Costo" = ac.CostoEstandar,
a.LDI,
a.LDIServicio,
a.EmidaRecargaTelefonica
FROM Art a
LEFT OUTER JOIN ArtCosto ac ON ac.Sucursal = @Sucursal AND ac.Empresa = @Empresa AND ac.Articulo = a.Articulo
WHERE a.SeVende = 1
FOR XML RAW
SELECT '</crArt>'
RETURN
END

