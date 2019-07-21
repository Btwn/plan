SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ArtSubDisponibleDesc

AS
SELECT
asd.Empresa,
asd.Articulo,
asd.SubCuenta,
asd.Almacen,
asd.Disponible,
a.Descripcion1,
"Llave" = RTRIM(asd.Articulo)+CHAR(9)+ISNULL(RTRIM(asd.SubCuenta), '')
FROM
ArtSubDisponible asd
JOIN Art a ON asd.Articulo = a.Articulo

