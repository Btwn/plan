SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW POSArSucursal2

AS
SELECT
POSArtSucursal.Articulo,
POSArtSucursal.Host,
POSArtSucursal.Sucursal,
Art.Rama,
Art.Descripcion1,
Art.Grupo,
Art.Categoria,
Art.Familia,
Art.Fabricante,
Art.Linea,
CB.Codigo,
CB.Cuenta
FROM POSArtSucursal
LEFT OUTER JOIN Art ON POSArtSucursal.Articulo=Art.Articulo
LEFT OUTER JOIN CB ON POSArtSucursal.Articulo=CB.Cuenta AND CB.TipoCuenta = 'Articulos'

