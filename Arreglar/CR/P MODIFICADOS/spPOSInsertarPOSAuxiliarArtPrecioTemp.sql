SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSInsertarPOSAuxiliarArtPrecioTemp
@Estacion           int,
@FechaD             datetime,
@FechaA             datetime,
@Sucursal           int

AS
BEGIN
DECLARE
@ListaPrecios         varchar(50)
SELECT @ListaPrecios = ListaPreciosEsp
FROM Sucursal WITH (NOLOCK)
WHERE Sucursal = @Sucursal
DECLARE @Tabla table (ID int, Articulo varchar(20), SubCuenta  varchar(50) , ListaPrecios varchar(50),Unidad varchar(50))
DELETE POSAuxiliarArtPrecioTemp WHERE Estacion = @Estacion
INSERT @Tabla(
ID, Articulo, SubCuenta, ListaPrecios, Unidad)
SELECT
MAX(ID), Articulo, ISNULL(SubCuenta,''), ListaPrecios, Unidad
FROM POSAuxiliarArtPrecio WITH (NOLOCK)
WHERE dbo.fnFechaSinHora(Fecha) BETWEEN @FechaD AND @FechaA AND ListaPrecios = @ListaPrecios
GROUP BY Articulo, ISNULL(SubCuenta,''),  ListaPrecios, Unidad
INSERT POSAuxiliarArtPrecioTemp(
Estacion, Articulo, SubCuenta, ListaPrecios, PrecioAnterior, Precio, Codigo, Unidad)
SELECT
@Estacion, t.Articulo, t.SubCuenta, t.ListaPrecios, MAX(p.PrecioAnterior), MAX(p.Precio), ISNULL(c.Codigo,''), ISNULL(ISNULL(c.Unidad,a.Unidad),'pza')					FROM @Tabla t JOIN POSAuxiliarArtPrecio p WITH (NOLOCK) ON t.ID = p.ID AND t.Articulo = p.Articulo AND ISNULL(t.SubCuenta,'') = ISNULL(p.SubCuenta,'')
JOIN Art a WITH (NOLOCK) ON t.Articulo=a.Articulo
LEFT JOIN CB  c WITH (NOLOCK) ON a.Articulo=c.Cuenta AND ISNULL(p.SubCuenta,'')=ISNULL(c.SubCuenta,'')    AND c.TipoCuenta = 'Articulos' AND c.Unidad = ISNULL(t.Unidad,a.Unidad)
GROUP BY t.Articulo,  t.SubCuenta, t.ListaPrecios,c.Codigo, c.Unidad,a.Unidad
END

